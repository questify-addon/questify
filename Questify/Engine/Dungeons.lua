local addonName, Q = ...

-- Donjons selon le niveau et la faction : table précalculée par tools/routebuilder/build_dungeons.lua
-- (Q.DungeonData, chargée après ce fichier par Guides\DungeonData.lua : relue à chaque appel), état
-- par personnage, alerte du suivi, ajout à la route (prendre les quêtes en ville avec les quêtes qui y
-- mènent, aller à l'entrée, faire, rendre, revenir à la route) et abandon. Même schéma que les quêtes de
-- classe (Engine/ClassQuests.lua).
--
-- Règle de faction stricte : un donjon n'est proposé qu'à une faction listée dans ses données, qui y
-- a au moins une quête à prendre en ville, et jamais dans une capitale de l'autre faction. Le Gouffre
-- de Ragefeu (Orgrimmar) reste Horde seulement, même si les données changeaient.
--
-- Sans QuestieDB, sans données ou avec l'option dungeonSuggest coupée (alerte seulement), le module
-- ne fait rien et ne lève jamais d'erreur.
local Dungeons = {}
Q.Dungeons = Dungeons

local TAG_PREFIX = "dg:"
local MAX_CHAIN = 5       -- niveaux de préquêtes enchaînées au plus (passage, ou quêtes de zone)

-- Zone du donjon -> seule faction autorisée (garde-fou indépendant des données).
local LOCKED_FACTION = { [2437] = "Horde" }   -- Gouffre de Ragefeu
-- Capitales : une faction n'est jamais envoyée dans une capitale de l'autre.
local CAPITAL = { [1453] = "Alliance", [1455] = "Alliance", [1457] = "Alliance",
                  [1454] = "Horde", [1456] = "Horde", [1458] = "Horde" }

---------------------------------------------------------------------------
-- État sauvegardé
---------------------------------------------------------------------------
-- Q.char.dungeons = { added = {[key]=true}, ignored = {...}, seen = {...}, chains = {[questId]=true} }
-- chains : quêtes de donjon dont le joueur a ajouté la chaîne de préquêtes (AddChain).
local function saved()
  local c = Q.char
  if type(c) ~= "table" then return nil end
  if type(c.dungeons) ~= "table" then c.dungeons = {} end
  local s = c.dungeons
  for _, k in ipairs({ "added", "ignored", "seen", "chains" }) do
    if type(s[k]) ~= "table" then s[k] = {} end
  end
  return s
end

-- DUNGEONS_CHANGED : suivi, journal et Automation/AutoQuest.lua (qui relit alors les étapes insérées
-- pour la prise et le rendu automatiques des quêtes).
local function notify()
  Q:Fire("DUNGEONS_CHANGED")
end

local function enabled()
  return Q.Progress ~= nil and Q.Progress:IsEnabled() and Q.QDB ~= nil and Q.QDB:IsAvailable()
end

---------------------------------------------------------------------------
-- Données
---------------------------------------------------------------------------
local function isPoint(p)
  return type(p) == "table" and type(p[1]) == "number" and type(p[2]) == "number" and type(p[3]) == "number"
end

local function validDungeon(d)
  return type(d) == "table" and type(d.key) == "string" and type(d.minLevel) == "number"
    and type(d.maxLevel) == "number" and isPoint(d.entrance) and type(d.quests) == "table"
end

local function isQuest(e) return type(e) == "table" and type(e.id) == "number" end

-- Quête à prendre en ville (ni de passage, ni prise dans le donjon).
local function isTown(e) return isQuest(e) and not e.bc and not e.inside and isPoint(e.at) end

local function questsOf(d, faction)
  local list = type(faction) == "string" and d.quests[faction]
  if type(list) ~= "table" then return {} end
  return list
end

-- Faction autorisée : listée dans les données, au moins une quête en ville, pas de verrou ni de
-- capitale adverse.
local function factionAllowed(d, faction)
  if type(faction) ~= "string" then return false end
  local lock = LOCKED_FACTION[d.areaId]
  if lock and lock ~= faction then return false end
  local owner = CAPITAL[d.entrance[1]]
  if owner and owner ~= faction then return false end
  local listed = false
  for _, f in ipairs(type(d.factions) == "table" and d.factions or {}) do
    if f == faction then listed = true end
  end
  if not listed then return false end
  for _, e in ipairs(questsOf(d, faction)) do
    if isTown(e) then return true end
  end
  return false
end

-- Race et classe du personnage (masques des données, puis QuestieDB).
local function eligible(e)
  local P = Q.Player
  if not Q.Util.MaskAllows(e.races, P.raceBit) then return false end
  if not Q.Util.MaskAllows(e.classes, P.classBit) then return false end
  return Q.QDB:IsEligible(e.id, P.raceBit, P.classBit)
end

-- Quêtes en ville du donjon que ce personnage peut faire (hors niveau et préquêtes).
local function townQuests(d)
  local out = {}
  for _, e in ipairs(questsOf(d, Q.Player.faction)) do
    if isTown(e) and eligible(e) then out[#out + 1] = e end
  end
  return out
end

-- Donjons proposés au personnage : faction autorisée et au moins une quête faisable par sa race.
local function dungeonsForPlayer()
  local out = {}
  local data = Q.DungeonData
  if type(data) ~= "table" then return out end
  local faction = Q.Player and Q.Player.faction
  for _, d in ipairs(data) do
    if validDungeon(d) and factionAllowed(d, faction) and #townQuests(d) > 0 then out[#out + 1] = d end
  end
  return out
end

local function findDungeon(key)
  if type(key) ~= "string" then return nil end
  for _, d in ipairs(dungeonsForPlayer()) do
    if d.key == key then return d end
  end
  return nil
end

---------------------------------------------------------------------------
-- Nom localisé (C_Map.GetAreaInfo), sinon le nom anglais des données
---------------------------------------------------------------------------
function Dungeons:Name(d)
  if type(d) ~= "table" then return "?" end
  if type(d.areaId) == "number" and C_Map and C_Map.GetAreaInfo then
    local ok, name = pcall(C_Map.GetAreaInfo, d.areaId)
    if ok and not Q.Util.IsSecret(name) and type(name) == "string" and name ~= "" then return name end
  end
  return tostring(d.name or d.key or "?")
end

---------------------------------------------------------------------------
-- Plan : quêtes à prendre maintenant (avec leurs préquêtes de passage), quêtes à faire et à rendre
---------------------------------------------------------------------------
local function isTurnedIn(id) return Q.Progress:IsTurnedIn(id) end

local function reqLevel(e)
  local q = Q.QDB:Quest(e.id)
  return (q and q.reqLevel) or tonumber(e.reqLevel) or 1
end

local function prereqLists(e)
  local q = Q.QDB:Quest(e.id)
  if q then return q.preSingle, q.preGroup, q.exclusiveTo end
  return type(e.pre) == "table" and e.pre or {}, type(e.preAll) == "table" and e.preAll or {}, {}
end

-- Préquêtes faites : règle de QuestieDB, ou celle des données quand QuestieDB ne connaît pas la quête
-- (pre = au moins une rendue, preAll = toutes rendues). planned = { [questId] = true } : quêtes comptées
-- comme rendues (chaîne prévue avant).
local function prereqsMet(e, planned)
  local done = isTurnedIn
  if planned then done = function(id) return planned[id] == true or isTurnedIn(id) end end
  if Q.QDB:Quest(e.id) then return Q.QDB:PrereqsMet(e.id, done) end
  local single = type(e.pre) == "table" and e.pre or {}
  if #single > 0 then
    local any = false
    for _, p in ipairs(single) do
      if done(p) then any = true; break end
    end
    if not any then return false end
  end
  for _, p in ipairs(type(e.preAll) == "table" and e.preAll or {}) do
    if not done(p) then return false end
  end
  return true
end

-- Quête utilisable maintenant par le personnage (hors préquêtes).
local function usableNow(e)
  if isTurnedIn(e.id) or not eligible(e) then return false end
  return reqLevel(e) <= (Q.Player.level or 1)
end

local function spawned(kind, id)
  local rec = kind == "npc" and Q.QDB:Npc(id) or Q.QDB:Object(id)
  return type(rec) == "table" and type(rec.spawns) == "table" and next(rec.spawns) ~= nil
end

local function anySpawned(list)
  for _, id in ipairs(list.npcs or {}) do if spawned("npc", id) then return true end end
  for _, id in ipairs(list.objects or {}) do if spawned("object", id) then return true end end
  return false
end

local function hasObjectives(o)
  return #o.creatures + #o.objects + #o.items + #o.killCredit + #o.spells > 0 or o.reputation ~= nil
end

-- Quête de zone (absente des données du donjon) enchaînable maintenant, d'après QuestieDB : faisable par le
-- personnage à son niveau, ni répétable, ni de métier, ni de réputation, donneur et receveur placés hors
-- instance, monstres ou objets d'objectif placés quand il y en a. Renvoie la quête ou nil.
local function zoneQuest(id)
  local q = Q.QDB:Quest(id)
  local P = Q.Player
  if not q or isTurnedIn(id) or not Q.QDB:IsEligible(id, P.raceBit, P.classBit) then return nil end
  if (q.reqLevel or 1) > (P.level or 1) then return nil end
  if (q.specialFlags or 0) % 2 == 1 or q.requiredSkill or q.objectives.reputation then return nil end
  for _, x in ipairs(q.exclusiveTo or {}) do
    if isTurnedIn(x) then return nil end
  end
  if not anySpawned(q.starters) or not anySpawned(q.finishers) then return nil end
  local o = q.objectives
  if #o.creatures + #o.objects > 0 then
    local placed = false
    for _, n in ipairs(o.creatures) do if spawned("npc", n) then placed = true end end
    for _, n in ipairs(o.objects) do if spawned("object", n) then placed = true end end
    if not placed then return nil end
  end
  return q
end

-- Étapes qui débloquent la quête e par ses préquêtes, en ajoutant les quêtes prises à `took` : préquêtes de
-- passage des données (bc ou talk : prendre, rendre) ou quêtes de zone de QuestieDB (prendre, faire, rendre),
-- sur MAX_CHAIN niveaux. Liste d'étapes, ou nil si une préquête manque et ne peut pas être enchaînée (quête
-- du donjon lui-même, hors niveau, sans donneur placé...).
local function unlockSteps(e, byId, depth, took)
  local single, group, exclusive = prereqLists(e)
  for _, x in ipairs(exclusive) do
    if isTurnedIn(x) then return nil end
  end
  local steps = {}
  local function bring(p)
    if isTurnedIn(p) or took[p] then return true end
    local pe, talk = byId[p], true
    if pe then
      -- quête du donjon (en ville ou dans l'instance) : faite avec le donjon, pas avant
      if not ((pe.bc or pe.talk) and isPoint(pe.at) and usableNow(pe)) then return false end
    else
      local zq = zoneQuest(p)
      if not zq then return false end
      talk = not hasObjectives(zq.objectives)
      pe = { id = p }
    end
    if Q.Progress:InLog(p) then
      if not talk and not Q.Progress:IsComplete(p) then steps[#steps + 1] = { "complete", p } end
      steps[#steps + 1] = { "turnin", p }
      took[p] = true
      return true
    end
    if not prereqsMet(pe) then
      if depth >= MAX_CHAIN then return false end
      local sub = unlockSteps(pe, byId, depth + 1, took)
      if not sub then return false end
      for _, s in ipairs(sub) do steps[#steps + 1] = s end
    end
    steps[#steps + 1] = { "accept", p }
    if not talk then steps[#steps + 1] = { "complete", p } end
    steps[#steps + 1] = { "turnin", p }
    took[p] = true
    return true
  end
  if #single > 0 then
    local any = false
    for _, p in ipairs(single) do
      if isTurnedIn(p) then any = true; break end
    end
    if not any then
      for _, p in ipairs(single) do
        if bring(p) then any = true; break end
      end
    end
    if not any then return nil end
  end
  for _, p in ipairs(group) do
    if not bring(p) then return nil end
  end
  return steps
end

---------------------------------------------------------------------------
-- Chaînes de préquêtes trop longues pour être enchaînées d'office (plus de MAX_CHAIN niveaux, ou quêtes hors
-- des règles de zoneQuest) : la fenêtre en donne le détail (ChainInfo) et le joueur peut les ajouter (AddChain).
---------------------------------------------------------------------------
local MAX_FULL_CHAIN = 20   -- quêtes au plus dans une chaîne proposée

-- Quête d'une chaîne, faisable par le personnage : connue de QuestieDB, race et classe, ni répétable, ni de
-- métier, ni de réputation, donneur et receveur placés. Le niveau requis n'est pas exigé ici (readyLevel).
-- -> q, ou nil et la raison : "unknown", "race", "special", "exclusive", "nogiver".
local function chainQuest(id)
  local q = Q.QDB:Quest(id)
  local P = Q.Player
  if not q then return nil, "unknown" end
  if not Q.QDB:IsEligible(id, P.raceBit, P.classBit) then return nil, "race" end
  if (q.specialFlags or 0) % 2 == 1 or q.requiredSkill or q.objectives.reputation then return nil, "special" end
  for _, x in ipairs(q.exclusiveTo or {}) do
    if isTurnedIn(x) then return nil, "exclusive" end
  end
  if not anySpawned(q.starters) or not anySpawned(q.finishers) then return nil, "nogiver" end
  return q
end

-- missingChain(e, planned, d) -> { questId, ... } : préquêtes à faire avant la quête de donjon e, dans l'ordre
-- (chaque quête après les siennes ; liste vide si aucune ne manque), ou nil, raison, quête en cause (raisons
-- de chainQuest, "dungeon" : quête faite dans le donjon lui-même, "long" : plus de MAX_FULL_CHAIN quêtes).
-- planned : quêtes déjà prévues (une autre chaîne), comptées comme faites. Préquête au choix (pre) : une déjà
-- rendue ou prévue suffit, sinon la première faisable.
local function missingChain(e, planned, d)
  planned = planned or {}
  local inside = {}
  if d then
    for _, x in ipairs(questsOf(d, Q.Player.faction)) do
      if isQuest(x) and x.inside then inside[x.id] = true end
    end
  end
  local order, seen = {}, {}
  local why, whyId
  local function fail(reason, id)
    if not why then why, whyId = reason, id end
    return false
  end
  local function done(id) return isTurnedIn(id) or planned[id] or seen[id] end
  local visit
  local function needs(single, group, depth)
    if #single > 0 then
      local any = false
      for _, p in ipairs(single) do
        if done(p) then any = true; break end
      end
      if not any then
        for _, p in ipairs(single) do
          local n, before = #order, {}
          for k in pairs(seen) do before[k] = true end
          if visit(p, depth) then any = true; why, whyId = nil, nil; break end
          for i = #order, n + 1, -1 do order[i] = nil end
          seen = before
        end
      end
      if not any then return false end
    end
    for _, p in ipairs(group) do
      if not done(p) and not visit(p, depth) then return false end
    end
    return true
  end
  visit = function(id, depth)
    if done(id) then return true end
    if depth > MAX_FULL_CHAIN or #order >= MAX_FULL_CHAIN then return fail("long", id) end
    if inside[id] then return fail("dungeon", id) end
    local q, reason = chainQuest(id)
    if not q then return fail(reason, id) end
    seen[id] = true
    if not Q.Progress:InLog(id) and not needs(q.preSingle, q.preGroup, depth + 1) then return false end
    order[#order + 1] = id
    return true
  end
  local single, group, exclusive = prereqLists(e)
  for _, x in ipairs(exclusive) do
    if isTurnedIn(x) then return nil, "exclusive", e.id end
  end
  if not needs(single, group, 1) then return nil, why or "unknown", whyId end
  return order
end

-- Niveau à partir duquel une chaîne et sa quête de donjon sont faisables (niveau requis le plus haut).
local function readyLevel(e, list)
  local lvl = reqLevel(e)
  for _, id in ipairs(list or {}) do
    local q = Q.QDB:Quest(id)
    if q and q.reqLevel and q.reqLevel > lvl then lvl = q.reqLevel end
  end
  return lvl
end

-- Étapes d'une quête de la chaîne : prendre, faire (s'il y a un objectif, une escorte ou un lieu à
-- explorer), rendre ; « faire » et « rendre » seulement si elle est déjà au journal.
local function chainQuestSteps(id, out)
  local q = Q.QDB:Quest(id)
  local talk = q and not hasObjectives(q.objectives) and not q.triggerEnd
  if Q.Progress:InLog(id) then
    if not talk and not Q.Progress:IsComplete(id) then out[#out + 1] = { "complete", id } end
  else
    out[#out + 1] = { "accept", id }
    if not talk then out[#out + 1] = { "complete", id } end
  end
  out[#out + 1] = { "turnin", id }
end

-- Quête de donjon laissée de côté par le chemin de base, que le joueur peut ajouter : en ville, faisable par
-- sa race et sa classe, ni rendue, ni au journal, et bloquée par une préquête ou par le niveau.
local function chainTarget(e)
  return isTown(e) and eligible(e) and not isTurnedIn(e.id) and not Q.Progress:InLog(e.id)
    and (reqLevel(e) > (Q.Player.level or 1) or not prereqsMet(e))
end

-- Quête débloquée par une chaîne prête maintenant (niveau compris).
local function chainCandidate(e)
  return chainTarget(e) and reqLevel(e) <= (Q.Player.level or 1)
end

-- Vrai si deux listes de quêtes ont une quête en commun.
local function overlap(a, b)
  local set = {}
  for _, id in ipairs(a or {}) do set[id] = true end
  for _, id in ipairs(b or {}) do
    if set[id] then return true end
  end
  return false
end

-- Suite choisie pour la quête e : elle-même (AddChain), ou une autre quête du donjon dont la suite partage des
-- quêtes avec la sienne (même chaîne, ajoutée depuis l'autre quête). -> vrai, quêtes choisies concernées.
local function chosenFor(d, e, list)
  local s = saved()
  if not s then return false, {} end
  local out = {}
  if s.chains[e.id] then out[#out + 1] = e.id end
  if list and #list > 0 then
    for _, other in ipairs(questsOf(d, Q.Player.faction)) do
      if other.id ~= e.id and s.chains[other.id] and isQuest(other) then
        local l2 = missingChain(other, nil, d)
        if l2 and overlap(list, l2) then out[#out + 1] = other.id end
      end
    end
  end
  return #out > 0, out
end

-- plan(d) -> {
--   units = { { steps = {...}, start = {m,x,y}, finish = {m,x,y}, quest = e }, ... },  -- à prendre en ville
--   active = { e, ... },   -- quêtes à faire puis rendre (prises par les unités, déjà dans le journal,
--                          -- ou prises dans le donjon)
--   locked = { [id] = "level" | "prereq" },
-- }
-- only = { [questId] = true } | nil : seulement ces quêtes du donjon (échelon du mode automatique, une aile) ;
-- les autres servent encore de préquêtes de passage.
local function plan(d, only)
  local list = questsOf(d, Q.Player.faction)
  local function kept(e) return only == nil or only[e.id] == true end
  local byId, preOf = {}, {}
  for _, e in ipairs(list) do
    if isQuest(e) then
      byId[e.id] = e
      for _, p in ipairs(type(e.pre) == "table" and e.pre or {}) do preOf[p] = true end
      for _, p in ipairs(type(e.preAll) == "table" and e.preAll or {}) do preOf[p] = true end
    end
  end
  local res = { units = {}, active = {}, locked = {} }
  local used = {}
  -- Chaînes choisies par le joueur (AddChain) : un seul bloc, préquêtes d'abord, puis la prise de chaque quête
  -- du donjon qu'elles débloquent (celles choisies et les autres).
  local s = saved()
  local chosen = s and s.chains or {}
  local chainSteps, planned = {}, {}
  local level = Q.Player.level or 1
  for _, e in ipairs(list) do
    if chosen[e.id] and kept(e) and chainCandidate(e) and not prereqsMet(e, planned) then
      -- chaîne prête : toutes ses quêtes à la portée du niveau (sinon elle attend, PLAYER_LEVEL_UP plus bas)
      local miss = missingChain(e, planned, d)
      if miss and readyLevel(e, miss) <= level then
        for _, id in ipairs(miss) do
          chainQuestSteps(id, chainSteps)
          planned[id] = true
        end
      end
    end
  end
  if #chainSteps > 0 then
    local first
    for _, e in ipairs(list) do
      if kept(e) and chainCandidate(e) and prereqsMet(e, planned) then
        chainSteps[#chainSteps + 1] = { "accept", e.id }
        used[e.id] = true
        res.active[#res.active + 1] = e
        first = first or e
      end
    end
    if first then
      local CQ = Q.ClassQuests
      local st = CQ and CQ.Starter and CQ:Starter(chainSteps[1][2])
      local start = st and st.mapId and { st.mapId, st.x, st.y } or first.at
      res.units[#res.units + 1] = { steps = chainSteps, start = start, finish = first.at, quest = first, chain = true }
    end
  end
  local function consider(e)
    if used[e.id] or not kept(e) or isTurnedIn(e.id) or not eligible(e) then return end
    if Q.Progress:InLog(e.id) then
      used[e.id] = true
      res.active[#res.active + 1] = e
      return
    end
    if reqLevel(e) > (Q.Player.level or 1) then
      res.locked[e.id] = "level"
      return
    end
    local steps = {}
    local took = {}
    if not prereqsMet(e) then
      local sub = unlockSteps(e, byId, 1, took)
      if not sub then
        res.locked[e.id] = "prereq"
        return
      end
      steps = sub
    end
    steps[#steps + 1] = { "accept", e.id }
    for id in pairs(took) do used[id] = true end
    used[e.id] = true
    local first, start = byId[steps[1][2]], e.at
    if first and isPoint(first.at) then
      start = first.at
    elseif not first then
      local CQ = Q.ClassQuests
      local s = CQ and CQ.Starter and CQ:Starter(steps[1][2])
      if s and s.mapId then start = { s.mapId, s.x, s.y } end
    end
    res.units[#res.units + 1] = { steps = steps, start = start, finish = e.at, quest = e }
    res.active[#res.active + 1] = e
  end
  -- Les quêtes demandées par d'autres viennent après : elles peuvent être enchaînées avant celles-ci.
  for _, e in ipairs(list) do
    if isTown(e) and not preOf[e.id] then consider(e) end
  end
  for _, e in ipairs(list) do
    if isTown(e) and preOf[e.id] then consider(e) end
  end
  -- Quêtes prises dans le donjon : « faire » et « rendre » seulement (sautées hors du journal).
  for _, e in ipairs(list) do
    if isQuest(e) and e.inside and kept(e) and not used[e.id] and not isTurnedIn(e.id) and eligible(e) then
      used[e.id] = true
      res.active[#res.active + 1] = e
    end
  end
  return res
end
Dungeons.Plan = function(_, d) return plan(d) end

---------------------------------------------------------------------------
-- Ordre : le plus proche d'abord, en finissant la carte (ville) en cours avant d'en changer
---------------------------------------------------------------------------
-- items = { { start = {m,x,y}, finish = {m,x,y}, ... } } ; m, x, y = point de départ (peut être nil).
local function orderNearest(items, m, x, y)
  local left, out = {}, {}
  for i, it in ipairs(items) do left[i] = it end
  while #left > 0 do
    local bestI, bestTier, bestD
    for i, it in ipairs(left) do
      local p = it.start
      local tier = (isPoint(p) and p[1] == m) and 0 or 1
      local dist
      if m and isPoint(p) then dist = Q.Maps:Distance(m, x, y, p[1], p[2], p[3]) end
      dist = dist or math.huge
      if not bestI or tier < bestTier or (tier == bestTier and dist < bestD) then
        bestI, bestTier, bestD = i, tier, dist
      end
    end
    local it = table.remove(left, bestI)
    out[#out + 1] = it
    local f = isPoint(it.finish) and it.finish or it.start
    if isPoint(f) then m, x, y = f[1], f[2], f[3] end
  end
  return out
end

---------------------------------------------------------------------------
-- États
---------------------------------------------------------------------------
-- Quêtes du donjon déjà prévues par le chapitre courant (la route s'occupe alors du donjon).
local function routeQuests()
  local set = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.source == "guide" and e.step and e.step.action == "accept" and type(e.step.questId) == "number" then
      set[e.step.questId] = true
    end
  end
  return set
end

local function inRoute(d, set)
  for _, e in ipairs(townQuests(d)) do
    if set[e.id] then return true end
  end
  return false
end

-- done, added, ignored, puis selon le niveau : past (dépassé), upcoming (à venir ou rien à prendre),
-- available (niveau entre min - 1 et max, au moins une quête à prendre ou en cours).
local function stateOf(d, s)
  local all = townQuests(d)
  local done = true
  for _, e in ipairs(all) do
    if not isTurnedIn(e.id) then done = false; break end
  end
  if done then return "done" end
  if s.added[d.key] then return "added" end
  if s.ignored[d.key] then return "ignored" end
  local level = Q.Player.level or 1
  if level > d.maxLevel then return "past" end
  if level < d.minLevel - 1 then return "upcoming" end
  local p = plan(d)
  if #p.units > 0 then return "available" end
  for _, e in ipairs(p.active) do
    if not e.inside then return "available" end
  end
  return "upcoming"
end

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------
-- List() -> { { dungeon, state }, ... } par niveau croissant.
function Dungeons:List()
  local out = {}
  local s = enabled() and saved()
  if not s then return out end
  local list = dungeonsForPlayer()
  table.sort(list, function(a, b)
    if a.minLevel ~= b.minLevel then return a.minLevel < b.minLevel end
    return a.key < b.key
  end)
  for _, d in ipairs(list) do
    local ok, state = pcall(stateOf, d, s)
    if ok then
      out[#out + 1] = { dungeon = d, state = state }
    else
      Q:ReportError(state)
    end
  end
  return out
end

-- Suggested() -> donjons conseillés (option dungeonSuggest), vus ou non, hors donjons dont la route
-- prend déjà les quêtes : { { dungeon, state }, ... }.
function Dungeons:Suggested()
  local out = {}
  if Q.Settings:Get("dungeonSuggest") == false then return out end
  -- mode automatique (Engine/DungeonMode.lua) : les donjons sont dans la route, rien à suggérer
  if Q.DungeonMode and Q.DungeonMode:IsOn() then return out end
  if not (enabled() and saved()) then return out end
  local set
  for _, row in ipairs(self:List()) do
    if row.state == "available" then
      set = set or routeQuests()
      if not inRoute(row.dungeon, set) then out[#out + 1] = row end
    end
  end
  return out
end

-- Alerts() -> donjons conseillés pas encore vus.
function Dungeons:Alerts()
  local out = {}
  local s = saved()
  if not s then return out end
  for _, row in ipairs(self:Suggested()) do
    if not s.seen[row.dungeon.key] then out[#out + 1] = row end
  end
  return out
end

function Dungeons:MarkSeen(key)
  local s = saved()
  if s and type(key) == "string" then s.seen[key] = true end
end

-- Details(d) -> { { id, giver, obj, at, ok = vrai si à prendre maintenant, reason = "level" | "prereq" |
-- "log" (déjà dans le journal) | "done" (rendue), level = niveau requis, chain = résumé de suite (ChainSummary)
-- }, ... } pour la fenêtre et le journal. Trois groupes, chacun dans l'ordre des données : les quêtes manquantes
-- (à prendre maintenant ou bloquées), celles du journal de quêtes, puis celles déjà rendues (done = true).
function Dungeons:Details(d)
  local out = {}
  if not (enabled() and validDungeon(d)) then return out end
  local p = plan(d)
  local taken, active, afterChain = {}, {}, {}
  for _, u in ipairs(p.units) do
    taken[u.quest.id] = true
    for _, st in ipairs(u.steps) do
      if st[1] == "accept" then
        taken[st[2]] = true
        if u.chain then afterChain[st[2]] = true end
      end
    end
  end
  for _, e in ipairs(p.active) do active[e.id] = true end
  local missing, inLog, done = {}, {}, {}
  for _, e in ipairs(townQuests(d)) do
    local row = { id = e.id, giver = e.giver, obj = e.obj, at = e.at, level = reqLevel(e) }
    if isTurnedIn(e.id) then
      row.ok, row.reason, row.done = false, "done", true
      done[#done + 1] = row
    else
      if taken[e.id] then
        row.ok = true
      elseif active[e.id] then
        row.ok, row.reason = true, "log"
      else
        row.ok, row.reason = false, p.locked[e.id] or "prereq"
      end
      -- quête laissée de côté (préquête, niveau) ou prise après une suite ajoutée : encadré du journal
      if (not row.ok and chainTarget(e)) or afterChain[e.id] then
        local ok, c = pcall(Dungeons.ChainSummary, Dungeons, e, d)
        if ok then row.chain = c else Q:ReportError(c) end
      end
      if row.reason == "log" then inLog[#inLog + 1] = row else missing[#missing + 1] = row end
    end
  end
  for _, group in ipairs({ missing, inLog, done }) do
    for _, row in ipairs(group) do out[#out + 1] = row end
  end
  return out
end

---------------------------------------------------------------------------
-- Chaînes de préquêtes : détail, ajout, retrait
---------------------------------------------------------------------------
-- Donneur le plus proche du joueur d'une liste QuestieDB : { kind = "npc"|"object", id, at = {m, x, y} }.
local function placeOf(list)
  local pm, px, py = Q.Maps:PlayerPos()
  local best
  local function try(kind, id, rec)
    if type(rec) ~= "table" or type(rec.spawns) ~= "table" then return end
    local m, x, y, dist = Q.Maps:Nearest(rec.spawns, pm, px, py)
    if not m then return end
    if not best or (dist and (not best.dist or dist < best.dist)) then
      best = { kind = kind, id = id, at = { m, x, y }, dist = dist }
    end
  end
  for _, id in ipairs(list and list.npcs or {}) do try("npc", id, Q.QDB:Npc(id)) end
  for _, id in ipairs(list and list.objects or {}) do try("object", id, Q.QDB:Object(id)) end
  if best then best.dist = nil end
  return best
end

-- XP d'une quête au niveau du personnage (Q.QuestRewardData, XP de base de DungeonData.lua ; modificateur
-- Classic selon l'écart de niveau, arrondi à 5) et objets de récompense.
local function rewardOf(id)
  local data = type(Q.QuestRewardData) == "table" and Q.QuestRewardData[id]
  if type(data) ~= "table" then return 0, {} end
  local level = Q.Player.level or 1
  local xp = 0
  if type(data.xp) == "number" and level < 60 then
    local q = Q.QDB:Quest(id)
    local diff = q and q.level and (level - q.level) or 0
    local m = 0.1
    if diff <= 5 then m = 1 elseif diff == 6 then m = 0.8 elseif diff == 7 then m = 0.6
    elseif diff == 8 then m = 0.4 elseif diff == 9 then m = 0.2 end
    xp = math.floor(data.xp * m / 5) * 5
  end
  return xp, type(data.items) == "table" and data.items or {}
end

-- Cartes de la route du chapitre (étapes du guide : lieux d'objectif, points de passage) : { [uiMapID] = true }.
local function routeMaps()
  local set = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    local st = e.step
    if e.source == "guide" and type(st) == "table" then
      if type(st.at) == "table" and type(st.at[1]) == "number" then set[st.at[1]] = true end
      if type(st.mapId) == "number" then set[st.mapId] = true end
    end
  end
  return set
end

-- Cartes traversées par une chaîne, dans l'ordre de passage (donneur puis receveur de chaque quête) :
-- trajet (deux cartes de suite identiques fusionnées) et liste sans doublon.
local function chainZones(list)
  local path, zones, seen = {}, {}, {}
  local function add(place)
    local m = place and place.at[1]
    if not m then return end
    if path[#path] ~= m then path[#path + 1] = m end
    if not seen[m] then seen[m] = true; zones[#zones + 1] = m end
  end
  for _, qid in ipairs(list) do
    local q = Q.QDB:Quest(qid)
    if q then
      add(placeOf(q.starters))
      add(placeOf(q.finishers))
    end
  end
  return path, zones
end

-- ChainSummary(e, d) -> résumé de ce qui manque à la quête de donjon e :
--   { count, sig = "65,132,...", giver|nil, obj|nil, mapId|nil, zones = { uiMapID, ... }, offRoute = bool,
--     readyLevel, ready = bool, chosen = bool }   -- count = 0 : seulement le niveau
--   ou { reason, reasonQuest } : suite hors de portée (raisons de missingChain).
-- Deux quêtes de même signature attendent la même suite.
function Dungeons:ChainSummary(e, d)
  local list, why, whyId = missingChain(e, nil, d)
  if not list then return { reason = why, reasonQuest = whyId } end
  local c = { count = #list, sig = table.concat(list, ","), readyLevel = readyLevel(e, list), zones = {},
              offRoute = false }
  c.ready = c.readyLevel <= (Q.Player.level or 1)
  c.chosen = d and (chosenFor(d, e, list)) or false
  if #list > 0 then
    local q = Q.QDB:Quest(list[1])
    local place = q and placeOf(q.starters)
    if place then
      if place.kind == "npc" then c.giver = place.id else c.obj = place.id end
      c.mapId = place.at[1]
    end
    local _, zones = chainZones(list)
    local onRoute = routeMaps()
    c.zones = zones
    for _, m in ipairs(zones) do
      if not onRoute[m] then c.offRoute = true end
    end
  end
  return c
end

local function townEntry(d, id)
  for _, e in ipairs(townQuests(d)) do
    if e.id == id then return e end
  end
  return nil
end

-- ChainInfo(key, questId) -> {
--   quests = { { id, kind, giver|nil, obj|nil, at = {m,x,y}|nil, ender|nil, endObj|nil, endAt|nil, xp, items },
--              ... },             -- préquêtes, dans l'ordre ; kind = "talk" (parler), "objectives" (tuer,
--                                 -- ramasser), "event" (escorte, lieu à explorer)
--   unlocks = { questId, ... },   -- quêtes du donjon prises après la chaîne (la quête demandée d'abord)
--   zones = { uiMapID, ... },     -- cartes des donneurs et des receveurs, sans doublon
--   path = { uiMapID, ... },      -- les mêmes dans l'ordre de passage (retours compris)
--   onRoute = { [uiMapID] = true }, -- cartes déjà sur la route du chapitre
--   minLevel, maxLevel,           -- niveau requis le plus bas, niveau de quête le plus haut de la chaîne
--   dungeon = nom du donjon,
--   xpChain = n,                  -- XP de la chaîne seule, au niveau du personnage
--   xp = n,                       -- XP de la chaîne et des quêtes débloquées
--   items = { itemId, ... },      -- récompenses des quêtes du donjon débloquées (pas celles de la suite)
--   rewards = { { quest = questId, items = { itemId, ... } }, ... },  -- les mêmes, par quête débloquée
--   readyLevel, ready = bool,     -- niveau à atteindre pour la suite et la quête ; atteint ou non
--   chosen = bool,                -- suite déjà ajoutée (AddChain), depuis cette quête ou une autre
-- } ou nil (quête prise par le chemin de base, ou suite hors de portée : ChainSummary en donne la raison).
-- quests est vide pour une quête bloquée seulement par le niveau.
function Dungeons:ChainInfo(key, id)
  if not enabled() then return nil end
  local d = findDungeon(key)
  local e = d and townEntry(d, id)
  if not e or not chainTarget(e) then return nil end
  local list = missingChain(e, nil, d)
  if not list then return nil end
  local planned = {}
  for _, qid in ipairs(list) do planned[qid] = true end
  local info = { quests = {}, unlocks = { id }, xp = 0, xpChain = 0, items = {}, dungeon = self:Name(d) }
  info.path, info.zones = chainZones(list)
  info.onRoute = routeMaps()
  info.readyLevel = readyLevel(e, list)
  info.ready = info.readyLevel <= (Q.Player.level or 1)
  if #list > 0 then
    for _, other in ipairs(questsOf(d, Q.Player.faction)) do
      if other.id ~= id and isQuest(other) and chainTarget(other) and not prereqsMet(other)
        and prereqsMet(other, planned) then
        info.unlocks[#info.unlocks + 1] = other.id
      end
    end
  end
  local seenItem = {}
  for _, qid in ipairs(list) do
    local q = Q.QDB:Quest(qid)
    local row = { id = qid, kind = "talk" }
    if q then
      if q.triggerEnd then row.kind = "event" elseif hasObjectives(q.objectives) then row.kind = "objectives" end
      if q.reqLevel and (not info.minLevel or q.reqLevel < info.minLevel) then info.minLevel = q.reqLevel end
      if q.level and (not info.maxLevel or q.level > info.maxLevel) then info.maxLevel = q.level end
    end
    local from = q and placeOf(q.starters)
    if from then
      if from.kind == "npc" then row.giver = from.id else row.obj = from.id end
      row.at = from.at
    end
    local to = q and placeOf(q.finishers)
    if to then
      if to.kind == "npc" then row.ender = to.id else row.endObj = to.id end
      row.endAt = to.at
    end
    row.xp, row.items = rewardOf(qid)
    info.xpChain = info.xpChain + row.xp
    info.quests[#info.quests + 1] = row
  end
  -- récompenses : seulement celles des quêtes du donjon débloquées (l'intérêt de la suite), par quête
  info.xp = info.xpChain
  info.rewards = {}
  for _, qid in ipairs(info.unlocks) do
    local xp, items = rewardOf(qid)
    info.xp = info.xp + xp
    local group = { quest = qid, items = {} }
    for _, it in ipairs(items) do
      group.items[#group.items + 1] = it
      if not seenItem[it] then seenItem[it] = true; info.items[#info.items + 1] = it end
    end
    if #group.items > 0 then info.rewards[#info.rewards + 1] = group end
  end
  info.chosen = (chosenFor(d, e, list))
  return info
end

-- Point où reprendre la route après le donjon : la cible de l'étape courante (hors étapes de ce donjon),
-- sinon la position du joueur. { mapId, x, y, titre|nil } ou nil.
local function returnPoint(tag)
  local cur = Q.Progress:Current()
  if cur and cur.tag ~= tag and Q.Targets and Q.Targets.ForEntry then
    local tg = Q.Targets:ForEntry(cur)
    if tg and tg.mapId and tg.x and tg.y then return { tg.mapId, tg.x, tg.y, tg.title } end
  end
  local m, x, y = Q.Maps:PlayerPos()
  if m and x and y then return { m, x, y } end
  return nil
end

-- Étapes d'un donjon ajouté : les quêtes à prendre et celles qui y mènent (la plus proche d'abord, ville par
-- ville), l'entrée du donjon, « faire » et « rendre » pour chaque quête. rung : échelon du mode automatique
-- (Engine/DungeonMode.lua) : prises en phase « prep », entrée, objectifs et rendus en phase « run », pour que
-- la case de l'échelon et « Passer ce donjon » s'y appliquent comme aux étapes de la route.
local function blockSteps(d, p, rung)
  local name = Dungeons:Name(d)
  local steps = {}
  local function add(st, phase)
    if rung then st.rung, st.phase = rung, phase end
    steps[#steps + 1] = st
  end
  local pm, px, py = Q.Maps:PlayerPos()
  for _, u in ipairs(orderNearest(p.units, pm, px, py)) do
    for _, st in ipairs(u.steps) do add({ st[1], st[2], dungeon = name }, "prep") end
  end
  local ent = d.entrance
  add({ "goto", ent[1], ent[2], ent[3], note = string.format(Q.L.DUNGEON_GOTO_NOTE, name) }, "run")
  for _, e in ipairs(p.active) do
    if not e.talk then add({ "complete", e.id, dungeon = name }, "run") end
  end
  -- Rendus : d'abord ceux qui se font dans le donjon (PNJ de fin sans position), puis du plus proche
  -- de l'entrée au plus loin.
  local inside, outside = {}, {}
  for _, e in ipairs(p.active) do
    if isPoint(e.endAt) then
      outside[#outside + 1] = { start = e.endAt, quest = e }
    else
      inside[#inside + 1] = e
    end
  end
  for _, e in ipairs(inside) do add({ "turnin", e.id, dungeon = name }, "run") end
  for _, it in ipairs(orderNearest(outside, ent[1], ent[2], ent[3])) do
    add({ "turnin", it.quest.id, dungeon = name }, "run")
  end
  return steps
end

-- Add(key) : insère avant la route les quêtes à prendre et celles qui y mènent, l'entrée du donjon, « faire »
-- et « rendre » pour chaque quête (blockSteps), puis le retour au point où la route en était (étape « goto »
-- marquée du donjon).
function Dungeons:Add(key)
  local s = saved()
  if not s or not enabled() then return false end
  local d = findDungeon(key)
  if not d then return false end
  local p = plan(d)
  local hasQuest = #p.units > 0
  for _, e in ipairs(p.active) do
    if not e.inside then hasQuest = true end
  end
  if not hasQuest then return false end
  local name = self:Name(d)
  local back = returnPoint(TAG_PREFIX .. d.key)
  local steps = blockSteps(d, p)
  if back then
    local note = back[4] and string.format(Q.L.DUNGEON_BACK_NOTE, back[4]) or Q.L.DUNGEON_BACK_NOTE_PLAIN
    steps[#steps + 1] = { "goto", back[1], back[2], back[3], dungeon = name, note = note }
  end
  -- l'état est enregistré avant l'insertion : celle-ci déclenche déjà des mises à jour
  s.added[d.key] = true
  s.ignored[d.key] = nil
  s.seen[d.key] = true
  Q.Progress:InsertSteps(TAG_PREFIX .. d.key, steps)
  notify()
  return true
end

-- Ignore(key) : retire les étapes insérées et mémorise le choix.
function Dungeons:Ignore(key)
  local s = saved()
  if not s or not enabled() or not findDungeon(key) then return false end
  s.ignored[key] = true
  s.added[key] = nil
  s.seen[key] = true
  for _, e in ipairs(townQuests(findDungeon(key))) do s.chains[e.id] = nil end
  Q.Progress:RemoveInserted(TAG_PREFIX .. key)
  notify()
  return true
end

-- Unignore(key) : le donjon redevient conseillé (ou à venir).
function Dungeons:Unignore(key)
  local s = saved()
  if not s or type(key) ~= "string" or not s.ignored[key] then return false end
  s.ignored[key] = nil
  notify()
  return true
end

---------------------------------------------------------------------------
-- Mode automatique (Engine/DungeonMode.lua) : quêtes en plus d'un échelon
---------------------------------------------------------------------------
-- La route du mode ne prend que les quêtes de donjon dont le donneur est sur son chemin, telles que la
-- simulation les a vues (un personnage qui joue toutes les alternatives). Un personnage qui a fait les donjons
-- précédents passe ces alternatives et arrive à l'entrée sans certaines quêtes (la Prison sans « What Comes
-- Around... » des Carmines, par exemple). Le suivi propose alors de les ajouter avant d'entrer : même bloc que
-- Add (prises, entrée, objectifs, rendus), sans retour au point de départ, puisque la route reprend d'elle-même.

-- Échelon coché du mode actif -> échelon, donjon des données, { [questId] = true } : quêtes de l'échelon.
local function rungTarget(key)
  local DM = Q.DungeonMode
  if not (DM and DM:IsOn()) then return nil end
  local r = DM:Rung(key)
  if not r or DM:State(key) ~= "on" then return nil end
  local d = findDungeon(r.dungeon)
  if not d then return nil end
  local only = {}
  for _, id in ipairs(type(r.quests) == "table" and r.quests or {}) do only[id] = true end
  return r, d, only
end

-- Extras(key) -> {
--   rung, dungeon,
--   quests = { { id, giver|nil, obj|nil, at = {m,x,y}, start = {m,x,y}, pre = { questId, ... } }, ... },
--                     -- quêtes à prendre, dans l'ordre du bloc ; pre : préquêtes enchaînées avant elle
--   plan,             -- plan(d) restreint à l'échelon
-- } ou nil : rien à ajouter (mode éteint, échelon décoché ou contourné, toutes les quêtes prises ou
-- bloquées, quêtes de donjon coupées dans les options).
function Dungeons:Extras(key)
  if not enabled() or Q.Settings:Get("dungeonQuests") == false then return nil end
  local r, d, only = rungTarget(key)
  if not r then return nil end
  local p = plan(d, only)
  if #p.units == 0 then return nil end
  local pm, px, py = Q.Maps:PlayerPos()
  local quests = {}
  for _, u in ipairs(orderNearest(p.units, pm, px, py)) do
    local e = u.quest
    local pre = {}
    for _, st in ipairs(u.steps) do
      if st[1] == "accept" and st[2] ~= e.id then pre[#pre + 1] = st[2] end
    end
    quests[#quests + 1] = { id = e.id, giver = e.giver, obj = e.obj, at = e.at, start = u.start or e.at, pre = pre }
  end
  return { rung = r, dungeon = d, quests = quests, plan = p }
end

-- ExtrasAdded(key) -> vrai si le bloc de l'échelon est dans la route.
function Dungeons:ExtrasAdded(key)
  if type(key) ~= "string" or not Q.Progress then return false end
  local tag = TAG_PREFIX .. key
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.tag == tag then return true end
  end
  return false
end

-- AddExtras(key) : insère avant la route les quêtes en plus de l'échelon (et leurs préquêtes), l'entrée, les
-- objectifs et les rendus de toutes les quêtes de l'échelon. -> vrai si fait.
function Dungeons:AddExtras(key)
  local info = self:Extras(key)
  if not info then return false end
  Q.Progress:InsertSteps(TAG_PREFIX .. key, blockSteps(info.dungeon, info.plan, key))
  notify()
  return true
end

-- RemoveExtras(key) : retire le bloc ; les étapes d'instance de la route restent. -> vrai si fait.
function Dungeons:RemoveExtras(key)
  if not self:ExtrasAdded(key) then return false end
  Q.Progress:RemoveInserted(TAG_PREFIX .. key)
  local s = saved()
  if s then s.added[key] = nil end
  notify()
  return true
end

-- ExtraTarget(entry) -> échelon, "add" | "remove", Extras(échelon) pour "add" ; ou nil : bouton du suivi pour
-- cette étape. "add" sur l'étape d'entrée d'un échelon (goto en phase « run » de la route) quand des quêtes sont
-- à ajouter ; "remove" sur une prise du bloc déjà ajouté (une fois à l'entrée, « Passer ce donjon » reste le
-- moyen de s'en passer).
function Dungeons:ExtraTarget(entry)
  local step = type(entry) == "table" and entry.step
  if type(step) ~= "table" or type(step.rung) ~= "string" then return nil end
  local DM = Q.DungeonMode
  if not (DM and DM:IsOn()) then return nil end
  if entry.source == "inserted" then
    if entry.tag == TAG_PREFIX .. step.rung and step.phase == "prep" then return step.rung, "remove" end
    return nil
  end
  if step.phase == "run" and step.action == "goto" then
    local info = self:Extras(step.rung)
    if info then return step.rung, "add", info end
  end
  return nil
end

-- Trip(m1, x1, y1, m2, x2, y2) -> { seconds, flight, boat, tram, newFlightPath } ou nil : trajet estimé par
-- ShortestPathForever, qui connaît les points de vol découverts par le personnage, les bateaux et le tram.
-- flight / boat / tram : le trajet en prend ; newFlightPath : il passe par un point de vol à découvrir. nil sans
-- l'addon, pendant son chargement, en combat ou hors de ses cartes. Coordonnées en 0-100 (0-1 chez lui).
function Dungeons:Trip(m1, x1, y1, m2, x2, y2)
  local SP = type(ShortestPathForever) == "table" and ShortestPathForever.API
  local fn = type(SP) == "table" and SP.EstimateDetail
  if type(fn) ~= "function" then return nil end
  for _, v in ipairs({ m1, x1, y1, m2, x2, y2 }) do
    if type(v) ~= "number" then return nil end
  end
  local ok, res = pcall(fn, m1, x1 / 100, y1 / 100, m2, x2 / 100, y2 / 100)
  if not ok or Q.Util.IsSecret(res) or type(res) ~= "table" or type(res.seconds) ~= "number" then return nil end
  local out = { seconds = res.seconds }
  for _, leg in ipairs(type(res.legs) == "table" and res.legs or {}) do
    if type(leg) == "table" then
      if leg.mode == "flight" then
        out.flight = true
      elseif leg.mode == "boat" or leg.mode == "zeppelin" then
        out.boat = true
      elseif leg.mode == "tram" then
        out.tram = true
      end
      if leg.newFlightPath then out.newFlightPath = true end
    end
  end
  return out
end

-- Rebâtit les étapes d'un donjon (chaînes ajoutées ou retirées) ; l'ajoute s'il ne l'était pas et que `add`.
local function rebuild(self, s, d, add)
  if s.added[d.key] then
    Q.Progress:RemoveInserted(TAG_PREFIX .. d.key)
    s.added[d.key] = nil
    add = true
  end
  if add then return self:Add(d.key) end
  return true
end

-- AddChain(key, questId) : la quête laissée de côté rejoint la route avec sa suite de préquêtes, dans les
-- étapes du donjon (ajouté s'il ne l'était pas), avant l'entrée. Suite ou quête au-dessus du niveau : elle est
-- retenue et rejoint la route au niveau voulu (PLAYER_LEVEL_UP), pour ne pas bloquer la route d'ici là. Faux si
-- rien n'est à ajouter (suite hors de portée, ou déjà ajoutée depuis une autre quête).
function Dungeons:AddChain(key, id)
  local s = saved()
  if not s or not enabled() then return false end
  local d = findDungeon(key)
  local info = d and self:ChainInfo(key, id)
  if not info or info.chosen then return false end
  s.chains[id] = true
  s.ignored[d.key] = nil
  if not info.ready then
    notify()
    return true
  end
  if not rebuild(self, s, d, true) then
    s.chains[id] = nil
    return false
  end
  return true
end

-- RemoveChain(key, questId) : retire la suite (choisie depuis cette quête ou une autre quête de la même suite) ;
-- le donjon ajouté garde ses autres quêtes.
function Dungeons:RemoveChain(key, id)
  local s = saved()
  if not s or not enabled() then return false end
  local d = findDungeon(key)
  local e = d and townEntry(d, id)
  local ids = {}
  if e then
    local list = missingChain(e, nil, d)
    local _, found = chosenFor(d, e, list)
    ids = found
  elseif s.chains[id] then
    ids = { id }
  end
  if #ids == 0 then return false end
  for _, q in ipairs(ids) do s.chains[q] = nil end
  if d then rebuild(self, s, d, false) end
  notify()
  return true
end

-- Passage de niveau : une suite retenue qui devient faisable rejoint la route (le donjon est ajouté au besoin).
local function inGroup(d, id)
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.tag == TAG_PREFIX .. d.key and e.step and e.step.action == "accept" and e.step.questId == id then
      return true
    end
  end
  return false
end

local function joinReadyChains()
  if not enabled() then return end
  local s = saved()
  if not s or next(s.chains) == nil then return end
  local level = Q.Player.level or 1
  for _, d in ipairs(dungeonsForPlayer()) do
    local due = false
    for _, e in ipairs(townQuests(d)) do
      if s.chains[e.id] and not isTurnedIn(e.id) and not Q.Progress:InLog(e.id) and not inGroup(d, e.id) then
        local list = missingChain(e, nil, d)
        if list and readyLevel(e, list) <= level then due = true end
      end
    end
    if due then rebuild(Dungeons, s, d, true) end
  end
end
Dungeons.JoinReadyChains = joinReadyChains

Q:RegisterEvent("PLAYER_LEVEL_UP", function()
  local ok, err = pcall(joinReadyChains)
  if not ok then Q:ReportError(err) end
end)

---------------------------------------------------------------------------
-- Un donjon ajouté se retire de lui-même quand il ne lui reste aucune étape de quête à faire
-- (toutes rendues ou sautées) ni le retour à la route (« goto » marqué du donjon) ; l'étape d'entrée
-- seule ne le retient pas.
---------------------------------------------------------------------------
local QUEST_ACTIONS = { accept = true, complete = true, turnin = true }

Q:On("PROGRESS_UPDATED", function()
  if not enabled() then return end
  local s = saved()
  if not s then return end
  local groups, order = {}, {}
  for _, e in ipairs(Q.Progress:Entries()) do
    local tag = e.tag
    if type(tag) == "string" and tag:sub(1, #TAG_PREFIX) == TAG_PREFIX then
      local g = groups[tag]
      if not g then g = { open = false }; groups[tag] = g; order[#order + 1] = tag end
      if QUEST_ACTIONS[e.step.action] or (e.step.action == "goto" and e.step.dungeon) then
        local state = Q.Progress:State(e)
        if state == "active" or state == "blocked" then g.open = true end
      end
    end
  end
  local changed = false
  for _, tag in ipairs(order) do
    if not groups[tag].open then
      Q.Progress:RemoveInserted(tag)
      s.added[tag:sub(#TAG_PREFIX + 1)] = nil
      changed = true
    end
  end
  if changed then notify() end
end)

Q:On("SETTINGS_CHANGED", function(path)
  if path == "dungeonSuggest" then Q:Fire("DUNGEONS_CHANGED") end
end)

-- Mode automatique allumé ou éteint : l'alerte des donjons suggérés disparaît ou revient.
Q:On("DUNGEON_MODE_CHANGED", function() Q:Fire("DUNGEONS_CHANGED") end)
