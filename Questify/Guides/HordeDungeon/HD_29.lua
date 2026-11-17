local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 10 étapes, niveau final 56.00, ~0 xp/h, 9 min.
Q:RegisterGuide({
  id = "HD_29",
  title = "Feralas",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 56, maxLevel = 57,
  next = "HD_30",
  sim = { steps = 10, endLevel = 56.00, xpPerHour = 0, minutes = 9 },
  steps = {
    { "accept", 7489, optional = true, dungeon = "Dire Maul", phase = "prep", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~0 xp, sim lvl 56)
    { "accept", 7441, optional = true, dungeon = "Dire Maul", phase = "prep", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~0 xp, sim lvl 56)
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: East (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_EAST" }, -- déplacement
    { "complete", 7441, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~3875 xp, sim lvl 56)
    { "complete", 7489, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~3775 xp, sim lvl 56)
    { "turnin", 7441, at = { 1444, 76.91, 37.35 }, xp = 3875, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~3875 xp, sim lvl 56)
    { "turnin", 7489, at = { 1444, 76.18, 43.83 }, xp = 3775, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~3775 xp, sim lvl 56)
    { "turnin", 7492, at = { 1444, 76.18, 43.83 }, xp = 750, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Camp Mojache (lvl 57, ~750 xp, sim lvl 56)
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: West (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_WEST" }, -- déplacement
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: North (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_NORTH" }, -- déplacement
  },
})
