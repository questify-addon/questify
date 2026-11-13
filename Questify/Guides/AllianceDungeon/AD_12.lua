local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 31 étapes, niveau final 33.00, ~27265 xp/h, 232 min.
Q:RegisterGuide({
  id = "AD_12",
  title = "Thousand Needles",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 31, maxLevel = 33,
  next = "AD_13",
  sim = { steps = 31, endLevel = 33.00, xpPerHour = 27265, minutes = 232 },
  steps = {
    { "goto", 1455, 55.5, 47.74, note = "Flight master" }, -- déplacement
    { "fly", 1436, node = 4, note = "Sentinel Hill, Westfall" }, -- vol
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "fp", 1445, 67.48, 51.3 }, -- point de vol
    { "accept", 1110 }, -- Rocket Car Parts (lvl 31, ~2500 xp, sim lvl 31)
    { "accept", 1111 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 31)
    { "accept", 5762 }, -- Hemet Nesingwary (lvl 31, ~0 xp, sim lvl 31)
    { "turnin", 1179, xp = 2450 }, -- The Brassbolts Brothers (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1105 }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1176 }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 31)
    { "complete", 1110, at = { 1441, 71.08, 57.98 } }, -- Rocket Car Parts (lvl 31, ~2500 xp, sim lvl 31)
    { "goto", 1445, 67.48, 51.3, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "turnin", 1111, xp = 1400 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 31)
    { "accept", 1112 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 31)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 32, note = "Theramore, Dustwallow Marsh" }, -- vol
    { "complete", 1105, at = { 1441, 82.41, 54.63 } }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 31)
    { "complete", 1176, at = { 1441, 87.86, 65.44 } }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 31)
    { "turnin", 1176, xp = 1850 }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 31)
    { "turnin", 1105, xp = 2450 }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 31)
    { "turnin", 1112, xp = 1400 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 31)
    { "accept", 1114 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 31)
    { "turnin", 1114, xp = 700 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 31)
    { "turnin", 1110, xp = 2500 }, -- Rocket Car Parts (lvl 31, ~2500 xp, sim lvl 31)
    { "accept", 1115 }, -- The Rumormonger (lvl 36, ~0 xp, sim lvl 31)
    { "level", 33, at = { 1441, 87.86, 65.44 }, note = "About 444 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1413, 42.9, 90.2, optional = true, dungeon = "Razorfen Kraul", note = "Dungeon: Razorfen Kraul (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "RFK" }, -- déplacement
    { "accept", 1142, optional = true, dungeon = "Razorfen Kraul", note = "Starts inside the dungeon", phase = "run", rung = "RFK" }, -- Mortality Wanes (lvl 30, ~1525 xp, sim lvl 33)
    { "complete", 1142, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Mortality Wanes (lvl 30, ~1525 xp, sim lvl 33)
    { "turnin", 1142, xp = 1525, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Mortality Wanes (lvl 30, ~1525 xp, sim lvl 33)
  },
})
