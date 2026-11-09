local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 67 étapes, niveau final 22.31, ~27017 xp/h, 131 min.
Q:RegisterGuide({
  id = "A_02",
  title = "Ashenvale and Stonetalon Mountains",
  faction = "Alliance",
  minLevel = 20, maxLevel = 22,
  next = "A_03",
  sim = { steps = 67, endLevel = 22.31, xpPerHour = 27017, minutes = 131 },
  steps = {
    { "fp", 1440, 34.41, 47.99 }, -- point de vol
    { "accept", 1008 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 19)
    { "accept", 1070 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 19)
    { "complete", 1008, at = { 1440, 12.08, 28.68 } }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 19)
    { "turnin", 967, xp = 1000 }, -- The Tower of Althalaxx (lvl 18, ~1000 xp, sim lvl 20)
    { "accept", 970 }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 1010 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "turnin", 5713, xp = 1050 }, -- One Shot.  One Kill. (lvl 15, ~1050 xp, sim lvl 20)
    { "complete", 1010, at = { 1440, 31.5, 23.36 } }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "complete", 970, at = { 1440, 31.4, 30.64 } }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1010, xp = 780 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "accept", 1020 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 970, xp = 1650 }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 973 }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 20)
    { "turnin", 1008, xp = 1450 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 20)
    { "accept", 1134 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 20)
    { "accept", 991 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 20)
    { "turnin", 990, xp = 365, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Trek to Ashenvale (lvl 19, ~365 xp, sim lvl 20)
    { "turnin", 1020, xp = 1950 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "accept", 78132 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 20)
    { "accept", 78133 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 20)
    { "accept", 78134 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78132, xp = 1000 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78133, xp = 1000 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78134, xp = 1000 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 20)
    { "accept", 1090 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "complete", 1090, at = { 1442, 71.87, 60 } }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "turnin", 1090, xp = 2200 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 20)
    { "accept", 1092 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "accept", 78149 }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 20)
    { "complete", 78149, at = { 1442, 74.4, 85.7 } }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 20)
    { "turnin", 1070, xp = 830 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 20)
    { "accept", 1085 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 20)
    { "turnin", 1085, xp = 165 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 20)
    { "accept", 1071 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1092, xp = 1300 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 20)
    { "accept", 1093 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 78270 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 21)
    { "turnin", 78270, xp = 1400 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 21)
    { "complete", 1093, at = { 1442, 62.38, 53.01 } }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 21)
    { "complete", 1071, at = { 1442, 66.63, 51.24 } }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "turnin", 1093, xp = 1650 }, -- Super Reaper 6000 (lvl 21, ~1650 xp, sim lvl 21)
    { "turnin", 1071, xp = 1650 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 1075 }, -- A Scroll from Mauren (lvl 21, ~830 xp, sim lvl 21)
    { "turnin", 79192, xp = 970, race = { "Dwarf", "Gnome" } }, -- Stepping Stones (lvl 24, ~970 xp, sim lvl 21)
    { "accept", 79980, race = { "Dwarf", "Gnome" } }, -- Scramble (lvl 24, ~970 xp, sim lvl 21)
    { "turnin", 79980, xp = 970, race = { "Dwarf", "Gnome" } }, -- Scramble (lvl 24, ~970 xp, sim lvl 21)
    { "accept", 79974, race = { "Dwarf", "Gnome" } }, -- Wet Job (lvl 32, ~0 xp, sim lvl 21)
    { "accept", 86574 }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "complete", 1134, at = { 1442, 53.55, 37.28 } }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 21)
    { "complete", 86574, at = { 1442, 53.57, 37.23 } }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "fp", 1442, 36.44, 7.18 }, -- point de vol
    { "turnin", 86574, xp = 1950 }, -- Stonetalon Supply Run (lvl 24, ~1950 xp, sim lvl 21)
    { "turnin", 991, xp = 1450 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 21)
    { "turnin", 945, xp = 1350 }, -- Therylune's Escape (lvl 18, ~1350 xp, sim lvl 21)
    { "level", 22, at = { 1440, 33.42, 66.61 }, note = "About 1 mobs here (Shadethicket Raincaller, level 22)" }, -- farm de niveau
    { "complete", 973, at = { 1440, 25.28, 60.69 } }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 22)
    { "turnin", 1134, xp = 1650 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 22)
    { "turnin", 973, xp = 1950 }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 22)
    { "goto", 1440, 34.41, 47.99, note = "Flight master" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore" }, -- vol
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "turnin", 97914, xp = 630, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Expanding Horizons (lvl 17, ~630 xp, sim lvl 22)
    { "fp", 1453, 71.29, 72.23 }, -- point de vol
    { "turnin", 1075, xp = 830 }, -- A Scroll from Mauren (lvl 21, ~830 xp, sim lvl 22)
    { "turnin", 78124, xp = 1550, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Nar'thalas Almanac (lvl 20, ~1550 xp, sim lvl 22)
    { "turnin", 78149, xp = 1550 }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 22)
  },
})
