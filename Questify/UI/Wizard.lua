local addonName, Q = ...

-- Assistant de premier démarrage (spec § 4 : un seul fournisseur actif), en neuf pages :
--   1. bienvenue et addons (QuestieDB, ShortestPath Forever, WaypointUI, TomTom) : état de chacun
--      (chargé, désactivé, activé mais pas encore chargé, périmé, absent, QuestieDB trop ancien),
--      lien CurseForge à copier pour les absents et pour QuestieDB trop ancien (le jeu n'ouvre pas
--      de navigateur), bouton « Activer » pour les désactivés ;
--   2. route : automatique (avec les donjons, Engine/DungeonMode.lua) ou manuelle ; l'automatique est
--      grisée quand elle n'existe pas pour le personnage ;
--   3. calcul d'itinéraire par ShortestPath Forever (case active seulement s'il est chargé) ;
--   4. affichage : WaypointUI, TomTom ou repère du jeu (les absents sont désactivés) ;
--   5. automatisations (accepter/rendre, choix de la récompense, vente de la camelote) ;
--   6. suivi des quêtes : masquer le suivi d'objectifs du jeu (tracker.hideBlizzard,
--      UI/BlizzardTracker.lua) ;
--   7. objectifs du suivi : mise en page et détail (tracker.objLayout, tracker.objDetail), avec un
--      aperçu du suivi redessiné à chaque clic dans le thème courant (UI/ObjectiveRows.lua) ;
--   8. thème (UI/Themes.lua) : « suivre la race » et une carte par thème ; la fenêtre prend le
--      thème choisi tout de suite ;
--   9. récapitulatif et « Terminer ».
-- Habillage du thème : bandeau illustré avec blason et titre, coins et liseré, boutons plats.
-- Chaque page a « Précédent », « Ignorer » (remet les choix de la page à leur valeur actuelle et
-- passe à la suivante) et « Suivant » ; la dernière a « Terminer ». « Recharger l'interface » est
-- visible sur la page des addons, et sur toutes les pages après « Activer ».
-- « Terminer » enregistre tout par Q.Settings:Set, pose Q.char.wizardDone et efface wizardPage.
-- Reprise : la page courante est gardée dans Q.char.wizardPage, les choix faits mais pas encore
-- enregistrés dans Q.char.wizardDraft. Tant que l'assistant n'est pas terminé, il se rouvre sur
-- cette page 3 s après « LOGIN » (donc après /reload ou une reconnexion), jamais en combat, au
-- plus une fois par session. Fermer par la croix ne termine pas : /qf wizard reprend à la même page.
-- Assistant terminé avant la page des objectifs : il se rouvre une seule fois sur cette page
-- (Q.char.wizardObjectivesSeen), avec un message dans la discussion.
Q.UI = Q.UI or {}
local Wizard = { page = 1, pages = {}, radios = {}, checks = {}, addonRows = {}, recap = {}, enabledNames = {} }
Q.UI.Wizard = Wizard

local L = Q.L

local FRAME_NAME = "QuestifyWizard"
local WIDTH, HEIGHT = 520, 560
local INNER = WIDTH - 48
local AUTO_DELAY = 3
local ROW_H, ROW_LINK_H = 34, 60   -- ligne d'addon sans / avec le lien à copier

local PAGE_ADDONS, PAGE_ROUTE, PAGE_ROUTING, PAGE_DISPLAY, PAGE_AUTO, PAGE_TRACKER, PAGE_OBJECTIVES, PAGE_THEME,
  PAGE_RECAP = 1, 2, 3, 4, 5, 6, 7, 8, 9
local HEADER_H = 40
local CARD_W, CARD_H, CARD_GAP = 152, 40, 8
local NUM_PAGES = PAGE_RECAP
Wizard.NUM_PAGES = NUM_PAGES
Wizard.PAGE_THEME = PAGE_THEME

-- Addons de la page 1. folders : noms de dossier possibles, le premier est celui du TOC publié
-- (QuestieDB.toc, ShortestPathForever.toc, WaypointUI.toc, TomTom.toc) ; les suivants couvrent
-- une installation renommée à la main.
local ADDONS = {
  { id = "questiedb", folders = { "QuestieDB" }, required = true,
    url = "https://www.curseforge.com/wow/addons/questiedb",
    name = "UI_WIZ_ADDON_QUESTIEDB", desc = "UI_WIZ_ADDON_QUESTIEDB_DESC" },
  { id = "shortestpath", folders = { "ShortestPathForever", "ShortestPath" },
    url = "https://www.curseforge.com/wow/addons/shortest-path-forever",
    name = "UI_NAV_SHORTESTPATH", desc = "UI_NAV_SHORTESTPATH_DESC" },
  { id = "waypointui", folders = { "WaypointUI", "Waypoint-UI" },
    url = "https://www.curseforge.com/wow/addons/waypointui",
    name = "UI_NAV_WAYPOINTUI", desc = "UI_NAV_WAYPOINTUI_DESC" },
  { id = "tomtom", folders = { "TomTom" },
    url = "https://www.curseforge.com/wow/addons/tomtom",
    name = "UI_NAV_TOMTOM", desc = "UI_NAV_TOMTOM_DESC" },
}
Wizard.ADDONS = ADDONS

local DISPLAYS = { "arrow", "waypointui", "tomtom", "native" }
-- Page 2 : route automatique (mode « Donjons ») ou manuelle (chapitres habituels).
local ROUTES = { { "auto", "DGMODE_WIZ_AUTO", "DGMODE_WIZ_AUTO_DESC" }, { "manual", "DGMODE_WIZ_MANUAL", "DGMODE_WIZ_MANUAL_DESC" } }
local PROVIDER_TEXT = {
  arrow = { "UI_NAV_ARROW", "UI_NAV_ARROW_DESC" },
  shortestpath = { "UI_NAV_SHORTESTPATH", "UI_NAV_SHORTESTPATH_DESC" },
  waypointui = { "UI_NAV_WAYPOINTUI", "UI_NAV_WAYPOINTUI_DESC" },
  tomtom = { "UI_NAV_TOMTOM", "UI_NAV_TOMTOM_DESC" },
  native = { "UI_NAV_NATIVE", "UI_NAV_NATIVE_DESC" },
}
local AUTOMATIONS = {
  { "autoQuest", "UI_OPT_AUTOQUEST" },
  { "autoReward", "UI_OPT_AUTOREWARD" },
  { "sellJunk", "UI_OPT_SELLJUNK" },
}
-- Choix de chaque page : « Ignorer » les remet à leur valeur de départ.
local PAGE_KEYS = {
  [PAGE_ROUTE] = { "route" },
  [PAGE_ROUTING] = { "routing" },
  [PAGE_DISPLAY] = { "display" },
  [PAGE_AUTO] = { "autoQuest", "autoReward", "sellJunk", "rewardRole" },
  [PAGE_TRACKER] = { "hideBlizzard" },
  [PAGE_OBJECTIVES] = { "objLayout", "objDetail" },
  [PAGE_THEME] = { "theme", "followRace" },
}
Wizard.PAGE_OBJECTIVES = PAGE_OBJECTIVES

-- Page 6 : choix (valeur, libellé, description) et aperçu.
local OBJ_CHOICES = {
  objLayout = { { "list", "OBJ_LAYOUT_LIST", "UI_WIZ_OBJ_LIST_DESC" }, { "bars", "OBJ_LAYOUT_BARS", "UI_WIZ_OBJ_BARS_DESC" },
    { "quest", "OBJ_LAYOUT_QUEST", "UI_WIZ_OBJ_QUEST_DESC" } },
  objDetail = { { "count", "OBJ_DETAIL_COUNT", "UI_WIZ_OBJ_COUNT_DESC" }, { "mobs", "OBJ_DETAIL_MOBS", "UI_WIZ_OBJ_MOBS_DESC" },
    { "distance", "OBJ_DETAIL_DISTANCE", "UI_WIZ_OBJ_DIST_DESC" } },
}
local OBJ_LEFT_W = 200          -- colonne des choix
local PREVIEW_W = 260           -- aperçu : largeur par défaut du suivi
local PREVIEW_PAD, PREVIEW_ICON_COL = 8, 38   -- comme UI/Tracker.lua (PAD, ICON_COL)

local READY = "Interface\\RaidFrame\\ReadyCheck-Ready"
local NOT_READY = "Interface\\RaidFrame\\ReadyCheck-NotReady"
local WAITING = "Interface\\RaidFrame\\ReadyCheck-Waiting"

local STATUS = {
  loaded = { "UI_WIZ_LOADED", "|cff40ff40", READY },
  missing = { "UI_WIZ_ABSENT", "|cff999999", NOT_READY },
  disabled = { "UI_WIZ_DISABLED", "|cffff9933", WAITING },
  pending = { "UI_WIZ_PENDING", "|cffffd100", WAITING },
  outdated = { "UI_WIZ_OUTDATED", "|cffffd100", WAITING },
  old = { "UI_WIZ_QDB_OLD", "|cffff4040", WAITING },
}
-- États qui affichent le lien CurseForge : addon absent, ou QuestieDB trop ancien (mise à jour).
local SHOW_LINK = { missing = true, old = true }

local function safe(fn)
  return function(...) return Q.SafeCall(fn, ...) end
end

local function playSound(kit)
  if PlaySound and SOUNDKIT and SOUNDKIT[kit] then pcall(PlaySound, SOUNDKIT[kit]) end
end

---------------------------------------------------------------------------
-- Détection
---------------------------------------------------------------------------
-- Fournisseurs : Q.Nav:Detect() (flux C) ; à défaut, les mêmes règles sur les globales.
-- Le repère du jeu (native) est toujours disponible ; questiedb = données lisibles,
-- questiedbOld = QuestieDB chargé mais trop ancien (Q.QDB:Status() == "old").
function Wizard:Detect()
  local d
  if Q.Nav and Q.Nav.Detect then
    local ok, res = pcall(Q.Nav.Detect, Q.Nav)
    if ok and type(res) == "table" then d = res end
  end
  d = d or {
    shortestpath = type(ShortestPathForever) == "table" and ShortestPathForever.API ~= nil,
    waypointui = type(WaypointUIAPI) == "table" and WaypointUIAPI.Navigation ~= nil,
    tomtom = type(TomTom) == "table" and TomTom.AddWaypoint ~= nil,
  }
  d.native = true
  d.arrow = true   -- flèche Questify : toujours disponible
  local status
  if Q.QDB and Q.QDB.Status then
    local ok, res = pcall(Q.QDB.Status, Q.QDB)
    if ok then status = res end
  end
  d.questiedb = status == "ok"
  d.questiedbOld = status == "old"
  return d
end

-- État d'un addon par C_AddOns. Chaque appel est protégé : une fonction absente ou qui refuse
-- un nom inconnu ne casse pas l'assistant.
local function addonCall(fn, ...)
  local f = C_AddOns and C_AddOns[fn]
  if type(f) ~= "function" then return false end
  return pcall(f, ...)
end

-- Installé ? DoesAddOnExist, sinon GetAddOnInfo (raison « MISSING » pour un dossier absent).
-- nil : impossible à savoir.
local function isInstalled(folder)
  local ok, exists = addonCall("DoesAddOnExist", folder)
  if ok and exists ~= nil then return exists and true or false end
  local ok2, name, title, _, _, reason = addonCall("GetAddOnInfo", folder)
  if ok2 then return (name ~= nil or title ~= nil) and reason ~= "MISSING" end
  return nil
end

local function isLoaded(folder)
  local ok, loaded = addonCall("IsAddOnLoaded", folder)
  return ok and loaded and true or false
end

-- Activé pour ce personnage ? (0 = désactivé, 1 ou 2 = activé ; booléen sur d'anciens clients)
-- nil : impossible à savoir.
local function playerName()
  local ok, name = pcall(function() return UnitName and UnitName("player") end)
  if ok and type(name) == "string" and name ~= "" then return name end
  return nil
end

local function isEnabled(folder)
  local ok, state = addonCall("GetAddOnEnableState", folder, playerName())
  if not ok then return nil end
  if type(state) == "number" then return state > 0 end
  if type(state) == "boolean" then return state end
  return nil
end

local function loadReason(folder)
  local ok, _, _, _, _, reason = addonCall("GetAddOnInfo", folder)
  if ok then return reason end
  return nil
end

-- AddonState(entry) -> "loaded" | "old" | "pending" | "outdated" | "disabled" | "missing", dossier
-- ("old" : QuestieDB chargé mais trop ancien pour Questify)
function Wizard:AddonState(entry)
  local tooOld = entry.id == "questiedb" and self.detected and self.detected.questiedbOld
  for _, folder in ipairs(entry.folders) do
    if isLoaded(folder) then return tooOld and "old" or "loaded", folder end
  end
  if tooOld then return "old", entry.folders[1] end
  if self.detected and self.detected[entry.id] then return "loaded", entry.folders[1] end
  for _, folder in ipairs(entry.folders) do
    if isInstalled(folder) then
      if isEnabled(folder) == false then return "disabled", folder end
      if loadReason(folder) == "INTERFACE_VERSION" then return "outdated", folder end
      return "pending", folder
    end
  end
  return "missing", entry.folders[1]
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function newFrame()
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "ButtonFrameTemplate")
  if ok and f then return f end
  return CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
end

local function pageTitle(page, key)
  local t = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  t:SetPoint("TOPLEFT", page, "TOPLEFT", 0, 0)
  t:SetWidth(INNER)
  t:SetJustifyH("LEFT")
  t:SetText(L[key])
  return t
end

local function paragraph(page, text, anchor, gap, font)
  local p = page:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  p:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(gap or 8))
  p:SetWidth(INNER)
  p:SetJustifyH("LEFT")
  p:SetWordWrap(true)
  p:SetText(text)
  return p
end

local widgetSeq = 0
local function newButton(kind, parent, template)
  widgetSeq = widgetSeq + 1
  return CreateFrame(kind, FRAME_NAME .. "Widget" .. widgetSeq, parent, template)
end

local function labelFor(widget, text, font)
  local fs = widget:GetParent():CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  fs:SetPoint("LEFT", widget, "RIGHT", 4, 1)
  fs:SetWidth(INNER - 40)
  fs:SetJustifyH("LEFT")
  fs:SetText(text)
  return fs
end

-- Champ en lecture seule qui contient un lien : sélectionné à la prise du focus pour Ctrl+C,
-- toute frappe remet le lien.
local function linkBox(parent, url)
  local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  box:SetSize(INNER - 34, 20)
  box:SetAutoFocus(false)
  box.url = url
  box:SetText(url)
  box:SetCursorPosition(0)
  box:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
  box:SetScript("OnMouseUp", function(self) self:HighlightText() end)
  box:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)
  box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
  box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
  box:SetScript("OnTextChanged", function(self, userInput)
    if userInput then
      self:SetText(self.url)
      self:HighlightText()
    end
  end)
  return box
end

function Wizard:BuildAddonsPage(page)
  local title = pageTitle(page, "UI_WIZ_WELCOME_TITLE")
  local intro = paragraph(page, L.UI_WIZ_WELCOME_TEXT, title, 8)
  local heading = paragraph(page, L.UI_WIZ_ADDONS_HEADING, intro, 12, "GameFontNormal")
  local anchor = heading
  for _, entry in ipairs(ADDONS) do
    local row = CreateFrame("Frame", nil, page)
    row:SetSize(INNER, ROW_H)
    row:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)
    row.entry = entry
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(16, 16)
    row.icon:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 6, 0)
    local name = L[entry.name]
    if entry.required then name = name .. " |cffff8040(" .. L.UI_WIZ_REQUIRED .. ")|r" end
    row.name:SetText(name)
    row.status = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.status:SetPoint("LEFT", row.name, "RIGHT", 8, 0)
    row.desc = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.desc:SetPoint("TOPLEFT", row, "TOPLEFT", 22, -19)
    row.desc:SetWidth(INNER - 22)
    row.desc:SetJustifyH("LEFT")
    row.desc:SetText(L[entry.desc])
    row.enable = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.enable:SetSize(90, 20)
    row.enable:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, 2)
    row.enable:SetText(L.UI_WIZ_ENABLE)
    row.enable:SetScript("OnClick", safe(function() Wizard:EnableAddon(entry.id) end))
    row.enable:Hide()
    row.link = linkBox(row, entry.url)
    row.link:SetPoint("TOPLEFT", row, "TOPLEFT", 28, -34)
    row.link:Hide()
    self.addonRows[entry.id] = row
    anchor = row
  end
  self.linkHint = paragraph(page, L.UI_WIZ_LINK_HINT, anchor, 6, "GameFontNormalSmall")
  self.restartNote = paragraph(page, L.UI_WIZ_RESTART_NOTE, self.linkHint, 6, "GameFontDisableSmall")
  self.reloadText = paragraph(page, "", self.restartNote, 6, "GameFontGreenSmall")
  self.reloadText:Hide()
end

-- Vrai si la route automatique existe pour le personnage.
local function autoAvailable()
  return Q.DungeonMode ~= nil and Q.DungeonMode:Available() == true
end

function Wizard:BuildRoutePage(page)
  local title = pageTitle(page, "DGMODE_WIZ_TITLE")
  local anchor = paragraph(page, L.DGMODE_WIZ_TEXT, title, 10)
  local gap = 14
  self.routeRadios = {}
  for _, def in ipairs(ROUTES) do
    local r = newButton("CheckButton", page, "UIRadioButtonTemplate")
    r:SetSize(16, 16)
    r:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
    r.id = def[1]
    r.label = labelFor(r, L[def[2]])
    r.desc = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.desc:SetPoint("TOPLEFT", r, "BOTTOMLEFT", 20, -2)
    r.desc:SetWidth(INNER - 20)
    r.desc:SetJustifyH("LEFT")
    r.desc:SetText(L[def[3]])
    r:SetScript("OnClick", safe(function(self)
      if not self:IsEnabled() then return end
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      Wizard:SelectRoute(self.id)
      Wizard:SetChoice("route", Wizard.choice.route)
    end))
    self.routeRadios[def[1]] = r
    anchor = r.desc
    gap = 12
  end
  local missing = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  missing:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -20, -18)
  missing:SetWidth(INNER)
  missing:SetJustifyH("LEFT")
  missing:SetText(L.DGMODE_WIZ_AUTO_MISSING)
  self.routeMissing = missing
end

function Wizard:BuildRoutingPage(page)
  local title = pageTitle(page, "UI_WIZ_P2_TITLE")
  local text = paragraph(page, L.UI_WIZ_P2_TEXT, title, 10)
  local cb = newButton("CheckButton", page, "UICheckButtonTemplate")
  cb:SetSize(26, 26)
  cb:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -4, -14)
  cb.label = labelFor(cb, L.UI_WIZ_ROUTING)
  cb:SetScript("OnClick", safe(function(self)
    if not self:IsEnabled() then return end
    Wizard:SetChoice("routing", self:GetChecked() and true or false)
  end))
  self.checks.routing = cb
  local missing = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  missing:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 30, -2)
  missing:SetWidth(INNER - 30)
  missing:SetJustifyH("LEFT")
  missing:SetText(L.UI_WIZ_ROUTING_MISSING)
  self.routingMissing = missing
end

function Wizard:BuildDisplayPage(page)
  local title = pageTitle(page, "UI_WIZ_DISPLAY_TITLE")
  local anchor = paragraph(page, L.UI_WIZ_P3_TEXT, title, 10)
  local gap = 14
  for _, id in ipairs(DISPLAYS) do
    local r = newButton("CheckButton", page, "UIRadioButtonTemplate")
    r:SetSize(16, 16)
    r:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
    r.id = id
    r.label = labelFor(r, L[PROVIDER_TEXT[id][1]])
    r.desc = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    r.desc:SetPoint("TOPLEFT", r, "BOTTOMLEFT", 20, -2)
    r.desc:SetWidth(INNER - 20)
    r.desc:SetJustifyH("LEFT")
    r.desc:SetText(L[PROVIDER_TEXT[id][2]])
    r:SetScript("OnClick", safe(function(self)
      if not self:IsEnabled() then return end
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      Wizard:SelectDisplay(self.id)
      Wizard:SetChoice("display", Wizard.choice.display)
    end))
    self.radios[id] = r
    anchor = r.desc
    gap = 12
  end
end

function Wizard:BuildAutoPage(page)
  local title = pageTitle(page, "UI_WIZ_AUTO_TITLE")
  local anchor = paragraph(page, L.UI_WIZ_P4_TEXT, title, 10)
  local x = -4   -- la première case s'aligne sur le texte, les suivantes sur la case précédente
  for _, def in ipairs(AUTOMATIONS) do
    local cb = newButton("CheckButton", page, "UICheckButtonTemplate")
    cb:SetSize(26, 26)
    cb:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", x, -10)
    x = 0
    cb.label = labelFor(cb, L[def[2]])
    cb.path = def[1]
    cb:SetScript("OnClick", safe(function(self)
      Wizard:SetChoice(self.path, self:GetChecked() and true or false)
    end))
    self.checks[def[1]] = cb
    anchor = cb
  end
  -- profil de récompense, sous les cases ; masqué pour une classe sans vrai choix
  local b = newButton("Button", page, "UIPanelButtonTemplate")
  b:SetSize(260, 22)
  local reward = self.checks.autoReward
  b:SetPoint("TOPLEFT", reward, "BOTTOMLEFT", 30, -4)
  -- la case suivante passe sous le bouton
  local after = self.checks.sellJunk
  if after then
    after:ClearAllPoints()
    after:SetPoint("TOPLEFT", b, "BOTTOMLEFT", -30, -6)
  end
  b:SetScript("OnClick", safe(function()
    local Rw = Q.Rewards
    if not (Rw and Wizard.choice) then return end
    Wizard:SetChoice("rewardRole", Rw:NextRole(Wizard.choice.rewardRole))
    Wizard:Refresh()
  end))
  self.rewardRoleButton = b
end

-- Page « Suivi des quêtes » : une case, réglage tracker.hideBlizzard (UI/BlizzardTracker.lua).
function Wizard:BuildTrackerPage(page)
  local title = pageTitle(page, "UI_WIZ_TRACKER_TITLE")
  local text = paragraph(page, L.UI_WIZ_TRACKER_TEXT, title, 10)
  local cb = newButton("CheckButton", page, "UICheckButtonTemplate")
  cb:SetSize(26, 26)
  cb:SetPoint("TOPLEFT", text, "BOTTOMLEFT", -4, -14)
  cb.label = labelFor(cb, L.UI_WIZ_HIDE_BLIZZARD)
  cb:SetScript("OnClick", safe(function(self)
    Wizard:SetChoice("hideBlizzard", self:GetChecked() and true or false)
  end))
  self.checks.hideBlizzard = cb
  local note = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  note:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 30, -2)
  note:SetWidth(INNER - 30)
  note:SetJustifyH("LEFT")
  note:SetFormattedText(L.UI_WIZ_HIDE_BLIZZARD_NOTE, L.OPT_SEC_TRACKER, L.OPT_CAT_TRACKER_CONTENT)
  self.hideBlizzardNote = note
end

-- Page « Objectifs du suivi » : deux groupes de choix à gauche, aperçu du suivi à droite.
function Wizard:BuildObjectivesPage(page)
  local title = pageTitle(page, "UI_WIZ_OBJ_TITLE")
  local text = paragraph(page, L.UI_WIZ_OBJ_TEXT, title, 8)
  self.objRadios = {}
  local anchor, gap = text, 12
  for _, key in ipairs({ "objLayout", "objDetail" }) do
    local head = page:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    head:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
    head:SetWidth(OBJ_LEFT_W)
    head:SetJustifyH("LEFT")
    head:SetText(L[key == "objLayout" and "UI_WIZ_OBJ_LAYOUT" or "UI_WIZ_OBJ_DETAIL"])
    anchor, gap = head, 6
    self.objRadios[key] = {}
    for _, def in ipairs(OBJ_CHOICES[key]) do
      local r = newButton("CheckButton", page, "UIRadioButtonTemplate")
      r:SetSize(16, 16)
      r:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
      r.id, r.key = def[1], key
      r.label = labelFor(r, L[def[2]])
      r.label:SetWidth(OBJ_LEFT_W - 22)
      r.desc = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
      r.desc:SetPoint("TOPLEFT", r, "BOTTOMLEFT", 20, 0)
      r.desc:SetWidth(OBJ_LEFT_W - 20)
      r.desc:SetJustifyH("LEFT")
      r.desc:SetText(L[def[3]])
      r:SetScript("OnClick", safe(function(self)
        playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
        Wizard:SetChoice(self.key, self.id)
        Wizard:SelectObjectives()
        Wizard:RenderPreview()
      end))
      self.objRadios[key][def[1]] = r
      anchor, gap = r.desc, 5
    end
    gap = 12
  end
  local label = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  label:SetPoint("TOPLEFT", text, "BOTTOMLEFT", OBJ_LEFT_W + 12, -12)
  label:SetText(L.UI_WIZ_OBJ_PREVIEW)
  -- aperçu : un cadre au thème du suivi (fond, bordure, couleurs), contenu rendu comme le suivi
  local f = CreateFrame("Frame", nil, page, "BackdropTemplate")
  f:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -3)
  f:SetSize(PREVIEW_W, 80)
  local icon = f:CreateTexture(nil, "ARTWORK")
  icon:SetSize(22, 22)
  icon:SetPoint("TOP", f, "TOPLEFT", PREVIEW_PAD + PREVIEW_ICON_COL / 2, -PREVIEW_PAD)
  local dist = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  dist:SetPoint("TOP", icon, "BOTTOM", 0, -2)
  self.preview = { frame = f, icon = icon, dist = dist, host = { parent = f } }
end

-- Coche les choix de la page 7 (objectifs) d'après self.choice.
function Wizard:SelectObjectives()
  for key, radios in pairs(self.objRadios or {}) do
    for id, r in pairs(radios) do r:SetChecked(self.choice[key] == id) end
  end
end

-- Exemple de l'aperçu : une étape « Faire » à trois objectifs (dont un fini, replié) et deux monstres.
local function previewSegments(layout, detail)
  local O = Q.Objectives
  local rows = {
    { index = 1, kind = "loot", label = L.UI_WIZ_OBJ_SAMPLE_1, have = 3, need = 8, lead = true,
      mob = { name = L.UI_WIZ_OBJ_SAMPLE_MOB_1, minLevel = 5, maxLevel = 6 }, dist = 64 },
    { index = 2, kind = "kill", label = L.UI_WIZ_OBJ_SAMPLE_2, have = 2, need = 6,
      mob = { name = L.UI_WIZ_OBJ_SAMPLE_MOB_2, minLevel = 1, maxLevel = 2 }, dist = 110 },
    { index = 3, kind = "use", label = L.UI_WIZ_OBJ_SAMPLE_3, have = 0, need = 1, dist = 150,
      icon = "Interface\\Icons\\INV_Misc_Orb_03" },
  }
  local segs = {}
  if layout == "quest" then
    segs[#segs + 1] = { quest = L.UI_WIZ_OBJ_SAMPLE_QUEST, sub = "· 1/4" }
  else
    segs[#segs + 1] = { text = string.format(L.STEP_COMPLETE, L.UI_WIZ_OBJ_SAMPLE_QUEST) }
  end
  for _, r in ipairs(rows) do
    r.icon = r.icon or (O and O.ICONS[r.kind])
    r.text = r.label .. ": " .. r.have .. "/" .. r.need
    local dist = detail == "distance" and Q.Util.FormatDistance(r.dist) or nil
    segs[#segs + 1] = { obj = r, bars = layout == "bars", dist = dist }
    if detail ~= "count" and r.mob then segs[#segs + 1] = { mob = r.mob } end
  end
  segs[#segs + 1] = { fold = string.format(L.OBJ_FOLD_ONE, L.UI_WIZ_OBJ_SAMPLE_DONE) }
  return segs
end
Wizard.PreviewSegments = previewSegments

-- Redessine l'aperçu avec les choix courants et le thème du suivi.
function Wizard:RenderPreview()
  local p = self.preview
  if not (p and self.choice) then return end
  local T = Q.Themes
  local theme
  if T then
    local key = T.CurrentKey and T:CurrentKey() or Q.Settings:Get("tracker.theme")
    theme = T:Apply(p.frame, key, Q.Settings:Get("tracker.opacity"))
  end
  p.host.theme = theme
  p.icon:SetTexture(Q.Format:ActionIcon("complete"))
  p.dist:SetText(Q.Util.FormatDistance(64))
  if T then T:StyleText(p.dist, "distance", theme) end
  local segs = previewSegments(self.choice.objLayout, self.choice.objDetail)
  local h = Q.UI.ObjectiveRows:Render(p.host, segs, PREVIEW_PAD + PREVIEW_ICON_COL + 2,
    PREVIEW_W - 2 * PREVIEW_PAD - PREVIEW_ICON_COL - 2, PREVIEW_PAD)
  p.frame:SetHeight(math.max(h, 36) + 2 * PREVIEW_PAD)
  p.segs = segs
end

-- Page Thème : texte, « suivre la race », cartes des thèmes (aplat de couleur, nom, trait d'accent).
local GROUPS = { neutral = "UI_THEME_GROUP_NEUTRAL", alliance = "UI_THEME_GROUP_ALLIANCE", horde = "UI_THEME_GROUP_HORDE" }
function Wizard:BuildThemePage(page)
  local T = Q.Themes
  local title = pageTitle(page, "UI_WIZ_THEME_TITLE")
  local intro = paragraph(page, "", title, 10)
  self.themeIntro = intro
  local cb = newButton("CheckButton", page, "UICheckButtonTemplate")
  cb:SetSize(26, 26)
  cb:SetPoint("TOPLEFT", intro, "BOTTOMLEFT", -4, -6)
  cb.label = labelFor(cb, L.OPT_THEME_FOLLOW_RACE)
  cb:SetScript("OnClick", safe(function(self)
    Wizard:SetChoice("followRace", self:GetChecked() and true or false)
    if self:GetChecked() and T then Wizard:SetChoice("theme", T:RaceKey() or Wizard.choice.theme) end
    Wizard:RefreshTheme()
  end))
  self.checks.followRace = cb
  self.themeCards = {}
  if not T then return end
  local y, col, last = 0, 0, nil
  local top = CreateFrame("Frame", nil, page)
  top:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 4, -4)
  top:SetSize(INNER, 1)
  for _, th in ipairs(T:List()) do
    if th.group ~= last then
      if col > 0 then y = y + CARD_H + CARD_GAP; col = 0 end
      local g = page:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
      g:SetPoint("TOPLEFT", top, "TOPLEFT", 0, -y)
      g:SetText(L[GROUPS[th.group] or GROUPS.neutral])
      self.themeGroupLabels = self.themeGroupLabels or {}
      table.insert(self.themeGroupLabels, g)
      y, last = y + 14, th.group
    end
    local theme = T:Get(th.key)
    local card = CreateFrame("Button", nil, page, "BackdropTemplate")
    card:SetSize(CARD_W, CARD_H)
    card:SetPoint("TOPLEFT", top, "TOPLEFT", col * (CARD_W + CARD_GAP), -y)
    local band = CreateFrame("Frame", nil, card)
    band:SetPoint("TOPLEFT", card, "TOPLEFT", 1, -1)
    band:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -1, 4)
    if band.SetClipsChildren then band:SetClipsChildren(true) end
    local sky = band:CreateTexture(nil, "BACKGROUND", nil, -6)
    sky:SetAllPoints(band)
    local k = theme.colors
    sky:SetColorTexture(k.panel[1], k.panel[2], k.panel[3], 1)
    local name = band:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    name:SetPoint("LEFT", band, "LEFT", 8, 0)
    name:SetPoint("RIGHT", band, "RIGHT", -18, 0)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    name:SetText(th.label)
    name:SetTextColor(k.text[1], k.text[2], k.text[3])
    local accent = card:CreateTexture(nil, "ARTWORK")
    accent:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 1, 1)
    accent:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -1, 1)
    accent:SetHeight(3)
    accent:SetColorTexture(k.accent[1], k.accent[2], k.accent[3], 1)
    local check = band:CreateTexture(nil, "OVERLAY")
    check:SetSize(12, 12)
    check:SetPoint("TOPRIGHT", band, "TOPRIGHT", -3, -3)
    check:SetTexture(T.GLYPH_CHECK)
    check:SetVertexColor(k.accent[1], k.accent[2], k.accent[3], 1)
    local hl = card:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(card)
    hl:SetColorTexture(1, 1, 1, 0.06)
    card:SetBackdrop(T.HAIRLINE)
    card.key, card.check, card.theme = th.key, check, theme
    card:SetScript("OnClick", safe(function(self)
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      Wizard:SetChoice("theme", self.key)
      if self.key ~= T:RaceKey() then Wizard:SetChoice("followRace", false) end
      Wizard:RefreshTheme()
    end))
    self.themeCards[#self.themeCards + 1] = card
    col = col + 1
    if col >= 3 then col = 0; y = y + CARD_H + CARD_GAP end
  end
  if col > 0 then y = y + CARD_H + CARD_GAP end
  local later = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  later:SetPoint("TOPLEFT", top, "TOPLEFT", 0, -y - 2)
  later:SetWidth(INNER)
  later:SetJustifyH("LEFT")
  later:SetText(L.UI_WIZ_THEME_LATER)
  self.themeLater = later
end

-- Cartes, case et fenêtre aux couleurs du thème choisi (aperçu : rien n'est enregistré avant
-- « Terminer »).
function Wizard:RefreshTheme()
  local T, c = Q.Themes, self.choice
  if not (T and c and self.themeCards) then return end
  local key = c.theme or T:CurrentKey()
  local race = T:RaceKey()
  local raceLabel = race and L[T:Get(race).label] or L.UI_THEME_NEUTRAL
  self.themeIntro:SetFormattedText(L.UI_WIZ_THEME_INTRO, raceLabel, raceLabel)
  self.checks.followRace:SetChecked(c.followRace and true or false)
  for _, card in ipairs(self.themeCards) do
    local k = card.theme.colors
    local on = card.key == key
    local edge = on and k.accent or k.edge
    card:SetBackdropBorderColor(edge[1], edge[2], edge[3], 1)
    if on then card.check:Show() else card.check:Hide() end
  end
  self:ApplyTheme(key)
end

-- Fenêtre de l'assistant au thème key (le choisi sur la page Thème, sinon celui en vigueur).
function Wizard:ApplyTheme(key)
  local T, f = Q.Themes, self.frame
  if not (T and f) then return end
  key = key or (self.choice and self.choice.theme) or T:CurrentKey()
  local theme = T:Apply(f, key, 1)
  T:StyleText(self.titleText, "title", theme)
  T:SkinClose(f, theme)
  T:SkinTree(f, theme)
  for _, b in ipairs({ self.prevButton, self.skipButton }) do if b then T:SkinButton(b, "secondary", theme) end end
  for _, b in ipairs({ self.nextButton, self.finishButton }) do if b then T:SkinButton(b, "primary", theme) end end
  if self.stepText then T:StyleText(self.stepText, "muted", theme) end
  for _, g in ipairs(self.themeGroupLabels or {}) do T:StyleText(g, "muted", theme) end
end

function Wizard:BuildRecapPage(page)
  local title = pageTitle(page, "UI_WIZ_RECAP_TITLE")
  local anchor = paragraph(page, L.UI_WIZ_RECAP_TEXT, title, 10)
  local gap = 14
  for _, key in ipairs({ "route", "routing", "display", "autoQuest", "autoReward", "sellJunk", "hideBlizzard",
                          "objectives", "theme" }) do
    local line = paragraph(page, "", anchor, gap)
    self.recap[key] = line
    anchor = line
    gap = 6
  end
  paragraph(page, L.UI_WIZ_RECAP_AFTER, anchor, 16, "GameFontDisableSmall")
end

function Wizard:Create()
  if self.frame then return self.frame end
  local f = newFrame()
  self.frame = f
  f:SetSize(WIDTH, HEIGHT)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
  f:SetFrameStrata("DIALOG")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  if f.SetTitle then f:SetTitle(L.UI_WIZ_TITLE) end
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end
  -- habillage du thème : gabarit caché, bandeau illustré avec blason et titre, coins et liseré
  local titleText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  titleText:SetText(L.UI_WIZ_TITLE)
  self.titleText = titleText
  local T = Q.Themes
  if T then
    T:StripTemplate(f)
    T:Apply(f, T:CurrentKey(), 1)
    T:Decorate(f, { header = HEADER_H, title = titleText })
    T:SkinClose(f)
  end

  local content = CreateFrame("Frame", nil, f)
  content:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -HEADER_H - 14)
  content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 58)
  for i = 1, NUM_PAGES do
    local page = CreateFrame("Frame", nil, content)
    page:SetAllPoints(content)
    page:Hide()
    self.pages[i] = page
  end
  self:BuildAddonsPage(self.pages[PAGE_ADDONS])
  self:BuildRoutePage(self.pages[PAGE_ROUTE])
  self:BuildRoutingPage(self.pages[PAGE_ROUTING])
  self:BuildDisplayPage(self.pages[PAGE_DISPLAY])
  self:BuildAutoPage(self.pages[PAGE_AUTO])
  self:BuildTrackerPage(self.pages[PAGE_TRACKER])
  self:BuildObjectivesPage(self.pages[PAGE_OBJECTIVES])
  self:BuildThemePage(self.pages[PAGE_THEME])
  self:BuildRecapPage(self.pages[PAGE_RECAP])

  local step = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  step:SetPoint("RIGHT", f, "TOPRIGHT", -42, -HEADER_H / 2)
  if f.qvDecor and f.qvDecor.header then step:SetParent(f.qvDecor.header) end
  self.stepText = step

  local function bottomButton(label, width, onClick)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(width, 22)
    b:SetText(label)
    b:SetScript("OnClick", safe(onClick))
    return b
  end
  self.prevButton = bottomButton(L.UI_WIZ_PREV, 110, function() Wizard:Prev() end)
  self.prevButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 4)
  self.nextButton = bottomButton(L.UI_WIZ_NEXT, 110, function() Wizard:Next() end)
  self.nextButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 4)
  self.finishButton = bottomButton(L.UI_WIZ_FINISH, 110, function() Wizard:Finish() end)
  self.finishButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 4)
  self.skipButton = bottomButton(L.UI_WIZ_SKIP, 110, function() Wizard:Skip() end)
  self.skipButton:SetPoint("RIGHT", self.nextButton, "LEFT", -6, 0)
  self.reloadButton = bottomButton(L.UI_WIZ_RELOAD, 190, function() Wizard:Reload() end)
  self.reloadButton:SetPoint("BOTTOM", f, "BOTTOM", 0, 30)
  self:ApplyTheme()

  f:Hide()
  -- Branché après le Hide() initial. Fermer sans terminer garde la page (/qf wizard y reprend)
  -- et ne vaut pas refus : l'assistant se rouvrira à la prochaine session, pas dans celle-ci.
  -- Fermé ou terminé, il laisse place au choix des métiers (une fois par session, voir
  -- UI/ProfessionPicker.lua). Un parent caché (Alt+Z) ne compte pas.
  f:HookScript("OnHide", function(self)
    if self:IsShown() then return end
    Wizard.dismissed = true
    if Q.UI.ProfessionPicker then Q:After(0.5, Q.UI.ProfessionPicker.AutoShow) end
  end)
  return f
end

---------------------------------------------------------------------------
-- État et pages
---------------------------------------------------------------------------
local function setEnabled(widget, enabled, label)
  if enabled then widget:Enable() else widget:Disable() end
  if label then
    local T = Q.Themes
    local th = T and T:Get(Wizard.choice and Wizard.choice.theme or T:CurrentKey())
    if th then
      local c = enabled and th.colors.text or th.colors.textMuted
      label:SetTextColor(c[1], c[2], c[3])
    elseif enabled then label:SetTextColor(1, 1, 1) else label:SetTextColor(0.5, 0.5, 0.5) end
  end
end

function Wizard:SelectRoute(id)
  if id ~= "auto" or not autoAvailable() then id = "manual" end
  self.choice.route = id
  for rid, r in pairs(self.routeRadios) do r:SetChecked(rid == id) end
end

function Wizard:SelectDisplay(id)
  if not (self.detected and self.detected[id]) then id = "arrow" end
  self.choice.display = id
  for rid, r in pairs(self.radios) do r:SetChecked(rid == id) end
end

-- Choix fait par le joueur : gardé aussi dans le brouillon du personnage (reprise après /reload).
function Wizard:SetChoice(key, value)
  self.choice[key] = value
  if Q.char then
    if type(Q.char.wizardDraft) ~= "table" then Q.char.wizardDraft = {} end
    Q.char.wizardDraft[key] = value
  end
end

-- État de chaque addon de la page 1 : icône, texte, lien des absents, « Activer » des désactivés.
function Wizard:UpdateAddons()
  local anyMissing = false
  for _, entry in ipairs(ADDONS) do
    local row = self.addonRows[entry.id]
    local state, folder = self:AddonState(entry)
    row.state, row.folder = state, folder
    local s = STATUS[state]
    local color = (state == "missing" and entry.required) and "|cffff4040" or s[2]
    row.icon:SetTexture(s[3])
    row.status:SetText(color .. "(" .. L[s[1]] .. ")|r")
    if state == "disabled" then row.enable:Show() else row.enable:Hide() end
    if SHOW_LINK[state] then
      anyMissing = true
      row.link:SetText(entry.url)
      row.link:SetCursorPosition(0)
      row.link:Show()
      row:SetHeight(ROW_LINK_H)
    else
      row.link:Hide()
      row:SetHeight(ROW_H)
    end
  end
  if anyMissing then self.linkHint:Show() else self.linkHint:Hide() end
  if #self.enabledNames > 0 then
    self.reloadText:SetFormattedText(L.UI_WIZ_ENABLED, table.concat(self.enabledNames, ", "))
    self.reloadText:Show()
  else
    self.reloadText:Hide()
  end
end

-- Cases et boutons d'après self.choice.
function Wizard:Refresh()
  local d, c = self.detected, self.choice
  local auto = autoAvailable()
  setEnabled(self.routeRadios.auto, auto, self.routeRadios.auto.label)
  if auto then self.routeMissing:Hide() else self.routeMissing:Show() end
  self:SelectRoute(c.route)
  local routing = self.checks.routing
  setEnabled(routing, d.shortestpath, routing.label)
  routing:SetChecked(c.routing)
  if d.shortestpath then self.routingMissing:Hide() else self.routingMissing:Show() end
  for _, id in ipairs(DISPLAYS) do
    local r = self.radios[id]
    setEnabled(r, d[id] and true or false, r.label)
  end
  self:SelectDisplay(c.display)
  for _, def in ipairs(AUTOMATIONS) do self.checks[def[1]]:SetChecked(c[def[1]]) end
  self.checks.hideBlizzard:SetChecked(c.hideBlizzard)
  self:SelectObjectives()
  self:RenderPreview()
  self:RefreshTheme()
  local rb, Rw = self.rewardRoleButton, Q.Rewards
  if rb and Rw then
    local classFile = Q.Player and Q.Player.classFile
    if Rw:HasChoice(classFile) then
      rb:SetText(string.format(L.UI_OPT_REWARD_ROLE, Rw:RoleLabel(c.rewardRole, classFile)))
      rb:Show()
    else
      rb:Hide()
    end
  end
end

-- Les cases sont relues avant le récapitulatif et au moment de terminer : leur état affiché fait foi.
function Wizard:ReadWidgets()
  local c = self.choice
  local routing = self.checks.routing
  c.routing = self.detected.shortestpath and routing:IsEnabled() and routing:GetChecked() and true or false
  for _, def in ipairs(AUTOMATIONS) do
    c[def[1]] = self.checks[def[1]]:GetChecked() and true or false
  end
  c.hideBlizzard = self.checks.hideBlizzard:GetChecked() and true or false
end

-- Lit la détection et les réglages actuels, reprend le brouillon, puis prépare chaque page.
function Wizard:Load()
  local d = self:Detect()
  self.detected = d
  -- Affichage : celui du réglage ; au premier passage, la flèche Questify (le défaut), même si un
  -- autre addon de repère est installé.
  local display = Q.Settings:Get("nav.display")
  if not (Q.char and Q.char.wizardDone) then display = "arrow" end
  if not d[display] then display = "arrow" end
  -- Route : celle du personnage ; au premier passage, l'automatique quand elle existe.
  local D = Q.DungeonMode
  local route = "manual"
  if autoAvailable() and (D:IsOn() or not (Q.char and Q.char.wizardDone)) then route = "auto" end
  local initial = {
    route = route,
    routing = d.shortestpath and Q.Settings:Get("nav.router") == "spf" or false,
    display = display,
    autoQuest = Q.Settings:Get("autoQuest") ~= false,
    autoReward = Q.Settings:Get("autoReward") ~= false,
    sellJunk = Q.Settings:Get("sellJunk") ~= false,
    hideBlizzard = Q.Settings:Get("tracker.hideBlizzard") == true,
    rewardRole = Q.Rewards and Q.Rewards:Role() or "auto",
    objLayout = Q.Objectives and Q.Objectives:Layout() or "list",
    objDetail = Q.Objectives and Q.Objectives:Detail() or "mobs",
    theme = Q.Themes and Q.Themes:CurrentKey() or "neutral",
    followRace = Q.Settings:Get("theme.followRace") ~= false,
  }
  self.initial = initial
  local choice = {}
  for k, v in pairs(initial) do choice[k] = v end
  -- Choix faits avant un /reload : repris s'ils sont encore possibles (addon toujours chargé).
  local draft = Q.char and Q.char.wizardDraft
  if type(draft) == "table" then
    for k, v in pairs(draft) do
      if initial[k] ~= nil and type(v) == type(initial[k]) then choice[k] = v end
    end
  end
  if Q.Rewards then
    -- un brouillon périmé ne doit pas imposer un profil que la classe n'a pas
    local ok = false
    for _, r in ipairs(Q.Rewards:Roles(Q.Player and Q.Player.classFile)) do
      if r == choice.rewardRole then ok = true end
    end
    if not ok then choice.rewardRole = initial.rewardRole end
  end
  if not d.shortestpath then choice.routing = false end
  if choice.route ~= "auto" or not autoAvailable() then choice.route = "manual" end
  if not d[choice.display] then choice.display = initial.display end
  self.choice = choice
  self:UpdateAddons()
  self:Refresh()
end

function Wizard:UpdateRecap()
  self:ReadWidgets()
  local c, r = self.choice, self.recap
  local function onOff(v) return v and L.UI_WIZ_ON or L.UI_WIZ_OFF end
  r.route:SetFormattedText(L.DGMODE_WIZ_RECAP, c.route == "auto" and L.DGMODE_TAB_AUTO or L.DGMODE_TAB_MANUAL)
  r.routing:SetFormattedText(L.UI_WIZ_RECAP_ROUTING, c.routing and L.UI_NAV_SHORTESTPATH or L.UI_WIZ_OFF)
  local display = PROVIDER_TEXT[c.display] or PROVIDER_TEXT.arrow
  r.display:SetFormattedText(L.UI_WIZ_RECAP_DISPLAY, L[display[1]])
  r.autoQuest:SetFormattedText(L.UI_WIZ_RECAP_AUTOQUEST, onOff(c.autoQuest))
  r.autoReward:SetFormattedText(L.UI_WIZ_RECAP_AUTOREWARD, onOff(c.autoReward))
  r.sellJunk:SetFormattedText(L.UI_WIZ_RECAP_SELLJUNK, onOff(c.sellJunk))
  r.hideBlizzard:SetFormattedText(L.UI_WIZ_RECAP_HIDE_BLIZZARD, c.hideBlizzard and L.UI_WIZ_HIDDEN or L.UI_WIZ_SHOWN)
  local function choiceText(key)
    for _, def in ipairs(OBJ_CHOICES[key]) do
      if def[1] == c[key] then return L[def[2]] end
    end
    return tostring(c[key])
  end
  r.objectives:SetFormattedText(L.UI_WIZ_RECAP_OBJ, choiceText("objLayout"), choiceText("objDetail"))
  local T = Q.Themes
  r.theme:SetFormattedText(L.UI_WIZ_RECAP_THEME, T and L[T:Get(c.theme).label] or tostring(c.theme))
end

-- Affiche la page n et la garde dans Q.char.wizardPage (reprise après /reload).
function Wizard:SetPage(n)
  n = math.max(1, math.min(NUM_PAGES, math.floor(tonumber(n) or 1)))
  self.page = n
  if Q.char then Q.char.wizardPage = n end
  for i, page in ipairs(self.pages) do
    if i == n then page:Show() else page:Hide() end
  end
  self.prevButton:Show()
  self.prevButton:SetEnabled(n > 1)
  if n < NUM_PAGES then
    self.nextButton:Show()
    self.skipButton:Show()
    self.finishButton:Hide()
  else
    self.nextButton:Hide()
    self.skipButton:Hide()
    self.finishButton:Show()
  end
  if n == PAGE_ADDONS or self.pendingReload then self.reloadButton:Show() else self.reloadButton:Hide() end
  if n == PAGE_RECAP then self:UpdateRecap() end
  self.stepText:SetFormattedText(L.UI_WIZ_STEP, n, NUM_PAGES)
end

function Wizard:Next() self:SetPage(self.page + 1) end
function Wizard:Prev() self:SetPage(self.page - 1) end

-- « Ignorer » : les choix de la page reprennent leur valeur de départ, puis page suivante.
function Wizard:Skip()
  local draft = Q.char and Q.char.wizardDraft
  for _, key in ipairs(PAGE_KEYS[self.page] or {}) do
    self.choice[key] = self.initial[key]
    if type(draft) == "table" then draft[key] = nil end
  end
  self:Refresh()
  self:SetPage(self.page + 1)
end

-- « Activer » : C_AddOns.EnableAddOn pour ce personnage seulement, puis le rechargement est
-- proposé sur toutes les pages.
function Wizard:EnableAddon(id)
  local row = self.addonRows[id]
  if not row or row.state ~= "disabled" then return end
  local f = C_AddOns and C_AddOns.EnableAddOn
  local who = playerName()
  if type(f) ~= "function" or not who then return end
  local ok, err = pcall(f, row.folder, who)
  if not ok then
    Q:ReportError(err)
    return
  end
  self.pendingReload = true
  self.enabledNames[#self.enabledNames + 1] = L[row.entry.name]
  playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
  self:UpdateAddons()
  self:SetPage(self.page)
end

-- « Recharger l'interface » : la page est déjà gardée, l'assistant y reprendra.
function Wizard:Reload()
  if Q.char then Q.char.wizardPage = self.page end
  local reload = ReloadUI or (C_UI and C_UI.Reload)
  if type(reload) == "function" then reload() end
end

-- Show() reprend à la page gardée (1 si aucune) ; Show(n) ouvre la page n.
function Wizard:Show(page)
  self:Create()
  self:Load()
  self:SetPage(page or (Q.char and Q.char.wizardPage) or 1)
  self.frame:Show()
  self.frame:Raise()
end

function Wizard:IsShown()
  return self.frame ~= nil and self.frame:IsShown()
end

-- Vrai si l'assistant a été fermé (croix, Échap ou « Terminer ») pendant cette session.
function Wizard:ClosedThisSession()
  return self.dismissed == true
end

function Wizard:Finish()
  self:ReadWidgets()
  local c = self.choice
  -- case « ShortestPath » : SPF, sinon le routeur choisi ailleurs (Questify s'il était sur SPF)
  local router = Q.Settings:Get("nav.router")
  if c.routing then router = "spf" elseif router == "spf" then router = "questify" end
  Q.Settings:Set("nav.router", router)
  Q.Settings:Set("nav.display", c.display or "arrow")
  Q.Settings:Set("autoQuest", c.autoQuest)
  Q.Settings:Set("autoReward", c.autoReward)
  Q.Settings:Set("sellJunk", c.sellJunk)
  Q.Settings:Set("tracker.hideBlizzard", c.hideBlizzard)
  Q.Settings:Set("tracker.objLayout", c.objLayout)
  Q.Settings:Set("tracker.objDetail", c.objDetail)
  -- thème : suivre la race, sinon le thème choisi
  if Q.Themes and c.theme then
    if c.followRace then
      Q.Settings:Set("theme.followRace", true)
      if c.theme ~= Q.Themes:RaceKey() then Q.Settings:Set("tracker.theme", c.theme) end
    else
      Q.Settings:Set("theme.followRace", false)
      Q.Settings:Set("tracker.theme", c.theme)
    end
  end
  -- profil de butin : propre au personnage (Q.char.rewardRole), hors profils d'options
  if Q.Rewards and c.rewardRole then Q.Rewards:SetRole(c.rewardRole) end
  if Q.char and Q.Rewards and Q.Rewards:HasChoice(Q.Player and Q.Player.classFile) then Q.char.rewardRoleChosen = true end
  -- route : le mode automatique est par personnage (Q.char.dungeonMode) ; SetOn relance le choix du chapitre
  if Q.DungeonMode and autoAvailable() then Q.DungeonMode:SetOn(c.route == "auto") end
  if Q.char then
    Q.char.wizardDone = true
    Q.char.wizardObjectivesSeen = true
    Q.char.wizardPage = nil
    Q.char.wizardDraft = nil
  end
  self.frame:Hide()   -- OnHide : étape suivante de l'accueil, le choix des métiers
  playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
  Q:Print(L.UI_WIZ_DONE)
end

---------------------------------------------------------------------------
-- Ouverture automatique (3 s après la connexion, jamais en combat, une fois par session)
---------------------------------------------------------------------------
local waitingCombat = false

-- Assistant terminé avant que la page des objectifs existe : elle est proposée une fois
-- (Q.char.wizardObjectivesSeen), les autres pages gardant les réglages en vigueur.
local function newPagePending()
  return Q.char ~= nil and Q.char.wizardDone == true and not Q.char.wizardObjectivesSeen
end

local function autoShow()
  if not Q.char or Wizard:IsShown() then return end
  local revisit = newPagePending()
  if Q.char.wizardDone and not revisit then return end
  -- déjà ouvert ou fermé par le joueur pendant cette session : pas d'insistance
  if Wizard.autoShown or Wizard.dismissed then return end
  if InCombatLockdown and InCombatLockdown() then
    waitingCombat = true
    return
  end
  Wizard.autoShown = true
  if revisit then
    Q.char.wizardObjectivesSeen = true
    Wizard:Show(PAGE_OBJECTIVES)
    Q:Print(L.UI_WIZ_NEW_OBJECTIVES)
  else
    Wizard:Show()
  end
end

Q:On("LOGIN", function()
  if Q.char and (not Q.char.wizardDone or newPagePending()) then Q:After(AUTO_DELAY, autoShow) end
end)

Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  if waitingCombat then
    waitingCombat = false
    autoShow()
  end
end)
