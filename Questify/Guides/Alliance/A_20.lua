local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 23 étapes, niveau final 48.00, ~48306 xp/h, 313 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 23, endLevel = 48.00, xpPerHour = 48306, minutes = 313 },
  steps = {
    { "note", "Not running Maraudon? Abandon Shadowshard Fragments", optional = true, dungeon = "Maraudon" },
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 82 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 82, at = { 1446, 31.97, 45.08 } }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "turnin", 82, xp = 3150 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "accept", 10 }, -- The Scrimshank Redemption (lvl 48, ~4400 xp, sim lvl 46)
    { "accept", 3161 }, -- Gahz'ridian (lvl 48, ~4400 xp, sim lvl 46)
    { "accept", 81949 }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "complete", 81949, at = { 1446, 72.6, 47.8 } }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "accept", 351, at = { 1446, 73.88, 47.24 }, note = "Loot OOX-17/TN Distress Beacon to start the quest" }, -- Find OOX-17/TN! (lvl 48, ~4400 xp, sim lvl 46)
    { "turnin", 351, xp = 4400 }, -- Find OOX-17/TN! (lvl 48, ~4400 xp, sim lvl 46)
    { "accept", 648 }, -- Rescue OOX-17/TN! (lvl 48, ~0 xp, sim lvl 46)
    { "complete", 10, at = { 1446, 55.96, 71.17 } }, -- The Scrimshank Redemption (lvl 48, ~4400 xp, sim lvl 46)
    { "complete", 3161, at = { 1446, 46.98, 65.67 } }, -- Gahz'ridian (lvl 48, ~4400 xp, sim lvl 46)
    { "turnin", 3161, xp = 4400 }, -- Gahz'ridian (lvl 48, ~4400 xp, sim lvl 46)
    { "turnin", 10, xp = 4400 }, -- The Scrimshank Redemption (lvl 48, ~4400 xp, sim lvl 46)
    { "accept", 110 }, -- Insect Part Analysis (lvl 48, ~440 xp, sim lvl 46)
    { "turnin", 110, xp = 440 }, -- Insect Part Analysis (lvl 48, ~440 xp, sim lvl 46)
    { "accept", 113 }, -- Insect Part Analysis (lvl 48, ~440 xp, sim lvl 46)
    { "turnin", 113, xp = 440 }, -- Insect Part Analysis (lvl 48, ~440 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "complete", 648, at = { 1446, 67.06, 23.16 } }, -- Rescue OOX-17/TN! (lvl 48, ~0 xp, sim lvl 46)
    { "level", 48, at = { 1446, 31.97, 45.08 }, note = "About 806 more mobs near the last objective" }, -- farm de niveau
  },
})
