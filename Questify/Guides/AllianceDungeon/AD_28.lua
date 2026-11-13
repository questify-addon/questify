local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 51 étapes, niveau final 55.00, ~58744 xp/h, 178 min.
Q:RegisterGuide({
  id = "AD_28",
  title = "Burning Steppes",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 53, maxLevel = 55,
  next = "AD_29",
  sim = { steps = 51, endLevel = 55.00, xpPerHour = 58744, minutes = 178 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "goto", 1434, 27.53, 77.79, note = "Flight master" }, -- déplacement
    { "fly", 1433, node = 5, note = "Lakeshire, Redridge" }, -- vol
    { "fp", 1428, 84.33, 68.33 }, -- point de vol
    { "accept", 3823 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 4283 }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "accept", 4286, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- The Good Stuff (lvl 56, ~0 xp, sim lvl 54)
    { "accept", 4182 }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 3823, at = { 1428, 80.83, 43.8 } }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 4726 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 4123, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~0 xp, sim lvl 54)
    { "accept", 4296 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "accept", 4136, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~0 xp, sim lvl 54)
    { "complete", 4726, at = { 1428, 86.98, 31.41 } }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 4023 }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4023, at = { 1428, 94.4, 31.8 } }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "turnin", 4023, xp = 5450 }, -- A Taste of Flame (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4024, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~0 xp, sim lvl 54)
    { "complete", 4182, at = { 1428, 90.26, 46.85 } }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4182, at = { 1428, 91.48, 54.68 } }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "turnin", 4182, xp = 5450 }, -- Dragonkin Menace (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4183 }, -- The True Masters (lvl 54, ~4100 xp, sim lvl 54)
    { "turnin", 3823, xp = 5100 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 54)
    { "accept", 3824 }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 54)
    { "complete", 4283, at = { 1428, 54.29, 53.81 } }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "complete", 3824, at = { 1428, 39.33, 55.3 } }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 54)
    { "accept", 81953 }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "complete", 81953, at = { 1428, 28.96, 28.93 } }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "complete", 4296, at = { 1428, 54.12, 40.76 } }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "turnin", 4296, xp = 2350 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 54)
    { "turnin", 4726, xp = 5100 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 54)
    { "turnin", 3824, xp = 5250 }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 54)
    { "turnin", 4283, xp = 5800 }, -- FIFTY! YEP! (lvl 56, ~5800 xp, sim lvl 54)
    { "accept", 3825 }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 54)
    { "complete", 3825, at = { 1428, 81, 46.79 } }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 54)
    { "turnin", 3825, xp = 5250 }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 54)
    { "fly", 1433, node = 5, note = "Lakeshire, Redridge" }, -- vol
    { "turnin", 4183, xp = 4100 }, -- The True Masters (lvl 54, ~4100 xp, sim lvl 54)
    { "goto", 1433, 25.5, 59.41, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "turnin", 81953, xp = 195 }, -- Stonewrought Design (lvl 45, ~195 xp, sim lvl 54)
    { "level", 55, at = { 1428, 36, 60.37 }, note = "About 318 more mobs here (Flamekin Rager, level 55)" }, -- farm de niveau
    { "goto", 1427, 34.8, 85.3, optional = true, dungeon = "Blackrock Depths", note = "Dungeon: Blackrock Depths (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "BRD" }, -- déplacement
    { "complete", 4024, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~3100 xp, sim lvl 55)
    { "complete", 4123, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 55)
    { "complete", 4136, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 55)
    { "complete", 4286, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Good Stuff (lvl 56, ~2900 xp, sim lvl 55)
    { "turnin", 4024, xp = 3100, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Taste of Flame (lvl 58, ~3100 xp, sim lvl 55)
    { "turnin", 4123, xp = 2825, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 55)
    { "turnin", 4136, xp = 1325, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 55)
    { "turnin", 4286, xp = 2900, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Good Stuff (lvl 56, ~2900 xp, sim lvl 55)
  },
})
