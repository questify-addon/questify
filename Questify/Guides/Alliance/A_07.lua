local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 84 étapes, niveau final 33.06, ~45744 xp/h, 76 min.
Q:RegisterGuide({
  id = "A_07",
  title = "Duskwood",
  faction = "Alliance",
  minLevel = 32, maxLevel = 33,
  next = "A_09",
  sim = { steps = 84, endLevel = 33.06, xpPerHour = 45744, minutes = 76 },
  steps = {
    { "hearth", 1437 }, -- pierre de foyer
    { "fp", 1455, 55.5, 47.74 }, -- point de vol
    { "boat", 1455, 78, 51.4, note = "Take the Deeprun Tram to Stormwind" }, -- bateau
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1431, node = 12, note = "Darkshire, Duskwood" }, -- vol
    { "accept", 181 }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 32)
    { "accept", 173 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "sethearth", 1431, 73.87, 44.41 }, -- lier la pierre de foyer
    { "complete", 173, at = { 1431, 64.98, 68.93 } }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "turnin", 173, xp = 1150 }, -- Worgen in the Woods (lvl 28, ~1150 xp, sim lvl 32)
    { "accept", 221 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "complete", 221, at = { 1431, 64.06, 72.31 } }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "accept", 81731 }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81736 }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81732 }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81737 }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81738 }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81745 }, -- Duskwood Mission XVI: Rescue Kroll Mountainshade (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81745, xp = 2200 }, -- Duskwood Mission XVI: Rescue Kroll Mountainshade (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81746 }, -- Duskwood Mission XVII: Rescue Alara Grovemender (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81746, xp = 2200 }, -- Duskwood Mission XVII: Rescue Alara Grovemender (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 81747 }, -- Duskwood Mission XVIII: Rescue Elenora Marshwalker (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81747, xp = 2200 }, -- Duskwood Mission XVIII: Rescue Elenora Marshwalker (lvl 27, ~2200 xp, sim lvl 32)
    { "accept", 134 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "accept", 68 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "complete", 134, at = { 1431, 33.42, 76.35 } }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "complete", 81737, at = { 1431, 35.7, 80.1 } }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 32)
    { "complete", 81731, at = { 1431, 35.15, 75.21 } }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 32)
    { "complete", 181, at = { 1431, 38, 80 } }, -- Look To The Stars (lvl 30, ~2450 xp, sim lvl 32)
    { "turnin", 134, xp = 1200 }, -- Ogre Thieves (lvl 30, ~1200 xp, sim lvl 32)
    { "accept", 160 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 32)
    { "turnin", 160, xp = 610 }, -- Note to the Mayor (lvl 30, ~610 xp, sim lvl 32)
    { "accept", 251 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 32)
    { "turnin", 251, xp = 245 }, -- Translate Abercrombie's Note (lvl 30, ~245 xp, sim lvl 32)
    { "accept", 401 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 32)
    { "turnin", 401, xp = 1850 }, -- Wait for Sirra to Finish (lvl 30, ~1850 xp, sim lvl 32)
    { "accept", 252 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 32)
    { "turnin", 252, xp = 245 }, -- Translation to Ello (lvl 30, ~245 xp, sim lvl 32)
    { "accept", 253 }, -- Bride of the Embalmer (lvl 30, ~3650 xp, sim lvl 32)
    { "turnin", 68, xp = 1700 }, -- The Legend of Stalvan (lvl 28, ~1700 xp, sim lvl 32)
    { "accept", 69 }, -- The Legend of Stalvan (lvl 28, ~570 xp, sim lvl 32)
    { "turnin", 221, xp = 1750 }, -- Worgen in the Woods (lvl 29, ~1750 xp, sim lvl 32)
    { "accept", 222 }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 32)
    { "complete", 222, at = { 1431, 72.52, 71.17 } }, -- Worgen in the Woods (lvl 31, ~1900 xp, sim lvl 32)
    { "complete", 81736, at = { 1431, 65.7, 67.45 } }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 32)
    { "complete", 81738, at = { 1431, 49.22, 72.47 } }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 32)
    { "complete", 81732, at = { 1431, 49.44, 74.39 } }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81736, xp = 2200 }, -- Duskwood Mission VII: Recover Shadowscythe (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81732, xp = 2200 }, -- Duskwood Mission III: Defeat Dragonkin (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81738, xp = 2200 }, -- Duskwood Mission IX: Recover Dragon Egg (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81737, xp = 2200 }, -- Duskwood Mission VIII: Recover Ogre Magi text (lvl 27, ~2200 xp, sim lvl 32)
    { "turnin", 81731, xp = 2200 }, -- Duskwood Mission II: Defeat Ogres (lvl 27, ~2200 xp, sim lvl 32)
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
    { "turnin", 563, xp = 3200 }, -- Reassignment (lvl 32, ~3200 xp, sim lvl 33)
  },
})
