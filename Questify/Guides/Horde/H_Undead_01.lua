local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 58 étapes, niveau final 6.07, ~10863 xp/h, 43 min.
Q:RegisterGuide({
  id = "H_Undead_01",
  title = "Deathknell",
  faction = "Horde",
  races = { "Undead" },
  minLevel = 1, maxLevel = 6,
  next = "H_Undead_02",
  sim = { steps = 58, endLevel = 6.07, xpPerHour = 10863, minutes = 43 },
  steps = {
    { "accept", 363 }, -- Rude Awakening (lvl 1, ~40 xp, sim lvl 1)
    { "turnin", 363, xp = 40 }, -- Rude Awakening (lvl 1, ~40 xp, sim lvl 1)
    { "accept", 364 }, -- The Mindless Ones (lvl 2, ~170 xp, sim lvl 1)
    { "complete", 364, at = { 1420, 32.1, 63.41 } }, -- The Mindless Ones (lvl 2, ~170 xp, sim lvl 1)
    { "accept", 376 }, -- The Damned (lvl 2, ~170 xp, sim lvl 2)
    { "turnin", 364, xp = 170 }, -- The Mindless Ones (lvl 2, ~170 xp, sim lvl 2)
    { "accept", 3095, classes = { "WARRIOR" } }, -- Simple Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 3096, classes = { "ROGUE" } }, -- Encrypted Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 3097, classes = { "PRIEST" } }, -- Hallowed Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 3098, classes = { "MAGE" } }, -- Glyphic Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 3099, classes = { "WARLOCK" } }, -- Tainted Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "turnin", 3099, xp = 40, classes = { "WARLOCK" } }, -- Tainted Scroll (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 98601, classes = { "PALADIN" } }, -- A Difficult Path (lvl 1, ~40 xp, sim lvl 2)
    { "accept", 3901 }, -- Rattling the Rattlecages (lvl 3, ~250 xp, sim lvl 2)
    { "complete", 376, at = { 1420, 35.73, 58.33 } }, -- The Damned (lvl 2, ~170 xp, sim lvl 2)
    { "complete", 3901, at = { 1420, 33.15, 61.99 } }, -- Rattling the Rattlecages (lvl 3, ~250 xp, sim lvl 3)
    { "turnin", 376, xp = 170 }, -- The Damned (lvl 2, ~170 xp, sim lvl 3)
    { "turnin", 3097, xp = 40, classes = { "PRIEST" } }, -- Hallowed Scroll (lvl 1, ~40 xp, sim lvl 3)
    { "turnin", 3098, xp = 40, classes = { "MAGE" } }, -- Glyphic Scroll (lvl 1, ~40 xp, sim lvl 3)
    { "accept", 6395 }, -- Marla's Last Wish (lvl 5, ~450 xp, sim lvl 3)
    { "turnin", 3901, xp = 250 }, -- Rattling the Rattlecages (lvl 3, ~250 xp, sim lvl 3)
    { "accept", 98389 }, -- A Light in the Darkness (lvl 4, ~355 xp, sim lvl 4)
    { "turnin", 98601, xp = 40, classes = { "PALADIN" } }, -- A Difficult Path (lvl 1, ~40 xp, sim lvl 4)
    { "accept", 90902, classes = { "PALADIN" } }, -- Rediscovering the Light (lvl 2, ~85 xp, sim lvl 4)
    { "accept", 1470, classes = { "WARLOCK" } }, -- Piercing the Veil (lvl 3, ~190 xp, sim lvl 4)
    { "accept", 3902 }, -- Scavenging Deathknell (lvl 3, ~315 xp, sim lvl 4)
    { "accept", 380 }, -- Night Web's Hollow (lvl 4, ~355 xp, sim lvl 4)
    { "turnin", 3095, xp = 40, classes = { "WARRIOR" } }, -- Simple Scroll (lvl 1, ~40 xp, sim lvl 4)
    { "turnin", 3096, xp = 40, classes = { "ROGUE" } }, -- Encrypted Scroll (lvl 1, ~40 xp, sim lvl 4)
    { "complete", 6395, at = { 1420, 31.17, 65.08 } }, -- Marla's Last Wish (lvl 5, ~450 xp, sim lvl 4)
    { "complete", 90902, at = { 1420, 31.88, 64.17 }, classes = { "PALADIN" } }, -- Rediscovering the Light (lvl 2, ~85 xp, sim lvl 4)
    { "turnin", 6395, xp = 450 }, -- Marla's Last Wish (lvl 5, ~450 xp, sim lvl 4)
    { "complete", 3902, at = { 1420, 33.04, 64.29 } }, -- Scavenging Deathknell (lvl 3, ~315 xp, sim lvl 4)
    { "complete", 1470, at = { 1420, 33.15, 61.99 }, classes = { "WARLOCK" } }, -- Piercing the Veil (lvl 3, ~190 xp, sim lvl 4)
    { "turnin", 3902, xp = 315 }, -- Scavenging Deathknell (lvl 3, ~315 xp, sim lvl 4)
    { "complete", 98389, at = { 1420, 26.8, 59.58 } }, -- A Light in the Darkness (lvl 4, ~355 xp, sim lvl 4)
    { "complete", 380, at = { 1420, 28.4, 58.08 } }, -- Night Web's Hollow (lvl 4, ~355 xp, sim lvl 4)
    { "turnin", 98389, xp = 355 }, -- A Light in the Darkness (lvl 4, ~355 xp, sim lvl 4)
    { "turnin", 90902, xp = 85, classes = { "PALADIN" } }, -- Rediscovering the Light (lvl 2, ~85 xp, sim lvl 4)
    { "turnin", 1470, xp = 190, classes = { "WARLOCK" } }, -- Piercing the Veil (lvl 3, ~190 xp, sim lvl 4)
    { "accept", 91208, classes = { "PALADIN" } }, -- Coming to Terms (lvl 4, ~180 xp, sim lvl 4)
    { "complete", 91208, at = { 1420, 27.69, 63.82 }, classes = { "PALADIN" } }, -- Coming to Terms (lvl 4, ~180 xp, sim lvl 4)
    { "turnin", 91208, xp = 180, classes = { "PALADIN" } }, -- Coming to Terms (lvl 4, ~180 xp, sim lvl 4)
    { "turnin", 380, xp = 355 }, -- Night Web's Hollow (lvl 4, ~355 xp, sim lvl 5)
    { "accept", 5651, classes = { "PRIEST" } }, -- In Favor of Darkness (lvl 4, ~90 xp, sim lvl 5)
    { "accept", 381 }, -- The Scarlet Crusade (lvl 4, ~355 xp, sim lvl 5)
    { "complete", 381, at = { 1420, 37.52, 67.46 } }, -- The Scarlet Crusade (lvl 4, ~355 xp, sim lvl 5)
    { "turnin", 381, xp = 355 }, -- The Scarlet Crusade (lvl 4, ~355 xp, sim lvl 5)
    { "accept", 382 }, -- The Red Messenger (lvl 5, ~670 xp, sim lvl 5)
    { "complete", 382, at = { 1420, 36.57, 68.54 } }, -- The Red Messenger (lvl 5, ~670 xp, sim lvl 5)
    { "turnin", 382, xp = 670 }, -- The Red Messenger (lvl 5, ~670 xp, sim lvl 5)
    { "accept", 383 }, -- Vital Intelligence (lvl 5, ~335 xp, sim lvl 5)
    { "accept", 96656 }, -- The Adventurer (lvl 6, ~405 xp, sim lvl 5)
    { "accept", 8 }, -- A Rogue's Deal (lvl 5, ~110 xp, sim lvl 5)
    { "turnin", 96656, xp = 405 }, -- The Adventurer (lvl 6, ~405 xp, sim lvl 5)
    { "turnin", 383, xp = 335 }, -- Vital Intelligence (lvl 5, ~335 xp, sim lvl 5)
    { "turnin", 8, xp = 110 }, -- A Rogue's Deal (lvl 5, ~110 xp, sim lvl 6)
    { "turnin", 5651, xp = 90, classes = { "PRIEST" } }, -- In Favor of Darkness (lvl 4, ~90 xp, sim lvl 6)
  },
})
