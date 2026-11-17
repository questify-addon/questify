local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 78 étapes, niveau final 27.00, ~28691 xp/h, 147 min.
Q:RegisterGuide({
  id = "HD_07",
  title = "Southern Barrens and Thousand Needles",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 25, maxLevel = 27,
  next = "HD_08",
  sim = { steps = 78, endLevel = 27.00, xpPerHour = 28691, minutes = 147 },
  steps = {
    { "hearth", 1413, alt = { "LORDAERON", "BFD" }, below = 27 }, -- pierre de foyer
    { "accept", 899, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Consumed by Hatred (lvl 20, ~1560 xp, sim lvl 25)
    { "accept", 97003, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 25)
    { "complete", 97003, at = { 1413, 57.53, 27.06 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 25)
    { "accept", 92706, alt = { "LORDAERON", "BFD" }, below = 27 }, -- WANTED: Bruuz (lvl 20, ~1560 xp, sim lvl 25)
    { "turnin", 1094, xp = 830, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 25)
    { "accept", 891, alt = { "LORDAERON", "BFD" }, below = 27 }, -- The Guns of Northwatch (lvl 20, ~1240 xp, sim lvl 25)
    { "complete", 92706, at = { 1413, 65.32, 39.24 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- WANTED: Bruuz (lvl 20, ~1560 xp, sim lvl 25)
    { "accept", 873, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 25)
    { "accept", 1530, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 25)
    { "complete", 873, at = { 1413, 65.49, 47.18 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 25)
    { "turnin", 873, xp = 2750, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 25)
    { "complete", 891, obj = 3, at = { 1413, 63.18, 56.64 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- The Guns of Northwatch (lvl 20, ~1240 xp, sim lvl 25)
    { "complete", 891, at = { 1413, 61.85, 54.65 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- The Guns of Northwatch (lvl 20, ~1240 xp, sim lvl 25)
    { "complete", 899, at = { 1413, 52.96, 53.61 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Consumed by Hatred (lvl 20, ~1560 xp, sim lvl 25)
    { "accept", 893, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "accept", 97250, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "accept", 5052, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 843, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 5052, at = { 1413, 47.24, 84.86 }, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "complete", 843, at = { 1413, 47.47, 85 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 98093, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 97250, at = { 1413, 49.11, 76.97 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "turnin", 97250, xp = 2300, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "turnin", 5052, xp = 1250, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 879, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 98093, at = { 1413, 44.98, 75.5 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "turnin", 1530, xp = 435, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~435 xp, sim lvl 25)
    { "accept", 1535, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 25)
    { "complete", 1535, at = { 1413, 44.28, 76.75 }, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 25)
    { "turnin", 1535, xp = 870, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 25)
    { "turnin", 843, xp = 1850, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 846, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 98093, xp = 1850, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 846, at = { 1413, 49.19, 84.17 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 846, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "accept", 849, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 879, obj = 3, at = { 1413, 40.15, 80.54 }, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 893, obj = 3, at = { 1413, 41.93, 81.47 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 893, at = { 1413, 43.52, 82.91 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 879, obj = 2, at = { 1413, 43.75, 83.26 }, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 4542, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 26)
    { "accept", 4904, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4904, at = { 1441, 30.93, 37.12 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "fp", 1441, 45.14, 49.11, alt = { "LORDAERON", "BFD" }, below = 27 }, -- point de vol
    { "accept", 4767, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 4542, xp = 510, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 26)
    { "turnin", 4904, xp = 2350, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "accept", 4821, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 4821, at = { 1441, 37.63, 56.13 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "turnin", 4821, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "accept", 4865, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "accept", 1149, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "accept", 4881, at = { 1441, 39.43, 33.1 }, note = "Loot Assassination Note to start the quest (85.5 % drop: about 2 kills)", alt = { "LORDAERON", "BFD" }, below = 27 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 4770, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4767, at = { 1441, 11.77, 35.26 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "complete", 4770, at = { 1441, 15.15, 32.65 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4881, xp = 2300, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 4865, xp = 1050, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4770, xp = 2350, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 1149, at = { 1441, 26.43, 32.93 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4767, xp = 1750, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 1149, xp = 1050, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 849, at = { 1413, 46.97, 85.63 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 879, at = { 1413, 45.12, 80.07 }, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "turnin", 849, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "turnin", 879, xp = 1500, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 906, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 893, xp = 1950, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 26)
    { "hearth", 1413, alt = { "LORDAERON", "BFD" }, below = 27 }, -- pierre de foyer
    { "turnin", 899, xp = 1560, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Consumed by Hatred (lvl 20, ~1560 xp, sim lvl 26)
    { "turnin", 906, xp = 3050, race = { "Orc", "Troll", "Skyborne" }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 97003, xp = 1650, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "goto", 1413, 51.5, 30.34, note = "Flight master", alt = { "LORDAERON", "BFD" }, below = 27 }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens", alt = { "LORDAERON", "BFD" }, below = 27 }, -- vol
    { "turnin", 92706, xp = 1560, alt = { "LORDAERON", "BFD" }, below = 27 }, -- WANTED: Bruuz (lvl 20, ~1560 xp, sim lvl 26)
    { "turnin", 891, xp = 1240, alt = { "LORDAERON", "BFD" }, below = 27 }, -- The Guns of Northwatch (lvl 20, ~1240 xp, sim lvl 26)
    { "level", 27, at = { 1413, 45.12, 80.07 }, note = "About 21 more mobs near the last objective", alt = { "LORDAERON", "BFD" }, below = 27 }, -- farm de niveau
  },
})
