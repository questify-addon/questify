local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 46 étapes, niveau final 60.00, ~55838 xp/h, 225 min.
Q:RegisterGuide({
  id = "HD_32",
  title = "Eastern Plaguelands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 59, maxLevel = 60,
  next = "HD_33",
  sim = { steps = 46, endLevel = 60.00, xpPerHour = 55838, minutes = 225 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "boat", 1434, 31.54, 29.36, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "turnin", 6029, xp = 1530 }, -- The Everlook Report (lvl 52, ~1530 xp, sim lvl 59)
    { "accept", 5098 }, -- All Along the Watchtowers (lvl 56, ~5800 xp, sim lvl 59)
    { "turnin", 84397, xp = 1650 }, -- Northern Kalimdor - A Comprehensive Guide (lvl 60, ~1650 xp, sim lvl 59)
    { "turnin", 84399, xp = 1650 }, -- Ka-Boom! (lvl 60, ~1650 xp, sim lvl 59)
    { "accept", 5233 }, -- Target: Writhing Haunt (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 4972 }, -- Counting Out Time (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 4972, at = { 1422, 39.98, 68.21 } }, -- Counting Out Time (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5098, obj = 1, at = { 1422, 40.05, 71.6 } }, -- All Along the Watchtowers (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5098, at = { 1422, 42.33, 66.24 } }, -- All Along the Watchtowers (lvl 56, ~5800 xp, sim lvl 59)
    { "turnin", 4972, xp = 5800 }, -- Counting Out Time (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5098, at = { 1422, 46.62, 71.05 } }, -- All Along the Watchtowers (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5233, at = { 1422, 52.88, 66.08 } }, -- Target: Writhing Haunt (lvl 55, ~5650 xp, sim lvl 59)
    { "turnin", 5233, xp = 5650 }, -- Target: Writhing Haunt (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 5234 }, -- Return to the Bulwark (lvl 55, ~2800 xp, sim lvl 59)
    { "turnin", 5234, xp = 2800 }, -- Return to the Bulwark (lvl 55, ~2800 xp, sim lvl 59)
    { "accept", 5235 }, -- Target: Gahrron's Withering (lvl 58, ~6200 xp, sim lvl 59)
    { "complete", 5235, at = { 1422, 62.18, 59.06 } }, -- Target: Gahrron's Withering (lvl 58, ~6200 xp, sim lvl 59)
    { "turnin", 5235, xp = 6200 }, -- Target: Gahrron's Withering (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 5236 }, -- Return to the Bulwark (lvl 58, ~3100 xp, sim lvl 59)
    { "turnin", 5236, xp = 3100 }, -- Return to the Bulwark (lvl 58, ~3100 xp, sim lvl 59)
    { "turnin", 5098, xp = 5800 }, -- All Along the Watchtowers (lvl 56, ~5800 xp, sim lvl 59)
    { "accept", 838 }, -- Scholomance (lvl 55, ~560 xp, sim lvl 59)
    { "accept", 5238 }, -- Mission Accomplished! (lvl 58, ~9300 xp, sim lvl 59)
    { "turnin", 5238, xp = 9300 }, -- Mission Accomplished! (lvl 58, ~9300 xp, sim lvl 59)
    { "turnin", 838, xp = 560 }, -- Scholomance (lvl 55, ~560 xp, sim lvl 59)
    { "accept", 5515, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Krastinov's Bag of Horrors (lvl 60, ~0 xp, sim lvl 59)
    { "turnin", 6030, xp = 1530 }, -- Duke Nicholas Zverenhoff (lvl 52, ~1530 xp, sim lvl 59)
    { "level", 60, at = { 1422, 62.18, 59.06 }, note = "About 516 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Live (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_LIVE" }, -- déplacement
    { "complete", 5214, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 60)
    { "complete", 5243, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 60)
    { "complete", 5251, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 60)
    { "complete", 5282, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 60)
    { "complete", 5848, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Of Love and Family (lvl 60, ~3300 xp, sim lvl 60)
    { "turnin", 5214, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5243, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 60)
    { "turnin", 5251, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5282, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5848, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Of Love and Family (lvl 60, ~3300 xp, sim lvl 60)
    { "accept", 5262, optional = true, dungeon = "Stratholme", note = "Starts inside the dungeon", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5262, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 60)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Undead (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_UD" }, -- déplacement
    { "complete", 5212, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 60)
    { "turnin", 5212, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 60)
  },
})
