local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 50 étapes, niveau final 57.00, ~60656 xp/h, 186 min.
Q:RegisterGuide({
  id = "A_27",
  title = "Felwood and Winterspring",
  faction = "Alliance",
  minLevel = 56, maxLevel = 57,
  next = "A_23",
  sim = { steps = 50, endLevel = 57.00, xpPerHour = 60656, minutes = 186 },
  steps = {
    { "accept", 4809 }, -- Chillwind Horns (lvl 54, ~5450 xp, sim lvl 56)
    { "accept", 6028 }, -- The Everlook Report (lvl 52, ~0 xp, sim lvl 56)
    { "sethearth", 1452, 61.36, 38.83 }, -- lier la pierre de foyer
    { "accept", 6030 }, -- Duke Nicholas Zverenhoff (lvl 52, ~0 xp, sim lvl 56)
    { "accept", 5601 }, -- Sister Pamela (lvl 55, ~0 xp, sim lvl 56)
    { "accept", 6604 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 56)
    { "accept", 6603 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 56)
    { "accept", 3783 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "accept", 5244 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 56)
    { "turnin", 6604, xp = 640 }, -- Enraged Wildkin (lvl 59, ~640 xp, sim lvl 56)
    { "accept", 4861 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 56)
    { "turnin", 5244, xp = 580 }, -- The Ruins of Kel'Theril (lvl 56, ~580 xp, sim lvl 56)
    { "accept", 5245 }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 56)
    { "accept", 8464 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "turnin", 6603, xp = 580 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 56)
    { "accept", 4842 }, -- Strange Sources (lvl 56, ~5800 xp, sim lvl 56)
    { "accept", 5082 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 5082, at = { 1452, 41.52, 43.15 } }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 5245, at = { 1452, 50.88, 41.71 } }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 56)
    { "complete", 5245, at = { 1452, 55.14, 42.98 } }, -- Troubled Spirits of Kel'Theril (lvl 56, ~0 xp, sim lvl 56)
    { "turnin", 4861, xp = 3200 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 56)
    { "accept", 4863 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 56)
    { "complete", 4842, at = { 1452, 59.82, 74.25 } }, -- Strange Sources (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 4863, xp = 3200 }, -- Enraged Wildkin (lvl 59, ~3200 xp, sim lvl 56)
    { "accept", 4864 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 56)
    { "complete", 4864, obj = 1, at = { 1452, 61.4, 60.73 } }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 56)
    { "complete", 4864, at = { 1452, 64.77, 59.76 } }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 56)
    { "complete", 4809, at = { 1452, 67.12, 50.22 } }, -- Chillwind Horns (lvl 54, ~5450 xp, sim lvl 56)
    { "complete", 3783, at = { 1452, 66.83, 42.67 } }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "turnin", 4809, xp = 5450 }, -- Chillwind Horns (lvl 54, ~5450 xp, sim lvl 56)
    { "turnin", 3783, xp = 4350 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "accept", 977 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "complete", 977, at = { 1452, 70.84, 39.16 } }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "complete", 8464, at = { 1452, 67.73, 35.93 } }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "complete", 5082, at = { 1452, 66.47, 34.66 } }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 977, xp = 4650 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "turnin", 4864, xp = 6400 }, -- Enraged Wildkin (lvl 59, ~6400 xp, sim lvl 56)
    { "turnin", 8464, xp = 6200 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "turnin", 4842, xp = 5800 }, -- Strange Sources (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 5082, xp = 5800 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "accept", 5204 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 56)
    { "accept", 5156 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "complete", 5204, at = { 1448, 38.3, 50.51 } }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 56)
    { "turnin", 5204, xp = 4500 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 56)
    { "accept", 5385 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 56)
    { "complete", 5156, obj = 3, at = { 1448, 41.03, 41.96 } }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "complete", 5156, at = { 1448, 43.73, 40.16 } }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "turnin", 5156, xp = 6800 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "turnin", 5385, xp = 7550 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 56)
    { "level", 57, at = { 1448, 43.73, 40.16 }, note = "About 258 more mobs near the last objective" }, -- farm de niveau
  },
})
