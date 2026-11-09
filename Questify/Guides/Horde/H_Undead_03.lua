local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 47 étapes, niveau final 14.01, ~19836 xp/h, 50 min.
Q:RegisterGuide({
  id = "H_Undead_03",
  title = "Silverpine Forest",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 12, maxLevel = 14,
  nextByRace = { Undead = "H_01" },
  sim = { steps = 47, endLevel = 14.01, xpPerHour = 19836, minutes = 50 },
  steps = {
    { "accept", 435 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "complete", 435, at = { 1421, 54.37, 13.38 } }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "turnin", 435, xp = 880 }, -- Escorting Erland (lvl 11, ~880 xp, sim lvl 12)
    { "accept", 449 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 12)
    { "accept", 429 }, -- Wild Hearts (lvl 11, ~440 xp, sim lvl 12)
    { "complete", 429, at = { 1421, 59.84, 9.16 } }, -- Wild Hearts (lvl 11, ~440 xp, sim lvl 12)
    { "fp", 1421, 45.62, 42.6 }, -- point de vol
    { "accept", 477 }, -- Border Crossings (lvl 14, ~980 xp, sim lvl 12)
    { "turnin", 449, xp = 440 }, -- The Deathstalkers' Report (lvl 11, ~440 xp, sim lvl 12)
    { "accept", 3221 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 12)
    { "turnin", 429, xp = 440 }, -- Wild Hearts (lvl 11, ~440 xp, sim lvl 12)
    { "turnin", 3221, xp = 90 }, -- Speak with Renferrel (lvl 12, ~90 xp, sim lvl 12)
    { "accept", 79096 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "accept", 6321 }, -- Supplying the Sepulcher (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 91921 }, -- Return to Quinn (Again) (lvl 11, ~660 xp, sim lvl 12)
    { "accept", 430 }, -- Return to Quinn (lvl 11, ~660 xp, sim lvl 12)
    { "accept", 1359 }, -- Zinge's Delivery (lvl 15, ~105 xp, sim lvl 12)
    { "complete", 79096, at = { 1421, 43.4, 41.2 } }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "turnin", 6321, xp = 210 }, -- Supplying the Sepulcher (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 6323 }, -- Ride to the Undercity (lvl 10, ~420 xp, sim lvl 12)
    { "turnin", 430, xp = 660 }, -- Return to Quinn (lvl 11, ~660 xp, sim lvl 12)
    { "turnin", 91921, xp = 660 }, -- Return to Quinn (Again) (lvl 11, ~660 xp, sim lvl 12)
    { "accept", 460, at = { 1421, 65.85, 24.49 }, note = "Loot A Talking Head to start the quest" }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "turnin", 460, xp = 630 }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "accept", 461 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "turnin", 461, xp = 680 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "accept", 491 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "turnin", 1359, xp = 105 }, -- Zinge's Delivery (lvl 15, ~105 xp, sim lvl 13)
    { "accept", 1358 }, -- Sample for Helbrim (lvl 15, ~0 xp, sim lvl 13)
    { "turnin", 6323, xp = 420 }, -- Ride to the Undercity (lvl 10, ~420 xp, sim lvl 13)
    { "accept", 6322 }, -- Michael Garrett (lvl 10, ~210 xp, sim lvl 13)
    { "turnin", 6322, xp = 210 }, -- Michael Garrett (lvl 10, ~210 xp, sim lvl 13)
    { "accept", 6324 }, -- Return to Podrig (lvl 10, ~1050 xp, sim lvl 13)
    { "turnin", 79096, xp = 1550 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "sethearth", 1458, 67.74, 37.89 }, -- lier la pierre de foyer
    { "accept", 78150 }, -- Friend of the Library (lvl 20, ~390 xp, sim lvl 13)
    { "turnin", 78150, xp = 390 }, -- Friend of the Library (lvl 20, ~390 xp, sim lvl 13)
    { "turnin", 491, xp = 1700 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1421, node = 10, note = "The Sepulcher, Silverpine Forest" }, -- vol
    { "turnin", 477, xp = 980 }, -- Border Crossings (lvl 14, ~980 xp, sim lvl 13)
    { "accept", 478 }, -- Maps and Runes (lvl 14, ~740 xp, sim lvl 13)
    { "turnin", 478, xp = 740 }, -- Maps and Runes (lvl 14, ~740 xp, sim lvl 13)
    { "turnin", 6324, xp = 1050 }, -- Return to Podrig (lvl 10, ~1050 xp, sim lvl 13)
    { "level", 14, at = { 1421, 39.91, 26.04 }, note = "About 26 more mobs here (Foothills Duskbat, level 12)" }, -- farm de niveau
    { "hearth", 1458 }, -- pierre de foyer
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
  },
})
