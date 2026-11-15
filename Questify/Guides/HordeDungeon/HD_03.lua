local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 80 étapes, niveau final 19.11, ~18796 xp/h, 166 min.
Q:RegisterGuide({
  id = "HD_03",
  title = "The Barrens",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 15, maxLevel = 19,
  next = "HD_04",
  sim = { steps = 80, endLevel = 19.11, xpPerHour = 18796, minutes = 166 },
  steps = {
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "accept", 819, at = { 1413, 55.7, 27.3 }, note = "Loot Chen's Empty Keg to start the quest" }, -- Chen's Empty Keg (lvl 15, ~1050 xp, sim lvl 16)
    { "turnin", 819, xp = 1050 }, -- Chen's Empty Keg (lvl 15, ~1050 xp, sim lvl 16)
    { "sethearth", 1413, 62.05, 39.41 }, -- lier la pierre de foyer
    { "accept", 821 }, -- Chen's Empty Keg (lvl 15, ~1350 xp, sim lvl 16)
    { "accept", 896 }, -- Miner's Fortune (lvl 18, ~1700 xp, sim lvl 16)
    { "accept", 898 }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 16)
    { "accept", 884, at = { 1413, 49.4, 59.2 }, note = "Loot Owatanka's Tailspike to start the quest (86.9 % drop: about 2 kills)" }, -- Owatanka (lvl 24, ~1450 xp, sim lvl 16)
    { "accept", 3513, at = { 1413, 46, 70 }, note = "Loot Runed Scroll to start the quest (95.2 % drop: about 2 kills)" }, -- The Runed Scroll (lvl 25, ~2550 xp, sim lvl 16)
    { "accept", 885, at = { 1413, 44.81, 74.93 }, note = "Loot Washte Pawne's Feather to start the quest (90.1 % drop: about 2 kills)" }, -- Washte Pawne (lvl 25, ~1500 xp, sim lvl 16)
    { "accept", 897, at = { 1413, 42, 70 }, note = "Loot Harvester's Head to start the quest (93.6 % drop: about 2 kills)" }, -- The Harvester (lvl 24, ~2400 xp, sim lvl 16)
    { "accept", 878 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 16)
    { "turnin", 897, xp = 2400 }, -- The Harvester (lvl 24, ~2400 xp, sim lvl 16)
    { "turnin", 885, xp = 1500 }, -- Washte Pawne (lvl 25, ~1500 xp, sim lvl 16)
    { "turnin", 884, xp = 1450 }, -- Owatanka (lvl 24, ~1450 xp, sim lvl 16)
    { "accept", 883, at = { 1413, 46.13, 49.28 }, note = "Loot Hoof of Lakota'mani to start the quest (91.7 % drop: about 2 kills)" }, -- Lakota'mani (lvl 22, ~1300 xp, sim lvl 16)
    { "complete", 821, obj = 3, at = { 1413, 47.13, 47.48 } }, -- Chen's Empty Keg (lvl 15, ~1350 xp, sim lvl 16)
    { "accept", 850 }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 16)
    { "accept", 855 }, -- Centaur Bracers (lvl 14, ~1250 xp, sim lvl 16)
    { "turnin", 1061, xp = 315 }, -- The Spirits of Stonetalon (lvl 17, ~315 xp, sim lvl 16)
    { "complete", 850, at = { 1413, 42.8, 23.52 } }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 16)
    { "turnin", 850, xp = 880 }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 16)
    { "accept", 851 }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 16)
    { "complete", 855, at = { 1413, 45.02, 38.54 } }, -- Centaur Bracers (lvl 14, ~1250 xp, sim lvl 16)
    { "complete", 851, at = { 1413, 53.06, 41.74 } }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 17)
    { "accept", 95774 }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 17)
    { "accept", 4921 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 17)
    { "accept", 871 }, -- Disrupt the Attacks (lvl 12, ~545 xp, sim lvl 17)
    { "complete", 821, obj = 1, at = { 1413, 54.85, 30.38 } }, -- Chen's Empty Keg (lvl 15, ~1350 xp, sim lvl 17)
    { "complete", 821, at = { 1413, 56.58, 30.4 } }, -- Chen's Empty Keg (lvl 15, ~1350 xp, sim lvl 17)
    { "complete", 871, at = { 1413, 55.39, 26.7 } }, -- Disrupt the Attacks (lvl 12, ~545 xp, sim lvl 17)
    { "complete", 896, at = { 1413, 61.2, 4.28 } }, -- Miner's Fortune (lvl 18, ~1700 xp, sim lvl 17)
    { "accept", 858 }, -- Ignition (lvl 18, ~1350 xp, sim lvl 17)
    { "complete", 858, at = { 1413, 56.27, 8.58 } }, -- Ignition (lvl 18, ~1350 xp, sim lvl 17)
    { "accept", 78145 }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 17)
    { "complete", 78145, at = { 1413, 56.3, 8.8 } }, -- Arcanic Systems Manual (lvl 20, ~0 xp, sim lvl 17)
    { "turnin", 858, xp = 1350 }, -- Ignition (lvl 18, ~1350 xp, sim lvl 17)
    { "accept", 863 }, -- The Escape (lvl 18, ~1700 xp, sim lvl 17)
    { "complete", 863, at = { 1413, 55.36, 7.68 } }, -- The Escape (lvl 18, ~1700 xp, sim lvl 17)
    { "turnin", 3513, xp = 2550 }, -- The Runed Scroll (lvl 25, ~2550 xp, sim lvl 17)
    { "turnin", 851, xp = 1000 }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 18)
    { "accept", 852 }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 18)
    { "turnin", 855, xp = 1250 }, -- Centaur Bracers (lvl 14, ~1250 xp, sim lvl 18)
    { "complete", 852, at = { 1413, 46.04, 41.14 } }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 18)
    { "complete", 878, obj = 3, at = { 1413, 43.26, 48.08 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "complete", 878, obj = 2, at = { 1413, 45.14, 51.55 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "complete", 878, at = { 1413, 45.69, 54.16 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "turnin", 878, xp = 1650 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "turnin", 883, xp = 1300 }, -- Lakota'mani (lvl 22, ~1300 xp, sim lvl 18)
    { "complete", 95774, at = { 1413, 50.37, 53.6 } }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 18)
    { "complete", 4921, at = { 1413, 49.33, 50.32 } }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 18)
    { "hearth", 1413 }, -- pierre de foyer
    { "complete", 898, at = { 1413, 62.27, 39.09 } }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 18)
    { "turnin", 898, xp = 1950 }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 18)
    { "turnin", 821, xp = 1350 }, -- Chen's Empty Keg (lvl 15, ~1350 xp, sim lvl 18)
    { "turnin", 896, xp = 1700 }, -- Miner's Fortune (lvl 18, ~1700 xp, sim lvl 18)
    { "accept", 1483 }, -- Ziz Fizziks (lvl 21, ~0 xp, sim lvl 18)
    { "turnin", 863, xp = 1700 }, -- The Escape (lvl 18, ~1700 xp, sim lvl 18)
    { "accept", 79097 }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 18)
    { "complete", 79097, at = { 1413, 62.7, 36.3 } }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 18)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 95774, xp = 1550 }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 18)
    { "turnin", 4921, xp = 1150 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 18)
    { "turnin", 871, xp = 545 }, -- Disrupt the Attacks (lvl 12, ~545 xp, sim lvl 19)
    { "accept", 78143 }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 19)
    { "complete", 78143, at = { 1413, 49.3, 32.88 } }, -- Secrets of the Dreamers (lvl 20, ~0 xp, sim lvl 19)
    { "turnin", 852, xp = 1100 }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 19)
    { "goto", 1413, 46, 36.5, optional = true, dungeon = "Wailing Caverns", note = "Dungeon: Wailing Caverns (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "WC" }, -- déplacement
    { "complete", 959, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~675 xp, sim lvl 19)
    { "complete", 1486, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Hides (lvl 17, ~800 xp, sim lvl 19)
    { "complete", 1487, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Eradication (lvl 21, ~1025 xp, sim lvl 19)
    { "turnin", 959, xp = 675, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~675 xp, sim lvl 19)
    { "turnin", 1486, xp = 800, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Hides (lvl 17, ~800 xp, sim lvl 19)
    { "turnin", 1487, xp = 1025, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Eradication (lvl 21, ~1025 xp, sim lvl 19)
    { "turnin", 1489, xp = 145, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Hamuul Runetotem (lvl 16, ~145 xp, sim lvl 19)
    { "accept", 6981, optional = true, dungeon = "Wailing Caverns", note = "Starts inside the dungeon", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 19)
    { "complete", 6981, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 19)
    { "turnin", 6981, xp = 1325, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 19)
  },
})
