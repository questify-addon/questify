local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 68 étapes, niveau final 31.02, ~40873 xp/h, 71 min.
Q:RegisterGuide({
  id = "AD_10",
  title = "Duskwood",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 29, maxLevel = 31,
  next = "AD_11",
  sim = { steps = 68, endLevel = 31.02, xpPerHour = 40873, minutes = 71 },
  steps = {
    { "hearth", 1424, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- pierre de foyer
    { "goto", 1424, 49.34, 52.27, note = "Flight master", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- déplacement
    { "fly", 1431, node = 12, note = "Darkshire, Duskwood", alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- vol
    { "accept", 173, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 67, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "sethearth", 1431, 73.87, 44.41, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- lier la pierre de foyer
    { "complete", 173, at = { 1431, 64.98, 68.93 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 81731, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81746, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVII: Rescue Alara Grovemender (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81738, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81746, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVII: Rescue Alara Grovemender (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81747, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVIII: Rescue Elenora Marshwalker (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81747, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVIII: Rescue Elenora Marshwalker (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81745, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVI: Rescue Kroll Mountainshade (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81732, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81737, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81745, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission XVI: Rescue Kroll Mountainshade (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 134, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "turnin", 67, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 68, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "complete", 134, at = { 1431, 33.42, 76.35 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "complete", 81737, at = { 1431, 35.7, 80.1 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 30)
    { "complete", 81731, at = { 1431, 35.15, 75.21 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 134, xp = 1200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 30)
    { "accept", 160, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 30)
    { "turnin", 81731, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81737, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 81736, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 160, xp = 610, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 30)
    { "accept", 251, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 30)
    { "turnin", 68, xp = 1700, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 30)
    { "accept", 69, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "turnin", 251, xp = 245, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 30)
    { "accept", 401, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 30)
    { "turnin", 401, xp = 1850, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 30)
    { "turnin", 173, xp = 1150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 30)
    { "accept", 221, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "accept", 181, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 81736, at = { 1431, 65.7, 67.45 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 30)
    { "complete", 221, at = { 1431, 64.06, 72.31 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "complete", 81738, at = { 1431, 49.22, 72.47 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 30)
    { "complete", 81732, at = { 1431, 49.44, 74.39 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 30)
    { "complete", 181, at = { 1431, 38, 80 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 81736, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81732, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 81738, xp = 2200, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 30)
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
    { "turnin", 78, xp = 570, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 30)
    { "turnin", 221, xp = 1750, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 30)
    { "accept", 222, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "complete", 222, at = { 1431, 72.52, 71.17 }, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "turnin", 222, xp = 1900, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 30)
    { "accept", 223, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 30)
    { "turnin", 223, xp = 3150, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Worgen in the Woods (lvl 31, ~3150 xp, sim lvl 30)
    { "turnin", 181, xp = 2450, alt = { "STOCKADE", "BFD", "EXCAVATION" }, below = 31 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 30)
  },
})
