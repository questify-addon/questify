local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 30 étapes, niveau final 50.00, ~46350 xp/h, 358 min.
Q:RegisterGuide({
  id = "A_21",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  minLevel = 48, maxLevel = 50,
  next = "A_22",
  sim = { steps = 30, endLevel = 50.00, xpPerHour = 46350, minutes = 358 },
  steps = {
    { "hearth", 1446 }, -- pierre de foyer
    { "goto", 1446, 51.01, 29.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 80, note = "Ratchet, The Barrens" }, -- vol
    { "boat", 1413, 63.54, 38.61, note = "Take the boat to Booty Bay (Stranglethorn Vale)" }, -- bateau
    { "accept", 608 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 48)
    { "turnin", 2874, xp = 3900 }, -- Deliver to MacKinley (lvl 45, ~3900 xp, sim lvl 48)
    { "accept", 8552, at = { 1434, 23.25, 72.1 }, note = "Loot Monogrammed Sash to start the quest (93.5 % drop: about 2 kills)" }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 48)
    { "turnin", 8552, xp = 2350 }, -- The Monogrammed Sash (lvl 50, ~2350 xp, sim lvl 48)
    { "accept", 8553 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 48)
    { "accept", 8551 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 48)
    { "turnin", 8553, xp = 470 }, -- The Captain's Cutlass (lvl 50, ~470 xp, sim lvl 48)
    { "accept", 594, at = { 1434, 33.79, 77.68 }, note = "Loot Carefully Folded Note to start the quest" }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 48)
    { "complete", 8551, at = { 1434, 36.95, 69.73 } }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 48)
    { "turnin", 594, xp = 2900 }, -- Message in a Bottle (lvl 45, ~2900 xp, sim lvl 48)
    { "complete", 608, obj = 1, at = { 1434, 32.87, 88.2 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 48)
    { "accept", 624, at = { 1434, 29.19, 88.6 }, note = "Loot Cortello's Riddle to start the quest" }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 48)
    { "complete", 608, at = { 1434, 29.32, 88.29 } }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 48)
    { "turnin", 608, xp = 4850 }, -- The Bloodsail Buccaneers (lvl 45, ~4850 xp, sim lvl 48)
    { "turnin", 8551, xp = 3150 }, -- The Captain's Chest (lvl 47, ~3150 xp, sim lvl 48)
    { "goto", 1434, 27.53, 77.79, note = "Flight master" }, -- déplacement
    { "fly", 1431, node = 12, note = "Darkshire, Duskwood" }, -- vol
    { "accept", 1398 }, -- Driftwood (lvl 42, ~2760 xp, sim lvl 48)
    { "accept", 81947 }, -- Sanguine Sorcery (lvl 45, ~0 xp, sim lvl 48)
    { "complete", 81947, at = { 1435, 70, 51 } }, -- Sanguine Sorcery (lvl 45, ~0 xp, sim lvl 48)
    { "complete", 1398, at = { 1435, 84.65, 86.55 } }, -- Driftwood (lvl 42, ~2760 xp, sim lvl 48)
    { "fp", 1419, 65.54, 24.34 }, -- point de vol
    { "turnin", 1398, xp = 2760 }, -- Driftwood (lvl 42, ~2760 xp, sim lvl 48)
    { "accept", 1425 }, -- Deliver the Shipment (lvl 42, ~0 xp, sim lvl 48)
    { "turnin", 624, xp = 3600 }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 48)
    { "level", 50, at = { 1434, 29.32, 88.29 }, note = "About 945 more mobs near the last objective" }, -- farm de niveau
  },
})
