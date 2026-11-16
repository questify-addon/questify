local addonName, Q = ...

-- Assistant « Anciens rangs sur tes barres » (maquette docs/superpowers/specs/2026-11-16-maitre-de-classe-maquette.html, B).
-- S'ouvre quand Engine/ActionRanks.lua trouve, après un achat chez le maître, des boutons d'action qui
-- portent un rang plus bas qu'un rang appris (message RANKS_PENDING).
--   en haut : l'icône de chaque sort restant (clic : aller à ce sort), puis un séparateur ;
--   un sort à la fois : flèches ‹ › pour passer d'un sort à l'autre, icône, nom, « Rang 3 sur tes barres,
--   rang 4 appris », emplacements ; « 1 / 3 » ;
--   quatre choix : Modifier <sort> rang N, Ignorer <sort> rang N, Appliquer tous, Ignorer tous.
-- Un sort traité sort de l'assistant ; Appliquer tous et Ignorer tous ne portent que sur les sorts restants.
-- En combat, les choix attendent la fin du combat (ligne d'avertissement). Couleurs : thème du suivi.
Q.UI = Q.UI or {}
local Wizard = { icons = {}, cur = 1 }
Q.UI.RanksWizard = Wizard

local L = Q.L

local WIDTH = 350
local PAD = 12
local SMALL = 26
local MAX_ICONS = 10
local BIG = 40
local BTN_W = (WIDTH - 2 * PAD - 6) / 2
local BTN_H = 34
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local BAD = { 0.85, 0.15, 0.15 }

local function R() return Q.ActionRanks end
local function theme() return Q.Themes:Current() end
local function style(fs, role) Q.Themes:StyleText(fs, role, theme()) end

local function text(parent, template, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlight")
  fs:SetJustifyH(justify or "LEFT")
  return fs
end

local function button(parent, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(BTN_W, BTN_H)
  local fs = b.GetFontString and b:GetFontString()
  if fs then
    fs:SetWidth(BTN_W - 12)
    fs:SetWordWrap(true)
    if fs.SetFontObject and GameFontNormalSmall then fs:SetFontObject(GameFontNormalSmall) end
  end
  b:SetScript("OnClick", function() Q.SafeCall(onClick) end)
  return b
end

local function arrow(parent, dir, onClick)
  local b = CreateFrame("Button", nil, parent)
  b:SetSize(24, 24)
  local base = dir < 0 and "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-" or "Interface\\Buttons\\UI-SpellbookIcon-NextPage-"
  b:SetNormalTexture(base .. "Up")
  b:SetPushedTexture(base .. "Down")
  b:SetDisabledTexture(base .. "Disabled")
  b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
  b:SetScript("OnClick", function() Q.SafeCall(onClick) end)
  return b
end

local function current()
  local list = R() and R():Pending() or {}
  if #list == 0 then return nil, list end
  if Wizard.cur > #list then Wizard.cur = #list end
  if Wizard.cur < 1 then Wizard.cur = 1 end
  return list[Wizard.cur], list
end

local function spellTooltip(owner, id)
  if not (GameTooltip and id) then return end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  if GameTooltip.SetSpellByID then GameTooltip:SetSpellByID(id) end
  GameTooltip:Show()
end

local function hideTooltip() if GameTooltip then GameTooltip:Hide() end end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function smallIcon(i)
  local b = Wizard.icons[i]
  if b then return b end
  b = CreateFrame("Button", nil, Wizard.frame)
  b:SetSize(SMALL, SMALL)
  b.tex = b:CreateTexture(nil, "ARTWORK")
  b.tex:SetAllPoints(b)
  b.mark = b:CreateTexture(nil, "OVERLAY")
  b.mark:SetTexture("Interface\\Buttons\\CheckButtonHilight")
  b.mark:SetBlendMode("ADD")
  b.mark:SetAllPoints(b)
  b:SetScript("OnClick", function(self)
    Wizard.cur = self.index
    Q.SafeCall(Wizard.Refresh, Wizard)
  end)
  b:SetScript("OnEnter", function(self) Q.SafeCall(spellTooltip, self, self.spellId) end)
  b:SetScript("OnLeave", hideTooltip)
  Wizard.icons[i] = b
  return b
end

function Wizard:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyRanksWizard", UIParent, "BackdropTemplate")
  self.frame = f
  f:SetSize(WIDTH, 260)
  f:SetPoint("TOP", UIParent, "TOP", 0, -140)
  f:SetFrameStrata("DIALOG")
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  if UISpecialFrames then tinsert(UISpecialFrames, "QuestifyRanksWizard") end

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
  close:SetScript("OnClick", function() Wizard:Hide() end)
  self.closeButton = close

  local ring = f:CreateTexture(nil, "ARTWORK")
  ring:SetSize(36, 36)
  ring:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
  self.ring = ring
  local kick = text(f, "GameFontDisableSmall")
  kick:SetPoint("TOPLEFT", ring, "TOPRIGHT", 8, -2)
  kick:SetText(L.RANKS_KICK:upper())
  self.kick = kick
  local title = text(f, "GameFontNormalLarge")
  title:SetPoint("BOTTOMLEFT", ring, "BOTTOMRIGHT", 8, 2)
  self.title = title

  local sep = f:CreateTexture(nil, "ARTWORK")
  sep:SetHeight(1)
  self.sep = sep

  self.prev = arrow(f, -1, function() Wizard:Step(-1) end)
  self.next = arrow(f, 1, function() Wizard:Step(1) end)
  local big = CreateFrame("Button", nil, f)
  big:SetSize(BIG, BIG)
  big.tex = big:CreateTexture(nil, "ARTWORK")
  big.tex:SetAllPoints(big)
  big:SetScript("OnEnter", function(self) Q.SafeCall(spellTooltip, self, self.spellId) end)
  big:SetScript("OnLeave", hideTooltip)
  self.big = big
  local name = text(f, "GameFontNormal")
  name:SetWidth(WIDTH - 2 * PAD - 2 * 24 - BIG - 24)
  name:SetWordWrap(false)
  self.name = name
  local rank = text(f, "GameFontHighlightSmall")
  rank:SetWidth(WIDTH - 2 * PAD - 2 * 24 - BIG - 24)
  self.rank = rank
  local slots = text(f, "GameFontDisableSmall")
  slots:SetWidth(WIDTH - 2 * PAD - 2 * 24 - BIG - 24)
  slots:SetWordWrap(true)
  self.slots = slots
  local pos = text(f, "GameFontDisableSmall", "CENTER")
  self.pos = pos

  self.applyButton = button(f, function()
    local e = current()
    if e then R():Apply(e.id) end
  end)
  self.ignoreButton = button(f, function()
    local e = current()
    if e then R():Ignore(e.id) end
  end)
  self.applyAllButton = button(f, function() R():ApplyAll() end)
  self.ignoreAllButton = button(f, function() R():IgnoreAll() end)

  local combat = text(f, "GameFontHighlightSmall")
  combat:SetWidth(WIDTH - 2 * PAD)
  combat:SetWordWrap(true)
  combat:SetText(L.RANKS_COMBAT_NOTE)
  self.combat = combat

  f:Hide()
  return f
end

local function place(region, y, x)
  region:ClearAllPoints()
  region:SetPoint("TOPLEFT", Wizard.frame, "TOPLEFT", PAD + (x or 0), -y)
end

---------------------------------------------------------------------------
-- Affichage
---------------------------------------------------------------------------
function Wizard:Step(delta)
  local _, list = current()
  local n = self.cur + delta
  if n < 1 or n > #list then return end
  self.cur = n
  self:Refresh()
end

-- Refresh() : redessine l'assistant ; fermé quand il ne reste rien. -> nombre de sorts restants.
function Wizard:Refresh()
  local f = self.frame
  if not f then return 0 end
  local e, list = current()
  if not e then
    f:Hide()
    return 0
  end
  local th = Q.Themes:Apply(f, theme().key, 1)
  local sepColor = Q.Themes:TextColor("dim", th)
  style(self.kick, "dim")
  style(self.title, "title")
  self.title:SetText(#list == 1 and L.RANKS_TITLE_ONE or string.format(L.RANKS_TITLE, #list))
  self.ring:SetTexture(e.icon or FALLBACK_ICON)

  local y = PAD + 36 + 8
  local shown = math.min(#list, MAX_ICONS)
  for i = 1, shown do
    local b = smallIcon(i)
    local s = list[i]
    b.index, b.spellId = i, s.id
    b.tex:SetTexture(s.icon or FALLBACK_ICON)
    b.tex:SetAlpha(i == self.cur and 1 or 0.6)
    b.mark:SetShown(i == self.cur)
    place(b, y, (i - 1) * (SMALL + 5))
    b:Show()
  end
  for i = shown + 1, #self.icons do self.icons[i]:Hide() end
  y = y + SMALL + 6
  self.sep:ClearAllPoints()
  self.sep:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
  self.sep:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, -y)
  self.sep:SetColorTexture(sepColor[1], sepColor[2], sepColor[3], 0.5)
  y = y + 9

  place(self.prev, y + (BIG - 24) / 2)
  self.prev:SetEnabled(self.cur > 1)
  place(self.big, y, 24 + 6)
  self.big.tex:SetTexture(e.icon or FALLBACK_ICON)
  self.big.spellId = e.id
  local tx = 24 + 6 + BIG + 8
  self.name:SetText(e.name or "?")
  style(self.name, "title")
  place(self.name, y, tx)
  self.rank:SetFormattedText(L.RANKS_STEP_RANK, e.have, e.best)
  style(self.rank, "body")
  place(self.rank, y + 16, tx)
  local nSlots = #e.slots
  self.slots:SetText(string.format(nSlots == 1 and L.RANKS_STEP_SLOTS_ONE or L.RANKS_STEP_SLOTS, nSlots,
    R().SlotsText(e.slots)))
  style(self.slots, "dim")
  place(self.slots, y + 30, tx)
  self.next:ClearAllPoints()
  self.next:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, -(y + (BIG - 24) / 2))
  self.next:SetEnabled(self.cur < #list)
  local textH = 30 + math.max(14, self.slots:GetStringHeight() or 14)
  y = y + math.max(BIG, textH) + 4
  self.pos:SetFormattedText(L.RANKS_POS, self.cur, #list)
  style(self.pos, "dim")
  self.pos:ClearAllPoints()
  self.pos:SetPoint("TOP", f, "TOP", 0, -y)
  y = y + 16

  self.applyButton:SetText(string.format(L.RANKS_APPLY_ONE, e.name or "?", e.have))
  self.ignoreButton:SetText(string.format(L.RANKS_IGNORE_ONE, e.name or "?", e.have))
  self.applyAllButton:SetText(string.format(L.RANKS_APPLY_ALL, #list))
  self.ignoreAllButton:SetText(string.format(L.RANKS_IGNORE_ALL, #list))
  place(self.applyButton, y)
  place(self.ignoreButton, y, BTN_W + 6)
  y = y + BTN_H + 4
  place(self.applyAllButton, y)
  place(self.ignoreAllButton, y, BTN_W + 6)
  y = y + BTN_H

  if R():InCombat() then
    y = y + 6
    place(self.combat, y)
    self.combat:SetTextColor(BAD[1], BAD[2], BAD[3], 1)
    self.combat:Show()
    y = y + (self.combat:GetStringHeight() or 14)
  else
    self.combat:Hide()
  end
  f:SetHeight(y + PAD)
  return #list
end

function Wizard:Show()
  self:Create()
  self.cur = 1
  self.frame:Show()
  if self:Refresh() == 0 then return false end
  self.frame:Raise()
  return true
end

function Wizard:Hide()
  if self.frame then self.frame:Hide() end
end

function Wizard:IsShown() return self.frame ~= nil and self.frame:IsShown() end

-- Nouvelle liste : l'assistant s'ouvre (ou se met à jour) ; liste vide : il se ferme.
Q:On("RANKS_PENDING", function(list)
  if type(list) ~= "table" or #list == 0 then
    Wizard:Hide()
  elseif Wizard:IsShown() then
    Wizard:Refresh()
  else
    Wizard:Show()
  end
end)
local function combatChanged()
  if Wizard:IsShown() then Wizard:Refresh() end
end
Q:RegisterEvent("PLAYER_REGEN_DISABLED", combatChanged)
Q:RegisterEvent("PLAYER_REGEN_ENABLED", combatChanged)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "tracker.theme" and Wizard:IsShown() then Wizard:Refresh() end
end)
Q:On("THEME_CHANGED", function() if Wizard:IsShown() then Q.SafeCall(Wizard.Refresh, Wizard) end end)
