local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-10.
-- Simulation : 76 étapes, niveau final 22.33, ~21610 xp/h, 166 min.
Q:RegisterGuide({
  id = "A_02",
  title = "Ashenvale and Stonetalon Mountains",
  faction = "Alliance",
  minLevel = 20, maxLevel = 22,
  next = "A_03",
  sim = { steps = 76, endLevel = 22.33, xpPerHour = 21610, minutes = 166 },
  steps = {
    { "fp", 1440, 34.41, 47.99 }, -- point de vol
    { "accept", 991 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 19)
    { "sethearth", 1440, 36.99, 49.22 }, -- lier la pierre de foyer
    { "turnin", 990, xp = 365, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Trek to Ashenvale (lvl 19, ~365 xp, sim lvl 19)
    { "accept", 1008 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 19)
    { "accept", 1070 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 19)
    { "turnin", 945, xp = 1350 }, -- Therylune's Escape (lvl 18, ~1350 xp, sim lvl 19)
    { "turnin", 991, xp = 1450 }, -- Raene's Cleansing (lvl 19, ~1450 xp, sim lvl 19)
    { "accept", 1023 }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 20)
    { "complete", 1023, at = { 1440, 20.54, 42.9 } }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 20)
    { "accept", 1007 }, -- The Ancient Statuette (lvl 20, ~1150 xp, sim lvl 20)
    { "complete", 1007, at = { 1440, 14.2, 20.64 } }, -- The Ancient Statuette (lvl 20, ~1150 xp, sim lvl 20)
    { "turnin", 1007, xp = 1150 }, -- The Ancient Statuette (lvl 20, ~1150 xp, sim lvl 20)
    { "accept", 1009 }, -- Ruuzel (lvl 25, ~2000 xp, sim lvl 20)
    { "complete", 1008, at = { 1440, 12.08, 28.68 } }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 20)
    { "turnin", 967, xp = 1000 }, -- The Tower of Althalaxx (lvl 18, ~1000 xp, sim lvl 20)
    { "accept", 1010 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "turnin", 5713, xp = 1050 }, -- One Shot.  One Kill. (lvl 15, ~1050 xp, sim lvl 20)
    { "complete", 1010, at = { 1440, 31.5, 23.36 } }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "turnin", 1010, xp = 780 }, -- Bathran's Hair (lvl 20, ~780 xp, sim lvl 20)
    { "accept", 1020 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "turnin", 1008, xp = 1450 }, -- The Zoram Strand (lvl 19, ~1450 xp, sim lvl 20)
    { "accept", 1134 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 20)
    { "turnin", 1023, xp = 1250 }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 20)
    { "accept", 1025 }, -- An Aggressive Defense (lvl 24, ~1950 xp, sim lvl 20)
    { "turnin", 1020, xp = 1950 }, -- Orendil's Cure (lvl 20, ~1950 xp, sim lvl 20)
    { "accept", 78133 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 20)
    { "accept", 78134 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 20)
    { "accept", 78132 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78133, xp = 1000 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78132, xp = 1000 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 20)
    { "turnin", 78134, xp = 1000 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 21)
    { "accept", 1090 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 21)
    { "complete", 1090, at = { 1442, 71.87, 60 } }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 21)
    { "turnin", 1090, xp = 2200 }, -- Gerenzo's Orders (lvl 22, ~2200 xp, sim lvl 21)
    { "accept", 1092 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 21)
    { "accept", 78149 }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 21)
    { "complete", 78149, at = { 1442, 74.4, 85.7 } }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 79008, xp = 870, race = { "Dwarf", "Gnome" } }, -- ... and that note you found (lvl 22, ~870 xp, sim lvl 21)
    { "accept", 79192, race = { "Dwarf", "Gnome" }, note = "Click the Nailed Plank: the Burned-Out Remains next to it do not give this quest" }, -- Stepping Stones (lvl 24, ~970 xp, sim lvl 21)
    { "hearth", 1440 }, -- pierre de foyer
    { "turnin", 1070, xp = 830 }, -- On Guard in Stonetalon (lvl 21, ~830 xp, sim lvl 21)
    { "accept", 1085 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 21)
    { "turnin", 1085, xp = 165 }, -- On Guard in Stonetalon (lvl 21, ~165 xp, sim lvl 21)
    { "accept", 1071 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "turnin", 1092, xp = 1300 }, -- Gerenzo's Orders (lvl 22, ~1300 xp, sim lvl 21)
    { "accept", 78270 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 21)
    { "turnin", 78270, xp = 1400 }, -- Goblin Lockpicks (lvl 23, ~1400 xp, sim lvl 21)
    { "complete", 1071, at = { 1442, 66.63, 51.24 } }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "turnin", 1071, xp = 1650 }, -- A Gnome's Respite (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 1075 }, -- A Scroll from Mauren (lvl 21, ~830 xp, sim lvl 21)
    { "turnin", 79192, xp = 970, race = { "Dwarf", "Gnome" } }, -- Stepping Stones (lvl 24, ~970 xp, sim lvl 21)
    { "accept", 79980, race = { "Dwarf", "Gnome" } }, -- Scramble (lvl 24, ~970 xp, sim lvl 21)
    { "turnin", 79980, xp = 970, race = { "Dwarf", "Gnome" } }, -- Scramble (lvl 24, ~970 xp, sim lvl 21)
    { "accept", 79974, race = { "Dwarf", "Gnome" } }, -- Wet Job (lvl 32, ~0 xp, sim lvl 21)
    { "complete", 1134, at = { 1442, 53.55, 37.28 } }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 21)
    { "turnin", 1134, xp = 1650 }, -- Pridewings of Stonetalon (lvl 21, ~1650 xp, sim lvl 21)
    { "goto", 1440, 34.41, 47.99, note = "Flight master" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore" }, -- vol
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "turnin", 78149, xp = 1550 }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 78124, xp = 1550, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Nar'thalas Almanac (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 1075, xp = 830 }, -- A Scroll from Mauren (lvl 21, ~830 xp, sim lvl 21)
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 28, note = "Astranaar, Ashenvale" }, -- vol
    { "complete", 1025, at = { 1440, 50.09, 60.15 } }, -- An Aggressive Defense (lvl 24, ~1950 xp, sim lvl 22)
    { "complete", 1025, at = { 1440, 53.61, 63.75 } }, -- An Aggressive Defense (lvl 24, ~1950 xp, sim lvl 22)
    { "hearth", 1440 }, -- pierre de foyer
    { "turnin", 1025, xp = 1950 }, -- An Aggressive Defense (lvl 24, ~1950 xp, sim lvl 22)
    { "complete", 1009, at = { 1440, 7.22, 13.06 } }, -- Ruuzel (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 1009, xp = 2000 }, -- Ruuzel (lvl 25, ~2000 xp, sim lvl 22)
    { "goto", 1440, 34.41, 47.99, note = "Flight master" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore" }, -- vol
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "turnin", 97914, xp = 630, race = { "Dwarf", "Gnome", "Human", "Skyborne" } }, -- Expanding Horizons (lvl 17, ~630 xp, sim lvl 22)
  },
})
