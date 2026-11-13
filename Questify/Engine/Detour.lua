local addonName, Q = ...

-- Zone de secours : quand la zone du chapitre est impraticable (monstres trop forts, zone envahie par
-- l'autre faction), le joueur passe sur une autre zone adaptée à son niveau, un peu moins rentable, puis
-- revient à son chemin. Sans interface (bouton du journal, /qf alt).
--
-- Choix de la zone de secours (Detour:Candidates) : chapitres de la faction et de la race du personnage,
-- hors chapitre courant, hors chapitres qui partagent une de ses zones, hors chapitres déjà finis. Le
-- niveau compte avec la barre d'XP (15,4 = niveau 15 à 40 %, Q.RouteChoice:PlayerLevel) :
--   under = niveaux sous le début de la tranche du chapitre (au plus MAX_UNDER) ;
--   over  = niveaux au-dessus de sa fin (au plus MAX_OVER).
-- Score = XP/h simulée relative x part des quêtes restantes - 0,5 x under - 0,35 x over (mêmes poids que
-- le choix de suite, Engine/RouteChoice.lua). Rien n'est estimé en jeu.
--
-- Retour (Detour:ReturnTarget) : le chapitre quitté s'il est encore à la portée du personnage et pas fini,
-- sinon le chapitre de son niveau dans son parcours. À la fin de la zone de secours, le retour est
-- automatique (Q.Guides:Next) ; le chemin se recale donc toujours sur le niveau du personnage.
--
-- État : Q.char.detour = { from = <chapitre quitté>, to = <zone de secours> }.
local Detour = {}
Q.Detour = Detour

local MAX_UNDER, MAX_OVER = 1, 2
Detour.MAX_UNDER, Detour.MAX_OVER = MAX_UNDER, MAX_OVER

local function mode()
  return Q.DungeonMode and Q.DungeonMode:Mode() or nil
end

local function level()
  local R = Q.RouteChoice
  if R and R.PlayerLevel then return R:PlayerLevel() end
  return tonumber(Q.Player and Q.Player.level) or 1
end

local function zonesOf(g)
  local set = {}
  local R = Q.RouteChoice
  local list = R and R.ZoneMaps and R:ZoneMaps(g) or {}
  for _, m in ipairs(list) do set[m] = true end
  local main = Q.Guides:MainMap(g)
  if main then set[main] = true end
  return set
end

local function shares(a, b)
  for m in pairs(a) do if b[m] then return true end end
  return false
end

-- Part des quêtes du chapitre qu'il reste à rendre (1 sans quête).
local function remaining(g)
  local total, left = 0, 0
  for _, s in ipairs(g.steps or {}) do
    if s.action == "turnin" and type(s.questId) == "number" then
      total = total + 1
      if not Q.Progress:IsTurnedIn(s.questId) then left = left + 1 end
    end
  end
  if total == 0 then return 1 end
  return left / total
end

-- Current() -> { from, to } tant que le personnage est sur sa zone de secours, sinon nil.
function Detour:Current()
  local c = Q.char
  local d = c and c.detour
  if type(d) ~= "table" then return nil end
  local g = Q.Progress and Q.Progress:Guide()
  if not g or g.id ~= d.to then return nil end
  return d
end

-- Candidates() -> { { guide, score, under, over }, ... } de la meilleure zone de secours à la moins bonne.
function Detour:Candidates()
  local out = {}
  local Pr = Q.Progress
  local cur = Pr and Pr:IsEnabled() and Pr:Guide()
  if not cur then return out end
  local P = Q.Player or {}
  local lvl, m = level(), mode()
  local d = self:Current()
  local avoid = zonesOf(cur)
  local from = d and Q.Guides:Get(d.from)
  -- depuis une zone de secours : la zone fuie au départ reste à éviter
  if from then for m in pairs(zonesOf(from)) do avoid[m] = true end end
  local best = 0
  local list = {}
  for _, g in ipairs(Q.Guides:All()) do
    -- chapitres habituels, plus ceux du mode automatique quand il est actif
    if g ~= cur and g ~= from and g.faction == P.faction and (g.mode == nil or g.mode == m)
      and (g.races == nil or Q.Util.Contains(g.races, P.raceKey))
      and not shares(avoid, zonesOf(g)) and not Pr:ChapterDone(g) then
      local under = math.max(0, (g.minLevel or 1) - lvl)
      local over = math.max(0, lvl - (g.maxLevel or 60))
      if under <= MAX_UNDER and over <= MAX_OVER then
        local rate = type(g.sim) == "table" and tonumber(g.sim.xpPerHour) or 0
        if rate > best then best = rate end
        list[#list + 1] = { guide = g, under = under, over = over, rate = rate, left = remaining(g) }
      end
    end
  end
  for _, c in ipairs(list) do
    local rel = best > 0 and c.rate / best or 0.5
    c.score = rel * c.left - 0.5 * c.under - 0.35 * c.over
    out[#out + 1] = c
  end
  table.sort(out, function(a, b)
    if math.abs(a.score - b.score) > 1e-9 then return a.score > b.score end
    return a.guide.id < b.guide.id
  end)
  return out
end

-- Start() -> chapitre de secours ouvert, ou nil s'il n'y en a aucun pour ce niveau. Depuis une zone de
-- secours, passe à la suivante ; le chapitre à retrouver reste celui quitté au départ.
function Detour:Start()
  local c = Q.char
  local cur = Q.Progress and Q.Progress:Guide()
  if not (c and cur) then return nil end
  local pick = self:Candidates()[1]
  if not pick then return nil end
  local d = self:Current()
  local from = d and d.from or cur.id
  c.detour = { from = from, to = pick.guide.id }
  Q.Progress:SetGuide(pick.guide.id, true)
  Q:Fire("DETOUR_CHANGED")
  return pick.guide
end

-- ReturnTarget() -> chapitre où revenir depuis la zone de secours, selon le niveau du personnage.
function Detour:ReturnTarget()
  local d = self:Current()
  if not d then return nil end
  local P = Q.Player or {}
  local lvl = level()
  local from = Q.Guides:Get(d.from)
  if from and lvl < (from.maxLevel or 60) + 1 and not Q.Progress:ChapterDone(from) then return from end
  local g = Q.Guides:ForPlayer(P.faction, P.raceKey, math.floor(lvl), mode())
  if g and g.id ~= d.to then return g end
  return from
end

-- Return() -> chapitre retrouvé, ou nil hors zone de secours.
function Detour:Return()
  local target = self:ReturnTarget()
  if not target then return nil end
  Q.char.detour = nil
  Q.Progress:SetGuide(target.id, true)
  Q:Fire("DETOUR_CHANGED")
  return target
end

-- NextAfter(guide) -> suite d'une zone de secours finie : le retour au chemin (Q.Guides:Next).
function Detour:NextAfter(guide)
  local d = self:Current()
  if d and type(guide) == "table" and guide.id == d.to then return self:ReturnTarget() end
  return nil
end

-- Le personnage a changé de chapitre autrement (journal, fin de zone) : la zone de secours est close.
Q:On("GUIDE_CHANGED", function(g)
  local c = Q.char
  if c and type(c.detour) == "table" and not (type(g) == "table" and g.id == c.detour.to) then
    c.detour = nil
    Q:Fire("DETOUR_CHANGED")
  end
end)
