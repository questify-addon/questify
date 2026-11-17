local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 24 étapes, niveau final 21.27, ~25761 xp/h, 15 min.
Q:RegisterGuide({
  id = "HD_05",
  title = "Undercity",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 20, maxLevel = 22,
  next = "HD_06",
  sim = { steps = 24, endLevel = 21.27, xpPerHour = 25761, minutes = 15 },
  steps = {
    { "hearth", 1413, phase = "prep", rung = "LORDAERON" }, -- pierre de foyer
    { "goto", 1413, 51.5, 30.34, note = "Flight master", phase = "prep", rung = "LORDAERON" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar", phase = "prep", rung = "LORDAERON" }, -- vol
    { "boat", 1411, 50.8, 13.5, note = "Take the zeppelin to Undercity (Tirisfal Glades)", phase = "prep", rung = "LORDAERON" }, -- bateau
    { "fp", 1458, 63.25, 48.56, phase = "prep", rung = "LORDAERON" }, -- point de vol
    { "turnin", 78143, xp = 1550, phase = "prep", rung = "LORDAERON" }, -- Secrets of the Dreamers (lvl 20, ~1550 xp, sim lvl 21)
    { "accept", 97286, classes = { "MAGE" }, phase = "prep", rung = "LORDAERON" }, -- Research Access (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 97286, xp = 390, classes = { "MAGE" }, phase = "prep", rung = "LORDAERON" }, -- Research Access (lvl 20, ~390 xp, sim lvl 21)
    { "accept", 78150, phase = "prep", rung = "LORDAERON" }, -- Friend of the Library (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 78145, xp = 1550, race = { "Orc", "Troll", "Undead", "Skyborne" }, phase = "prep", rung = "LORDAERON" }, -- Arcanic Systems Manual (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 78149, xp = 1550, phase = "prep", rung = "LORDAERON" }, -- Fury of the Land (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 79097, xp = 1550, phase = "prep", rung = "LORDAERON" }, -- Baxtan: On Destructive Magics (lvl 20, ~1550 xp, sim lvl 21)
    { "turnin", 78150, xp = 390, phase = "prep", rung = "LORDAERON" }, -- Friend of the Library (lvl 20, ~390 xp, sim lvl 21)
    { "accept", 92421, optional = true, dungeon = "Ruins of Lordaeron", phase = "prep", rung = "LORDAERON" }, -- Light's Justice (lvl 22, ~0 xp, sim lvl 21)
    { "accept", 1013, optional = true, dungeon = "Shadowfang Keep", phase = "prep", rung = "SFK" }, -- The Book of Ur (lvl 26, ~0 xp, sim lvl 21)
    { "accept", 5679, race = { "Undead" }, classes = { "PRIEST" }, phase = "prep", rung = "LORDAERON" }, -- Dark Sacrifice (lvl 20, ~390 xp, sim lvl 21)
    { "turnin", 5679, xp = 390, race = { "Undead" }, classes = { "PRIEST" }, phase = "prep", rung = "LORDAERON" }, -- Dark Sacrifice (lvl 20, ~390 xp, sim lvl 21)
    { "goto", 1458, 72.41, 11.37, optional = true, dungeon = "Ruins of Lordaeron", note = "Dungeon: Ruins of Lordaeron (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "LORDAERON" }, -- déplacement
    { "complete", 92421, optional = true, dungeon = "Ruins of Lordaeron", phase = "run", rung = "LORDAERON" }, -- Light's Justice (lvl 22, ~875 xp, sim lvl 21)
    { "turnin", 92421, at = { 1458, 58.08, 89.51 }, xp = 875, optional = true, dungeon = "Ruins of Lordaeron", phase = "run", rung = "LORDAERON" }, -- Light's Justice (lvl 22, ~875 xp, sim lvl 21)
    { "accept", 95204, optional = true, dungeon = "Ruins of Lordaeron", note = "Starts inside the dungeon", phase = "run", rung = "LORDAERON" }, -- Crest of Lordaeron (lvl 22, ~325 xp, sim lvl 21)
    { "accept", 97288, optional = true, dungeon = "Ruins of Lordaeron", note = "Starts inside the dungeon", phase = "run", rung = "LORDAERON" }, -- Unending Torment (lvl 21, ~415 xp, sim lvl 21)
    { "turnin", 95204, at = { 1458, 73.06, 32.85 }, xp = 325, optional = true, dungeon = "Ruins of Lordaeron", phase = "run", rung = "LORDAERON" }, -- Crest of Lordaeron (lvl 22, ~325 xp, sim lvl 21)
    { "turnin", 97288, at = { 1458, 48.82, 69.28 }, xp = 415, optional = true, dungeon = "Ruins of Lordaeron", phase = "run", rung = "LORDAERON" }, -- Unending Torment (lvl 21, ~415 xp, sim lvl 21)
  },
})
