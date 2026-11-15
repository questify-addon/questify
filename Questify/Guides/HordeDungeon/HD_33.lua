local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 5 étapes, niveau final 60.00, ~0 xp/h, 20 min.
Q:RegisterGuide({
  id = "HD_33",
  title = "Silithus",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 59, maxLevel = 60,
  sim = { steps = 5, endLevel = 60.00, xpPerHour = 0, minutes = 20 },
  steps = {
    { "hearth", 1434, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- pierre de foyer
    { "boat", 1434, 31.43, 29.91, note = "Take the zeppelin to Orgrimmar (Durotar)", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- déplacement
    { "fly", 1444, node = 42, note = "Camp Mojache, Feralas", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- vol
    { "fp", 1451, 48.68, 36.67, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- point de vol
  },
})
