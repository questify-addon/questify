local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-10.
-- Simulation : 52 étapes, niveau final 33.05, ~24035 xp/h, 112 min.
Q:RegisterGuide({
  id = "H_07",
  title = "Thousand Needles",
  faction = "Horde",
  minLevel = 32, maxLevel = 33,
  next = "H_08",
  sim = { steps = 52, endLevel = 33.05, xpPerHour = 24035, minutes = 112 },
  steps = {
    { "note", "Not running Blackfathom Deeps? Abandon Amongst the Ruins", optional = true, dungeon = "Blackfathom Deeps" },
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1441, node = 30, note = "Freewind Post, Thousand Needles" }, -- vol
    { "accept", 1150 }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 5361 }, -- Family Tree (lvl 35, ~2050 xp, sim lvl 32)
    { "complete", 1150, at = { 1441, 26.35, 55.55 } }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 1150, xp = 2450 }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 1151 }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 32)
    { "complete", 1151, at = { 1441, 17.1, 38.1 } }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 32)
    { "accept", 5151 }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 32)
    { "complete", 5151, at = { 1441, 22.76, 24.62 } }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 32)
    { "turnin", 5151, xp = 3050 }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 32)
    { "accept", 79007 }, -- ... and that note you found (lvl 22, ~0 xp, sim lvl 32)
    { "goto", 1413, 44.45, 59.15, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "accept", 1145 }, -- The Swarm Grows (lvl 33, ~1300 xp, sim lvl 32)
    { "sethearth", 1413, 51.99, 29.89 }, -- lier la pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "turnin", 1145, xp = 1300 }, -- The Swarm Grows (lvl 33, ~1300 xp, sim lvl 32)
    { "accept", 1146 }, -- The Swarm Grows (lvl 33, ~1950 xp, sim lvl 32)
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1441, node = 30, note = "Freewind Post, Thousand Needles" }, -- vol
    { "turnin", 1146, xp = 1950 }, -- The Swarm Grows (lvl 33, ~1950 xp, sim lvl 32)
    { "accept", 1147 }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "accept", 5762 }, -- Hemet Nesingwary (lvl 31, ~0 xp, sim lvl 32)
    { "accept", 1148, at = { 1441, 70.08, 85.09 }, note = "Loot Cracked Silithid Carapace to start the quest (7.3 % drop: about 14 kills)" }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "complete", 1148, at = { 1441, 69.98, 85.21 } }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "complete", 1147, obj = 3, at = { 1441, 64.99, 85.97 } }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 1147, at = { 1441, 67.73, 82.45 } }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 1147, xp = 2750 }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 1151, xp = 3050 }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 32)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 1148, xp = 1350 }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "accept", 1184 }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "turnin", 1184, xp = 1350 }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "accept", 2841, optional = true, dungeon = "Gnomeregan" }, -- Rig Wars (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 2842, optional = true, dungeon = "Gnomeregan" }, -- Chief Engineer Scooty (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 1431 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "turnin", 1431, xp = 610 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 1432 }, -- Alliance Relations (lvl 30, ~1200 xp, sim lvl 32)
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 1361, xp = 640 }, -- Regthar Deathgate (lvl 32, ~640 xp, sim lvl 32)
    { "accept", 1362 }, -- The Kolkar of Desolace (lvl 32, ~640 xp, sim lvl 32)
    { "fp", 1456, 47, 49.83 }, -- point de vol
    { "turnin", 1362, xp = 640 }, -- The Kolkar of Desolace (lvl 32, ~640 xp, sim lvl 32)
    { "turnin", 5361, xp = 2050 }, -- Family Tree (lvl 35, ~2050 xp, sim lvl 32)
    { "turnin", 1432, xp = 1200 }, -- Alliance Relations (lvl 30, ~1200 xp, sim lvl 33)
  },
})
