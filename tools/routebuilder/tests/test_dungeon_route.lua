-- Échelle du mode « Donjons » (build_dungeon_route.lua) : niveau d'entrée, quêtes des ailes, XP, étoiles,
-- ordre joué, refus d'une échelle incohérente, et accord entre l'échelle écrite à la main
-- (dungeon_ladder.lua), les faits de Questify/Guides/DungeonData.lua et le fichier livré.
local H = require("helpers")

local function br() return assert(loadfile(H.ROOT .. "/build_dungeon_route.lua"))("--as-module") end

local PROJECT = H.ROOT:match("^(.*)[/\\]tools[/\\]routebuilder$") or "."

local function ladder(rungs)
  return { ENTRY_OFFSET = 2, ENTRY_CAP = 58, starts = {}, omitted = {}, rungs = rungs,
           STARS = { { min = 0.30, stars = 3 }, { min = 0.12, stars = 2 }, { min = 0, stars = 1 } } }
end

local function data()
  return {
    dungeons = {
      { key = "DM", name = "The Deadmines", areaId = 1581, minLevel = 17, maxLevel = 26,
        quests = { Alliance = { { id = 166 }, { id = 167 } } } },
      { key = "SM", name = "Scarlet Monastery", areaId = 796, minLevel = 28, maxLevel = 45,
        quests = { Alliance = { { id = 1050 }, { id = 1053 } } } },
      { key = "SFK", name = "Shadowfang Keep", areaId = 209, minLevel = 22, maxLevel = 30, quests = { Horde = { { id = 9 } } } },
      { key = "STRAT", name = "Stratholme", areaId = 2017, minLevel = 58, maxLevel = 60,
        quests = { Alliance = { { id = 5212 } } } },
    },
    -- niveau 19 : 21 300 XP ; niveau 30 : 47 400 XP
    rewards = { [166] = { xp = 6390 }, [167] = { xp = 0 }, [1050] = { xp = 474, est = true }, [1053] = { xp = 14220 } },
    names = {}, source = "test",
  }
end

local function fails(t, rungs, what)
  local B = br()
  local ok, err = pcall(B.build, ladder(rungs), data())
  t.ok(not ok, "expected a refusal: " .. what)
  t.ok(tostring(err):find(what, 1, true), tostring(err))
end

return {
  entry_level_xp_and_stars = function(t)
    local B = br()
    local out = B.build(ladder({
      { key = "SM_LIB", dungeon = "SM", wing = "Library", min = 29, max = 39, quests = { 1050 } },
      { key = "DM", dungeon = "DM" },
      { key = "SM_CATH", dungeon = "SM", wing = "Cathedral", min = 35, max = 45, quests = { 1053 }, entry = 36 },
      { key = "SFK", dungeon = "SFK" },
      { key = "STRAT", dungeon = "STRAT" },
    }), data())
    local keys = {}
    for i, r in ipairs(out) do keys[i] = r.key end
    t.eq(table.concat(keys, ","), "DM,SFK,SM_LIB,SM_CATH,STRAT", "sorted by entry level")
    local dm, sfk, lib, cath, strat = out[1], out[2], out[3], out[4], out[5]
    t.eq(dm.entry, 19, "range floor + 2")
    t.eq(dm.xp, 6390); t.eq(#dm.quests, 2)
    t.ok(math.abs(dm.pct - 0.30) < 1e-9, "6390 / 21300")
    t.eq(dm.stars, 3)
    t.eq(sfk.entry, 24); t.eq(#sfk.quests, 0); t.eq(sfk.stars, 0, "no quest: no star")
    t.eq(lib.entry, 31, "wing range"); t.eq(lib.est, true); t.eq(lib.stars, 1)
    t.eq(lib.minLevel, 29); t.eq(lib.maxLevel, 39)
    t.eq(cath.entry, 36, "imposed entry level"); t.eq(cath.stars, 2)
    t.eq(strat.entry, 58, "capped"); t.eq(strat.minLevel, 58)
  end,

  skipped_quests_are_left_out = function(t)
    local B = br()
    local out = B.build(ladder({ { key = "DM", dungeon = "DM", skip = { [166] = "too high" } } }), data())
    t.eq(#out[1].quests, 1)
    t.eq(out[1].quests[1], 167)
    t.eq(out[1].xp, 0)
    t.eq(out[1].stars, 1, "a quest without XP still counts as a quest")
  end,

  inconsistent_ladders_are_refused = function(t)
    fails(t, { { key = "X", dungeon = "NOPE" } }, "unknown dungeon")
    fails(t, { { key = "DM", dungeon = "DM" }, { key = "DM", dungeon = "DM" } }, "duplicate")
    fails(t, { { key = "DM", dungeon = "DM", quests = { 166 } } }, "a wing lists its quests")
    fails(t, { { key = "W", dungeon = "SM", wing = "Library" } }, "a wing lists its quests")
    fails(t, { { key = "W", dungeon = "SM", wing = "Library", quests = { 166 } } }, "is not an Alliance quest")
    fails(t, { { key = "W", dungeon = "SM", wing = "Library", quests = { 1050 } } }, "is in no wing")
    fails(t, { { key = "A", dungeon = "SM", wing = "Library", quests = { 1050, 1053 } },
               { key = "B", dungeon = "SM", wing = "Armory", quests = { 1053 } } }, "is in two rungs")
    fails(t, { { key = "DM", dungeon = "DM", entry = 40 } }, "outside")
    fails(t, { { key = "DM", dungeon = "DM", skip = { [1050] = "x" } } }, "skipped quest")
  end,

  emitted_file_loads_in_the_addon = function(t)
    local B = br()
    local L = ladder({ { key = "DM", dungeon = "DM" },
                       { key = "SM_LIB", dungeon = "SM", wing = "Library", min = 29, max = 39, quests = { 1050, 1053 } } })
    local text = B.emitLua(B.build(L, data()), L, data(), "2026-01-01")
    local Q = {}
    assert(loadstring(text))("Questify", Q)
    local d = Q.DungeonRouteData
    t.eq(d.faction, "Alliance"); t.eq(d.entryOffset, 2)
    t.eq(#d.rungs, 2)
    t.eq(d.rungs[1].key, "DM"); t.eq(d.rungs[1].areaId, 1581); t.eq(d.rungs[1].stars, 3)
    t.eq(d.rungs[2].wing, "Library"); t.eq(d.rungs[2].est, true); t.eq(#d.rungs[2].quests, 2)
    t.ok(text:find("2026-01-01", 1, true))
  end,

  -- l'échelle livrée : cohérente avec DungeonData.lua, et le fichier livré est à jour
  shipped_ladder_matches_shipped_files = function(t)
    local B = br()
    local L = dofile(H.ROOT .. "/dungeon_ladder.lua")
    local D = B.loadData(PROJECT .. "/Questify/Guides/DungeonData.lua")
    local rungs = B.build(L, D)
    t.ok(#rungs >= 26, "every 5-player dungeon and wing")
    local f = assert(io.open(PROJECT .. "/Questify/Guides/DungeonRouteData.lua", "rb"))
    local shipped = f:read("*a"); f:close()
    local date = shipped:match("généré le (%d+%-%d+%-%d+)")
    t.eq(B.emitLua(rungs, L, D, date), shipped, "DungeonRouteData.lua is stale: run build_dungeon_route.lua")
    local p = assert(io.open(PROJECT .. "/docs/dungeon-mode/ECHELLE.md", "rb"))
    local plan = p:read("*a"); p:close()
    t.eq(B.emitPlan(rungs, L, D, plan:match("le (%d+%-%d+%-%d+) à partir")), plan, "ECHELLE.md is stale")
    -- chaque échelon a ses zones d'avant et son alternative en extérieur
    for _, r in ipairs(rungs) do
      t.ok(type(r.rung.before) == "table" and #r.rung.before > 0, "no zone before " .. r.key)
      t.ok(type(r.rung.alt) == "table" and r.rung.alt.zone, "no open-world alternative for " .. r.key)
      t.ok(r.rung.alt.from <= r.entry + 1, "alternative too high for " .. r.key)
    end
  end,
}
