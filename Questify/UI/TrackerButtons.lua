local addonName, Q = ...

-- Boutons d'accès rapide dans l'en-tête du suivi, à droite du titre du chapitre (UI/Tracker.lua).
-- Beaucoup de joueurs ne retrouvent plus le bouton de la minicarte parmi ceux de leurs addons, alors
-- que le suivi reste à l'écran, à l'endroit qu'ils ont choisi.
--   « route »    : point d'exclamation de quête sur un chemin -> journal, onglet Route ;
--   « dungeons » : portail de donjon (atlas du jeu « dungeon ») et point d'exclamation -> journal,
--                  onglet Donjons ;
--   « class »    : icône de la classe du joueur -> journal, onglet Quêtes de classe ;
--   « options »  : engrenage -> fenêtre d'options.
-- Un second clic sur le bouton de l'onglet ouvert ferme le journal (l'engrenage ferme les options).
-- Lueurs pulsées :
--   Classe brille tant qu'une suite de quêtes de classe est disponible et qu'aucune n'est suivie
--   (ajoutée à la route ou en cours dans le journal de quêtes) ;
--   Donjons brille tant qu'un donjon est conseillé (Dungeons:Suggested) et qu'aucun n'est ajouté à
--   la route.
-- Des boutons simples, jamais sécurisés : un enfant sécurisé rendrait le suivi protégé (impossible
-- à redimensionner en combat).
Q.UI = Q.UI or {}
local Buttons = { buttons = {}, classCount = 0, dungeonCount = 0 }
Q.UI.TrackerButtons = Buttons

local L = Q.L

local SIZE = 18
local GAP = 3
local ORDER = { "route", "dungeons", "class", "options" }
Buttons.ORDER, Buttons.SIZE, Buttons.GAP = ORDER, SIZE, GAP

local QUEST_MARK = "Interface\\GossipFrame\\AvailableQuestIcon"
local ROUTE_PATH = "Interface\\AddOns\\" .. addonName .. "\\Media\\ButtonRoute"
local DUNGEON_ATLAS = "dungeon"
local DUNGEON_FALLBACK = "Interface\\Icons\\INV_Misc_Bone_HumanSkull_01"   -- atlas absent du client
local CLASS_SHEET = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"
local CLASS_FALLBACK = "Interface\\Icons\\INV_Misc_QuestionMark"
local GEAR = "Interface\\Icons\\Trade_Engineering"
local HIGHLIGHT = "Interface\\Buttons\\ButtonHilight-Square"
local ICON_CROP = { 0.08, 0.92, 0.08, 0.92 }   -- bord des icônes de sort et d'objet
local BORDER_COLOR = { 0.72, 0.55, 0.25, 1 }
local BACK_COLOR = { 0.07, 0.05, 0.02, 1 }
local GLOW_COLOR = { 1, 0.78, 0.1, 1 }

local TABS = { route = "route", dungeons = "dungeons", class = "class" }
local NAMES = {
  route = "UI_TRACKER_BTN_ROUTE", dungeons = "UI_TRACKER_BTN_DUNGEONS",
  class = "UI_TRACKER_BTN_CLASS", options = "UI_TRACKER_BTN_OPTIONS",
}
Buttons.TEXTURES = { questMark = QUEST_MARK, routePath = ROUTE_PATH, dungeonAtlas = DUNGEON_ATLAS,
  dungeonFallback = DUNGEON_FALLBACK, classSheet = CLASS_SHEET, classFallback = CLASS_FALLBACK, gear = GEAR }

-- Largeur de la rangée de boutons (le titre du chapitre s'arrête avant).
function Buttons:Width()
  return #ORDER * SIZE + (#ORDER - 1) * GAP
end

---------------------------------------------------------------------------
-- Lueurs
---------------------------------------------------------------------------
-- États d'une suite de quêtes de classe que le joueur suit (Engine/ClassQuests.lua).
local FOLLOWED = { added = true, inprogress = true }

-- ClassGlow() -> nombre de suites disponibles quand aucune n'est suivie, sinon 0.
function Buttons.ClassGlow()
  local cq = Q.ClassQuests
  if not (cq and cq.List) then return 0 end
  local ok, list = pcall(cq.List, cq)
  if not ok then
    Q:ReportError(list)
    return 0
  end
  local available = 0
  for _, row in ipairs(type(list) == "table" and list or {}) do
    if FOLLOWED[row.state] then return 0 end
    if row.state == "available" then available = available + 1 end
  end
  return available
end

-- DungeonGlow() -> nombre de donjons conseillés quand aucun n'est ajouté à la route, sinon 0.
function Buttons.DungeonGlow()
  local D = Q.Dungeons
  if not (D and D.List and D.Suggested) then return 0 end
  local ok, list = pcall(D.List, D)
  if not ok then
    Q:ReportError(list)
    return 0
  end
  for _, row in ipairs(type(list) == "table" and list or {}) do
    if row.state == "added" then return 0 end
  end
  local ok2, suggested = pcall(D.Suggested, D)
  if not ok2 then
    Q:ReportError(suggested)
    return 0
  end
  return type(suggested) == "table" and #suggested or 0
end

local function setGlow(b, on)
  if on then
    b.glow:Show()
    if not b.pulse:IsPlaying() then b.pulse:Play() end
  else
    b.pulse:Stop()
    b.glow:Hide()
  end
end

function Buttons:UpdateGlows()
  if not self.frame then return end
  self.classCount = Buttons.ClassGlow()
  self.dungeonCount = Buttons.DungeonGlow()
  setGlow(self.buttons.class, self.classCount > 0)
  setGlow(self.buttons.dungeons, self.dungeonCount > 0)
end

---------------------------------------------------------------------------
-- Clics et infobulles
---------------------------------------------------------------------------
-- Click(clé) : ouvre le journal sur l'onglet du bouton ; s'il y est déjà, le ferme. L'engrenage
-- ouvre ou ferme la fenêtre d'options.
function Buttons:Click(key)
  if key == "options" then
    local O = Q.UI.Options
    if O then O:Toggle() end
    return
  end
  local J = Q.UI.Journal
  local tab = TABS[key]
  if not (J and tab) then return end
  if J:IsShown() and J.tab == J:ResolveTab(tab) then
    J.frame:Hide()
  else
    J:ShowTab(tab)
  end
end

function Buttons:Tooltip(owner, key)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(L[NAMES[key]], 1, 0.82, 0)
  if key == "class" and self.classCount > 0 then
    GameTooltip:AddLine(string.format(L.UI_TRACKER_BTN_CLASS_GLOW, self.classCount), 1, 1, 1, true)
  elseif key == "dungeons" and self.dungeonCount > 0 then
    GameTooltip:AddLine(string.format(L.UI_TRACKER_BTN_DUNGEON_GLOW, self.dungeonCount), 1, 1, 1, true)
  end
  GameTooltip:AddLine(L.UI_TRACKER_BTN_HINT, 0.7, 0.7, 0.7, true)
  GameTooltip:Show()
end

local function hideTooltip()
  if GameTooltip then GameTooltip:Hide() end
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
-- Coordonnées de la classe du joueur dans la planche des icônes de classe, ou nil.
local function classCoords()
  local cf = Q.Player and Q.Player.classFile
  if not cf and UnitClass then cf = select(2, UnitClass("player")) end
  local all = CLASS_ICON_TCOORDS
  return type(all) == "table" and cf and all[cf] or nil
end

local function inset(tex, b, px)
  tex:ClearAllPoints()
  tex:SetPoint("TOPLEFT", b, "TOPLEFT", px, -px)
  tex:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -px, px)
end

-- Point d'exclamation de quête dans le coin haut droit du bouton.
local function questMark(b)
  local m = b:CreateTexture(nil, "OVERLAY")
  m:SetTexture(QUEST_MARK)
  m:SetSize(math.floor(SIZE * 0.62 + 0.5), math.floor(SIZE * 0.62 + 0.5))
  m:SetPoint("TOPRIGHT", b, "TOPRIGHT", 1, 1)
  return m
end

-- IconMarkup(clé, taille) -> icône du bouton en séquence de texte (|T…|t ou |A…|a), pour les onglets
-- du journal. Route et Donjons : le symbole principal seul (chemin ou « ! » illisibles à cette taille).
function Buttons.IconMarkup(key, size)
  size = size or 14
  if key == "route" then
    return string.format("|T%s:%d:%d|t", QUEST_MARK, size, size)
  elseif key == "dungeons" then
    if Q.Util.HasAtlas(DUNGEON_ATLAS) then return string.format("|A:%s:%d:%d|a", DUNGEON_ATLAS, size, size) end
    return string.format("|T%s:%d:%d|t", DUNGEON_FALLBACK, size, size)
  elseif key == "class" then
    local c = classCoords()
    if c then
      return string.format("|T%s:%d:%d:0:0:256:256:%d:%d:%d:%d|t", CLASS_SHEET, size, size,
        math.floor(c[1] * 256 + 0.5), math.floor(c[2] * 256 + 0.5), math.floor(c[3] * 256 + 0.5),
        math.floor(c[4] * 256 + 0.5))
    end
    return string.format("|T%s:%d:%d|t", CLASS_FALLBACK, size, size)
  end
  return ""
end

-- Icône de la classe du joueur (la classe est connue à la connexion : refaite tant qu'elle manque).
function Buttons:SetClassIcon()
  local b = self.buttons.class
  if not b then return end
  local coords = classCoords()
  if coords then
    b.icon:SetTexture(CLASS_SHEET)
    b.icon:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
    self.classIconSet = true
  else
    b.icon:SetTexture(CLASS_FALLBACK)
    b.icon:SetTexCoord(ICON_CROP[1], ICON_CROP[2], ICON_CROP[3], ICON_CROP[4])
  end
end

local function newButton(f, key)
  local b = CreateFrame("Button", nil, f)
  b:SetSize(SIZE, SIZE)
  b:RegisterForClicks("LeftButtonUp")
  b:SetFrameLevel((f:GetFrameLevel() or 1) + 4)
  -- lueur derrière le bouton, qui dépasse de 2 pixels
  local glow = b:CreateTexture(nil, "BACKGROUND", nil, -2)
  glow:SetColorTexture(GLOW_COLOR[1], GLOW_COLOR[2], GLOW_COLOR[3], GLOW_COLOR[4])
  glow:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
  glow:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
  glow:Hide()
  local pulse = glow:CreateAnimationGroup()
  pulse:SetLooping("BOUNCE")
  local fade = pulse:CreateAnimation("Alpha")
  fade:SetFromAlpha(0.15)
  fade:SetToAlpha(0.95)
  fade:SetDuration(0.8)
  -- liseré doré et fond sombre
  local border = b:CreateTexture(nil, "BACKGROUND", nil, -1)
  border:SetAllPoints(b)
  border:SetColorTexture(BORDER_COLOR[1], BORDER_COLOR[2], BORDER_COLOR[3], BORDER_COLOR[4])
  local back = b:CreateTexture(nil, "BACKGROUND", nil, 0)
  inset(back, b, 1)
  back:SetColorTexture(BACK_COLOR[1], BACK_COLOR[2], BACK_COLOR[3], BACK_COLOR[4])
  local icon = b:CreateTexture(nil, "ARTWORK")
  inset(icon, b, 1)
  b:SetHighlightTexture(HIGHLIGHT, "ADD")
  b.key, b.glow, b.pulse, b.border, b.icon = key, glow, pulse, border, icon
  b:SetScript("OnClick", function() Q.SafeCall(Buttons.Click, Buttons, key) end)
  b:SetScript("OnEnter", function(btn) Q.SafeCall(Buttons.Tooltip, Buttons, btn, key) end)
  b:SetScript("OnLeave", hideTooltip)
  return b
end

-- Create(frame) : boutons du suivi (une seule fois par cadre).
function Buttons:Create(f)
  if self.frame == f then return end
  self.frame = f
  self.buttons = {}
  for _, key in ipairs(ORDER) do self.buttons[key] = newButton(f, key) end
  local B = self.buttons
  -- Route : chemin en pointillés et point d'exclamation
  B.route.icon:SetTexture(ROUTE_PATH)
  B.route.mark = questMark(B.route)
  -- Donjons : portail de la carte et point d'exclamation
  if Q.Util.HasAtlas(DUNGEON_ATLAS) then
    B.dungeons.icon:SetAtlas(DUNGEON_ATLAS)
    inset(B.dungeons.icon, B.dungeons, 2)
  else
    B.dungeons.icon:SetTexture(DUNGEON_FALLBACK)
    B.dungeons.icon:SetTexCoord(ICON_CROP[1], ICON_CROP[2], ICON_CROP[3], ICON_CROP[4])
  end
  B.dungeons.mark = questMark(B.dungeons)
  -- Classe
  self.classIconSet = false
  self:SetClassIcon()
  -- Options
  B.options.icon:SetTexture(GEAR)
  B.options.icon:SetTexCoord(ICON_CROP[1], ICON_CROP[2], ICON_CROP[3], ICON_CROP[4])
end

-- Layout(frame, pad) : boutons en haut à droite du suivi, de gauche à droite dans l'ordre ORDER,
-- puis lueurs à jour.
function Buttons:Layout(f, pad)
  self:Create(f)
  if not self.classIconSet then self:SetClassIcon() end
  local n = #ORDER
  for i, key in ipairs(ORDER) do
    local b = self.buttons[key]
    b:ClearAllPoints()
    b:SetPoint("TOPRIGHT", f, "TOPRIGHT", -(pad + (n - i) * (SIZE + GAP)), -(pad - 2))
    b:Show()
  end
  self:UpdateGlows()
end
