local addonName, Q = ...

-- Panneau « Sorts du maître » (maquette docs/superpowers/specs/2026-11-16-maitre-de-classe-maquette.html, A),
-- collé à droite de la fenêtre du maître de classe de Blizzard, qui n'est pas modifiée. Ouvert et fermé avec
-- elle (TRAINER_WINDOW de Engine/Trainer.lua), seulement chez un maître de classe du joueur.
--   en-tête : icône de la classe, « Niveau 24 · Druide », « Sorts du maître » ;
--   « À apprendre maintenant » : les sorts disponibles à ce niveau, les moins chers d'abord, une ligne par
--   sort (icône, nom, rang, prix, niveau) ; prix en rouge quand l'or ne suffit plus ;
--   « Prochains niveaux » : les sorts des deux prochains niveaux, grisés, sous « Niveau 26 » ;
--   pied : l'or du joueur et ce qui manque.
-- Survol d'une ligne : infobulle du sort du jeu. Couleurs : thème du suivi (Q.Themes), fond opaque.
-- Réglage trainerPanel (onglet Options, Maître de classe).
Q.UI = Q.UI or {}
local Panel = { rows = {}, levels = {} }
Q.UI.TrainerPanel = Panel

local L = Q.L

local WIDTH = 300
local PAD = 12
local ICON = 30
local ROW_H = 36
local MAX_NOW = 14
local MAX_LATER = 8
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
local BAD = { 0.85, 0.15, 0.15 }   -- prix que l'or ne couvre pas (lisible sur parchemin et sur fond sombre)

local function setting(path) return Q.Settings:Get(path) end

function Panel.Money(copper)
  copper = math.floor(tonumber(copper) or 0)
  if type(GetCoinTextureString) == "function" then
    local ok, s = pcall(GetCoinTextureString, copper)
    if ok and type(s) == "string" then return s end
  end
  local g, s, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
  local parts = {}
  if g > 0 then parts[#parts + 1] = g .. "g" end
  if s > 0 then parts[#parts + 1] = s .. "s" end
  if c > 0 or #parts == 0 then parts[#parts + 1] = c .. "c" end
  return table.concat(parts, " ")
end
local money = Panel.Money

local function theme() return Q.Themes:Current() end

local function style(fs, role) Q.Themes:StyleText(fs, role, theme()) end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function text(parent, template, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlight")
  fs:SetJustifyH(justify or "LEFT")
  fs:SetWordWrap(false)
  return fs
end

local function rowOnEnter(row)
  if not GameTooltip then return end
  GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
  if row.spellID and GameTooltip.SetSpellByID then
    GameTooltip:SetSpellByID(row.spellID)
  else
    GameTooltip:ClearLines()
    GameTooltip:AddLine(row.label or "", 1, 1, 1)
  end
  if row.copper and row.copper > 0 then
    GameTooltip:AddLine(string.format(L.TRAINER_PANEL_TIP_COST, money(row.copper)), 1, 1, 1)
  end
  GameTooltip:Show()
end

local function newRow(parent)
  local r = CreateFrame("Button", nil, parent)
  r:SetSize(WIDTH - 2 * PAD, ROW_H)
  r:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  local icon = r:CreateTexture(nil, "ARTWORK")
  icon:SetSize(ICON, ICON)
  icon:SetPoint("LEFT", r, "LEFT", 2, 0)
  r.icon = icon
  local cost = text(r, "GameFontHighlightSmall", "RIGHT")
  cost:SetPoint("TOPRIGHT", r, "TOPRIGHT", -2, -4)
  r.cost = cost
  local lvl = text(r, "GameFontDisableSmall", "RIGHT")
  lvl:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", -2, 4)
  r.lvl = lvl
  local name = text(r, "GameFontHighlight")
  name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -1)
  name:SetPoint("RIGHT", r, "RIGHT", -70, 0)
  r.name = name
  local rank = text(r, "GameFontDisableSmall")
  rank:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", 8, 1)
  r.rank = rank
  r:SetScript("OnEnter", function(self) Q.SafeCall(rowOnEnter, self) end)
  r:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
  r:Hide()
  return r
end

local function sectionHeader(parent)
  local h = CreateFrame("Frame", nil, parent)
  h:SetSize(WIDTH - 2 * PAD, 18)
  h.label = text(h, "GameFontNormalSmall")
  h.label:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 3)
  h.right = text(h, "GameFontNormalSmall", "RIGHT")
  h.right:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 3)
  local line = h:CreateTexture(nil, "ARTWORK")
  line:SetHeight(1)
  line:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 0)
  line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 0)
  h.line = line
  return h
end

function Panel:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyTrainerPanel", UIParent, "BackdropTemplate")
  self.frame = f
  f:SetSize(WIDTH, 200)
  f:SetFrameStrata("HIGH")
  f:SetClampedToScreen(true)
  f:EnableMouse(true)

  local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
  close:SetPoint("TOPRIGHT", f, "TOPRIGHT", 2, 2)
  close:SetScript("OnClick", function() Panel:Hide(true) end)
  self.closeButton = close

  local ring = f:CreateTexture(nil, "ARTWORK")
  ring:SetSize(36, 36)
  ring:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
  self.ring = ring
  local kick = text(f, "GameFontDisableSmall")
  kick:SetPoint("TOPLEFT", ring, "TOPRIGHT", 8, -2)
  self.kick = kick
  local title = text(f, "GameFontNormalLarge")
  title:SetPoint("BOTTOMLEFT", ring, "BOTTOMRIGHT", 8, 2)
  title:SetText(L.TRAINER_PANEL_TITLE)
  self.title = title

  self.nowHeader = sectionHeader(f)
  self.nowHeader.label:SetText(L.TRAINER_PANEL_NOW)
  self.laterHeader = sectionHeader(f)
  self.laterHeader.label:SetText(L.TRAINER_PANEL_LATER)
  local none = text(f, "GameFontDisable")
  none:SetText(L.TRAINER_PANEL_NONE)
  self.none = none

  local foot = CreateFrame("Frame", nil, f)
  foot:SetSize(WIDTH - 2 * PAD, 20)
  foot.line = foot:CreateTexture(nil, "ARTWORK")
  foot.line:SetHeight(1)
  foot.line:SetPoint("TOPLEFT", foot, "TOPLEFT", 0, 0)
  foot.line:SetPoint("TOPRIGHT", foot, "TOPRIGHT", 0, 0)
  foot.left = text(foot, "GameFontHighlightSmall")
  foot.left:SetPoint("BOTTOMLEFT", foot, "BOTTOMLEFT", 0, 0)
  foot.right = text(foot, "GameFontHighlightSmall", "RIGHT")
  foot.right:SetPoint("BOTTOMRIGHT", foot, "BOTTOMRIGHT", 0, 0)
  self.foot = foot

  f:Hide()
  return f
end

local function levelLabel(i)
  local fs = Panel.levels[i]
  if not fs then
    fs = text(Panel.frame, "GameFontDisableSmall")
    Panel.levels[i] = fs
  end
  return fs
end

local function row(i)
  local r = Panel.rows[i]
  if not r then
    r = newRow(Panel.frame)
    Panel.rows[i] = r
  end
  return r
end

local function place(region, y, x)
  region:ClearAllPoints()
  region:SetPoint("TOPLEFT", Panel.frame, "TOPLEFT", PAD + (x or 0), -y)
end

---------------------------------------------------------------------------
-- Affichage
---------------------------------------------------------------------------
local function className()
  if type(UnitClass) ~= "function" then return "" end
  local ok, name = pcall(UnitClass, "player")
  if not ok or Q.Util.IsSecret(name) or type(name) ~= "string" then return "" end
  return name
end

local function classIcon(tx)
  local cf = Q.Player and Q.Player.classFile
  local tc = type(CLASS_ICON_TCOORDS) == "table" and cf and CLASS_ICON_TCOORDS[cf]
  if type(tc) == "table" then
    tx:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
    tx:SetTexCoord(tc[1], tc[2], tc[3], tc[4])
  else
    tx:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    tx:SetTexCoord(0, 1, 0, 1)
  end
end

-- Remplit une ligne : s = ligne de Q.Trainer:PanelData(), later = sort d'un prochain niveau.
local function fill(r, s, later)
  r.spellID, r.copper = s.spellID, s.cost
  r.label = s.rank and (s.name .. " (" .. s.rank .. ")") or s.name
  r.icon:SetTexture(s.icon or FALLBACK_ICON)
  r.icon:SetDesaturated(later and true or false)
  r.name:SetText(s.name)
  r.rank:SetText(s.rank or "")
  r.cost:SetText(s.cost > 0 and money(s.cost) or L.TRAINER_PANEL_FREE)
  r.lvl:SetFormattedText(L.TRAINER_PANEL_LEVEL, s.level or 0)
  style(r.name, later and "dim" or "body")
  style(r.rank, "dim")
  style(r.lvl, "dim")
  if not later and s.affordable == false then
    r.cost:SetTextColor(BAD[1], BAD[2], BAD[3], 1)
  else
    style(r.cost, later and "dim" or "body")
  end
  r:SetAlpha(later and 0.75 or 1)
  r:Show()
end

-- À droite de la fenêtre du maître de Blizzard (chargée à la demande, parfois affichée juste après
-- TRAINER_SHOW : Show() replace le panneau une image plus tard).
local function anchor(f)
  f:ClearAllPoints()
  local blz = ClassTrainerFrame
  if type(blz) == "table" and blz.GetObjectType then
    f:SetPoint("TOPLEFT", blz, "TOPRIGHT", 4, 0)
  else
    f:SetPoint("LEFT", UIParent, "CENTER", 200, 60)
  end
end

-- Refresh() : redessine le panneau ouvert depuis Q.Trainer:PanelData(). -> nombre de lignes.
function Panel:Refresh()
  local f = self.frame
  if not f then return 0 end
  local data = Q.Trainer and Q.Trainer:PanelData()
  if not data then
    f:Hide()
    return 0
  end
  local th = Q.Themes:Apply(f, theme().key, 1)
  classIcon(self.ring)
  self.kick:SetText(string.format(L.TRAINER_PANEL_KICK, data.level, className()):upper())
  style(self.kick, "dim")
  style(self.title, "title")
  local sepColor = Q.Themes:TextColor("dim", th)
  for _, h in ipairs({ self.nowHeader, self.laterHeader }) do
    style(h.label, "dim")
    style(h.right, "title")
    h.line:SetColorTexture(sepColor[1], sepColor[2], sepColor[3], 0.5)
  end
  self.foot.line:SetColorTexture(sepColor[1], sepColor[2], sepColor[3], 0.5)

  local y = PAD + 36 + 8
  local n = 0
  place(self.nowHeader, y)
  self.nowHeader.right:SetText(#data.now > 0 and string.format(L.TRAINER_PANEL_SUM, #data.now, money(data.cost)) or "")
  y = y + 20
  if #data.now == 0 then
    place(self.none, y, 4)
    style(self.none, "dim")
    self.none:Show()
    y = y + 20
  else
    self.none:Hide()
    for i = 1, math.min(#data.now, MAX_NOW) do
      n = n + 1
      local r = row(n)
      fill(r, data.now[i], false)
      place(r, y)
      y = y + ROW_H
    end
  end

  local labels = 0
  if #data.later > 0 then
    y = y + 4
    place(self.laterHeader, y)
    self.laterHeader:Show()
    y = y + 20
    local shown = 0
    for _, group in ipairs(data.later) do
      if shown >= MAX_LATER then break end
      labels = labels + 1
      local fs = levelLabel(labels)
      fs:SetFormattedText(L.TRAINER_PANEL_LEVEL_HEADER, group.level)
      style(fs, "dim")
      place(fs, y + 2, 4)
      fs:Show()
      y = y + 16
      for _, s in ipairs(group.spells) do
        if shown >= MAX_LATER then break end
        shown = shown + 1
        n = n + 1
        local r = row(n)
        fill(r, s, true)
        place(r, y)
        y = y + ROW_H
      end
    end
  else
    self.laterHeader:Hide()
  end
  for i = n + 1, #self.rows do self.rows[i]:Hide() end
  for i = labels + 1, #self.levels do self.levels[i]:Hide() end

  y = y + 6
  place(self.foot, y)
  if data.money then
    self.foot.left:SetText(string.format(L.TRAINER_PANEL_MONEY, money(data.money)))
  else
    self.foot.left:SetText("")
  end
  style(self.foot.left, "dim")
  if data.missing > 0 then
    self.foot.right:SetText(string.format(L.TRAINER_PANEL_MISSING, money(data.missing)))
    self.foot.right:SetTextColor(BAD[1], BAD[2], BAD[3], 1)
  else
    self.foot.right:SetText("")
  end
  y = y + 20 + PAD
  f:SetHeight(y)
  return n
end

function Panel:Show()
  if setting("trainerPanel") == false then return false end
  self:Create()
  anchor(self.frame)
  self.closed = nil
  self.frame:Show()
  self:Refresh()
  Q:After(0, function()
    if Panel:IsShown() then anchor(Panel.frame) end
  end)
  return self.frame:IsShown()
end

-- Hide(byUser) : fermé par sa croix, il reste fermé jusqu'à la prochaine visite.
function Panel:Hide(byUser)
  if byUser then self.closed = true end
  if self.frame then self.frame:Hide() end
end

function Panel:IsShown() return self.frame ~= nil and self.frame:IsShown() end

Q:On("TRAINER_WINDOW", function(isClass)
  if isClass then Panel:Show() else Panel:Hide() end
end)
Q:On("TRAINER_CHANGED", function()
  if Panel:IsShown() then Panel:Refresh() end
end)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "trainerPanel" and setting("trainerPanel") == false then Panel:Hide() end
  if path == "tracker.theme" and Panel:IsShown() then Panel:Refresh() end
end)
