local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 90 étapes, niveau final 39.13, ~45649 xp/h, 121 min.
Q:RegisterGuide({
  id = "HD_14",
  title = "Arathi Highlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 38, maxLevel = 39,
  next = "HD_15",
  sim = { steps = 90, endLevel = 39.13, xpPerHour = 45649, minutes = 121 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "boat", 1434, 31.54, 29.36, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 17, note = "Hammerfall, Arathi" }, -- vol
    { "turnin", 6522, xp = 1750, optional = true, dungeon = "Razorfen Downs", phase = "run", rung = "RFD" }, -- An Unholy Alliance (lvl 36, ~1750 xp, sim lvl 38)
    { "accept", 677 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 638, xp = 710 }, -- Trollbane (lvl 37, ~710 xp, sim lvl 38)
    { "sethearth", 1417, 73.84, 32.46 }, -- lier la pierre de foyer
    { "complete", 677, at = { 1417, 62.26, 71.04 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79678 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 79677 }, -- A Quick Grocery Run (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 79678, xp = 3150 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 677, at = { 1417, 68.8, 76.69 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 79974, xp = 2040 }, -- Wet Job (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79975 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 79242, xp = 3900 }, -- No Honor Among Thieves (lvl 40, ~3900 xp, sim lvl 38)
    { "accept", 701 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "accept", 95143 }, -- Finding Tan'jani (lvl 38, ~0 xp, sim lvl 38)
    { "turnin", 677, xp = 2040 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 678 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "goto", 1417, 73.02, 32.7, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 13, note = "Tarren Mill, Hillsbrad" }, -- vol
    { "complete", 79677, obj = 1, at = { 1424, 84.07, 32.51 } }, -- A Quick Grocery Run (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 96781, classes = { "ROGUE" } }, -- What's the Big Idea? (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 96783, classes = { "ROGUE" } }, -- A Way In (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 503 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 566 }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "accept", 495 }, -- The Crown of Will (lvl 39, ~300 xp, sim lvl 38)
    { "accept", 6521, optional = true, dungeon = "Razorfen Downs", phase = "prep", rung = "RFD" }, -- An Unholy Alliance (lvl 36, ~0 xp, sim lvl 38)
    { "accept", 1048, optional = true, dungeon = "Scarlet Monastery", phase = "prep", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~0 xp, sim lvl 38)
    { "accept", 2342, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Reclaimed Treasures (lvl 43, ~0 xp, sim lvl 38)
    { "turnin", 79952, xp = 2750 }, -- RwlRwlRwlRwl! (lvl 35, ~2750 xp, sim lvl 38)
    { "accept", 79536 }, -- Greater Friend of the Library (lvl 35, ~1350 xp, sim lvl 38)
    { "turnin", 79536, xp = 1350 }, -- Greater Friend of the Library (lvl 35, ~1350 xp, sim lvl 38)
    { "turnin", 79535, xp = 2750 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~2750 xp, sim lvl 38)
    { "accept", 3341, optional = true, dungeon = "Razorfen Downs", phase = "prep", rung = "RFD" }, -- Bring the End (lvl 42, ~0 xp, sim lvl 38)
    { "complete", 566, at = { 1416, 57.04, 28.25 } }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 503, at = { 1416, 61.9, 42.38 } }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 95534, at = { 1416, 61.77, 43.22 }, note = "Loot Singed Note to start the quest (20.0 % drop: about 5 kills)" }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 38)
    { "complete", 96781, at = { 1416, 62.51, 45.3 }, classes = { "ROGUE" } }, -- What's the Big Idea? (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 503, xp = 2800 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 506 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "turnin", 495, xp = 300 }, -- The Crown of Will (lvl 39, ~300 xp, sim lvl 38)
    { "accept", 518 }, -- The Crown of Will (lvl 39, ~2250 xp, sim lvl 38)
    { "turnin", 566, xp = 3150 }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 506, xp = 2100 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "turnin", 95534, xp = 2800 }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 96781, xp = 2800, classes = { "ROGUE" } }, -- What's the Big Idea? (lvl 36, ~2800 xp, sim lvl 38)
    { "complete", 518, at = { 1416, 43.63, 47.43 } }, -- The Crown of Will (lvl 39, ~2250 xp, sim lvl 38)
    { "turnin", 518, xp = 2250 }, -- The Crown of Will (lvl 39, ~2250 xp, sim lvl 38)
    { "turnin", 79975, xp = 2040 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79976 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "turnin", 79976, xp = 1560 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "turnin", 96783, xp = 2800, classes = { "ROGUE" } }, -- A Way In (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 96784, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 663 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "turnin", 663, xp = 690 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "turnin", 96784, xp = 2800, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 662 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 664 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 665 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 665, at = { 1417, 33.87, 80.6 } }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 665, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 666 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 662, at = { 1417, 23.05, 84.51 } }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 79677, at = { 1417, 21.3, 84 } }, -- A Quick Grocery Run (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 666, at = { 1417, 23.62, 88.25 } }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 664, at = { 1417, 23.27, 87.78 } }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 662, xp = 3150 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 666, xp = 3900 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "turnin", 664, xp = 3150 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 668 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "turnin", 668, xp = 1550 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "complete", 701, at = { 1417, 51.72, 66.78 } }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "complete", 678, at = { 1417, 53.46, 75.05 } }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 79677, xp = 3150 }, -- A Quick Grocery Run (lvl 40, ~3150 xp, sim lvl 38)
    { "hearth", 1417 }, -- pierre de foyer
    { "turnin", 701, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 39)
    { "accept", 702 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 39)
    { "turnin", 678, xp = 2850 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 39)
    { "turnin", 702, xp = 285 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 39)
    { "accept", 847 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 39)
    { "turnin", 847, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 39)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Armory (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_ARM" }, -- déplacement
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Cathedral (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_CATH" }, -- déplacement
    { "complete", 1048, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~2575 xp, sim lvl 39)
    { "turnin", 1048, xp = 2575, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_CATH" }, -- Into The Scarlet Monastery (lvl 42, ~2575 xp, sim lvl 39)
  },
})
