-- Questify Route: with Questify (the free WoW: Forever leveling guide) installed, a quick button that routes to each
-- step of its guide in turn, as RestedXP Route (RestedXP.lua) and Zygor Route (Zygor.lua). Questify publishes where
-- its guide sends the player in a read-only global, QuestifyAPI.Destination() (Questify's docs/API.md): uiMap `mapID`,
-- x, y from 0 to 1, a `key` that changes as soon as the place does. That place is the route's first stop; when the key
-- changes (the step checked off, the objective done, another mob picked), that stop is done and the new place is the
-- stop. Getting there doesn't finish it (Questify says when: N.CheckArrival). No place (a step done where the player
-- stands, the guide finished or paused) leaves no stop until one comes. Another route picked turns it off, and so do
-- RestedXP Route and Zygor Route (one guide at a time). Read only: nothing in Questify is changed or called but
-- QuestifyAPI.Destination().
local _, ns = ...
local L = ns.L or setmetatable({}, { __index = function(_, k) return k end }) -- (the game's language: Locales.lua)

local Q = {}
ns.Questify = Q

Q.TICK = 0.5 -- s between looks at Questify's destination
Q.USE_VIA = false -- also stop at the cave mouths Questify gives (`via`); off: AzerothGPS's own caves (Data/Caves.lua)
Q.lastKey = nil -- the place the route was last given (nil: none yet since turned on)

local function API()
  local a = _G.QuestifyAPI
  return (type(a) == "table" and type(a.Destination) == "function") and a or nil
end

-- Questify is loaded (its API is there).
function Q.Available()
  return API() ~= nil
end

local function CDB() return ns.CharDB and ns.db and ns.CharDB() end

-- Following Questify's steps (per character, kept over a /reload). On by itself where Questify is loaded, until it's
-- turned off, unless RestedXP Route or Zygor Route was turned on by hand (one guide at a time).
function Q.On()
  local cdb = CDB()
  if not cdb then return false end
  if cdb.questifyFollow ~= nil then return cdb.questifyFollow == true end
  return Q.Available() and cdb.rxpFollow ~= true and cdb.zygorFollow ~= true
end

-- Questify's destination, or nil (in a pcall: an error there stays there).
function Q.Destination()
  local a = API()
  if not a then return nil end
  local ok, d = pcall(a.Destination)
  if not ok or type(d) ~= "table" or type(d.key) ~= "string" then return nil end
  if not (tonumber(d.mapID) and tonumber(d.x) and tonumber(d.y)) then return nil end
  return d
end

-- A Questify point (mapID, x, y from 0 to 1) as a stop: { x, y, cont, name } in world yards, or nil.
local function ToStop(mapID, x, y, name)
  return ns.Import and ns.Import.ToStop({ mapID = tonumber(mapID), x = x * 100, y = y * 100, name = name })
end

-- The stop's name: Questify's step text, else "Step n".
function Q.Name(d)
  local t = type(d.title) == "string" and d.title:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("%s+", " ")
  t = t and t:match("^%s*(.-)%s*$")
  if not t or t == "" then
    local s = type(d.step) == "table" and d.step.index
    t = s and L["Step %s"]:format(tostring(s)) or L["Step"]
  end
  return "Questify: " .. t
end

-- The route's Questify stop: index, stop (or nil).
function Q.Stop()
  for i, d in ipairs(ns.Nav and ns.Nav.stops or {}) do
    if d.questify then return i, d end
  end
end

-- The cave mouths put in for Questify's place (Q.USE_VIA), removed with it.
local function RemoveVia()
  local N = ns.Nav
  for i = #(N and N.stops or {}), 1, -1 do
    if N.stops[i].questifyVia then N.RemoveStop(i) end
  end
end

-- One look at Questify's destination (every Q.TICK while on).
function Q.Tick()
  if not Q.On() or not ns.Nav then return end
  local N = ns.Nav
  local dest = Q.Destination()
  local stop = dest and ToStop(dest.mapID, dest.x, dest.y, Q.Name(dest))
  local key = stop and dest.key
  local i, d = Q.Stop()
  if d and d.questify ~= key then
    -- (Questify moved on: the step or objective is done, so is the stop)
    N.RemoveStop(i)
    RemoveVia()
    d = nil
  end
  -- (where floors stack: the guides' shipped heights, Data/GuideFloors.lua, else an NPC talked to there, else the
  -- followed floor: as Zygor Route's)
  local X = ns.RestedXP
  local H = X and X.HeightAt and function(c, px, py) return X.TableHeight(c, px, py) or X.HeightAt(c, px, py) end
  if d and d.z == nil and H then
    local z = H(d.cont, d.x, d.y)
    if z then
      d.z = z
      if N.Invalidate then N.Invalidate() end
    end
  end
  if key and not d then
    if Q.lastKey == key then
      -- (Questify still on the same place and its stop gone: another route was picked, or it was removed by hand)
      Q.SetOn(false)
      RemoveVia()
      ns.Print(L["Questify Route: off (the route was changed). Click Questify Route to follow the guide again."])
      return
    end
    stop.z, stop.questify = H and H(stop.cont, stop.x, stop.y), key
    N.InsertStop(stop, 1, true)
    if Q.USE_VIA and type(dest.via) == "table" then
      -- (Questify's cave mouths, in order, before its place: plain stops, done by getting there)
      for n = #dest.via, 1, -1 do
        local v = dest.via[n]
        local s = type(v) == "table" and ToStop(v.mapID, v.x, v.y, Q.Name(dest))
        if s then
          s.questifyVia = key
          N.InsertStop(s, 1, true)
        end
      end
    end
  end
  Q.lastKey = key
end

function Q.SetOn(on)
  local cdb = CDB()
  if not cdb then return end
  cdb.questifyFollow = on and true or false -- (off is kept too: the default is on)
  Q.lastKey = nil
end

-- The button: on replaces the route with Questify's current place (and each one after it); off leaves the route.
function Q.Toggle()
  if not Q.Available() then
    ns.Print(L["Questify Route: Questify isn't loaded."])
    return
  end
  if Q.On() then
    Q.SetOn(false)
    local i = Q.Stop()
    if i then ns.Nav.RemoveStop(i) end
    RemoveVia()
    ns.Print(L["Questify Route: off."])
    return
  end
  local X, Z = ns.RestedXP, ns.Zygor
  if X and X.On and X.On() then X.Toggle() end -- (one guide at a time)
  if Z and Z.On and Z.On() then Z.Toggle() end
  if ns.Nav.Clear then ns.Nav.Clear() end
  Q.SetOn(true)
  Q.Tick()
  ns.Print(Q.Stop() and L["Questify Route: on. Each Questify step is your next stop; it's done when Questify checks it off."]
    or L["Questify Route: on. Questify's step has no place to go right now; the route starts at the next one that has."])
end

if C_Timer and C_Timer.NewTicker then
  Q.ticker = C_Timer.NewTicker(Q.TICK, function()
    local ok, err = pcall(Q.Tick)
    if not ok and ns.GPS and ns.GPS.LogError then ns.GPS.LogError("Questify Route", err) end
  end)
end
