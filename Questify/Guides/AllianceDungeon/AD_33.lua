local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 68 étapes, niveau final 60.00, ~59246 xp/h, 212 min.
Q:RegisterGuide({
  id = "AD_33",
  title = "Eastern Plaguelands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 59, maxLevel = 60,
  next = "AD_34",
  sim = { steps = 68, endLevel = 60.00, xpPerHour = 59246, minutes = 212 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "goto", 1434, 27.53, 77.79, note = "Flight master" }, -- déplacement
    { "fly", 1425, node = 43, note = "Aerie Peak, The Hinterlands" }, -- vol
    { "fp", 1423, 71.81, 49.6 }, -- point de vol
    { "accept", 9664 }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 5529, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Plagued Hatchlings (lvl 58, ~0 xp, sim lvl 59)
    { "accept", 5212, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~0 xp, sim lvl 59)
    { "accept", 5211 }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 59)
    { "turnin", 6030, xp = 1530 }, -- Duke Nicholas Zverenhoff (lvl 52, ~1530 xp, sim lvl 59)
    { "accept", 5251, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~0 xp, sim lvl 59)
    { "accept", 5281 }, -- The Restless Souls (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 6021 }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 59)
    { "complete", 9664, obj = 2, at = { 1423, 59.04, 39.41 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 5211, at = { 1423, 57.48, 31.44 } }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 5542 }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 59)
    { "accept", 5543 }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 59)
    { "accept", 5544 }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5544, at = { 1423, 13.83, 65.59 } }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5543, at = { 1423, 13.96, 66.95 } }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5542, obj = 1, at = { 1423, 14.95, 67.41 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 9664, obj = 1, at = { 1423, 34.09, 64.1 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 5542, obj = 2, at = { 1423, 46.24, 51.84 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 5542, at = { 1423, 28.26, 33.69 } }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 59)
    { "turnin", 5542, xp = 5800 }, -- Demon Dogs (lvl 56, ~5800 xp, sim lvl 59)
    { "turnin", 5543, xp = 5800 }, -- Blood Tinged Skies (lvl 56, ~5800 xp, sim lvl 59)
    { "turnin", 5544, xp = 5800 }, -- Carrion Grubbage (lvl 56, ~5800 xp, sim lvl 59)
    { "accept", 5742 }, -- Redemption (lvl 56, ~580 xp, sim lvl 59)
    { "complete", 5742, at = { 1423, 5.16, 35.57 } }, -- Redemption (lvl 56, ~580 xp, sim lvl 59)
    { "turnin", 5742, xp = 580 }, -- Redemption (lvl 56, ~580 xp, sim lvl 59)
    { "accept", 5781 }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 59)
    { "accept", 6024 }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 5781, at = { 1423, 23.85, 74.22 } }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 59)
    { "complete", 6021, at = { 1423, 23.07, 72.63 } }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 59)
    { "turnin", 5781, xp = 6000 }, -- Of Forgotten Memories (lvl 57, ~6000 xp, sim lvl 59)
    { "accept", 5845 }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 6164 }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 59)
    { "turnin", 5281, xp = 6600 }, -- The Restless Souls (lvl 60, ~6600 xp, sim lvl 59)
    { "accept", 5282, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~0 xp, sim lvl 59)
    { "complete", 6164, at = { 1423, 14.04, 24.22 } }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 59)
    { "complete", 9664, obj = 4, at = { 1423, 18.16, 25.06 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 5245, xp = 5800 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~5800 xp, sim lvl 59)
    { "complete", 9664, at = { 1423, 49.25, 18.2 } }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 6024, at = { 1423, 61.96, 11.11 } }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 59)
    { "complete", 5845, at = { 1423, 62.53, 26.81 } }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 59)
    { "accept", 5214, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~0 xp, sim lvl 59)
    { "turnin", 9664, xp = 6600 }, -- Establishing New Outposts (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 5211, xp = 5650 }, -- Defenders of Darrowshire (lvl 55, ~5650 xp, sim lvl 59)
    { "accept", 5243, optional = true, dungeon = "Stratholme", phase = "prep", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~0 xp, sim lvl 59)
    { "turnin", 6021, xp = 4200 }, -- Zaeldarr the Outcast (lvl 55, ~4200 xp, sim lvl 59)
    { "turnin", 5142, xp = 2800 }, -- Little Pamela (lvl 55, ~2800 xp, sim lvl 59)
    { "turnin", 6024, xp = 6600 }, -- Hameya's Plea (lvl 60, ~6600 xp, sim lvl 59)
    { "turnin", 5845, xp = 6200 }, -- Of Lost Honor (lvl 58, ~6200 xp, sim lvl 59)
    { "turnin", 6164, xp = 1400 }, -- Augustus' Receipt Book (lvl 55, ~1400 xp, sim lvl 59)
    { "level", 60, at = { 1423, 61.96, 11.11 }, note = "About 320 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Live (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "STRAT_LIVE" }, -- déplacement
    { "complete", 5214, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 60)
    { "complete", 5243, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 60)
    { "complete", 5251, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 60)
    { "complete", 5282, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5214, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Great Ezra Grimm (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5243, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- Houses of the Holy (lvl 60, ~3300 xp, sim lvl 60)
    { "turnin", 5251, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Archivist (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5282, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Restless Souls (lvl 60, ~4150 xp, sim lvl 60)
    { "accept", 5262, optional = true, dungeon = "Stratholme", note = "Starts inside the dungeon", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 60)
    { "turnin", 5262, xp = 4150, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_LIVE" }, -- The Truth Comes Crashing Down (lvl 60, ~4150 xp, sim lvl 60)
    { "goto", 1423, 26.52, 10.36, optional = true, dungeon = "Stratholme", note = "Dungeon: Stratholme: Undead (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "STRAT_UD" }, -- déplacement
    { "complete", 5212, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 60)
    { "turnin", 5212, xp = 3300, optional = true, dungeon = "Stratholme", phase = "run", rung = "STRAT_UD" }, -- The Flesh Does Not Lie (lvl 60, ~3300 xp, sim lvl 60)
  },
})
