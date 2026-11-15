local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 57 étapes, niveau final 59.00, ~48379 xp/h, 251 min.
Q:RegisterGuide({
  id = "HD_31",
  title = "Felwood and Winterspring",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 58, maxLevel = 59,
  next = "HD_32",
  sim = { steps = 57, endLevel = 59.00, xpPerHour = 48379, minutes = 251 },
  steps = {
    { "hearth", 1434, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- pierre de foyer
    { "boat", 1434, 31.43, 29.91, note = "Take the zeppelin to Orgrimmar (Durotar)", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- déplacement
    { "fly", 1447, node = 44, note = "Valormok, Azshara", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- vol
    { "fp", 1452, 60.47, 36.3, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- point de vol
    { "accept", 3783, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "accept", 92859, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 },
    { "turnin", 92859, xp = 6600, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 },
    { "accept", 6603, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 58)
    { "accept", 84399, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Ka-Boom! (lvl 60, ~0 xp, sim lvl 58)
    { "accept", 5054, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 3783, at = { 1452, 66.83, 42.67 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "goto", 1452, 60.47, 36.3, note = "Flight master", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- déplacement
    { "fly", 1448, node = 48, note = "Bloodvenom Post, Felwood", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- vol
    { "accept", 5156, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 58)
    { "accept", 4521, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5156, obj = 3, at = { 1448, 41.03, 41.96 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 58)
    { "complete", 5156, at = { 1448, 43.73, 40.16 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 58)
    { "accept", 8465, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Speak to Salfa (lvl 55, ~560 xp, sim lvl 58)
    { "accept", 8464, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 8465, xp = 560, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Speak to Salfa (lvl 55, ~560 xp, sim lvl 58)
    { "complete", 4521, obj = 1, at = { 1452, 60.94, 30.59 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5054, at = { 1452, 60.92, 32.9 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 5054, xp = 5800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 5055, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 3783, xp = 4350, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 58)
    { "accept", 977, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "complete", 4521, at = { 1452, 54.48, 37.45 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 58)
    { "goto", 1452, 60.47, 36.3, note = "Flight master", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- déplacement
    { "fly", 1448, node = 48, note = "Bloodvenom Post, Felwood", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- vol
    { "turnin", 4521, xp = 5800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 4741, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 6603, xp = 580, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 58)
    { "accept", 5082, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5082, at = { 1452, 41.52, 43.15 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 4741, at = { 1452, 64.1, 21.8 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 58)
    { "complete", 5082, at = { 1452, 66.47, 34.66 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 8464, at = { 1452, 67.73, 35.93 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "complete", 977, at = { 1452, 70.84, 39.16 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "complete", 5055, at = { 1452, 62.54, 57.9 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 5156, xp = 6800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 58)
    { "turnin", 4741, xp = 6200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 4721, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 58)
    { "turnin", 5082, xp = 5800, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 84399, at = { 1452, 60.7, 37.7 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Ka-Boom! (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 977, xp = 4650, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 58)
    { "accept", 6029, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- The Everlook Report (lvl 52, ~0 xp, sim lvl 58)
    { "accept", 6030, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Duke Nicholas Zverenhoff (lvl 52, ~0 xp, sim lvl 58)
    { "turnin", 5055, xp = 6200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 4882, at = { 1452, 65.3, 22.14 }, note = "Loot Blue-feathered Necklace to start the quest (4.0 % drop: about 25 kills)", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Guarding Secrets (lvl 59, ~3200 xp, sim lvl 58)
    { "complete", 4721, at = { 1452, 64.35, 22.54 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 58)
    { "turnin", 8464, xp = 6200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 84397, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Northern Kalimdor - A Comprehensive Guide (lvl 60, ~0 xp, sim lvl 58)
    { "complete", 84397, at = { 1448, 65.2, 3.3 }, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Northern Kalimdor - A Comprehensive Guide (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 4721, xp = 6400, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 58)
    { "turnin", 4882, xp = 3200, alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- Guarding Secrets (lvl 59, ~3200 xp, sim lvl 58)
    { "level", 59, at = { 1452, 64.35, 22.54 }, note = "About 261 more mobs near the last objective", alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, below = 59 }, -- farm de niveau
  },
})
