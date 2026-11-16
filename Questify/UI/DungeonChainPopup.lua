local addonName, Q = ...

-- Annexe « Suite de quêtes » du journal (« Voir la suite » dans l'onglet Donjons) : collée à droite du journal,
-- même hauteur, fermée avec lui et avec Échap. Pour la chaîne de préquêtes d'une quête de donjon : nombre de
-- quêtes, niveaux et donjon ; zones dans l'ordre de passage (en vert celles déjà sur la route du chapitre) ;
-- étapes dans l'ordre (type d'action, donneur, zone, XP) ; quêtes débloquées et XP (la suite seule, puis avec
-- le donjon) ; objets de récompense (boutons de UI/ClassQuestPopup.lua : infobulle et comparaison comme dans
-- le sac). Un bouton ajoute la suite à la route (Q.Dungeons:AddChain) ou l'en retire.
-- TooltipLines sert aussi au survol de l'encadré dans le journal.
-- Habillage du thème (UI/Themes.lua) : bandeau avec blason et titre, textes, pastilles et boutons aux
-- couleurs du thème (ajout ou retrait de la suite en action principale), repeints au changement de thème.
Q.UI = Q.UI or {}
local Popup = { lines = {}, xps = {}, items = {}, pills = {}, arrows = {}, rewardHeads = {} }
Q.UI.DungeonChainPopup = Popup

local L = Q.L

local FRAME_NAME = "QuestifyDungeonChainPopup"
local WIDTH = 350
local INNER = WIDTH - 56          -- largeur du contenu (barre de défilement comprise)
local XP_W = 64
local ITEM_SIZE = 30
local MAX_ITEMS = 24
local GIVER_COLOR = "|cff00ff96"
local XP_COLOR = "|cffaaaaaa"
local ICONS = {
  talk = "Interface\\GossipFrame\\GossipGossipIcon",
  objectives = "Interface\\Icons\\INV_Sword_04",
  event = "Interface\\Icons\\Ability_Rogue_Sprint",
}

---------------------------------------------------------------------------
-- Textes
---------------------------------------------------------------------------
local function fmtNumber(n)
  local s = tostring(math.floor(tonumber(n) or 0))
  local out = s:reverse():gsub("(%d%d%d)", "%1 "):reverse()
  return (out:gsub("^ ", ""))
end
Popup.FormatNumber = fmtNumber

local function npcName(npc, obj)
  if npc then return Q.QDB:NpcName(npc) end
  if obj then return Q.QDB:ObjectName(obj) end
  return "?"
end

local function zoneName(m) return type(m) == "number" and Q.Maps:MapName(m) or "?" end

local function zonesText(info)
  local names = {}
  for _, m in ipairs(info.zones or {}) do names[#names + 1] = zoneName(m) end
  return table.concat(names, ", ")
end

local function questList(ids)
  local names = {}
  for _, id in ipairs(ids or {}) do names[#names + 1] = Q.QDB:QuestName(id) end
  if #names <= 1 then return names[1] or "" end
  return table.concat(names, ", ", 1, #names - 1) .. L.DUNGEON_CHAIN_AND .. names[#names]
end

local function countText(info)
  local n = #(info.quests or {})
  if n == 1 then return L.DUNGEON_CHAIN_COUNT_ONE end
  return string.format(L.DUNGEON_CHAIN_COUNT, n)
end

-- « 6 quêtes · niveaux 14 à 18 · avant Les Mortemines ».
function Popup.MetaText(info)
  local n = #(info.quests or {})
  local parts = {}
  if n > 0 then parts[1] = n == 1 and L.DUNGEON_CHAIN_N_ONE or string.format(L.DUNGEON_CHAIN_N, n) end
  local lo, hi = tonumber(info.minLevel), tonumber(info.maxLevel)
  if lo and hi and lo < hi then
    parts[#parts + 1] = string.format(L.DUNGEON_CHAIN_LEVELS, lo, hi)
  elseif lo or hi then
    parts[#parts + 1] = string.format(L.DUNGEON_CHAIN_LEVEL, lo or hi)
  end
  if info.ready == false and info.readyLevel then
    parts[#parts + 1] = string.format(L.DUNGEON_CHAIN_READY_AT, info.readyLevel)
  end
  if info.dungeon then parts[#parts + 1] = string.format(L.DUNGEON_CHAIN_BEFORE, info.dungeon) end
  return table.concat(parts, " · ")
end

-- Étape « 1. [icône] Nom - Donneur (Zone) » ; une quête où l'on ne fait que parler nomme aussi son receveur.
function Popup.StepText(i, row)
  local icon = ICONS[row.kind] or ICONS.objectives
  local text = string.format(L.DUNGEON_CHAIN_STEP, Q.QDB:QuestName(row.id),
    GIVER_COLOR .. npcName(row.giver, row.obj) .. "|r", zoneName(row.at and row.at[1]))
  local sameEnd = (row.ender and row.ender == row.giver) or (row.endObj and row.endObj == row.obj)
  if row.kind == "talk" and (row.ender or row.endObj) and not sameEnd then
    text = text .. string.format(L.DUNGEON_CHAIN_STEP_TO, GIVER_COLOR .. npcName(row.ender, row.endObj) .. "|r",
      zoneName(row.endAt and row.endAt[1]))
  end
  return ("%d. |T%s:14:14|t %s"):format(i, icon, text)
end

-- Nom d'un objet (couleur de qualité si le client le connaît déjà).
local function itemName(itemId)
  if C_Item and C_Item.GetItemInfo then
    local ok, name, _, quality = pcall(C_Item.GetItemInfo, itemId)
    if ok and type(name) == "string" then
      local color = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[quality or 1]
      if color and color.hex then return color.hex .. name .. "|r" end
      return name
    end
  end
  local name = Q.QDB:ItemName(itemId)
  return name or ("item " .. tostring(itemId))
end

-- Lignes d'infobulle (première ligne = titre) : quêtes à faire, zones, XP, quêtes débloquées, récompenses.
function Popup.TooltipLines(info)
  local lines = { countText(info) }
  lines[#lines + 1] = string.format(L.DUNGEON_CHAIN_ZONES, zonesText(info))
  lines[#lines + 1] = string.format(L.DUNGEON_CHAIN_UNLOCKS, questList(info.unlocks))
  if (tonumber(info.xp) or 0) > 0 then
    lines[#lines + 1] = string.format(L.DUNGEON_CHAIN_XP, fmtNumber(info.xp))
  end
  local groups = info.rewards or {}
  if #groups > 0 then
    lines[#lines + 1] = L.DUNGEON_CHAIN_REWARDS
    for _, g in ipairs(groups) do
      local indent = "  "
      if #groups > 1 then
        lines[#lines + 1] = "  " .. string.format(L.DUNGEON_CHAIN_REWARD_QUEST, Q.QDB:QuestName(g.quest))
        indent = "    "
      end
      for _, it in ipairs(g.items) do lines[#lines + 1] = indent .. itemName(it) end
    end
  else
    lines[#lines + 1] = L.DUNGEON_CHAIN_NO_REWARD
  end
  return lines
end

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

-- Codes de couleur des textes remplacés par ceux du thème.
local function recolor(text)
  local T = Q.Themes
  if T then return T:Recolor(text) end
  return text
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

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function newFrame()
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "ButtonFrameTemplate")
  if ok and f then return f end
  ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "BasicFrameTemplateWithInset")
  if ok and f then return f end
  return CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
end

local function text(parent, font, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", font)
  fs:SetJustifyH("LEFT")
  if width then fs:SetWidth(width) end
  fs:SetWordWrap(true)
  return fs
end

function Popup:Create()
  if self.frame then return self.frame end
  local f = newFrame()
  self.frame = f
  f:SetSize(WIDTH, 560)
  f:SetFrameStrata("MEDIUM")
  f:SetToplevel(true)
  f:EnableMouse(true)
  if f.SetTitle then f:SetTitle(L.DUNGEON_CHAIN_WINDOW) end
  if ButtonFrameTemplate_HidePortrait then pcall(ButtonFrameTemplate_HidePortrait, f) end
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end
  local head = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  head:SetText(L.DUNGEON_CHAIN_WINDOW)
  self.headText = head
  self.footBar = skinWindow(f, head)
  if not self.footBar then head:Hide() end

  -- liste défilante : sous le bandeau du thème (sinon sous le titre du modèle), au-dessus du pied
  local scroll = CreateFrame("ScrollFrame", FRAME_NAME .. "Scroll", f, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", f, "TOPLEFT", 14, self.footBar and -(HEADER_H + 10) or -30)
  scroll:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -32, self.footBar and FOOTER_H + 6 or 32)
  local c = CreateFrame("Frame", nil, scroll)
  c:SetSize(INNER, 1)
  scroll:SetScrollChild(c)
  self.scroll, self.content = scroll, c

  self.title = text(c, "GameFontNormalLarge", INNER)
  self.meta = text(c, "GameFontHighlightSmall", INNER)
  self.whereHeader = text(c, "GameFontNormal", INNER)
  self.whereHeader:SetText(L.DUNGEON_CHAIN_WHERE)
  self.legend = text(c, "GameFontDisableSmall", INNER)
  self.legend:SetText(L.DUNGEON_CHAIN_LEGEND)
  self.orderHeader = text(c, "GameFontNormal", INNER)
  self.orderHeader:SetText(L.DUNGEON_CHAIN_ORDER)
  self.levelOnly = text(c, "GameFontHighlightSmall", INNER)
  self.unlocksHeader = text(c, "GameFontNormal", INNER)
  self.unlocksHeader:SetText(L.DUNGEON_CHAIN_UNLOCKS_HEADER)
  self.unlocks = text(c, "GameFontHighlightSmall", INNER)
  self.xpChain = text(c, "GameFontHighlightSmall", INNER)
  self.xpAll = text(c, "GameFontHighlightSmall", INNER)
  self.rewardsHeader = text(c, "GameFontNormal", INNER)
  self.rewardsHeader:SetText(L.DUNGEON_CHAIN_REWARDS_HEADER)
  self.rewardsHint = text(c, "GameFontDisableSmall", INNER)
  self.rewardsHint:SetText(L.DUNGEON_CHAIN_REWARDS_HINT)
  self.noReward = text(c, "GameFontDisable", INNER)
  self.noReward:SetText(L.DUNGEON_CHAIN_NO_REWARD)
  self.foot = text(c, "GameFontDisableSmall", INNER)
  self.foot:SetText(L.DUNGEON_CHAIN_FOOT)
  for i = 1, MAX_ITEMS do
    self.items[i] = Q.UI.ClassQuestPopup.CreateItemButton(c, ITEM_SIZE)
  end

  local toggle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  toggle:SetSize(190, 22)
  toggle:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, self.footBar and (FOOTER_H - 22) / 2 + 1 or 4)
  toggle:SetScript("OnClick", function() Q.SafeCall(function() Popup:Toggle() end) end)
  self.toggleButton = skin(toggle, "primary")
  local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  close:SetSize(90, 22)
  close:SetPoint("RIGHT", toggle, "LEFT", -6, 0)
  close:SetText(CLOSE or "Close")
  close:SetScript("OnClick", function() f:Hide() end)
  self.closeButton = skin(close, "secondary")

  self:ApplyTheme()
  f:Hide()
  return f
end

-- Rôle de couleur de chaque texte fixe de la fenêtre.
local TEXT_COLORS = {
  headText = "title", title = "quest", meta = "textDim", whereHeader = "textMuted", legend = "textMuted",
  orderHeader = "textMuted", levelOnly = "textDim", unlocksHeader = "textMuted", unlocks = "text",
  xpChain = "xp", xpAll = "xp", rewardsHeader = "textMuted", rewardsHint = "textMuted",
  noReward = "textMuted", foot = "textMuted",
}

-- Couleurs du thème : textes, boutons, croix et pied (les pastilles et les étapes au prochain Show).
function Popup:ApplyTheme()
  if not (self.frame and Q.Themes) then return end
  for key, role in pairs(TEXT_COLORS) do paint(self[key], role) end
  for _, fs in ipairs(self.lines) do paint(fs, "text") end
  for _, fs in ipairs(self.xps) do paint(fs, "textDim") end
  for _, a in ipairs(self.arrows) do paint(a, "textMuted") end
  for _, h in ipairs(self.rewardHeads) do paint(h, "textDim") end
  skin(self.toggleButton, "primary")
  skin(self.closeButton, "secondary")
  paintChrome(self.frame, self.footBar)
end

-- Annexe collée à droite du journal (même hauteur), fermée avec lui ; au centre de l'écran sans journal.
function Popup:Dock()
  local f = self.frame
  local J = Q.UI.Journal
  local jf = J and J.frame
  f:ClearAllPoints()
  if jf and jf:IsShown() then
    f:SetPoint("TOPLEFT", jf, "TOPRIGHT", 0, 0)
    f:SetHeight(jf:GetHeight() or 560)
    if not self.hooked then
      self.hooked = true
      jf:HookScript("OnHide", function() if Popup.frame then Popup.frame:Hide() end end)
    end
  else
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

local function line(i)
  local fs = Popup.lines[i]
  if fs then return fs end
  fs = text(Popup.content, "GameFontHighlightSmall", INNER - XP_W)
  paint(fs, "text")
  Popup.lines[i] = fs
  local xp = Popup.content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  xp:SetJustifyH("RIGHT")
  xp:SetWidth(XP_W)
  paint(xp, "textDim")
  Popup.xps[i] = xp
  return fs, xp
end

local function place(region, y, x)
  region:ClearAllPoints()
  region:SetPoint("TOPLEFT", Popup.content, "TOPLEFT", x or 0, -y)
end

-- Pastille d'une zone en gélule (bord 1 px, rayon = demi-hauteur, comme la maquette), sans fichier livré :
-- deux couches (bord, puis fond rentré de 1 px), chacune faite de deux disques aux extrémités (masque
-- circulaire du client) et d'un rectangle entre leurs centres. Bord vert et texte vert clair pour une zone
-- déjà sur la route. Avec le thème : fond panelAlt, bord edge, texte textDim ; zone de la route en
-- couleur des zones (jeton zone). Les couleurs ci-dessous servent sans module de thèmes.
local PILL_H = 16
local PILL_FILL = { 0.184, 0.165, 0.125 }          -- #2f2a20
local PILL_EDGE = { 0.420, 0.388, 0.322 }          -- #6b6352
local PILL_EDGE_ROUTE = { 0.251, 0.878, 0.314 }    -- #40e050
local PILL_TEXT = { 0.910, 0.878, 0.800 }          -- #e8e0cc
local PILL_TEXT_ROUTE = { 0.6, 1, 0.6 }            -- #9f9
local CIRCLE_MASK = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"

local function capsule(p, sublevel, inset)
  local h = PILL_H - 2 * inset
  local function disc(point, x)
    local tex = p:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    tex:SetSize(h, h)
    tex:SetPoint(point, p, point, x, 0)
    local m = p:CreateMaskTexture()
    m:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    m:SetAllPoints(tex)
    tex:AddMaskTexture(m)
    tex.mask = m
    return tex
  end
  local part = { left = disc("LEFT", inset), right = disc("RIGHT", -inset) }
  local mid = p:CreateTexture(nil, "BACKGROUND", nil, sublevel)
  mid:SetPoint("TOPLEFT", p, "TOPLEFT", inset + h / 2, -inset)
  mid:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -(inset + h / 2), inset)
  part.mid = mid
  return part
end

local function paintPill(part, c)
  for _, k in ipairs({ "left", "right", "mid" }) do part[k]:SetColorTexture(c[1], c[2], c[3], 1) end
end

-- Couleur d'un jeton du thème { r, g, b }, sinon fallback.
local function token(role, fallback)
  local T = Q.Themes
  if not T then return fallback end
  local r, g, b = T:Color(role)
  return { r, g, b }
end

local function pill(i)
  local p = Popup.pills[i]
  if p then return p end
  p = CreateFrame("Frame", nil, Popup.content)
  p:SetHeight(PILL_H)
  p.edge = capsule(p, 1, 0)
  p.fill = capsule(p, 2, 1)
  p.text = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  p.text:SetPoint("CENTER", p, "CENTER", 0, 0)
  Popup.pills[i] = p
  return p
end

-- Couleurs d'une pastille selon que la zone est déjà sur la route.
local function setPill(p, onRoute)
  p.onRoute = onRoute and true or false
  paintPill(p.fill, token("panelAlt", PILL_FILL))
  paintPill(p.edge, onRoute and token("zone", PILL_EDGE_ROUTE) or token("edge", PILL_EDGE))
  local c = onRoute and token("zone", PILL_TEXT_ROUTE) or token("textDim", PILL_TEXT)
  p.text:SetTextColor(c[1], c[2], c[3])
end

local function arrow(i)
  local a = Popup.arrows[i]
  if a then return a end
  a = Popup.content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  a:SetText("»")
  paint(a, "textMuted")
  Popup.arrows[i] = a
  return a
end

-- Trajet en pastilles, à la ligne quand la largeur est pleine. -> hauteur occupée.
local function layoutPath(info, y)
  local x, rowY, n = 0, y, 0
  local path = info.path or info.zones or {}
  for i, m in ipairs(path) do
    local p = pill(i)
    p.text:SetText(zoneName(m))
    local w = math.min(INNER, math.max(PILL_H, (p.text:GetStringWidth() or 60) + 16))
    p:SetSize(w, PILL_H)
    setPill(p, info.onRoute and info.onRoute[m])
    local a = i > 1 and arrow(i - 1) or nil
    local need = w + (a and 16 or 0)
    if x > 0 and x + need > INNER then x, rowY = 0, rowY + PILL_H + 4 end
    if a then
      a:ClearAllPoints()
      if x == 0 then
        a:SetPoint("TOPLEFT", Popup.content, "TOPLEFT", 0, -(rowY + 2))
        x = 14
      else
        a:SetPoint("TOPLEFT", Popup.content, "TOPLEFT", x + 3, -(rowY + 2))
        x = x + 16
      end
      a:Show()
    end
    p:ClearAllPoints()
    p:SetPoint("TOPLEFT", Popup.content, "TOPLEFT", x, -rowY)
    p:Show()
    x = x + w + 2
    n = i
  end
  for i = n + 1, #Popup.pills do Popup.pills[i]:Hide() end
  for i = math.max(n, 1), #Popup.arrows do Popup.arrows[i]:Hide() end
  if n == 0 then return 0 end
  return rowY - y + PILL_H + 4
end

---------------------------------------------------------------------------
-- Affichage
---------------------------------------------------------------------------
-- Show(key, questId) : chaîne de la quête du donjon `key`. Faux (annexe cachée) s'il n'y a rien à montrer.
function Popup:Show(key, questId)
  local D = Q.Dungeons
  local info
  if D and D.ChainInfo then
    local ok, res = pcall(D.ChainInfo, D, key, questId)
    if ok then info = res else Q:ReportError(res) end
  end
  if not info then
    if self.frame then self.frame:Hide() end
    return false
  end
  self:Create()
  self.key, self.questId, self.info = key, questId, info
  local y = 0
  local function put(region, gap, x)
    place(region, y, x)
    region:Show()
    y = y + (region:GetStringHeight() or 13) + (gap or 4)
  end
  self.title:SetText(Q.QDB:QuestName(questId))
  put(self.title, 2)
  self.meta:SetText(Popup.MetaText(info))
  put(self.meta, 12)
  -- Où ça se passe (rien pour une quête bloquée seulement par le niveau)
  if #(info.path or {}) > 0 then
    put(self.whereHeader, 6)
    y = y + layoutPath(info, y) + 2
    put(self.legend, 12)
  else
    layoutPath(info, y)
    self.whereHeader:Hide()
    self.legend:Hide()
  end
  -- La suite, dans l'ordre
  put(self.orderHeader, 6)
  if #info.quests == 0 then
    self.levelOnly:SetFormattedText(L.DUNGEON_CHAIN_LEVEL_ONLY, tonumber(info.readyLevel) or 1)
    put(self.levelOnly, 4)
  else
    self.levelOnly:Hide()
  end
  for i, row in ipairs(info.quests) do
    local fs, xp = line(i)
    xp = xp or self.xps[i]
    fs:SetText(recolor(Popup.StepText(i, row)))
    place(fs, y, 4)
    fs:Show()
    xp:SetText((tonumber(row.xp) or 0) > 0 and recolor(XP_COLOR .. string.format(L.DUNGEON_CHAIN_STEP_XP, fmtNumber(row.xp)) .. "|r") or "")
    xp:ClearAllPoints()
    xp:SetPoint("TOPRIGHT", self.content, "TOPLEFT", INNER, -y)
    xp:Show()
    y = y + math.max(14, fs:GetStringHeight() or 13) + 4
  end
  for i = #info.quests + 1, #self.lines do self.lines[i]:Hide(); self.xps[i]:Hide() end
  y = y + 8
  -- Ce que ça débloque
  put(self.unlocksHeader, 6)
  self.unlocks:SetFormattedText(L.DUNGEON_CHAIN_UNLOCKS_IN, info.dungeon or "?", questList(info.unlocks))
  put(self.unlocks, 4)
  if (tonumber(info.xpChain) or 0) > 0 then
    self.xpChain:SetFormattedText(L.DUNGEON_CHAIN_XP_CHAIN, fmtNumber(info.xpChain))
    put(self.xpChain, 2)
  else
    self.xpChain:Hide()
  end
  if (tonumber(info.xp) or 0) > (tonumber(info.xpChain) or 0) then
    self.xpAll:SetFormattedText(L.DUNGEON_CHAIN_XP_ALL, fmtNumber(info.xp))
    put(self.xpAll, 2)
  else
    self.xpAll:Hide()
  end
  y = y + 10
  -- Récompenses : celles des quêtes du donjon débloquées, sous le nom de chaque quête quand il y en a plusieurs
  put(self.rewardsHeader, 4)
  local groups = info.rewards or {}
  local perRow = math.max(1, math.floor(INNER / (ITEM_SIZE + 6)))
  local n, heads = 0, 0
  if #groups > 0 then
    self.noReward:Hide()
    put(self.rewardsHint, 6)
    for _, g in ipairs(groups) do
      if #groups > 1 then
        heads = heads + 1
        local h = self.rewardHeads[heads]
        if not h then
          h = text(self.content, "GameFontHighlightSmall", INNER)
          paint(h, "textDim")
          self.rewardHeads[heads] = h
        end
        h:SetFormattedText(L.DUNGEON_CHAIN_REWARD_QUEST, Q.QDB:QuestName(g.quest))
        put(h, 3)
      end
      local count = 0
      for _, it in ipairs(g.items) do
        if n < MAX_ITEMS then
          n, count = n + 1, count + 1
          local b = self.items[n]
          Q.UI.ClassQuestPopup.SetItemButton(b, it)
          local col, rowN = (count - 1) % perRow, math.floor((count - 1) / perRow)
          b:ClearAllPoints()
          b:SetPoint("TOPLEFT", self.content, "TOPLEFT", col * (ITEM_SIZE + 6), -(y + rowN * (ITEM_SIZE + 4)))
        end
      end
      y = y + math.ceil(count / perRow) * (ITEM_SIZE + 4) + 4
    end
  else
    self.rewardsHint:Hide()
    put(self.noReward, 6)
  end
  for i = n + 1, MAX_ITEMS do self.items[i]:Hide() end
  for i = heads + 1, #self.rewardHeads do self.rewardHeads[i]:Hide() end
  y = y + 6
  if info.ready == false then
    self.foot:SetFormattedText(L.DUNGEON_CHAIN_FOOT_LATER, tonumber(info.readyLevel) or 1)
  else
    self.foot:SetText(L.DUNGEON_CHAIN_FOOT)
  end
  put(self.foot, 4)
  self.content:SetHeight(math.max(1, y))
  self.toggleButton:SetText(info.chosen and L.DUNGEON_CHAIN_REMOVE_ROUTE or L.DUNGEON_CHAIN_ADD_ROUTE)
  self:Dock()
  self.frame:Show()
  return true
end

-- Toggle() : ajoute la suite à la route, ou l'en retire, puis rafraîchit l'annexe et le journal.
function Popup:Toggle()
  local D = Q.Dungeons
  if not (D and self.key and self.questId and self.info) then return end
  if self.info.chosen then D:RemoveChain(self.key, self.questId) else D:AddChain(self.key, self.questId) end
  if PlaySound and SOUNDKIT then pcall(PlaySound, SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) end
  if not self:Show(self.key, self.questId) and self.frame then self.frame:Hide() end
  local J = Q.UI.Journal
  if J and J.frame and J.frame:IsShown() and J.RefreshDungeonTab then J:RefreshDungeonTab() end
end

function Popup:Hide()
  if self.frame then self.frame:Hide() end
end

-- Changement de thème : couleurs repeintes ; annexe ouverte : étapes et pastilles refaites.
Q:On("THEME_CHANGED", function()
  if not Popup.frame then return end
  Q.SafeCall(Popup.ApplyTheme, Popup)
  if Popup.frame:IsShown() and Popup.key and Popup.questId then
    Q.SafeCall(Popup.Show, Popup, Popup.key, Popup.questId)
  end
end)
