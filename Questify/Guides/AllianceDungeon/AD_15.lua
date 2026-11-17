local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 69 étapes, niveau final 37.00, ~29803 xp/h, 144 min.
Q:RegisterGuide({
  id = "AD_15",
  title = "Arathi Highlands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 35, maxLevel = 37,
  next = "AD_16",
  sim = { steps = 69, endLevel = 37.00, xpPerHour = 29803, minutes = 144 },
  steps = {
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "fp", 1417, 45.73, 46.1 }, -- point de vol
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "accept", 536 }, -- Down the Coast (lvl 30, ~1480 xp, sim lvl 36)
    { "accept", 659 }, -- Hints of a New Plague? (lvl 33, ~1300 xp, sim lvl 36)
    { "accept", 500 }, -- Crushridge Bounty (lvl 36, ~3500 xp, sim lvl 36)
    { "accept", 522, at = { 1424, 50.06, 57.91 }, note = "Loot Assassin's Contract to start the quest (81.9 % drop: about 2 kills)" }, -- Assassin's Contract (lvl 38, ~710 xp, sim lvl 36)
    { "turnin", 522, xp = 710 }, -- Assassin's Contract (lvl 38, ~710 xp, sim lvl 36)
    { "accept", 512 }, -- Noble Deaths (lvl 36, ~2800 xp, sim lvl 36)
    { "accept", 92432 }, -- An Alarming Request (lvl 33, ~660 xp, sim lvl 36)
    { "turnin", 92432, xp = 660 }, -- An Alarming Request (lvl 33, ~660 xp, sim lvl 36)
    { "accept", 98463 }, -- Talk of the Town (lvl 33, ~0 xp, sim lvl 36)
    { "complete", 536, at = { 1424, 43.8, 67.72 } }, -- Down the Coast (lvl 30, ~1480 xp, sim lvl 36)
    { "turnin", 536, xp = 1480 }, -- Down the Coast (lvl 30, ~1480 xp, sim lvl 36)
    { "accept", 559 }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 36)
    { "goto", 1424, 49.34, 52.27, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 16, note = "Refuge Pointe, Arathi" }, -- vol
    { "accept", 691 }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 36)
    { "turnin", 659, xp = 1300 }, -- Hints of a New Plague? (lvl 33, ~1300 xp, sim lvl 36)
    { "accept", 658 }, -- Hints of a New Plague? (lvl 36, ~2800 xp, sim lvl 36)
    { "turnin", 635, xp = 1350 }, -- Crystal in the Mountains (lvl 35, ~1350 xp, sim lvl 36)
    { "fp", 1425, 11.07, 46.15 }, -- point de vol
    { "accept", 511 }, -- Encrypted Letter (lvl 34, ~1350 xp, sim lvl 36)
    { "complete", 512, at = { 1416, 61.74, 43.57 } }, -- Noble Deaths (lvl 36, ~2800 xp, sim lvl 36)
    { "complete", 500, at = { 1416, 51.18, 43.99 } }, -- Crushridge Bounty (lvl 36, ~3500 xp, sim lvl 36)
    { "accept", 79948 }, -- Defensive Magics 101 (lvl 35, ~0 xp, sim lvl 36)
    { "complete", 79948, at = { 1416, 48.45, 57.65 } }, -- Defensive Magics 101 (lvl 35, ~0 xp, sim lvl 36)
    { "accept", 96800, optional = true, dungeon = "Scarlet Monastery", phase = "prep", rung = "SM_LIB" }, -- Past Due (lvl 38, ~0 xp, sim lvl 36)
    { "accept", 96773, optional = true, dungeon = "Razorfen Downs", phase = "prep", rung = "RFD" }, -- The Coldbringer's Eye (lvl 41, ~0 xp, sim lvl 36)
    { "complete", 658, at = { 1424, 43.75, 30.15 } }, -- Hints of a New Plague? (lvl 36, ~2800 xp, sim lvl 36)
    { "complete", 559, at = { 1424, 32.19, 72.78 } }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 36)
    { "turnin", 559, xp = 2550 }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 36)
    { "accept", 560 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 36)
    { "turnin", 511, xp = 1350 }, -- Encrypted Letter (lvl 34, ~1350 xp, sim lvl 36)
    { "turnin", 560, xp = 255 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 36)
    { "turnin", 500, xp = 3500 }, -- Crushridge Bounty (lvl 36, ~3500 xp, sim lvl 36)
    { "accept", 561 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 36)
    { "turnin", 512, xp = 2800 }, -- Noble Deaths (lvl 36, ~2800 xp, sim lvl 36)
    { "turnin", 561, xp = 255 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 36)
    { "accept", 562 }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 36)
    { "complete", 562, at = { 1424, 58.14, 71.42 } }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 36)
    { "accept", 92872 }, -- Dutiful Steps (lvl 38, ~2850 xp, sim lvl 36)
    { "turnin", 92872, xp = 2850 }, -- Dutiful Steps (lvl 38, ~2850 xp, sim lvl 36)
    { "complete", 691, at = { 1417, 68.31, 80.15 } }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 36)
    { "accept", 79949 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~0 xp, sim lvl 36)
    { "complete", 79949, at = { 1417, 73.6, 65.2 } }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~0 xp, sim lvl 36)
    { "turnin", 658, xp = 2800 }, -- Hints of a New Plague? (lvl 36, ~2800 xp, sim lvl 36)
    { "accept", 657 }, -- Hints of a New Plague? (lvl 36, ~1400 xp, sim lvl 36)
    { "turnin", 657, xp = 1400 }, -- Hints of a New Plague? (lvl 36, ~1400 xp, sim lvl 36)
    { "accept", 660 }, -- Hints of a New Plague? (lvl 37, ~2850 xp, sim lvl 36)
    { "complete", 660, at = { 1417, 60.1, 53.83 } }, -- Hints of a New Plague? (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 660, xp = 2850 }, -- Hints of a New Plague? (lvl 37, ~2850 xp, sim lvl 36)
    { "accept", 661 }, -- Hints of a New Plague? (lvl 37, ~3550 xp, sim lvl 36)
    { "turnin", 691, xp = 3500 }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 36)
    { "goto", 1417, 45.73, 46.1, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "turnin", 562, xp = 1950 }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 36)
    { "accept", 563 }, -- Reassignment (lvl 32, ~0 xp, sim lvl 36)
    { "turnin", 661, xp = 3550 }, -- Hints of a New Plague? (lvl 37, ~3550 xp, sim lvl 36)
    { "level", 37, at = { 1417, 68.31, 80.15 }, note = "About 14 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Library (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_LIB" }, -- déplacement
    { "complete", 1050, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_LIB" }, -- Mythology of the Titans (lvl 38, ~1775 xp, sim lvl 37)
    { "complete", 96800, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_LIB" }, -- Past Due (lvl 38, ~1425 xp, sim lvl 37)
    { "turnin", 96800, at = { 1416, 9.51, 62.25 }, xp = 1425, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_LIB" }, -- Past Due (lvl 38, ~1425 xp, sim lvl 37)
    { "turnin", 1050, at = { 1455, 74.97, 12.48 }, xp = 1775, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_LIB" }, -- Mythology of the Titans (lvl 38, ~1775 xp, sim lvl 37)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Armory (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_ARM" }, -- déplacement
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Cathedral (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_CATH" }, -- déplacement
  },
})
