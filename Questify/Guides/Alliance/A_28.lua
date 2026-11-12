local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 27 étapes, niveau final 53.00, ~53272 xp/h, 181 min.
Q:RegisterGuide({
  id = "A_28",
  title = "Burning Steppes",
  faction = "Alliance",
  minLevel = 52, maxLevel = 53,
  next = "A_24",
  sim = { steps = 27, endLevel = 53.00, xpPerHour = 53272, minutes = 181 },
  steps = {
    { "note", "Not running Maraudon? Abandon The Pariah's Instructions", optional = true, dungeon = "Maraudon" },
    { "note", "Not running Zul'Farrak? Abandon Divino-matic Rod", optional = true, dungeon = "Zul'Farrak" },
    { "goto", 1419, 65.54, 24.34, note = "Flight master" }, -- déplacement
    { "fly", 1428, node = 71, note = "Morgan's Vigil, Burning Steppes" }, -- vol
    { "accept", 3823 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 4286, optional = true, dungeon = "Blackrock Depths" }, -- The Good Stuff (lvl 56, ~0 xp, sim lvl 52)
    { "complete", 3823, at = { 1428, 80.83, 43.8 } }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 52)
    { "turnin", 3823, xp = 5100 }, -- Extinguish the Firegut (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 3824 }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 52)
    { "accept", 4726 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 4296 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "accept", 4123, optional = true, dungeon = "Blackrock Depths" }, -- The Heart of the Mountain (lvl 55, ~0 xp, sim lvl 52)
    { "complete", 4296, at = { 1428, 54.12, 40.76 } }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "complete", 3824, at = { 1428, 39.33, 55.3 } }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 52)
    { "turnin", 3824, xp = 5250 }, -- Gor'tesh the Brute Lord (lvl 53, ~5250 xp, sim lvl 52)
    { "accept", 3825 }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 52)
    { "complete", 3825, at = { 1428, 81, 46.79 } }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 52)
    { "turnin", 3825, xp = 5250 }, -- Ogre Head On A Stick = Party (lvl 53, ~5250 xp, sim lvl 52)
    { "complete", 4726, at = { 1428, 86.98, 31.41 } }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 4136, optional = true, dungeon = "Blackrock Depths" }, -- Ribbly Screwspigot (lvl 53, ~0 xp, sim lvl 52)
    { "turnin", 4726, xp = 5100 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "turnin", 4296, xp = 2350 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "accept", 4808 }, -- Felnok Steelspring (lvl 54, ~0 xp, sim lvl 52)
    { "accept", 81953 }, -- Stonewrought Design (lvl 45, ~585 xp, sim lvl 52)
    { "complete", 81953, at = { 1428, 28.96, 28.93 } }, -- Stonewrought Design (lvl 45, ~585 xp, sim lvl 52)
    { "turnin", 81953, xp = 585 }, -- Stonewrought Design (lvl 45, ~585 xp, sim lvl 52)
    { "level", 53, at = { 1428, 39.83, 47.48 }, note = "About 401 more mobs here (Scalding Broodling, level 53)" }, -- farm de niveau
  },
})
