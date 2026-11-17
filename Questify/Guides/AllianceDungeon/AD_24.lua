local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 81 étapes, niveau final 48.00, ~39514 xp/h, 248 min.
Q:RegisterGuide({
  id = "AD_24",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 46, maxLevel = 48,
  next = "AD_25",
  sim = { steps = 81, endLevel = 48.00, xpPerHour = 39514, minutes = 248 },
  steps = {
    { "goto", 1446, 51.01, 29.34, note = "Flight master", alt = { "MARAUDON", "ZF" }, below = 48 }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens", alt = { "MARAUDON", "ZF" }, below = 48 }, -- vol
    { "boat", 1413, 63.54, 38.61, note = "Take the boat to Booty Bay (Stranglethorn Vale)", alt = { "MARAUDON", "ZF" }, below = 48 }, -- bateau
    { "accept", 587, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Up to Snuff (lvl 41, ~1320 xp, sim lvl 46)
    { "accept", 621, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 46)
    { "accept", 604, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 46)
    { "turnin", 2874, xp = 3900, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Deliver to MacKinley (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 348, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 46)
    { "accept", 606, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 46)
    { "complete", 604, at = { 1434, 26.87, 83.26 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 46)
    { "accept", 594, at = { 1434, 33.79, 77.68 }, note = "Loot Carefully Folded Note to start the quest", alt = { "MARAUDON", "ZF" }, below = 48 }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 46)
    { "complete", 606, at = { 1434, 32.62, 66.62 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 46)
    { "turnin", 606, xp = 3300, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 46)
    { "accept", 607, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 46)
    { "accept", 8551, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 46)
    { "turnin", 604, xp = 3600, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 46)
    { "accept", 608, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 46)
    { "turnin", 607, xp = 2450, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 46)
    { "accept", 609, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 46)
    { "accept", 624, at = { 1434, 29.19, 88.6 }, note = "Loot Cortello's Riddle to start the quest", alt = { "MARAUDON", "ZF" }, below = 48 }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 46)
    { "complete", 608, at = { 1434, 29.32, 88.29 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 46)
    { "complete", 587, at = { 1434, 29.97, 89.12 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Up to Snuff (lvl 41, ~1320 xp, sim lvl 46)
    { "complete", 608, at = { 1434, 32.87, 88.2 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 594, xp = 2900, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 47)
    { "complete", 8551, at = { 1434, 36.95, 69.73 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "complete", 609, obj = 3, at = { 1434, 40, 58.24 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 47)
    { "complete", 621, at = { 1434, 39.62, 58.31 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 47)
    { "complete", 609, at = { 1434, 35.26, 51.27 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 47)
    { "accept", 576, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "turnin", 609, xp = 3750, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 47)
    { "accept", 613, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 608, xp = 4850, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 621, xp = 3750, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 47)
    { "turnin", 587, xp = 1320, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Up to Snuff (lvl 41, ~1320 xp, sim lvl 47)
    { "accept", 8552, at = { 1434, 23.25, 72.1 }, note = "Loot Monogrammed Sash to start the quest (93.5 % drop: about 2 kills)", alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "complete", 576, at = { 1434, 23.83, 53.95 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "accept", 192, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 38, ~430 xp, sim lvl 47)
    { "accept", 207, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "accept", 202, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Colonel Kurzen (lvl 40, ~1890 xp, sim lvl 47)
    { "complete", 207, obj = 1, at = { 1434, 29.48, 19.14 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "complete", 207, obj = 2, at = { 1434, 24.8, 22.96 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "complete", 207, obj = 3, at = { 1434, 22.95, 12.02 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "complete", 207, at = { 1434, 24.7, 8.93 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "turnin", 207, xp = 710, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Kurzen's Mystery (lvl 38, ~710 xp, sim lvl 47)
    { "accept", 205, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Troll Witchery (lvl 40, ~1890 xp, sim lvl 47)
    { "complete", 202, at = { 1434, 47.59, 7.02 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Colonel Kurzen (lvl 40, ~1890 xp, sim lvl 47)
    { "complete", 202, at = { 1434, 49.94, 3.95 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Colonel Kurzen (lvl 40, ~1890 xp, sim lvl 47)
    { "turnin", 624, xp = 3600, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 47)
    { "accept", 1398, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Driftwood (lvl 42, ~3450 xp, sim lvl 47)
    { "accept", 81947, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Sanguine Sorcery (lvl 45, ~975 xp, sim lvl 47)
    { "complete", 81947, at = { 1435, 70, 51 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Sanguine Sorcery (lvl 45, ~975 xp, sim lvl 47)
    { "complete", 1398, at = { 1435, 84.65, 86.55 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Driftwood (lvl 42, ~3450 xp, sim lvl 47)
    { "fp", 1419, 65.54, 24.34, alt = { "MARAUDON", "ZF" }, below = 48 }, -- point de vol
    { "turnin", 1398, xp = 3450, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Driftwood (lvl 42, ~3450 xp, sim lvl 47)
    { "accept", 1425, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Deliver the Shipment (lvl 42, ~0 xp, sim lvl 47)
    { "complete", 192, at = { 1434, 49.19, 21.6 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 38, ~430 xp, sim lvl 47)
    { "complete", 613, at = { 1434, 50.96, 28.04 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "accept", 97405, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Noise Complaints (lvl 44, ~4650 xp, sim lvl 47)
    { "complete", 205, at = { 1434, 47.39, 39.76 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Troll Witchery (lvl 40, ~1890 xp, sim lvl 47)
    { "complete", 348, at = { 1434, 35.05, 60.88 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 47)
    { "turnin", 576, xp = 2550, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 47)
    { "turnin", 613, xp = 4650, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 348, xp = 5850, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 47)
    { "turnin", 8552, xp = 2350, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "turnin", 8551, xp = 3150, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "accept", 8553, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "turnin", 8553, xp = 470, alt = { "MARAUDON", "ZF" }, below = 48 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "turnin", 192, xp = 430, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 38, ~430 xp, sim lvl 47)
    { "accept", 193, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 40, ~1890 xp, sim lvl 47)
    { "turnin", 202, xp = 1890, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Colonel Kurzen (lvl 40, ~1890 xp, sim lvl 47)
    { "turnin", 205, xp = 1890, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Troll Witchery (lvl 40, ~1890 xp, sim lvl 47)
    { "accept", 206, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Mai'Zoth (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 193, at = { 1434, 49.6, 23.97 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 40, ~1890 xp, sim lvl 47)
    { "complete", 97405, at = { 1434, 51.63, 27.42 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Noise Complaints (lvl 44, ~4650 xp, sim lvl 47)
    { "complete", 206, at = { 1434, 52.93, 27.6 }, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Mai'Zoth (lvl 46, ~5050 xp, sim lvl 47)
    { "turnin", 97405, xp = 4650, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Noise Complaints (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 193, xp = 1890, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Panther Mastery (lvl 40, ~1890 xp, sim lvl 47)
    { "turnin", 206, xp = 5050, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Mai'Zoth (lvl 46, ~5050 xp, sim lvl 47)
    { "turnin", 81947, xp = 975, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Sanguine Sorcery (lvl 45, ~975 xp, sim lvl 47)
    { "turnin", 81949, xp = 975, alt = { "MARAUDON", "ZF" }, below = 48 }, -- Legends of the Tidesages (lvl 45, ~975 xp, sim lvl 47)
    { "level", 48, at = { 1434, 52.93, 27.6 }, note = "About 7 more mobs near the last objective", alt = { "MARAUDON", "ZF" }, below = 48 }, -- farm de niveau
  },
})
