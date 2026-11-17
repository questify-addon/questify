local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 32 étapes, niveau final 24.00, ~22947 xp/h, 187 min.
Q:RegisterGuide({
  id = "AD_05",
  title = "Redridge Mountains",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 20, maxLevel = 24,
  next = "AD_06",
  sim = { steps = 32, endLevel = 24.00, xpPerHour = 22947, minutes = 187 },
  steps = {
    { "hearth", 1440, alt = { "THANES", "DM", "WC" }, below = 24 }, -- pierre de foyer
    { "goto", 1440, 34.41, 47.99, note = "Flight master", alt = { "THANES", "DM", "WC" }, below = 24 }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore", alt = { "THANES", "DM", "WC" }, below = 24 }, -- vol
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor", alt = { "THANES", "DM", "WC" }, below = 24 }, -- bateau
    { "fp", 1433, 25.5, 59.41, alt = { "THANES", "DM", "WC" }, below = 24 }, -- point de vol
    { "accept", 128, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 21)
    { "accept", 91, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 21)
    { "accept", 127, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 21)
    { "accept", 150, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 65, xp = 1350, alt = { "THANES", "DM", "WC" }, below = 24 }, -- The Defias Brotherhood (lvl 18, ~1350 xp, sim lvl 21)
    { "accept", 1699, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 21)
    { "accept", 92, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "accept", 219, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 21)
    { "complete", 1699, at = { 1433, 14.05, 24.71 }, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 21)
    { "complete", 92, obj = 3, at = { 1433, 47.06, 41.78 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "complete", 91, at = { 1433, 73.03, 44.85 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 21)
    { "complete", 150, at = { 1433, 52.43, 56.88 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 21)
    { "complete", 127, at = { 1433, 52.51, 57.46 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 21)
    { "complete", 92, obj = 2, at = { 1433, 51.75, 75.62 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 21)
    { "complete", 128, at = { 1433, 24.14, 11.87 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 128, xp = 2000, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Blackrock Bounty (lvl 25, ~2000 xp, sim lvl 22)
    { "accept", 386, optional = true, dungeon = "The Stockade", alt = { "THANES", "DM", "WC" }, below = 24 }, -- What Comes Around... (lvl 25, ~0 xp, sim lvl 22)
    { "turnin", 1699, xp = 1300, alt = { "THANES", "DM", "WC" }, below = 24, classes = { "WARRIOR" } }, -- The Rethban Gauntlet (lvl 22, ~1300 xp, sim lvl 22)
    { "complete", 92, at = { 1433, 23.71, 75.93 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 22)
    { "complete", 219, at = { 1433, 28.27, 48.7 }, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 22)
    { "turnin", 219, xp = 2550, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Missing In Action (lvl 25, ~2550 xp, sim lvl 22)
    { "turnin", 91, xp = 1850, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Solomon's Law (lvl 23, ~1850 xp, sim lvl 22)
    { "turnin", 127, xp = 1250, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Selling Fish (lvl 21, ~1250 xp, sim lvl 22)
    { "turnin", 150, xp = 1550, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Murloc Poachers (lvl 20, ~1550 xp, sim lvl 22)
    { "turnin", 92, xp = 1350, alt = { "THANES", "DM", "WC" }, below = 24 }, -- Redridge Goulash (lvl 18, ~1350 xp, sim lvl 22)
    { "fp", 1431, 77.49, 44.29, alt = { "THANES", "DM", "WC" }, below = 24 }, -- point de vol
    { "level", 24, at = { 1431, 78.97, 71.24 }, note = "About 294 more mobs here (Skeletal Warrior, level 21)", alt = { "THANES", "DM", "WC" }, below = 24 }, -- farm de niveau
  },
})
