local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 28 étapes, niveau final 52.00, ~65000 xp/h, 139 min.
Q:RegisterGuide({
  id = "HD_24",
  title = "Blasted Lands",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 51, maxLevel = 52,
  next = "HD_25",
  sim = { steps = 28, endLevel = 52.00, xpPerHour = 65000, minutes = 139 },
  steps = {
    { "accept", 2601, alt = "ST", below = 52 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 81917, alt = "ST", below = 52 }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "accept", 2603, alt = "ST", below = 52 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 81919, alt = "ST", below = 52 }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "accept", 2581, alt = "ST", below = 52 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2583, alt = "ST", below = 52 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2585, alt = "ST", below = 52 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2585, at = { 1419, 47.8, 20.03 }, alt = "ST", below = 52 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2583, obj = 2, at = { 1419, 47.74, 21.26 }, alt = "ST", below = 52 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2581, obj = 3, at = { 1419, 46.16, 21.89 }, alt = "ST", below = 52 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2601, at = { 1419, 45.74, 22.7 }, alt = "ST", below = 52 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2585, at = { 1419, 45.68, 35.17 }, alt = "ST", below = 52 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2581, at = { 1419, 47.37, 36.25 }, alt = "ST", below = 52 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 81919, at = { 1419, 51.04, 36.74 }, alt = "ST", below = 52 }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "accept", 93685, alt = "ST", below = 52 }, -- To Serve Kum'isha (lvl 55, ~1400 xp, sim lvl 51)
    { "turnin", 93685, xp = 1400, alt = "ST", below = 52 }, -- To Serve Kum'isha (lvl 55, ~1400 xp, sim lvl 51)
    { "complete", 2583, obj = 1, at = { 1419, 51.94, 38.22 }, alt = "ST", below = 52 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2603, at = { 1419, 55.15, 36.6 }, alt = "ST", below = 52 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2583, at = { 1419, 59.86, 38.52 }, alt = "ST", below = 52 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 81917, at = { 1419, 65.88, 31.89 }, alt = "ST", below = 52 }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 2601, xp = 4700, alt = "ST", below = 52 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2603, xp = 4700, alt = "ST", below = 52 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 81917, xp = 5450, alt = "ST", below = 52 }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 81919, xp = 5450, alt = "ST", below = 52 }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 2583, xp = 4700, alt = "ST", below = 52 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2581, xp = 4700, alt = "ST", below = 52 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2585, xp = 4700, alt = "ST", below = 52 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "level", 52, at = { 1419, 45.89, 36.17 }, note = "About 182 more mobs here (Helboar, level 52)", alt = "ST", below = 52 }, -- farm de niveau
  },
})
