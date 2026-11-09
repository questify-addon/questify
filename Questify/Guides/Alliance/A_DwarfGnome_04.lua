local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 60 étapes, niveau final 16.88, ~19343 xp/h, 117 min.
Q:RegisterGuide({
  id = "A_DwarfGnome_04",
  title = "Westfall",
  faction = "Alliance",
  races = { "Dwarf", "Gnome" },
  minLevel = 13, maxLevel = 16,
  next = "A_01",
  sim = { steps = 60, endLevel = 16.88, xpPerHour = 19343, minutes = 117 },
  steps = {
    { "fp", 1453, 71.29, 72.23 }, -- point de vol
    { "accept", 64 }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 151 }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 14)
    { "fp", 1436, 56.55, 52.64 }, -- point de vol
    { "accept", 12 }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 102 }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 14)
    { "accept", 153 }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 14)
    { "accept", 92742 }, -- Testing the Wells (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 92744 }, -- Murloc Gills (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 109 }, -- Report to Gryan Stoutmantle (lvl 10, ~630 xp, sim lvl 14)
    { "accept", 9 }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 14)
    { "complete", 151, at = { 1436, 57.27, 18.31 } }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 14)
    { "complete", 92742, obj = 1, at = { 1436, 56.62, 18.69 } }, -- Testing the Wells (lvl 12, ~910 xp, sim lvl 14)
    { "complete", 64, at = { 1436, 49.33, 19.28 } }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 14)
    { "complete", 153, at = { 1436, 45.34, 22.76 } }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 14)
    { "complete", 12, obj = 2, at = { 1436, 44.8, 25.95 } }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 136, at = { 1436, 34.53, 17 }, note = "Loot Captain Sander's Treasure Map to start the quest" }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 14)
    { "complete", 92744, at = { 1436, 34.53, 17 } }, -- Murloc Gills (lvl 12, ~910 xp, sim lvl 14)
    { "complete", 12, at = { 1436, 31.61, 33.78 } }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 14)
    { "complete", 92742, at = { 1436, 46.08, 38.14 } }, -- Testing the Wells (lvl 12, ~910 xp, sim lvl 14)
    { "turnin", 109, xp = 630 }, -- Report to Gryan Stoutmantle (lvl 10, ~630 xp, sim lvl 14)
    { "turnin", 12, xp = 910 }, -- The People's Militia (lvl 12, ~910 xp, sim lvl 14)
    { "accept", 13 }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 14)
    { "turnin", 153, xp = 1050 }, -- Red Leather Bandanas (lvl 15, ~1050 xp, sim lvl 14)
    { "turnin", 92744, xp = 910 }, -- Murloc Gills (lvl 12, ~910 xp, sim lvl 15)
    { "turnin", 92742, xp = 910 }, -- Testing the Wells (lvl 12, ~910 xp, sim lvl 15)
    { "accept", 92745 }, -- The State of the Mines (lvl 14, ~980 xp, sim lvl 15)
    { "complete", 13, at = { 1436, 43.7, 68.91 } }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 15)
    { "accept", 103 }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 15)
    { "complete", 102, at = { 1436, 31.04, 68.76 } }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 15)
    { "turnin", 136, xp = 580 }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 15)
    { "accept", 138 }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 15)
    { "complete", 92745, obj = 2, at = { 1436, 29.98, 47.26 } }, -- The State of the Mines (lvl 14, ~980 xp, sim lvl 15)
    { "accept", 79192 }, -- Stepping Stones (lvl 24, ~0 xp, sim lvl 15)
    { "complete", 9, at = { 1436, 38.78, 51.51 } }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 15)
    { "turnin", 138, xp = 580 }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 15)
    { "accept", 139 }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 15)
    { "turnin", 139, xp = 580 }, -- Captain Sander's Hidden Treasure (lvl 16, ~580 xp, sim lvl 15)
    { "accept", 140 }, -- Captain Sander's Hidden Treasure (lvl 16, ~1150 xp, sim lvl 15)
    { "turnin", 140, xp = 1150 }, -- Captain Sander's Hidden Treasure (lvl 16, ~1150 xp, sim lvl 15)
    { "complete", 92745, at = { 1436, 45.29, 20.05 } }, -- The State of the Mines (lvl 14, ~980 xp, sim lvl 15)
    { "complete", 103, at = { 1436, 52.84, 23.8 } }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 15)
    { "turnin", 9, xp = 1050 }, -- The Killing Fields (lvl 15, ~1050 xp, sim lvl 16)
    { "turnin", 13, xp = 980 }, -- The People's Militia (lvl 14, ~980 xp, sim lvl 16)
    { "accept", 14 }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 16)
    { "turnin", 102, xp = 980 }, -- Patrolling Westfall (lvl 14, ~980 xp, sim lvl 16)
    { "turnin", 92745, xp = 980 }, -- The State of the Mines (lvl 14, ~980 xp, sim lvl 16)
    { "accept", 92747 }, -- Moonbrook Espionage (lvl 15, ~1050 xp, sim lvl 16)
    { "complete", 14, at = { 1436, 52.07, 76.61 } }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 16)
    { "turnin", 103, xp = 1150 }, -- Keeper of the Flame (lvl 16, ~1150 xp, sim lvl 16)
    { "complete", 92747, at = { 1436, 43.11, 68.85 } }, -- Moonbrook Espionage (lvl 15, ~1050 xp, sim lvl 16)
    { "turnin", 92747, xp = 1050 }, -- Moonbrook Espionage (lvl 15, ~1050 xp, sim lvl 16)
    { "accept", 92748 }, -- Explosive Consultation (lvl 16, ~580 xp, sim lvl 16)
    { "turnin", 14, xp = 1600 }, -- The People's Militia (lvl 17, ~1600 xp, sim lvl 16)
    { "turnin", 151, xp = 1250 }, -- Poor Old Blanchy (lvl 14, ~1250 xp, sim lvl 16)
    { "turnin", 64, xp = 910 }, -- The Forgotten Heirloom (lvl 12, ~910 xp, sim lvl 16)
    { "accept", 167, optional = true, dungeon = "The Deadmines" }, -- Oh Brother. . . (lvl 20, ~0 xp, sim lvl 16)
    { "accept", 168, optional = true, dungeon = "The Deadmines" }, -- Collecting Memories (lvl 18, ~0 xp, sim lvl 16)
    { "accept", 2040, optional = true, dungeon = "The Deadmines" }, -- Underground Assault (lvl 20, ~0 xp, sim lvl 16)
    { "turnin", 92748, xp = 580 }, -- Explosive Consultation (lvl 16, ~580 xp, sim lvl 16)
  },
})
