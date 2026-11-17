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
-- sombre pour se lire sur la carte (parchemin), comme dans la maquette. Sous chaque marque, un halo
-- sombre un peu plus grand (maquette : .halo, noir à 2/3), posé comme un repère à part à un niveau
-- plus bas que toutes les marques, pour qu'aucun halo ne couvre la marque voisine.
--
-- Tracée seulement avec le routeur Questify (Q.Nav:Active() == "questify"), quel que soit
-- l'affichage ; jamais avec Shortest Path Forever, qui dessine la sienne.
--
-- Coût (spec § 3 bis) : les points sont calculés à chaque NAV_ROUTE et au changement de style, pas à
-- chaque image ; une route dont les trajets et le chemin n'ont pas changé (signature) n'est pas
-- reposée : seuls les points dépassés partent (chaque retrait d'un repère de la carte du monde
-- parcourt tous ses repères). La carte du monde ne reçoit ses repères que pendant qu'elle est ouverte (posés à
-- l'ouverture, retirés à la fermeture) ; la minicarte les reçoit tout le temps. Toutes les
-- CHECK_EVERY s, l'avancée du joueur le long du chemin retire les points dépassés et la minicarte
-- reprend les points les plus proches quand le joueur a bougé. Au plus MAX_PINS repères (halos
-- compris) sur la carte du monde, les premiers devant le joueur, et MAX_MINIMAP sur la minicarte,
-- sur le continent du joueur seulement. Cadres réutilisés (réserves).
--
-- Niveaux : sur la carte du monde, deux types de niveau propres insérés sous celui des repères de
-- quête (PIN_FRAME_LEVEL_AREA_POI, défaut de HereBeDragons) : la ligne passe sous les repères, le
-- halo sous la ligne. Si le gestionnaire de niveaux de la carte ne le permet pas, niveau par défaut.
-- Sur la minicarte (pas de type de niveau chez HereBeDragons), halo et ligne au-dessus de la carte.
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
local MAX_PINS = 400               -- repères sur la carte du monde (halos compris)
local MAX_MINIMAP = 60             -- repères sur la minicarte (halos compris)
local WORLD_POINTS = MAX_PINS / 2  -- un halo par point
local MINI_POINTS = MAX_MINIMAP / 2
local MAX_POINTS = 4000            -- points calculés au plus pour une route
local MINI_RANGE = 400             -- yards : au-delà, un point n'est pas proposé à la minicarte
local MINI_MOVE = 10               -- yards de déplacement avant de refaire la minicarte
local CHECK_EVERY = 0.5            -- secondes entre deux relevés de l'avancée du joueur
local BEHIND, AHEAD = 50, 200      -- yards : fenêtre du chemin où l'on cherche le joueur
local MIN_BRIGHT = 0.48            -- canal le plus fort de la couleur au moins à ce niveau (lisible)
local RIDE_ALPHA = 0.9
local HALO_ALPHA = 0.667           -- maquette : #000a
local HALO_GROW = { world = 2, mini = 2 }   -- pixels de halo en plus de la marque
-- Carte du monde : écart voulu entre deux marques, en pixels de la carte affichée. Les points sont
-- calculés en yards ; selon l'échelle de la carte (yards par pixel), un point sur n seulement est
-- posé, pour que les marques ne se chevauchent pas en pâté (carte de zone) ni ne s'empilent (carte
-- du continent). Trait plein : des barres tournées le long du chemin, longues comme l'écart, qui se
-- rejoignent en un trait fin et continu.
local GAP_PX = { dots = 9, solid = 6, dashes = 15, ride = 9 }
local SOLID_THICK = 3              -- épaisseur du trait plein en barres
local SOLID_OVERLAP = 1.5          -- pixels de recouvrement entre deux barres

-- Types de niveau de la carte du monde (insérés sous le niveau des repères de quête).
local LEVEL_LINE, LEVEL_HALO = "QUESTIFY_ROUTE_LINE", "QUESTIFY_ROUTE_HALO"
local LEVEL_ABOVE = "PIN_FRAME_LEVEL_AREA_POI"

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
local worldLast = 0    -- dernier point posé sur la carte du monde (first - 1 : aucun)
local worldLine, worldHalo = {}, {}   -- [index du point] = cadre
local miniPins = {}    -- cadres posés sur la minicarte (marques et halos)
-- Trajet en cours : polyligne { { instance, x, y } } et abscisses cumulées, avancée du joueur.
local poly, cum
local progress = 0
local miniAt           -- { instance, x, y } du joueur au dernier calcul de la minicarte
local ticker
local levels           -- nil : pas encore tenté ; false : niveau par défaut ; true : types insérés
local posedSig         -- signature de la route posée (voir signature), nil : rien de posé
local ypp              -- yards par pixel de la carte du monde affichée ; nil : inconnu (un point sur un)
local worldN = 0       -- marques posées sur la carte du monde (hors halos)

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

local function mapShown()
  local map = WorldMapFrame
  return type(map) == "table" and type(map.IsShown) == "function" and map:IsShown() == true
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

-- Types de niveau de la ligne et du halo sur la carte du monde, ou nil, nil (niveau par défaut).
-- Insérés une fois sous LEVEL_ABOVE ; vérifiés (le gestionnaire doit leur donner un niveau), sans
-- quoi HereBeDragons poserait un repère sans niveau valide.
local function worldLevels()
  if levels == nil then
    levels = false
    local map = WorldMapFrame
    local mgr
    if type(map) == "table" and type(map.GetPinFrameLevelsManager) == "function" then
      local ok, m = pcall(map.GetPinFrameLevelsManager, map)
      if ok and type(m) == "table" then mgr = m end
    end
    if mgr and type(mgr.InsertFrameLevelBelow) == "function" and type(mgr.GetValidFrameLevel) == "function" then
      local ok1 = pcall(mgr.InsertFrameLevelBelow, mgr, LEVEL_LINE, LEVEL_ABOVE)
      local ok2 = ok1 and pcall(mgr.InsertFrameLevelBelow, mgr, LEVEL_HALO, LEVEL_LINE)
      if ok2 then
        local okL, l = pcall(mgr.GetValidFrameLevel, mgr, LEVEL_LINE)
        local okH, h = pcall(mgr.GetValidFrameLevel, mgr, LEVEL_HALO)
        local okA, a = pcall(mgr.GetValidFrameLevel, mgr, LEVEL_ABOVE)
        levels = okL and okH and okA and type(l) == "number" and type(h) == "number" and type(a) == "number"
          and h < l and l < a
      end
    end
  end
  if levels then return LEVEL_LINE, LEVEL_HALO end
  return nil, nil
end

-- Yards par pixel de la carte du monde affichée (largeur de la zone chez HereBeDragons sur la
-- largeur de la carte à l'écran), ou nil quand l'une des deux manque (carte du monde entier, API
-- absente).
local function mapScale()
  local map, stub = WorldMapFrame, LibStub
  if type(map) ~= "table" or type(map.GetMapID) ~= "function" then return nil end
  if type(stub) ~= "table" or type(stub.GetLibrary) ~= "function" then return nil end
  local okL, hbd = pcall(stub.GetLibrary, stub, "HereBeDragons-2.0", true)
  if not okL or type(hbd) ~= "table" or type(hbd.GetZoneSize) ~= "function" then return nil end
  local okM, id = pcall(map.GetMapID, map)
  if not okM or type(id) ~= "number" then return nil end
  local okZ, yards = pcall(hbd.GetZoneSize, hbd, id)
  if not okZ or type(yards) ~= "number" or yards <= 0 then return nil end
  local child = type(map.ScrollContainer) == "table" and map.ScrollContainer.Child or nil
  if type(child) ~= "table" or type(child.GetWidth) ~= "function" then return nil end
  local okW, width = pcall(child.GetWidth, child)
  if not okW or type(width) ~= "number" or width <= 0 then return nil end
  local scale = 1
  if type(map.GetCanvasScale) == "function" then
    local okS, v = pcall(map.GetCanvasScale, map)
    if okS and type(v) == "number" and v > 0 then scale = v end
  end
  return yards / (width * scale)
end

-- Un point sur n posé sur la carte du monde pour ce genre de marque, et l'écart obtenu en pixels
-- (nil : échelle inconnue, tous les points).
local function strideOf(kind)
  if not ypp then return 1, nil end
  local look = kind == "ride" and "ride" or style
  local spacing = kind == "ride" and RIDE_SPACING or SPACING[style]
  local n = max(1, math.ceil(GAP_PX[look] * ypp / spacing - 1e-6))
  return n, n * spacing / ypp
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
  f.index = nil
  local list = free[where]
  list[#list + 1] = f
end

-- Apparence du repère du point i : marque (couleur, angle) ou halo (noir, un peu plus grand).
-- span : écart en pixels jusqu'à la marque suivante (carte du monde à l'échelle connue) ; le trait
-- plein devient alors une barre de cette longueur, tournée le long du chemin.
local function dress(f, i, where, color, halo, span)
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
  if look == "solid" and span then
    round, w, h = false, span + SOLID_OVERLAP, SOLID_THICK
  end
  if halo then
    local g = HALO_GROW[where]
    w, h = w + g, h + g
  end
  if round then
    tex:SetTexture(DOT_TEXTURE)
    tex:SetRotation(0)
  else
    tex:SetTexture(SQUARE_TEXTURE)
    tex:SetRotation(ptA[i])
  end
  tex:SetSize(w, h)
  local alpha = kind == "ride" and RIDE_ALPHA or 1
  if halo then
    tex:SetVertexColor(0, 0, 0, HALO_ALPHA * alpha)
  else
    tex:SetVertexColor(color[1], color[2], color[3], alpha)
  end
  f:SetSize(max(w, h), max(w, h))
  f.kind = kind
  f.halo = halo or nil
  f.index = i
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

-- Avancée du joueur le long du trajet en cours (yards), jamais en arrière. Le joueur n'est cherché
-- que sur les segments proches de l'avancée connue (BEHIND yd derrière, AHEAD devant) : un chemin
-- en lacets qui repasse près du joueur ne fait pas sauter la ligne en avant.
local function measure(me)
  if not (poly and cum and me) then return progress end
  local lo, hi = progress - BEHIND, progress + AHEAD
  local bestD, bestS = huge, nil
  for k = 1, #poly - 1 do
    if cum[k] > hi then break end
    local a, b = poly[k], poly[k + 1]
    if cum[k + 1] >= lo and a.instance == me.instance and b.instance == me.instance then
      local dx, dy = b.x - a.x, b.y - a.y
      local l2 = dx * dx + dy * dy
      local t = 0
      if l2 > 0 then t = max(0, min(1, ((me.x - a.x) * dx + (me.y - a.y) * dy) / l2)) end
      local s = cum[k] + t * sqrt(l2)
      if s > hi then
        -- au-delà de la fenêtre : le point du segment au bout de la fenêtre
        t = (hi - cum[k]) / sqrt(l2)
        s = hi
      end
      local px, py = a.x + dx * t - me.x, a.y + dy * t - me.y
      local d = px * px + py * py
      if d < bestD then bestD, bestS = d, s end
    end
  end
  if bestS and bestS > progress then progress = bestS end
  return progress
end

---------------------------------------------------------------------------
-- Pose
---------------------------------------------------------------------------
local function placeWorld(lib, i, color)
  local stride, span = strideOf(ptK[i])
  if i % stride ~= 0 then return end
  local lineLevel, haloLevel = worldLevels()
  local flag = HBD_PINS_WORLDMAP_SHOW_CONTINENT or 2
  -- HereBeDragons : x vers l'ouest, y vers le nord
  local h = acquire("world")
  dress(h, i, "world", color, true, span)
  if call(lib.AddWorldMapIconWorld, lib, REF, h, ptI[i], ptY[i], ptX[i], flag, haloLevel) then
    worldHalo[i] = h
  else
    release("world", h)
  end
  local f = acquire("world")
  dress(f, i, "world", color, false, span)
  if call(lib.AddWorldMapIconWorld, lib, REF, f, ptI[i], ptY[i], ptX[i], flag, lineLevel) then
    worldLine[i] = f
    worldN = worldN + 1
  else
    release("world", f)
  end
end

local function removeWorld(lib, i)
  for _, list in ipairs({ worldLine, worldHalo }) do
    local f = list[i]
    if f then
      list[i] = nil
      if list == worldLine then worldN = worldN - 1 end
      if type(lib.RemoveWorldMapIcon) == "function" then call(lib.RemoveWorldMapIcon, lib, REF, f) end
      release("world", f)
    end
  end
end

-- Tous les repères de la carte du monde retirés (carte fermée, nouvelle route).
local function clearWorld(lib)
  if lib and type(lib.RemoveAllWorldMapIcons) == "function" then call(lib.RemoveAllWorldMapIcons, lib, REF) end
  for _, list in ipairs({ worldLine, worldHalo }) do
    for i, f in pairs(list) do
      list[i] = nil
      release("world", f)
    end
  end
  worldLast = first - 1
  worldN = 0
end

-- Fenêtre de la carte du monde : à partir de first, jusqu'à WORLD_POINTS marques posées (un point
-- sur n selon l'échelle de la carte, voir strideOf), carte ouverte seulement.
local function syncWorld(lib, color)
  if not mapShown() then return end
  if worldN == 0 then ypp = mapScale() end
  local i = max(worldLast + 1, first)
  while i <= count and worldN < WORLD_POINTS do
    placeWorld(lib, i, color)
    worldLast = i
    i = i + 1
  end
end

local function clearMinimap(lib)
  if lib and type(lib.RemoveAllMinimapIcons) == "function" then call(lib.RemoveAllMinimapIcons, lib, REF) end
  for k = #miniPins, 1, -1 do
    release("mini", miniPins[k])
    miniPins[k] = nil
  end
end

local function placeMini(lib, i, color, halo, level)
  local f = acquire("mini")
  dress(f, i, "mini", color, halo)
  if call(lib.AddMinimapIconWorld, lib, REF, f, ptI[i], ptY[i], ptX[i], false) then
    if level then f:SetFrameLevel(level) end
    miniPins[#miniPins + 1] = f
  else
    release("mini", f)
  end
end

local candI, candD = {}, {}
local function byDistance(a, b) return candD[a] < candD[b] end

-- Minicarte : les MINI_POINTS points non dépassés les plus proches, sur le continent du joueur.
local function syncMinimap(lib, me, color)
  clearMinimap(lib)
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
  -- halo juste au-dessus de la carte, marque au-dessus du halo
  local base = Minimap and type(Minimap.GetFrameLevel) == "function" and Minimap:GetFrameLevel() or nil
  local take = min(n, MINI_POINTS)
  for k = 1, take do placeMini(lib, candI[k], color, true, base and base + 1) end
  for k = 1, take do placeMini(lib, candI[k], color, false, base and base + 2) end
  for k = 1, n do candD[candI[k]] = nil end
end

-- Signature de ce qui est tracé : style, trajet en cours, trajets (genre, départ, arrivée) et chemin,
-- sans la position du joueur.
local function pointKey(p)
  if type(p) ~= "table" then return "" end
  return string.format("%s:%.1f:%.1f", tostring(p.mapId or p.instance), tonumber(p.x) or 0, tonumber(p.y) or 0)
end

local function signature(r)
  local parts = { currentStyle(), tostring(r.leg), tostring(r.straight == true) }
  for _, L in ipairs(type(r.legs) == "table" and r.legs or {}) do
    if type(L) == "table" then parts[#parts + 1] = tostring(L.kind) .. pointKey(L.from) .. pointKey(L.to) end
  end
  parts[#parts + 1] = "path"
  for _, p in ipairs(type(r.path) == "table" and r.path or {}) do parts[#parts + 1] = pointKey(p) end
  return table.concat(parts, "|")
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
    if worldLast < first - 1 then worldLast = first - 1 end
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
  clearWorld(lib)
  clearMinimap(lib)
  count, first, worldLast, progress = 0, 1, 0, 0
  poly, cum, miniAt = nil, nil, nil
  posedSig = nil
end

function RouteLine:Refresh()
  local lib = hbdPins()
  if type(route) ~= "table" or not drawable() or not lib then
    self:Clear()
    return
  end
  local sig = signature(route)
  if sig == posedSig and count > 0 then
    -- même tracé : seule l'avancée a pu changer
    follow(false)
    return
  end
  self:Clear()
  posedSig = sig
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

-- Couleur du thème reprise sur les marques posées (les halos restent noirs), sans les reposer.
function RouteLine:Recolor()
  local color = self:Color()
  for _, f in pairs(worldLine) do
    local _, _, _, a = f.tex:GetVertexColor()
    f.tex:SetVertexColor(color[1], color[2], color[3], a)
  end
  for _, f in ipairs(miniPins) do
    if not f.halo then
      local _, _, _, a = f.tex:GetVertexColor()
      f.tex:SetVertexColor(color[1], color[2], color[3], a)
    end
  end
end

function RouteLine:State()
  local w = 0
  for _ in pairs(worldLine) do w = w + 1 end
  local m = 0
  for _, f in ipairs(miniPins) do if not f.halo then m = m + 1 end end
  return { style = style, points = count, first = first, world = w, minimap = m }
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
Q:On("THEME_CHANGED", function() Q.SafeCall(RouteLine.Recolor, RouteLine) end)
Q:On("SETTINGS_CHANGED", function(path)
  if path == nil or REDRAW[path] then
    RouteLine:Refresh()
  elseif RECOLOR[path] then
    RouteLine:Recolor()
  end
end)

-- Carte du monde : repères posés à l'ouverture, retirés à la fermeture.
if type(WorldMapFrame) == "table" and type(WorldMapFrame.HookScript) == "function" then
  WorldMapFrame:HookScript("OnShow", function()
    Q.SafeCall(function()
      local lib = hbdPins()
      if lib and count > 0 then syncWorld(lib, RouteLine:Color()) end
    end)
  end)
  WorldMapFrame:HookScript("OnHide", function()
    Q.SafeCall(function() clearWorld(hbdPins()) end)
  end)
  -- autre carte affichée (zone, continent) : l'échelle change, les marques sont reposées
  if type(hooksecurefunc) == "function" and type(WorldMapFrame.OnMapChanged) == "function" then
    hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
      Q.SafeCall(function()
        local lib = hbdPins()
        if not lib or count == 0 or not mapShown() then return end
        clearWorld(lib)
        syncWorld(lib, RouteLine:Color())
      end)
    end)
  end
end

-- Écran de chargement : la minicarte suit le continent du joueur.
Q:RegisterEvent("PLAYER_ENTERING_WORLD", function()
  if count > 0 then Q.SafeCall(follow, true) end
end)
