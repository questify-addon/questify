local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 37 étapes, niveau final 51.00, ~55293 xp/h, 313 min.
Q:RegisterGuide({
  id = "HD_22",
  title = "The Hinterlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 49, maxLevel = 51,
  next = "HD_23",
  sim = { steps = 37, endLevel = 51.00, xpPerHour = 55293, minutes = 313 },
  steps = {
    { "hearth", 1417 }, -- pierre de foyer
    { "fp", 1425, 81.7, 81.76 }, -- point de vol
    { "accept", 7816 }, -- Gammerita, Mon! (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 7815 }, -- Snapjaws, Mon! (lvl 50, ~4700 xp, sim lvl 49)
    { "accept", 7828 }, -- Stalking the Stalkers (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 7830 }, -- Avenging the Fallen (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 7829 }, -- Hunt the Savages (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 7844 }, -- Cannibalistic Cousins (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 7850 }, -- Dark Vessels (lvl 50, ~5900 xp, sim lvl 49)
    { "accept", 7840 }, -- Lard Lost His Lunch (lvl 49, ~4550 xp, sim lvl 49)
    { "accept", 7845 }, -- Kidnapped Elder Torntusk! (lvl 51, ~4900 xp, sim lvl 49)
    { "accept", 7839 }, -- Vilebranch Hooligans (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7850, at = { 1425, 65.8, 70.53 } }, -- Dark Vessels (lvl 50, ~5900 xp, sim lvl 49)
    { "complete", 7844, obj = 2, at = { 1425, 48.07, 66.02 } }, -- Cannibalistic Cousins (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7828, obj = 2, at = { 1425, 50.71, 58.79 } }, -- Stalking the Stalkers (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7829, at = { 1425, 53.36, 51.63 } }, -- Hunt the Savages (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7839, at = { 1425, 57.45, 42.6 } }, -- Vilebranch Hooligans (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7830, at = { 1425, 62.72, 48.93 } }, -- Avenging the Fallen (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7828, at = { 1425, 71.91, 57.56 } }, -- Stalking the Stalkers (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7844, at = { 1425, 71.1, 48.15 } }, -- Cannibalistic Cousins (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7840, at = { 1425, 84.49, 41.22 } }, -- Lard Lost His Lunch (lvl 49, ~4550 xp, sim lvl 49)
    { "complete", 7816, at = { 1425, 80.4, 58.23 } }, -- Gammerita, Mon! (lvl 48, ~4400 xp, sim lvl 49)
    { "complete", 7815, at = { 1425, 76.94, 68.12 } }, -- Snapjaws, Mon! (lvl 50, ~4700 xp, sim lvl 49)
    { "turnin", 7844, xp = 4400 }, -- Cannibalistic Cousins (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7830, xp = 4400 }, -- Avenging the Fallen (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7828, xp = 4400 }, -- Stalking the Stalkers (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7829, xp = 4400 }, -- Hunt the Savages (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7850, xp = 5900 }, -- Dark Vessels (lvl 50, ~5900 xp, sim lvl 49)
    { "turnin", 7840, xp = 4550 }, -- Lard Lost His Lunch (lvl 49, ~4550 xp, sim lvl 49)
    { "turnin", 7839, xp = 4400 }, -- Vilebranch Hooligans (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7815, xp = 4700 }, -- Snapjaws, Mon! (lvl 50, ~4700 xp, sim lvl 49)
    { "turnin", 7816, xp = 4400 }, -- Gammerita, Mon! (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 7845, xp = 4900 }, -- Kidnapped Elder Torntusk! (lvl 51, ~4900 xp, sim lvl 49)
    { "accept", 1446, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "prep", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~0 xp, sim lvl 49)
    { "accept", 2933 }, -- Venom Bottles (lvl 43, ~2880 xp, sim lvl 49)
    { "turnin", 2933, xp = 2880 }, -- Venom Bottles (lvl 43, ~2880 xp, sim lvl 49)
    { "level", 51, at = { 1425, 76.94, 68.12 }, note = "About 762 more mobs near the last objective" }, -- farm de niveau
  },
})
