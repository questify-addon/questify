local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 40 étapes, niveau final 38.47, ~33285 xp/h, 68 min.
Q:RegisterGuide({
  id = "AD_17",
  title = "Badlands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 37, maxLevel = 39,
  next = "AD_18",
  sim = { steps = 40, endLevel = 38.47, xpPerHour = 33285, minutes = 68 },
  steps = {
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "fp", 1432, 33.94, 50.95 }, -- point de vol
    { "accept", 2198, at = { 1418, 47.68, 11.24 }, optional = true, dungeon = "Uldaman", note = "Loot Shattered Necklace to start the quest (7.1 % drop: about 15 kills)", phase = "prep", rung = "ULDAMAN" }, -- The Shattered Necklace (lvl 41, ~0 xp, sim lvl 38)
    { "accept", 719 }, -- A Dwarf and His Tools (lvl 35, ~2750 xp, sim lvl 38)
    { "accept", 718 }, -- Mirages (lvl 38, ~2150 xp, sim lvl 38)
    { "complete", 718, at = { 1418, 66.6, 22 } }, -- Mirages (lvl 38, ~2150 xp, sim lvl 38)
    { "complete", 719, at = { 1418, 53.23, 32.73 } }, -- A Dwarf and His Tools (lvl 35, ~2750 xp, sim lvl 38)
    { "accept", 720 }, -- A Sign of Hope (lvl 35, ~1350 xp, sim lvl 38)
    { "turnin", 718, xp = 2150 }, -- Mirages (lvl 38, ~2150 xp, sim lvl 38)
    { "turnin", 720, xp = 1350 }, -- A Sign of Hope (lvl 35, ~1350 xp, sim lvl 38)
    { "accept", 721, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- A Sign of Hope (lvl 35, ~0 xp, sim lvl 38)
    { "turnin", 719, xp = 2750 }, -- A Dwarf and His Tools (lvl 35, ~2750 xp, sim lvl 38)
    { "accept", 703 }, -- Barbecued Buzzard Wings (lvl 40, ~2350 xp, sim lvl 38)
    { "accept", 2418, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~0 xp, sim lvl 38)
    { "accept", 710 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 38)
    { "complete", 710, at = { 1418, 20.96, 45.07 } }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 710, xp = 2850 }, -- Study of the Elements: Rock (lvl 37, ~2850 xp, sim lvl 38)
    { "accept", 711 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 38)
    { "complete", 703, at = { 1418, 15.71, 60.94 } }, -- Barbecued Buzzard Wings (lvl 40, ~2350 xp, sim lvl 38)
    { "complete", 711, at = { 1418, 42.98, 80.83 } }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 38)
    { "accept", 709, optional = true, dungeon = "Uldaman", phase = "prep", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~0 xp, sim lvl 38)
    { "turnin", 703, xp = 2350 }, -- Barbecued Buzzard Wings (lvl 40, ~2350 xp, sim lvl 38)
    { "turnin", 711, xp = 3000 }, -- Study of the Elements: Rock (lvl 39, ~3000 xp, sim lvl 38)
    { "goto", 1418, 44.6, 12.1, optional = true, dungeon = "Uldaman", note = "Dungeon: Uldaman (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "ULDAMAN" }, -- déplacement
    { "complete", 709, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~1575 xp, sim lvl 38)
    { "complete", 2418, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~1750 xp, sim lvl 38)
    { "turnin", 709, at = { 1418, 51.39, 76.87 }, xp = 1575, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Solution to Doom (lvl 40, ~1575 xp, sim lvl 38)
    { "turnin", 721, at = { 1418, 37.9, 10.59 }, xp = 1375, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- A Sign of Hope (lvl 35, ~1375 xp, sim lvl 38)
    { "turnin", 2418, at = { 1418, 42.39, 52.93 }, xp = 1750, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- Power Stones (lvl 36, ~1750 xp, sim lvl 38)
    { "turnin", 2198, at = { 1455, 36.38, 3.61 }, xp = 1650, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Shattered Necklace (lvl 41, ~1650 xp, sim lvl 38)
    { "accept", 2240, optional = true, dungeon = "Uldaman", note = "Starts inside the dungeon", phase = "run", rung = "ULDAMAN" }, -- The Hidden Chamber (lvl 40, ~1950 xp, sim lvl 38)
    { "accept", 2278, optional = true, dungeon = "Uldaman", note = "Starts inside the dungeon", phase = "run", rung = "ULDAMAN" }, -- The Platinum Discs (lvl 47, ~2100 xp, sim lvl 38)
    { "complete", 2240, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Hidden Chamber (lvl 40, ~1950 xp, sim lvl 38)
    { "complete", 2278, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Platinum Discs (lvl 47, ~2100 xp, sim lvl 38)
    { "turnin", 2278, xp = 2100, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Platinum Discs (lvl 47, ~2100 xp, sim lvl 38)
    { "turnin", 2240, at = { 1455, 74.64, 11.74 }, xp = 1950, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Hidden Chamber (lvl 40, ~1950 xp, sim lvl 38)
    { "accept", 2279, optional = true, dungeon = "Uldaman", note = "Starts inside the dungeon", phase = "run", rung = "ULDAMAN" }, -- The Platinum Discs (lvl 47, ~2625 xp, sim lvl 38)
    { "turnin", 2279, at = { 1455, 69.93, 18.55 }, xp = 2625, optional = true, dungeon = "Uldaman", phase = "run", rung = "ULDAMAN" }, -- The Platinum Discs (lvl 47, ~2625 xp, sim lvl 38)
  },
})
