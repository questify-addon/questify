local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 38 étapes, niveau final 27.69, ~20140 xp/h, 75 min.
Q:RegisterGuide({
  id = "AD_08",
  title = "Wetlands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 26, maxLevel = 28,
  next = "AD_09",
  sim = { steps = 38, endLevel = 27.69, xpPerHour = 20140, minutes = 75 },
  steps = {
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor" }, -- bateau
    { "fp", 1437, 9.49, 59.69 }, -- point de vol
    { "accept", 470 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "accept", 95647, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Lost in the Thicket Things (lvl 31, ~0 xp, sim lvl 27)
    { "accept", 472 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 27)
    { "accept", 305 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 27)
    { "accept", 294 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 305, xp = 970 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 27)
    { "accept", 306 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "accept", 98223 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 27)
    { "accept", 87491 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 27)
    { "turnin", 472, xp = 1200 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 27)
    { "accept", 304, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "turnin", 87491, xp = 2450 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 27)
    { "complete", 304, at = { 1437, 61.9, 29.94 }, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "turnin", 304, xp = 3350, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "complete", 470, at = { 1437, 44.36, 25.54 } }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "complete", 294, at = { 1437, 24.5, 48.38 } }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 306, xp = 485 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "turnin", 98223, xp = 1250 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 27)
    { "accept", 98221 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 27)
    { "turnin", 98221, xp = 2300 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 27)
    { "turnin", 470, xp = 2400 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "accept", 971, optional = true, dungeon = "Blackfathom Deeps", phase = "prep", rung = "BFD" }, -- Knowledge in the Deeps (lvl 23, ~0 xp, sim lvl 27)
    { "accept", 2924, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Essential Artificials (lvl 30, ~0 xp, sim lvl 27)
    { "accept", 2929, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- The Grand Betrayal (lvl 35, ~0 xp, sim lvl 27)
    { "accept", 2927, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- The Day After (lvl 27, ~0 xp, sim lvl 27)
    { "accept", 2922, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Save Techbot's Brain! (lvl 26, ~0 xp, sim lvl 27)
    { "accept", 2930, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Data Rescue (lvl 30, ~0 xp, sim lvl 27)
    { "turnin", 294, xp = 1950 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "goto", 1437, 47.79, 56.16, optional = true, dungeon = "Excavation Site: Wetlands", note = "Dungeon: Excavation Site: Wetlands (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "EXCAVATION" }, -- déplacement
    { "turnin", 95647, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost in the Thicket Things (lvl 31, ~625 xp, sim lvl 27)
    { "turnin", 95737, at = { 1437, 11.88, 58.82 }, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Seeking Caitlin (lvl 31, ~625 xp, sim lvl 27)
    { "accept", 95810, optional = true, dungeon = "Excavation Site: Wetlands", note = "Starts inside the dungeon", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 27)
    { "complete", 95810, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 27)
    { "turnin", 95810, at = { 1437, 38.81, 52.39 }, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 27)
  },
})
