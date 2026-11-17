local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 41 étapes, niveau final 60.00, ~60422 xp/h, 402 min.
Q:RegisterGuide({
  id = "HD_33",
  title = "Silithus",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 59, maxLevel = 60,
  sim = { steps = 41, endLevel = 60.00, xpPerHour = 60422, minutes = 402 },
  steps = {
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- déplacement
    { "fly", 1444, node = 42, note = "Camp Mojache, Feralas", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- vol
    { "fp", 1451, 48.68, 36.67, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- point de vol
    { "accept", 8284, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 9416, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Report to General Kirika (lvl 60, ~6600 xp, sim lvl 58)
    { "accept", 8304, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 8284, at = { 1451, 22.09, 10.4 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 8284, xp = 6200, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Mystery (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 8285, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Deserter (lvl 59, ~4800 xp, sim lvl 58)
    { "accept", 8280, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 58)
    { "accept", 8277, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 58)
    { "turnin", 8285, xp = 4800, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Deserter (lvl 59, ~4800 xp, sim lvl 58)
    { "accept", 8279, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 58)
    { "complete", 8277, at = { 1451, 64.64, 30.1 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 58)
    { "complete", 8280, at = { 1451, 56.05, 29.94 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 58)
    { "turnin", 8280, xp = 5650, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Securing the Supply Lines (lvl 55, ~5650 xp, sim lvl 58)
    { "accept", 8281, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 58)
    { "turnin", 8277, xp = 5650, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Deadly Desert Venom (lvl 55, ~5650 xp, sim lvl 58)
    { "complete", 8279, obj = 3, at = { 1451, 40.86, 42.22 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 58)
    { "complete", 8281, at = { 1451, 30.56, 43.71 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 58)
    { "complete", 8279, obj = 1, at = { 1451, 26.35, 36.62 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 58)
    { "accept", 8308, at = { 1451, 25.19, 61.73 }, note = "Loot Brann Bronzebeard's Lost Letter to start the quest (0.4 % drop: about 225 kills)", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Brann Bronzebeard's Lost Letter (lvl 60, ~8300 xp, sim lvl 58)
    { "complete", 8279, at = { 1451, 16.09, 86.37 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 58)
    { "complete", 8304, at = { 1451, 40.81, 88.86 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 8308, xp = 8300, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Brann Bronzebeard's Lost Letter (lvl 60, ~8300 xp, sim lvl 58)
    { "accept", 9422, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 9416, xp = 6600, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Report to General Kirika (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 9422, at = { 1451, 50.93, 69.33 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 9422, xp = 6600, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Scouring the Desert (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 8279, xp = 8300, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- The Twilight Lexicon (lvl 60, ~8300 xp, sim lvl 58)
    { "accept", 8287, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- A Terrible Purpose (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 8281, xp = 6000, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Stepping Up Security (lvl 57, ~6000 xp, sim lvl 58)
    { "turnin", 8287, xp = 6600, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- A Terrible Purpose (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 8304, xp = 6600, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Dearest Natalia (lvl 60, ~6600 xp, sim lvl 58)
    { "goto", 1451, 48.68, 36.67, note = "Flight master", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- déplacement
    { "fly", 1452, node = 53, note = "Everlook, Winterspring", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- vol
    { "accept", 5055, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "complete", 5055, at = { 1452, 62.54, 57.9 }, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 5055, xp = 6200, alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- Brumeran of the Chillwind (lvl 58, ~6200 xp, sim lvl 58)
    { "level", 60, at = { 1452, 66.97, 37.93 }, note = "About 685 more mobs here (Winterfall Ursa, level 57)", alt = { "STRAT_LIVE", "STRAT_UD" }, below = 60 }, -- farm de niveau
  },
})
