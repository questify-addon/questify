local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 29 étapes, niveau final 38.03, ~34228 xp/h, 63 min.
Q:RegisterGuide({
  id = "H_10",
  title = "Dustwallow Marsh",
  faction = "Horde",
  minLevel = 37, maxLevel = 38,
  next = "H_11",
  sim = { steps = 29, endLevel = 38.03, xpPerHour = 34228, minutes = 63 },
  steps = {
    { "note", "Not running City of Dalaran? Abandon Heart of Disruption, The Grave Knight", optional = true, dungeon = "City of Dalaran" },
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "fp", 1445, 35.56, 31.88 }, -- point de vol
    { "accept", 1268 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1251 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1269 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "accept", 1218 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1238 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "turnin", 1251, xp = 690 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 37)
    { "accept", 1321 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "turnin", 1268, xp = 1350 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1269, xp = 710 }, -- Lieutenant Paval Reethe (lvl 37, ~710 xp, sim lvl 37)
    { "turnin", 1321, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 37)
    { "accept", 1322 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 1238, xp = 2050 }, -- The Lost Report (lvl 35, ~2050 xp, sim lvl 37)
    { "accept", 1273 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1273, at = { 1445, 42.65, 38.07 } }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "complete", 1322, at = { 1445, 42.69, 43.51 } }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "complete", 1218, at = { 1445, 66.44, 51.46 } }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "turnin", 1218, xp = 1350 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 37)
    { "accept", 1206 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 1239 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 37)
    { "turnin", 1322, xp = 2850 }, -- The Black Shield (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1323 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "turnin", 1323, xp = 1400 }, -- The Black Shield (lvl 37, ~1400 xp, sim lvl 37)
    { "turnin", 1273, xp = 3550 }, -- Questioning Reethe (lvl 37, ~3550 xp, sim lvl 37)
    { "turnin", 1239, xp = 2050 }, -- The Severed Head (lvl 35, ~2050 xp, sim lvl 37)
    { "complete", 1206, at = { 1445, 31.88, 21.93 } }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1206, xp = 2750 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 37)
  },
})
