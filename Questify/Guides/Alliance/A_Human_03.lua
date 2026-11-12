local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 63 étapes, niveau final 16.00, ~20163 xp/h, 148 min.
Q:RegisterGuide({
  id = "A_Human_03",
  title = "Westfall",
  faction = "Alliance",
  races = { "Human" },
  minLevel = 11, maxLevel = 16,
  next = "A_01",
  sim = { steps = 63, endLevel = 16.00, xpPerHour = 20163, minutes = 148 },
  steps = {
    { "accept", 12 }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 11)
    { "accept", 102 }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 11)
    { "accept", 6181 }, -- A Swift Message (lvl 10, ~210 xp, sim lvl 11)
    { "turnin", 6181, xp = 210 }, -- A Swift Message (lvl 10, ~210 xp, sim lvl 11)
    { "accept", 6281 }, -- Continue to Stormwind (lvl 10, ~420 xp, sim lvl 11)
    { "accept", 153 }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 11)
    { "accept", 92742 }, -- Testing the Wells (lvl 12, ~455 xp, sim lvl 11)
    { "accept", 92744 }, -- Murloc Gills (lvl 12, ~455 xp, sim lvl 11)
    { "accept", 79093 }, -- Rumi of Gnomeregan: The Collected Works (lvl 20, ~1550 xp, sim lvl 11)
    { "complete", 92742, obj = 2, at = { 1436, 46.08, 38.14 } }, -- Testing the Wells (lvl 12, ~455 xp, sim lvl 11)
    { "complete", 12, obj = 1, at = { 1436, 31.61, 33.78 } }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 11)
    { "complete", 92744, at = { 1436, 34.53, 17 } }, -- Murloc Gills (lvl 12, ~455 xp, sim lvl 12)
    { "complete", 12, at = { 1436, 44.8, 25.95 } }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 12)
    { "complete", 153, at = { 1436, 45.34, 22.76 } }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 12)
    { "accept", 92909 }, -- Harvesting the Harvesters (lvl 15, ~800 xp, sim lvl 12)
    { "accept", 9 }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 12)
    { "accept", 22 }, -- Goretusk Liver Pie (lvl 12, ~910 xp, sim lvl 12)
    { "accept", 36 }, -- Westfall Stew (lvl 10, ~420 xp, sim lvl 12)
    { "accept", 151 }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 12)
    { "accept", 64 }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 12)
    { "complete", 151, at = { 1436, 57.27, 18.31 } }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 12)
    { "complete", 92742, at = { 1436, 56.62, 18.69 } }, -- Testing the Wells (lvl 12, ~455 xp, sim lvl 12)
    { "complete", 92909, at = { 1436, 53.08, 23.98 } }, -- Harvesting the Harvesters (lvl 15, ~800 xp, sim lvl 12)
    { "turnin", 92909, xp = 800 }, -- Harvesting the Harvesters (lvl 15, ~800 xp, sim lvl 13)
    { "complete", 22, at = { 1436, 53.7, 42.94 } }, -- Goretusk Liver Pie (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 12, xp = 910 }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 13 }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 13)
    { "turnin", 92742, xp = 455 }, -- Testing the Wells (lvl 12, ~455 xp, sim lvl 13)
    { "turnin", 92744, xp = 455 }, -- Murloc Gills (lvl 12, ~455 xp, sim lvl 13)
    { "accept", 92745 }, -- The State of the Mines (lvl 14, ~490 xp, sim lvl 13)
    { "turnin", 153, xp = 1050 }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 13, at = { 1436, 43.7, 68.91 } }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 13)
    { "accept", 103 }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 13)
    { "complete", 102, at = { 1436, 31.04, 68.76 } }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 13)
    { "complete", 92745, obj = 2, at = { 1436, 29.98, 47.26 } }, -- The State of the Mines (lvl 14, ~490 xp, sim lvl 14)
    { "complete", 9, at = { 1436, 38.78, 51.51 } }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 14)
    { "complete", 92745, at = { 1436, 45.29, 20.05 } }, -- The State of the Mines (lvl 14, ~490 xp, sim lvl 14)
    { "complete", 64, at = { 1436, 49.33, 19.28 } }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 14)
    { "complete", 103, at = { 1436, 52.84, 23.8 } }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 14)
    { "turnin", 36, xp = 420 }, -- Westfall Stew (lvl 10, ~420 xp, sim lvl 14)
    { "turnin", 22, xp = 910 }, -- Goretusk Liver Pie (lvl 12, ~910 xp, sim lvl 14)
    { "turnin", 9, xp = 1050 }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 14)
    { "turnin", 13, xp = 980 }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 14)
    { "accept", 14 }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 14)
    { "turnin", 102, xp = 980 }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 14)
    { "turnin", 92745, xp = 490 }, -- The State of the Mines (lvl 14, ~490 xp, sim lvl 14)
    { "accept", 92747 }, -- Moonbrook Espionage (lvl 15, ~800 xp, sim lvl 14)
    { "complete", 79093, at = { 1436, 52.7, 53.8 } }, -- Rumi of Gnomeregan: The Collected Works (lvl 20, ~1550 xp, sim lvl 14)
    { "level", 15, at = { 1436, 43.49, 70.69 }, note = "About 16 mobs here (Defias Pillager, level 14)" }, -- farm de niveau
    { "complete", 14, at = { 1436, 52.07, 76.61 } }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 15)
    { "turnin", 103, xp = 1150 }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 15)
    { "complete", 92747, at = { 1436, 43.11, 68.85 } }, -- Moonbrook Espionage (lvl 15, ~800 xp, sim lvl 15)
    { "turnin", 92747, xp = 800 }, -- Moonbrook Espionage (lvl 15, ~800 xp, sim lvl 15)
    { "accept", 92748 }, -- Explosive Consultation (lvl 16, ~580 xp, sim lvl 15)
    { "turnin", 14, xp = 1600 }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 15)
    { "turnin", 151, xp = 1250 }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 15)
    { "turnin", 64, xp = 910 }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 15)
    { "turnin", 79093, xp = 1550 }, -- Rumi of Gnomeregan: The Collected Works (lvl 20, ~1550 xp, sim lvl 15)
    { "turnin", 6281, xp = 420 }, -- Continue to Stormwind (lvl 10, ~420 xp, sim lvl 15)
    { "turnin", 92748, xp = 580 }, -- Explosive Consultation (lvl 16, ~580 xp, sim lvl 15)
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1436, node = 4, note = "Sentinel Hill, Westfall" }, -- vol
    { "level", 16, at = { 1436, 42.43, 77.14 }, note = "About 24 more mobs here (Defias Digger, level 15)" }, -- farm de niveau
  },
})
