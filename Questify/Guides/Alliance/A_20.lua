local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-16.
-- Simulation : 18 étapes, niveau final 48.00, ~49449 xp/h, 306 min.
Q:RegisterGuide({
  id = "A_20",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 46, maxLevel = 48,
  next = "A_21",
  sim = { steps = 18, endLevel = 48.00, xpPerHour = 49449, minutes = 306 },
  steps = {
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 992 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "complete", 992, at = { 1446, 39, 29 } }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "turnin", 992, xp = 3050 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "accept", 82 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 82, at = { 1446, 31.97, 45.08 } }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "accept", 95753 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 95753, at = { 1446, 45.73, 37.76 } }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "turnin", 95753, xp = 3900 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 81949 }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "complete", 81949, at = { 1446, 72.6, 47.8 } }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "accept", 95383 }, -- Shipping and Handling (lvl 40, ~250 xp, sim lvl 46)
    { "turnin", 95383, xp = 250 }, -- Shipping and Handling (lvl 40, ~250 xp, sim lvl 46)
    { "accept", 95312 }, -- Coming to Collect (lvl 40, ~250 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "turnin", 95312, xp = 250 }, -- Coming to Collect (lvl 40, ~250 xp, sim lvl 46)
    { "turnin", 82, xp = 3150 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "level", 48, at = { 1446, 31.97, 45.08 }, note = "About 834 more mobs near the last objective" }, -- farm de niveau
  },
})
