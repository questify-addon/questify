local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 93 étapes, niveau final 28.00, ~26425 xp/h, 248 min.
Q:RegisterGuide({
  id = "H_04",
  title = "Southern Barrens and Thousand Needles",
  faction = "Horde",
  minLevel = 25, maxLevel = 28,
  next = "H_05",
  sim = { steps = 93, endLevel = 28.00, xpPerHour = 26425, minutes = 248 },
  steps = {
    { "hearth", 1413 }, -- pierre de foyer
    { "goto", 1413, 44.45, 59.15, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "accept", 868 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "sethearth", 1413, 51.99, 29.89 }, -- lier la pierre de foyer
    { "accept", 95774 }, -- Her Name Is Olgra (lvl 20, ~1240 xp, sim lvl 25)
    { "complete", 95774, at = { 1413, 51.04, 50.57 } }, -- Her Name Is Olgra (lvl 20, ~1240 xp, sim lvl 25)
    { "accept", 97250 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 878 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 25)
    { "accept", 893 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 878, obj = 1, at = { 1413, 45.69, 54.16 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 25)
    { "complete", 878, obj = 2, at = { 1413, 45.14, 51.55 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 25)
    { "complete", 878, at = { 1413, 43.26, 48.08 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 25)
    { "turnin", 878, xp = 1650 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 25)
    { "accept", 5052 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 843 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 5052, at = { 1413, 47.24, 84.86 } }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "complete", 843, at = { 1413, 47.47, 85 } }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "turnin", 843, xp = 1850 }, -- Gann's Reclamation (lvl 23, ~1850 xp, sim lvl 25)
    { "accept", 846 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 97250, at = { 1413, 49.04, 77.28 } }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~1850 xp, sim lvl 25)
    { "complete", 846, at = { 1413, 49.19, 84.17 } }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 846, xp = 2100 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "accept", 849 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 25)
    { "complete", 868, at = { 1413, 47.96, 70.53 } }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 25)
    { "turnin", 97250, xp = 1850 }, -- Wrongly Blamed, Justly Corrected (lvl 23, ~1850 xp, sim lvl 25)
    { "turnin", 5052, xp = 1250 }, -- Blood Shards of Agamaggan (lvl 21, ~1250 xp, sim lvl 25)
    { "accept", 879 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 879, obj = 3, at = { 1413, 40.15, 80.54 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "complete", 893, obj = 3, at = { 1413, 41.93, 81.47 } }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 893, at = { 1413, 43.52, 82.91 } }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 25)
    { "complete", 879, obj = 2, at = { 1413, 43.75, 83.26 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 25)
    { "accept", 4542 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 25)
    { "accept", 4904 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 25)
    { "accept", 4881, at = { 1441, 39.43, 33.1 }, note = "Loot Assassination Note to start the quest" }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "fp", 1441, 45.14, 49.11 }, -- point de vol
    { "accept", 1149 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4542, xp = 510 }, -- Message to Freewind Post (lvl 25, ~510 xp, sim lvl 26)
    { "accept", 4841 }, -- Pacify the Centaur (lvl 25, ~2000 xp, sim lvl 26)
    { "accept", 4821 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 4821, at = { 1441, 37.63, 56.13 } }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 4841, at = { 1441, 40.95, 36.01 } }, -- Pacify the Centaur (lvl 25, ~2000 xp, sim lvl 26)
    { "accept", 4767 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 4821, xp = 2100 }, -- Alien Egg (lvl 26, ~2100 xp, sim lvl 26)
    { "turnin", 4841, xp = 2000 }, -- Pacify the Centaur (lvl 25, ~2000 xp, sim lvl 26)
    { "accept", 5064 }, -- Grimtotem Spying (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 4865 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 5064, obj = 3, at = { 1441, 39.34, 41.53 } }, -- Grimtotem Spying (lvl 28, ~2300 xp, sim lvl 26)
    { "complete", 5064, obj = 1, at = { 1441, 31.79, 32.58 } }, -- Grimtotem Spying (lvl 28, ~2300 xp, sim lvl 26)
    { "complete", 1149, at = { 1441, 26.43, 32.93 } }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4865, xp = 1050 }, -- Serpent Wild (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 4881, xp = 2300 }, -- Assassination Plot (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 4770 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4767, at = { 1441, 11.77, 35.26 } }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "complete", 4770, at = { 1441, 15.15, 32.65 } }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 4770, xp = 2350 }, -- Homeward Bound (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 4904, at = { 1441, 30.93, 37.12 } }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "complete", 5064, at = { 1441, 33.76, 39.99 } }, -- Grimtotem Spying (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 4767, xp = 1750 }, -- Wind Rider (lvl 29, ~1750 xp, sim lvl 26)
    { "turnin", 5064, xp = 2300 }, -- Grimtotem Spying (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 4904, xp = 2350 }, -- Free at Last (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 1149, xp = 1050 }, -- Test of Faith (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 849, at = { 1413, 46.97, 85.63 } }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "complete", 879, at = { 1413, 45.12, 80.07 } }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "turnin", 849, xp = 2100 }, -- Revenge of Gann (lvl 26, ~2100 xp, sim lvl 26)
    { "turnin", 879, xp = 1500 }, -- Betrayal from Within (lvl 25, ~1500 xp, sim lvl 26)
    { "accept", 906 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "accept", 874 }, -- Mahren Skyseer (lvl 27, ~550 xp, sim lvl 26)
    { "turnin", 893, xp = 1950 }, -- Weapons of Choice (lvl 24, ~1950 xp, sim lvl 26)
    { "hearth", 1413 }, -- pierre de foyer
    { "accept", 78143 }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 78143, at = { 1413, 49.3, 32.88 } }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 26)
    { "turnin", 95774, xp = 1240 }, -- Her Name Is Olgra (lvl 20, ~1240 xp, sim lvl 26)
    { "turnin", 906, xp = 3050 }, -- Betrayal from Within (lvl 25, ~3050 xp, sim lvl 26)
    { "turnin", 868, xp = 1750 }, -- Egg Hunt (lvl 22, ~1750 xp, sim lvl 26)
    { "accept", 97003 }, -- Chol'aruk the Ravener (lvl 21, ~1320 xp, sim lvl 26)
    { "complete", 97003, at = { 1413, 57.95, 26.8 } }, -- Chol'aruk the Ravener (lvl 21, ~1320 xp, sim lvl 26)
    { "accept", 79097 }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 26)
    { "complete", 79097, at = { 1413, 62.7, 36.3 } }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 26)
    { "accept", 891 }, -- The Guns of Northwatch (lvl 20, ~930 xp, sim lvl 26)
    { "turnin", 874, xp = 550 }, -- Mahren Skyseer (lvl 27, ~550 xp, sim lvl 26)
    { "accept", 873 }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 26)
    { "complete", 873, at = { 1413, 64.12, 50.8 } }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 26)
    { "complete", 891, obj = 3, at = { 1413, 63.18, 56.64 } }, -- The Guns of Northwatch (lvl 20, ~930 xp, sim lvl 26)
    { "complete", 891, at = { 1413, 61.85, 54.65 } }, -- The Guns of Northwatch (lvl 20, ~930 xp, sim lvl 26)
    { "turnin", 873, xp = 2750 }, -- Isha Awak (lvl 27, ~2750 xp, sim lvl 27)
    { "turnin", 891, xp = 930 }, -- The Guns of Northwatch (lvl 20, ~930 xp, sim lvl 27)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 97003, xp = 1320 }, -- Chol'aruk the Ravener (lvl 21, ~1320 xp, sim lvl 27)
    { "accept", 78145 }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 27)
    { "complete", 78145, at = { 1413, 56.3, 8.8 } }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 27)
    { "level", 28, at = { 1413, 61.85, 54.65 }, note = "About 210 more mobs near the last objective" }, -- farm de niveau
  },
})
