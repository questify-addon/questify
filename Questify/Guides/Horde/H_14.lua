local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 43 étapes, niveau final 43.00, ~50062 xp/h, 121 min.
Q:RegisterGuide({
  id = "H_14",
  title = "Swamp of Sorrows",
  faction = "Horde",
  minLevel = 42, maxLevel = 43,
  next = "H_15",
  sim = { steps = 43, endLevel = 43.00, xpPerHour = 50062, minutes = 121 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 624, xp = 3600 }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 42)
    { "accept", 625 }, -- Cortello's Riddle (lvl 43, ~0 xp, sim lvl 42)
    { "accept", 93429 }, -- Blood of My Blood (lvl 35, ~1650 xp, sim lvl 42)
    { "turnin", 93429, xp = 1650 }, -- Blood of My Blood (lvl 35, ~1650 xp, sim lvl 42)
    { "accept", 1389 }, -- Draenethyst Crystals (lvl 35, ~1650 xp, sim lvl 42)
    { "accept", 93430 }, -- Taking the Bait Back (lvl 35, ~1230 xp, sim lvl 42)
    { "fp", 1435, 46.07, 54.83 }, -- point de vol
    { "accept", 698 }, -- Lack of Surplus (lvl 40, ~3150 xp, sim lvl 42)
    { "accept", 1430 }, -- Fresh Meat (lvl 44, ~3750 xp, sim lvl 42)
    { "turnin", 1420, xp = 2350 }, -- Report to Helgrum (lvl 40, ~2350 xp, sim lvl 42)
    { "accept", 1424 }, -- Pool of Tears (lvl 43, ~4450 xp, sim lvl 42)
    { "complete", 698, at = { 1435, 55.41, 52.01 } }, -- Lack of Surplus (lvl 40, ~3150 xp, sim lvl 42)
    { "turnin", 698, xp = 3150 }, -- Lack of Surplus (lvl 40, ~3150 xp, sim lvl 42)
    { "accept", 699 }, -- Lack of Surplus (lvl 42, ~3450 xp, sim lvl 42)
    { "complete", 1430, at = { 1435, 95.77, 74.9 } }, -- Fresh Meat (lvl 44, ~3750 xp, sim lvl 42)
    { "complete", 699, at = { 1435, 80.35, 27.79 } }, -- Lack of Surplus (lvl 42, ~3450 xp, sim lvl 42)
    { "turnin", 699, xp = 3450 }, -- Lack of Surplus (lvl 42, ~3450 xp, sim lvl 42)
    { "accept", 1422 }, -- Threat From the Sea (lvl 45, ~970 xp, sim lvl 42)
    { "turnin", 1422, xp = 970 }, -- Threat From the Sea (lvl 45, ~970 xp, sim lvl 42)
    { "accept", 1426 }, -- Threat From the Sea (lvl 43, ~4450 xp, sim lvl 42)
    { "complete", 1426, at = { 1435, 85.84, 85.19 } }, -- Threat From the Sea (lvl 43, ~4450 xp, sim lvl 42)
    { "complete", 1426, at = { 1435, 63.26, 82.96 } }, -- Threat From the Sea (lvl 43, ~4450 xp, sim lvl 42)
    { "turnin", 1426, xp = 4450 }, -- Threat From the Sea (lvl 43, ~4450 xp, sim lvl 42)
    { "accept", 1427 }, -- Threat From the Sea (lvl 43, ~3600 xp, sim lvl 42)
    { "turnin", 1427, xp = 3600 }, -- Threat From the Sea (lvl 43, ~3600 xp, sim lvl 42)
    { "accept", 1428 }, -- Continued Threat (lvl 45, ~3900 xp, sim lvl 42)
    { "complete", 1428, obj = 1, at = { 1435, 84.77, 87.21 } }, -- Continued Threat (lvl 45, ~3900 xp, sim lvl 42)
    { "complete", 1428, at = { 1435, 63.26, 82.96 } }, -- Continued Threat (lvl 45, ~3900 xp, sim lvl 42)
    { "turnin", 1428, xp = 3900 }, -- Continued Threat (lvl 45, ~3900 xp, sim lvl 42)
    { "complete", 1424, at = { 1435, 72.58, 56.48 } }, -- Pool of Tears (lvl 43, ~4450 xp, sim lvl 42)
    { "accept", 1393 }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 42)
    { "complete", 1389, at = { 1435, 63.27, 22.35 } }, -- Draenethyst Crystals (lvl 35, ~1650 xp, sim lvl 42)
    { "complete", 1393, at = { 1435, 53.08, 29.55 } }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 42)
    { "complete", 93430, at = { 1435, 54.49, 30.2 } }, -- Taking the Bait Back (lvl 35, ~1230 xp, sim lvl 42)
    { "accept", 1392, at = { 1435, 54.9, 34.1 }, note = "Loot Noboru's Cudgel to start the quest (93.3 % drop: about 2 kills)" }, -- Noboru the Cudgel (lvl 39, ~2250 xp, sim lvl 42)
    { "turnin", 1393, xp = 2850 }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 42)
    { "turnin", 1424, xp = 4450 }, -- Pool of Tears (lvl 43, ~4450 xp, sim lvl 42)
    { "turnin", 1430, xp = 3750 }, -- Fresh Meat (lvl 44, ~3750 xp, sim lvl 42)
    { "turnin", 1389, xp = 1650 }, -- Draenethyst Crystals (lvl 35, ~1650 xp, sim lvl 42)
    { "turnin", 1392, xp = 2250 }, -- Noboru the Cudgel (lvl 39, ~2250 xp, sim lvl 42)
    { "turnin", 93430, xp = 1230 }, -- Taking the Bait Back (lvl 35, ~1230 xp, sim lvl 42)
    { "level", 43, at = { 1435, 54.49, 30.2 }, note = "About 85 more mobs near the last objective" }, -- farm de niveau
  },
})
