local addonName, Q = ...

-- Quête peu rentable (option questValue) : la route est simulée hors du jeu pour un personnage type ;
-- en jeu, une quête peut ne plus valoir le détour pour ce joueur-là. Sur l'étape courante (prendre,
-- faire ou rendre une quête), trois signaux, par ordre de priorité :
--   "gray"  : la quête est grise pour le niveau du joueur (même seuil que le jeu) ;
--   "group" : un monstre à tuer est élite (rang QuestieDB) ou le journal conseille un groupe, et le
--             joueur n'est pas groupé ;
--   "high"  : un monstre à tuer (son niveau le plus bas), ou la quête sans monstre à tuer, est à
--             LEVEL_GAP niveaux ou plus au-dessus du joueur.
-- Le suivi (UI/QuestValue.lua) montre la raison, l'XP perdue et des choix : passer, garder, zone de
-- secours (Engine/Detour.lua), bash jusqu'au bon niveau (étape « level » insérée), chercher un groupe.
-- Rien n'est jamais passé sans clic.
-- Passer = la quête et ses suites dans la route (quêtes qui en dépendent) : Progress:DropQuests. Une quête
-- grise présente dans le journal en est aussi abandonnée, UNDO_DELAY secondes après le clic seulement :
-- « Annuler » remet tout tant que le délai court. Ensuite, clic sur l'étape dans le journal ou /qf back.
-- Rien ici n'est protégé ; les valeurs secrètes sont ignorées.
local QuestValue = {}
Q.QuestValue = QuestValue

local LEVEL_GAP = 3        -- niveaux au-dessus du joueur : quête « trop haute »
local BASH_GAP = 2         -- bash jusqu'à ce que tous les monstres soient au plus à 2 niveaux au-dessus
local UNDO_DELAY = 10      -- secondes pendant lesquelles « Annuler » reste possible
local MAX_DROPPERS = 12    -- monstres examinés au plus pour un objet à ramasser
local ELITE_RANKS = { [1] = true, [2] = true, [3] = true }
QuestValue.LEVEL_GAP, QuestValue.BASH_GAP, QuestValue.UNDO_DELAY = LEVEL_GAP, BASH_GAP, UNDO_DELAY

local QUEST_STEPS = { accept = true, complete = true, turnin = true }
local XP_FACTORS = { [6] = 0.8, [7] = 0.6, [8] = 0.4, [9] = 0.2 }   -- écart de niveaux -> part de l'XP

local pending        -- saut qui peut encore être annulé : { root, ids, names, steps, abandon, at, kind }
local ticker

local function now() return (GetTime and GetTime()) or 0 end
local function enabled() return Q.Settings and Q.Settings:Get("questValue") ~= false end

local function plain(v)
  if Q.Util.IsSecret(v) then return nil end
  return v
end

local function playerLevel()
  return tonumber(Q.Player and Q.Player.level) or 1
end

local function questName(id)
  return Q.API.QuestTitle(id) or Q.QDB:QuestName(id) or ("#" .. tostring(id))
end

local function changed(what)
  Q:Fire("QUESTVALUE_CHANGED", what)
end

local function keepState()
  local c = Q.char
  if not c then return {} end
  if type(c.questValueKeep) ~= "table" then c.questValueKeep = {} end
  return c.questValueKeep
end

---------------------------------------------------------------------------
-- Niveaux et XP
---------------------------------------------------------------------------
-- Écart vert : GetQuestGreenRange du jeu, sinon le niveau gris de Classic (gris quand niveau du joueur -
-- niveau de la quête > écart vert) : jusqu'au niveau 39, gris à niveau - floor(niveau / 10) - 5 et en
-- dessous ; 40-59, à niveau - floor(niveau / 5) - 1 ; 60, à niveau - 9.
function QuestValue:GreenRange(level)
  level = tonumber(level) or playerLevel()
  if type(GetQuestGreenRange) == "function" then
    local ok, r = pcall(GetQuestGreenRange, "player")
    r = ok and tonumber(plain(r)) or nil
    if r and r > 0 then return r end
  end
  if level <= 5 then return level end   -- rien n'est gris avant le niveau 6
  if level < 40 then return math.floor(level / 10) + 4 end
  if level < 60 then return math.floor(level / 5) end
  return 8
end

function QuestValue:IsGray(questLevel, level)
  questLevel, level = tonumber(questLevel), tonumber(level) or playerLevel()
  if not questLevel or questLevel <= 0 then return false end
  return level - questLevel > self:GreenRange(level)
end

-- Part de l'XP d'une quête gagnée par le joueur (Classic : pleine jusqu'à 5 niveaux au-dessus de la quête,
-- puis 80, 60, 40, 20 %, et 10 % à partir de 10 niveaux).
function QuestValue:XPFactor(questLevel, level)
  questLevel, level = tonumber(questLevel), tonumber(level) or playerLevel()
  if not questLevel or questLevel <= 0 then return 1 end
  local diff = level - questLevel
  if diff <= 5 then return 1 end
  return XP_FACTORS[diff] or 0.1
end

-- XP de base d'une quête : champ xp de son étape « rendre » dans la route, ou nil.
function QuestValue:BaseXP(questId)
  for _, e in ipairs(Q.Progress:Entries()) do
    local s = e.step
    if s.questId == questId and s.action == "turnin" and type(s.xp) == "number" then return s.xp end
  end
  return nil
end

-- XP qu'apporterait la quête au niveau actuel (arrondie à 5), ou nil si l'XP de base est inconnue.
function QuestValue:XPNow(questId, level)
  local base = self:BaseXP(questId)
  if not base then return nil end
  local q = Q.QDB:Quest(questId)
  local f = self:XPFactor(q and q.level, level)
  return math.floor(base * f / 5 + 0.5) * 5, base
end

---------------------------------------------------------------------------
-- Chaîne : la quête et les quêtes de la route qui en dépendent
---------------------------------------------------------------------------
local function contains(list, set)
  for _, x in ipairs(list) do
    if set[x] then return true end
  end
  return false
end

-- Chain(root) -> { root, suite1, ... } dans l'ordre de la route : quêtes encore à rendre dont une préquête
-- obligatoire (preGroup), ou toutes les préquêtes possibles encore à faire (preSingle), sont dans la chaîne.
function QuestValue:Chain(root)
  local P = Q.Progress
  local order, seen = {}, {}
  for _, e in ipairs(P:Entries()) do
    local id = e.step.questId
    if type(id) == "number" and not seen[id] and QUEST_STEPS[e.step.action] then
      seen[id] = true
      order[#order + 1] = id
    end
  end
  local set = { [root] = true }
  local grew = true
  while grew do
    grew = false
    for _, id in ipairs(order) do
      if not set[id] and not P:IsTurnedIn(id) then
        local q = Q.QDB:Quest(id)
        if q then
          local dep = contains(q.preGroup, set)
          if not dep and #q.preSingle > 0 and contains(q.preSingle, set) then
            -- toutes les préquêtes possibles sont dans la chaîne ou hors d'atteinte
            dep = true
            for _, p in ipairs(q.preSingle) do
              if not set[p] and (P:IsTurnedIn(p) or P:InLog(p) or seen[p]) then dep = false; break end
            end
          end
          if dep then
            set[id] = true
            grew = true
          end
        end
      end
    end
  end
  local out = { root }
  for _, id in ipairs(order) do
    if id ~= root and set[id] then out[#out + 1] = id end
  end
  return out
end

-- Étapes de la route que le saut retire : ni faites, ni déjà passées (sauf un rendu ou un objectif « passé »
-- parce que la quête n'est pas encore prise : il était prévu).
local function openSteps(ids)
  local set = {}
  for _, id in ipairs(ids) do set[id] = true end
  local n = 0
  for _, e in ipairs(Q.Progress:Entries()) do
    if set[e.step.questId] then
      local s, reason = Q.Progress:State(e)
      if s ~= "done" and (s ~= "skipped" or reason == "notinlog") then n = n + 1 end
    end
  end
  return n
end

---------------------------------------------------------------------------
-- Monstres à tuer
---------------------------------------------------------------------------
local function npcInfo(id)
  local n = Q.QDB:Npc(id)
  if not n then return nil end
  local lo = tonumber(n.minLevel) or tonumber(n.maxLevel)
  local hi = tonumber(n.maxLevel) or lo
  return lo, hi, ELITE_RANKS[n.rank] == true
end

-- Targets(q) -> { { lo, hi, elite }, ... } : une ligne par objectif « tuer » ou « objet lâché par un monstre ».
-- Pour un objet, le monstre le plus facile compte, et il n'est élite que si tous ceux qui le lâchent le sont.
function QuestValue:Targets(q)
  local out = {}
  local o = q and q.objectives
  if not o then return out end
  local function add(npcIds)
    local lo, hi, elite, any = nil, nil, true, false
    for i, id in ipairs(npcIds) do
      if i > MAX_DROPPERS then break end
      local a, b, e = npcInfo(id)
      if a then
        any = true
        lo = lo and math.min(lo, a) or a
        hi = hi and math.max(hi, b) or b
        if not e then elite = false end
      end
    end
    if any then out[#out + 1] = { lo = lo, hi = hi, elite = elite } end
  end
  for _, id in ipairs(o.creatures) do add({ id }) end
  for _, kc in ipairs(o.killCredit) do add(kc.npcIds) end
  for _, itemId in ipairs(o.items) do
    local item = Q.QDB:Item(itemId)
    if item and #item.objectDrops == 0 and #item.npcDrops > 0 then add(item.npcDrops) end
  end
  return out
end

local function inGroup()
  if type(IsInGroup) == "function" then
    local ok, v = pcall(IsInGroup)
    if ok and plain(v) then return true end
  end
  if type(GetNumGroupMembers) == "function" then
    local ok, n = pcall(GetNumGroupMembers)
    n = ok and tonumber(plain(n)) or 0
    if n > 1 then return true end
  end
  return false
end

local function inInstance()
  if type(IsInInstance) ~= "function" then return false end
  local ok, v = pcall(IsInInstance)
  return ok and plain(v) == true
end

-- Groupe conseillé par le journal du jeu (C_QuestLog.GetInfo().suggestedGroup), 0 si inconnu.
local function suggestedGroup(questId)
  local idx = Q.API.QuestLogIndex(questId)
  local fn = idx and C_QuestLog and C_QuestLog.GetInfo
  if not fn then return 0 end
  local ok, info = pcall(fn, idx)
  if not ok or type(info) ~= "table" then return 0 end
  return tonumber(plain(info.suggestedGroup)) or 0
end

---------------------------------------------------------------------------
-- Conseil pour l'étape courante
---------------------------------------------------------------------------
-- Advice(entry) -> nil, ou { kind, questId, name, inLog, abandon, xpNow, xpBase, lost, chain, steps,
--   mobLo, mobHi, elites, group, bashLevel, detour }.
--   kind : "gray" | "group" | "high" ; lost : XP perdue avec les suites au niveau actuel (nil si inconnue) ;
--   abandon : vrai quand « Passer » abandonne aussi la quête dans le journal du jeu (quête grise du journal).
function QuestValue:Advice(entry)
  if not enabled() or type(entry) ~= "table" or type(entry.step) ~= "table" then return nil end
  local step = entry.step
  local id = step.questId
  if type(id) ~= "number" or not QUEST_STEPS[step.action] then return nil end
  if step.rung or step.dungeon or step.optional or inInstance() then return nil end
  if not (Q.Progress:IsEnabled()) then return nil end
  local state = Q.Progress:State(entry)
  if state ~= "active" then return nil end
  local q = Q.QDB:Quest(id)
  if not q then return nil end
  local level = playerLevel()
  local kind
  local info = { questId = id }
  if self:IsGray(q.level, level) then
    kind = "gray"
  elseif step.action ~= "turnin" then
    local targets = self:Targets(q)
    local elites, lo, hi, need = 0, nil, nil, nil
    for _, t in ipairs(targets) do
      if t.elite then elites = elites + 1 end
      lo = lo and math.min(lo, t.lo) or t.lo
      hi = hi and math.max(hi, t.hi) or t.hi
      need = need and math.max(need, t.lo) or t.lo
    end
    local group = suggestedGroup(id)
    if (elites > 0 or group > 1) and not inGroup() then
      kind = "group"
    elseif need and need - level >= LEVEL_GAP then
      kind = "high"
    elseif not need and q.level and q.level - level >= LEVEL_GAP then
      kind = "high"
      need = q.level
    end
    info.elites, info.group, info.mobLo, info.mobHi = elites, group, lo, hi
    -- bash : jusqu'à ce que le plus haut des monstres à tuer soit à BASH_GAP niveaux au plus
    if kind == "high" then info.bashLevel = math.max(need, hi or need) - BASH_GAP end
  end
  if not kind or keepState()[id] == kind then return nil end
  info.kind = kind
  info.name = questName(id)
  info.inLog = Q.Progress:InLog(id)
  info.abandon = kind == "gray" and info.inLog or false
  info.xpNow, info.xpBase = self:XPNow(id, level)
  info.chain = self:Chain(id)
  info.steps = openSteps(info.chain)
  local lost, known = 0, false
  for _, cid in ipairs(info.chain) do
    local xp = self:XPNow(cid, level)
    if xp then lost, known = lost + xp, true end
  end
  info.lost = known and lost or nil
  info.detour = Q.Detour ~= nil and #Q.Detour:Candidates() > 0
  return info
end

-- Conseil pour l'étape courante de la route (sans saut en attente d'annulation).
function QuestValue:Current()
  if pending then return nil end
  local ok, advice = pcall(self.Advice, self, Q.Progress:Current())
  if not ok then
    Q:ReportError(advice)
    return nil
  end
  return advice
end

---------------------------------------------------------------------------
-- Choix du joueur
---------------------------------------------------------------------------
local function stopTicker()
  if ticker then ticker:Cancel() end
  ticker = nil
end

-- Abandonne dans le journal du jeu les quêtes du saut en attente, puis le saut devient définitif.
local function commit()
  local p = pending
  pending = nil
  stopTicker()
  if not p then return end
  for _, id in ipairs(p.abandon) do
    if Q.Progress:InLog(id) then Q.API.AbandonQuest(id) end
  end
  changed("commit")
end

-- Skip(advice) : passe la quête et ses suites ; -> vrai si fait.
function QuestValue:Skip(advice)
  if type(advice) ~= "table" or type(advice.questId) ~= "number" or not Q.char then return false end
  if pending then commit() end
  local chain = advice.chain or self:Chain(advice.questId)
  local steps = advice.steps or openSteps(chain)
  local abandon = {}
  if advice.abandon then
    for _, id in ipairs(chain) do
      if Q.Progress:InLog(id) then abandon[#abandon + 1] = id end
    end
  end
  pending = { root = chain[1], ids = chain, name = advice.name or questName(chain[1]), steps = steps,
    abandon = abandon, at = now(), kind = advice.kind }
  if not Q.Progress:DropQuests(chain) then
    pending = nil
    return false
  end
  stopTicker()
  ticker = Q:NewTicker(1, function()
    if not pending then return stopTicker() end
    if now() - pending.at >= UNDO_DELAY then commit() else changed("tick") end
  end)
  changed("skip")
  return true
end

-- Saut qui peut encore être annulé : { root, ids, name, steps, abandon, kind, left = secondes }, ou nil.
function QuestValue:Pending()
  if not pending then return nil end
  local left = math.max(0, math.ceil(UNDO_DELAY - (now() - pending.at)))
  return { root = pending.root, ids = pending.ids, name = pending.name, steps = pending.steps,
    abandon = pending.abandon, kind = pending.kind, left = left }
end

-- Undo() : annule le saut en attente (rien n'a encore été abandonné). -> vrai si fait.
function QuestValue:Undo()
  local p = pending
  if not p then return false end
  pending = nil
  stopTicker()
  Q.Progress:UndropQuests(p.root)
  changed("undo")
  return true
end

-- Keep(advice) : le joueur garde la quête ; ce conseil ne revient plus pour elle (un autre signal, si).
function QuestValue:Keep(advice)
  if type(advice) ~= "table" or type(advice.questId) ~= "number" or not Q.char then return false end
  keepState()[advice.questId] = advice.kind
  changed("keep")
  return true
end

-- Bash(advice) : étape « monter au niveau N » insérée avant la route ; -> vrai si fait.
function QuestValue:Bash(advice)
  local lvl = type(advice) == "table" and tonumber(advice.bashLevel)
  if not lvl or lvl <= playerLevel() then return false end
  local ok = Q.Progress:InsertSteps("questvalue:bash", { { "level", lvl, note = Q.L.QV_BASH_NOTE } })
  if ok then Q.Progress:MoveInsertedFirst("questvalue:bash") end
  changed("bash")
  return ok
end

-- Detour() : zone de secours (Engine/Detour.lua) ; -> chapitre ouvert, ou nil.
function QuestValue:Detour()
  local g = Q.Detour and Q.Detour:Start()
  if not g then Q:Print(Q.L.QV_NO_DETOUR) end
  return g
end

-- FindGroup(advice) : ouvre la ligne de discussion avec un message prêt ; le joueur choisit le canal et
-- l'envoie lui-même. -> vrai si la ligne a été ouverte.
function QuestValue:FindGroup(advice)
  if type(advice) ~= "table" then return false end
  local text = string.format(Q.L.QV_LFG_MESSAGE, advice.name or questName(advice.questId))
  if type(ChatFrame_OpenChat) == "function" then
    local ok = pcall(ChatFrame_OpenChat, text)
    return ok
  end
  return false
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
-- Le suivi se redessine quand le groupe change (signal « groupe »).
Q:RegisterEvent("GROUP_ROSTER_UPDATE", function() changed("group") end)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "questValue" then changed("settings") end
end)
