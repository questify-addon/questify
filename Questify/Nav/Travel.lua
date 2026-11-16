local addonName, Q = ...

-- Planificateur de voyage : plus court trajet (Dijkstra) entre deux points, avec ce que le personnage
-- a débloqué. Même modèle que sim.route du route builder (tools/routebuilder/sim.lua) :
--   * marche en ligne droite seulement à l'intérieur d'une région de marche (Q.TravelData.regions) ;
--   * vols entre points de vol, en plusieurs sauts par les points connus (Q.TravelData.edges) ;
--   * liaisons de transport de la faction et de la race (bateau, zeppelin, tram, portail) ;
--   * pierre de foyer, seulement au départ, quand elle est prête et que l'auberge liée est connue.
-- Un point de vol non appris peut être rejoint à pied, appris puis quitté en vol, jamais rejoint en vol.
--
-- Q.Travel:Plan(from, to) -> legs | nil ; from, to = { mapId, x, y } (0-100, ou champs mapId / x / y ;
-- to.name, facultatif, nomme la destination dans la légende de la dernière marche).
-- legs = { { kind = "walk"|"fly"|"boat"|"zeppelin"|"tram"|"portal"|"hearth",
--            from = { mapId, x, y }, to = { mapId, x, y }, seconds, caption, icon,
--            node (vol : nœud d'arrivée), link (liaison : identifiant), yards (marche) } }
-- Les points de from / to sont des tables { mapId = , x = , y = }.
local Travel = {}
Q.Travel = Travel

local L = Q.L

-- Coûts copiés de tools/routebuilder/sim.lua (sim.CONST) : garder les mêmes valeurs.
local WALK = 7               -- C.WALK : yards/s à pied
local FLY_PENALTY = 30       -- C.FLY_PENALTY : s ajoutées au choix d'un vol (descendre, remonter, file)
local HEARTH_CAST = 10       -- C.HEARTH_CAST : s d'incantation
local HEARTH_PENALTY = 120   -- C.HEARTH_PENALTY : s de coût d'opportunité de la pierre (recharge)
local HEARTH_LOAD = 15       -- C.HEARTH_LOAD : s d'écran de chargement (temps affiché = CAST + LOAD)
local HEARTH_NEAR = 120      -- C.HEARTH_NEAR : yards, apparitions d'un même aubergiste fusionnées
local FLIGHT_OVERHEAD = 20   -- world.FLIGHT_OVERHEAD (repris de Q.TravelData.params) : par vol

-- Monture (compétence Monte) : ×1,6 à 75 (apprenti), ×2,0 à 150 (compagnon).
local RIDING_APPRENTICE, RIDING_JOURNEYMAN = 75, 150
local MOUNT_SLOW, MOUNT_FAST = 1.6, 2.0
local RIDING_SPELL = 33388   -- Monte (apprenti) : son nom localisé contient celui de la compétence
local RIDING_NAMES = { Riding = true, Monte = true }

-- Icônes du jeu, comme la maquette (docs/superpowers/specs/2026-11-16-routeur-integre-maquette.html).
local ICONS = {
  walk = "Interface\\Icons\\INV_Boots_Cloth_03",
  fly = "Interface\\Icons\\Ability_Mount_Gryphon_01",
  boat = "Interface\\Icons\\INV_Misc_Anchor",
  zeppelin = "Interface\\Icons\\INV_Misc_EngGizmos_30",
  tram = "Interface\\Icons\\INV_Misc_Gear_01",
  portal = "Interface\\Icons\\Spell_Arcane_PortalStormWind",
  hearth = "Interface\\Icons\\INV_Misc_Rune_01",
}
Travel.ICONS = ICONS

local CAPTIONS = {
  boat = "NAV_TRAVEL_BOAT", zeppelin = "NAV_TRAVEL_ZEPPELIN", tram = "NAV_TRAVEL_TRAM", portal = "NAV_TRAVEL_PORTAL",
}

-- Le tram relie Stormwind et Ironforge : villes de l'Alliance, interdites à la Horde, bien que la
-- liaison soit neutre dans les données (transport.lua ne lui donne pas de faction).
local KIND_SIDE = { tram = "A" }

-- Cartes de continent interrogées pour les points de vol connus.
local CONTINENT_MAPS = { 1415, 1414 }
-- Faction d'un nœud de C_TaxiMap : 0 neutre, 1 Horde, 2 Alliance.
local NODE_FACTION = { Horde = 1, Alliance = 2 }

local function secret(v) return Q.Util.IsSecret(v) end

---------------------------------------------------------------------------
-- Personnage
---------------------------------------------------------------------------
local function playerSide()
  local f = Q.Player and Q.Player.faction
  if f == "Alliance" then return "A" end
  if f == "Horde" then return "H" end
  return nil
end

local function sideOk(side, mine)
  return side == "N" or (mine ~= nil and side == mine)
end

local function linkOk(l, mine, race)
  if not sideOk(l.side, mine) then return false end
  if KIND_SIDE[l.kind] and not sideOk(KIND_SIDE[l.kind], mine) then return false end
  if l.races then
    for _, r in ipairs(l.races) do if r == race then return true end end
    return false
  end
  return true
end

-- Nom localisé du sort de monte (contient le nom de la compétence dans toutes les langues).
local function ridingSpellName()
  if C_Spell and type(C_Spell.GetSpellInfo) == "function" then
    local ok, info = pcall(C_Spell.GetSpellInfo, RIDING_SPELL)
    if ok and type(info) == "table" and not secret(info.name) and type(info.name) == "string" then return info.name end
  end
  if type(GetSpellInfo) == "function" then
    local ok, name = pcall(GetSpellInfo, RIDING_SPELL)
    if ok and not secret(name) and type(name) == "string" then return name end
  end
  return nil
end

-- Rang de la compétence Monte, nil si illisible.
local function ridingRank()
  if type(GetNumSkillLines) ~= "function" or type(GetSkillLineInfo) ~= "function" then return nil end
  local ok, n = pcall(GetNumSkillLines)
  if not ok or secret(n) or type(n) ~= "number" then return nil end
  local spell = ridingSpellName()
  for i = 1, n do
    local ok2, name, header, _, rank = pcall(GetSkillLineInfo, i)
    if ok2 and not secret(name) and type(name) == "string" and not header and not secret(rank) then
      local riding = RIDING_NAMES[name] or (spell and #name >= 4 and spell:find(name, 1, true) ~= nil)
      if riding and type(rank) == "number" then return rank end
    end
  end
  return nil
end

-- Vitesse de déplacement hors vol (yards/s) : à pied, ou à monture selon la compétence Monte.
function Travel:Speed()
  local rank = ridingRank()
  if rank and rank >= RIDING_JOURNEYMAN then return WALK * MOUNT_FAST end
  if rank and rank >= RIDING_APPRENTICE then return WALK * MOUNT_SLOW end
  return WALK
end

---------------------------------------------------------------------------
-- Points de vol connus : union de deux sources, gardée en cache et rafraîchie à TAXIMAP_OPENED et
-- UI_INFO_MESSAGE.
--   * Q.char.knownTaxi[nodeID] : points vus atteignables sur la carte des vols (Q.Taxi:Nodes, état
--     CURRENT ou REACHABLE) à chaque ouverture ; l'ensemble ne fait que grandir ;
--   * C_TaxiMap.GetTaxiNodesForMap(continent) : un nœud compte seulement si isUndiscovered vaut false
--     (un champ absent ne prouve pas que le point est appris).
---------------------------------------------------------------------------
local STATE_CURRENT, STATE_REACHABLE = 0, 1   -- Enum.FlightPathState
local knownCache, nodeNames
local flightCache = {}

local function readTaxiMap(m, mine, out, names)
  local ok, nodes = pcall(C_TaxiMap.GetTaxiNodesForMap, m)
  if not ok or secret(nodes) or type(nodes) ~= "table" then return end
  for _, n in ipairs(nodes) do
    if type(n) == "table" and not secret(n.isUndiscovered) and n.isUndiscovered == false
       and not secret(n.nodeID) and type(n.nodeID) == "number" then
      local f = not secret(n.faction) and tonumber(n.faction) or nil
      if f == nil or f == 0 or mine == nil or f == mine then
        out[n.nodeID] = true
        if not secret(n.name) and type(n.name) == "string" then names[n.nodeID] = n.name end
      end
    end
  end
end

-- Points de vol mémorisés du personnage (Q.char.knownTaxi), créés au besoin ; nil sans Q.char.
local function recorded(create)
  local c = Q.char
  if type(c) ~= "table" then return nil end
  if type(c.knownTaxi) ~= "table" then
    if not create then return nil end
    c.knownTaxi = {}
  end
  return c.knownTaxi
end

-- -> { [nodeId] = true } (identifiants de TaxiNodes, ceux de Q.TravelData.taxi).
function Travel:KnownTaxi()
  if knownCache then return knownCache end
  local out, names = {}, {}
  for id in pairs(recorded(false) or {}) do
    if type(id) == "number" then out[id] = true end
  end
  if C_TaxiMap and type(C_TaxiMap.GetTaxiNodesForMap) == "function" then
    local mine = NODE_FACTION[Q.Player and Q.Player.faction or ""]
    for _, m in ipairs(CONTINENT_MAPS) do readTaxiMap(m, mine, out, names) end
  end
  knownCache, nodeNames = out, names
  return out
end

-- Carte des vols ouverte : mémorise les points atteignables (avec leur identifiant de TaxiNodes).
function Travel:RecordTaxiMap()
  if not (Q.Taxi and Q.Taxi.Nodes) then return end
  local set
  for _, n in ipairs(Q.Taxi:Nodes()) do
    if n.nodeID and (n.state == STATE_CURRENT or n.state == STATE_REACHABLE) then
      set = set or recorded(true)
      if not set then return end
      set[n.nodeID] = true
    end
  end
end

function Travel:Refresh()
  knownCache, nodeNames = nil, nil
  flightCache = {}
end

-- Durées de vol depuis `src` (secondes, sans le décollage) en passant seulement par des points
-- connus (comme world.flightTime). Gardées en cache jusqu'au prochain rafraîchissement.
local function flightsFrom(src, known)
  local c = flightCache[src]
  if c then return c end
  local edges = Q.TravelData.edges
  local dist, done = { [src] = 0 }, {}
  while true do
    local cur, best
    for id, d in pairs(dist) do
      if not done[id] and (not best or d < best or (d == best and id < cur)) then cur, best = id, d end
    end
    if not cur then break end
    done[cur] = true
    for nb, s in pairs(edges[cur] or {}) do
      if known[nb] then
        local nd = best + s
        if not dist[nb] or nd < dist[nb] then dist[nb] = nd end
      end
    end
  end
  flightCache[src] = dist
  return dist
end

---------------------------------------------------------------------------
-- Géométrie
---------------------------------------------------------------------------
-- Région de marche ; Rut'theran (bas du tronc de Teldrassil) à part ; à défaut, le continent.
local function regionOf(m, x, y, c)
  local T = Q.TravelData
  local rut = T.rut
  if rut and m == rut.m and x >= rut.minX and y >= rut.minY then return "RUT" end
  return T.regions[m] or ("c" .. tostring(c))
end
function Travel:RegionOf(m, x, y)
  local c = Q.Maps:WorldPos(m, x, y)
  if not c then return nil end
  return regionOf(m, x, y, c)
end

-- { mapId, x, y } ou { mapId =, x =, y = } -> point résolu (continent, monde, région) ou nil.
local function point(p)
  if type(p) ~= "table" then return nil end
  local m, x, y = p.mapId or p.m or p[1], p.x or p[2], p.y or p[3]
  if type(m) ~= "number" or type(x) ~= "number" or type(y) ~= "number" then return nil end
  local c, wx, wy = Q.Maps:WorldPos(m, x, y)
  if not c then return nil end
  return { m = m, x = x, y = y, c = c, wx = wx, wy = wy, r = regionOf(m, x, y, c), name = p.name }
end

local function yards(a, b)
  if a.c ~= b.c then return nil end
  local dx, dy = a.wx - b.wx, a.wy - b.wy
  return math.sqrt(dx * dx + dy * dy)
end

-- Points fixes (nœuds de vol triés, quais), résolus une fois.
local static
local function staticPoints()
  if static then return static end
  local T = Q.TravelData
  static = { fms = {}, links = {} }
  local ids = {}
  for id in pairs(T.taxi) do ids[#ids + 1] = id end
  table.sort(ids)
  for _, id in ipairs(ids) do
    local n = T.taxi[id]
    local p = point({ n.m, n.x, n.y })
    if p then p.node, p.side, p.name = id, n.side, n.name; static.fms[#static.fms + 1] = p end
  end
  for _, l in ipairs(T.links) do
    local a, b = point(l.from), point(l.to)
    if a and b then static.links[#static.links + 1] = { l = l, from = a, to = b } end
  end
  return static
end

---------------------------------------------------------------------------
-- Auberges
---------------------------------------------------------------------------
-- Auberges de la faction, apparitions d'un même lieu fusionnées (HEARTH_NEAR, comme sim.hearthInns).
local function factionInns()
  local mine = playerSide()
  local out = {}
  for _, inn in ipairs(Q.TravelData.inns or {}) do
    if sideOk(inn.side, mine) then
      local p = point(inn)
      if p then
        local dup = false
        for _, o in ipairs(out) do
          local d = yards(o, p)
          if d and d <= HEARTH_NEAR then dup = true; break end
        end
        if not dup then out[#out + 1] = p end
      end
    end
  end
  return out
end

-- Auberge désignée par le nom de GetBindLocation : la seule auberge de la faction sur une carte de
-- ce nom. -> mapId, x, y ou nil (aucune ou plusieurs).
function Travel:InnNamed(loc)
  if type(loc) ~= "string" or loc == "" or not Q.TravelData then return nil end
  local found
  for _, p in ipairs(factionInns()) do
    if Q.Maps:MapName(p.m) == loc then
      if found then return nil end
      found = p
    end
  end
  if found then return found.m, found.x, found.y end
  return nil
end

---------------------------------------------------------------------------
-- Plan
---------------------------------------------------------------------------
local function shortName(name)
  if type(name) ~= "string" then return "?" end
  return name:match("^(.-),") or name
end

-- Destination d'une liaison : nom localisé de la carte d'arrivée (client) ; la note anglaise des
-- données (« Take the boat to Auberdine (…) ») seulement si la carte n'a pas de nom.
local function linkTarget(l, to)
  local name = Q.Maps:MapName(to.m)
  if name:sub(1, 1) ~= "#" then return name end
  return type(l.name) == "string" and (l.name:match(" to (.-)%s*%(") or l.name:match(" to (.-)%s*$")) or name
end

local function bindName(inn)
  local ok, loc = pcall(GetBindLocation or function() return nil end)
  if ok and not secret(loc) and type(loc) == "string" and loc ~= "" then return loc end
  return Q.Maps:MapName(inn.m)
end

local function out(p) return { mapId = p.m, x = p.x, y = p.y } end

local function caption(leg, nodeFrom, nodeTo)
  local k = leg.kind
  if k == "walk" then
    if nodeTo.kind == "fm" then return L.NAV_TRAVEL_WALK_FM end
    return string.format(L.NAV_TRAVEL_WALK, nodeTo.name or Q.Maps:MapName(nodeTo.m))
  elseif k == "fly" then
    return string.format(L.NAV_TRAVEL_FLY, shortName(nodeNames and nodeNames[leg.node] or nodeTo.name))
  elseif k == "hearth" then
    return string.format(L.NAV_TRAVEL_HEARTH, bindName(nodeTo))
  end
  return string.format(L[CAPTIONS[k]], linkTarget(nodeFrom.l, nodeTo))
end

function Travel:Plan(from, to)
  local T = Q.TravelData
  if not T then return nil end
  local a, b = point(from), point(to)
  if not a or not b then return nil end
  local speed = self:Speed()
  local mine, race = playerSide(), Q.Player and Q.Player.raceKey
  local known = self:KnownTaxi()
  local overhead = (T.params and T.params.flightOverhead) or FLIGHT_OVERHEAD
  local S = staticPoints()

  a.kind, b.kind = "start", "dest"
  local nodes = { a, b }
  for _, p in ipairs(S.fms) do
    -- point de vol connu, ou à apprendre en y marchant (seulement ceux de la faction)
    if known[p.node] or sideOk(p.side, mine) then
      nodes[#nodes + 1] = setmetatable({ kind = "fm", known = known[p.node] == true }, { __index = p })
    end
  end
  for _, s in ipairs(S.links) do
    if linkOk(s.l, mine, race) then
      local arrive = setmetatable({ kind = "arrive" }, { __index = s.to })
      nodes[#nodes + 1] = arrive
      nodes[#nodes + 1] = setmetatable({ kind = "dock", l = s.l, arrive = arrive }, { __index = s.from })
    end
  end
  local inn
  local left = Q.Hearth and Q.Hearth:Remaining()
  if left == 0 then
    local p = point({ Q.Hearth:BindPos() })
    if p then p.kind = "inn"; inn = p; nodes[#nodes + 1] = p end
  end

  -- Dijkstra (comme sim.route). Tronçon retenu vers v : prevU[v], prevKind[v], prevSec[v].
  local dist, done, prevU, prevKind, prevSec = { [1] = 0 }, {}, {}, {}, {}
  local u, best
  local function relax(v, cost, kind, seconds)
    local nd = best + cost
    if not dist[v] or nd < dist[v] - 1e-9 then
      dist[v], prevU[v], prevKind[v], prevSec[v] = nd, u, kind, seconds
    end
  end
  while true do
    u, best = nil, nil
    for i = 1, #nodes do
      if not done[i] and dist[i] and (not best or dist[i] < best) then u, best = i, dist[i] end
    end
    if not u or u == 2 then break end
    done[u] = true
    local nu = nodes[u]
    local flights = nu.kind == "fm" and flightsFrom(nu.node, known)
    for v = 2, #nodes do
      if not done[v] then
        local nv = nodes[v]
        if nu.r == nv.r and nv.kind ~= "inn" then
          local d = yards(nu, nv)
          if d then relax(v, d / speed, "walk", d / speed) end
        end
        if flights and nv.kind == "fm" and nv.known and nv.node ~= nu.node and flights[nv.node] then
          local ft = flights[nv.node] + overhead
          relax(v, ft + FLY_PENALTY, "fly", ft)
        end
        if nu.kind == "dock" and nv == nu.arrive then relax(v, nu.l.seconds, nu.l.kind, nu.l.seconds) end
        if u == 1 and nv == inn then relax(v, HEARTH_CAST + HEARTH_PENALTY, "hearth", HEARTH_CAST + HEARTH_LOAD) end
      end
    end
  end
  if not dist[2] then return nil end

  local chain, v = {}, 2
  while prevU[v] do
    table.insert(chain, 1, v)
    v = prevU[v]
  end
  local legs = {}
  for _, w in ipairs(chain) do
    local nf, nt = nodes[prevU[w]], nodes[w]
    local leg = { kind = prevKind[w], seconds = prevSec[w], from = out(nf), to = out(nt) }
    if leg.kind == "walk" then leg.yards = yards(nf, nt)
    elseif leg.kind == "fly" then leg.node = nt.node
    elseif leg.kind ~= "hearth" then leg.link = nf.l.id end
    -- marche nulle (départ sur un quai ou un point de vol) : pas d'étape
    if not (leg.kind == "walk" and leg.yards < 1) then
      leg.icon = ICONS[leg.kind]
      leg.caption = caption(leg, nf, nt)
      legs[#legs + 1] = leg
    end
  end
  return legs
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
local function refresh() Travel:Refresh() end
Q:RegisterEvent("TAXIMAP_OPENED", function()
  Travel:RecordTaxiMap()
  refresh()
end)
Q:RegisterEvent("UI_INFO_MESSAGE", refresh)
