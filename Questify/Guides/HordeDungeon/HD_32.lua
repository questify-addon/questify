local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 24 étapes, niveau final 58.04, ~17189 xp/h, 26 min.
Q:RegisterGuide({
  id = "HD_32",
  title = "Eastern Plaguelands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 58, maxLevel = 59,
  next = "HD_33",
  sim = { steps = 24, endLevel = 58.04, xpPerHour = 17189, minutes = 26 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "boat", 1434, 31.54, 29.36, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "turnin", 6029, xp = 2040 }, -- The Everlook Report (lvl 52, ~2040 xp, sim lvl 58)
    { "turnin", 84397, xp = 1650 }, -- Northern Kalimdor - A Comprehensive Guide (lvl 60, ~1650 xp, sim lvl 58)
    { "turnin", 84399, xp = 1650 }, -- Ka-Boom! (lvl 60, ~1650 xp, sim lvl 58)
    { "accept", 5515, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Krastinov's Bag of Horrors (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 6030, xp = 2040 }, -- Duke Nicholas Zverenhoff (lvl 52, ~2040 xp, sim lvl 58)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Live (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_LIVE" }, -- déplacement
    { "complete", 5214, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 58)
    { "complete", 5243, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 58)
    { "complete", 5251, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 58)
    { "complete", 5282, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 58)
    { "complete", 5848, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Of Love and Family (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5214, at = { 1423, 70.88, 48.43 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5243, at = { 1423, 71.89, 48.29 }, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5251, at = { 1423, 71.63, 50.09 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5282, at = { 1423, 11.36, 26.6 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5848, at = { 1423, 5.16, 35.57 }, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Of Love and Family (lvl 60, ~3300 xp, sim lvl 58)
    { "accept", 5262, optional = true, dungeon = "Stratholme", note = "Starts inside the dungeon", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5262, at = { 1423, 71.63, 50.09 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 58)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Undead (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_UD" }, -- déplacement
    { "complete", 5212, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5212, at = { 1423, 71.66, 49.94 }, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 58)
  },
})
