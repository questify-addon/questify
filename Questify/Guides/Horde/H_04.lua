local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 74 étapes, niveau final 28.00, ~28272 xp/h, 232 min.
Q:RegisterGuide({
  id = "H_04",
  title = "Southern Barrens and Thousand Needles",
  faction = "Horde",
  minLevel = 25, maxLevel = 28,
  next = "H_06",
  sim = { steps = 74, endLevel = 28.00, xpPerHour = 28272, minutes = 232 },
  steps = {
    { "hearth", 1413 }, -- pierre de foyer
    { "accept", 868 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "accept", 893 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "accept", 5052 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 97250 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "complete", 868, at = { 1413, 47.96, 70.53 } }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "accept", 843 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 5052, at = { 1413, 47.24, 84.86 } }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "complete", 843, at = { 1413, 47.47, 85 } }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 98093 }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 98093, at = { 1413, 44.98, 75.5 } }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 1535, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~695 xp, sim lvl 25)
    { "complete", 1535, at = { 1413, 44.28, 76.75 }, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~695 xp, sim lvl 25)
    { "turnin", 1535, xp = 695, classes = { "SHAMAN" } }, -- Call of Water (lvl 22, ~695 xp, sim lvl 25)
    { "turnin", 843, xp = 1850 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 846 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 98093, xp = 1850 }, -- Field to Clear (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 97250, at = { 1413, 49.11, 76.97 } }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "complete", 846, at = { 1413, 49.19, 84.17 } }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 846, xp = 2100 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "accept", 849 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 97250, xp = 2300 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~2300 xp, sim lvl 25)
    { "turnin", 5052, xp = 1250 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 879 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 879, obj = 3, at = { 1413, 40.15, 80.54 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 893, obj = 3, at = { 1413, 41.93, 81.47 } }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 893, at = { 1413, 43.52, 82.91 } }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 879, obj = 2, at = { 1413, 43.75, 83.26 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 4542 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 26)
    { "accept", 4904 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4904, at = { 1441, 30.93, 37.12 } }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "fp", 1441, 45.14, 49.11 }, -- point de vol
    { "accept", 4767 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 4542, xp = 510 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 26)
    { "turnin", 4904, xp = 2350 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "accept", 4821 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 4821, at = { 1441, 37.63, 56.13 } }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "turnin", 4821, xp = 2100 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "accept", 4865 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "accept", 1149 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "accept", 4881, at = { 1441, 39.43, 33.1 }, note = "Loot Assassination Note to start the quest (85.5 % drop: about 2 kills)" }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "complete", 1149, at = { 1441, 26.43, 32.93 } }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4865, xp = 1050 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4881, xp = 2300 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 4770 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4767, at = { 1441, 11.77, 35.26 } }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "complete", 4770, at = { 1441, 15.15, 32.65 } }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4770, xp = 2350 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4767, xp = 1750 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 1149, xp = 1050 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 849, at = { 1413, 46.97, 85.63 } }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 879, at = { 1413, 45.12, 80.07 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "turnin", 849, xp = 2100 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "accept", 79007 }, -- ... and that note you found (lvl 22, ~0 xp, sim lvl 26)
    { "turnin", 879, xp = 1500 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 906 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 893, xp = 1950 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 26)
    { "hearth", 1413 }, -- pierre de foyer
    { "accept", 78143 }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 78143, at = { 1413, 49.3, 33.04 } }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 26)
    { "turnin", 906, xp = 3050 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 868, xp = 1750 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 26)
    { "accept", 97003 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "accept", 79097 }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 79097, at = { 1413, 62.7, 36.3 } }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 97003, at = { 1413, 57.53, 27.06 } }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "turnin", 97003, xp = 1650 }, -- Chol'aruk the Ravener (lvl 21, ~1650 xp, sim lvl 26)
    { "accept", 78145 }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 78145, at = { 1413, 56.3, 8.8 } }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 26)
    { "level", 28, at = { 1413, 57.53, 27.06 }, note = "About 305 more mobs near the last objective" }, -- farm de niveau
  },
})
