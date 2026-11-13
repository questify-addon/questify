local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 53 étapes, niveau final 56.00, ~52629 xp/h, 206 min.
Q:RegisterGuide({
  id = "AD_29",
  title = "Felwood",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 54, maxLevel = 56,
  next = "AD_30",
  sim = { steps = 53, endLevel = 56.00, xpPerHour = 52629, minutes = 206 },
  steps = {
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)", alt = "BRD", below = 56 }, -- bateau
    { "fp", 1448, 62.49, 24.24, alt = "BRD", below = 56 }, -- point de vol
    { "accept", 4421, alt = "BRD", below = 56 }, -- The Corruption of the Jadefire (lvl 54, ~5450 xp, sim lvl 55)
    { "accept", 86577, alt = "BRD", below = 56 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 55)
    { "accept", 5155, alt = "BRD", below = 56 }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 55)
    { "accept", 8460, alt = "BRD", below = 56 }, -- Timbermaw Ally (lvl 48, ~2640 xp, sim lvl 55)
    { "accept", 4101, alt = "BRD", below = 56 }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 55)
    { "complete", 4101, at = { 1448, 58.31, 20.92 }, alt = "BRD", below = 56 }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 55)
    { "accept", 86611, alt = "BRD", below = 56 }, -- Stag Lord's Bauble (lvl 55, ~1400 xp, sim lvl 55)
    { "accept", 7601, alt = "BRD", below = 56, classes = { "WARLOCK" } }, -- What Niby Commands (lvl 50, ~375 xp, sim lvl 55)
    { "turnin", 7601, xp = 375, alt = "BRD", below = 56, classes = { "WARLOCK" } }, -- What Niby Commands (lvl 50, ~375 xp, sim lvl 55)
    { "accept", 5202, at = { 1448, 39.53, 48.86 }, note = "Loot Blood Red Key to start the quest (5.2 % drop: about 20 kills)", alt = "BRD", below = 56 }, -- A Strange Red Key (lvl 55, ~5650 xp, sim lvl 55)
    { "turnin", 5202, xp = 5650, alt = "BRD", below = 56 }, -- A Strange Red Key (lvl 55, ~5650 xp, sim lvl 55)
    { "accept", 5203, alt = "BRD", below = 56 }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 55)
    { "complete", 5203, at = { 1448, 35.45, 59.06 }, alt = "BRD", below = 56 }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 55)
    { "complete", 5155, at = { 1448, 38.7, 60.78 }, alt = "BRD", below = 56 }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 55)
    { "complete", 4421, obj = 4, at = { 1448, 32.23, 67.11 }, alt = "BRD", below = 56 }, -- The Corruption of the Jadefire (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 4421, at = { 1448, 37.38, 68.62 }, alt = "BRD", below = 56 }, -- The Corruption of the Jadefire (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 4421, at = { 1448, 43.09, 87.46 }, alt = "BRD", below = 56 }, -- The Corruption of the Jadefire (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 8460, at = { 1448, 48.61, 91.57 }, alt = "BRD", below = 56 }, -- Timbermaw Ally (lvl 48, ~2640 xp, sim lvl 55)
    { "turnin", 4101, xp = 5650, alt = "BRD", below = 56 }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 55)
    { "accept", 5882, alt = "BRD", below = 56 }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 55)
    { "turnin", 8460, xp = 2640, alt = "BRD", below = 56 }, -- Timbermaw Ally (lvl 48, ~2640 xp, sim lvl 55)
    { "accept", 8462, alt = "BRD", below = 56 }, -- Speak to Nafien (lvl 55, ~560 xp, sim lvl 55)
    { "turnin", 5155, xp = 4900, alt = "BRD", below = 56 }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 55)
    { "accept", 5157, alt = "BRD", below = 56 }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 55)
    { "turnin", 5203, xp = 5650, alt = "BRD", below = 56 }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 55)
    { "accept", 5204, alt = "BRD", below = 56 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 55)
    { "turnin", 4421, xp = 5450, alt = "BRD", below = 56 }, -- The Corruption of the Jadefire (lvl 54, ~5450 xp, sim lvl 55)
    { "accept", 4906, alt = "BRD", below = 56 }, -- Further Corruption (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 86577, obj = 2, at = { 1448, 44.95, 69.34 }, alt = "BRD", below = 56 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 55)
    { "complete", 86577, at = { 1448, 43.67, 64.23 }, alt = "BRD", below = 56 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 55)
    { "complete", 5157, at = { 1448, 35.17, 59.79 }, alt = "BRD", below = 56 }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 55)
    { "complete", 5204, at = { 1448, 38.3, 50.51 }, alt = "BRD", below = 56 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 55)
    { "turnin", 5204, xp = 4500, alt = "BRD", below = 56 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 55)
    { "accept", 5385, alt = "BRD", below = 56 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 55)
    { "complete", 5882, at = { 1448, 37.71, 46.16 }, alt = "BRD", below = 56 }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 55)
    { "accept", 939, at = { 1448, 39.07, 22.35 }, note = "Loot Flute of Xavaric to start the quest (36.4 % drop: about 3 kills)", alt = "BRD", below = 56 }, -- Flute of Xavaric (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 4906, at = { 1448, 39.85, 21.18 }, alt = "BRD", below = 56 }, -- Further Corruption (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 4906, at = { 1448, 42.08, 18.83 }, alt = "BRD", below = 56 }, -- Further Corruption (lvl 54, ~5450 xp, sim lvl 55)
    { "complete", 939, at = { 1448, 43.11, 15.57 }, alt = "BRD", below = 56 }, -- Flute of Xavaric (lvl 54, ~5450 xp, sim lvl 55)
    { "accept", 8461, alt = "BRD", below = 56 }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 55)
    { "turnin", 8462, xp = 560, alt = "BRD", below = 56 }, -- Speak to Nafien (lvl 55, ~560 xp, sim lvl 55)
    { "complete", 8461, at = { 1448, 62.07, 8.44 }, alt = "BRD", below = 56 }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 55)
    { "turnin", 8461, xp = 5650, alt = "BRD", below = 56 }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 55)
    { "turnin", 86611, xp = 1400, alt = "BRD", below = 56 }, -- Stag Lord's Bauble (lvl 55, ~1400 xp, sim lvl 55)
    { "turnin", 939, xp = 5450, alt = "BRD", below = 56 }, -- Flute of Xavaric (lvl 54, ~5450 xp, sim lvl 55)
    { "turnin", 4906, xp = 5450, alt = "BRD", below = 56 }, -- Further Corruption (lvl 54, ~5450 xp, sim lvl 55)
    { "turnin", 86577, xp = 4200, alt = "BRD", below = 56 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 55)
    { "turnin", 5157, xp = 3800, alt = "BRD", below = 56 }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 55)
    { "turnin", 5385, xp = 7550, alt = "BRD", below = 56 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 55)
    { "turnin", 5882, xp = 4200, alt = "BRD", below = 56 }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 55)
    { "level", 56, at = { 1448, 62.07, 8.44 }, note = "About 78 more mobs near the last objective", alt = "BRD", below = 56 }, -- farm de niveau
  },
})
