local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 23 étapes, niveau final 40.00, ~40599 xp/h, 122 min.
Q:RegisterGuide({
  id = "H_12",
  title = "Badlands",
  faction = "Horde",
  minLevel = 39, maxLevel = 40,
  next = "H_13",
  sim = { steps = 23, endLevel = 40.00, xpPerHour = 40599, minutes = 122 },
  steps = {
    { "note", "Not running Gnomeregan? Abandon Rig Wars, Chief Engineer Scooty", optional = true, dungeon = "Gnomeregan" },
    { "fp", 1418, 3.99, 44.78 }, -- point de vol
    { "accept", 97663 }, -- Supplies and Studies (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 97663, xp = 3150 }, -- Supplies and Studies (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 2258 }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 1419 }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 1420 }, -- Report to Helgrum (lvl 40, ~0 xp, sim lvl 39)
    { "complete", 2258, obj = 3, at = { 1418, 21.13, 45.46 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 710 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "complete", 710, at = { 1418, 20.96, 45.07 } }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "turnin", 710, xp = 2850 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "accept", 711 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 2418, optional = true, dungeon = "Uldaman" }, -- Power Stones (lvl 36, ~0 xp, sim lvl 39)
    { "accept", 709, optional = true, dungeon = "Uldaman" }, -- Solution to Doom (lvl 40, ~0 xp, sim lvl 39)
    { "complete", 711, at = { 1418, 42.98, 80.83 } }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 39)
    { "complete", 1419, at = { 1418, 35.5, 62.56 } }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 39)
    { "complete", 2258, obj = 2, at = { 1418, 35.5, 62.56 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "turnin", 711, xp = 3000 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 39)
    { "complete", 2258, at = { 1418, 15.71, 60.94 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "turnin", 1419, xp = 3150 }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 2258, xp = 3000 }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 2202, optional = true, dungeon = "Uldaman" }, -- Uldaman Reagent Run (lvl 42, ~0 xp, sim lvl 39)
    { "level", 40, at = { 1418, 14.59, 62.88 }, note = "About 5 more mobs here (Giant Buzzard, level 40)" }, -- farm de niveau
  },
})
