local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 5 étapes, niveau final 60.00, ~0 xp/h, 19 min.
Q:RegisterGuide({
  id = "AD_34",
  title = "Silithus",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 59, maxLevel = 60,
  sim = { steps = 5, endLevel = 60.00, xpPerHour = 0, minutes = 19 },
  steps = {
    { "hearth", 1434, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- déplacement
    { "fly", 1449, node = 79, note = "Marshal's Refuge, Un'Goro Crater", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- vol
    { "fp", 1451, 50.58, 34.45, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- point de vol
  },
})
