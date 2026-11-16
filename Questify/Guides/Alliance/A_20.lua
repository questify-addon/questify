local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-16.
-- Simulation : 6 étapes, niveau final 48.00, ~50502 xp/h, 300 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 6, endLevel = 48.00, xpPerHour = 50502, minutes = 300 },
  steps = {
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 82 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 82, at = { 1446, 31.97, 45.08 } }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "turnin", 82, xp = 3150 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "level", 48, at = { 1446, 31.97, 45.08 }, note = "About 860 more mobs near the last objective" }, -- farm de niveau
  },
})
