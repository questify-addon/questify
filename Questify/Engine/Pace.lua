local addonName, Q = ...

-- Rythme du joueur face à la route simulée (champ `sim` des chapitres générés par tools/routebuilder :
-- { steps, endLevel, xpPerHour, minutes }), session de jeu et passages de chapitre.
--
-- Temps actif : tranches de 10 secondes, comptées seulement quand le joueur joue (même règle que
-- Engine/XPRate.lua) : il bouge, gagne de l'XP ou se bat. Absent (AFK) ou mort : temps mort. Ni XP ni
-- mouvement depuis 5 minutes : ces 5 minutes et la suite passent en temps mort « immobile ».
--
-- Écart d'un chapitre : temps que la simulation met pour la part du chapitre faite depuis le début de la
-- mesure (étapes faites / étapes du chapitre, les étapes passées ne comptent pas comme faites), moins le
-- temps actif du joueur sur ce chapitre. Positif : en avance.
--
-- Données :
--   Q.char.pace = { chapters = { [chapitre] = ch }, session = s, lastSession = s } (personnage)
--     ch = { active, frac0, frac, lvlIn, lvlOut, xp, startedAt, closed, closedAt, delta, zones }
--     s  = { startedAt, lastTick, wall, active, xp, levels, down = { afk, dead, idle }, zones }
--     zones[uiMapID] = { sec, xp, lvlIn, lvlOut }
--   Q.db.pace = { v = 1, runs = { run, ... } } (compte) : tous les passages de chapitre des personnages
--     du compte, sans nom ni royaume, dans un format prêt à être partagé (classement à venir) :
--     run = { id, guide, sec, simMin, simSteps, frac0, frac, partial, faction, class, race, lvlIn,
--             lvlOut, xp, date, ver, zones, steps }
--     steps : copie de Q.char.telemetry[chapitre] (secondes par étape, Engine/Telemetry.lua).
-- Enregistrement des passages : option « telemetry » (comme les mesures par étape). Affichage dans le
-- suivi : option « showPace ».
local Pace = {}
Q.Pace = Pace

local L = Q.L

local TICK = 10              -- secondes par tranche
local IDLE_AFTER = 5 * 60    -- ni XP ni mouvement pendant ce temps : temps mort
local MOVE_EPS = 0.02        -- écart de position (0-100) compté comme un mouvement
local EVEN = 2 * 60          -- écart sous lequel on est « dans les temps »
local MIN_SHOW = 3 * 60      -- temps actif sur le chapitre avant d'afficher l'écart
local MIN_CALIBRATE = 10 * 60 -- temps actif mesuré avant de calibrer les prévisions sur le joueur
local FINISH_FRAC = 0.9      -- part du chapitre faite pour clore un passage quand on change de chapitre
local FULL_START = 0.05      -- mesure commencée au plus à cette part : passage complet
local RECENT = 5             -- derniers passages montrés par chapitre
local RESUME_GAP = 5 * 60    -- reconnexion (ou /reload) plus proche : même session
local DATA_VERSION = 1

Pace.TICK, Pace.IDLE_AFTER, Pace.EVEN, Pace.MIN_SHOW = TICK, IDLE_AFTER, EVEN, MIN_SHOW
Pace.MIN_CALIBRATE, Pace.FINISH_FRAC, Pace.RECENT = MIN_CALIBRATE, FINISH_FRAC, RECENT

-- Codes de couleur des écarts : déjà recolorés par thème dans le suivi (UI/Themes.lua, codes).
Pace.COLOR_AHEAD = "ff40e050"
Pace.COLOR_BEHIND = "ffffb040"
Pace.COLOR_EVEN = "ffc8c8c8"

---------------------------------------------------------------------------
-- Outils
---------------------------------------------------------------------------
local function isSecret(v) return Q.Util.IsSecret(v) end
local function now() return (GetTime and GetTime()) or 0 end
local function clock() return (time and time()) or 0 end

local function call(fn, ...)
  local C = Q.Comfort
  if C and C.Call then return C.Call(fn, ...) end
  if type(fn) ~= "function" then return nil end
  local ok, v = pcall(fn, ...)
  if ok and not isSecret(v) then return v end
  return nil
end

local function number(v)
  if isSecret(v) or type(v) ~= "number" or v ~= v then return nil end
  return v
end

local function flag(fn)
  local v = call(fn, "player")
  return v == true or v == 1
end

local function fmt(template, ...)
  local ok, s = pcall(string.format, template, ...)
  if ok then return s end
  return tostring(template)
end

local function duration(seconds)
  local C = Q.Comfort
  if C and C.FormatDuration then return C.FormatDuration(seconds) end
  return tostring(math.floor((seconds or 0) / 60 + 0.5)) .. " min"
end
Pace.Duration = duration

-- Durée en heures et minutes, toujours : "1 h 05", "0 h 49" (colonnes du journal).
function Pace.Clock(seconds)
  local minutes = math.floor((tonumber(seconds) or 0) / 60 + 0.5)
  return fmt(L.PACE_CLOCK, math.floor(minutes / 60), minutes % 60)
end

local function short(n)
  local C = Q.Comfort
  if C and C.ShortNumber then return C.ShortNumber(n) end
  return tostring(math.floor((n or 0) + 0.5))
end
Pace.Short = short

local function readXP()
  local xp = number(call(UnitXP, "player"))
  local max = number(call(UnitXPMax, "player"))
  if not (xp and max) then return nil end
  return xp, max
end

local function level()
  local lvl = number(call(UnitLevel, "player"))
  if not lvl then lvl = Q.Player and Q.Player.level end
  return tonumber(lvl) or 1
end

-- Niveau avec la part du niveau en cours : 22.44 (même mesure que sim.endLevel).
local function exactLevel()
  local lvl = level()
  local xp, max = readXP()
  if xp and max and max > 0 then lvl = lvl + math.min(xp / max, 0.99) end
  return math.floor(lvl * 100 + 0.5) / 100
end
Pace.ExactLevel = exactLevel

local function zone(list, map)
  if not map then return nil end
  local z = list[map]
  if type(z) ~= "table" then
    local lvl = exactLevel()
    z = { sec = 0, xp = 0, lvlIn = lvl, lvlOut = lvl }
    list[map] = z
  end
  return z
end

---------------------------------------------------------------------------
-- Données enregistrées
---------------------------------------------------------------------------
local function newSession()
  return { startedAt = clock(), lastTick = clock(), wall = 0, active = 0, xp = 0, levels = 0,
    down = { afk = 0, dead = 0, idle = 0 }, zones = {} }
end

function Pace:CharData()
  local c = Q.char
  if type(c) ~= "table" then return nil end
  local p = c.pace
  if type(p) ~= "table" then p = {}; c.pace = p end
  if type(p.chapters) ~= "table" then p.chapters = {} end
  return p
end

function Pace:AccountData()
  local db = Q.db
  if type(db) ~= "table" then return nil end
  local p = db.pace
  if type(p) ~= "table" then p = {}; db.pace = p end
  p.v = p.v or DATA_VERSION
  if type(p.runs) ~= "table" then p.runs = {} end
  return p
end

function Pace:Session()
  local p = self:CharData()
  if not p then return nil end
  if type(p.session) ~= "table" then p.session = newSession() end
  return p.session
end

function Pace:LastSession()
  local p = self:CharData()
  return p and type(p.lastSession) == "table" and p.lastSession or nil
end

-- Nouvelle session à la connexion, sauf reconnexion rapide ou /reload (moins de 5 minutes depuis la
-- dernière tranche) : la session en cours continue. Une session de moins d'une minute de jeu n'est pas
-- gardée comme « session précédente ».
function Pace:StartSession()
  local p = self:CharData()
  if not p then return end
  local s = p.session
  if type(s) == "table" and clock() - (tonumber(s.lastTick) or 0) < RESUME_GAP then return end
  if type(s) == "table" and (tonumber(s.wall) or 0) >= 60 then p.lastSession = s end
  p.session = newSession()
end

---------------------------------------------------------------------------
-- Chapitre courant
---------------------------------------------------------------------------
local function simOf(g)
  local sim = type(g) == "table" and g.sim
  if type(sim) == "table" and type(sim.minutes) == "number" and sim.minutes > 0 then return sim end
  return nil
end
Pace.SimOf = simOf

-- Part du chapitre courant faite : étapes faites / étapes du chapitre (passées comprises) ; nil sans
-- chapitre.
function Pace:Fraction()
  local P = Q.Progress
  if not (P and P:IsEnabled() and P:Guide()) then return nil end
  local done, total = 0, 0
  for _, e in ipairs(P:Entries()) do
    if e.source == "guide" then
      total = total + 1
      if P:State(e) == "done" then done = done + 1 end
    end
  end
  if total == 0 then return nil end
  return done / total
end

local function guideId()
  local P = Q.Progress
  local g = P and P:IsEnabled() and P:Guide()
  return g and g.id or nil, g
end

-- Mesure du chapitre g (créée à la première tranche jouée sur ce chapitre).
function Pace:Chapter(id, create)
  local p = self:CharData()
  if not (p and id) then return nil end
  local ch = p.chapters[id]
  if type(ch) ~= "table" and create then
    local frac = self:Fraction() or 0
    local lvl = exactLevel()
    ch = { active = 0, frac0 = frac, frac = frac, lvlIn = lvl, lvlOut = lvl, xp = 0, startedAt = clock(), zones = {} }
    p.chapters[id] = ch
  end
  return type(ch) == "table" and ch or nil
end

-- Écart (secondes, positif = en avance) et temps simulé de la part faite, pour une mesure de chapitre.
function Pace:ChapterDelta(id, ch)
  ch = ch or self:Chapter(id)
  local g = Q.Guides and Q.Guides:Get(id)
  local sim = simOf(g)
  if not (ch and sim) then return nil end
  if ch.closed and type(ch.delta) == "number" then return ch.delta, ch.expected or 0 end
  local expected = sim.minutes * 60 * math.max(0, (ch.frac or 0) - (ch.frac0 or 0))
  return expected - (ch.active or 0), expected
end

---------------------------------------------------------------------------
-- Passages (compte)
---------------------------------------------------------------------------
local function newId()
  local r = math.random and math.random(0, 0xFFFF) or 0
  return string.format("%08x%04x", clock() % 0x100000000, r)
end

local function copySteps(id)
  local all = Q.char and Q.char.telemetry
  local slot = type(all) == "table" and all[id]
  if type(slot) ~= "table" then return nil end
  local out = {}
  for k, v in pairs(slot) do
    if type(k) == "number" and type(v) == "number" then out[k] = v end
  end
  return next(out) and out or nil
end

local function copyZones(zones)
  local out = {}
  for m, z in pairs(zones or {}) do
    if type(z) == "table" then out[m] = { sec = z.sec, xp = z.xp, lvlIn = z.lvlIn, lvlOut = z.lvlOut } end
  end
  return out
end

-- Clôt le passage du chapitre id : écart final et passage du compte (option telemetry).
function Pace:Close(id)
  local ch = self:Chapter(id)
  if not ch or ch.closed then return nil end
  local delta, expected = self:ChapterDelta(id, ch)
  ch.closed = true
  ch.closedAt = clock()
  ch.delta, ch.expected = delta, expected
  ch.lvlOut = exactLevel()
  if (ch.active or 0) < 60 then return nil end
  if Q.Settings and Q.Settings:Get("telemetry") == false then return nil end
  local acc = self:AccountData()
  if not acc then return nil end
  local g = Q.Guides and Q.Guides:Get(id)
  local sim = simOf(g)
  local P = Q.Player or {}
  local run = {
    id = newId(), guide = id, sec = math.floor(ch.active + 0.5),
    simMin = sim and sim.minutes or nil, simSteps = sim and sim.steps or nil,
    frac0 = math.floor((ch.frac0 or 0) * 1000 + 0.5) / 1000, frac = math.floor((ch.frac or 0) * 1000 + 0.5) / 1000,
    faction = P.faction, class = P.classFile, race = P.raceKey,
    lvlIn = ch.lvlIn, lvlOut = ch.lvlOut, xp = ch.xp or 0,
    date = clock(), ver = Q.version, zones = copyZones(ch.zones), steps = copySteps(id),
  }
  run.partial = (run.frac0 > FULL_START or run.frac < FINISH_FRAC) or nil
  acc.runs[#acc.runs + 1] = run
  Q:Fire("PACE_RUN_SAVED", run)
  return run
end

-- Passages du compte pour un chapitre, les plus récents d'abord.
function Pace:Runs(id)
  local acc = self:AccountData()
  local out = {}
  if not acc then return out end
  for _, r in ipairs(acc.runs) do
    if type(r) == "table" and r.guide == id then out[#out + 1] = r end
  end
  table.sort(out, function(a, b) return (a.date or 0) > (b.date or 0) end)
  return out
end

-- Meilleur passage complet du compte pour ce chapitre, ou nil.
function Pace:Best(id)
  local best
  for _, r in ipairs(self:Runs(id)) do
    if not r.partial and type(r.sec) == "number" and (not best or r.sec < best.sec) then best = r end
  end
  return best
end

function Pace:Recent(id, n)
  local runs = self:Runs(id)
  local out = {}
  for i = 1, math.min(n or RECENT, #runs) do out[i] = runs[i] end
  return out
end

---------------------------------------------------------------------------
-- Calibrage et prévisions
---------------------------------------------------------------------------
-- Rapport de vitesse du joueur sur la simulation (1.13 = 13 % plus rapide), mesuré sur les chapitres
-- du personnage, sinon sur les passages du compte ; -> rapport, source ("char" | "account"), ou nil.
function Pace:Ratio()
  local p = self:CharData()
  local expected, active = 0, 0
  if p then
    for id, ch in pairs(p.chapters) do
      local _, exp = self:ChapterDelta(id, ch)
      if exp and (ch.active or 0) > 0 then
        expected, active = expected + exp, active + ch.active
      end
    end
  end
  if active >= MIN_CALIBRATE and expected > 0 then return expected / active, "char" end
  local acc = self:AccountData()
  expected, active = 0, 0
  for _, r in ipairs(acc and acc.runs or {}) do
    if type(r) == "table" and type(r.simMin) == "number" and type(r.sec) == "number" and r.sec > 0 then
      expected = expected + r.simMin * 60 * math.max(0, (r.frac or 1) - (r.frac0 or 0))
      active = active + r.sec
    end
  end
  if active >= MIN_CALIBRATE and expected > 0 then return expected / active, "account" end
  return nil
end

-- XP par heure du joueur sur son temps actif de la session (au moins 10 minutes), sinon la fenêtre
-- glissante de Engine/XPRate.lua, sinon la simulation corrigée par le rapport de vitesse.
function Pace:XPPerHour()
  local s = self:Session()
  if s and (s.active or 0) >= MIN_CALIBRATE and (s.xp or 0) > 0 then return s.xp * 3600 / s.active end
  local X = Q.XPRate
  local rate = X and X.Rate and X:Rate()
  if rate and rate > 0 then return rate end
  local _, g = guideId()
  local sim = simOf(g)
  if sim and type(sim.xpPerHour) == "number" and sim.xpPerHour > 0 then return sim.xpPerHour * (self:Ratio() or 1) end
  return nil
end

-- -> secondes avant la fin du chapitre courant au rythme du joueur, temps simulé restant ; ou nil.
function Pace:ChapterETA()
  local _, g = guideId()
  local sim = simOf(g)
  local frac = self:Fraction()
  if not (sim and frac) then return nil end
  local remaining = sim.minutes * 60 * math.max(0, 1 - frac)
  return remaining / (self:Ratio() or 1), remaining
end

-- -> secondes avant le prochain niveau, prochain niveau, XP/h utilisée ; ou nil.
function Pace:LevelETA()
  local xp, max = readXP()
  local rate = self:XPPerHour()
  if not (xp and max and rate and rate > 0 and max > xp) then return nil end
  return (max - xp) / rate * 3600, level() + 1, rate
end

-- Écart sur toute la route : somme des écarts des chapitres mesurés du personnage ; -> secondes, nombre.
function Pace:RouteDelta()
  local p = self:CharData()
  if not p then return nil end
  local total, n = 0, 0
  for id, ch in pairs(p.chapters) do
    local d = self:ChapterDelta(id, ch)
    if d and (ch.active or 0) > 0 then total, n = total + d, n + 1 end
  end
  if n == 0 then return nil end
  return total, n
end

---------------------------------------------------------------------------
-- Textes
---------------------------------------------------------------------------
-- Écart en texte : "+12 min d'avance", "8 min de retard", "dans les temps" ; -> texte, code couleur.
function Pace.DeltaText(seconds)
  if type(seconds) ~= "number" then return nil end
  if math.abs(seconds) < EVEN then return L.PACE_EVEN, Pace.COLOR_EVEN end
  if seconds > 0 then return fmt(L.PACE_AHEAD, duration(seconds)), Pace.COLOR_AHEAD end
  return fmt(L.PACE_BEHIND, duration(-seconds)), Pace.COLOR_BEHIND
end

-- Écart court des colonnes du journal : "+11 min", "-6 min".
function Pace.DeltaShort(seconds)
  if type(seconds) ~= "number" then return nil end
  if math.abs(seconds) < EVEN then return "=", Pace.COLOR_EVEN end
  local minutes = math.floor(math.abs(seconds) / 60 + 0.5)
  if seconds > 0 then return fmt(L.PACE_DELTA_PLUS, minutes), Pace.COLOR_AHEAD end
  return fmt(L.PACE_DELTA_MINUS, minutes), Pace.COLOR_BEHIND
end

local function painted(text, code)
  if not text then return nil end
  return "|c" .. code .. text .. "|r"
end
Pace.Painted = painted

local function showEnabled()
  return not (Q.Settings and Q.Settings:Get("showPace") == false)
end

-- Écart du chapitre courant pour le suivi (coloré), ou nil (option coupée, chapitre sans simulation,
-- moins de 3 minutes mesurées).
function Pace:TrackerText()
  if not showEnabled() then return nil end
  local id = guideId()
  local ch = self:Chapter(id)
  if not ch or (ch.active or 0) < MIN_SHOW then return nil end
  local d = self:ChapterDelta(id, ch)
  return painted(Pace.DeltaText(d))
end

-- Lignes de l'infobulle de la ligne du suivi : { titre, ligne, ... } ; nil sans écart à montrer.
function Pace:TooltipLines()
  local id = guideId()
  local ch = self:Chapter(id)
  if not ch then return nil end
  local d, expected = self:ChapterDelta(id, ch)
  if not d then return nil end
  local lines = { L.PACE_TITLE }
  lines[#lines + 1] = fmt(L.PACE_TIP_CHAPTER, painted(Pace.DeltaText(d)))
  lines[#lines + 1] = "|cffaaaaaa" .. fmt(L.PACE_TIP_DETAIL, Pace.Clock(expected), Pace.Clock(ch.active or 0)) .. "|r"
  local route = self:RouteDelta()
  if route then lines[#lines + 1] = fmt(L.PACE_TIP_ROUTE, painted(Pace.DeltaText(route))) end
  local eta = self:ChapterETA()
  if eta then lines[#lines + 1] = fmt(L.PACE_TIP_CHAPTER_ETA, duration(eta)) end
  local lvlEta, nextLevel = self:LevelETA()
  if lvlEta then lines[#lines + 1] = fmt(L.PACE_TIP_LEVEL_ETA, nextLevel, duration(lvlEta)) end
  local ratio = self:Ratio()
  if ratio then
    lines[#lines + 1] = "|cffaaaaaa" .. fmt(L.PACE_TIP_RATIO, math.floor(ratio * 100 + 0.5)) .. "|r"
  else
    lines[#lines + 1] = "|cffaaaaaa" .. L.PACE_TIP_NO_RATIO .. "|r"
  end
  lines[#lines + 1] = "|cff66bbff" .. L.PACE_TIP_CLICK .. "|r"
  return lines
end

-- Résumé de session pour la discussion (/qf session) : liste de lignes.
function Pace:SessionLines(s)
  s = s or self:Session()
  if type(s) ~= "table" then return { L.PACE_SESSION_NONE } end
  local down = s.down or {}
  local afk, dead, idle = down.afk or 0, down.dead or 0, down.idle or 0
  local out = {}
  out[#out + 1] = fmt(L.PACE_SESSION_TIME, duration(s.wall or 0), duration(s.active or 0),
    duration(afk + dead + idle), duration(afk), duration(idle), duration(dead))
  local rate = (s.active or 0) > 0 and (s.xp or 0) * 3600 / s.active or 0
  out[#out + 1] = fmt(L.PACE_SESSION_XP, short(s.xp or 0), short(rate), s.levels or 0)
  for _, z in ipairs(self.ZoneRows(s)) do
    out[#out + 1] = fmt(L.PACE_SESSION_ZONE, z.name, duration(z.sec), short(z.xp), short(z.rate))
  end
  return out
end

-- Zones d'une session, triées par temps actif : { { map, name, sec, xp, rate } }.
function Pace.ZoneRows(s)
  local out = {}
  for map, z in pairs(type(s) == "table" and s.zones or {}) do
    if type(z) == "table" and (z.sec or 0) > 0 then
      local name = Q.Maps and Q.Maps.MapName and Q.Maps:MapName(map) or tostring(map)
      out[#out + 1] = { map = map, name = name, sec = z.sec, xp = z.xp or 0, rate = (z.xp or 0) * 3600 / z.sec }
    end
  end
  table.sort(out, function(a, b)
    if a.sec ~= b.sec then return a.sec > b.sec end
    return tostring(a.map) < tostring(b.map)
  end)
  return out
end

---------------------------------------------------------------------------
-- Mesure
---------------------------------------------------------------------------
local pendingXP = 0     -- XP gagnée depuis la dernière tranche
local lastXP, lastMax
local levelUps = 0      -- montées de niveau depuis la dernière tranche
local lastPos           -- { map, x, y }
local lastActivity      -- GetTime() du dernier gain d'XP, mouvement ou combat
local pendingStill = 0  -- secondes immobiles pas encore attribuées (actives ou temps mort)
local lastGuide         -- chapitre de la tranche précédente
local ticker

function Pace:Reset()
  pendingXP, levelUps, pendingStill = 0, 0, 0
  lastXP, lastMax, lastPos, lastGuide = nil, nil, nil, nil
  lastActivity = now()
end

function Pace:OnXP()
  local xp, max = readXP()
  if not xp then return end
  if lastXP then
    local gain
    if xp < lastXP or (lastMax and max ~= lastMax) then
      gain = math.max(0, (lastMax or 0) - lastXP) + xp
      levelUps = levelUps + 1
    else
      gain = xp - lastXP
    end
    if gain > 0 then
      pendingXP = pendingXP + gain
      lastActivity = now()
    end
  end
  lastXP, lastMax = xp, max
end

local function currentMap()
  local m = Q.Maps and Q.Maps.PlayerPos and Q.Maps:PlayerPos()
  return m
end

local function moved()
  local m, x, y = Q.Maps:PlayerPos()
  if not m then return false end
  local p = lastPos
  lastPos = { m, x, y }
  if not p then return false end
  return p[1] ~= m or math.abs(p[2] - x) > MOVE_EPS or math.abs(p[3] - y) > MOVE_EPS
end

-- Ajoute des secondes actives (et l'XP) à la session, au chapitre ouvert et à leurs zones.
local function credit(self, s, ch, map, seconds, xp)
  local lvl = exactLevel()
  s.active = (s.active or 0) + seconds
  s.xp = (s.xp or 0) + xp
  local sz = zone(s.zones, map)
  if sz then sz.sec, sz.xp, sz.lvlOut = sz.sec + seconds, sz.xp + xp, lvl end
  if ch and not ch.closed then
    ch.active = (ch.active or 0) + seconds
    ch.xp = (ch.xp or 0) + xp
    ch.lvlOut = lvl
    local cz = zone(ch.zones, map)
    if cz then cz.sec, cz.xp, cz.lvlOut = cz.sec + seconds, cz.xp + xp, lvl end
  end
end

-- Une tranche de TICK secondes.
function Pace:Tick()
  local s = self:Session()
  if not s then return end
  -- scène de /qf demo affichée (UI/Demo.lua) : étapes et alertes simulées, rien n'est mesuré
  local demo = Q.UI and Q.UI.Demo
  if demo and demo.showing then return end
  if not lastXP then self:OnXP() end
  local t = now()
  s.wall = (s.wall or 0) + TICK
  s.lastTick = clock()
  s.down = s.down or { afk = 0, dead = 0, idle = 0 }
  local gained = pendingXP
  pendingXP = 0
  s.levels = (s.levels or 0) + levelUps
  levelUps = 0

  -- chapitre courant : passage clos quand on le quitte presque fini (Pace:Left), ou quand il est fini
  local id = guideId()
  self:Left(id)
  local ch = id and self:Chapter(id, true)
  if ch and not ch.closed then ch.frac = self:Fraction() or ch.frac end

  local move = moved()
  local fighting = flag(UnitAffectingCombat)
  if gained > 0 or move or fighting then lastActivity = t end
  lastActivity = lastActivity or t
  local map = currentMap()
  if flag(UnitIsAFK) and gained == 0 then
    s.down.afk = (s.down.afk or 0) + TICK + pendingStill
    pendingStill = 0
  elseif flag(UnitIsDeadOrGhost) and gained == 0 then
    if pendingStill > 0 then credit(self, s, ch, map, pendingStill, 0) end
    pendingStill = 0
    s.down.dead = (s.down.dead or 0) + TICK
  elseif gained > 0 or move or fighting then
    credit(self, s, ch, map, TICK + pendingStill, gained)
    pendingStill = 0
  elseif t - lastActivity >= IDLE_AFTER then
    s.down.idle = (s.down.idle or 0) + TICK + pendingStill
    pendingStill = 0
  else
    pendingStill = pendingStill + TICK
  end

  if ch and not ch.closed and Q.Progress:GuideFinished() then self:Close(id) end
  self:Changed()
end

-- Part faite d'un chapitre qui n'est plus le chapitre courant : ses rendus sont tous faits
-- (Progress:ChapterDone) -> toutes ses étapes sauf les passées ; sinon nil (part gardée telle quelle).
local function finishedFraction(id)
  local P, g = Q.Progress, Q.Guides and Q.Guides:Get(id)
  if not (g and P and P.ChapterDone and P:ChapterDone(g)) then return nil end
  local total, skipped = #g.steps, 0
  local list = Q.char and Q.char.skipped or {}
  for i = 1, total do
    if list["g:" .. id .. ":" .. i] then skipped = skipped + 1 end
  end
  if total == 0 then return nil end
  return (total - skipped) / total
end

-- Le chapitre courant est maintenant id : le passage du chapitre quitté est clos s'il est presque fini
-- (au moins 90 % des étapes faites) ; sinon sa mesure reste ouverte pour une reprise.
function Pace:Left(id)
  if lastGuide and lastGuide ~= id then
    local prev = self:Chapter(lastGuide)
    if prev and not prev.closed then
      local done = finishedFraction(lastGuide)
      if done and done > (prev.frac or 0) then prev.frac = done end
      if (prev.frac or 0) >= FINISH_FRAC then self:Close(lastGuide) end
    end
  end
  lastGuide = id
end

-- Progression changée : part faite du chapitre courant à jour (sans attendre la tranche suivante).
function Pace:OnProgress()
  local demo = Q.UI and Q.UI.Demo
  if demo and demo.showing then return end
  local id = guideId()
  self:Left(id)
  local ch = self:Chapter(id)
  if ch and not ch.closed then ch.frac = self:Fraction() or ch.frac end
  self:Changed()
end

local lastText
function Pace:Changed()
  local text = self:TrackerText()
  if text ~= lastText then
    lastText = text
    Q:Fire("COMFORT_CHANGED", "pace")
  end
  Q:Fire("PACE_UPDATED")
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
lastActivity = now()

Q:On("LOGIN", function()
  Pace:Reset()
  Pace:StartSession()
  Pace:OnXP()
  if not ticker then ticker = Q:NewTicker(TICK, function() Pace:Tick() end) end
end)

Q:RegisterEvent("PLAYER_XP_UPDATE", function(_, unit)
  if isSecret(unit) then return end
  if unit ~= nil and unit ~= "player" then return end
  Pace:OnXP()
end)

Q:On("PROGRESS_UPDATED", function() Pace:OnProgress() end)

-- Bascule automatique vers la suite d'un chapitre fini (Engine/Progress.lua, checkRollover) : le chapitre
-- quitté est fait en entier, sauf ses étapes passées.
Q:On("GUIDE_CHANGED", function(_, finished)
  if type(finished) ~= "table" or not finished.id then return end
  local demo = Q.UI and Q.UI.Demo
  if demo and demo.showing then return end
  local ch = Pace:Chapter(finished.id)
  if not ch or ch.closed then return end
  local total, skipped = #(finished.steps or {}), 0
  local list = Q.char and Q.char.skipped or {}
  for i = 1, total do
    if list["g:" .. finished.id .. ":" .. i] then skipped = skipped + 1 end
  end
  if total > 0 then ch.frac = math.max(ch.frac or 0, (total - skipped) / total) end
  Pace:Close(finished.id)
end)

Q:On("SETTINGS_CHANGED", function(path)
  if path == "showPace" then Pace:Changed() end
end)
