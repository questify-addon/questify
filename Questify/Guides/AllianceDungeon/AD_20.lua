local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 25 étapes, niveau final 43.00, ~0 xp/h, 18 min.
Q:RegisterGuide({
  id = "AD_20",
  title = "Desolace",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 42, maxLevel = 44,
  next = "AD_21",
  sim = { steps = 25, endLevel = 43.00, xpPerHour = 0, minutes = 18 },
  steps = {
    { "hearth", 1431, phase = "prep", rung = "MARAUDON" }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master", phase = "prep", rung = "MARAUDON" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn", phase = "prep", rung = "MARAUDON" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)", phase = "prep", rung = "MARAUDON" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master", phase = "prep", rung = "MARAUDON" }, -- déplacement
    { "fly", 1443, node = 37, note = "Nijel's Point, Desolace", phase = "prep", rung = "MARAUDON" }, -- vol
    { "accept", 7041, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~0 xp, sim lvl 43)
    { "accept", 7028, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~0 xp, sim lvl 43)
    { "accept", 7044, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~0 xp, sim lvl 43)
    { "goto", 1443, 29.1, 62.5, optional = true, dungeon = "Maraudon", note = "Dungeon: Maraudon (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "MARAUDON" }, -- déplacement
    { "complete", 7028, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~2625 xp, sim lvl 43)
    { "complete", 7041, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~2625 xp, sim lvl 43)
    { "complete", 7044, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~1700 xp, sim lvl 43)
    { "complete", 7067, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~2725 xp, sim lvl 43)
    { "complete", 7070, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Shadowshard Fragments (lvl 42, ~1725 xp, sim lvl 43)
    { "turnin", 7044, xp = 1700, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Legends of Maraudon (lvl 49, ~1700 xp, sim lvl 43)
    { "turnin", 7028, at = { 1443, 62.2, 39.63 }, xp = 2625, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Twisted Evils (lvl 47, ~2625 xp, sim lvl 43)
    { "turnin", 7041, at = { 1443, 68.5, 8.88 }, xp = 2625, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Vyletongue Corruption (lvl 47, ~2625 xp, sim lvl 43)
    { "turnin", 7067, at = { 1443, 50.42, 86.65 }, xp = 2725, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~2725 xp, sim lvl 43)
    { "turnin", 7070, at = { 1445, 66.42, 49.26 }, xp = 1725, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Shadowshard Fragments (lvl 42, ~1725 xp, sim lvl 43)
    { "accept", 7046, optional = true, dungeon = "Maraudon", note = "Starts inside the dungeon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 43)
    { "accept", 7066, optional = true, dungeon = "Maraudon", note = "Starts inside the dungeon", phase = "run", rung = "MARAUDON" }, -- Seed of Life (lvl 51, ~3050 xp, sim lvl 43)
    { "complete", 7046, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 43)
    { "turnin", 7046, xp = 2850, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- The Scepter of Celebras (lvl 49, ~2850 xp, sim lvl 43)
    { "turnin", 7066, at = { 1450, 36.18, 41.79 }, xp = 3050, optional = true, dungeon = "Maraudon", phase = "run", rung = "MARAUDON" }, -- Seed of Life (lvl 51, ~3050 xp, sim lvl 43)
  },
})
