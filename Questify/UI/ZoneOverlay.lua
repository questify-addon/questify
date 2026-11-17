local addonName, Q = ...

-- Zone du mode zone (Engine/ZoneMode.lua) dessinée sur la carte du monde et sur la minicarte :
--   enveloppe des points d'apparition de la zone (polygone convexe qui épouse les points, chacun
--   élargi de PAD yards), voile léger et bord fin de la couleur de la zone ;
--   un point par endroit d'apparition retenu, coloré selon le groupe du suivi (objets, élites et
--   nommés, monstres) ; le premier point de chaque objectif est plus gros et porte son numéro
--   d'ordre (ordre de Q.ZoneMode:Objectives, celui du suivi et de la flèche). Carte du monde
--   seulement : survol d'un point = nom, quête et avancement.
-- Minicarte : même enveloppe à l'échelle, projetée autour du joueur (rotation de la minicarte
-- comprise), découpée par un masque rond (ou par le cadre si la minicarte est carrée). Une veille
-- à 10 Hz compare position, orientation, zoom et taille : un pas déplace seulement l'ancre, un
-- changement de zoom, de taille ou d'orientation refait la forme.
-- Dessin : textures blanches pliées par Texture:SetVertexOffset (éventail de triangles pour le voile,
-- un quadrilatère par côté pour le bord). Client sans SetVertexOffset : un disque du rayon de la
-- zone à son centre, même voile.
-- Couleurs : codes de couleur Questify lus par Q.Themes:CodeColor (aucune teinte propre).
-- Coordonnées : celles de Q.Maps (monde : X vers le nord, Y vers l'ouest ; carte : 0-100).
-- Option zoneOverlay (absente = active). Mode zone coupé, pas de zone, API absente : rien, sans
-- erreur. Rien ici n'est protégé : le dessin suit aussi en combat.
-- Technique de l'enveloppe et de la projection sur la minicarte inspirée de Polestar
-- (github.com/fitzforge/polestar, GPL-3.0).
Q.UI = Q.UI or {}
local ZoneOverlay = {}
Q.UI.ZoneOverlay = ZoneOverlay

local WHITE = "Interface\\Buttons\\WHITE8X8"
local DISC = "Interface\\CharacterFrame\\TempPortraitAlphaMask"   -- disque blanc
local NUMBER_FONT = "NumberFontNormalSmall"

local PAD = 25                 -- yards autour de chaque point d'apparition
local SMALL_SPAN = 200         -- yards : en dessous, disques à 8 côtés au lieu de 16
local FILL_ALPHA, RIM_ALPHA = 0.20, 0.70
local RIM_WIDTH = 1.5          -- pixels à l'écran
local DOT, DOT_FIRST = 7, 14   -- pixels : point d'apparition, premier point d'un objectif (numéro)
local DOT_MINI = 5             -- pixels : point sur la minicarte
local DOT_EDGE = 1.5           -- pixels : liseré sombre autour d'un point
local WATCH = 0.1              -- secondes entre deux relevés (minicarte, carte du monde)
local REFRESH_DELAY = 0.2

-- Codes de couleur (remappés par le thème) : zone, groupes du suivi, textes de l'infobulle.
local CODES = {
  zone = "ff40e050",
  object = "ff66bbff",
  named = "ffffb040",
  mob = "ffff6060",
  item = "ffff6060",       -- monstre qui laisse un objet : groupe « Monstres » du suivi
  edge = "ff000000",
  number = "ffffffff",
  name = "ffffffff",
  quest = "ffffd100",
  note = "ffaaaaaa",
}

-- Diamètre de la minicarte en yards selon le zoom (sans C_Minimap.GetViewRadius).
local MINIMAP_SIZE = {
  outdoor = { [0] = 466 + 2 / 3, 400, 333 + 1 / 3, 266 + 2 / 3, 200, 133 + 1 / 3 },
  indoor = { [0] = 300, 240, 180, 120, 80, 50 },
}

-- Compteurs pour les tests : morceaux dessinés par surface.
ZoneOverlay.active = {
  world = { fill = 0, rim = 0, dots = 0, disc = 0 },
  mini = { fill = 0, rim = 0, dots = 0, disc = 0 },
}

---------------------------------------------------------------------------
-- Outils
---------------------------------------------------------------------------
local function enabled()
  return Q.Settings:Get("zoneOverlay") ~= false
end

local function color(key)
  local T = Q.Themes
  local c = T and T.CodeColor and T:CodeColor(CODES[key] or CODES.mob)
  return c or { 1, 1, 1 }
end

local function call(obj, method, ...)
  local fn = obj and obj[method]
  if fn == nil then return nil end
  local ok, a, b, c = pcall(fn, obj, ...)
  if ok then return a, b, c end
  return nil
end

local function num(v, default)
  v = tonumber(v)
  if not v or v ~= v then return default end
  return v
end

-- Vrai si la texture sait se plier (Texture:SetVertexOffset) ; remplaçable par les tests.
function ZoneOverlay.CanBend(tex)
  return tex ~= nil and tex.SetVertexOffset ~= nil
end

---------------------------------------------------------------------------
-- Géométrie
---------------------------------------------------------------------------
local function cross(o, a, b)
  return (a[1] - o[1]) * (b[2] - o[2]) - (a[2] - o[2]) * (b[1] - o[1])
end

-- Q.UI.ZoneOverlay.Hull(points, pad, sides) -> { { x, y } } : enveloppe convexe (chaîne monotone,
-- sens trigonométrique) des points { x, y }, chacun remplacé par un polygone régulier de `sides`
-- côtés (16 par défaut) de rayon `pad`. Moins de trois sommets distincts : liste vide.
function ZoneOverlay.Hull(points, pad, sides)
  pad = num(pad, 0)
  sides = math.max(3, math.floor(num(sides, 16)))
  local all = {}
  for _, p in ipairs(points or {}) do
    local x, y = num(p[1]), num(p[2])
    if x and y then
      if pad > 0 then
        for i = 0, sides - 1 do
          local a = i * 2 * math.pi / sides
          all[#all + 1] = { x + pad * math.cos(a), y + pad * math.sin(a) }
        end
      else
        all[#all + 1] = { x, y }
      end
    end
  end
  if #all < 3 then return {} end
  table.sort(all, function(a, b)
    if a[1] ~= b[1] then return a[1] < b[1] end
    return a[2] < b[2]
  end)
  local lower, upper = {}, {}
  for _, p in ipairs(all) do
    while #lower >= 2 and cross(lower[#lower - 1], lower[#lower], p) <= 0 do lower[#lower] = nil end
    lower[#lower + 1] = p
  end
  for i = #all, 1, -1 do
    local p = all[i]
    while #upper >= 2 and cross(upper[#upper - 1], upper[#upper], p) <= 0 do upper[#upper] = nil end
    upper[#upper + 1] = p
  end
  lower[#lower] = nil
  upper[#upper] = nil
  for _, p in ipairs(upper) do lower[#lower + 1] = p end
  if #lower < 3 then return {} end
  return lower
end

-- Q.UI.ZoneOverlay.Project(dNorth, dWest, facing, radius, half, rotate) -> x (vers la droite),
-- y (vers le haut) en pixels depuis le centre de la minicarte : écart en yards vers le nord et
-- vers l'ouest, orientation du joueur (radians), rayon de vue (yards), demi-largeur (pixels),
-- minicarte tournante.
function ZoneOverlay.Project(dNorth, dWest, facing, radius, half, rotate)
  local scale = half / radius
  local x, y = -dWest * scale, dNorth * scale
  if rotate and facing then
    local c, s = math.cos(facing), math.sin(facing)
    x, y = x * c + y * s, -x * s + y * c
  end
  return x, y
end

-- Zone à dessiner : celle du mode zone, ou nil.
local function currentZone()
  local Z = Q.ZoneMode
  if not (Z and Z.Current) then return nil end
  local ok, z = pcall(Z.Current, Z)
  if ok and type(z) == "table" and type(z.objectives) == "table" then return z end
  return nil
end

-- Géométrie de la zone (monde, yards) : enveloppe { { n, w } } (nord, ouest), centre de gravité,
-- points numérotés { n, w, kind, o, order, first }. nil sans point.
local function geometry(z)
  local Z = Q.ZoneMode
  local ordered = Z.Objectives and Z:Objectives(z) or z.objectives
  local plane, dots = {}, {}
  local minE, maxE, minN, maxN
  for order, o in ipairs(ordered) do
    local first = o.nearest or (o.points and o.points[1])
    for _, p in ipairs(o.points or {}) do
      local n, w = num(p.wx), num(p.wy)
      if n and w then
        local e = -w
        plane[#plane + 1] = { e, n }
        minE, maxE = math.min(minE or e, e), math.max(maxE or e, e)
        minN, maxN = math.min(minN or n, n), math.max(maxN or n, n)
        dots[#dots + 1] = { n = n, w = w, kind = o.kind, o = o, order = order, first = p == first }
      end
    end
  end
  if #plane == 0 then return nil end
  local span = math.max(maxE - minE, maxN - minN)
  local hull = ZoneOverlay.Hull(plane, PAD, span < SMALL_SPAN and 8 or 16)
  if #hull < 3 then return nil end
  local verts, ce, cn = {}, 0, 0
  for i, v in ipairs(hull) do
    verts[i] = { n = v[2], w = -v[1] }
    ce, cn = ce + v[1], cn + v[2]
  end
  -- premiers points au-dessus des autres
  table.sort(dots, function(a, b)
    if a.first ~= b.first then return not a.first end
    return a.order > b.order
  end)
  return {
    hull = verts,
    center = { n = cn / #hull, w = -ce / #hull },
    dots = dots,
    continent = z.continent,
    zone = z,
  }
end

---------------------------------------------------------------------------
-- Morceaux pliés
---------------------------------------------------------------------------
-- Réserve de textures d'une surface : t.tex[kind][i], cachées au début de chaque dessin.
local function newSurface(frame)
  return { frame = frame, tex = { fill = {}, rim = {}, disc = {} }, used = { fill = 0, rim = 0, disc = 0 },
    dots = {}, nDots = 0 }
end

local function piece(s, kind, mask)
  s.used[kind] = s.used[kind] + 1
  local i = s.used[kind]
  local t = s.tex[kind][i]
  if not t then
    t = s.frame:CreateTexture(nil, kind == "rim" and "ARTWORK" or "BORDER")
    if kind == "disc" then t:SetTexture(DISC) else t:SetTexture(WHITE) end
    call(t, "SetSnapToPixelGrid", false)
    call(t, "SetTexelSnappingBias", 0)
    if mask then call(t, "AddMaskTexture", mask) end
    s.tex[kind][i] = t
  end
  t:Show()
  return t
end

-- Vrai si les textures de cette surface savent se plier (texture témoin, jamais affichée).
local function canBend(s)
  if not s.probe then
    s.probe = s.frame:CreateTexture(nil, "BACKGROUND")
    s.probe:Hide()
  end
  return ZoneOverlay.CanBend(s.probe)
end

local function hideRest(s)
  for kind, list in pairs(s.tex) do
    for i = s.used[kind] + 1, #list do list[i]:Hide() end
  end
  for i = s.nDots + 1, #s.dots do s.dots[i]:Hide() end
end

-- Quadrilatère A, B (haut), C, D (bas) en coordonnées du jeu (x vers la droite, y vers le haut),
-- depuis le coin haut gauche de `rel` : texture 1 x 1 ancrée en A, coins déplacés
-- (1 haut gauche, 2 bas gauche, 3 haut droit, 4 bas droit).
local function quad(t, rel, a, b, c, d)
  t:ClearAllPoints()
  t:SetPoint("TOPLEFT", rel, "TOPLEFT", a[1], a[2])
  t:SetSize(1, 1)
  t:SetVertexOffset(1, 0, 0)
  t:SetVertexOffset(2, c[1] - a[1], c[2] - a[2] + 1)
  t:SetVertexOffset(3, b[1] - a[1] - 1, b[2] - a[2])
  t:SetVertexOffset(4, d[1] - a[1] - 1, d[2] - a[2] + 1)
  t.qzCorners = { a, b, c, d }
end

-- Voile et bord d'un polygone (sommets en coordonnées du jeu depuis le coin haut gauche de rel).
local function drawPolygon(s, rel, pts, rimWidth, mask)
  local c = color("zone")
  local gx, gy = 0, 0
  for _, p in ipairs(pts) do gx, gy = gx + p[1], gy + p[2] end
  local g = { gx / #pts, gy / #pts }
  local half = rimWidth / 2
  for i, p in ipairs(pts) do
    local q = pts[i % #pts + 1]
    local t = piece(s, "fill", mask)
    t:SetVertexColor(c[1], c[2], c[3], FILL_ALPHA)
    quad(t, rel, g, p, q, q)
    local dx, dy = q[1] - p[1], q[2] - p[2]
    local len = math.sqrt(dx * dx + dy * dy)
    if len > 0 then
      local nx, ny = -dy / len * half, dx / len * half
      local r = piece(s, "rim", mask)
      r:SetVertexColor(c[1], c[2], c[3], RIM_ALPHA)
      quad(r, rel, { p[1] + nx, p[2] + ny }, { q[1] + nx, q[2] + ny }, { p[1] - nx, p[2] - ny }, { q[1] - nx, q[2] - ny })
    end
  end
end

-- Disque de secours (sans SetVertexOffset) : centre et rayon en coordonnées du jeu.
local function drawDisc(s, rel, cx, cy, r, mask)
  local c = color("zone")
  local t = piece(s, "disc", mask)
  t:SetVertexColor(c[1], c[2], c[3], FILL_ALPHA)
  t:ClearAllPoints()
  t:SetPoint("CENTER", rel, "TOPLEFT", cx, cy)
  t:SetSize(2 * r, 2 * r)
end

local function surfaceCount(s, where)
  local a = ZoneOverlay.active[where]
  a.fill, a.rim, a.disc, a.dots = s.used.fill, s.used.rim, s.used.disc, s.nDots
end

---------------------------------------------------------------------------
-- Points d'apparition
---------------------------------------------------------------------------
local function tooltip(self)
  local d = self.qzDot
  if not (d and GameTooltip) then return end
  local o = d.o
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
  local c = color("name")
  GameTooltip:AddLine(tostring(o.name or "?"), c[1], c[2], c[3])
  c = color("quest")
  GameTooltip:AddLine(Q.QDB:QuestName(o.questId), c[1], c[2], c[3])
  local ok, text = pcall(Q.ZoneMode.ProgressText, Q.ZoneMode, o)
  if ok and type(text) == "string" and text ~= "" then
    c = color("note")
    GameTooltip:AddLine(text, c[1], c[2], c[3])
  end
  GameTooltip:Show()
end

local function hideTooltip()
  if GameTooltip then GameTooltip:Hide() end
end

-- Point d'apparition : liseré sombre, disque coloré, numéro (premier point d'un objectif).
local function dotFrame(s, interactive, mask)
  s.nDots = s.nDots + 1
  local f = s.dots[s.nDots]
  if not f then
    f = CreateFrame(interactive and "Button" or "Frame", nil, s.frame)
    f.edge = f:CreateTexture(nil, "ARTWORK", nil, 1)
    f.edge:SetTexture(DISC)
    f.edge:SetAllPoints(f)
    f.fill = f:CreateTexture(nil, "ARTWORK", nil, 2)
    f.fill:SetTexture(DISC)
    f.fill:SetPoint("TOPLEFT", f, "TOPLEFT", DOT_EDGE, -DOT_EDGE)
    f.fill:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -DOT_EDGE, DOT_EDGE)
    if mask then
      call(f.edge, "AddMaskTexture", mask)
      call(f.fill, "AddMaskTexture", mask)
    end
    if interactive then
      f.num = f:CreateFontString(nil, "OVERLAY", NUMBER_FONT)
      f.num:SetPoint("CENTER", f, "CENTER", 0, 0)
      f:SetScript("OnEnter", tooltip)
      f:SetScript("OnLeave", hideTooltip)
      call(f, "EnableMouse", true)
    end
    s.dots[s.nDots] = f
  end
  f:Show()
  return f
end

local function paintDot(f, d, size)
  local e, c = color("edge"), color(d.kind)
  f.edge:SetVertexColor(e[1], e[2], e[3], 0.9)
  f.fill:SetVertexColor(c[1], c[2], c[3], 1)
  f:SetSize(size, size)
  f.qzDot = d
  if f.num then
    local w = color("number")
    f.num:SetTextColor(w[1], w[2], w[3], 1)
    f.num:SetText(d.first and tostring(d.order) or "")
  end
end

---------------------------------------------------------------------------
-- Carte du monde
---------------------------------------------------------------------------
local world = { mapId = nil, w = 0, h = 0, scale = 1, elapsed = 0 }
local geo   -- géométrie de la zone courante (nil : rien à dessiner)

local function worldCanvas()
  local map = WorldMapFrame
  if not map then return nil end
  local canvas = call(map, "GetCanvas")
  if type(canvas) ~= "table" then return nil end
  return map, canvas
end

-- Repère affine de la carte m (X, Y monde) : origine et variations pour x et y de 0 à 1.
local mapFrames = {}
local function mapFrame(m)
  local f = mapFrames[m]
  if f ~= nil then return f or nil end
  local c0, ox, oy = Q.Maps:WorldPos(m, 0, 0)
  local c1, ax, ay = Q.Maps:WorldPos(m, 100, 0)
  local c2, bx, by = Q.Maps:WorldPos(m, 0, 100)
  if c0 == nil or c0 ~= c1 or c0 ~= c2 then return nil end
  local xX, xY, yX, yY = ax - ox, ay - oy, bx - ox, by - oy
  local det = xX * yY - xY * yX
  if det == 0 then
    mapFrames[m] = false
    return nil
  end
  f = { continent = c0, ox = ox, oy = oy, xX = xX, xY = xY, yX = yX, yY = yY, det = det }
  mapFrames[m] = f
  return f
end

-- Point monde (nord, ouest) -> coordonnées 0-1 de la carte décrite par f.
local function toMap(f, n, w)
  local dx, dy = n - f.ox, w - f.oy
  return (dx * f.yY - dy * f.yX) / f.det, (f.xX * dy - f.xY * dx) / f.det
end

function ZoneOverlay:WorldSurface()
  if self.world then return self.world end
  local _, canvas = worldCanvas()
  if not canvas then return nil end
  local frame = CreateFrame("Frame", nil, canvas)
  frame:SetAllPoints(canvas)
  call(frame, "SetFrameLevel", (num(call(canvas, "GetFrameLevel"), 1)) + 1)
  frame:SetScript("OnUpdate", function(_, elapsed)
    world.elapsed = world.elapsed + num(elapsed, 0)
    if world.elapsed < WATCH then return end
    world.elapsed = 0
    local map, cv = worldCanvas()
    if not map then return end
    local m = call(map, "GetMapID")
    local w, h = num(call(cv, "GetWidth"), 0), num(call(cv, "GetHeight"), 0)
    local sc = num(call(map, "GetCanvasScale"), 1)
    if m ~= world.mapId or w ~= world.w or h ~= world.h or sc ~= world.scale then
      Q.SafeCall(ZoneOverlay.DrawWorld, ZoneOverlay)
    end
  end)
  self.world = newSurface(frame)
  return self.world
end

-- Dessine la zone sur la carte affichée (rien si elle n'y est pas).
function ZoneOverlay:DrawWorld()
  local s = self:WorldSurface()
  if not s then return end
  s.used.fill, s.used.rim, s.used.disc, s.nDots = 0, 0, 0, 0
  local map, canvas = worldCanvas()
  local m = map and call(map, "GetMapID")
  local W, H = num(call(canvas, "GetWidth"), 0), num(call(canvas, "GetHeight"), 0)
  local sc = num(call(map, "GetCanvasScale"), 1)
  if sc <= 0 then sc = 1 end
  world.mapId, world.w, world.h, world.scale = m, W, H, sc
  local f = geo and type(m) == "number" and W > 0 and H > 0 and mapFrame(m)
  if f and f.continent == geo.continent then
    local cu, cv = toMap(f, geo.center.n, geo.center.w)
    if cu >= 0 and cu <= 1 and cv >= 0 and cv <= 1 then
      local rel = s.frame
      if canBend(s) then
        local pts = {}
        for i, v in ipairs(geo.hull) do
          local u, vv = toMap(f, v.n, v.w)
          pts[i] = { u * W, -vv * H }
        end
        drawPolygon(s, rel, pts, RIM_WIDTH / sc)
      else
        local z = geo.zone
        local u, vv = toMap(f, geo.center.n + num(z.radius, 60), geo.center.w)
        local r = math.sqrt(((u - cu) * W) ^ 2 + ((vv - cv) * H) ^ 2)
        drawDisc(s, rel, cu * W, -cv * H, r)
      end
      for _, d in ipairs(geo.dots) do
        local u, vv = toMap(f, d.n, d.w)
        local dot = dotFrame(s, true)
        paintDot(dot, d, d.first and DOT_FIRST or DOT)
        dot:SetScale(1 / sc)
        dot:ClearAllPoints()
        dot:SetPoint("CENTER", rel, "TOPLEFT", u * W * sc, -vv * H * sc)
      end
    end
  end
  hideRest(s)
  surfaceCount(s, "world")
end

---------------------------------------------------------------------------
-- Minicarte
---------------------------------------------------------------------------
local mini = { elapsed = 0 }

local function square()
  return type(GetMinimapShape) == "function" and GetMinimapShape() == "SQUARE"
end

function ZoneOverlay:MiniSurface()
  if self.mini then return self.mini end
  if not Minimap then return nil end
  local frame = CreateFrame("Frame", nil, Minimap)
  frame:SetAllPoints(Minimap)
  call(frame, "SetFrameLevel", (num(call(Minimap, "GetFrameLevel"), 1)) + 3)
  local s = newSurface(frame)
  if square() then
    call(frame, "SetClipsChildren", true)
  else
    local mask = call(frame, "CreateMaskTexture")
    if mask then
      call(mask, "SetTexture", DISC, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
      call(mask, "SetAllPoints", Minimap)
      s.mask = mask
    end
  end
  -- ancre : centre de gravité de l'enveloppe ; un pas du joueur la déplace seulement
  s.anchor = CreateFrame("Frame", nil, frame)
  s.anchor:SetSize(1, 1)
  frame:SetScript("OnUpdate", function(_, elapsed)
    mini.elapsed = mini.elapsed + num(elapsed, 0)
    if mini.elapsed < WATCH then return end
    mini.elapsed = 0
    Q.SafeCall(ZoneOverlay.WatchMini, ZoneOverlay)
  end)
  self.mini = s
  return s
end

-- Rayon de vue de la minicarte en yards.
local function viewRadius()
  local fn = C_Minimap and C_Minimap.GetViewRadius
  if type(fn) == "function" then
    local ok, r = pcall(fn)
    r = ok and num(r) or nil
    if r and r > 0 then return r end
  end
  local zoom = num(call(Minimap, "GetZoom"), 0)
  local indoor = num(GetCVar and GetCVar("minimapZoom"), zoom) ~= zoom
  local list = MINIMAP_SIZE[indoor and "indoor" or "outdoor"]
  return (list[zoom] or list[0]) / 2
end

-- Relevé : -> état { n, w, continent, facing, rotate, radius, half } ou nil (position inconnue).
local function miniState()
  local pm, px, py = Q.Maps:PlayerPos()
  if not pm then return nil end
  local c, n, w = Q.Maps:WorldPos(pm, px, py)
  if c == nil then return nil end
  local rotate = GetCVar and GetCVar("rotateMinimap") == "1" or false
  local facing = rotate and type(GetPlayerFacing) == "function" and num(GetPlayerFacing()) or nil
  return { n = n, w = w, continent = c, facing = facing, rotate = rotate, radius = viewRadius(),
    half = num(call(Minimap, "GetWidth"), 0) / 2 }
end

local function shapeKey(st)
  return table.concat({ tostring(st.rotate), string.format("%.3f", st.facing or 0), string.format("%.2f", st.radius),
    string.format("%.1f", st.half) }, "|")
end

-- Dessine la forme (relative à l'ancre) pour ce zoom, cette taille et cette orientation.
function ZoneOverlay:BuildMini(st)
  local s = self.mini
  s.used.fill, s.used.rim, s.used.disc, s.nDots = 0, 0, 0, 0
  local function proj(n, w)
    return ZoneOverlay.Project(n - geo.center.n, w - geo.center.w, st.facing, st.radius, st.half, st.rotate)
  end
  -- ancre en (0, 0) : les sommets sont exprimés depuis son coin haut gauche (taille 1 x 1)
  if canBend(s) then
    local pts = {}
    for i, v in ipairs(geo.hull) do
      local x, y = proj(v.n, v.w)
      pts[i] = { x, y }
    end
    drawPolygon(s, s.anchor, pts, RIM_WIDTH, s.mask)
  else
    drawDisc(s, s.anchor, 0, 0, num(geo.zone.radius, 60) * st.half / st.radius, s.mask)
  end
  for _, d in ipairs(geo.dots) do
    local x, y = proj(d.n, d.w)
    local dot = dotFrame(s, false, s.mask)
    paintDot(dot, d, d.first and DOT_MINI + 2 or DOT_MINI)
    dot:ClearAllPoints()
    dot:SetPoint("CENTER", s.anchor, "TOPLEFT", x, y)
  end
  hideRest(s)
  surfaceCount(s, "mini")
  s.shape = shapeKey(st)
end

-- Place l'ancre (centre de gravité projeté autour du joueur).
function ZoneOverlay:PlaceMiniAnchor(st)
  local s = self.mini
  local x, y = ZoneOverlay.Project(geo.center.n - st.n, geo.center.w - st.w, st.facing, st.radius, st.half, st.rotate)
  s.anchor:ClearAllPoints()
  s.anchor:SetPoint("TOPLEFT", Minimap, "CENTER", x, y)
  ZoneOverlay.active.mini.anchor = { x, y }
  s.pos = string.format("%.1f|%.1f", st.n, st.w)
end

local function hideMini(s)
  s.used.fill, s.used.rim, s.used.disc, s.nDots = 0, 0, 0, 0
  hideRest(s)
  surfaceCount(s, "mini")
  s.shape, s.pos = nil, nil
  ZoneOverlay.active.mini.anchor = nil
end

-- Veille de la minicarte : forme refaite au besoin, ancre déplacée quand le joueur bouge.
function ZoneOverlay:WatchMini(force)
  local s = self:MiniSurface()
  if not s then return end
  local st = geo and miniState()
  if not st or st.continent ~= geo.continent or st.half <= 0 or st.radius <= 0 then
    if s.shape or s.used.fill > 0 or s.used.disc > 0 or s.nDots > 0 then hideMini(s) end
    return
  end
  if force or s.shape ~= shapeKey(st) then self:BuildMini(st) end
  if force or s.pos ~= string.format("%.1f|%.1f", st.n, st.w) or not s.anchor:GetPoint(1) then
    self:PlaceMiniAnchor(st)
  end
end

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------
-- Vrai quand l'enveloppe de la zone est (ou va être) dessinée sur la carte du monde : UI/MapPins.lua
-- se passe alors du repère vert au centre. Lu sur la zone courante, pas sur le dernier dessin : les
-- deux modules se redessinent après le même message, dans un ordre quelconque.
function ZoneOverlay:DrawsWorld()
  if not enabled() then return false end
  local z = currentZone()
  if not z then return false end
  for _, o in ipairs(z.objectives) do
    if o.points and o.points[1] then return true end
  end
  return false
end

-- Recalcule la zone et redessine les deux surfaces.
function ZoneOverlay:Refresh()
  geo = nil
  if enabled() then
    local z = currentZone()
    if z then
      local ok, g = pcall(geometry, z)
      if ok then geo = g else Q:ReportError("ZoneOverlay: " .. tostring(g)) end
    end
  end
  Q.SafeCall(self.DrawWorld, self)
  Q.SafeCall(self.WatchMini, self, true)
end

local pending = false
local function schedule()
  if pending then return end
  pending = true
  Q:After(REFRESH_DELAY, function()
    pending = false
    ZoneOverlay:Refresh()
  end)
end
ZoneOverlay.Schedule = function() schedule() end

for _, msg in ipairs({ "LOGIN", "PROGRESS_UPDATED", "STEP_CHANGED", "GUIDE_CHANGED", "ZONEMODE_CHANGED" }) do
  Q:On(msg, schedule)
end

Q:On("SETTINGS_CHANGED", function(path)
  if path == "zoneOverlay" or path == "zoneMode" or path == "tracker.theme" or path == nil then schedule() end
end)
Q:On("THEME_CHANGED", schedule)
