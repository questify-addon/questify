local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 68 étapes, niveau final 58.46, ~57926 xp/h, 96 min.
Q:RegisterGuide({
  id = "AD_33",
  title = "Eastern Plaguelands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 58, maxLevel = 59,
  next = "AD_34",
  sim = { steps = 68, endLevel = 58.46, xpPerHour = 57926, minutes = 96 },
  steps = {
    { "goto", 1448, 62.49, 24.24, note = "Flight master" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore" }, -- vol
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor" }, -- bateau
    { "goto", 1437, 9.49, 59.69, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 16, note = "Refuge Pointe, Arathi" }, -- vol
    { "fp", 1423, 71.81, 49.6 }, -- point de vol
    { "accept", 9664 }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "accept", 5212, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~0 xp, sim lvl 58)
    { "accept", 5529, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Plagued Hatchlings (lvl 58, ~0 xp, sim lvl 58)
    { "accept", 5211 }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 58)
    { "accept", 5251, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 6030, xp = 2040 }, -- Duke Nicholas Zverenhoff (lvl 52, ~2040 xp, sim lvl 58)
    { "accept", 5281 }, -- The Restless Souls (lvl 60, ~6600 xp, sim lvl 58)
    { "accept", 6021 }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 58)
    { "complete", 9664, obj = 2, at = { 1423, 59.04, 39.41 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "accept", 5542 }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5542, obj = 1, at = { 1423, 14.95, 67.41 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 6024 }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 5142, xp = 2800 }, -- Little Pamela (lvl 55, ~2800 xp, sim lvl 58)
    { "complete", 9664, obj = 1, at = { 1423, 34.09, 64.1 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 5542, obj = 2, at = { 1423, 46.24, 51.84 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5211, at = { 1423, 57.48, 31.44 } }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 58)
    { "complete", 6024, at = { 1423, 61.96, 11.11 } }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 9664, obj = 3, at = { 1423, 49.25, 18.2 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 5542, at = { 1423, 28.26, 33.69 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 5542, xp = 5800 }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 5543 }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5543, at = { 1423, 13.96, 66.95 } }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 5543, xp = 5800 }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 5544 }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 58)
    { "complete", 5544, at = { 1423, 13.83, 65.59 } }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 58)
    { "turnin", 5544, xp = 5800 }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 58)
    { "accept", 5742 }, -- Redemption (lvl 56, ~580 xp, sim lvl 58)
    { "complete", 5742, at = { 1423, 5.16, 35.57 } }, -- Redemption (lvl 56, ~580 xp, sim lvl 58)
    { "turnin", 5742, xp = 580 }, -- Redemption (lvl 56, ~580 xp, sim lvl 58)
    { "accept", 5781 }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 58)
    { "turnin", 6024, xp = 6600 }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 5781, at = { 1423, 23.85, 74.22 } }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 58)
    { "complete", 6021, at = { 1423, 23.07, 72.63 } }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 58)
    { "turnin", 5781, xp = 6000 }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 58)
    { "accept", 5845 }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 6164 }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 58)
    { "turnin", 5281, xp = 6600 }, -- The Restless Souls (lvl 60, ~6600 xp, sim lvl 58)
    { "accept", 5282, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~0 xp, sim lvl 58)
    { "complete", 6164, at = { 1423, 14.04, 24.22 } }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 58)
    { "complete", 9664, at = { 1423, 18.16, 25.06 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "complete", 5845, at = { 1423, 62.53, 26.81 } }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 58)
    { "accept", 5214, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 9664, xp = 6600 }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 58)
    { "turnin", 5211, xp = 5650 }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 58)
    { "accept", 5243, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~0 xp, sim lvl 58)
    { "turnin", 6021, xp = 4200 }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 58)
    { "turnin", 5845, xp = 6200 }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 58)
    { "turnin", 6164, xp = 1400 }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 58)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Live (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_LIVE" }, -- déplacement
    { "complete", 5214, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 58)
    { "complete", 5243, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 58)
    { "complete", 5251, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 58)
    { "complete", 5282, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5214, at = { 1423, 70.88, 48.43 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5243, at = { 1423, 71.89, 48.29 }, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5251, at = { 1423, 71.63, 50.09 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5282, at = { 1423, 11.36, 26.6 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 58)
    { "accept", 5262, optional = true, dungeon = "Stratholme", note = "Starts inside the dungeon", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 58)
    { "turnin", 5262, at = { 1423, 71.63, 50.09 }, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 58)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Undead (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STRAT_UD" }, -- déplacement
    { "complete", 5212, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5212, at = { 1423, 71.66, 49.94 }, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 58)
  },
})
