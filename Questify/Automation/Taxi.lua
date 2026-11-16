local addonName, Q = ...

-- Vols automatiques (option autoFly). Quand l'étape courante est « fly » et que la carte des vols
-- s'ouvre (TAXIMAP_OPENED), le point de vol de la destination est choisi puis pris avec
-- TakeTaxiNode. Maj (Shift) à l'ouverture laisse le joueur choisir ; rien en combat.
-- Nœuds : C_TaxiMap.GetAllTaxiNodes(GetTaxiMapID()) (carte des vols de Mainline), sinon les
-- fonctions historiques NumTaxiNodes / TaxiNodeName / TaxiNodeGetType (TaxiFrame). Les deux
-- existent sur la branche forever de l'interface Blizzard.
-- Choix du nœud, dans l'ordre :
--   1. identifiant de nœud de l'étape (step.node, ID TaxiNodes du générateur) comparé au nodeID
--      de C_TaxiMap ; la carte historique n'a pas d'identifiant, on passe aux noms ;
--   2. ville de la note du guide (« Ratchet, The Barrens » -> « Ratchet ») dans le nom du nœud ;
--   3. nom de la zone de destination (langue du client) dans un seul nom de nœud ;
--   4. position : nœud le plus proche de la première étape localisée sur la carte de destination.
-- Nœud trouvé mais inaccessible, ou aucun nœud : un court message, pas de vol.
--
-- Surbrillance (toujours, avec ou sans autoFly) : à l'ouverture de la carte des vols, le point de vol
-- à prendre est entouré d'un anneau doré qui pulse. C'est celui de l'étape « fly », sinon l'arrivée
-- du premier vol de la route du routeur Questify (Q.Walk:Route, trajet « fly », champ node). Le
-- bouton du point est cherché sur la carte des vols de Mainline (FlightMapFrame, repères
-- FlightMap_FlightPointPinTemplate) puis sur la carte historique (TaxiButton<index>).
local Taxi = {}
Q.Taxi = Taxi

local L = Q.L
local C = Q.Comfort

local STATE_CURRENT, STATE_REACHABLE, STATE_UNREACHABLE = 0, 1, 2   -- Enum.FlightPathState
local NODE_RADIUS = 1500    -- yards : nœud accepté par la position seule
local LOOKAHEAD = 6
local RETRY_DELAY = 0.3     -- la liste des nœuds peut être vide à l'instant de l'ouverture

local open = false
local done = false          -- un vol a été demandé pour cette ouverture

local function enabled() return C.Enabled("autoFly") end

local function shiftDown()
  local v = C.Call(IsShiftKeyDown)
  return v == true or v == 1
end

---------------------------------------------------------------------------
-- Nœuds de la carte des vols
---------------------------------------------------------------------------
local LEGACY_STATE = { CURRENT = STATE_CURRENT, REACHABLE = STATE_REACHABLE }

local function plainString(v)
  if Q.Util.IsSecret(v) or type(v) ~= "string" or v == "" then return nil end
  return v
end

-- -> { { index, name, lname, state, nodeID, mapId, x, y } } (x, y en 0-100 sur mapId, ou nil).
function Taxi:Nodes()
  local list = {}
  local mapId = C.Number(C.Call(GetTaxiMapID))
  if mapId and C_TaxiMap and type(C_TaxiMap.GetAllTaxiNodes) == "function" then
    local ok, nodes = pcall(C_TaxiMap.GetAllTaxiNodes, mapId)
    if ok and not Q.Util.IsSecret(nodes) and type(nodes) == "table" then
      for _, n in ipairs(nodes) do
        local name = type(n) == "table" and plainString(n.name)
        local index = name and C.Number(n.slotIndex)
        if index and n.isMapLayerTransition ~= true then
          local x, y
          local pos = n.position
          if type(pos) == "table" then
            if pos.GetXY then x, y = pos:GetXY() else x, y = pos.x, pos.y end
          end
          x, y = C.Number(x), C.Number(y)
          list[#list + 1] = {
            index = index, name = name, lname = name:lower(),
            state = C.Number(n.state) or STATE_UNREACHABLE, nodeID = C.Number(n.nodeID),
            mapId = mapId, x = x and x * 100, y = y and y * 100,
          }
        end
      end
    end
  end
  if #list > 0 then return list end
  -- carte des vols historique
  local count = C.Number(C.Call(NumTaxiNodes))
  if not count then return list end
  for i = 1, count do
    local name = plainString(C.Call(TaxiNodeName, i))
    if name then
      local kind = C.Call(TaxiNodeGetType, i)
      local state = type(kind) == "string" and LEGACY_STATE[kind] or STATE_UNREACHABLE
      list[#list + 1] = { index = i, name = name, lname = name:lower(), state = state }
    end
  end
  return list
end

---------------------------------------------------------------------------
-- Choix du nœud
---------------------------------------------------------------------------
-- Ville de la note du guide : « Ratchet, The Barrens » -> « ratchet ».
local function noteTown(step)
  if type(step.note) ~= "string" then return nil end
  local town = step.note:match("^%s*([^,]-)%s*,") or step.note:match("^%s*(.-)%s*$")
  if not town or #town < 3 then return nil end
  return town:lower()
end

-- Seul nœud dont le nom contient `needle`, sinon nil (aucun ou plusieurs).
local function onlyMatch(nodes, needle)
  if not needle or needle == "" then return nil end
  local found
  for _, n in ipairs(nodes) do
    if n.lname:find(needle, 1, true) then
      if found then return nil end
      found = n
    end
  end
  return found
end

-- Première étape localisée sur la carte de destination après l'étape de vol : -> map, x, y.
local function destinationPoint(entry)
  local mapId = entry.step.mapId
  local entries = Q.Progress:Entries()
  local index
  for i, e in ipairs(entries) do
    if e == entry or e.key == entry.key then index = i; break end
  end
  if not index then return nil end
  for i = index + 1, math.min(#entries, index + LOOKAHEAD) do
    local target = Q.Targets:ForEntry(entries[i])
    if target and target.mapId == mapId and type(target.x) == "number" then
      return target.mapId, target.x, target.y
    end
  end
  return nil
end

-- Nœud de destination pour l'étape `entry` parmi `nodes`, ou nil.
function Taxi:Pick(entry, nodes)
  local step = entry.step
  local others = {}
  for _, n in ipairs(nodes) do
    if n.state ~= STATE_CURRENT then others[#others + 1] = n end
  end
  -- 1. identifiant de nœud donné par l'étape (nœud courant compris : le joueur y est déjà, Try
  -- ne fait alors rien) ; absent de la liste : on passe aux noms
  local wanted = tonumber(step.node)
  if wanted then
    for _, n in ipairs(nodes) do
      if n.nodeID == wanted then return n end
    end
  end
  -- 2. ville de la note (guides en anglais : marche sur un client anglais)
  local n = onlyMatch(others, noteTown(step))
  if n then return n end
  -- 3. nom de la zone dans la langue du client
  local zone = Q.Maps:MapName(step.mapId)
  local inZone = {}
  if type(zone) == "string" and zone:sub(1, 1) ~= "#" then
    local needle = zone:lower()
    for _, node in ipairs(others) do
      if node.lname:find(needle, 1, true) then inZone[#inZone + 1] = node end
    end
    if #inZone == 1 then return inZone[1] end
  end
  -- 4. position : le plus proche de la destination
  local dm, dx, dy = destinationPoint(entry)
  if not dm then return nil end
  local pool = #inZone > 0 and inZone or others
  local best, bestD
  for _, node in ipairs(pool) do
    if node.mapId and node.x and node.y then
      local d = Q.Maps:Distance(node.mapId, node.x, node.y, dm, dx, dy)
      if d and (not bestD or d < bestD) then best, bestD = node, d end
    end
  end
  if best and (#inZone > 0 or bestD <= NODE_RADIUS) then return best end
  return nil
end

---------------------------------------------------------------------------
-- Ouverture de la carte des vols
---------------------------------------------------------------------------
local function currentFly()
  local P = Q.Progress
  if not (P and P:IsEnabled()) then return nil end
  local cur = P:Current()
  if cur and cur.step.action == "fly" and type(cur.step.mapId) == "number" then return cur end
  return nil
end

-- -> true si un vol a été demandé ou un message affiché, false si la liste était vide.
function Taxi:Try()
  if done or not open or not enabled() or C.InCombat() or shiftDown() then return true end
  local entry = currentFly()
  if not entry then return true end
  local nodes = self:Nodes()
  if #nodes == 0 then return false end
  done = true
  local node = self:Pick(entry, nodes)
  if not node then
    Q:Print(L.COMFORT_TAXI_NOT_FOUND, Q.Maps:MapName(entry.step.mapId))
    return true
  end
  if node.state == STATE_CURRENT then return true end   -- déjà à destination
  if node.state ~= STATE_REACHABLE then
    Q:Print(L.COMFORT_TAXI_UNREACHABLE, node.name)
    return true
  end
  if type(TakeTaxiNode) ~= "function" then return true end
  local ok, err = pcall(TakeTaxiNode, node.index)
  if not ok then
    Q:Debug("TakeTaxiNode", err)
    return true
  end
  Q:Print(L.COMFORT_TAXI_FLYING, node.name)
  return true
end

---------------------------------------------------------------------------
-- Surbrillance du point de vol à prendre
---------------------------------------------------------------------------
local GLOW_NAME = "QuestifyTaxiGlow"
local GLOW_MIN, GLOW_FACTOR = 34, 2.4    -- pixels, et taille par rapport au bouton du point
local GLOW_TIME = 1.1
local RING_TEXTURE = "Interface\\Cooldown\\ping4"
local glow

-- Point de vol à prendre parmi `nodes` : celui de l'étape « fly », sinon l'arrivée du premier vol
-- de la route du routeur. nil : aucun, ou le joueur y est déjà.
function Taxi:Wanted(nodes)
  local node
  local entry = currentFly()
  if entry then node = self:Pick(entry, nodes) end
  if not node then
    local W = Q.Walk
    local ok, r = false, nil
    if W and type(W.Route) == "function" then ok, r = pcall(W.Route, W) end
    if ok and type(r) == "table" and type(r.legs) == "table" then
      for i = tonumber(r.leg) or 1, #r.legs do
        local leg = r.legs[i]
        if type(leg) == "table" and leg.kind == "fly" then
          local id = tonumber(leg.node)
          for _, n in ipairs(nodes) do
            if id and n.nodeID == id then node = n; break end
          end
          break
        end
      end
    end
  end
  if node and node.state == STATE_CURRENT then return nil end
  return node
end

-- Bouton (cadre) du point de vol sur la carte des vols affichée, ou nil.
local function nodeButton(node)
  local fm = FlightMapFrame
  if type(fm) == "table" and type(fm.EnumeratePinsByTemplate) == "function"
    and type(fm.IsShown) == "function" and fm:IsShown() then
    local ok, found = pcall(function()
      for pin in fm:EnumeratePinsByTemplate("FlightMap_FlightPointPinTemplate") do
        local d = pin.taxiNodeData
        if type(d) == "table" and not Q.Util.IsSecret(d.slotIndex)
          and (d.slotIndex == node.index or (node.nodeID ~= nil and d.nodeID == node.nodeID)) then
          return pin
        end
      end
    end)
    if ok and found then return found end
  end
  local b = _G["TaxiButton" .. tostring(node.index)]
  if type(b) == "table" and type(b.IsShown) == "function" and b:IsShown() then return b end
  return nil
end

local function glowFrame()
  if glow then return glow end
  local f = CreateFrame("Frame", GLOW_NAME, UIParent)
  f:Hide()
  f:EnableMouse(false)
  local steady = f:CreateTexture(nil, "OVERLAY")
  steady:SetTexture(RING_TEXTURE)
  steady:SetBlendMode("ADD")
  steady:SetVertexColor(1, 0.82, 0, 0.9)
  steady:SetAllPoints(f)
  local ring = f:CreateTexture(nil, "OVERLAY")
  ring:SetTexture(RING_TEXTURE)
  ring:SetBlendMode("ADD")
  ring:SetVertexColor(1, 0.82, 0)
  ring:SetAllPoints(f)
  local group = ring:CreateAnimationGroup()
  group:SetLooping("REPEAT")
  local scale = group:CreateAnimation("Scale")
  if scale.SetScaleFrom then
    scale:SetScaleFrom(0.6, 0.6)
    scale:SetScaleTo(1.7, 1.7)
  end
  scale:SetDuration(GLOW_TIME)
  local fade = group:CreateAnimation("Alpha")
  fade:SetFromAlpha(1)
  fade:SetToAlpha(0)
  fade:SetDuration(GLOW_TIME)
  f.pulse = group
  glow = f
  return f
end

function Taxi:HideHighlight()
  if not glow then return end
  if glow.pulse then glow.pulse:Stop() end
  glow:Hide()
  glow.node = nil
end

-- Entoure le point de vol à prendre. -> le nœud entouré, ou nil (aucun, ou bouton introuvable).
function Taxi:Highlight()
  if not open then return nil end
  local nodes = self:Nodes()
  local node = #nodes > 0 and self:Wanted(nodes) or nil
  local button = node and nodeButton(node)
  if not button then
    self:HideHighlight()
    return nil
  end
  local f = glowFrame()
  local w = type(button.GetWidth) == "function" and tonumber(button:GetWidth()) or 0
  local size = math.max(GLOW_MIN, w * GLOW_FACTOR)
  f:SetParent(button)
  f:ClearAllPoints()
  f:SetPoint("CENTER", button, "CENTER", 0, 0)
  f:SetSize(size, size)
  if f.SetFrameLevel and button.GetFrameLevel then f:SetFrameLevel((button:GetFrameLevel() or 0) + 5) end
  f.node = node
  f:Show()
  if f.pulse then f.pulse:Play() end
  return node
end

-- Une nouvelle ouverture sans fermeture entre les deux ne relance pas de vol.
function Taxi:OnOpened()
  if not open then done = false end
  open = true
  if not self:Try() then
    Q:After(RETRY_DELAY, function() Taxi:Try() end)
  end
  -- les boutons des points de vol peuvent n'être posés qu'un instant après l'ouverture
  Q.SafeCall(Taxi.Highlight, Taxi)
  Q:After(RETRY_DELAY, function() Q.SafeCall(Taxi.Highlight, Taxi) end)
end

-- Progress (chargé avant) traite TAXIMAP_OPENED d'abord : l'étape « fp » de ce maître de vol est
-- validée, l'étape courante est donc déjà la suivante quand ce gestionnaire s'exécute.
Q:RegisterEvent("TAXIMAP_OPENED", function() Taxi:OnOpened() end)
Q:RegisterEvent("TAXIMAP_CLOSED", function()
  open, done = false, false
  Q.SafeCall(Taxi.HideHighlight, Taxi)
end)
