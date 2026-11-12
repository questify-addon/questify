local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 62 étapes, niveau final 39.04, ~39045 xp/h, 110 min.
Q:RegisterGuide({
  id = "H_11",
  title = "Arathi Highlands",
  faction = "Horde",
  minLevel = 38, maxLevel = 39,
  next = "H_12",
  sim = { steps = 62, endLevel = 39.04, xpPerHour = 39045, minutes = 110 },
  steps = {
    { "hearth", 1413 }, -- pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "boat", 1411, 50.8, 13.5, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "goto", 1458, 63.25, 48.56, note = "Flight master" }, -- déplacement
    { "fly", 1417, node = 17, note = "Hammerfall, Arathi" }, -- vol
    { "accept", 677 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 638, xp = 710 }, -- Trollbane (lvl 37, ~710 xp, sim lvl 38)
    { "accept", 701 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 79242, xp = 3900 }, -- No Honor Among Thieves (lvl 40, ~3900 xp, sim lvl 38)
    { "turnin", 79974, xp = 2040 }, -- Wet Job (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79975 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "complete", 677, obj = 2, at = { 1417, 68.8, 76.69 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "complete", 677, at = { 1417, 62.26, 71.04 } }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "turnin", 677, xp = 2040 }, -- Call to Arms (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 678 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "complete", 701, at = { 1417, 51.72, 66.78 } }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "complete", 678, at = { 1417, 53.46, 75.05 } }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "accept", 79678 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 79678, xp = 3150 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 701, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "accept", 702 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 38)
    { "turnin", 678, xp = 2850 }, -- Call to Arms (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 702, xp = 285 }, -- Guile of the Raptor (lvl 37, ~285 xp, sim lvl 38)
    { "accept", 847 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 38)
    { "turnin", 79975, xp = 2040 }, -- Eagle's Fist (lvl 32, ~2040 xp, sim lvl 38)
    { "accept", 79976 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "turnin", 79976, xp = 1560 }, -- This Must Be The Place (lvl 32, ~1560 xp, sim lvl 38)
    { "accept", 96784, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 503 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 566 }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "sethearth", 1424, 62.78, 19.03 }, -- lier la pierre de foyer
    { "accept", 95534, at = { 1416, 61.77, 43.22 }, note = "Loot Singed Note to start the quest (20.0 % drop: about 5 kills)" }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 38)
    { "complete", 503, at = { 1416, 61.9, 42.38 } }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 503, xp = 2800 }, -- Gol'dir (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 506 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "complete", 566, at = { 1416, 57.04, 28.25 } }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 566, xp = 3150 }, -- WANTED: Baron Vardus (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 506, xp = 2100 }, -- Blackmoore's Legacy (lvl 36, ~2100 xp, sim lvl 38)
    { "turnin", 95534, xp = 2800 }, -- Strahnbrad Mystery (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 96783, classes = { "ROGUE" } }, -- A Way In (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 96783, xp = 2800, classes = { "ROGUE" } }, -- A Way In (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 663 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "turnin", 663, xp = 690 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 38)
    { "turnin", 96784, xp = 2800, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 38)
    { "accept", 662 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 664 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 665 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 665, at = { 1417, 33.87, 80.6 } }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 665, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 38)
    { "accept", 666 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 666, at = { 1417, 23.62, 88.25 } }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "complete", 662, at = { 1417, 23.05, 84.51 } }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "complete", 664, at = { 1417, 23.27, 87.78 } }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 666, xp = 3900 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 38)
    { "accept", 668 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "turnin", 662, xp = 3150 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 664, xp = 3150 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 38)
    { "turnin", 668, xp = 1550 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 38)
    { "accept", 669 }, -- Sunken Treasure (lvl 40, ~0 xp, sim lvl 39)
    { "turnin", 847, xp = 2850 }, -- Guile of the Raptor (lvl 37, ~2850 xp, sim lvl 39)
  },
})
