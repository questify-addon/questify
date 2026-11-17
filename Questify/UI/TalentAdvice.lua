local addonName, Q = ...

-- Encart « point de talent » sous le suivi (UI/Tracker.lua), au passage de niveau quand un point de talent
-- est à dépenser : icône et nom du talent suivant du guide de classe (Engine/ClassGuide.lua), rang visé,
-- début de l'explication, boutons « Voir le guide » (Options › Classe › Talents) et « OK », barre qui se
-- vide en 8 secondes (arrêtée au survol). Même boîte et même place que « Amélioration trouvée »
-- (UI/UpgradePopup.lua) : collée sous le suivi, au-dessus s'il touche le bas de l'écran ; suivi caché :
-- en haut au milieu de l'écran. Jamais en combat : l'encart attend la fin du combat. Option
-- classGuide.levelUp. Maquette : docs/media/apercus/classe/maquette.png (3).
Q.UI = Q.UI or {}
local Advice = {}
Q.UI.TalentAdvice = Advice

local L = Q.L
local SHOW_TIME = 8
local WIDTH = 260
local PAD = 8
local GAP = 4
local ICON = 36
local BTN_H = 20
local BAR_H = 3
local WHITE = "Interface\\Buttons\\WHITE8X8"

local function setting(path) return Q.Settings:Get(path) end
local function inCombat() return InCombatLockdown and InCombatLockdown() end

local function color(role)
  local P = Q.UI.ClassPanel
  if P and P.Color then return P.Color(role) end
  return 1, 1, 1, 1
end

function Advice:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyTalentAdvice", UIParent)
  f:SetSize(WIDTH, 90)
  f:SetFrameStrata("MEDIUM")
  f:EnableMouse(true)
  if f.SetClampedToScreen then f:SetClampedToScreen(true) end
  f.bg = f:CreateTexture(nil, "BACKGROUND")
  f.bg:SetAllPoints(f)
  f.edges = {}
  for i, spec in ipairs({ { "TOPLEFT", "TOPRIGHT", nil, 1 }, { "BOTTOMLEFT", "BOTTOMRIGHT", nil, 1 },
      { "TOPLEFT", "BOTTOMLEFT", 1, nil }, { "TOPRIGHT", "BOTTOMRIGHT", 1, nil } }) do
    local t = f:CreateTexture(nil, "BORDER")
    t:SetPoint(spec[1], f, spec[1], 0, 0)
    t:SetPoint(spec[2], f, spec[2], 0, 0)
    if spec[3] then t:SetWidth(spec[3]) end
    if spec[4] then t:SetHeight(spec[4]) end
    f.edges[i] = t
  end
  local icon = f:CreateTexture(nil, "ARTWORK")
  icon:SetSize(ICON, ICON)
  icon:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
  if icon.SetTexCoord then icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
  local ring = f:CreateTexture(nil, "BORDER")
  ring:SetPoint("TOPLEFT", icon, "TOPLEFT", -1, 1)
  ring:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
  local x = PAD + ICON + 8
  local head = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  head:SetPoint("TOPLEFT", f, "TOPLEFT", x, -PAD + 1)
  head:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
  head:SetJustifyH("LEFT")
  local name = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  name:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, -2)
  name:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
  name:SetJustifyH("LEFT")
  local why = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  why:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
  why:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
  why:SetJustifyH("LEFT")
  if why.SetWordWrap then why:SetWordWrap(false) end
  local P = Q.UI.ClassPanel
  local open = P.Button(f, L.CLASS_ADVICE_OPEN, "primary", function() Advice:OpenGuide() end)
  open:SetPoint("TOPLEFT", why, "BOTTOMLEFT", 0, -6)
  local ok = P.Button(f, L.CLASS_ADVICE_OK, "ghost", function() Advice:Dismiss() end)
  ok:SetPoint("LEFT", open, "RIGHT", 4, 0)
  local bar = CreateFrame("StatusBar", nil, f)
  bar:SetHeight(BAR_H)
  bar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD, PAD - 2)
  bar:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -PAD, PAD - 2)
  bar:SetStatusBarTexture(WHITE)
  bar:SetMinMaxValues(0, SHOW_TIME)
  bar:SetValue(SHOW_TIME)
  local barBg = bar:CreateTexture(nil, "BACKGROUND")
  barBg:SetAllPoints(bar)
  f:SetScript("OnMouseUp", function(_, button)
    if button == "RightButton" then Q.SafeCall(Advice.Dismiss, Advice) end
  end)
  f:SetScript("OnUpdate", function(_, elapsed) Q.SafeCall(Advice.Tick, Advice, elapsed) end)
  f:Hide()
  self.frame, self.icon, self.ring, self.head, self.name, self.why = f, icon, ring, head, name, why
  self.openButton, self.okButton, self.bar, self.barBg = open, ok, bar, barBg
  return f
end

function Advice:ApplyTheme()
  local f = self.frame
  if not f then return end
  local r, g, b = color("bg")
  f.bg:SetColorTexture(r, g, b, tonumber(setting("tracker.opacity")) or 0.94)
  r, g, b = color("edge")
  for _, t in ipairs(f.edges) do t:SetColorTexture(r, g, b, 1) end
  r, g, b = color("accent")
  self.ring:SetColorTexture(r, g, b, 1)
  self.bar:SetStatusBarColor(r, g, b)
  self.name:SetTextColor(r, g, b, 1)
  r, g, b = color("textMuted")
  self.head:SetTextColor(r, g, b, 1)
  r, g, b = color("textDim")
  self.why:SetTextColor(r, g, b, 1)
  r, g, b = color("line")
  self.barBg:SetColorTexture(r, g, b, 1)
  self.openButton:SetKind("primary")
  self.okButton:SetKind("ghost")
end

-- Sous le suivi (même largeur et même échelle) ; au-dessus s'il touche le bas ; sinon en haut de l'écran.
-- Une boîte « Amélioration trouvée » déjà affichée sous le suivi garde sa place : l'encart va dessous.
function Advice:Anchor()
  local f = self.frame
  local tracker = Q.UI.Tracker and Q.UI.Tracker.frame
  local up = Q.UI.UpgradePopup and Q.UI.UpgradePopup.frame
  f:ClearAllPoints()
  if tracker and tracker:IsShown() then
    f:SetScale(tracker:GetScale() or 1)
    local below = (up and up:IsShown() and Q.UI.UpgradePopup.placement == "below") and up or tracker
    local bottom = tonumber(below:GetBottom()) or 0
    local need = (f:GetHeight() + GAP) * (f:GetScale() or 1)
    if bottom * (tracker:GetScale() or 1) < need then
      f:SetPoint("BOTTOMLEFT", tracker, "TOPLEFT", 0, GAP)
      f:SetPoint("BOTTOMRIGHT", tracker, "TOPRIGHT", 0, GAP)
      self.placement = "above"
    else
      f:SetPoint("TOPLEFT", below, "BOTTOMLEFT", 0, -GAP)
      f:SetPoint("TOPRIGHT", below, "BOTTOMRIGHT", 0, -GAP)
      self.placement = "below"
    end
  else
    f:SetScale(1)
    f:SetWidth(WIDTH)
    f:SetPoint("TOP", UIParent, "TOP", 0, -180)
    self.placement = "screen"
  end
end

-- Show(conseil) : conseil = Q.ClassGuide:Advice() ; en combat, gardé jusqu'à la fin du combat.
function Advice:Show(advice)
  if not advice then return end
  if inCombat() then self.pending = advice; return end
  self.pending = nil
  self:Create()
  self.current = advice
  local G = Q.ClassGuide
  self.icon:SetTexture("Interface\\Icons\\" .. (advice.icon or "INV_Misc_QuestionMark"))
  self.head:SetText(string.format(L.CLASS_ADVICE_HEAD, advice.level, G:SpecName(advice.spec, G:Tree())))
  self.name:SetText(string.format("%s %d/%d", G:TalentName(advice.spell, advice.spec), advice.rank, advice.max))
  self.why:SetText(advice.why or "")
  self.openButton:SetLabel(L.CLASS_ADVICE_OPEN)
  self.okButton:SetLabel(L.CLASS_ADVICE_OK)
  self:ApplyTheme()
  self.frame:SetHeight(PAD + 12 + 2 + 15 + 2 + 12 + 6 + BTN_H + 6 + BAR_H + PAD - 2)
  self:Anchor()
  self.remaining = SHOW_TIME
  self.bar:SetValue(SHOW_TIME)
  self.frame:Show()
end

function Advice:Tick(elapsed)
  local f = self.frame
  if not (f and f:IsShown() and self.current) then return end
  if f:IsMouseOver() then return end
  self.remaining = (self.remaining or SHOW_TIME) - (tonumber(elapsed) or 0)
  self.bar:SetValue(math.max(0, self.remaining))
  if self.remaining <= 0 then self:Dismiss() end
end

function Advice:Dismiss()
  self.current = nil
  if self.frame then self.frame:Hide() end
end

function Advice:OpenGuide()
  self:Dismiss()
  local P = Q.UI.ClassPanel
  if P then P:Open("talents") end
end

-- Passage de niveau : conseil si l'option est active et qu'un point du guide est dû.
function Advice:OnLevelUp()
  if setting("classGuide.levelUp") == false then return end
  Q.ClassGuide:Invalidate()
  local advice = Q.ClassGuide:Advice()
  if advice then self:Show(advice) end
end

Q:RegisterEvent("PLAYER_LEVEL_UP", function()
  -- Q.Player et la monnaie des talents suivent l'évènement : on attend un instant
  Q:After(1, function() Q.SafeCall(Advice.OnLevelUp, Advice) end)
end)
Q:RegisterEvent("PLAYER_REGEN_DISABLED", function()
  if Advice.current and Advice.frame and Advice.frame:IsShown() then
    Advice.pending = Advice.current
    Advice:Dismiss()
  end
end)
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  if Advice.pending then Q.SafeCall(Advice.Show, Advice, Advice.pending) end
end)
-- Point dépensé : l'encart n'a plus lieu d'être.
Q:On("TALENTS_CHANGED", function()
  if not Advice.current then return end
  local a = Q.ClassGuide:Advice()
  if not a or a.spell ~= Advice.current.spell or a.rank ~= Advice.current.rank then Advice:Dismiss() end
end)
