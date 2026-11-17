local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 45 étapes, niveau final 34.00, ~38418 xp/h, 224 min.
Q:RegisterGuide({
  id = "AD_13",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 32, maxLevel = 34,
  next = "AD_14",
  sim = { steps = 45, endLevel = 34.00, xpPerHour = 38418, minutes = 224 },
  steps = {
    { "hearth", 1431, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- pierre de foyer
    { "turnin", 5762, xp = 1250, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Hemet Nesingwary (lvl 31, ~1250 xp, sim lvl 31)
    { "accept", 583, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 31)
    { "turnin", 583, xp = 245, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 31)
    { "accept", 194, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 31)
    { "accept", 185, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "accept", 190, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "accept", 215, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Jungle Secrets (lvl 33, ~1300 xp, sim lvl 31)
    { "turnin", 215, xp = 1300, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Jungle Secrets (lvl 33, ~1300 xp, sim lvl 31)
    { "accept", 200, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bookie Herod (lvl 35, ~1350 xp, sim lvl 31)
    { "accept", 203, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 31)
    { "accept", 204, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 190, at = { 1434, 41.8, 12.69 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "turnin", 200, xp = 1350, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bookie Herod (lvl 35, ~1350 xp, sim lvl 31)
    { "accept", 328, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Hidden Key (lvl 37, ~1400 xp, sim lvl 31)
    { "complete", 204, obj = 2, at = { 1434, 44.3, 9.63 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 203, at = { 1434, 44.7, 10.07 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 31)
    { "turnin", 328, xp = 1400, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Hidden Key (lvl 37, ~1400 xp, sim lvl 31)
    { "accept", 329, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Spy Revealed! (lvl 37, ~1400 xp, sim lvl 31)
    { "turnin", 329, xp = 1400, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Spy Revealed! (lvl 37, ~1400 xp, sim lvl 31)
    { "accept", 330, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Patrol Schedules (lvl 37, ~285 xp, sim lvl 31)
    { "turnin", 330, xp = 285, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Patrol Schedules (lvl 37, ~285 xp, sim lvl 31)
    { "accept", 331, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Report to Doren (lvl 37, ~2850 xp, sim lvl 31)
    { "turnin", 331, xp = 2850, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Report to Doren (lvl 37, ~2850 xp, sim lvl 31)
    { "turnin", 203, xp = 1950, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 31)
    { "complete", 185, at = { 1434, 34.28, 11.84 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "turnin", 185, xp = 1250, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "accept", 186, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 31)
    { "turnin", 190, xp = 1250, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 31)
    { "accept", 191, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 31)
    { "complete", 186, at = { 1434, 29.8, 10.25 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 31)
    { "complete", 191, at = { 1434, 29.62, 10.42 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 31)
    { "complete", 194, at = { 1434, 26.88, 16.33 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 31)
    { "turnin", 186, xp = 1300, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 31)
    { "accept", 187, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 31)
    { "turnin", 194, xp = 1350, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 31)
    { "turnin", 191, xp = 1300, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 32)
    { "complete", 187, at = { 1434, 35.01, 18.88 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 32)
    { "complete", 204, at = { 1434, 47.45, 7.11 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 32)
    { "turnin", 204, xp = 2700, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 32)
    { "turnin", 187, xp = 2050, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 32)
    { "accept", 97329, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 97329, at = { 1434, 25.06, 10.31 }, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 97329, xp = 2750, alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 32)
    { "level", 34, at = { 1434, 29.71, 10.34 }, note = "About 491 more mobs here (Panther, level 32)", alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" }, below = 34 }, -- farm de niveau
  },
})
