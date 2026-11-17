local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 140 étapes, niveau final 18.44, ~19139 xp/h, 254 min.
Q:RegisterGuide({
  id = "H_01",
  title = "The Barrens",
  faction = "Horde",
  minLevel = 12, maxLevel = 17,
  next = "H_02",
  sim = { steps = 140, endLevel = 18.44, xpPerHour = 19139, minutes = 254 },
  steps = {
    { "accept", 842, race = { "Orc", "Troll" } }, -- Crossroads Conscription (lvl 12, ~910 xp, sim lvl 12)
    { "fp", 1413, 63.08, 37.16 }, -- point de vol
    { "accept", 887 }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 12)
    { "accept", 97253 }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 12)
    { "accept", 894 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 12)
    { "accept", 895 }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 12)
    { "fp", 1413, 51.5, 30.34 }, -- point de vol
    { "accept", 870 }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 12)
    { "accept", 867 }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 12)
    { "sethearth", 1413, 51.99, 29.89 }, -- lier la pierre de foyer
    { "accept", 848 }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 12)
    { "accept", 1492 }, -- Wharfmaster Dizzywig (lvl 11, ~350 xp, sim lvl 12)
    { "complete", 867, at = { 1413, 40.78, 15.56 } }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 12)
    { "complete", 870, at = { 1413, 45.06, 22.53 } }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 13)
    { "complete", 848, at = { 1413, 45.11, 22.66 } }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 867, xp = 1050 }, -- Harpy Raiders (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 875 }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 13)
    { "turnin", 848, xp = 1050 }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 844 }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 842, xp = 910, race = { "Orc", "Troll" } }, -- Crossroads Conscription (lvl 12, ~910 xp, sim lvl 13)
    { "complete", 844, at = { 1413, 57.05, 31.02 } }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 844, xp = 910 }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 845 }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 13)
    { "turnin", 870, xp = 680 }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 13)
    { "accept", 877 }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 13)
    { "complete", 845, at = { 1413, 49.16, 37.48 } }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 13)
    { "accept", 850 }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 14)
    { "complete", 850, at = { 1413, 42.8, 23.52 } }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 14)
    { "complete", 875, at = { 1413, 38.72, 14.4 } }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 14)
    { "turnin", 850, xp = 880 }, -- Kolkar Leaders (lvl 16, ~880 xp, sim lvl 14)
    { "accept", 851 }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 14)
    { "turnin", 875, xp = 1150 }, -- Harpy Lieutenants (lvl 16, ~1150 xp, sim lvl 14)
    { "accept", 876 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 14)
    { "accept", 4921 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 14)
    { "turnin", 845, xp = 910 }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 14)
    { "accept", 903 }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 14)
    { "accept", 869 }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 14)
    { "accept", 6361, race = { "Tauren" } }, -- A Bundle of Hides (lvl 10, ~0 xp, sim lvl 14)
    { "accept", 95507 }, -- Vrang's Game (lvl 18, ~1000 xp, sim lvl 14)
    { "accept", 95494 }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 14)
    { "level", 15, at = { 1413, 40.91, 19.75 }, note = "About 46 mobs here (Witchwing Roguefeather, level 15)" }, -- farm de niveau
    { "complete", 95494, at = { 1413, 43.81, 15.82 } }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 15)
    { "turnin", 894, xp = 740 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 15)
    { "accept", 900 }, -- Samophlange (lvl 14, ~490 xp, sim lvl 15)
    { "complete", 900, at = { 1413, 52.33, 11.56 } }, -- Samophlange (lvl 14, ~490 xp, sim lvl 15)
    { "turnin", 900, xp = 490 }, -- Samophlange (lvl 14, ~490 xp, sim lvl 15)
    { "accept", 901 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 15)
    { "complete", 901, at = { 1413, 52.84, 10.39 } }, -- Samophlange (lvl 14, ~740 xp, sim lvl 15)
    { "turnin", 901, xp = 740 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 15)
    { "accept", 902 }, -- Samophlange (lvl 16, ~1150 xp, sim lvl 15)
    { "accept", 858 }, -- Ignition (lvl 18, ~1350 xp, sim lvl 15)
    { "complete", 95507, at = { 1413, 47, 12.75 } }, -- Vrang's Game (lvl 18, ~1000 xp, sim lvl 15)
    { "turnin", 95494, xp = 1350 }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 15)
    { "turnin", 95507, xp = 1000 }, -- Vrang's Game (lvl 18, ~1000 xp, sim lvl 15)
    { "accept", 95495 }, -- The Hermit Tanner (lvl 18, ~135 xp, sim lvl 15)
    { "turnin", 95495, xp = 135 }, -- The Hermit Tanner (lvl 18, ~135 xp, sim lvl 15)
    { "accept", 95621 }, -- Trouble in the Valley (lvl 18, ~1000 xp, sim lvl 15)
    { "complete", 903, at = { 1413, 43.14, 33.95 } }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 15)
    { "accept", 883, at = { 1413, 46.13, 49.28 }, note = "Loot Hoof of Lakota'mani to start the quest (91.7 % drop: about 2 kills)" }, -- Lakota'mani (lvl 22, ~1300 xp, sim lvl 15)
    { "fp", 1413, 44.45, 59.15 }, -- point de vol
    { "accept", 878 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 15)
    { "turnin", 883, xp = 1300 }, -- Lakota'mani (lvl 22, ~1300 xp, sim lvl 15)
    { "accept", 898 }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 15)
    { "complete", 895, at = { 1413, 62.95, 49.4 } }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 15)
    { "complete", 887, at = { 1413, 64.02, 44.58 } }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 15)
    { "complete", 869, at = { 1413, 59.36, 45.7 } }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 15)
    { "complete", 877, at = { 1413, 55.61, 42.75 } }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 15)
    { "level", 16, at = { 1413, 55.77, 42.25 }, note = "About 4 mobs here (Oasis Snapjaw, level 15)" }, -- farm de niveau
    { "complete", 851, at = { 1413, 53.06, 41.74 } }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 16)
    { "complete", 95621, at = { 1413, 41.8, 15.76 } }, -- Trouble in the Valley (lvl 18, ~1000 xp, sim lvl 16)
    { "turnin", 95621, xp = 1000 }, -- Trouble in the Valley (lvl 18, ~1000 xp, sim lvl 16)
    { "accept", 95508 }, -- Unwelcome Guests (lvl 18, ~1350 xp, sim lvl 16)
    { "complete", 858, at = { 1413, 56.27, 8.58 } }, -- Ignition (lvl 18, ~1350 xp, sim lvl 16)
    { "turnin", 858, xp = 1350 }, -- Ignition (lvl 18, ~1350 xp, sim lvl 16)
    { "accept", 863 }, -- The Escape (lvl 18, ~1700 xp, sim lvl 16)
    { "complete", 863, at = { 1413, 55.36, 7.68 } }, -- The Escape (lvl 18, ~1700 xp, sim lvl 16)
    { "hearth", 1413 }, -- pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "turnin", 863, xp = 1700 }, -- The Escape (lvl 18, ~1700 xp, sim lvl 16)
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 877, xp = 1150 }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 16)
    { "accept", 880 }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 16)
    { "turnin", 903, xp = 1050 }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 16)
    { "accept", 881 }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 16)
    { "turnin", 869, xp = 910 }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 16)
    { "turnin", 6361, xp = 165, race = { "Tauren" } }, -- A Bundle of Hides (lvl 10, ~165 xp, sim lvl 16)
    { "accept", 6365, race = { "Orc", "Troll" } }, -- Meats to Orgrimmar (lvl 10, ~165 xp, sim lvl 16)
    { "complete", 881, at = { 1413, 55.86, 17.19 } }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 16)
    { "turnin", 6365, xp = 165, race = { "Orc", "Troll" } }, -- Meats to Orgrimmar (lvl 10, ~165 xp, sim lvl 16)
    { "turnin", 881, xp = 1450 }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 16)
    { "turnin", 851, xp = 1000 }, -- Verog the Dervish (lvl 18, ~1000 xp, sim lvl 16)
    { "accept", 852 }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 16)
    { "level", 17, at = { 1413, 46.41, 39.58 }, note = "About 50 mobs here (Oasis Snapjaw, level 15)" }, -- farm de niveau
    { "complete", 852, at = { 1413, 46.04, 41.14 } }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 17)
    { "complete", 95508, at = { 1413, 41.89, 11.4 } }, -- Unwelcome Guests (lvl 18, ~1350 xp, sim lvl 17)
    { "turnin", 95508, xp = 1350 }, -- Unwelcome Guests (lvl 18, ~1350 xp, sim lvl 17)
    { "complete", 4921, at = { 1413, 49.33, 50.32 } }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 17)
    { "turnin", 4921, xp = 1150 }, -- Lost in Battle (lvl 20, ~1150 xp, sim lvl 17)
    { "accept", 95774 }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 17)
    { "complete", 95774, at = { 1413, 49.37, 50.84 } }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 17)
    { "turnin", 95774, xp = 1550 }, -- Her Name Is Olgra (lvl 20, ~1550 xp, sim lvl 17)
    { "complete", 880, at = { 1413, 46.73, 39.63 } }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 17)
    { "accept", 1487, optional = true, dungeon = "Wailing Caverns" }, -- Deviate Eradication (lvl 21, ~0 xp, sim lvl 17)
    { "accept", 1486, optional = true, dungeon = "Wailing Caverns" }, -- Deviate Hides (lvl 17, ~0 xp, sim lvl 17)
    { "turnin", 852, xp = 1100 }, -- Hezrul Bloodmark (lvl 19, ~1100 xp, sim lvl 17)
    { "accept", 4021 }, -- Counterattack! (lvl 20, ~1950 xp, sim lvl 17)
    { "complete", 4021, at = { 1413, 44.53, 28.15 } }, -- Counterattack! (lvl 20, ~1950 xp, sim lvl 17)
    { "turnin", 4021, xp = 1950 }, -- Counterattack! (lvl 20, ~1950 xp, sim lvl 17)
    { "turnin", 880, xp = 1150 }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 17)
    { "accept", 1489, optional = true, dungeon = "Wailing Caverns" }, -- Hamuul Runetotem (lvl 16, ~0 xp, sim lvl 17)
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "turnin", 887, xp = 740 }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 17)
    { "accept", 890 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 17)
    { "turnin", 895, xp = 1150 }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 17)
    { "turnin", 902, xp = 1150 }, -- Samophlange (lvl 16, ~1150 xp, sim lvl 17)
    { "accept", 959, optional = true, dungeon = "Wailing Caverns" }, -- Trouble at the Docks (lvl 18, ~0 xp, sim lvl 17)
    { "turnin", 1492, xp = 350 }, -- Wharfmaster Dizzywig (lvl 11, ~350 xp, sim lvl 17)
    { "turnin", 890, xp = 100 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 17)
    { "accept", 892 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 17)
    { "turnin", 892, xp = 100 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 17)
    { "accept", 888 }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 17)
    { "complete", 898, at = { 1413, 62.27, 39.09 } }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 17)
    { "turnin", 898, xp = 1950 }, -- Free From the Hold (lvl 20, ~1950 xp, sim lvl 17)
    { "complete", 97253, at = { 1413, 61.8, 45.13 } }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 17)
    { "complete", 888, at = { 1413, 62.63, 49.63 } }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 17)
    { "turnin", 97253, xp = 1050 }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 17)
    { "turnin", 888, xp = 1150 }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 17)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "complete", 878, obj = 3, at = { 1413, 43.26, 48.08 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "complete", 878, obj = 2, at = { 1413, 45.14, 51.55 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "complete", 878, at = { 1413, 45.69, 54.16 } }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "turnin", 878, xp = 1650 }, -- Tribes at War (lvl 21, ~1650 xp, sim lvl 18)
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "complete", 876, at = { 1413, 39.16, 12.17 } }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 18)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 876, xp = 1950 }, -- Serena Bloodfeather (lvl 20, ~1950 xp, sim lvl 18)
    { "accept", 1060 }, -- Letter to Jin'Zil (lvl 20, ~0 xp, sim lvl 18)
  },
})
