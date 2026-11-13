local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 60 étapes, niveau final 36.00, ~35720 xp/h, 218 min.
Q:RegisterGuide({
  id = "AD_14",
  title = "Desolace",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 33, maxLevel = 36,
  next = "AD_15",
  sim = { steps = 60, endLevel = 36.00, xpPerHour = 35720, minutes = 218 },
  steps = {
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1442, node = 33, note = "Stonetalon Peak, Stonetalon Mountains" }, -- vol
    { "turnin", 2928, xp = 1225, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Gyrodrillmatic Excavationators (lvl 30, ~1225 xp, sim lvl 31)
    { "turnin", 92489, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Power Overwhelming (lvl 33, ~1325 xp, sim lvl 30)
    { "turnin", 92456, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- A Green Sample (lvl 33, ~1325 xp, sim lvl 30)
    { "fp", 1443, 64.66, 10.54 }, -- point de vol
    { "accept", 1437 }, -- Vahlarriel's Search (lvl 33, ~1950 xp, sim lvl 34)
    { "accept", 97284 }, -- Vahlarriel's Vengeance (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 1437, xp = 1950 }, -- Vahlarriel's Search (lvl 33, ~1950 xp, sim lvl 34)
    { "accept", 1465 }, -- Vahlarriel's Search (lvl 33, ~1950 xp, sim lvl 34)
    { "turnin", 1465, xp = 1950 }, -- Vahlarriel's Search (lvl 33, ~1950 xp, sim lvl 34)
    { "accept", 1438 }, -- Vahlarriel's Search (lvl 33, ~2650 xp, sim lvl 34)
    { "complete", 97284, at = { 1443, 56.31, 23.39 } }, -- Vahlarriel's Vengeance (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 1438, xp = 2650 }, -- Vahlarriel's Search (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 1439 }, -- Search for Tyranis (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 79950 }, -- Demons and You (lvl 35, ~2750 xp, sim lvl 34)
    { "complete", 1439, at = { 1443, 53.01, 29.08 } }, -- Search for Tyranis (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 5741 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 1439, xp = 2650 }, -- Search for Tyranis (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 1440 }, -- Return to Vahlarriel (lvl 33, ~3300 xp, sim lvl 34)
    { "complete", 79950, at = { 1443, 55, 26.2 } }, -- Demons and You (lvl 35, ~2750 xp, sim lvl 34)
    { "complete", 5741, at = { 1443, 55.17, 30.15 } }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 34)
    { "complete", 1440, at = { 1443, 58.27, 30.91 } }, -- Return to Vahlarriel (lvl 33, ~3300 xp, sim lvl 34)
    { "accept", 5821 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 1440, xp = 3300 }, -- Return to Vahlarriel (lvl 33, ~3300 xp, sim lvl 34)
    { "turnin", 97284, xp = 2650 }, -- Vahlarriel's Vengeance (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 5741, xp = 2650 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 6161 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 34)
    { "complete", 6161, obj = 1, at = { 1443, 33.01, 32.36 } }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 34)
    { "complete", 6161, at = { 1443, 35.44, 25.28 } }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 34)
    { "turnin", 6161, xp = 2800 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 34)
    { "accept", 635, at = { 1443, 31.83, 55.73 }, note = "Loot Pendant of Myzrael to start the quest (2.3 % drop: about 45 kills)" }, -- Crystal in the Mountains (lvl 35, ~0 xp, sim lvl 34)
    { "accept", 92817 }, -- Leather Technique (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 92817, xp = 2050 }, -- Leather Technique (lvl 35, ~2050 xp, sim lvl 34)
    { "accept", 92814 }, -- I Need a Tailor (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 92814, xp = 2050 }, -- I Need a Tailor (lvl 35, ~2050 xp, sim lvl 34)
    { "accept", 5943 }, -- Gizelton Caravan (lvl 38, ~2850 xp, sim lvl 35)
    { "complete", 5943, at = { 1443, 55.69, 67.79 } }, -- Gizelton Caravan (lvl 38, ~2850 xp, sim lvl 35)
    { "accept", 5561 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 35)
    { "turnin", 5943, xp = 2850 }, -- Gizelton Caravan (lvl 38, ~2850 xp, sim lvl 35)
    { "complete", 5821, at = { 1443, 67.17, 56.62 } }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 35)
    { "complete", 5561, at = { 1443, 52.17, 58.23 } }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 35)
    { "turnin", 5821, xp = 2750 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 35)
    { "turnin", 5561, xp = 2000 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 35)
    { "accept", 92818 }, -- Big, No, MASSIVE Iron Axes (lvl 35, ~2050 xp, sim lvl 35)
    { "turnin", 92818, xp = 2050 }, -- Big, No, MASSIVE Iron Axes (lvl 35, ~2050 xp, sim lvl 35)
    { "accept", 92755 }, -- Mysterious Mysticism (lvl 35, ~2050 xp, sim lvl 35)
    { "turnin", 92755, xp = 2050 }, -- Mysterious Mysticism (lvl 35, ~2050 xp, sim lvl 35)
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "turnin", 79950, xp = 2750 }, -- Demons and You (lvl 35, ~2750 xp, sim lvl 35)
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1443, node = 37, note = "Nijel's Point, Desolace" }, -- vol
    { "level", 36, at = { 1443, 57.31, 48.35 }, note = "About 230 more mobs here (Hulking Gritjaw Basilisk, level 35)" }, -- farm de niveau
  },
})
