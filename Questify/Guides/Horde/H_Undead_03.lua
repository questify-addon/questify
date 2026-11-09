local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 80866960788084ae1592abf66a08f0d306458a95, généré le 2026-11-07.
-- Simulation : 27 étapes, niveau final 14.13, ~17648 xp/h, 48 min.
Q:RegisterGuide({
  id = "H_Undead_03",
  title = "Silverpine Forest",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 12, maxLevel = 14,
  nextByRace = { Undead = "H_01" },
  sim = { steps = 27, endLevel = 14.13, xpPerHour = 17648, minutes = 48 },
  steps = {
    { "accept", 437 }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 12)
    { "accept", 435 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "complete", 435, at = { 1421, 54.37, 13.38 } }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "turnin", 435, xp = 880 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "accept", 449 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 12)
    { "level", 13, at = { 1421, 35.67, 15.75 }, note = "About 1 mobs here (Foothills Duskbat, level 12)" }, -- farm de niveau
    { "complete", 437, at = { 1421, 44.67, 20.67 } }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 13)
    { "turnin", 437, xp = 980 }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 13)
    { "accept", 438 }, -- The Decrepit Ferry (lvl 16, ~880 xp, sim lvl 13)
    { "turnin", 449, xp = 440 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 13)
    { "accept", 3221 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 13)
    { "turnin", 3221, xp = 90 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 13)
    { "accept", 1359 }, -- Zinge's Delivery (lvl 15, ~105 xp, sim lvl 13)
    { "turnin", 438, xp = 880 }, -- The Decrepit Ferry (lvl 16, ~880 xp, sim lvl 13)
    { "accept", 439 }, -- Rot Hide Clues (lvl 16, ~290 xp, sim lvl 13)
    { "turnin", 439, xp = 290 }, -- Rot Hide Clues (lvl 16, ~290 xp, sim lvl 13)
    { "accept", 440 }, -- The Engraved Ring (lvl 16, ~580 xp, sim lvl 13)
    { "accept", 460, at = { 1421, 65.88, 24.68 }, note = "Loot A Talking Head to start the quest (2.0 % drop: about 50 kills)" }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "turnin", 460, xp = 630 }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "accept", 461 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "turnin", 461, xp = 680 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "accept", 491 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "turnin", 1359, xp = 105 }, -- Zinge's Delivery (lvl 15, ~105 xp, sim lvl 13)
    { "accept", 1358 }, -- Sample for Helbrim (lvl 15, ~0 xp, sim lvl 13)
    { "turnin", 491, xp = 1700 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "turnin", 440, xp = 580 }, -- The Engraved Ring (lvl 16, ~580 xp, sim lvl 14)
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
  },
})
