-- Tests de la simulation de chapitre (sim.lua) et de l'ordonnancement (order.lua) sur la zone synthétique.
local F = require("fixture_zone")
local sim = require("sim")
local order = require("order")

local function run(opts)
  local D, W = F.D(), F.W()
  local state = F.state()
  local steps, report = sim.chapter(D, W, F.plan(), state, opts)
  return steps, report, state
end

-- index de la première étape (action, quête)
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

-- Zone de test + une quête de classe (Guerrier) qui suit 103, une autre trop loin, et une quête démarrée par un
-- objet qui tombe à 1 % des loups.
local function extendedD()
  local D = F.D()
  local base = D.quests[101]
  local function copy(t) local o = {}; for k, v in pairs(t) do o[k] = v end; return o end
  local q109 = copy(D.quests[102]); q109.id, q109.name, q109.level, q109.classes = 109, "Warrior Tusks", 3, 1
  q109.preSingle = { 103 }
  local q111 = copy(D.quests[106]); q111.id, q111.name, q111.classes = 111, "Warrior Far Errand", 1
  local q110 = copy(base); q110.id, q110.name, q110.level = 110, "Strange Note", 2
  q110.starters = { npcs = {}, objects = {}, items = { 3199 } }
  q110.objectives = { creatures = {}, killCredit = {}, objects = {}, items = {}, list = {} }
  D.quests[109], D.quests[110], D.quests[111] = q109, q110, q111
  D.items[3199] = { id = 3199, name = "Strange Note", npcDrops = { 2101 }, objectDrops = {}, itemDrops = {},
                    questRewards = {}, vendors = {} }
  D.drops[3199] = { [2101] = 0.01 }
  D.xp[109], D.xp[110], D.xp[111] = { 3, 250 }, { 2, 170 }, { 3, 100 }
  return D
end

local function runExtended(opts)
  local D, W = extendedD(), F.W()
  local state = F.state()
  local steps, report = sim.chapter(D, W, F.plan(), state, opts)
  return steps, report, state
end

return {
  -- Quête de classe dans la région : étapes `classes`, après le rendu de son pré-requis commun, sans changer
  -- la route commune ; trop loin : laissée à la fenêtre des quêtes de classe du jeu.
  class_quest_woven_without_changing_the_route = function(t)
    -- 111 : ~1 500 yd de détour (environ 9 min) ; seuil abaissé à 5 min pour ce test
    local saved = sim.CONST.CLASS_MAX_DETOUR
    sim.CONST.CLASS_MAX_DETOUR = 300
    local steps, report, state = runExtended({ _noWiden = true })
    sim.CONST.CLASS_MAX_DETOUR = saved
    local a, c, tt = indexOf(steps, "accept", 109), indexOf(steps, "complete", 109), indexOf(steps, "turnin", 109)
    t.ok(a and c and tt, "class quest woven: " .. stepsText(steps))
    t.ok(a < c and c < tt, "A < O < T")
    t.ok(indexOf(steps, "turnin", 103) < a, "after its prerequisite turn-in")
    for _, i in ipairs({ a, c, tt }) do t.eq(table.concat(steps[i].classes or {}, ","), "WARRIOR") end
    t.ok(state.classDone["WARRIOR:109"], "remembered for the next chapters")
    t.eq(indexOf(steps, "accept", 111), nil, "far class quest left to the in-game offer")
    local skipped = false
    for _, s in ipairs(report.classSkipped) do if s.id == 111 then skipped = true end end
    t.ok(skipped, "far class quest reported")
    local _, base = run({ _noWiden = true })
    t.eq(report.time, base.time, "simulated route unchanged")
  end,

  -- Quête de classe au niveau requis pas encore atteint : jamais prise avant ce niveau. « Call of Earth » 96243
  -- (niveau requis 10) était prise au niveau simulé 6 en A_DwarfGnome_02, une étape que le jeu refuse.
  class_quest_not_accepted_below_its_required_level = function(t)
    local D, W = extendedD(), F.W()
    D.quests[109].reqLevel = 4   -- 103 est rendue au niveau 2, le niveau 4 n'arrive qu'en fin de chapitre
    -- détour sans limite : la quête est posée, reste à savoir où
    local saved = sim.CONST.CLASS_MAX_DETOUR
    sim.CONST.CLASS_MAX_DETOUR = math.huge
    local steps = sim.chapter(D, W, F.plan(), F.state(), { _noWiden = true })
    sim.CONST.CLASS_MAX_DETOUR = saved
    local a = indexOf(steps, "accept", 109)
    t.ok(a, "class quest woven: " .. stepsText(steps))
    local lvl = 0
    for i = 1, a - 1 do
      local s = steps[i]
      if not s.classes and s._c and s._c.simLevel then lvl = math.max(lvl, s._c.simLevel) end
      if s[1] == "level" then lvl = math.max(lvl, s[2]) end
    end
    t.ok(lvl >= 4, ("accepted at simulated level %d: %s"):format(lvl, stepsText(steps)))
  end,

  -- Lettre vers une chaîne déjà faite : pas tissée. 112, même titre que 109, se prend chez Giver Two et se rend
  -- chez Giver One, qui donne 109 (comme « Call of Earth » 96243 -> Teo Hammerstorm -> 94373). 109 est posée
  -- dans le chapitre : la lettre ne mène plus à rien.
  class_letter_to_a_chain_already_done_is_not_woven = function(t)
    local D, W = extendedD(), F.W()
    local q112 = {}
    for k, v in pairs(D.quests[105]) do q112[k] = v end
    q112.id, q112.name, q112.level, q112.classes, q112.breadcrumbFor = 112, "Warrior Tusks", 3, 1, nil
    q112.starters = { npcs = { 2001 }, objects = {}, items = {} }
    q112.finishers = { npcs = { 1001 }, objects = {} }
    D.quests[112], D.xp[112] = q112, { 3, 40 }
    local saved = sim.CONST.CLASS_MAX_DETOUR
    sim.CONST.CLASS_MAX_DETOUR = math.huge
    local steps, report = sim.chapter(D, W, F.plan(), F.state(), { _noWiden = true })
    sim.CONST.CLASS_MAX_DETOUR = saved
    t.ok(indexOf(steps, "turnin", 109), "the chain is woven: " .. stepsText(steps))
    t.eq(indexOf(steps, "accept", 112), nil, "the letter is not: " .. stepsText(steps))
    local why
    for _, s in ipairs(report.classSkipped) do if s.id == 112 then why = s.reason end end
    t.ok(why and why:find("letter to 109", 1, true), "reported as a letter: " .. tostring(why))
  end,

  -- Objet de départ à 1 % (100 tués) : laissé ; avec un farm de niveau à faire sur ces loups, plus de raison de taux.
  starter_item_rate_and_grind_budget = function(t)
    local _, report = runExtended({ _noWiden = true })
    t.ok((dropped(report, 110) or ""):find("starter item drop rate 1.0 %", 1, true), tostring((dropped(report, 110))))
    local _, r2 = runExtended({ _noWiden = true, grindBudget = 200 })
    t.ok(not (dropped(r2, 110) or ""):find("starter item", 1, true), "budget covers the kills: " .. tostring((dropped(r2, 110))))
  end,

  respects_precedence = function(t)
    local steps = run()
    for _, q in ipairs({ 101, 102, 103, 104, 107, 108 }) do
      local a, c, tt = indexOf(steps, "accept", q), indexOf(steps, "complete", q), indexOf(steps, "turnin", q)
      t.ok(a and c and tt, "quest " .. q .. " has accept, complete and turnin: " .. stepsText(steps))
      t.ok(a < c and c < tt, "A < O < T for " .. q)
    end
    t.ok(indexOf(steps, "turnin", 103) < indexOf(steps, "accept", 104), "chain: T103 before A104")
    t.ok(indexOf(steps, "turnin", 105) < indexOf(steps, "accept", 107), "breadcrumb before its target")
  end,

  drops_far_low_xp = function(t)
    local steps, report = run()
    local r = dropped(report, 106)
    t.ok(r == "far" or r == "low ratio", "106 dropped: " .. tostring(r))
    t.eq(indexOf(steps, "accept", 106), nil)
  end,

  keeps_breadcrumb = function(t)
    local steps, report = run()
    t.eq(dropped(report, 105), nil)
    t.ok(indexOf(steps, "accept", 105) and indexOf(steps, "turnin", 105), "breadcrumb in route")
  end,

  log_cap = function(t)
    local steps = run({ logCap = 3 })
    local open, maxOpen = {}, 0
    for _, s in ipairs(steps) do
      if s[1] == "accept" then open[s[2]] = true end
      if s[1] == "turnin" then open[s[2]] = nil end
      local n = 0
      for _ in pairs(open) do n = n + 1 end
      if n > maxOpen then maxOpen = n end
    end
    t.ok(maxOpen <= 3, "max open quests " .. maxOpen)
    t.ok(indexOf(steps, "turnin", 108), "route still complete")
  end,

  hub_batching = function(t)
    local steps = run()
    local hub1 = { [101] = true, [102] = true, [103] = true, [105] = true, [106] = true }
    for i = 1, 3 do
      t.eq(steps[i][1], "accept", "step " .. i .. ": " .. stepsText(steps))
      t.ok(hub1[steps[i][2]], "hub 1 quest")
    end
  end,

  inserts_fp = function(t)
    local steps, _, state = run()
    local fp
    for _, s in ipairs(steps) do if s[1] == "fp" then fp = s end end
    t.ok(fp, "fp step: " .. stepsText(steps))
    t.eq(fp[2], F.MAP)
    t.ok(math.abs(fp[3] - 40) < 0.01 and math.abs(fp[4] - 40) < 0.01, "at the flight master")
    t.ok(state.knownTaxi[501], "node known afterwards")
  end,

  deterministic = function(t)
    local a = stepsText((run()))
    local b = stepsText((run()))
    t.eq(a, b)
  end,

  report_and_state = function(t)
    local _, report, state = run()
    t.ok(report.xpPerHour > 0, "xp/h")
    t.ok(report.endLevel >= 2, "levels up")
    t.ok(state.done[101] and state.done[108], "done quests recorded")
    t.ok(state.time > 0, "time advanced")
    t.ok(#report.quests >= 6, "kept quests listed")
  end,

  -- Élites : un camp (2 apparitions ou plus) près d'un site, ou l'élite cible de l'objectif, fixe son niveau minimal
  -- (niveau de l'élite) ; un élite seul qui n'est pas la cible ne compte pas.
  elite_camp_or_target_makes_the_objective_dangerous = function(t)
    local W = F.W()
    local function elite(D, id, x, y, level)
      D.npcs[id] = { id = id, name = "Elite " .. id, minLevel = level, maxLevel = level, rank = 1,
        spawns = { [9001] = { { x, y } } }, npcFlags = 0, questStarts = {}, questEnds = {} }
    end
    -- camp de deux élites de niveau 9 au milieu des loups de 101 (25, 28)
    local D = F.D()
    elite(D, 2901, 25, 28, 9); elite(D, 2902, 25.5, 28.5, 9)
    local _, report = sim.chapter(D, W, F.plan(), F.state())
    t.ok(dropped(report, 101) and dropped(report, 101):find("too dangerous before level 9", 1, true), tostring(dropped(report, 101)))
    -- un seul élite qui n'est pas la cible : 101 reste
    D = F.D()
    elite(D, 2901, 25, 28, 9)
    local steps = sim.chapter(D, W, F.plan(), F.state())
    t.ok(indexOf(steps, "turnin", 101), "a lone passing elite does not block")
    -- la cible elle-même élite (chef trogg de 104, niveau 9) : 104 écartée
    D = F.D()
    D.npcs[2104].rank, D.npcs[2104].minLevel, D.npcs[2104].maxLevel = 1, 9, 9
    local _, r3 = sim.chapter(D, W, F.plan(), F.state())
    t.ok(dropped(r3, 104) and dropped(r3, 104):find("too dangerous", 1, true), tostring(dropped(r3, 104)))
  end,

  -- Objectif sous son niveau minimal (loups de 101 au niveau 5 : minimum 3) : reporté après d'autres quêtes, fait au
  -- niveau 3 ou plus, jamais trop bas ni écarté quand le chapitre l'atteint.
  dangerous_objective_is_deferred_not_done_too_low = function(t)
    local D, W = F.D(), F.W()
    D.npcs[2101].minLevel, D.npcs[2101].maxLevel = 5, 5
    local steps, report = sim.chapter(D, W, F.plan(), F.state())
    t.eq(dropped(report, 101), nil, "101 kept")
    local i = indexOf(steps, "complete", 101)
    t.ok(i, "101 done: " .. stepsText(steps))
    t.ok(steps[i]._c.simLevel >= 3, "done at level " .. tostring(steps[i]._c.simLevel))
  end,

  -- Objets gardés : les monstres hostiles à CLEAR_RADIUS yards ou moins des objets pris, au plus CLEAR_PER_OBJECT
  -- par objet, les plus proches d'abord (signal de partage avec une quête de butin sur ces monstres).
  guards_of_objects_counted_per_object = function(t)
    local W = F.W()
    local function at(x, y) return sim.mkPos(W, 9001, x, y) end
    local function guard(x, y, npc) local p = at(x, y); p.npc, p.level = npc, 4; return p end
    -- 1 % = 20 yd : 0,5 % = 10 yd (dans le rayon), 2 % = 40 yd (hors rayon)
    local ctx = { guards = { guard(50.5, 50, 7), guard(50, 50.5, 7), guard(49.5, 50, 8), guard(52, 50, 9) } }
    local g = sim.guardsOf(ctx, { at(50, 50) }, at(50, 50), 1)
    t.eq(g.n, 2, "two per object at most")
    t.eq(g.clear[9], nil, "a mob 40 yd away is not a guard")
    local total = 0
    for _, c in pairs(g.clear) do total = total + c end
    t.eq(total, 2)
    t.eq(sim.guardsOf(ctx, { at(10, 10) }, at(10, 10), 1), nil, "no guard far from the object")
  end,

  widen_true_always_widens_the_band = function(t)
    local W = F.W()
    local plan = F.plan()
    local threshold = sim.CONST.WIDEN_GRIND
    sim.CONST.WIDEN_GRIND = 100000   -- le chapitre de test ne franchit plus le seuil
    local ok, err = pcall(function()
      local _, base = sim.chapter(F.D(), W, plan, F.state())
      t.eq(base.widened, nil, "below the threshold: not widened")
      plan.widen = true
      local _, report = sim.chapter(F.D(), W, plan, F.state())
      t.ok(report.widened and report.widened:find("band widened", 1, true), tostring(report.widened))
      plan.widen = false
      local _, never = sim.chapter(F.D(), W, plan, F.state())
      t.eq(never.widened, nil, "widen = false: never")
    end)
    sim.CONST.WIDEN_GRIND = threshold
    if not ok then error(err, 0) end
  end,

  accept_waits_for_required_level = function(t)
    local D, W = F.D(), F.W()
    D.quests[104].reqLevel = 5
    local steps, report = sim.chapter(D, W, F.plan(), F.state())
    local i = indexOf(steps, "accept", 104)
    if not i then
      -- quête terminale trop haute : sautée (pas de farm en cours de chapitre), raison dans le rapport
      t.ok(dropped(report, 104) and dropped(report, 104):find("required level", 1, true), "104 skipped with a reason")
      t.eq(indexOf(steps, "turnin", 104), nil, "no turnin of a skipped quest")
      return
    end
    local okLevel = steps[i]._c.simLevel >= 5
    for k = 1, i - 1 do if steps[k][1] == "level" and steps[k][2] >= 5 then okLevel = true end end
    t.ok(okLevel, "accepted at level 5 or after a level step: " .. stepsText(steps))
  end,

  order_nearest_and_constraints = function(t)
    local function P(x) return { x = x } end
    local dist = function(a, b) return math.abs(a.x - b.x) end
    local tasks = {
      { id = "A1", kind = "A", q = 1, pos = P(0), dur = 5, after = {} },
      { id = "O1", kind = "O", q = 1, pos = P(100), dur = 50, after = { "A1" } },
      { id = "T1", kind = "T", q = 1, pos = P(0), dur = 5, after = { "O1" } },
      { id = "A2", kind = "A", q = 2, pos = P(0), dur = 5, after = { "T1" } },
      { id = "O2", kind = "O", q = 2, pos = P(10), dur = 50, after = { "A2" } },
      { id = "T2", kind = "T", q = 2, pos = P(0), dur = 5, after = { "O2" } },
    }
    local seq = order.build(tasks, P(0), dist, { logCap = 20 })
    local pos = {}
    for i, task in ipairs(seq) do pos[task.id] = i end
    t.ok(pos.A1 < pos.O1 and pos.O1 < pos.T1 and pos.T1 < pos.A2, "precedence kept")
    t.eq(#seq, 6)
  end,

  -- Jamais de farm en capitale : foules de PNJ de Forever sans faction ni drapeau, prises pour des mobs.
  grind_site_never_in_a_capital = function(t)
    local D, W = F.D(), F.W()
    local ctx = { D = D, W = W, letter = "A", plan = F.plan(), opts = {} }
    local pos = sim.mkPos(W, F.MAP, 25, 28)
    local g = sim.grindSite(ctx, pos, 2)
    t.ok(g, "wolves of the fixture make a grind site")
    local saved = sim.CAPITAL_MAPS[F.MAP]
    sim.CAPITAL_MAPS[F.MAP] = true
    local inCity = sim.grindSite(ctx, pos, 2)
    sim.CAPITAL_MAPS[F.MAP] = saved
    t.eq(inCity, nil, "no grind site in a capital")
  end,

  -- Lot L : une quête de donjon prise au passage (jamais rendue) n'ouvre pas sa suite hors du donjon.
  dungeon_pickup_is_not_a_prerequisite = function(t)
    local D, W = F.D(), F.W()
    D.dungeonAreas[9100] = "Fixture Deeps"
    D.dungeonCatalog = { ["Fixture Deeps"] = { key = "FIX", area = 9100, min = 1, max = 10 } }
    local deep = D.quests[103]
    D.quests[110] = { }
    for k, v in pairs(deep) do D.quests[110][k] = v end
    D.quests[110].id, D.quests[110].name, D.quests[110].zoneOrSort = 110, "Into the Deeps", 9100
    D.quests[111] = { }
    for k, v in pairs(D.quests[101]) do D.quests[111][k] = v end
    D.quests[111].id, D.quests[111].name, D.quests[111].preSingle = 111, "Back from the Deeps", { 110 }
    D.xp[111] = { 4, 900 }
    D.unlocks[110] = { 111 }
    local steps, report = sim.chapter(D, W, F.plan(), F.state())
    local i = indexOf(steps, "accept", 110)
    t.ok(i, "dungeon quest picked up: " .. stepsText(steps))
    t.eq(steps[i].optional, true); t.eq(steps[i].dungeon, "Fixture Deeps")
    t.eq(indexOf(steps, "turnin", 110), nil, "never turned in")
    t.eq(indexOf(steps, "accept", 111), nil, "follow-up not offered")
    t.eq(dropped(report, 111), "prerequisite unavailable")
  end,

  -- Lot L : quêtes « event » (specialFlags 2) sans point d'exploration : récit chez le donneur ou objectif
  -- placé par QuestieDB gardés ; escortes écartées.
  event_quests_kept_unless_escort = function(t)
    local D, W = F.D(), F.W()
    local function copy(id, newId, fields)
      local q = {}
      for k, v in pairs(D.quests[id]) do q[k] = v end
      q.id = newId
      for k, v in pairs(fields) do q[k] = v end
      D.quests[newId] = q
      D.xp[newId] = { 3, 400 }
    end
    -- récit : objectif « tuer » le donneur lui-même (PNJ amical) -> objectif « parler »
    copy(101, 112, { name = "Listen to Giver One", specialFlags = 2, objectivesText = { "Listen as Giver One tells his story." },
      objectives = { creatures = { 1001 }, killCredit = {}, objects = {}, items = {}, list = { { kind = "kill", id = 1001, index = 1 } } } })
    -- récit sans objectif, rendu au donneur
    copy(101, 113, { name = "In a Moment", specialFlags = 2, objectivesText = { "Speak with Giver One in a moment." },
      objectives = { creatures = {}, killCredit = {}, objects = {}, items = {}, list = {} } })
    -- escorte sans point d'arrivée
    copy(101, 114, { name = "Wolf Escort", specialFlags = 2, objectivesText = { "Escort the old wolf back to Giver One." } })
    local steps, report = sim.chapter(D, W, F.plan(), F.state())
    for _, q in ipairs({ 112, 113 }) do
      t.ok(indexOf(steps, "accept", q) and indexOf(steps, "turnin", q), "event quest " .. q .. " kept: " .. stepsText(steps))
    end
    local c = steps[indexOf(steps, "complete", 113)]
    t.ok(c and c.at and math.abs(c.at[2] - 20) < 0.01 and math.abs(c.at[3] - 20) < 0.01, "113 waits at the giver")
    t.eq(dropped(report, 114), "event (escort)")
    t.eq(indexOf(steps, "accept", 114), nil)
  end,

  escort_text = function(t)
    local function q(text) return { objectivesText = { text } } end
    t.ok(sim.isEscort(q("Escort Kinelory safely to Quae.")))
    t.ok(sim.isEscort(q("Protect Kanati Greycloud from the centaur attack.")))
    t.ok(sim.isEscort(q("Defend Gor'shak.")))
    t.ok(sim.isEscort(q("Show Tooga the way back to his wife, Torta.")))
    t.ok(sim.isEscort(q("Lead Ringo to Spraggle Frock.")))
    t.ok(not sim.isEscort(q("Listen as Kalaran Windblade tells his story.")))
    t.ok(not sim.isEscort(q("Defeat Dashel Stonefist in Stormwind.")))
    t.ok(not sim.isEscort(q("Discover the location of the Northern Crystal Pylon in Un'Goro Crater.")))
  end,
  -- Lot L : quête d'un autre parcours de race ("foreign", build.mergeStates) rendue dans le chapitre, sans XP
  -- pour la race simulée ni « faite » pour elle.
  foreign_quest_turned_in_without_xp = function(t)
    local D, W = F.D(), F.W()
    local q = {}
    for k, v in pairs(D.quests[105]) do q[k] = v end
    q.id, q.name, q.breadcrumbFor = 120, "Letter from Elsewhere", nil
    q.finishers = { npcs = { 1001 }, objects = {} }
    D.quests[120] = q
    D.xp[120] = { 3, 400 }
    local state = F.state()
    state.log[120] = "foreign"
    local steps, report = sim.chapter(D, W, F.plan(), state)
    t.ok(indexOf(steps, "turnin", 120), "turned in: " .. stepsText(steps))
    for _, r in ipairs(report.quests) do t.ok(r.id ~= 120, "no XP for the simulated race") end
    t.eq(state.log[120], nil, "left the log")
    t.eq(state.done[120], nil, "not done for the simulated race")
  end,
}
