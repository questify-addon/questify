-- tools/routebuilder/gen_travel.lua : génère Questify/Data/Travel.lua (Q.TravelData), les données du
-- planificateur de voyage en jeu : nœuds et durées de vol, liaisons de transport, régions de marche,
-- auberges, niveau minimum par zone. Mêmes sources que sim.route (world, transport, QuestieDB, plans).
--
-- Usage :
--   luajit tools/routebuilder/gen_travel.lua [--db PATH] [--questie PATH] [--out Questify/Data/Travel.lua]
--          [--date AAAA-MM-JJ]
--
-- Sortie déterministe : clés triées, coordonnées à 2 décimales (échelle 0-100), secondes entières.

local here = (arg and arg[0] or ""):match("^(.*)[/\\]gen_travel%.lua$") or "tools/routebuilder"
package.path = here .. "/?.lua;" .. package.path

local qdb = require("qdb")
local world = require("world")
local transport = require("transport")
local plans = require("plans")

local gen = {}

local SIDE = { Alliance = "A", Horde = "H", Both = "N" }

local function c2(v) return ("%.2f"):format(v) end
local function q(s) return ("%q"):format(s):gsub("\\\n", "\\n") end

-- Côté d'un PNJ d'après son champ friendly ("A", "H", "AH"...).
local function sideOf(friendly)
  local a = friendly and friendly:find("A", 1, true)
  local h = friendly and friendly:find("H", 1, true)
  if a and not h then return "A" end
  if h and not a then return "H" end
  return "N"
end

-- Type de liaison d'après son identifiant (transport.lua ne distingue que boat / portal).
local function kindOf(l)
  if l.id:find("^tram") then return "tram" end
  if l.id:find("^zep") then return "zeppelin" end
  return l.kind
end

local function sortedKeys(t)
  local k = {}
  for key in pairs(t) do k[#k + 1] = key end
  table.sort(k)
  return k
end

-- Construit la table de données (sans l'écrire).
function gen.collect(opts)
  local W = world.load(opts.dataDir or (here .. "/data"))
  local T = { taxi = {}, edges = {}, links = {}, regions = {}, inns = {}, zoneLevels = {}, params = {} }

  -- Nœuds de vol : carte réelle = carte du spawn du maître de vol de QuestieDB le plus proche
  -- (mapAt seul prend la plus petite zone dont le cadre englobe le point : faux près des bords).
  local Ds = {}
  for _, faction in ipairs({ "Alliance", "Horde" }) do
    Ds[#Ds + 1] = qdb.load({ db = opts.db, questie = opts.questie, faction = faction })
  end
  local nodeMap, nodeDist = {}, {}
  for _, D in ipairs(Ds) do
    for _, id in ipairs(D.flightMasters or {}) do
      local npc = D.npcs[id]
      for _, m in ipairs(npc and sortedKeys(npc.spawns) or {}) do
        local p = npc.spawns[m][1]
        local c, wx, wy = W.toWorld(m, p[1], p[2])
        if c then
          local node, d = W.nearestTaxi(c, wx, wy)
          if node and d <= 100 and (not nodeDist[node.id] or d < nodeDist[node.id]) then
            nodeMap[node.id], nodeDist[node.id] = m, d
          end
        end
        break
      end
    end
  end
  -- Sans maître de vol : zone nommée par le nœud ("Tour, Zone" ou "Zone") si son cadre contient le point,
  -- sinon la plus petite zone englobante.
  local OVERRIDE = { [1] = 1429 }  -- Northshire Abbey : carte d'Elwynn
  local function zoneByName(n)
    local want = n.name:match(",%s*(.-)%s*$") or n.name
    local found
    for mid, mm in pairs(W.maps) do
      if mm.type == 3 and mm.name == want and mm.continent == n.continent
         and n.wx >= mm.minX and n.wx <= mm.maxX and n.wy >= mm.minY and n.wy <= mm.maxY
         and (not found or mid < found) then found = mid end
    end
    return OVERRIDE[n.id] or found or W.mapAt(n.continent, n.wx, n.wy)
  end
  T.unmapped = {}
  for id, n in pairs(W.taxi.nodes) do
    local m = nodeMap[id] or zoneByName(n)
    if m then
      local x, y = W.fromWorld(m, n.wx, n.wy)
      T.taxi[id] = { m = m, x = x, y = y, side = SIDE[n.faction] or "N", name = n.name }
      if not nodeMap[id] then T.unmapped[#T.unmapped + 1] = id end
    end
  end
  table.sort(T.unmapped)
  T.dropped = 0
  for id in pairs(W.taxi.nodes) do if not T.taxi[id] then T.dropped = T.dropped + 1 end end
  -- Durées de vol (secondes), symétriques : une arête connue dans un seul sens est recopiée.
  local function put(a, b, s)
    if not T.taxi[a] or not T.taxi[b] then return end
    T.edges[a] = T.edges[a] or {}
    if not T.edges[a][b] or s < T.edges[a][b] then T.edges[a][b] = s end
  end
  for a, row in pairs(W.taxi.edges) do
    for b, s in pairs(row) do
      local sec = math.max(1, math.floor(s + 0.5))
      put(a, b, sec); put(b, a, sec)
    end
  end
  T.params.flightOverhead = world.FLIGHT_OVERHEAD

  -- Liaisons : union de toutes les factions et races.
  for _, l in ipairs(transport.links) do
    T.links[#T.links + 1] = {
      id = l.id, kind = kindOf(l), name = l.note, seconds = l.time,
      from = { m = l.from[1], x = l.from[2], y = l.from[3] },
      to = { m = l.to[1], x = l.to[2], y = l.to[3] },
      side = l.faction and SIDE[l.faction] or "N", races = l.races,
    }
  end

  -- Régions de marche (Teldrassil : voir `rut`).
  for m, r in pairs(transport.REGION) do T.regions[m] = r end
  T.regions[1438] = "TELD"
  T.rut = { m = 1438, minX = 45, minY = 84 }  -- Rut'theran : x >= 45 et y >= 84 sur 1438

  -- Auberges des deux factions (un PNJ = une entrée par apparition).
  local seen = {}
  for _, D in ipairs(Ds) do
    for _, id in ipairs(D.innkeepers) do
      local n = D.npcs[id]
      if n and not seen[id] then
        seen[id] = true
        for _, m in ipairs(sortedKeys(n.spawns)) do
          for _, p in ipairs(n.spawns[m]) do
            T.inns[#T.inns + 1] = { m = m, x = p[1], y = p[2], side = sideOf(n.friendly), name = n.name, npc = id }
          end
        end
      end
    end
    T.commit = T.commit or D.commit
  end
  table.sort(T.inns, function(a, b)
    if a.m ~= b.m then return a.m < b.m end
    if a.x ~= b.x then return a.x < b.x end
    if a.y ~= b.y then return a.y < b.y end
    return a.npc < b.npc
  end)

  -- Niveau minimum d'une zone : plus petit minLevel des chapitres qui la listent.
  for _, faction in ipairs({ "Alliance", "Horde" }) do
    for _, p in ipairs(plans[faction]) do
      for _, key in ipairs({ "zones", "endZones" }) do
        for _, m in ipairs(p[key] or {}) do
          if not T.zoneLevels[m] or p.minLevel < T.zoneLevels[m] then T.zoneLevels[m] = p.minLevel end
        end
      end
    end
  end
  return T
end

local function pos(p) return ("{ m = %d, x = %s, y = %s }"):format(p.m, c2(p.x), c2(p.y)) end

-- Texte du fichier Lua.
function gen.emit(T, meta)
  local o = {}
  local function w(s) o[#o + 1] = s end
  w("local addonName, Q = ...")
  w("-- Généré par tools/routebuilder/gen_travel.lua. Ne pas modifier à la main.")
  w(("-- Source : QuestieDB commit %s, généré le %s."):format(T.commit or "unknown", meta.date))
  w("-- Données du planificateur de voyage : vols, liaisons, régions de marche, auberges, niveaux de zone.")
  w("-- Coordonnées sur 0-100 (carte uiMapID), durées en secondes. side : A = Alliance, H = Horde, N = les deux.")
  w("Q.TravelData = {")
  w(("  params = { flightOverhead = %d },"):format(T.params.flightOverhead))
  w(("  rut = { m = %d, minX = %d, minY = %d },"):format(T.rut.m, T.rut.minX, T.rut.minY))
  w("  -- Nœuds de vol : [id] = { carte, x, y, côté, nom }")
  w("  taxi = {")
  for _, id in ipairs(sortedKeys(T.taxi)) do
    local n = T.taxi[id]
    w(("    [%d] = { m = %d, x = %s, y = %s, side = %q, name = %s },"):format(id, n.m, c2(n.x), c2(n.y), n.side, q(n.name)))
  end
  w("  },")
  w("  -- Durées de vol directes entre deux nœuds reliés (symétriques)")
  w("  edges = {")
  for _, a in ipairs(sortedKeys(T.edges)) do
    local parts = {}
    for _, b in ipairs(sortedKeys(T.edges[a])) do parts[#parts + 1] = ("[%d] = %d"):format(b, T.edges[a][b]) end
    w(("    [%d] = { %s },"):format(a, table.concat(parts, ", ")))
  end
  w("  },")
  w("  -- Liaisons orientées (bateau, zeppelin, tram, portail) ; races absent : toutes les races du côté")
  w("  links = {")
  for _, l in ipairs(T.links) do
    local races = ""
    if l.races then
      local r = {}
      for _, name in ipairs(l.races) do r[#r + 1] = q(name) end
      races = (", races = { %s }"):format(table.concat(r, ", "))
    end
    w(("    { id = %s, kind = %q, from = %s, to = %s, seconds = %d, side = %q%s, name = %s },"):format(
      q(l.id), l.kind, pos(l.from), pos(l.to), l.seconds, l.side, races, q(l.name)))
  end
  w("  },")
  w("  -- Régions de marche : deux points d'une même région se rejoignent à pied")
  w("  regions = {")
  for _, m in ipairs(sortedKeys(T.regions)) do w(("    [%d] = %q,"):format(m, T.regions[m])) end
  w("  },")
  w("  -- Auberges")
  w("  inns = {")
  for _, i in ipairs(T.inns) do
    w(("    { m = %d, x = %s, y = %s, side = %q, name = %s },"):format(i.m, c2(i.x), c2(i.y), i.side, q(i.name)))
  end
  w("  },")
  w("  -- Niveau minimum conseillé par zone (plus petit minLevel des chapitres de la zone)")
  w("  zoneLevels = {")
  for _, m in ipairs(sortedKeys(T.zoneLevels)) do w(("    [%d] = %d,"):format(m, T.zoneLevels[m])) end
  w("  },")
  w("}")
  return table.concat(o, "\n") .. "\n"
end

function gen.generate(opts)
  return gen.emit(gen.collect(opts), { date = opts.date or os.date("%Y-%m-%d") })
end

-- Ligne de commande (exécution directe seulement).
if arg and arg[0] and arg[0]:find("gen_travel%.lua$") then
  local o = { db = qdb.DEFAULT_DB, questie = qdb.DEFAULT_QUESTIE, out = "Questify/Data/Travel.lua" }
  local i = 1
  while i <= #arg do
    local a, v = arg[i], arg[i + 1]
    if a == "--db" then o.db = v elseif a == "--questie" then o.questie = v
    elseif a == "--out" then o.out = v elseif a == "--date" then o.date = v
    else error("unknown argument " .. tostring(a)) end
    i = i + 2
  end
  local T = gen.collect(o)
  local nt = 0
  for _ in pairs(T.taxi) do nt = nt + 1 end
  print(("taxi nodes %d, without flight master (fallback map): %d, dropped (no map): %d"):format(nt, #T.unmapped, T.dropped))
  local text = gen.emit(T, { date = o.date or os.date("%Y-%m-%d") })
  local f = assert(io.open(o.out, "wb"))
  f:write(text); f:close()
  print(("wrote %s (%d bytes)"):format(o.out, #text))
end

return gen
