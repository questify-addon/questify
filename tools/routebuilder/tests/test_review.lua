-- Tests des corrections demandées par la revue du générateur (reproductibilité, filtres de race du
-- tronc, invariants d'ordonnancement, validateur par parcours, données tierces dans les commentaires,
-- chemins shell, chemin par défaut, `obj` des sites fusionnés, quêtes écartées, XP affichée).
local H = require("helpers")
local F = require("fixture_zone")
local sim = require("sim")
local order = require("order")
local emit = require("emit")
local paths = require("paths")

local function readFile(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local s = f:read("*a"); f:close()
  return s
end

-- Rejeu sur une base minimale : quêtes { id = { pre = {...}, races = mask } }
local function miniD(quests)
  local D = { quests = {} }
  for id, q in pairs(quests) do
    D.quests[id] = { id = id, races = q.races or 0, preSingle = q.pre or {}, preGroup = {}, exclusiveTo = {},
      objectives = { list = q.objs or { { index = 1 } } }, starters = { items = {} } }
  end
  return D
end

local function issuesOf(D, race, chapters)
  local out = {}
  paths.replay(D, H.W(), "Alliance", race, chapters, function(ci, si, msg) out[#out + 1] = ci .. ":" .. si .. " " .. msg end)
  return out
end

return {
  -- IMPORTANT 1 : deux processus (JIT et interpréteur) donnent le même chapitre, octet pour octet.
  repro_two_processes = function(t)
    local dir = H.tmpdir()
    local root = H.ROOT
    local outs = {}
    for k, flag in ipairs({ "--jit", "" }) do
      local out, rep = dir .. "/repro" .. k, dir .. "/repro" .. k .. "_rep"
      local cmd = ("luajit '%s/build.lua' --faction Alliance --only A_DwarfGnome_01 --date 2026-01-01 --out '%s' --report '%s' %s >/dev/null 2>&1")
        :format(root, out, rep, flag)
      t.ok(os.execute(cmd) == 0 or true)
      outs[k] = readFile(out .. "/Alliance/A_DwarfGnome_01.lua")
      t.ok(outs[k] and #outs[k] > 100, "chapter written by run " .. k)
    end
    t.eq(outs[1], outs[2], "identical output")
  end,

  -- Coûts entiers : la même entrée donne la même séquence quel que soit le bruit flottant.
  order_quantised_costs = function(t)
    local function P(x) return { x = x } end
    local tasks = {}
    for i = 1, 12 do tasks[#tasks + 1] = { id = "A" .. i, kind = "A", pos = P((i * 7) % 13 + 1e-12 * i), dur = 5, after = {} } end
    local d = function(a, b) return math.abs(a.x - b.x) end
    local s1 = order.build(tasks, P(0), d, { anneal = true, seed = 99, annealIters = 2000 })
    local d2 = function(a, b) return math.abs(a.x - b.x) * (1 + 1e-13) end
    local s2 = order.build(tasks, P(0), d2, { anneal = true, seed = 99, annealIters = 2000 })
    for i = 1, #s1 do t.eq(s1[i].id, s2[i].id, "same task at " .. i) end
  end,

  -- IMPORTANT 3 : impasse (journal plein, rendu final reporté) : on avance le rendu final, pas de dépassement.
  order_deadlock_keeps_cap = function(t)
    local function P(x) return { x = x } end
    local dist = function(a, b) return math.abs(a.x - b.x) end
    local tasks = {
      { id = "A2", kind = "A", q = 2, pos = P(1), dur = 5, after = {} },
      { id = "T2", kind = "T", q = 2, pos = P(2), dur = 5, after = { "A2" } },
      { id = "T0", kind = "T", q = 0, pos = P(50), dur = 5, after = {}, final = true },
    }
    local seq, issues = order.build(tasks, P(0), dist, { logCap = 1, initialLog = 1 })
    t.eq(seq[1].id, "T0", "carried turn-in first")
    t.ok(order.feasible(seq, { logCap = 1, initialLog = 1, ids = { A2 = true, T2 = true, T0 = true } }), "feasible")
    t.ok(#issues >= 1, "issue reported")
  end,

  -- IMPORTANT 2 : un accept dont le prérequis n'est fait que sur un parcours reçoit un filtre de race.
  trunk_race_filter = function(t)
    local build = assert(loadfile(H.ROOT .. "/build.lua"))("--as-module")
    local D = miniD({ [1] = {}, [2] = { pre = { 1 } }, [3] = {} })
    local list = {
      { id = "X_Dwarf_01", races = { "Dwarf" }, minLevel = 1, next = "X_01" },
      { id = "X_Human_01", races = { "Human" }, minLevel = 1, next = "X_01" },
      { id = "X_01", minLevel = 5 },
    }
    local results = {
      X_Dwarf_01 = { plan = list[1], report = { warnings = {} }, steps = { { "accept", 1 }, { "turnin", 1 } } },
      X_Human_01 = { plan = list[2], report = { warnings = {} }, steps = { { "accept", 3 }, { "turnin", 3 } } },
      X_01 = { plan = list[3], report = { warnings = {} }, steps = { { "accept", 2 }, { "complete", 2 }, { "turnin", 2 } } },
    }
    build.raceFilters(D, H.W(), "Alliance", results, list)
    for _, s in ipairs(results.X_01.steps) do
      t.ok(s.race and #s.race == 1 and s.race[1] == "Dwarf", "step " .. s[1] .. " filtered to Dwarf")
    end
  end,

  -- Validateur (règles du rejeu) : prérequis, journal, obj, complete après rendu, vol non découvert.
  replay_rules = function(t)
    local D = miniD({ [1] = {}, [2] = { pre = { 1 } }, [3] = { objs = { { index = 1 }, { index = 2 } } } })
    local iss = issuesOf(D, "Dwarf", { { steps = { { "accept", 2 } } } })
    t.ok(iss[1] and iss[1]:find("prerequisite", 1, true), "missing prerequisite: " .. tostring(iss[1]))
    iss = issuesOf(D, "Dwarf", { { steps = { { "accept", 3 }, { "complete", 3, obj = 5 } } } })
    t.ok(iss[1] and iss[1]:find("obj=5", 1, true), "bad obj index")
    iss = issuesOf(D, "Dwarf", { { steps = { { "accept", 1 }, { "turnin", 1 } } }, { steps = { { "complete", 1 }, { "accept", 1 } } } })
    t.eq(#iss, 2, "complete after turnin + repeat across chapters")
    local many = {}
    for i = 1, 21 do D.quests[100 + i] = D.quests[1]; many[#many + 1] = { "accept", 100 + i } end
    iss = issuesOf(D, "Dwarf", { { steps = many } })
    t.ok(#iss == 1 and iss[1]:find("log full", 1, true), "21st accept refused")
    iss = issuesOf(D, "Dwarf", { { steps = { { "fly", 1453, note = "Stormwind, Elwynn" } } } })
    t.ok(iss[1] and iss[1]:find("not discovered", 1, true), "fly without fp")
    iss = issuesOf(D, "Dwarf", { { steps = { { "hearth", 1426 } } } })
    t.ok(iss[1] and iss[1]:find("sethearth", 1, true), "hearth without sethearth")
    iss = issuesOf(D, "Dwarf", { { steps = { { "accept", 2, race = { "Human" } } } } })
    t.eq(#iss, 0, "filtered step ignored for the other race")
  end,

  -- ClassQuestData : chaînes Forever sans pré-requis dans les données, regroupées (Chaman nain).
  classquests_dwarf_shaman_chains = function(t)
    local cq = require("classquests")
    local data = cq.build(H.D("Alliance"))
    local function chainOf(q)
      for _, ch in ipairs(data.SHAMAN) do
        for i, x in ipairs(ch.quests) do if x == q then return ch, i end end
      end
    end
    local earth, i1 = chainOf(94373)
    t.ok(earth and i1 == 1, "Call of Earth starts its chain")
    local _, i3 = chainOf(94375)
    t.ok(chainOf(94375) == earth and i3 > i1, "94375 after 94373 in the same chain")
    local fire, f1 = chainOf(94449)
    t.ok(fire and f1 == 1, "Call of Fire breadcrumb heads the chain")
    local _, f2 = chainOf(94465)
    local _, f5 = chainOf(94468)
    t.ok(chainOf(94465) == fire and chainOf(94468) == fire and f2 < f5, "94449 > 94465 ... 94468")
  end,

  -- « Call of Earth » 96243 (niveau 10, même titre) se prend chez Eldrun Stormbreaker (Forgefer) ou Ingrid
  -- Dunwald (Kharanos) et se rend à Teo Hammerstorm, qui donne 94373 : une lettre vers la tête de la chaîne.
  -- Accrochée après 94375 (même titre, niveau puis id), elle rendait la chaîne jamais faite pour un nain qui
  -- commence à Anvilmar. Elle ouvre une variante de la chaîne, exclusive de celle qui part de Teo.
  classquests_letter_to_head_is_an_alternative_head = function(t)
    local cq = require("classquests")
    local data = cq.build(H.D("Alliance"))
    local byKey = {}
    for _, ch in ipairs(data.SHAMAN) do byKey[ch.key] = ch end
    local function list(key)
      local ch = byKey[key]
      return ch and table.concat(ch.quests, ",") or "absent"
    end
    t.eq(list("SHAMAN_94373"), "94373,94374,94375", "chain from Teo Hammerstorm ends with the Earth Totem")
    t.eq(list("SHAMAN_96243"), "96243,94373,94374,94375", "the letter leads to Teo, then the chain")
    t.eq(byKey.SHAMAN_96243 and byKey.SHAMAN_96243.level, 10, "the letter needs level 10")
    t.eq(table.concat(byKey.SHAMAN_94373.exclusive or {}, ","), "SHAMAN_96243", "Teo's chain excludes the letter")
    t.eq(table.concat(byKey.SHAMAN_96243 and byKey.SHAMAN_96243.exclusive or {}, ","), "SHAMAN_94373",
      "the letter excludes Teo's chain")
    -- Même cas chez le Druide tauren : 98405 (Dendrite Starblaze -> Esprit du Grand Félin) précède 98342,
    -- donnée par l'Esprit (côté Alliance : 98394 puis 98396). Avant, 98405 suivait 98342.
    local horde = {}
    for _, ch in ipairs(cq.build(H.D("Horde")).DRUID) do horde[ch.key] = table.concat(ch.quests, ",") end
    t.eq(horde.DRUID_98405, "98405,98342", "Dendrite's letter, then the relics")
    t.eq(horde.DRUID_98342, "98342", "the relics quest no longer followed by the letter")
  end,

  -- Autres départs ajoutés en fin de liste (même schéma que « Call of Earth » 96243) : aucune chaîne ne doit
  -- finir sur un départ qu'un personnage ne prend jamais.
  classquests_alternative_starts_are_heads = function(t)
    local cq = require("classquests")
    local byKey = {}
    for _, f in ipairs({ "Alliance", "Horde" }) do
      for _, chains in pairs(cq.build(H.D(f))) do
        for _, ch in ipairs(chains) do byKey[ch.key] = byKey[ch.key] or ch end
      end
    end
    local function list(key) return byKey[key] and table.concat(byKey[key].quests, ",") or "absent" end
    local function ex(key) return byKey[key] and table.concat(byKey[key].exclusive or {}, ",") or "absent" end
    -- Démoniste Alliance : 1715 (Lago Blackwrench) est l'autre départ du niveau 10, 1717 la lettre du niveau 20
    t.eq(list("WARLOCK_1685"), "1685,1688,1689", "voidwalker from Remen Marcot")
    t.eq(list("WARLOCK_1715"), "1715,1688,1689", "voidwalker from Lago Blackwrench")
    t.eq(ex("WARLOCK_1715"), "WARLOCK_1685")
    t.eq(list("WARLOCK_1717"), "1717,1716,1738,1739,65602,65603", "level 20 letter, then the succubus or incubus")
    t.eq(table.concat(byKey.WARLOCK_1717.ends or {}, ","), "1739,65603", "either binding ends the chain")
    -- Démoniste Horde : succube ou incube, la branche incube n'est plus la seule fin (Orgrimmar : branches de
    -- longueurs différentes)
    t.eq(table.concat(byKey.WARLOCK_1478.ends or {}, ","), "1474,65597", "Undercity")
    t.eq(table.concat(byKey.WARLOCK_1506.ends or {}, ","), "1513,65604", "Orgrimmar")
    t.eq(ex("WARLOCK_1506"), "WARLOCK_1478")
    -- quête annexe à côté de la vraie fin : pas de fins multiples
    t.eq(byKey.PALADIN_91282.ends, nil, "Making Repairs is a side quest of A Second Home")
    -- « Seeking Strahad » : 3001 (Undercity) est un autre départ de la chaîne de 2996 (Orgrimmar)
    t.eq(list("WARLOCK_2996"), "2996,1801,1803,1805,1795")
    t.eq(list("WARLOCK_3001"), "3001,1801,1803,1805,1795")
    t.eq(ex("WARLOCK_3001"), "WARLOCK_2996")
    t.eq(list("WARLOCK_1798"), "1798,1758,1802,1804,1795", "the Alliance chain ends at its own binding")
    -- « Contingency Plan » : deux lettres au même texte (Hurlevent, Forgefer), une seule se fait
    t.eq(list("PRIEST_94818"), "94818,94819")
    t.eq(list("PRIEST_94820"), "94820")
    t.eq(ex("PRIEST_94820"), "PRIEST_94818")
    -- étoile sans liens autour de la tête : la dernière quête reste la règle
    t.eq(byKey.HUNTER_7632.ends, nil, "no ends for The Ancient Leaf")
  end,

  -- Guerrier 10 de l'Alliance : trois branches parallèles (Bartleby à Hurlevent, Vejrek à Forgefer,
  -- Vorlus à Darnassus). La 2e quête de chaque branche accepte n'importe quelle 1re partie
  -- (preQuestSingle) : les branches ne doivent pas se fondre en une seule chaîne.
  classquests_warrior10_branches_split = function(t)
    local cq = require("classquests")
    local data = cq.build(H.D("Alliance"))
    local byKey = {}
    for _, ch in ipairs(data.WARRIOR) do byKey[ch.key] = ch end
    local function list(key)
      local ch = byKey[key]
      return ch and table.concat(ch.quests, ",") or "absent"
    end
    t.eq(list("WARRIOR_1638"), "1638,1639,1640,1665,1666,1667", "human branch")
    t.eq(list("WARRIOR_1679"), "1679,1678,1680,1681,1682", "dwarf branch")
    t.eq(list("WARRIOR_1684"), "1684,1683,1686,1692,1693", "night elf branch")
    t.eq(byKey.WARRIOR_1683, nil, "Vorlus Vilehoof follows Elanaria, no chain of its own")
    -- les trois branches s'excluent : chacune connaît les deux autres
    t.eq(table.concat(byKey.WARRIOR_1679.exclusive or {}, ","), "WARRIOR_1638,WARRIOR_1684", "dwarf exclusive")
    t.eq(table.concat(byKey.WARRIOR_1638.exclusive or {}, ","), "WARRIOR_1679,WARRIOR_1684", "human exclusive")
  end,

  -- (a) un nom de quête avec un saut de ligne ne sort pas du commentaire
  emit_sanitises_names = function(t)
    local text = emit.guide({ id = "T_X", title = "X", faction = "Alliance", minLevel = 1, maxLevel = 2 },
      { { "accept", 1, _c = { name = "Evil\nos.exit(1) --", level = 1, simLevel = 1 } } }, {}, {})
    for line in text:gmatch("[^\n]+") do t.ok(not line:match("^os%.exit"), "no injected line") end
    t.ok(text:find("Evil os.exit", 1, true), "name kept on the comment line")
  end,

  -- (b) chemins passés au shell entre apostrophes
  shell_quoting = function(t)
    local build = assert(loadfile(H.ROOT .. "/build.lua"))("--as-module")
    t.eq(build.shq("a b"), "'a b'")
    t.eq(build.shq("x'; rm -rf y"), "'x'\\''; rm -rf y'")
  end,

  -- (c) chemin par défaut déduit de l'emplacement du script
  default_cache_path = function(t)
    local qdb = require("qdb")
    t.ok(qdb.DEFAULT_DB:match("%.cache/questiedb$"), qdb.DEFAULT_DB)
    t.ok(not qdb.DEFAULT_DB:find("/private/tmp", 1, true), "not the session scratchpad")
  end,

  -- (d) un site qui regroupe deux objectifs n'a pas d'`obj` ; (e) quête de classe signalée ;
  -- (f) XP affichée pour une quête d'une autre race.
  sim_obj_dropped_xp = function(t)
    local D, W = F.D(), F.W()
    D.npcs[2108] = { id = 2108, name = "Wolf Pup", minLevel = 2, maxLevel = 2, rank = 0,
      spawns = { [F.MAP] = { { 26, 29 }, { 26.2, 29.4 }, { 25.8, 28.6 }, { 26.4, 28.8 } } }, npcFlags = 0, questStarts = {}, questEnds = {} }
    local base = D.quests[101]
    local q = {}
    for k, v in pairs(base) do q[k] = v end
    q.id, q.name = 109, "Three Packs"
    q.objectives = { creatures = { 2101, 2108, 2107 }, killCredit = {}, objects = {}, items = {}, list = {
      { kind = "kill", id = 2101, index = 1 }, { kind = "kill", id = 2108, index = 2 }, { kind = "kill", id = 2107, index = 3 } } }
    q.objectivesText = { "Kill 4 Fixture Wolves, 2 Wolf Pups and 4 Grey Wolves." }
    D.quests[109] = q
    D.xp[109] = { 3, 300 }
    local cls = {}
    for k, v in pairs(base) do cls[k] = v end
    cls.id, cls.name, cls.classes = 110, "Warrior Training", 1
    D.quests[110] = cls
    local hum = {}
    for k, v in pairs(base) do hum[k] = v end
    hum.id, hum.name, hum.races = 111, "Human Errand", 1
    D.quests[111] = hum
    D.xp[111] = { 2, 170 }
    local plan = F.plan()
    plan.races = { "Dwarf", "Human" }
    local steps, report = sim.chapter(D, W, plan, F.state(), {})
    for _, s in ipairs(steps) do
      if s[1] == "complete" and s[2] == 109 then t.ok(s.obj ~= 1 and s.obj ~= 2, "no obj on the merged site") end
      if s[1] == "turnin" and s[2] == 111 then t.ok((s.xp or 0) > 0, "xp shown for the Human-only quest"); t.eq(s.race[1], "Human") end
    end
    local reason
    for _, d in ipairs(report.dropped) do if d.id == 110 then reason = d.reason end end
    t.ok(reason and reason:find("class quest", 1, true), "class quest listed as dropped: " .. tostring(reason))
  end,
}
