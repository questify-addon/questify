local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 68 étapes, niveau final 39.11, ~29956 xp/h, 169 min.
Q:RegisterGuide({
  id = "HD_14",
  title = "Arathi Highlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 38, maxLevel = 39,
  next = "HD_15",
  sim = { steps = 68, endLevel = 39.11, xpPerHour = 29956, minutes = 169 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "boat", 1434, 31.54, 29.36, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 17, note = "Hammerfall, Arathi" }, -- vol
    { "turnin", 6522, at = { 1458, 56.25, 92.2 }, xp = 1750, optional = true, dungeon = "Razorfen Downs", phase = "run", rung = "RFD" }, -- An Unholy Alliance (lvl 36, ~1750 xp, sim lvl 38)
    { "accept", 677 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 638, xp = 710 }, -- Trollbane (lvl 37, ~710 xp, sim lvl 38)
    { "sethearth", 1417, 73.84, 32.46 }, -- lier la pierre de foyer
    { "complete", 677, at = { 1417, 62.26, 71.04 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "complete", 677, at = { 1417, 68.8, 76.69 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 701 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 677, xp = 2040 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 678 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "complete", 701, at = { 1417, 51.72, 66.78 } }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "complete", 678, at = { 1417, 53.46, 75.05 } }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 701, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "accept", 702 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 38)
    { "turnin", 678, xp = 2850 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 702, xp = 285 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 38)
    { "accept", 847 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 847, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 79974, xp = 2040 }, -- Wet Job (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79975 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "hearth", 1417 }, -- pierre de foyer
    { "accept", 663 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "turnin", 663, xp = 690 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "accept", 664 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 665 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 665, at = { 1417, 33.87, 80.6 } }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 665, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 666 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 666, at = { 1417, 23.62, 88.25 } }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 664, at = { 1417, 23.27, 87.78 } }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 666, xp = 3900 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "accept", 668 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "turnin", 664, xp = 3150 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 668, xp = 1550 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "turnin", 79975, xp = 2040 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79976 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "turnin", 79976, xp = 1560 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "accept", 533 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 38)
    { "accept", 541 }, -- Battle of Hillsbrad (lvl 30, ~980 xp, sim lvl 38)
    { "complete", 533, at = { 1416, 58.3, 67.96 } }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 38)
    { "turnin", 533, xp = 2700 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 38)
    { "accept", 503 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "complete", 503, at = { 1416, 61.9, 42.38 } }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 503, xp = 2800 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 506 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "turnin", 506, xp = 2100 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "complete", 541, at = { 1424, 71.28, 79.49 } }, -- Battle of Hillsbrad (lvl 30, ~980 xp, sim lvl 38)
    { "turnin", 541, xp = 980 }, -- Battle of Hillsbrad (lvl 30, ~980 xp, sim lvl 38)
    { "accept", 550 }, -- Battle of Hillsbrad (lvl 32, ~1530 xp, sim lvl 39)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "accept", 1048, optional = true, dungeon = "Scarlet Monastery", phase = "prep", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~0 xp, sim lvl 39)
    { "accept", 6521, optional = true, dungeon = "Razorfen Downs", phase = "prep", rung = "RFD" }, -- An Unholy Alliance (lvl 36, ~0 xp, sim lvl 39)
    { "turnin", 550, xp = 1530 }, -- Battle of Hillsbrad (lvl 32, ~1530 xp, sim lvl 39)
    { "accept", 2342, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Reclaimed Treasures (lvl 43, ~0 xp, sim lvl 39)
    { "accept", 79536 }, -- Greater Friend of the Library (lvl 35, ~1350 xp, sim lvl 39)
    { "turnin", 79535, xp = 2750 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~2750 xp, sim lvl 39)
    { "turnin", 79536, xp = 1350 }, -- Greater Friend of the Library (lvl 35, ~1350 xp, sim lvl 39)
    { "turnin", 79952, xp = 2750 }, -- RwlRwlRwlRwl! (lvl 35, ~2750 xp, sim lvl 39)
    { "accept", 3341, optional = true, dungeon = "Razorfen Downs", phase = "prep", rung = "RFD" }, -- Bring the End (lvl 42, ~0 xp, sim lvl 39)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Armory (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_ARM" }, -- déplacement
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Cathedral (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_CATH" }, -- déplacement
    { "complete", 1048, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~2575 xp, sim lvl 39)
    { "turnin", 1048, at = { 1458, 56.25, 92.2 }, xp = 2575, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~2575 xp, sim lvl 39)
  },
})
