local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 11 étapes, niveau final 15.00, ~0 xp/h, 7 min.
Q:RegisterGuide({
  id = "AD_01",
  title = "Ironforge",
  faction = "Alliance",
  mode = "dungeon",
  after = { "A_Human_03", "A_DwarfGnome_04", "A_Skyborne_01" },
  minLevel = 15, maxLevel = 16,
  next = "AD_02",
  sim = { steps = 11, endLevel = 15.00, xpPerHour = 0, minutes = 7 },
  steps = {
    { "boat", 1453, 69.6, 30.3, note = "Take the Deeprun Tram to Ironforge", phase = "prep", rung = "THANES" }, -- bateau
    { "fp", 1455, 55.5, 47.74, phase = "prep", rung = "THANES" }, -- point de vol
    { "turnin", 968, xp = 1700, race = { "NightElf" }, phase = "prep", rung = "THANES" }, -- The Powers Below (lvl 18, ~1700 xp, sim lvl 15)
    { "accept", 2041, phase = "prep", rung = "THANES" }, -- Speak with Shoni (lvl 15, ~0 xp, sim lvl 15)
    { "goto", 1455, 27.63, 47.83, optional = true, dungeon = "The Hall of Thanes", note = "Dungeon: The Hall of Thanes (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "THANES" }, -- déplacement
    { "complete", 96393, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- Old Ironforge Incursion (lvl 16, ~575 xp, sim lvl 15)
    { "complete", 96394, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- The Restless Dead (lvl 15, ~525 xp, sim lvl 15)
    { "complete", 96403, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- Important Heirlooms (lvl 15, ~525 xp, sim lvl 15)
    { "turnin", 96393, xp = 575, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- Old Ironforge Incursion (lvl 16, ~575 xp, sim lvl 15)
    { "turnin", 96394, xp = 525, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- The Restless Dead (lvl 15, ~525 xp, sim lvl 15)
    { "turnin", 96403, xp = 525, race = { "Dwarf", "Gnome" }, optional = true, dungeon = "The Hall of Thanes", phase = "run", rung = "THANES" }, -- Important Heirlooms (lvl 15, ~525 xp, sim lvl 15)
  },
})
