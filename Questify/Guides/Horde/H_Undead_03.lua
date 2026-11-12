local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 14 étapes, niveau final 14.07, ~19054 xp/h, 51 min.
Q:RegisterGuide({
  id = "H_Undead_03",
  title = "Silverpine Forest",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 12, maxLevel = 14,
  nextByRace = { Undead = "H_01" },
  sim = { steps = 14, endLevel = 14.07, xpPerHour = 19054, minutes = 51 },
  steps = {
    { "accept", 447 }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 12)
    { "accept", 79096 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "complete", 79096, at = { 1421, 43.4, 41.2 } }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 12)
    { "complete", 447, obj = 2, at = { 1421, 35.45, 14.54 } }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 12)
    { "complete", 447, at = { 1421, 49.89, 19.79 } }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 12)
    { "accept", 460, at = { 1421, 65.88, 24.68 }, note = "Loot A Talking Head to start the quest (2.0 % drop: about 50 kills)" }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "turnin", 460, xp = 630 }, -- Resting in Pieces (lvl 17, ~630 xp, sim lvl 13)
    { "accept", 461 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "turnin", 461, xp = 680 }, -- The Hidden Niche (lvl 18, ~680 xp, sim lvl 13)
    { "accept", 491 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "turnin", 447, xp = 910 }, -- A Recipe For Death (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 79096, xp = 1550 }, -- Ataeric: On Arcane Curiosities (lvl 20, ~1550 xp, sim lvl 13)
    { "turnin", 491, xp = 1700 }, -- Wand to Bethor (lvl 18, ~1700 xp, sim lvl 13)
    { "boat", 1420, 60.7, 58.9, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
  },
})
