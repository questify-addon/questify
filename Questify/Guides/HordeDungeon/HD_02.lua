local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 12 étapes, niveau final 16.22, ~3432 xp/h, 12 min.
Q:RegisterGuide({
  id = "HD_02",
  title = "Orgrimmar",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 15, maxLevel = 17,
  next = "HD_03",
  sim = { steps = 12, endLevel = 16.22, xpPerHour = 3432, minutes = 12 },
  steps = {
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", phase = "prep", rung = "RFC" }, -- vol
    { "fp", 1454, 45.12, 63.89, phase = "prep", rung = "RFC" }, -- point de vol
    { "turnin", 6384, xp = 335, race = { "Orc", "Troll" }, phase = "prep", rung = "RFC" }, -- Ride to Orgrimmar (lvl 10, ~335 xp, sim lvl 16)
    { "turnin", 3923, xp = 340, phase = "prep", rung = "RFC" }, -- Rilli Greasygob (lvl 18, ~340 xp, sim lvl 16)
    { "accept", 1061, phase = "prep", rung = "RFC" }, -- The Spirits of Stonetalon (lvl 17, ~0 xp, sim lvl 16)
    { "accept", 2379, classes = { "ROGUE" }, phase = "prep", rung = "RFC" }, -- Zando'zan (lvl 16, ~580 xp, sim lvl 16)
    { "turnin", 2379, xp = 580, classes = { "ROGUE" }, phase = "prep", rung = "RFC" }, -- Zando'zan (lvl 16, ~580 xp, sim lvl 16)
    { "goto", 1454, 52.6, 49, optional = true, dungeon = "Ragefire Chasm", note = "Dungeon: Ragefire Chasm (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "RFC" }, -- déplacement
    { "complete", 5728, race = { "Orc", "Troll" }, optional = true, dungeon = "Ragefire Chasm", phase = "run", rung = "RFC" }, -- Hidden Enemies (lvl 16, ~575 xp, sim lvl 16)
    { "complete", 5761, race = { "Orc", "Troll" }, optional = true, dungeon = "Ragefire Chasm", phase = "run", rung = "RFC" }, -- Slaying the Beast (lvl 16, ~575 xp, sim lvl 16)
    { "turnin", 5728, at = { 1454, 31.73, 37.82 }, xp = 575, race = { "Orc", "Troll" }, optional = true, dungeon = "Ragefire Chasm", phase = "run", rung = "RFC" }, -- Hidden Enemies (lvl 16, ~575 xp, sim lvl 16)
    { "turnin", 5761, at = { 1454, 49.47, 50.59 }, xp = 575, race = { "Orc", "Troll" }, optional = true, dungeon = "Ragefire Chasm", phase = "run", rung = "RFC" }, -- Slaying the Beast (lvl 16, ~575 xp, sim lvl 16)
  },
})
