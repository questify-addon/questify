local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 66 étapes, niveau final 56.66, ~44554 xp/h, 166 min.
Q:RegisterGuide({
  id = "AD_30",
  title = "Feralas and Azshara",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 55, maxLevel = 57,
  next = "AD_31",
  sim = { steps = 66, endLevel = 56.66, xpPerHour = 44554, minutes = 166 },
  steps = {
    { "fp", 1447, 11.9, 77.59 }, -- point de vol
    { "accept", 5535 }, -- Spiritual Unrest (lvl 47, ~840 xp, sim lvl 56)
    { "accept", 5536 }, -- A Land Filled with Hatred (lvl 47, ~840 xp, sim lvl 56)
    { "accept", 88812 }, -- Reclaiming Ravencrest (lvl 55, ~5650 xp, sim lvl 56)
    { "accept", 88809 }, -- Preserving Eldarath (lvl 52, ~5100 xp, sim lvl 56)
    { "accept", 88807 }, -- Slay the Spitelash (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 88813 }, -- The Head of the Serpent (lvl 55, ~5650 xp, sim lvl 56)
    { "accept", 88821 }, -- Making Contact (lvl 51, ~490 xp, sim lvl 56)
    { "turnin", 88812, xp = 5650 }, -- Reclaiming Ravencrest (lvl 55, ~5650 xp, sim lvl 56)
    { "accept", 89013 }, -- Gettin' Buzzed (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 89001 }, -- Home on the Range (lvl 48, ~1760 xp, sim lvl 56)
    { "complete", 89001, at = { 1447, 49.63, 80.88 } }, -- Home on the Range (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 89053 }, -- Your Final Reward (lvl 55, ~5650 xp, sim lvl 56)
    { "turnin", 88821, xp = 490 }, -- Making Contact (lvl 51, ~490 xp, sim lvl 56)
    { "accept", 3601 }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 56)
    { "complete", 3601, at = { 1447, 57.57, 28.05 } }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 56)
    { "turnin", 3601, xp = 6550 }, -- Kim'jael Indeed! (lvl 53, ~6550 xp, sim lvl 56)
    { "accept", 5534 }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 56)
    { "turnin", 89053, xp = 5650 }, -- Your Final Reward (lvl 55, ~5650 xp, sim lvl 56)
    { "accept", 89470 }, -- Ill Tidings (lvl 55, ~2800 xp, sim lvl 56)
    { "complete", 5534, at = { 1447, 47.31, 49.11 } }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 56)
    { "turnin", 5534, xp = 6550 }, -- Kim'jael's "Missing" Equipment (lvl 53, ~6550 xp, sim lvl 56)
    { "accept", 86746 }, -- The Legashi Threat (lvl 53, ~5250 xp, sim lvl 56)
    { "turnin", 86746, xp = 5250 }, -- The Legashi Threat (lvl 53, ~5250 xp, sim lvl 56)
    { "complete", 88809, at = { 1447, 40.56, 52.4 } }, -- Preserving Eldarath (lvl 52, ~5100 xp, sim lvl 56)
    { "complete", 88813, at = { 1447, 41.02, 53.05 } }, -- The Head of the Serpent (lvl 55, ~5650 xp, sim lvl 56)
    { "complete", 88807, at = { 1447, 33.79, 59.72 } }, -- Slay the Spitelash (lvl 48, ~1760 xp, sim lvl 56)
    { "complete", 89013, at = { 1447, 19.05, 51.97 } }, -- Gettin' Buzzed (lvl 48, ~1760 xp, sim lvl 56)
    { "complete", 5536, at = { 1447, 20.31, 61.77 } }, -- A Land Filled with Hatred (lvl 47, ~840 xp, sim lvl 56)
    { "accept", 88857 }, -- Saving a Sentinel (lvl 47, ~840 xp, sim lvl 56)
    { "complete", 5535, at = { 1447, 17.1, 69.7 } }, -- Spiritual Unrest (lvl 47, ~840 xp, sim lvl 56)
    { "turnin", 89001, xp = 1760 }, -- Home on the Range (lvl 48, ~1760 xp, sim lvl 56)
    { "turnin", 89013, xp = 1760 }, -- Gettin' Buzzed (lvl 48, ~1760 xp, sim lvl 56)
    { "turnin", 88807, xp = 1760 }, -- Slay the Spitelash (lvl 48, ~1760 xp, sim lvl 56)
    { "turnin", 88809, xp = 5100 }, -- Preserving Eldarath (lvl 52, ~5100 xp, sim lvl 56)
    { "turnin", 89470, xp = 2800 }, -- Ill Tidings (lvl 55, ~2800 xp, sim lvl 56)
    { "turnin", 88857, xp = 840 }, -- Saving a Sentinel (lvl 47, ~840 xp, sim lvl 56)
    { "turnin", 88813, xp = 5650 }, -- The Head of the Serpent (lvl 55, ~5650 xp, sim lvl 56)
    { "turnin", 5536, xp = 840 }, -- A Land Filled with Hatred (lvl 47, ~840 xp, sim lvl 56)
    { "turnin", 5535, xp = 840 }, -- Spiritual Unrest (lvl 47, ~840 xp, sim lvl 56)
    { "hearth", 1445 }, -- pierre de foyer
    { "goto", 1445, 67.48, 51.3, note = "Flight master" }, -- déplacement
    { "fly", 1444, node = 31, note = "Thalanaar, Feralas" }, -- vol
    { "accept", 7441, optional = true, dungeon = "Dire Maul", phase = "prep", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~0 xp, sim lvl 56)
    { "accept", 7003 }, -- Zapped Giants (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 7721 }, -- Fuel for the Zapping (lvl 48, ~1760 xp, sim lvl 56)
    { "complete", 7721, at = { 1444, 48.3, 52.09 } }, -- Fuel for the Zapping (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 81924, classes = { "DRUID" } }, -- Wisdom of the Guardians (lvl 50, ~4720 xp, sim lvl 56)
    { "turnin", 81924, xp = 4720, classes = { "DRUID" } }, -- Wisdom of the Guardians (lvl 50, ~4720 xp, sim lvl 56)
    { "accept", 7488, optional = true, dungeon = "Dire Maul", phase = "prep", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~0 xp, sim lvl 56)
    { "complete", 7003, at = { 1444, 38.68, 22.35 } }, -- Zapped Giants (lvl 48, ~1760 xp, sim lvl 56)
    { "accept", 2844 }, -- The Giant Guardian (lvl 49, ~2040 xp, sim lvl 56)
    { "turnin", 2844, xp = 2040 }, -- The Giant Guardian (lvl 49, ~2040 xp, sim lvl 56)
    { "accept", 2845 }, -- Wandering Shay (lvl 49, ~2730 xp, sim lvl 56)
    { "complete", 2845, obj = 1, at = { 1444, 38.25, 10.29 } }, -- Wandering Shay (lvl 49, ~2730 xp, sim lvl 56)
    { "complete", 2845, at = { 1444, 42.33, 21.85 } }, -- Wandering Shay (lvl 49, ~2730 xp, sim lvl 56)
    { "turnin", 2845, xp = 2730 }, -- Wandering Shay (lvl 49, ~2730 xp, sim lvl 56)
    { "turnin", 7003, xp = 1760 }, -- Zapped Giants (lvl 48, ~1760 xp, sim lvl 56)
    { "turnin", 7721, xp = 1760 }, -- Fuel for the Zapping (lvl 48, ~1760 xp, sim lvl 56)
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: East (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_EAST" }, -- déplacement
    { "complete", 7441, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~3875 xp, sim lvl 56)
    { "complete", 7488, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~3775 xp, sim lvl 56)
    { "turnin", 7441, at = { 1444, 76.91, 37.35 }, xp = 3875, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Pusillin and the Elder Azj'Tordin (lvl 58, ~3875 xp, sim lvl 56)
    { "turnin", 7488, at = { 1444, 30.38, 46.17 }, xp = 3775, optional = true, dungeon = "Dire Maul", phase = "run", rung = "DM_EAST" }, -- Lethtendris's Web (lvl 57, ~3775 xp, sim lvl 56)
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: West (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_WEST" }, -- déplacement
    { "goto", 1444, 59.2, 45.1, optional = true, dungeon = "Dire Maul", note = "Dungeon: Dire Maul: North (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "DM_NORTH" }, -- déplacement
  },
})
