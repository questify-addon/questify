-- Tests de l'enveloppe des zones sur la carte du monde et la minicarte (Q.UI.ZoneOverlay).
-- La zone est fabriquée à la main (Q.ZoneMode:Current remplacé) : trois objectifs à Dun Morogh
-- (uiMap 1426 du mock : 4925 x 3283 yards).
local TOC = "Questify/Questify.toc"
local FILE = "Questify/UI/ZoneOverlay.lua"

-- Tant que le TOC ne liste pas le fichier, il est chargé en plus après le TOC.
local function inToc()
  local f = io.open(Mock.root .. "/" .. TOC, "r")
  if not f then return false end
  local src = f:read("*a")
  f:close()
  return src:find("UI\\ZoneOverlay.lua", 1, true) ~= nil
end

local MAP = 1426

-- Zone : objet (2 points), nommé (1 point), monstres (4 points) autour de (50, 50).
local function makeZone(Q)
  local function pts(list)
    local out = {}
    for _, p in ipairs(list) do
      local c, wx, wy = Q.Maps:WorldPos(MAP, p[1], p[2])
      out[#out + 1] = { mapId = MAP, x = p[1], y = p[2], wx = wx, wy = wy, continent = c }
    end
    return out
  end
  local objectives = {
    { kind = "object", targetKind = "object", id = 1, name = "Felix's Chest", questId = 100, objIndex = 1,
      priority = 1, points = pts({ { 49, 48 }, { 49.5, 48.5 } }) },
    { kind = "named", targetKind = "npc", id = 2, name = "Grik'nir", questId = 101, objIndex = 1,
      priority = 2, points = pts({ { 52, 47 } }) },
    { kind = "mob", targetKind = "npc", id = 3, name = "Rockjaw Trogg", questId = 102, objIndex = 1,
      priority = 3, points = pts({ { 48, 51 }, { 50, 52 }, { 52, 51 }, { 51, 50 } }) },
  }
  local c = objectives[1].points[1].continent
  return { ownerKey = "k", center = { MAP, 50, 50, mapId = MAP, x = 50, y = 50 }, radius = 120, continent = c,
    objectives = objectives, entries = {}, entryKeys = {}, questCount = 3, inside = true, name = "Coldridge" }
end

local zone

local function load(opts)
  opts = opts or {}
  Mock.player.map, Mock.player.x, Mock.player.y = MAP, 50, 50
  local Q = Mock.loadAddon(TOC, {
    skipGuides = true,
    extraFiles = (not inToc()) and { FILE } or nil,
    beforeLogin = function(Q)
      if opts.settings then
        for k, v in pairs(opts.settings) do Q.Settings:Set(k, v) end
      end
      zone = nil
      Q.ZoneMode.Current = function() return zone end
      Q.ZoneMode.IsOwner = function() return zone ~= nil end
    end,
  })
  Minimap:SetSize(140, 140)
  local canvas = WorldMapFrame:GetCanvas()
  canvas:SetSize(1002, 668)
  if opts.zone ~= false then zone = makeZone(Q) end
  Mock.advance(0.3)   -- dessin demandé à la connexion
  Q.UI.ZoneOverlay:Refresh()
  return Q
end

local function showMap(id)
  WorldMapFrame:SetMapID(id)
  WorldMapFrame:Show()
  Mock.advance(0.2)
end

-- Aire signée d'un polygone { { x, y } } (positive : sens trigonométrique).
local function area(poly)
  local a = 0
  for i, p in ipairs(poly) do
    local q = poly[i % #poly + 1]
    a = a + p[1] * q[2] - q[1] * p[2]
  end
  return a / 2
end

local function inside(poly, x, y)
  for i, p in ipairs(poly) do
    local q = poly[i % #poly + 1]
    if (q[1] - p[1]) * (y - p[2]) - (q[2] - p[2]) * (x - p[1]) < -1e-6 then return false end
  end
  return true
end

return {
  hull_is_convex_and_contains_every_point = function(t)
    local Q = load({ zone = false })
    local H = Q.UI.ZoneOverlay.Hull
    local pts = { { 0, 0 }, { 100, 0 }, { 50, 80 }, { 50, 20 }, { 30, 10 }, { 70, 60 } }
    local hull = H(pts, 25, 16)
    t.ok(#hull >= 3, "hull has vertices")
    t.ok(area(hull) > 0, "counter-clockwise")
    for i = 1, #hull do
      local a, b, c = hull[i], hull[i % #hull + 1], hull[(i + 1) % #hull + 1]
      t.ok((b[1] - a[1]) * (c[2] - a[2]) - (b[2] - a[2]) * (c[1] - a[1]) > 0, "convex at " .. i)
    end
    for _, p in ipairs(pts) do t.ok(inside(hull, p[1], p[2]), "contains " .. p[1] .. "," .. p[2]) end
    -- marge : un point à 20 yards d'un point d'apparition reste dedans
    t.ok(inside(hull, -20, 0), "padding around points")
    t.eq(#H({ { 1, 1 } }, 0), 0, "single point without padding")
    t.ok(#H({ { 1, 1 } }, 10, 8) == 8, "single point becomes an octagon")
    t.eq(#Mock.errors, 0)
  end,

  projection_orientation = function(t)
    local Q = load({ zone = false })
    local P = Q.UI.ZoneOverlay.Project
    -- minicarte fixe : est à droite, nord en haut
    local x, y = P(0, -100, 0, 200, 70, false)
    t.ok(x > 0 and math.abs(y) < 1e-9, "east is right")
    x, y = P(100, 0, 0, 200, 70, false)
    t.ok(y > 0 and math.abs(x) < 1e-9, "north is up")
    t.near(y, 35, 1e-9, "scale = half / radius")
    -- minicarte tournante, joueur tourné vers l'ouest (pi/2) : l'ouest passe en haut
    x, y = P(0, 100, math.pi / 2, 200, 70, true)
    t.near(x, 0, 1e-9)
    t.ok(y > 0, "west is up when facing west")
    t.eq(#Mock.errors, 0)
  end,

  world_map_draws_hull_and_dots = function(t)
    local Q = load()
    showMap(MAP)
    local a = Q.UI.ZoneOverlay.active.world
    t.ok(a.fill >= 8, "fill pieces: " .. a.fill)
    t.eq(a.rim, a.fill, "one rim piece per edge")
    t.eq(a.dots, 7, "one dot per spawn point")
    t.eq(a.disc, 0)
    t.ok(Q.UI.ZoneOverlay:DrawsWorld(), "draws on the world map")
    -- les morceaux tombent autour du centre de la zone (50 % de la carte)
    local s = Q.UI.ZoneOverlay.world
    local tex = s.tex.fill[1]
    local A = tex.qzCorners[1]
    t.near(A[1], 501, 30, "fan centre x")
    t.near(A[2], -334, 30, "fan centre y")
    -- numéros : 1 objet, 2 nommé, 3 monstres (ordre de Q.ZoneMode:Objectives)
    local numbers = {}
    for i = 1, a.dots do
      local txt = s.dots[i].num:GetText()
      if txt ~= "" then numbers[#numbers + 1] = txt end
    end
    table.sort(numbers)
    t.eq(numbers, { "1", "2", "3" })
    t.eq(#Mock.errors, 0)
  end,

  world_map_skips_other_maps = function(t)
    local Q = load()
    showMap(1411)   -- Durotar, autre continent
    local a = Q.UI.ZoneOverlay.active.world
    t.eq(a.fill + a.rim + a.dots + a.disc, 0)
    showMap(1429)   -- Elwynn : même continent, zone hors de la carte
    t.eq(a.fill + a.rim + a.dots + a.disc, 0)
    -- carte de continent qui contient Dun Morogh (celle du mock ne la contient pas)
    Mock.maps[90001] = { name = "Test continent", continent = 0, left = 20000, top = 20000, width = 40000, height = 40000 }
    showMap(90001)
    t.ok(a.fill > 0 and a.dots == 7, "continent map shows the zone")
    t.eq(#Mock.errors, 0)
  end,

  nothing_without_zone_or_with_option_off = function(t)
    local Q = load({ zone = false })
    showMap(MAP)
    local w, m = Q.UI.ZoneOverlay.active.world, Q.UI.ZoneOverlay.active.mini
    t.eq(w.fill + w.dots + m.fill + m.dots, 0, "no zone")
    t.ok(not Q.UI.ZoneOverlay:DrawsWorld())
    Q = load({ settings = { zoneOverlay = false } })
    showMap(MAP)
    w, m = Q.UI.ZoneOverlay.active.world, Q.UI.ZoneOverlay.active.mini
    t.eq(w.fill + w.dots + m.fill + m.dots, 0, "option off")
    t.ok(not Q.UI.ZoneOverlay:DrawsWorld())
    -- option rallumée : le dessin revient
    Q.Settings:Set("zoneOverlay", true)
    Mock.advance(0.5)
    t.ok(Q.UI.ZoneOverlay.active.mini.fill > 0, "back on")
    t.eq(#Mock.errors, 0)
  end,

  minimap_follows_the_player = function(t)
    local Q = load()
    local m = Q.UI.ZoneOverlay.active.mini
    t.ok(m.fill > 0 and m.rim == m.fill, "hull on the minimap")
    t.eq(m.dots, 7)
    local before = m.anchor
    t.ok(before, "anchor placed")
    -- joueur au centre : l'ancre (centre de gravité) est près du centre de la minicarte
    t.ok(math.abs(before[1]) < 40 and math.abs(before[2]) < 40, "near the centre")
    -- 1 % vers l'est (≈ 49 yards) : l'ancre part vers la gauche, la forme n'est pas refaite
    local shape = Q.UI.ZoneOverlay.mini.shape
    local firstTex = Q.UI.ZoneOverlay.mini.tex.fill[1]
    local corners = firstTex.qzCorners
    Mock.player.x = 51
    Mock.advance(0.2)
    local after = m.anchor
    t.ok(after[1] < before[1] - 5, "anchor moved left")
    t.near(after[2], before[2], 1e-6, "same height")
    t.eq(Q.UI.ZoneOverlay.mini.shape, shape, "shape kept")
    t.ok(firstTex.qzCorners == corners, "pieces not rebuilt")
    -- zoom (rayon de vue) changé : forme refaite
    C_Minimap.GetViewRadius = function() return 120 end
    Mock.advance(0.2)
    t.ok(Q.UI.ZoneOverlay.mini.shape ~= shape, "shape rebuilt on zoom")
    -- autre continent : tout disparaît
    Mock.player.map, Mock.player.x, Mock.player.y = 1411, 50, 50
    Mock.advance(0.2)
    t.eq(m.fill + m.rim + m.dots, 0, "hidden on another continent")
    t.eq(#Mock.errors, 0)
  end,

  fallback_disc_without_vertex_offset = function(t)
    local Q = load({ zone = false })
    Q.UI.ZoneOverlay.CanBend = function() return false end
    zone = makeZone(Q)
    Q.UI.ZoneOverlay:Refresh()
    showMap(MAP)
    local w, m = Q.UI.ZoneOverlay.active.world, Q.UI.ZoneOverlay.active.mini
    t.eq(w.fill + w.rim, 0, "no bent pieces")
    t.eq(w.disc, 1, "one disc on the world map")
    t.eq(m.disc, 1, "one disc on the minimap")
    t.eq(w.dots, 7, "dots still drawn")
    t.eq(#Mock.errors, 0)
  end,

  colours_follow_the_theme = function(t)
    local Q = load({ settings = { ["tracker.theme"] = "dark" } })
    showMap(MAP)
    local s = Q.UI.ZoneOverlay.world
    local r, g, b, a = s.tex.fill[1]:GetVertexColor()
    -- couleur du code de zone (ff40e050) telle que le thème en vigueur l'affiche
    local want = Q.Themes:CodeColor("ff40e050")
    t.near(r, want[1], 1e-6); t.near(g, want[2], 1e-6); t.near(b, want[3], 1e-6)
    t.near(a, 0.2, 1e-6, "fill alpha")
    -- autre thème choisi : la zone est repeinte avec lui
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "horde")
    Mock.advance(0.5)
    r, g, b = s.tex.fill[1]:GetVertexColor()
    want = Q.Themes:CodeColor("ff40e050", Q.Themes:Get("horde"))
    t.near(r, want[1], 1e-6); t.near(g, want[2], 1e-6); t.near(b, want[3], 1e-6)
    t.eq(#Mock.errors, 0)
  end,
}
