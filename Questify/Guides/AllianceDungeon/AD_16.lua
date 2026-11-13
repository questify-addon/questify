local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 78 étapes, niveau final 38.29, ~40354 xp/h, 141 min.
Q:RegisterGuide({
  id = "AD_16",
  title = "Stranglethorn Vale and Swamp of Sorrows",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 36, maxLevel = 38,
  next = "AD_17",
  sim = { steps = 78, endLevel = 38.29, xpPerHour = 40354, minutes = 141 },
  steps = {
    { "hearth", 1431, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- pierre de foyer
    { "fp", 1434, 27.53, 77.79, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- point de vol
    { "accept", 79236, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 37)
    { "accept", 605, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 98463, xp = 265, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Talk of the Town (lvl 33, ~265 xp, sim lvl 37)
    { "turnin", 1115, xp = 1400, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Rumormonger (lvl 36, ~1400 xp, sim lvl 37)
    { "accept", 575, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Supply and Demand (lvl 31, ~1000 xp, sim lvl 37)
    { "accept", 595, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 37)
    { "accept", 95325, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- We've Been Robbed! (lvl 40, ~2350 xp, sim lvl 37)
    { "accept", 95322, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Get the Goods (lvl 40, ~2350 xp, sim lvl 37)
    { "turnin", 95322, xp = 2350, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Get the Goods (lvl 40, ~2350 xp, sim lvl 37)
    { "turnin", 595, xp = 2450, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 37)
    { "accept", 597, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 37)
    { "complete", 605, at = { 1434, 24.73, 17.49 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 188, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "complete", 188, at = { 1434, 31.84, 16.45 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 188, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 210, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Krazek's Cookery (lvl 37, ~1400 xp, sim lvl 37)
    { "accept", 97047, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Cook in the Cage (lvl 38, ~2850 xp, sim lvl 37)
    { "accept", 97048, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Returning to Port (lvl 38, ~2850 xp, sim lvl 37)
    { "complete", 97047, at = { 1434, 48.89, 6.24 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Cook in the Cage (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 97047, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Cook in the Cage (lvl 38, ~2850 xp, sim lvl 37)
    { "complete", 575, at = { 1434, 40.47, 13.2 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Supply and Demand (lvl 31, ~1000 xp, sim lvl 37)
    { "turnin", 95325, xp = 2350, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- We've Been Robbed! (lvl 40, ~2350 xp, sim lvl 37)
    { "accept", 95326, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Big Payback (lvl 39, ~3000 xp, sim lvl 37)
    { "complete", 95326, at = { 1434, 43.87, 20.41 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Big Payback (lvl 39, ~3000 xp, sim lvl 37)
    { "turnin", 575, xp = 1000, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Supply and Demand (lvl 31, ~1000 xp, sim lvl 37)
    { "accept", 577, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 37)
    { "turnin", 97048, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Returning to Port (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 597, xp = 2450, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 37)
    { "accept", 599, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 37)
    { "turnin", 605, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 599, xp = 820, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 37)
    { "turnin", 210, xp = 1400, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Krazek's Cookery (lvl 37, ~1400 xp, sim lvl 37)
    { "accept", 600, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 37)
    { "complete", 577, at = { 1434, 39.33, 29.86 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 37)
    { "turnin", 577, xp = 1400, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 37)
    { "accept", 628, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 95326, xp = 3000, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Big Payback (lvl 39, ~3000 xp, sim lvl 37)
    { "complete", 79236, at = { 1434, 27.04, 77.17 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 37)
    { "turnin", 79236, xp = 1550, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 37)
    { "accept", 79535, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 79535, at = { 1434, 41.45, 50.9 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~2750 xp, sim lvl 37)
    { "hearth", 1431, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- pierre de foyer
    { "accept", 1396, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Encroaching Wildlife (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 93585, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- This Light of Mine (lvl 34, ~2700 xp, sim lvl 37)
    { "accept", 93429, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Blood of My Blood (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 93429, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Blood of My Blood (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 1389, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Draenethyst Crystals (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 93464, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Visiting Mage (lvl 38, ~0 xp, sim lvl 37)
    { "turnin", 93585, xp = 2700, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- This Light of Mine (lvl 34, ~2700 xp, sim lvl 37)
    { "complete", 1396, obj = 3, at = { 1435, 26.66, 38.62 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Encroaching Wildlife (lvl 37, ~2850 xp, sim lvl 37)
    { "complete", 1396, at = { 1435, 27.2, 53.67 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Encroaching Wildlife (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 1396, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Encroaching Wildlife (lvl 37, ~2850 xp, sim lvl 37)
    { "accept", 1421, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Lost Caravan (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 1392, at = { 1435, 54.9, 34.1 }, note = "Loot Noboru's Cudgel to start the quest (93.3 % drop: about 2 kills)", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Noboru the Cudgel (lvl 39, ~2250 xp, sim lvl 37)
    { "complete", 1389, at = { 1435, 63.27, 22.35 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Draenethyst Crystals (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 1421, at = { 1435, 64.46, 18.3 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Lost Caravan (lvl 35, ~2750 xp, sim lvl 37)
    { "accept", 1393, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 37)
    { "complete", 1393, at = { 1435, 53.08, 29.55 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 1393, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Galen's Escape (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 1421, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- The Lost Caravan (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 1392, xp = 2250, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Noboru the Cudgel (lvl 39, ~2250 xp, sim lvl 37)
    { "turnin", 1389, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Draenethyst Crystals (lvl 35, ~2750 xp, sim lvl 37)
    { "goto", 1433, 25.5, 59.41, note = "Flight master", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- vol
    { "turnin", 563, xp = 3200, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Reassignment (lvl 32, ~3200 xp, sim lvl 37)
    { "goto", 1453, 71.29, 72.23, note = "Flight master", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- déplacement
    { "fly", 1436, node = 4, note = "Sentinel Hill, Westfall", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- vol
    { "complete", 628, at = { 1434, 33.43, 32.53 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 628, xp = 2850, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 38)
    { "complete", 600, at = { 1434, 41.63, 44.07 }, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 38)
    { "turnin", 600, xp = 3300, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 38)
    { "goto", 1434, 27.53, 77.79, note = "Flight master", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn", alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- vol
    { "turnin", 79949, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~2750 xp, sim lvl 38)
    { "turnin", 79948, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Defensive Magics 101 (lvl 35, ~2750 xp, sim lvl 38)
    { "turnin", 79535, xp = 2750, alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" }, below = 38 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~2750 xp, sim lvl 38)
  },
})
