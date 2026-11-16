local addonName, Q = ...

-- Fenêtre « Quels métiers veux-tu apprendre ? » : métiers principaux (deux au plus) et secondaires.
-- S'ouvre tant que le choix n'est pas fait, une fois par session au plus, après l'assistant de
-- démarrage (terminé, ou fermé pendant la session), et depuis le journal (onglet Options).
-- « Valider » enregistre le choix (Q.Professions:SetChosen) ; « Plus tard » referme sans rien
-- enregistrer : la question revient à la prochaine connexion.
-- Habillage du thème (UI/Themes.lua) : bandeau avec blason et titre, cases plates, « Valider » en action
-- principale, textes aux couleurs du thème, repeints à chaque changement de thème.
Q.UI = Q.UI or {}
local Picker = { checks = {} }
Q.UI.ProfessionPicker = Picker

local L = Q.L

local FRAME_NAME = "QuestifyProfessionPicker"
local WIDTH, HEIGHT = 420, 400
local AUTO_DELAY = 4
local ROW_H = 24

local function safe(fn)
  return function(...) return Q.SafeCall(fn, ...) end
end

local function inCombat() return InCombatLockdown and InCombatLockdown() end

---------------------------------------------------------------------------
-- Habillage du thème (UI/Themes.lua, maquette docs/media/apercus/src/themes/maquette.html, popup(t)) :
-- gabarit de Blizzard caché, bordure de 1 px, fond, bandeau illustré de 46 px avec blason et titre,
-- coins, liseré, croix plate et pied aux couleurs du thème. Sans module de thèmes, le gabarit reste.
---------------------------------------------------------------------------
local HEADER_H, FOOTER_H = 46, 34
local TEXT_ROLES = { text = "body", textDim = "dim", textMuted = "muted" }

-- Couleur, ombre et police d'une ligne de texte ; rôles des jetons (text, textDim, textMuted) ou du
-- texte (title, quest, npc, xp, accent…).
local function paint(fs, role)
  local T = Q.Themes
  if T and fs then T:StyleText(fs, TEXT_ROLES[role] or role) end
end

-- Bouton plat du thème : "primary" (action principale), "secondary" ou "ghost".
local function skin(btn, kind)
  btn.qvButtonKind = kind
  if Q.Themes then Q.Themes:SkinButton(btn, kind) end
  return btn
end

-- Habille la fenêtre f ; title : FontString posé dans le bandeau. -> pied { bg, line }, nil sans thème.
local function skinWindow(f, title)
  local T = Q.Themes
  if not T then return nil end
  T:StripTemplate(f)
  -- bordure de 1 px : le gabarit n'a pas de BackdropTemplate (Q.Themes:Apply ne pose alors que le fond)
  if not f.SetBackdrop and type(Mixin) == "function" and type(BackdropTemplateMixin) == "table" then
    Mixin(f, BackdropTemplateMixin)
    if f.OnBackdropSizeChanged then f:HookScript("OnSizeChanged", f.OnBackdropSizeChanged) end
  end
  T:Apply(f, T:CurrentKey(), 1)
  T:Decorate(f, { header = HEADER_H, emblem = 30, title = title })
  local foot = { bg = f:CreateTexture(nil, "BACKGROUND", nil, -3), line = f:CreateTexture(nil, "BORDER") }
  foot.bg:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
  foot.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
  foot.bg:SetHeight(FOOTER_H)
  foot.line:SetPoint("BOTTOMLEFT", foot.bg, "TOPLEFT", 0, 0)
  foot.line:SetPoint("BOTTOMRIGHT", foot.bg, "TOPRIGHT", 0, 0)
  foot.line:SetHeight(1)
  return foot
end

-- Croix et pied aux couleurs du thème (à la création et à chaque changement de thème).
local function paintChrome(f, foot)
  local T = Q.Themes
  if not (T and f) then return end
  T:SkinClose(f)
  if foot then
    foot.bg:SetColorTexture(T:Color("footer"))
    foot.line:SetColorTexture(T:Color("line"))
  end
end

local function newFrame()
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "BasicFrameTemplateWithInset")
  if ok and f then return f end
  return CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
end

local function primaryCount(self)
  local n = 0
  for key, cb in pairs(self.checks) do
    if Q.Professions.BY_KEY[key].primary and cb:GetChecked() then n = n + 1 end
  end
  return n
end

function Picker:Create()
  if self.frame then return self.frame end
  local f = newFrame()
  self.frame = f
  f:SetSize(WIDTH, HEIGHT)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
  f:SetFrameStrata("DIALOG")
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  local head = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  head:SetText(L.UI_PROF_TITLE)
  self.headText = head
  self.footBar = skinWindow(f, head)
  -- avec le bandeau du thème, le contenu descend de 24 px (fenêtre agrandie d'autant)
  local dy = self.footBar and 24 or 0
  if self.footBar then f:SetHeight(HEIGHT + dy) else head:Hide() end
  if f.SetBackdrop and not f.TitleText and not self.footBar then
    f:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 24,
      insets = { left = 6, right = 6, top = 6, bottom = 6 } })
  end
  local title = f.TitleText or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  if not f.TitleText then title:SetPoint("TOP", f, "TOP", 0, -8) end
  title:SetText(L.UI_PROF_TITLE)

  local intro = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  intro:SetPoint("TOPLEFT", f, "TOPLEFT", 18, -34 - dy)
  intro:SetWidth(WIDTH - 36)
  intro:SetJustifyH("LEFT")
  intro:SetWordWrap(true)
  intro:SetText(L.UI_PROF_INTRO)
  self.intro = intro

  local colPrimary = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  colPrimary:SetPoint("TOPLEFT", f, "TOPLEFT", 18, -84 - dy)
  colPrimary:SetText(L.UI_PROF_PRIMARY)
  local colSecondary = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  colSecondary:SetPoint("TOPLEFT", f, "TOPLEFT", WIDTH / 2 + 10, -84 - dy)
  colSecondary:SetText(L.UI_PROF_SECONDARY)
  self.colPrimary, self.colSecondary = colPrimary, colSecondary

  local warn = f:CreateFontString(nil, "OVERLAY", "GameFontRedSmall")
  warn:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 18, 44)
  warn:SetText("")
  self.warn = warn

  local yP, yS, seq = 104 + dy, 104 + dy, 0
  for _, p in ipairs(Q.Professions.LIST) do
    seq = seq + 1
    local cb = CreateFrame("CheckButton", FRAME_NAME .. "Check" .. seq, f, "UICheckButtonTemplate")
    cb:SetSize(24, 24)
    local x = p.primary and 18 or (WIDTH / 2 + 10)
    local y = p.primary and yP or yS
    cb:SetPoint("TOPLEFT", f, "TOPLEFT", x, -y)
    if Q.Themes then Q.Themes:SkinCheck(cb) end
    local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("LEFT", cb, "RIGHT", 2, 1)
    label:SetText(Q.Professions:Name(p.key))
    cb.key, cb.label = p.key, label
    cb:SetScript("OnClick", safe(function(self)
      if self:GetChecked() and Q.Professions.BY_KEY[self.key].primary and primaryCount(Picker) > Q.Professions.MAX_PRIMARY then
        self:SetChecked(false)
        Picker.warn:SetText(L.UI_PROF_MAX)
        return
      end
      Picker.warn:SetText("")
    end))
    self.checks[p.key] = cb
    if p.primary then yP = yP + ROW_H else yS = yS + ROW_H end
  end

  local ok = CreateFrame("Button", FRAME_NAME .. "OK", f, "UIPanelButtonTemplate")
  ok:SetSize(120, 24)
  ok:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, self.footBar and (FOOTER_H - 24) / 2 + 1 or 14)
  ok:SetText(L.UI_PROF_OK)
  ok:SetScript("OnClick", safe(function() Picker:Validate() end))
  local later = CreateFrame("Button", FRAME_NAME .. "Later", f, "UIPanelButtonTemplate")
  later:SetSize(120, 24)
  later:SetPoint("RIGHT", ok, "LEFT", -8, 0)
  later:SetText(L.UI_PROF_LATER)
  later:SetScript("OnClick", safe(function() Picker.frame:Hide() end))
  self.okButton, self.laterButton = skin(ok, "primary"), skin(later, "ghost")
  self:ApplyTheme()
  f:Hide()
  return f
end

-- Rôle de couleur de chaque texte fixe de la fenêtre.
local TEXT_COLORS = { headText = "title", intro = "textDim", colPrimary = "textMuted", colSecondary = "textMuted",
  warn = "danger" }

-- Couleurs du thème : textes, cases, boutons, croix et pied.
function Picker:ApplyTheme()
  local T = Q.Themes
  if not (self.frame and T) then return end
  for key, role in pairs(TEXT_COLORS) do paint(self[key], role) end
  for _, cb in pairs(self.checks) do
    T:SkinCheck(cb)
    paint(cb.label, "text")
  end
  skin(self.okButton, "primary")
  skin(self.laterButton, "ghost")
  paintChrome(self.frame, self.footBar)
end

function Picker:Show()
  if inCombat() then
    self.pendingShow = true
    return
  end
  self:Create()
  local chosen = Q.Professions:Chosen() or {}
  for key, cb in pairs(self.checks) do cb:SetChecked(chosen[key] == true) end
  self.warn:SetText("")
  self.frame:Show()
end

function Picker:Validate()
  local set = {}
  for key, cb in pairs(self.checks) do
    if cb:GetChecked() then set[key] = true end
  end
  Q.Professions:SetChosen(set)
  self.frame:Hide()
  local names = {}
  for _, p in ipairs(Q.Professions.LIST) do
    if set[p.key] then names[#names + 1] = Q.Professions:Name(p.key) end
  end
  if #names > 0 then
    Q:Print(L.UI_PROF_SAVED, table.concat(names, ", "))
  else
    Q:Print(L.UI_PROF_NONE)
  end
end

-- Tant que le choix n'est pas fait, au plus une fois par session, quand l'assistant de démarrage
-- est terminé ou a été fermé pendant cette session (jamais pendant qu'il est ouvert).
local function autoShow()
  if not Q.char or Q.Professions:HasAnswered() or Picker.autoShown then return end
  local W = Q.UI.Wizard
  local wizardPassed = Q.char.wizardDone or (W and W.ClosedThisSession and W:ClosedThisSession())
  if not wizardPassed then return end
  if W and W:IsShown() then return end
  Picker.autoShown = true
  Picker:Show()
end
Picker.AutoShow = autoShow

Q:On("LOGIN", function()
  Q:After(AUTO_DELAY, autoShow)
end)
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  if Picker.pendingShow then
    Picker.pendingShow = false
    Picker:Show()
  end
end)
Q:On("THEME_CHANGED", function()
  if Picker.frame then Q.SafeCall(Picker.ApplyTheme, Picker) end
end)
