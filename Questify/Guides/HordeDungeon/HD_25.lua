local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 95 étapes, niveau final 53.00, ~62941 xp/h, 153 min.
Q:RegisterGuide({
  id = "HD_25",
  title = "Searing Gorge and Burning Steppes",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 52, maxLevel = 53,
  next = "HD_26",
  sim = { steps = 95, endLevel = 53.00, xpPerHour = 62941, minutes = 153 },
  steps = {
    { "goto", 1435, 46.07, 54.83, note = "Flight master" }, -- déplacement
    { "fly", 1418, node = 21, note = "Kargath, Badlands" }, -- vol
    { "accept", 4081, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- KILL ON SIGHT: Dark Iron Dwarves (lvl 52, ~0 xp, sim lvl 52)
    { "accept", 3821 }, -- Dreadmaul Rock (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 4061 }, -- The Rise of the Machines (lvl 54, ~5450 xp, sim lvl 52)
    { "accept", 4134, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- Lost Thunderbrew Recipe (lvl 55, ~0 xp, sim lvl 52)
    { "boat", 1455, 78, 51.4, note = "Take the Deeprun Tram to Stormwind" }, -- bateau
    { "fp", 1427, 34.84, 30.87 }, -- point de vol
    { "accept", 7701 }, -- WANTED: Overseer Maltorius (lvl 50, ~4700 xp, sim lvl 52)
    { "accept", 7728 }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 52)
    { "accept", 7729 }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 52)
    { "accept", 7727 }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 52)
    { "accept", 7723 }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 52)
    { "accept", 7724 }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 52)
    { "accept", 7722 }, -- What the Flux? (lvl 50, ~4700 xp, sim lvl 52)
    { "accept", 3441 }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 52)
    { "complete", 3441, at = { 1427, 39.06, 38.99 } }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 52)
    { "turnin", 3441, xp = 440 }, -- Divine Retribution (lvl 48, ~440 xp, sim lvl 52)
    { "accept", 3442 }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 52)
    { "complete", 7722, at = { 1427, 40.45, 35.74 } }, -- What the Flux? (lvl 50, ~4700 xp, sim lvl 52)
    { "accept", 4451, at = { 1427, 42.12, 34.65 }, note = "Loot Grimesilt Outhouse Key to start the quest (5.2 % drop: about 20 kills)" }, -- The Key to Freedom (lvl 47, ~5250 xp, sim lvl 52)
    { "complete", 7729, at = { 1427, 43.75, 35.25 } }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 52)
    { "complete", 7701, at = { 1427, 40.77, 35.89 } }, -- WANTED: Overseer Maltorius (lvl 50, ~4700 xp, sim lvl 52)
    { "complete", 7723, at = { 1427, 43.63, 41.32 } }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 52)
    { "complete", 7727, at = { 1427, 48.4, 24.03 } }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 52)
    { "complete", 3442, at = { 1427, 54.57, 47.42 } }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 52)
    { "turnin", 4451, xp = 5250 }, -- The Key to Freedom (lvl 47, ~5250 xp, sim lvl 52)
    { "fp", 1428, 65.69, 24.22 }, -- point de vol
    { "accept", 4136, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~0 xp, sim lvl 52)
    { "accept", 4296 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "accept", 4123, optional = true, dungeon = "Blackrock Depths", phase = "prep", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~0 xp, sim lvl 52)
    { "accept", 4726 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "complete", 4726, at = { 1428, 86.98, 31.41 } }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "turnin", 3821, xp = 5100 }, -- Dreadmaul Rock (lvl 52, ~5100 xp, sim lvl 52)
    { "accept", 3822 }, -- Krom'Grul (lvl 53, ~5250 xp, sim lvl 52)
    { "complete", 3822, at = { 1428, 79.66, 47.43 } }, -- Krom'Grul (lvl 53, ~5250 xp, sim lvl 52)
    { "complete", 4296, at = { 1428, 54.12, 40.76 } }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "complete", 4061, at = { 1428, 59.6, 37.02 } }, -- The Rise of the Machines (lvl 54, ~5450 xp, sim lvl 52)
    { "turnin", 4726, xp = 5100 }, -- Broodling Essence (lvl 52, ~5100 xp, sim lvl 52)
    { "turnin", 4296, xp = 2350 }, -- Tablet of the Seven (lvl 50, ~2350 xp, sim lvl 52)
    { "fly", 1418, node = 21, note = "Kargath, Badlands" }, -- vol
    { "turnin", 3822, xp = 5250 }, -- Krom'Grul (lvl 53, ~5250 xp, sim lvl 52)
    { "turnin", 4061, xp = 5450 }, -- The Rise of the Machines (lvl 54, ~5450 xp, sim lvl 52)
    { "goto", 1418, 3.99, 44.78, note = "Flight master" }, -- déplacement
    { "fly", 1427, node = 75, note = "Thorium Point, Searing Gorge" }, -- vol
    { "turnin", 3442, xp = 4400 }, -- The Flawless Flame (lvl 48, ~4400 xp, sim lvl 52)
    { "accept", 3443 }, -- Forging the Shaft (lvl 48, ~4400 xp, sim lvl 52)
    { "complete", 3443, at = { 1427, 42.09, 34.68 } }, -- Forging the Shaft (lvl 48, ~4400 xp, sim lvl 52)
    { "turnin", 3443, xp = 4400 }, -- Forging the Shaft (lvl 48, ~4400 xp, sim lvl 52)
    { "accept", 3452 }, -- The Flame's Casing (lvl 50, ~4700 xp, sim lvl 52)
    { "complete", 3452, at = { 1427, 21.78, 37.25 } }, -- The Flame's Casing (lvl 50, ~4700 xp, sim lvl 52)
    { "turnin", 3452, xp = 4700 }, -- The Flame's Casing (lvl 50, ~4700 xp, sim lvl 52)
    { "accept", 3453 }, -- The Torch of Retribution (lvl 50, ~470 xp, sim lvl 52)
    { "complete", 3453, at = { 1427, 39.06, 38.99 } }, -- The Torch of Retribution (lvl 50, ~470 xp, sim lvl 52)
    { "turnin", 3453, xp = 470 }, -- The Torch of Retribution (lvl 50, ~470 xp, sim lvl 52)
    { "accept", 3454 }, -- The Torch of Retribution (lvl 50, ~4700 xp, sim lvl 52)
    { "turnin", 3454, xp = 4700 }, -- The Torch of Retribution (lvl 50, ~4700 xp, sim lvl 52)
    { "accept", 3462 }, -- Squire Maltrake (lvl 50, ~470 xp, sim lvl 52)
    { "turnin", 3462, xp = 470 }, -- Squire Maltrake (lvl 50, ~470 xp, sim lvl 52)
    { "accept", 3463 }, -- Set Them Ablaze! (lvl 52, ~7600 xp, sim lvl 52)
    { "complete", 3463, obj = 3, at = { 1427, 50.07, 54.74 } }, -- Set Them Ablaze! (lvl 52, ~7600 xp, sim lvl 52)
    { "complete", 3463, obj = 2, at = { 1427, 44.03, 60.91 } }, -- Set Them Ablaze! (lvl 52, ~7600 xp, sim lvl 52)
    { "complete", 3463, at = { 1427, 35.67, 60.68 } }, -- Set Them Ablaze! (lvl 52, ~7600 xp, sim lvl 52)
    { "complete", 7728, obj = 2, at = { 1427, 33.01, 53.96 } }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 52)
    { "complete", 7724, at = { 1427, 28.59, 72.01 } }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 52)
    { "complete", 7728, at = { 1427, 39.88, 50.1 } }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 52)
    { "turnin", 3463, xp = 7600 }, -- Set Them Ablaze! (lvl 52, ~7600 xp, sim lvl 52)
    { "accept", 3481 }, -- Trinkets... (lvl 50, ~470 xp, sim lvl 52)
    { "turnin", 3481, xp = 470 }, -- Trinkets... (lvl 50, ~470 xp, sim lvl 52)
    { "turnin", 7722, xp = 4700 }, -- What the Flux? (lvl 50, ~4700 xp, sim lvl 52)
    { "turnin", 7729, xp = 4400 }, -- JOB OPPORTUNITY: Culling the Competition (lvl 48, ~4400 xp, sim lvl 52)
    { "turnin", 7728, xp = 4400 }, -- STOLEN: Smithing Tuyere and Lookout's Spyglass (lvl 48, ~4400 xp, sim lvl 52)
    { "turnin", 7727, xp = 4550 }, -- Incendosaurs? Whateverosaur is More Like It (lvl 49, ~4550 xp, sim lvl 52)
    { "turnin", 7723, xp = 4550 }, -- Curse These Fat Fingers (lvl 49, ~4550 xp, sim lvl 52)
    { "turnin", 7724, xp = 4550 }, -- Fiery Menace! (lvl 49, ~4550 xp, sim lvl 52)
    { "turnin", 7701, xp = 4700 }, -- WANTED: Overseer Maltorius (lvl 50, ~4700 xp, sim lvl 52)
    { "level", 53, at = { 1427, 39.88, 50.1 }, note = "About 22 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1427, 34.8, 85.3, optional = true, dungeon = "Blackrock Depths", note = "Dungeon: Blackrock Depths (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "BRD" }, -- déplacement
    { "complete", 4081, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- KILL ON SIGHT: Dark Iron Dwarves (lvl 52, ~2550 xp, sim lvl 53)
    { "complete", 4123, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 53)
    { "complete", 4134, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Lost Thunderbrew Recipe (lvl 55, ~2825 xp, sim lvl 53)
    { "complete", 4136, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 53)
    { "turnin", 4081, at = { 1418, 5.81, 47.52 }, xp = 2550, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- KILL ON SIGHT: Dark Iron Dwarves (lvl 52, ~2550 xp, sim lvl 53)
    { "turnin", 4134, at = { 1418, 2.9, 47.76 }, xp = 2825, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Lost Thunderbrew Recipe (lvl 55, ~2825 xp, sim lvl 53)
    { "turnin", 4123, at = { 1428, 65.15, 23.91 }, xp = 2825, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Heart of the Mountain (lvl 55, ~2825 xp, sim lvl 53)
    { "turnin", 4136, at = { 1428, 66.06, 21.95 }, xp = 1325, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- Ribbly Screwspigot (lvl 53, ~1325 xp, sim lvl 53)
    { "accept", 4083, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 53)
    { "accept", 4201, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 53)
    { "accept", 7604, optional = true, dungeon = "Blackrock Depths", note = "Starts inside the dungeon", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 53)
    { "complete", 4083, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 53)
    { "complete", 4201, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 53)
    { "complete", 7604, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 53)
    { "turnin", 4083, xp = 280, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Spectral Chalice (lvl 55, ~280 xp, sim lvl 53)
    { "turnin", 4201, xp = 2725, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- The Love Potion (lvl 54, ~2725 xp, sim lvl 53)
    { "turnin", 7604, xp = 3300, optional = true, dungeon = "Blackrock Depths", phase = "run", rung = "BRD" }, -- A Binding Contract (lvl 60, ~3300 xp, sim lvl 53)
  },
})
