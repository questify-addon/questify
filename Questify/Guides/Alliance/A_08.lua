local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 71 étapes, niveau final 32.00, ~30528 xp/h, 193 min.
Q:RegisterGuide({
  id = "A_08",
  title = "Ashenvale",
  faction = "Alliance",
  minLevel = 30, maxLevel = 32,
  next = "A_07",
  sim = { steps = 71, endLevel = 32.00, xpPerHour = 30528, minutes = 193 },
  steps = {
    { "note", "Not running The Deadmines? Abandon Oh Brother. . ., Collecting Memories, Underground Assault", optional = true, dungeon = "The Deadmines" },
    { "note", "Not running The Hall of Thanes? Abandon Old Ironforge Incursion", optional = true, dungeon = "The Hall of Thanes" },
    { "note", "Not running The Stockade? Abandon Crime and Punishment, What Comes Around...", optional = true, dungeon = "The Stockade" },
    { "boat", 1424, 50.5, 67, note = "Take the boat to Auberdine" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 28, note = "Astranaar, Ashenvale" }, -- vol
    { "accept", 1022 }, -- The Howling Vale (lvl 30, ~2450 xp, sim lvl 30)
    { "accept", 1021 }, -- Vile Satyr! Dryads in Danger! (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 1033 }, -- Elune's Tear (lvl 22, ~700 xp, sim lvl 30)
    { "accept", 1054 }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 1024 }, -- Raene's Cleansing (lvl 21, ~165 xp, sim lvl 30)
    { "complete", 1054, at = { 1440, 39.61, 36.31 } }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 30)
    { "complete", 1022, at = { 1440, 50.49, 39.13 } }, -- The Howling Vale (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 1024, xp = 165 }, -- Raene's Cleansing (lvl 21, ~165 xp, sim lvl 30)
    { "accept", 1026 }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 30)
    { "complete", 1026, at = { 1440, 54.42, 35.4 } }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 30)
    { "turnin", 1026, xp = 2200 }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 30)
    { "accept", 1027 }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 30)
    { "turnin", 1021, xp = 2550 }, -- Vile Satyr! Dryads in Danger! (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 1031 }, -- The Branch of Cenarius (lvl 32, ~2550 xp, sim lvl 30)
    { "complete", 1031, at = { 1440, 77.99, 42.42 } }, -- The Branch of Cenarius (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 1011 }, -- Forsaken Diseases (lvl 29, ~2350 xp, sim lvl 30)
    { "accept", 98418 }, -- Shared Fury (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 1011, at = { 1440, 75.3, 72 } }, -- Forsaken Diseases (lvl 29, ~2350 xp, sim lvl 30)
    { "complete", 1027, at = { 1440, 75.72, 69.27 } }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 30)
    { "turnin", 1011, xp = 2350 }, -- Forsaken Diseases (lvl 29, ~2350 xp, sim lvl 30)
    { "accept", 1012 }, -- Insane Druids (lvl 32, ~3200 xp, sim lvl 30)
    { "complete", 98418, at = { 1440, 78.27, 46.01 } }, -- Shared Fury (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 1027, xp = 2300 }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 30)
    { "accept", 1028 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 30)
    { "turnin", 1028, xp = 1700 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 30)
    { "accept", 1055 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 30)
    { "turnin", 1055, xp = 230 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 1029 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 30)
    { "complete", 1033, at = { 1440, 46.37, 46.39 } }, -- Elune's Tear (lvl 22, ~700 xp, sim lvl 30)
    { "turnin", 1033, xp = 700 }, -- Elune's Tear (lvl 22, ~700 xp, sim lvl 30)
    { "accept", 1034 }, -- The Ruins of Stardust (lvl 23, ~1110 xp, sim lvl 30)
    { "turnin", 1029, xp = 230 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 30)
    { "accept", 1030 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 30)
    { "turnin", 1054, xp = 2000 }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 30)
    { "accept", 4581 }, -- Kayneth Stillwind (lvl 29, ~590 xp, sim lvl 30)
    { "turnin", 1022, xp = 2450 }, -- The Howling Vale (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 1031, xp = 2550 }, -- The Branch of Cenarius (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 1032 }, -- Satyr Slaying! (lvl 32, ~2550 xp, sim lvl 30)
    { "complete", 1034, at = { 1440, 33.3, 67.8 } }, -- The Ruins of Stardust (lvl 23, ~1110 xp, sim lvl 30)
    { "turnin", 1034, xp = 1110 }, -- The Ruins of Stardust (lvl 23, ~1110 xp, sim lvl 30)
    { "accept", 1035 }, -- Fallen Sky Lake (lvl 30, ~3050 xp, sim lvl 30)
    { "accept", 86757 }, -- Slowing the Orc Advance (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 1030, xp = 1700 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 30)
    { "accept", 1045 }, -- Raene's Cleansing (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 1045, at = { 1440, 54.75, 79.62 } }, -- Raene's Cleansing (lvl 30, ~2450 xp, sim lvl 30)
    { "complete", 1035, at = { 1440, 66.66, 82.17 } }, -- Fallen Sky Lake (lvl 30, ~3050 xp, sim lvl 30)
    { "complete", 1012, at = { 1440, 77.18, 73.99 } }, -- Insane Druids (lvl 32, ~3200 xp, sim lvl 30)
    { "complete", 86757, at = { 1440, 89.27, 57.58 } }, -- Slowing the Orc Advance (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 98418, xp = 2450 }, -- Shared Fury (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 4581, xp = 590 }, -- Kayneth Stillwind (lvl 29, ~590 xp, sim lvl 30)
    { "turnin", 1012, xp = 3200 }, -- Insane Druids (lvl 32, ~3200 xp, sim lvl 30)
    { "complete", 1032, at = { 1440, 81.02, 49.88 } }, -- Satyr Slaying! (lvl 32, ~2550 xp, sim lvl 30)
    { "accept", 98027 }, -- Gleaming Crescent Necklace (lvl 26, ~1050 xp, sim lvl 30)
    { "turnin", 1045, xp = 2450 }, -- Raene's Cleansing (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 86757, xp = 2450 }, -- Slowing the Orc Advance (lvl 30, ~2450 xp, sim lvl 30)
    { "turnin", 1035, xp = 3050 }, -- Fallen Sky Lake (lvl 30, ~3050 xp, sim lvl 30)
    { "turnin", 98027, xp = 1050 }, -- Gleaming Crescent Necklace (lvl 26, ~1050 xp, sim lvl 31)
    { "turnin", 1032, xp = 2550 }, -- Satyr Slaying! (lvl 32, ~2550 xp, sim lvl 31)
    { "accept", 1007 }, -- The Ancient Statuette (lvl 20, ~115 xp, sim lvl 31)
    { "complete", 1007, at = { 1440, 14.2, 20.64 } }, -- The Ancient Statuette (lvl 20, ~115 xp, sim lvl 31)
    { "turnin", 1007, xp = 115 }, -- The Ancient Statuette (lvl 20, ~115 xp, sim lvl 31)
    { "accept", 1009 }, -- Ruuzel (lvl 25, ~1600 xp, sim lvl 31)
    { "complete", 1009, at = { 1440, 7.22, 13.06 } }, -- Ruuzel (lvl 25, ~1600 xp, sim lvl 31)
    { "turnin", 1009, xp = 1600 }, -- Ruuzel (lvl 25, ~1600 xp, sim lvl 31)
    { "level", 32, at = { 1440, 7.22, 13.06 }, note = "About 240 more mobs near the last objective" }, -- farm de niveau
  },
})
