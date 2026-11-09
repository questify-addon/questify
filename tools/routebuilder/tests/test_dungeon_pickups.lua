-- Tests des quêtes de donjon prises au passage (sim.lua) : chaque chapitre prend les quêtes des donjons du
-- catalogue (dungeon_catalog.lua) dont le donneur est dans sa région, avec leurs pré-requis, sans farmer pour
-- leur niveau requis.
local F = require("fixture_zone")
local sim = require("sim")

local function indexOf(steps, action, q)
  for i, s in ipairs(steps) do
    if s[1] == action and s[2] == q then return i end
  end
end

local function dropped(report, q)
  for _, d in ipairs(report.dropped) do if d.id == q then return d.reason end end
end

local function stepsText(steps)
  local out = {}
  for i, s in ipairs(steps) do
    local parts = {}
    for k = 1, #s do parts[#parts + 1] = tostring(s[k]) end
    out[i] = table.concat(parts, " ")
  end
  return table.concat(out, " | ")
end

local function copy(t)
  local o = {}
  for k, v in pairs(t) do o[k] = v end
  return o
end

-- Zone de test + donjon « Fixture Deeps » (zone 9100) au catalogue, niveaux 4-10, et une quête de donjon 120
-- donnée au hub 1.
local function dungeonD(def)
  local D = F.D()
  D.dungeonAreas[9100] = "Fixture Deeps"
  D.dungeonCatalog = { ["Fixture Deeps"] = def or { key = "FIX", area = 9100, min = 4, max = 10 } }
  local q = copy(D.quests[103])
  q.id, q.name, q.level, q.zoneOrSort = 120, "Into the Deeps", 6, 9100
  D.quests[120] = q
  D.xp[120] = { 6, 900 }
  return D
end

local function run(D, opts)
  local steps, report, state
  state = F.state()
  steps, report = sim.chapter(D, F.W(), F.plan(), state, opts or { _noWiden = true })
  return steps, report, state
end

return {
  -- Sans liste de donjons dans le plan : la quête est prise (étape optional + dungeon), jamais rendue.
  dungeon_quest_picked_up_without_plan_list = function(t)
    local steps = run(dungeonD())
    local i = indexOf(steps, "accept", 120)
    t.ok(i, "dungeon quest picked up: " .. stepsText(steps))
    t.eq(steps[i].optional, true)
    t.eq(steps[i].dungeon, "Fixture Deeps")
    t.eq(indexOf(steps, "turnin", 120), nil, "never turned in")
  end,

  -- Hors catalogue, réservé à l'autre faction, ou dépassé avant le chapitre : pas prise, raison au rapport.
  dungeon_quest_left_out_of_the_catalogue_or_outleveled = function(t)
    local D = dungeonD()
    D.dungeonCatalog = {}
    local steps, report = run(D)
    t.eq(indexOf(steps, "accept", 120), nil)
    t.eq(dropped(report, 120), "dungeon quest (Fixture Deeps outside the dungeon catalogue)")

    steps, report = run(dungeonD({ key = "FIX", area = 9100, min = 4, max = 10, only = "Horde" }))
    t.eq(indexOf(steps, "accept", 120), nil)
    t.eq(dropped(report, 120), "dungeon quest (Fixture Deeps closed to the Alliance)")

    D = dungeonD({ key = "FIX", area = 9100, min = 1, max = 3 })
    local plan = F.plan()
    plan.minLevel = 4
    steps, report = sim.chapter(D, F.W(), plan, F.state(), { _noWiden = true })
    t.eq(indexOf(steps, "accept", 120), nil)
    t.eq(dropped(report, 120), "dungeon quest (Fixture Deeps outleveled: up to level 3)")
  end,

  -- Pré-requis d'une quête de donjon (chaîne faite dans la zone) : gardé même au rendement faible.
  dungeon_prerequisite_kept_despite_a_low_ratio = function(t)
    -- 121 : message du hub 1 à porter au hub 2 (Giver Three), presque sans XP ; la quête de donjon 120 est
    -- alors donnée au hub 2
    local function withErrand(linked)
      local D = dungeonD()
      local pre = copy(D.quests[105])
      pre.id, pre.name, pre.breadcrumbFor = 121, "Word for the Deeps", nil
      pre.finishers = { npcs = { 2002 }, objects = {} }
      D.quests[121] = pre
      D.xp[121] = { 3, 5 }
      if linked then
        D.quests[120].starters = { npcs = { 2002 }, objects = {}, items = {} }
        D.quests[120].preSingle = { 121 }
        D.unlocks[121] = { 120 }
      end
      return D
    end
    local steps, report = run(withErrand(false))
    t.eq(dropped(report, 121), "low ratio", "control: errand dropped on its own: " .. stepsText(steps))

    steps, report = run(withErrand(true))
    local tn, a = indexOf(steps, "turnin", 121), indexOf(steps, "accept", 120)
    t.ok(tn and a, "prerequisite then dungeon quest: " .. stepsText(steps) .. " / " .. tostring((dropped(report, 121))))
    t.ok(tn < a)
    t.eq(steps[tn].optional, true, "kept only for the dungeon: optional")
    t.eq(steps[tn].dungeon, "Fixture Deeps")
  end,

  -- Quête de passage vers une quête de donjon donnée ailleurs (autre chapitre) : candidate au-dessus de la bande
  -- de niveaux de quête, gardée au rendement faible, étapes en optional + dungeon.
  dungeon_breadcrumb_kept_for_a_quest_given_elsewhere = function(t)
    local D = dungeonD()
    -- 120 : donnée hors de la région (aucune apparition de son donneur)
    D.npcs[2999] = { id = 2999, name = "Far Giver", minLevel = 5, maxLevel = 5, rank = 0, spawns = {},
                     friendly = "A", npcFlags = 0, questStarts = {}, questEnds = {} }
    D.quests[120].starters = { npcs = { 2999 }, objects = {}, items = {} }
    local bc = copy(D.quests[105])
    bc.id, bc.name, bc.level, bc.breadcrumbFor = 122, "Word of the Deeps", 10, nil
    bc.finishers = { npcs = { 2002 }, objects = {} }
    D.quests[122] = bc
    D.xp[122] = { 10, 5 }
    D.quests[120].preSingle = { 122 }
    local steps, report = run(D)
    local tn = indexOf(steps, "turnin", 122)
    t.ok(tn, "breadcrumb done: " .. stepsText(steps) .. " / " .. tostring((dropped(report, 122))))
    t.eq(steps[tn].optional, true)
    t.eq(steps[tn].dungeon, "Fixture Deeps")

    -- donjon dépassé : la quête de passage retrouve la bande de niveaux
    D = dungeonD({ key = "FIX", area = 9100, min = 1, max = 0 })
    D.quests[122] = bc
    D.xp[122] = { 10, 5 }
    D.quests[120].preSingle = { 122 }
    steps, report = run(D)
    t.eq(indexOf(steps, "accept", 122), nil)
    t.eq(dropped(report, 122), "quest level 10 above the band")
  end,

  -- Niveau requis : la prise attend le niveau (aucun farm pour elle) ; pas atteint dans le chapitre : laissée.
  dungeon_quest_waits_for_its_required_level_without_grinding = function(t)
    local _, base = run(F.D())
    local D = dungeonD()
    D.quests[120].reqLevel = 4
    local steps, report = run(D)
    local i = indexOf(steps, "accept", 120)
    t.ok(i, "picked up once level 4 is reached: " .. stepsText(steps))
    t.ok(steps[i]._c.simLevel >= 4, "accepted at level " .. tostring(steps[i]._c.simLevel))
    t.ok(steps[i - 1][1] ~= "level", "no grinding before the accept")
    -- (l'ordre des rendus peut bouger d'un mob ou deux d'XP, jamais d'un farm pour la prise)
    t.ok((report.grindMobs or 0) <= (base.grindMobs or 0) + 2, "no grinding for the dungeon quest")

    D = dungeonD()
    D.quests[120].reqLevel = 6
    steps, report = run(D)
    t.eq(indexOf(steps, "accept", 120), nil)
    t.eq(dropped(report, 120), "dungeon quest: required level 6 not reached in this chapter")
    t.ok((report.grindMobs or 0) <= (base.grindMobs or 0) + 2, "no grinding for the dungeon quest")
  end,
}
