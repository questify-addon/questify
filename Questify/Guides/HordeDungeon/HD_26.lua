local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-15.
-- Simulation : 77 étapes, niveau final 54.07, ~55039 xp/h, 195 min.
Q:RegisterGuide({
  id = "HD_26",
  title = "Azshara",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 53, maxLevel = 54,
  next = "HD_27",
  sim = { steps = 77, endLevel = 54.07, xpPerHour = 55039, minutes = 195 },
  steps = {
    { "hearth", 1434, alt = "BRD", below = 54 }, -- pierre de foyer
    { "boat", 1434, 31.43, 29.91, note = "Take the zeppelin to Orgrimmar (Durotar)", alt = "BRD", below = 54 }, -- bateau
    { "fp", 1447, 21.96, 49.62, alt = "BRD", below = 54 }, -- point de vol
    { "accept", 3517, alt = "BRD", below = 54 }, -- Stealing Knowledge (lvl 52, ~5100 xp, sim lvl 53)
    { "accept", 92346, alt = "BRD", below = 54 }, -- Beneath Nordrassil (lvl 55, ~1400 xp, sim lvl 53)
    { "accept", 91569, alt = "BRD", below = 54 }, -- Blue Gold (lvl 53, ~5250 xp, sim lvl 53)
    { "accept", 91568, alt = "BRD", below = 54 }, -- Long Walks on the Beach (lvl 51, ~4900 xp, sim lvl 53)
    { "accept", 91608, alt = "BRD", below = 54 }, -- Gettin' Buzzed (lvl 48, ~4400 xp, sim lvl 53)
    { "accept", 91488, alt = "BRD", below = 54 }, -- Home on the Range (lvl 48, ~4400 xp, sim lvl 53)
    { "complete", 3517, at = { 1447, 35.16, 56.94 }, alt = "BRD", below = 54 }, -- Stealing Knowledge (lvl 52, ~5100 xp, sim lvl 53)
    { "turnin", 3517, xp = 5100, alt = "BRD", below = 54 }, -- Stealing Knowledge (lvl 52, ~5100 xp, sim lvl 53)
    { "accept", 3518, alt = "BRD", below = 54 }, -- Delivery to Magatha (lvl 52, ~2550 xp, sim lvl 53)
    { "accept", 3541, alt = "BRD", below = 54 }, -- Delivery to Jes'rimon (lvl 52, ~2550 xp, sim lvl 53)
    { "accept", 3561, alt = "BRD", below = 54 }, -- Delivery to Archmage Xylem (lvl 52, ~2550 xp, sim lvl 53)
    { "complete", 91608, at = { 1447, 19.05, 51.97 }, alt = "BRD", below = 54 }, -- Gettin' Buzzed (lvl 48, ~4400 xp, sim lvl 53)
    { "accept", 5536, alt = "BRD", below = 54 }, -- A Land Filled with Hatred (lvl 47, ~3360 xp, sim lvl 53)
    { "accept", 5535, alt = "BRD", below = 54 }, -- Spiritual Unrest (lvl 47, ~3360 xp, sim lvl 53)
    { "accept", 91735, alt = "BRD", below = 54 }, -- Remote Contact (lvl 52, ~510 xp, sim lvl 53)
    { "turnin", 3541, xp = 2550, alt = "BRD", below = 54 }, -- Delivery to Jes'rimon (lvl 52, ~2550 xp, sim lvl 53)
    { "accept", 3563, alt = "BRD", below = 54 }, -- Jes'rimon's Payment to Jediga (lvl 52, ~3800 xp, sim lvl 53)
    { "accept", 649, alt = "BRD", below = 54 }, -- Ripple Recovery (lvl 48, ~440 xp, sim lvl 53)
    { "accept", 8151, alt = "BRD", below = 54, classes = { "HUNTER" } }, -- The Hunter's Charm (lvl 52, ~510 xp, sim lvl 53)
    { "turnin", 649, xp = 440, alt = "BRD", below = 54 }, -- Ripple Recovery (lvl 48, ~440 xp, sim lvl 53)
    { "accept", 3504, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~2650 xp, sim lvl 53)
    { "complete", 91488, at = { 1447, 49.63, 80.88 }, alt = "BRD", below = 54 }, -- Home on the Range (lvl 48, ~4400 xp, sim lvl 53)
    { "complete", 91568, at = { 1447, 44.06, 54.34 }, alt = "BRD", below = 54 }, -- Long Walks on the Beach (lvl 51, ~4900 xp, sim lvl 53)
    { "turnin", 3504, xp = 2650, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~2650 xp, sim lvl 53)
    { "accept", 3505, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~3950 xp, sim lvl 53)
    { "turnin", 3563, xp = 3800, alt = "BRD", below = 54 }, -- Jes'rimon's Payment to Jediga (lvl 52, ~3800 xp, sim lvl 53)
    { "turnin", 91735, xp = 510, alt = "BRD", below = 54 }, -- Remote Contact (lvl 52, ~510 xp, sim lvl 53)
    { "turnin", 91568, xp = 4900, alt = "BRD", below = 54 }, -- Long Walks on the Beach (lvl 51, ~4900 xp, sim lvl 53)
    { "turnin", 91488, xp = 4400, alt = "BRD", below = 54 }, -- Home on the Range (lvl 48, ~4400 xp, sim lvl 53)
    { "turnin", 91608, xp = 4400, alt = "BRD", below = 54 }, -- Gettin' Buzzed (lvl 48, ~4400 xp, sim lvl 53)
    { "accept", 86746, alt = "BRD", below = 54 }, -- The Legashi Threat (lvl 53, ~5250 xp, sim lvl 53)
    { "turnin", 8151, xp = 510, alt = "BRD", below = 54, classes = { "HUNTER" } }, -- The Hunter's Charm (lvl 52, ~510 xp, sim lvl 53)
    { "turnin", 86746, xp = 5250, alt = "BRD", below = 54 }, -- The Legashi Threat (lvl 53, ~5250 xp, sim lvl 53)
    { "accept", 3601, alt = "BRD", below = 54 }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 53)
    { "complete", 3601, at = { 1447, 57.57, 28.05 }, alt = "BRD", below = 54 }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 53)
    { "complete", 3505, at = { 1447, 56.35, 27.88 }, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~3950 xp, sim lvl 53)
    { "accept", 91500, alt = "BRD", below = 54 }, -- An Explosive Gambit (lvl 55, ~4200 xp, sim lvl 53)
    { "accept", 91538, alt = "BRD", below = 54 }, -- Sin'dorei Tome of Summoning (lvl 55, ~1400 xp, sim lvl 53)
    { "accept", 91497, alt = "BRD", below = 54 }, -- Seals of the Sin'dorei (lvl 53, ~5250 xp, sim lvl 53)
    { "complete", 3505, at = { 1447, 59.53, 31.47 }, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~3950 xp, sim lvl 53)
    { "turnin", 3505, xp = 3950, alt = "BRD", below = 54 }, -- Betrayed (lvl 53, ~3950 xp, sim lvl 53)
    { "accept", 3506, alt = "BRD", below = 54 }, -- Betrayed (lvl 56, ~4350 xp, sim lvl 53)
    { "complete", 91500, at = { 1447, 59.51, 31.37 }, alt = "BRD", below = 54 }, -- An Explosive Gambit (lvl 55, ~4200 xp, sim lvl 53)
    { "complete", 3506, at = { 1447, 59.51, 31.37 }, alt = "BRD", below = 54 }, -- Betrayed (lvl 56, ~4350 xp, sim lvl 53)
    { "complete", 91497, obj = 1, at = { 1447, 66.5, 29.07 }, alt = "BRD", below = 54 }, -- Seals of the Sin'dorei (lvl 53, ~5250 xp, sim lvl 53)
    { "complete", 91569, at = { 1447, 69.49, 29.58 }, alt = "BRD", below = 54 }, -- Blue Gold (lvl 53, ~5250 xp, sim lvl 53)
    { "complete", 91497, obj = 3, at = { 1447, 70.19, 29.06 }, alt = "BRD", below = 54 }, -- Seals of the Sin'dorei (lvl 53, ~5250 xp, sim lvl 53)
    { "turnin", 3601, xp = 6550, alt = "BRD", below = 54 }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 53)
    { "accept", 5534, alt = "BRD", below = 54 }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 53)
    { "complete", 91497, at = { 1447, 56.84, 28.26 }, alt = "BRD", below = 54 }, -- Seals of the Sin'dorei (lvl 53, ~5250 xp, sim lvl 53)
    { "turnin", 91497, xp = 5250, alt = "BRD", below = 54 }, -- Seals of the Sin'dorei (lvl 53, ~5250 xp, sim lvl 53)
    { "complete", 5534, at = { 1447, 47.31, 49.11 }, alt = "BRD", below = 54 }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 53)
    { "turnin", 5534, xp = 6550, alt = "BRD", below = 54 }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 53)
    { "turnin", 3561, xp = 2550, alt = "BRD", below = 54 }, -- Delivery to Archmage Xylem (lvl 52, ~2550 xp, sim lvl 53)
    { "accept", 3565, alt = "BRD", below = 54 }, -- Xylem's Payment to Jediga (lvl 52, ~3800 xp, sim lvl 53)
    { "turnin", 91538, xp = 1400, alt = "BRD", below = 54 }, -- Sin'dorei Tome of Summoning (lvl 55, ~1400 xp, sim lvl 53)
    { "turnin", 3565, xp = 3800, alt = "BRD", below = 54 }, -- Xylem's Payment to Jediga (lvl 52, ~3800 xp, sim lvl 53)
    { "turnin", 91569, xp = 5250, alt = "BRD", below = 54 }, -- Blue Gold (lvl 53, ~5250 xp, sim lvl 53)
    { "turnin", 91500, xp = 4200, alt = "BRD", below = 54 }, -- An Explosive Gambit (lvl 55, ~4200 xp, sim lvl 53)
    { "turnin", 3506, xp = 4350, alt = "BRD", below = 54 }, -- Betrayed (lvl 56, ~4350 xp, sim lvl 53)
    { "accept", 3507, alt = "BRD", below = 54 }, -- Betrayed (lvl 56, ~7300 xp, sim lvl 53)
    { "complete", 5536, at = { 1447, 20.31, 61.77 }, alt = "BRD", below = 54 }, -- A Land Filled with Hatred (lvl 47, ~3360 xp, sim lvl 53)
    { "complete", 5535, at = { 1447, 17.1, 69.7 }, alt = "BRD", below = 54 }, -- Spiritual Unrest (lvl 47, ~3360 xp, sim lvl 53)
    { "turnin", 5535, xp = 3360, alt = "BRD", below = 54 }, -- Spiritual Unrest (lvl 47, ~3360 xp, sim lvl 53)
    { "turnin", 5536, xp = 3360, alt = "BRD", below = 54 }, -- A Land Filled with Hatred (lvl 47, ~3360 xp, sim lvl 53)
    { "turnin", 3507, xp = 7300, alt = "BRD", below = 54 }, -- Betrayed (lvl 56, ~7300 xp, sim lvl 54)
    { "accept", 1018, alt = "BRD", below = 54 }, -- The New Frontier (lvl 55, ~560 xp, sim lvl 54)
    { "accept", 7492, optional = true, dungeon = "Dire Maul", alt = "BRD", below = 54 }, -- Camp Mojache (lvl 57, ~0 xp, sim lvl 54)
    { "accept", 2861, optional = true, dungeon = "Zul'Farrak", alt = "BRD", below = 54 }, -- Tabetha's Task (lvl 46, ~0 xp, sim lvl 54)
    { "goto", 1454, 45.12, 63.89, note = "Flight master", alt = "BRD", below = 54 }, -- déplacement
    { "fly", 1413, node = 25, note = "Crossroads, The Barrens", alt = "BRD", below = 54 }, -- vol
    { "turnin", 1018, xp = 560, alt = "BRD", below = 54 }, -- The New Frontier (lvl 55, ~560 xp, sim lvl 54)
    { "turnin", 92346, xp = 1400, alt = "BRD", below = 54 }, -- Beneath Nordrassil (lvl 55, ~1400 xp, sim lvl 54)
    { "turnin", 3518, xp = 2550, alt = "BRD", below = 54 }, -- Delivery to Magatha (lvl 52, ~2550 xp, sim lvl 54)
  },
})
