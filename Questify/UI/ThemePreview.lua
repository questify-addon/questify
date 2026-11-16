local addonName, Q = ...

-- Aperçu en direct de la section Thème des options (UI/Options.lua, colonne de droite) : un suivi
-- d'exemple dessiné avec le thème, le fond (tracker.style), l'opacité, la police et les icônes en
-- vigueur, sur un fond clair de paysage enneigé (le cas le plus dur), et la flèche flottante à sa
-- couleur. Trois onglets : monstres à tuer, zone à plusieurs quêtes, objet à utiliser (bouton
-- de l'objet à gauche du suivi). Redessiné à chaque changement de thème ou de réglage.
Q.UI = Q.UI or {}
local Preview = { scene = "kill" }
Q.UI.ThemePreview = Preview

local L = Q.L
local MEDIA = "Interface\\AddOns\\" .. addonName .. "\\Media\\Themes\\"
local W = 272          -- largeur du suivi d'exemple
local HEADER = 28
local PAD = 8
local SCENES = { "kill", "zone", "item" }
local SCENE_LABELS = { kill = "OPT_THEME_LIVE_KILL", zone = "OPT_THEME_LIVE_ZONE", item = "OPT_THEME_LIVE_ITEM" }
Preview.SCENES = SCENES

-- Lignes de chaque scène : { texte (clé de Q.L), rôle, taille de police ("big" / "small"), retrait }.
local LINES = {
  kill = {
    { "PREVIEW_KILL_QUEST", "body", "big" }, { "PREVIEW_KILL_OBJ", "body", "big", 6 },
    { "PREVIEW_KILL_MOB", "body", "small", 16, skull = true },
  },
  zone = {
    { "PREVIEW_ZONE_TITLE", "body", "big" }, { "PREVIEW_ZONE_LINE", "dim", "small" },
    { "PREVIEW_ZONE_ITEMS", "body", "small" }, { "PREVIEW_ZONE_ITEM1", "body", "small", 6 },
    { "PREVIEW_ZONE_ELITES", "body", "small" }, { "PREVIEW_ZONE_MOB1", "body", "small", 16, skull = true },
    { "PREVIEW_ZONE_MOBS", "body", "small" }, { "PREVIEW_ZONE_MOB2", "body", "small", 16, skull = true },
  },
  item = {
    { "PREVIEW_ITEM_QUEST", "body", "big" }, { "PREVIEW_ITEM_OBJ", "body", "big", 6 },
    { "PREVIEW_ITEM_USE", "body", "small", 6 },
  },
}
local HEADS = {
  kill = { "PREVIEW_KILL_ZONE", "1-6", 30, "Interface\\Icons\\INV_Sword_04", "142 yd" },
  zone = { "PREVIEW_KILL_ZONE", "1-6", 50, "Interface\\COMMON\\Indicator-Green", "38 yd" },
  item = { "PREVIEW_ITEM_ZONE", "16-19", 28, "Interface\\Icons\\INV_Sword_04", "96 yd" },
}
local NEXT = { "PREVIEW_NEXT1", "PREVIEW_NEXT2", "PREVIEW_NEXT3" }
local NEXT_ACTIONS = { "turnin", "accept", "accept" }

local function setting(path) return Q.Settings:Get(path) end

function Preview:Create(parent)
  if self.panel then return self.panel end
  local T = Q.Themes
  local p = CreateFrame("Frame", nil, parent)
  p:SetAllPoints(parent)
  self.panel = p
  local bg = p:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(p)
  local divider = p:CreateTexture(nil, "BORDER")
  divider:SetPoint("TOPLEFT", p, "TOPLEFT", 0, 0)
  divider:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 0, 0)
  divider:SetWidth(1)
  self.bg, self.divider = bg, divider

  local title = p:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  title:SetPoint("TOPLEFT", p, "TOPLEFT", 14, -12)
  title:SetText(L.OPT_THEME_LIVE)
  local dot = p:CreateTexture(nil, "OVERLAY")
  dot:SetSize(8, 8)
  dot:SetPoint("LEFT", title, "RIGHT", 6, 0)
  dot:SetTexture(MEDIA .. "glyph-dot")
  self.title, self.dot = title, dot

  -- onglets
  self.tabs = {}
  local x = 14
  for i, key in ipairs(SCENES) do
    local b = CreateFrame("Button", nil, p, "BackdropTemplate")
    b:SetSize(96, 22)
    b:SetPoint("TOPLEFT", p, "TOPLEFT", x + (i - 1) * 95, -32)
    local text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER", b, "CENTER", 0, 0)
    text:SetText(L[SCENE_LABELS[key]])
    local fill = b:CreateTexture(nil, "BACKGROUND")
    fill:SetPoint("TOPLEFT", b, "TOPLEFT", 1, -1)
    fill:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    local under = b:CreateTexture(nil, "ARTWORK")
    under:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 1, 1)
    under:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)
    under:SetHeight(2)
    b.text, b.fill, b.under, b.scene = text, fill, under, key
    b:SetScript("OnClick", function(self) Q.SafeCall(Preview.Show, Preview, self.scene) end)
    self.tabs[i] = b
  end

  -- paysage clair derrière le suivi
  local world = CreateFrame("Frame", nil, p)
  world:SetPoint("TOPLEFT", p, "TOPLEFT", 12, -64)
  world:SetPoint("TOPRIGHT", p, "TOPRIGHT", -12, -64)
  world:SetHeight(300)
  local ground = world:CreateTexture(nil, "BACKGROUND")
  ground:SetAllPoints(world)
  if T then
    T.ApplyGradient(ground, { orientation = "VERTICAL", from = { 0.44, 0.51, 0.59, 1 }, to = { 0.80, 0.84, 0.88, 1 } })
  end
  self.world = world

  -- suivi d'exemple
  local trk = CreateFrame("Frame", nil, world, "BackdropTemplate")
  trk:SetWidth(W)
  trk:SetPoint("TOPRIGHT", world, "TOPRIGHT", -8, -10)
  trk.qvOwnTheme = true
  local head = trk:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  head:SetJustifyH("LEFT")
  if T then self.decor = T:Decorate(trk, { header = HEADER, title = head }) end
  local levels = trk:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  levels:SetPoint("TOPRIGHT", trk, "TOPRIGHT", -PAD, -(HEADER - 12) / 2)
  local bar = trk:CreateTexture(nil, "ARTWORK")
  bar:SetHeight(4)
  local barBg = trk:CreateTexture(nil, "BORDER")
  barBg:SetHeight(4)
  local barText = trk:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  barText:SetJustifyH("LEFT")
  local icon = trk:CreateTexture(nil, "ARTWORK")
  icon:SetSize(22, 22)
  local dist = trk:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.trk, self.head, self.levels, self.bar, self.barBg, self.barText = trk, head, levels, bar, barBg, barText
  self.icon, self.dist = icon, dist
  self.lines, self.skulls, self.nextIcons, self.nextTexts = {}, {}, {}, {}
  for i = 1, 8 do
    local fs = trk:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetJustifyH("LEFT")
    fs:SetWordWrap(true)
    self.lines[i] = fs
    local sk = trk:CreateTexture(nil, "ARTWORK")
    sk:SetSize(12, 12)
    sk:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_8")
    self.skulls[i] = sk
  end
  for i = 1, 3 do
    self.nextIcons[i] = trk:CreateTexture(nil, "ARTWORK")
    self.nextIcons[i]:SetSize(12, 12)
    local fs = trk:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    fs:SetJustifyH("LEFT")
    fs:SetWordWrap(false)
    self.nextTexts[i] = fs
  end
  -- bouton de l'objet de quête (scène « objet »)
  local item = T and T:Emblem(world, 40)
  if item then
    item:SetPoint("TOPRIGHT", trk, "TOPLEFT", -6, -70)
    item.disc:SetTexture("Interface\\Icons\\Spell_Shadow_SoulGem")
    item.disc:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    self.item = item
  end

  -- flèche flottante d'exemple
  local arrowBox = CreateFrame("Frame", nil, p)
  arrowBox:SetPoint("TOPLEFT", world, "BOTTOMLEFT", 0, -8)
  arrowBox:SetPoint("TOPRIGHT", world, "BOTTOMRIGHT", 0, -8)
  arrowBox:SetHeight(104)
  local abg = arrowBox:CreateTexture(nil, "BACKGROUND")
  abg:SetAllPoints(arrowBox)
  if T then
    T.ApplyGradient(abg, { orientation = "VERTICAL", from = { 0.44, 0.51, 0.59, 1 }, to = { 0.80, 0.84, 0.88, 1 } })
  end
  local glow = arrowBox:CreateTexture(nil, "ARTWORK", nil, 1)
  glow:SetSize(70, 70)
  glow:SetPoint("TOP", arrowBox, "TOP", 0, -2)
  glow:SetTexture(MEDIA .. "arrow-glow")
  glow:SetAlpha(0.55)
  glow:SetRotation(-0.5)
  local arrow = arrowBox:CreateTexture(nil, "ARTWORK", nil, 2)
  arrow:SetSize(58, 58)
  arrow:SetPoint("TOP", arrowBox, "TOP", 0, -8)
  arrow:SetTexture(MEDIA .. "arrow")
  arrow:SetRotation(-0.5)
  local adist = arrowBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  adist:SetPoint("TOP", arrow, "BOTTOM", 0, 0)
  adist:SetText("128 yd")
  adist:SetShadowColor(0, 0, 0, 1)
  adist:SetShadowOffset(1, -1)
  local aname = arrowBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  aname:SetPoint("TOP", adist, "BOTTOM", 0, -1)
  aname:SetText(L.PREVIEW_ARROW_TARGET)
  aname:SetShadowColor(0, 0, 0, 1)
  aname:SetShadowOffset(1, -1)
  self.arrowBox, self.arrow, self.arrowGlow = arrowBox, arrow, glow

  local hint = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  hint:SetPoint("TOPLEFT", arrowBox, "BOTTOMLEFT", 2, -8)
  hint:SetPoint("TOPRIGHT", arrowBox, "BOTTOMRIGHT", -2, -8)
  hint:SetJustifyH("LEFT")
  hint:SetText(L.OPT_THEME_LIVE_HINT)
  self.hint = hint
  return p
end

-- Show(scène) : onglet affiché (kill, zone ou item).
function Preview:Show(scene)
  if scene then self.scene = scene end
  self:Refresh()
end

local function place(fs, trk, x, y, w)
  fs:ClearAllPoints()
  fs:SetPoint("TOPLEFT", trk, "TOPLEFT", x, -y)
  if w then fs:SetWidth(w) end
end

function Preview:Refresh()
  local T = Q.Themes
  if not (self.panel and T) then return end
  local th = T:Current()
  local style = T:Style()
  local opacity = T:Opacity(setting("tracker.opacity"))
  local variant = T:Apply(self.trk, th.key, opacity, style)
  self.theme = variant
  local c = th.colors
  self.bg:SetColorTexture(c.sidebar[1], c.sidebar[2], c.sidebar[3], 1)
  self.divider:SetColorTexture(c.line[1], c.line[2], c.line[3], c.line[4])
  self.title:SetTextColor(c.textMuted[1], c.textMuted[2], c.textMuted[3])
  self.dot:SetVertexColor(c.success[1], c.success[2], c.success[3], 1)
  self.hint:SetTextColor(c.textMuted[1], c.textMuted[2], c.textMuted[3])
  for _, b in ipairs(self.tabs) do
    local on = b.scene == self.scene
    b:SetBackdrop(T.HAIRLINE)
    b:SetBackdropBorderColor(c.edge[1], c.edge[2], c.edge[3], 1)
    if on then b.fill:SetColorTexture(c.accent[1], c.accent[2], c.accent[3], 0.16)
    else b.fill:SetColorTexture(c.panelAlt[1], c.panelAlt[2], c.panelAlt[3], 1) end
    b.under:SetColorTexture(c.accent[1], c.accent[2], c.accent[3], 1)
    if on then b.under:Show(); b.text:SetTextColor(c.text[1], c.text[2], c.text[3])
    else b.under:Hide(); b.text:SetTextColor(c.textDim[1], c.textDim[2], c.textDim[3]) end
  end

  -- suivi d'exemple
  local trk = self.trk
  local head = HEADS[self.scene] or HEADS.kill
  local decor = variant.decor ~= false
  local top = decor and HEADER or 20
  if self.decor and self.decor.header then self.decor.header:SetHeight(top) end
  self.head:SetText(L[head[1]])
  self.head:ClearAllPoints()
  if decor and self.decor and self.decor.header then self.head:SetPoint("LEFT", self.decor.header, "LEFT", PAD, 0)
  else self.head:SetPoint("TOPLEFT", trk, "TOPLEFT", PAD, -6) end
  T:StyleText(self.head, "title", variant)
  self.levels:SetText(head[2])
  T:StyleText(self.levels, "levels", variant)
  local y = top + 6
  self.barBg:ClearAllPoints()
  self.barBg:SetPoint("TOPLEFT", trk, "TOPLEFT", PAD, -y)
  self.barBg:SetPoint("TOPRIGHT", trk, "TOPRIGHT", -PAD, -y)
  self.barBg:SetColorTexture(variant.bar.bg[1], variant.bar.bg[2], variant.bar.bg[3], variant.bar.bg[4] or 1)
  self.bar:ClearAllPoints()
  self.bar:SetPoint("TOPLEFT", self.barBg, "TOPLEFT", 0, 0)
  self.bar:SetWidth((W - 2 * PAD) * head[3] / 100)
  self.bar:SetColorTexture(variant.bar.fill[1], variant.bar.fill[2], variant.bar.fill[3], 1)
  y = y + 4 + 3
  place(self.barText, trk, PAD, y, W - 2 * PAD)
  self.barText:SetText(string.format("%d%%", head[3]))
  T:StyleText(self.barText, "bar", variant)
  y = y + 17

  -- étape courante
  local y0 = y
  self.icon:ClearAllPoints()
  self.icon:SetPoint("TOP", trk, "TOPLEFT", PAD + 19, -y)
  self.icon:SetTexture(head[4])
  place(self.dist, trk, PAD, y + 26, 38)
  self.dist:SetJustifyH("CENTER")
  self.dist:SetText(head[5])
  T:StyleText(self.dist, "distance", variant)
  local x0 = PAD + 40
  local lines = LINES[self.scene] or LINES.kill
  for i, fs in ipairs(self.lines) do
    local spec = lines[i]
    local sk = self.skulls[i]
    if spec then
      local indent = spec[4] or 0
      if spec[3] == "big" then fs:SetFontObject("GameFontHighlight") else fs:SetFontObject("GameFontHighlightSmall") end
      fs.qvBaseFont = nil
      place(fs, trk, x0 + indent, y, W - x0 - PAD - indent)
      fs:SetText(T:Recolor(L[spec[1]], variant))
      T:StyleText(fs, spec[2], variant)
      fs:Show()
      if spec.skull then
        sk:ClearAllPoints()
        sk:SetPoint("TOPLEFT", trk, "TOPLEFT", x0 + indent - 15, -y)
        sk:Show()
      else
        sk:Hide()
      end
      y = y + (spec[3] == "big" and 16 or 14)
    else
      fs:Hide()
      sk:Hide()
    end
  end
  y = math.max(y, y0 + 40) + 6
  -- étapes suivantes
  for i, fs in ipairs(self.nextTexts) do
    local tex, r, g, b = T:StepIcon(NEXT_ACTIONS[i], variant)
    local ic = self.nextIcons[i]
    ic:SetTexture(tex)
    if r then ic:SetVertexColor(r, g, b, 1) else ic:SetVertexColor(1, 1, 1, 0.7) end
    ic:ClearAllPoints()
    ic:SetPoint("TOPLEFT", trk, "TOPLEFT", PAD + 2, -y - 1)
    place(fs, trk, PAD + 18, y, W - PAD * 2 - 18)
    fs:SetText(L[NEXT[i]])
    T:StyleText(fs, "dim", variant)
    y = y + 15
  end
  trk:SetHeight(y + PAD)
  if self.item then
    if self.scene == "item" then self.item:SetTheme(th); self.item.disc:SetTexture("Interface\\Icons\\Spell_Shadow_SoulGem"); self.item:Show()
    else self.item:Hide() end
  end
  self.world:SetHeight(y + PAD + 20)

  -- flèche à sa couleur
  local r, g, b = T:ArrowColor(th)
  self.arrow:SetVertexColor(r, g, b, 1)
  self.arrowGlow:SetVertexColor(r, g, b, 1)
  if setting("arrow.show") == false then self.arrowBox:SetAlpha(0.35) else self.arrowBox:SetAlpha(1) end
end

Q:On("THEME_CHANGED", function() if Preview.panel and Preview.panel:IsVisible() then Q.SafeCall(Preview.Refresh, Preview) end end)
Q:On("SETTINGS_CHANGED", function(path)
  if not (Preview.panel and Preview.panel:IsVisible()) then return end
  if path == "tracker.opacity" or path == "tracker.style" or path == "arrow.color" or path == "arrow.show"
    or path == "theme.font" or path == "theme.icons" then
    Q.SafeCall(Preview.Refresh, Preview)
  end
end)
