local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 45 étapes, niveau final 49.00, ~44084 xp/h, 360 min.
Q:RegisterGuide({
  id = "HD_21",
  title = "Stranglethorn Vale",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 47, maxLevel = 49,
  next = "HD_22",
  sim = { steps = 45, endLevel = 49.00, xpPerHour = 44084, minutes = 360 },
  steps = {
    { "note", "Not running Razorfen Downs? Abandon Bring the End", optional = true, dungeon = "Razorfen Downs" },
    { "hearth", 1434 }, -- pierre de foyer
    { "accept", 617 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 47)
    { "accept", 209 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 47)
    { "accept", 608 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 2874, xp = 3900 }, -- Deliver to MacKinley (lvl 45, ~3900 xp, sim lvl 47)
    { "accept", 613 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "accept", 576 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "accept", 8551 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "accept", 8552, at = { 1434, 23.25, 72.1 }, note = "Loot Monogrammed Sash to start the quest (93.5 % drop: about 2 kills)" }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "complete", 576, at = { 1434, 23.83, 53.95 } }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "complete", 617, at = { 1434, 26, 28.52 } }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 47)
    { "accept", 97386 }, -- The Offense of Grom'gol (lvl 44, ~4650 xp, sim lvl 47)
    { "accept", 572 }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "accept", 591 }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "accept", 95326 }, -- The Big Payback (lvl 39, ~1200 xp, sim lvl 47)
    { "complete", 95326, at = { 1434, 43.87, 20.41 } }, -- The Big Payback (lvl 39, ~1200 xp, sim lvl 47)
    { "complete", 613, at = { 1434, 50.96, 28.04 } }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "complete", 97386, at = { 1434, 51.63, 27.42 } }, -- The Offense of Grom'gol (lvl 44, ~4650 xp, sim lvl 47)
    { "complete", 591, at = { 1434, 52.93, 27.6 } }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 209, at = { 1434, 47.41, 39.79 } }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 47)
    { "turnin", 591, xp = 5050 }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "accept", 592 }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "turnin", 97386, xp = 4650 }, -- The Offense of Grom'gol (lvl 44, ~4650 xp, sim lvl 47)
    { "complete", 592, at = { 1434, 39.02, 58.35 } }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 8551, at = { 1434, 36.95, 69.73 } }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "accept", 594, at = { 1434, 33.79, 77.68 }, note = "Loot Carefully Folded Note to start the quest" }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 47)
    { "turnin", 594, xp = 2900 }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 47)
    { "complete", 608, obj = 1, at = { 1434, 32.87, 88.2 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "accept", 624, at = { 1434, 29.19, 88.6 }, note = "Loot Cortello's Riddle to start the quest" }, -- Cortello's Riddle (lvl 43, ~0 xp, sim lvl 47)
    { "complete", 608, at = { 1434, 29.32, 88.29 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 209, xp = 3450 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 47)
    { "turnin", 617, xp = 3600 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 47)
    { "turnin", 608, xp = 4850 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 613, xp = 4650 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 576, xp = 2550 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "turnin", 95326, xp = 1200 }, -- The Big Payback (lvl 39, ~1200 xp, sim lvl 47)
    { "turnin", 8551, xp = 3150 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "turnin", 8552, xp = 2350 }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "accept", 8553 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "turnin", 8553, xp = 470 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "complete", 572, at = { 1434, 31.35, 42.55 } }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "turnin", 572, xp = 1960 }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "turnin", 592, xp = 5050 }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "level", 49, at = { 1434, 31.35, 42.55 }, note = "About 558 more mobs near the last objective" }, -- farm de niveau
  },
})
