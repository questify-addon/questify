local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 50 étapes, niveau final 21.01, ~19205 xp/h, 84 min.
Q:RegisterGuide({
  id = "HD_04",
  title = "Stonetalon Mountains and The Barrens",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 19, maxLevel = 21,
  next = "HD_05",
  sim = { steps = 50, endLevel = 21.01, xpPerHour = 19205, minutes = 84 },
  steps = {
    { "accept", 905, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "complete", 905, at = { 1413, 52.6, 46.11 }, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "hearth", 1413, alt = { "RFC", "WC" }, below = 21 }, -- pierre de foyer
    { "turnin", 905, xp = 1250, alt = { "RFC", "WC" }, below = 21 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 19)
    { "accept", 3261, alt = { "RFC", "WC" }, below = 21 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 19)
    { "accept", 6541, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 19)
    { "turnin", 1060, xp = 1550, alt = { "RFC", "WC" }, below = 21 }, -- Letter to Jin'Zil (lvl 20, ~1550 xp, sim lvl 19)
    { "accept", 6542, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 19)
    { "accept", 6523, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 78149, alt = { "RFC", "WC" }, below = 21 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 19)
    { "complete", 78149, at = { 1442, 74.4, 85.7 }, alt = { "RFC", "WC" }, below = 21 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 19)
    { "complete", 6523, at = { 1442, 77.1, 90.85 }, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 6523, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 19)
    { "accept", 6401, alt = { "RFC", "WC" }, below = 21 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 20)
    { "turnin", 3261, xp = 135, alt = { "RFC", "WC" }, below = 21 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 20)
    { "accept", 882, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "goto", 1413, 44.45, 59.15, note = "Flight master", alt = { "RFC", "WC" }, below = 21 }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", alt = { "RFC", "WC" }, below = 21 }, -- vol
    { "complete", 882, at = { 1413, 59.8, 30.6 }, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "accept", 865, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 20)
    { "accept", 1221, optional = true, dungeon = "Razorfen Kraul", alt = { "RFC", "WC" }, below = 21 }, -- Blueleaf Tubers (lvl 26, ~0 xp, sim lvl 20)
    { "goto", 1413, 63.08, 37.16, note = "Flight master", alt = { "RFC", "WC" }, below = 21 }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens", alt = { "RFC", "WC" }, below = 21 }, -- vol
    { "turnin", 882, xp = 1800, alt = { "RFC", "WC" }, below = 21 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 20)
    { "accept", 6382, alt = { "RFC", "WC" }, below = 21 }, -- The Ashenvale Hunt (lvl 20, ~0 xp, sim lvl 20)
    { "accept", 907, alt = { "RFC", "WC" }, below = 21 }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 20)
    { "complete", 907, at = { 1413, 49.33, 59.83 }, alt = { "RFC", "WC" }, below = 21 }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 20)
    { "turnin", 907, xp = 1700, alt = { "RFC", "WC" }, below = 21 }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 20)
    { "accept", 913, alt = { "RFC", "WC" }, below = 21 }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 20)
    { "complete", 913, at = { 1413, 48.97, 55.85 }, alt = { "RFC", "WC" }, below = 21 }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 913, xp = 1950, alt = { "RFC", "WC" }, below = 21 }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 20)
    { "accept", 874, alt = { "RFC", "WC" }, below = 21 }, -- Mahren Skyseer (lvl 27, ~550 xp, sim lvl 20)
    { "complete", 865, at = { 1413, 57.44, 53.8 }, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 20)
    { "turnin", 874, xp = 550, alt = { "RFC", "WC" }, below = 21 }, -- Mahren Skyseer (lvl 27, ~550 xp, sim lvl 20)
    { "turnin", 865, xp = 1350, alt = { "RFC", "WC" }, below = 21 }, -- Raptor Horns (lvl 18, ~1350 xp, sim lvl 20)
    { "accept", 1491, optional = true, dungeon = "Wailing Caverns", alt = { "RFC", "WC" }, below = 21 }, -- Smart Drinks (lvl 18, ~0 xp, sim lvl 20)
    { "goto", 1413, 63.08, 37.16, note = "Flight master", alt = { "RFC", "WC" }, below = 21 }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", alt = { "RFC", "WC" }, below = 21 }, -- vol
    { "turnin", 6541, xp = 145, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 20)
    { "turnin", 6542, xp = 145, alt = { "RFC", "WC" }, below = 21 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 20)
    { "accept", 1090, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "complete", 1090, at = { 1442, 71.87, 60 }, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "turnin", 1090, xp = 2200, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "accept", 1092, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "turnin", 1092, xp = 1300, alt = { "RFC", "WC" }, below = 21 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "turnin", 1483, xp = 415, alt = { "RFC", "WC" }, below = 21 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 20)
    { "fp", 1442, 45.12, 59.84, alt = { "RFC", "WC" }, below = 21 }, -- point de vol
    { "accept", 6562, optional = true, dungeon = "Blackfathom Deeps", alt = { "RFC", "WC" }, below = 21 }, -- Trouble in the Deeps (lvl 22, ~0 xp, sim lvl 20)
    { "turnin", 6401, xp = 1000, alt = { "RFC", "WC" }, below = 21 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 20)
    { "level", 21, at = { 1442, 52.1, 43.92 }, note = "About 14 more mobs here (Pridewing Wyvern, level 21)", alt = { "RFC", "WC" }, below = 21 }, -- farm de niveau
  },
})
