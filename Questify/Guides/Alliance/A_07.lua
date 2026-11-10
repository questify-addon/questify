local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-10.
-- Simulation : 75 étapes, niveau final 33.00, ~36339 xp/h, 90 min.
Q:RegisterGuide({
  id = "A_07",
  title = "Duskwood",
  faction = "Alliance",
  minLevel = 32, maxLevel = 33,
  next = "A_09",
  sim = { steps = 75, endLevel = 33.00, xpPerHour = 36339, minutes = 90 },
  steps = {
    { "note", "Not running Excavation Site: Wetlands? Abandon Highland Hides", optional = true, dungeon = "Excavation Site: Wetlands" },
    { "hearth", 1437 }, -- pierre de foyer
    { "fp", 1455, 55.5, 47.74 }, -- point de vol
    { "boat", 1455, 78, 51.4, note = "Take the Deeprun Tram to Stormwind" }, -- bateau
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1431, node = 12, note = "Darkshire, Duskwood" }, -- vol
    { "accept", 181 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 173 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "complete", 173, at = { 1431, 64.98, 68.93 } }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 58 }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 32)
    { "sethearth", 1431, 73.87, 44.41 }, -- lier la pierre de foyer
    { "turnin", 173, xp = 1150 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 221 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "complete", 221, at = { 1431, 64.06, 72.31 } }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "accept", 96138, at = { 1431, 43.94, 67.21 }, note = "Loot Merrick's Bow to start the quest" }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 134 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "complete", 58, at = { 1431, 24.44, 33.35 } }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 225 }, -- The Weathered Grave (lvl 35, ~690 xp, sim lvl 32)
    { "accept", 68 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "complete", 134, at = { 1431, 33.42, 76.35 } }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "complete", 96138, at = { 1431, 34.66, 75.98 } }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 32)
    { "complete", 181, at = { 1431, 38, 80 } }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 134, xp = 1200 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "accept", 160 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 32)
    { "turnin", 160, xp = 610 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 251 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 32)
    { "turnin", 251, xp = 245 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 32)
    { "accept", 401 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 32)
    { "turnin", 96138, xp = 2450 }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 225, xp = 690 }, -- The Weathered Grave (lvl 35, ~690 xp, sim lvl 32)
    { "accept", 227 }, -- Morgan Ladimore (lvl 35, ~275 xp, sim lvl 32)
    { "turnin", 401, xp = 1850 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 32)
    { "accept", 252 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 32)
    { "turnin", 252, xp = 245 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 32)
    { "accept", 253 }, -- Bride of the Embalmer (lvl 30, ~3650 xp, sim lvl 32)
    { "turnin", 68, xp = 1700 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "accept", 69 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 32)
    { "turnin", 58, xp = 2450 }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 227, xp = 275 }, -- Morgan Ladimore (lvl 35, ~275 xp, sim lvl 32)
    { "turnin", 221, xp = 1750 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "accept", 222 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 32)
    { "complete", 222, at = { 1431, 72.52, 71.17 } }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 32)
    { "complete", 253, at = { 1431, 28.82, 30.91 } }, -- Bride of the Embalmer (lvl 30, ~3650 xp, sim lvl 32)
    { "turnin", 69, xp = 570 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 32)
    { "accept", 70 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "complete", 70, at = { 1429, 44.3, 65.82 } }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "turnin", 70, xp = 1700 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "accept", 72 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "turnin", 72, xp = 230 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "accept", 74 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 32)
    { "hearth", 1431 }, -- pierre de foyer
    { "turnin", 74, xp = 1150 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 75 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 32)
    { "complete", 75, at = { 1429, 85.7, 69.54 } }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 32)
    { "turnin", 75, xp = 1150 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 78 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 32)
    { "turnin", 78, xp = 570 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 32)
    { "accept", 79 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "turnin", 79, xp = 230 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "accept", 80 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "turnin", 253, xp = 3650 }, -- Bride of the Embalmer (lvl 30, ~3650 xp, sim lvl 32)
    { "turnin", 80, xp = 230 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "accept", 97 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "turnin", 97, xp = 230 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 32)
    { "accept", 98 }, -- The Legend of Stalvan (lvl 35, ~4100 xp, sim lvl 32)
    { "complete", 98, at = { 1431, 77.35, 36.19 } }, -- The Legend of Stalvan (lvl 35, ~4100 xp, sim lvl 32)
    { "turnin", 181, xp = 2450 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 222, xp = 1900 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 32)
    { "accept", 223 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 32)
    { "turnin", 223, xp = 3150 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 32)
    { "turnin", 98, xp = 4100 }, -- The Legend of Stalvan (lvl 35, ~4100 xp, sim lvl 32)
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "turnin", 563, xp = 3200 }, -- Reassignment (lvl 32, ~3200 xp, sim lvl 32)
    { "level", 33, at = { 1431, 77.35, 36.19 }, note = "About 31 more mobs near the last objective" }, -- farm de niveau
  },
})
