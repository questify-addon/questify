local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 47 étapes, niveau final 40.00, ~43902 xp/h, 332 min.
Q:RegisterGuide({
  id = "H_31",
  title = "Riverglades",
  faction = "Horde",
  minLevel = 37, maxLevel = 40,
  next = "H_13",
  sim = { steps = 47, endLevel = 40.00, xpPerHour = 43902, minutes = 332 },
  steps = {
    { "note", "Not running City of Dalaran? Abandon The Grave Knight", optional = true, dungeon = "City of Dalaran" },
    { "note", "Travel to Riverglades" },
    { "accept", 94556 }, -- Jom-jom's Escape (lvl 42, ~4300 xp, sim lvl 37)
    { "turnin", 94556, xp = 4300 }, -- Jom-jom's Escape (lvl 42, ~4300 xp, sim lvl 37)
    { "accept", 95118 }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 37)
    { "accept", 95121 }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 37)
    { "accept", 95260 }, -- Terrors From the Deep (lvl 42, ~345 xp, sim lvl 37)
    { "complete", 95118, at = { 2548, 74.17, 62.4 } }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 37)
    { "complete", 95121, at = { 2548, 74.3, 62.42 } }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 95121, xp = 3150 }, -- A Taste of the Sea (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 95118, xp = 3300 }, -- Saltwater Savages (lvl 41, ~3300 xp, sim lvl 37)
    { "turnin", 95260, xp = 345 }, -- Terrors From the Deep (lvl 42, ~345 xp, sim lvl 37)
    { "accept", 95062 }, -- Frazzlespark's Crate (lvl 36, ~280 xp, sim lvl 37)
    { "accept", 96103 }, -- A Feast for Buzzards (lvl 38, ~710 xp, sim lvl 37)
    { "accept", 96107 }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 96103, xp = 710 }, -- A Feast for Buzzards (lvl 38, ~710 xp, sim lvl 37)
    { "accept", 96104 }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 37)
    { "complete", 96107, at = { 2548, 68.06, 51.38 } }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 96107, xp = 3150 }, -- Feathers for Fletching (lvl 40, ~3150 xp, sim lvl 37)
    { "accept", 96108 }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 37)
    { "complete", 96108, at = { 2548, 64.29, 55.08 } }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 37)
    { "complete", 96104, at = { 2548, 59.4, 58.78 } }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 37)
    { "accept", 94961 }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 37)
    { "complete", 94961, at = { 2548, 48.18, 47.61 } }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 37)
    { "turnin", 96108, xp = 2350 }, -- Poison Tips (lvl 40, ~2350 xp, sim lvl 37)
    { "accept", 96109 }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 96104, xp = 3000 }, -- Song of the Strider (lvl 39, ~3000 xp, sim lvl 37)
    { "accept", 96105 }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 37)
    { "complete", 96109, at = { 2548, 60.63, 53.33 } }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 37)
    { "complete", 96105, at = { 2548, 59.61, 53.44 } }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 37)
    { "turnin", 96109, xp = 3150 }, -- A Hunter's Quiver (lvl 40, ~3150 xp, sim lvl 37)
    { "accept", 94532 }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 96105, xp = 3300 }, -- King of the Wild Plains (lvl 41, ~3300 xp, sim lvl 37)
    { "accept", 94535 }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 37)
    { "turnin", 95062, xp = 280 }, -- Frazzlespark's Crate (lvl 36, ~280 xp, sim lvl 37)
    { "accept", 93786 }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 37)
    { "turnin", 95141, xp = 285 }, -- Report to Rog'mar (lvl 38, ~285 xp, sim lvl 37)
    { "turnin", 94961, xp = 2350 }, -- Biting the Hand (lvl 40, ~2350 xp, sim lvl 37)
    { "accept", 94963 }, -- Biting the Hand (lvl 40, ~3150 xp, sim lvl 37)
    { "turnin", 94963, xp = 3150 }, -- Biting the Hand (lvl 40, ~3150 xp, sim lvl 37)
    { "complete", 94535, at = { 2548, 30.85, 58.95 } }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 37)
    { "complete", 94532, at = { 2548, 30.83, 59 } }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 38)
    { "complete", 93786, at = { 2548, 45.77, 81.27 } }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 38)
    { "turnin", 94532, xp = 2850 }, -- Gnoll Infestation (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 94535, xp = 2850 }, -- Bristle Hills Bandits (lvl 38, ~2850 xp, sim lvl 38)
    { "turnin", 93786, xp = 2800 }, -- A Message in Blood (lvl 36, ~2800 xp, sim lvl 38)
    { "level", 40, at = { 2548, 49.29, 47.69 }, note = "About 603 more mobs here (Twilight Raider, level 39)" }, -- farm de niveau
  },
})
