local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-16.
-- Simulation : 44 étapes, niveau final 44.27, ~51856 xp/h, 158 min.
Q:RegisterGuide({
  id = "A_17",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  minLevel = 42, maxLevel = 44,
  next = "A_18",
  sim = { steps = 44, endLevel = 44.27, xpPerHour = 51856, minutes = 158 },
  steps = {
    { "note", "Not running Scarlet Monastery? Abandon Past Due", optional = true, dungeon = "Scarlet Monastery" },
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 19, note = "Booty Bay, Stranglethorn" }, -- vol
    { "accept", 2864, optional = true, dungeon = "Zul'Farrak" }, -- Tran'rek (lvl 45, ~0 xp, sim lvl 43)
    { "accept", 587 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 43)
    { "accept", 621 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "sethearth", 1434, 27.04, 77.31 }, -- lier la pierre de foyer
    { "accept", 604 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 669, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 43)
    { "accept", 1183 }, -- Goblin Sponsorship (lvl 37, ~0 xp, sim lvl 43)
    { "accept", 348 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "accept", 2872 }, -- Stoley's Debt (lvl 45, ~0 xp, sim lvl 43)
    { "accept", 609 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "accept", 576 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 43)
    { "turnin", 95295, xp = 315 }, -- I Know a Guy (lvl 40, ~315 xp, sim lvl 43)
    { "complete", 576, at = { 1434, 23.83, 53.95 } }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 43)
    { "accept", 193 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 43)
    { "accept", 196 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "complete", 193, at = { 1434, 49.6, 23.97 } }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 609, at = { 1434, 35.26, 51.27 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 609, at = { 1434, 40, 58.24 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 621, at = { 1434, 39.62, 58.31 } }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 348, at = { 1434, 35.05, 60.88 } }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "complete", 587, at = { 1434, 29.97, 89.12 } }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 43)
    { "complete", 604, at = { 1434, 26.87, 83.26 } }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 587, xp = 1650 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 43)
    { "turnin", 621, xp = 3750 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 604, xp = 3600 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 348, xp = 5850 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "turnin", 609, xp = 3750 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 576, xp = 2550 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 44)
    { "complete", 196, at = { 1434, 31.35, 42.55 } }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 44)
    { "turnin", 193, xp = 3150 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 44)
    { "turnin", 196, xp = 2450 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 44)
    { "accept", 197 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 44)
    { "complete", 197, at = { 1434, 31.85, 42 } }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 44)
    { "turnin", 197, xp = 3600 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 44)
    { "accept", 208 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 44)
    { "complete", 208, at = { 1434, 38.21, 35.58 } }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 44)
    { "turnin", 208, xp = 5350 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 44)
    { "turnin", 79949, xp = 550 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~550 xp, sim lvl 44)
    { "turnin", 94893, xp = 4200 }, -- Delivering Closure (lvl 47, ~4200 xp, sim lvl 44)
    { "turnin", 94894, xp = 4850 }, -- The Twilight Threat (lvl 45, ~4850 xp, sim lvl 44)
  },
})
