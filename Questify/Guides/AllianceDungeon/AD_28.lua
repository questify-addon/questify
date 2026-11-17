local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 54 étapes, niveau final 54.34, ~53810 xp/h, 65 min.
Q:RegisterGuide({
  id = "AD_28",
  title = "Burning Steppes",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 53, maxLevel = 55,
  next = "AD_29",
  sim = { steps = 54, endLevel = 54.34, xpPerHour = 53810, minutes = 65 },
  steps = {
    { "hearth", 1444 }, -- pierre de foyer
    { "goto", 1444, 30.24, 43.25, note = "Flight master" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore" }, -- vol
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1428, node = 71, note = "Morgan's Vigil, Burning Steppes" }, -- vol
    { "accept", 3823 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 4286, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- The Good Stuff (lvl 56, ~0 xp, sim lvl 54)
    { "accept", 4283 }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "accept", 4182 }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4182, obj = 2, at = { 1428, 91.48, 54.68 } }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4182, at = { 1428, 90.26, 46.85 } }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4023 }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4023, at = { 1428, 94.4, 31.8 } }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "turnin", 4023, xp = 5450 }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4024, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~0 xp, sim lvl 54)
    { "accept", 4136, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~0 xp, sim lvl 54)
    { "accept", 4296 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "accept", 4123, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~0 xp, sim lvl 54)
    { "accept", 4726 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "complete", 4726, at = { 1428, 86.98, 31.41 } }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "complete", 3823, at = { 1428, 80.83, 43.8 } }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "complete", 4283, at = { 1428, 54.29, 53.81 } }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "complete", 4296, at = { 1428, 54.12, 40.76 } }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "accept", 81953 }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "complete", 81953, at = { 1428, 28.96, 28.93 } }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "turnin", 4296, xp = 2350 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "turnin", 4726, xp = 5100 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "turnin", 3823, xp = 5100 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "turnin", 4283, xp = 5800 }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "turnin", 4182, xp = 5450 }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4183 }, -- The True Masters (lvl 54, ~4100 xp, sim lvl 54)
    { "turnin", 4183, xp = 4100 }, -- The True Masters (lvl 54, ~4100 xp, sim lvl 54)
    { "goto", 1433, 25.5, 59.41, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "turnin", 81953, xp = 195 }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "goto", 1427, 34.8, 85.3, optional = true, dungeon = "Blackrock Depths", note = "Dungeon: Blackrock Depths (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "BRD" }, -- déplacement
    { "complete", 4024, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~3100 xp, sim lvl 54)
    { "complete", 4123, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 54)
    { "complete", 4136, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 54)
    { "complete", 4286, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Good Stuff (lvl 56, ~2900 xp, sim lvl 54)
    { "turnin", 4024, at = { 1428, 95.09, 31.56 }, xp = 3100, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~3100 xp, sim lvl 54)
    { "turnin", 4123, at = { 1428, 65.15, 23.91 }, xp = 2825, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 54)
    { "turnin", 4136, at = { 1428, 66.06, 21.95 }, xp = 1325, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 54)
    { "turnin", 4286, at = { 1428, 84.56, 68.68 }, xp = 2900, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Good Stuff (lvl 56, ~2900 xp, sim lvl 54)
    { "accept", 4083, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 54)
    { "accept", 4201, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 54)
    { "accept", 7604, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 54)
    { "complete", 4083, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 54)
    { "complete", 4201, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 54)
    { "complete", 7604, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 54)
    { "turnin", 4083, xp = 280, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 54)
    { "turnin", 4201, xp = 2725, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 54)
    { "turnin", 7604, xp = 3300, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 54)
  },
})
