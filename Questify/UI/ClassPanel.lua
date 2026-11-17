local addonName, Q = ...

-- Panneau « Classe » des options (section classguide de Core/OptionsSchema.lua, affiché par
-- UI/Options.lua à la place de la liste) : sélecteur Talents | Macros, pour la classe du joueur seulement.
-- Maquette validée : docs/media/apercus/classe/maquette.png (source docs/media/apercus/src/classe/).
--   Talents : trois spécialisations (choix gardé pour le personnage, sinon l'arbre où il a le plus de
--             points), un arbre à la fois (pris, suivant, plus tard avec le niveau prévu), prochain
--             point avec l'explication du guide, cinq points à venir, écart au guide, crédit.
--   Macros  : filtres PvE / PvP, spé, origine ; texte traduit par le jeu ; Créer (personnage ou compte),
--             Mettre à jour une macro créée par Questify ; crédit et mise en garde du site.
-- Données et règles : Engine/ClassGuide.lua, Engine/ClassMacros.lua. Couleurs : jetons du thème
-- (Q.Themes:Color quand il existe, sinon la palette « Questify »).
Q.UI = Q.UI or {}
local Panel = { tab = "talents", treeGroup = nil, cards = {}, nodes = {}, rows = {}, macroCards = {} }
Q.UI.ClassPanel = Panel

local L = Q.L
local WHITE = "Interface\\Buttons\\WHITE8X8"
local ICONS = "Interface\\Icons\\"
local PAD = 10
local NODE, COL_W, ROW_H = 30, 48, 36
local TREE_W, TREE_H = 206, 7 * ROW_H + 12
local CARD_ACT_W = 104
local UPCOMING = 5

---------------------------------------------------------------------------
-- Couleurs (jetons du thème)
---------------------------------------------------------------------------
local FALLBACK = {
  bg = "0c1724", panel = "102030", panelAlt = "15283b", sidebar = "09121c", edge = "2a4258", line = "1d3346",
  text = "eef3f7", textDim = "b9c7d3", textMuted = "8fa0b0", accent = "3fd0e6", onAccent = "04161d",
  quest = "ffd773", success = "6bd99a", warning = "fabf4d", danger = "f57373", sel = "123a4a", code = "060d15",
}

local function hexColor(h)
  return tonumber(h:sub(1, 2), 16) / 255, tonumber(h:sub(3, 4), 16) / 255, tonumber(h:sub(5, 6), 16) / 255, 1
end

-- color(rôle) -> r, g, b, a : thème en vigueur (Q.Themes:Color) sinon palette par défaut.
local function color(role)
  local T = Q.Themes
  if T and T.Color then
    local ok, r, g, b, a = pcall(T.Color, T, role)
    if ok and type(r) == "number" then return r, g, b, a or 1 end
  end
  return hexColor(FALLBACK[role] or FALLBACK.text)
end
Panel.Color = color

local function hex(role)
  local r, g, b = color(role)
  return string.format("ff%02x%02x%02x", math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

local function paint(tex, role, alpha)
  local r, g, b, a = color(role)
  tex:SetColorTexture(r, g, b, alpha or a or 1)
end

local function ink(fs, role)
  local r, g, b = color(role)
  fs:SetTextColor(r, g, b, 1)
end

local function colored(role, text) return "|c" .. hex(role) .. tostring(text) .. "|r" end

---------------------------------------------------------------------------
-- Briques
---------------------------------------------------------------------------
local function text(parent, template, role, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
  fs:SetJustifyH(justify or "LEFT")
  if fs.SetWordWrap then fs:SetWordWrap(false) end
  if role then ink(fs, role) end
  fs.qvRole = role
  return fs
end

local function wrap(fs) if fs.SetWordWrap then fs:SetWordWrap(true) end return fs end

local function rect(parent, role, layer, alpha)
  local t = parent:CreateTexture(nil, layer or "BACKGROUND")
  paint(t, role, alpha)
  t.qvRole, t.qvAlpha = role, alpha
  return t
end

-- Cadre 1 px (bordure) autour d'un frame.
local function border(f, role)
  local edges = {}
  for i, spec in ipairs({ { "TOPLEFT", "TOPRIGHT", nil, 1 }, { "BOTTOMLEFT", "BOTTOMRIGHT", nil, 1 },
      { "TOPLEFT", "BOTTOMLEFT", 1, nil }, { "TOPRIGHT", "BOTTOMRIGHT", 1, nil } }) do
    local t = rect(f, role, "BORDER")
    t:SetPoint(spec[1], f, spec[1], 0, 0)
    t:SetPoint(spec[2], f, spec[2], 0, 0)
    if spec[3] then t:SetWidth(spec[3]) end
    if spec[4] then t:SetHeight(spec[4]) end
    edges[i] = t
  end
  f.qvEdges = edges
  return edges
end

local function setBorder(f, role)
  for _, t in ipairs(f.qvEdges or {}) do t.qvRole = role; paint(t, role) end
end

-- Bouton : "primary" (accent), "secondary" (contrôle), "ghost" (transparent), "done" (succès).
local function button(parent, label, kind, onClick)
  local b = CreateFrame("Button", nil, parent)
  b:SetHeight(20)
  b.bg = rect(b, "panelAlt", "BACKGROUND")
  b.bg:SetAllPoints(b)
  border(b, "edge")
  b.label = text(b, "GameFontHighlightSmall", "text", "CENTER")
  b.label:SetPoint("CENTER", b, "CENTER", 0, 0)
  local hl = b:CreateTexture(nil, "HIGHLIGHT")
  hl:SetAllPoints(b)
  hl:SetColorTexture(1, 1, 1, 0.10)
  b:RegisterForClicks("LeftButtonUp")
  if onClick then b:SetScript("OnClick", function(self) Q.SafeCall(onClick, self) end) end
  function b:SetKind(k)
    self.kind = k
    if k == "primary" then
      paint(self.bg, "accent"); setBorder(self, "accent"); ink(self.label, "onAccent")
    elseif k == "done" then
      paint(self.bg, "panelAlt", 0); setBorder(self, "success"); ink(self.label, "success")
    elseif k == "ghost" then
      paint(self.bg, "panelAlt", 0); setBorder(self, "edge"); ink(self.label, "textDim")
    else
      paint(self.bg, "panelAlt"); setBorder(self, "edge"); ink(self.label, "text")
    end
  end
  function b:SetLabel(s)
    self.label:SetText(s)
    self:SetWidth(math.max(self.minWidth or 0, (tonumber(self.label:GetStringWidth()) or 40) + 20))
  end
  b:SetKind(kind or "secondary")
  b:SetLabel(label or "")
  return b
end
Panel.Button = button

-- Sélecteur segmenté : items = { { value, label } } ; onPick(value).
local function segmented(parent, onPick, height)
  local seg = CreateFrame("Frame", nil, parent)
  seg:SetHeight(height or 20)
  seg.items = {}
  border(seg, "edge")
  function seg:Set(items, current)
    local x = 1
    for i, it in ipairs(items) do
      local b = self.items[i]
      if not b then
        b = CreateFrame("Button", nil, self)
        b.bg = rect(b, "panelAlt", "BACKGROUND")
        b.bg:SetAllPoints(b)
        b.line = rect(b, "accent", "ARTWORK")
        b.line:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 0, 0)
        b.line:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
        b.line:SetHeight(2)
        b.sep = rect(b, "edge", "BORDER")
        b.sep:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 0)
        b.sep:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", -1, 0)
        b.sep:SetWidth(1)
        b.label = text(b, "GameFontHighlightSmall", "textDim", "CENTER")
        b.label:SetPoint("CENTER", b, "CENTER", 0, 0)
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints(b)
        hl:SetColorTexture(1, 1, 1, 0.08)
        b:RegisterForClicks("LeftButtonUp")
        b:SetScript("OnClick", function(btn) Q.SafeCall(onPick, btn.value) end)
        self.items[i] = b
      end
      b.value = it[1]
      b.label:SetText(it[2])
      local w = (tonumber(b.label:GetStringWidth()) or 30) + 18
      b:ClearAllPoints()
      b:SetPoint("TOPLEFT", self, "TOPLEFT", x, -1)
      b:SetSize(w, (height or 20) - 2)
      local on = it[1] == current
      b.on = on
      if on then paint(b.bg, "sel") else paint(b.bg, "panelAlt") end
      ink(b.label, on and "text" or "textDim")
      if on then b.line:Show() else b.line:Hide() end
      if i == 1 then b.sep:Hide() else b.sep:Show() end
      b:Show()
      x = x + w
    end
    for i = #items + 1, #self.items do self.items[i]:Hide() end
    self:SetWidth(x + 1)
  end
  return seg
end

-- Titre de groupe : petites capitales discrètes, filet dessous, texte à droite.
local function heading(parent)
  local h = CreateFrame("Frame", nil, parent)
  h:SetHeight(16)
  h.left = text(h, "GameFontNormalSmall", "textMuted")
  h.left:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 4)
  h.right = text(h, "GameFontHighlightSmall", "textMuted", "RIGHT")
  h.right:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 4)
  local line = rect(h, "line", "ARTWORK")
  line:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 0)
  line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 0)
  line:SetHeight(1)
  function h:Set(left, right, rightRole)
    self.left:SetText(string.upper(left or ""))
    self.right:SetText(right or "")
    ink(self.right, rightRole or "textMuted")
  end
  return h
end

local function iconPath(name)
  if not name or name == "" then return ICONS .. "INV_Misc_QuestionMark" end
  return ICONS .. name
end

local function showTip(owner, lines)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:ClearLines()
  for i, l in ipairs(lines) do
    if type(l) == "table" then
      GameTooltip:AddLine(l[1], l[2] or 1, l[3] or 1, l[4] or 1, true)
    elseif i == 1 then
      GameTooltip:AddLine(l, 1, 0.82, 0)
    else
      GameTooltip:AddLine(l, 1, 1, 1, true)
    end
  end
  GameTooltip:Show()
end
local function hideTip() if GameTooltip then GameTooltip:Hide() end end

local function className()
  if UnitClass then
    local name = UnitClass("player")
    if type(name) == "string" and not Q.Util.IsSecret(name) then return name end
  end
  return Q.Player and Q.Player.classFile or ""
end

local function dateText(iso)
  local y, m, d = tostring(iso or ""):match("^(%d+)-(%d+)-(%d+)$")
  if not y then return iso or "" end
  return string.format("%d/%d/%s", tonumber(d), tonumber(m), y)
end

local function shortUrl(url) return (tostring(url or ""):gsub("^https?://", ""):gsub("/$", "")) end

---------------------------------------------------------------------------
-- Copie d'un lien (crédit cliquable)
---------------------------------------------------------------------------
local COPY_DIALOG = "QUESTIFY_CLASS_COPY_URL"
function Panel:CopyUrl(url)
  if not StaticPopupDialogs then return end
  StaticPopupDialogs[COPY_DIALOG] = StaticPopupDialogs[COPY_DIALOG] or {
    text = L.CLASS_COPY_TITLE, button1 = OKAY or "OK", hasEditBox = true, editBoxWidth = 320,
    timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3,
    OnShow = function(self, data)
      local eb = self.editBox or self.EditBox
      if eb then eb:SetText(data or ""); eb:HighlightText(); eb:SetFocus() end
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
    EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
  }
  self.copied = url
  if StaticPopup_Show then StaticPopup_Show(COPY_DIALOG, nil, nil, url) end
end

local function creditLine(parent)
  local b = CreateFrame("Button", nil, parent)
  b.text = wrap(text(b, "GameFontHighlightSmall", "textMuted"))
  b.text:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
  b.text:SetPoint("TOPRIGHT", b, "TOPRIGHT", 0, 0)
  b:SetScript("OnClick", function(self) Q.SafeCall(Panel.CopyUrl, Panel, self.url) end)
  b:SetScript("OnEnter", function(self) showTip(self, { L.CLASS_CREDIT_COPY, self.url or "" }) end)
  b:SetScript("OnLeave", hideTip)
  function b:Set(s, url)
    self.url = url
    self.text:SetText(s)
    self:SetHeight(math.max(12, tonumber(self.text:GetStringHeight()) or 12))
  end
  return b
end

---------------------------------------------------------------------------
-- Cadre
---------------------------------------------------------------------------
function Panel:Create(parent)
  if self.frame then
    if parent and self.frame:GetParent() ~= parent then self.frame:SetParent(parent) end
    return self.frame
  end
  local f = CreateFrame("Frame", "QuestifyClassPanel", parent or UIParent)
  self.frame = f
  f:Hide()

  self.title = text(f, "GameFontNormalLarge", "text")
  self.title:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -2)
  self.subtitle = text(f, "GameFontHighlightSmall", "textMuted")
  self.subtitle:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", 0, -2)
  self.tabs = segmented(f, function(v) Panel:ShowTab(v) end, 24)
  self.tabs:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, -2)

  -- Talents
  local t = CreateFrame("Frame", nil, f)
  t:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -40)
  t:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
  self.talents = t
  self:CreateTalents(t)

  -- Macros
  local m = CreateFrame("Frame", nil, f)
  m:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -40)
  m:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
  self.macros = m
  self:CreateMacros(m)

  self.empty = wrap(text(f, "GameFontHighlight", "textDim"))
  self.empty:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -50)
  self.empty:SetPoint("RIGHT", f, "RIGHT", 0, 0)
  self.empty:SetText(L.CLASS_NO_DATA)
  return f
end

-- Attach(fenêtre, zone) : appelé par Options:ShowPanel ; le panneau prend la place de la liste.
function Panel:Attach(owner, area)
  local f = self:Create(owner)
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", area, "TOPLEFT", 4, -2)
  f:SetPoint("BOTTOMRIGHT", area, "BOTTOMRIGHT", 22, -24)
  f:Show()
  self:Refresh()
end

function Panel:Detach()
  if self.frame then self.frame:Hide() end
  hideTip()
end

function Panel:IsShown() return self.frame ~= nil and self.frame:IsShown() end

-- Open("talents" | "macros") : fenêtre d'options sur la section Classe, à cet onglet.
function Panel:Open(tab)
  if tab then self.tab = tab end
  local O = Q.UI.Options
  if O then O:Open("classguide") end
end

function Panel:ShowTab(tab)
  self.tab = tab == "macros" and "macros" or "talents"
  self:Refresh()
end

function Panel:Refresh()
  if not self:IsShown() then return end
  local hasData = Q.ClassGuide:Specs() ~= nil
  self.title:SetText(string.format(L.CLASS_TITLE, className()))
  self.tabs:Set({ { "talents", L.CLASS_TAB_TALENTS }, { "macros", L.CLASS_TAB_MACROS } }, self.tab)
  if not hasData then
    self.talents:Hide(); self.macros:Hide(); self.empty:Show()
    self.subtitle:SetText("")
    return
  end
  self.empty:Hide()
  if self.tab == "macros" then
    self.talents:Hide(); self.macros:Show()
    self.subtitle:SetText(L.CLASS_SUB_MACROS)
    self:RenderMacros()
  else
    self.macros:Hide(); self.talents:Show()
    self.subtitle:SetText(L.CLASS_SUB_TALENTS)
    self:RenderTalents()
  end
end

---------------------------------------------------------------------------
-- Talents
---------------------------------------------------------------------------
local function specCard(parent, i)
  local c = CreateFrame("Button", nil, parent)
  c:SetHeight(34)
  c.bg = rect(c, "panelAlt", "BACKGROUND")
  c.bg:SetAllPoints(c)
  border(c, "edge")
  c.icon = c:CreateTexture(nil, "ARTWORK")
  c.icon:SetSize(24, 24)
  c.icon:SetPoint("LEFT", c, "LEFT", 6, 0)
  if c.icon.SetTexCoord then c.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
  c.name = text(c, "GameFontNormal", "text")
  c.name:SetPoint("TOPLEFT", c.icon, "TOPRIGHT", 7, 1)
  c.tag = text(c, "GameFontDisableSmall", "textMuted")
  c.tag:SetPoint("BOTTOMLEFT", c.icon, "BOTTOMRIGHT", 7, -1)
  c.tag:SetPoint("RIGHT", c, "RIGHT", -26, 0)
  c.points = text(c, "GameFontHighlightSmall", "textDim", "RIGHT")
  c.points:SetPoint("RIGHT", c, "RIGHT", -7, 0)
  c.auto = CreateFrame("Frame", nil, c)
  c.auto:SetHeight(11)
  c.auto:SetPoint("TOPRIGHT", c, "TOPRIGHT", -4, 6)
  c.auto.bg = rect(c.auto, "quest", "ARTWORK")
  c.auto.bg:SetAllPoints(c.auto)
  c.auto.text = text(c.auto, "GameFontNormalSmall", "onAccent", "CENTER")
  c.auto.text:SetPoint("CENTER", c.auto, "CENTER", 0, 0)
  c.auto.text:SetText(L.CLASS_SPEC_AUTO)
  c.auto:SetWidth((tonumber(c.auto.text:GetStringWidth()) or 50) + 6)
  local hl = c:CreateTexture(nil, "HIGHLIGHT")
  hl:SetAllPoints(c)
  hl:SetColorTexture(1, 1, 1, 0.06)
  c:RegisterForClicks("LeftButtonUp")
  c:SetScript("OnClick", function(self)
    if self.key then Q.ClassGuide:Choose(self.key); Panel.treeGroup = nil; Panel:Refresh() end
  end)
  c:SetScript("OnEnter", function(self)
    showTip(self, { L.CLASS_SPEC_TIP, L.CLASS_SPEC_TIP_AUTO })
  end)
  -- pastille (« tes points » ou « ton choix ») à la largeur de son texte
  function c.auto:SetLabel(s)
    self.text:SetText(s)
    self:SetWidth((tonumber(self.text:GetStringWidth()) or 50) + 6)
  end
  c:SetScript("OnLeave", hideTip)
  c.index = i
  return c
end

local function treeNode(parent)
  local n = CreateFrame("Button", nil, parent)
  n:SetSize(NODE, NODE)
  n.ring = rect(n, "accent", "BACKGROUND")
  n.ring:SetPoint("TOPLEFT", n, "TOPLEFT", -2, 2)
  n.ring:SetPoint("BOTTOMRIGHT", n, "BOTTOMRIGHT", 2, -2)
  n.edge = rect(n, "edge", "BORDER")
  n.edge:SetPoint("TOPLEFT", n, "TOPLEFT", -1, 1)
  n.edge:SetPoint("BOTTOMRIGHT", n, "BOTTOMRIGHT", 1, -1)
  n.icon = n:CreateTexture(nil, "ARTWORK")
  n.icon:SetAllPoints(n)
  if n.icon.SetTexCoord then n.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
  -- étiquette du rang (bas droit) et du niveau prévu (haut gauche)
  local function tagFrame(point, x, y)
    local tg = CreateFrame("Frame", nil, n)
    tg:SetHeight(11)
    tg:SetPoint(point, n, point, x, y)
    tg:SetFrameLevel((n:GetFrameLevel() or 1) + 2)
    tg.bg = rect(tg, "bg", "BACKGROUND")
    tg.bg:SetAllPoints(tg)
    border(tg, "edge")
    tg.text = text(tg, "GameFontHighlightSmall", "textDim", "CENTER")
    tg.text:SetPoint("CENTER", tg, "CENTER", 0, 0)
    function tg:Set(s, role, bgRole)
      self.text:SetText(s)
      ink(self.text, role)
      paint(self.bg, bgRole or "bg")
      setBorder(self, bgRole == "accent" and "accent" or role)
      self:SetWidth((tonumber(self.text:GetStringWidth()) or 14) + 6)
      self:Show()
    end
    return tg
  end
  n.rank = tagFrame("BOTTOMRIGHT", 6, -6)
  n.level = tagFrame("TOPLEFT", -5, 6)
  n:SetScript("OnEnter", function(self) Q.SafeCall(Panel.NodeTooltip, Panel, self) end)
  n:SetScript("OnLeave", hideTip)
  return n
end

function Panel:CreateTalents(t)
  self.specHead = heading(t)
  self.specHead:SetPoint("TOPLEFT", t, "TOPLEFT", 0, 0)
  self.specHead:SetPoint("TOPRIGHT", t, "TOPRIGHT", 0, 0)
  for i = 1, 3 do self.cards[i] = specCard(t, i) end
  -- mode : suivre l'arbre où le joueur a le plus de points, ou la spé choisie à la main
  self.specMode = segmented(t, function(v)
    local G = Q.ClassGuide
    if v == "auto" then
      G:Choose(nil)
    else
      local cur = G:Current(G:Tree())
      if cur then G:Choose(cur.key) end
    end
    Panel.treeGroup = nil
    Panel:Refresh()
  end, 18)
  self.specMode:SetPoint("TOPRIGHT", t, "TOPRIGHT", 0, 2)

  -- arbre
  local box = CreateFrame("Frame", nil, t)
  box:SetSize(TREE_W, TREE_H + 24)
  self.treeBox = box
  self.treeTabs = {}
  for i = 1, 3 do
    local b = CreateFrame("Button", nil, box)
    b:SetSize(TREE_W / 3, 18)
    b:SetPoint("TOPLEFT", box, "TOPLEFT", (i - 1) * TREE_W / 3, 0)
    -- icône de l'arbre et points dépensés : le nom (trop long pour un tiers de l'arbre) en infobulle
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(14, 14)
    b.icon:SetPoint("RIGHT", b, "CENTER", -2, 1)
    if b.icon.SetTexCoord then b.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
    b.label = text(b, "GameFontHighlightSmall", "textMuted", "LEFT")
    b.label:SetPoint("LEFT", b, "CENTER", 2, 1)
    b:SetScript("OnEnter", function(self) if self.name then showTip(self, { self.name }) end end)
    b:SetScript("OnLeave", hideTip)
    b.line = rect(b, "accent", "ARTWORK")
    b.line:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 6, 0)
    b.line:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -6, 0)
    b.line:SetHeight(2)
    b:RegisterForClicks("LeftButtonUp")
    b:SetScript("OnClick", function(self) Panel.treeGroup = self.group; Panel:RenderTalents() end)
    self.treeTabs[i] = b
  end
  local rule = rect(box, "line", "ARTWORK")
  rule:SetPoint("TOPLEFT", box, "TOPLEFT", 0, -18)
  rule:SetPoint("TOPRIGHT", box, "TOPRIGHT", 0, -18)
  rule:SetHeight(1)
  local tree = CreateFrame("Frame", nil, box)
  tree:SetPoint("TOPLEFT", box, "TOPLEFT", 0, -24)
  tree:SetSize(TREE_W, TREE_H)
  tree.bg = rect(tree, "sidebar", "BACKGROUND")
  tree.bg:SetAllPoints(tree)
  tree.art = tree:CreateTexture(nil, "BACKGROUND", nil, 1)
  tree.art:SetPoint("CENTER", tree, "CENTER", 0, 0)
  tree.art:SetSize(140, 140)
  tree.art:SetAlpha(0.06)
  border(tree, "edge")
  self.tree = tree
  self.legend = text(box, "GameFontDisableSmall", "textMuted")
  self.legend:SetPoint("TOPLEFT", tree, "BOTTOMLEFT", 0, -5)

  -- colonne de droite
  local right = CreateFrame("Frame", nil, t)
  self.right = right
  self.nextHead = heading(right)
  self.nextHead:SetPoint("TOPLEFT", right, "TOPLEFT", 0, 0)
  self.nextHead:SetPoint("TOPRIGHT", right, "TOPRIGHT", 0, 0)
  local nc = CreateFrame("Frame", nil, right)
  nc:SetPoint("TOPLEFT", self.nextHead, "BOTTOMLEFT", 0, -6)
  nc:SetPoint("TOPRIGHT", self.nextHead, "BOTTOMRIGHT", 0, -6)
  nc.bg = rect(nc, "panel", "BACKGROUND")
  nc.bg:SetAllPoints(nc)
  border(nc, "edge")
  nc.bar = rect(nc, "accent", "ARTWORK")
  nc.bar:SetPoint("TOPLEFT", nc, "TOPLEFT", 0, 0)
  nc.bar:SetPoint("BOTTOMLEFT", nc, "BOTTOMLEFT", 0, 0)
  nc.bar:SetWidth(2)
  nc.icon = nc:CreateTexture(nil, "ARTWORK")
  nc.icon:SetSize(38, 38)
  nc.icon:SetPoint("TOPLEFT", nc, "TOPLEFT", 10, -9)
  if nc.icon.SetTexCoord then nc.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
  nc.meta = text(nc, "GameFontHighlightSmall", "textMuted")
  nc.meta:SetPoint("TOPLEFT", nc.icon, "TOPRIGHT", 10, 1)
  nc.name = text(nc, "GameFontNormalLarge", "accent")
  nc.name:SetPoint("TOPLEFT", nc.meta, "BOTTOMLEFT", 0, -2)
  nc.why = wrap(text(nc, "GameFontHighlightSmall", "textDim"))
  nc.why:SetPoint("TOPLEFT", nc.name, "BOTTOMLEFT", 0, -3)
  nc.why:SetPoint("RIGHT", nc, "RIGHT", -10, 0)
  self.nextCard = nc
  self.upHead = heading(right)
  self.upHead:SetPoint("TOPLEFT", nc, "BOTTOMLEFT", 0, -10)
  self.upHead:SetPoint("TOPRIGHT", nc, "BOTTOMRIGHT", 0, -10)
  for i = 1, UPCOMING do
    local r = CreateFrame("Button", nil, right)
    r:SetHeight(20)
    r:SetPoint("TOPLEFT", self.upHead, "BOTTOMLEFT", 0, -2 - (i - 1) * 20)
    r:SetPoint("TOPRIGHT", self.upHead, "BOTTOMRIGHT", 0, -2 - (i - 1) * 20)
    r.lv = text(r, "GameFontHighlightSmall", "textMuted")
    r.lv:SetPoint("LEFT", r, "LEFT", 0, 0)
    r.lv:SetWidth(40)
    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetSize(16, 16)
    r.icon:SetPoint("LEFT", r, "LEFT", 42, 0)
    if r.icon.SetTexCoord then r.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
    r.name = text(r, "GameFontHighlightSmall", "text")
    r.name:SetPoint("LEFT", r.icon, "RIGHT", 8, 0)
    r.rank = text(r, "GameFontHighlightSmall", "textMuted", "RIGHT")
    r.rank:SetPoint("RIGHT", r, "RIGHT", 0, 0)
    local line = rect(r, "line", "ARTWORK")
    line:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 0, 0)
    line:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", 0, 0)
    line:SetHeight(1)
    r:SetScript("OnEnter", function(self)
      if self.spell then Q.SafeCall(Panel.SpellTooltip, Panel, self, self.spell) end
    end)
    r:SetScript("OnLeave", hideTip)
    self.rows[i] = r
  end
  self.extraText = wrap(text(right, "GameFontHighlightSmall", "warning"))
  self.noTree = wrap(text(right, "GameFontHighlightSmall", "textMuted"))
  self.talentCredit = creditLine(t)
  self.talentCredit:SetPoint("BOTTOMLEFT", t, "BOTTOMLEFT", 0, 4)
  self.talentCredit:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", 0, 4)
  local rule2 = rect(t, "line", "ARTWORK")
  rule2:SetPoint("BOTTOMLEFT", self.talentCredit, "TOPLEFT", 0, 5)
  rule2:SetPoint("BOTTOMRIGHT", self.talentCredit, "TOPRIGHT", 0, 5)
  rule2:SetHeight(1)
end

-- Infobulle d'un nœud : nom, rang, ce que prévoit le guide, explication de l'étape.
function Panel:NodeTooltip(n)
  local G, spec, st = Q.ClassGuide, self.spec, self.state
  if not (n.node and spec and st) then return end
  local e = n.info or {}
  local lines = { G:TalentName(n.node.spell, spec) }
  lines[#lines + 1] = { string.format(L.CLASS_TIP_RANK, e.rank or 0, n.node.max), 0.75, 0.75, 0.75 }
  if (e.planned or 0) > 0 then
    if e.level then
      lines[#lines + 1] = string.format(L.CLASS_TIP_PLANNED, e.planned, n.node.max, e.level)
    else
      lines[#lines + 1] = string.format(L.CLASS_TIP_DONE, e.rank or 0, n.node.max)
    end
  else
    lines[#lines + 1] = { L.CLASS_TIP_NOT_PLANNED, 0.6, 0.6, 0.6 }
  end
  local point = { spell = n.node.spell, level = e.level or 60 }
  local stage, i = G:StageFor(spec, point)
  if stage and i then lines[#lines + 1] = { G:Why(spec, i), 0.85, 0.85, 0.85 } end
  showTip(n, lines)
end

function Panel:SpellTooltip(owner, spellID)
  local G, spec = Q.ClassGuide, self.spec
  local lines = { G:TalentName(spellID, spec) }
  local stage, i = G:StageFor(spec, { spell = spellID, level = owner.level or 60 })
  if stage and i then lines[#lines + 1] = { G:Why(spec, i), 0.85, 0.85, 0.85 } end
  showTip(owner, lines)
end

function Panel:RenderTalents()
  local G = Q.ClassGuide
  local t = self.talents
  local width = (tonumber(t:GetWidth()) or 0) > 0 and t:GetWidth() or 540
  local tree = G:Tree()
  local spec, how = G:Current(tree)
  if not spec then return end
  self.spec = spec
  local st = G:State(spec, tree)
  self.state = st
  local _, spent = G:Ranks(tree)
  local auto = G:AutoSpec(tree)

  -- spécialisations
  self.specHead:Set(L.CLASS_SPEC, "")
  self.specMode:Set({ { "auto", L.CLASS_SPEC_MODE_AUTO }, { "choice", L.CLASS_SPEC_MODE_CHOICE } },
    how == "choice" and "choice" or "auto")
  local cardW = (width - 12) / 3
  for i, s in ipairs(G:Specs() or {}) do
    local c = self.cards[i]
    c:ClearAllPoints()
    c:SetPoint("TOPLEFT", t, "TOPLEFT", (i - 1) * (cardW + 6), -26)
    c:SetWidth(cardW)
    c.key = s.key
    c.icon:SetTexture(iconPath(s.icon))
    c.name:SetText(G:SpecName(s, tree))
    c.tag:SetText(G:Tagline(s) or "")
    c.points:SetText((spent[s.group] or 0) > 0 and tostring(spent[s.group]) or "")
    local on = s.key == spec.key
    if on then paint(c.bg, "sel"); setBorder(c, "accent") else paint(c.bg, "panelAlt"); setBorder(c, "edge") end
    if how == "choice" and on then
      c.auto:SetLabel(L.CLASS_SPEC_CHOSEN)
      c.auto:Show()
    elseif s.key == auto then
      c.auto:SetLabel(L.CLASS_SPEC_AUTO)
      c.auto:Show()
    else
      c.auto:Hide()
    end
    c:Show()
  end

  -- arbre (onglet : celui du point suivant, sinon celui de la spé)
  local group = self.treeGroup
  if not group then
    local _, ns = st.next and G:Node(st.next.spell)
    group = ns and ns.group or spec.group
  end
  self.treeBox:ClearAllPoints()
  self.treeBox:SetPoint("TOPLEFT", t, "TOPLEFT", 0, -72)
  for i, s in ipairs(G:Specs() or {}) do
    local b = self.treeTabs[i]
    b.group = s.group
    b.icon:SetTexture(iconPath(s.icon))
    b.icon:Show()
    b.name = G:SpecName(s, tree)
    b.label:SetText(tostring(spent[s.group] or 0))
    local on = s.group == group
    ink(b.label, on and "text" or "textMuted")
    if on then b.line:Show() else b.line:Hide() end
  end
  local groupSpec
  for _, s in ipairs(G:Specs() or {}) do if s.group == group then groupSpec = s end end
  self.tree.art:SetTexture(iconPath(groupSpec and groupSpec.icon))
  local infos = G:NodeStates(spec, st)
  for _, n in ipairs(self.nodes) do n:Hide() end
  for i, node in ipairs(groupSpec and groupSpec.nodes or {}) do
    local n = self.nodes[i] or treeNode(self.tree)
    self.nodes[i] = n
    n.node = node
    local e = infos[node.spell] or { state = "off", rank = 0, planned = 0 }
    n.info = e
    n:ClearAllPoints()
    n:SetPoint("TOPLEFT", self.tree, "TOPLEFT", 14 + node.col * COL_W, -(8 + node.row * ROW_H))
    n.icon:SetTexture(iconPath(node.icon))
    local s = e.state
    if n.icon.SetDesaturated then n.icon:SetDesaturated(s == "plan" or s == "off") end
    n.icon:SetVertexColor(1, 1, 1)
    if s == "plan" then n.icon:SetVertexColor(0.55, 0.55, 0.55) elseif s == "off" then n.icon:SetVertexColor(0.3, 0.3, 0.3) end
    if s == "next" then n.ring:Show() else n.ring:Hide() end
    paint(n.edge, (s == "done" and "success") or (s == "extra" and "warning") or (s == "next" and "accent") or "edge")
    n.rank:Hide(); n.level:Hide()
    if s == "next" then
      n.rank:Set(string.format("%d/%d", (e.rank or 0) + 1, node.max), "onAccent", "accent")
    elseif s == "done" then
      n.rank:Set(string.format("%d/%d", e.rank, node.max), "success")
    elseif s == "extra" then
      n.rank:Set(string.format("%d/%d", e.rank, node.max), "warning")
    end
    if s == "plan" and e.level then n.level:Set(tostring(e.level), "textMuted") end
    n:Show()
  end
  self.legend:SetText(string.format("|c%s■|r %s   |c%s■|r %s   |c%s■|r %s", hex("success"), L.CLASS_LEGEND_DONE,
    hex("accent"), L.CLASS_LEGEND_NEXT, hex("edge"), L.CLASS_LEGEND_PLAN))

  -- colonne de droite
  self.right:ClearAllPoints()
  self.right:SetPoint("TOPLEFT", self.treeBox, "TOPRIGHT", 14, 0)
  self.right:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", 0, 40)
  local nc = self.nextCard
  if st.next then
    local unspentText = st.due and (st.unspent == 1 and L.CLASS_UNSPENT_ONE or string.format(L.CLASS_UNSPENT_MANY, st.unspent))
    self.nextHead:Set(L.CLASS_NEXT, unspentText or string.format(L.CLASS_NEXT_LATER, st.next.level),
      unspentText and "quest" or "textMuted")
    local node, ns = G:Node(st.next.spell)
    nc.icon:SetTexture(iconPath(node and node.icon))
    nc.meta:SetText(string.format(L.CLASS_NEXT_META, st.next.level, ns and G:SpecName(ns, tree) or "?",
      (node and node.row or 0) + 1))
    nc.name:SetText(G:TalentName(st.next.spell, spec) .. " " .. colored("textDim",
      string.format("%d/%d", st.next.rank, node and node.max or st.next.rank)))
    local _, idx = G:StageFor(spec, st.next)
    nc.why:SetText(idx and G:Why(spec, idx) or "")
    nc.icon:Show(); nc.meta:Show(); nc.why:Show()
  else
    self.nextHead:Set(L.CLASS_NEXT, "")
    nc.icon:Hide(); nc.meta:Hide(); nc.why:SetText("")
    nc.name:SetText(L.CLASS_DONE_ALL)
  end
  local whyH = tonumber(nc.why:GetStringHeight()) or 0
  nc:SetHeight(math.max(58, 9 + 12 + 2 + 18 + 3 + whyH + 10))

  self.upHead:Set(L.CLASS_UPCOMING, "")
  for i = 1, UPCOMING do
    local r, u = self.rows[i], st.upcoming[i]
    if u then
      local node = G:Node(u.spell)
      r.spell, r.level = u.spell, u.from
      r.lv:SetText(u.from == u.to and tostring(u.from) or (u.from .. "–" .. u.to))
      r.icon:SetTexture(iconPath(node and node.icon))
      r.name:SetText(G:TalentName(u.spell, spec))
      r.rank:SetText(string.format("%d/%d", u.rank, node and node.max or u.rank))
      r:Show()
    else
      r:Hide()
    end
  end
  if #st.upcoming == 0 then self.upHead:Hide() else self.upHead:Show() end
  local below = self.rows[math.max(1, #st.upcoming)]
  local anchor = #st.upcoming > 0 and below or nc

  self.extraText:ClearAllPoints()
  self.extraText:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -8)
  self.extraText:SetPoint("RIGHT", self.right, "RIGHT", 0, 0)
  if #st.extra > 0 then
    local parts = {}
    for i, x in ipairs(st.extra) do
      if i > 2 then break end
      local node = G:Node(x.spell)
      parts[#parts + 1] = string.format(L.CLASS_EXTRA_ITEM, G:TalentName(x.spell, spec), x.rank, node and node.max or x.rank)
    end
    local list = table.concat(parts, ", ")
    if #st.extra > 2 then list = string.format(L.CLASS_EXTRA_MORE, list, #st.extra - 2) end
    self.extraText:SetText("|TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:12:12|t " .. string.format(L.CLASS_EXTRA, list))
    self.extraText:Show()
  else
    self.extraText:SetText("")
    self.extraText:Hide()
  end
  self.noTree:ClearAllPoints()
  self.noTree:SetPoint("TOPLEFT", self.extraText, "BOTTOMLEFT", 0, -6)
  self.noTree:SetPoint("RIGHT", self.right, "RIGHT", 0, 0)
  if tree then self.noTree:Hide() else self.noTree:SetText(L.CLASS_NO_TREE); self.noTree:Show() end

  self.talentCredit:Set(string.format(L.CLASS_CREDIT_GUIDE, className(), spec.name ~= "" and G:SpecName(spec, tree) or "",
    spec.author or "Classic WoW Forever", colored("accent", shortUrl(spec.url)), spec.build or "?",
    dateText(spec.reviewed)), spec.url)
  self.how = how
end

---------------------------------------------------------------------------
-- Macros
---------------------------------------------------------------------------
local ORIGIN_BADGE = { classic = "CLASS_BADGE_CLASSIC", adapted = "CLASS_BADGE_ADAPTED", forever = "CLASS_BADGE_FOREVER" }
local ORIGIN_ROLE = { classic = "textDim", adapted = "warning", forever = "success" }

function Panel:Filters()
  local cs = Q.ClassGuide:CharState()
  if cs.macroPvp == nil then cs.macroPvp = false end
  if cs.macroSpec == nil then
    local spec = Q.ClassGuide:Current()
    cs.macroSpec = spec and spec.key or "class"
  end
  if cs.macroOrigin == nil then cs.macroOrigin = "all" end
  if cs.macroWhere == nil then cs.macroWhere = "char" end
  return cs
end

local function setFilter(key, value)
  Panel:Filters()[key] = value
  Panel.macroScroll = 0
  Panel:Refresh()
end

local function radio(parent, onClick)
  local r = CreateFrame("Button", nil, parent)
  r:SetHeight(14)
  r.box = CreateFrame("Frame", nil, r)
  r.box:SetSize(12, 12)
  r.box:SetPoint("LEFT", r, "LEFT", 0, 0)
  r.box.bg = rect(r.box, "panelAlt", "BACKGROUND")
  r.box.bg:SetAllPoints(r.box)
  border(r.box, "edge")
  r.dot = rect(r.box, "accent", "ARTWORK")
  r.dot:SetSize(6, 6)
  r.dot:SetPoint("CENTER", r.box, "CENTER", 0, 0)
  r.label = text(r, "GameFontHighlightSmall", "textDim")
  r.label:SetPoint("LEFT", r.box, "RIGHT", 5, 0)
  r:RegisterForClicks("LeftButtonUp")
  r:SetScript("OnClick", function() Q.SafeCall(onClick) end)
  function r:Set(label, on)
    self.label:SetText(label)
    ink(self.label, on and "text" or "textDim")
    setBorder(self.box, on and "accent" or "edge")
    if on then self.dot:Show() else self.dot:Hide() end
    self:SetWidth(18 + (tonumber(self.label:GetStringWidth()) or 40))
    self.on = on
  end
  return r
end

local function badge(parent)
  local b = CreateFrame("Frame", nil, parent)
  b:SetHeight(12)
  b.bg = rect(b, "panelAlt", "BACKGROUND")
  b.bg:SetAllPoints(b)
  border(b, "edge")
  b.text = text(b, "GameFontNormalSmall", "textDim", "CENTER")
  b.text:SetPoint("CENTER", b, "CENTER", 0, 0)
  function b:Set(s, role, filled)
    self.text:SetText(string.upper(s))
    if filled then
      paint(self.bg, role); setBorder(self, role); ink(self.text, "onAccent")
    else
      paint(self.bg, "panelAlt", 0); setBorder(self, "edge"); ink(self.text, role)
    end
    self:SetWidth((tonumber(self.text:GetStringWidth()) or 30) + 8)
    self:Show()
  end
  return b
end

local function macroCard(parent)
  local c = CreateFrame("Frame", nil, parent)
  c.bg = rect(c, "panel", "BACKGROUND")
  c.bg:SetAllPoints(c)
  border(c, "edge")
  c.icon = c:CreateTexture(nil, "ARTWORK")
  c.icon:SetSize(30, 30)
  c.icon:SetPoint("TOPLEFT", c, "TOPLEFT", 9, -9)
  if c.icon.SetTexCoord then c.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
  c.title = text(c, "GameFontNormal", "text")
  c.title:SetPoint("TOPLEFT", c.icon, "TOPRIGHT", 9, 1)
  c.origin = badge(c)
  c.level = badge(c)
  c.use = wrap(text(c, "GameFontHighlightSmall", "textDim"))
  c.codeBox = CreateFrame("Frame", nil, c)
  c.codeBox.bg = rect(c.codeBox, "code", "BACKGROUND")
  c.codeBox.bg:SetAllPoints(c.codeBox)
  border(c.codeBox, "line")
  c.code = wrap(text(c.codeBox, "ChatFontSmall", "text"))
  c.code:SetPoint("TOPLEFT", c.codeBox, "TOPLEFT", 6, -5)   -- largeur posée au rendu (RenderMacros)
  c.mods = wrap(text(c, "GameFontHighlightSmall", "textDim"))
  c.req = wrap(text(c, "GameFontHighlightSmall", "textMuted"))
  c.main = button(c, "", "primary", function(b) Panel:MacroAction(b:GetParent(), "main") end)
  c.second = button(c, "", "secondary", function(b) Panel:MacroAction(b:GetParent(), "second") end)
  c.main.minWidth, c.second.minWidth = CARD_ACT_W - 10, CARD_ACT_W - 10
  c.status = wrap(text(c, "GameFontDisableSmall", "textMuted", "CENTER"))
  c.status:SetWidth(CARD_ACT_W - 6)
  c.codeBox:EnableMouse(true)
  c.codeBox:SetScript("OnEnter", function(self)
    local card = self:GetParent()
    if card.gameName then showTip(self, { string.format(L.CLASS_ST_NAME, card.gameName) }) end
  end)
  c.codeBox:SetScript("OnLeave", hideTip)
  return c
end

-- Statut et boutons d'une carte -> libellé du bouton principal, genre, statut, second bouton ou nil.
function Panel:MacroState(m)
  local M = Q.ClassMacros
  local where = self:Filters().macroWhere == "char"
  local status = M:Status(m)
  local body = M:Body(m)
  local okWrite, why = M:CanWrite(m, where, status ~= "new" and status ~= "deleted")
  local note, noteRole
  if not okWrite then
    if why == "combat" then note = L.CLASS_ST_COMBAT
    elseif why == "full" then note = L.CLASS_ST_FULL
    elseif why == "long" then note = string.format(L.CLASS_ST_LONG, #body)
    else note = L.CLASS_ST_NOAPI end
    noteRole = "warning"
  end
  if status == "ok" then
    return { main = L.CLASS_BTN_CREATED, kind = "done", note = note, noteRole = noteRole }
  elseif (status == "outdated" or status == "edited") and M:Foreign(m) then
    -- créée dans une autre langue que celle du jeu : on traduit la macro telle qu'elle est
    local canWrite = why ~= "combat" and why ~= "noapi"
    return { main = L.CLASS_BTN_CREATED, kind = "done", second = L.CLASS_BTN_TRANSLATE, canWrite = canWrite,
      note = (not canWrite and note) or L.CLASS_ST_FOREIGN, noteRole = "warning", translate = true }
  elseif status == "outdated" or status == "edited" then
    return { main = L.CLASS_BTN_CREATED, kind = "done", second = L.CLASS_BTN_UPDATE, canWrite = okWrite,
      note = note or (status == "outdated" and L.CLASS_ST_OUTDATED or L.CLASS_ST_EDITED),
      noteRole = noteRole or "warning", edited = status == "edited" }
  end
  if not note then
    local known, missing = M:Known(m)
    if not known then
      note = string.format(L.CLASS_ST_UNKNOWN, M:SpellName(missing) or "?")
      if m.level and (Q.Player and Q.Player.level or 1) < m.level then
        note = string.format(L.CLASS_ST_LEVEL, M:SpellName(missing) or "?", m.level)
      end
    elseif m.fill then
      note = L.CLASS_ST_FILL
    elseif status == "deleted" then
      note = L.CLASS_ST_DELETED
    else
      note = L.CLASS_ST_READY
    end
    noteRole = "textMuted"
  end
  return { main = L.CLASS_BTN_CREATE, kind = okWrite and "primary" or "ghost", canWrite = okWrite, note = note,
    noteRole = noteRole }
end

function Panel:MacroAction(card, which)
  local m = card and card.macro
  if not m then return end
  local M = Q.ClassMacros
  local s = card.state or {}
  local ok, why
  if which == "main" and s.kind ~= "done" then
    ok, why = M:Create(m, self:Filters().macroWhere == "char")
  elseif which == "second" and s.translate then
    ok, why = M:Translate(m)
    if not ok and why == "long" and Q.UI.Options then
      Q.UI.Options:Status(string.format(L.CLASS_ST_LONG, M.MAX_BODY + 1), true)
    end
  elseif which == "second" then
    if s.edited and Q.UI.Options and Q.UI.Options.Confirm then
      Q.UI.Options:Confirm(L.CLASS_EDIT_CONFIRM, function()
        local ok2, why2 = M:Update(m)
        Panel:AfterWrite(ok2, why2)
      end)
      return
    end
    ok, why = M:Update(m)
  else
    return
  end
  self:AfterWrite(ok, why)
end

function Panel:AfterWrite(ok, why)
  if not ok and why == "failed" and Q.UI.Options then Q.UI.Options:Status(L.CLASS_ST_FAILED, true) end
  self:Refresh()
end

function Panel:CreateMacros(m)
  self.fPvp = segmented(m, function(v) setFilter("macroPvp", v) end)
  self.fPvp:SetPoint("TOPLEFT", m, "TOPLEFT", 0, 0)
  self.fSpec = segmented(m, function(v) setFilter("macroSpec", v) end)
  self.fSpec:SetPoint("LEFT", self.fPvp, "RIGHT", 8, 0)
  self.fOrigin = segmented(m, function(v) setFilter("macroOrigin", v) end)
  self.fOrigin:SetPoint("TOPLEFT", self.fPvp, "BOTTOMLEFT", 0, -6)
  self.whereLabel = text(m, "GameFontHighlightSmall", "textMuted")
  self.whereLabel:SetPoint("TOPLEFT", self.fOrigin, "BOTTOMLEFT", 0, -8)
  self.whereChar = radio(m, function() setFilter("macroWhere", "char") end)
  self.whereChar:SetPoint("LEFT", self.whereLabel, "RIGHT", 10, 0)
  self.whereAcc = radio(m, function() setFilter("macroWhere", "account") end)
  self.whereAcc:SetPoint("LEFT", self.whereChar, "RIGHT", 10, 0)
  self.slots = text(m, "GameFontHighlightSmall", "textDim", "RIGHT")
  self.slots:SetPoint("RIGHT", m, "RIGHT", 0, 0)
  self.slots:SetPoint("TOP", self.whereLabel, "TOP", 0, 0)

  local sf = CreateFrame("ScrollFrame", "QuestifyClassMacroScroll", m, "UIPanelScrollFrameTemplate")
  sf:SetPoint("TOPLEFT", self.whereLabel, "BOTTOMLEFT", 0, -8)
  sf:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", -22, 44)
  local child = CreateFrame("Frame", nil, sf)
  child:SetSize(400, 1)
  sf:SetScrollChild(child)
  self.macroList, self.macroChild = sf, child
  self.macroEmpty = text(child, "GameFontHighlight", "textMuted")
  self.macroEmpty:SetPoint("TOPLEFT", child, "TOPLEFT", 6, -10)
  self.macroEmpty:SetText(L.CLASS_EMPTY)

  self.untested = wrap(text(m, "GameFontHighlightSmall", "warning"))
  self.macroCredit = creditLine(m)
  self.macroCredit:SetPoint("BOTTOMLEFT", m, "BOTTOMLEFT", 0, 4)
  self.macroCredit:SetPoint("BOTTOMRIGHT", m, "BOTTOMRIGHT", 0, 4)
  self.untested:SetPoint("BOTTOMLEFT", self.macroCredit, "TOPLEFT", 0, 2)
  self.untested:SetPoint("RIGHT", m, "RIGHT", 0, 0)
  local rule = rect(m, "line", "ARTWORK")
  rule:SetPoint("BOTTOMLEFT", self.untested, "TOPLEFT", 0, 5)
  rule:SetPoint("RIGHT", m, "RIGHT", 0, 0)
  rule:SetHeight(1)
end

-- Écarts sous la boîte de code (touches) et entre les touches et les notes (« Needs: … »).
local CODE_GAP, NOTE_GAP = 8, 6

local function th(fs) return tonumber(fs:GetText() ~= nil and fs:GetText() ~= "" and fs:GetStringHeight()) or 0 end

function Panel:RenderMacros()
  local M, G = Q.ClassMacros, Q.ClassGuide
  local m = self.macros
  local width = (tonumber(m:GetWidth()) or 0) > 0 and m:GetWidth() or 540
  local f = self:Filters()
  local counts = M:Counts(f.macroPvp)
  self.fPvp:Set({ { false, string.format("%s |c%s%d|r", L.CLASS_PVE, hex("textMuted"), counts.pve) },
    { true, string.format("%s |c%s%d|r", L.CLASS_PVP, hex("textMuted"), counts.pvp) } }, f.macroPvp)
  local specItems = { { "class", string.format("%s |c%s%d|r", L.CLASS_FILTER_CLASS, hex("textMuted"), counts.class or 0) } }
  for _, s in ipairs(G:Specs() or {}) do
    specItems[#specItems + 1] = { s.key, string.format("%s |c%s%d|r", G:SpecName(s, G:Tree()), hex("textMuted"), counts[s.key] or 0) }
  end
  self.fSpec:Set(specItems, f.macroSpec)
  self.fOrigin:Set({ { "all", L.CLASS_ORIGIN_ALL }, { "classic", L.CLASS_ORIGIN_CLASSIC },
    { "adapted", L.CLASS_ORIGIN_ADAPTED }, { "forever", L.CLASS_ORIGIN_FOREVER } }, f.macroOrigin)
  self.whereLabel:SetText(L.CLASS_CREATE_IN)
  self.whereChar:Set(L.CLASS_WHERE_CHAR, f.macroWhere == "char")
  self.whereAcc:Set(L.CLASS_WHERE_ACCOUNT, f.macroWhere ~= "char")
  local acc, accMax, char, charMax = M:Slots()
  self.slots:SetText(string.format(L.CLASS_SLOTS, char, charMax, acc, accMax))

  local list = M:List({ pvp = f.macroPvp, spec = f.macroSpec, origin = f.macroOrigin ~= "all" and f.macroOrigin or nil })
  local cw = width - 26
  self.macroChild:SetWidth(cw)
  for _, c in ipairs(self.macroCards) do c:Hide() end
  local y = 0
  for i, mac in ipairs(list) do
    local c = self.macroCards[i] or macroCard(self.macroChild)
    self.macroCards[i] = c
    c.macro = mac
    local tx = M:Text(mac)
    c:ClearAllPoints()
    c:SetPoint("TOPLEFT", self.macroChild, "TOPLEFT", 0, -y)
    c:SetWidth(cw)
    c.icon:SetTexture(iconPath(mac.icon))
    local bodyW = cw - 9 - 30 - 9 - CARD_ACT_W - 12
    c.title:SetWidth(bodyW)
    c.title:SetText(tx.title)
    c.title:SetWidth(math.min(bodyW, (tonumber(c.title:GetStringWidth()) or bodyW)))
    c.origin:ClearAllPoints()
    c.origin:SetPoint("TOPLEFT", c.title, "BOTTOMLEFT", 0, -3)
    c.origin:Set(L[ORIGIN_BADGE[mac.origin] or "CLASS_BADGE_CLASSIC"], ORIGIN_ROLE[mac.origin] or "textDim",
      mac.origin ~= "classic")
    if mac.level then
      c.level:ClearAllPoints()
      c.level:SetPoint("LEFT", c.origin, "RIGHT", 4, 0)
      c.level:Set(string.format(L.CLASS_BADGE_LEVEL, mac.level), "textMuted", false)
    else
      c.level:Hide()
    end
    c.use:ClearAllPoints()
    c.use:SetPoint("TOPLEFT", c.origin, "BOTTOMLEFT", 0, -4)
    c.use:SetWidth(bodyW)
    c.use:SetText(tx.use)
    local body = M:Body(mac)
    c.gameName = M:DefaultName(mac)
    c.codeBox:ClearAllPoints()
    c.codeBox:SetPoint("TOPLEFT", c.use, "BOTTOMLEFT", 0, -5)
    c.codeBox:SetWidth(bodyW)
    -- largeur posée avant la mesure : les ancres ne sont résolues qu'au rendu, et sans largeur le texte n'est
    -- pas replié (hauteur trop petite, le code déborde de sa boîte)
    c.code:SetWidth(bodyW - 12)
    c.code:SetText(M:Highlight(mac, body, hex("quest")))
    c.codeBox:SetHeight(th(c.code) + 10)
    local mods = {}
    for _, md in ipairs(tx.mods) do
      local key = md.key == "None" and L.CLASS_KEY_NONE or md.key
      mods[#mods + 1] = colored("text", key) .. " " .. md.does
    end
    c.mods:ClearAllPoints()
    c.mods:SetPoint("TOPLEFT", c.codeBox, "BOTTOMLEFT", 0, -CODE_GAP)
    c.mods:SetWidth(bodyW)
    c.mods:SetText(table.concat(mods, "  ·  "))
    c.req:ClearAllPoints()
    c.req:SetPoint("TOPLEFT", c.mods, "BOTTOMLEFT", 0, #mods > 0 and -NOTE_GAP or 0)
    c.req:SetWidth(bodyW)
    c.req:SetText(tx.requires ~= "" and string.format(L.CLASS_REQUIRES, tx.requires) or "")
    local h = 9 + 15 + 3 + 12 + 4 + th(c.use) + 5 + (th(c.code) + 10) + CODE_GAP + th(c.mods)
      + (#mods > 0 and NOTE_GAP or 0) + th(c.req) + 9
    -- action
    local state = self:MacroState(mac)
    c.state = state
    c.main:SetLabel(state.main)
    c.main:SetKind(state.kind)
    c.main:ClearAllPoints()
    c.main:SetPoint("TOPRIGHT", c, "TOPRIGHT", -9, -9)
    c.main:SetWidth(CARD_ACT_W - 10)
    local below = c.main
    if state.second then
      c.second:SetLabel(state.second)
      c.second:SetKind(state.canWrite and "secondary" or "ghost")
      c.second:ClearAllPoints()
      c.second:SetPoint("TOPRIGHT", c.main, "BOTTOMRIGHT", 0, -4)
      c.second:SetWidth(CARD_ACT_W - 10)
      c.second:Show()
      below = c.second
    else
      c.second:Hide()
    end
    c.status:ClearAllPoints()
    c.status:SetPoint("TOP", below, "BOTTOM", 0, -4)
    c.status:SetText(state.note or "")
    ink(c.status, state.noteRole or "textMuted")
    c:SetHeight(math.max(h, 9 + 20 + (state.second and 24 or 0) + 4 + th(c.status) + 9))
    c:Show()
    y = y + c:GetHeight() + 6
  end
  if #list == 0 then self.macroEmpty:Show() else self.macroEmpty:Hide() end
  self.macroChild:SetHeight(math.max(1, y))
  if self.macroScroll == 0 and self.macroList.SetVerticalScroll then
    self.macroList:SetVerticalScroll(0)
    self.macroScroll = nil
  end
  self.untested:SetText(L.CLASS_MACROS_UNTESTED)
  local d = Q.ClassMacroData and Q.ClassMacroData[Q.Player and Q.Player.classFile or ""]
  local url = d and d.url or (Q.ClassMacroData and Q.ClassMacroData.source.url) or ""
  self.macroCredit:Set(string.format(L.CLASS_CREDIT_MACROS, className(), colored("accent", shortUrl(url))), url)
end

---------------------------------------------------------------------------
-- Rafraîchissements
---------------------------------------------------------------------------
local function refresh() if Panel:IsShown() then Q.SafeCall(Panel.Refresh, Panel) end end
Q:On("TALENTS_CHANGED", refresh)
Q:On("CLASS_GUIDE_CHANGED", refresh)
Q:On("CLASS_MACROS_CHANGED", refresh)
Q:On("THEME_CHANGED", refresh)
Q:RegisterEvent("PLAYER_LEVEL_UP", function() Q:After(0.5, refresh) end)
