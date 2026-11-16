local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-16.
-- Simulation : 70 étapes, niveau final 44.03, ~37977 xp/h, 171 min.
Q:RegisterGuide({
  id = "H_15",
  title = "Dustwallow Marsh",
  faction = "Horde",
  minLevel = 43, maxLevel = 44,
  next = "H_16",
  sim = { steps = 70, endLevel = 44.03, xpPerHour = 37977, minutes = 171 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "boat", 1434, 31.43, 29.91, note = "Take the zeppelin to Orgrimmar (Durotar)" }, -- bateau
    { "goto", 1454, 45.12, 63.89, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 55, note = "Brackenwall Village, Dustwallow Marsh" }, -- vol
    { "accept", 1166 }, -- Overlord Mok'Morokk's Concern (lvl 43, ~4450 xp, sim lvl 43)
    { "accept", 98192 }, -- Skin Careful, Skin Sharp (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 1168 }, -- Army of the Black Dragon (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 1169 }, -- Identifying the Brood (lvl 43, ~5350 xp, sim lvl 43)
    { "accept", 1177 }, -- Hungry! (lvl 36, ~1120 xp, sim lvl 43)
    { "accept", 1268 }, -- Suspicious Hoofprints (lvl 35, ~540 xp, sim lvl 43)
    { "accept", 1269 }, -- Lieutenant Paval Reethe (lvl 37, ~565 xp, sim lvl 43)
    { "accept", 1251 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 43)
    { "turnin", 625, xp = 3600 }, -- Cortello's Riddle (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 98192, at = { 1445, 32.48, 65.17 } }, -- Skin Careful, Skin Sharp (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 1166, obj = 3, at = { 1445, 36.64, 69.57 } }, -- Overlord Mok'Morokk's Concern (lvl 43, ~4450 xp, sim lvl 43)
    { "complete", 1168, obj = 3, at = { 1445, 37.46, 68.38 } }, -- Army of the Black Dragon (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 1166, obj = 2, at = { 1445, 38.66, 65.57 } }, -- Overlord Mok'Morokk's Concern (lvl 43, ~4450 xp, sim lvl 43)
    { "accept", 98215 }, -- Dragon Scales, Post Burnt Tails (lvl 44, ~3750 xp, sim lvl 43)
    { "accept", 98205 }, -- Whelps are the Worst! (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 98205, at = { 1445, 46.02, 69.15 } }, -- Whelps are the Worst! (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 1166, at = { 1445, 44.53, 66.04 } }, -- Overlord Mok'Morokk's Concern (lvl 43, ~4450 xp, sim lvl 43)
    { "complete", 1169, at = { 1445, 44.68, 66.09 } }, -- Identifying the Brood (lvl 43, ~5350 xp, sim lvl 43)
    { "complete", 98215, at = { 1445, 44.69, 66.02 } }, -- Dragon Scales, Post Burnt Tails (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 1168, at = { 1445, 43.65, 66.29 } }, -- Army of the Black Dragon (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 2846, optional = true, dungeon = "Zul'Farrak" }, -- Tiara of the Deep (lvl 46, ~0 xp, sim lvl 43)
    { "accept", 1218 }, -- Soothing Spices (lvl 35, ~540 xp, sim lvl 43)
    { "accept", 81570 }, -- Jarl Needs a Blade (lvl 35, ~540 xp, sim lvl 43)
    { "accept", 1238 }, -- The Lost Report (lvl 35, ~820 xp, sim lvl 43)
    { "turnin", 81570, xp = 540 }, -- Jarl Needs a Blade (lvl 35, ~540 xp, sim lvl 43)
    { "turnin", 1169, xp = 5350 }, -- Identifying the Brood (lvl 43, ~5350 xp, sim lvl 43)
    { "accept", 1170 }, -- The Brood of Onyxia (lvl 43, ~360 xp, sim lvl 43)
    { "turnin", 1269, xp = 565 }, -- Lieutenant Paval Reethe (lvl 37, ~565 xp, sim lvl 43)
    { "turnin", 1251, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 43)
    { "turnin", 1268, xp = 540 }, -- Suspicious Hoofprints (lvl 35, ~540 xp, sim lvl 43)
    { "accept", 1321 }, -- The Black Shield (lvl 35, ~110 xp, sim lvl 43)
    { "turnin", 1321, xp = 110 }, -- The Black Shield (lvl 35, ~110 xp, sim lvl 43)
    { "accept", 1322 }, -- The Black Shield (lvl 37, ~2280 xp, sim lvl 43)
    { "turnin", 1170, xp = 360 }, -- The Brood of Onyxia (lvl 43, ~360 xp, sim lvl 43)
    { "accept", 1171 }, -- The Brood of Onyxia (lvl 43, ~360 xp, sim lvl 43)
    { "turnin", 1168, xp = 3600 }, -- Army of the Black Dragon (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 98192, xp = 3600 }, -- Skin Careful, Skin Sharp (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 1166, xp = 4450 }, -- Overlord Mok'Morokk's Concern (lvl 43, ~4450 xp, sim lvl 43)
    { "turnin", 1171, xp = 360 }, -- The Brood of Onyxia (lvl 43, ~360 xp, sim lvl 43)
    { "accept", 1172 }, -- The Brood of Onyxia (lvl 45, ~4850 xp, sim lvl 43)
    { "turnin", 1238, xp = 820 }, -- The Lost Report (lvl 35, ~820 xp, sim lvl 43)
    { "accept", 1273 }, -- Questioning Reethe (lvl 37, ~2840 xp, sim lvl 43)
    { "complete", 1273, at = { 1445, 42.65, 38.07 } }, -- Questioning Reethe (lvl 37, ~2840 xp, sim lvl 43)
    { "complete", 1322, at = { 1445, 42.69, 43.51 } }, -- The Black Shield (lvl 37, ~2280 xp, sim lvl 43)
    { "turnin", 98215, xp = 3750 }, -- Dragon Scales, Post Burnt Tails (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 98205, xp = 3750 }, -- Whelps are the Worst! (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 1172, at = { 1445, 48.48, 73.62 } }, -- The Brood of Onyxia (lvl 45, ~4850 xp, sim lvl 43)
    { "complete", 1218, at = { 1445, 66.44, 51.46 } }, -- Soothing Spices (lvl 35, ~540 xp, sim lvl 43)
    { "turnin", 1218, xp = 540 }, -- Soothing Spices (lvl 35, ~540 xp, sim lvl 43)
    { "accept", 1206 }, -- Jarl Needs Eyes (lvl 35, ~1100 xp, sim lvl 43)
    { "accept", 1239 }, -- The Severed Head (lvl 35, ~820 xp, sim lvl 43)
    { "complete", 1177, at = { 1445, 58.75, 9.66 } }, -- Hungry! (lvl 36, ~1120 xp, sim lvl 43)
    { "complete", 1206, at = { 1445, 31.88, 21.93 } }, -- Jarl Needs Eyes (lvl 35, ~1100 xp, sim lvl 43)
    { "turnin", 1206, xp = 1100 }, -- Jarl Needs Eyes (lvl 35, ~1100 xp, sim lvl 43)
    { "turnin", 1172, xp = 4850 }, -- The Brood of Onyxia (lvl 45, ~4850 xp, sim lvl 43)
    { "turnin", 1273, xp = 2840 }, -- Questioning Reethe (lvl 37, ~2840 xp, sim lvl 43)
    { "turnin", 1322, xp = 2280 }, -- The Black Shield (lvl 37, ~2280 xp, sim lvl 43)
    { "accept", 1323 }, -- The Black Shield (lvl 37, ~1120 xp, sim lvl 43)
    { "accept", 1173 }, -- Challenge Overlord Mok'Morokk (lvl 45, ~4850 xp, sim lvl 43)
    { "turnin", 1323, xp = 1120 }, -- The Black Shield (lvl 37, ~1120 xp, sim lvl 43)
    { "accept", 1276 }, -- The Black Shield (lvl 37, ~840 xp, sim lvl 43)
    { "turnin", 1239, xp = 820 }, -- The Severed Head (lvl 35, ~820 xp, sim lvl 43)
    { "complete", 1173, at = { 1445, 36.41, 31.43 } }, -- Challenge Overlord Mok'Morokk (lvl 45, ~4850 xp, sim lvl 43)
    { "turnin", 1173, xp = 4850 }, -- Challenge Overlord Mok'Morokk (lvl 45, ~4850 xp, sim lvl 43)
    { "turnin", 1177, xp = 1120 }, -- Hungry! (lvl 36, ~1120 xp, sim lvl 44)
    { "turnin", 1276, xp = 840 }, -- The Black Shield (lvl 37, ~840 xp, sim lvl 44)
  },
})
