local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 51 étapes, niveau final 55.00, ~62509 xp/h, 155 min.
Q:RegisterGuide({
  id = "H_26",
  title = "Felwood",
  faction = "Horde",
  minLevel = 54, maxLevel = 55,
  next = "H_27",
  sim = { steps = 51, endLevel = 55.00, xpPerHour = 62509, minutes = 155 },
  steps = {
    { "note", "Not running Zul'Farrak? Abandon Tabetha's Task", optional = true, dungeon = "Zul'Farrak" },
    { "goto", 1456, 47, 49.83, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 61, note = "Splintertree Post, Ashenvale" }, -- vol
    { "accept", 4102 }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 8460 }, -- Timbermaw Ally (lvl 48, ~3520 xp, sim lvl 54)
    { "complete", 8460, at = { 1448, 48.61, 91.57 } }, -- Timbermaw Ally (lvl 48, ~3520 xp, sim lvl 54)
    { "turnin", 8460, xp = 3520 }, -- Timbermaw Ally (lvl 48, ~3520 xp, sim lvl 54)
    { "accept", 8462 }, -- Speak to Nafien (lvl 55, ~560 xp, sim lvl 54)
    { "accept", 5155 }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 54)
    { "accept", 86577 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 54)
    { "accept", 8461 }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 54)
    { "turnin", 8462, xp = 560 }, -- Speak to Nafien (lvl 55, ~560 xp, sim lvl 54)
    { "complete", 8461, at = { 1448, 62.07, 8.44 } }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 54)
    { "turnin", 8461, xp = 5650 }, -- Deadwood of the North (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 8465 }, -- Speak to Salfa (lvl 55, ~0 xp, sim lvl 54)
    { "complete", 4102, at = { 1448, 58.31, 20.92 } }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 5202, at = { 1448, 39.53, 48.86 }, note = "Loot Blood Red Key to start the quest (5.2 % drop: about 20 kills)" }, -- A Strange Red Key (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 7601, classes = { "WARLOCK" } }, -- What Niby Commands (lvl 50, ~470 xp, sim lvl 54)
    { "turnin", 7601, xp = 470, classes = { "WARLOCK" } }, -- What Niby Commands (lvl 50, ~470 xp, sim lvl 54)
    { "fp", 1448, 34.44, 53.96 }, -- point de vol
    { "accept", 4505 }, -- Well of Corruption (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 6162 }, -- A Husband's Last Battle (lvl 51, ~4900 xp, sim lvl 54)
    { "turnin", 5202, xp = 5650 }, -- A Strange Red Key (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 5203 }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 54)
    { "complete", 5203, at = { 1448, 35.45, 59.06 } }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 54)
    { "complete", 5155, at = { 1448, 38.7, 60.78 } }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 54)
    { "turnin", 5203, xp = 5650 }, -- Rescue From Jaedenar (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 5204 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 54)
    { "turnin", 5155, xp = 4900 }, -- Forces of Jaedenar (lvl 51, ~4900 xp, sim lvl 54)
    { "accept", 5157 }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 54)
    { "complete", 6162, at = { 1448, 48.23, 94.28 } }, -- A Husband's Last Battle (lvl 51, ~4900 xp, sim lvl 54)
    { "turnin", 4102, xp = 5650 }, -- Cleansing Felwood (lvl 55, ~5650 xp, sim lvl 54)
    { "accept", 5887 }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 54)
    { "complete", 4505, at = { 1448, 32.32, 66.56 } }, -- Well of Corruption (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 5157, at = { 1448, 35.17, 59.79 } }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 54)
    { "turnin", 6162, xp = 4900 }, -- A Husband's Last Battle (lvl 51, ~4900 xp, sim lvl 54)
    { "turnin", 4505, xp = 5450 }, -- Well of Corruption (lvl 54, ~5450 xp, sim lvl 54)
    { "accept", 4506 }, -- Corrupted Sabers (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 4506, at = { 1448, 34.26, 52.32 } }, -- Corrupted Sabers (lvl 54, ~5450 xp, sim lvl 54)
    { "turnin", 4506, xp = 5450 }, -- Corrupted Sabers (lvl 54, ~5450 xp, sim lvl 54)
    { "complete", 5887, at = { 1448, 37.71, 46.16 } }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 54)
    { "complete", 5204, at = { 1448, 38.3, 50.51 } }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 54)
    { "turnin", 5204, xp = 4500 }, -- Retribution of the Light (lvl 57, ~4500 xp, sim lvl 54)
    { "accept", 5385 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 54)
    { "complete", 86577, obj = 1, at = { 1448, 43.67, 64.23 } }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 54)
    { "complete", 86577, at = { 1448, 44.95, 69.34 } }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 54)
    { "turnin", 5887, xp = 4200 }, -- Salve via Hunting (lvl 55, ~4200 xp, sim lvl 54)
    { "turnin", 86577, xp = 4200 }, -- A Sampling of Putrescence (lvl 55, ~4200 xp, sim lvl 54)
    { "turnin", 5157, xp = 3800 }, -- Collection of the Corrupt Water (lvl 52, ~3800 xp, sim lvl 54)
    { "turnin", 5385, xp = 7550 }, -- The Remains of Trey Lightforge (lvl 57, ~7550 xp, sim lvl 54)
    { "level", 55, at = { 1448, 44.95, 69.34 }, note = "About 179 more mobs near the last objective" }, -- farm de niveau
  },
})
