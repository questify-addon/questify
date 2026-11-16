-- Tests du planificateur de voyage (Q.Travel, Nav/Travel.lua) sur les vraies données de
-- Data/Travel.lua. Les cartes du mock reçoivent leurs vraies bornes (UiMapAssignment du client
-- Forever, comme tools/routebuilder/world.lua) : distances et temps de marche réalistes.
local TOC = "Questify/Questify.toc"
local Ext = dofile(Mock.root .. "/tests/mock_ext_comfort.lua")

-- uiMapID = { nom, continent, minX, minY, maxX, maxY } (yards monde)
local BOUNDS = {
  [1426] = { "Dun Morogh", 0, -7160.4165, -3122.9165, -3877.0833, 1802.0833 },
  [1429] = { "Elwynn Forest", 0, -10254.1660, -1935.4166, -7939.5830, 1535.4166 },
  [1436] = { "Westfall", 0, -11733.3330, -483.3333, -9400, 3016.6665 },
  [1453] = { "Stormwind City", 0, -9154.1699, -14.5840, -7995.8301, 1722.9200 },
  [1455] = { "Ironforge", 0, -5096.8457, -1504.2164, -4569.2412, -713.5914 },
  [1420] = { "Tirisfal Glades", 0, 825.0, -1485.4166, 3837.4998, 3033.3333 },
  [1411] = { "Durotar", 1, -1716.6666, -7250.0, 1808.3333, -1962.4999 },
  [1439] = { "Darkshore", 1, 3966.6665, -3608.3333, 8333.3330, 2941.6665 },
  [1438] = { "Teldrassil", 1, 8437.5, -1277.0833, 11831.25, 3814.5833 },
  [1457] = { "Darnassus", 1, 9532.5869, 1880.0295, 10238.3164, 2938.3628 },
}

-- Repère du mock : monde = (top - y * height, left - x * width), soit x carte vers -Y et y vers -X.
local function realMaps()
  for id, b in pairs(BOUNDS) do
    Mock.maps[id] = { name = b[1], continent = b[2], top = b[5], left = b[6], height = b[5] - b[3],
      width = b[6] - b[4], parent = b[2] == 0 and 1415 or 1414 }
  end
end

-- Points de vol connus : nœuds de C_TaxiMap.GetTaxiNodesForMap (identifiants de TaxiNodes).
local NODES = {
  [2] = { 1415, "Stormwind, Elwynn" },
  [4] = { 1415, "Sentinel Hill, Westfall" },
  [6] = { 1415, "Ironforge, Dun Morogh" },
}
local function known(ids)
  Mock.comfort.mapNodes = {}
  for _, id in ipairs(ids) do
    local n = NODES[id]
    local list = Mock.comfort.mapNodes[n[1]] or {}
    Mock.comfort.mapNodes[n[1]] = list
    list[#list + 1] = { nodeID = id, name = n[2], x = 0.5, y = 0.5 }
  end
end

local function load(opts)
  opts = opts or {}
  Ext.install()
  realMaps()
  if opts.locale then Mock.locale = opts.locale end
  if opts.faction then
    Mock.player.faction = opts.faction
    Mock.player.raceId = opts.faction == "Horde" and 2 or 1
  end
  known(opts.known or {})
  return Mock.loadAddon(TOC, { skipGuides = true })
end

local function kinds(legs)
  local out = {}
  for i, l in ipairs(legs or {}) do out[i] = l.kind end
  return table.concat(out, ",")
end

local function has(legs, kind)
  for _, l in ipairs(legs or {}) do if l.kind == kind then return true end end
  return false
end

local function cooldown(left)
  Mock.advance(10)
  Mock.comfort.cooldown = { start = Mock.now, duration = left, enable = 1 }
end

-- Lie la pierre à l'auberge de Goldshire (Innkeeper Farley) comme le jeu : HEARTHSTONE_BOUND.
local function bindGoldshire()
  Mock.player.map, Mock.player.x, Mock.player.y, Mock.player.bind = 1429, 43.77, 65.80, "Goldshire"
  Mock.fire("HEARTHSTONE_BOUND")
end

-- Elwynn devant Stormwind, Gryan Stoutmantle à Sentinel Hill, auberge de Goldshire.
local ELWYNN_GATE = { 1429, 32, 50 }
local GRYAN = { 1436, 56.33, 47.52 }
local GOLDSHIRE = { 1429, 43.0, 66.0 }

return {
  walk_only_close = function(t)
    local Q = load()
    -- 300 yards vers l'est : x carte vers -Y, 3470,8 yards pour 100 unités sur Elwynn
    local legs = Q.Travel:Plan({ 1429, 40, 60 }, { 1429, 40 + 300 / 3470.833 * 100, 60 })
    t.eq(kinds(legs), "walk")
    t.near(legs[1].seconds, 300 / 7, 0.05)
    t.eq(legs[1].icon, Q.Travel.ICONS.walk)
    t.eq(#Mock.errors, 0)
  end,

  fly_when_known = function(t)
    local Q = load({ locale = "frFR", known = { 2, 4 } })
    local legs = Q.Travel:Plan(ELWYNN_GATE, GRYAN)
    t.eq(kinds(legs), "walk,fly,walk")
    t.eq(legs[2].caption, "Vol vers Sentinel Hill")
    t.eq(legs[2].icon, Q.Travel.ICONS.fly)
    t.eq(legs[2].node, 4)
    -- 71 s de vol direct + 20 s de décollage et d'atterrissage
    t.eq(legs[2].seconds, 91)
    t.eq(legs[1].to.mapId, 1453)
    t.eq(legs[3].to.mapId, 1436)
    t.eq(legs[1].caption, "Marche jusqu'au maître de vol")
    t.eq(#Mock.errors, 0)
  end,

  fly_caption_english = function(t)
    local Q = load({ known = { 2, 4 } })
    local legs = Q.Travel:Plan(ELWYNN_GATE, GRYAN)
    t.eq(legs[2].caption, "Fly to Sentinel Hill")
  end,

  no_unknown_flight = function(t)
    local Q = load({ known = { 2 } })
    local legs = Q.Travel:Plan(ELWYNN_GATE, GRYAN)
    t.ok(legs, "a plan")
    local knownSet = Q.Travel:KnownTaxi()
    for _, l in ipairs(legs) do
      t.ok(l.kind ~= "fly" or knownSet[l.node], "flight lands on a known node")
      t.ok(not (l.kind == "fly" and l.node == 4), "no flight to Sentinel Hill")
    end
    t.eq(kinds(legs), "walk")
  end,

  known_taxi_refreshed = function(t)
    local Q = load({ known = { 2 } })
    t.eq(Q.Travel:KnownTaxi(), { [2] = true })
    known({ 2, 4 })
    Mock.comfort.mapNodes[1415][3] = { nodeID = 5, name = "Lakeshire, Redridge", undiscovered = true }
    t.eq(Q.Travel:KnownTaxi(), { [2] = true }, "cached")
    Mock.fire("TAXIMAP_OPENED")
    t.eq(Q.Travel:KnownTaxi(), { [2] = true, [4] = true })
    known({ 2, 4, 6 })
    Mock.fire("UI_INFO_MESSAGE", 0, "New flight path discovered!")
    t.eq(Q.Travel:KnownTaxi(), { [2] = true, [4] = true, [6] = true })
  end,

  hearth_ready = function(t)
    local Q = load()
    bindGoldshire()
    t.eq({ Q.Hearth:BindPos() }, { 1429, 43.77, 65.80 })
    local legs = Q.Travel:Plan(GRYAN, GOLDSHIRE)
    t.eq(kinds(legs), "hearth,walk")
    t.eq(legs[1].seconds, 25)
    t.eq(legs[1].caption, "Hearthstone to Goldshire")
    t.eq(legs[1].icon, Q.Travel.ICONS.hearth)
    t.eq(legs[1].to.mapId, 1429)
    t.eq(#Mock.errors, 0)
  end,

  hearth_cooldown = function(t)
    local Q = load()
    bindGoldshire()
    cooldown(20 * 60)
    t.ok(Q.Hearth:Remaining() > 0, "on cooldown")
    local legs = Q.Travel:Plan(GRYAN, GOLDSHIRE)
    t.ok(not has(legs, "hearth"), "no hearth: " .. kinds(legs))
  end,

  hearth_only_from_start = function(t)
    local Q = load()
    bindGoldshire()
    -- Stormwind -> Darnassus : la pierre ramène à Goldshire, jamais en cours de trajet
    local legs = Q.Travel:Plan({ 1453, 50, 60 }, { 1457, 40, 50 })
    for i, l in ipairs(legs) do t.ok(l.kind ~= "hearth" or i == 1, "hearth first only") end
  end,

  unknown_bind = function(t)
    local Q = load()
    Mock.player.bind = "Coldridge Valley"
    t.eq(Q.Hearth:BindPos(), nil)
    local legs = Q.Travel:Plan(GRYAN, GOLDSHIRE)
    t.ok(not has(legs, "hearth"), "no hearth: " .. kinds(legs))
  end,

  stale_recorded_bind = function(t)
    local Q = load()
    bindGoldshire()
    Mock.player.bind = "Coldridge Valley"   -- liée ailleurs depuis, sans Questify
    t.eq(Q.Hearth:BindPos(), nil)
    t.ok(not has(Q.Travel:Plan(GRYAN, GOLDSHIRE), "hearth"))
  end,

  bind_from_inn_map_name = function(t)
    local Q = load()
    Mock.player.bind = "Stormwind City"     -- une seule auberge de l'Alliance sur cette carte
    t.eq({ Q.Hearth:BindPos() }, { 1453, 60.39, 75.27 })
    local legs = Q.Travel:Plan(GRYAN, { 1453, 60, 75 })
    t.eq(legs[1].kind, "hearth")
  end,

  other_faction_link = function(t)
    local Q = load()
    t.ok(has(Q.Travel:Plan({ 1455, 76, 50 }, { 1453, 68, 32 }), "tram"), "Alliance takes the tram")
    t.ok(not has(Q.Travel:Plan({ 1411, 50.8, 14 }, { 1420, 61, 58 }), "zeppelin"), "Alliance: no zeppelin")
    Q = load({ faction = "Horde" })
    t.ok(not has(Q.Travel:Plan({ 1455, 76, 50 }, { 1453, 68, 32 }), "tram"), "Horde: no tram")
    local legs = Q.Travel:Plan({ 1411, 50.8, 14 }, { 1420, 61, 58 })
    t.ok(has(legs, "zeppelin"), "Horde takes the zeppelin: " .. kinds(legs))
    t.eq(#Mock.errors, 0)
  end,

  other_continent = function(t)
    local Q = load()
    local legs = Q.Travel:Plan({ 1453, 50, 60 }, { 1457, 40, 50 })
    t.ok(has(legs, "boat"), "boat: " .. kinds(legs))
    t.ok(has(legs, "portal"), "portal up to Darnassus")
    t.eq(legs[#legs].to.mapId, 1457)
    for _, l in ipairs(legs) do
      t.ok(type(l.caption) == "string" and l.caption ~= "", "caption")
      t.eq(l.icon, Q.Travel.ICONS[l.kind])
    end
  end,

  mount_speed = function(t)
    local function walk700(Q)
      local legs = Q.Travel:Plan({ 1429, 30, 60 }, { 1429, 30 + 700 / 3470.833 * 100, 60 })
      t.eq(kinds(legs), "walk")
      return legs[1].seconds
    end
    Mock.skills = { { name = "Secondary Skills", header = true }, { name = "Riding", rank = 75 } }
    local Q = load()
    t.near(Q.Travel:Speed(), 11.2, 1e-6)
    t.near(walk700(Q), 62.5, 0.05)
    Mock.skills = { { name = "Riding", rank = 150 } }
    t.near(walk700(Q), 50, 0.05)
    Mock.skills = {}
    t.eq(Q.Travel:Speed(), 7)
    t.near(walk700(Q), 100, 0.05)
    Mock.locale = "frFR"
    Mock.skills = { { name = "Monte", rank = 75 } }
    t.near(Q.Travel:Speed(), 11.2, 1e-6)
  end,

  unknown_map_no_plan = function(t)
    local Q = load()
    t.eq(Q.Travel:Plan({ 99999, 50, 50 }, { 1429, 40, 60 }), nil)
    t.eq(Q.Travel:Plan(nil, { 1429, 40, 60 }), nil)
    t.eq(#Mock.errors, 0)
  end,
}
