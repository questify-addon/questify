local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 50 étapes, niveau final 46.00, ~43190 xp/h, 466 min.
Q:RegisterGuide({
  id = "AD_22",
  title = "Feralas",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 44, maxLevel = 46,
  next = "AD_23",
  sim = { steps = 50, endLevel = 46.00, xpPerHour = 43190, minutes = 466 },
  steps = {
    { "goto", 1417, 45.73, 46.1, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "boat", 1424, 50.5, 67, note = "Take the boat to Auberdine" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1443, node = 37, note = "Nijel's Point, Desolace" }, -- vol
    { "fp", 1444, 30.24, 43.25 }, -- point de vol
    { "accept", 2821 }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 43)
    { "accept", 92858 }, -- WANTED: Ohk'zi (lvl 43, ~4450 xp, sim lvl 43)
    { "accept", 2866 }, -- The Ruins of Solarsal (lvl 43, ~2700 xp, sim lvl 43)
    { "accept", 4124 }, -- The Missing Courier (lvl 43, ~360 xp, sim lvl 43)
    { "turnin", 2866, xp = 2700 }, -- The Ruins of Solarsal (lvl 43, ~2700 xp, sim lvl 43)
    { "accept", 2867 }, -- Return to Feathermoon Stronghold (lvl 43, ~1800 xp, sim lvl 43)
    { "turnin", 2867, xp = 1800 }, -- Return to Feathermoon Stronghold (lvl 43, ~1800 xp, sim lvl 43)
    { "accept", 3130 }, -- Against the Hatecrest (lvl 43, ~360 xp, sim lvl 43)
    { "turnin", 3130, xp = 360 }, -- Against the Hatecrest (lvl 43, ~360 xp, sim lvl 43)
    { "accept", 2869 }, -- Against the Hatecrest (lvl 43, ~2700 xp, sim lvl 43)
    { "turnin", 4124, xp = 360 }, -- The Missing Courier (lvl 43, ~360 xp, sim lvl 43)
    { "accept", 4125 }, -- The Missing Courier (lvl 43, ~2700 xp, sim lvl 43)
    { "accept", 2982 }, -- The High Wilderness (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 2869, at = { 1444, 27.75, 53.32 } }, -- Against the Hatecrest (lvl 43, ~2700 xp, sim lvl 43)
    { "turnin", 4125, xp = 2700 }, -- The Missing Courier (lvl 43, ~2700 xp, sim lvl 43)
    { "accept", 4127 }, -- Boat Wreckage (lvl 44, ~375 xp, sim lvl 43)
    { "turnin", 4127, xp = 375 }, -- Boat Wreckage (lvl 44, ~375 xp, sim lvl 43)
    { "accept", 4129 }, -- The Knife Revealed (lvl 44, ~375 xp, sim lvl 43)
    { "turnin", 4129, xp = 375 }, -- The Knife Revealed (lvl 44, ~375 xp, sim lvl 43)
    { "accept", 4130 }, -- Psychometric Reading (lvl 44, ~375 xp, sim lvl 43)
    { "turnin", 4130, xp = 375 }, -- Psychometric Reading (lvl 44, ~375 xp, sim lvl 43)
    { "accept", 4131 }, -- The Woodpaw Gnolls (lvl 44, ~2800 xp, sim lvl 43)
    { "complete", 2821, at = { 1444, 52.05, 58.58 } }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 43)
    { "complete", 2982, obj = 2, at = { 1444, 60.16, 65.41 } }, -- The High Wilderness (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 2982, at = { 1444, 60.75, 56.39 } }, -- The High Wilderness (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 4131, xp = 2800 }, -- The Woodpaw Gnolls (lvl 44, ~2800 xp, sim lvl 43)
    { "accept", 4135 }, -- The Writhing Deep (lvl 46, ~3050 xp, sim lvl 43)
    { "accept", 4281, at = { 1444, 73.32, 56.31 }, note = "Loot Undelivered Parcel to start the quest" }, -- Thalanaar Delivery (lvl 44, ~2800 xp, sim lvl 43)
    { "turnin", 4135, xp = 3050 }, -- The Writhing Deep (lvl 46, ~3050 xp, sim lvl 43)
    { "accept", 4265 }, -- Freed from the Hive (lvl 46, ~4050 xp, sim lvl 43)
    { "complete", 4265, at = { 1444, 72.13, 63.84 } }, -- Freed from the Hive (lvl 46, ~4050 xp, sim lvl 43)
    { "fp", 1444, 89.5, 45.85 }, -- point de vol
    { "turnin", 4281, xp = 2800 }, -- Thalanaar Delivery (lvl 44, ~2800 xp, sim lvl 43)
    { "complete", 92858, at = { 1444, 74.98, 25.35 } }, -- WANTED: Ohk'zi (lvl 43, ~4450 xp, sim lvl 43)
    { "goto", 1444, 89.5, 45.85, note = "Flight master" }, -- déplacement
    { "fly", 1444, node = 41, note = "Feathermoon, Feralas" }, -- vol
    { "turnin", 4265, xp = 4050 }, -- Freed from the Hive (lvl 46, ~4050 xp, sim lvl 43)
    { "accept", 4266 }, -- A Hero's Welcome (lvl 46, ~6050 xp, sim lvl 43)
    { "turnin", 2982, xp = 3750 }, -- The High Wilderness (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 2869, xp = 2700 }, -- Against the Hatecrest (lvl 43, ~2700 xp, sim lvl 43)
    { "turnin", 92858, xp = 4450 }, -- WANTED: Ohk'zi (lvl 43, ~4450 xp, sim lvl 43)
    { "turnin", 4266, xp = 6050 }, -- A Hero's Welcome (lvl 46, ~6050 xp, sim lvl 43)
    { "turnin", 2821, xp = 4050 }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 43)
    { "level", 46, at = { 1444, 29.18, 52.26 }, note = "About 1130 more mobs here (Hatecrest Warrior, level 42)" }, -- farm de niveau
  },
})
