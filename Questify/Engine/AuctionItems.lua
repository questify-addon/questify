local addonName, Q = ...

-- Objets de collecte achetables à l'hôtel des ventes (option auctionItems).
-- Données : Q.AuctionItemData (tools/routebuilder/build_auction_items.lua) : par chapitre, les objectifs
-- « objet » dont l'objet n'est ni un objet de quête (classe 12) ni vendu par un marchand, et les encanteurs.
--
-- Liste : chapitre en cours puis chapitre suivant sur la route (Progress:NextGuide). Une ligne par objet
-- (les quêtes qui demandent le même objet s'additionnent). Écartés :
--   - quêtes rendues, ou hors de la route du personnage (race, classe, quêtes de donjon : Progress:FilterSkip) ;
--   - objectifs déjà remplis (journal), quantité couverte par les sacs ;
--   - objets liés (type de lien 1 « quand ramassé » ou 4 « objet de quête », lu par GetItemInfo) : un objet
--     pas encore en cache est demandé au serveur et attend sa réponse (GET_ITEM_INFO_RECEIVED) avant d'entrer.
-- Quantité : quête dans le journal : numRequired du client ; sinon la quantité des données (texte des
-- objectifs ; inconnue = 1, signalée par `approx`). Moins les exemplaires des sacs.
-- Un objet acheté avant la quête valide l'objectif dès qu'elle est prise (le client compte les sacs) :
-- l'étape « complete » est alors faite (Engine/Progress.lua). Un achat partiel laisse l'étape avec le reste.
--
-- Choix du joueur (Q.char.auction) : skip[itemId] = true (case décochée, l'objet n'est plus proposé),
-- hidden[guideId] = true (alerte masquée pour ce chapitre), offered[guideId] = true (message déjà donné).
-- Questify n'achète rien : « Chercher » remplit et lance la recherche de l'hôtel des ventes, l'achat reste
-- le clic du joueur (les achats sont protégés par le client).
local AI = {}
Q.AuctionItems = AI

local L = Q.L

local CHECK_INTERVAL = 5
local NEAR_AUCTIONEER = 120      -- yards : alerte près d'un encanteur
local START_WINDOW = 15 * 60     -- secondes : alerte de début de chapitre
local BIND_PICKUP, BIND_QUEST = 1, 4
local CLASS_QUEST = 12

AI.CHAT_LINK = "addon:Questify:ah"

local startedAt, startedGuide   -- début du chapitre (GUIDE_CHANGED) pour l'alerte
local nearAuctioneer = false
local ahOpen = false
local requested = {}            -- objets demandés au serveur

local function now() return (GetTime and GetTime()) or 0 end

function AI:Enabled()
  return Q.Settings and Q.Settings:Get("auctionItems") ~= false
end

local function charState()
  local c = Q.char
  if not c then return { skip = {}, hidden = {}, offered = {} } end
  c.auction = type(c.auction) == "table" and c.auction or {}
  local a = c.auction
  a.skip = type(a.skip) == "table" and a.skip or {}
  a.hidden = type(a.hidden) == "table" and a.hidden or {}
  a.offered = type(a.offered) == "table" and a.offered or {}
  return a
end

---------------------------------------------------------------------------
-- Objets (client)
---------------------------------------------------------------------------
-- Exemplaires dans les sacs (0 si inconnu ou secret).
function AI:Count(id)
  local fn = (C_Item and C_Item.GetItemCount) or GetItemCount
  if type(fn) ~= "function" or type(id) ~= "number" then return 0 end
  local ok, n = pcall(fn, id)
  if not ok or Q.Util.IsSecret(n) then return 0 end
  return tonumber(n) or 0
end

-- -> "ok" (vendable), "bound" (lié ou objet de quête), "loading" (pas encore en cache).
function AI:Tradable(id)
  local fn = (C_Item and C_Item.GetItemInfo) or GetItemInfo
  if type(fn) ~= "function" then return "loading" end
  local ok, name, _, _, _, _, _, _, _, _, _, _, classID, _, bindType = pcall(fn, id)
  if not ok or not name then
    if not requested[id] and C_Item and C_Item.RequestLoadItemDataByID then
      requested[id] = true
      pcall(C_Item.RequestLoadItemDataByID, id)
    end
    return "loading"
  end
  if classID == CLASS_QUEST or bindType == BIND_PICKUP or bindType == BIND_QUEST then return "bound" end
  return "ok"
end

function AI:Name(id)
  return Q.QDB:ItemName(id)
end

function AI:Icon(id)
  local fn = C_Item and C_Item.GetItemIconByID or GetItemIcon
  if type(fn) == "function" then
    local ok, icon = pcall(fn, id)
    if ok and icon then return icon end
  end
  return 134400
end

---------------------------------------------------------------------------
-- Prix : premier addon trouvé (Auctionator, TradeSkillMaster, LifeOnAzeroth: Market)
---------------------------------------------------------------------------
-- LifeOnAzeroth: Market n'a pas d'API : son addon de données remplit la globale LOA_DATA (houses[clé].lat :
-- id -> { prix typique, moins cher, ... }, ou latS en texte avant son premier usage). Lecture défensive :
-- au moindre écart de format, pas de prix.
local LOA_RULESETS = { "PvP", "Normal", "Roleplay", "Roleplay PvP" }

local function loaRuleset()
  local ok, name = pcall(GetRealmName)
  name = ok and type(name) == "string" and name:lower() or ""
  if name == "" then return nil end
  if name:find("rppvp", 1, true) or name:find("rp-pvp", 1, true) or name:find("rp pvp", 1, true) then
    return "Roleplay PvP"
  end
  if name:find("pvp", 1, true) then return "PvP" end
  if name:find("rp", 1, true) or name:find("roleplay", 1, true) then return "Roleplay" end
  return "Normal"
end

local function loaHouse(D)
  if type(D.houses) ~= "table" then return nil end
  local fac = UnitFactionGroup and UnitFactionGroup("player")
  local f = fac == "Alliance" and "A" or fac == "Horde" and "H" or nil
  local rs = loaRuleset()
  if f and rs then
    for i, n in ipairs(LOA_RULESETS) do
      if n == rs and type(D.houses[(i - 1) .. f]) == "table" then return D.houses[(i - 1) .. f] end
    end
  end
  for _, k in ipairs({ "0A", "0H", "1A", "1H", "2A", "2H", "3A", "3H" }) do
    if (not f or k:sub(2, 2) == f) and type(D.houses[k]) == "table" then return D.houses[k] end
  end
  return nil
end

local function loaPrice(id)
  local D = rawget(_G, "LOA_DATA")
  if type(D) ~= "table" then return nil end
  local H = loaHouse(D)
  if not H then return nil end
  local typical, cheapest
  if type(H.lat) == "table" and type(H.lat[id]) == "table" then
    typical, cheapest = H.lat[id][1], H.lat[id][2]
  elseif type(H.latS) == "string" then
    local a, b = ("\n" .. H.latS):match("\n" .. id .. ",([%d%.]*),([%d%.]*)")
    typical, cheapest = tonumber(a), tonumber(b)
  end
  if type(typical) ~= "number" or typical <= 0 then return nil end
  if type(cheapest) == "number" and cheapest > 0 and cheapest < typical then return cheapest end
  return typical
end

local PRICE_SOURCES = {
  { name = "Auctionator", get = function(id)
    local api = rawget(_G, "Auctionator")
    api = type(api) == "table" and type(api.API) == "table" and api.API.v1
    if type(api) ~= "table" or type(api.GetAuctionPriceByItemID) ~= "function" then return nil end
    return api.GetAuctionPriceByItemID("Questify", id)
  end },
  { name = "TSM", get = function(id)
    local api = rawget(_G, "TSM_API")
    if type(api) ~= "table" or type(api.GetCustomPriceValue) ~= "function" then return nil end
    return api.GetCustomPriceValue("DBMinBuyout", "i:" .. id) or api.GetCustomPriceValue("DBMarket", "i:" .. id)
  end },
  { name = "LifeOnAzeroth", get = loaPrice },
}
AI.PRICE_SOURCES = PRICE_SOURCES

-- -> prix unitaire en cuivre, nom de la source ; nil si aucun addon ne le connaît.
function AI:Price(id)
  for _, src in ipairs(PRICE_SOURCES) do
    local ok, v = pcall(src.get, id)
    if ok and type(v) == "number" and v > 0 and not Q.Util.IsSecret(v) then return math.floor(v + 0.5), src.name end
  end
  return nil
end

-- Somme en pièces (icônes du client), "" pour nil.
function AI:Money(copper)
  if type(copper) ~= "number" then return "" end
  copper = math.floor(copper + 0.5)
  local fn = (C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString) or GetCoinTextureString
  if type(fn) == "function" then
    local ok, s = pcall(fn, copper)
    if ok and type(s) == "string" then return s end
  end
  local g, s, c = math.floor(copper / 10000), math.floor(copper % 10000 / 100), copper % 100
  local out = {}
  if g > 0 then out[#out + 1] = g .. "g" end
  if s > 0 then out[#out + 1] = s .. "s" end
  if c > 0 or #out == 0 then out[#out + 1] = c .. "c" end
  return table.concat(out, " ")
end

---------------------------------------------------------------------------
-- Liste
---------------------------------------------------------------------------
local function data() return type(Q.AuctionItemData) == "table" and Q.AuctionItemData or {} end

local QUEST_STEPS = { accept = true, complete = true, turnin = true }

-- La quête est encore à faire dans le chapitre g pour le personnage. Chapitre courant (entries) : une étape
-- « accept », « complete » ou « turnin » ni faite ni sautée (une quête pas encore prise a son « accept »
-- actif, ses autres étapes sautées) ; chapitre suivant : une étape « complete » ou « turnin » qui le concerne.
local function questInGuide(g, questId, entries)
  if entries then
    for _, e in ipairs(entries) do
      local step = e.step
      if step.questId == questId and QUEST_STEPS[step.action] then
        local st = Q.Progress:State(e)
        if st ~= "done" and st ~= "skipped" then return true end
      end
    end
    return false
  end
  for _, step in ipairs(g.steps or {}) do
    if step.questId == questId and (step.action == "complete" or step.action == "turnin")
      and not Q.Progress:FilterSkip(step) then
      return true
    end
  end
  return false
end

-- Quantité demandée par la quête pour cet objectif, avant les sacs -> n, approx (quantité devinée), filled
-- (objectif déjà rempli : ses exemplaires des sacs lui restent réservés jusqu'au rendu).
local function required(e)
  local P = Q.Progress
  if P:InLog(e.quest) then
    local objs = C_QuestLog.GetQuestObjectives(e.quest)
    local o = objs and objs[e.obj]
    local n = o and tonumber(o.numRequired)
    if o and o.finished == true then return n or 0, false, true end
    if n and n > 0 then return n, false, false end
    if P:IsComplete(e.quest) then return 0, false, true end
  end
  if e.count then return e.count, false, false end
  return 1, true, false
end

-- Rows() -> { { item, name, need, have, total, approx, quests = { id... } (quêtes qui en demandent encore),
--               chapter = "current"|"next",
--               guideId, state = "ok"|"loading", skipped, price, source }, ... } (ordre des chapitres et des
-- étapes ; objets liés et quantités couvertes exclus ; lignes décochées incluses avec skipped = true).
function AI:Rows()
  local out = {}
  local P = Q.Progress
  if not (P and P:IsEnabled()) then return out end
  local g = P:Guide()
  if not g then return out end
  local byGuide = data().guides or {}
  local skip = charState().skip
  local byItem, counted = {}, {}
  local chapters = { { g, "current", P:Entries() } }
  local nxt = P.NextGuide and P:NextGuide()
  if nxt and nxt.id ~= g.id then chapters[#chapters + 1] = { nxt, "next" } end
  for _, ch in ipairs(chapters) do
    local guide, chapter, entries = ch[1], ch[2], ch[3]
    for _, e in ipairs(byGuide[guide.id] or {}) do
      if type(e) == "table" and type(e.item) == "number" and type(e.quest) == "number"
        and not P:IsTurnedIn(e.quest) and questInGuide(guide, e.quest, entries) then
        local n, approx, filled = required(e)
        local key = e.quest .. ":" .. e.item
        if n > 0 and not counted[key] then
          counted[key] = true
          local row = byItem[e.item]
          if not row then
            row = { item = e.item, total = 0, approx = false, quests = {} }
            byItem[e.item] = row
            out[#out + 1] = row
          end
          -- un objectif rempli garde ses exemplaires (total) sans rien demander de plus (quests)
          row.total = row.total + n
          if not filled then
            -- chapitre de la première quête qui en demande encore
            if not row.chapter then row.chapter, row.guideId = chapter, guide.id end
            row.quests[#row.quests + 1] = e.quest
            row.approx = row.approx or approx
          end
        end
      end
    end
  end
  local kept = {}
  for _, row in ipairs(out) do
    local state = self:Tradable(row.item)
    if state ~= "bound" then
      row.state = state
      row.have = self:Count(row.item)
      row.need = math.max(0, row.total - row.have)
      if row.need > 0 and #row.quests > 0 then
        row.name = self:Name(row.item)
        row.skipped = skip[row.item] == true
        row.price, row.source = self:Price(row.item)
        kept[#kept + 1] = row
      end
    end
  end
  return kept
end

-- Lignes à acheter : cochées et connues (objets en cache).
function AI:Wanted()
  local out = {}
  if not self:Enabled() then return out end
  for _, row in ipairs(self:Rows()) do
    if not row.skipped and row.state == "ok" then out[#out + 1] = row end
  end
  return out
end

function AI:SetSkipped(itemId, skipped)
  charState().skip[itemId] = skipped and true or nil
  Q:Fire("AUCTION_ITEMS_CHANGED")
end

-- Remet toutes les cases (/qf hv reset).
function AI:ResetChoices()
  local a = charState()
  local n = 0
  for k in pairs(a.skip) do a.skip[k] = nil; n = n + 1 end
  for k in pairs(a.hidden) do a.hidden[k] = nil end
  Q:Fire("AUCTION_ITEMS_CHANGED")
  return n
end

-- Ligne d'indice sous une étape « accept » ou « complete » : -> { item, need, name, approx } ou nil.
function AI:HintFor(entry)
  if not self:Enabled() or type(entry) ~= "table" then return nil end
  local step = entry.step or entry
  if step.action ~= "accept" and step.action ~= "complete" then return nil end
  for _, row in ipairs(self:Wanted()) do
    for _, q in ipairs(row.quests) do
      if q == step.questId then return row end
    end
  end
  return nil
end

---------------------------------------------------------------------------
-- Alerte du suivi : début de chapitre ou près d'un encanteur
---------------------------------------------------------------------------
local function auctioneerIds()
  local a = data().auctioneers or {}
  local f = Q.Player and Q.Player.faction
  return (f == "Horde" and a.H) or (f == "Alliance" and a.A) or {}
end

-- Encanteur ami à NEAR_AUCTIONEER yards ou moins.
function AI:NearAuctioneer()
  local pm, px, py = Q.Maps:PlayerPos()
  if not pm then return false end
  for _, id in ipairs(auctioneerIds()) do
    local n = Q.QDB:Npc(id)
    if n and n.spawns then
      local _, _, _, d = Q.Maps:Nearest(n.spawns, pm, px, py)
      if d and d <= NEAR_AUCTIONEER then return true end
    end
  end
  return false
end

-- Alert() -> { count, rows } quand l'alerte du suivi doit s'afficher, sinon nil.
function AI:Alert()
  if not self:Enabled() or ahOpen then return nil end
  local g = Q.Progress and Q.Progress:Guide()
  if not g or charState().hidden[g.id] then return nil end
  local fresh = startedGuide == g.id and startedAt and (now() - startedAt) <= START_WINDOW
  if not (fresh or nearAuctioneer) then return nil end
  local rows = self:Wanted()
  if #rows == 0 then return nil end
  return { count = #rows, rows = rows }
end

-- Clic droit sur l'alerte : masquée jusqu'au prochain chapitre.
function AI:HideAlert()
  local g = Q.Progress and Q.Progress:Guide()
  if g then charState().hidden[g.id] = true end
  Q:Fire("AUCTION_ITEMS_CHANGED")
end

-- Début de chapitre : alerte, et une ligne dans la discussion (une fois par chapitre).
function AI:OnChapterStart(g)
  if not (g and g.id) then return end
  startedGuide, startedAt = g.id, now()
  if not self:Enabled() then return end
  local a = charState()
  if a.offered[g.id] then return end
  local rows = self:Wanted()
  if #rows == 0 then return end
  a.offered[g.id] = true
  local names = {}
  for i, row in ipairs(rows) do
    if i > 4 then names[#names + 1] = "…"; break end
    names[#names + 1] = row.name
  end
  local msg = string.format(L.AH_CHAT_OFFER, #rows, table.concat(names, ", "))
  -- lien cliquable (liens d'addon du client : EventRegistry « SetItemRef », UI/AuctionPanel.lua)
  if EventRegistry and EventRegistry.RegisterCallback then
    msg = msg .. " |H" .. AI.CHAT_LINK .. "|h|cffffd100" .. L.AH_CHAT_LINK .. "|r|h"
  end
  Q:Print("%s", msg .. " " .. L.AH_CHAT_HINT)
end

---------------------------------------------------------------------------
-- Hôtel des ventes
---------------------------------------------------------------------------
function AI:IsOpen() return ahOpen end

-- Remplit et lance la recherche de l'hôtel des ventes (nom exact). -> vrai si la recherche est partie.
-- À appeler depuis un clic du joueur.
function AI:Search(itemId)
  local name = self:Name(itemId)
  if type(name) ~= "string" or name == "" or name:sub(1, 1) == "#" then return false end
  local exact = '"' .. name .. '"'
  local AHF = rawget(_G, "AuctionHouseFrame")
  local bar = type(AHF) == "table" and AHF.SearchBar
  if type(bar) == "table" and bar.SearchBox and bar.SearchBox.SetText then
    bar.SearchBox:SetText(exact)
    if type(bar.StartSearch) == "function" then
      local ok = pcall(bar.StartSearch, bar)
      return ok
    end
    return false
  end
  -- interface classique (AuctionFrame) si le client la fournit
  local box = rawget(_G, "BrowseName")
  if type(box) == "table" and box.SetText then
    box:SetText(name)
    local fn = rawget(_G, "AuctionFrameBrowse_Search")
    if type(fn) == "function" then return (pcall(fn)) end
  end
  return false
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
local lastNear, lastSig

local function signature()
  local parts = {}
  for _, row in ipairs(AI:Wanted()) do parts[#parts + 1] = row.item .. ":" .. row.need end
  return table.concat(parts, ",")
end

local function check()
  if not (Q.Progress and Q.Progress:IsEnabled()) then return end
  local ok, near = pcall(AI.NearAuctioneer, AI)
  nearAuctioneer = ok and near or false
  local sig = signature()
  if nearAuctioneer ~= lastNear or sig ~= lastSig then
    lastNear, lastSig = nearAuctioneer, sig
    Q:Fire("AUCTION_ITEMS_CHANGED")
  end
end

Q:On("LOGIN", function()
  Q:NewTicker(CHECK_INTERVAL, function() Q.SafeCall(check) end)
  local g = Q.Progress and Q.Progress:Guide()
  if g then startedGuide, startedAt = g.id, now() end
end)
Q:On("GUIDE_CHANGED", function(g) Q.SafeCall(AI.OnChapterStart, AI, g) end)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "auctionItems" then Q:Fire("AUCTION_ITEMS_CHANGED") end
end)
for _, event in ipairs({ "BAG_UPDATE_DELAYED", "QUEST_LOG_UPDATE", "GET_ITEM_INFO_RECEIVED" }) do
  Q:RegisterEvent(event, function() Q.SafeCall(check) end)
end
Q:RegisterEvent("AUCTION_HOUSE_SHOW", function()
  ahOpen = true
  Q:Fire("AUCTION_HOUSE_OPENED")
  Q:Fire("AUCTION_ITEMS_CHANGED")
end)
Q:RegisterEvent("AUCTION_HOUSE_CLOSED", function()
  ahOpen = false
  Q:Fire("AUCTION_HOUSE_CLOSED")
  Q:Fire("AUCTION_ITEMS_CHANGED")
end)
