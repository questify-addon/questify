local addonName, Q = ...

-- Vue « Automatique » de l'onglet Route du journal (UI/Journal.lua) : le parcours complet avec les donjons
-- (Engine/DungeonMode.lua). De haut en bas : un gros bouton centré qui lance ou arrête le mode, puis une
-- liste défilante : le sous-menu repliable des donjons (une case et des étoiles par donjon ou par aile ; un
-- donjon décoché est sauté) et l'aperçu des zones à explorer, dans l'ordre.
-- Tout l'état est dans Engine/DungeonMode.lua ; la vue ne fait qu'afficher et transmettre.
Q.UI = Q.UI or {}
local Panel = { rows = {}, zoneRows = {}, dungeonsOpen = false }
Q.UI.DungeonModePanel = Panel

local L = Q.L

local NAME = "QuestifyJournalAuto"
local WIDTH, LIST_W, LIST_H, ROW_H = 500, 462, 352, 18
local LIST_TOP = 104
local STAR_ON, STAR_OFF = "tradeskills-star", "tradeskills-star-off"
local STAR_FALLBACK = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"
local seq = 0

local function safe(fn)
  return function(...) return Q.SafeCall(fn, ...) end
end

-- Nom affiché d'un échelon : nom du donjon dans la langue du client, suivi de l'aile.
function Panel.RungName(r)
  local name = Q.Dungeons and Q.Dungeons.Name and Q.Dungeons:Name(r) or tostring(r.name or r.key)
  if r.wing then
    local wing = rawget(L, "DGMODE_WING_" .. tostring(r.wing)) or tostring(r.wing)
    return string.format(L.DGMODE_ROW_WING, name, wing)
  end
  return name
end

-- Lignes d'infobulle d'un échelon : nom, plage, XP de quêtes.
function Panel.RungTip(r)
  local lines = { Panel.RungName(r),
    string.format(L.DGMODE_ROW_TIP_RANGE, tonumber(r.minLevel) or 1, tonumber(r.maxLevel) or 60) }
  if type(r.quests) ~= "table" or #r.quests == 0 then
    lines[#lines + 1] = L.DGMODE_ROW_TIP_NOQUEST
  else
    local pct = math.floor((tonumber(r.pct) or 0) * 100 + 0.5)
    lines[#lines + 1] = string.format(r.est and L.DGMODE_ROW_TIP_XP_EST or L.DGMODE_ROW_TIP_XP,
      tonumber(r.xp) or 0, pct, tonumber(r.entry) or 1)
  end
  lines[#lines + 1] = L.DGMODE_STARS_HELP
  return lines
end

-- Texte d'une zone de l'aperçu : -> niveaux, nom, précision (donjons faits à la fin, ou « si besoin »).
function Panel.ZoneText(item)
  local g = item.guide
  local detail = ""
  if item.alt then
    detail = L.DGMODE_ZONE_ALT
  elseif #item.runs > 0 then
    local names = {}
    for _, key in ipairs(item.runs) do
      local r = Q.DungeonMode:Rung(key)
      if r and Q.DungeonMode:IsChecked(key) then names[#names + 1] = Panel.RungName(r) end
    end
    detail = table.concat(names, ", ")
  end
  return string.format(L.DGMODE_ZONE_LEVELS, tonumber(g.minLevel) or 1, tonumber(g.maxLevel) or 60),
    Q.Guides:DisplayTitle(g), detail
end

local function showTip(owner, lines)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:ClearLines()
  for i, line in ipairs(lines) do
    if i == 1 then GameTooltip:AddLine(line, 1, 0.82, 0, true) else GameTooltip:AddLine(line, 1, 1, 1, true) end
  end
  GameTooltip:Show()
end

local function hideTip()
  if GameTooltip then GameTooltip:Hide() end
end

-- Étoiles pleines puis éteintes (grisées et pâles, quel que soit le dessin) ; aucune quand count vaut 0.
local function setStars(stars, count)
  for i, tex in ipairs(stars) do
    local on = i <= count
    if Q.Util.HasAtlas(on and STAR_ON or STAR_OFF) then
      tex:SetAtlas(on and STAR_ON or STAR_OFF)
    else
      tex:SetTexture(STAR_FALLBACK)
    end
    tex:SetDesaturated(not on)
    tex:SetAlpha(on and 1 or 0.25)
    if count > 0 then tex:Show() else tex:Hide() end
  end
end

local function button(parent, text, width, height)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width, height)
  b:SetText(text)
  return b
end

-- Build(parent) : construit la vue dans le panneau « Automatique » du journal.
function Panel:Build(parent)
  if self.parent then return end
  self.parent = parent

  local help = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  help:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -4)
  help:SetWidth(WIDTH - 20)
  help:SetJustifyH("LEFT")
  help:SetWordWrap(true)
  self.help = help

  -- lance ou arrête le mode : même style que « Tout cocher », plus gros et centré
  local start = button(parent, L.DGMODE_START, 240, 30)
  start:SetPoint("TOP", parent, "TOP", 0, -46)
  start:SetScript("OnClick", safe(function()
    Q.DungeonMode:SetOn(not Q.DungeonMode:IsOn())
    Panel:Refresh()
  end))
  self.startButton = start
  local status = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  status:SetPoint("TOP", start, "BOTTOM", 0, -4)
  status:SetWidth(WIDTH - 20)
  status:SetJustifyH("CENTER")
  self.status = status

  local scroll = CreateFrame("ScrollFrame", NAME .. "Scroll", parent, "UIPanelScrollFrameTemplate")
  scroll:SetSize(LIST_W, LIST_H)
  scroll:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -LIST_TOP)
  local child = CreateFrame("Frame", nil, scroll)
  child:SetSize(LIST_W, 1)
  scroll:SetScrollChild(child)
  self.scroll, self.child = scroll, child

  -- sous-menu des donjons : en-tête repliable, puis « Tout cocher » / « Tout décocher » et les lignes
  local fold = CreateFrame("Button", nil, child)
  fold:SetSize(LIST_W, 20)
  fold:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  local foldText = fold:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  foldText:SetPoint("LEFT", fold, "LEFT", 4, 0)
  foldText:SetJustifyH("LEFT")
  fold.text = foldText
  fold:SetScript("OnClick", safe(function()
    Panel.dungeonsOpen = not Panel.dungeonsOpen
    Panel:Refresh()
  end))
  self.fold = fold
  local all = button(child, L.DGMODE_ALL, 120, 20)
  all:SetScript("OnClick", safe(function() Panel:SetAll(true) end))
  self.allButton = all
  local none = button(child, L.DGMODE_NONE, 120, 20)
  none:SetPoint("LEFT", all, "RIGHT", 6, 0)
  none:SetScript("OnClick", safe(function() Panel:SetAll(false) end))
  self.noneButton = none

  local zones = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  zones:SetJustifyH("LEFT")
  zones:SetText(L.DGMODE_ZONES)
  self.zonesHeader = zones
end

local function row(i)
  local r = Panel.rows[i]
  if r then return r end
  r = CreateFrame("Frame", nil, Panel.child)
  r:SetSize(LIST_W, ROW_H)
  r:EnableMouse(true)
  r:SetScript("OnEnter", safe(function(self) if self.rung then showTip(self, Panel.RungTip(self.rung)) end end))
  r:SetScript("OnLeave", hideTip)
  seq = seq + 1
  local cb = CreateFrame("CheckButton", NAME .. "Check" .. seq, r, "UICheckButtonTemplate")
  cb:SetSize(20, 20)
  cb:SetPoint("LEFT", r, "LEFT", 12, 0)
  cb:SetScript("OnClick", safe(function(btn)
    local key = btn:GetParent().key
    if key then Q.DungeonMode:SetChecked(key, btn:GetChecked() and true or false) end
    Panel:Refresh()
  end))
  r.check = cb
  r.stars = {}
  for s = 1, 3 do
    local tex = r:CreateTexture(nil, "ARTWORK")
    tex:SetSize(10, 10)
    tex:SetPoint("LEFT", r, "LEFT", 36 + (s - 1) * 10, 0)
    r.stars[s] = tex
  end
  local name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  name:SetPoint("LEFT", r, "LEFT", 72, 0)
  name:SetWidth(250)
  name:SetJustifyH("LEFT")
  name:SetWordWrap(false)
  r.name = name
  local level = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  level:SetPoint("LEFT", r, "LEFT", 330, 0)
  level:SetWidth(60)
  level:SetJustifyH("LEFT")
  r.level = level
  local quests = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  quests:SetPoint("LEFT", r, "LEFT", 396, 0)
  quests:SetWidth(60)
  quests:SetJustifyH("LEFT")
  r.quests = quests
  Panel.rows[i] = r
  return r
end

local function zoneRow(i)
  local r = Panel.zoneRows[i]
  if r then return r end
  r = CreateFrame("Frame", nil, Panel.child)
  r:SetSize(LIST_W, ROW_H)
  local level = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  level:SetPoint("LEFT", r, "LEFT", 12, 0)
  level:SetWidth(52)
  level:SetJustifyH("LEFT")
  r.level = level
  local name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  name:SetPoint("LEFT", r, "LEFT", 66, 0)
  name:SetWidth(176)
  name:SetJustifyH("LEFT")
  name:SetWordWrap(false)
  r.name = name
  local detail = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  detail:SetPoint("LEFT", r, "LEFT", 246, 0)
  detail:SetWidth(LIST_W - 250)
  detail:SetJustifyH("LEFT")
  detail:SetWordWrap(false)
  r.detail = detail
  Panel.zoneRows[i] = r
  return r
end

-- Coche ou décoche tous les donjons.
function Panel:SetAll(checked)
  local D = Q.DungeonMode
  for _, it in ipairs(D:Rungs()) do
    if (it.state ~= "off") ~= checked then D:SetChecked(it.key, checked) end
  end
  self:Refresh()
end

function Panel:Refresh()
  if not self.parent then return end
  local D = Q.DungeonMode
  local on = D:IsOn()
  self.help:SetText(L.DGMODE_HELP)
  self.startButton:SetText(on and L.DGMODE_STOP or L.DGMODE_START)
  if D:Available() then self.startButton:Enable() else self.startButton:Disable() end
  self.status:SetText(not D:Available() and L.DGMODE_UNAVAILABLE or on and L.DGMODE_STATUS_ON or L.DGMODE_STATUS_OFF)

  local child, y = self.child, 0
  local function place(region, x, h)
    region:ClearAllPoints()
    region:SetPoint("TOPLEFT", child, "TOPLEFT", x, -y)
    region:Show()
    y = y + h
  end

  -- donjons
  local items = D:Rungs()
  local ticked = 0
  for _, it in ipairs(items) do if it.state ~= "off" then ticked = ticked + 1 end end
  self.fold.text:SetFormattedText(self.dungeonsOpen and L.DGMODE_FOLD_OPEN or L.DGMODE_FOLD_CLOSED, ticked, #items)
  place(self.fold, 0, 24)
  if self.dungeonsOpen then
    place(self.allButton, 12, 26)
    self.noneButton:Show()
    for i, it in ipairs(items) do
      local r = row(i)
      local rung = it.rung
      r.key, r.rung = it.key, rung
      r.check:SetChecked(it.state ~= "off")
      setStars(r.stars, it.stars)
      r.name:SetText(Panel.RungName(rung))
      if it.state == "off" then r.name:SetTextColor(0.5, 0.5, 0.5) else r.name:SetTextColor(1, 1, 1) end
      r.level:SetFormattedText(L.DGMODE_ROW_LEVEL, tonumber(rung.entry) or 1)
      if it.total > 0 then r.quests:SetFormattedText(L.DGMODE_ROW_QUESTS, it.done, it.total) else r.quests:SetText("") end
      place(r, 0, ROW_H)
    end
    for i = #items + 1, #self.rows do self.rows[i]:Hide() end
    y = y + 8
  else
    self.allButton:Hide()
    self.noneButton:Hide()
    for _, r in ipairs(self.rows) do r:Hide() end
  end

  -- zones à explorer, dans l'ordre
  place(self.zonesHeader, 4, 22)
  local chain = D:Chain()
  local current = on and Q.Progress and Q.Progress:Guide() or nil
  for i, item in ipairs(chain) do
    local r = zoneRow(i)
    local levels, name, detail = Panel.ZoneText(item)
    r.level:SetText(levels)
    r.name:SetText(name)
    r.detail:SetText(detail)
    if current and item.guide == current then
      r.name:SetTextColor(1, 0.82, 0)
    elseif item.alt then
      r.name:SetTextColor(0.6, 0.6, 0.6)
    else
      r.name:SetTextColor(1, 1, 1)
    end
    place(r, 0, ROW_H)
  end
  for i = #chain + 1, #self.zoneRows do self.zoneRows[i]:Hide() end
  child:SetHeight(math.max(1, y + 8))
end

-- Ouvre le journal sur l'onglet Route, vue « Automatique » (/qf donjons, bouton des options).
function Panel:Show()
  local J = Q.UI.Journal
  if J and J.ShowRouteMode then J:ShowRouteMode("auto") end
end

Q:On("DUNGEON_MODE_CHANGED", function()
  local J = Q.UI.Journal
  if J and J.IsShown and J:IsShown() and J.tab == "route" then J:RefreshRoute(false) end
end)
