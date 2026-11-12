local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 45 étapes, niveau final 40.00, ~38754 xp/h, 90 min.
Q:RegisterGuide({
  id = "A_13",
  title = "Arathi Highlands",
  faction = "Alliance",
  minLevel = 39, maxLevel = 40,
  next = "A_15",
  sim = { steps = 45, endLevel = 40.00, xpPerHour = 38754, minutes = 90 },
  steps = {
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "fp", 1417, 45.73, 46.1 }, -- point de vol
    { "accept", 691 }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 39)
    { "complete", 691, at = { 1417, 68.31, 80.15 } }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 39)
    { "turnin", 79242, xp = 3900 }, -- No Honor Among Thieves (lvl 40, ~3900 xp, sim lvl 39)
    { "accept", 79949 }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~0 xp, sim lvl 39)
    { "complete", 79949, at = { 1417, 73.6, 65.2 } }, -- A Web of Lies: Debunking Myths and Legends (lvl 35, ~0 xp, sim lvl 39)
    { "turnin", 635, xp = 1350 }, -- Crystal in the Mountains (lvl 35, ~1350 xp, sim lvl 39)
    { "accept", 96016, classes = { "SHAMAN" } }, -- The Tempest's Weapons (lvl 40, ~3900 xp, sim lvl 39)
    { "turnin", 691, xp = 3500 }, -- Worth Its Weight in Gold (lvl 36, ~3500 xp, sim lvl 39)
    { "accept", 693 }, -- Wand over Fist (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 96784, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 39)
    { "accept", 663 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 39)
    { "turnin", 663, xp = 690 }, -- Land Ho! (lvl 35, ~690 xp, sim lvl 39)
    { "accept", 662 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 664 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 665 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 39)
    { "complete", 665, at = { 1417, 33.87, 80.6 } }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 665, xp = 3150 }, -- Sunken Treasure (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 666 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 39)
    { "complete", 666, at = { 1417, 23.62, 88.25 } }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 39)
    { "complete", 662, at = { 1417, 23.05, 84.51 } }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 39)
    { "complete", 664, at = { 1417, 23.27, 87.78 } }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 666, xp = 3900 }, -- Sunken Treasure (lvl 40, ~3900 xp, sim lvl 39)
    { "accept", 668 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 39)
    { "turnin", 662, xp = 3150 }, -- Deep Sea Salvage (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 664, xp = 3150 }, -- Drowned Sorrows (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 668, xp = 1550 }, -- Sunken Treasure (lvl 40, ~1550 xp, sim lvl 39)
    { "accept", 669 }, -- Sunken Treasure (lvl 40, ~0 xp, sim lvl 39)
    { "complete", 693, at = { 1417, 54.75, 81.87 } }, -- Wand over Fist (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 79678 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 79678, xp = 3150 }, -- Taste Testing (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 693, xp = 3000 }, -- Wand over Fist (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 92872 }, -- Dutiful Steps (lvl 38, ~2850 xp, sim lvl 39)
    { "turnin", 96784, xp = 2800, classes = { "ROGUE" } }, -- Master of Disguise (lvl 36, ~2800 xp, sim lvl 39)
    { "turnin", 92872, xp = 2850 }, -- Dutiful Steps (lvl 38, ~2850 xp, sim lvl 39)
    { "goto", 1417, 45.73, 46.1, note = "Flight master" }, -- déplacement
    { "fly", 1424, node = 14, note = "Southshore, Hillsbrad" }, -- vol
    { "turnin", 602, xp = 1400 }, -- Magical Analysis (lvl 37, ~1400 xp, sim lvl 39)
    { "turnin", 96016, xp = 3900, classes = { "SHAMAN" } }, -- The Tempest's Weapons (lvl 40, ~3900 xp, sim lvl 39)
    { "accept", 96773, optional = true, dungeon = "Razorfen Downs" }, -- The Coldbringer's Eye (lvl 41, ~0 xp, sim lvl 39)
    { "accept", 96770, optional = true, dungeon = "Zul'Farrak" }, -- The Witch Doctor's Head (lvl 46, ~0 xp, sim lvl 39)
    { "accept", 96800, optional = true, dungeon = "Scarlet Monastery" }, -- Past Due (lvl 38, ~0 xp, sim lvl 39)
    { "level", 40, at = { 1417, 54.75, 81.87 }, note = "About 16 more mobs near the last objective" }, -- farm de niveau
  },
})
