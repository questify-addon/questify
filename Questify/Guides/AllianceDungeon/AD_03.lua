local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 17 étapes, niveau final 19.66, ~4081 xp/h, 29 min.
Q:RegisterGuide({
  id = "AD_03",
  title = "Westfall",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 18, maxLevel = 20,
  next = "AD_04",
  sim = { steps = 17, endLevel = 19.66, xpPerHour = 4081, minutes = 29 },
  steps = {
    { "boat", 1439, 32.7, 41.8, note = "Take the boat to Stormwind Harbor" }, -- bateau
    { "fp", 1436, 56.55, 52.64 }, -- point de vol
    { "accept", 65 }, -- The Defias Brotherhood (lvl 18, ~0 xp, sim lvl 19)
    { "fp", 1453, 71.29, 72.23 }, -- point de vol
    { "turnin", 2041, xp = 270 }, -- Speak with Shoni (lvl 15, ~270 xp, sim lvl 19)
    { "goto", 1453, 71.29, 72.23, note = "Flight master" }, -- déplacement
    { "fly", 1436, node = 4, note = "Sentinel Hill, Westfall" }, -- vol
    { "accept", 104 }, -- The Coastal Menace (lvl 20, ~1550 xp, sim lvl 19)
    { "complete", 104, at = { 1436, 29.27, 75.95 } }, -- The Coastal Menace (lvl 20, ~1550 xp, sim lvl 19)
    { "turnin", 104, xp = 1550 }, -- The Coastal Menace (lvl 20, ~1550 xp, sim lvl 19)
    { "goto", 1436, 42.5, 71.7, optional = true, dungeon = "The Deadmines", note = "Dungeon: The Deadmines (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "DM" }, -- déplacement
    { "complete", 167, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Oh Brother. . . (lvl 20, ~775 xp, sim lvl 19)
    { "complete", 168, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Collecting Memories (lvl 18, ~675 xp, sim lvl 19)
    { "complete", 2040, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Underground Assault (lvl 20, ~775 xp, sim lvl 19)
    { "turnin", 167, xp = 775, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Oh Brother. . . (lvl 20, ~775 xp, sim lvl 19)
    { "turnin", 168, xp = 675, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Collecting Memories (lvl 18, ~675 xp, sim lvl 19)
    { "turnin", 2040, xp = 775, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Deadmines", phase = "run", rung = "DM" }, -- Underground Assault (lvl 20, ~775 xp, sim lvl 19)
  },
})
