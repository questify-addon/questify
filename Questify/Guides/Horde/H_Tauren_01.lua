local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 42 étapes, niveau final 6.92, ~10234 xp/h, 64 min.
Q:RegisterGuide({
  id = "H_Tauren_01",
  title = "Camp Narache",
  faction = "Horde",
  races = { "Tauren" },
  minLevel = 1, maxLevel = 6,
  next = "H_Tauren_02",
  sim = { steps = 42, endLevel = 6.92, xpPerHour = 10234, minutes = 64 },
  steps = {
    { "accept", 752 }, -- A Humble Task (lvl 2, ~85 xp, sim lvl 1)
    { "accept", 747 }, -- The Hunt Begins (lvl 2, ~170 xp, sim lvl 1)
    { "complete", 747, at = { 1412, 44.79, 84.54 } }, -- The Hunt Begins (lvl 2, ~170 xp, sim lvl 1)
    { "turnin", 747, xp = 170 }, -- The Hunt Begins (lvl 2, ~170 xp, sim lvl 3)
    { "accept", 3091, classes = { "WARRIOR" } }, -- Simple Note (lvl 1, ~40 xp, sim lvl 3)
    { "accept", 3092, classes = { "HUNTER" } }, -- Etched Note (lvl 1, ~40 xp, sim lvl 3)
    { "accept", 3093, classes = { "SHAMAN" } }, -- Rune-Inscribed Note (lvl 1, ~40 xp, sim lvl 3)
    { "accept", 3094, classes = { "DRUID" } }, -- Verdant Note (lvl 1, ~40 xp, sim lvl 3)
    { "accept", 750 }, -- The Hunt Continues (lvl 3, ~250 xp, sim lvl 3)
    { "accept", 3376 }, -- Break Sharptusk! (lvl 5, ~670 xp, sim lvl 3)
    { "turnin", 3093, xp = 40, classes = { "SHAMAN" } }, -- Rune-Inscribed Note (lvl 1, ~40 xp, sim lvl 3)
    { "turnin", 3094, xp = 40, classes = { "DRUID" } }, -- Verdant Note (lvl 1, ~40 xp, sim lvl 3)
    { "turnin", 752, xp = 85 }, -- A Humble Task (lvl 2, ~85 xp, sim lvl 3)
    { "accept", 753 }, -- A Humble Task (lvl 3, ~250 xp, sim lvl 3)
    { "complete", 753, at = { 1412, 48.98, 81.16 } }, -- A Humble Task (lvl 3, ~250 xp, sim lvl 3)
    { "complete", 750, at = { 1412, 50.83, 88.66 } }, -- The Hunt Continues (lvl 3, ~250 xp, sim lvl 3)
    { "turnin", 750, xp = 250 }, -- The Hunt Continues (lvl 3, ~250 xp, sim lvl 3)
    { "accept", 780 }, -- The Battleboars (lvl 4, ~445 xp, sim lvl 4)
    { "turnin", 753, xp = 250 }, -- A Humble Task (lvl 3, ~250 xp, sim lvl 4)
    { "turnin", 3091, xp = 40, classes = { "WARRIOR" } }, -- Simple Note (lvl 1, ~40 xp, sim lvl 4)
    { "turnin", 3092, xp = 40, classes = { "HUNTER" } }, -- Etched Note (lvl 1, ~40 xp, sim lvl 4)
    { "accept", 755 }, -- Rites of the Earthmother (lvl 3, ~250 xp, sim lvl 4)
    { "turnin", 755, xp = 250 }, -- Rites of the Earthmother (lvl 3, ~250 xp, sim lvl 4)
    { "accept", 757 }, -- Rite of Strength (lvl 4, ~445 xp, sim lvl 4)
    { "complete", 780, at = { 1412, 54.33, 86.11 } }, -- The Battleboars (lvl 4, ~445 xp, sim lvl 4)
    { "accept", 781, at = { 1412, 59.8, 82.2 }, note = "Loot Dirt-stained Map to start the quest" }, -- Attack on Camp Narache (lvl 4, ~355 xp, sim lvl 5)
    { "complete", 757, at = { 1412, 60.89, 78.43 } }, -- Rite of Strength (lvl 4, ~445 xp, sim lvl 5)
    { "complete", 3376, at = { 1412, 61.02, 78 } }, -- Break Sharptusk! (lvl 5, ~670 xp, sim lvl 5)
    { "accept", 749 }, -- The Ravaged Caravan (lvl 8, ~530 xp, sim lvl 5)
    { "accept", 745 }, -- Sharing the Land (lvl 8, ~700 xp, sim lvl 5)
    { "complete", 745, obj = 3, at = { 1412, 51.94, 73.68 } }, -- Sharing the Land (lvl 8, ~700 xp, sim lvl 5)
    { "turnin", 780, xp = 445 }, -- The Battleboars (lvl 4, ~445 xp, sim lvl 5)
    { "turnin", 3376, xp = 670 }, -- Break Sharptusk! (lvl 5, ~670 xp, sim lvl 5)
    { "turnin", 781, xp = 355 }, -- Attack on Camp Narache (lvl 4, ~355 xp, sim lvl 5)
    { "turnin", 757, xp = 445 }, -- Rite of Strength (lvl 4, ~445 xp, sim lvl 6)
    { "accept", 763 }, -- Rites of the Earthmother (lvl 5, ~335 xp, sim lvl 6)
    { "accept", 98430 }, -- The Longwalkers (lvl 8, ~0 xp, sim lvl 6)
    { "complete", 98430, at = { 1412, 37.19, 64.62 } }, -- The Longwalkers (lvl 8, ~0 xp, sim lvl 6)
    { "complete", 745, at = { 1412, 35.97, 65.02 } }, -- Sharing the Land (lvl 8, ~700 xp, sim lvl 6)
    { "turnin", 745, xp = 700 }, -- Sharing the Land (lvl 8, ~700 xp, sim lvl 6)
    { "turnin", 763, xp = 335 }, -- Rites of the Earthmother (lvl 5, ~335 xp, sim lvl 6)
    { "turnin", 749, xp = 530 }, -- The Ravaged Caravan (lvl 8, ~530 xp, sim lvl 6)
  },
})
