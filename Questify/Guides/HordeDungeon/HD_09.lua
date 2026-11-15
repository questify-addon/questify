local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 61 étapes, niveau final 32.11, ~36392 xp/h, 245 min.
Q:RegisterGuide({
  id = "HD_09",
  title = "Alterac Mountains and Arathi Highlands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 29, maxLevel = 31,
  next = "HD_10",
  sim = { steps = 61, endLevel = 32.11, xpPerHour = 36392, minutes = 245 },
  steps = {
    { "hearth", 1424 }, -- pierre de foyer
    { "level", 30, at = { 1424, 45.51, 31.17 }, note = "About 223 mobs here (Cave Yeti, level 30)" }, -- farm de niveau
    { "accept", 544 }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 30)
    { "accept", 556 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 30)
    { "accept", 676 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 533 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 30)
    { "accept", 79364, classes = { "SHAMAN" } }, -- Eyes on the Sky (lvl 33, ~265 xp, sim lvl 30)
    { "turnin", 79364, xp = 265, classes = { "SHAMAN" } }, -- Eyes on the Sky (lvl 33, ~265 xp, sim lvl 30)
    { "accept", 1361 }, -- Regthar Deathgate (lvl 32, ~0 xp, sim lvl 30)
    { "accept", 535 }, -- Valik (lvl 34, ~270 xp, sim lvl 30)
    { "complete", 533, at = { 1416, 58.3, 67.96 } }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 30)
    { "level", 31, at = { 1416, 41.6, 78.56 }, note = "About 41 mobs here (High Order Mage, level 30)" }, -- farm de niveau
    { "complete", 535, at = { 1416, 58.98, 68.49 } }, -- Valik (lvl 34, ~270 xp, sim lvl 31)
    { "turnin", 535, xp = 270 }, -- Valik (lvl 34, ~270 xp, sim lvl 31)
    { "complete", 556, at = { 1416, 19.4, 84.93 } }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 31)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 556, xp = 2650 }, -- Stone Tokens (lvl 33, ~2650 xp, sim lvl 31)
    { "accept", 557 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 533, xp = 2700 }, -- Infiltration (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 557, at = { 1416, 21.03, 58.34 } }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "complete", 544, at = { 1416, 19.91, 85.97 } }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 31)
    { "turnin", 557, xp = 2650 }, -- Bracers of Binding (lvl 33, ~2650 xp, sim lvl 31)
    { "turnin", 544, xp = 3300 }, -- Prison Break In (lvl 33, ~3300 xp, sim lvl 31)
    { "accept", 545 }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "complete", 545, at = { 1416, 21.01, 58.98 } }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "turnin", 545, xp = 2050 }, -- Dalaran Patrols (lvl 35, ~2050 xp, sim lvl 31)
    { "fp", 1417, 73.02, 32.7 }, -- point de vol
    { "accept", 655 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "sethearth", 1417, 73.84, 32.46 }, -- lier la pierre de foyer
    { "turnin", 655, xp = 270 }, -- Hammerfall (lvl 34, ~270 xp, sim lvl 31)
    { "accept", 672 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "accept", 671 }, -- Foul Magics (lvl 33, ~2650 xp, sim lvl 31)
    { "accept", 95663, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Dragonmaw Rumors (lvl 31, ~0 xp, sim lvl 31)
    { "complete", 672, at = { 1417, 66.71, 38.36 } }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 31)
    { "complete", 676, at = { 1417, 35.32, 42.95 } }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "complete", 671, at = { 1417, 32.11, 28.4 } }, -- Foul Magics (lvl 33, ~2650 xp, sim lvl 31)
    { "hearth", 1417 }, -- pierre de foyer
    { "turnin", 676, xp = 2550 }, -- The Hammer May Fall (lvl 32, ~2550 xp, sim lvl 31)
    { "turnin", 672, xp = 2700 }, -- Raising Spirits (lvl 34, ~2700 xp, sim lvl 32)
    { "turnin", 671, xp = 2650 }, -- Foul Magics (lvl 33, ~2650 xp, sim lvl 32)
    { "accept", 674 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "turnin", 674, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "accept", 675 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "turnin", 675, xp = 270 }, -- Raising Spirits (lvl 34, ~270 xp, sim lvl 32)
    { "goto", 1437, 47.79, 56.16, optional = true, dungeon = "Excavation Site: Wetlands", note = "Dungeon: Excavation Site: Wetlands (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "EXCAVATION" }, -- déplacement
    { "turnin", 95663, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Dragonmaw Rumors (lvl 31, ~625 xp, sim lvl 32)
    { "accept", 95664, optional = true, dungeon = "Excavation Site: Wetlands", note = "Starts inside the dungeon", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 32)
    { "complete", 95664, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 32)
    { "turnin", 95664, xp = 1250, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Elder Knowledge (lvl 31, ~1250 xp, sim lvl 32)
    { "goto", 1416, 8.46, 59.21, optional = true, dungeon = "City of Dalaran", note = "Dungeon: City of Dalaran (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DALARAN" }, -- déplacement
    { "complete", 96984, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Heart of Disruption (lvl 33, ~1325 xp, sim lvl 32)
    { "complete", 96986, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- The Grave Knight (lvl 33, ~1325 xp, sim lvl 32)
    { "complete", 96988, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Source of Power (lvl 33, ~1325 xp, sim lvl 32)
    { "turnin", 96984, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Heart of Disruption (lvl 33, ~1325 xp, sim lvl 32)
    { "turnin", 96986, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- The Grave Knight (lvl 33, ~1325 xp, sim lvl 32)
    { "turnin", 96988, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Source of Power (lvl 33, ~1325 xp, sim lvl 32)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Graveyard (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_GY" }, -- déplacement
    { "accept", 1051, optional = true, dungeon = "Scarlet Monastery", note = "Starts inside the dungeon", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 32)
    { "complete", 1051, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 32)
    { "turnin", 1051, xp = 1650, optional = true, dungeon = "Scarlet Monastery", phase = "run", rung = "SM_GY" }, -- Vorrel's Revenge (lvl 33, ~1650 xp, sim lvl 32)
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Library (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SM_LIB" }, -- déplacement
  },
})
