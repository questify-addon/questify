local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 48 étapes, niveau final 35.00, ~35971 xp/h, 195 min.
Q:RegisterGuide({
  id = "H_08",
  title = "Desolace",
  faction = "Horde",
  minLevel = 33, maxLevel = 35,
  next = "H_09",
  sim = { steps = 48, endLevel = 35.00, xpPerHour = 35971, minutes = 195 },
  steps = {
    { "accept", 1433 }, -- Alliance Relations (lvl 33, ~265 xp, sim lvl 33)
    { "accept", 1434 }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 33)
    { "turnin", 1433, xp = 265 }, -- Alliance Relations (lvl 33, ~265 xp, sim lvl 33)
    { "accept", 1435 }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 1480, at = { 1443, 54.86, 28.36 }, note = "Loot Flayed Demon Skin to start the quest (3.5 % drop: about 29 kills)" }, -- The Corrupter (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 1435, at = { 1443, 54.81, 28.21 } }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 5741 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 6161 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6161, obj = 1, at = { 1443, 33.01, 32.36 } }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "fp", 1443, 21.6, 74.13 }, -- point de vol
    { "accept", 6142 }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 33)
    { "sethearth", 1443, 24.09, 68.21 }, -- lier la pierre de foyer
    { "accept", 6143 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 33)
    { "turnin", 1435, xp = 2650 }, -- The Burning of Spirits (lvl 33, ~2650 xp, sim lvl 33)
    { "turnin", 1480, xp = 1300 }, -- The Corrupter (lvl 33, ~1300 xp, sim lvl 33)
    { "accept", 1481 }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 1365 }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 33)
    { "accept", 5561 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 33)
    { "complete", 1365, at = { 1443, 73.92, 46.32 } }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 33)
    { "complete", 1481, at = { 1443, 76.49, 25.56 } }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 33)
    { "complete", 1434, at = { 1443, 74.85, 23.46 } }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 33)
    { "accept", 5821 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 33)
    { "complete", 5741, at = { 1443, 55.17, 30.15 } }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 33)
    { "turnin", 5741, xp = 2650 }, -- Sceptre of Light (lvl 33, ~2650 xp, sim lvl 33)
    { "complete", 6161, at = { 1443, 35.44, 25.28 } }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 33)
    { "complete", 6143, obj = 2, at = { 1443, 36.22, 22.48 } }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 34)
    { "turnin", 6161, xp = 2800 }, -- Claim Rackmore's Treasure! (lvl 36, ~2800 xp, sim lvl 34)
    { "complete", 6143, at = { 1443, 32.21, 22.1 } }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 34)
    { "complete", 6142, at = { 1443, 33.28, 28.35 } }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 34)
    { "hearth", 1443 }, -- pierre de foyer
    { "turnin", 6142, xp = 2750 }, -- Clam Bait (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 6143, xp = 2800 }, -- Other Fish to Fry (lvl 36, ~2800 xp, sim lvl 34)
    { "accept", 5763 }, -- Hunting in Stranglethorn (lvl 31, ~0 xp, sim lvl 34)
    { "turnin", 1481, xp = 2650 }, -- The Corrupter (lvl 33, ~2650 xp, sim lvl 34)
    { "turnin", 1434, xp = 2650 }, -- Befouled by Satyr (lvl 33, ~2650 xp, sim lvl 34)
    { "accept", 1436 }, -- Alliance Relations (lvl 33, ~2650 xp, sim lvl 34)
    { "complete", 5561, at = { 1443, 52.17, 58.23 } }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 34)
    { "turnin", 1365, xp = 3450 }, -- Khan Dez'hepah (lvl 35, ~3450 xp, sim lvl 34)
    { "accept", 1366 }, -- Centaur Bounty (lvl 31, ~3750 xp, sim lvl 34)
    { "complete", 1366, at = { 1443, 72.21, 44.04 } }, -- Centaur Bounty (lvl 31, ~3750 xp, sim lvl 34)
    { "complete", 5821, at = { 1443, 67.17, 56.62 } }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 5821, xp = 2750 }, -- Bodyguard for Hire (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 5561, xp = 2000 }, -- Kodo Roundup (lvl 34, ~2000 xp, sim lvl 34)
    { "turnin", 1366, xp = 3750 }, -- Centaur Bounty (lvl 31, ~3750 xp, sim lvl 34)
    { "goto", 1456, 47, 49.83, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "turnin", 1436, xp = 2650 }, -- Alliance Relations (lvl 33, ~2650 xp, sim lvl 34)
    { "level", 35, at = { 1443, 72.21, 44.04 }, note = "About 70 more mobs near the last objective" }, -- farm de niveau
  },
})
