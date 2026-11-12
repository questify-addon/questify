local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 65 étapes, niveau final 44.00, ~32928 xp/h, 378 min.
Q:RegisterGuide({
  id = "A_17",
  title = "Stranglethorn Vale",
  faction = "Alliance",
  minLevel = 42, maxLevel = 44,
  next = "A_18",
  sim = { steps = 65, endLevel = 44.00, xpPerHour = 32928, minutes = 378 },
  steps = {
    { "note", "Not running Scarlet Monastery? Abandon Past Due", optional = true, dungeon = "Scarlet Monastery" },
    { "note", "Not running Uldaman? Abandon A Sign of Hope, Power Stones", optional = true, dungeon = "Uldaman" },
    { "accept", 587 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 42)
    { "accept", 604 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 42)
    { "accept", 621 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 42)
    { "sethearth", 1434, 27.04, 77.31 }, -- lier la pierre de foyer
    { "accept", 1183 }, -- Goblin Sponsorship (lvl 37, ~0 xp, sim lvl 42)
    { "accept", 348 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 42)
    { "accept", 609 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 42)
    { "accept", 617 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 42)
    { "complete", 604, at = { 1434, 26.87, 83.26 } }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 42)
    { "complete", 587, at = { 1434, 29.97, 89.12 } }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 42)
    { "accept", 576 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 42)
    { "turnin", 604, xp = 3600 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 42)
    { "turnin", 587, xp = 1650 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 42)
    { "complete", 576, at = { 1434, 23.83, 53.95 } }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 42)
    { "complete", 617, at = { 1434, 26, 28.52 } }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 42)
    { "accept", 196 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 42)
    { "accept", 193 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 42)
    { "accept", 339 }, -- Chapter I (lvl 40, ~780 xp, sim lvl 42)
    { "accept", 340 }, -- Chapter II (lvl 40, ~780 xp, sim lvl 42)
    { "accept", 342 }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 42)
    { "accept", 341 }, -- Chapter III (lvl 40, ~780 xp, sim lvl 42)
    { "accept", 574 }, -- Special Forces (lvl 38, ~2850 xp, sim lvl 42)
    { "complete", 340, at = { 1434, 44.83, 9.73 } }, -- Chapter II (lvl 40, ~780 xp, sim lvl 42)
    { "complete", 339, at = { 1434, 44.83, 9.73 } }, -- Chapter I (lvl 40, ~780 xp, sim lvl 42)
    { "complete", 342, obj = 2, at = { 1434, 44.83, 9.73 } }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 42)
    { "complete", 574, at = { 1434, 45.79, 7.9 } }, -- Special Forces (lvl 38, ~2850 xp, sim lvl 42)
    { "turnin", 574, xp = 2850 }, -- Special Forces (lvl 38, ~2850 xp, sim lvl 42)
    { "accept", 202 }, -- Colonel Kurzen (lvl 40, ~3150 xp, sim lvl 42)
    { "complete", 340, obj = 2, at = { 1434, 28.87, 7.42 } }, -- Chapter II (lvl 40, ~780 xp, sim lvl 42)
    { "complete", 196, at = { 1434, 31.35, 42.55 } }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "complete", 609, at = { 1434, 35.26, 51.27 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 609, at = { 1434, 40, 58.24 } }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 621, at = { 1434, 39.62, 58.31 } }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 348, at = { 1434, 35.05, 60.88 } }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "turnin", 576, xp = 2550 }, -- Keep An Eye Out (lvl 42, ~2550 xp, sim lvl 43)
    { "accept", 2872 }, -- Stoley's Debt (lvl 45, ~0 xp, sim lvl 43)
    { "turnin", 609, xp = 3750 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 348, xp = 5850 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "turnin", 621, xp = 3750 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 617, xp = 3600 }, -- Akiris by the Bundle (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 2864, optional = true, dungeon = "Zul'Farrak" }, -- Tran'rek (lvl 45, ~0 xp, sim lvl 43)
    { "complete", 193, at = { 1434, 49.6, 23.97 } }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 202, obj = 3, at = { 1434, 49.94, 3.95 } }, -- Colonel Kurzen (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 202, at = { 1434, 47.59, 7.02 } }, -- Colonel Kurzen (lvl 40, ~3150 xp, sim lvl 43)
    { "turnin", 202, xp = 3150 }, -- Colonel Kurzen (lvl 40, ~3150 xp, sim lvl 43)
    { "turnin", 193, xp = 3150 }, -- Panther Mastery (lvl 40, ~3150 xp, sim lvl 43)
    { "turnin", 196, xp = 2450 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 197 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 197, at = { 1434, 31.85, 42 } }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 342, at = { 1434, 34.75, 22.74 } }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 43)
    { "complete", 340, at = { 1434, 34.75, 22.74 } }, -- Chapter II (lvl 40, ~780 xp, sim lvl 43)
    { "complete", 339, at = { 1434, 34.75, 22.74 } }, -- Chapter I (lvl 40, ~780 xp, sim lvl 43)
    { "complete", 341, at = { 1434, 34.75, 22.74 } }, -- Chapter III (lvl 40, ~780 xp, sim lvl 43)
    { "turnin", 197, xp = 3600 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 208 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 43)
    { "turnin", 342, xp = 780 }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 43)
    { "turnin", 339, xp = 780 }, -- Chapter I (lvl 40, ~780 xp, sim lvl 43)
    { "turnin", 340, xp = 780 }, -- Chapter II (lvl 40, ~780 xp, sim lvl 43)
    { "complete", 208, at = { 1434, 38.21, 35.58 } }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 43)
    { "complete", 341, at = { 1434, 37.37, 31.22 } }, -- Chapter III (lvl 40, ~780 xp, sim lvl 43)
    { "turnin", 208, xp = 5350 }, -- Big Game Hunter (lvl 43, ~5350 xp, sim lvl 43)
    { "turnin", 341, xp = 780 }, -- Chapter III (lvl 40, ~780 xp, sim lvl 43)
    { "level", 44, at = { 1434, 37.37, 31.22 }, note = "About 182 more mobs near the last objective" }, -- farm de niveau
  },
})
