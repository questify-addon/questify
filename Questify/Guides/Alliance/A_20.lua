local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 6 étapes, niveau final 48.00, ~47500 xp/h, 319 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 6, endLevel = 48.00, xpPerHour = 47500, minutes = 319 },
  steps = {
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 95753 }, -- Challenge of the Desert Wolf (lvl 45, ~1950 xp, sim lvl 46)
    { "complete", 95753, at = { 1446, 45.73, 37.76 } }, -- Challenge of the Desert Wolf (lvl 45, ~1950 xp, sim lvl 46)
    { "turnin", 95753, xp = 1950 }, -- Challenge of the Desert Wolf (lvl 45, ~1950 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "level", 48, note = "About 941 more mobs" }, -- farm de niveau
  },
})
