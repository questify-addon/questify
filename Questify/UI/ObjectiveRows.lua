local addonName, Q = ...

-- Rendu des lignes de l'étape courante, commun au suivi (UI/Tracker.lua) et à l'aperçu de
-- l'assistant (UI/Wizard.lua). Les lignes sont des morceaux (« segments ») posés de haut en bas :
--   { text = "..." }                       texte coloré qui passe à la ligne (titre, notes) ;
--   { obj = ligne, bars, num, dist }       objectif : trait de l'objectif visé, icône (ou numéro du
--                                          mode zone), libellé, distance, compteur à droite, barre ;
--   { mob = monstre }                      monstre ciblable : crâne, nom, niveau (bouton posé par MobPanel) ;
--   { quest = nom, sub = "· 2/4" }         en-tête de quête (mise en page « par quête », zone hors de la zone) ;
--   { group = nom }                        groupe du mode zone (petites capitales et filet) ;
--   { pill = nom, sub = "5 objectifs…" }   pastille arrondie du mode zone ;
--   { fold = texte }                       objectifs faits repliés (coche).
-- Couleurs : rôles du thème (Q.Themes:TextColor) et codes Questify vus par le thème
-- (Q.Themes:CodeColor) : rien de propre à ce module. Hôte : table { parent, theme, textChunks,
-- mobRows, … } dont les réserves de lignes sont gardées d'un rendu à l'autre (rien n'est détruit).
Q.UI = Q.UI or {}
local Rows = {}
Q.UI.ObjectiveRows = Rows

local OBJ_H = 15            -- ligne d'objectif
local BAR_H, BAR_GAP = 3, 2 -- barre d'avancement sous le libellé
local ICON = 13
local ICON_GAP = 5
local MARK_X = 5            -- trait de l'objectif visé, à gauche de l'icône
local COUNT_W = 34
local MOB_ROW_H = 16
local MOB_INDENT = 10
local MOB_LEVEL_W = 62
local QUEST_H = 14
local GROUP_H = 13
local PILL_H = 16
local FOLD_H = 14
local NUM = 12
Rows.OBJ_H, Rows.MOB_ROW_H = OBJ_H, MOB_ROW_H

local SKULL_ICON = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
local CIRCLE_MASK = "Interface\\CHARACTERFRAME\\TempPortraitAlphaMask"
local WHITE = "Interface\\Buttons\\WHITE8X8"

-- Codes de couleur Questify (remappés par le thème) : objectif fait, zone, quête, monstre, niveau.
local CODE_OK = "ff40e050"
local CODE_QUEST = "ffffd100"
local MOB_COLOR = "|cffff6060"
local MOB_DONE_COLOR = "|cff808080"
local LEVEL_COLOR = "|cffaaaaaa"
Rows.CODE_OK, Rows.CODE_QUEST = CODE_OK, CODE_QUEST

---------------------------------------------------------------------------
-- Couleurs
---------------------------------------------------------------------------
local function themes() return Q.Themes end

local function roleColor(host, role)
  local T = themes()
  if T and T.TextColor then return T:TextColor(role, host.theme) end
  return { 1, 1, 1 }
end

local function codeColor(host, hex)
  local T = themes()
  if T and T.CodeColor then return T:CodeColor(hex, host.theme) or roleColor(host, "body") end
  return roleColor(host, "body")
end

local function paint(host, text)
  local T = themes()
  if T and T.Recolor then return T:Recolor(text, host.theme) end
  return text
end

local function style(host, fs, role)
  local T = themes()
  if T and T.StyleText and fs then T:StyleText(fs, role, host.theme) end
end

local function tint(fs, c)
  if fs and c then fs:SetTextColor(c[1], c[2], c[3], 1) end
end

local function hex(c)
  return string.format("ff%02x%02x%02x", math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5),
    math.floor(c[3] * 255 + 0.5))
end

-- Majuscules (petites capitales des groupes), lettres accentuées françaises comprises : string.upper
-- ne touche qu'aux lettres ASCII.
local ACCENTS = { ["é"] = "É", ["è"] = "È", ["ê"] = "Ê", ["ë"] = "Ë", ["à"] = "À", ["â"] = "Â", ["ç"] = "Ç",
  ["î"] = "Î", ["ï"] = "Ï", ["ô"] = "Ô", ["ù"] = "Ù", ["û"] = "Û", ["ü"] = "Ü" }
local function upper(s)
  s = tostring(s or ""):upper()
  for lo, up in pairs(ACCENTS) do s = s:gsub(lo, up) end
  return s
end
Rows.Upper = upper

local function pool(host, name)
  host[name] = host[name] or {}
  return host[name]
end

local function font(parent, template, wrap, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template)
  fs:SetJustifyH(justify or "LEFT")
  fs:SetJustifyV("TOP")
  fs:SetWordWrap(wrap and true or false)
  fs:Hide()
  return fs
end

local function hideAll(list, from)
  for i = from, #list do
    local item = list[i]
    if item.Hide then
      item:Hide()
    else
      for _, region in pairs(item) do
        if type(region) == "table" and region.Hide then region:Hide() end
      end
      item.mob = nil
    end
  end
end

---------------------------------------------------------------------------
-- Réserves de lignes
---------------------------------------------------------------------------
local function textChunk(host, i)
  local list = pool(host, "textChunks")
  local chunk = list[i]
  if chunk then return chunk end
  chunk = font(host.parent, "GameFontHighlight", true)
  style(host, chunk, "body")
  list[i] = chunk
  return chunk
end
Rows.TextChunk = textChunk

local function mobRow(host, i)
  local list = pool(host, "mobRows")
  local row = list[i]
  if row then return row end
  local p = host.parent
  row = {}
  row.skull = p:CreateTexture(nil, "ARTWORK")
  row.skull:SetTexture(SKULL_ICON)
  row.skull:SetSize(12, 12)
  row.name = font(p, "GameFontHighlightSmall")
  row.level = font(p, "GameFontDisableSmall", false, "RIGHT")
  row.level:SetWidth(MOB_LEVEL_W)
  style(host, row.name, "body")
  style(host, row.level, "dim")
  row.skull:Hide()
  list[i] = row
  return row
end

local function objRow(host, i)
  local list = pool(host, "objRows")
  local row = list[i]
  if row then return row end
  local p = host.parent
  row = {}
  row.mark = p:CreateTexture(nil, "ARTWORK")
  row.mark:SetTexture(WHITE)
  row.mark:SetWidth(2)
  row.icon = p:CreateTexture(nil, "ARTWORK")
  row.icon:SetSize(ICON, ICON)
  row.numBg = p:CreateTexture(nil, "ARTWORK")
  row.numBg:SetSize(NUM, NUM)
  row.numBg:SetTexture(CIRCLE_MASK)
  row.num = font(p, "GameFontHighlightSmall", false, "CENTER")
  row.num:SetWidth(NUM + 4)
  row.label = font(p, "GameFontHighlight")
  row.count = font(p, "GameFontHighlightSmall", false, "RIGHT")
  row.count:SetWidth(COUNT_W)
  row.barBg = p:CreateTexture(nil, "ARTWORK")
  row.barBg:SetTexture(WHITE)
  row.barBg:SetHeight(BAR_H)
  row.bar = p:CreateTexture(nil, "OVERLAY")
  row.bar:SetTexture(WHITE)
  row.bar:SetHeight(BAR_H)
  style(host, row.label, "body")
  style(host, row.count, "body")
  style(host, row.num, "body")
  for _, r in pairs(row) do if r.Hide then r:Hide() end end
  list[i] = row
  return row
end

local function questHead(host, i)
  local list = pool(host, "questHeads")
  local fs = list[i]
  if fs then return fs end
  fs = font(host.parent, "GameFontNormalSmall")
  style(host, fs, "body")
  list[i] = fs
  return fs
end

local function groupHead(host, i)
  local list = pool(host, "groupHeads")
  local g = list[i]
  if g then return g end
  g = {}
  g.text = font(host.parent, "GameFontDisableSmall")
  style(host, g.text, "dim")
  g.line = host.parent:CreateTexture(nil, "ARTWORK")
  g.line:SetTexture(WHITE)
  g.line:SetHeight(1)
  g.line:Hide()
  list[i] = g
  return g
end

-- Capsule arrondie : deux disques (masque circulaire du jeu) et un rectangle entre leurs centres.
local function capsule(p, sublevel, h, inset)
  local function disc(point, x)
    local tex = p:CreateTexture(nil, "BACKGROUND", nil, sublevel)
    tex:SetSize(h, h)
    tex:SetPoint(point, p, point, x, 0)
    if p.CreateMaskTexture and tex.AddMaskTexture then
      local m = p:CreateMaskTexture()
      m:SetTexture(CIRCLE_MASK, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
      m:SetAllPoints(tex)
      tex:AddMaskTexture(m)
    end
    return tex
  end
  local part = { disc("LEFT", inset), disc("RIGHT", -inset) }
  local mid = p:CreateTexture(nil, "BACKGROUND", nil, sublevel)
  mid:SetPoint("TOPLEFT", p, "TOPLEFT", inset + h / 2, -inset)
  mid:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -(inset + h / 2), inset)
  part[3] = mid
  return part
end

local function paintCapsule(part, c, a)
  for _, tex in ipairs(part) do tex:SetColorTexture(c[1], c[2], c[3], a) end
end

local function pill(host, i)
  local list = pool(host, "pills")
  local pl = list[i]
  if pl then return pl end
  local f = CreateFrame("Frame", nil, host.parent)
  f:SetHeight(PILL_H)
  f.edge = capsule(f, 1, PILL_H, 0)
  f.fill = capsule(f, 2, PILL_H - 2, 1)
  f.text = font(f, "GameFontHighlight")
  f.text:SetPoint("LEFT", f, "LEFT", 8, 0)
  f.text:Show()
  f.sub = font(f, "GameFontDisableSmall")
  f.sub:SetPoint("LEFT", f.text, "RIGHT", 5, 0)
  f.sub:Show()
  style(host, f.text, "body")
  style(host, f.sub, "dim")
  f:Hide()
  list[i] = f
  return f
end

local function foldLine(host, i)
  local list = pool(host, "foldLines")
  local fl = list[i]
  if fl then return fl end
  fl = {}
  fl.icon = host.parent:CreateTexture(nil, "ARTWORK")
  fl.icon:SetSize(11, 11)
  fl.icon:SetTexture(Q.Objectives and Q.Objectives.ICONS.done or "Interface\\RaidFrame\\ReadyCheck-Ready")
  fl.icon:Hide()
  fl.text = font(host.parent, "GameFontDisableSmall")
  style(host, fl.text, "dim")
  list[i] = fl
  return fl
end

---------------------------------------------------------------------------
-- Pose des lignes
---------------------------------------------------------------------------
local function at(region, host, x, y)
  region:ClearAllPoints()
  region:SetPoint("TOPLEFT", host.parent, "TOPLEFT", x, -y)
end

-- Ligne d'objectif à la hauteur y ; -> hauteur prise.
local function placeObj(host, row, seg, x0, width, y)
  local r = seg.obj
  local O = Q.Objectives
  local body, dim = roleColor(host, "body"), roleColor(host, "dim")
  local ok = codeColor(host, CODE_OK)
  -- trait de l'objectif visé (couleur d'accent du thème : celle des titres)
  if r.lead then
    row.mark:SetVertexColor(1, 1, 1, 1)
    local accent = roleColor(host, "title")
    row.mark:SetColorTexture(accent[1], accent[2], accent[3], 1)
    row.mark:ClearAllPoints()
    row.mark:SetPoint("TOPLEFT", host.parent, "TOPLEFT", x0 - MARK_X, -(y + 1))
    row.mark:SetHeight(OBJ_H - 2)
    row.mark:Show()
  else
    row.mark:Hide()
  end
  -- icône ou numéro d'ordre (mode zone)
  if seg.num then
    row.icon:Hide()
    local c = r.lead and roleColor(host, "title") or dim
    row.numBg:SetVertexColor(c[1], c[2], c[3], 1)
    at(row.numBg, host, x0, y + 1)
    row.numBg:Show()
    row.num:SetText(tostring(seg.num))
    at(row.num, host, x0 - 2, y + 2)
    -- chiffre blanc sur fond foncé, noir sur fond clair
    local lum = 0.299 * c[1] + 0.587 * c[2] + 0.114 * c[3]
    tint(row.num, lum > 0.6 and { 0, 0, 0 } or { 1, 1, 1 })
    row.num:Show()
  else
    row.numBg:Hide()
    row.num:Hide()
    row.icon:SetTexture(r.icon)
    row.icon:SetVertexColor(1, 1, 1, r.done and 0.9 or 1)
    at(row.icon, host, x0, y + 1)
    row.icon:Show()
  end
  -- compteur
  local count = O and O:CountText(r) or nil
  local countW = 0
  if count then
    row.count:SetText(count)
    tint(row.count, r.done and ok or body)
    row.count:ClearAllPoints()
    row.count:SetPoint("TOPRIGHT", host.parent, "TOPLEFT", x0 + width, -(y + 2))
    row.count:Show()
    countW = COUNT_W
  else
    row.count:Hide()
  end
  -- libellé (et distance, en gris)
  local text = r.label or ""
  if seg.dist then text = text .. "  " .. LEVEL_COLOR .. seg.dist .. "|r" end
  row.label:SetText(paint(host, text))
  tint(row.label, r.done and dim or body)
  row.label:SetWidth(math.max(20, width - ICON - ICON_GAP - countW))
  at(row.label, host, x0 + ICON + ICON_GAP, y + 1)
  row.label:Show()
  local h = OBJ_H
  -- barre d'avancement
  if seg.bars then
    local bar = host.theme and host.theme.bar
    local w = math.max(1, width - ICON - ICON_GAP)
    local bg = bar and bar.bg or { 0, 0, 0, 0.4 }
    row.barBg:SetColorTexture(bg[1], bg[2], bg[3], bg[4] or 0.5)
    row.barBg:SetWidth(w)
    at(row.barBg, host, x0 + ICON + ICON_GAP, y + OBJ_H + 1)
    row.barBg:Show()
    local frac = O and O:Fraction(r) or 0
    if frac > 0 then
      local fill = r.done and ok or (bar and bar.fill) or body
      row.bar:SetColorTexture(fill[1], fill[2], fill[3], 1)
      row.bar:SetWidth(math.max(1, w * frac))
      at(row.bar, host, x0 + ICON + ICON_GAP, y + OBJ_H + 1)
      row.bar:Show()
    else
      row.bar:Hide()
    end
    h = h + BAR_H + BAR_GAP
  else
    row.barBg:Hide()
    row.bar:Hide()
  end
  row.data, row.dist = r, seg.dist
  return h
end

-- Pose les segments dans host.parent, colonne de texte de x0 à x0 + width, à partir de y0.
-- -> hauteur totale, emplacements des monstres { { mob, x, y, w, h } } (coordonnées dans parent).
function Rows:Render(host, segs, x0, width, y0)
  local n = { text = 0, mob = 0, obj = 0, quest = 0, group = 0, pill = 0, fold = 0 }
  local slots = {}
  local y = y0 or 0
  for _, seg in ipairs(segs or {}) do
    if seg.text then
      n.text = n.text + 1
      local chunk = textChunk(host, n.text)
      chunk:SetWidth(width)
      at(chunk, host, x0, y)
      chunk:SetText(paint(host, seg.text))
      chunk:Show()
      y = y + (chunk:GetStringHeight() or 14)
    elseif seg.obj then
      n.obj = n.obj + 1
      y = y + placeObj(host, objRow(host, n.obj), seg, x0, width, y)
    elseif seg.mob then
      n.mob = n.mob + 1
      local mob, row = seg.mob, mobRow(host, n.mob)
      local x = x0 + MOB_INDENT
      at(row.skull, host, x, y + 2)
      row.skull:SetDesaturated(mob.done and true or false)
      row.skull:SetAlpha(mob.done and 0.5 or 1)
      row.skull:Show()
      row.name:SetWidth(width - MOB_INDENT - 16 - MOB_LEVEL_W)
      at(row.name, host, x + 16, y + 2)
      row.name:SetText(paint(host, (mob.done and MOB_DONE_COLOR or MOB_COLOR) .. tostring(mob.name) .. "|r"))
      row.name:Show()
      local P = Q.UI.MobPanel
      local lvl = P and P.LevelText and P:LevelText(mob) or ""
      row.level:ClearAllPoints()
      row.level:SetPoint("TOPRIGHT", host.parent, "TOPLEFT", x0 + width, -(y + 2))
      row.level:SetText(lvl ~= "" and paint(host, LEVEL_COLOR .. lvl .. "|r") or "")
      row.level:Show()
      row.mob = mob
      slots[#slots + 1] = { mob = mob, x = x - 2, y = y, w = width - MOB_INDENT + 2, h = MOB_ROW_H }
      y = y + MOB_ROW_H
    elseif seg.quest then
      n.quest = n.quest + 1
      local fs = questHead(host, n.quest)
      local q = codeColor(host, CODE_QUEST)
      local text = "|c" .. hex(q) .. tostring(seg.quest) .. "|r"
      if seg.sub then text = text .. "|c" .. hex(roleColor(host, "dim")) .. " " .. seg.sub .. "|r" end
      fs:SetText(text)
      fs:SetWidth(width)
      at(fs, host, x0, y + (n.quest > 1 and 3 or 0))
      fs:Show()
      y = y + QUEST_H + (n.quest > 1 and 3 or 0)
    elseif seg.group then
      n.group = n.group + 1
      local g = groupHead(host, n.group)
      g.text:SetText(upper(seg.group))
      at(g.text, host, x0, y + 4)
      g.text:Show()
      local dim = roleColor(host, "dim")
      g.line:SetColorTexture(dim[1], dim[2], dim[3], 0.45)
      g.line:ClearAllPoints()
      g.line:SetPoint("LEFT", g.text, "RIGHT", 6, 0)
      g.line:SetPoint("RIGHT", host.parent, "TOPLEFT", x0 + width, -(y + 10))
      g.line:Show()
      y = y + GROUP_H + 4
    elseif seg.pill then
      n.pill = n.pill + 1
      local f = pill(host, n.pill)
      local c = codeColor(host, CODE_OK)
      paintCapsule(f.edge, c, 0.55)
      paintCapsule(f.fill, c, 0.18)
      f.text:SetText(tostring(seg.pill))
      tint(f.text, c)
      f.sub:SetText(seg.sub or "")
      local w = (f.text:GetStringWidth() or 60) + (f.sub:GetStringWidth() or 0) + 22
      f:SetWidth(math.min(width, math.max(PILL_H * 2, w)))
      f:ClearAllPoints()
      f:SetPoint("TOPLEFT", host.parent, "TOPLEFT", x0, -y)
      f:Show()
      y = y + PILL_H + 4
    elseif seg.fold then
      n.fold = n.fold + 1
      local fl = foldLine(host, n.fold)
      at(fl.icon, host, x0 + 1, y + 1)
      fl.icon:Show()
      fl.text:SetText(seg.fold)
      tint(fl.text, roleColor(host, "dim"))
      fl.text:SetWidth(width - 16)
      at(fl.text, host, x0 + 16, y + 1)
      fl.text:Show()
      y = y + FOLD_H
    end
  end
  hideAll(pool(host, "textChunks"), n.text + 1)
  hideAll(pool(host, "mobRows"), n.mob + 1)
  hideAll(pool(host, "objRows"), n.obj + 1)
  hideAll(pool(host, "questHeads"), n.quest + 1)
  hideAll(pool(host, "groupHeads"), n.group + 1)
  hideAll(pool(host, "pills"), n.pill + 1)
  hideAll(pool(host, "foldLines"), n.fold + 1)
  return y - (y0 or 0), slots
end

-- Restyle de toutes les lignes existantes (changement de thème).
function Rows:Restyle(host)
  for _, chunk in ipairs(pool(host, "textChunks")) do style(host, chunk, "body") end
  for _, row in ipairs(pool(host, "mobRows")) do
    style(host, row.name, "body")
    style(host, row.level, "dim")
  end
  for _, row in ipairs(pool(host, "objRows")) do
    style(host, row.label, "body")
    style(host, row.count, "body")
    style(host, row.num, "body")
  end
  for _, fs in ipairs(pool(host, "questHeads")) do style(host, fs, "body") end
  for _, g in ipairs(pool(host, "groupHeads")) do style(host, g.text, "dim") end
  for _, f in ipairs(pool(host, "pills")) do
    style(host, f.text, "body")
    style(host, f.sub, "dim")
  end
  for _, fl in ipairs(pool(host, "foldLines")) do style(host, fl.text, "dim") end
end

-- Texte visible, sans couleurs, dans l'ordre (tests, infobulles) : un objectif donne son texte
-- du journal (« Loup tué : 3/8 »), suivi de sa distance quand elle est affichée.
function Rows:VisibleText(host)
  local items = {}
  local function add(region, text)
    if region and region:IsShown() then
      local _, _, _, _, y = region:GetPoint(1)
      items[#items + 1] = { y = -(tonumber(y) or 0), text = Q.Util.StripColors(text or region:GetText() or "") }
    end
  end
  for _, c in ipairs(pool(host, "textChunks")) do add(c) end
  for _, r in ipairs(pool(host, "objRows")) do
    if r.label:IsShown() and r.data then
      add(r.label, (r.data.text or r.data.label or "") .. (r.dist and ("  " .. r.dist) or ""))
    end
  end
  for _, r in ipairs(pool(host, "mobRows")) do add(r.name) end
  for _, fs in ipairs(pool(host, "questHeads")) do add(fs) end
  for _, g in ipairs(pool(host, "groupHeads")) do add(g.text) end
  for _, f in ipairs(pool(host, "pills")) do
    if f:IsShown() then
      local _, _, _, _, y = f:GetPoint(1)
      items[#items + 1] = { y = -(tonumber(y) or 0),
        text = Q.Util.StripColors((f.text:GetText() or "") .. " " .. (f.sub:GetText() or "")) }
    end
  end
  for _, fl in ipairs(pool(host, "foldLines")) do add(fl.text) end
  for i, it in ipairs(items) do it.i = i end
  table.sort(items, function(a, b)
    if a.y ~= b.y then return a.y < b.y end
    return a.i < b.i
  end)
  local out = {}
  for _, it in ipairs(items) do out[#out + 1] = it.text end
  return table.concat(out, "\n")
end
