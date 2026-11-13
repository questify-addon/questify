local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 23 étapes, niveau final 30.00, ~30112 xp/h, 171 min.
Q:RegisterGuide({
  id = "AD_09",
  title = "Hillsbrad Foothills and Alterac Mountains",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 28, maxLevel = 30,
  next = "AD_10",
  sim = { steps = 23, endLevel = 30.00, xpPerHour = 30112, minutes = 171 },
  steps = {
    { "accept", 98071 }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 28)
    { "fp", 1424, 49.34, 52.27 }, -- point de vol
    { "accept", 98059 }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 28)
    { "complete", 98059, at = { 1424, 29.7, 41.6 } }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 28)
    { "accept", 95534, at = { 1416, 61.77, 43.22 }, note = "Loot Singed Note to start the quest (20.0 % drop: about 5 kills)" }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 28)
    { "accept", 510 }, -- Foreboding Plans (lvl 34, ~1350 xp, sim lvl 28)
    { "turnin", 95534, xp = 2800 }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 28)
    { "complete", 98071, at = { 1424, 70, 79 } }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 28)
    { "turnin", 98071, xp = 2200 }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 28)
    { "accept", 92458, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- Heart of Disruption (lvl 33, ~0 xp, sim lvl 28)
    { "accept", 92457, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- Starving Arcane (lvl 33, ~0 xp, sim lvl 28)
    { "turnin", 510, xp = 1350 }, -- Foreboding Plans (lvl 34, ~1350 xp, sim lvl 28)
    { "turnin", 98059, xp = 2200 }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 28)
    { "level", 30, at = { 1416, 15.76, 68.24 }, note = "About 430 more mobs here (Adorean Lew, level 28)" }, -- farm de niveau
    { "goto", 1416, 8.46, 59.21, optional = true, dungeon = "City of Dalaran", note = "Dungeon: City of Dalaran (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "DALARAN" }, -- déplacement
    { "complete", 92456, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- A Green Sample (lvl 33, ~1325 xp, sim lvl 30)
    { "complete", 92457, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Starving Arcane (lvl 33, ~1325 xp, sim lvl 30)
    { "complete", 92458, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Heart of Disruption (lvl 33, ~1325 xp, sim lvl 30)
    { "complete", 92489, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Power Overwhelming (lvl 33, ~1325 xp, sim lvl 30)
    { "turnin", 92457, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Starving Arcane (lvl 33, ~1325 xp, sim lvl 30)
    { "turnin", 92458, xp = 1325, optional = true, dungeon = "City of Dalaran", phase = "run", rung = "DALARAN" }, -- Heart of Disruption (lvl 33, ~1325 xp, sim lvl 30)
    { "goto", 1421, 44.8, 67.8, optional = true, dungeon = "Shadowfang Keep", note = "Dungeon: Shadowfang Keep (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "SFK" }, -- déplacement
    { "goto", 1420, 82.6, 33.8, optional = true, dungeon = "Scarlet Monastery", note = "Dungeon: Scarlet Monastery: Graveyard (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "SM_GY" }, -- déplacement
  },
})
