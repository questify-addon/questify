local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 3 étapes, niveau final 51.00, ~0 xp/h, 3 min.
Q:RegisterGuide({
  id = "AD_26",
  title = "Swamp of Sorrows",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 50, maxLevel = 52,
  next = "AD_27",
  sim = { steps = 3, endLevel = 51.00, xpPerHour = 0, minutes = 3 },
  steps = {
    { "goto", 1435, 69.9, 53.5, optional = true, dungeon = "The Temple of Atal'Hakkar", note = "Dungeon: The Temple of Atal'Hakkar (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "ST" }, -- déplacement
    { "complete", 1446, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "run", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~3275 xp, sim lvl 51)
    { "turnin", 1446, xp = 3275, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "run", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~3275 xp, sim lvl 51)
  },
})
