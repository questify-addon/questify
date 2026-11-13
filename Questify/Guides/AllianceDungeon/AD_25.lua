local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 72 étapes, niveau final 51.00, ~55795 xp/h, 414 min.
Q:RegisterGuide({
  id = "AD_25",
  title = "Searing Gorge and Blasted Lands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 48, maxLevel = 51,
  next = "AD_26",
  sim = { steps = 72, endLevel = 51.00, xpPerHour = 55795, minutes = 414 },
  steps = {
    { "accept", 81900 }, -- The Burning Beast (lvl 54, ~4100 xp, sim lvl 48)
    { "fp", 1427, 37.94, 30.86 }, -- point de vol
    { "accept", 3441 }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 48)
    { "complete", 3441, at = { 1427, 39.06, 38.99 } }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 48)
    { "turnin", 3441, xp = 440 }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 48)
    { "accept", 3442 }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 48)
    { "accept", 4451, at = { 1427, 42.12, 34.65 }, note = "Loot Grimesilt Outhouse Key to start the quest (5.2 % drop: about 20 kills)" }, -- The Key to Freedom (lvl 47, ~5250 xp, sim lvl 48)
    { "accept", 7727 }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 48)
    { "accept", 7724 }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 48)
    { "accept", 7723 }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 48)
    { "accept", 7729 }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 48)
    { "accept", 7728 }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 48)
    { "complete", 7727, at = { 1427, 48.4, 24.03 } }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 48)
    { "complete", 3442, at = { 1427, 54.57, 47.42 } }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 48)
    { "accept", 4449 }, -- Caught! (lvl 45, ~3900 xp, sim lvl 48)
    { "turnin", 4451, xp = 5250 }, -- The Key to Freedom (lvl 47, ~5250 xp, sim lvl 48)
    { "accept", 3367 }, -- Suntara Stones (lvl 48, ~4400 xp, sim lvl 48)
    { "complete", 4449, obj = 1, at = { 1427, 63.3, 60.56 } }, -- Caught! (lvl 45, ~3900 xp, sim lvl 48)
    { "complete", 4449, at = { 1427, 46.81, 53.53 } }, -- Caught! (lvl 45, ~3900 xp, sim lvl 48)
    { "complete", 7724, at = { 1427, 28.59, 72.01 } }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 48)
    { "complete", 7728, obj = 2, at = { 1427, 33.01, 53.96 } }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 48)
    { "accept", 81955 }, -- A Mind of Metal (lvl 45, ~975 xp, sim lvl 48)
    { "complete", 81955, at = { 1427, 37.85, 49.45 } }, -- A Mind of Metal (lvl 45, ~975 xp, sim lvl 48)
    { "complete", 7728, at = { 1427, 39.88, 50.1 } }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 48)
    { "turnin", 3442, xp = 4400 }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 48)
    { "complete", 7723, at = { 1427, 43.63, 41.32 } }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 48)
    { "complete", 7729, at = { 1427, 43.75, 35.25 } }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 48)
    { "turnin", 7723, xp = 4550 }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 48)
    { "turnin", 7727, xp = 4550 }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 48)
    { "turnin", 7724, xp = 4550 }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 48)
    { "turnin", 7728, xp = 4400 }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 48)
    { "turnin", 7729, xp = 4400 }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 48)
    { "complete", 3367, at = { 1427, 74.47, 19.44 } }, -- Suntara Stones (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 3367, xp = 4400 }, -- Suntara Stones (lvl 48, ~4400 xp, sim lvl 49)
    { "accept", 3368 }, -- Suntara Stones (lvl 48, ~4400 xp, sim lvl 49)
    { "turnin", 4449, xp = 3900 }, -- Caught! (lvl 45, ~3900 xp, sim lvl 49)
    { "accept", 3181, at = { 1427, 73.52, 82.31 }, note = "Loot Margol's Horn to start the quest (86.0 % drop: about 2 kills)" }, -- The Horn of the Beast (lvl 48, ~5450 xp, sim lvl 49)
    { "hearth", 1434 }, -- pierre de foyer
    { "goto", 1434, 27.53, 77.79, note = "Flight master" }, -- déplacement
    { "fly", 1419, node = 45, note = "Nethergarde Keep, Blasted Lands" }, -- vol
    { "accept", 2603 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 49)
    { "accept", 2601 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 49)
    { "turnin", 81900, xp = 4100 }, -- The Burning Beast (lvl 54, ~4100 xp, sim lvl 49)
    { "accept", 87295 }, -- Deflective Surface (lvl 52, ~5100 xp, sim lvl 49)
    { "accept", 96799 }, -- A Heavy Responsibility (lvl 54, ~4100 xp, sim lvl 49)
    { "accept", 96798 }, -- Into the Darkness (lvl 54, ~5450 xp, sim lvl 49)
    { "turnin", 1425, xp = 1530 }, -- Deliver the Shipment (lvl 42, ~1530 xp, sim lvl 49)
    { "turnin", 96798, xp = 5450 }, -- Into the Darkness (lvl 54, ~5450 xp, sim lvl 49)
    { "accept", 96811 }, -- Escaping the Shadows (lvl 54, ~4100 xp, sim lvl 49)
    { "complete", 87295, at = { 1419, 59.85, 38.53 } }, -- Deflective Surface (lvl 52, ~5100 xp, sim lvl 49)
    { "complete", 2603, at = { 1419, 55.15, 36.6 } }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 49)
    { "accept", 81956 }, -- Conjurer's Codex (lvl 45, ~975 xp, sim lvl 49)
    { "complete", 81956, at = { 1419, 55.43, 32.3 } }, -- Conjurer's Codex (lvl 45, ~975 xp, sim lvl 49)
    { "turnin", 96811, xp = 4100 }, -- Escaping the Shadows (lvl 54, ~4100 xp, sim lvl 49)
    { "turnin", 96799, xp = 4100 }, -- A Heavy Responsibility (lvl 54, ~4100 xp, sim lvl 49)
    { "turnin", 87295, xp = 5100 }, -- Deflective Surface (lvl 52, ~5100 xp, sim lvl 49)
    { "complete", 2601, at = { 1419, 45.74, 22.7 } }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 49)
    { "turnin", 2601, xp = 4700 }, -- The Basilisk's Bite (lvl 50, ~4700 xp, sim lvl 49)
    { "turnin", 2603, xp = 4700 }, -- Vulture's Vigor (lvl 50, ~4700 xp, sim lvl 49)
    { "goto", 1419, 65.54, 24.34, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "turnin", 81955, xp = 975 }, -- A Mind of Metal (lvl 45, ~975 xp, sim lvl 49)
    { "turnin", 81956, xp = 975 }, -- Conjurer's Codex (lvl 45, ~975 xp, sim lvl 49)
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1432, node = 8, note = "Thelsamar, Loch Modan" }, -- vol
    { "turnin", 3181, xp = 5450 }, -- The Horn of the Beast (lvl 48, ~5450 xp, sim lvl 49)
    { "goto", 1432, 33.94, 50.95, note = "Flight master" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "turnin", 3368, xp = 4400 }, -- Suntara Stones (lvl 48, ~4400 xp, sim lvl 49)
    { "goto", 1455, 55.5, 47.74, note = "Flight master" }, -- déplacement
    { "fly", 1419, node = 45, note = "Nethergarde Keep, Blasted Lands" }, -- vol
    { "level", 51, at = { 1419, 51.78, 39.14 }, note = "About 718 more mobs here (Felbeast, level 50)" }, -- farm de niveau
  },
})
