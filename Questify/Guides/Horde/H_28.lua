local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 47 étapes, niveau final 57.00, ~48297 xp/h, 233 min.
Q:RegisterGuide({
  id = "H_28",
  title = "Felwood and Winterspring",
  faction = "Horde",
  minLevel = 56, maxLevel = 57,
  next = "H_29",
  sim = { steps = 47, endLevel = 57.00, xpPerHour = 48297, minutes = 233 },
  steps = {
    { "goto", 1446, 51.6, 25.44, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 61, note = "Splintertree Post, Ashenvale" }, -- vol
    { "accept", 5156 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "accept", 4521 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 4521, obj = 2, at = { 1452, 54.48, 37.45 } }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 56)
    { "fp", 1452, 60.47, 36.3 }, -- point de vol
    { "accept", 6603 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 56)
    { "accept", 3783 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "accept", 92859 },
    { "turnin", 92859, xp = 6600 },
    { "accept", 5054 }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 3783, at = { 1452, 66.83, 42.67 } }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "accept", 6029 }, -- The Everlook Report (lvl 52, ~0 xp, sim lvl 56)
    { "accept", 6030 }, -- Duke Nicholas Zverenhoff (lvl 52, ~0 xp, sim lvl 56)
    { "accept", 5601 }, -- Sister Pamela (lvl 55, ~0 xp, sim lvl 56)
    { "turnin", 3783, xp = 4350 }, -- Are We There, Yeti? (lvl 56, ~4350 xp, sim lvl 56)
    { "accept", 977 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "complete", 5054, at = { 1452, 60.92, 32.9 } }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 4521, at = { 1452, 60.94, 30.59 } }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 56)
    { "accept", 8464 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "turnin", 8465, xp = 560 }, -- Speak to Salfa (lvl 55, ~560 xp, sim lvl 56)
    { "complete", 5156, at = { 1448, 43.73, 40.16 } }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "complete", 5156, at = { 1448, 41.03, 41.96 } }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "turnin", 4521, xp = 5800 }, -- Wild Guardians (lvl 56, ~5800 xp, sim lvl 56)
    { "accept", 4741 }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 56)
    { "turnin", 980, xp = 2800 }, -- The New Springs (lvl 55, ~2800 xp, sim lvl 56)
    { "turnin", 6603, xp = 580 }, -- Trouble in Winterspring! (lvl 56, ~580 xp, sim lvl 56)
    { "accept", 5082 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 4741, at = { 1452, 64.1, 21.8 } }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 56)
    { "complete", 5082, obj = 2, at = { 1452, 66.47, 34.66 } }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "complete", 8464, at = { 1452, 67.73, 35.93 } }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "complete", 977, at = { 1452, 70.84, 39.16 } }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "turnin", 5054, xp = 5800 }, -- Ursius of the Shardtooth (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 977, xp = 4650 }, -- Are We There, Yeti? (lvl 58, ~4650 xp, sim lvl 56)
    { "goto", 1452, 60.47, 36.3, note = "Flight master" }, -- déplacement
    { "fly", 1448, node = 48, note = "Bloodvenom Post, Felwood" }, -- vol
    { "turnin", 5156, xp = 6800 }, -- Verifying the Corruption (lvl 54, ~6800 xp, sim lvl 56)
    { "turnin", 4741, xp = 6200 }, -- Wild Guardians (lvl 58, ~6200 xp, sim lvl 56)
    { "accept", 4721 }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 56)
    { "turnin", 8464, xp = 6200 }, -- Winterfall Activity (lvl 58, ~6200 xp, sim lvl 56)
    { "complete", 4721, at = { 1452, 64.35, 22.54 } }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 56)
    { "accept", 4882, at = { 1452, 65.3, 22.14 }, note = "Loot Blue-feathered Necklace to start the quest (4.0 % drop: about 25 kills)" }, -- Guarding Secrets (lvl 59, ~3200 xp, sim lvl 56)
    { "complete", 5082, at = { 1452, 41.52, 43.15 } }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 5082, xp = 5800 }, -- Threat of the Winterfall (lvl 56, ~5800 xp, sim lvl 56)
    { "turnin", 4721, xp = 6400 }, -- Wild Guardians (lvl 59, ~6400 xp, sim lvl 56)
    { "turnin", 4882, xp = 3200 }, -- Guarding Secrets (lvl 59, ~3200 xp, sim lvl 56)
    { "level", 57, at = { 1452, 41.52, 43.15 }, note = "About 234 more mobs near the last objective" }, -- farm de niveau
  },
})
