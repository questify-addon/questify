local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 29 étapes, niveau final 40.08, ~40066 xp/h, 122 min.
Q:RegisterGuide({
  id = "HD_15",
  title = "Badlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 39, maxLevel = 40,
  next = "HD_16",
  sim = { steps = 29, endLevel = 40.08, xpPerHour = 40066, minutes = 122 },
  steps = {
    { "fp", 1418, 3.99, 44.78 }, -- point de vol
    { "accept", 97663 }, -- Supplies and Studies (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 97663, xp = 3150 }, -- Supplies and Studies (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 2258 }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 1419 }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 39)
    { "complete", 2258, obj = 3, at = { 1418, 21.13, 45.46 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 710 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "complete", 710, at = { 1418, 20.96, 45.07 } }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "turnin", 710, xp = 2850 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 39)
    { "accept", 711 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 2418, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~0 xp, sim lvl 39)
    { "accept", 709, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~0 xp, sim lvl 39)
    { "complete", 711, at = { 1418, 42.98, 80.83 } }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 39)
    { "complete", 1419, at = { 1418, 35.5, 62.56 } }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 39)
    { "complete", 2258, obj = 2, at = { 1418, 35.5, 62.56 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "complete", 2258, at = { 1418, 15.71, 60.94 } }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "turnin", 2258, xp = 3000 }, -- Badlands Reagent Run (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 2202, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Uldaman Reagent Run (lvl 42, ~0 xp, sim lvl 40)
    { "turnin", 1419, xp = 3150 }, -- Coyote Thieves (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 711, xp = 3000 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 40)
    { "goto", 1418, 44.6, 12.1, optional = true, dungeon = "Uldaman", note = "Dungeon: Uldaman (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "ULDAMAN" }, -- déplacement
    { "complete", 709, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~1575 xp, sim lvl 40)
    { "complete", 2202, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Uldaman Reagent Run (lvl 42, ~1725 xp, sim lvl 40)
    { "complete", 2342, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Reclaimed Treasures (lvl 43, ~1800 xp, sim lvl 40)
    { "complete", 2418, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~1750 xp, sim lvl 40)
    { "turnin", 709, xp = 1575, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~1575 xp, sim lvl 40)
    { "turnin", 2202, xp = 1725, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Uldaman Reagent Run (lvl 42, ~1725 xp, sim lvl 40)
    { "turnin", 2418, xp = 1750, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~1750 xp, sim lvl 40)
    { "turnin", 2342, xp = 1800, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Reclaimed Treasures (lvl 43, ~1800 xp, sim lvl 40)
  },
})
