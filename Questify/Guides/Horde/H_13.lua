local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 64 étapes, niveau final 42.00, ~52528 xp/h, 213 min.
Q:RegisterGuide({
  id = "H_13",
  title = "Stranglethorn Vale",
  faction = "Horde",
  minLevel = 40, maxLevel = 42,
  next = "H_14",
  sim = { steps = 64, endLevel = 42.00, xpPerHour = 52528, minutes = 213 },
  steps = {
    { "note", "Not running Uldaman? Abandon Power Stones", optional = true, dungeon = "Uldaman" },
    { "goto", 1418, 3.99, 44.78, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "sethearth", 1434, 31.49, 29.75 }, -- lier la pierre de foyer
    { "accept", 629 }, -- The Vile Reef (lvl 37, ~2850 xp, sim lvl 40)
    { "accept", 95770 }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 95748 }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 584 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 40)
    { "complete", 584, at = { 1434, 23.44, 8.12 } }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 40)
    { "complete", 95748, at = { 1434, 22.95, 12.02 } }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 40)
    { "complete", 629, at = { 1434, 24.8, 22.96 } }, -- The Vile Reef (lvl 37, ~2850 xp, sim lvl 40)
    { "complete", 95770, at = { 1434, 22.4, 27.18 } }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 40)
    { "goto", 1434, 32.54, 29.35, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 18, note = "Booty Bay, Stranglethorn" }, -- vol
    { "accept", 606 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 628 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 669, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 621 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 40)
    { "accept", 600 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 79236 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 40)
    { "accept", 2864, optional = true, dungeon = "Zul'Farrak" }, -- Tran'rek (lvl 45, ~0 xp, sim lvl 40)
    { "accept", 209 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 40)
    { "accept", 617 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 40)
    { "accept", 595 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "complete", 606, at = { 1434, 32.62, 66.62 } }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 40)
    { "turnin", 595, xp = 2450 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "accept", 597 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 40)
    { "turnin", 606, xp = 3300 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 40)
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
    { "complete", 600, at = { 1434, 41.63, 44.07 } }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 40)
    { "complete", 209, at = { 1434, 47.41, 39.79 } }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 40)
    { "complete", 628, at = { 1434, 33.43, 32.53 } }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 41)
    { "turnin", 95770, xp = 3150 }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 41)
    { "turnin", 629, xp = 2850 }, -- The Vile Reef (lvl 37, ~2850 xp, sim lvl 41)
    { "turnin", 95748, xp = 3150 }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 41)
    { "turnin", 584, xp = 3300 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 41)
    { "complete", 617, at = { 1434, 26, 28.52 } }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 41)
    { "complete", 609, at = { 1434, 35.26, 51.27 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "complete", 621, at = { 1434, 39.62, 58.31 } }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 41)
    { "complete", 609, at = { 1434, 40, 58.24 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "accept", 624, at = { 1434, 33.64, 88.37 }, note = "Loot Cortello's Riddle to start the quest" }, -- Cortello's Riddle (lvl 43, ~0 xp, sim lvl 41)
    { "complete", 587, at = { 1434, 29.97, 89.12 } }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 41)
    { "complete", 604, at = { 1434, 26.87, 83.26 } }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 41)
    { "turnin", 628, xp = 2850 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 41)
    { "turnin", 609, xp = 3750 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 41)
    { "turnin", 604, xp = 3600 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 41)
    { "turnin", 600, xp = 3300 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 41)
    { "turnin", 621, xp = 3750 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 41)
    { "turnin", 587, xp = 1650 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 41)
    { "turnin", 209, xp = 3450 }, -- Skullsplitter Tusks (lvl 42, ~3450 xp, sim lvl 41)
    { "turnin", 617, xp = 3600 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 41)
    { "turnin", 576, xp = 2550 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 41)
    { "complete", 79236, at = { 1434, 27.04, 77.17 } }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 41)
    { "turnin", 79236, xp = 1550 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 41)
    { "level", 42, at = { 1434, 27.13, 82.94 }, note = "About 20 more mobs here (Bloodsail Swashbuckler, level 42)" }, -- farm de niveau
  },
})
