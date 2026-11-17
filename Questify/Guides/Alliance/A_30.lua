local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 50 étapes, niveau final 60.00, ~65362 xp/h, 192 min.
Q:RegisterGuide({
  id = "A_30",
  title = "Silithus",
  faction = "Alliance",
  minLevel = 59, maxLevel = 60,
  sim = { steps = 50, endLevel = 60.00, xpPerHour = 65362, minutes = 192 },
  steps = {
    { "note", "Not running Blackrock Depths? Abandon The Heart of the Mountain, Ragnar Thunderbrew", optional = true, dungeon = "Blackrock Depths" },
    { "hearth", 1434 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1444, node = 31, note = "Thalanaar, Feralas" }, -- vol
    { "fp", 1451, 50.58, 34.45 }, -- point de vol
    { "accept", 9415 }, -- Report to Marshal Bluewall (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 8284 }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 8280 }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 8283 }, -- Wanted - Deathclasp, Terror of the Sands (lvl 59, ~8050 xp, sim lvl 59)
    { "accept", 8277 }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 59)
    { "complete", 8280, at = { 1451, 56.05, 29.94 } }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 59)
    { "complete", 8284, at = { 1451, 22.09, 10.4 } }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 8304 }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 8284, xp = 6200 }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 8285 }, -- The Deserter (lvl 59, ~4800 xp, sim lvl 59)
    { "turnin", 8280, xp = 5650 }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 8281 }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 59)
    { "complete", 8277, at = { 1451, 64.64, 30.1 } }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 59)
    { "turnin", 8285, xp = 4800 }, -- The Deserter (lvl 59, ~4800 xp, sim lvl 59)
    { "accept", 8279 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8279, obj = 3, at = { 1451, 40.86, 42.22 } }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8279, obj = 1, at = { 1451, 26.35, 36.62 } }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8281, at = { 1451, 30.56, 43.71 } }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 59)
    { "turnin", 9415, xp = 6600 }, -- Report to Marshal Bluewall (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 9419 }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 9419, at = { 1451, 32.95, 50.81 } }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 9419, xp = 6600 }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 8308, at = { 1451, 25.19, 61.73 }, note = "Loot Brann Bronzebeard's Lost Letter to start the quest (0.4 % drop: about 225 kills)" }, -- Brann Bronzebeard's Lost Letter (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8279, at = { 1451, 16.09, 86.37 } }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8304, at = { 1451, 40.81, 88.86 } }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 8308, xp = 8300 }, -- Brann Bronzebeard's Lost Letter (lvl 60, ~8300 xp, sim lvl 59)
    { "complete", 8283, at = { 1451, 45.07, 92.31 } }, -- Wanted - Deathclasp, Terror of the Sands (lvl 59, ~8050 xp, sim lvl 59)
    { "turnin", 8279, xp = 8300 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 59)
    { "accept", 8287 }, -- A Terrible Purpose (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 8277, xp = 5650 }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 59)
    { "turnin", 8281, xp = 6000 }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 59)
    { "turnin", 8304, xp = 6600 }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 8287, xp = 6600 }, -- A Terrible Purpose (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 8283, xp = 8050 }, -- Wanted - Deathclasp, Terror of the Sands (lvl 59, ~8050 xp, sim lvl 59)
    { "fly", 1452, node = 52, note = "Everlook, Winterspring" }, -- vol
    { "accept", 92859 }, -- Shroud of the Winter Wilds (lvl 60, ~3300 xp, sim lvl 59)
    { "complete", 92859, obj = 2, at = { 1452, 64.35, 27.89 } }, -- Shroud of the Winter Wilds (lvl 60, ~3300 xp, sim lvl 59)
    { "complete", 92859, at = { 1452, 59.59, 22.53 } }, -- Shroud of the Winter Wilds (lvl 60, ~3300 xp, sim lvl 59)
    { "turnin", 92859, xp = 3300 }, -- Shroud of the Winter Wilds (lvl 60, ~3300 xp, sim lvl 59)
    { "accept", 98462 }, -- Shroud of the Winter Wilds (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 98462, obj = 2, at = { 1452, 64.35, 27.89 } }, -- Shroud of the Winter Wilds (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 98462, at = { 1452, 59.59, 22.53 } }, -- Shroud of the Winter Wilds (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 98462, xp = 6600 }, -- Shroud of the Winter Wilds (lvl 60, ~6600 xp, sim lvl 59)
    { "level", 60, at = { 1452, 59.59, 22.53 }, note = "About 18 more mobs near the last objective" }, -- farm de niveau
  },
})
