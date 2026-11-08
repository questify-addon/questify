local addonName, Q = ...

-- Quêtes qui donnent un sac : entrées précalculées par le générateur (Q.BagQuestData,
-- tools/routebuilder/bagquests.lua), état par personnage, utilité du sac, ajout à la route et refus.
-- Q.BagQuestData = { { key, title, faction, races, level, bag = itemId, quests = { prérequis..., quête },
--                      rewards = { [questId] = { items, xp } } }, ... }
-- est défini par Guides/BagQuestData.lua, chargé après ce fichier : on le lit à chaque appel.
--
-- Un sac est utile quand un emplacement de sac est vide, ou quand il a plus d'emplacements que le plus petit
-- sac ordinaire porté (les sacs spéciaux, carquois ou sacs de métier, ne comptent pas et ne sont pas remplacés).
-- QuestieDB n'a pas la taille des sacs : elle est lue dans l'infobulle de l'objet (« 8 Slot Bag », chaîne du
-- jeu CONTAINER_SLOTS), puis gardée en cache. Taille encore inconnue (objet pas chargé) : utile seulement s'il
-- reste un emplacement de sac vide.
local BagQuests = {}
Q.BagQuests = BagQuests

local TAG_PREFIX = "bq:"
local BAG_SLOTS = { 1, 2, 3, 4 }   -- emplacements de sac (0 = sac à dos, toujours là)

---------------------------------------------------------------------------
-- Données et état sauvegardé
---------------------------------------------------------------------------
-- Q.char.bagQuests = { added = {[key]=true}, ignored = {...} }
local function saved()
  local c = Q.char
  if not c then return nil end
  if type(c.bagQuests) ~= "table" then c.bagQuests = {} end
  local bq = c.bagQuests
  for _, k in ipairs({ "added", "ignored" }) do
    if type(bq[k]) ~= "table" then bq[k] = {} end
  end
  return bq
end

-- Entrées dont la faction et les races conviennent au joueur.
local function entriesForPlayer()
  local P = Q.Player
  local data = type(Q.BagQuestData) == "table" and Q.BagQuestData or nil
  local out = {}
  if not data then return out end
  for _, e in ipairs(data) do
    if type(e) == "table" and type(e.key) == "string" and type(e.quests) == "table" and #e.quests > 0 then
      local factionOk = e.faction == nil or e.faction == P.faction
      if factionOk and Q.Util.MaskAllows(e.races, P.raceBit) then out[#out + 1] = e end
    end
  end
  return out
end

-- Find(key) -> entrée du joueur portant cette clé, ou nil.
function BagQuests:Find(key)
  for _, e in ipairs(entriesForPlayer()) do
    if e.key == key then return e end
  end
  return nil
end

-- Title(entry) -> nom de la quête à sac (la dernière de la chaîne) dans la langue du client.
function BagQuests:Title(entry)
  if type(entry) ~= "table" then return "?" end
  local id = type(entry.quests) == "table" and entry.quests[#entry.quests] or nil
  if id then
    local name = Q.QDB:QuestName(id)
    if type(name) == "string" and name ~= "" and name:sub(1, 1) ~= "#" then return name end
  end
  return tostring(entry.title or entry.key or "?")
end

local function isTurnedIn(id) return Q.Progress:IsTurnedIn(id) end

-- FirstQuest(entry) -> première quête pas encore rendue (la dernière si tout est rendu).
function BagQuests:FirstQuest(entry)
  local quests = type(entry) == "table" and type(entry.quests) == "table" and entry.quests or {}
  for _, id in ipairs(quests) do
    if not isTurnedIn(id) then return id end
  end
  return quests[#quests]
end

---------------------------------------------------------------------------
-- Taille des sacs
---------------------------------------------------------------------------
local slotCache = {}   -- [itemId] = nombre d'emplacements (seulement les valeurs lues)

-- Motif tiré d'une chaîne de format du jeu (« %d Slot %s », positions « %1$d » comprises) : le nombre
-- est capturé, le reste doit correspondre.
local function patternFrom(fmt)
  if type(fmt) ~= "string" or not fmt:find("%%%d?%$?d") then return nil end
  local p = fmt:gsub("%%%d%$", "%%")                       -- %1$d -> %d
  p = p:gsub("([%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")         -- caractères spéciaux (pas %)
  p = p:gsub("%%d", "\1"):gsub("%%s", "\2")
  p = p:gsub("%%", "%%%%")
  p = p:gsub("\1", "(%%d+)"):gsub("\2", ".-")
  return "^" .. p .. "$"
end
BagQuests.PatternFrom = patternFrom

local function slotsFromText(text)
  if type(text) ~= "string" then return nil end
  local p = patternFrom(CONTAINER_SLOTS)
  local n = p and text:match(p)
  if not n then n = text:match("^(%d+) Slot") end   -- client anglais sans la chaîne globale
  return tonumber(n)
end
BagQuests.SlotsFromText = slotsFromText

local scanTip
local function tooltipLines(itemId)
  local lines = {}
  local TI = C_TooltipInfo
  if TI and type(TI.GetItemByID) == "function" then
    local ok, data = pcall(TI.GetItemByID, itemId)
    if ok and type(data) == "table" and type(data.lines) == "table" then
      for _, l in ipairs(data.lines) do
        if type(l) == "table" and type(l.leftText) == "string" then lines[#lines + 1] = l.leftText end
      end
      if #lines > 0 then return lines end
    end
  end
  if not CreateFrame then return lines end
  if not scanTip then
    local ok, tip = pcall(CreateFrame, "GameTooltip", "QuestifyBagScanTooltip", nil, "GameTooltipTemplate")
    if not ok or not tip then return lines end
    scanTip = tip
  end
  local ok = pcall(function()
    scanTip:SetOwner(WorldFrame or UIParent, "ANCHOR_NONE")
    scanTip:ClearLines()
    if scanTip.SetItemByID then scanTip:SetItemByID(itemId) else scanTip:SetHyperlink("item:" .. itemId) end
  end)
  if not ok then return lines end
  local n = scanTip.NumLines and scanTip:NumLines() or 0
  for i = 1, n do
    local fs = _G["QuestifyBagScanTooltipTextLeft" .. i]
    local text = fs and fs.GetText and fs:GetText()
    if type(text) == "string" then lines[#lines + 1] = text end
  end
  scanTip:Hide()
  return lines
end

-- BagSlots(itemId) -> nombre d'emplacements du sac, ou nil s'il n'est pas encore connu (une demande de
-- chargement de l'objet est alors faite).
function BagQuests:BagSlots(itemId)
  if type(itemId) ~= "number" then return nil end
  if slotCache[itemId] then return slotCache[itemId] end
  for _, text in ipairs(tooltipLines(itemId)) do
    local n = slotsFromText(text)
    if n and n > 0 then
      slotCache[itemId] = n
      return n
    end
  end
  if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, itemId) end
  return nil
end

local function containerCall(name, bag)
  local fn = C_Container and C_Container[name] or _G[name]
  if type(fn) ~= "function" then return nil end
  local ok, a, b = pcall(fn, bag)
  if ok then return a, b end
  return nil
end

-- Equipped() -> { empty = nombre d'emplacements de sac vides, sizes = { tailles des sacs ordinaires portés } }
function BagQuests:Equipped()
  local out = { empty = 0, sizes = {} }
  for _, bag in ipairs(BAG_SLOTS) do
    local size = tonumber(containerCall("GetContainerNumSlots", bag)) or 0
    if size <= 0 then
      out.empty = out.empty + 1
    else
      local _, family = containerCall("GetContainerNumFreeSlots", bag)
      if family == nil or family == 0 then out.sizes[#out.sizes + 1] = size end
    end
  end
  table.sort(out.sizes)
  return out
end

-- Useful(entry) -> vrai si le sac de l'entrée améliore les sacs portés, faux sinon ; second résultat : taille
-- du sac (nil si inconnue).
function BagQuests:Useful(entry)
  if type(entry) ~= "table" then return false end
  local eq = self:Equipped()
  local slots = self:BagSlots(entry.bag)
  if eq.empty > 0 then return true, slots end
  if not slots then return false, nil end
  local smallest = eq.sizes[1]
  return smallest ~= nil and slots > smallest, slots
end

---------------------------------------------------------------------------
-- État
---------------------------------------------------------------------------
-- Entrée « dans la route » : toutes ses quêtes pas encore rendues sont rendues par une étape de la route du
-- joueur (Q.Progress:RouteTurnins) : la route la fait déjà, rien à proposer.
local function inRoute(entry, routeTurnins)
  if not routeTurnins then return false end
  local remaining = 0
  for _, id in ipairs(entry.quests) do
    if not isTurnedIn(id) then
      if not routeTurnins[id] then return false end
      remaining = remaining + 1
    end
  end
  return remaining > 0
end

local function requiredLevel(id, entry)
  local q = Q.QDB:Quest(id)
  local lvl = q and tonumber(q.reqLevel)
  if lvl and lvl > 0 then return lvl end
  return tonumber(entry.level) or 1
end

-- État, dans cet ordre : done, inroute, inprogress, added, ignored, available, upcoming.
local function entryState(entry, bq, routeTurnins)
  local last = entry.quests[#entry.quests]
  if isTurnedIn(last) then return "done" end
  if inRoute(entry, routeTurnins) then return "inroute" end
  for _, id in ipairs(entry.quests) do
    if Q.Progress:InLog(id) then return "inprogress" end
  end
  if bq.added[entry.key] then return "added" end
  if bq.ignored[entry.key] then return "ignored" end
  local first = BagQuests:FirstQuest(entry)
  if first and requiredLevel(first, entry) <= (Q.Player.level or 1) and Q.QDB:PrereqsMet(first, isTurnedIn) then
    return "available"
  end
  return "upcoming"
end

local function routeTurnins()
  local ok, set = pcall(Q.Progress.RouteTurnins, Q.Progress)
  if ok then return set end
  Q:ReportError(set)
  return nil
end

-- List() -> { { entry, state }, ... } dans l'ordre des données (niveau croissant).
function BagQuests:List()
  local out = {}
  local bq = Q.Progress:IsEnabled() and saved()
  if not bq then return out end
  local turnins = routeTurnins()
  for _, e in ipairs(entriesForPlayer()) do
    out[#out + 1] = { entry = e, state = entryState(e, bq, turnins) }
  end
  return out
end

---------------------------------------------------------------------------
-- Choix du joueur
---------------------------------------------------------------------------
-- Add(key) : insère « prendre, faire, rendre » pour chaque quête restante, avant la route. Refusé (faux) pour
-- une entrée déjà dans la route.
function BagQuests:Add(key)
  local bq = saved()
  if not bq or not Q.Progress:IsEnabled() then return false end
  local entry = self:Find(key)
  if not entry then return false end
  if inRoute(entry, routeTurnins()) then return false end
  local steps = {}
  for _, id in ipairs(entry.quests) do
    if not isTurnedIn(id) then
      steps[#steps + 1] = { "accept", id }
      steps[#steps + 1] = { "complete", id }
      steps[#steps + 1] = { "turnin", id }
    end
  end
  if #steps == 0 then return false end
  if Q.BagQuestOffer then Q.BagQuestOffer:Remove(key) end
  bq.added[key] = true
  bq.ignored[key] = nil
  Q.Progress:InsertSteps(TAG_PREFIX .. key, steps)
  Q:Fire("BAGQUESTS_CHANGED")
  return true
end

-- Ignore(key) : retire les étapes insérées et mémorise le choix.
function BagQuests:Ignore(key)
  local bq = saved()
  if not bq or not self:Find(key) then return false end
  bq.ignored[key] = true
  bq.added[key] = nil
  if Q.BagQuestOffer then Q.BagQuestOffer:Remove(key) end
  Q.Progress:RemoveInserted(TAG_PREFIX .. key)
  Q:Fire("BAGQUESTS_CHANGED")
  return true
end

-- UnignoreAll() -> nombre d'entrées de nouveau proposables (/qf sacs reset).
function BagQuests:UnignoreAll()
  local bq = saved()
  if not bq then return 0 end
  local n = 0
  for key in pairs(bq.ignored) do n = n + 1; bq.ignored[key] = nil end
  if n > 0 then Q:Fire("BAGQUESTS_CHANGED") end
  return n
end

---------------------------------------------------------------------------
-- Une entrée insérée se retire d'elle-même quand toutes ses étapes sont faites
---------------------------------------------------------------------------
Q:On("PROGRESS_UPDATED", function()
  if not Q.Progress:IsEnabled() then return end
  local bq = saved()
  if not bq then return end
  local groups, order = {}, {}
  for _, e in ipairs(Q.Progress:Entries()) do
    local tag = e.tag
    if tag and tag:sub(1, #TAG_PREFIX) == TAG_PREFIX then
      local g = groups[tag]
      if not g then g = { open = false }; groups[tag] = g; order[#order + 1] = tag end
      local state = Q.Progress:State(e)
      if state == "active" or state == "blocked" then g.open = true end
    end
  end
  local turnins
  for _, tag in ipairs(order) do
    local key = tag:sub(#TAG_PREFIX + 1)
    local entry = BagQuests:Find(key)
    local finished = not groups[tag].open or (entry and isTurnedIn(entry.quests[#entry.quests]))
    -- ajoutée à la main mais rendue par la route (chapitre suivant choisi) : la copie insérée part
    if not finished and entry then
      turnins = turnins or routeTurnins()
      finished = inRoute(entry, turnins)
    end
    if finished then
      Q.Progress:RemoveInserted(tag)
      bq.added[key] = nil
      Q:Fire("BAGQUESTS_CHANGED")
    end
  end
end)
