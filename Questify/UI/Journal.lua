local addonName, Q = ...

-- Journal principal (spec § 5.8), ouvert par /questify, /qf, le compartiment d'addons ou les boutons du
-- suivi (UI/TrackerButtons.lua). Trois onglets, chacun avec l'icône de son bouton du suivi :
--   « Route » : chapitres de la faction à gauche, groupés (conseillés à ton niveau, à suivre, puis
--               faits, dépassés ou d'une autre race ; coche verte sur un chapitre fini), étapes du
--               chapitre à droite (icône d'état, clic = étape courante) ;
--   « Donjons » : liste groupée et notée (étoiles) à gauche, détail du donjon choisi à droite ;
--   « Quêtes de classe » : une ligne par chaîne avec son état et Ajouter / Ignorer / Réactiver.
-- Le bouton « Options… » en bas à droite ouvre la fenêtre d'options (UI/Options.lua).
Q.UI = Q.UI or {}
local Journal = { tab = "route", panels = {}, tabs = {}, chapterRows = {}, stepRows = {}, classRows = {} }
Q.UI.Journal = Journal

local L = Q.L

local FRAME_NAME = "QuestifyJournal"
local WIDTH, HEIGHT = 520, 560
local TAB_NAMES = { "route", "dungeons", "class" }
local TAB_INDEX = { route = 1, dungeons = 2, class = 3 }

local CHAPTER_W, CHAPTER_ROW_H = 150, 20
local STEP_W, STEP_ROW_H = 290, 18
local CLASS_W, CLASS_ROW_H = 456, 46
local CLASS_ITEMS = 3
local LIST_H = 432

Journal.STATE_ICONS = {
  done = "Interface\\RaidFrame\\ReadyCheck-Ready",
  skipped = "Interface\\RaidFrame\\ReadyCheck-NotReady",
  current = "Interface\\ChatFrame\\ChatFrameExpandArrow",
  blocked = "Interface\\LFGFrame\\UI-LFG-ICON-LOCK",
}
local ICONS = Journal.STATE_ICONS

local CQ_STATE_TEXT = {
  available = "UI_CQ_AVAILABLE", upcoming = "UI_CQ_UPCOMING", added = "UI_CQ_ADDED",
  ignored = "UI_CQ_IGNORED", inprogress = "UI_CQ_INPROGRESS", done = "UI_CQ_DONE",
  inroute = "UI_CQ_INROUTE",   -- quêtes déjà étapes de la route (Engine/ClassQuests.lua) : aucun bouton
}
local CQ_LATE_COLOR = "|cffff5050"   -- couleur d'alerte : chaîne en retard
local CQ_STATE_COLOR = {
  available = "|cff40ff40", upcoming = "|cffaaaaaa", added = "|cffffd100",
  ignored = "|cff808080", inprogress = "|cff66bbff", done = "|cff808080", inroute = "|cffffd100",
}

local function playSound(kit)
  if PlaySound and SOUNDKIT and SOUNDKIT[kit] then pcall(PlaySound, SOUNDKIT[kit]) end
end

local function safe(fn)
  return function(...) return Q.SafeCall(fn, ...) end
end

local function showTooltip(owner, lines, anchor)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, anchor or "ANCHOR_RIGHT")
  GameTooltip:ClearLines()
  for i, line in ipairs(lines) do
    if i == 1 then GameTooltip:AddLine(line, 1, 0.82, 0, true) else GameTooltip:AddLine(line, 1, 1, 1, true) end
  end
  GameTooltip:Show()
end
local function hideTooltip() if GameTooltip then GameTooltip:Hide() end end

-- Liste défilante (modèle natif UIPanelScrollFrameTemplate) : -> scrollFrame, enfant.
local function newScroll(parent, name, width, height)
  local scroll = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
  scroll:SetSize(width, height)
  local child = CreateFrame("Frame", nil, scroll)
  child:SetSize(width, 1)
  scroll:SetScrollChild(child)
  return scroll, child
end

-- Fait défiler la liste pour que la ligne `index` soit visible.
local function ensureVisible(scroll, index, rowH, total)
  if not index then return end
  local viewH = scroll:GetHeight() or LIST_H
  local offset = scroll:GetVerticalScroll() or 0
  local top, bottom = (index - 1) * rowH, index * rowH
  if top >= offset and bottom <= offset + viewH then return end
  local maxOffset = math.max(0, total * rowH - viewH)
  local wanted = math.max(0, math.min(maxOffset, top - math.floor(viewH / 3)))
  scroll:SetVerticalScroll(wanted)
end

---------------------------------------------------------------------------
-- Cadre et onglets
---------------------------------------------------------------------------
local function newFrame()
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "ButtonFrameTemplate")
  if ok and f then return f end
  ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "BasicFrameTemplateWithInset")
  if ok and f then return f end
  return CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
end

function Journal:Create()
  if self.frame then return self.frame end
  local f = newFrame()
  self.frame = f
  f:SetSize(WIDTH, HEIGHT)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  f:SetFrameStrata("MEDIUM")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  if f.SetTitle then f:SetTitle(L.UI_JOURNAL_TITLE) end
  if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, "Interface\\Icons\\INV_Misc_Book_09") end
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end

  -- Zone de contenu : intérieur du cadre « Inset » du modèle (60 px en haut, 26 px en bas).
  local content = CreateFrame("Frame", nil, f)
  content:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -64)
  content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 30)
  self.content = content

  -- libellés précédés de l'icône du bouton du suivi correspondant
  local B = Q.UI.TrackerButtons
  local function label(key, text)
    if B and B.IconMarkup then
      local ok, icon = pcall(B.IconMarkup, key, 14)
      if ok and icon ~= "" then return icon .. " " .. text end
    end
    return text
  end
  local labels = { label("route", L.UI_TAB_ROUTE), label("dungeons", L.UI_TAB_DUNGEONS), label("class", L.UI_TAB_CLASS) }
  for i, name in ipairs(TAB_NAMES) do
    local tab = CreateFrame("Button", FRAME_NAME .. "Tab" .. i, f, "PanelTabButtonTemplate")
    tab:SetID(i)
    tab:SetText(labels[i])
    if i == 1 then
      tab:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 12, 2)
    else
      -- même ancre que PanelTemplates_AnchorTabs : l'appel suivant la remplace sans conflit
      tab:SetPoint("TOPLEFT", self.tabs[i - 1], "TOPRIGHT", 3, 0)
    end
    tab:SetScript("OnClick", safe(function()
      playSound("IG_CHARACTER_INFO_TAB")
      Journal:ShowTab(name)
    end))
    if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, tab, 0) end
    self.tabs[i] = tab

    local panel = CreateFrame("Frame", nil, content)
    panel:SetAllPoints(content)
    panel:Hide()
    self.panels[name] = panel
  end
  if PanelTemplates_SetNumTabs then pcall(PanelTemplates_SetNumTabs, f, #TAB_NAMES) end

  -- Onglet Route : deux vues. « Manuel » : chapitres et étapes ; « Automatique » : parcours complet avec les
  -- donjons (UI/DungeonModePanel.lua), proposé seulement quand il existe pour le personnage.
  local routePanel = self.panels.route
  self.routePanels = {}
  for _, mode in ipairs({ "manual", "auto" }) do
    local sub = CreateFrame("Frame", nil, routePanel)
    sub:SetAllPoints(routePanel)
    sub:Hide()
    self.routePanels[mode] = sub
  end
  self:BuildRoute(self.routePanels.manual)
  local auto = Q.UI.DungeonModePanel
  if auto and auto.Build then auto:Build(self.routePanels.auto) end
  self.routeModeButtons = {}
  for i, mode in ipairs({ "manual", "auto" }) do
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(112, 22)
    b:SetPoint("TOPLEFT", f, "TOPLEFT", 62 + (i - 1) * 116, -34)
    b:SetText(mode == "manual" and L.DGMODE_TAB_MANUAL or L.DGMODE_TAB_AUTO)
    b:SetScript("OnClick", safe(function()
      playSound("IG_CHARACTER_INFO_TAB")
      Journal:ShowRouteMode(mode)
    end))
    b:Hide()
    self.routeModeButtons[mode] = b
  end
  self:BuildDungeons(self.panels.dungeons)
  self:BuildClass(self.panels.class)
  -- Options : fenêtre à part (UI/Options.lua)
  local opt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  opt:SetSize(120, 22)
  opt:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 4)
  opt:SetText(L.OPT_JOURNAL_OPTIONS)
  opt:SetScript("OnClick", safe(function()
    playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
    if Q.UI.Options then Q.UI.Options:Open() end
  end))
  self.optionsButton = opt
  -- Choix de suite (UI/RouteChoicePopup.lua) : rouvre le choix du chapitre courant ou du dernier choisi
  local route = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  route:SetSize(130, 22)
  route:SetPoint("RIGHT", opt, "LEFT", -6, 0)
  route:SetText(L.UI_ROUTECHOICE_JOURNAL)
  route:SetScript("OnClick", safe(function()
    playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
    local P = Q.UI.RouteChoicePopup
    if P then P:OpenForPlayer() end
  end))
  self.routeButton = route
  -- Zone de secours (Engine/Detour.lua) : autre zone du niveau du personnage, puis retour à la route
  local alt = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  alt:SetSize(140, 22)
  alt:SetPoint("RIGHT", route, "LEFT", -6, 0)
  alt:SetText(L.DETOUR_BTN)
  alt:SetScript("OnClick", safe(function()
    playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
    local go = Q.UI.Detour
    if go then go(Q.Detour ~= nil and Q.Detour:Current() ~= nil) end
    Journal:UpdateDetourButton()
  end))
  alt:SetScript("OnEnter", safe(function(self)
    local back = Q.Detour and Q.Detour:Current()
    showTooltip(self, { back and L.DETOUR_BTN_BACK or L.DETOUR_BTN, back and L.DETOUR_TIP_BACK or L.DETOUR_TIP })
  end))
  alt:SetScript("OnLeave", hideTooltip)
  self.detourButton = alt
  f:Hide()
  -- Sons d'ouverture et de fermeture branchés après le Hide() initial (pas de son à la création).
  f:HookScript("OnShow", function() playSound("IG_CHARACTER_INFO_OPEN") end)
  f:HookScript("OnHide", function() playSound("IG_CHARACTER_INFO_CLOSE") end)
  return f
end

function Journal:IsShown()
  return self.frame ~= nil and self.frame:IsShown()
end

function Journal:Toggle()
  self:Create()
  if self.frame:IsShown() then
    self.frame:Hide()
  else
    self:ShowTab(self.tab or "route")
  end
end

-- ResolveTab(nom) -> onglet réellement ouvert pour ce nom ("route" si le nom est inconnu).
function Journal:ResolveTab(name)
  if not TAB_INDEX[name] then name = "route" end
  return name
end

-- ShowTab("route" | "class" | "dungeons") : ouvre le journal sur cet onglet. "options" ouvre la
-- fenêtre d'options (l'ancien onglet Options). À l'ouverture du journal, l'onglet Route revient sur la vue
-- de la route choisie (Automatique si le mode automatique est actif), sauf keepRouteMode (ShowRouteMode).
function Journal:ShowTab(name, keepRouteMode)
  if name == "options" then
    if Q.UI.Options then Q.UI.Options:Open() end
    return
  end
  name = self:ResolveTab(name)
  self:Create()
  if not keepRouteMode and not self.frame:IsShown() then self.routeMode = nil end
  self.tab = name
  if PanelTemplates_SetTab then pcall(PanelTemplates_SetTab, self.frame, TAB_INDEX[name]) end
  for n, panel in pairs(self.panels) do
    if n == name then panel:Show() else panel:Hide() end
  end
  self.frame:Show()
  self:UpdateDetourButton()
  self:UpdateRouteMode()
  self:RefreshTab(name, true)
end

-- Bouton de la zone de secours : « Zone alternative », ou « Revenir à ma route » sur une zone de secours.
function Journal:UpdateDetourButton()
  if not self.detourButton then return end
  local back = Q.Detour and Q.Detour:Current()
  self.detourButton:SetText(back and L.DETOUR_BTN_BACK or L.DETOUR_BTN)
end

-- Vue de l'onglet Route réellement affichée : celle choisie par les boutons, sinon celle de la route du
-- personnage ; "auto" seulement si le mode automatique existe pour le personnage, sinon "manual".
function Journal:RouteMode()
  local D = Q.DungeonMode
  local want = self.routeMode or (D and D:IsOn() and "auto" or "manual")
  if want == "auto" and D and D:Available() then return "auto" end
  return "manual"
end

-- Boutons « Manuel » / « Automatique » (visibles sur l'onglet Route quand le mode automatique existe) et
-- vue affichée.
function Journal:UpdateRouteMode()
  if not self.frame then return end
  local D = Q.DungeonMode
  local mode = self:RouteMode()
  local show = self.tab == "route" and D ~= nil and D:Available()
  for m, b in pairs(self.routeModeButtons) do
    if show then b:Show() else b:Hide() end
    -- vue ouverte : bouton enfoncé
    if m == mode then b:Disable() else b:Enable() end
  end
  for m, sub in pairs(self.routePanels) do
    if m == mode then sub:Show() else sub:Hide() end
  end
end

-- ShowRouteMode("manual" | "auto") : ouvre le journal sur l'onglet Route, dans cette vue.
function Journal:ShowRouteMode(mode)
  self:Create()
  self.routeMode = mode == "auto" and "auto" or "manual"
  self:ShowTab("route", true)
end

function Journal:RefreshTab(name, scroll)
  if name == "route" then
    self:RefreshRoute(scroll)
  elseif name == "dungeons" then
    self:RefreshDungeonTab()
  elseif name == "class" then
    self:RefreshClass()
  end
end

-- Rafraîchit l'onglet visible, si le journal est ouvert.
local function refreshIfShown(name, scroll)
  if Journal:IsShown() and Journal.tab == name then Journal:RefreshTab(name, scroll) end
end

---------------------------------------------------------------------------
-- Onglet Route
---------------------------------------------------------------------------
function Journal:BuildRoute(panel)
  local chHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  chHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  chHeader:SetText(L.UI_ROUTE_CHAPTERS)
  local stHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  stHeader:SetPoint("TOPLEFT", panel, "TOPLEFT", CHAPTER_W + 34, -4)
  stHeader:SetWidth(STEP_W)
  stHeader:SetJustifyH("LEFT")
  stHeader:SetWordWrap(false)
  stHeader:SetText(L.UI_ROUTE_STEPS)
  self.stepHeader = stHeader

  local chScroll, chChild = newScroll(panel, "QuestifyJournalChapterScroll", CHAPTER_W, LIST_H)
  chScroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -24)
  self.chapterScroll, self.chapterChild = chScroll, chChild

  local stScroll, stChild = newScroll(panel, "QuestifyJournalStepScroll", STEP_W, LIST_H)
  stScroll:SetPoint("TOPLEFT", panel, "TOPLEFT", CHAPTER_W + 32, -24)
  self.stepScroll, self.stepChild = stScroll, stChild

  local msg = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  msg:SetPoint("TOPLEFT", stScroll, "TOPLEFT", 4, -4)
  msg:SetWidth(STEP_W - 8)
  msg:SetJustifyH("LEFT")
  msg:Hide()
  self.routeMessage = msg
end

local function chapterRow(i)
  local row = Journal.chapterRows[i]
  if row then return row end
  row = CreateFrame("Button", nil, Journal.chapterChild)
  row:SetSize(CHAPTER_W, CHAPTER_ROW_H)
  row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  local sel = row:CreateTexture(nil, "BACKGROUND")
  sel:SetAllPoints(row)
  sel:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
  sel:SetBlendMode("ADD")
  sel:SetVertexColor(1, 0.82, 0, 0.5)
  sel:Hide()
  -- coche verte : chapitre fini (Q.Progress:ChapterDone)
  local check = row:CreateTexture(nil, "ARTWORK")
  check:SetTexture(ICONS.done)
  check:SetSize(12, 12)
  check:SetPoint("LEFT", row, "LEFT", 2, 0)
  check:Hide()
  local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("LEFT", row, "LEFT", 16, 0)
  text:SetWidth(CHAPTER_W - 52)
  text:SetJustifyH("LEFT")
  text:SetWordWrap(false)
  local lvl = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  lvl:SetPoint("RIGHT", row, "RIGHT", -4, 0)
  lvl:SetJustifyH("RIGHT")
  row.text, row.levels, row.selected, row.check = text, lvl, sel, check
  row:SetScript("OnClick", safe(function(self)
    if self.guide then
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      -- true : un chapitre déjà fini reste affiché, pour y rouvrir une étape passée par erreur
      Q.Progress:SetGuide(self.guide.id, true)
      Journal:RefreshRoute(true)
    end
  end))
  row:SetScript("OnEnter", safe(function(self)
    if self.guide then
      local lines = { Q.Guides:DisplayTitle(self.guide),
        string.format(L.UI_TRACKER_LEVELS, self.guide.minLevel or 1, self.guide.maxLevel or 60) }
      if self.done then lines[#lines + 1] = "|cff40e050" .. L.UI_ROUTE_CHAPTER_DONE .. "|r" end
      lines[#lines + 1] = L.UI_ROUTE_CHAPTER_HINT
      showTooltip(self, lines)
    end
  end))
  row:SetScript("OnLeave", hideTooltip)
  Journal.chapterRows[i] = row
  return row
end

-- Rend une étape courante : les étapes non faites avant elle sont passées, celles passées
-- après elle sont rouvertes (Q.Progress:JumpTo fait tout en un seul recalcul).
local function jumpTo(entry)
  if Q.Progress.JumpTo then
    Q.Progress:JumpTo(entry.key)
    return
  end
  local c = Q.char
  local before = true
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.key == entry.key then
      before = false
      c.skipped[e.key], c.manual[e.key] = nil, nil
    elseif before then
      local s = Q.Progress:State(e)
      if s == "active" or s == "blocked" then c.skipped[e.key] = true end
    else
      c.skipped[e.key] = nil
    end
  end
  Q.Progress:Update()
end

local function stepTooltip(row)
  local e = row.entry
  if not e then return end
  local state, reason = Q.Progress:State(e)
  local lines = { Q.Format:StepTitle(e), Q.Format:StepText(e) }
  local label = ({ done = L.UI_STATE_DONE, skipped = L.UI_STATE_SKIPPED, blocked = L.UI_STATE_BLOCKED,
    active = L.UI_STATE_ACTIVE })[state] or ""
  if row.isCurrent then label = L.UI_STATE_CURRENT end
  if reason and reason ~= "" then label = label .. " - " .. Q.Format:Reason(reason) end
  lines[#lines + 1] = "|cffaaaaaa" .. label .. "|r"
  lines[#lines + 1] = "|cff66bbff" .. L.UI_ROUTE_STEP_HINT .. "|r"
  showTooltip(row, lines)
end

local function stepRow(i)
  local row = Journal.stepRows[i]
  if row then return row end
  row = CreateFrame("Button", nil, Journal.stepChild)
  row:SetSize(STEP_W, STEP_ROW_H)
  row:SetPoint("TOPLEFT", Journal.stepChild, "TOPLEFT", 0, -(i - 1) * STEP_ROW_H)
  row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  local bg = row:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(row)
  bg:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
  bg:SetBlendMode("ADD")
  bg:SetVertexColor(1, 0.82, 0, 0.45)
  bg:Hide()
  local state = row:CreateTexture(nil, "ARTWORK")
  state:SetSize(14, 14)
  state:SetPoint("LEFT", row, "LEFT", 2, 0)
  local action = row:CreateTexture(nil, "ARTWORK")
  action:SetSize(14, 14)
  action:SetPoint("LEFT", row, "LEFT", 18, 0)
  local text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("LEFT", row, "LEFT", 36, 0)
  text:SetWidth(STEP_W - 38)
  text:SetJustifyH("LEFT")
  text:SetWordWrap(false)
  row.state, row.action, row.text, row.currentBg = state, action, text, bg
  row:SetScript("OnClick", safe(function(self)
    if self.entry then
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      jumpTo(self.entry)
      Journal:RefreshRoute(false)
    end
  end))
  row:SetScript("OnEnter", safe(stepTooltip))
  row:SetScript("OnLeave", hideTooltip)
  Journal.stepRows[i] = row
  return row
end

local function factionChapters()
  local faction = Q.Player and Q.Player.faction
  local list = {}
  -- chapitres du parcours du personnage : guides habituels, ou ceux du mode « Donjons » quand il est choisi
  local mode = Q.DungeonMode and Q.DungeonMode:Mode() or nil
  for _, g in ipairs(Q.Guides:All()) do
    if (g.faction == nil or g.faction == faction) and g.mode == mode then list[#list + 1] = g end
  end
  table.sort(list, function(a, b)
    if (a.minLevel or 1) ~= (b.minLevel or 1) then return (a.minLevel or 1) < (b.minLevel or 1) end
    return a.id < b.id
  end)
  return list
end

-- Groupes de chapitres, comme les donjons :
--   « now »  : conseillés à ton niveau (niveau entre le minimum et le maximum du chapitre), et le
--              chapitre suivi même s'il n'est plus de ton niveau ;
--   « next » : à suivre (niveau minimum pas encore atteint) ;
--   « past » : faits, dépassés, ou réservés à une autre race.
-- ChapterGroups(chapitres, chapitre suivi, niveau, race) -> { { key, items = { { guide, done } } } },
-- groupes vides omis, ordre des chapitres gardé dans chaque groupe.
local CHAPTER_GROUPS = { "now", "next", "past" }
local CHAPTER_GROUP_TEXT = { now = "UI_ROUTE_GROUP_NOW", next = "UI_ROUTE_GROUP_NEXT", past = "UI_ROUTE_GROUP_PAST" }

function Journal.ChapterGroups(chapters, current, level, raceKey)
  level = tonumber(level) or 1
  local by = {}
  for _, g in ipairs(chapters) do
    local done = Q.Progress.ChapterDone and Q.Progress:ChapterDone(g) or false
    local group
    if current and g.id == current.id then
      group = "now"
    elseif done then
      group = "past"
    elseif raceKey and g.races and not Q.Util.Contains(g.races, raceKey) then
      group = "past"
    elseif level > (g.maxLevel or 60) then
      group = "past"
    elseif level < (g.minLevel or 1) then
      group = "next"
    else
      group = "now"
    end
    by[group] = by[group] or {}
    table.insert(by[group], { guide = g, done = done })
  end
  local out = {}
  for _, key in ipairs(CHAPTER_GROUPS) do
    if by[key] then out[#out + 1] = { key = key, items = by[key] } end
  end
  return out
end

local function chapterHeader(i)
  Journal.chapterHeaders = Journal.chapterHeaders or {}
  local h = Journal.chapterHeaders[i]
  if h then return h end
  h = Journal.chapterChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  h:SetJustifyH("LEFT")
  h:SetWidth(CHAPTER_W - 8)
  h:SetWordWrap(false)
  Journal.chapterHeaders[i] = h
  return h
end

local function setStepRow(row, e, cur)
  local state, reason = Q.Progress:State(e)
  local isCurrent = cur ~= nil and e.key == cur.key
  row.entry, row.isCurrent = e, isCurrent
  row.action:SetTexture(Q.Format:ActionIcon(e.step.action))
  local text = Q.Util.StripColors(Q.Format:StepTitle(e))
  local icon
  if isCurrent then
    icon = ICONS.current
  elseif state == "done" then
    icon = ICONS.done
  elseif state == "skipped" then
    icon = ICONS.skipped
  elseif state == "blocked" then
    icon = ICONS.blocked
  end
  if state == "blocked" and reason then
    text = text .. " |cffff5555(" .. Q.Format:Reason(reason) .. ")|r"
  end
  row.state:SetTexture(icon)
  row.state:SetDesaturated(state == "skipped")
  if icon then row.state:Show() else row.state:Hide() end
  row.action:SetDesaturated(state == "done" or state == "skipped")
  row.text:SetText(text)
  if isCurrent then
    row.text:SetTextColor(1, 0.82, 0)
  elseif state == "skipped" then
    row.text:SetTextColor(0.5, 0.5, 0.5)
  elseif state == "done" then
    row.text:SetTextColor(0.75, 0.75, 0.75)
  else
    row.text:SetTextColor(1, 1, 1)
  end
  if isCurrent then row.currentBg:Show() else row.currentBg:Hide() end
  row:Show()
end

function Journal:RefreshRoute(scrollToCurrent)
  self:UpdateRouteMode()
  if self:RouteMode() == "auto" then
    local auto = Q.UI.DungeonModePanel
    if auto and auto.Refresh then auto:Refresh() end
    return
  end
  if not self.frame then return end
  local available = Q.QDB and Q.QDB:IsAvailable()
  -- Chapitres, groupés
  local chapters = available and factionChapters() or {}
  local guide = available and Q.Progress:Guide() or nil
  local P = Q.Player or {}
  local groups = Journal.ChapterGroups(chapters, guide, P.level, P.raceKey)
  local child, y, nh, nr = self.chapterChild, 0, 0, 0
  for _, grp in ipairs(groups) do
    nh = nh + 1
    local h = chapterHeader(nh)
    h:SetText(L[CHAPTER_GROUP_TEXT[grp.key]])
    h:ClearAllPoints()
    h:SetPoint("TOPLEFT", child, "TOPLEFT", 4, -(y + 6))
    h:Show()
    y = y + CHAPTER_ROW_H
    for _, it in ipairs(grp.items) do
      nr = nr + 1
      local g = it.guide
      local row = chapterRow(nr)
      row.guide, row.done = g, it.done
      row:ClearAllPoints()
      row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -y)
      row.text:SetText(Q.Guides:DisplayTitle(g))
      row.levels:SetFormattedText(L.UI_TRACKER_LEVELS, g.minLevel or 1, g.maxLevel or 60)
      if it.done then row.check:Show() else row.check:Hide() end
      local selected = guide ~= nil and guide.id == g.id
      if selected then row.selected:Show() else row.selected:Hide() end
      if selected then
        row.text:SetTextColor(1, 0.82, 0)
      elseif grp.key == "now" then
        row.text:SetTextColor(1, 1, 1)
      else
        row.text:SetTextColor(0.6, 0.6, 0.6)
      end
      row:Show()
      y = y + CHAPTER_ROW_H
    end
  end
  for i = nh + 1, #(self.chapterHeaders or {}) do self.chapterHeaders[i]:Hide() end
  for i = nr + 1, #self.chapterRows do
    self.chapterRows[i].guide = nil
    self.chapterRows[i]:Hide()
  end
  self.chapterChild:SetHeight(math.max(1, y))

  -- Étapes
  local entries = guide and Q.Progress:Entries() or {}
  if not available then
    self.routeMessage:SetText(Q.QDB and Q.QDB.Status and Q.QDB:Status() == "old" and L.QUESTIEDB_TOO_OLD
      or L.NEED_QUESTIEDB)
    self.routeMessage:Show()
  elseif not guide then
    self.routeMessage:SetText(L.UI_ROUTE_NO_GUIDE)
    self.routeMessage:Show()
  else
    self.routeMessage:Hide()
  end
  self.stepHeader:SetText(guide and (L.UI_ROUTE_STEPS .. " - " .. Q.Guides:DisplayTitle(guide)) or L.UI_ROUTE_STEPS)
  local cur = guide and Q.Progress:Current() or nil
  local curIndex
  for i, e in ipairs(entries) do
    setStepRow(stepRow(i), e, cur)
    if cur and e.key == cur.key then curIndex = i end
  end
  for i = #entries + 1, #self.stepRows do
    self.stepRows[i].entry = nil
    self.stepRows[i]:Hide()
  end
  self.stepChild:SetHeight(math.max(1, #entries * STEP_ROW_H))
  if scrollToCurrent then ensureVisible(self.stepScroll, curIndex, STEP_ROW_H, #entries) end
end

---------------------------------------------------------------------------
-- Onglet Quêtes de classe
---------------------------------------------------------------------------
function Journal:BuildClass(panel)
  local scroll, child = newScroll(panel, "QuestifyJournalClassScroll", CLASS_W, LIST_H + 20)
  scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -4)
  self.classScroll, self.classChild = scroll, child
  local empty = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  empty:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -10)
  empty:SetWidth(CLASS_W - 16)
  empty:SetJustifyH("LEFT")
  empty:Hide()
  self.classEmpty = empty
end

local CQ_CONFIRM = { Add = "UI_CQ_ADDED_MSG", Track = "UI_CQ_TRACKED_MSG" }

local function classAction(method, key, chain)
  local cq = Q.ClassQuests
  if not (cq and cq[method]) then return end
  playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
  local done = cq[method](cq, key)
  -- confirmation dans la discussion (un échec explicite, retour faux, n'en donne pas)
  if done ~= false and chain and CQ_CONFIRM[method] then
    Q:Print(L[CQ_CONFIRM[method]], Q.UI.ClassQuestPopup.ChainTitle(chain))
  end
  Journal:RefreshClass()
end

local function isLate(chain, state)
  local cq = Q.ClassQuests
  return cq and cq.IsLate and cq.IsLate(chain, state) or false
end

-- Ordre d'affichage : en retard, disponibles, ajoutées, en cours, dans la route, à venir, faites,
-- ignorées.
local CQ_RANK = { available = 2, added = 3, inprogress = 4, inroute = 5, upcoming = 6, done = 7, ignored = 8 }

-- Tri stable : à rang égal l'ordre du moteur est conservé.
local function sortedClassRows(list)
  local rows = {}
  for _, item in ipairs(list or {}) do
    if type(item) == "table" and type(item.chain) == "table" then
      rows[#rows + 1] = { item = item, rank = isLate(item.chain, item.state) and 1 or CQ_RANK[item.state] or 9,
        index = #rows + 1 }
    end
  end
  table.sort(rows, function(a, b)
    if a.rank ~= b.rank then return a.rank < b.rank end
    return a.index < b.index
  end)
  local out = {}
  for i, r in ipairs(rows) do out[i] = r.item end
  return out
end

local function classTooltip(row)
  local chain = row.chain
  if not chain then return end
  local lines = { Q.UI.ClassQuestPopup.ChainTitle(chain), L.UI_CLASS_QUESTS }
  for _, id in ipairs(chain.quests or {}) do
    local q = Q.QDB:Quest(id)
    local lvl = q and q.level and (" |cffaaaaaa(" .. q.level .. ")|r") or ""
    lines[#lines + 1] = "- " .. Q.QDB:QuestName(id) .. lvl
  end
  local xp = 0
  for _, r in pairs(type(chain.rewards) == "table" and chain.rewards or {}) do
    if type(r) == "table" and type(r.xp) == "number" then xp = xp + r.xp end
  end
  if xp > 0 then lines[#lines + 1] = string.format(L.UI_POPUP_XP, xp) end
  showTooltip(row, lines)
end

local function classRow(i)
  local row = Journal.classRows[i]
  if row then return row end
  local parent = Journal.classChild
  row = CreateFrame("Button", nil, parent)
  row:SetSize(CLASS_W, CLASS_ROW_H)
  row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -(i - 1) * CLASS_ROW_H)
  if i % 2 == 0 then
    local stripe = row:CreateTexture(nil, "BACKGROUND")
    stripe:SetAllPoints(row)
    stripe:SetColorTexture(1, 1, 1, 0.04)
  end
  local title = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOPLEFT", row, "TOPLEFT", 8, -7)
  title:SetWidth(150)
  title:SetJustifyH("LEFT")
  title:SetWordWrap(false)
  local info = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  info:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
  info:SetWidth(150)
  info:SetJustifyH("LEFT")
  info:SetWordWrap(false)
  row.title, row.info, row.items = title, info, {}
  for j = 1, CLASS_ITEMS do
    local b = Q.UI.ClassQuestPopup.CreateItemButton(row, 24)
    b:SetPoint("LEFT", row, "LEFT", 160 + (j - 1) * 26, 0)
    row.items[j] = b
  end
  local function button(label, width)
    local b = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    b:SetSize(width, 22)
    b:SetText(label)
    b:Hide()
    return b
  end
  row.ignoreButton = button(L.UI_BTN_IGNORE, 80)
  row.unignoreButton = button(L.UI_BTN_UNIGNORE, 80)
  row.addButton = button(L.UI_BTN_ADD_ROUTE, 118)
  row.trackButton = button(L.UI_BTN_TRACK, 118)
  row.ignoreButton:SetPoint("RIGHT", row, "RIGHT", -6, 0)
  row.unignoreButton:SetPoint("RIGHT", row, "RIGHT", -6, 0)
  -- Ignorer et Réactiver occupent la même place (jamais affichés ensemble) : Ajouter à leur gauche.
  row.addButton:SetPoint("RIGHT", row, "RIGHT", -90, 0)
  row.trackButton:SetPoint("RIGHT", row, "RIGHT", -90, 0)   -- Ajouter et Suivre : jamais ensemble
  row.addButton:SetScript("OnClick", safe(function()
    if row.chain then classAction("Add", row.chain.key, row.chain) end
  end))
  row.trackButton:SetScript("OnClick", safe(function()
    if row.chain then classAction("Track", row.chain.key, row.chain) end
  end))
  row.ignoreButton:SetScript("OnClick", safe(function() if row.chain then classAction("Ignore", row.chain.key) end end))
  row.unignoreButton:SetScript("OnClick", safe(function() if row.chain then classAction("Unignore", row.chain.key) end end))
  row:SetScript("OnEnter", safe(classTooltip))
  row:SetScript("OnLeave", hideTooltip)
  Journal.classRows[i] = row
  return row
end

local function setClassRow(row, item)
  local chain, state = item.chain, item.state
  row.chain, row.cqState = chain, state
  row.title:SetText(Q.UI.ClassQuestPopup.ChainTitle(chain))
  local stateKey = CQ_STATE_TEXT[state]
  local stateText = stateKey and L[stateKey] or tostring(state)
  if isLate(chain, state) then
    row.info:SetText(CQ_LATE_COLOR .. string.format(L.UI_CQ_LATE, tonumber(chain.level) or 1) .. "|r")
  else
    row.info:SetText(string.format(L.UI_CLASS_ROW_INFO, tonumber(chain.level) or 1,
      (CQ_STATE_COLOR[state] or "|cffffffff") .. stateText .. "|r"))
  end
  local items, n = {}, 0
  local rewards = type(chain.rewards) == "table" and chain.rewards or {}
  for _, id in ipairs(chain.quests or {}) do
    local r = rewards[id]
    for _, itemId in ipairs(type(r) == "table" and r.items or {}) do
      if n < CLASS_ITEMS then
        n = n + 1
        items[n] = itemId
      end
    end
  end
  for j = 1, CLASS_ITEMS do
    if items[j] then Q.UI.ClassQuestPopup.SetItemButton(row.items[j], items[j]) else row.items[j]:Hide() end
  end
  -- Une chaîne ignorée se rajoute directement (Add efface l'état « ignorée ») ou se réactive.
  local canAdd = state == "available" or state == "upcoming" or state == "inprogress" or state == "ignored"
  local canIgnore = state == "available" or state == "upcoming" or state == "inprogress" or state == "added"
  if canAdd then row.addButton:Show() else row.addButton:Hide() end
  if state == "added" then row.trackButton:Show() else row.trackButton:Hide() end
  if canIgnore then row.ignoreButton:Show() else row.ignoreButton:Hide() end
  if state == "ignored" then row.unignoreButton:Show() else row.unignoreButton:Hide() end
  row:Show()
end

function Journal:RefreshClass()
  if not self.frame then return end
  local cq = Q.ClassQuests
  local list
  local qdbOk = Q.QDB and Q.QDB:IsAvailable()
  if qdbOk and cq and cq.List then
    local ok, res = pcall(cq.List, cq)
    if ok and type(res) == "table" then list = res elseif not ok then Q:ReportError(res) end
  end
  local n = 0
  for _, item in ipairs(sortedClassRows(list)) do
    n = n + 1
    setClassRow(classRow(n), item)
  end
  for i = n + 1, #self.classRows do
    self.classRows[i].chain = nil
    self.classRows[i]:Hide()
  end
  self.classChild:SetHeight(math.max(1, n * CLASS_ROW_H))
  if not qdbOk then
    self.classEmpty:SetText(Q.QDB and Q.QDB.Status and Q.QDB:Status() == "old" and L.QUESTIEDB_TOO_OLD
      or L.NEED_QUESTIEDB)
    self.classEmpty:Show()
  elseif not list then
    self.classEmpty:SetText(L.UI_CLASS_UNAVAILABLE)
    self.classEmpty:Show()
  elseif n == 0 then
    self.classEmpty:SetText(L.UI_CLASS_EMPTY)
    self.classEmpty:Show()
  else
    self.classEmpty:Hide()
  end
end

---------------------------------------------------------------------------
-- Onglet Donjons (Engine/Dungeons.lua) : la liste à gauche, groupée comme les chapitres (conseillés à
-- ton niveau, à venir, puis ignorés, dépassés et faits), triée par niveau ou par nombre de quêtes ; le
-- détail du donjon choisi à droite : niveaux, entrée, état, note, quêtes à prendre avec leur donneur
-- (grisées avec la raison quand elles ne sont pas à prendre), et Ajouter / Ignorer / Réactiver.
-- Note : une à trois étoiles selon les quêtes qu'il reste à y faire (DungeonStars).
---------------------------------------------------------------------------
local DG_LIST_W, DG_ROW_H, DG_HEAD_H = 210, 18, 20
local DG_DETAIL_X, DG_DETAIL_W = 244, 226
local DG_STATE_TEXT = {
  available = "DUNGEON_STATE_AVAILABLE", upcoming = "DUNGEON_STATE_UPCOMING", added = "DUNGEON_STATE_ADDED",
  ignored = "DUNGEON_STATE_IGNORED", done = "DUNGEON_STATE_DONE", past = "DUNGEON_STATE_PAST",
}
local DG_STATE_COLOR = {
  available = "|cff40ff40", upcoming = "|cffaaaaaa", added = "|cffffd100",
  ignored = "|cff808080", done = "|cff808080", past = "|cff808080",
}
-- Groupe de la liste selon l'état du donjon.
local DG_GROUP = { available = "now", added = "now", upcoming = "next", ignored = "past", done = "past", past = "past" }
local GROUP_ORDER = { "now", "next", "past" }
local DG_GROUP_TEXT = { now = "DUNGEON_GROUP_NOW", next = "DUNGEON_GROUP_NEXT", past = "DUNGEON_GROUP_PAST" }
local STAR_ON, STAR_OFF = "tradeskills-star", "tradeskills-star-off"
local STAR_FALLBACK = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"   -- étoile des marqueurs de raid
local ROUTE_DOT = "Interface\\COMMON\\Indicator-Green"

-- DungeonStars(n) -> 0 à 3 étoiles pour n quêtes à faire : 1-3 -> 1, 4-7 -> 2, 8 et plus -> 3.
function Journal.DungeonStars(n)
  n = tonumber(n) or 0
  if n <= 0 then return 0 end
  if n <= 3 then return 1 end
  if n <= 7 then return 2 end
  return 3
end

-- Trois textures d'étoile pleines ou vides ; aucune quand count vaut 0.
local function newStars(parent, size)
  local stars = {}
  for i = 1, 3 do
    local tex = parent:CreateTexture(nil, "ARTWORK")
    tex:SetSize(size, size)
    stars[i] = tex
  end
  return stars
end

local function setStars(stars, count)
  for i, tex in ipairs(stars) do
    local on = i <= count
    local atlas = on and STAR_ON or STAR_OFF
    if Q.Util.HasAtlas(atlas) then
      tex:SetAtlas(atlas)
      tex:SetDesaturated(false)
      tex:SetAlpha(1)
    else
      tex:SetTexture(STAR_FALLBACK)
      tex:SetDesaturated(not on)
      tex:SetAlpha(on and 1 or 0.35)
    end
    if count > 0 then tex:Show() else tex:Hide() end
  end
end

local function dungeonAction(method, key)
  local D = Q.Dungeons
  if not (D and D[method]) then return end
  playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
  D[method](D, key)
  Journal:RefreshDungeonTab()
end

-- Donjons de la faction avec leurs quêtes restantes : { dungeon, state, group, todo, now, details }.
-- nil si le module manque ou échoue.
local function dungeonItems()
  local D = Q.Dungeons
  if not (D and D.List) then return nil end
  local ok, list = pcall(D.List, D)
  if not ok then
    Q:ReportError(list)
    return nil
  end
  local out = {}
  for _, row in ipairs(type(list) == "table" and list or {}) do
    if type(row) == "table" and type(row.dungeon) == "table" then
      local okD, details = pcall(D.Details, D, row.dungeon)
      if not okD then
        Q:ReportError(details)
        details = {}
      end
      details = type(details) == "table" and details or {}
      -- quêtes rendues : listées (en dernier, cochées) mais hors des compteurs et des étoiles
      local now, todo = 0, 0
      for _, r in ipairs(details) do
        if not r.done then todo = todo + 1 end
        if r.ok and r.reason ~= "log" then now = now + 1 end
      end
      out[#out + 1] = { dungeon = row.dungeon, state = row.state, group = DG_GROUP[row.state] or "past",
        todo = todo, now = now, details = details }
    end
  end
  return out
end
Journal.DungeonItems = dungeonItems

-- Groupes affichés : { { key, items }, ... } dans l'ordre de GROUP_ORDER, groupes vides omis. Tri
-- « quests » : plus de quêtes à faire d'abord, puis par niveau ; sinon l'ordre de Dungeons:List (niveau).
function Journal.DungeonGroups(items, sort)
  local byGroup = {}
  for i, it in ipairs(items) do
    it.order = i
    byGroup[it.group] = byGroup[it.group] or {}
    table.insert(byGroup[it.group], it)
  end
  local out = {}
  for _, key in ipairs(GROUP_ORDER) do
    local list = byGroup[key]
    if list then
      if sort == "quests" then
        table.sort(list, function(a, b)
          if a.todo ~= b.todo then return a.todo > b.todo end
          return a.order < b.order
        end)
      end
      out[#out + 1] = { key = key, items = list }
    end
  end
  return out
end

local function dgHeader(i)
  Journal.dgHeaders = Journal.dgHeaders or {}
  local h = Journal.dgHeaders[i]
  if h then return h end
  h = Journal.dgChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  h:SetJustifyH("LEFT")
  h:SetWidth(DG_LIST_W - 8)
  h:SetWordWrap(false)
  Journal.dgHeaders[i] = h
  return h
end

local function dgRow(i)
  Journal.dgRows = Journal.dgRows or {}
  local row = Journal.dgRows[i]
  if row then return row end
  row = CreateFrame("Button", nil, Journal.dgChild)
  row:SetSize(DG_LIST_W, DG_ROW_H)
  row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  local sel = row:CreateTexture(nil, "BACKGROUND")
  sel:SetAllPoints(row)
  sel:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
  sel:SetBlendMode("ADD")
  sel:SetVertexColor(1, 0.82, 0, 0.5)
  sel:Hide()
  local stars = newStars(row, 9)
  for s, tex in ipairs(stars) do tex:SetPoint("LEFT", row, "LEFT", 2 + (s - 1) * 9, 0) end
  local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  name:SetPoint("LEFT", row, "LEFT", 32, 0)
  name:SetWidth(DG_LIST_W - 32 - 50)
  name:SetJustifyH("LEFT")
  name:SetWordWrap(false)
  local lvl = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  lvl:SetPoint("RIGHT", row, "RIGHT", -4, 0)
  lvl:SetJustifyH("RIGHT")
  local dot = row:CreateTexture(nil, "ARTWORK")
  dot:SetTexture(ROUTE_DOT)
  dot:SetSize(10, 10)
  dot:SetPoint("RIGHT", row, "RIGHT", -38, 0)
  dot:Hide()
  row.selected, row.stars, row.name, row.levels, row.routeDot = sel, stars, name, lvl, dot
  row:SetScript("OnClick", safe(function(self)
    if self.item then
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      Journal.dungeonSel = self.item.dungeon.key
      Journal:RefreshDungeonTab()
    end
  end))
  Journal.dgRows[i] = row
  return row
end

-- Lignes de quête du détail (créées à la demande).
local function dgLine(i)
  Journal.dgLines = Journal.dgLines or {}
  local fs = Journal.dgLines[i]
  if fs then return fs end
  fs = Journal.dgDetail:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  fs:SetWidth(DG_DETAIL_W - 10)
  fs:SetJustifyH("LEFT")
  fs:SetWordWrap(true)
  Journal.dgLines[i] = fs
  return fs
end

-- Quête bloquée par une chaîne de préquêtes : infobulle (quêtes à faire, zones, XP, récompenses) et boutons
-- « Ajouter ces quêtes » / « Les retirer » et « Plus d'infos » (UI/DungeonChainPopup.lua).
local function chainInfo(row)
  local D, item = Q.Dungeons, Journal.dgItem
  if not (D and D.ChainInfo and item and row) then return nil end
  local ok, info = pcall(D.ChainInfo, D, item.dungeon.key, row.id)
  if ok then return info end
  Q:ReportError(info)
  return nil
end

local function chainTooltip(owner)
  local info = chainInfo(owner.row)
  if not info then return end
  local names = {}
  for _, r in ipairs(owner.rows or { owner.row }) do names[#names + 1] = Q.QDB:QuestName(r.id) end
  local lines = { table.concat(names, ", ") }
  for _, l in ipairs(Q.UI.DungeonChainPopup.TooltipLines(info)) do lines[#lines + 1] = l end
  showTooltip(owner, lines)
end

local function chainAction(row)
  local D, item = Q.Dungeons, Journal.dgItem
  if not (D and item and row and row.chain) then return end
  playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
  if row.chain.chosen then D:RemoveChain(item.dungeon.key, row.id) else D:AddChain(item.dungeon.key, row.id) end
  Journal:RefreshDungeonTab()
  local P = Q.UI.DungeonChainPopup
  if P and P.frame and P.frame:IsShown() and P.questId == row.id then P:Show(item.dungeon.key, row.id) end
end

-- Encadré d'une chaîne de préquêtes sous la quête qu'elle débloque : « Demande une suite de 6 quêtes, hors de ta
-- route (zones) », infobulle au survol, boutons « Voir la suite » (annexe du journal) et « Ajouter la suite ».
local CHAIN_BACKDROP = {
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 12, insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

local function dgChain(i)
  Journal.dgChains = Journal.dgChains or {}
  local w = Journal.dgChains[i]
  if w then return w end
  local parent = Journal.dgDetail
  local ok, box = pcall(CreateFrame, "Frame", nil, parent, "BackdropTemplate")
  if not ok or not box then box = CreateFrame("Frame", nil, parent) end
  if box.SetBackdrop then
    box:SetBackdrop(CHAIN_BACKDROP)
    box:SetBackdropColor(0.12, 0.09, 0.05, 0.85)
    box:SetBackdropBorderColor(0.6, 0.5, 0.3, 0.9)
  end
  box:EnableMouse(true)
  box:SetScript("OnEnter", safe(function(self) chainTooltip(self) end))
  box:SetScript("OnLeave", hideTooltip)
  local text = box:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("TOPLEFT", box, "TOPLEFT", 7, -7)
  text:SetJustifyH("LEFT")
  text:SetWordWrap(true)
  local function button(width)
    local b = CreateFrame("Button", nil, box, "UIPanelButtonTemplate")
    b:SetSize(width, 20)
    return b
  end
  local info, add = button(100), button(100)
  info:SetText(L.DUNGEON_CHAIN_INFO)
  add:SetScript("OnClick", safe(function(self) chainAction(self.row) end))
  info:SetScript("OnClick", safe(function(self)
    playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
    if Journal.dgItem and self.row then Q.UI.DungeonChainPopup:Show(Journal.dgItem.dungeon.key, self.row.id) end
  end))
  box:Hide()
  w = { box = box, text = text, add = add, info = info }
  Journal.dgChains[i] = w
  return w
end

-- Raison d'une suite hors de portée, en une ligne (quête en cause nommée).
local WHY_KEYS = { unknown = "DUNGEON_CHAIN_WHY_UNKNOWN", race = "DUNGEON_CHAIN_WHY_RACE",
  special = "DUNGEON_CHAIN_WHY_SPECIAL", exclusive = "DUNGEON_CHAIN_WHY_EXCLUSIVE",
  nogiver = "DUNGEON_CHAIN_WHY_NOGIVER", dungeon = "DUNGEON_CHAIN_WHY_DUNGEON", long = "DUNGEON_CHAIN_WHY_LONG" }

local function questLabel(id)
  local name = type(id) == "number" and Q.QDB:QuestName(id) or nil
  if type(name) ~= "string" or name == "" or name == "?" then return "#" .. tostring(id or "?") end
  return name
end

-- Texte de l'encadré : suite (quêtes qu'elle débloque en tête, nombre de quêtes, zones hors de la route ou
-- non), niveau à atteindre, suite déjà ajoutée (tout de suite ou au niveau voulu), ou raison quand elle est hors
-- de portée. rows : quêtes du détail que cette suite débloque (une ou plusieurs).
local function chainBoxText(chain, rows)
  if chain.reason then
    return string.format(L[WHY_KEYS[chain.reason] or "DUNGEON_CHAIN_WHY_UNKNOWN"], questLabel(chain.reasonQuest))
  end
  local names = {}
  for _, m in ipairs(chain.zones or {}) do names[#names + 1] = Q.Maps:MapName(m) end
  local zones = table.concat(names, ", ")
  local n = tonumber(chain.count) or 0
  local lvl = tonumber(chain.readyLevel) or 1
  local quests = {}
  for _, r in ipairs(rows or {}) do quests[#quests + 1] = questLabel(r.id) end
  local who = "|cffffffff" .. table.concat(quests, ", ") .. "|r"
  local pl = #quests > 1 and "_PL" or ""
  if chain.chosen then
    if not chain.ready then
      if n == 0 then return string.format(L.DUNGEON_CHAIN_BOX_LATER, lvl) end
      return string.format(L.DUNGEON_CHAIN_BOX_LATER_CHAIN, who, n, lvl)
    end
    return string.format(L.DUNGEON_CHAIN_BOX_ADDED, who, n, zones)
  end
  if n == 0 then return string.format(L.DUNGEON_CHAIN_BOX_LEVEL, lvl) end
  local text
  if n == 1 then text = string.format(L["DUNGEON_CHAIN_BOX_ONE" .. pl], who, zones)
  elseif chain.offRoute then text = string.format(L["DUNGEON_CHAIN_BOX" .. pl], who, n, zones)
  else text = string.format(L["DUNGEON_CHAIN_BOX_ON" .. pl], who, n, zones) end
  if not chain.ready then text = text .. "\n" .. string.format(L.DUNGEON_CHAIN_BOX_LEVEL, lvl) end
  return text
end

-- Largeur d'un bouton d'après son texte (texte + 18 px), sans dépasser `max`.
local function fitButton(b, max)
  local w
  local ok, tw = pcall(function() return b:GetTextWidth() end)
  if ok and type(tw) == "number" and tw > 0 then w = tw end
  if not w then
    local fs = b.GetFontString and b:GetFontString()
    w = fs and fs.GetStringWidth and fs:GetStringWidth() or nil
  end
  w = math.floor((w or #(b:GetText() or "") * 6) + 18)
  b:SetWidth(math.min(max, math.max(60, w)))
  return b:GetWidth()
end

function Journal:BuildDungeons(panel)
  local head = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  head:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -4)
  head:SetText(L.DUNGEON_SECTION)
  -- Tri : niveau ou nombre de quêtes
  local function sortButton(key, label)
    local b = CreateFrame("Button", nil, panel)
    b:SetSize(48, 14)
    local fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetAllPoints(b)
    fs:SetText(label)
    b.text, b.sortKey = fs, key
    b:SetScript("OnClick", safe(function()
      playSound("IG_MAINMENU_OPTION_CHECKBOX_ON")
      Journal.dungeonSort = key
      Journal:RefreshDungeonTab()
    end))
    return b
  end
  local byQuests = sortButton("quests", L.DUNGEON_SORT_QUESTS)
  byQuests:SetPoint("TOPRIGHT", panel, "TOPLEFT", DG_LIST_W + 4, -4)
  local byLevel = sortButton("level", L.DUNGEON_SORT_LEVEL)
  byLevel:SetPoint("RIGHT", byQuests, "LEFT", -2, 0)
  local sortLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  sortLabel:SetPoint("RIGHT", byLevel, "LEFT", -2, 0)
  sortLabel:SetText(L.DUNGEON_SORT)
  self.dgSortButtons = { level = byLevel, quests = byQuests }

  local scroll, child = newScroll(panel, "QuestifyJournalDungeonScroll", DG_LIST_W, LIST_H)
  scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 2, -24)
  self.dgScroll, self.dgChild = scroll, child
  local dScroll, dChild = newScroll(panel, "QuestifyJournalDungeonDetail", DG_DETAIL_W, LIST_H + 20)
  dScroll:SetPoint("TOPLEFT", panel, "TOPLEFT", DG_DETAIL_X, -4)
  self.dgDetailScroll, self.dgDetail = dScroll, dChild

  local title = dChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", dChild, "TOPLEFT", 2, -2)
  title:SetWidth(DG_DETAIL_W - 6)
  title:SetJustifyH("LEFT")
  local meta = dChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  meta:SetWidth(DG_DETAIL_W - 6)
  meta:SetJustifyH("LEFT")
  local stars = newStars(dChild, 13)
  local score = dChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  score:SetWidth(DG_DETAIL_W - 50)
  score:SetJustifyH("LEFT")
  self.dgTitle, self.dgMeta, self.dgStars, self.dgScore = title, meta, stars, score

  local function button(label, width)
    local b = CreateFrame("Button", nil, dChild, "UIPanelButtonTemplate")
    b:SetSize(width, 22)
    b:SetText(label)
    b:Hide()
    return b
  end
  self.dgAdd = button(L.UI_BTN_ADD_ROUTE, 130)
  self.dgIgnore = button(L.UI_BTN_IGNORE, 80)
  self.dgUnignore = button(L.UI_BTN_UNIGNORE, 90)
  self.dgAdd:SetScript("OnClick", safe(function() if Journal.dgItem then dungeonAction("Add", Journal.dgItem.dungeon.key) end end))
  self.dgIgnore:SetScript("OnClick", safe(function() if Journal.dgItem then dungeonAction("Ignore", Journal.dgItem.dungeon.key) end end))
  self.dgUnignore:SetScript("OnClick", safe(function() if Journal.dgItem then dungeonAction("Unignore", Journal.dgItem.dungeon.key) end end))

  local empty = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  empty:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -30)
  empty:SetWidth(DG_LIST_W + DG_DETAIL_W)
  empty:SetJustifyH("LEFT")
  empty:Hide()
  self.dgEmpty = empty
end

-- Détail du donjon choisi (item de dungeonItems) ; nil vide la colonne.
function Journal:ShowDungeonDetail(item)
  self.dgItem = item
  local child = self.dgDetail
  local lines = self.dgLines or {}
  local widgets = { self.dgTitle, self.dgMeta, self.dgScore, self.dgAdd, self.dgIgnore, self.dgUnignore }
  if not item then
    for _, w in ipairs(widgets) do w:Hide() end
    setStars(self.dgStars, 0)
    for _, fs in ipairs(lines) do fs:Hide() end
    for _, w in ipairs(self.dgChains or {}) do w.box:Hide() end
    child:SetHeight(1)
    return
  end
  local d, state = item.dungeon, item.state
  self.dgTitle:SetText(Q.UI.DungeonPopup.DungeonName(d))
  self.dgTitle:Show()
  local key = DG_STATE_TEXT[state]
  local meta = string.format(L.DUNGEON_ROW_INFO, tonumber(d.minLevel) or 1, tonumber(d.maxLevel) or 60,
    (DG_STATE_COLOR[state] or "|cffffffff") .. (key and L[key] or tostring(state)) .. "|r")
  if type(d.entrance) == "table" and type(d.entrance[1]) == "number" then
    meta = meta .. "\n" .. string.format(L.DUNGEON_ENTRANCE, Q.Maps:MapName(d.entrance[1]))
  end
  self.dgMeta:SetText(meta)
  local y = 2 + (self.dgTitle:GetStringHeight() or 16) + 4
  self.dgMeta:ClearAllPoints()
  self.dgMeta:SetPoint("TOPLEFT", child, "TOPLEFT", 2, -y)
  self.dgMeta:Show()
  y = y + (self.dgMeta:GetStringHeight() or 24) + 8
  -- note et décompte
  local count = Journal.DungeonStars(item.todo)
  setStars(self.dgStars, count)
  for i, tex in ipairs(self.dgStars) do
    tex:ClearAllPoints()
    tex:SetPoint("TOPLEFT", child, "TOPLEFT", 2 + (i - 1) * 13, -y)
  end
  self.dgScore:ClearAllPoints()
  self.dgScore:SetPoint("TOPLEFT", child, "TOPLEFT", count > 0 and 44 or 2, -y)
  if item.todo > 0 then
    self.dgScore:SetFormattedText(L.DUNGEON_SCORE, item.todo, item.now)
  else
    self.dgScore:SetText(L.DUNGEON_SCORE_NONE)
  end
  self.dgScore:Show()
  y = y + math.max(14, self.dgScore:GetStringHeight() or 12) + 8
  -- quêtes
  local P = Q.UI.DungeonPopup
  local nChain, nLine = 0, 0
  local boxW = DG_DETAIL_W - 14
  local inner = boxW - 14
  -- quêtes débloquées par une même suite : un seul encadré, à la place de la première, qui les nomme toutes
  local function isSuite(c) return type(c) == "table" and not c.reason and (tonumber(c.count) or 0) > 0 and c.sig end
  local bySig = {}
  for _, r in ipairs(item.details) do
    if isSuite(r.chain) then
      bySig[r.chain.sig] = bySig[r.chain.sig] or {}
      table.insert(bySig[r.chain.sig], r)
    end
  end
  local function box(r, chain, rows)
    nChain = nChain + 1
    local w = dgChain(nChain)
    w.box.row, w.add.row, w.info.row = r, r, r
    w.box.rows = rows
    w.text:SetWidth(inner)
    w.text:SetText(chainBoxText(chain, rows))
    local textH = w.text:GetStringHeight() or 12
    local buttonsH = 0
    if chain.reason then
      w.add:Hide()
      w.info:Hide()
    else
      w.add:SetText(chain.chosen and L.DUNGEON_CHAIN_REMOVE or L.DUNGEON_CHAIN_ADD)
      local wi, wa = fitButton(w.info, inner), fitButton(w.add, inner)
      w.info:ClearAllPoints()
      w.add:ClearAllPoints()
      w.info:SetPoint("TOPLEFT", w.box, "TOPLEFT", 7, -(textH + 12))
      if wi + 4 + wa <= inner then
        w.add:SetPoint("LEFT", w.info, "RIGHT", 4, 0)
        buttonsH = 24
      else
        -- trop étroit côte à côte : l'un sous l'autre
        w.add:SetPoint("TOPLEFT", w.info, "BOTTOMLEFT", 0, -3)
        buttonsH = 47
      end
      w.info:Show()
      w.add:Show()
    end
    local boxH = textH + 14 + buttonsH
    w.box:ClearAllPoints()
    w.box:SetPoint("TOPLEFT", child, "TOPLEFT", 8, -y)
    w.box:SetSize(boxW, boxH)
    w.box:Show()
    y = y + boxH + 6
  end
  for _, r in ipairs(item.details) do
    local chain = type(r.chain) == "table" and r.chain or nil
    if isSuite(chain) then
      local rows = bySig[chain.sig]
      if rows[1] == r then box(r, chain, rows) end
    else
      nLine = nLine + 1
      local fs = dgLine(nLine)
      local prefix = r.done and "|TInterface\\RaidFrame\\ReadyCheck-Ready:12:12|t " or "- "
      fs:SetText(prefix .. P.QuestLine(r, chain and { box = true } or nil))
      fs:ClearAllPoints()
      fs:SetPoint("TOPLEFT", child, "TOPLEFT", 4, -y)
      fs:Show()
      y = y + (fs:GetStringHeight() or 12) + 4
      -- quête sans suite : niveau seul, ou suite hors de portée (raison, sans bouton)
      if chain then box(r, chain, { r }) end
    end
  end
  for i = nLine + 1, #(self.dgLines or {}) do self.dgLines[i]:Hide() end
  for i = nChain + 1, #(self.dgChains or {}) do self.dgChains[i].box:Hide() end
  -- actions
  y = y + 6
  local canAdd = state == "available" or state == "upcoming" or state == "past" or state == "ignored"
  local canIgnore = state == "available" or state == "upcoming" or state == "past" or state == "added"
  local x = 2
  for _, pair in ipairs({ { self.dgAdd, canAdd }, { self.dgUnignore, state == "ignored" }, { self.dgIgnore, canIgnore } }) do
    local b, shown = pair[1], pair[2]
    b:ClearAllPoints()
    if shown then
      b:SetPoint("TOPLEFT", child, "TOPLEFT", x, -y)
      b:Show()
      x = x + b:GetWidth() + 6
    else
      b:Hide()
    end
  end
  child:SetHeight(math.max(1, y + 28))
end

function Journal:RefreshDungeonTab()
  if not self.frame or not self.dgChild then return end
  local qdbOk = Q.QDB and Q.QDB:IsAvailable()
  local items = qdbOk and dungeonItems() or nil
  local sort = self.dungeonSort or "level"
  for key, b in pairs(self.dgSortButtons) do
    if key == sort then b.text:SetTextColor(1, 0.82, 0) else b.text:SetTextColor(0.6, 0.6, 0.6) end
  end
  local groups = items and Journal.DungeonGroups(items, sort) or {}
  -- sélection : celle d'avant si le donjon est encore là, sinon le premier conseillé, sinon le premier
  local selected, first
  for _, g in ipairs(groups) do
    for _, it in ipairs(g.items) do
      first = first or it
      if it.dungeon.key == self.dungeonSel then selected = it end
    end
  end
  selected = selected or first
  self.dungeonSel = selected and selected.dungeon.key or nil

  local child, y, nh, nr = self.dgChild, 0, 0, 0
  for _, g in ipairs(groups) do
    nh = nh + 1
    local h = dgHeader(nh)
    h:SetText(L[DG_GROUP_TEXT[g.key]])
    h:ClearAllPoints()
    h:SetPoint("TOPLEFT", child, "TOPLEFT", 4, -(y + 6))
    h:Show()
    y = y + DG_HEAD_H
    for _, it in ipairs(g.items) do
      nr = nr + 1
      local row = dgRow(nr)
      row.item = it
      row:ClearAllPoints()
      row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -y)
      setStars(row.stars, Journal.DungeonStars(it.todo))
      row.name:SetText(Q.UI.DungeonPopup.DungeonName(it.dungeon))
      row.levels:SetFormattedText(L.UI_TRACKER_LEVELS, tonumber(it.dungeon.minLevel) or 1, tonumber(it.dungeon.maxLevel) or 60)
      local isSel = it == selected
      if isSel then row.selected:Show() else row.selected:Hide() end
      if isSel then
        row.name:SetTextColor(1, 0.82, 0)
      elseif g.key == "now" then
        row.name:SetTextColor(1, 1, 1)
      else
        row.name:SetTextColor(0.6, 0.6, 0.6)
      end
      if it.state == "added" then row.routeDot:Show() else row.routeDot:Hide() end
      row:Show()
      y = y + DG_ROW_H
    end
  end
  for i = nh + 1, #(self.dgHeaders or {}) do self.dgHeaders[i]:Hide() end
  for i = nr + 1, #(self.dgRows or {}) do
    self.dgRows[i].item = nil
    self.dgRows[i]:Hide()
  end
  child:SetHeight(math.max(1, y))

  if not qdbOk then
    self.dgEmpty:SetText(Q.QDB and Q.QDB.Status and Q.QDB:Status() == "old" and L.QUESTIEDB_TOO_OLD
      or L.NEED_QUESTIEDB)
    self.dgEmpty:Show()
  elseif nr == 0 then
    self.dgEmpty:SetText(L.DUNGEON_EMPTY)
    self.dgEmpty:Show()
  else
    self.dgEmpty:Hide()
  end
  self:ShowDungeonDetail(selected)
end

---------------------------------------------------------------------------
-- Export des mesures (ancien onglet Options) : dans la fenêtre d'options, section Outils.
---------------------------------------------------------------------------
function Journal:ShowExport()
  if Q.UI.Options then return Q.UI.Options:ShowTelemetryExport() end
end

---------------------------------------------------------------------------
-- Messages
---------------------------------------------------------------------------
Q:On("PROGRESS_UPDATED", function()
  refreshIfShown("route", false)
  refreshIfShown("dungeons")
end)
Q:On("GUIDE_CHANGED", function() refreshIfShown("route", true) end)
Q:On("STEP_CHANGED", function() refreshIfShown("route", true) end)
Q:On("CLASSQUESTS_CHANGED", function() refreshIfShown("class") end)
Q:On("DUNGEONS_CHANGED", function() refreshIfShown("dungeons") end)
Q:On("DETOUR_CHANGED", function() if Journal:IsShown() then Journal:UpdateDetourButton() end end)
