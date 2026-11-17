local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 108 étapes, niveau final 33.00, ~30166 xp/h, 474 min.
Q:RegisterGuide({
  id = "H_06",
  title = "Alterac Mountains and Arathi Highlands",
  faction = "Horde",
  minLevel = 30, maxLevel = 33,
  next = "H_09",
  sim = { steps = 108, endLevel = 33.00, xpPerHour = 30166, minutes = 474 },
  steps = {
    { "note", "Not running Blackfathom Deeps? Abandon Trouble in the Deeps, The Essence of Aku'Mai", optional = true, dungeon = "Blackfathom Deeps" },
    { "note", "Not running Ragefire Chasm? Abandon Hidden Enemies, Slaying the Beast", optional = true, dungeon = "Ragefire Chasm" },
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul" },
    { "note", "Not running Wailing Caverns? Abandon Trouble at the Docks, Deviate Hides, Deviate Eradication, Hamuul Runetotem, Smart Drinks", optional = true, dungeon = "Wailing Caverns" },
    { "fp", 1454, 45.12, 63.89 }, -- point de vol
    { "boat", 1411, 50.8, 13.5, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "fp", 1458, 63.25, 48.56 }, -- point de vol
    { "fp", 1424, 60.14, 18.62 }, -- point de vol
    { "accept", 501 }, -- Elixir of Pain (lvl 24, ~1560 xp, sim lvl 28)
    { "accept", 509 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 567 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "sethearth", 1424, 62.78, 19.03 }, -- lier la pierre de foyer
    { "accept", 547 }, -- Humbert's Sword (lvl 30, ~3050 xp, sim lvl 28)
    { "accept", 527 }, -- Battle of Hillsbrad (lvl 24, ~1560 xp, sim lvl 28)
    { "accept", 96986, optional = true, dungeon = "City of Dalaran" }, -- The Grave Knight (lvl 33, ~0 xp, sim lvl 28)
    { "accept", 498 }, -- The Rescue (lvl 22, ~220 xp, sim lvl 28)
    { "complete", 527, at = { 1424, 33.86, 37.58 } }, -- Battle of Hillsbrad (lvl 24, ~1560 xp, sim lvl 28)
    { "level", 30, note = "About 472 mobs" }, -- farm de niveau
    { "accept", 556 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 552 }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "complete", 552, at = { 1424, 44.16, 29.07 } }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "turnin", 552, xp = 2650 }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 553 }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "complete", 553, obj = 3, at = { 1416, 37.55, 66.24 } }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "complete", 553, at = { 1424, 43.89, 28.06 } }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "turnin", 553, xp = 3300 }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "turnin", 527, xp = 1560 }, -- Battle of Hillsbrad (lvl 24, ~1560 xp, sim lvl 30)
    { "accept", 528 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 676 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 30)
    { "complete", 501, at = { 1424, 51.78, 34.17 } }, -- Elixir of Pain (lvl 24, ~1560 xp, sim lvl 30)
    { "complete", 528, at = { 1424, 35, 45.59 } }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 30)
    { "complete", 567, obj = 4, at = { 1424, 35.88, 46.57 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 30)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 528, xp = 2000 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 529 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 30)
    { "turnin", 501, xp = 1560 }, -- Elixir of Pain (lvl 24, ~1560 xp, sim lvl 30)
    { "accept", 502 }, -- Elixir of Pain (lvl 24, ~1740 xp, sim lvl 30)
    { "accept", 98094 }, -- Scout Support (lvl 25, ~800 xp, sim lvl 30)
    { "complete", 556, at = { 1416, 19.4, 84.93 } }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "complete", 567, at = { 1424, 29.51, 42.41 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 31)
    { "complete", 529, at = { 1424, 32.11, 44.42 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 31)
    { "turnin", 556, xp = 2650 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 31)
    { "accept", 557 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 529, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 31)
    { "accept", 532 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 31)
    { "accept", 95534, at = { 1416, 61.77, 43.22 }, note = "Loot Singed Note to start the quest (20.0 % drop: about 5 kills)" }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 31)
    { "complete", 557, at = { 1416, 21.03, 58.34 } }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "complete", 532, at = { 1424, 29.67, 41.64 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 31)
    { "turnin", 502, xp = 1740 }, -- Elixir of Pain (lvl 24, ~1740 xp, sim lvl 31)
    { "turnin", 557, xp = 2650 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 532, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 31)
    { "accept", 539 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 31)
    { "turnin", 95534, xp = 2800 }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 31)
    { "complete", 567, at = { 1424, 31.8, 52.7 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 31)
    { "complete", 539, at = { 1424, 31.21, 56.01 } }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 31)
    { "turnin", 539, xp = 2300 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 31)
    { "accept", 541 }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 31)
    { "turnin", 567, xp = 2300 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 31)
    { "turnin", 98094, xp = 800 }, -- Scout Support (lvl 25, ~800 xp, sim lvl 31)
    { "accept", 98095 }, -- Valuable Vantages (lvl 25, ~1600 xp, sim lvl 31)
    { "turnin", 98095, xp = 1600 }, -- Valuable Vantages (lvl 25, ~1600 xp, sim lvl 31)
    { "complete", 509, at = { 1424, 64.39, 61.33 } }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 31)
    { "complete", 676, at = { 1417, 35.32, 42.95 } }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "accept", 79949 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 31)
    { "fp", 1417, 73.02, 32.7 }, -- point de vol
    { "accept", 655 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 676, xp = 2550 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "turnin", 655, xp = 270 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 672 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 672, at = { 1417, 66.71, 38.36 } }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "turnin", 672, xp = 2700 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 79949, at = { 1417, 73.6, 65.2 } }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 32)
    { "hearth", 1424 }, -- pierre de foyer
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "turnin", 79949, xp = 2750 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 32)
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 13, note = "Tarren Mill, Hillsbrad" }, -- vol
    { "complete", 547, at = { 1424, 71.27, 79.23 } }, -- Humbert's Sword (lvl 30, ~3050 xp, sim lvl 32)
    { "turnin", 547, xp = 3050 }, -- Humbert's Sword (lvl 30, ~3050 xp, sim lvl 32)
    { "complete", 541, at = { 1424, 71.28, 79.49 } }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 541, xp = 2450 }, -- Battle of Hillsbrad (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 550 }, -- Battle of Hillsbrad (lvl 32, ~2550 xp, sim lvl 32)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "turnin", 550, xp = 2550 }, -- Battle of Hillsbrad (lvl 32, ~2550 xp, sim lvl 32)
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 17, note = "Hammerfall, Arathi" }, -- vol
    { "accept", 674 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "turnin", 674, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "accept", 675 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "turnin", 675, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "goto", 1417, 73.02, 32.7, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 13, note = "Tarren Mill, Hillsbrad" }, -- vol
    { "complete", 498, at = { 1424, 75.33, 41.5 } }, -- The Rescue (lvl 22, ~220 xp, sim lvl 32)
    { "turnin", 498, xp = 220 }, -- The Rescue (lvl 22, ~220 xp, sim lvl 32)
    { "turnin", 509, xp = 2300 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 32)
    { "accept", 513 }, -- Elixir of Agony (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 79948 }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 79948, at = { 1416, 48.45, 57.65 } }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 513, xp = 1150 }, -- Elixir of Agony (lvl 28, ~1150 xp, sim lvl 32)
    { "turnin", 78149, xp = 155 }, -- Fury of the Land (lvl 20, ~155 xp, sim lvl 32)
    { "turnin", 79097, xp = 155 }, -- Baxtan: On Destructive Magics (lvl 20, ~155 xp, sim lvl 32)
    { "turnin", 78143, xp = 155 }, -- Secrets of the Dreamers (lvl 20, ~155 xp, sim lvl 32)
    { "turnin", 79948, xp = 2750 }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 78145, xp = 155 }, -- Arcanic Systems Manual (lvl 20, ~155 xp, sim lvl 32)
    { "hearth", 1424 }, -- pierre de foyer
    { "level", 33, at = { 1424, 57.67, 68.05 }, note = "About 116 more mobs here (Daggerspine Siren, level 31)" }, -- farm de niveau
  },
})
