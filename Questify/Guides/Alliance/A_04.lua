local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 48 étapes, niveau final 29.00, ~33819 xp/h, 130 min.
Q:RegisterGuide({
  id = "A_04",
  title = "Wetlands",
  faction = "Alliance",
  minLevel = 26, maxLevel = 29,
  next = "A_05",
  sim = { steps = 48, endLevel = 29.00, xpPerHour = 33819, minutes = 130 },
  steps = {
    { "note", "You pass through Stormwind: run The Stockade now for Crime and Punishment and What Comes Around..., or abandon them", optional = true, dungeon = "The Stockade" },
    { "goto", 1436, 56.55, 52.64, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor" }, -- bateau
    { "fp", 1437, 9.49, 59.69 }, -- point de vol
    { "accept", 288 }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 27)
    { "complete", 288, at = { 1437, 10.7, 60.95 } }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 27)
    { "sethearth", 1437, 10.7, 60.95 }, -- lier la pierre de foyer
    { "turnin", 288, xp = 220 }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 27)
    { "accept", 95647, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Lost in the Thicket Things (lvl 31, ~0 xp, sim lvl 27)
    { "accept", 470 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "accept", 98221 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 27)
    { "accept", 98230 }, -- This Land Was Their Land (lvl 29, ~235 xp, sim lvl 27)
    { "turnin", 98221, xp = 2300 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 27)
    { "accept", 98240 }, -- Crimson Crate Delivery (lvl 29, ~1200 xp, sim lvl 27)
    { "accept", 98815, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Highland Hides (lvl 28, ~0 xp, sim lvl 27)
    { "accept", 472 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 27)
    { "accept", 305 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 27)
    { "complete", 470, at = { 1437, 44.36, 25.54 } }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "accept", 87491 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 27)
    { "turnin", 472, xp = 1200 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 27)
    { "accept", 304, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "turnin", 87491, xp = 2450 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 27)
    { "turnin", 98230, xp = 235 }, -- This Land Was Their Land (lvl 29, ~235 xp, sim lvl 27)
    { "accept", 98245 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 27)
    { "turnin", 98240, xp = 1200 }, -- Crimson Crate Delivery (lvl 29, ~1200 xp, sim lvl 27)
    { "accept", 95646, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Horrors in the Highland (lvl 31, ~0 xp, sim lvl 27)
    { "complete", 98245, at = { 1437, 68.59, 30.72 } }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 27)
    { "complete", 304, at = { 1437, 61.9, 29.94 }, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "turnin", 304, xp = 3350, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 27)
    { "turnin", 98245, xp = 2350 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 27)
    { "accept", 98223 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 27)
    { "turnin", 305, xp = 970 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 27)
    { "accept", 306 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "accept", 98216, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 27)
    { "accept", 98824, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Prehistoric Prism (lvl 31, ~0 xp, sim lvl 27)
    { "accept", 294 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "hearth", 1437 }, -- pierre de foyer
    { "turnin", 470, xp = 2400 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "turnin", 98223, xp = 1250 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 27)
    { "turnin", 306, xp = 485 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "complete", 294, at = { 1437, 24.5, 48.38 } }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "complete", 98216, at = { 1437, 34.91, 49.67 }, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 27)
    { "turnin", 294, xp = 1950 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 98216, xp = 3150, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 28)
    { "turnin", 79974, xp = 2550, race = { "Dwarf", "Gnome" } }, -- Wet Job (lvl 32, ~2550 xp, sim lvl 28)
    { "accept", 79975, race = { "Dwarf", "Gnome" } }, -- Eagle's Fist (lvl 32, ~0 xp, sim lvl 28)
    { "level", 29, at = { 1437, 34.91, 49.67 }, note = "About 154 more mobs near the last objective" }, -- farm de niveau
  },
})
