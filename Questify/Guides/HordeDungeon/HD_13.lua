local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 44 étapes, niveau final 38.00, ~34915 xp/h, 78 min.
Q:RegisterGuide({
  id = "HD_13",
  title = "Dustwallow Marsh",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 37, maxLevel = 38,
  next = "HD_14",
  sim = { steps = 44, endLevel = 38.00, xpPerHour = 34915, minutes = 78 },
  steps = {
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "fp", 1445, 35.56, 31.88 }, -- point de vol
    { "accept", 1268 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1251 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1269 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "turnin", 1251, xp = 690 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1321 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "turnin", 1268, xp = 1350 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1269, xp = 710 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "turnin", 1321, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "accept", 1322 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1273 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1273, at = { 1445, 42.65, 38.07 } }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1322, at = { 1445, 42.69, 43.51 } }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1218 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 81570 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 81570, xp = 1350 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1238 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "complete", 1218, at = { 1445, 66.44, 51.46 } }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1218, xp = 1350 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1206 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1322, xp = 2850 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1323 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "turnin", 1273, xp = 3550 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "turnin", 1323, xp = 1400 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "accept", 1201 }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1238, xp = 2050 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "complete", 1206, at = { 1445, 31.88, 21.93 } }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 1201, at = { 1445, 38.45, 25.29 } }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 79952 }, -- RwlRwlRwlRwl! (lvl 35, ~0 xp, sim lvl 37)
    { "complete", 79952, at = { 1445, 57.2, 20.8 } }, -- RwlRwlRwlRwl! (lvl 35, ~0 xp, sim lvl 37)
    { "accept", 1239 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 37)
    { "turnin", 1206, xp = 2750 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1201, xp = 2750 }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1239, xp = 2050 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 37)
    { "goto", 1445, 35.56, 31.88, note = "Flight master" }, -- déplacement
    { "fly", 1442, node = 29, note = "Sun Rock Retreat, Stonetalon Mountains" }, -- vol
    { "turnin", 79192, xp = 195 }, -- Stepping Stones (lvl 24, ~195 xp, sim lvl 37)
    { "accept", 79980 }, -- Scramble (lvl 24, ~15 xp, sim lvl 37)
    { "turnin", 79980, xp = 15 }, -- Scramble (lvl 24, ~15 xp, sim lvl 37)
    { "accept", 79974 }, -- Wet Job (lvl 32, ~0 xp, sim lvl 37)
    { "level", 38, at = { 1445, 38.45, 25.29 }, note = "About 16 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1413, 49, 93.9, optional = true, dungeon = "Razorfen Downs", note = "Dungeon: Razorfen Downs (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "RFD" }, -- déplacement
    { "accept", 6522, optional = true, dungeon = "Razorfen Downs", note = "Starts inside the dungeon", phase = "run", rung = "RFD" }, -- An Unholy Alliance (lvl 36, ~1750 xp, sim lvl 38)
  },
})
