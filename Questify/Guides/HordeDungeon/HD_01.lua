local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 87 étapes, niveau final 16.18, ~19425 xp/h, 126 min.
Q:RegisterGuide({
  id = "HD_01",
  title = "The Barrens",
  faction = "Horde",
  mode = "dungeon",
  after = { "H_OrcTroll_02", "H_Tauren_02", "H_Undead_03", "H_Skyborne_01" },
  minLevel = 12, maxLevel = 15,
  next = "HD_02",
  sim = { steps = 87, endLevel = 16.18, xpPerHour = 19425, minutes = 126 },
  steps = {
    { "accept", 842, race = { "Orc", "Troll" } }, -- Crossroads Conscription (lvl 12, ~910 xp, sim lvl 13)
    { "fp", 1413, 63.08, 37.16 }, -- point de vol
    { "accept", 887 }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 13)
    { "accept", 97253 }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 894 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 13)
    { "complete", 887, at = { 1413, 64.02, 44.58 } }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 13)
    { "complete", 97253, at = { 1413, 61.8, 45.13 } }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 895 }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 13)
    { "turnin", 887, xp = 740 }, -- Southsea Freebooters (lvl 14, ~740 xp, sim lvl 13)
    { "accept", 890 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 13)
    { "turnin", 97253, xp = 1050 }, -- Parts and Pieces (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 890, xp = 100 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 13)
    { "accept", 892 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 13)
    { "turnin", 892, xp = 100 }, -- The Missing Shipment (lvl 14, ~100 xp, sim lvl 13)
    { "accept", 888 }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 13)
    { "fp", 1413, 51.5, 30.34 }, -- point de vol
    { "accept", 870 }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 13)
    { "turnin", 842, xp = 910, race = { "Orc", "Troll" } }, -- Crossroads Conscription (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 844 }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "complete", 844, at = { 1413, 57.05, 31.02 } }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 6365, race = { "Orc", "Troll" } }, -- Meats to Orgrimmar (lvl 10, ~210 xp, sim lvl 13)
    { "turnin", 844, xp = 910 }, -- Plainstrider Menace (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 845 }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 13)
    { "accept", 869 }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 13)
    { "sethearth", 1413, 51.99, 29.89 }, -- lier la pierre de foyer
    { "turnin", 6365, xp = 210, race = { "Orc", "Troll" } }, -- Meats to Orgrimmar (lvl 10, ~210 xp, sim lvl 13)
    { "accept", 848 }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 1492 }, -- Wharfmaster Dizzywig (lvl 11, ~440 xp, sim lvl 13)
    { "accept", 6384, race = { "Orc", "Troll" } }, -- Ride to Orgrimmar (lvl 10, ~0 xp, sim lvl 13)
    { "complete", 845, at = { 1413, 49.16, 37.48 } }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 13)
    { "complete", 848, at = { 1413, 45.11, 22.66 } }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 14)
    { "complete", 870, at = { 1413, 45.06, 22.53 } }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 14)
    { "turnin", 894, xp = 740 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 14)
    { "accept", 900 }, -- Samophlange (lvl 14, ~490 xp, sim lvl 14)
    { "complete", 900, at = { 1413, 52.33, 11.56 } }, -- Samophlange (lvl 14, ~490 xp, sim lvl 14)
    { "turnin", 900, xp = 490 }, -- Samophlange (lvl 14, ~490 xp, sim lvl 14)
    { "accept", 901 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 14)
    { "complete", 901, at = { 1413, 52.84, 10.39 } }, -- Samophlange (lvl 14, ~740 xp, sim lvl 14)
    { "turnin", 901, xp = 740 }, -- Samophlange (lvl 14, ~740 xp, sim lvl 14)
    { "accept", 902 }, -- Samophlange (lvl 16, ~1150 xp, sim lvl 14)
    { "accept", 6361, race = { "Tauren" } }, -- A Bundle of Hides (lvl 10, ~0 xp, sim lvl 14)
    { "turnin", 848, xp = 1050 }, -- Fungal Spores (lvl 15, ~1050 xp, sim lvl 14)
    { "turnin", 6361, xp = 210, race = { "Tauren" } }, -- A Bundle of Hides (lvl 10, ~210 xp, sim lvl 14)
    { "turnin", 845, xp = 910 }, -- The Zhevra (lvl 13, ~910 xp, sim lvl 14)
    { "accept", 903 }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 14)
    { "turnin", 870, xp = 680 }, -- The Forgotten Pools (lvl 13, ~680 xp, sim lvl 14)
    { "accept", 877 }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 14)
    { "complete", 877, at = { 1413, 55.61, 42.75 } }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 14)
    { "complete", 869, at = { 1413, 59.36, 45.7 } }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 14)
    { "complete", 888, at = { 1413, 62.63, 49.63 } }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 14)
    { "complete", 895, at = { 1413, 62.95, 49.4 } }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 14)
    { "turnin", 1492, xp = 440 }, -- Wharfmaster Dizzywig (lvl 11, ~440 xp, sim lvl 14)
    { "accept", 959, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~0 xp, sim lvl 14)
    { "turnin", 902, xp = 1150 }, -- Samophlange (lvl 16, ~1150 xp, sim lvl 14)
    { "accept", 3921 }, -- Wenikee Boltbucket (lvl 14, ~490 xp, sim lvl 14)
    { "turnin", 888, xp = 1150 }, -- Stolen Booty (lvl 16, ~1150 xp, sim lvl 14)
    { "turnin", 895, xp = 1150 }, -- WANTED: Baron Longshore (lvl 16, ~1150 xp, sim lvl 14)
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens" }, -- vol
    { "turnin", 877, xp = 1150 }, -- The Stagnant Oasis (lvl 16, ~1150 xp, sim lvl 14)
    { "accept", 880 }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 14)
    { "complete", 880, at = { 1413, 46.73, 39.63 } }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 14)
    { "accept", 1487, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Deviate Eradication (lvl 21, ~0 xp, sim lvl 15)
    { "accept", 1486, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Deviate Hides (lvl 17, ~0 xp, sim lvl 15)
    { "complete", 903, at = { 1413, 43.14, 33.95 } }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 15)
    { "turnin", 903, xp = 1050 }, -- Prowlers of the Barrens (lvl 15, ~1050 xp, sim lvl 15)
    { "accept", 881 }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 15)
    { "turnin", 869, xp = 910 }, -- Raptor Thieves (lvl 13, ~910 xp, sim lvl 15)
    { "accept", 95494 }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 15)
    { "complete", 95494, at = { 1413, 43.81, 15.82 } }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 15)
    { "turnin", 95494, xp = 1350 }, -- Bruised Pride and Lion Hides (lvl 18, ~1350 xp, sim lvl 15)
    { "accept", 95495 }, -- The Hermit Tanner (lvl 18, ~135 xp, sim lvl 15)
    { "accept", 95508 }, -- Unwelcome Guests (lvl 18, ~1350 xp, sim lvl 15)
    { "turnin", 95508, xp = 1350 }, -- Unwelcome Guests (lvl 18, ~1350 xp, sim lvl 15)
    { "turnin", 95495, xp = 135 }, -- The Hermit Tanner (lvl 18, ~135 xp, sim lvl 15)
    { "turnin", 3921, xp = 490 }, -- Wenikee Boltbucket (lvl 14, ~490 xp, sim lvl 15)
    { "accept", 3922 }, -- Nugget Slugs (lvl 15, ~1050 xp, sim lvl 15)
    { "complete", 3922, at = { 1413, 56.29, 8.45 } }, -- Nugget Slugs (lvl 15, ~1050 xp, sim lvl 15)
    { "turnin", 3922, xp = 1050 }, -- Nugget Slugs (lvl 15, ~1050 xp, sim lvl 15)
    { "accept", 3923 }, -- Rilli Greasygob (lvl 18, ~0 xp, sim lvl 15)
    { "level", 16, at = { 1413, 56.3, 8.96 }, note = "About 28 mobs here (Venture Co. Drudger, level 14)" }, -- farm de niveau
    { "complete", 881, at = { 1413, 55.86, 17.19 } }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 16)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 881, xp = 1450 }, -- Echeyakee (lvl 16, ~1450 xp, sim lvl 16)
    { "turnin", 880, xp = 1150 }, -- Altered Beings (lvl 16, ~1150 xp, sim lvl 16)
    { "accept", 1489, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Hamuul Runetotem (lvl 16, ~0 xp, sim lvl 16)
    { "fp", 1413, 44.45, 59.15 }, -- point de vol
  },
})
