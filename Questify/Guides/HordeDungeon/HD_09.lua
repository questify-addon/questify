local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 51 étapes, niveau final 31.55, ~32744 xp/h, 271 min.
Q:RegisterGuide({
  id = "HD_09",
  title = "Alterac Mountains and Arathi Highlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 29, maxLevel = 31,
  next = "HD_10",
  sim = { steps = 51, endLevel = 31.55, xpPerHour = 32744, minutes = 271 },
  steps = {
    { "goto", 1421, 45.62, 42.6, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 13, note = "Tarren Mill, Hillsbrad" }, -- vol
    { "level", 30, note = "About 413 mobs" }, -- farm de niveau
    { "accept", 556 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 552 }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "complete", 552, at = { 1424, 44.16, 29.07 } }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "turnin", 552, xp = 2650 }, -- Helcular's Revenge (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 553 }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "complete", 553, obj = 3, at = { 1416, 37.55, 66.24 } }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "complete", 553, at = { 1424, 43.89, 28.06 } }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "turnin", 553, xp = 3300 }, -- Helcular's Revenge (lvl 33, ~3300 xp, sim lvl 30)
    { "accept", 676 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 1361 }, -- Regthar Deathgate (lvl 32, ~0 xp, sim lvl 30)
    { "complete", 556, at = { 1416, 19.4, 84.93 } }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 556, xp = 2650 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 557 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 30)
    { "level", 31, at = { 1416, 13.28, 56 }, note = "About 22 mobs here (High Order Mage, level 30)" }, -- farm de niveau
    { "complete", 557, at = { 1416, 21.03, 58.34 } }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 557, xp = 2650 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "complete", 676, at = { 1417, 35.32, 42.95 } }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "fp", 1417, 73.02, 32.7 }, -- point de vol
    { "accept", 655 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 676, xp = 2550 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "turnin", 655, xp = 270 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 672 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "accept", 95663, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Dragonmaw Rumors (lvl 31, ~0 xp, sim lvl 31)
    { "complete", 672, at = { 1417, 66.71, 38.36 } }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "turnin", 672, xp = 2700 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "accept", 674 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 674, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 675 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 675, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 31)
    { "goto", 1437, 47.79, 56.16, optional = true, dungeon = "Excavation Site: Wetlands", note = "Dungeon: Excavation Site: Wetlands (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "EXCAVATION" }, -- déplacement
    { "turnin", 95663, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Dragonmaw Rumors (lvl 31, ~625 xp, sim lvl 31)
    { "accept", 95664, optional = true, dungeon = "Excavation Site: Wetlands", note = "Starts inside the dungeon", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 31)
    { "complete", 95664, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 31)
    { "turnin", 95664, at = { 1456, 71.06, 34.19 }, xp = 1250, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 31)
    { "goto", 1416, 8.46, 59.21, optional = true, dungeon = "City of Dalaran", note = "Dungeon: City of Dalaran (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DALARAN" }, -- déplacement
    { "complete", 96986, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- The Grave Knight (lvl 33, ~1325 xp, sim lvl 31)
    { "complete", 96988, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Source of Power (lvl 33, ~1325 xp, sim lvl 31)
    { "turnin", 96986, at = { 1424, 62.63, 20.65 }, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- The Grave Knight (lvl 33, ~1325 xp, sim lvl 31)
    { "turnin", 96988, at = { 1458, 46.61, 74.09 }, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Source of Power (lvl 33, ~1325 xp, sim lvl 31)
    { "accept", 96987, optional = true, dungeon = "City of Dalaran", note = "Starts inside the dungeon", phase = "run", rung = "DALARAN" }, -- Opportunistic Education (lvl 33, ~1325 xp, sim lvl 31)
    { "complete", 96987, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Opportunistic Education (lvl 33, ~1325 xp, sim lvl 31)
    { "turnin", 96987, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Opportunistic Education (lvl 33, ~1325 xp, sim lvl 31)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Graveyard (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_GY" }, -- déplacement
    { "accept", 1051, optional = true, dungeon = "Scarlet Monastery", note = "Starts inside the dungeon", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 31)
    { "complete", 1051, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 31)
    { "turnin", 1051, at = { 1424, 62.67, 18.88 }, xp = 1650, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 31)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Library (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_LIB" }, -- déplacement
  },
})
