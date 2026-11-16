-- Tests de la ligne de route sur la carte du monde et la minicarte (UI/RouteLine.lua), posée par
-- les vraies bibliothèques HereBeDragons chargées par le TOC.
-- Repère du mock : Elwynn (1429) mesure 3470 × 2314 yd : 1 unité de x vaut 34,7 yd, 1 de y 23,14 yd.
local TOC = "Questify/Questify.toc"
local Ext = dofile(Mock.root .. "/tests/mock_ext_mappins.lua")

local REF = "Questify_RouteLine"
local ELWYNN, DUROTAR = 1429, 1411
local DOT = "Interface\\CharacterFrame\\TempPortraitAlphaMask"
local SQUARE = "Interface\\Buttons\\WHITE8X8"

-- Charge l'addon, Questify_Nav installé (routeur Questify), joueur à Elwynn 40,50, sans guides,
-- carte du monde ouverte sur Elwynn (sauf mapClosed : la ligne n'y est posée que carte ouverte).
local function load(settings, mapClosed)
  Mock.addons.Questify_Nav = "demand"
  Mock.player.map, Mock.player.x, Mock.player.y = ELWYNN, 40, 50
  local Q = Mock.loadAddon(TOC, { skipGuides = true, beforeLogin = function(Q)
    for path, value in pairs(settings or {}) do Q.Settings:Set(path, value) end
  end })
  if not mapClosed then
    WorldMapFrame:Show()
    WorldMapFrame:SetMapID(ELWYNN)
  end
  return Q
end

local function world(Q, m, x, y)
  local c, X, Y = Q.Maps:WorldPos(m, x, y)
  return { instance = c, x = X, y = Y }
end

local function leg(kind, m1, x1, y1, m2, x2, y2)
  return { kind = kind, from = { mapId = m1, x = x1, y = y1 }, to = { mapId = m2, x = x2, y = y2 }, seconds = 60 }
end

-- Route publiée comme le pont de marche (Nav/Walk.lua) : une marche Elwynn 40,50 -> 60,50 (694 yd
-- vers l'est), chemin en ligne droite, ou les legs et le chemin donnés.
local function fakeRoute(Q, legs, path)
  legs = legs or { leg("walk", ELWYNN, 40, 50, ELWYNN, 60, 50) }
  path = path or { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 60, 50) }
  return { legs = legs, leg = 1, path = path, nextPoint = path[#path], straight = false, warnings = {},
    target = { mapId = ELWYNN, x = 60, y = 50, title = "East" } }
end

-- Données HereBeDragons des repères posés : { icon = data } pour la carte du monde ou la minicarte,
-- marques de la ligne (halo nil) ou halos (halo vrai).
local function pinData(where, halo)
  local lib = Ext.pins()
  local reg = where == "world" and lib.worldmapPinRegistry[REF] or lib.minimapPinRegistry[REF]
  local store = where == "world" and lib.worldmapPins or lib.minimapPins
  local out = {}
  for icon in pairs(reg or {}) do
    if (icon.halo == true) == (halo == true) then out[icon] = store[icon] end
  end
  return out
end

local function size(t)
  local n = 0
  for _ in pairs(t) do n = n + 1 end
  return n
end

-- Marques de la ligne posées (sans les halos) : carte du monde, minicarte.
local function counts() return size(pinData("world")), size(pinData("minimap")) end

local function noErrors(t) t.eq(Mock.errors, {}, "no Lua error") end

return {
  draws_dots = function(t)
    local Q = load()
    t.ok(Q.RouteLine, "Q.RouteLine exists")
    t.eq(Q.Settings:Get("nav.lineStyle"), "dots", "dots by default")
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    local w, m = counts()
    t.eq(w, 58, "694 yd every 12 yd: 58 points on the world map")
    t.ok(m > 0 and m <= 60, "points near the player on the minimap (" .. m .. ")")
    -- coordonnées monde de HereBeDragons : x vers l'ouest, y vers le nord (UnitPosition inversé)
    local HBD = LibStub("HereBeDragons-2.0")
    local xs = {}
    for icon, d in pairs(pinData("world")) do
      t.eq(d.instanceID, 0, "Eastern Kingdoms")
      local zx, zy = HBD:GetZoneCoordinatesFromWorldInstance(d.x, d.y, d.instanceID, ELWYNN)
      t.ok(zx and zy, "pin inside Elwynn")
      t.near(zy * 100, 50, 0.01, "on the line y = 50")
      xs[#xs + 1] = zx * 100
      t.eq(icon.tex:GetTexture(), DOT, "round dot")
    end
    table.sort(xs)
    t.near(xs[1], 40, 0.01, "first point at the player")
    t.near(xs[2] - xs[1], 12 / 34.7, 0.001, "12 yd apart")
    t.ok(xs[#xs] <= 60, "last point before the goal")
    -- couleur : rôle title du thème (parchemin), éclairci pour rester lisible sur la carte
    local c = Q.RouteLine:Color()
    local title = Q.Themes:TextColor("title")
    t.ok(c[1] > title[1], "parchment title lightened")
    t.near(c[2] / c[1], title[2] / title[1], 0.001, "same hue")
    local icon = next(pinData("world"))
    local r, g, b = icon.tex:GetVertexColor()
    t.near(r, c[1], 0.001)
    t.near(g, c[2], 0.001)
    t.near(b, c[3], 0.001)
    noErrors(t)
  end,

  dark_theme_color_unchanged = function(t)
    local Q = load({ ["tracker.theme"] = "dark" })
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    local c = Q.RouteLine:Color()
    local title = Q.Themes:TextColor("title")
    t.near(c[1], title[1], 0.001, "bright title kept as is")
    t.near(c[2], title[2], 0.001)
    t.near(c[3], title[3], 0.001)
    noErrors(t)
  end,

  style_switch = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 58, "dots: every 12 yd")
    Q.Settings:Set("nav.lineStyle", "dashes")
    t.eq((counts()), 70, "dashes: every 10 yd")
    for icon in pairs(pinData("world")) do
      t.eq(icon.tex:GetTexture(), SQUARE, "dash")
      t.near(icon.tex:GetRotation(), 0, 0.001, "eastward segment: horizontal dash")
    end
    Q.Settings:Set("nav.lineStyle", "solid")
    t.eq((counts()), 174, "solid: every 4 yd")
    -- tirets le long d'un segment vers le nord : tournés d'un quart de tour
    Q.Settings:Set("nav.lineStyle", "dashes")
    Q:Fire("NAV_ROUTE", fakeRoute(Q, { leg("walk", ELWYNN, 40, 50, ELWYNN, 40, 30) },
      { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 40, 30) }))
    for icon in pairs(pinData("world")) do
      t.near(icon.tex:GetRotation(), math.pi / 2, 0.001, "northward segment: vertical dash")
    end
    noErrors(t)
  end,

  ride_legs_fine_dashes = function(t)
    local Q = load({ ["nav.lineStyle"] = "solid" })
    local legs = {
      leg("walk", ELWYNN, 40, 50, ELWYNN, 41, 50),
      leg("fly", ELWYNN, 41, 50, ELWYNN, 61, 50),
      leg("hearth", ELWYNN, 61, 50, ELWYNN, 20, 20),
    }
    Q:Fire("NAV_ROUTE", fakeRoute(Q, legs, { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 41, 50) }))
    local walk, fly = 0, 0
    for icon in pairs(pinData("world")) do
      if icon.kind == "ride" then
        fly = fly + 1
        t.eq(icon.tex:GetTexture(), SQUARE, "flight: fine dashes whatever the style")
      else
        walk = walk + 1
        t.eq(icon.tex:GetTexture(), DOT)
      end
    end
    t.eq(walk, 9, "35 yd walk every 4 yd")
    t.eq(fly, 58, "694 yd flight every 12 yd")
    noErrors(t)
  end,

  cleared_on_nil_route = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    local w = counts()
    t.ok(w > 0)
    Q:Fire("NAV_ROUTE", nil)
    local w2, m2 = counts()
    t.eq(w2, 0, "world map cleared")
    t.eq(m2, 0, "minimap cleared")
    noErrors(t)
  end,

  pin_cap = function(t)
    local Q = load({ ["nav.lineStyle"] = "solid" })
    -- 2382 yd every 4 yd : 596 points
    Q:Fire("NAV_ROUTE", fakeRoute(Q, { leg("walk", ELWYNN, 40, 50, ELWYNN, 100, 100) },
      { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 100, 100) }))
    local w, m = counts()
    t.eq(w, 200, "world map: 200 marks")
    t.eq(m, 30, "minimap: 30 marks")
    t.eq({ Ext.registered(REF) }, { 400, 60 }, "with their halos: 400 and 60 pins at most")
    -- les plus proches du joueur : le début du chemin
    local HBD = LibStub("HereBeDragons-2.0")
    local maxX = 0
    for _, d in pairs(pinData("minimap")) do
      local zx = HBD:GetZoneCoordinatesFromWorldInstance(d.x, d.y, d.instanceID, ELWYNN)
      maxX = math.max(maxX, zx * 100)
    end
    t.ok(maxX < 47, "minimap keeps the closest points (" .. maxX .. ")")
    noErrors(t)
  end,

  passed_points_removed = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 58)
    local frames = #Mock.frames
    Mock.player.x = 50          -- 347 yd plus loin sur le chemin
    Mock.advance(1)
    local w = counts()
    t.ok(w <= 58 - 28 and w >= 58 - 30, "points behind the player removed (" .. w .. " left)")
    local HBD = LibStub("HereBeDragons-2.0")
    for _, d in pairs(pinData("world")) do
      local zx = HBD:GetZoneCoordinatesFromWorldInstance(d.x, d.y, d.instanceID, ELWYNN)
      t.ok(zx * 100 >= 49.6, "only points ahead remain")
    end
    t.eq(#Mock.frames, frames, "no new frame: pins reused")
    noErrors(t)
  end,

  other_continent_only_current = function(t)
    local Q = load()
    local legs = {
      leg("walk", ELWYNN, 40, 50, ELWYNN, 60, 50),
      leg("boat", ELWYNN, 60, 50, DUROTAR, 10, 10),
      leg("walk", DUROTAR, 10, 10, DUROTAR, 30, 10),
    }
    Q:Fire("NAV_ROUTE", fakeRoute(Q, legs))
    local inst = { [0] = 0, [1] = 0 }
    for _, d in pairs(pinData("world")) do inst[d.instanceID] = inst[d.instanceID] + 1 end
    t.eq(inst[0], 58, "Elwynn walk on the Eastern Kingdoms")
    t.eq(inst[1], 89, "Durotar walk (1057 yd every 12 yd) on Kalimdor; boat across continents not drawn")
    local mini = 0
    for _, d in pairs(pinData("minimap")) do
      mini = mini + 1
      t.eq(d.instanceID, 0, "minimap: player's continent only")
    end
    t.ok(mini > 0)
    noErrors(t)
  end,

  not_drawn_with_spf = function(t)
    Mock.addons.ShortestPathForever = true
    local Q = load({ ["nav.router"] = "spf" })
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    local w, m = counts()
    t.eq(w, 0, "SPF draws its own line")
    t.eq(m, 0)
    -- retour au routeur Questify : la route suivante est tracée
    Q.Settings:Set("nav.router", "questify")
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 58)
    -- et retirée quand SPF est choisi
    Q.Settings:Set("nav.router", "spf")
    t.eq((counts()), 0, "switched to SPF: line removed")
    noErrors(t)
  end,

  follows_the_walk_bridge = function(t)
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    Mock.advance(0.3)
    local w, m = counts()
    t.ok(w > 0, "route of the walk bridge drawn (" .. w .. ")")
    t.ok(m > 0)
    Q.Nav:Clear()
    t.eq((counts()), 0, "target cleared: line removed")
    noErrors(t)
  end,

  map_closed_no_world_pins = function(t)
    local Q = load(nil, true)
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    local w, m = counts()
    t.eq(w, 0, "world map closed: no world pin registered")
    t.ok(m > 0, "minimap pins stay live")
    t.eq(Mock.countCalls("WorldMapFrame:AcquirePin"), 0)
    -- ouverture : la ligne est posée ; fermeture : retirée
    WorldMapFrame:Show()
    WorldMapFrame:SetMapID(ELWYNN)
    t.eq((counts()), 58, "map opened: line placed")
    WorldMapFrame:Hide()
    t.eq((counts()), 0, "map closed: line removed")
    t.eq(select(2, counts()), m, "minimap untouched")
    -- nouvelle route carte fermée : rien sur la carte du monde
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 0)
    noErrors(t)
  end,

  halo_under_each_mark = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    for _, where in ipairs({ "world", "minimap" }) do
      local marks, halos = pinData(where), pinData(where, true)
      t.eq(size(halos), size(marks), where .. ": one halo per mark")
      local at = {}
      for icon, d in pairs(halos) do at[icon.index] = { d = d, icon = icon } end
      for icon, d in pairs(marks) do
        local h = at[icon.index]
        t.ok(h, where .. ": halo of the same point")
        t.near(h.d.x, d.x, 0.001)
        t.near(h.d.y, d.y, 0.001)
        local r, g, b, a = h.icon.tex:GetVertexColor()
        t.eq({ r, g, b }, { 0, 0, 0 }, "dark halo")
        t.near(a, 0.667, 0.001, "maquette #000a")
        t.ok(h.icon.tex:GetWidth() > icon.tex:GetWidth(), "halo wider than the mark")
      end
    end
    -- minicarte : halo sous la marque
    local base = Minimap:GetFrameLevel()
    for icon in pairs(pinData("minimap")) do t.eq(icon:GetFrameLevel(), base + 2) end
    for icon in pairs(pinData("minimap", true)) do t.eq(icon:GetFrameLevel(), base + 1) end
    noErrors(t)
  end,

  world_frame_levels_below_quest_pins = function(t)
    -- gestionnaire de niveaux de la carte (MapCanvas) : types rangés dans l'ordre
    local order = { "PIN_FRAME_LEVEL_MAP_EXPLORATION", "PIN_FRAME_LEVEL_AREA_POI" }
    local mgr = {}
    function mgr:InsertFrameLevelBelow(new, existing)
      for i, v in ipairs(order) do
        if v == existing then table.insert(order, i, new); return end
      end
      error("unknown frame level " .. tostring(existing))
    end
    function mgr:GetValidFrameLevel(kind)
      for i, v in ipairs(order) do if v == kind then return 100 + i end end
      return nil
    end
    local Q = load(nil, true)
    rawset(WorldMapFrame, "GetPinFrameLevelsManager", function() return mgr end)
    WorldMapFrame:Show()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq(order, { "PIN_FRAME_LEVEL_MAP_EXPLORATION", "QUESTIFY_ROUTE_HALO", "QUESTIFY_ROUTE_LINE",
      "PIN_FRAME_LEVEL_AREA_POI" }, "halo below the line, line below quest pins")
    for _, d in pairs(pinData("world")) do t.eq(d.frameLevelType, "QUESTIFY_ROUTE_LINE") end
    for _, d in pairs(pinData("world", true)) do t.eq(d.frameLevelType, "QUESTIFY_ROUTE_HALO") end
    noErrors(t)
  end,

  world_frame_levels_fallback = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 58, "no level manager: default level")
    for _, d in pairs(pinData("world")) do t.eq(d.frameLevelType, nil) end
    noErrors(t)
  end,

  switchback_not_skipped = function(t)
    local Q = load()
    -- chemin en U : 231 yd vers le nord, 69 vers l'est, 231 vers le sud (532 yd, 45 points)
    local path = { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 40, 40), world(Q, ELWYNN, 42, 40),
      world(Q, ELWYNN, 42, 50) }
    Q:Fire("NAV_ROUTE", fakeRoute(Q, { leg("walk", ELWYNN, 40, 50, ELWYNN, 42, 50) }, path))
    t.eq((counts()), 45)
    -- un pas vers le nord, un peu à l'est : plus près du retour du U (28 yd) que de l'aller (42 yd)
    Mock.player.x, Mock.player.y = 41.2, 49
    Mock.advance(1)
    local w = counts()
    t.eq(w, 43, "only the 2 points behind the player removed (" .. w .. " left)")
    noErrors(t)
  end,

  theme_change_recolors = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q))
    t.eq((counts()), 58)
    Q.Settings:Set("tracker.theme", "dark")
    local title = Q.Themes:TextColor("title")
    for icon in pairs(pinData("world")) do
      local r, g, b = icon.tex:GetVertexColor()
      t.near(r, title[1], 0.001)
      t.near(g, title[2], 0.001)
      t.near(b, title[3], 0.001)
    end
    noErrors(t)
  end,
}
