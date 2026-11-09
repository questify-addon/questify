local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 63 étapes, niveau final 25.00, ~30550 xp/h, 223 min.
Q:RegisterGuide({
  id = "H_03",
  title = "Ashenvale and Stonetalon Mountains",
  faction = "Horde",
  minLevel = 21, maxLevel = 25,
  next = "H_04",
  sim = { steps = 63, endLevel = 25.00, xpPerHour = 30550, minutes = 223 },
  steps = {
    { "accept", 6284 }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 21)
    { "complete", 6284, at = { 1442, 53.25, 72.55 } }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 6562, optional = true, dungeon = "Blackfathom Deeps" }, -- Trouble in the Deeps (lvl 22, ~0 xp, sim lvl 21)
    { "turnin", 6284, xp = 1650 }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 21)
    { "accept", 1087 }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 21)
    { "accept", 6301 }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 21)
    { "complete", 6301, at = { 1442, 50.05, 38.78 } }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 21)
    { "fp", 1440, 12.24, 33.8 }, -- point de vol
    { "accept", 6442 }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 21)
    { "accept", 6462 }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6641 }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 21)
    { "accept", 216 }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6563, optional = true, dungeon = "Blackfathom Deeps" }, -- The Essence of Aku'Mai (lvl 22, ~0 xp, sim lvl 21)
    { "accept", 6921, optional = true, dungeon = "Blackfathom Deeps" }, -- Amongst the Ruins (lvl 27, ~0 xp, sim lvl 21)
    { "complete", 6641, at = { 1440, 9.59, 27.58 } }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 21)
    { "complete", 6442, at = { 1440, 12.08, 28.68 } }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 21)
    { "complete", 216, at = { 1440, 37.13, 34.81 } }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 21)
    { "complete", 6462, at = { 1440, 40.78, 33.76 } }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6482 }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "complete", 6482, at = { 1440, 38.53, 37.32 } }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "fp", 1440, 73.18, 61.59 }, -- point de vol
    { "turnin", 6482, xp = 2400 }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "accept", 6383 }, -- The Ashenvale Hunt (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 6383, xp = 390 }, -- The Ashenvale Hunt (lvl 20, ~390 xp, sim lvl 21)
    { "accept", 6503 }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 2, at = { 1440, 74.98, 70.06 }, note = "Loot Sharptalon's Claw to start the quest" }, -- Sharptalon's Claw (lvl 30, ~2450 xp, sim lvl 21)
    { "complete", 6503, at = { 1440, 75.16, 70.9 } }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 21)
    { "turnin", 6503, xp = 1950 }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6544 }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 21)
    { "complete", 6544, at = { 1440, 64.65, 75.35 } }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 21)
    { "accept", 78134 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 21)
    { "accept", 78132 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 21)
    { "accept", 78133 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 21)
    { "turnin", 78134, xp = 1000 }, -- Dragonslayer's Lance (lvl 25, ~1000 xp, sim lvl 21)
    { "turnin", 78133, xp = 1000 }, -- Dragonslayer's Shield (lvl 25, ~1000 xp, sim lvl 21)
    { "turnin", 78132, xp = 1000 }, -- Dragonslayer's Helm (lvl 25, ~1000 xp, sim lvl 21)
    { "accept", 23, at = { 1440, 39.76, 65.21 }, note = "Loot Ursangous's Paw to start the quest" }, -- Ursangous's Paw (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 98251 }, -- Never Coming Back (lvl 23, ~1850 xp, sim lvl 21)
    { "accept", 98252 }, -- A Void Path (lvl 23, ~1400 xp, sim lvl 21)
    { "accept", 24, at = { 1440, 57.5, 56.05 }, note = "Loot Shadumbra's Head to start the quest" }, -- Shadumbra's Head (lvl 27, ~2200 xp, sim lvl 21)
    { "turnin", 24, xp = 2200 }, -- Shadumbra's Head (lvl 27, ~2200 xp, sim lvl 21)
    { "turnin", 23, xp = 1950 }, -- Ursangous's Paw (lvl 24, ~1950 xp, sim lvl 21)
    { "turnin", 2, xp = 2450 }, -- Sharptalon's Claw (lvl 30, ~2450 xp, sim lvl 21)
    { "accept", 247 }, -- The Hunt Completed (lvl 30, ~3050 xp, sim lvl 22)
    { "turnin", 247, xp = 3050 }, -- The Hunt Completed (lvl 30, ~3050 xp, sim lvl 22)
    { "turnin", 6544, xp = 2400 }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 22)
    { "complete", 98251, at = { 1440, 45.52, 61.57 } }, -- Never Coming Back (lvl 23, ~1850 xp, sim lvl 22)
    { "turnin", 98251, xp = 1850 }, -- Never Coming Back (lvl 23, ~1850 xp, sim lvl 22)
    { "turnin", 98252, xp = 1400 }, -- A Void Path (lvl 23, ~1400 xp, sim lvl 22)
    { "turnin", 6641, xp = 2300 }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 22)
    { "turnin", 216, xp = 1950 }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 22)
    { "turnin", 6462, xp = 1950 }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 22)
    { "turnin", 6442, xp = 1450 }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 22)
    { "complete", 1087, at = { 1442, 36.18, 12.84 } }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 22)
    { "accept", 79974 }, -- Wet Job (lvl 32, ~0 xp, sim lvl 22)
    { "turnin", 6301, xp = 1400 }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 22)
    { "accept", 6381 }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 1087, xp = 1500 }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 22)
    { "complete", 6381, at = { 1442, 32.73, 70.18 } }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 6381, xp = 2000 }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "accept", 78149 }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 22)
    { "complete", 78149, at = { 1442, 74.4, 85.7 } }, -- Fury of the Land (lvl 20, ~0 xp, sim lvl 22)
    { "level", 25, at = { 1442, 36.18, 12.84 }, note = "About 375 more mobs near the last objective" }, -- farm de niveau
  },
})
