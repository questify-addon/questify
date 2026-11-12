local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 33 étapes, niveau final 30.00, ~37090 xp/h, 72 min.
Q:RegisterGuide({
  id = "A_05",
  title = "Hillsbrad Foothills",
  faction = "Alliance",
  minLevel = 29, maxLevel = 30,
  next = "A_08",
  sim = { steps = 33, endLevel = 30.00, xpPerHour = 37090, minutes = 72 },
  steps = {
    { "hearth", 1437 }, -- pierre de foyer
    { "boat", 1437, 4.9, 57.3, note = "Take the boat to Southshore" }, -- bateau
    { "fp", 1424, 49.34, 52.27 }, -- point de vol
    { "accept", 98059 }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 29)
    { "accept", 536 }, -- Down the Coast (lvl 30, ~1850 xp, sim lvl 29)
    { "accept", 555 }, -- Soothing Turtle Bisque (lvl 31, ~2500 xp, sim lvl 29)
    { "complete", 536, at = { 1424, 43.8, 67.72 } }, -- Down the Coast (lvl 30, ~1850 xp, sim lvl 29)
    { "turnin", 536, xp = 1850 }, -- Down the Coast (lvl 30, ~1850 xp, sim lvl 29)
    { "accept", 559 }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 29)
    { "accept", 92458, optional = true, dungeon = "City of Dalaran" }, -- Heart of Disruption (lvl 33, ~0 xp, sim lvl 29)
    { "accept", 92457, optional = true, dungeon = "City of Dalaran" }, -- Starving Arcane (lvl 33, ~0 xp, sim lvl 29)
    { "complete", 559, at = { 1424, 32.19, 72.78 } }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 29)
    { "complete", 98059, at = { 1424, 29.7, 41.6 } }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 29)
    { "turnin", 98059, xp = 2200 }, -- Hillsbrad's Hoard (lvl 27, ~2200 xp, sim lvl 29)
    { "complete", 555, obj = 2, at = { 1424, 48.94, 55.03 } }, -- Soothing Turtle Bisque (lvl 31, ~2500 xp, sim lvl 29)
    { "turnin", 559, xp = 2550 }, -- Farren's Proof (lvl 32, ~2550 xp, sim lvl 29)
    { "accept", 560 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 29)
    { "accept", 98071 }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 29)
    { "turnin", 560, xp = 255 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 29)
    { "accept", 561 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 29)
    { "turnin", 561, xp = 255 }, -- Farren's Proof (lvl 32, ~255 xp, sim lvl 29)
    { "accept", 562 }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 29)
    { "complete", 562, at = { 1424, 58.14, 71.42 } }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 29)
    { "complete", 98071, at = { 1424, 70, 79 } }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 29)
    { "turnin", 79975, xp = 2550, race = { "Dwarf", "Gnome" } }, -- Eagle's Fist (lvl 32, ~2550 xp, sim lvl 29)
    { "accept", 79976, race = { "Dwarf", "Gnome" } }, -- This Must Be The Place (lvl 32, ~1950 xp, sim lvl 29)
    { "turnin", 79976, xp = 1950, race = { "Dwarf", "Gnome" } }, -- This Must Be The Place (lvl 32, ~1950 xp, sim lvl 29)
    { "complete", 555, at = { 1424, 56.08, 53.87 } }, -- Soothing Turtle Bisque (lvl 31, ~2500 xp, sim lvl 29)
    { "turnin", 98071, xp = 2200 }, -- Brewer's Trade (lvl 27, ~2200 xp, sim lvl 29)
    { "turnin", 555, xp = 2500 }, -- Soothing Turtle Bisque (lvl 31, ~2500 xp, sim lvl 29)
    { "turnin", 562, xp = 1950 }, -- Stormwind Ho! (lvl 32, ~1950 xp, sim lvl 29)
    { "accept", 563 }, -- Reassignment (lvl 32, ~0 xp, sim lvl 29)
    { "level", 30, at = { 1424, 59.96, 74.99 }, note = "About 10 more mobs here (Daggerspine Shorehunter, level 30)" }, -- farm de niveau
  },
})
