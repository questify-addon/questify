local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 74 étapes, niveau final 21.40, ~19443 xp/h, 125 min.
Q:RegisterGuide({
  id = "AD_04",
  title = "Ashenvale and Stonetalon Mountains",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 19, maxLevel = 21,
  next = "AD_05",
  sim = { steps = 74, endLevel = 21.40, xpPerHour = 19443, minutes = 125 },
  steps = {
    { "goto", 1436, 56.55, 52.64, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "fp", 1440, 34.41, 47.99 }, -- point de vol
    { "turnin", 990, xp = 365 }, -- Trek to Ashenvale (lvl 19, ~365 xp, sim lvl 19)
    { "accept", 991 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 19)
    { "accept", 1008 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 19)
    { "accept", 1070 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 19)
    { "turnin", 945, xp = 1350 }, -- Therylune's Escape (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 991, xp = 1450 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 19)
    { "complete", 1008, at = { 1440, 12.08, 28.68 } }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 19)
    { "turnin", 967, xp = 1000 }, -- The Tower of Althalaxx (lvl 18, ~1000 xp, sim lvl 19)
    { "accept", 1010 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "complete", 1010, at = { 1440, 31.5, 23.36 } }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "turnin", 5713, xp = 1050 }, -- One Shot.  One Kill. (lvl 15, ~1050 xp, sim lvl 20)
    { "turnin", 1010, xp = 780 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "accept", 1020 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 1008, xp = 1450 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 20)
    { "accept", 1134 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1020, xp = 1950 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "complete", 1134, at = { 1442, 53.55, 37.28 } }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1070, xp = 830 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 20)
    { "accept", 1085 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 20)
    { "turnin", 1085, xp = 165 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 20)
    { "accept", 1071 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 78149 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 20)
    { "complete", 78149, at = { 1442, 74.4, 85.7 } }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 20)
    { "fp", 1413, 63.08, 37.16 }, -- point de vol
    { "accept", 1069 }, -- Deepmoss Spider Eggs (lvl 20, ~1950 xp, sim lvl 20)
    { "sethearth", 1413, 62.05, 39.41 }, -- lier la pierre de foyer
    { "accept", 1221, optional = true, dungeon = "Razorfen Kraul", phase = "prep", rung = "RFK" }, -- Blueleaf Tubers (lvl 26, ~0 xp, sim lvl 20)
    { "accept", 959, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~0 xp, sim lvl 20)
    { "accept", 1483 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 20)
    { "accept", 79097 }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 20)
    { "complete", 79097, at = { 1413, 62.7, 36.3 } }, -- Baxtan: On Destructive Magics (lvl 20, ~0 xp, sim lvl 20)
    { "accept", 1090 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "complete", 1090, at = { 1442, 71.87, 60 } }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "turnin", 1090, xp = 2200 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "accept", 1092 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "complete", 1071, at = { 1442, 66.63, 51.24 } }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1092, xp = 1300 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "turnin", 1483, xp = 415 }, -- Ziz Fizziks (lvl 21, ~415 xp, sim lvl 20)
    { "accept", 1093 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 20)
    { "complete", 1093, at = { 1442, 62.38, 53.01 } }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 78270, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 20)
    { "complete", 78270, at = { 1442, 65.98, 50.52 }, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 20)
    { "turnin", 78270, xp = 1850, classes = { "ROGUE" } }, -- Goblin Lockpicks (lvl 23, ~1850 xp, sim lvl 20)
    { "turnin", 1093, xp = 1650 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 1094 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 21)
    { "turnin", 1071, xp = 1650 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 1075 }, -- A Scroll from Mauren (lvl 21, ~0 xp, sim lvl 21)
    { "complete", 1069, at = { 1442, 53.49, 73.76 } }, -- Deepmoss Spider Eggs (lvl 20, ~1950 xp, sim lvl 21)
    { "accept", 86574 }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "complete", 86574, at = { 1442, 53.57, 37.23 } }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "fp", 1442, 36.44, 7.18 }, -- point de vol
    { "turnin", 86574, xp = 1950 }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "goto", 1442, 36.44, 7.18, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 28, note = "Astranaar, Ashenvale" }, -- vol
    { "turnin", 1134, xp = 1650 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 21)
    { "hearth", 1413 }, -- pierre de foyer
    { "turnin", 1094, xp = 830 }, -- Further Instructions (lvl 21, ~830 xp, sim lvl 21)
    { "turnin", 1069, xp = 1950 }, -- Deepmoss Spider Eggs (lvl 20, ~1950 xp, sim lvl 21)
    { "accept", 1486, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Deviate Hides (lvl 17, ~0 xp, sim lvl 21)
    { "accept", 1487, optional = true, dungeon = "Wailing Caverns", phase = "prep", rung = "WC" }, -- Deviate Eradication (lvl 21, ~0 xp, sim lvl 21)
    { "goto", 1413, 46, 36.5, optional = true, dungeon = "Wailing Caverns", note = "Dungeon: Wailing Caverns (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "WC" }, -- déplacement
    { "complete", 959, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~675 xp, sim lvl 21)
    { "complete", 1486, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Hides (lvl 17, ~800 xp, sim lvl 21)
    { "complete", 1487, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Eradication (lvl 21, ~1025 xp, sim lvl 21)
    { "turnin", 959, xp = 675, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Trouble at the Docks (lvl 18, ~675 xp, sim lvl 21)
    { "turnin", 1486, xp = 800, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Hides (lvl 17, ~800 xp, sim lvl 21)
    { "turnin", 1487, xp = 1025, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- Deviate Eradication (lvl 21, ~1025 xp, sim lvl 21)
    { "accept", 6981, optional = true, dungeon = "Wailing Caverns", note = "Starts inside the dungeon", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 21)
    { "complete", 6981, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 21)
    { "turnin", 6981, xp = 1325, optional = true, dungeon = "Wailing Caverns", phase = "run", rung = "WC" }, -- The Glowing Shard (lvl 26, ~1325 xp, sim lvl 21)
  },
})
