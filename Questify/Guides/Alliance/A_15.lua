local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 51 étapes, niveau final 41.00, ~33854 xp/h, 161 min.
Q:RegisterGuide({
  id = "A_15",
  title = "Dustwallow Marsh",
  faction = "Alliance",
  minLevel = 40, maxLevel = 41,
  next = "A_16",
  sim = { steps = 51, endLevel = 41.00, xpPerHour = 33854, minutes = 161 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 32, note = "Theramore, Dustwallow Marsh" }, -- vol
    { "accept", 1282 }, -- They Call Him Smiling Jim (lvl 35, ~275 xp, sim lvl 40)
    { "accept", 1204 }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 1282, xp = 275 }, -- They Call Him Smiling Jim (lvl 35, ~275 xp, sim lvl 40)
    { "accept", 1218 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 40)
    { "accept", 1219 }, -- The Orc Report (lvl 35, ~690 xp, sim lvl 40)
    { "accept", 1177 }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 40)
    { "accept", 1284 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 40)
    { "accept", 1252 }, -- Lieutenant Paval Reethe (lvl 40, ~780 xp, sim lvl 40)
    { "accept", 1253 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 40)
    { "turnin", 1219, xp = 690 }, -- The Orc Report (lvl 35, ~690 xp, sim lvl 40)
    { "complete", 1218, at = { 1445, 66.44, 51.46 } }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 40)
    { "accept", 1220 }, -- Captain Vimes (lvl 35, ~2750 xp, sim lvl 40)
    { "turnin", 1252, xp = 780 }, -- Lieutenant Paval Reethe (lvl 40, ~780 xp, sim lvl 40)
    { "turnin", 1253, xp = 690 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 40)
    { "accept", 1259 }, -- Lieutenant Paval Reethe (lvl 40, ~315 xp, sim lvl 40)
    { "turnin", 1259, xp = 315 }, -- Lieutenant Paval Reethe (lvl 40, ~315 xp, sim lvl 40)
    { "accept", 1285 }, -- Daelin's Men (lvl 38, ~285 xp, sim lvl 40)
    { "accept", 1319 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 40)
    { "turnin", 1284, xp = 1350 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 40)
    { "turnin", 1285, xp = 285 }, -- Daelin's Men (lvl 38, ~285 xp, sim lvl 40)
    { "accept", 1286 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 1220, xp = 2750 }, -- Captain Vimes (lvl 35, ~2750 xp, sim lvl 40)
    { "turnin", 1218, xp = 1350 }, -- Soothing Spices (lvl 35, ~1350 xp, sim lvl 40)
    { "accept", 1206 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 40)
    { "accept", 79952 }, -- RwlRwlRwlRwl! (lvl 35, ~0 xp, sim lvl 40)
    { "complete", 79952, at = { 1445, 57.2, 20.8 } }, -- RwlRwlRwlRwl! (lvl 35, ~0 xp, sim lvl 40)
    { "complete", 1177, at = { 1445, 58.75, 9.66 } }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 40)
    { "accept", 1222 }, -- Stinky's Escape (lvl 37, ~2850 xp, sim lvl 40)
    { "complete", 1222, at = { 1445, 48.87, 24.58 } }, -- Stinky's Escape (lvl 37, ~2850 xp, sim lvl 40)
    { "complete", 1206, at = { 1445, 31.88, 21.93 } }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 40)
    { "turnin", 1177, xp = 2800 }, -- Hungry! (lvl 36, ~2800 xp, sim lvl 40)
    { "turnin", 1286, xp = 2850 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "accept", 1287 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "accept", 2846, optional = true, dungeon = "Zul'Farrak" }, -- Tiara of the Deep (lvl 46, ~0 xp, sim lvl 40)
    { "complete", 1204, at = { 1445, 58.35, 50.98 } }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 1319, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 40)
    { "accept", 1320 }, -- The Black Shield (lvl 35, ~1350 xp, sim lvl 40)
    { "accept", 7070, optional = true, dungeon = "Maraudon" }, -- Shadowshard Fragments (lvl 42, ~0 xp, sim lvl 40)
    { "turnin", 1320, xp = 1350 }, -- The Black Shield (lvl 35, ~1350 xp, sim lvl 40)
    { "turnin", 1287, xp = 2850 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 1222, xp = 2850 }, -- Stinky's Escape (lvl 37, ~2850 xp, sim lvl 40)
    { "turnin", 1204, xp = 2850 }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 40)
    { "turnin", 1206, xp = 2750 }, -- Jarl Needs Eyes (lvl 35, ~2750 xp, sim lvl 40)
    { "goto", 1445, 67.48, 51.3, note = "Flight master" }, -- déplacement
    { "fly", 1443, node = 37, note = "Nijel's Point, Desolace" }, -- vol
    { "accept", 7067, optional = true, dungeon = "Maraudon" }, -- The Pariah's Instructions (lvl 48, ~0 xp, sim lvl 40)
    { "level", 41, at = { 1443, 52.01, 83.92 }, note = "About 138 more mobs here (Nether Sorceress, level 39)" }, -- farm de niveau
  },
})
