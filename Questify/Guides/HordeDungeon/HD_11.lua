local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 60 étapes, niveau final 35.00, ~34980 xp/h, 208 min.
Q:RegisterGuide({
  id = "HD_11",
  title = "Desolace",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 33, maxLevel = 35,
  next = "HD_12",
  sim = { steps = 60, endLevel = 35.00, xpPerHour = 34980, minutes = 208 },
  steps = {
    { "accept", 92755, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Mysterious Mysticism (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 92755, xp = 2050, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Mysterious Mysticism (lvl 35, ~2050 xp, sim lvl 33)
    { "accept", 92818, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Big, No, MASSIVE Iron Axes (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 92818, xp = 2050, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Big, No, MASSIVE Iron Axes (lvl 35, ~2050 xp, sim lvl 33)
    { "accept", 5561, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 33)
    { "accept", 1365, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 33)
    { "turnin", 1432, xp = 1200, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Alliance Relations (lvl 30, ~1200 xp, sim lvl 33)
    { "accept", 1434, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 1433, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Alliance Relations (lvl 33, ~265 xp, sim lvl 33)
    { "turnin", 1433, xp = 265, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Alliance Relations (lvl 33, ~265 xp, sim lvl 33)
    { "accept", 1435, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "complete", 5561, at = { 1443, 52.17, 58.23 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 33)
    { "accept", 92814, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- I Need a Tailor (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 92814, xp = 2050, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- I Need a Tailor (lvl 35, ~2050 xp, sim lvl 33)
    { "accept", 92817, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Leather Technique (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 92817, xp = 2050, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Leather Technique (lvl 35, ~2050 xp, sim lvl 33)
    { "fp", 1443, 21.6, 74.13, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- point de vol
    { "accept", 6142, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 33)
    { "accept", 6143, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 97265, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Hate the Hatefury (lvl 33, ~2650 xp, sim lvl 33)
    { "sethearth", 1443, 24.09, 68.21, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- lier la pierre de foyer
    { "accept", 6161, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6161, obj = 1, at = { 1443, 33.01, 32.36 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6142, at = { 1443, 33.28, 28.35 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 33)
    { "complete", 6161, at = { 1443, 35.44, 25.28 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6143, obj = 2, at = { 1443, 36.22, 22.48 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6143, at = { 1443, 32.21, 22.1 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 33)
    { "turnin", 6161, xp = 2800, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 5741, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 33)
    { "complete", 1435, at = { 1443, 54.81, 28.21 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 1480, at = { 1443, 54.86, 28.36 }, note = "Loot Flayed Demon Skin to start the quest (3.5 % drop: about 29 kills)", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Corrupter (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 5741, at = { 1443, 55.17, 30.15 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 33)
    { "turnin", 1435, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "turnin", 1480, xp = 1300, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Corrupter (lvl 33, ~1300 xp, sim lvl 33)
    { "accept", 1481, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 5821, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 33)
    { "complete", 1434, at = { 1443, 74.85, 23.46 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 33)
    { "complete", 1481, at = { 1443, 76.49, 25.56 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 34)
    { "complete", 97265, at = { 1443, 78, 20.15 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Hate the Hatefury (lvl 33, ~2650 xp, sim lvl 34)
    { "complete", 1365, at = { 1443, 73.92, 46.32 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 34)
    { "complete", 5821, at = { 1443, 67.17, 56.62 }, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 5561, xp = 2000, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 34)
    { "turnin", 5821, xp = 2750, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 1365, xp = 3450, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 34)
    { "turnin", 5361, xp = 2050, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Family Tree (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 1434, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 1436, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Alliance Relations (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 1481, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 34)
    { "hearth", 1443, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- pierre de foyer
    { "accept", 5763, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Hunting in Stranglethorn (lvl 31, ~0 xp, sim lvl 34)
    { "turnin", 6143, xp = 2800, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 34)
    { "turnin", 6142, xp = 2750, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 97265, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Hate the Hatefury (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 5741, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 34)
    { "goto", 1442, 45.12, 59.84, note = "Flight master", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- vol
    { "turnin", 1436, xp = 2650, alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- Alliance Relations (lvl 33, ~2650 xp, sim lvl 34)
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- déplacement
    { "fly", 1442, node = 29, note = "Sun Rock Retreat, Stonetalon Mountains", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- vol
    { "level", 35, at = { 1443, 69.99, 58.55 }, note = "About 66 more mobs here (Raging Thunder Lizard, level 33)", alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" }, below = 35 }, -- farm de niveau
  },
})
