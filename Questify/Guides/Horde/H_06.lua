local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 62 étapes, niveau final 32.23, ~36339 xp/h, 182 min.
Q:RegisterGuide({
  id = "H_06",
  title = "Alterac Mountains and Arathi Highlands",
  faction = "Horde",
  minLevel = 30, maxLevel = 32,
  next = "H_07",
  sim = { steps = 62, endLevel = 32.23, xpPerHour = 36339, minutes = 182 },
  steps = {
    { "note", "Not running Blackfathom Deeps? Abandon Trouble in the Deeps, The Essence of Aku'Mai", optional = true, dungeon = "Blackfathom Deeps" },
    { "note", "Not running Ragefire Chasm? Abandon Hidden Enemies, Slaying the Beast", optional = true, dungeon = "Ragefire Chasm" },
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul" },
    { "note", "Not running Wailing Caverns? Abandon Trouble at the Docks, Deviate Hides, Deviate Eradication, Hamuul Runetotem, Smart Drinks", optional = true, dungeon = "Wailing Caverns" },
    { "hearth", 1424 }, -- pierre de foyer
    { "accept", 556 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 95126, classes = { "PALADIN" } }, -- The Moonsilver Blade (lvl 25, ~600 xp, sim lvl 30)
    { "turnin", 95126, xp = 600, classes = { "PALADIN" } }, -- The Moonsilver Blade (lvl 25, ~600 xp, sim lvl 30)
    { "accept", 544 }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 30)
    { "accept", 541 }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 30)
    { "accept", 676 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 533 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 30)
    { "accept", 79364, classes = { "SHAMAN" } }, -- Eyes on the Sky (lvl 33, ~265 xp, sim lvl 30)
    { "turnin", 79364, xp = 265, classes = { "SHAMAN" } }, -- Eyes on the Sky (lvl 33, ~265 xp, sim lvl 30)
    { "accept", 1361 }, -- Regthar Deathgate (lvl 32, ~0 xp, sim lvl 30)
    { "accept", 535 }, -- Valik (lvl 34, ~270 xp, sim lvl 30)
    { "complete", 533, at = { 1416, 58.3, 67.96 } }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 30)
    { "level", 31, at = { 1416, 41.6, 78.56 }, note = "About 41 mobs here (High Order Mage, level 30)" }, -- farm de niveau
    { "complete", 535, at = { 1416, 58.98, 68.49 } }, -- Valik (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 535, xp = 270 }, -- Valik (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 533, xp = 2700 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 676, at = { 1417, 35.32, 42.95 } }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "fp", 1417, 73.02, 32.7 }, -- point de vol
    { "accept", 655 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 676, xp = 2550 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "turnin", 655, xp = 270 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 672 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 672, at = { 1417, 66.71, 38.36 } }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "turnin", 672, xp = 2700 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "accept", 674 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 674, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 675 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 675, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 79949 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 31)
    { "hearth", 1424 }, -- pierre de foyer
    { "complete", 544, at = { 1416, 19.91, 85.97 } }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 31)
    { "complete", 556, at = { 1416, 19.4, 84.93 } }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 556, xp = 2650 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 31)
    { "accept", 557 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 544, xp = 3300 }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 31)
    { "accept", 545 }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "complete", 557, at = { 1416, 21.03, 58.34 } }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "complete", 545, at = { 1416, 21.01, 58.98 } }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "turnin", 557, xp = 2650 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 545, xp = 2050 }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "accept", 79948 }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 31)
    { "level", 32, at = { 1416, 37.51, 70.87 }, note = "About 12 mobs here (Mountain Yeti, level 32)" }, -- farm de niveau
    { "complete", 79948, at = { 1416, 48.45, 57.65 } }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 541, at = { 1424, 71.28, 79.49 } }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 541, xp = 2450 }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 550 }, -- Battle of Hillsbrad (lvl 32, ~2550 xp, sim lvl 32)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "turnin", 550, xp = 2550 }, -- Battle of Hillsbrad (lvl 32, ~2550 xp, sim lvl 32)
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 17, note = "Hammerfall, Arathi" }, -- vol
    { "complete", 79949, at = { 1417, 73.6, 65.2 } }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 32)
    { "hearth", 1424 }, -- pierre de foyer
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "turnin", 79949, xp = 2750 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 79948, xp = 2750 }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 32)
  },
})
