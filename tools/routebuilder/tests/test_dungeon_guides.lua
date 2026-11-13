-- Routes du mode « Donjons » : chaîne des chapitres (plans_dungeon.lua) et traitement des étapes
-- (build_dungeon_guides.lua : bloc « instance », étiquettes, rendus lointains, en-tête du guide).
local H = require("helpers")

local function bg() return assert(loadfile(H.ROOT .. "/build_dungeon_guides.lua"))("--as-module") end
local function br() return assert(loadfile(H.ROOT .. "/build_dungeon_route.lua"))("--as-module") end
local PROJECT = H.ROOT:match("^(.*)[/\\]tools[/\\]routebuilder$") or "."

local function shippedRungs()
  local B = br()
  return B.build(dofile(H.ROOT .. "/dungeon_ladder.lua"), B.loadData(PROJECT .. "/Questify/Guides/DungeonData.lua"))
end

local function quest(id, extra)
  local q = { id = id, name = "Q" .. id, level = 20, races = 0, preSingle = {}, preGroup = {},
              objectives = { list = { { index = 1 } } } }
  for k, v in pairs(extra or {}) do q[k] = v end
  return q
end

-- Donjon de test : 1 quête de ville rendue sur place, 1 rendue loin, 1 sans objectif, 1 prise dans
-- l'instance après la première, 1 jamais prise.
local function fixture()
  local D = { quests = {
    [1] = quest(1), [2] = quest(2), [3] = quest(3, { objectives = { list = {} } }),
    [4] = quest(4, { preSingle = { 1 } }), [5] = quest(5), [9] = quest(9, { preSingle = { 77 } }),
  } }
  local data = {
    dungeons = { { key = "DG", name = "Test Dungeon", quests = { Alliance = {
      { id = 1, at = { 100, 10, 10 }, endAt = { 100, 10, 10 } }, { id = 2, at = { 100, 12, 12 }, endAt = { 300, 50, 50 } },
      { id = 3, at = { 100, 11, 11 }, endAt = { 100, 11, 11 } }, { id = 4, inside = true, endAt = { 100, 10, 10 } },
      { id = 5, at = { 400, 1, 1 }, endAt = { 400, 1, 1 } },
    } } } },
    rewards = { [1] = { xp = 500 }, [2] = { xp = 700 }, [3] = { xp = 50 }, [4] = { xp = 900 } }, names = {},
  }
  local rungs = { { key = "DG", dungeon = "DG", name = "Test Dungeon", quests = { 1, 2, 3, 4, 5 },
                    entrance = { 100, 20, 20 } } }
  return D, data, rungs
end

return {
  shipped_chain_is_consistent = function(t)
    local PD = dofile(H.ROOT .. "/plans_dungeon.lua")
    local rungs = shippedRungs()
    local errs = PD.check(rungs)
    t.eq(#errs, 0, table.concat(errs, "; "))
    local plansm = require("plans")
    local list = PD.build(plansm.Alliance, rungs)
    local ids, emitted = {}, 0
    for _, p in ipairs(list) do
      t.ok(not ids[p.id], "duplicate chapter " .. p.id)
      ids[p.id] = p
      if not p.noEmit then
        emitted = emitted + 1
        t.eq(p.mode, "dungeon")
        t.ok(p.id:match("^AD_"), "dungeon chapters are named AD_*: " .. p.id)
        t.ok(p.entry or p.entryHub, "no entry point for " .. p.id)
        t.ok(p.choices == nil and p.nextByRace == nil, "no usual branching in " .. p.id)
      end
    end
    t.ok(emitted >= 30, "chapters: " .. emitted)
    -- chaque départ rejoint le tronc ; le tronc va au bout
    for _, race in ipairs({ "Human", "Dwarf", "Gnome", "NightElf", "Skyborne" }) do
      local path = plansm.pathIn(list, race)
      t.ok(#path > 30, race .. " path length " .. #path)
      t.eq(path[#path].maxLevel, 60, race .. " reaches level 60")
    end
    -- les plans habituels ne sont pas touchés par la copie
    for _, p in ipairs(plansm.Alliance) do
      t.ok(p.mode == nil and p.noEmit == nil, "usual plan modified: " .. p.id)
    end
    t.eq(plansm.find("A_Human_03").next, "A_01")
  end,

  chain_check_refuses_bad_orders = function(t)
    local PD = dofile(H.ROOT .. "/plans_dungeon.lua")
    local rungs = { { key = "A" }, { key = "B" } }
    local function errs(trunk)
      PD.TRUNK = trunk
      return table.concat(PD.check(rungs), "; ")
    end
    t.eq(errs({ { id = "X1", min = 1, max = 2, run = { "A", "B" } }, { id = "X2", min = 2, max = 3, alt = { "A", "B" } } }), "")
    t.ok(errs({ { id = "X1", min = 1, max = 2, alt = { "A" } }, { id = "X2", min = 2, max = 3, run = { "A", "B" } } })
      :find("alternative of A before its run", 1, true))
    t.ok(errs({ { id = "X1", min = 1, max = 2, run = { "A" } }, { id = "X2", min = 2, max = 3, alt = { "A" } } })
      :find("rung B is never run", 1, true))
    t.ok(errs({ { id = "X1", min = 1, max = 2, run = { "A", "B" } }, { id = "X2", min = 2, max = 3, alt = { "A" } } })
      :find("rung B has no open-world alternative", 1, true))
    t.ok(errs({ { id = "X1", min = 1, max = 2, run = { "A", "B", "C" } } }):find("unknown rung C", 1, true))
    t.ok(errs({ { id = "X1", min = 1, max = 2, run = { "A", "B", "A" } } }):find("run twice", 1, true))
    t.ok(errs({ { id = "X1", min = 3, max = 3, run = { "A", "B" } } }):find("empty level band", 1, true))
  end,

  run_block_finishes_the_quests_in_the_log = function(t)
    local G = bg()
    local D, data, rungs = fixture()
    local ix = G.index(D, rungs, data)
    local state = { level = 20.4, log = { [1] = "dungeon", [2] = "dungeon", [3] = "dungeon" }, done = {} }
    local steps = { { "accept", 1 } }
    local info = G.runBlock(D, ix, data, rungs[1], state, steps, { 100 })
    local out = {}
    for i = 2, #steps do
      local s = steps[i]
      t.eq(s.rung, "DG"); t.eq(s.phase, "run"); t.eq(s.optional, true); t.eq(s.dungeon, "Test Dungeon")
      out[#out + 1] = s[1] .. (s[1] == "goto" and "" or tostring(s[2]))
    end
    -- entrée ; objectifs ; rendus proches puis lointain ; quête de l'instance (préquête 1 rendue)
    t.eq(table.concat(out, " "), "goto complete1 complete2 turnin1 turnin3 turnin2 accept4 complete4 turnin4")
    t.eq(steps[2][2], 100); t.eq(steps[2][3], 20)
    t.eq(info.taken, 4); t.eq(info.total, 5)
    t.eq(#info.missing, 1); t.eq(info.missing[1], 5)
    t.ok(state.done[1] and state.done[2] and state.done[3] and state.done[4], "quests are done in the simulated state")
    t.eq(state.log[1], nil)
    t.eq(state.level, 20.4, "no XP is assumed for the instance")
    local far
    for _, s in ipairs(steps) do if s[1] == "turnin" and s[2] == 2 then far = s end end
    t.eq(far._far, true); t.eq(far._endMap, 300); t.eq(far.xp, 700)
  end,

  steps_are_tagged_by_role = function(t)
    local G = bg()
    local D, data, rungs = fixture()
    D.quests[77] = quest(77)
    D.quests[1].preSingle = { 77 }
    local ix = G.index(D, rungs, data)
    t.eq(ix.questRung[1], "DG"); t.eq(ix.prereqRung[77], "DG")
    -- chapitre de zone avec une instance : prises et suite d'accès en prep, trajet final en run
    local steps = {
      { "accept", 50 }, { "accept", 77, optional = true, dungeon = "Test Dungeon" },
      { "accept", 1, optional = true, dungeon = "Test Dungeon" }, { "turnin", 50 },
      { "fly", 100 }, { "goto", 100, 19, 19 },
      { "goto", 100, 20, 20, rung = "DG", phase = "run" }, { "complete", 1, rung = "DG", phase = "run" },
    }
    G.tagSteps(ix, { run = { "DG" }, maxLevel = 22 }, steps)
    t.eq(steps[1].rung, nil, "zone quest untouched")
    t.eq(steps[2].rung, "DG"); t.eq(steps[2].phase, "prep")
    t.eq(steps[3].phase, "prep")
    t.eq(steps[4].rung, nil)
    t.eq(steps[5].phase, "run", "final trip to the entrance"); t.eq(steps[6].phase, "run")
    -- chapitre d'alternative : tout est alt + below
    local alt = { { "accept", 60 }, { "accept", 1, optional = true, dungeon = "Test Dungeon" }, { "level", 24 } }
    G.tagSteps(ix, { alt = { "DG", "XX" }, maxLevel = 24 }, alt)
    for _, s in ipairs(alt) do
      t.eq(#s.alt, 2); t.eq(s.below, 24); t.eq(s.rung, nil)
    end
    local one = { { "accept", 60 } }
    G.tagSteps(ix, { alt = { "DG" }, maxLevel = 30 }, one)
    t.eq(one[1].alt, "DG")
    -- chapitre qui ne sert qu'à un donjon
    local only = { { "fly", 100 }, { "accept", 1, optional = true, dungeon = "Test Dungeon" } }
    G.tagSteps(ix, { prepFor = "DG", maxLevel = 30 }, only)
    t.eq(only[1].rung, "DG"); t.eq(only[1].phase, "prep"); t.eq(only[2].phase, "prep")
  end,

  far_turnins_move_to_the_next_chapter_through_the_zone = function(t)
    local G = bg()
    local far = { "turnin", 2, rung = "DG", phase = "run", _far = true, _endMap = 300 }
    local lost = { "turnin", 7, rung = "DG", phase = "run", _far = true, _endMap = 999 }
    local chapters = {
      { plan = { zones = { 100 } }, steps = { { "accept", 1 }, far, lost } },
      { plan = { zones = { 300 }, alt = { "DG" } }, steps = { { "accept", 8 } } },   -- alternative : jamais
      { plan = { zones = { 200 }, endZones = { 300 } }, steps = { { "fly", 200 }, { "goto", 200, 1, 1 }, { "accept", 9 } } },
    }
    t.eq(G.deferTurnins(chapters), 1)
    t.eq(#chapters[1].steps, 2); t.eq(chapters[1].steps[2], lost, "no chapter through that zone: stays")
    t.eq(#chapters[2].steps, 1)
    t.eq(chapters[3].steps[3], far, "after the opening trip")
    t.eq(far.rung, "DG"); t.eq(far._far, nil)
  end,

  guide_text_carries_the_mode = function(t)
    local G = bg()
    local plan = { id = "AD_99", title = "Test", faction = "Alliance", minLevel = 20, maxLevel = 22, next = "AD_100",
                   after_ = { "A_Human_03" } }
    local text = G.guideText(plan, { { "accept", 1, rung = "DG", phase = "prep" },
                                     { "accept", 2, alt = { "DG", "XX" }, below = 22 } }, {}, { commit = "abc", date = "2026-01-01" })
    t.ok(text:find('mode = "dungeon",', 1, true))
    t.ok(text:find('after = { "A_Human_03" },', 1, true))
    t.ok(text:find("plans_dungeon.lua", 1, true))
    local defs, Q = {}, {}
    function Q:RegisterGuide(def) defs[#defs + 1] = def end
    assert(loadstring(text))("Questify", Q)
    t.eq(defs[1].mode, "dungeon"); t.eq(defs[1].id, "AD_99"); t.eq(defs[1].next, "AD_100")
    t.eq(defs[1].steps[1].rung, "DG"); t.eq(defs[1].steps[2].alt[2], "XX"); t.eq(defs[1].steps[2].below, 22)
  end,

  shipped_route_files_match_the_chain = function(t)
    local PD = dofile(H.ROOT .. "/plans_dungeon.lua")
    local f = assert(io.open(PROJECT .. "/Questify/Guides/DungeonGuides.xml", "rb"))
    local xml = f:read("*a"); f:close()
    local listed = {}
    for id in xml:gmatch('AllianceDungeon\\(AD_[%w_]+)%.lua') do listed[#listed + 1] = id end
    t.eq(#listed, #PD.TRUNK, "one file per chapter of the chain")
    for i, tr in ipairs(PD.TRUNK) do
      t.eq(listed[i], tr.id)
      local g = io.open(PROJECT .. "/Questify/Guides/AllianceDungeon/" .. tr.id .. ".lua", "rb")
      t.ok(g ~= nil, "missing file " .. tr.id)
      if g then g:close() end
    end
  end,
}
