local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 55 étapes, niveau final 35.00, ~44298 xp/h, 85 min.
Q:RegisterGuide({
  id = "A_10",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  minLevel = 34, maxLevel = 35,
  next = "A_11",
  sim = { steps = 55, endLevel = 35.00, xpPerHour = 44298, minutes = 85 },
  steps = {
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul" },
    { "hearth", 1431 }, -- pierre de foyer
    { "accept", 583 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 34)
    { "turnin", 583, xp = 245 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 34)
    { "accept", 194 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 34)
    { "accept", 185 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "accept", 190 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "turnin", 5762, xp = 1250 }, -- Hemet Nesingwary (lvl 31, ~1250 xp, sim lvl 34)
    { "complete", 185, at = { 1434, 34.28, 11.84 } }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "complete", 190, at = { 1434, 41.8, 12.69 } }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "accept", 215 }, -- Jungle Secrets (lvl 33, ~1300 xp, sim lvl 34)
    { "turnin", 185, xp = 1250 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "accept", 186 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "turnin", 190, xp = 1250 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 34)
    { "accept", 191 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "complete", 194, at = { 1434, 26.88, 16.33 } }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 34)
    { "accept", 97329 }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 34)
    { "accept", 97331 }, -- Zimmix's Great Escape (lvl 35, ~0 xp, sim lvl 34)
    { "complete", 97329, at = { 1434, 25.06, 10.31 } }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 97329, xp = 2750 }, -- Where's the Key? (lvl 35, ~2750 xp, sim lvl 34)
    { "complete", 191, at = { 1434, 29.62, 10.42 } }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "complete", 186, at = { 1434, 29.8, 10.25 } }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "turnin", 194, xp = 1350 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 34)
    { "accept", 195 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 34)
    { "turnin", 186, xp = 1300 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "accept", 187 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 191, xp = 1300 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 34)
    { "accept", 203 }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 34)
    { "accept", 204 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 34)
    { "turnin", 215, xp = 1300 }, -- Jungle Secrets (lvl 33, ~1300 xp, sim lvl 34)
    { "accept", 200 }, -- Bookie Herod (lvl 35, ~1350 xp, sim lvl 34)
    { "accept", 210 }, -- Krazek's Cookery (lvl 37, ~0 xp, sim lvl 34)
    { "accept", 97048 }, -- Returning to Port (lvl 38, ~0 xp, sim lvl 34)
    { "turnin", 200, xp = 1350 }, -- Bookie Herod (lvl 35, ~1350 xp, sim lvl 34)
    { "accept", 328 }, -- The Hidden Key (lvl 37, ~1400 xp, sim lvl 34)
    { "complete", 204, obj = 2, at = { 1434, 44.3, 9.63 } }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 34)
    { "complete", 203, at = { 1434, 44.7, 10.07 } }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 34)
    { "complete", 204, at = { 1434, 47.45, 7.11 } }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 34)
    { "turnin", 328, xp = 1400 }, -- The Hidden Key (lvl 37, ~1400 xp, sim lvl 34)
    { "accept", 329 }, -- The Spy Revealed! (lvl 37, ~1400 xp, sim lvl 34)
    { "accept", 97420 }, -- Reduce, Reuse, Reconcile (lvl 36, ~2800 xp, sim lvl 34)
    { "complete", 195, at = { 1434, 38.49, 20.44 } }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 34)
    { "complete", 187, at = { 1434, 35.01, 18.88 } }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 195, xp = 1400 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 34)
    { "turnin", 187, xp = 2050 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 204, xp = 2700 }, -- Bad Medicine (lvl 34, ~2700 xp, sim lvl 34)
    { "turnin", 203, xp = 1950 }, -- The Second Rebellion (lvl 33, ~1950 xp, sim lvl 34)
    { "turnin", 329, xp = 1400 }, -- The Spy Revealed! (lvl 37, ~1400 xp, sim lvl 34)
    { "accept", 330 }, -- Patrol Schedules (lvl 37, ~285 xp, sim lvl 34)
    { "turnin", 330, xp = 285 }, -- Patrol Schedules (lvl 37, ~285 xp, sim lvl 34)
    { "accept", 331 }, -- Report to Doren (lvl 37, ~2850 xp, sim lvl 34)
    { "turnin", 331, xp = 2850 }, -- Report to Doren (lvl 37, ~2850 xp, sim lvl 34)
    { "complete", 97420, at = { 1434, 42.59, 18.77 } }, -- Reduce, Reuse, Reconcile (lvl 36, ~2800 xp, sim lvl 34)
    { "turnin", 97420, xp = 2800 }, -- Reduce, Reuse, Reconcile (lvl 36, ~2800 xp, sim lvl 34)
    { "level", 35, at = { 1434, 42.59, 18.77 }, note = "About 47 more mobs near the last objective" }, -- farm de niveau
  },
})
