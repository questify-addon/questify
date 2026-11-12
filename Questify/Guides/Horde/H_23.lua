local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 34 étapes, niveau final 52.00, ~61878 xp/h, 149 min.
Q:RegisterGuide({
  id = "H_23",
  title = "Blasted Lands",
  faction = "Horde",
  minLevel = 51, maxLevel = 52,
  next = "H_24",
  sim = { steps = 34, endLevel = 52.00, xpPerHour = 61878, minutes = 149 },
  steps = {
    { "note", "Not running Zul'Farrak? Abandon Divino-matic Rod, Tiara of the Deep", optional = true, dungeon = "Zul'Farrak" },
    { "hearth", 1434 }, -- pierre de foyer
    { "goto", 1434, 32.54, 29.35, note = "Flight master" }, -- déplacement
    { "fly", 1435, node = 56, note = "Stonard, Swamp of Sorrows" }, -- vol
    { "accept", 2581 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2585 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2583 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2603 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 2601 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 81917 }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "accept", 81919 }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "complete", 2585, at = { 1419, 47.8, 20.03 } }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2583, obj = 2, at = { 1419, 47.74, 21.26 } }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2581, obj = 3, at = { 1419, 46.16, 21.89 } }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2601, at = { 1419, 45.74, 22.7 } }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2585, at = { 1419, 45.68, 35.17 } }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2581, at = { 1419, 47.37, 36.25 } }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 81919, at = { 1419, 51.04, 36.74 } }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "complete", 2583, obj = 1, at = { 1419, 51.94, 38.22 } }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 2603, at = { 1419, 55.15, 36.6 } }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "accept", 93685 }, -- To Serve Kum'isha (lvl 55, ~1400 xp, sim lvl 51)
    { "turnin", 93685, xp = 1400 }, -- To Serve Kum'isha (lvl 55, ~1400 xp, sim lvl 51)
    { "accept", 81956 }, -- Conjurer's Codex (lvl 45, ~0 xp, sim lvl 51)
    { "complete", 81956, at = { 1419, 55.43, 32.3 } }, -- Conjurer's Codex (lvl 45, ~0 xp, sim lvl 51)
    { "complete", 2583, at = { 1419, 59.86, 38.52 } }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "complete", 81917, at = { 1419, 65.88, 31.89 } }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 81919, xp = 5450 }, -- Brought to Heel (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 81917, xp = 5450 }, -- Chains That Bind (lvl 54, ~5450 xp, sim lvl 51)
    { "turnin", 2601, xp = 4700 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2603, xp = 4700 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2583, xp = 4700 }, -- A Boar's Vitality (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2585, xp = 4700 }, -- The Decisive Striker (lvl 50, ~4700 xp, sim lvl 51)
    { "turnin", 2581, xp = 4700 }, -- Snickerfang Jowls (lvl 50, ~4700 xp, sim lvl 51)
    { "level", 52, at = { 1419, 45.89, 36.17 }, note = "About 192 more mobs here (Helboar, level 52)" }, -- farm de niveau
  },
})
