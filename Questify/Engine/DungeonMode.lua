local addonName, Q = ...

-- Mode « Donjons » : un second parcours de montée de niveau, centré sur les donjons 5 joueurs, à côté des
-- guides habituels (qui ne changent pas). Sans interface (UI/DungeonModePanel.lua l'affiche).
--
-- Données : Q.DungeonRouteData (Guides\DungeonRouteData.lua, généré par
-- tools/routebuilder/build_dungeon_route.lua, relu à chaque appel) : un échelon par donjon ou par aile,
-- dans l'ordre joué, avec son niveau d'entrée, ses quêtes et ses étoiles (part d'un niveau que donnent ses
-- quêtes ; méthode dans docs/dungeon-mode/README.md).
--
-- Chapitres : ceux dont le champ mode vaut "dungeon" (Q:RegisterGuide). Le mode n'existe pour un
-- personnage que si sa faction a de tels chapitres : sinon tout se passe comme avant.
--
-- Choix du joueur, par personnage (Q.char.dungeonMode) :
--   on       mode choisi ;
--   off      [échelon] = true : case décochée (toutes cochées par défaut) ;
--   bypassed [échelon] = true : quêtes prises mais instance contournée (pas de groupe).
--
-- Étapes des chapitres du mode (champs lus par Q.Guides:Normalize) :
--   rung = "<échelon>", phase = "prep" | "run"
--       prep : suites, quêtes d'accès et prises des quêtes du donjon, détours qui ne servent qu'à lui ;
--       run  : aller à l'entrée, objectifs dans l'instance, rendus.
--       Case décochée : toutes passées. Instance contournée : seules les étapes « run » sont passées.
--   alt = "<échelon>" : alternative en extérieur, jouée quand la case est décochée ou l'instance
--       contournée ; avec below = N, jouée aussi tant que le personnage est sous le niveau N (l'instance
--       n'a pas donné assez d'XP pour l'échelon suivant).
--   below = N (sans alt) : étape de rattrapage, passée dès le niveau N.
-- Le donjon ne bloque donc jamais la route.
local DungeonMode = {}
Q.DungeonMode = DungeonMode

local MODE = "dungeon"
DungeonMode.MODE = MODE
local serial = 0   -- change à chaque choix (caches de Engine/Progress.lua)

local function saved()
  local c = Q.char
  if type(c) ~= "table" then return nil end
  if type(c.dungeonMode) ~= "table" then c.dungeonMode = {} end
  local s = c.dungeonMode
  if type(s.off) ~= "table" then s.off = {} end
  if type(s.bypassed) ~= "table" then s.bypassed = {} end
  return s
end

local function data()
  local d = Q.DungeonRouteData
  if type(d) ~= "table" or type(d.rungs) ~= "table" then return nil end
  return d
end

local function validRung(r)
  return type(r) == "table" and type(r.key) == "string" and type(r.dungeon) == "string"
end

local function changed()
  serial = serial + 1
  Q:Fire("DUNGEON_MODE_CHANGED")
end

function DungeonMode:Serial()
  return serial
end

-- Rung(key) -> échelon des données, ou nil.
function DungeonMode:Rung(key)
  local d = data()
  if not d or key == nil then return nil end
  for _, r in ipairs(d.rungs) do
    if validRung(r) and r.key == key then return r end
  end
  return nil
end

-- Available(faction) -> vrai si le mode existe pour la faction (celle du personnage par défaut) : données
-- de l'échelle pour elle et au moins un chapitre du mode.
function DungeonMode:Available(faction)
  faction = faction or (Q.Player and Q.Player.faction)
  local d = data()
  if not d or faction == nil or d.faction ~= faction then return false end
  return Q.Guides ~= nil and Q.Guides:HasMode(MODE, faction)
end

-- IsOn() -> le joueur a choisi le mode et il existe pour son personnage.
function DungeonMode:IsOn()
  local s = saved()
  return s ~= nil and s.on == true and self:Available()
end

-- Mode() -> "dungeon" ou nil : valeur du champ mode des chapitres de la route du personnage.
function DungeonMode:Mode()
  if self:IsOn() then return MODE end
  return nil
end

-- SetOn(on) : choisit le mode et relance le choix du chapitre pour le niveau du personnage.
-- -> vrai si le mode a changé.
function DungeonMode:SetOn(on)
  local s = saved()
  if not s then return false end
  on = on and true or false
  if on and not self:Available() then return false end
  if (s.on == true) == on then return false end
  s.on = on
  changed()
  local P = Q.Player or {}
  local Pr = Q.Progress
  if Pr and Pr:IsEnabled() and Q.Guides then
    local g = Q.Guides:ForPlayer(P.faction, P.raceKey, P.level, self:Mode())
    if g then Pr:SetGuide(g.id) end
  end
  return true
end

function DungeonMode:IsChecked(key)
  local s = saved()
  return not (s and s.off[key])
end

function DungeonMode:IsBypassed(key)
  local s = saved()
  return s ~= nil and s.bypassed[key] == true
end

-- SetChecked(key, checked) : case de l'échelon. Recocher efface aussi le contournement.
function DungeonMode:SetChecked(key, checked)
  local s = saved()
  if not s or not self:Rung(key) then return false end
  if checked then
    s.off[key] = nil
    s.bypassed[key] = nil
  else
    s.off[key] = true
  end
  changed()
  return true
end

-- SetBypassed(key, bypassed) : contourne (ou reprend) l'instance d'un échelon coché, quêtes gardées.
function DungeonMode:SetBypassed(key, bypassed)
  local s = saved()
  if not s or not self:Rung(key) or s.off[key] then return false end
  s.bypassed[key] = bypassed and true or nil
  changed()
  return true
end

-- État d'un échelon : "off" (décoché), "bypassed" (instance contournée), "on".
function DungeonMode:State(key)
  if not self:IsChecked(key) then return "off" end
  if self:IsBypassed(key) then return "bypassed" end
  return "on"
end

-- Rungs() -> { { rung, key, state, stars, done, total }, ... } dans l'ordre joué. done / total : quêtes
-- de l'échelon rendues (0 / 0 sans Q.Progress).
function DungeonMode:Rungs()
  local out = {}
  local d = data()
  if not d then return out end
  local Pr = Q.Progress
  for _, r in ipairs(d.rungs) do
    if validRung(r) then
      local done, total = 0, 0
      for _, id in ipairs(type(r.quests) == "table" and r.quests or {}) do
        total = total + 1
        if Pr and Pr.IsTurnedIn and Pr:IsTurnedIn(id) then done = done + 1 end
      end
      out[#out + 1] = { rung = r, key = r.key, state = self:State(r.key),
        stars = math.max(0, math.min(3, tonumber(r.stars) or 0)), done = done, total = total }
    end
  end
  return out
end

-- StepSkip(step, level) -> raison pour laquelle l'étape est passée ("rung-off", "rung-bypass", "rung-alt",
-- "rung-level"), ou nil. Un échelon inconnu des données ne passe rien (la route reste jouable).
function DungeonMode:StepSkip(step, level)
  if type(step) ~= "table" then return nil end
  level = tonumber(level) or tonumber(Q.Player and Q.Player.level) or 1
  if step.rung ~= nil then
    if not self:Rung(step.rung) then return nil end
    local state = self:State(step.rung)
    if state == "off" then return "rung-off" end
    if state == "bypassed" and step.phase == "run" then return "rung-bypass" end
    return nil
  end
  if step.alt ~= nil then
    if not self:Rung(step.alt) then return nil end
    if self:State(step.alt) ~= "on" then return nil end
    if type(step.below) == "number" and level < step.below then return nil end
    return "rung-alt"
  end
  if type(step.below) == "number" and level >= step.below then return "rung-level" end
  return nil
end
