local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 39 étapes, niveau final 59.00, ~53532 xp/h, 227 min.
Q:RegisterGuide({
  id = "AD_32",
  title = "Winterspring",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 58, maxLevel = 59,
  next = "AD_33",
  sim = { steps = 39, endLevel = 59.00, xpPerHour = 53532, minutes = 227 },
  steps = {
    { "hearth", 1434, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- déplacement
    { "fly", 1448, node = 65, note = "Talonbranch Glade, Felwood", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- vol
    { "fp", 1452, 62.33, 36.61, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- point de vol
    { "accept", 3783, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "accept", 6603, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 58)
    { "accept", 92859, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 },
    { "turnin", 92859, xp = 6600, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 },
    { "accept", 6604, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 58)
    { "accept", 6030, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Duke Nicholas Zverenhoff (lvl 52, ~0 xp, sim lvl 58)
    { "complete", 3783, at = { 1452, 66.83, 42.67 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "turnin", 3783, xp = 4350, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "accept", 977, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "accept", 5244, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 58)
    { "turnin", 5244, xp = 580, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 58)
    { "turnin", 6604, xp = 640, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 58)
    { "accept", 4861, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 58)
    { "accept", 5245, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 58)
    { "accept", 8464, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 6603, xp = 580, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 58)
    { "accept", 5082, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5082, at = { 1452, 41.52, 43.15 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5245, at = { 1452, 50.88, 41.71 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 58)
    { "complete", 5245, at = { 1452, 55.14, 42.98 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 58)
    { "turnin", 4861, xp = 3200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 58)
    { "accept", 4863, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 58)
    { "turnin", 4863, xp = 3200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 58)
    { "accept", 4864, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 58)
    { "complete", 4864, obj = 1, at = { 1452, 61.4, 60.73 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 58)
    { "complete", 4864, at = { 1452, 64.77, 59.76 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 58)
    { "complete", 977, at = { 1452, 70.84, 39.16 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "complete", 8464, at = { 1452, 67.73, 35.93 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "complete", 5082, at = { 1452, 66.47, 34.66 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 977, xp = 4650, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "turnin", 4864, xp = 6400, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 58)
    { "turnin", 5082, xp = 5800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 8464, xp = 6200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "level", 59, at = { 1452, 66.47, 34.66 }, note = "About 436 more mobs near the last objective", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- farm de niveau
  },
})
