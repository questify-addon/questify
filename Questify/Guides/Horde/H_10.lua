local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 45 étapes, niveau final 38.15, ~39709 xp/h, 88 min.
Q:RegisterGuide({
  id = "H_10",
  title = "Dustwallow Marsh",
  faction = "Horde",
  minLevel = 37, maxLevel = 38,
  next = "H_11",
  sim = { steps = 45, endLevel = 38.15, xpPerHour = 39709, minutes = 88 },
  steps = {
    { "note", "Not running City of Dalaran? Abandon Heart of Disruption, The Grave Knight", optional = true, dungeon = "City of Dalaran" },
    { "hearth", 1413 }, -- pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1413, node = 77, note = "Camp Taurajo, The Barrens" }, -- vol
    { "fp", 1445, 35.56, 31.88 }, -- point de vol
    { "accept", 1268 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1251 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1269 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "accept", 1177 }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 37)
    { "turnin", 1269, xp = 710 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "turnin", 1268, xp = 1350 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1251, xp = 690 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1321 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "turnin", 1321, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "accept", 1322 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1273 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1273, at = { 1445, 42.65, 38.07 } }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1322, at = { 1445, 42.69, 43.51 } }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1218 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 81570 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1238 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "turnin", 81570, xp = 1350 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 37)
    { "complete", 1218, at = { 1445, 66.44, 51.46 } }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1218, xp = 1350 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1206 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1322, xp = 2850 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1323 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "turnin", 1323, xp = 1400 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "turnin", 1273, xp = 3550 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "accept", 1201 }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1238, xp = 2050 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "complete", 1206, at = { 1445, 31.88, 21.93 } }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 1201, at = { 1445, 38.45, 25.29 } }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 1177, at = { 1445, 58.75, 9.66 } }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 37)
    { "accept", 1239 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 38)
    { "turnin", 1206, xp = 2750 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 38)
    { "turnin", 1177, xp = 2800 }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 1201, xp = 2750 }, -- Theramore Spies (lvl 35, ~2750 xp, sim lvl 38)
    { "turnin", 1239, xp = 2050 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 38)
    { "goto", 1445, 35.56, 31.88, note = "Flight master" }, -- déplacement
    { "fly", 1442, node = 29, note = "Sun Rock Retreat, Stonetalon Mountains" }, -- vol
    { "turnin", 79192, xp = 195 }, -- Stepping Stones (lvl 24, ~195 xp, sim lvl 38)
    { "accept", 79980 }, -- Scramble (lvl 24, ~15 xp, sim lvl 38)
    { "turnin", 79980, xp = 15 }, -- Scramble (lvl 24, ~15 xp, sim lvl 38)
    { "accept", 79974 }, -- Wet Job (lvl 32, ~0 xp, sim lvl 38)
  },
})
