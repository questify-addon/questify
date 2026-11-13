local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 32 étapes, niveau final 24.00, ~22270 xp/h, 194 min.
Q:RegisterGuide({
  id = "AD_05",
  title = "Redridge Mountains",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 20, maxLevel = 24,
  next = "AD_06",
  sim = { steps = 32, endLevel = 24.00, xpPerHour = 22270, minutes = 194 },
  steps = {
    { "boat", 1413, 63.54, 38.61, note = "Take the boat to Booty Bay (Stranglethorn Vale)", alt = { "THANES", "DM", "WC" }, below = 24 }, -- bateau
    { "fp", 1431, 77.49, 44.29, alt = { "THANES", "DM", "WC" }, below = 24 }, -- point de vol
    { "fp", 1433, 25.5, 59.41, alt = { "THANES", "DM", "WC" }, below = 24 }, -- point de vol
    { "accept", 98407, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Show of Force (lvl 17, ~950 xp, sim lvl 21)
    { "accept", 128, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 21)
    { "accept", 91, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 21)
    { "accept", 150, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 21)
    { "accept", 127, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 21)
    { "turnin", 65, xp = 1350, alt = { "THANES", "DM", "WC" }, below = 24 }, -- The Defias Brotherhood (lvl 18, ~1350 xp, sim lvl 21)
    { "accept", 1699, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 21)
    { "accept", 92, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "accept", 219, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 21)
    { "complete", 92, obj = 3, at = { 1433, 46.96, 41.84 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "complete", 91, at = { 1433, 73.03, 44.85 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 21)
    { "complete", 150, at = { 1433, 52.43, 56.88 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 21)
    { "complete", 127, at = { 1433, 52.51, 57.46 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 21)
    { "complete", 92, obj = 2, at = { 1433, 51.75, 75.62 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "complete", 128, at = { 1433, 24.14, 11.87 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 128, xp = 2000, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 22)
    { "accept", 386, optional = true, dungeon = "The Stockade", alt = { "THANES", "DM", "WC" }, below = 24 }, -- What Comes Around... (lvl 25, ~0 xp, sim lvl 22)
    { "complete", 92, at = { 1433, 23.71, 75.93 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 22)
    { "complete", 98407, at = { 1433, 10.44, 64.63 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Show of Force (lvl 17, ~950 xp, sim lvl 22)
    { "turnin", 92, xp = 1350, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 22)
    { "turnin", 127, xp = 1250, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 22)
    { "turnin", 150, xp = 1550, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 22)
    { "turnin", 91, xp = 1850, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 22)
    { "complete", 219, at = { 1433, 28.27, 48.7 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 22)
    { "turnin", 219, xp = 2550, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 22)
    { "turnin", 98407, xp = 950, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Show of Force (lvl 17, ~950 xp, sim lvl 22)
    { "level", 24, at = { 1433, 21.97, 22.08 }, note = "About 289 more mobs here (Redridge Alpha, level 21)", alt = { "THANES", "DM", "WC" }, below = 24 }, -- farm de niveau
    { "complete", 1699, at = { 1433, 14.05, 24.71 }, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 24)
    { "turnin", 1699, xp = 1300, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 24)
  },
})
