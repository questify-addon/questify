local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 91 étapes, niveau final 33.00, ~28956 xp/h, 161 min.
Q:RegisterGuide({
  id = "HD_10",
  title = "Thousand Needles",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 31, maxLevel = 33,
  next = "HD_11",
  sim = { steps = 91, endLevel = 33.00, xpPerHour = 28956, minutes = 161 },
  steps = {
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul" },
    { "note", "Not running Wailing Caverns? Abandon Smart Drinks", optional = true, dungeon = "Wailing Caverns" },
    { "goto", 1417, 73.02, 32.7, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1441, node = 30, note = "Freewind Post, Thousand Needles" }, -- vol
    { "accept", 5147 }, -- WANTED: Arnak Grimtotem (lvl 29, ~2350 xp, sim lvl 31)
    { "accept", 98070 }, -- Stop the Screeching (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1150 }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 31)
    { "complete", 98070, at = { 1441, 27.67, 49.38 } }, -- Stop the Screeching (lvl 30, ~2450 xp, sim lvl 31)
    { "complete", 1150, at = { 1441, 26.35, 55.55 } }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1111 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 31)
    { "accept", 5762 }, -- Hemet Nesingwary (lvl 31, ~0 xp, sim lvl 31)
    { "accept", 1105 }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1176 }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 31)
    { "accept", 1175 }, -- A Bump in the Road (lvl 33, ~2650 xp, sim lvl 31)
    { "complete", 1176, at = { 1441, 87.86, 65.44 } }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 31)
    { "complete", 1105, at = { 1441, 82.41, 54.63 } }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 31)
    { "complete", 1175, obj = 1, at = { 1441, 75.74, 58.39 } }, -- A Bump in the Road (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 1150, xp = 2450 }, -- Test of Endurance (lvl 30, ~2450 xp, sim lvl 31)
    { "accept", 1151 }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 31)
    { "complete", 5147, at = { 1441, 38.11, 26.87 } }, -- WANTED: Arnak Grimtotem (lvl 29, ~2350 xp, sim lvl 31)
    { "accept", 5151 }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 31)
    { "complete", 5151, at = { 1441, 22.76, 24.62 } }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 31)
    { "turnin", 5151, xp = 3050 }, -- Hypercapacitor Gizmo (lvl 30, ~3050 xp, sim lvl 31)
    { "complete", 1151, at = { 1441, 17.1, 38.1 } }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 31)
    { "goto", 1441, 45.14, 49.11, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "accept", 1145 }, -- The Swarm Grows (lvl 33, ~1300 xp, sim lvl 31)
    { "sethearth", 1413, 51.99, 29.89 }, -- lier la pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "turnin", 1145, xp = 1300 }, -- The Swarm Grows (lvl 33, ~1300 xp, sim lvl 31)
    { "accept", 1718, classes = { "WARRIOR" } }, -- The Islander (lvl 30, ~610 xp, sim lvl 31)
    { "accept", 1146 }, -- The Swarm Grows (lvl 33, ~1950 xp, sim lvl 31)
    { "hearth", 1413 }, -- pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "turnin", 1111, xp = 1400 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 31)
    { "turnin", 1718, xp = 610, classes = { "WARRIOR" } }, -- The Islander (lvl 30, ~610 xp, sim lvl 31)
    { "accept", 1112 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 31)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1441, node = 30, note = "Freewind Post, Thousand Needles" }, -- vol
    { "turnin", 1146, xp = 1950 }, -- The Swarm Grows (lvl 33, ~1950 xp, sim lvl 31)
    { "accept", 1147 }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 1147, at = { 1441, 67.73, 82.45 } }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 1147, at = { 1441, 64.99, 85.97 } }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "accept", 1148, at = { 1441, 70.08, 85.09 }, note = "Loot Cracked Silithid Carapace to start the quest (7.3 % drop: about 14 kills)" }, -- Parts of the Swarm (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 1148, at = { 1441, 69.98, 85.21 } }, -- Parts of the Swarm (lvl 35, ~2750 xp, sim lvl 32)
    { "complete", 1175, at = { 1441, 78.44, 87.69 } }, -- A Bump in the Road (lvl 33, ~2650 xp, sim lvl 32)
    { "turnin", 1175, xp = 2650 }, -- A Bump in the Road (lvl 33, ~2650 xp, sim lvl 32)
    { "turnin", 1176, xp = 1850 }, -- Load Lightening (lvl 30, ~1850 xp, sim lvl 32)
    { "turnin", 1105, xp = 2450 }, -- Hardened Shells (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 1112, xp = 1400 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 32)
    { "accept", 1114 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 32)
    { "turnin", 1114, xp = 700 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 32)
    { "accept", 1115 }, -- The Rumormonger (lvl 36, ~0 xp, sim lvl 32)
    { "turnin", 1147, xp = 2750 }, -- The Swarm Grows (lvl 35, ~2750 xp, sim lvl 32)
    { "turnin", 98070, xp = 2450 }, -- Stop the Screeching (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 5147, xp = 2350 }, -- WANTED: Arnak Grimtotem (lvl 29, ~2350 xp, sim lvl 32)
    { "accept", 5361 }, -- Family Tree (lvl 35, ~0 xp, sim lvl 32)
    { "turnin", 1151, xp = 3050 }, -- Test of Strength (lvl 30, ~3050 xp, sim lvl 32)
    { "goto", 1441, 45.14, 49.11, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 1148, xp = 2750 }, -- Parts of the Swarm (lvl 35, ~2750 xp, sim lvl 32)
    { "accept", 1184 }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "turnin", 1184, xp = 1350 }, -- Parts of the Swarm (lvl 35, ~1350 xp, sim lvl 32)
    { "accept", 2841, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Rig Wars (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 2842, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Chief Engineer Scooty (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 1431 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 1531, classes = { "SHAMAN" } }, -- Call of Air (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 2996, classes = { "WARLOCK" } }, -- Seeking Strahad (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 4737, classes = { "WARLOCK" } }, -- In Search of Menara Voidrender (lvl 31, ~630 xp, sim lvl 32)
    { "turnin", 1431, xp = 610 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 1432 }, -- Alliance Relations (lvl 30, ~0 xp, sim lvl 32)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 1361, xp = 640 }, -- Regthar Deathgate (lvl 32, ~640 xp, sim lvl 32)
    { "turnin", 2996, xp = 610, classes = { "WARLOCK" } }, -- Seeking Strahad (lvl 30, ~610 xp, sim lvl 32)
    { "turnin", 4737, xp = 630, classes = { "WARLOCK" } }, -- In Search of Menara Voidrender (lvl 31, ~630 xp, sim lvl 32)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 55, note = "Brackenwall Village, Dustwallow Marsh" }, -- vol
    { "accept", 79007 }, -- ... and that note you found (lvl 22, ~0 xp, sim lvl 32)
    { "level", 33, at = { 1441, 78.44, 87.69 }, note = "About 19 more mobs near the last objective" }, -- farm de niveau
    { "turnin", 1531, xp = 2450, classes = { "SHAMAN" } }, -- Call of Air (lvl 30, ~2450 xp, sim lvl 33)
    { "goto", 1413, 42.9, 90.2, optional = true, dungeon = "Razorfen Kraul", note = "Dungeon: Razorfen Kraul (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "RFK" }, -- déplacement
    { "accept", 1144, optional = true, dungeon = "Razorfen Kraul", note = "Starts inside the dungeon", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
    { "complete", 1144, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
    { "turnin", 1144, xp = 1525, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
  },
})
