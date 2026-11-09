local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 80866960788084ae1592abf66a08f0d306458a95, généré le 2026-11-07.
-- Simulation : 8 étapes, niveau final 48.00, ~54707 xp/h, 277 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 8, endLevel = 48.00, xpPerHour = 54707, minutes = 277 },
  steps = {
    { "note", "Not running Maraudon? Abandon Shadowshard Fragments", optional = true, dungeon = "Maraudon" },
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 5863 }, -- The Dunemaul Compound (lvl 49, ~4550 xp, sim lvl 46)
    { "complete", 5863, at = { 1446, 40, 51.34 } }, -- The Dunemaul Compound (lvl 49, ~4550 xp, sim lvl 46)
    { "complete", 5863, at = { 1446, 41.5, 57.81 } }, -- The Dunemaul Compound (lvl 49, ~4550 xp, sim lvl 46)
    { "turnin", 5863, xp = 4550 }, -- The Dunemaul Compound (lvl 49, ~4550 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "level", 48, at = { 1446, 41.5, 57.81 }, note = "About 776 more mobs near the last objective" }, -- farm de niveau
  },
})
