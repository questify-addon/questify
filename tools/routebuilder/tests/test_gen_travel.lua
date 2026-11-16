-- Tests du générateur de données de voyage (gen_travel.lua) : contenu de Q.TravelData et déterminisme.
local H = require("helpers")
local gen = require("gen_travel")
local transport = require("transport")

-- Texte généré, chargé comme le client : `local addonName, Q = ...`.
local cache
local function build()
  if not cache then
    local text = gen.generate({ db = require("qdb").DEFAULT_DB, questie = require("qdb").DEFAULT_QUESTIE,
                                date = "2026-01-01", dataDir = H.ROOT .. "/data" })
    local Q = {}
    local fn = assert(loadstring(text, "=Travel"))
    fn("Questify", Q)
    cache = { text = text, T = Q.TravelData }
  end
  return cache.T, cache.text
end

local function findLink(T, kind, fm, tm)
  for _, l in ipairs(T.links) do
    if l.kind == kind and l.from.m == fm and l.to.m == tm then return l end
  end
end

return {
  taxi_has_capitals_with_side = function(t)
    local T = build()
    local sw, org
    for _, n in pairs(T.taxi) do
      local name = n.name
      if name == "Stormwind, Elwynn" then sw = n end
      if name == "Orgrimmar, Durotar" then org = n end
    end
    t.ok(sw and org, "Stormwind and Orgrimmar nodes")
    t.eq(sw.side, "A"); t.eq(org.side, "H")
    t.ok(sw.x > 0 and sw.x < 100 and sw.y > 0 and sw.y < 100, "coords 0-100")
  end,

  taxi_nodes_on_real_zone = function(t)
    local T = build()
    local want = { ["Ratchet, The Barrens"] = 1413, ["Aerie Peak, The Hinterlands"] = 1425,
                   ["Crossroads, The Barrens"] = 1413, ["Tarren Mill, Hillsbrad"] = 1424,
                   ["Northshire Abbey"] = 1429 }
    local got = {}
    for _, n in pairs(T.taxi) do if want[n.name] then got[n.name] = n.m end end
    for name, m in pairs(want) do t.eq(got[name], m, name) end
  end,

  edges_symmetric_positive = function(t)
    local T = build()
    local n = 0
    for a, row in pairs(T.edges) do
      t.ok(T.taxi[a], "edge source is a taxi node")
      for b, s in pairs(row) do
        n = n + 1
        t.ok(s > 0 and s == math.floor(s), "positive integer seconds")
        t.eq(T.edges[b] and T.edges[b][a], s, "symmetric")
      end
    end
    t.ok(n > 50, "many edges")
  end,

  links_tram_and_zeppelin = function(t)
    local T = build()
    local tram = findLink(T, "tram", 1455, 1453)
    t.ok(tram, "tram Ironforge -> Stormwind")
    t.eq(tram.side, "N")
    t.ok(findLink(T, "tram", 1453, 1455), "tram Stormwind -> Ironforge")
    local zep = findLink(T, "zeppelin", 1411, 1420)
    t.ok(zep and zep.side == "H", "zeppelin Orgrimmar -> Undercity")
    t.ok(findLink(T, "zeppelin", 1420, 1411), "zeppelin Undercity -> Orgrimmar")
    local sky
    for _, l in ipairs(T.links) do if l.races then sky = l end end
    t.ok(sky and sky.races[1] == "Skyborne", "race-restricted link keeps races")
    t.eq(#T.links, #transport.links, "every link exported")
  end,

  zone_levels = function(t)
    local T = build()
    t.eq(T.zoneLevels[1429], 1, "Elwynn")
    t.ok(T.zoneLevels[1446] >= 40, "Tanaris")
  end,

  regions_cover_transport = function(t)
    local T = build()
    for m = 1400, 1460 do
      local r = transport.regionOf(m, 10, 10)
      if r and m ~= 1438 then t.eq(T.regions[m], r, "region " .. m) end
    end
    t.eq(T.regions[1438], "TELD")
  end,

  inns_both_sides = function(t)
    local T = build()
    local seen = {}
    for _, i in ipairs(T.inns) do seen[i.side] = true; t.ok(i.m and i.x and i.y, "inn position") end
    t.ok(seen.A and seen.H, "inns of both sides")
  end,

  deterministic = function(t)
    local _, a = build()
    cache = nil
    local _, b = build()
    t.ok(a == b, "same output twice")
    t.ok(a:find("Ne pas modifier", 1, true), "header")
  end,
}
