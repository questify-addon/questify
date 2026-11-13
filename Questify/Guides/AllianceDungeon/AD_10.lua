local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 68 étapes, niveau final 31.00, ~36710 xp/h, 77 min.
Q:RegisterGuide({
  id = "AD_10",
  title = "Duskwood",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 29, maxLevel = 31,
  next = "AD_11",
  sim = { steps = 68, endLevel = 31.00, xpPerHour = 36710, minutes = 77 },
  steps = {
    { "hearth", 1431, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- pierre de foyer
    { "accept", 174, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 173, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 58, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 30)
    { "accept", 67, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 134, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "complete", 58, at = { 1431, 24.44, 33.35 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 174, at = { 1436, 41.27, 66.41 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~2000 xp, sim lvl 30)
    { "turnin", 67, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 68, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "complete", 134, at = { 1431, 33.42, 76.35 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "complete", 173, at = { 1431, 64.98, 68.93 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "turnin", 68, xp = 1700, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "accept", 69, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "turnin", 58, xp = 2450, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Night Watch (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 173, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 221, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "turnin", 174, xp = 2000, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 175, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~1000 xp, sim lvl 30)
    { "turnin", 175, xp = 1000, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~1000 xp, sim lvl 30)
    { "accept", 177, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~1500 xp, sim lvl 30)
    { "complete", 177, at = { 1431, 80.9, 71.96 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~1500 xp, sim lvl 30)
    { "complete", 221, at = { 1431, 64.06, 72.31 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "turnin", 134, xp = 1200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "accept", 160, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 30)
    { "turnin", 69, xp = 570, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "accept", 70, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "complete", 70, at = { 1429, 44.3, 65.82 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "turnin", 70, xp = 1700, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "accept", 72, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "turnin", 72, xp = 230, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 74, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "goto", 1453, 71.29, 72.23, note = "Flight master", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- déplacement
    { "fly", 1433, node = 5, note = "Lakeshire, Redridge", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- vol
    { "turnin", 74, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 75, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "complete", 75, at = { 1429, 85.7, 69.54 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "turnin", 75, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 78, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "turnin", 177, xp = 1500, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 25, ~1500 xp, sim lvl 30)
    { "accept", 181, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 221, xp = 1750, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "accept", 222, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "turnin", 78, xp = 570, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "accept", 79, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "turnin", 79, xp = 230, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 80, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "turnin", 80, xp = 230, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 97, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "turnin", 160, xp = 610, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 30)
    { "turnin", 97, xp = 230, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 251, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 30)
    { "turnin", 251, xp = 245, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 30)
    { "accept", 401, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 30)
    { "turnin", 401, xp = 1850, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 30)
    { "accept", 252, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 30)
    { "turnin", 252, xp = 245, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 30)
    { "accept", 96138, at = { 1431, 43.37, 68.23 }, note = "Loot Merrick's Bow to start the quest", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 96138, at = { 1431, 34.66, 75.98 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 181, at = { 1431, 38, 80 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
    { "hearth", 1431, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- pierre de foyer
    { "turnin", 181, xp = 2450, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 96138, xp = 2450, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Merrick's Bow (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 222, at = { 1431, 72.52, 71.17 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "turnin", 222, xp = 1900, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "accept", 223, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 30)
    { "turnin", 223, xp = 3150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 30)
    { "level", 31, at = { 1431, 72.55, 71.42 }, note = "About 18 more mobs here (Nightbane Vile Fang, level 29)", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- farm de niveau
  },
})
