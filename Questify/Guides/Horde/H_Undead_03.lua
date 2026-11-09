local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 32 étapes, niveau final 14.10, ~19472 xp/h, 48 min.
Q:RegisterGuide({
  id = "H_Undead_03",
  title = "Silverpine Forest",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 12, maxLevel = 14,
  nextByRace = { Undead = "H_01" },
  sim = { steps = 32, endLevel = 14.10, xpPerHour = 19472, minutes = 48 },
  steps = {
    { "accept", 435 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "complete", 435, at = { 1421, 54.37, 13.38 } }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "turnin", 435, xp = 880 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "accept", 449 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 12)
    { "fp", 1421, 45.62, 42.6 }, -- point de vol
    { "turnin", 449, xp = 440 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 12)
    { "accept", 3221 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 12)
    { "accept", 437 }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 12)
    { "turnin", 3221, xp = 90 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 12)
    { "accept", 1359 }, -- Zinge's Delivery (lvl 15, ~105 xp, sim lvl 12)
    { "accept", 79096 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "complete", 437, at = { 1421, 44.67, 20.67 } }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 12)
    { "turnin", 437, xp = 980 }, -- The Dead Fields (lvl 14, ~980 xp, sim lvl 12)
    { "accept", 438 }, -- The Decrepit Ferry (lvl 16, ~880 xp, sim lvl 12)
    { "complete", 79096, at = { 1421, 43.4, 41.2 } }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "turnin", 438, xp = 880 }, -- The Decrepit Ferry (lvl 16, ~880 xp, sim lvl 12)
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
    { "turnin", 79096, xp = 1550 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "accept", 94435, classes = { "PALADIN" } }, -- A Lesson in Divinity (lvl 12, ~225 xp, sim lvl 13)
    { "turnin", 491, xp = 1700 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "turnin", 440, xp = 580 }, -- The Engraved Ring (lvl 16, ~580 xp, sim lvl 14)
    { "turnin", 94435, xp = 225, classes = { "PALADIN" } }, -- A Lesson in Divinity (lvl 12, ~225 xp, sim lvl 14)
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
  },
})
