local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 65 étapes, niveau final 27.00, ~28675 xp/h, 148 min.
Q:RegisterGuide({
  id = "HD_07",
  title = "Southern Barrens and Thousand Needles",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 25, maxLevel = 27,
  next = "HD_08",
  sim = { steps = 65, endLevel = 27.00, xpPerHour = 28675, minutes = 148 },
  steps = {
    { "hearth", 1413, alt = { "LORDAERON", "BFD" }, below = 27 }, -- pierre de foyer
    { "goto", 1413, 44.45, 59.15, note = "Flight master", alt = { "LORDAERON", "BFD" }, below = 27 }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", alt = { "LORDAERON", "BFD" }, below = 27 }, -- vol
    { "accept", 868, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "sethearth", 1413, 51.99, 29.89, alt = { "LORDAERON", "BFD" }, below = 27 }, -- lier la pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master", alt = { "LORDAERON", "BFD" }, below = 27 }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens", alt = { "LORDAERON", "BFD" }, below = 27 }, -- vol
    { "accept", 893, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "accept", 97250, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "accept", 5052, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 843, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 5052, at = { 1413, 47.24, 84.86 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "complete", 843, at = { 1413, 47.47, 85 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "turnin", 843, xp = 1850, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 846, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 846, at = { 1413, 49.19, 84.17 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 97250, at = { 1413, 49.42, 77.67 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "complete", 868, at = { 1413, 47.96, 70.53 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "turnin", 97250, xp = 2300, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "turnin", 5052, xp = 1250, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 879, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "turnin", 846, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "accept", 849, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 879, obj = 3, at = { 1413, 40.15, 80.54 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 893, obj = 3, at = { 1413, 41.93, 81.47 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 893, at = { 1413, 43.52, 82.91 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 879, obj = 2, at = { 1413, 43.75, 83.26 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "accept", 4542, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 25)
    { "accept", 4904, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 25)
    { "accept", 4881, at = { 1441, 39.43, 33.1 }, note = "Loot Assassination Note to start the quest (85.5 % drop: about 2 kills)", alt = { "LORDAERON", "BFD" }, below = 27 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 25)
    { "fp", 1441, 45.14, 49.11, alt = { "LORDAERON", "BFD" }, below = 27 }, -- point de vol
    { "accept", 1149, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 25)
    { "accept", 4767, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 25)
    { "turnin", 4542, xp = 510, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 25)
    { "accept", 4821, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 4821, at = { 1441, 37.63, 56.13 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 4821, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 25)
    { "accept", 4865, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "accept", 4770, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4767, at = { 1441, 11.77, 35.26 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "complete", 4770, at = { 1441, 15.15, 32.65 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4881, xp = 2300, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 4770, xp = 2350, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4865, xp = 1050, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 1149, at = { 1441, 26.43, 32.93 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 4904, at = { 1441, 30.93, 37.12 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4767, xp = 1750, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 4904, xp = 2350, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 1149, xp = 1050, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 849, at = { 1413, 46.97, 85.63 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 879, at = { 1413, 45.12, 80.07 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 1535, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 26)
    { "turnin", 849, xp = 2100, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 1535, at = { 1413, 44.28, 76.75 }, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 26)
    { "turnin", 1535, xp = 870, alt = { "LORDAERON", "BFD" }, below = 27, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~870 xp, sim lvl 26)
    { "turnin", 879, xp = 1500, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 906, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 893, xp = 1950, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 26)
    { "hearth", 1413, alt = { "LORDAERON", "BFD" }, below = 27 }, -- pierre de foyer
    { "turnin", 906, xp = 3050, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 868, xp = 1750, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 26)
    { "accept", 97003, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "complete", 97003, at = { 1413, 58.05, 26.68 }, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "turnin", 97003, xp = 1650, alt = { "LORDAERON", "BFD" }, below = 27 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "level", 27, at = { 1413, 58.05, 26.68 }, note = "About 82 more mobs near the last objective", alt = { "LORDAERON", "BFD" }, below = 27 }, -- farm de niveau
  },
})
