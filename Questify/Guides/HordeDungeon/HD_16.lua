local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 55 étapes, niveau final 43.00, ~43796 xp/h, 387 min.
Q:RegisterGuide({
  id = "HD_16",
  title = "Riverglades",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 39, maxLevel = 43,
  next = "HD_17",
  sim = { steps = 55, endLevel = 43.00, xpPerHour = 43796, minutes = 387 },
  steps = {
    { "note", "Travel to Riverglades", alt = { "RFD", "ULDAMAN" }, below = 43 },
    { "accept", 96103, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Feast for Buzzards (lvl 38, ~710 xp, sim lvl 40)
    { "accept", 94961, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 40)
    { "complete", 94961, at = { 2548, 48.18, 47.61 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 40)
    { "accept", 96107, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 96103, xp = 710, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Feast for Buzzards (lvl 38, ~710 xp, sim lvl 40)
    { "accept", 96104, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 40)
    { "accept", 95062, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Frazzlespark's Crate (lvl 36, ~280 xp, sim lvl 40)
    { "accept", 95118, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 95121, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 95254, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- WANTED: Trapclaw (lvl 42, ~3450 xp, sim lvl 40)
    { "complete", 95121, at = { 2548, 74.3, 62.42 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 40)
    { "complete", 95118, at = { 2548, 74.17, 62.4 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 40)
    { "accept", 95260, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Terrors From the Deep (lvl 42, ~345 xp, sim lvl 40)
    { "turnin", 95118, xp = 3300, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 40)
    { "turnin", 95260, xp = 345, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Terrors From the Deep (lvl 42, ~345 xp, sim lvl 40)
    { "turnin", 95121, xp = 3150, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 40)
    { "complete", 95254, at = { 2548, 82.89, 51.5 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- WANTED: Trapclaw (lvl 42, ~3450 xp, sim lvl 40)
    { "turnin", 95254, xp = 3450, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- WANTED: Trapclaw (lvl 42, ~3450 xp, sim lvl 40)
    { "complete", 96107, at = { 2548, 68.06, 51.38 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 96107, xp = 3150, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 96108, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 40)
    { "complete", 96108, at = { 2548, 64.29, 55.08 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 40)
    { "turnin", 96108, xp = 2350, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 40)
    { "accept", 96109, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 40)
    { "complete", 96109, at = { 2548, 60.63, 53.33 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 96109, xp = 3150, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 40)
    { "accept", 94532, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 40)
    { "accept", 94535, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 40)
    { "accept", 93786, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 40)
    { "turnin", 95062, xp = 280, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Frazzlespark's Crate (lvl 36, ~280 xp, sim lvl 40)
    { "turnin", 94961, xp = 2350, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 40)
    { "accept", 94963, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Biting the Hand (lvl 40, ~3150 xp, sim lvl 40)
    { "turnin", 94963, xp = 3150, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Biting the Hand (lvl 40, ~3150 xp, sim lvl 40)
    { "complete", 94535, at = { 2548, 30.85, 58.95 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 40)
    { "complete", 94532, at = { 2548, 30.83, 59 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 40)
    { "complete", 93786, at = { 2548, 45.77, 81.27 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 40)
    { "complete", 96104, at = { 2548, 59.4, 58.78 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 40)
    { "turnin", 96104, xp = 3000, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 40)
    { "accept", 96105, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 40)
    { "turnin", 94532, xp = 2850, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 40)
    { "level", 41, at = { 2548, 49.47, 47.82 }, note = "About 27 mobs here (Twilight Raider, level 39)", alt = { "RFD", "ULDAMAN" }, below = 43 }, -- farm de niveau
    { "complete", 96105, at = { 2548, 59.61, 53.44 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 41)
    { "turnin", 96105, xp = 3300, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 41)
    { "turnin", 94535, xp = 2850, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 41)
    { "turnin", 93786, xp = 2800, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 41)
    { "accept", 95163, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Drive Them Back (lvl 40, ~3150 xp, sim lvl 41)
    { "accept", 94556, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Jom-jom's Escape (lvl 42, ~4300 xp, sim lvl 41)
    { "complete", 95163, at = { 2548, 72.84, 38.52 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Drive Them Back (lvl 40, ~3150 xp, sim lvl 41)
    { "turnin", 95163, xp = 3150, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Drive Them Back (lvl 40, ~3150 xp, sim lvl 41)
    { "accept", 95183, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Step One: Rock (lvl 41, ~1650 xp, sim lvl 41)
    { "complete", 95183, at = { 2548, 68, 29.1 }, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Step One: Rock (lvl 41, ~1650 xp, sim lvl 41)
    { "turnin", 95183, xp = 1650, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Step One: Rock (lvl 41, ~1650 xp, sim lvl 41)
    { "turnin", 94556, xp = 4300, alt = { "RFD", "ULDAMAN" }, below = 43 }, -- Jom-jom's Escape (lvl 42, ~4300 xp, sim lvl 41)
    { "level", 43, at = { 2548, 68.06, 30.08 }, note = "About 738 more mobs here (Twilight Mauler, level 41)", alt = { "RFD", "ULDAMAN" }, below = 43 }, -- farm de niveau
  },
})
