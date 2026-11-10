local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-10.
-- Simulation : 51 étapes, niveau final 29.00, ~32837 xp/h, 179 min.
Q:RegisterGuide({
  id = "A_04",
  title = "Wetlands",
  faction = "Alliance",
  minLevel = 26, maxLevel = 29,
  next = "A_05",
  sim = { steps = 51, endLevel = 29.00, xpPerHour = 32837, minutes = 179 },
  steps = {
    { "note", "You pass through Stormwind: run The Stockade now for Crime and Punishment and What Comes Around..., or abandon them", optional = true, dungeon = "The Stockade" },
    { "goto", 1436, 56.55, 52.64, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor" }, -- bateau
    { "fp", 1437, 9.49, 59.69 }, -- point de vol
    { "accept", 98189 }, -- Return the Statuette (lvl 25, ~1000 xp, sim lvl 26)
    { "accept", 98815, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Highland Hides (lvl 28, ~0 xp, sim lvl 26)
    { "accept", 98240 }, -- Crimson Crate Delivery (lvl 29, ~590 xp, sim lvl 26)
    { "accept", 98221 }, -- From the Ashes (lvl 28, ~570 xp, sim lvl 26)
    { "accept", 98230 }, -- This Land Was Their Land (lvl 29, ~590 xp, sim lvl 26)
    { "turnin", 98189, xp = 1000 }, -- Return the Statuette (lvl 25, ~1000 xp, sim lvl 26)
    { "turnin", 98221, xp = 570 }, -- From the Ashes (lvl 28, ~570 xp, sim lvl 26)
    { "accept", 288 }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 26)
    { "complete", 288, at = { 1437, 10.7, 60.95 } }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 26)
    { "sethearth", 1437, 10.7, 60.95 }, -- lier la pierre de foyer
    { "turnin", 288, xp = 220 }, -- The Third Fleet (lvl 27, ~220 xp, sim lvl 26)
    { "accept", 289 }, -- The Cursed Crew (lvl 29, ~1750 xp, sim lvl 26)
    { "accept", 470 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 26)
    { "accept", 472 }, -- Fall of Dun Modr (lvl 25, ~1000 xp, sim lvl 26)
    { "accept", 305 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 26)
    { "accept", 98245 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 98230, xp = 590 }, -- This Land Was Their Land (lvl 29, ~590 xp, sim lvl 26)
    { "turnin", 98240, xp = 590 }, -- Crimson Crate Delivery (lvl 29, ~590 xp, sim lvl 26)
    { "complete", 470, at = { 1437, 44.36, 25.54 } }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 26)
    { "accept", 304, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 26)
    { "turnin", 472, xp = 1000 }, -- Fall of Dun Modr (lvl 25, ~1000 xp, sim lvl 26)
    { "complete", 304, at = { 1437, 61.9, 29.94 }, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 26)
    { "complete", 98245, at = { 1437, 68.59, 30.72 } }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 26)
    { "turnin", 304, xp = 3350, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 26)
    { "accept", 95646, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Horrors in the Highland (lvl 31, ~0 xp, sim lvl 27)
    { "turnin", 98245, xp = 2350 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 27)
    { "accept", 98223 }, -- Old Habits (lvl 31, ~940 xp, sim lvl 27)
    { "turnin", 305, xp = 970 }, -- In Search of The Excavation Team (lvl 24, ~970 xp, sim lvl 27)
    { "accept", 306 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "accept", 98216, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~2500 xp, sim lvl 27)
    { "accept", 294 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "complete", 289, obj = 2, at = { 1437, 14.67, 24.18 } }, -- The Cursed Crew (lvl 29, ~1750 xp, sim lvl 27)
    { "complete", 289, at = { 1437, 13.81, 30.07 } }, -- The Cursed Crew (lvl 29, ~1750 xp, sim lvl 27)
    { "turnin", 306, xp = 485 }, -- In Search of The Excavation Team (lvl 24, ~485 xp, sim lvl 27)
    { "turnin", 98223, xp = 940 }, -- Old Habits (lvl 31, ~940 xp, sim lvl 27)
    { "turnin", 289, xp = 1750 }, -- The Cursed Crew (lvl 29, ~1750 xp, sim lvl 27)
    { "turnin", 470, xp = 2400 }, -- Digging Through the Ooze (lvl 24, ~2400 xp, sim lvl 27)
    { "accept", 95647, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Lost in the Thicket Things (lvl 31, ~0 xp, sim lvl 27)
    { "complete", 294, at = { 1437, 24.5, 48.38 } }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "complete", 98216, at = { 1437, 34.62, 49.89 }, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~2500 xp, sim lvl 27)
    { "turnin", 294, xp = 1950 }, -- Ormer's Revenge (lvl 24, ~1950 xp, sim lvl 27)
    { "turnin", 98216, xp = 2500, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~2500 xp, sim lvl 27)
    { "accept", 98824, optional = true, dungeon = "Excavation Site: Wetlands" }, -- Prehistoric Prism (lvl 31, ~0 xp, sim lvl 27)
    { "turnin", 79974, xp = 640, race = { "Dwarf", "Gnome" } }, -- Wet Job (lvl 32, ~640 xp, sim lvl 27)
    { "accept", 79975, race = { "Dwarf", "Gnome" } }, -- Eagle's Fist (lvl 32, ~0 xp, sim lvl 27)
    { "level", 29, at = { 1437, 34.62, 49.89 }, note = "About 263 more mobs near the last objective" }, -- farm de niveau
  },
})
