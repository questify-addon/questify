local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 90 étapes, niveau final 21.00, ~24090 xp/h, 150 min.
Q:RegisterGuide({
  id = "H_02",
  title = "Stonetalon Mountains and The Barrens",
  faction = "Horde",
  minLevel = 17, maxLevel = 21,
  next = "H_03",
  sim = { steps = 90, endLevel = 21.00, xpPerHour = 24090, minutes = 150 },
  steps = {
    { "accept", 3281 }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 18)
    { "accept", 876 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 18)
    { "accept", 905 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 18)
    { "accept", 4921 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 18)
    { "complete", 905, at = { 1413, 52.6, 46.11 } }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 18)
    { "turnin", 905, xp = 1250 }, -- The Angry Scytheclaws (lvl 17, ~1250 xp, sim lvl 18)
    { "accept", 3261 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 18)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "accept", 1483 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 18)
    { "complete", 3281, at = { 1413, 58.04, 53.87 } }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 18)
    { "complete", 4921, at = { 1413, 49.33, 50.32 } }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 18)
    { "turnin", 3261, xp = 135 }, -- Jorn Skyseer (lvl 18, ~135 xp, sim lvl 18)
    { "accept", 882 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 18)
    { "accept", 3513, at = { 1413, 46, 70 }, note = "Loot Runed Scroll to start the quest (95.2 % drop: about 2 kills)" }, -- The Runed Scroll (lvl 25, ~2550 xp, sim lvl 18)
    { "accept", 885, at = { 1413, 44.81, 74.93 }, note = "Loot Washte Pawne's Feather to start the quest (90.1 % drop: about 2 kills)" }, -- Washte Pawne (lvl 25, ~1500 xp, sim lvl 18)
    { "accept", 897, at = { 1413, 42, 70 }, note = "Loot Harvester's Head to start the quest (93.6 % drop: about 2 kills)" }, -- The Harvester (lvl 24, ~2400 xp, sim lvl 18)
    { "hearth", 1413 }, -- pierre de foyer
    { "accept", 1062 }, -- Goblin Invaders (lvl 19, ~1450 xp, sim lvl 18)
    { "accept", 6548 }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 18)
    { "complete", 6548, at = { 1442, 82.86, 86.34 } }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 18)
    { "turnin", 6548, xp = 1350 }, -- Avenge My Village (lvl 18, ~1350 xp, sim lvl 18)
    { "accept", 6629 }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 18)
    { "complete", 6629, at = { 1442, 73.65, 86.12 } }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 18)
    { "accept", 6523 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 18)
    { "accept", 1090 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 18)
    { "complete", 1062, at = { 1442, 66.63, 51.24 } }, -- Goblin Invaders (lvl 19, ~1450 xp, sim lvl 18)
    { "turnin", 1483, xp = 415 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 18)
    { "accept", 1093 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 18)
    { "accept", 78270 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 18)
    { "turnin", 78270, xp = 1400 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 18)
    { "complete", 1093, at = { 1442, 62.38, 53.01 } }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 18)
    { "turnin", 1093, xp = 1650 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 18)
    { "accept", 1094 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 18)
    { "fp", 1442, 45.12, 59.84 }, -- point de vol
    { "accept", 6421 }, -- Boulderslide Ravine (lvl 18, ~1350 xp, sim lvl 18)
    { "complete", 6421, at = { 1442, 59.73, 91.48 } }, -- Boulderslide Ravine (lvl 18, ~1350 xp, sim lvl 18)
    { "accept", 6542 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 18)
    { "complete", 6523, at = { 1442, 77.1, 90.85 } }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 18)
    { "complete", 876, at = { 1413, 39.16, 12.17 } }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 18)
    { "turnin", 3513, xp = 2550 }, -- The Runed Scroll (lvl 25, ~2550 xp, sim lvl 18)
    { "complete", 1090, at = { 1442, 71.87, 60 } }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 19)
    { "turnin", 1090, xp = 2200 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 19)
    { "accept", 1092 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 19)
    { "turnin", 1092, xp = 1300 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 19)
    { "turnin", 6542, xp = 145 }, -- Report to Kadrak (lvl 19, ~145 xp, sim lvl 19)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 3281, xp = 1350 }, -- Stolen Silver (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 876, xp = 1950 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 19)
    { "accept", 1060 }, -- Letter to Jin'Zil (lvl 20, ~1550 xp, sim lvl 19)
    { "turnin", 4921, xp = 1150 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 19)
    { "complete", 882, at = { 1413, 59.8, 30.6 } }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 19)
    { "accept", 92706 }, -- WANTED: Bruuz (lvl 20, ~1550 xp, sim lvl 19)
    { "turnin", 1094, xp = 830 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 19)
    { "accept", 1095 }, -- Further Instructions (lvl 27, ~1100 xp, sim lvl 19)
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "turnin", 882, xp = 1800 }, -- Ishamuhale (lvl 19, ~1800 xp, sim lvl 19)
    { "accept", 907 }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 19)
    { "turnin", 885, xp = 1500 }, -- Washte Pawne (lvl 25, ~1500 xp, sim lvl 19)
    { "turnin", 897, xp = 2400 }, -- The Harvester (lvl 24, ~2400 xp, sim lvl 19)
    { "complete", 907, at = { 1413, 49.33, 59.83 } }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 19)
    { "accept", 884, at = { 1413, 49.4, 59.2 }, note = "Loot Owatanka's Tailspike to start the quest (86.9 % drop: about 2 kills)" }, -- Owatanka (lvl 24, ~1450 xp, sim lvl 19)
    { "turnin", 907, xp = 1700 }, -- Enraged Thunder Lizards (lvl 18, ~1700 xp, sim lvl 19)
    { "accept", 913 }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 19)
    { "turnin", 884, xp = 1450 }, -- Owatanka (lvl 24, ~1450 xp, sim lvl 19)
    { "goto", 1413, 44.45, 59.15, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "complete", 92706, at = { 1413, 65.29, 39.59 } }, -- WANTED: Bruuz (lvl 20, ~1550 xp, sim lvl 20)
    { "accept", 1530, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 20)
    { "turnin", 92706, xp = 1550 }, -- WANTED: Bruuz (lvl 20, ~1550 xp, sim lvl 20)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "complete", 913, at = { 1413, 48.97, 55.85 } }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 913, xp = 1950 }, -- Cry of the Thunderhawk (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 1530, xp = 435, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 20)
    { "turnin", 1062, xp = 1450 }, -- Goblin Invaders (lvl 19, ~1450 xp, sim lvl 20)
    { "turnin", 6629, xp = 1350 }, -- Kill Grundig Darkcloud (lvl 18, ~1350 xp, sim lvl 20)
    { "turnin", 6523, xp = 1350 }, -- Protect Kaya (lvl 18, ~1350 xp, sim lvl 20)
    { "accept", 6401 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 20)
    { "turnin", 1060, xp = 1550 }, -- Letter to Jin'Zil (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 1095, xp = 1100 }, -- Further Instructions (lvl 27, ~1100 xp, sim lvl 20)
    { "turnin", 6421, xp = 1350 }, -- Boulderslide Ravine (lvl 18, ~1350 xp, sim lvl 20)
    { "accept", 6481 }, -- Earthen Arise (lvl 20, ~1550 xp, sim lvl 20)
    { "complete", 6481, at = { 1442, 57.4, 89.4 } }, -- Earthen Arise (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 6481, xp = 1550 }, -- Earthen Arise (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 6401, xp = 1000 }, -- Kaya's Alive (lvl 18, ~1000 xp, sim lvl 20)
    { "turnin", 79192, xp = 970 }, -- Stepping Stones (lvl 24, ~970 xp, sim lvl 20)
    { "accept", 79980 }, -- Scramble (lvl 24, ~970 xp, sim lvl 20)
    { "turnin", 79980, xp = 970 }, -- Scramble (lvl 24, ~970 xp, sim lvl 20)
    { "level", 21, at = { 1442, 45.81, 46.1 }, note = "About 20 more mobs here (Pridewing Wyvern, level 21)" }, -- farm de niveau
  },
})
