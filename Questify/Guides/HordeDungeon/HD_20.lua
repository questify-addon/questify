local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 70 étapes, niveau final 47.00, ~49903 xp/h, 289 min.
Q:RegisterGuide({
  id = "HD_20",
  title = "Feralas",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 45, maxLevel = 47,
  next = "HD_21",
  sim = { steps = 70, endLevel = 47.00, xpPerHour = 49903, minutes = 289 },
  steps = {
    { "fp", 1449, 45.23, 5.83, alt = { "MARAUDON", "ZF" }, below = 47 }, -- point de vol
    { "fp", 1444, 75.45, 44.36, alt = { "MARAUDON", "ZF" }, below = 47 }, -- point de vol
    { "accept", 3062, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Heart (lvl 50, ~5900 xp, sim lvl 45)
    { "accept", 2975, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 43, ~2700 xp, sim lvl 45)
    { "accept", 2987, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Gordunni Cobalt (lvl 43, ~3600 xp, sim lvl 45)
    { "accept", 2973, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A New Cloak's Sheen (lvl 45, ~3900 xp, sim lvl 45)
    { "accept", 2862, alt = { "MARAUDON", "ZF" }, below = 47 }, -- War on the Woodpaw (lvl 42, ~2550 xp, sim lvl 45)
    { "accept", 2822, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 45)
    { "accept", 3121, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Strange Request (lvl 45, ~1950 xp, sim lvl 45)
    { "accept", 2978, at = { 1444, 80.55, 34.29 }, note = "Loot Gordunni Scroll to start the quest", alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Gordunni Scroll (lvl 43, ~1800 xp, sim lvl 45)
    { "complete", 2975, at = { 1444, 74.78, 26.47 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 43, ~2700 xp, sim lvl 45)
    { "complete", 2987, at = { 1444, 75.97, 33.44 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Gordunni Cobalt (lvl 43, ~3600 xp, sim lvl 45)
    { "complete", 2862, at = { 1444, 72.51, 37.63 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- War on the Woodpaw (lvl 42, ~2550 xp, sim lvl 45)
    { "turnin", 2862, xp = 2550, alt = { "MARAUDON", "ZF" }, below = 47 }, -- War on the Woodpaw (lvl 42, ~2550 xp, sim lvl 45)
    { "accept", 2863, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Alpha Strike (lvl 43, ~2700 xp, sim lvl 45)
    { "complete", 2863, at = { 1444, 65.63, 52.47 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Alpha Strike (lvl 43, ~2700 xp, sim lvl 45)
    { "complete", 2822, at = { 1444, 52.05, 58.58 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 45)
    { "complete", 2973, at = { 1444, 66.91, 47.29 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A New Cloak's Sheen (lvl 45, ~3900 xp, sim lvl 45)
    { "turnin", 2822, xp = 4050, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Mark of Quality (lvl 46, ~4050 xp, sim lvl 45)
    { "accept", 7734, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Improved Quality (lvl 48, ~4400 xp, sim lvl 45)
    { "turnin", 2863, xp = 2700, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Alpha Strike (lvl 43, ~2700 xp, sim lvl 45)
    { "accept", 2902, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Woodpaw Investigation (lvl 43, ~1800 xp, sim lvl 45)
    { "turnin", 2973, xp = 3900, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A New Cloak's Sheen (lvl 45, ~3900 xp, sim lvl 45)
    { "accept", 2974, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Grim Discovery (lvl 45, ~3900 xp, sim lvl 45)
    { "turnin", 2978, xp = 1800, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Gordunni Scroll (lvl 43, ~1800 xp, sim lvl 45)
    { "turnin", 2975, xp = 2700, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 43, ~2700 xp, sim lvl 45)
    { "accept", 2979, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Ceremony (lvl 46, ~4050 xp, sim lvl 45)
    { "accept", 2980, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 44, ~3750 xp, sim lvl 45)
    { "turnin", 2987, xp = 3600, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Gordunni Cobalt (lvl 43, ~3600 xp, sim lvl 45)
    { "turnin", 2902, xp = 1800, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Woodpaw Investigation (lvl 43, ~1800 xp, sim lvl 45)
    { "accept", 2903, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Battle Plans (lvl 43, ~3600 xp, sim lvl 45)
    { "accept", 92878, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Lost for Words (lvl 43, ~4450 xp, sim lvl 45)
    { "turnin", 2903, xp = 3600, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Battle Plans (lvl 43, ~3600 xp, sim lvl 45)
    { "accept", 7730, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Zukk'ash Infestation (lvl 45, ~3900 xp, sim lvl 45)
    { "accept", 7731, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Stinglasher (lvl 47, ~4200 xp, sim lvl 45)
    { "complete", 2974, at = { 1444, 69.29, 39.31 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Grim Discovery (lvl 45, ~3900 xp, sim lvl 45)
    { "complete", 92878, at = { 1444, 67, 38.86 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Lost for Words (lvl 43, ~4450 xp, sim lvl 45)
    { "complete", 7734, at = { 1444, 54.73, 32.76 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Improved Quality (lvl 48, ~4400 xp, sim lvl 45)
    { "complete", 3062, at = { 1444, 40.55, 8.6 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Heart (lvl 50, ~5900 xp, sim lvl 45)
    { "complete", 2980, at = { 1444, 60.26, 66.29 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 44, ~3750 xp, sim lvl 45)
    { "complete", 2979, at = { 1444, 60.44, 69.41 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Ceremony (lvl 46, ~4050 xp, sim lvl 45)
    { "accept", 81924, alt = { "MARAUDON", "ZF" }, below = 47, classes = { "DRUID" } }, -- Wisdom of the Guardians (lvl 50, ~5900 xp, sim lvl 45)
    { "turnin", 81924, xp = 5900, alt = { "MARAUDON", "ZF" }, below = 47, classes = { "DRUID" } }, -- Wisdom of the Guardians (lvl 50, ~5900 xp, sim lvl 45)
    { "complete", 7730, at = { 1444, 73.68, 63.39 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Zukk'ash Infestation (lvl 45, ~3900 xp, sim lvl 45)
    { "complete", 7731, at = { 1444, 75.58, 60.85 }, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Stinglasher (lvl 47, ~4200 xp, sim lvl 45)
    { "turnin", 92878, xp = 4450, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Lost for Words (lvl 43, ~4450 xp, sim lvl 45)
    { "turnin", 7734, xp = 4400, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Improved Quality (lvl 48, ~4400 xp, sim lvl 45)
    { "turnin", 7731, xp = 4200, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Stinglasher (lvl 47, ~4200 xp, sim lvl 45)
    { "turnin", 7730, xp = 3900, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Zukk'ash Infestation (lvl 45, ~3900 xp, sim lvl 45)
    { "accept", 7732, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Zukk'ash Report (lvl 48, ~4400 xp, sim lvl 45)
    { "turnin", 2979, xp = 4050, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Ceremony (lvl 46, ~4050 xp, sim lvl 45)
    { "turnin", 2980, xp = 3750, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Ogres of Feralas (lvl 44, ~3750 xp, sim lvl 45)
    { "accept", 3002, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Gordunni Orb (lvl 47, ~2100 xp, sim lvl 45)
    { "turnin", 3062, xp = 5900, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Dark Heart (lvl 50, ~5900 xp, sim lvl 45)
    { "turnin", 2974, xp = 3900, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Grim Discovery (lvl 45, ~3900 xp, sim lvl 45)
    { "accept", 2976, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Grim Discovery (lvl 45, ~4850 xp, sim lvl 45)
    { "goto", 1444, 75.45, 44.36, note = "Flight master", alt = { "MARAUDON", "ZF" }, below = 47 }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar", alt = { "MARAUDON", "ZF" }, below = 47 }, -- vol
    { "turnin", 3002, xp = 2100, alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Gordunni Orb (lvl 47, ~2100 xp, sim lvl 45)
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "MARAUDON", "ZF" }, below = 47 }, -- déplacement
    { "fly", 1444, node = 42, note = "Camp Mojache, Feralas", alt = { "MARAUDON", "ZF" }, below = 47 }, -- vol
    { "accept", 3380, optional = true, dungeon = "The Temple of Atal'Hakkar", alt = { "MARAUDON", "ZF" }, below = 47 }, -- The Sunken Temple (lvl 51, ~0 xp, sim lvl 46)
    { "goto", 1444, 75.45, 44.36, note = "Flight master", alt = { "MARAUDON", "ZF" }, below = 47 }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar", alt = { "MARAUDON", "ZF" }, below = 47 }, -- vol
    { "turnin", 3121, xp = 1950, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Strange Request (lvl 45, ~1950 xp, sim lvl 46)
    { "turnin", 7732, xp = 4400, alt = { "MARAUDON", "ZF" }, below = 47 }, -- Zukk'ash Report (lvl 48, ~4400 xp, sim lvl 46)
    { "turnin", 2976, xp = 4850, alt = { "MARAUDON", "ZF" }, below = 47 }, -- A Grim Discovery (lvl 45, ~4850 xp, sim lvl 46)
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = { "MARAUDON", "ZF" }, below = 47 }, -- déplacement
    { "fly", 1444, node = 42, note = "Camp Mojache, Feralas", alt = { "MARAUDON", "ZF" }, below = 47 }, -- vol
    { "level", 47, at = { 1444, 77.9, 63.48 }, note = "About 437 more mobs here (Zukk'ash Tunneler, level 45)", alt = { "MARAUDON", "ZF" }, below = 47 }, -- farm de niveau
  },
})
