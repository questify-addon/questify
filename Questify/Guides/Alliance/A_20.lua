local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 7 étapes, niveau final 48.00, ~49859 xp/h, 304 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 7, endLevel = 48.00, xpPerHour = 49859, minutes = 304 },
  steps = {
    { "note", "Not running Maraudon? Abandon Shadowshard Fragments", optional = true, dungeon = "Maraudon" },
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 82 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 82, at = { 1446, 31.97, 45.08 } }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "turnin", 82, xp = 3150 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "level", 48, at = { 1446, 31.97, 45.08 }, note = "About 860 more mobs near the last objective" }, -- farm de niveau
  },
})
