local addonName, Q = ...

-- Comparatif « avant → après » d'une amélioration d'équipement (UI/UpgradePopup.lua) :
--   Q.UI.UpgradeCompare:Build(entry) -> données : objets portés remplacés (avant), objets proposés
--   (après), écart de chaque stat, effets « Équipé : » / « Utiliser : » perdus ou nouveaux, gain au
--   score de classe ;
--   Q.UI.UpgradeCompare:Show(owner, data) / :Hide() : panneau à côté de la boîte, au survol.
-- Avant : l'objet porté dans l'emplacement comparé (le moins bon des deux pour bagues, bijoux et
-- armes à une main, comme Q.Rewards:UpgradeGain) ; arme à deux mains (proposée ou portée face à une
-- main droite ou une main gauche) et paire : les deux mains réunies.
-- Les stats viennent de GetItemStats (Q.Rewards:ReadItem), triées par poids dans le profil de la
-- classe (Q.Rewards:Score sur la seule stat) ; les effets viennent des lignes de l'infobulle de
-- l'objet (C_TooltipInfo, sinon une infobulle cachée) et ne comptent pas dans le score.
-- Couleurs lues dans le thème du suivi (Q.Themes) : gains |cff40e050, pertes |cffff5555, recolorés
-- sur parchemin.
Q.UI = Q.UI or {}
local Compare = {}
Q.UI.UpgradeCompare = Compare

local L = Q.L

local WIDTH = 250
local PAD = 8
local ICON = 22
local ROW_H = 14
local COL_W = 44             -- colonnes Avant, Après, Écart
local TAG_W = 52             -- étiquette « perdu » / « nouveau »
local GAIN, LOSS = "|cff40e050", "|cffff5555"
Compare.GAIN, Compare.LOSS = GAIN, LOSS

-- Couleur du nom selon la qualité : celles du jeu, foncées sur parchemin (lisibles sur le fond clair).
local QUALITY = { [0] = "ff9d9d9d", "ffffffff", "ff1eff00", "ff0070dd", "ffa335ee", "ffff8000", "ffe6cc80" }
local QUALITY_PARCHMENT = { [0] = "ff5e4b33", "ff2b1a08", "ff1f6e1f", "ff1d4f8c", "ff5a2585", "ff8a4b00", "ff7a5200" }
-- Fond des étiquettes perdu / nouveau : teinte pâle (parchemin) ou sombre (autres thèmes).
local TAG_BG = {
  parchment = { lost = { 0.94, 0.79, 0.75 }, new = { 0.78, 0.89, 0.75 } },
  other = { lost = { 0.35, 0.08, 0.08 }, new = { 0.08, 0.30, 0.10 } },
}

local function setting(path) return Q.Settings and Q.Settings:Get(path) end
local function itemId(link) return type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil end

---------------------------------------------------------------------------
-- Données
---------------------------------------------------------------------------
-- Nombre lisible : entier sans décimale, sinon une décimale (virgule en français).
local function number(v)
  local s
  if math.abs(v - math.floor(v + 0.5)) < 0.05 then s = string.format("%d", math.floor(v + 0.5))
  else s = string.format("%.1f", v) end
  if GetLocale and GetLocale() == "frFR" then s = s:gsub("%.", ",") end
  return s
end
local function signed(v)
  if v > 0 then return "+" .. number(v) end
  if v < 0 then return "−" .. number(-v) end
  return "0"
end
Compare.Number, Compare.Signed = number, signed

-- Nom de la stat : chaîne globale du client (ITEM_MOD_AGILITY_SHORT = « Agilité »), sinon la clé.
local function statName(key)
  local v = rawget(_G, key)
  if type(v) == "string" and v ~= "" then return v end
  return (key:gsub("^ITEM_MOD_", ""):gsub("_SHORT$", ""))
end

-- Qualité de l'objet : GetItemInfo, sinon le code couleur du lien.
local function quality(link)
  if Q.API and Q.API.GetItemInfo then
    local ok, name, _, q = pcall(Q.API.GetItemInfo, link)
    if ok and name and tonumber(q) then return tonumber(q) end
  end
  local hex = type(link) == "string" and link:match("^|c(%x%x%x%x%x%x%x%x)")
  if hex then
    for q, h in pairs(QUALITY) do if h == hex:lower() then return q end end
  end
  return 1
end

-- « [Nom] » coloré selon la qualité et le thème.
function Compare:ItemLabel(item, theme)
  if not item then return "" end
  local name = item.name or (type(item.link) == "string" and item.link:match("%[(.-)%]")) or "?"
  local q = quality(item.link)
  local map = (theme and theme.key == "parchment") and QUALITY_PARCHMENT or QUALITY
  return "|c" .. (map[q] or map[1]) .. "[" .. name .. "]|r"
end

-- Lignes d'effet de l'infobulle (« Équipé : », « Utiliser : », « Chances quand vous touchez : »).
local scanTip
local function triggers()
  local out = {}
  for _, k in ipairs({ "ITEM_SPELL_TRIGGER_ONEQUIP", "ITEM_SPELL_TRIGGER_ONUSE", "ITEM_SPELL_TRIGGER_ONPROC" }) do
    local v = rawget(_G, k)
    if type(v) == "string" and v ~= "" then out[#out + 1] = v end
  end
  if #out == 0 then out = { "Equip:", "Use:", "Chance on hit:" } end
  return out
end

local function tooltipLines(link)
  local lines = {}
  local TI = C_TooltipInfo
  if TI and type(TI.GetHyperlink) == "function" then
    local ok, data = pcall(TI.GetHyperlink, link)
    if ok and type(data) == "table" and type(data.lines) == "table" then
      for _, l in ipairs(data.lines) do
        if type(l) == "table" and type(l.leftText) == "string" then lines[#lines + 1] = l.leftText end
      end
      if #lines > 0 then return lines end
    end
  end
  if not CreateFrame then return lines end
  if not scanTip then
    local ok, tip = pcall(CreateFrame, "GameTooltip", "QuestifyUpgradeScanTooltip", nil, "GameTooltipTemplate")
    if not ok or not tip then return lines end
    scanTip = tip
  end
  local ok = pcall(function()
    scanTip:SetOwner(WorldFrame or UIParent, "ANCHOR_NONE")
    scanTip:ClearLines()
    scanTip:SetHyperlink(link)
  end)
  if not ok then return lines end
  local n = scanTip.NumLines and scanTip:NumLines() or 0
  for i = 1, tonumber(n) or 0 do
    local fs = _G["QuestifyUpgradeScanTooltipTextLeft" .. i]
    local text = fs and fs.GetText and fs:GetText()
    if type(text) == "string" then lines[#lines + 1] = text end
  end
  scanTip:Hide()
  return lines
end

-- Effets d'un objet : { [texte] = true } (couleurs retirées).
function Compare:Effects(link)
  local out = {}
  if type(link) ~= "string" then return out end
  local starts = triggers()
  for _, line in ipairs(tooltipLines(link)) do
    local text = Q.Util.StripColors(line)
    if type(text) == "string" and not Q.Util.IsSecret(text) then
      for _, s in ipairs(starts) do
        if text:sub(1, #s) == s then out[text] = true; break end
      end
    end
  end
  return out
end

local MAIN_HAND = { INVTYPE_WEAPON = true, INVTYPE_WEAPONMAINHAND = true }
local OFF_HAND = { INVTYPE_SHIELD = true, INVTYPE_HOLDABLE = true, INVTYPE_WEAPONOFFHAND = true }

-- Objets remplacés et objets proposés.
local function sides(entry, player)
  local R = Q.Rewards
  local function read(link) return link and R:ReadItem(link) or nil end
  local hands = function() return { R:EquippedItem(16), R:EquippedItem(17) } end
  if entry.pair then
    return hands(), { read(entry.pair.main), read(entry.pair.off) }, false
  end
  local item = read(entry.link)
  local loc = item and item.equipLoc
  if loc == "INVTYPE_2HWEAPON" then return hands(), { item }, false end
  local main = R:EquippedItem(16)
  if main and main.equipLoc == "INVTYPE_2HWEAPON" and (MAIN_HAND[loc] or OFF_HAND[loc]) then
    return hands(), { item }, false
  end
  local slots = loc and R:ComparisonSlots(loc, player) or {}
  local worst, worstScore
  for _, s in ipairs(slots) do
    local it = R:EquippedItem(s)
    local sc = it and R:Score(it.stats, player.classFile, s == 18) or 0
    if not worstScore or sc < worstScore then worst, worstScore = it or false, sc end
  end
  return { worst or nil }, { item }, slots[1] == 18
end

-- Build(entry) -> { before = { objets }, after = { objets }, fromBags = { [i] = vrai },
--   stats = { { key, name, before, after, delta, weight } }, summary = { lignes de gain },
--   effects = { { text, kind = "lost" | "new" } }, gain = nombre ou nil }
function Compare:Build(entry)
  local R = Q.Rewards
  local player = Q.Player or {}
  local before, after, ranged = sides(entry, player)
  local data = { before = {}, after = {}, fromBags = {}, stats = {}, summary = {}, effects = {}, gain = entry.gain }
  for _, it in ipairs(before) do if it then data.before[#data.before + 1] = it end end
  for i, it in ipairs(after) do
    if it then
      data.after[#data.after + 1] = it
      -- paire : la moitié qui n'est pas l'objet ramassé vient des sacs
      if entry.pair and itemId(it.link) ~= itemId(entry.link) then data.fromBags[#data.after] = true end
    end
  end

  local sums, keys = { {}, {} }, {}
  for side, list in ipairs({ data.before, data.after }) do
    for _, it in ipairs(list) do
      for k, v in pairs(it.stats or {}) do
        v = tonumber(v)
        if v and v ~= 0 and type(k) == "string" then
          if not keys[k] then keys[k] = true end
          sums[side][k] = (sums[side][k] or 0) + v
        end
      end
    end
  end
  for k in pairs(keys) do
    local b, a = sums[1][k] or 0, sums[2][k] or 0
    local weight = R:Score({ [k] = 1 }, player.classFile, ranged) or 0
    data.stats[#data.stats + 1] = { key = k, name = statName(k), before = b, after = a, delta = a - b, weight = weight }
  end
  -- poids de la classe d'abord (apport au score), puis les autres stats, gains avant pertes
  table.sort(data.stats, function(x, y)
    local cx, cy = math.abs(x.delta * x.weight), math.abs(y.delta * y.weight)
    if cx ~= cy then return cx > cy end
    if x.delta ~= y.delta then return x.delta > y.delta end
    return x.name < y.name
  end)
  for _, s in ipairs(data.stats) do
    if s.delta > 0 and s.weight > 0 and #data.summary < 2 then
      data.summary[#data.summary + 1] = signed(s.delta) .. " " .. s.name
    end
  end

  local had, has = {}, {}
  for _, it in ipairs(data.before) do for t in pairs(self:Effects(it.link)) do had[t] = true end end
  for _, it in ipairs(data.after) do for t in pairs(self:Effects(it.link)) do has[t] = true end end
  for t in pairs(had) do if not has[t] then data.effects[#data.effects + 1] = { text = t, kind = "lost" } end end
  for t in pairs(has) do if not had[t] then data.effects[#data.effects + 1] = { text = t, kind = "new" } end end
  table.sort(data.effects, function(x, y)
    if x.kind ~= y.kind then return x.kind == "lost" end
    return x.text < y.text
  end)
  return data
end

-- Ligne du score : « Score de classe : +5,4 (Voleur, mêlée) » ; profil automatique : la classe seule.
function Compare:ScoreLine(gain)
  local R = Q.Rewards
  local classFile = Q.Player and Q.Player.classFile
  local className = UnitClass and UnitClass("player") or classFile or "?"
  local value = GAIN .. signed(gain) .. "|r"
  local role = R:Role(classFile)
  if role == nil or role == "auto" then return string.format(L.UI_UPGRADE_SCORE_CLASS, value, className) end
  return string.format(L.UI_UPGRADE_SCORE, value, className, (R:RoleLabel(role, classFile) or ""):lower())
end

---------------------------------------------------------------------------
-- Panneau
---------------------------------------------------------------------------
local function theme()
  local T = Q.Themes
  return T and (T.Current and T:Current() or T:Get(setting("tracker.theme"))) or nil
end
local function recolor(text, th)
  return Q.Themes and Q.Themes:Recolor(text, th) or text
end
local function style(fs, role, th)
  if Q.Themes and fs then Q.Themes:StyleText(fs, role, th) end
end

function Compare:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyUpgradeCompare", UIParent, "BackdropTemplate")
  f:SetWidth(WIDTH)
  f:SetFrameStrata("MEDIUM")
  f:SetFrameLevel(20)
  f:Hide()
  self.frame = f
  self.pools = {}
  return f
end

-- Réserves : textes (une par police : le thème garde la police d'origine de chaque texte), icônes,
-- filets et étiquettes, réutilisés d'un affichage à l'autre.
local function pooled(self, list, make)
  self.used[list] = (self.used[list] or 0) + 1
  local pool = self.pools[list]
  if not pool then
    pool = {}
    self.pools[list] = pool
  end
  local obj = pool[self.used[list]]
  if not obj then
    obj = make()
    pool[self.used[list]] = obj
  end
  obj:ClearAllPoints()
  obj:Show()
  return obj
end

function Compare:Text(template, role)
  template = template or "GameFontHighlightSmall"
  local fs = pooled(self, "text:" .. template, function()
    return self.frame:CreateFontString(nil, "OVERLAY", template)
  end)
  fs:SetJustifyH("LEFT")
  fs:SetWidth(0)
  if fs.SetWordWrap then fs:SetWordWrap(false) end
  style(fs, role or "body", self.theme)
  return fs
end

function Compare:Icon(link)
  local tx = pooled(self, "icons", function() return self.frame:CreateTexture(nil, "ARTWORK") end)
  tx:SetSize(ICON, ICON)
  local id = itemId(link)
  local icon = id and C_Item and C_Item.GetItemIconByID and C_Item.GetItemIconByID(id)
  tx:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
  return tx
end

function Compare:Rule(y)
  local tx = pooled(self, "rules", function() return self.frame:CreateTexture(nil, "ARTWORK") end)
  local c = self.theme and self.theme.border and self.theme.border.color or { 0.5, 0.5, 0.5, 0.8 }
  tx:SetColorTexture(c[1], c[2], c[3], 0.8)
  tx:SetHeight(1)
  tx:SetPoint("TOPLEFT", self.frame, "TOPLEFT", PAD, -y)
  tx:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -PAD, -y)
  return y + 6
end

function Compare:Tag(kind, y)
  local tag = pooled(self, "tags", function()
    local bg = self.frame:CreateTexture(nil, "BORDER")
    bg.label = self.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    return bg
  end)
  local palette = TAG_BG[self.theme and self.theme.key == "parchment" and "parchment" or "other"]
  local c = palette[kind]
  tag:SetColorTexture(c[1], c[2], c[3], 1)
  tag.label:ClearAllPoints()
  tag.label:Show()
  tag.label:SetText(recolor((kind == "lost" and LOSS or GAIN) .. L[kind == "lost" and "UI_UPGRADE_LOST" or "UI_UPGRADE_NEW"] .. "|r", self.theme))
  tag:SetSize(TAG_W - 6, ROW_H - 2)
  tag:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", -PAD, -y - 1)
  tag.label:SetPoint("CENTER", tag, "CENTER", 0, 0)
  return tag
end

-- Show(owner, data) : panneau à côté de la boîte, du côté où l'écran a le plus de place.
function Compare:Show(owner, data)
  local f = self:Create()
  self.theme = theme()
  local T = Q.Themes
  if T then T:Apply(f, T.CurrentKey and T:CurrentKey() or setting("tracker.theme"), setting("tracker.opacity")) end
  self.used = {}
  for _, pool in pairs(self.pools) do
    for _, o in ipairs(pool) do
      o:Hide()
      if o.label then o.label:Hide() end
    end
  end
  local th = self.theme
  local y = PAD

  local function itemRows(label, items, fromBags)
    local head = self:Text("GameFontNormalSmall", "dim")
    head:SetText(label)
    head:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
    y = y + ROW_H
    if #items == 0 then
      local none = self:Text("GameFontHighlightSmall", "dim")
      none:SetText(L.UI_UPGRADE_EMPTY_SLOT)
      none:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
      y = y + ROW_H + 2
    end
    for i, it in ipairs(items) do
      local icon = self:Icon(it.link)
      icon:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
      local name = self:Text("GameFontHighlightSmall", "body")
      local suffix = fromBags and fromBags[i] and (" |cff999999" .. L.UI_UPGRADE_FROM_BAGS .. "|r") or ""
      name:SetText(recolor(self:ItemLabel(it, th) .. suffix, th))
      name:SetPoint("LEFT", icon, "RIGHT", 6, 0)
      name:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
      y = y + ICON + 3
    end
  end
  itemRows(L.UI_UPGRADE_BEFORE, data.before)
  itemRows(L.UI_UPGRADE_AFTER, data.after, data.fromBags)

  -- tableau Stat / Avant / Après / Écart
  y = self:Rule(y + 2)
  local function cell(text, col, role, template)
    local fs = self:Text(template or "GameFontHighlightSmall", role)
    fs:SetText(text)
    if col == 0 then
      fs:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
    else
      fs:SetJustifyH("RIGHT")
      fs:SetWidth(COL_W)
      fs:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD - (3 - col) * COL_W, -y)
    end
    return fs
  end
  cell(L.UI_UPGRADE_COL_STAT, 0, "dim")
  cell(L.UI_UPGRADE_COL_BEFORE, 1, "dim")
  cell(L.UI_UPGRADE_COL_AFTER, 2, "dim")
  cell(L.UI_UPGRADE_COL_DIFF, 3, "dim")
  y = y + ROW_H
  self.statRows = {}
  for _, s in ipairs(data.stats) do
    local nameFs = cell(s.name, 0, "body")
    nameFs:SetPoint("RIGHT", f, "RIGHT", -PAD - 3 * COL_W, 0)
    cell(s.before ~= 0 and number(s.before) or "—", 1, "body")
    cell(s.after ~= 0 and number(s.after) or "—", 2, "body")
    local color = s.delta > 0 and GAIN or (s.delta < 0 and LOSS or "|cff999999")
    local d = cell(recolor(color .. signed(s.delta) .. "|r", th), 3, "body")
    self.statRows[#self.statRows + 1] = { name = nameFs, diff = d }
    y = y + ROW_H
  end

  -- effets hors score
  y = self:Rule(y + 2)
  local eh = self:Text("GameFontNormalSmall", "dim")
  eh:SetText(L.UI_UPGRADE_EFFECTS)
  eh:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
  y = y + ROW_H
  self.effectRows = {}
  if #data.effects == 0 then
    local none = self:Text("GameFontHighlightSmall", "dim")
    none:SetText(L.UI_UPGRADE_EFFECTS_NONE)
    none:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
    y = y + ROW_H
  end
  for _, e in ipairs(data.effects) do
    local fs = self:Text("GameFontHighlightSmall", "body")
    if fs.SetWordWrap then fs:SetWordWrap(true) end
    fs:SetWidth(WIDTH - 2 * PAD - TAG_W)
    fs:SetText(recolor((e.kind == "lost" and LOSS or GAIN) .. e.text .. "|r", th))
    fs:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
    local tag = self:Tag(e.kind, y)
    self.effectRows[#self.effectRows + 1] = { text = fs, tag = tag }
    local h = fs.GetStringHeight and tonumber(fs:GetStringHeight()) or ROW_H
    y = y + math.max(ROW_H, h + 2)
  end

  if data.gain then
    y = self:Rule(y + 2)
    local sc = self:Text("GameFontNormalSmall", "dim")
    sc:SetText(recolor(self:ScoreLine(data.gain), th))
    sc:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
    sc:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
    self.scoreText = sc
    y = y + ROW_H
  else
    self.scoreText = nil
  end
  f:SetHeight(y + PAD - 2)

  -- côté libre : à gauche si la boîte est dans la moitié droite de l'écran
  f:SetScale(owner:GetScale() or 1)
  f:ClearAllPoints()
  local x = owner:GetCenter()
  local screen = (UIParent and UIParent:GetWidth()) or 0
  if screen <= 0 and GetScreenWidth then screen = GetScreenWidth() end
  if x and screen > 0 and x * (owner:GetEffectiveScale() or 1) > screen * ((UIParent and UIParent:GetEffectiveScale()) or 1) / 2 then
    f:SetPoint("TOPRIGHT", owner, "TOPLEFT", -4, 0)
    self.side = "left"
  else
    f:SetPoint("TOPLEFT", owner, "TOPRIGHT", 4, 0)
    self.side = "right"
  end
  self.data = data
  f:Show()
  return f
end

function Compare:Hide()
  if self.frame then self.frame:Hide() end
end

function Compare:IsShown()
  return self.frame ~= nil and self.frame:IsShown()
end
