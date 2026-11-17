local addonName, Q = ...

-- Commande cachée /qf demo : montre les vraies fenêtres et alertes de l'addon avec des données
-- d'exemple, pour prendre des captures en jeu. Absente de /qf help, des options et du menu de la
-- minicarte ; /qf demo seul liste les scènes dans la discussion.
--   /qf demo <scène>   une scène : tracker, zone, classquest, classlate, dungeon, upgrade, pair, route,
--                      supplies, cave, profession, questitem, theme (thème suivant à chaque appel), options
--   /qf demo all       enchaîne les scènes ; /qf demo next passe à la suivante
--   /qf demo off       ferme tout et rétablit l'état d'avant (repère, lignes du suivi, alertes)
-- Aucun effet de bord : rien n'est écrit dans Q.char ni dans Q.db, aucune quête n'est ajoutée, ignorée
-- ou choisie, aucun objet n'est équipé. Les fenêtres reçoivent un drapeau « demo » (sur la chaîne, le
-- donjon, l'annonce ou les cartes) : leurs boutons se contentent alors de fermer la fenêtre. Les alertes
-- du suivi et les lignes d'avant-poste viennent de fonctions du jeu remplacées le temps de la scène et
-- rendues par « off » ; le repère de la grotte passe par Q.Nav:SetTarget, puis l'ancien repère revient.
-- Hors combat seulement : en combat un message le dit et rien ne s'ouvre ; un début de combat range tout.
-- Données : les vraies (chaînes de la classe du joueur, donjon de sa faction, guides livrés, grottes) ;
-- exemples fixes : la suite de Loch Modan est calculée pour un Nain de l'Alliance (quelle que soit la
-- position réelle), les objets viennent de Demo:ItemSet() (le premier connu du client est pris).
-- Une donnée ou une API absente : la scène le dit dans la discussion et ne lève jamais d'erreur.
Q.UI = Q.UI or {}
local Demo = {}
Q.UI.Demo = Demo

local L = Q.L

-- Ordre de /qf demo all.
Demo.SCENES = { "tracker", "zone", "classquest", "classlate", "dungeon", "upgrade", "pair", "route", "supplies", "cave",
  "profession", "questitem", "auction", "theme", "options" }

-- Objets d'exemple (ID de WoW Classic) : par liste, le premier que le client connaît est pris.
-- upgrade : annonce simple ; main + off : une arme à une main et un bouclier (annonce de paire).
Demo.ITEMS = {
  upgrade = { 2129, 2362 },
  main = { 36, 37 },
  off = { 2362, 2129 },
  quest = 13892,   -- Kodo Kombobulator : objet de quête à utiliser, absent des sacs (le clic ne fait rien)
}

-- Jeux d'objets par niveau (récompenses de quête vérifiées dans QuestieDB, niveau d'objet entre
-- parenthèses) : le comparatif de l'annonce montre un vrai gain face à l'équipement d'un personnage de ce
-- niveau. Demo:ItemSet() prend le plus haut jeu dont le niveau ne dépasse pas celui du joueur + 4.
Demo.ITEM_SETS = {
  { level = 1, upgrade = Demo.ITEMS.upgrade, main = Demo.ITEMS.main, off = Demo.ITEMS.off },
  { level = 28,
    upgrade = { 6972, 7133 },       -- Fire Hardened Hauberk (30), Brutal Hauberk (30)
    main = { 19292, 4978 },         -- Last Month's Mutton (34), Ryedol's Hammer (36)
    off = { 9607, 16660 } },        -- Bastion of Stormwind (25), Driftmire Shield (27)
  { level = 36,
    upgrade = { 4508, 6773 },       -- Blood-tinged Armor (42), Gelkis Marauder Chain (42)
    main = { 4511, 6804 },          -- Black Water Hammer (40), Windstorm Hammer (38)
    off = { 4507, 9661 } },         -- Pit Fighter's Shield (42), Earthclasp Barrier (43)
  { level = 50,
    upgrade = { 12049, 9650 },      -- Splintsteel Armor (53), Honorguard Chestpiece (55)
    main = { 11120, 9651 },         -- Belgrom's Hammer (55), Gryphon Rider's Stormhammer (53)
    off = { 10686, 11915 } },       -- Aegis of Battle (55), Shizzle's Drizzle Blocker (55)
}

function Demo:ItemSet()
  local level = tonumber(Q.Player and Q.Player.level) or 1
  local best = self.ITEM_SETS[1]
  for _, set in ipairs(self.ITEM_SETS) do
    if set.level <= level + 4 then best = set end
  end
  return best
end

-- Liste d'achats d'exemple (Guides/AuctionItemData.lua) : objets de collecte à acheter à l'hôtel des ventes,
-- chapitre en cours (Loch Modan, Marche de l'Ouest) puis chapitre suivant (Darkshore).
Demo.AUCTION = {
  { item = 814, quest = 103, count = 5, chapter = "current" },   -- Flask of Oil : Keeper of the Flame
  { item = 723, quest = 22, count = 8, chapter = "current" },    -- Goretusk Liver : Goretusk Liver Pie
  { item = 3712, quest = 555, count = 10, chapter = "next" },    -- Turtle Meat : Soothing Turtle Bisque
}

local ROUTE_FROM = "A_DwarfGnome_03"            -- Loch Modan : Marche de l'Ouest ou Sombrivage
local ROUTE_RACE, ROUTE_FACTION = "Dwarf", "Alliance"
local DUNGEONS = { Alliance = "DM", Horde = "RFC" }
local CAVE_KEY = "dunmorogh_grizzled_den"
local ITEM_TRIES, ITEM_DELAY = 6, 0.5          -- attente du chargement d'un objet : 3 s au plus
local SUPPLY_COLOR = "|cffffd040"
local CENTER_COLOR = { r = 1, g = 0.82, b = 0.25 }
local WHY_DATA, WHY_API, WHY_ITEM = "UI_DEMO_WHY_DATA", "UI_DEMO_WHY_API", "UI_DEMO_WHY_ITEM"
local WHY_TRACKER = "UI_DEMO_WHY_TRACKER"

local token = 0            -- change à chaque scène et à chaque « off » : les attentes en cours s'annulent
local patches = {}         -- fonctions remplacées : { table, clé, original }
local extraLines = {}      -- lignes ajoutées au suivi (zone des avertissements)
local savedNav             -- { target = ... } : repère d'avant la scène
local coverActive          -- étape « tuer » simulée : la route est recalculée à la fermeture
local zoneActive           -- zone d'exemple : suivi, carte et minicarte redessinés à la fermeture
local optionsOpened        -- fenêtre d'options ouverte par la scène « options »
local auctionOpened        -- liste d'achats ouverte par la scène « auction »
Demo.themeIndex = 0        -- dernier thème montré par la scène « theme » (le suivant au prochain appel)
local seq                  -- { i = scène courante de /qf demo all }

local function inCombat() return InCombatLockdown and InCombatLockdown() end

local function say(fmt, ...) Q:Print(fmt, ...) end

local function copy(t)
  local out = {}
  for k, v in pairs(t) do out[k] = v end
  return out
end

local function refreshTracker()
  local T = Q.UI and Q.UI.Tracker
  if T and T.Refresh then T:Refresh() end
end

---------------------------------------------------------------------------
-- Fonctions remplacées le temps d'une scène
---------------------------------------------------------------------------
local function patch(tbl, key, make)
  patches[#patches + 1] = { tbl, key, tbl[key] }
  tbl[key] = make(tbl[key])
end

local function unpatch()
  for i = #patches, 1, -1 do
    local p = patches[i]
    p[1][p[2]] = p[3]
    patches[i] = nil
  end
end

-- Lignes ajoutées après celles d'Engine/Supplies.lua (zone des avertissements du suivi).
local function showExtraLines(lines)
  local S = Q.Supplies
  if not (S and type(S.Lines) == "function") then return false end
  extraLines = lines
  local patched = false
  for _, p in ipairs(patches) do
    if p[1] == S and p[2] == "Lines" then patched = true end
  end
  if not patched then
    patch(S, "Lines", function(orig)
      return function(self, ...)
        local out = orig(self, ...)
        out = type(out) == "table" and out or {}
        for _, line in ipairs(extraLines) do out[#out + 1] = line end
        return out
      end
    end)
  end
  return true
end

---------------------------------------------------------------------------
-- Données d'exemple
---------------------------------------------------------------------------
-- Chaînes de la classe du joueur (faction et race convenables).
local function classChains()
  local P = Q.Player or {}
  local byClass = type(Q.ClassQuestData) == "table" and Q.ClassQuestData[P.classFile]
  local out = {}
  if type(byClass) ~= "table" then return out end
  for _, chain in ipairs(byClass) do
    if type(chain) == "table" and type(chain.key) == "string" and type(chain.quests) == "table"
      and #chain.quests > 0 and (chain.faction == nil or chain.faction == P.faction)
      and Q.Util.MaskAllows(chain.races, P.raceBit) then
      out[#out + 1] = chain
    end
  end
  return out
end

-- Copie de la chaîne marquée « demo » : la première disponible (en retard d'abord si late), sinon la
-- première de la classe. nil sans donnée.
local function pickChain(late)
  local mine = classChains()
  if #mine == 0 then return nil end
  local state = {}
  local cq = Q.ClassQuests
  if cq and cq.List then
    local ok, rows = pcall(cq.List, cq)
    if ok and type(rows) == "table" then
      for _, row in ipairs(rows) do
        if type(row) == "table" and type(row.chain) == "table" then state[row.chain.key] = row.state end
      end
    end
  end
  local chosen
  if late and cq and cq.IsLate then
    for _, chain in ipairs(mine) do
      if state[chain.key] == "available" and cq.IsLate(chain, "available") then chosen = chain; break end
    end
  end
  if not chosen then
    for _, chain in ipairs(mine) do
      if state[chain.key] == "available" then chosen = chain; break end
    end
  end
  local demo = copy(chosen or mine[1])
  demo.demo = true
  return demo
end

local function pickDungeon()
  local P = Q.Player or {}
  local key = DUNGEONS[P.faction] or DUNGEONS.Alliance
  for _, d in ipairs(type(Q.DungeonData) == "table" and Q.DungeonData or {}) do
    if type(d) == "table" and d.key == key then
      local demo = copy(d)
      demo.demo = true
      return demo
    end
  end
  return nil
end

-- Premier objet connu du client parmi des ID : -> id, nom, lien.
local function knownItem(ids)
  for _, id in ipairs(ids) do
    local name, link = Q.API.GetItemInfo(id)
    if type(name) == "string" and name ~= "" and type(link) == "string" and link ~= "" then
      return id, name, link
    end
  end
  return nil
end

-- Attend que chaque liste d'ID donne un objet connu, puis done({ { id, name, link }, ... }). Les
-- données sont demandées au client à chaque essai ; sans réponse, un message le dit.
local function whenItems(mine, scene, lists, done, tries)
  if mine ~= token then return end
  local items = {}
  for i, ids in ipairs(lists) do
    local id, name, link = knownItem(ids)
    if not id then break end
    items[i] = { id = id, name = name, link = link }
  end
  if #items == #lists then return done(items) end
  if tries >= ITEM_TRIES then
    say(L.UI_DEMO_MISSING, scene, L[WHY_ITEM])
    return
  end
  if C_Item and C_Item.RequestLoadItemDataByID then
    for _, ids in ipairs(lists) do
      for _, id in ipairs(ids) do pcall(C_Item.RequestLoadItemDataByID, id) end
    end
  end
  Q:After(ITEM_DELAY, function() whenItems(mine, scene, lists, done, tries + 1) end)
end

---------------------------------------------------------------------------
-- Scènes : chacune renvoie true, ou false et la clé du texte qui dit pourquoi.
---------------------------------------------------------------------------
local SCENE = {}

-- Bouton du suivi qui brille pendant la scène (UI/TrackerButtons.lua : ClassGlow ou DungeonGlow).
local function glowButton(name)
  local B = Q.UI.TrackerButtons
  if B and B[name] then patch(B, name, function() return function() return 1 end end) end
end

-- Alerte du suivi : une seule ligne d'exemple à la place des vraies alertes ; late = en retard.
local function classAlert(chain, late)
  local cq = Q.ClassQuests
  if not (cq and cq.Alerts) then return end
  patch(cq, "Alerts", function()
    return function() return { { chain = chain, state = "available" } } end
  end)
  patch(cq, "IsLate", function(orig)
    return function(c, state)
      if late and type(c) == "table" and c.demo then return state == "available" end
      return orig(c, state)
    end
  end)
  glowButton("ClassGlow")
end

function SCENE.classquest()
  local P = Q.UI.ClassQuestPopup
  local chain = pickChain(false)
  if not (P and chain) then return false, WHY_DATA end
  classAlert(chain, false)
  refreshTracker()
  P:Show(chain, 1, 1)
  return true
end

-- Le suivi ne dessine ses alertes qu'avec QuestieDB et un chapitre en cours (UI/Tracker.lua, Refresh) :
-- sans eux, une scène qui ne montre qu'une alerte du suivi n'aurait rien à l'écran.
local function trackerShowsChapter()
  local qdb = Q.QDB
  if not qdb then return false end
  local status = qdb.Status and qdb:Status() or (qdb.IsAvailable and qdb:IsAvailable() and "ok") or "missing"
  if status ~= "ok" then return false end
  return Q.Progress and Q.Progress.Guide and Q.Progress:Guide() ~= nil or false
end

function SCENE.classlate()
  if not trackerShowsChapter() then return false, WHY_TRACKER end
  local chain = pickChain(true)
  if not (Q.UI.ClassQuestPopup and chain) then return false, WHY_DATA end
  classAlert(chain, true)
  refreshTracker()
  return true
end

function SCENE.dungeon()
  local P, D = Q.UI.DungeonPopup, Q.Dungeons
  local d = pickDungeon()
  if not (P and D and D.Alerts and d) then return false, WHY_DATA end
  patch(D, "Alerts", function()
    return function() return { { dungeon = d, state = "available" } } end
  end)
  glowButton("DungeonGlow")
  refreshTracker()
  P:Show(d, 1, 1)
  return true
end

-- Boîte « Équiper » sous le suivi : l'objet est demandé au client, puis la vraie boîte s'affiche, sans
-- minuterie (survol : comparatif avant/après).
local function announce(scene, lists, make)
  local P = Q.UI.UpgradePopup
  if not (P and P.ShowEntry and Q.API and Q.API.GetItemInfo) then return false, WHY_API end
  whenItems(token, scene, lists, function(items)
    if inCombat() then
      say(L.UI_DEMO_COMBAT)
      return
    end
    -- une vraie annonce à l'écran repart en tête de file : « off » la rend
    if P.current and not P.current.demo then table.insert(P.queue, 1, P.current) end
    P:ShowEntry(make(items))
    P.serial = (P.serial or 0) + 1   -- l'annonce reste affichée jusqu'à « off » ou au clic
  end, 0)
  return true
end

-- Gain au score de classe de l'objet de démonstration (ligne du comparatif), rien s'il n'en a pas.
local function demoGain(link)
  local R = Q.Rewards
  local ok, gain = pcall(function() return R:UpgradeGain(R:ReadItem(link), Q.Player) end)
  return ok and type(gain) == "number" and gain > 0 and gain or nil
end

function SCENE.upgrade()
  return announce("upgrade", { Demo:ItemSet().upgrade }, function(items)
    return { link = items[1].link, name = items[1].name, gain = demoGain(items[1].link), demo = true }
  end)
end

function SCENE.pair()
  local set = Demo:ItemSet()
  return announce("pair", { set.main, set.off }, function(items)
    return { link = items[1].link, name = items[1].name, gain = demoGain(items[1].link), demo = true,
      pair = { main = items[1].link, off = items[2].link } }
  end)
end

-- Fenêtre de choix de suite : cartes de Q.RouteChoice:Rank pour les suites de la fin de Loch Modan,
-- comme Popup:Open les montre (sans passer par Q.Progress, qui dépend de la position réelle).
function SCENE.route()
  local P = Q.UI.RouteChoicePopup
  local guide = Q.Guides and Q.Guides:Get(ROUTE_FROM)
  if not (P and guide and Q.RouteChoice) then return false, WHY_DATA end
  local options = Q.Guides:Choices(guide, ROUTE_RACE, ROUTE_FACTION)
  if #options < 2 then return false, WHY_DATA end
  -- classées au niveau de fin du chapitre, pas au niveau réel : un personnage plus haut verrait toutes les
  -- cartes en « quêtes faciles »
  local cards = Q.RouteChoice:Rank(options, tonumber(guide.maxLevel))
  cards.demo = true
  P.resume = nil
  P.fromId, P.manual, P.cards = ROUTE_FROM, true, cards
  local f = P:Create()
  P:Fill(ROUTE_FROM, cards)
  f:Show()
  if P.fadeIn then P.fadeIn:Play() end
  P:SetKeyboard(true)
  return true
end

-- Message bien visible au milieu de l'écran (même chemin qu'Engine/Supplies.lua).
local function centerMessage(text)
  if RaidWarningFrame then
    if type(RaidWarningUtil) == "table" and type(RaidWarningUtil.AddMessage) == "function" then
      if pcall(RaidWarningUtil.AddMessage, text, CENTER_COLOR) then return end
    elseif type(RaidNotice_AddMessage) == "function" then
      if pcall(RaidNotice_AddMessage, RaidWarningFrame, text, CENTER_COLOR) then return end
    end
  end
  local frame = UIErrorsFrame
  if type(frame) == "table" and type(frame.AddMessage) == "function" then
    pcall(frame.AddMessage, frame, text, CENTER_COLOR.r, CENTER_COLOR.g, CENTER_COLOR.b)
  end
end

-- Alerte d'avant-poste : « 4 places libres sur 64, pas de boisson » (lignes du suivi, discussion et
-- message au centre, comme Engine/Supplies.lua).
function SCENE.supplies()
  local C = Q.Comfort
  if not C then return false, WHY_API end
  local slots = C.Format(L.COMFORT_SLOTS_FREE, 4, 64)
  local lines = {
    SUPPLY_COLOR .. C.Format(L.COMFORT_BAGS_FULL, slots) .. "|r",
    SUPPLY_COLOR .. L.COMFORT_NO_DRINK .. "|r",
  }
  if not showExtraLines(lines) then return false, WHY_API end
  local msg = C.Format(L.COMFORT_SUPPLY_ALERT, slots .. L.COMFORT_LIST_SEP .. L.COMFORT_PART_DRINK)
  say("%s", msg)
  centerMessage(msg)
  refreshTracker()
  return true
end

-- Repère « Entrée de la grotte — The Grizzled Den » à l'entrée réelle, par la navigation normale
-- (affichage WaypointUI, TomTom ou natif selon les réglages).
function SCENE.cave()
  local N = Q.Nav
  if not (N and N.SetTarget and N.Status) then return false, WHY_API end
  local cave
  for _, c in ipairs(type(Q.CaveData) == "table" and Q.CaveData or {}) do
    if type(c) == "table" and type(c.entrance) == "table" and type(c.mapId) == "number" then
      cave = cave or c
      if c.key == CAVE_KEY then cave = c; break end
    end
  end
  if not cave then return false, WHY_DATA end
  local name = tostring(cave.name or cave.key):gsub("%s*%b()%s*$", "")
  savedNav = savedNav or { target = N:Status().target }
  N:SetTarget(cave.mapId, cave.entrance[1], cave.entrance[2], L.NAV_CAVE_ENTER .. " — " .. name)
  return true
end

-- Étape « Métier : Herboristerie (Compagnon) » : titre dans la discussion, texte dans la zone des
-- avertissements du suivi ; rien n'est inséré dans la route.
function SCENE.profession()
  local F = Q.Format
  if not (F and Q.Professions) then return false, WHY_DATA end
  local step = { action = "trainprof", prof = "HERBALISM", rank = 2 }
  say("%s", F:StepTitle(step))
  if not showExtraLines({ F:StepText(step) }) then return false, WHY_API end
  refreshTracker()
  return true
end

-- Couverture : le suivi sur une étape « tuer » du chapitre courant, avec les monstres sous l'objectif,
-- la distance et la ligne XP/h. Étape choisie : d'abord une quête du journal (vrais compteurs), sinon la
-- première étape « complete » dont les objectifs ont des monstres. Sans assez de données pour l'XP/h,
-- un exemple fixe la remplace.
local function killEntry()
  local P, T = Q.Progress, Q.Targets
  if not (P and P.Entries and T and T.MobsForEntry) then return nil end
  local fallback
  for _, e in ipairs(P:Entries()) do
    local s = e.step
    if type(s) == "table" and s.action == "complete" and type(s.questId) == "number" then
      local ok, mobs = pcall(T.MobsForEntry, T, e)
      if ok and type(mobs) == "table" and #mobs > 0 then
        if P:InLog(s.questId) then return e end
        fallback = fallback or e
      end
    end
  end
  return fallback
end

local function coverSetup()
  if not trackerShowsChapter() then return false, WHY_TRACKER end
  local entry = killEntry()
  if not entry then return false, WHY_DATA end
  coverActive = true
  patch(Q.Progress, "Current", function() return function() return entry end end)
  local X, C = Q.XPRate, Q.Comfort
  if X and X.Text and C and C.Format and C.FormatDuration then
    patch(X, "Text", function(orig)
      return function(self, ...)
        local text = orig(self, ...)
        if text then return text end
        return C.Format(L.COMFORT_XP_RATE_LEVEL, "11.8k", C.FormatDuration(1260))
      end
    end)
  end
  return true
end

function SCENE.tracker()
  local ok, why = coverSetup()
  if not ok then return false, why end
  refreshTracker()
  return true
end

-- Zone d'exemple autour du joueur (mode zone, Engine/ZoneMode.lua) : un objet du monde, un nommé et
-- deux sortes de monstres, dans le suivi (dedans : objectifs groupés et numérotés) et sur la carte
-- du monde et la minicarte (UI/ZoneOverlay.lua). Positions : décalages fixes (en % de la carte) autour
-- du joueur ; textes d'exemple (Q.L) ; le journal de quêtes n'est pas lu.
Demo.ZONE_SAMPLE = {
  { kind = "object", targetKind = "object", name = "UI_DEMO_ZONE_OBJECT", text = "UI_DEMO_ZONE_OBJECT_TEXT",
    pts = { { -1.2, -1.0 }, { -0.9, -1.3 } } },
  { kind = "named", targetKind = "npc", name = "UI_DEMO_ZONE_NAMED", text = "UI_DEMO_ZONE_NAMED_TEXT",
    pts = { { 1.4, -1.6 } }, minLevel = 5, maxLevel = 5 },
  { kind = "mob", targetKind = "npc", name = "UI_DEMO_ZONE_MOB_1", text = "UI_DEMO_ZONE_MOB_1_TEXT",
    pts = { { -1.6, 0.8 }, { -0.6, 1.5 }, { 0.3, 1.1 }, { -2.0, -0.2 } }, minLevel = 1, maxLevel = 2 },
  { kind = "mob", targetKind = "npc", name = "UI_DEMO_ZONE_MOB_2", text = "UI_DEMO_ZONE_MOB_2_TEXT",
    pts = { { 1.2, 0.3 }, { 1.8, 1.0 }, { 2.2, -0.5 }, { 0.6, -0.4 } }, minLevel = 2, maxLevel = 2 },
}
local ZONE_PRIORITY = { object = 1, named = 2, mob = 3 }

local function demoZone(entry)
  local pm, px, py = Q.Maps:PlayerPos()
  if not pm then return nil, WHY_API end
  local cont = Q.Maps:WorldPos(pm, px, py)
  if cont == nil then return nil, WHY_API end
  local objectives, quests = {}, {}
  local questId = entry.step.questId
  for i, s in ipairs(Demo.ZONE_SAMPLE) do
    local points = {}
    for _, d in ipairs(s.pts) do
      local x, y = px + d[1], py + d[2]
      local c, wx, wy = Q.Maps:WorldPos(pm, x, y)
      if c == cont then points[#points + 1] = { mapId = pm, x = x, y = y, wx = wx, wy = wy } end
    end
    objectives[#objectives + 1] = { kind = s.kind, targetKind = s.targetKind, id = -i, name = L[s.name],
      questId = questId, objIndex = i, done = false, priority = ZONE_PRIORITY[s.kind], points = points,
      entryKey = entry.key, minLevel = s.minLevel, maxLevel = s.maxLevel, demoText = L[s.text], seq = i }
    quests[questId] = true
  end
  return {
    ownerKey = entry.key, entries = { entry }, entryKeys = { [entry.key] = true },
    center = { pm, px, py, mapId = pm, x = px, y = py }, radius = 120, continent = cont,
    objectives = objectives, questCount = 3, inside = true, name = L.UI_DEMO_ZONE_NAME,
  }
end

function SCENE.zone()
  local ok, why = coverSetup()
  if not ok then return false, why end
  local entry = Q.Progress:Current()
  local Z = Q.ZoneMode
  if not (Z and Z.Current) then return false, WHY_API end
  local z, why2 = demoZone(entry)
  if not z then return false, why2 end
  zoneActive = true
  -- la navigation suit la zone d'exemple : le repère d'avant revient à la fermeture
  local N = Q.Nav
  if N and N.Status then savedNav = savedNav or { target = N:Status().target } end
  patch(Z, "Current", function() return function() return z end end)
  patch(Z, "IsOwner", function() return function(_, e) return type(e) == "table" and e.key == z.ownerKey end end)
  patch(Z, "ProgressText", function(orig)
    return function(self, o, ...)
      if o and o.demoText then return o.demoText end
      return orig(self, o, ...)
    end
  end)
  Q:Fire("ZONEMODE_CHANGED", z)
  refreshTracker()
  return true
end

-- Bouton de l'objet de quête à gauche du suivi (objet d'exemple Demo.ITEMS.quest, icône en couleur).
function SCENE.questitem()
  local B = Q.UI.QuestItemButton
  if not (B and B.ItemFor and B.Refresh and B.UpdateLook) then return false, WHY_API end
  local ok, why = coverSetup()
  if not ok then return false, why end
  patch(B, "ItemFor", function() return function() return Demo.ITEMS.quest end end)
  patch(B, "UpdateLook", function(orig)
    return function(self, ...)
      orig(self, ...)
      if self.icon then self.icon:SetDesaturated(false) end
    end
  end)
  refreshTracker()
  B:Refresh()
  return true
end

-- Thèmes (UI/Themes.lua) : chaque appel montre le suivant (Questify, Alliance, les races…), sur la
-- même étape que la couverture, sur le suivi et les fenêtres décorées ; le réglage enregistré ne
-- change pas. Le blason retenu (atlas ou fichier du client) est écrit dans la discussion.
function SCENE.theme()
  local T = Q.Themes
  if not (T and T.List) then return false, WHY_API end
  local list = T:List()
  if #list == 0 then return false, WHY_DATA end
  local ok, why = coverSetup()
  if not ok then return false, why end
  Demo.themeIndex = Demo.themeIndex % #list + 1
  local theme = list[Demo.themeIndex]
  patch(Q.Settings, "Get", function(orig)
    return function(self, path, ...)
      if path == "tracker.theme" then return theme.key end
      if path == "theme.followRace" then return false end
      return orig(self, path, ...)
    end
  end)
  say(L.UI_DEMO_THEME, theme.label, Demo.themeIndex, #list)
  if T.EmblemSource then
    local src = T:EmblemSource(T:Get(theme.key))
    say(L.UI_DEMO_THEME_EMBLEM, theme.label, tostring(src.atlas or src.file))
  end
  if T.RepaintAll then T:RepaintAll() end
  Q:Fire("THEME_CHANGED", T:Get(theme.key))
  refreshTracker()
  return true
end

-- Fenêtre d'options sur la section Automatisation (bouton de la touche de ciblage).
-- Liste des objets de quête à acheter (UI/AuctionPanel.lua) remplie avec Demo.AUCTION, prix réels de la
-- source de prix (Auctionator) quand il y en a une. Chez un encanteur, la liste d'achats à côté de l'HV
-- reprend les mêmes lignes.
function SCENE.auction()
  local AI, P = Q.AuctionItems, Q.UI.AuctionPanel
  if not (AI and AI.Rows and P and P.ShowList and Q.API and Q.API.GetItemInfo) then return false, WHY_API end
  local lists = {}
  for i, e in ipairs(Demo.AUCTION) do lists[i] = { e.item } end
  whenItems(token, "auction", lists, function()
    patch(AI, "Rows", function()
      return function(self)
        local out = {}
        for _, e in ipairs(Demo.AUCTION) do
          local have = math.min(self:Count(e.item), e.count - 1)
          local price, source = self:Price(e.item)
          out[#out + 1] = { item = e.item, name = self:Name(e.item), total = e.count, have = have,
            need = e.count - have, approx = false, quests = { e.quest }, chapter = e.chapter, state = "ok",
            skipped = false, price = price, source = source }
        end
        return out
      end
    end)
    auctionOpened = true
    P:ShowList()
    if AI.IsOpen and AI:IsOpen() and P.ShowShop then P:ShowShop() end
    Q:Fire("AUCTION_ITEMS_CHANGED")
  end, 0)
  return true
end

function SCENE.options()
  local O = Q.UI.Options
  if not (O and O.Open) then return false, WHY_API end
  O:Open("automation")
  optionsOpened = true
  return true
end

---------------------------------------------------------------------------
-- Ouverture, fermeture
---------------------------------------------------------------------------
-- Ferme toutes les scènes et rétablit l'état d'avant.
function Demo:Reset()
  token = token + 1
  Demo.showing = nil
  local cq, dg, up, rp = Q.UI.ClassQuestPopup, Q.UI.DungeonPopup, Q.UI.UpgradePopup, Q.UI.RouteChoicePopup
  if cq and cq.demo then cq.demo = nil; cq:Hide() end
  if dg and dg.demo then dg.demo = nil; dg:Hide() end
  if up then
    for i = #up.queue, 1, -1 do
      if up.queue[i].demo then table.remove(up.queue, i) end
    end
    if up.current and up.current.demo then up:Next() end
  end
  if rp and rp.cards and rp.cards.demo then
    rp.resume = nil
    rp:Close()
    rp.cards = nil
  end
  unpatch()
  extraLines = {}
  if auctionOpened then
    auctionOpened = nil
    local ap = Q.UI.AuctionPanel
    if ap and ap.list then ap.list:Hide() end
    Q:Fire("AUCTION_ITEMS_CHANGED")
  end
  if zoneActive then
    zoneActive = nil
    Q:Fire("ZONEMODE_CHANGED", Q.ZoneMode and Q.ZoneMode:Current())
  end
  if optionsOpened then
    optionsOpened = nil
    if Q.UI.Options and Q.UI.Options.Close then Q.UI.Options:Close() end
  end
  -- étape simulée : la route, le repère et le bouton d'objet reviennent à l'étape réelle
  if coverActive then
    coverActive = nil
    if Q.Progress and Q.Progress.Update then Q.SafeCall(Q.Progress.Update, Q.Progress) end
  end
  local qb = Q.UI.QuestItemButton
  if qb and qb.Refresh and qb.button then Q.SafeCall(qb.Refresh, qb) end
  if savedNav then
    local prev = savedNav.target
    savedNav = nil
    if prev then Q.Nav:SetTarget(prev.mapId, prev.x, prev.y, prev.title) else Q.Nav:Clear() end
  end
  refreshTracker()
end

local function runScene(name)
  Demo:Reset()
  local ok, res, why = pcall(SCENE[name])
  if ok and res then
    Demo.showing = true   -- scène affichée : Engine/Pace.lua ne mesure pas (route et étapes simulées)
    return true
  end
  Demo:Reset()
  say(L.UI_DEMO_MISSING, name, ok and L[why] or tostring(res))
  return false
end

local function printList()
  say("%s", L.UI_DEMO_HEADER)
  for _, name in ipairs(Demo.SCENES) do say("%s", "  /qf demo " .. name .. " - " .. L["UI_DEMO_SCENE_" .. name]) end
  say("%s", L.UI_DEMO_FOOTER)
end

function Demo:Run(name)
  if not SCENE[name] then
    say(L.UI_DEMO_UNKNOWN, name)
    printList()
    return false
  end
  if inCombat() then
    say(L.UI_DEMO_COMBAT)
    return false
  end
  seq = nil
  return runScene(name)
end

function Demo:Next()
  if not seq then
    say(L.UI_DEMO_NO_SEQUENCE)
    return false
  end
  if seq.i >= #self.SCENES then
    say(L.UI_DEMO_LAST)
    return false
  end
  if inCombat() then
    say(L.UI_DEMO_COMBAT)
    return false
  end
  seq.i = seq.i + 1
  local name = self.SCENES[seq.i]
  say(L.UI_DEMO_STEP, name, seq.i, #self.SCENES)
  return runScene(name)
end

function Demo:Off()
  seq = nil
  self:Reset()
  say(L.UI_DEMO_OFF)
end

-- /qf demo [scène | all | next | off]
function Demo:Handle(arg)
  arg = arg or ""
  if arg == "" then return printList() end
  if arg == "off" then return self:Off() end
  if arg == "next" then return self:Next() end
  if arg == "all" then
    if inCombat() then
      say(L.UI_DEMO_COMBAT)
      return false
    end
    seq = { i = 0 }
    return self:Next()
  end
  return self:Run(arg)
end

-- Début de combat : tout se range, sans message.
Q:RegisterEvent("PLAYER_REGEN_DISABLED", function()
  seq = nil
  Demo:Reset()
end)
