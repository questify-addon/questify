local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 38 étapes, niveau final 58.00, ~58760 xp/h, 188 min.
Q:RegisterGuide({
  id = "AD_32",
  title = "Winterspring",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 57, maxLevel = 58,
  next = "AD_33",
  sim = { steps = 38, endLevel = 58.00, xpPerHour = 58760, minutes = 188 },
  steps = {
    { "hearth", 1445, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- pierre de foyer
    { "goto", 1445, 67.48, 51.3, note = "Flight master", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- déplacement
    { "fly", 1447, node = 64, note = "Talrendis Point, Azshara", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- vol
    { "fp", 1452, 62.33, 36.61, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- point de vol
    { "accept", 3783, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 57)
    { "accept", 6603, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 57)
    { "accept", 92859, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 },
    { "turnin", 92859, xp = 6600, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 },
    { "accept", 6604, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 57)
    { "accept", 6030, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Duke Nicholas Zverenhoff (lvl 52, ~0 xp, sim lvl 57)
    { "complete", 3783, at = { 1452, 66.83, 42.67 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 57)
    { "turnin", 3783, xp = 4350, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 57)
    { "accept", 977, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 57)
    { "accept", 5244, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 57)
    { "turnin", 6604, xp = 640, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 57)
    { "turnin", 5244, xp = 580, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 57)
    { "accept", 5245, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 57)
    { "accept", 4861, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 57)
    { "accept", 8464, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 57)
    { "turnin", 6603, xp = 580, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 57)
    { "accept", 5082, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 57)
    { "complete", 5082, at = { 1452, 41.52, 43.15 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 57)
    { "complete", 5245, at = { 1452, 50.88, 41.71 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 57)
    { "complete", 5245, at = { 1452, 55.14, 42.98 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 57)
    { "turnin", 4861, xp = 3200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 57)
    { "accept", 4863, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 57)
    { "turnin", 4863, xp = 3200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 57)
    { "accept", 4864, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 57)
    { "complete", 4864, obj = 1, at = { 1452, 61.4, 60.73 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 57)
    { "complete", 4864, at = { 1452, 64.77, 59.76 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 57)
    { "complete", 977, at = { 1452, 70.84, 39.16 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 57)
    { "complete", 8464, at = { 1452, 67.73, 35.93 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 57)
    { "complete", 5082, at = { 1452, 66.47, 34.66 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 57)
    { "turnin", 977, xp = 4650, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 57)
    { "turnin", 4864, xp = 6400, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 57)
    { "turnin", 5082, xp = 5800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 57)
    { "turnin", 8464, xp = 6200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 57)
    { "level", 58, at = { 1452, 66.47, 34.66 }, note = "About 379 more mobs near the last objective", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 58 }, -- farm de niveau
  },
})
