local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 64 étapes, niveau final 42.47, ~44223 xp/h, 317 min.
Q:RegisterGuide({
  id = "H_13",
  title = "Stranglethorn Vale",
  faction = "Horde",
  minLevel = 40, maxLevel = 42,
  next = "H_14",
  sim = { steps = 64, endLevel = 42.47, xpPerHour = 44223, minutes = 317 },
  steps = {
    { "note", "Not running Uldaman? Abandon Power Stones", optional = true, dungeon = "Uldaman" },
    { "goto", 1418, 3.99, 44.78, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "accept", 596 }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 40)
    { "accept", 584 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 40)
    { "complete", 596, at = { 1434, 25.12, 10.34 } }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 40)
    { "complete", 584, at = { 1434, 23.44, 8.12 } }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 193 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 584, xp = 3300 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 585 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 40)
    { "turnin", 596, xp = 2100 }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 40)
    { "accept", 598 }, -- Split Bone Necklace (lvl 42, ~3450 xp, sim lvl 40)
    { "goto", 1434, 32.54, 29.35, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 18, note = "Booty Bay, Stranglethorn" }, -- vol
    { "accept", 606 }, -- Scaring Shaky (lvl 41, ~820 xp, sim lvl 40)
    { "accept", 628 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 669, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 600 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 621 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 40)
    { "accept", 209 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 40)
    { "accept", 2864, optional = true, dungeon = "Zul'Farrak" }, -- Tran'rek (lvl 45, ~0 xp, sim lvl 40)
    { "accept", 617 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 40)
    { "accept", 595 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "complete", 606, at = { 1434, 32.62, 66.62 } }, -- Scaring Shaky (lvl 41, ~820 xp, sim lvl 40)
    { "turnin", 595, xp = 2450 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "accept", 597 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "turnin", 606, xp = 820 }, -- Scaring Shaky (lvl 41, ~820 xp, sim lvl 40)
    { "accept", 607 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 40)
    { "turnin", 597, xp = 2450 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "accept", 599 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 40)
    { "accept", 576 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 40)
    { "turnin", 607, xp = 2450 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 40)
    { "accept", 609 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 40)
    { "turnin", 599, xp = 820 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 40)
    { "accept", 604 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 40)
    { "accept", 587 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 40)
    { "complete", 576, at = { 1434, 23.83, 53.95 } }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 40)
    { "complete", 609, at = { 1434, 35.26, 51.27 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "complete", 621, at = { 1434, 39.62, 58.31 } }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 41)
    { "complete", 609, at = { 1434, 40, 58.24 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "complete", 600, at = { 1434, 41.63, 44.07 } }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 41)
    { "complete", 585, obj = 2, at = { 1434, 42.21, 36.11 } }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 41)
    { "complete", 585, obj = 3, at = { 1434, 47.65, 39.54 } }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 41)
    { "complete", 209, at = { 1434, 47.41, 39.79 } }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 41)
    { "complete", 598, at = { 1434, 47.41, 39.8 } }, -- Split Bone Necklace (lvl 42, ~3450 xp, sim lvl 41)
    { "complete", 585, at = { 1434, 46.13, 32.33 } }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 41)
    { "complete", 193, at = { 1434, 49.6, 23.97 } }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 41)
    { "turnin", 193, xp = 3150 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 41)
    { "turnin", 585, xp = 2350 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 41)
    { "turnin", 598, xp = 3450 }, -- Split Bone Necklace (lvl 42, ~3450 xp, sim lvl 41)
    { "complete", 628, at = { 1434, 33.43, 32.53 } }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 41)
    { "complete", 617, at = { 1434, 27.13, 62.54 } }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 41)
    { "turnin", 576, xp = 2550 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 41)
    { "turnin", 609, xp = 3750 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "turnin", 628, xp = 2850 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 42)
    { "turnin", 209, xp = 3450 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 42)
    { "turnin", 621, xp = 3750 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 42)
    { "turnin", 600, xp = 3300 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 42)
    { "turnin", 617, xp = 3600 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 42)
    { "accept", 624, at = { 1434, 33.64, 88.37 }, note = "Loot Cortello's Riddle to start the quest" }, -- Cortello's Riddle (lvl 43, ~0 xp, sim lvl 42)
    { "complete", 587, at = { 1434, 29.97, 89.12 } }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 42)
    { "complete", 604, at = { 1434, 26.87, 83.26 } }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 42)
    { "turnin", 587, xp = 1650 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 42)
    { "turnin", 604, xp = 3600 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 42)
  },
})
