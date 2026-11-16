local addonName, Q = ...

-- Pont de marche entre Questify et le routeur intégré (Questify_Nav, chargé à la demande) :
-- spec du routeur intégré, § 2, § 2 bis et § 3 bis.
--
-- À chaque cible (message NAV_TARGET de Nav/Navigation.lua), quand le routeur actif est Questify
-- (Q.Nav:Active()), le voyage est planifié par Q.Travel:Plan (vols, bateaux, pierre…), puis le seul
-- trajet à pied en cours est calculé par le routeur (Questify_NavEngine.Find), du joueur au bout de ce
-- trajet. Les autres trajets sont montrés tels quels (départ, arrivée).
--
--   Q.Walk:Route() -> route | nil
--     route.legs       trajets du planificateur (Nav/Travel.lua), ou une seule marche jusqu'à la cible
--     route.leg        index du trajet en cours
--     route.path       { { instance, x, y } } : chemin du trajet en cours, repère monde (celui de
--                      UnitPosition : x vers le nord, y vers l'ouest ; instance 0 ou 1)
--     route.nextPoint  { instance, x, y } : premier point du chemin à plus de LOOKAHEAD yd du joueur
--     route.straight   vrai quand la flèche pointe en ligne droite (pas de cartes, calcul en cours ou
--                      échoué, combat, joueur dans la grotte de la cible)
--     route.reason     pourquoi en ligne droite (nil sinon) : "computing", "combat", "noaddon",
--                      "noengine", "nodata", "position", "continent", "cave", ou la raison du routeur
--                      ("outside", "offmesh", "unreachable", "error")
--     route.warnings   { { kind = "hostile", name } | { kind = "level", level } } du trajet calculé :
--                      villes hostiles traversées (job.hubs) et zones de la table de danger
--     route.goal       { instance, x, y } : bout du trajet à pied (arrêt de grotte compris)
--     route.target     { mapId, x, y, title } : la cible reçue
--   La table est partagée : on la lit, on ne la modifie pas.
--   Q:Fire("NAV_ROUTE", route | nil) à chaque changement (nouvelle cible, chemin reçu, trajet suivant,
--   retrait) ; nextPoint, lui, suit le joueur à chaque Route() sans message.
--
--   Q.Walk:Status() -> { loaded, maps = { [0] = bool, [1] = bool }, reason, search } (/qf check)
--   Q.Walk:DangerTable(fromMap, toMap) -> { [uiMapID] = 2 | 4 } | nil
--   Q.Walk:Perf() -> { worstMs, avgMs, frames, searches, memKB = { Questify, Questify_Nav } }
--   Q.Walk:ResetPerf()
--
-- Règles : Questify_Nav puis la partie du continent se chargent à la première route, jamais en combat
-- (le chargement construit des dizaines de Mo de chaînes) ; au plus un calcul par seconde, le calcul
-- en cours annulé avant d'en lancer un ; relance quand la cible change, quand le joueur s'écarte de
-- plus de OFF_PATH yd du chemin, à la fin d'un trajet et après un écran de chargement. En combat, le
-- routeur met lui-même ses calculs en pause (Routing/PathJobs.lua) et les reprend après.
local Walk = {}
Q.Walk = Walk

local OFF_PATH = 25          -- yards : au-delà, le chemin est recalculé depuis le joueur
local LOOKAHEAD = 12         -- yards : nextPoint est le premier point du chemin plus loin que ça
local MIN_INTERVAL = 1       -- secondes entre deux calculs (comme la minuterie des grottes)
local CHECK_EVERY = 1        -- secondes : écart au chemin, fin de trajet, arrêts de grotte
local ARRIVE_WALK = 15       -- yards : bout d'un trajet à pied atteint
local ARRIVE_RIDE = 60       -- yards : bout d'un vol, d'un bateau, d'une pierre atteint
local LEVEL_X2, LEVEL_X4 = 5, 10   -- écart de niveau d'une zone : coût ×2, ×4 (style « safe »)
local SAMPLE = 40            -- yards entre deux points testés pour les zones traversées
local ROUTER = "Questify_Nav"
-- Parties des cartes par continent, si QuestifyPathData[instance].part ne les nomme pas.
local PARTS = { [0] = "Questify_Nav_EK", [1] = "Questify_Nav_Kalimdor" }
-- Raisons qui tiennent à l'installation : inutile de relancer un calcul.
local FINAL = { noaddon = true, noengine = true, nodata = true, cave = true }

Walk.OFF_PATH, Walk.LOOKAHEAD = OFF_PATH, LOOKAHEAD

local target          -- dernière cible reçue : { mapId, x, y, title }
local route           -- route publiée, ou nil
local job             -- calcul en cours (handle du routeur)
local lastLaunch = -math.huge
local pending         -- relance retardée : "launch" (prochain calcul) ou "replan" (après chargement)
local timer           -- minuteur de la relance retardée
local ticker          -- minuterie de suivi, tant qu'une route existe
local routerTried     -- chargement de Questify_Nav tenté (une fois)
local loadReason      -- pourquoi le routeur ou les cartes manquent (nil : rien ne manque)
local lastSearch      -- raison du dernier calcul échoué (nil : réussi)
local maps = {}       -- [instance] = true (cartes prêtes) | false (absentes) ; nil : pas encore tenté
local measuredAfter   -- routeur dont la planification par image est mesurée (voir wrapAfter)

local sqrt, huge = math.sqrt, math.huge
local unpack = unpack or table.unpack

---------------------------------------------------------------------------
-- Mesure (spec § 3 bis) : le budget se compte par image. Chaque rappel du pont et chaque tranche du
-- routeur est chronométré (debugprofilestop) ; une mesure imbriquée dans une autre n'est comptée
-- qu'une fois (profondeur) ; les mesures d'une même image (même GetTime(), constant pendant une
-- image) s'additionnent dans un seau, fermé quand l'image change. Pire image et moyenne portent sur
-- les seaux fermés.
---------------------------------------------------------------------------
local perf = { worst = 0, total = 0, frames = 0, searches = 0 }
local depth = 0             -- mesures en cours (seule la plus externe compte)
local bucketKey             -- image du seau ouvert (GetTime), nil : aucun
local bucketMs = 0          -- millisecondes accumulées dans cette image

local function clock() return debugprofilestop and debugprofilestop() or 0 end
local function now() return GetTime and GetTime() or 0 end

local function closeBucket()
  if bucketKey == nil then return end
  perf.frames = perf.frames + 1
  perf.total = perf.total + bucketMs
  if bucketMs > perf.worst then perf.worst = bucketMs end
  bucketKey, bucketMs = nil, 0
end

local function sample(ms)
  if type(ms) ~= "number" or ms < 0 then ms = 0 end
  local key = now()
  if bucketKey ~= key then
    closeBucket()
    bucketKey = key
  end
  bucketMs = bucketMs + ms
end

local function pack(...) return { n = select("#", ...), ... } end

-- fn protégée et mesurée ; renvoie ce que fn renvoie (rien en cas d'erreur).
local function measured(fn)
  return function(...)
    depth = depth + 1
    local t0 = clock()
    local res = pack(Q.SafeCall(fn, ...))
    depth = depth - 1
    if depth == 0 then sample(clock() - t0) end
    if not res[1] then return nil end
    return unpack(res, 2, res.n)
  end
end

-- Le routeur planifie chaque tranche de calcul par Path.after (Routing/PathJobs.lua) : en l'enveloppant
-- une fois, chaque image du routeur est mesurée, sans rien changer à son découpage ni à ses plafonds.
local function wrapAfter(E)
  if measuredAfter == E or type(E.after) ~= "function" then return end
  measuredAfter = E
  local original = E.after
  E.after = function(fn)
    return original(function(...)
      depth = depth + 1
      local t0 = clock()
      local ok, err = pcall(fn, ...)
      depth = depth - 1
      if depth == 0 then sample(clock() - t0) end
      if not ok then error(err, 0) end    -- l'erreur du routeur suit son cours, comme sans mesure
    end)
  end
end

---------------------------------------------------------------------------
-- Personnage et coordonnées
---------------------------------------------------------------------------
local function inCombat() return InCombatLockdown and InCombatLockdown() == true end

local function playerLevel()
  local l = UnitLevel and UnitLevel("player")
  if type(l) == "number" and not Q.Util.IsSecret(l) and l > 0 then return l end
  local P = Q.Player
  return P and tonumber(P.level) or nil
end

local function faction()
  local f = Q.Player and Q.Player.faction
  if f == "Alliance" or f == "Horde" then return f end
  if UnitFactionGroup then
    f = UnitFactionGroup("player")
    if not Q.Util.IsSecret(f) and (f == "Alliance" or f == "Horde") then return f end
  end
  return nil
end

-- Point de carte (mapId, 0-100) -> { instance, x, y } monde, ou nil.
local function worldOf(p)
  if type(p) ~= "table" then return nil end
  local c, X, Y = Q.Maps:WorldPos(p.mapId, p.x, p.y)
  if not c then return nil end
  return { instance = c, x = X, y = Y, mapId = p.mapId }
end

-- Joueur : { instance, x, y, mapId, mx, my } (monde, et carte en 0-100), ou nil.
local function playerWorld()
  local m, x, y = Q.Maps:PlayerPos()
  if not m then return nil end
  local c, X, Y = Q.Maps:WorldPos(m, x, y)
  if not c then return nil end
  return { instance = c, x = X, y = Y, mapId = m, mx = x, my = y }
end

local function dist(a, b)
  local dx, dy = a.x - b.x, a.y - b.y
  return sqrt(dx * dx + dy * dy)
end

local function segDist(a, b, p)
  local dx, dy = b.x - a.x, b.y - a.y
  local l2 = dx * dx + dy * dy
  local t = 0
  if l2 > 0 then
    t = ((p.x - a.x) * dx + (p.y - a.y) * dy) / l2
    if t < 0 then t = 0 elseif t > 1 then t = 1 end
  end
  local ex, ey = a.x + t * dx - p.x, a.y + t * dy - p.y
  return sqrt(ex * ex + ey * ey)
end

---------------------------------------------------------------------------
-- Routeur : chargement à la demande
---------------------------------------------------------------------------
local function engine()
  local E = Questify_NavEngine
  if type(E) == "table" and type(E.Find) == "function" then return E end
  return nil
end

local function loadAddOn(name)
  local load = C_AddOns and C_AddOns.LoadAddOn
  if type(load) ~= "function" then return false end
  local ok, loaded = pcall(load, name)
  return ok and loaded == true
end

-- Routeur prêt pour ce continent ? -> E ou nil, raison.
local function ensureEngine(instance)
  local E = engine()
  if not E then
    if routerTried then return nil, loadReason end
    if inCombat() then
      loadReason = "combat"
      return nil, loadReason
    end
    routerTried = true
    local loaded = loadAddOn(ROUTER)
    E = engine()
    if not E then
      loadReason = loaded and "noengine" or "noaddon"
      return nil, loadReason
    end
  end
  wrapAfter(E)
  if maps[instance] == nil then
    if inCombat() then
      loadReason = "combat"
      return nil, loadReason
    end
    local ok, has = pcall(E.Available, instance)
    if ok and has then
      local D = type(QuestifyPathData) == "table" and QuestifyPathData[instance] or nil
      -- partie nommée par les données ; nom par défaut seulement si les données manquent (cartes
      -- livrées entières : aucune partie à charger)
      local part
      if type(D) == "table" then part = D.part else part = PARTS[instance] end
      if part then loadAddOn(part) end
      ok, has = pcall(E.Available, instance)
      if ok and has and type(E.Resident) == "function" then ok, has = pcall(E.Resident, instance) end
    end
    maps[instance] = ok and has == true
  end
  if not maps[instance] then
    loadReason = "nodata"
    return nil, loadReason
  end
  loadReason = nil
  return E
end

---------------------------------------------------------------------------
-- Danger et avertissements (spec § 2 bis)
---------------------------------------------------------------------------
-- Zones (uiMapID) dont le niveau minimal dépasse celui du joueur d'au moins LEVEL_X2 (×2) ou
-- LEVEL_X4 (×4), sans les zones de départ et d'arrivée ; nil quand il n'y en a aucune.
function Walk:DangerTable(fromMap, toMap)
  local levels = Q.TravelData and Q.TravelData.zoneLevels
  local lvl = playerLevel()
  if type(levels) ~= "table" or not lvl then return nil end
  local out
  for id, min in pairs(levels) do
    if id ~= fromMap and id ~= toMap and type(min) == "number" then
      local gap = min - lvl
      local mult = (gap >= LEVEL_X4 and 4) or (gap >= LEVEL_X2 and 2) or nil
      if mult then
        out = out or {}
        out[id] = mult
      end
    end
  end
  return out
end

local function areaName(hub)
  local id = hub.areaId
  if id and C_Map and C_Map.GetAreaInfo then
    local ok, name = pcall(C_Map.GetAreaInfo, id)
    if ok and type(name) == "string" and name ~= "" and not Q.Util.IsSecret(name) then return name end
  end
  return hub.name
end

-- Villes hostiles (job.hubs, dans l'ordre du chemin) puis zones de la table de danger traversées,
-- chacune une fois. Les zones sont lues tous les SAMPLE yd le long du chemin (Path.ZoneAt).
local function warningsOf(E, j, path, danger)
  local out = {}
  for _, h in ipairs(type(j.hubs) == "table" and j.hubs or {}) do
    if type(h) == "table" then out[#out + 1] = { kind = "hostile", name = areaName(h) } end
  end
  if not (danger and type(E.ZoneAt) == "function") then return out end
  local levels = Q.TravelData and Q.TravelData.zoneLevels or {}
  local seen = {}
  local function probe(instance, x, y)
    local ok, zone = pcall(E.ZoneAt, instance, x, y)
    if ok and zone and danger[zone] and not seen[zone] then
      seen[zone] = true
      out[#out + 1] = { kind = "level", level = levels[zone] }
    end
  end
  for i, p in ipairs(path) do
    probe(p.instance, p.x, p.y)
    local b = path[i + 1]
    if b then
      local n = math.floor(dist(p, b) / SAMPLE)
      for k = 1, n do
        local t = k / (n + 1)
        probe(p.instance, p.x + (b.x - p.x) * t, p.y + (b.y - p.y) * t)
      end
    end
  end
  return out
end

-- Options du routeur selon nav.routeStyle : « safe » = balanced + faction + danger.
local function options(fromMap, toMap)
  local style = Q.Settings:Get("nav.routeStyle")
  local profile = faction()
  if style == "fastest" or style == "roads" then return { profile = profile, style = style } end
  return { profile = profile, style = "balanced", danger = Walk:DangerTable(fromMap, toMap) }
end

---------------------------------------------------------------------------
-- Route
---------------------------------------------------------------------------
local function active()
  local N = Q.Nav
  if not (N and N.Active) then return false end
  return N:Active() == "questify"
end

local function publish() Q:Fire("NAV_ROUTE", route) end

local function cancelJob()
  local j = job
  job = nil
  if not j then return end
  local E = engine()
  if E and type(E.Cancel) == "function" then pcall(E.Cancel, j) end
end

local function stopTimer()
  if timer then timer:Cancel() end
  timer, pending = nil, nil
end

-- Plan du voyage (Nav/Travel.lua), sinon une seule marche jusqu'à la cible.
local function plan(t, me)
  local T = Q.Travel
  if me and T and T.Plan then
    local ok, legs = Q.SafeCall(T.Plan, T, { mapId = me.mapId, x = me.mx, y = me.my },
      { mapId = t.mapId, x = t.x, y = t.y })
    if ok and type(legs) == "table" and #legs > 0 then return legs end
  end
  local icons = T and T.ICONS
  return { {
    kind = "walk", to = { mapId = t.mapId, x = t.x, y = t.y },
    from = me and { mapId = me.mapId, x = me.mx, y = me.my } or nil,
    caption = t.title, icon = icons and icons.walk,
  } }
end

-- Bout du trajet à pied en cours : son arrivée, ou l'arrêt de grotte (Nav/Caves.lua) à rejoindre
-- d'abord, comme Navigation le fait pour les autres fournisseurs : sortir de la grotte où est le
-- joueur, puis, au dernier trajet, entrer dans celle de la cible. Dans la grotte de la cible, la
-- flèche directe (direct) : le routeur ne sait pas à quel étage est la cible. Le plan est celui que
-- Navigation tient à jour (Nav:CavePlan) : Caves:Plan change l'état du joueur, on ne l'appelle pas ici.
local function walkGoal(r)
  local L = r.legs[r.leg]
  local last = r.leg == #r.legs
  local N = Q.Nav
  local cave = N and N.CavePlan and N:CavePlan() or nil
  if cave then
    if cave.direct and last then
      local g = worldOf(target)
      if g then g.direct = true end
      return g
    end
    local s = cave.stops and cave.stops[1]
    if s and (s.kind == "exit" or last) then
      local g = worldOf(s)
      if g then g.cave = s.kind end
      return g
    end
  end
  return worldOf(L.to)
end

local function sameGoal(a, b)
  if not a or not b then return a == b end
  return a.instance == b.instance and math.abs(a.x - b.x) < 1 and math.abs(a.y - b.y) < 1
    and a.direct == b.direct
end

-- Ligne droite vers le bout du trajet en cours.
local function straight(reason)
  local r = route
  if not r then return end
  r.straight, r.reason, r.warnings = true, reason, {}
  r.path = r.goal and { r.goal } or {}
  r.nextPoint = r.goal
  r.origin = playerWorld()
end

local launch

-- Un calcul pour le trajet à pied en cours : tout de suite, ou à la seconde suivante au plus tôt.
local function request()
  if not route then return end
  if pending == "replan" then return end
  local wait = lastLaunch + MIN_INTERVAL - now()
  if wait <= 0 then
    launch()
    return
  end
  if pending == "launch" then return end
  pending = "launch"
  timer = C_Timer.NewTimer(wait, measured(function()
    timer = nil
    if pending == "launch" then
      pending = nil
      launch()
    end
  end))
end

-- warnDanger : table de danger des avertissements, gardée ici (jamais dans le job du routeur, qui lit
-- job.danger au début du calcul).
local function onResult(points, cost, j, warnDanger)
  if j ~= job or not route then return end
  job = nil
  local r = route
  r.computing = nil
  if type(points) ~= "table" or #points == 0 then
    lastSearch = type(cost) == "string" and cost or "error"
    straight(lastSearch)
    publish()
    return
  end
  lastSearch = nil
  local path = {}
  for i, p in ipairs(points) do
    path[i] = { instance = p.map or j.map, x = p.x, y = p.y }
  end
  r.path, r.straight, r.reason = path, false, nil
  local E = engine()
  r.warnings = E and warningsOf(E, j, path, warnDanger) or {}
  r.yards = j.yards
  r.origin = nil
  r.nextPoint = path[#path]
  Walk:Route()      -- nextPoint depuis la position du joueur
  publish()
end

launch = function()
  local r = route
  if not r then return end
  local L = r.legs[r.leg]
  if not (L and L.kind == "walk") then return end
  cancelJob()
  r.goal = walkGoal(r)
  local me = playerWorld()
  if not r.goal then
    straight("position")
    publish()
    return
  end
  if r.goal.direct then
    straight("cave")
    publish()
    return
  end
  if not me then
    straight("position")
    publish()
    return
  end
  if me.instance ~= r.goal.instance then
    straight("continent")
    publish()
    return
  end
  local E, reason = ensureEngine(me.instance)
  if not E then
    straight(reason or "nodata")
    publish()
    return
  end
  local opts = options(me.mapId, r.goal.mapId or target.mapId)
  -- avertissements de niveau : la table de danger, quel que soit le style
  local danger = opts.danger or Walk:DangerTable(me.mapId, r.goal.mapId or target.mapId)
  lastLaunch = now()
  perf.searches = perf.searches + 1
  local cb = measured(onResult)
  local j = E.Find(me.instance, { x = me.x, y = me.y }, { x = r.goal.x, y = r.goal.y },
    function(points, cost, jj) cb(points, cost, jj, danger) end, opts)
  if type(j) ~= "table" then
    straight("error")
    publish()
    return
  end
  j.urgent = true      -- le trajet que suit la flèche passe avant tout autre calcul (PathJobs.lua)
  job = j
  r.computing = true
  -- un chemin déjà reçu reste affiché jusqu'au nouveau ; sinon, ligne droite en attendant
  if r.straight then r.reason = "computing" end
end

local tick

local function startTicker()
  if ticker then return end
  ticker = Q:NewTicker(CHECK_EVERY, measured(function() tick() end))
end

local function stopTicker()
  if ticker then ticker:Cancel() end
  ticker = nil
end

-- Route du trajet `index` des legs (nouvelle table, publiée).
local function startLeg(legs, index)
  cancelJob()
  local L = legs[index]
  local r = { legs = legs, leg = index, target = target, warnings = {}, path = {}, straight = true }
  route = r
  startTicker()
  if L.kind == "walk" then
    r.goal = walkGoal(r)
    straight("computing")
    publish()
    request()
    return
  end
  -- vol, bateau, zeppelin, tram, portail, pierre : montrés tels quels
  local a, b = worldOf(L.from), worldOf(L.to)
  r.goal = b
  r.path = {}
  if a then r.path[#r.path + 1] = a end
  if b then r.path[#r.path + 1] = b end
  r.straight, r.reason = false, nil
  r.nextPoint = a or b
  publish()
end

local function replan()
  stopTimer()
  cancelJob()
  if not (target and active()) then return end
  local me = playerWorld()
  startLeg(plan(target, me), 1)
end

-- Plus de route : calcul annulé, minuteries arrêtées, NAV_ROUTE nil si une route était publiée.
local function reset()
  stopTimer()
  cancelJob()
  stopTicker()
  local had = route ~= nil
  route = nil
  if had then publish() end
end

-- Chaque seconde : fin du trajet en cours, arrêt de grotte changé, écart au chemin.
tick = function()
  local r = route
  if not r then
    stopTicker()
    return
  end
  local me = playerWorld()
  local L = r.legs[r.leg]
  if me and L and r.leg < #r.legs then
    local to = worldOf(L.to)
    local near = L.kind == "walk" and ARRIVE_WALK or ARRIVE_RIDE
    if to and to.instance == me.instance and dist(me, to) <= near then
      startLeg(r.legs, r.leg + 1)
      return
    end
  end
  if not (L and L.kind == "walk") then return end
  local goal = walkGoal(r)
  if not sameGoal(goal, r.goal) then
    r.goal = goal
    cancelJob()
    request()
    return
  end
  if job or pending or not me then return end
  if r.straight then
    if FINAL[r.reason] or r.reason == "combat" then return end
    -- calcul échoué ou impossible : relancé quand le joueur s'est déplacé
    if not r.origin or r.origin.instance ~= me.instance or dist(me, r.origin) > OFF_PATH then request() end
    return
  end
  Walk:Route()
  if r.offPath and r.offPath > OFF_PATH then request() end
end

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------
-- nextPoint (et l'écart au chemin, r.offPath) depuis la position du joueur.
local function follow()
  local r = route
  if not r then return nil end
  local path = r.path
  local n = path and #path or 0
  if r.straight or n < 2 then return r end
  local me = playerWorld()
  if not me or me.instance ~= path[1].instance then return r end
  local L = r.legs[r.leg]
  if not (L and L.kind == "walk") then
    r.nextPoint = dist(me, path[1]) > ARRIVE_RIDE and path[1] or path[n]
    return r
  end
  -- segment le plus proche (le plus avancé à égalité), puis premier point au-delà de LOOKAHEAD
  local bestI, bestD = 1, huge
  for i = 1, n - 1 do
    local d = segDist(path[i], path[i + 1], me)
    if d <= bestD then bestI, bestD = i, d end
  end
  r.offPath = bestD
  for k = bestI + 1, n do
    if dist(path[k], me) > LOOKAHEAD then
      r.nextPoint = path[k]
      return r
    end
  end
  r.nextPoint = path[n]
  return r
end
local followMeasured = measured(follow)
function Walk:Route() return followMeasured() end

function Walk:Status()
  return {
    loaded = engine() ~= nil,
    maps = { [0] = maps[0] == true, [1] = maps[1] == true },
    reason = loadReason,
    search = lastSearch,
  }
end

function Walk:Perf()
  -- l'image du seau ouvert est finie si le temps a changé
  if bucketKey ~= nil and bucketKey ~= now() then closeBucket() end
  local mem = {}
  local update = (C_AddOns and C_AddOns.UpdateAddOnMemoryUsage) or UpdateAddOnMemoryUsage
  local get = (C_AddOns and C_AddOns.GetAddOnMemoryUsage) or GetAddOnMemoryUsage
  if type(update) == "function" then pcall(update) end
  for _, name in ipairs({ addonName, ROUTER }) do
    local ok, kb = false, nil
    if type(get) == "function" then ok, kb = pcall(get, name) end
    mem[name] = ok and tonumber(kb) or 0
  end
  if addonName ~= "Questify" then mem.Questify = mem[addonName] end
  return {
    worstMs = perf.worst,
    avgMs = perf.frames > 0 and perf.total / perf.frames or 0,
    frames = perf.frames,
    searches = perf.searches,
    memKB = mem,
  }
end

function Walk:ResetPerf()
  perf.worst, perf.total, perf.frames, perf.searches = 0, 0, 0, 0
  bucketKey, bucketMs = nil, 0
end

---------------------------------------------------------------------------
-- Messages et évènements
---------------------------------------------------------------------------
Q:On("NAV_TARGET", measured(function(t)
  if not (t and active()) then
    target = nil
    reset()
    return
  end
  target = { mapId = t.mapId, x = t.x, y = t.y, title = t.title }
  replan()
end))

-- Routeur changé : Navigation annonce de nouveau la cible (NAV_TARGET). Style changé : le trajet à
-- pied en cours est recalculé avec les nouvelles options.
Q:On("SETTINGS_CHANGED", measured(function(path)
  if path == "nav" or path == "nav.router" then
    if not active() then reset() end
  end
  if (path == "nav" or path == "nav.routeStyle") and route and active() then
    local L = route.legs[route.leg]
    if L and L.kind == "walk" then
      cancelJob()
      request()
    end
  end
end))

-- Fin du combat : le chargement refusé en combat est retenté.
Q:On("COMBAT_ENDED", measured(function()
  if route and route.straight and route.reason == "combat" then request() end
end))

-- Écran de chargement (bateau, portail, pierre, instance) : le calcul en cours est annulé, la route
-- retirée, puis tout est replanifié depuis la nouvelle position une seconde plus tard.
Q:RegisterEvent("PLAYER_ENTERING_WORLD", measured(function()
  if not route and not target then return end
  stopTimer()
  cancelJob()
  local had = route ~= nil
  route = nil
  if had then publish() end
  if not target then return end
  pending = "replan"
  timer = C_Timer.NewTimer(MIN_INTERVAL, measured(function()
    timer = nil
    if pending == "replan" then
      pending = nil
      replan()
    end
  end))
end))
