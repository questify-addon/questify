local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 21 étapes, niveau final 44.13, ~0 xp/h, 20 min.
Q:RegisterGuide({
  id = "HD_18",
  title = "Desolace",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 42, maxLevel = 45,
  next = "HD_19",
  sim = { steps = 21, endLevel = 44.13, xpPerHour = 0, minutes = 20 },
  steps = {
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)", phase = "prep", rung = "MARAUDON" }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master", phase = "prep", rung = "MARAUDON" }, -- déplacement
    { "fly", 1443, node = 38, note = "Shadowprey Village, Desolace", phase = "prep", rung = "MARAUDON" }, -- vol
    { "accept", 7029, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~0 xp, sim lvl 44)
    { "accept", 7067, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~0 xp, sim lvl 44)
    { "accept", 7028, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~0 xp, sim lvl 44)
    { "accept", 7044, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~0 xp, sim lvl 44)
    { "goto", 1443, 29.1, 62.5, optional = true, dungeon = "Maraudon", note = "Dungeon: Maraudon (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "MARAUDON" }, -- déplacement
    { "complete", 7028, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~2625 xp, sim lvl 44)
    { "complete", 7029, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~2625 xp, sim lvl 44)
    { "complete", 7044, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~1700 xp, sim lvl 44)
    { "complete", 7067, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~2725 xp, sim lvl 44)
    { "turnin", 7044, xp = 1700, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~1700 xp, sim lvl 44)
    { "turnin", 7028, at = { 1443, 62.2, 39.63 }, xp = 2625, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~2625 xp, sim lvl 44)
    { "turnin", 7029, at = { 1443, 23.22, 70.33 }, xp = 2625, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~2625 xp, sim lvl 44)
    { "turnin", 7067, at = { 1443, 50.42, 86.65 }, xp = 2725, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~2725 xp, sim lvl 44)
    { "accept", 7046, optional = true, dungeon = "Maraudon", note = "Starts inside the dungeon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 44)
    { "accept", 7066, optional = true, dungeon = "Maraudon", note = "Starts inside the dungeon", phase = "run", rung = "MARAUDON" }, -- Seed of Life (lvl 51, ~3050 xp, sim lvl 44)
    { "complete", 7046, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 44)
    { "turnin", 7046, xp = 2850, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 44)
    { "turnin", 7066, at = { 1450, 36.18, 41.79 }, xp = 3050, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Seed of Life (lvl 51, ~3050 xp, sim lvl 44)
  },
})
