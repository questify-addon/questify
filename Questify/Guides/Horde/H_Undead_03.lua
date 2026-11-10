local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-10.
-- Simulation : 15 étapes, niveau final 14.01, ~17478 xp/h, 54 min.
Q:RegisterGuide({
  id = "H_Undead_03",
  title = "Silverpine Forest",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 12, maxLevel = 14,
  nextByRace = { Undead = "H_01" },
  sim = { steps = 15, endLevel = 14.01, xpPerHour = 17478, minutes = 54 },
  steps = {
    { "accept", 460, at = { 1421, 65.88, 24.68 }, note = "Loot A Talking Head to start the quest (2.0 % drop: about 50 kills)" }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "turnin", 460, xp = 630 }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "accept", 461 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "turnin", 461, xp = 680 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "accept", 491 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "fp", 1421, 45.62, 42.6 }, -- point de vol
    { "accept", 79096 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "accept", 447 }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 13)
    { "complete", 79096, at = { 1421, 43.4, 41.2 } }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "complete", 447, obj = 2, at = { 1421, 35.45, 14.54 } }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 13)
    { "complete", 447, at = { 1421, 49.89, 19.79 } }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 447, xp = 910 }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 79096, xp = 1550 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "turnin", 491, xp = 1700 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
  },
})
