local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 10 étapes, niveau final 51.02, ~9888 xp/h, 20 min.
Q:RegisterGuide({
  id = "HD_23",
  title = "Swamp of Sorrows",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 50, maxLevel = 52,
  next = "HD_24",
  sim = { steps = 10, endLevel = 51.02, xpPerHour = 9888, minutes = 20 },
  steps = {
    { "hearth", 1434, phase = "prep", rung = "ST" }, -- pierre de foyer
    { "fp", 1435, 46.07, 54.83, phase = "prep", rung = "ST" }, -- point de vol
    { "turnin", 624, xp = 1440, phase = "prep", rung = "ST" }, -- Cortello's Riddle (lvl 43, ~1440 xp, sim lvl 51)
    { "accept", 1424, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "prep", rung = "ST" }, -- Pool of Tears (lvl 43, ~1780 xp, sim lvl 51)
    { "complete", 1424, at = { 1435, 72.58, 56.48 }, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "prep", rung = "ST" }, -- Pool of Tears (lvl 43, ~1780 xp, sim lvl 51)
    { "turnin", 1424, xp = 1780, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "prep", rung = "ST" }, -- Pool of Tears (lvl 43, ~1780 xp, sim lvl 51)
    { "goto", 1435, 69.9, 53.5, optional = true, dungeon = "The Temple of Atal'Hakkar", note = "Dungeon: The Temple of Atal'Hakkar (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "ST" }, -- déplacement
    { "complete", 1446, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "run", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~3275 xp, sim lvl 51)
    { "turnin", 1446, xp = 3275, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "run", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~3275 xp, sim lvl 51)
    { "turnin", 3380, xp = 1825, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "run", rung = "ST" }, -- The Sunken Temple (lvl 51, ~1825 xp, sim lvl 51)
  },
})
