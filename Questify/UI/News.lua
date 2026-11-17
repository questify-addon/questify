local addonName, Q = ...

-- Fenêtre des nouveautés (maquette docs/superpowers/specs/2026-11-17-nouveautes-maquette.html).
-- Contenu : Q.NewsData (Data/News.lua), une entrée par version, une étape par nouveauté.
-- Fenêtre de 540 × 444, au thème courant (UI/Themes.lua) :
--   en-tête de 40 : icône de Questify, « Nouveautés de Questify 1.0 », « 3 / 10 », fermer ;
--   bande d'icônes (une par étape, 34 × 34) : l'étape courante cerclée de 2 px à l'accent avec un
--   trait dessous, les étapes vues atténuées ; un clic va à l'étape ;
--   corps : grande icône (56), catégorie à l'accent, titre, texte, 3 points au plus, bouton qui mène
--   au réglage (options, page de l'assistant, onglet du journal, commande /qf) et chemin affiché ;
--   pied de 40 : « Ne plus afficher pour la 1.0 », « Précédent », « Suivant » (« Terminer » à la fin).
-- Ouverture : 3 s après la connexion, pour un personnage qui a fini l'assistant de départ, quand une
-- version de Q.NewsData est plus récente que QuestifyDB.newsSeen (compte entier) ; jamais en combat
-- (attend la fin du combat), une fois par session. Fermer (croix, Échap) : elle revient à la
-- connexion suivante. « Ne plus afficher » et « Terminer » posent QuestifyDB.newsSeen ; finir
-- l'assistant de départ aussi (un nouveau personnage n'a pas de nouveautés à voir). Elle remplace la
-- réouverture de l'assistant sur la page des objectifs (une de ses étapes y mène).
-- /qf news (ou /qf nouveautes) et le bouton du récapitulatif de l'assistant la rouvrent.
Q.UI = Q.UI or {}
local News = { chips = {}, points = {}, steps = {}, cur = 1, visited = {} }
Q.UI.News = News

local L = Q.L

local FRAME_NAME = "QuestifyNews"
local WIDTH, HEIGHT = 540, 444
local HEADER_H, FOOTER_H = 40, 40
local CHIP, CHIP_GAP = 34, 6
local STRIP_TOP = HEADER_H + 1 + 12            -- 53 : haut de la bande d'icônes
local STRIP_LINE = STRIP_TOP + CHIP + 10       -- 97 : filet sous la bande
local PAD_X = 18
local BODY_TOP = STRIP_LINE + 1 + 16           -- 114 : haut du corps
local BIG = 56
local MAX_POINTS = 3
local AUTO_DELAY = 3
local LOGO = "Interface\\AddOns\\Questify\\Media\\Icon"
local CLASS_SHEET = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local ICON_CROP = { 0.08, 0.92, 0.08, 0.92 }  -- bord des icônes de sort et d'objet

local function inCombat() return InCombatLockdown and InCombatLockdown() and true or false end
local function safe(fn) return function(...) return Q.SafeCall(fn, ...) end end
local function theme() return Q.Themes and Q.Themes:Current() end

---------------------------------------------------------------------------
-- Données
---------------------------------------------------------------------------
local function compare(a, b)
  local VC = Q.VersionCheck
  return VC and VC.Compare(a, b) or nil
end

-- Dernière version vue (QuestifyDB.newsSeen), ou nil.
function News:Seen()
  local d = Q.db
  if type(d) == "table" and type(d.newsSeen) == "string" then return d.newsSeen end
  return nil
end

function News:Latest()
  local d = Q.NewsData or {}
  return d[#d]
end

-- Versions pas encore vues, de la plus ancienne à la plus récente. Sans aucune version vue (mise à
-- jour depuis une version d'avant cette fenêtre), seulement la plus récente.
function News:Unseen()
  local seen, out = self:Seen(), {}
  for _, v in ipairs(Q.NewsData or {}) do
    if not seen or (compare(v.version, seen) or 0) > 0 then out[#out + 1] = v end
  end
  if not seen and #out > 1 then out = { out[#out] } end
  return out
end

-- Vrai si la fenêtre doit s'ouvrir d'elle-même pour ce personnage.
function News:Pending()
  if not (Q.char and Q.char.wizardDone) then return false end
  return #self:Unseen() > 0
end

-- La version la plus récente compte comme vue (jamais de retour en arrière).
function News:MarkSeen()
  local v = self:Latest()
  if not (v and type(Q.db) == "table") then return end
  local seen = self:Seen()
  if not seen or (compare(v.version, seen) or 0) > 0 then Q.db.newsSeen = v.version end
end

-- Étapes à montrer : celles des versions pas vues, sinon celles de la plus récente.
local function collect()
  local list = News:Unseen()
  if #list == 0 then list = { News:Latest() } end
  local steps = {}
  for i = #list, 1, -1 do
    for _, s in ipairs(list[i].steps or {}) do steps[#steps + 1] = s end
  end
  return steps, list[#list]
end

local function text(step, suffix)
  local v = rawget(L, "NEWS_" .. step.id .. "_" .. suffix)
  return type(v) == "string" and v or nil
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function solid(parent, layer, sub)
  return parent:CreateTexture(nil, layer or "BACKGROUND", nil, sub)
end

-- Cadre d'icône : fond, quatre bords, icône. thick : bord de 2 px (étape courante).
local function iconBox(b, size, inner)
  b:SetSize(size, size)
  b.bg = solid(b, "BACKGROUND", 1)
  b.bg:SetAllPoints(b)
  b.edges = {}
  for i = 1, 4 do b.edges[i] = solid(b, "BORDER") end
  b.icon = b:CreateTexture(nil, "ARTWORK")
  b.icon:SetSize(inner, inner)
  b.icon:SetPoint("CENTER", b, "CENTER", 0, 0)
end

local function paintBox(b, edgeColor, thick, c)
  b.bg:SetColorTexture(c.panelAlt[1], c.panelAlt[2], c.panelAlt[3], 1)
  local w = thick and 2 or 1
  local pts = { { "TOPLEFT", "TOPRIGHT" }, { "BOTTOMLEFT", "BOTTOMRIGHT" }, { "TOPLEFT", "BOTTOMLEFT" }, { "TOPRIGHT", "BOTTOMRIGHT" } }
  for i, e in ipairs(b.edges) do
    e:ClearAllPoints()
    e:SetPoint(pts[i][1], b, pts[i][1], 0, 0)
    e:SetPoint(pts[i][2], b, pts[i][2], 0, 0)
    if i <= 2 then e:SetHeight(w) else e:SetWidth(w) end
    e:SetColorTexture(edgeColor[1], edgeColor[2], edgeColor[3], 1)
  end
end

-- Icône d'une étape : texture du jeu, ou "class" (planche des classes, découpée sur la classe du joueur).
local function setIcon(tex, icon)
  if icon == "class" then
    local cf = Q.Player and Q.Player.classFile
    if not cf and UnitClass then cf = select(2, UnitClass("player")) end
    local c = type(CLASS_ICON_TCOORDS) == "table" and cf and CLASS_ICON_TCOORDS[cf]
    if c then
      tex:SetTexture(CLASS_SHEET)
      tex:SetTexCoord(c[1], c[2], c[3], c[4])
      return
    end
    icon = "Interface\\Icons\\INV_Misc_Book_09"
  end
  tex:SetTexture(icon or FALLBACK_ICON)
  if type(icon) == "string" and icon:find("^Interface\\Icons\\") then
    tex:SetTexCoord(ICON_CROP[1], ICON_CROP[2], ICON_CROP[3], ICON_CROP[4])
  else
    tex:SetTexCoord(0, 1, 0, 1)
  end
end

local function fontString(parent, font, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  fs:SetJustifyH("LEFT")
  if width then
    fs:SetWidth(width)
    fs:SetWordWrap(true)
  end
  return fs
end

local function chip(i)
  local b = News.chips[i]
  if b then return b end
  b = CreateFrame("Button", nil, News.frame)
  iconBox(b, CHIP, CHIP - 4)
  b.bar = solid(b, "OVERLAY")
  b.bar:SetSize(CHIP - 12, 2)
  b.bar:SetPoint("TOP", b, "BOTTOM", 0, -6)
  b:SetPoint("TOPLEFT", News.frame, "TOPLEFT", 16 + (i - 1) * (CHIP + CHIP_GAP), -STRIP_TOP)
  b:SetScript("OnClick", safe(function(self) News:Go(self.index) end))
  b:SetScript("OnEnter", function(self)
    local s = News.steps[self.index]
    if not (GameTooltip and s) then return end
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText(text(s, "TITLE") or s.id)
    GameTooltip:Show()
  end)
  b:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
  News.chips[i] = b
  return b
end

local function button(parent, onClick)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetHeight(22)
  b:SetScript("OnClick", safe(onClick))
  return b
end

-- Largeur d'un bouton d'après son texte (12 px de marge de chaque côté).
local function fit(b, label)
  b:SetText(label)
  News.measure:SetText(label)
  b:SetWidth(math.max(70, math.floor((News.measure:GetStringWidth() or 0) + 24 + 0.5)))
end

function News:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
  self.frame = f
  f:SetSize(WIDTH, HEIGHT)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
  f:SetFrameStrata("MEDIUM")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) self:StartMoving() end)
  f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end

  local title = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  self.titleText = title
  local T = Q.Themes
  if T then
    T:Apply(f, T:CurrentKey(), 1)
    T:Decorate(f, { header = HEADER_H, title = title })
    T:SkinClose(f)
  end
  local header = f.qvDecor and f.qvDecor.header or f
  local logo = header:CreateTexture(nil, "ARTWORK")
  logo:SetSize(22, 22)
  logo:SetPoint("LEFT", header, "LEFT", 12, 0)
  logo:SetTexture(LOGO)
  self.logo = logo
  title:ClearAllPoints()
  title:SetPoint("LEFT", logo, "RIGHT", 8, 0)
  local step = header:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  step:SetPoint("RIGHT", header, "RIGHT", -40, 0)
  self.stepText = step
  self.measure = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.measure:Hide()

  -- filet sous la bande d'icônes
  local line = solid(f, "BORDER")
  line:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -STRIP_LINE)
  line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -STRIP_LINE)
  line:SetHeight(1)
  self.stripLine = line

  -- corps
  local big = CreateFrame("Frame", nil, f)
  iconBox(big, BIG, BIG - 4)
  big:SetPoint("TOPLEFT", f, "TOPLEFT", PAD_X, -BODY_TOP)
  self.big = big
  local tag = fontString(f, "GameFontNormalSmall")
  tag:SetPoint("TOPLEFT", big, "TOPRIGHT", 14, -2)
  self.tag = tag
  local heading = fontString(f, "GameFontHighlightLarge", WIDTH - PAD_X * 2 - BIG - 14)
  heading:SetPoint("TOPLEFT", tag, "BOTTOMLEFT", 0, -3)
  self.heading = heading
  local body = fontString(f, "GameFontHighlight", WIDTH - PAD_X * 2)
  body:SetPoint("TOPLEFT", big, "BOTTOMLEFT", 0, -14)
  self.body = body
  local anchor = body
  for i = 1, MAX_POINTS do
    local p = fontString(f, "GameFontHighlightSmall", WIDTH - PAD_X * 2 - 14)
    p:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", i == 1 and 14 or 0, i == 1 and -10 or -4)
    p.dot = solid(f, "ARTWORK")
    p.dot:SetSize(5, 5)
    p.dot:SetPoint("TOPRIGHT", p, "TOPLEFT", -7, -4)
    self.points[i] = p
    anchor = p
  end
  self.goButton = button(f, function() News:Run() end)
  self.where = fontString(f, "GameFontDisableSmall")
  self.where:SetPoint("LEFT", self.goButton, "RIGHT", 10, 0)

  -- pied
  local foot = solid(f, "BACKGROUND", 2)
  foot:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
  foot:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
  foot:SetHeight(FOOTER_H)
  self.footBg = foot
  local footLine = solid(f, "BORDER")
  footLine:SetPoint("BOTTOMLEFT", foot, "TOPLEFT", 0, 0)
  footLine:SetPoint("BOTTOMRIGHT", foot, "TOPRIGHT", 0, 0)
  footLine:SetHeight(1)
  self.footLine = footLine
  self.hideButton = button(f, function() News:HideForVersion() end)
  self.hideButton:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 9)
  self.nextButton = button(f, function() News:Next() end)
  self.nextButton:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 9)
  self.prevButton = button(f, function() News:Prev() end)
  self.prevButton:SetPoint("RIGHT", self.nextButton, "LEFT", -6, 0)

  f:Hide()
  return f
end

---------------------------------------------------------------------------
-- Affichage
---------------------------------------------------------------------------
function News:Refresh()
  local f = self.frame
  if not f then return end
  local s = self.steps[self.cur]
  if not s then return end
  local T = Q.Themes
  local th = T and T:Apply(f, T:CurrentKey(), 1) or theme()
  local c = th and th.colors
  local label = self.entry and self.entry.label or ""
  self.titleText:SetText(string.format(L.NEWS_TITLE, label))
  self.stepText:SetText(string.format(L.NEWS_STEP, self.cur, #self.steps))

  for i, step in ipairs(self.steps) do
    local b = chip(i)
    b.index = i
    b.current = i == self.cur
    b.seen = not b.current and self.visited[i] == true
    setIcon(b.icon, step.icon)
    b.icon:SetAlpha(b.seen and 0.62 or 1)
    if c then
      paintBox(b, b.current and c.accent or c.edge, b.current, c)
      b.bar:SetColorTexture(c.accent[1], c.accent[2], c.accent[3], 1)
    end
    b.bar:SetShown(b.current)
    b:Show()
  end
  for i = #self.steps + 1, #self.chips do self.chips[i]:Hide() end

  setIcon(self.big.icon, s.icon)
  if c then
    paintBox(self.big, c.edge, false, c)
    self.stripLine:SetColorTexture(c.line[1], c.line[2], c.line[3], c.line[4] or 0.12)
    self.footLine:SetColorTexture(c.line[1], c.line[2], c.line[3], c.line[4] or 0.12)
    self.footBg:SetColorTexture(c.footer[1], c.footer[2], c.footer[3], 1)
  end
  self.tag:SetText(text(s, "TAG") or "")
  self.heading:SetText(text(s, "TITLE") or s.id)
  self.body:SetText(text(s, "TEXT") or "")
  local last = self.body
  for i, p in ipairs(self.points) do
    local t = text(s, "P" .. i)
    p:SetText(t or "")
    p:SetShown(t ~= nil)
    if c then p.dot:SetColorTexture(c.accent[1], c.accent[2], c.accent[3], 1) end
    p.dot:SetShown(t ~= nil)
    if t then last = p end
  end
  local go = self.goButton
  go:ClearAllPoints()
  go:SetPoint("TOPLEFT", last, "BOTTOMLEFT", last == self.body and 0 or -14, -16)
  fit(go, text(s, "GO") or "")
  go:SetShown(s.go ~= nil)
  self.where:SetText(text(s, "WHERE") or "")

  fit(self.hideButton, string.format(L.NEWS_HIDE, label))
  fit(self.prevButton, L.UI_WIZ_PREV)
  self.prevButton:SetEnabled(self.cur > 1)
  fit(self.nextButton, self.cur < #self.steps and L.UI_WIZ_NEXT or L.UI_WIZ_FINISH)

  if T and th then
    T:StyleText(self.titleText, "title", th)
    T:StyleText(self.stepText, "muted", th)
    T:StyleText(self.tag, "accent", th)
    T:StyleText(self.heading, "title", th)
    T:StyleText(self.body, "dim", th)
    for _, p in ipairs(self.points) do T:StyleText(p, "dim", th) end
    T:StyleText(self.where, "muted", th)
    T:SkinClose(f, th)
    T:SkinButton(go, "primary", th)
    T:SkinButton(self.hideButton, "ghost", th)
    T:SkinButton(self.prevButton, "secondary", th)
    T:SkinButton(self.nextButton, "primary", th)
  end
end

-- Va à l'étape i (bande d'icônes, Précédent, Suivant).
function News:Go(i)
  i = math.max(1, math.min(#self.steps, tonumber(i) or 1))
  self.visited[self.cur] = true
  self.cur = i
  self:Refresh()
end

function News:Next()
  if self.cur >= #self.steps then return self:Finish() end
  self:Go(self.cur + 1)
end

function News:Prev() self:Go(self.cur - 1) end

-- Ouvre la fenêtre (rien en combat : elle s'ouvrira à la fin du combat).
function News:Show()
  if inCombat() then
    self.waitingShow = true
    Q:Print(L.NEWS_COMBAT)
    return false
  end
  local steps, entry = collect()
  if not entry or #steps == 0 then return false end
  self:Create()
  self.steps, self.entry, self.cur, self.visited = steps, entry, 1, {}
  self:Refresh()
  self.frame:Show()
  self.frame:Raise()
  Q:Print(L.NEWS_OPENED, entry.label)
  return true
end

function News:IsShown() return self.frame ~= nil and self.frame:IsShown() end

-- « Terminer » : vu, fermé.
function News:Finish()
  self:MarkSeen()
  if self.frame then self.frame:Hide() end
end

-- « Ne plus afficher pour la 1.0 ».
function News:HideForVersion()
  self:MarkSeen()
  if self.frame then self.frame:Hide() end
  Q:Print(L.NEWS_HIDDEN, self.entry and self.entry.label or "")
end

-- Bouton de l'étape : mène au réglage ; la fenêtre reste ouverte, derrière.
function News:Run(step)
  step = step or self.steps[self.cur]
  local g = step and step.go
  if type(g) ~= "table" then return end
  local UI = Q.UI
  if g.options and UI.Options then
    UI.Options:Open(g.options)
  elseif g.wizard and UI.Wizard then
    UI.Wizard:Show(UI.Wizard[g.wizard])
  elseif g.journal and UI.Journal then
    UI.Journal:ShowTab(g.journal)
  elseif g.slash and SlashCmdList and SlashCmdList.QUESTIFY then
    SlashCmdList.QUESTIFY(g.slash)
  end
  if self.frame and self.frame.Lower then self.frame:Lower() end
end

---------------------------------------------------------------------------
-- Ouverture automatique
---------------------------------------------------------------------------
local function autoShow()
  if News.autoShown or News:IsShown() or not News:Pending() then return end
  local W = Q.UI.Wizard
  if W and W.IsShown and W:IsShown() then return end
  if inCombat() then
    News.waitingCombat = true
    return
  end
  News.autoShown = true
  if Q.char then Q.char.wizardObjectivesSeen = true end   -- une étape mène à la page des objectifs
  News:Show()
end

Q:On("LOGIN", function()
  if News:Pending() then Q:After(AUTO_DELAY, autoShow) end
end)

-- Fin du combat : ouverture demandée pendant le combat (/qf news), sinon ouverture automatique.
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  if News.waitingShow then
    News.waitingShow, News.waitingCombat = false, false
    News:Show()
  elseif News.waitingCombat then
    News.waitingCombat = false
    autoShow()
  end
end)

Q:On("THEME_CHANGED", function() if News:IsShown() then News:Refresh() end end)
