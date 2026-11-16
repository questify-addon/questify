local addonName, Q = ...

-- Objectifs d'une étape « Faire », mis en forme pour le suivi (UI/Tracker.lua) : un objectif par
-- ligne, avec son type (icône), son libellé sans compteur, son avancement (fait / à faire) et son
-- ordre. Disposition inspirée de Polestar (github.com/fitzforge/polestar, GPL-3.0) : libellé,
-- compteur à droite, objectif suivi par la flèche marqué d'un trait, objectifs faits repliés.
--   Types : kill (tuer), loot (ramasser sur un monstre), object (objet du monde : coffre, plante),
--   use (objet à utiliser), talk (parler), explore (lieu, événement), rep (réputation), note.
--   Source : le journal de quêtes (texte, compteur, fait), complété par QuestieDB pour le type et les
--   cibles ; quête absente du journal : objectifs QuestieDB, à 0.
--   Ordre : celui du journal, stable (les boutons de ciblage ne bougent pas en combat) ; l'objectif
--   visé par la flèche (cible de navigation de l'étape) porte un trait. Un objectif fini reste
--   visible FOLD_DELAY secondes (compteur en vert), puis se replie.
-- Réglages du joueur : tracker.objLayout (list | bars | quest) et tracker.objDetail (count | mobs |
-- distance) ; ancien réglage tracker.showMobs = false : détail « count ».
local Objectives = {}
Q.Objectives = Objectives

Objectives.LAYOUTS = { "list", "bars", "quest" }
Objectives.DETAILS = { "count", "mobs", "distance" }
Objectives.FOLD_DELAY = 1.5   -- secondes pendant lesquelles un objectif fini reste affiché

-- Textures du jeu par type (curseurs et icônes de l'interface de Blizzard).
local ICONS = {
  kill = "Interface\\Cursor\\Attack",
  loot = "Interface\\Buttons\\Button-Backpack-Up",
  object = "Interface\\Cursor\\Interact",
  use = "Interface\\Cursor\\Cast",
  talk = "Interface\\GossipFrame\\GossipGossipIcon",
  explore = "Interface\\Icons\\INV_Misc_Map_01",
  rep = "Interface\\Icons\\INV_Misc_Note_01",
  note = "Interface\\Icons\\INV_Misc_Note_01",
  done = "Interface\\RaidFrame\\ReadyCheck-Ready",
}
Objectives.ICONS = ICONS

local doneSince = {}   -- [questId:index] = GetTime() du premier affichage fini
local foldedKeys = {}  -- [questId:index] = true une fois replié

local function now() return (type(GetTime) == "function" and GetTime()) or 0 end

-- En combat, rien ne se replie ni ne se déplie : les boutons de ciblage posés sur les lignes de
-- monstres (UI/MobPanel.lua) ne peuvent pas suivre.
local function inCombat() return type(InCombatLockdown) == "function" and InCombatLockdown() and true or false end

local function isSecret(v) return Q.Util.IsSecret and Q.Util.IsSecret(v) end

---------------------------------------------------------------------------
-- Réglages
---------------------------------------------------------------------------
local function valid(list, v)
  for _, k in ipairs(list) do if k == v then return true end end
  return false
end

-- Mise en page choisie : list (défaut), bars ou quest.
function Objectives:Layout()
  local v = Q.Settings and Q.Settings:Get("tracker.objLayout")
  return valid(self.LAYOUTS, v) and v or "list"
end

-- Détail choisi : mobs (défaut), count ou distance. Jamais choisi dans ce profil : l'ancien
-- réglage tracker.showMobs = false (monstres cachés) vaut count.
function Objectives:Detail()
  local S = Q.Settings
  if not S then return "mobs" end
  local store = S.Store and S:Store()
  local saved = type(store) == "table" and type(store.tracker) == "table" and store.tracker.objDetail or nil
  if saved == nil and S:Get("tracker.showMobs") == false then return "count" end
  local v = S:Get("tracker.objDetail")
  return valid(self.DETAILS, v) and v or "mobs"
end

---------------------------------------------------------------------------
-- Libellé et compteur
---------------------------------------------------------------------------
-- Q.Objectives:Split(text) -> libellé, fait, total : « Loup tué : 3/8 », « Kobold slain: 3/8 » ou
-- « 3/8 Loup ». Sans compteur dans le texte : libellé = texte, fait et total nil.
function Objectives:Split(text)
  if type(text) ~= "string" then return "", nil, nil end
  local label, a, b = text:match("^(.-)%s*:%s*(%d+)%s*/%s*(%d+)%s*$")
  if label and label ~= "" then return label, tonumber(a), tonumber(b) end
  a, b, label = text:match("^%s*(%d+)%s*/%s*(%d+)%s+(.+)$")
  if label then return label, tonumber(a), tonumber(b) end
  return text, nil, nil
end

---------------------------------------------------------------------------
-- Type d'un objectif
---------------------------------------------------------------------------
-- Cibles QuestieDB d'une quête rangées par objectif du journal : { [objIndex] = { rows } }.
local function targetsByIndex(questId)
  local out = {}
  if not (Q.Targets and Q.Targets.ObjectiveTargets) then return out end
  local ok, rows = pcall(Q.Targets.ObjectiveTargets, Q.Targets, questId)
  if not ok or type(rows) ~= "table" then return out end
  for _, r in ipairs(rows) do
    local k = r.objIndex or 0
    out[k] = out[k] or {}
    table.insert(out[k], r)
  end
  return out
end

local function anyViaItem(rows)
  for _, r in ipairs(rows or {}) do if r.viaItem then return r end end
  return nil
end

-- Objectif « parler » : texte qui contient un des verbes de L.OBJ_TALK_WORDS (liste séparée par des
-- virgules, en minuscules).
local function looksLikeTalk(text)
  local words = Q.L and rawget(Q.L, "OBJ_TALK_WORDS")
  if type(words) ~= "string" or type(text) ~= "string" then return false end
  local lower = text:lower()
  for w in words:gmatch("[^,]+") do
    w = w:gsub("^%s+", ""):gsub("%s+$", "")
    if w ~= "" and lower:find(w, 1, true) then return true end
  end
  return false
end

-- Type à partir du journal (type de l'objectif) et des cibles QuestieDB de l'objectif.
local function kindOf(logType, rows, text, useItem)
  local via = anyViaItem(rows)
  if via then
    -- objet ramassé sur un objet du monde seulement (coffre, plante) : interagir
    local npcDrop = false
    for _, r in ipairs(rows) do if r.viaItem and r.kind == "npc" then npcDrop = true end end
    return npcDrop and "loot" or "object"
  end
  if rows and rows[1] then
    if rows[1].kind == "object" then return "object" end
    if logType ~= "item" then return "kill" end
  end
  if logType == "monster" then return "kill" end
  if logType == "item" then return "loot" end
  if logType == "object" then return "object" end
  if logType == "reputation" then return "rep" end
  if logType == "event" then
    if looksLikeTalk(text) then return "talk" end
    if useItem then return "use" end
    return "explore"
  end
  if looksLikeTalk(text) then return "talk" end
  return "note"
end
Objectives.KindOf = function(_, logType, rows, text, useItem) return kindOf(logType, rows, text, useItem) end

-- Icône d'un objectif : celle de l'objet à utiliser s'il est connu, sinon celle du type.
local function iconOf(kind, itemId)
  if kind == "use" and itemId then
    local fn = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
    if type(fn) == "function" then
      local ok, icon = pcall(fn, itemId)
      if ok and icon and not isSecret(icon) then return icon end
    end
  end
  return ICONS[kind] or ICONS.note
end
Objectives.IconOf = function(_, kind, itemId) return iconOf(kind, itemId) end

---------------------------------------------------------------------------
-- Objectifs d'une étape
---------------------------------------------------------------------------
local function questObjectives(questId)
  local fn = C_QuestLog and C_QuestLog.GetQuestObjectives
  if type(fn) ~= "function" then return nil end
  local ok, objs = pcall(fn, questId)
  if ok and type(objs) == "table" then return objs end
  return nil
end

-- Objet à utiliser de l'étape (UI/QuestItemButton.lua), ou nil.
local function useItemFor(entry)
  local B = Q.UI and Q.UI.QuestItemButton
  if not (B and B.ItemFor) then return nil end
  local ok, id = pcall(B.ItemFor, B, entry)
  if ok then return id end
  return nil
end

-- Index de l'objectif visé par la flèche (cible de navigation de l'étape), ou nil.
local function leadIndex(entry, byIndex)
  if not (Q.Targets and Q.Targets.ForEntry) then return nil end
  local ok, tg = pcall(Q.Targets.ForEntry, Q.Targets, entry)
  if not ok or type(tg) ~= "table" or not tg.id then return nil end
  for index, rows in pairs(byIndex) do
    for _, r in ipairs(rows) do
      if r.id == tg.id and (r.kind == tg.kind or tg.kind == "area" or tg.kind == "zone") then return index end
    end
  end
  return nil
end

-- Lignes QuestieDB d'une quête absente du journal (même forme que celles du journal).
local function fromQuestie(questId)
  local q = Q.QDB:Quest(questId)
  local out = {}
  if not q then return out end
  for ordinal, o in ipairs(q.objectives.ordered) do
    local name
    if o.kind == "creature" then name = Q.QDB:NpcName(o.ids[1])
    elseif o.kind == "killCredit" then name = o.text or Q.QDB:NpcName(o.base or o.ids[1])
    elseif o.kind == "object" then name = Q.QDB:ObjectName(o.ids[1])
    elseif o.kind == "item" then name = Q.QDB:ItemName(o.ids[1])
    end
    if name then
      local logType = (o.kind == "item" and "item") or (o.kind == "object" and "object") or "monster"
      out[ordinal] = { text = name, type = logType, finished = false, numFulfilled = 0,
        numRequired = tonumber(o.count) or 1, fromQuestie = true }
    end
  end
  return out
end

-- Q.Objectives:ForStep(entry) -> { questId, rows = { { index, kind, icon, label, have, need, done,
--   text, lead, folded, itemId } }, shown = { lignes visibles dans l'ordre }, folded = { faits repliés } }
-- ou nil (étape sans objectifs : autre action, quête inconnue).
function Objectives:ForStep(entry)
  local step = type(entry) == "table" and entry.step
  if type(step) ~= "table" or step.action ~= "complete" or type(step.questId) ~= "number" then return nil end
  local questId = step.questId
  local inLog = Q.Progress and Q.Progress:InLog(questId)
  local objs = inLog and questObjectives(questId) or nil
  if not objs or not next(objs) then objs = fromQuestie(questId) end
  local byIndex = targetsByIndex(questId)
  local useItem = useItemFor(entry)
  local lead = leadIndex(entry, byIndex)
  local t = now()
  local rows = {}
  for index, o in pairs(objs) do
    if type(o) == "table" and (not step.obj or step.obj == index) then
      local text = not isSecret(o.text) and type(o.text) == "string" and o.text or ""
      if text ~= "" then
        local label, have, need = self:Split(text)
        if not have and not o.fromQuestie then
          have, need = tonumber(o.numFulfilled), tonumber(o.numRequired)
        elseif o.fromQuestie then
          have, need = 0, o.numRequired
        end
        local done = o.finished == true or (have and need and need > 0 and have >= need) or false
        local kind = kindOf(o.type, byIndex[index], text, useItem)
        local key = questId .. ":" .. index
        local folded = foldedKeys[key] or false
        if inCombat() then
          if done then doneSince[key] = doneSince[key] or t end
        elseif done then
          doneSince[key] = doneSince[key] or t
          folded = t - doneSince[key] >= self.FOLD_DELAY
          foldedKeys[key] = folded or nil
        else
          doneSince[key], foldedKeys[key], folded = nil, nil, false
        end
        rows[#rows + 1] = { index = index, kind = kind, icon = iconOf(done and "done" or kind, useItem),
          label = label, have = have, need = need, done = done, text = text, folded = folded,
          lead = (index == lead) and not done, itemId = kind == "use" and useItem or nil, questId = questId }
      end
    end
  end
  table.sort(rows, function(a, b) return a.index < b.index end)
  -- ordre du journal, stable : les lignes ciblables (boutons sécurisés, figés en combat) ne
  -- changent pas de place quand la flèche passe d'un objectif à l'autre ; repliés à part
  local shown, folded = {}, {}
  for _, r in ipairs(rows) do
    if r.folded then folded[#folded + 1] = r else shown[#shown + 1] = r end
  end
  -- pas d'objectif visé : le premier non fait prend le trait
  if not lead then
    for _, r in ipairs(shown) do
      if not r.done then r.lead = true; break end
    end
  end
  return { questId = questId, rows = rows, shown = shown, folded = folded }
end

-- Secondes avant le prochain repli d'un objectif fini (nil : aucun en attente).
function Objectives:NextFold(data)
  if type(data) ~= "table" or inCombat() then return nil end
  local t, best = now(), nil
  for _, r in ipairs(data.rows) do
    if r.done and not r.folded then
      local since = doneSince[data.questId .. ":" .. r.index]
      if since then
        local left = math.max(0, self.FOLD_DELAY - (t - since)) + 0.05
        if not best or left < best then best = left end
      end
    end
  end
  return best
end

-- Texte de la ligne des objectifs repliés : « 1 fait : <libellé> » ou « N faits ».
function Objectives:FoldText(folded)
  local L = Q.L
  if type(folded) ~= "table" or #folded == 0 then return nil end
  if #folded == 1 then return string.format(L.OBJ_FOLD_ONE, folded[1].label) end
  return string.format(L.OBJ_FOLD_MANY, #folded)
end

-- Compteur affiché : « 3/8 » (nil sans total connu).
function Objectives:CountText(r)
  if not (r and r.have and r.need and r.need > 0) then return nil end
  return math.min(r.have, r.need) .. "/" .. r.need
end

-- Fraction faite (0 à 1), pour la barre d'avancement.
function Objectives:Fraction(r)
  if not r then return 0 end
  if r.done then return 1 end
  if not (r.have and r.need and r.need > 0) then return 0 end
  return math.max(0, math.min(1, r.have / r.need))
end

-- Distance (yards) du joueur au point d'apparition le plus proche d'un objectif ; nil sinon.
function Objectives:Distance(questId, index)
  if not (Q.Maps and Q.Targets and Q.QDB) then return nil end
  local pm, px, py = Q.Maps:PlayerPos()
  if not pm then return nil end
  local best
  for _, r in ipairs(targetsByIndex(questId)[index] or {}) do
    local data = r.kind == "npc" and Q.QDB:Npc(r.id) or Q.QDB:Object(r.id)
    local m, _, _, d = Q.Maps:Nearest(data and data.spawns, pm, px, py)
    if m and d and (not best or d < best) then best = d end
  end
  return best
end
