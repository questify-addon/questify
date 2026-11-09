local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 58 étapes, niveau final 49.00, ~46150 xp/h, 344 min.
Q:RegisterGuide({
  id = "H_18",
  title = "Stranglethorn Vale",
  faction = "Horde",
  minLevel = 47, maxLevel = 49,
  next = "H_21",
  sim = { steps = 58, endLevel = 49.00, xpPerHour = 46150, minutes = 344 },
  steps = {
    { "note", "Not running Uldaman? Abandon Uldaman Reagent Run", optional = true, dungeon = "Uldaman" },
    { "goto", 1444, 75.45, 44.36, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "boat", 1413, 63.54, 38.61, note = "Take the boat to Booty Bay (Stranglethorn Vale)" }, -- bateau
    { "accept", 608 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "accept", 613 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 2874, xp = 3900 }, -- Deliver to MacKinley (lvl 45, ~3900 xp, sim lvl 47)
    { "accept", 348 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 47)
    { "accept", 8551 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "accept", 8552, at = { 1434, 23.25, 72.1 }, note = "Loot Monogrammed Sash to start the quest (93.5 % drop: about 2 kills)" }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "accept", 572 }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "sethearth", 1434, 31.49, 29.75 }, -- lier la pierre de foyer
    { "accept", 586 }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 47)
    { "accept", 196 }, -- Raptor Mastery (lvl 41, ~1960 xp, sim lvl 47)
    { "complete", 586, at = { 1434, 45.64, 42.96 } }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 47)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 586, xp = 4050 }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 47)
    { "accept", 588 }, -- The Fate of Yenniku (lvl 45, ~390 xp, sim lvl 47)
    { "turnin", 588, xp = 390 }, -- The Fate of Yenniku (lvl 45, ~390 xp, sim lvl 47)
    { "accept", 589 }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 47)
    { "complete", 572, at = { 1434, 31.35, 42.55 } }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "complete", 196, at = { 1434, 31.35, 42.55 } }, -- Raptor Mastery (lvl 41, ~1960 xp, sim lvl 47)
    { "turnin", 572, xp = 1960 }, -- Mok'thardin's Enchantment (lvl 41, ~1960 xp, sim lvl 47)
    { "turnin", 196, xp = 1960 }, -- Raptor Mastery (lvl 41, ~1960 xp, sim lvl 47)
    { "accept", 197 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 47)
    { "complete", 589, at = { 1434, 43.11, 48.08 } }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 47)
    { "complete", 197, at = { 1434, 31.85, 42 } }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 47)
    { "turnin", 589, xp = 3900 }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 47)
    { "accept", 591 }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "turnin", 197, xp = 3600 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 47)
    { "accept", 208 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 47)
    { "complete", 591, at = { 1434, 52.93, 27.6 } }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 613, at = { 1434, 50.96, 28.04 } }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 591, xp = 5050 }, -- The Mind's Eye (lvl 46, ~5050 xp, sim lvl 47)
    { "accept", 592 }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 208, at = { 1434, 38.21, 35.58 } }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 47)
    { "complete", 592, at = { 1434, 39.02, 58.35 } }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "complete", 348, at = { 1434, 35.05, 60.88 } }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 47)
    { "complete", 8551, at = { 1434, 36.95, 69.73 } }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "accept", 594, at = { 1434, 33.79, 77.68 }, note = "Loot Carefully Folded Note to start the quest" }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 47)
    { "turnin", 594, xp = 2900 }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 47)
    { "complete", 608, obj = 1, at = { 1434, 32.87, 88.2 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "complete", 608, at = { 1434, 29.32, 88.29 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 613, xp = 4650 }, -- Cracking Maury's Foot (lvl 44, ~4650 xp, sim lvl 47)
    { "turnin", 348, xp = 5850 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 47)
    { "turnin", 608, xp = 4850 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 47)
    { "turnin", 8552, xp = 2350 }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 47)
    { "accept", 8553 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "turnin", 8551, xp = 3150 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 47)
    { "turnin", 8553, xp = 470 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 47)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "turnin", 592, xp = 5050 }, -- Saving Yenniku (lvl 46, ~5050 xp, sim lvl 47)
    { "turnin", 208, xp = 5350 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 47)
    { "level", 49, at = { 1434, 29.32, 88.29 }, note = "About 665 more mobs near the last objective" }, -- farm de niveau
  },
})
