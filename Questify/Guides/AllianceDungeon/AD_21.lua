local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 6 étapes, niveau final 43.00, ~0 xp/h, 24 min.
Q:RegisterGuide({
  id = "AD_21",
  title = "Aerie Peak",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 43, maxLevel = 45,
  next = "AD_22",
  sim = { steps = 6, endLevel = 43.00, xpPerHour = 0, minutes = 24 },
  steps = {
    { "goto", 1443, 64.66, 10.54, note = "Flight master", phase = "prep", rung = "ST" }, -- déplacement
    { "fly", 1439, node = 26, note = "Auberdine, Darkshore", phase = "prep", rung = "ST" }, -- vol
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor", phase = "prep", rung = "ST" }, -- bateau
    { "goto", 1437, 9.49, 59.69, note = "Flight master", phase = "prep", rung = "ST" }, -- déplacement
    { "fly", 1425, node = 43, note = "Aerie Peak, The Hinterlands", phase = "prep", rung = "ST" }, -- vol
    { "accept", 1446, optional = true, dungeon = "The Temple of Atal'Hakkar", phase = "prep", rung = "ST" }, -- Jammal'an the Prophet (lvl 53, ~0 xp, sim lvl 43)
  },
})
