local addonName, Q = ...

-- Fenêtre du mode « Donjons » (/qf donjons, bouton des options) : choix du mode pour le personnage, puis
-- une ligne par échelon (donjon ou aile) dans l'ordre joué : case à cocher, étoiles, nom, niveau d'entrée,
-- quêtes rendues, et bouton « Contourner » pour sauter l'instance en gardant les quêtes prises.
-- Tout l'état est dans Engine/DungeonMode.lua ; la fenêtre ne fait qu'afficher et transmettre.
Q.UI = Q.UI or {}
local Panel = { rows = {} }
Q.UI.DungeonModePanel = Panel

local L = Q.L

local FRAME_NAME = "QuestifyDungeonModePanel"
local WIDTH, ROW_H, TOP = 470, 18, 150
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
  return lines
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

local function newCheck(parent)
  seq = seq + 1
  local cb = CreateFrame("CheckButton", FRAME_NAME .. "Check" .. seq, parent, "UICheckButtonTemplate")
  cb:SetSize(20, 20)
  return cb
end

function Panel:Create()
  if self.frame then return self.frame end
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "ButtonFrameTemplate")
  if not ok or not f then f = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate") end
  self.frame = f
  f:SetSize(WIDTH, 300)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 20)
  f:SetFrameStrata("DIALOG")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  if f.SetTitle then f:SetTitle(L.DGMODE_TITLE) end
  if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, "Interface\\Icons\\INV_Misc_Key_14") end
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end

  local enable = newCheck(f)
  enable:SetPoint("TOPLEFT", f, "TOPLEFT", 64, -32)
  enable:SetScript("OnClick", safe(function(btn)
    Q.DungeonMode:SetOn(btn:GetChecked() and true or false)
    Panel:Refresh()
  end))
  self.enable = enable
  local enableText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  enableText:SetPoint("LEFT", enable, "RIGHT", 2, 0)
  enableText:SetJustifyH("LEFT")
  enableText:SetText(L.DGMODE_ENABLE)
  self.enableText = enableText

  local help = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  help:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -68)
  help:SetWidth(WIDTH - 32)
  help:SetJustifyH("LEFT")
  help:SetWordWrap(true)
  self.help = help

  local function button(text, width)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
    b:SetSize(width, 20)
    b:SetText(text)
    return b
  end
  local all = button(L.DGMODE_ALL, 110)
  all:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -(TOP - 26))
  all:SetScript("OnClick", safe(function() Panel:SetAll(true) end))
  self.allButton = all
  local none = button(L.DGMODE_NONE, 110)
  none:SetPoint("LEFT", all, "RIGHT", 6, 0)
  none:SetScript("OnClick", safe(function() Panel:SetAll(false) end))
  self.noneButton = none

  f:Hide()
  return f
end

local function row(i)
  local r = Panel.rows[i]
  if r then return r end
  local f = Panel.frame
  r = CreateFrame("Frame", nil, f)
  r:SetSize(WIDTH - 32, ROW_H)
  r:EnableMouse(true)
  r:SetScript("OnEnter", safe(function(self) if self.rung then showTip(self, Panel.RungTip(self.rung)) end end))
  r:SetScript("OnLeave", hideTip)
  local cb = newCheck(r)
  cb:SetPoint("LEFT", r, "LEFT", 0, 0)
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
    tex:SetPoint("LEFT", r, "LEFT", 24 + (s - 1) * 10, 0)
    r.stars[s] = tex
  end
  local name = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  name:SetPoint("LEFT", r, "LEFT", 60, 0)
  name:SetWidth(190)
  name:SetJustifyH("LEFT")
  name:SetWordWrap(false)
  r.name = name
  local level = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  level:SetPoint("LEFT", r, "LEFT", 254, 0)
  level:SetWidth(44)
  level:SetJustifyH("LEFT")
  r.level = level
  local quests = r:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  quests:SetPoint("LEFT", r, "LEFT", 300, 0)
  quests:SetWidth(36)
  quests:SetJustifyH("LEFT")
  r.quests = quests
  local bypass = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
  bypass:SetSize(96, 16)
  bypass:SetPoint("RIGHT", r, "RIGHT", 0, 0)
  bypass:SetScript("OnClick", safe(function(btn)
    local key = btn:GetParent().key
    if key then Q.DungeonMode:SetBypassed(key, not Q.DungeonMode:IsBypassed(key)) end
    Panel:Refresh()
  end))
  bypass:SetScript("OnEnter", safe(function(self) showTip(self, { L.DGMODE_BYPASS, L.DGMODE_BYPASS_TIP }) end))
  bypass:SetScript("OnLeave", hideTip)
  r.bypass = bypass
  Panel.rows[i] = r
  return r
end

-- Coche ou décoche tous les échelons.
function Panel:SetAll(checked)
  local D = Q.DungeonMode
  for _, it in ipairs(D:Rungs()) do
    if (it.state ~= "off") ~= checked then D:SetChecked(it.key, checked) end
  end
  self:Refresh()
end

function Panel:Refresh()
  if not self.frame then return end
  local D = Q.DungeonMode
  local available = D:Available()
  self.enable:SetChecked(D:IsOn())
  if available then self.enable:Enable() else self.enable:Disable() end
  self.help:SetText((available and "" or (L.DGMODE_UNAVAILABLE .. "\n")) .. L.DGMODE_HELP .. "\n" .. L.DGMODE_STARS_HELP)
  local items = D:Rungs()
  for i, it in ipairs(items) do
    local r = row(i)
    local rung = it.rung
    r.key, r.rung = it.key, rung
    r:ClearAllPoints()
    r:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 16, -(TOP + (i - 1) * ROW_H))
    r.check:SetChecked(it.state ~= "off")
    setStars(r.stars, it.stars)
    r.name:SetText(Panel.RungName(rung))
    if it.state == "off" then r.name:SetTextColor(0.5, 0.5, 0.5) else r.name:SetTextColor(1, 1, 1) end
    r.level:SetFormattedText(L.DGMODE_ROW_LEVEL, tonumber(rung.entry) or 1)
    if it.total > 0 then r.quests:SetFormattedText(L.DGMODE_ROW_QUESTS, it.done, it.total) else r.quests:SetText("") end
    if it.state == "off" then
      r.bypass:Hide()
    else
      r.bypass:SetText(it.state == "bypassed" and L.DGMODE_RESUME or L.DGMODE_BYPASS)
      r.bypass:Show()
    end
    r:Show()
  end
  for i = #items + 1, #self.rows do self.rows[i]:Hide() end
  self.frame:SetHeight(TOP + #items * ROW_H + 16)
end

function Panel:Show()
  self:Create()
  self:Refresh()
  self.frame:Show()
  self.frame:Raise()
end

function Panel:Hide()
  if self.frame then self.frame:Hide() end
end

function Panel:Toggle()
  if self.frame and self.frame:IsShown() then self:Hide() else self:Show() end
end

Q:On("DUNGEON_MODE_CHANGED", function()
  if Panel.frame and Panel.frame:IsShown() then Panel:Refresh() end
end)
