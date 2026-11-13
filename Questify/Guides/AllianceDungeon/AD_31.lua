local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 54 étapes, niveau final 58.00, ~62533 xp/h, 187 min.
Q:RegisterGuide({
  id = "AD_31",
  title = "Western Plaguelands",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 56, maxLevel = 58,
  next = "AD_32",
  sim = { steps = 54, endLevel = 58.00, xpPerHour = 62533, minutes = 187 },
  steps = {
    { "hearth", 1434 }, -- pierre de foyer
    { "goto", 1434, 27.53, 77.79, note = "Flight master" }, -- déplacement
    { "fly", 1425, node = 43, note = "Aerie Peak, The Hinterlands" }, -- vol
    { "fp", 1422, 42.92, 85.06 }, -- point de vol
    { "accept", 5092 }, -- Clear the Way (lvl 52, ~5100 xp, sim lvl 57)
    { "accept", 5401 }, -- Argent Dawn Commission (lvl 55, ~560 xp, sim lvl 57)
    { "turnin", 5401, xp = 560 }, -- Argent Dawn Commission (lvl 55, ~560 xp, sim lvl 57)
    { "accept", 5343, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Barov Family Fortune (lvl 60, ~0 xp, sim lvl 57)
    { "complete", 5092, at = { 1422, 37.47, 56.15 } }, -- Clear the Way (lvl 52, ~5100 xp, sim lvl 57)
    { "accept", 4971 }, -- A Matter of Time (lvl 56, ~5800 xp, sim lvl 57)
    { "turnin", 5092, xp = 5100 }, -- Clear the Way (lvl 52, ~5100 xp, sim lvl 57)
    { "accept", 5215 }, -- The Scourge Cauldrons (lvl 53, ~530 xp, sim lvl 57)
    { "turnin", 5215, xp = 530 }, -- The Scourge Cauldrons (lvl 53, ~530 xp, sim lvl 57)
    { "accept", 5216 }, -- Target: Felstone Field (lvl 53, ~5250 xp, sim lvl 57)
    { "complete", 4971, at = { 1422, 48.03, 64.46 } }, -- A Matter of Time (lvl 56, ~5800 xp, sim lvl 57)
    { "accept", 4984 }, -- The Wildlife Suffers Too (lvl 54, ~4100 xp, sim lvl 57)
    { "accept", 6004 }, -- Unfinished Business (lvl 56, ~5800 xp, sim lvl 57)
    { "complete", 4984, at = { 1422, 46.24, 45.57 } }, -- The Wildlife Suffers Too (lvl 54, ~4100 xp, sim lvl 57)
    { "complete", 6004, at = { 1422, 40.66, 51.85 } }, -- Unfinished Business (lvl 56, ~5800 xp, sim lvl 57)
    { "accept", 5021 }, -- Better Late Than Never (lvl 52, ~2550 xp, sim lvl 57)
    { "turnin", 5021, xp = 2550 }, -- Better Late Than Never (lvl 52, ~2550 xp, sim lvl 57)
    { "complete", 5216, at = { 1422, 36.93, 57.41 } }, -- Target: Felstone Field (lvl 53, ~5250 xp, sim lvl 57)
    { "turnin", 5216, xp = 5250 }, -- Target: Felstone Field (lvl 53, ~5250 xp, sim lvl 57)
    { "accept", 5217 }, -- Return to Chillwind Camp (lvl 53, ~2650 xp, sim lvl 57)
    { "turnin", 4971, xp = 5800 }, -- A Matter of Time (lvl 56, ~5800 xp, sim lvl 57)
    { "turnin", 5217, xp = 2650 }, -- Return to Chillwind Camp (lvl 53, ~2650 xp, sim lvl 57)
    { "accept", 5219 }, -- Target: Dalson's Tears (lvl 55, ~5650 xp, sim lvl 57)
    { "turnin", 4984, xp = 4100 }, -- The Wildlife Suffers Too (lvl 54, ~4100 xp, sim lvl 57)
    { "accept", 4985 }, -- The Wildlife Suffers Too (lvl 56, ~4350 xp, sim lvl 57)
    { "complete", 5219, at = { 1422, 46.11, 52.61 } }, -- Target: Dalson's Tears (lvl 55, ~5650 xp, sim lvl 57)
    { "turnin", 5219, xp = 5650 }, -- Target: Dalson's Tears (lvl 55, ~5650 xp, sim lvl 57)
    { "accept", 5220 }, -- Return to Chillwind Camp (lvl 55, ~2800 xp, sim lvl 57)
    { "accept", 5058 }, -- Mrs. Dalson's Diary (lvl 55, ~1400 xp, sim lvl 57)
    { "turnin", 5058, xp = 1400 }, -- Mrs. Dalson's Diary (lvl 55, ~1400 xp, sim lvl 57)
    { "accept", 5060 }, -- Locked Away (lvl 55, ~7050 xp, sim lvl 57)
    { "complete", 5060, at = { 1422, 48.23, 49.67 } }, -- Locked Away (lvl 55, ~7050 xp, sim lvl 57)
    { "turnin", 5060, xp = 7050 }, -- Locked Away (lvl 55, ~7050 xp, sim lvl 57)
    { "complete", 6004, at = { 1422, 51.17, 40.34 } }, -- Unfinished Business (lvl 56, ~5800 xp, sim lvl 57)
    { "turnin", 6004, xp = 5800 }, -- Unfinished Business (lvl 56, ~5800 xp, sim lvl 57)
    { "accept", 6023 }, -- Unfinished Business (lvl 57, ~6000 xp, sim lvl 57)
    { "complete", 6023, obj = 2, at = { 1422, 55.15, 23.62 } }, -- Unfinished Business (lvl 57, ~6000 xp, sim lvl 57)
    { "complete", 6023, at = { 1422, 57.83, 36.1 } }, -- Unfinished Business (lvl 57, ~6000 xp, sim lvl 57)
    { "turnin", 6023, xp = 6000 }, -- Unfinished Business (lvl 57, ~6000 xp, sim lvl 57)
    { "complete", 4985, at = { 1422, 64.84, 47.98 } }, -- The Wildlife Suffers Too (lvl 56, ~4350 xp, sim lvl 57)
    { "turnin", 4985, xp = 4350 }, -- The Wildlife Suffers Too (lvl 56, ~4350 xp, sim lvl 57)
    { "turnin", 5220, xp = 2800 }, -- Return to Chillwind Camp (lvl 55, ~2800 xp, sim lvl 57)
    { "accept", 5142 }, -- Little Pamela (lvl 55, ~0 xp, sim lvl 57)
    { "accept", 5382, optional = true, dungeon = "Scholomance", phase = "prep", rung = "SCHOLO" }, -- Doctor Theolen Krastinov, the Butcher (lvl 60, ~0 xp, sim lvl 57)
    { "level", 58, at = { 1422, 63.62, 58.32 }, note = "About 366 more mobs here (Hungering Wraith, level 57)" }, -- farm de niveau
    { "goto", 1422, 69.7, 73.2, optional = true, dungeon = "Scholomance", note = "Dungeon: Scholomance (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "SCHOLO" }, -- déplacement
    { "complete", 5343, optional = true, dungeon = "Scholomance", phase = "run", rung = "SCHOLO" }, -- Barov Family Fortune (lvl 60, ~3300 xp, sim lvl 58)
    { "complete", 5382, optional = true, dungeon = "Scholomance", phase = "run", rung = "SCHOLO" }, -- Doctor Theolen Krastinov, the Butcher (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5343, xp = 3300, optional = true, dungeon = "Scholomance", phase = "run", rung = "SCHOLO" }, -- Barov Family Fortune (lvl 60, ~3300 xp, sim lvl 58)
    { "turnin", 5382, xp = 3300, optional = true, dungeon = "Scholomance", phase = "run", rung = "SCHOLO" }, -- Doctor Theolen Krastinov, the Butcher (lvl 60, ~3300 xp, sim lvl 58)
  },
})
