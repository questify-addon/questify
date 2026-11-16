local addonName, Q = ...

-- Ligne de route sur la carte du monde et la minicarte (spec du routeur intégré, § 4 ; maquette
-- validée : docs/superpowers/specs/2026-11-16-routeur-integre-maquette.html, bloc « Ligne de route »).
--
-- Des points posés par HereBeDragons-Pins-2.0 (Libs\HereBeDragons, clé REF) tous les SPACING yards :
--   * le long du chemin du trajet en cours (route.path du pont de marche, Nav/Walk.lua), ou d'une
--     ligne droite du joueur au bout du trajet quand la route est en ligne droite ;
--   * le long des trajets suivants, du départ à l'arrivée : marche au style choisi ; vol, bateau,
--     zeppelin, tram en tirets fins quel que soit le style (maquette : « le vol entre deux maîtres
--     de vol est un trait en pointillés fins ») ; ni portail ni pierre (téléportations), ni trajet
--     d'un continent à l'autre.
-- Styles (nav.lineStyle) : dots (défaut) points ronds tous les 12 yd ; solid points serrés tous les
-- 4 yd qui se touchent ; dashes tirets tous les 10 yd, tournés par SetRotation le long du segment.
-- Couleur : rôle title du thème du suivi (theme.text.accent s'il existe), éclairci quand il est trop
-- sombre pour se lire sur la carte (parchemin), comme dans la maquette. Aucune autre couleur.
--
-- Tracée seulement avec le routeur Questify (Q.Nav:Active() == "questify"), quel que soit
-- l'affichage ; jamais avec Shortest Path Forever, qui dessine la sienne.
--
-- Coût (spec § 3 bis) : les points sont calculés à chaque NAV_ROUTE et au changement de style, pas à
-- chaque image. Ensuite, toutes les CHECK_EVERY s, l'avancée du joueur le long du chemin retire les
-- points dépassés (un par un) et la minicarte reprend les MAX_MINIMAP points les plus proches quand
-- le joueur a bougé. Au plus MAX_PINS repères sur la carte du monde (les premiers devant le joueur),
-- MAX_MINIMAP sur la minicarte (sur le continent du joueur seulement). Cadres réutilisés (réserves).
--
-- Repères : HereBeDragons compte ses coordonnées monde comme UnitPosition inversé (x vers l'ouest,
-- y vers le nord : HBD:GetPlayerWorldPosition lit « local y, x = UnitPosition ») ; route.path et
-- Q.Maps:WorldPos donnent x vers le nord, y vers l'ouest. Les deux sont donc échangés à la pose.
--
--   Q.RouteLine:Refresh()   recalcule et repose tout (route reçue, style, routeur)
--   Q.RouteLine:Clear()     retire tout
--   Q.RouteLine:Color()     { r, g, b } de la ligne
--   Q.RouteLine:State()     { style, points, first, world, minimap } (tests, /qf)
Q.UI = Q.UI or {}
local RouteLine = {}
Q.RouteLine = RouteLine
Q.UI.RouteLine = RouteLine

local REF = "Questify_RouteLine"   -- clé de nos repères chez HereBeDragons-Pins
local SPACING = { dots = 12, solid = 4, dashes = 10 }   -- yards entre deux points, par style
local RIDE_SPACING = 12            -- yards entre deux tirets fins d'un vol, bateau…
local MAX_PINS = 400               -- repères sur la carte du monde
local MAX_MINIMAP = 60             -- repères sur la minicarte
local MAX_POINTS = 4000            -- points calculés au plus pour une route
local MINI_RANGE = 400             -- yards : au-delà, un point n'est pas proposé à la minicarte
local MINI_MOVE = 10               -- yards de déplacement avant de refaire la minicarte
local CHECK_EVERY = 0.5            -- secondes entre deux relevés de l'avancée du joueur
local MIN_BRIGHT = 0.48            -- canal le plus fort de la couleur au moins à ce niveau (lisible)
local RIDE_ALPHA = 0.9

-- Trajets montrés en tirets fins (les autres non marchés : téléportations, pas de ligne).
local RIDES = { fly = true, boat = true, zeppelin = true, tram = true }

local DOT_TEXTURE = "Interface\\CharacterFrame\\TempPortraitAlphaMask"   -- disque blanc
local SQUARE_TEXTURE = "Interface\\Buttons\\WHITE8X8"

-- Taille des marques en pixels { largeur, hauteur } (maquette : trait 3,2, points 4,4, tirets
-- 10 sur 3,2, vol 3 sur 3,2), un peu plus petites sur la minicarte.
local SIZES = {
  dots = { world = { 5, 5 }, mini = { 4, 4 } },
  solid = { world = { 4, 4 }, mini = { 3.5, 3.5 } },
  dashes = { world = { 7, 3 }, mini = { 6, 2.5 } },
  ride = { world = { 4, 2.5 }, mini = { 3.5, 2 } },
}

local sqrt, huge, max, min = math.sqrt, math.huge, math.max, math.min
local atan2 = math.atan2 or math.atan

---------------------------------------------------------------------------
-- État
---------------------------------------------------------------------------
local route            -- dernière route reçue (NAV_ROUTE), lue sans la modifier
local style = "dots"   -- style du dernier calcul
-- Points calculés (tableaux à plat, réutilisés) : instance, x (nord), y (ouest), angle à l'écran,
-- abscisse le long du trajet en cours (huge pour les trajets suivants), genre ("line" | "ride").
local ptI, ptX, ptY, ptA, ptS, ptK = {}, {}, {}, {}, {}, {}
local count = 0
local first = 1        -- premier point non dépassé
local worldLast = 0    -- dernier point posé sur la carte du monde
local worldPins = {}   -- [index du point] = cadre
local miniPins = {}    -- cadres posés sur la minicarte
-- Trajet en cours : polyligne { { instance, x, y } } et abscisses cumulées, avancée du joueur.
local poly, cum
local progress = 0
local miniAt           -- { instance, x, y } du joueur au dernier calcul de la minicarte
local ticker

---------------------------------------------------------------------------
-- Outils
---------------------------------------------------------------------------
-- Bibliothèque HereBeDragons-Pins-2.0, ou nil si elle ne s'est pas chargée.
local function hbdPins()
  local stub = LibStub
  if type(stub) ~= "table" or type(stub.GetLibrary) ~= "function" then return nil end
  local ok, lib = pcall(stub.GetLibrary, stub, "HereBeDragons-Pins-2.0", true)
  if ok and type(lib) == "table" and type(lib.AddWorldMapIconWorld) == "function"
    and type(lib.AddMinimapIconWorld) == "function" then
    return lib
  end
  return nil
end

-- Appel protégé d'une fonction de la bibliothèque : -> résultat, ou nil (erreur signalée).
local function call(fn, ...)
  local ok, res = pcall(fn, ...)
  if not ok then
    Q:ReportError("RouteLine: " .. tostring(res))
    return nil
  end
  return res
end

-- Le routeur Questify calcule-t-il ? (jamais avec SPF ni sans routeur)
local function drawable()
  local N = Q.Nav
  return N ~= nil and type(N.Active) == "function" and N:Active() == "questify"
end

local function currentStyle()
  local s = Q.Settings:Get("nav.lineStyle")
  if SPACING[s] then return s end
  return "dots"
end

local function worldOf(p)
  if type(p) ~= "table" then return nil end
  local c, X, Y = Q.Maps:WorldPos(p.mapId, p.x, p.y)
  if not c then return nil end
  return { instance = c, x = X, y = Y }
end

local function playerWorld()
  local m, x, y = Q.Maps:PlayerPos()
  if not m then return nil end
  local c, X, Y = Q.Maps:WorldPos(m, x, y)
  if not c then return nil end
  return { instance = c, x = X, y = Y }
end

local function rotatingMinimap()
  return type(GetCVar) == "function" and GetCVar("rotateMinimap") == "1"
end

---------------------------------------------------------------------------
-- Couleur
---------------------------------------------------------------------------
function RouteLine:Color()
  local T = Q.Themes
  local theme = T:Current()
  local c = (theme and theme.text and theme.text.accent) or T:TextColor("title", theme)
  local r, g, b = c[1], c[2], c[3]
  local m = max(r, g, b)
  if m > 0 and m < MIN_BRIGHT then
    local k = MIN_BRIGHT / m
    r, g, b = r * k, g * k, b * k
  end
  return { r, g, b }
end

---------------------------------------------------------------------------
-- Cadres (une réserve pour la carte du monde, une pour la minicarte)
---------------------------------------------------------------------------
local free = { world = {}, mini = {} }

local function acquire(where)
  local list = free[where]
  local f = list[#list]
  if f then
    list[#list] = nil
    return f
  end
  f = CreateFrame("Frame", nil, UIParent)
  f:Hide()
  f:EnableMouse(false)
  f.tex = f:CreateTexture(nil, "OVERLAY")
  f.tex:SetPoint("CENTER", f, "CENTER", 0, 0)
  return f
end

local function release(where, f)
  f:Hide()
  local list = free[where]
  list[#list + 1] = f
end

-- Apparence du repère du point i (style, genre, couleur, angle).
local function dress(f, i, where, color)
  local kind = ptK[i]
  local look = kind == "ride" and "ride" or style
  local size = SIZES[look][where]
  local w, h = size[1], size[2]
  local tex = f.tex
  local round = look == "dots" or look == "solid"
  if not round and where == "mini" and rotatingMinimap() then
    -- minicarte qui tourne : l'angle changerait avec le joueur, un point rond à la place
    round, w = true, h
  end
  if round then
    tex:SetTexture(DOT_TEXTURE)
    tex:SetRotation(0)
  else
    tex:SetTexture(SQUARE_TEXTURE)
    tex:SetRotation(ptA[i])
  end
  tex:SetSize(w, h)
  tex:SetVertexColor(color[1], color[2], color[3], kind == "ride" and RIDE_ALPHA or 1)
  f:SetSize(max(w, h), max(w, h))
  f.kind = kind
end

---------------------------------------------------------------------------
-- Points
---------------------------------------------------------------------------
local function push(inst, x, y, angle, s, kind)
  count = count + 1
  ptI[count], ptX[count], ptY[count], ptA[count], ptS[count], ptK[count] = inst, x, y, angle, s, kind
end

-- Points tous les `spacing` yards le long d'une polyligne (segments d'un continent à l'autre
-- sautés). track : abscisses gardées (trajet en cours), sinon huge. -> abscisses cumulées.
local function sample(points, spacing, kind, track)
  local acc = { 0 }
  local total, nextAt = 0, 0
  for k = 1, #points - 1 do
    local a, b = points[k], points[k + 1]
    local dx, dy = b.x - a.x, b.y - a.y
    local len = sqrt(dx * dx + dy * dy)
    if a.instance == b.instance and len > 0 then
      -- à l'écran : droite = est (-y), haut = nord (+x)
      local angle = atan2(dx, -dy)
      while nextAt <= total + len and count < MAX_POINTS do
        local t = (nextAt - total) / len
        push(a.instance, a.x + dx * t, a.y + dy * t, angle, track and nextAt or huge, kind)
        nextAt = nextAt + spacing
      end
    else
      len = 0
    end
    total = total + len
    acc[k + 1] = total
  end
  return acc
end

-- Polyligne du trajet en cours, ou nil.
local function currentPoly(r, L)
  local path = r.path
  if type(path) ~= "table" then return nil end
  if L.kind == "walk" then
    if not r.straight and #path >= 2 then return path end
    -- ligne droite : du joueur au bout du trajet
    local goal = path[#path] or r.goal
    local me = playerWorld()
    if goal and me and me.instance == goal.instance then return { me, goal } end
    return nil
  end
  if RIDES[L.kind] and #path >= 2 then return path end
  return nil
end

local function build(r)
  count, first, progress = 0, 1, 0
  poly, cum = nil, nil
  style = currentStyle()
  local legs = r.legs
  local index = r.leg or 1
  if type(legs) ~= "table" then return end
  local L = legs[index]
  if type(L) == "table" then
    poly = currentPoly(r, L)
    if poly then
      cum = sample(poly, RIDES[L.kind] and RIDE_SPACING or SPACING[style], RIDES[L.kind] and "ride" or "line", true)
    end
  end
  for k = index + 1, #legs do
    local N = legs[k]
    if type(N) == "table" and (N.kind == "walk" or RIDES[N.kind]) then
      local a, b = worldOf(N.from), worldOf(N.to)
      if a and b and a.instance == b.instance then
        if N.kind == "walk" then
          sample({ a, b }, SPACING[style], "line", false)
        else
          sample({ a, b }, RIDE_SPACING, "ride", false)
        end
      end
    end
  end
end

-- Avancée du joueur le long du trajet en cours (yards), jamais en arrière.
local function measure(me)
  if not (poly and cum and me) then return progress end
  local bestD, bestS = huge, nil
  for k = 1, #poly - 1 do
    local a, b = poly[k], poly[k + 1]
    if a.instance == me.instance and b.instance == me.instance then
      local dx, dy = b.x - a.x, b.y - a.y
      local l2 = dx * dx + dy * dy
      local t = 0
      if l2 > 0 then t = max(0, min(1, ((me.x - a.x) * dx + (me.y - a.y) * dy) / l2)) end
      local px, py = a.x + dx * t - me.x, a.y + dy * t - me.y
      local d = px * px + py * py
      if d < bestD then bestD, bestS = d, cum[k] + t * sqrt(l2) end
    end
  end
  if bestS and bestS > progress then progress = bestS end
  return progress
end

---------------------------------------------------------------------------
-- Pose
---------------------------------------------------------------------------
local function placeWorld(lib, i, color)
  local f = acquire("world")
  dress(f, i, "world", color)
  -- HereBeDragons : x vers l'ouest, y vers le nord
  local ok = call(lib.AddWorldMapIconWorld, lib, REF, f, ptI[i], ptY[i], ptX[i],
    HBD_PINS_WORLDMAP_SHOW_CONTINENT or 2)
  if ok then
    worldPins[i] = f
  else
    release("world", f)
  end
end

local function removeWorld(lib, i)
  local f = worldPins[i]
  if not f then return end
  worldPins[i] = nil
  if type(lib.RemoveWorldMapIcon) == "function" then call(lib.RemoveWorldMapIcon, lib, REF, f) end
  release("world", f)
end

-- Fenêtre de la carte du monde : points first .. first + MAX_PINS - 1.
local function syncWorld(lib, color)
  local last = min(count, first + MAX_PINS - 1)
  for i = worldLast + 1, last do
    if i >= first then placeWorld(lib, i, color) end
  end
  worldLast = max(worldLast, last)
end

local candI, candD = {}, {}
local function byDistance(a, b) return candD[a] < candD[b] end

-- Minicarte : les MAX_MINIMAP points non dépassés les plus proches, sur le continent du joueur.
local function syncMinimap(lib, me, color)
  if type(lib.RemoveAllMinimapIcons) == "function" then call(lib.RemoveAllMinimapIcons, lib, REF) end
  for k = #miniPins, 1, -1 do
    release("mini", miniPins[k])
    miniPins[k] = nil
  end
  miniAt = me
  if not me then return end
  local n = 0
  local range2 = MINI_RANGE * MINI_RANGE
  for i = first, count do
    if ptI[i] == me.instance then
      local dx, dy = ptX[i] - me.x, ptY[i] - me.y
      local d = dx * dx + dy * dy
      if d <= range2 then
        n = n + 1
        candI[n], candD[i] = i, d
      end
    end
  end
  for k = #candI, n + 1, -1 do candI[k] = nil end
  table.sort(candI, byDistance)
  for k = 1, min(n, MAX_MINIMAP) do
    local i = candI[k]
    local f = acquire("mini")
    dress(f, i, "mini", color)
    if call(lib.AddMinimapIconWorld, lib, REF, f, ptI[i], ptY[i], ptX[i], false) then
      miniPins[#miniPins + 1] = f
    else
      release("mini", f)
    end
  end
  for k = 1, n do candD[candI[k]] = nil end
end

-- Points dépassés retirés, fenêtre de la carte avancée, minicarte refaite si le joueur a bougé.
local function follow(force)
  local lib = hbdPins()
  if not lib or count == 0 then return end
  local me = playerWorld()
  local color
  local at = measure(me)
  local newFirst = first
  while newFirst <= count and ptS[newFirst] < at do newFirst = newFirst + 1 end
  local advanced = newFirst > first
  if advanced then
    for i = first, newFirst - 1 do removeWorld(lib, i) end
    first = newFirst
    color = RouteLine:Color()
    syncWorld(lib, color)
  end
  local moved = force or advanced or not miniAt or not me or miniAt.instance ~= me.instance
  if not moved then
    local dx, dy = me.x - miniAt.x, me.y - miniAt.y
    moved = dx * dx + dy * dy >= MINI_MOVE * MINI_MOVE
  end
  if moved then syncMinimap(lib, me, color or RouteLine:Color()) end
end

local function stopTicker()
  if ticker then ticker:Cancel() end
  ticker = nil
end

local function startTicker()
  if ticker then return end
  ticker = Q:NewTicker(CHECK_EVERY, function() follow(false) end)
end

---------------------------------------------------------------------------
-- API
---------------------------------------------------------------------------
function RouteLine:Clear()
  stopTicker()
  local lib = hbdPins()
  if lib then
    if type(lib.RemoveAllWorldMapIcons) == "function" then call(lib.RemoveAllWorldMapIcons, lib, REF) end
    if type(lib.RemoveAllMinimapIcons) == "function" then call(lib.RemoveAllMinimapIcons, lib, REF) end
  end
  for i, f in pairs(worldPins) do
    worldPins[i] = nil
    release("world", f)
  end
  for k = #miniPins, 1, -1 do
    release("mini", miniPins[k])
    miniPins[k] = nil
  end
  count, first, worldLast, progress = 0, 1, 0, 0
  poly, cum, miniAt = nil, nil, nil
end

function RouteLine:Refresh()
  self:Clear()
  if type(route) ~= "table" or not drawable() then return end
  local lib = hbdPins()
  if not lib then return end
  build(route)
  if count == 0 then return end
  -- points déjà dépassés (chemin parti d'avant la position actuelle) retirés avant la pose
  local at = measure(playerWorld())
  while first <= count and ptS[first] < at do first = first + 1 end
  worldLast = first - 1
  local color = self:Color()
  syncWorld(lib, color)
  syncMinimap(lib, playerWorld(), color)
  startTicker()
end

-- Couleur du thème reprise sur les repères posés, sans les reposer.
function RouteLine:Recolor()
  local color = self:Color()
  for i, f in pairs(worldPins) do dress(f, i, "world", color) end
  -- minicarte : l'index du point n'est pas gardé, la couleur seule change
  for _, f in ipairs(miniPins) do
    local _, _, _, a = f.tex:GetVertexColor()
    f.tex:SetVertexColor(color[1], color[2], color[3], a)
  end
end

function RouteLine:State()
  local w = 0
  for _ in pairs(worldPins) do w = w + 1 end
  return { style = style, points = count, first = first, world = w, minimap = #miniPins }
end

---------------------------------------------------------------------------
-- Messages
---------------------------------------------------------------------------
Q:On("NAV_ROUTE", function(r)
  route = type(r) == "table" and r or nil
  RouteLine:Refresh()
end)

local REDRAW = { nav = true, ["nav.lineStyle"] = true, ["nav.router"] = true, ["nav.display"] = true }
local RECOLOR = { tracker = true, ["tracker.theme"] = true }
Q:On("SETTINGS_CHANGED", function(path)
  if path == nil or REDRAW[path] then
    RouteLine:Refresh()
  elseif RECOLOR[path] then
    RouteLine:Recolor()
  end
end)

-- Écran de chargement : la minicarte suit le continent du joueur.
Q:RegisterEvent("PLAYER_ENTERING_WORLD", function()
  if count > 0 then Q.SafeCall(follow, true) end
end)
