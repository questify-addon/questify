local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 44 étapes, niveau final 28.73, ~26237 xp/h, 50 min.
Q:RegisterGuide({
  id = "AD_08",
  title = "Wetlands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 28, maxLevel = 29,
  next = "AD_09",
  sim = { steps = 44, endLevel = 28.73, xpPerHour = 26237, minutes = 50 },
  steps = {
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1453, node = 2, note = "Stormwind, Elwynn" }, -- vol
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "boat", 1439, 32.4, 43.8, note = "Take the boat to Menethil Harbor" }, -- bateau
    { "fp", 1437, 9.49, 59.69 }, -- point de vol
    { "accept", 98221 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 98230 }, -- This Land Was Their Land (lvl 29, ~235 xp, sim lvl 28)
    { "turnin", 98221, xp = 2300 }, -- From the Ashes (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 98240 }, -- Crimson Crate Delivery (lvl 29, ~1200 xp, sim lvl 28)
    { "accept", 472 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 28)
    { "accept", 98216, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 28)
    { "accept", 98824, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Prehistoric Prism (lvl 31, ~0 xp, sim lvl 28)
    { "accept", 98223 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 28)
    { "turnin", 98230, xp = 235 }, -- This Land Was Their Land (lvl 29, ~235 xp, sim lvl 28)
    { "accept", 98245 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 28)
    { "turnin", 98240, xp = 1200 }, -- Crimson Crate Delivery (lvl 29, ~1200 xp, sim lvl 28)
    { "accept", 87491 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 28)
    { "accept", 304, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 28)
    { "turnin", 87491, xp = 2450 }, -- Spark of Freedom (lvl 30, ~2450 xp, sim lvl 28)
    { "turnin", 472, xp = 1200 }, -- Fall of Dun Modr (lvl 25, ~1200 xp, sim lvl 28)
    { "complete", 304, at = { 1437, 61.9, 29.94 }, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 28)
    { "complete", 98245, at = { 1437, 68.59, 30.72 } }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 28)
    { "turnin", 304, xp = 3350, optional = true, dungeon = "Group quest: Balgaras the Foul, level 34 elite" }, -- A Grim Task (lvl 34, ~3350 xp, sim lvl 28)
    { "turnin", 98245, xp = 2350 }, -- Razormaw Needling (lvl 29, ~2350 xp, sim lvl 28)
    { "complete", 98216, at = { 1437, 34.91, 49.67 }, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 28)
    { "accept", 95647, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Lost in the Thicket Things (lvl 31, ~0 xp, sim lvl 28)
    { "turnin", 98223, xp = 1250 }, -- Old Habits (lvl 31, ~1250 xp, sim lvl 28)
    { "goto", 1437, 9.49, 59.69, note = "Flight master" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "accept", 2924, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Essential Artificials (lvl 30, ~0 xp, sim lvl 28)
    { "accept", 2929, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- The Grand Betrayal (lvl 35, ~0 xp, sim lvl 28)
    { "accept", 2927, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- The Day After (lvl 27, ~0 xp, sim lvl 28)
    { "accept", 2922, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Save Techbot's Brain! (lvl 26, ~0 xp, sim lvl 28)
    { "accept", 2930, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Data Rescue (lvl 30, ~0 xp, sim lvl 28)
    { "accept", 1050, optional = true, dungeon = "Scarlet Monastery", phase = "prep", rung = "SM_LIB" }, -- Mythology of the Titans (lvl 38, ~0 xp, sim lvl 28)
    { "turnin", 98216, xp = 3150, optional = true, dungeon = "Group quest: Goaz Warder, level 32 elite" }, -- Understanding Our Present (lvl 31, ~3150 xp, sim lvl 28)
    { "goto", 1437, 47.79, 56.16, optional = true, dungeon = "Excavation Site: Wetlands", note = "Dungeon: Excavation Site: Wetlands (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "EXCAVATION" }, -- déplacement
    { "turnin", 95647, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost in the Thicket Things (lvl 31, ~625 xp, sim lvl 28)
    { "turnin", 95737, at = { 1437, 11.88, 58.82 }, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Seeking Caitlin (lvl 31, ~625 xp, sim lvl 28)
    { "turnin", 98824, at = { 1455, 69.93, 18.55 }, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Prehistoric Prism (lvl 31, ~625 xp, sim lvl 28)
    { "accept", 95810, optional = true, dungeon = "Excavation Site: Wetlands", note = "Starts inside the dungeon", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 28)
    { "complete", 95810, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 28)
    { "turnin", 95810, at = { 1437, 38.81, 52.39 }, xp = 625, optional = true, dungeon = "Excavation Site: Wetlands", phase = "run", rung = "EXCAVATION" }, -- Lost Relic Carry (lvl 31, ~625 xp, sim lvl 28)
  },
})
