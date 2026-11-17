local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 71 étapes, niveau final 25.00, ~26721 xp/h, 240 min.
Q:RegisterGuide({
  id = "HD_06",
  title = "Ashenvale",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 21, maxLevel = 25,
  next = "HD_07",
  sim = { steps = 71, endLevel = 25.00, xpPerHour = 26721, minutes = 240 },
  steps = {
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
    { "fp", 1440, 73.18, 61.59 }, -- point de vol
    { "accept", 6383 }, -- The Ashenvale Hunt (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 6383, xp = 390 }, -- The Ashenvale Hunt (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 6382, xp = 390 }, -- The Ashenvale Hunt (lvl 20, ~390 xp, sim lvl 21)
    { "accept", 6503 }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 2, at = { 1440, 74.98, 70.06 }, note = "Loot Sharptalon's Claw to start the quest (83.9 % drop: about 2 kills)" }, -- Sharptalon's Claw (lvl 30, ~2450 xp, sim lvl 21)
    { "complete", 6503, at = { 1440, 75.16, 70.9 } }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6544 }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 21)
    { "complete", 6544, at = { 1440, 64.65, 75.35 } }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 21)
    { "accept", 23, at = { 1440, 39.76, 65.21 }, note = "Loot Ursangous's Paw to start the quest (86.5 % drop: about 2 kills)" }, -- Ursangous's Paw (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 98251 }, -- Never Coming Back (lvl 23, ~1400 xp, sim lvl 21)
    { "accept", 98252 }, -- A Void Path (lvl 23, ~920 xp, sim lvl 21)
    { "complete", 98251, at = { 1440, 45.52, 61.57 } }, -- Never Coming Back (lvl 23, ~1400 xp, sim lvl 21)
    { "turnin", 98251, xp = 1400 }, -- Never Coming Back (lvl 23, ~1400 xp, sim lvl 21)
    { "turnin", 98252, xp = 920 }, -- A Void Path (lvl 23, ~920 xp, sim lvl 21)
    { "fp", 1440, 12.24, 33.8 }, -- point de vol
    { "accept", 6641 }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 21)
    { "accept", 216 }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 95042, classes = { "PALADIN" } }, -- Seeking the Kor Gem (lvl 25, ~2000 xp, sim lvl 21)
    { "accept", 6442 }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 21)
    { "accept", 6462 }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6921, optional = true, dungeon = "Blackfathom Deeps", phase = "prep", rung = "BFD" }, -- Amongst the Ruins (lvl 27, ~0 xp, sim lvl 21)
    { "accept", 6563, optional = true, dungeon = "Blackfathom Deeps", phase = "prep", rung = "BFD" }, -- The Essence of Aku'Mai (lvl 22, ~0 xp, sim lvl 21)
    { "complete", 6641, at = { 1440, 9.59, 27.58 } }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 21)
    { "complete", 6442, at = { 1440, 12.08, 28.68 } }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 21)
    { "complete", 216, at = { 1440, 37.13, 34.81 } }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 21)
    { "complete", 6462, at = { 1440, 40.78, 33.76 } }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 21)
    { "accept", 6482 }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "complete", 6482, at = { 1440, 38.53, 37.32 } }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "accept", 24, at = { 1440, 57.5, 56.05 }, note = "Loot Shadumbra's Head to start the quest (85.5 % drop: about 2 kills)" }, -- Shadumbra's Head (lvl 27, ~2200 xp, sim lvl 21)
    { "turnin", 6482, xp = 2400 }, -- Freedom to Ruul (lvl 24, ~2400 xp, sim lvl 21)
    { "turnin", 2, xp = 2450 }, -- Sharptalon's Claw (lvl 30, ~2450 xp, sim lvl 21)
    { "turnin", 24, xp = 2200 }, -- Shadumbra's Head (lvl 27, ~2200 xp, sim lvl 21)
    { "turnin", 23, xp = 1950 }, -- Ursangous's Paw (lvl 24, ~1950 xp, sim lvl 22)
    { "accept", 247 }, -- The Hunt Completed (lvl 30, ~3050 xp, sim lvl 22)
    { "turnin", 247, xp = 3050 }, -- The Hunt Completed (lvl 30, ~3050 xp, sim lvl 22)
    { "turnin", 6544, xp = 2400 }, -- Torek's Assault (lvl 24, ~2400 xp, sim lvl 22)
    { "turnin", 6503, xp = 1950 }, -- Ashenvale Outrunners (lvl 24, ~1950 xp, sim lvl 22)
    { "accept", 6284 }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 22)
    { "complete", 6284, at = { 1442, 53.25, 72.55 } }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 22)
    { "turnin", 6284, xp = 1650 }, -- Arachnophobia (lvl 21, ~1650 xp, sim lvl 22)
    { "accept", 1087 }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 22)
    { "accept", 6301 }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 22)
    { "complete", 1087, at = { 1442, 36.18, 12.84 } }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 22)
    { "complete", 6301, at = { 1442, 50.05, 38.78 } }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 22)
    { "turnin", 6301, xp = 1400 }, -- Cycle of Rebirth (lvl 23, ~1400 xp, sim lvl 22)
    { "accept", 6381 }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "complete", 6381, at = { 1442, 32.73, 70.18 } }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 1087, xp = 1500 }, -- Cenarius' Legacy (lvl 25, ~1500 xp, sim lvl 22)
    { "turnin", 6381, xp = 2000 }, -- New Life (lvl 25, ~2000 xp, sim lvl 22)
    { "turnin", 6442, xp = 1450 }, -- Naga at the Zoram Strand (lvl 19, ~1450 xp, sim lvl 22)
    { "turnin", 6462, xp = 1950 }, -- Troll Charm (lvl 24, ~1950 xp, sim lvl 22)
    { "turnin", 216, xp = 1950 }, -- Between a Rock and a Thistlefur (lvl 24, ~1950 xp, sim lvl 22)
    { "turnin", 6641, xp = 2300 }, -- Vorsha the Lasher (lvl 23, ~2300 xp, sim lvl 22)
    { "level", 25, at = { 1440, 7.48, 18.73 }, note = "About 398 more mobs here (Mystlash Flayer, level 23)" }, -- farm de niveau
    { "complete", 95042, at = { 1440, 13.55, 12.06 }, classes = { "PALADIN" } }, -- Seeking the Kor Gem (lvl 25, ~2000 xp, sim lvl 25)
    { "turnin", 95042, xp = 2000, classes = { "PALADIN" } }, -- Seeking the Kor Gem (lvl 25, ~2000 xp, sim lvl 25)
    { "goto", 1440, 14.5, 14.2, optional = true, dungeon = "Blackfathom Deeps", note = "Dungeon: Blackfathom Deeps (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "BFD" }, -- déplacement
    { "complete", 6563, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- The Essence of Aku'Mai (lvl 22, ~875 xp, sim lvl 25)
    { "complete", 6921, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Amongst the Ruins (lvl 27, ~1375 xp, sim lvl 25)
    { "turnin", 6562, at = { 1440, 11.56, 34.29 }, xp = 215, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Trouble in the Deeps (lvl 22, ~215 xp, sim lvl 25)
    { "turnin", 6563, at = { 1440, 11.56, 34.29 }, xp = 875, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- The Essence of Aku'Mai (lvl 22, ~875 xp, sim lvl 25)
    { "turnin", 6921, at = { 1440, 11.56, 34.29 }, xp = 1375, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Amongst the Ruins (lvl 27, ~1375 xp, sim lvl 25)
    { "accept", 6561, optional = true, dungeon = "Blackfathom Deeps", note = "Starts inside the dungeon", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 25)
    { "accept", 6564, optional = true, dungeon = "Blackfathom Deeps", note = "Starts inside the dungeon", phase = "run", rung = "BFD" }, -- Allegiance to the Old Gods (lvl 22, ~650 xp, sim lvl 25)
    { "accept", 6922, optional = true, dungeon = "Blackfathom Deeps", note = "Starts inside the dungeon", phase = "run", rung = "BFD" }, -- Baron Aquanis (lvl 30, ~1525 xp, sim lvl 25)
    { "complete", 6561, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 25)
    { "turnin", 6564, at = { 1440, 11.56, 34.29 }, xp = 650, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Allegiance to the Old Gods (lvl 22, ~650 xp, sim lvl 25)
    { "turnin", 6922, at = { 1440, 11.56, 34.29 }, xp = 1525, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Baron Aquanis (lvl 30, ~1525 xp, sim lvl 25)
    { "turnin", 6561, at = { 1456, 71.06, 34.19 }, xp = 825, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 25)
  },
})
