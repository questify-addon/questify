local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 60 étapes, niveau final 28.32, ~21543 xp/h, 145 min.
Q:RegisterGuide({
  id = "HD_08",
  title = "Hillsbrad Foothills",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 27, maxLevel = 29,
  next = "HD_09",
  sim = { steps = 60, endLevel = 28.32, xpPerHour = 21543, minutes = 145 },
  steps = {
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "boat", 1411, 50.8, 13.5, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "fp", 1424, 60.14, 18.62 }, -- point de vol
    { "accept", 527 }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 27)
    { "accept", 549 }, -- WANTED: Syndicate Personnel (lvl 22, ~1750 xp, sim lvl 27)
    { "accept", 96986, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- The Grave Knight (lvl 33, ~0 xp, sim lvl 27)
    { "accept", 498 }, -- The Rescue (lvl 22, ~2200 xp, sim lvl 27)
    { "accept", 567 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 27)
    { "sethearth", 1424, 62.78, 19.03 }, -- lier la pierre de foyer
    { "accept", 501 }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 27)
    { "accept", 509 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 27)
    { "complete", 527, at = { 1424, 33.86, 37.58 } }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 527, xp = 1950 }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 27)
    { "accept", 528 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 27)
    { "accept", 546 }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 27)
    { "complete", 528, at = { 1424, 35, 45.59 } }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 27)
    { "complete", 567, obj = 4, at = { 1424, 35.88, 46.57 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 27)
    { "complete", 501, at = { 1424, 51.78, 34.17 } }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 528, xp = 2000 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 27)
    { "accept", 98094 }, -- Scout Support (lvl 25, ~1000 xp, sim lvl 27)
    { "accept", 529 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 27)
    { "turnin", 501, xp = 1950 }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 27)
    { "accept", 502 }, -- Elixir of Pain (lvl 24, ~2900 xp, sim lvl 27)
    { "complete", 567, at = { 1424, 29.51, 42.41 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 27)
    { "complete", 529, at = { 1424, 32.11, 44.42 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 27)
    { "complete", 567, at = { 1424, 31.8, 52.7 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 27)
    { "complete", 509, at = { 1424, 64.39, 61.33 } }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 27)
    { "turnin", 98094, xp = 1000 }, -- Scout Support (lvl 25, ~1000 xp, sim lvl 27)
    { "accept", 98095 }, -- Valuable Vantages (lvl 25, ~2000 xp, sim lvl 27)
    { "turnin", 98095, xp = 2000 }, -- Valuable Vantages (lvl 25, ~2000 xp, sim lvl 27)
    { "complete", 549, at = { 1424, 80.07, 45.06 } }, -- WANTED: Syndicate Personnel (lvl 22, ~1750 xp, sim lvl 27)
    { "complete", 546, at = { 1424, 79.76, 44.4 } }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 27)
    { "complete", 498, at = { 1424, 75.33, 41.5 } }, -- The Rescue (lvl 22, ~2200 xp, sim lvl 27)
    { "turnin", 498, xp = 2200 }, -- The Rescue (lvl 22, ~2200 xp, sim lvl 27)
    { "turnin", 529, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 27)
    { "accept", 532 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 27)
    { "turnin", 549, xp = 1750 }, -- WANTED: Syndicate Personnel (lvl 22, ~1750 xp, sim lvl 27)
    { "turnin", 567, xp = 2300 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 27)
    { "turnin", 546, xp = 2550 }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 27)
    { "turnin", 509, xp = 2300 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 28)
    { "turnin", 502, xp = 2900 }, -- Elixir of Pain (lvl 24, ~2900 xp, sim lvl 28)
    { "complete", 532, at = { 1424, 29.67, 41.64 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 532, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "accept", 539 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 28)
    { "complete", 539, at = { 1424, 31.21, 56.01 } }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 28)
    { "turnin", 539, xp = 2300 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 28)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "accept", 96988, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- Source of Power (lvl 33, ~0 xp, sim lvl 28)
    { "fp", 1421, 45.62, 42.6 }, -- point de vol
    { "accept", 1014, optional = true, dungeon = "Shadowfang Keep", phase = "prep", rung = "SFK" }, -- Arugal Must Die (lvl 27, ~0 xp, sim lvl 28)
    { "accept", 1098, optional = true, dungeon = "Shadowfang Keep", phase = "prep", rung = "SFK" }, -- Deathstalkers in Shadowfang (lvl 25, ~0 xp, sim lvl 28)
    { "goto", 1421, 44.8, 67.8, optional = true, dungeon = "Shadowfang Keep", note = "Dungeon: Shadowfang Keep (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "SFK" }, -- déplacement
    { "complete", 1013, optional = true, dungeon = "Shadowfang Keep", phase = "run", rung = "SFK" }, -- The Book of Ur (lvl 26, ~1050 xp, sim lvl 28)
    { "complete", 1014, optional = true, dungeon = "Shadowfang Keep", phase = "run", rung = "SFK" }, -- Arugal Must Die (lvl 27, ~1650 xp, sim lvl 28)
    { "turnin", 1098, xp = 1000, optional = true, dungeon = "Shadowfang Keep", phase = "run", rung = "SFK" }, -- Deathstalkers in Shadowfang (lvl 25, ~1000 xp, sim lvl 28)
    { "turnin", 1014, at = { 1421, 44.2, 39.81 }, xp = 1650, optional = true, dungeon = "Shadowfang Keep", phase = "run", rung = "SFK" }, -- Arugal Must Die (lvl 27, ~1650 xp, sim lvl 28)
    { "turnin", 1013, at = { 1458, 53.74, 54.46 }, xp = 1050, optional = true, dungeon = "Shadowfang Keep", phase = "run", rung = "SFK" }, -- The Book of Ur (lvl 26, ~1050 xp, sim lvl 28)
  },
})
