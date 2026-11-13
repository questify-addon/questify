local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 45 étapes, niveau final 54.00, ~51900 xp/h, 557 min.
Q:RegisterGuide({
  id = "AD_27",
  title = "Un'Goro Crater",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 51, maxLevel = 54,
  next = "AD_28",
  sim = { steps = 45, endLevel = 54.00, xpPerHour = 51900, minutes = 557 },
  steps = {
    { "hearth", 1434, alt = "ST", below = 54 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)", alt = "ST", below = 54 }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master", alt = "ST", below = 54 }, -- déplacement
    { "fly", 1444, node = 31, note = "Thalanaar, Feralas", alt = "ST", below = 54 }, -- vol
    { "fp", 1449, 45.23, 5.83, alt = "ST", below = 54 }, -- point de vol
    { "accept", 4284, alt = "ST", below = 54 }, -- Crystals of Power (lvl 53, ~5250 xp, sim lvl 51)
    { "accept", 4141, alt = "ST", below = 54 }, -- Muigin and Larion (lvl 52, ~5100 xp, sim lvl 51)
    { "accept", 4503, alt = "ST", below = 54 }, -- Shizzle's Flyer (lvl 51, ~4900 xp, sim lvl 51)
    { "complete", 4503, obj = 1, at = { 1449, 50.63, 63.36 }, alt = "ST", below = 54 }, -- Shizzle's Flyer (lvl 51, ~4900 xp, sim lvl 51)
    { "accept", 3844, alt = "ST", below = 54 }, -- It's a Secret to Everybody (lvl 52, ~1250 xp, sim lvl 51)
    { "turnin", 3844, xp = 1250, alt = "ST", below = 54 }, -- It's a Secret to Everybody (lvl 52, ~1250 xp, sim lvl 51)
    { "accept", 4290, alt = "ST", below = 54 }, -- The Fare of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4284, at = { 1449, 73.61, 63.55 }, alt = "ST", below = 54 }, -- Crystals of Power (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4290, at = { 1449, 68.74, 56.71 }, alt = "ST", below = 54 }, -- The Fare of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "accept", 4243, alt = "ST", below = 54 }, -- Chasing A-Me 01 (lvl 53, ~2650 xp, sim lvl 51)
    { "accept", 3883, alt = "ST", below = 54 }, -- Alien Ecology (lvl 52, ~5100 xp, sim lvl 51)
    { "accept", 3881, alt = "ST", below = 54 }, -- Expedition Salvation (lvl 53, ~5250 xp, sim lvl 51)
    { "turnin", 4284, xp = 5250, alt = "ST", below = 54 }, -- Crystals of Power (lvl 53, ~5250 xp, sim lvl 51)
    { "accept", 4285, alt = "ST", below = 54 }, -- The Northern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "accept", 4288, alt = "ST", below = 54 }, -- The Western Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "accept", 4287, alt = "ST", below = 54 }, -- The Eastern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "complete", 4285, at = { 1449, 56.52, 12.54 }, alt = "ST", below = 54 }, -- The Northern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "turnin", 4243, xp = 2650, alt = "ST", below = 54 }, -- Chasing A-Me 01 (lvl 53, ~2650 xp, sim lvl 51)
    { "complete", 4141, at = { 1449, 68.8, 29.53 }, alt = "ST", below = 54 }, -- Muigin and Larion (lvl 52, ~5100 xp, sim lvl 51)
    { "complete", 3881, obj = 1, at = { 1449, 68.54, 36.54 }, alt = "ST", below = 54 }, -- Expedition Salvation (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4287, at = { 1449, 77.16, 49.98 }, alt = "ST", below = 54 }, -- The Eastern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "turnin", 4290, xp = 5250, alt = "ST", below = 54 }, -- The Fare of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "accept", 4291, alt = "ST", below = 54 }, -- The Scent of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4291, at = { 1449, 66.5, 66.5 }, alt = "ST", below = 54 }, -- The Scent of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "turnin", 4291, xp = 5250, alt = "ST", below = 54 }, -- The Scent of Lar'korwi (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4503, at = { 1449, 57.08, 88.97 }, alt = "ST", below = 54 }, -- Shizzle's Flyer (lvl 51, ~4900 xp, sim lvl 51)
    { "complete", 3883, at = { 1449, 48.69, 85.32 }, alt = "ST", below = 54 }, -- Alien Ecology (lvl 52, ~5100 xp, sim lvl 51)
    { "complete", 3881, at = { 1449, 38.45, 66.06 }, alt = "ST", below = 54 }, -- Expedition Salvation (lvl 53, ~5250 xp, sim lvl 51)
    { "complete", 4288, at = { 1449, 23.86, 59.19 }, alt = "ST", below = 54 }, -- The Western Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "turnin", 4503, xp = 4900, alt = "ST", below = 54 }, -- Shizzle's Flyer (lvl 51, ~4900 xp, sim lvl 51)
    { "turnin", 4141, xp = 5100, alt = "ST", below = 54 }, -- Muigin and Larion (lvl 52, ~5100 xp, sim lvl 51)
    { "turnin", 3883, xp = 5100, alt = "ST", below = 54 }, -- Alien Ecology (lvl 52, ~5100 xp, sim lvl 51)
    { "turnin", 3881, xp = 5250, alt = "ST", below = 54 }, -- Expedition Salvation (lvl 53, ~5250 xp, sim lvl 51)
    { "turnin", 4288, xp = 3950, alt = "ST", below = 54 }, -- The Western Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "turnin", 4287, xp = 3950, alt = "ST", below = 54 }, -- The Eastern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "turnin", 4285, xp = 3950, alt = "ST", below = 54 }, -- The Northern Pylon (lvl 53, ~3950 xp, sim lvl 51)
    { "accept", 4321, alt = "ST", below = 54 }, -- Making Sense of It (lvl 53, ~530 xp, sim lvl 51)
    { "complete", 4321, at = { 1449, 41.92, 2.7 }, alt = "ST", below = 54 }, -- Making Sense of It (lvl 53, ~530 xp, sim lvl 51)
    { "turnin", 4321, xp = 530, alt = "ST", below = 54 }, -- Making Sense of It (lvl 53, ~530 xp, sim lvl 51)
    { "level", 54, at = { 1449, 56.67, 9.91 }, note = "About 1362 more mobs here (Pterrordax, level 51)", alt = "ST", below = 54 }, -- farm de niveau
  },
})
