local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 43 étapes, niveau final 33.00, ~7853 xp/h, 64 min.
Q:RegisterGuide({
  id = "HD_10",
  title = "Thousand Needles",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 31, maxLevel = 33,
  next = "HD_11",
  sim = { steps = 43, endLevel = 33.00, xpPerHour = 7853, minutes = 64 },
  steps = {
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul" },
    { "note", "Not running Wailing Caverns? Abandon Smart Drinks", optional = true, dungeon = "Wailing Caverns" },
    { "goto", 1417, 73.02, 32.7, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1441, node = 30, note = "Freewind Post, Thousand Needles" }, -- vol
    { "accept", 5361 }, -- Family Tree (lvl 35, ~0 xp, sim lvl 32)
    { "sethearth", 1441, 46.07, 51.52 }, -- lier la pierre de foyer
    { "accept", 1111 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 32)
    { "goto", 1441, 45.14, 49.11, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "turnin", 1111, xp = 1400 }, -- Wharfmaster Dizzywig (lvl 36, ~1400 xp, sim lvl 32)
    { "accept", 1112 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 32)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "accept", 2841, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Rig Wars (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 2842, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Chief Engineer Scooty (lvl 35, ~0 xp, sim lvl 32)
    { "accept", 1431 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 1531, classes = { "SHAMAN" } }, -- Call of Air (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 2996, classes = { "WARLOCK" } }, -- Seeking Strahad (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 4737, classes = { "WARLOCK" } }, -- In Search of Menara Voidrender (lvl 31, ~630 xp, sim lvl 32)
    { "turnin", 1431, xp = 610 }, -- Alliance Relations (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 1432 }, -- Alliance Relations (lvl 30, ~0 xp, sim lvl 32)
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 1361, xp = 640 }, -- Regthar Deathgate (lvl 32, ~640 xp, sim lvl 32)
    { "turnin", 2996, xp = 610, classes = { "WARLOCK" } }, -- Seeking Strahad (lvl 30, ~610 xp, sim lvl 32)
    { "turnin", 4737, xp = 630, classes = { "WARLOCK" } }, -- In Search of Menara Voidrender (lvl 31, ~630 xp, sim lvl 32)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "accept", 79007 }, -- ... and that note you found (lvl 22, ~0 xp, sim lvl 32)
    { "hearth", 1441 }, -- pierre de foyer
    { "turnin", 1112, xp = 1400 }, -- Parts for Kravel (lvl 36, ~1400 xp, sim lvl 32)
    { "turnin", 1531, xp = 2450, classes = { "SHAMAN" } }, -- Call of Air (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 1114 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 32)
    { "turnin", 1114, xp = 700 }, -- Delivery to the Gnomes (lvl 36, ~700 xp, sim lvl 32)
    { "accept", 1115 }, -- The Rumormonger (lvl 36, ~0 xp, sim lvl 32)
    { "level", 33, note = "About 18 more mobs" }, -- farm de niveau
    { "goto", 1413, 42.9, 90.2, optional = true, dungeon = "Razorfen Kraul", note = "Dungeon: Razorfen Kraul (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "RFK" }, -- déplacement
    { "accept", 1144, optional = true, dungeon = "Razorfen Kraul", note = "Starts inside the dungeon", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
    { "complete", 1144, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
    { "turnin", 1144, xp = 1525, optional = true, dungeon = "Razorfen Kraul", phase = "run", rung = "RFK" }, -- Willix the Importer (lvl 30, ~1525 xp, sim lvl 33)
  },
})
