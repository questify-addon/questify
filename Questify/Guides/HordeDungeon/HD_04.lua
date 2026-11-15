local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 76 étapes, niveau final 21.00, ~19419 xp/h, 131 min.
Q:RegisterGuide({
  id = "HD_04",
  title = "Stonetalon Mountains and The Barrens",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 19, maxLevel = 21,
  next = "HD_05",
  sim = { steps = 76, endLevel = 21.00, xpPerHour = 19419, minutes = 131 },
  steps = {
    { "accept", 867, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 19)
    { "accept", 6541, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 19)
    { "accept", 905, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "goto", 1413, 51.5, 30.34, note = "Flight master", alt = { "RFC", "WC" }, below = 21 }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens", alt = { "RFC", "WC" }, below = 21 }, -- vol
    { "accept", 92706, alt = { "RFC", "WC" }, below = 21 }, -- WANTED: Bruuz (lvl 20, ~1950 xp, sim lvl 19)
    { "accept", 865, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 19)
    { "complete", 905, at = { 1413, 52.6, 46.11 }, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "complete", 867, at = { 1413, 40.78, 15.56 }, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 19)
    { "accept", 3281, alt = { "RFC", "WC" }, below = 21 }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 905, xp = 1250, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "accept", 3261, alt = { "RFC", "WC" }, below = 21 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 19)
    { "turnin", 867, xp = 1050, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 19)
    { "accept", 875, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 19)
    { "accept", 899, alt = { "RFC", "WC" }, below = 21 }, -- Consumed by Hatred (lvl 20, ~1950 xp, sim lvl 19)
    { "complete", 875, at = { 1413, 38.72, 14.4 }, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 19)
    { "accept", 1090, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 19)
    { "complete", 1090, at = { 1442, 71.87, 60 }, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 19)
    { "turnin", 1090, xp = 2200, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 19)
    { "accept", 1092, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 19)
    { "turnin", 1483, xp = 415, alt = { "RFC", "WC" }, below = 21 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 19)
    { "accept", 1093, alt = { "RFC", "WC" }, below = 21 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 19)
    { "turnin", 1092, xp = 1300, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 19)
    { "complete", 1093, at = { 1442, 62.38, 53.01 }, alt = { "RFC", "WC" }, below = 21 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 19)
    { "accept", 78270, alt = { "RFC", "WC" }, below = 21, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 19)
    { "complete", 78270, at = { 1442, 65.98, 50.52 }, alt = { "RFC", "WC" }, below = 21, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 19)
    { "turnin", 78270, xp = 1850, alt = { "RFC", "WC" }, below = 21, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 19)
    { "turnin", 1093, xp = 1650, alt = { "RFC", "WC" }, below = 21 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 19)
    { "accept", 1094, alt = { "RFC", "WC" }, below = 21 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 19)
    { "fp", 1442, 45.12, 59.84, alt = { "RFC", "WC" }, below = 21 }, -- point de vol
    { "accept", 6562, optional = true, dungeon = "Blackfathom Deeps", alt = { "RFC", "WC" }, below = 21 }, -- Trouble in the Deeps (lvl 22, ~0 xp, sim lvl 19)
    { "accept", 6523, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 78149, alt = { "RFC", "WC" }, below = 21 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 19)
    { "complete", 78149, at = { 1442, 74.4, 85.7 }, alt = { "RFC", "WC" }, below = 21 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 19)
    { "complete", 6523, at = { 1442, 77.1, 90.85 }, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 6548, alt = { "RFC", "WC" }, below = 21 }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 6523, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 6401, alt = { "RFC", "WC" }, below = 21 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 19)
    { "complete", 6548, at = { 1442, 82.86, 86.34 }, alt = { "RFC", "WC" }, below = 21 }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 6548, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 6629, alt = { "RFC", "WC" }, below = 21 }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 6542, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 19)
    { "complete", 6629, at = { 1442, 73.65, 86.12 }, alt = { "RFC", "WC" }, below = 21 }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 6629, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 20)
    { "turnin", 3261, xp = 135, alt = { "RFC", "WC" }, below = 21 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 20)
    { "sethearth", 1413, 45.58, 59.04, alt = { "RFC", "WC" }, below = 21 }, -- lier la pierre de foyer
    { "accept", 882, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "complete", 899, at = { 1413, 52.91, 53.61 }, alt = { "RFC", "WC" }, below = 21 }, -- Consumed by Hatred (lvl 20, ~1950 xp, sim lvl 20)
    { "complete", 3281, at = { 1413, 58.04, 53.87 }, alt = { "RFC", "WC" }, below = 21 }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 20)
    { "complete", 865, at = { 1413, 57.44, 53.8 }, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 20)
    { "complete", 92706, at = { 1413, 64.24, 40.32 }, alt = { "RFC", "WC" }, below = 21 }, -- WANTED: Bruuz (lvl 20, ~1950 xp, sim lvl 20)
    { "accept", 1530, alt = { "RFC", "WC" }, below = 21, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 20)
    { "accept", 1221, optional = true, dungeon = "Razorfen Kraul", alt = { "RFC", "WC" }, below = 21 }, -- Blueleaf Tubers (lvl 26, ~0 xp, sim lvl 20)
    { "turnin", 865, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 20)
    { "accept", 1491, optional = true, dungeon = "Wailing Caverns", alt = { "RFC", "WC" }, below = 21 }, -- Smart Drinks (lvl 18, ~0 xp, sim lvl 20)
    { "turnin", 1094, xp = 830, alt = { "RFC", "WC" }, below = 21 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 20)
    { "turnin", 92706, xp = 1950, alt = { "RFC", "WC" }, below = 21 }, -- WANTED: Bruuz (lvl 20, ~1950 xp, sim lvl 20)
    { "complete", 882, at = { 1413, 59.8, 30.6 }, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "turnin", 875, xp = 1150, alt = { "RFC", "WC" }, below = 21 }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 20)
    { "accept", 876, alt = { "RFC", "WC" }, below = 21 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 3281, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 20)
    { "turnin", 899, xp = 1950, alt = { "RFC", "WC" }, below = 21 }, -- Consumed by Hatred (lvl 20, ~1950 xp, sim lvl 20)
    { "complete", 876, at = { 1413, 39.16, 12.17 }, alt = { "RFC", "WC" }, below = 21 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 6542, xp = 145, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 20)
    { "turnin", 6541, xp = 145, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 20)
    { "hearth", 1413, alt = { "RFC", "WC" }, below = 21 }, -- pierre de foyer
    { "turnin", 882, xp = 1800, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "turnin", 1530, xp = 435, alt = { "RFC", "WC" }, below = 21, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 20)
    { "accept", 6382, alt = { "RFC", "WC" }, below = 21 }, -- The Ashenvale Hunt (lvl 20, ~0 xp, sim lvl 20)
    { "goto", 1413, 44.45, 59.15, note = "Flight master", alt = { "RFC", "WC" }, below = 21 }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", alt = { "RFC", "WC" }, below = 21 }, -- vol
    { "turnin", 876, xp = 1950, alt = { "RFC", "WC" }, below = 21 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 20)
    { "accept", 1060, alt = { "RFC", "WC" }, below = 21 }, -- Letter to Jin'Zil (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 1060, xp = 1550, alt = { "RFC", "WC" }, below = 21 }, -- Letter to Jin'Zil (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 6401, xp = 1000, alt = { "RFC", "WC" }, below = 21 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 20)
    { "level", 21, at = { 1442, 52.1, 43.92 }, note = "About 22 more mobs here (Pridewing Wyvern, level 21)", alt = { "RFC", "WC" }, below = 21 }, -- farm de niveau
  },
})
