local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 22 étapes, niveau final 31.00, ~0 xp/h, 21 min.
Q:RegisterGuide({
  id = "AD_11",
  title = "Dun Morogh",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 30, maxLevel = 32,
  next = "AD_12",
  sim = { steps = 22, endLevel = 31.00, xpPerHour = 0, minutes = 21 },
  steps = {
    { "note", "Not running Blackfathom Deeps? Abandon Knowledge in the Deeps", optional = true, dungeon = "Blackfathom Deeps", phase = "prep", rung = "GNOMER" },
    { "note", "Not running Gnomeregan? Abandon Save Techbot's Brain!, Tinkmaster Overspark", optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" },
    { "note", "Not running Razorfen Kraul? Abandon Blueleaf Tubers", optional = true, dungeon = "Razorfen Kraul", phase = "prep", rung = "GNOMER" },
    { "goto", 1431, 77.49, 44.29, note = "Flight master", phase = "prep", rung = "GNOMER" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh", phase = "prep", rung = "GNOMER" }, -- vol
    { "accept", 2926, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Gnogaine (lvl 27, ~0 xp, sim lvl 31)
    { "accept", 1179, phase = "prep", rung = "GNOMER" }, -- The Brassbolts Brothers (lvl 30, ~0 xp, sim lvl 31)
    { "accept", 1050, optional = true, dungeon = "Scarlet Monastery", phase = "prep", rung = "SM_LIB" }, -- Mythology of the Titans (lvl 38, ~0 xp, sim lvl 31)
    { "goto", 1426, 24.3, 39.8, optional = true, dungeon = "Gnomeregan", note = "Dungeon: Gnomeregan (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "GNOMER" }, -- déplacement
    { "complete", 2924, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Essential Artificials (lvl 30, ~1525 xp, sim lvl 31)
    { "complete", 2926, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Gnogaine (lvl 27, ~1100 xp, sim lvl 31)
    { "complete", 2928, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Gyrodrillmatic Excavationators (lvl 30, ~1225 xp, sim lvl 31)
    { "complete", 2929, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- The Grand Betrayal (lvl 35, ~1375 xp, sim lvl 31)
    { "complete", 2930, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Data Rescue (lvl 30, ~1825 xp, sim lvl 31)
    { "turnin", 2926, xp = 1100, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Gnogaine (lvl 27, ~1100 xp, sim lvl 31)
    { "turnin", 2927, xp = 110, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- The Day After (lvl 27, ~110 xp, sim lvl 31)
    { "turnin", 2924, xp = 1525, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Essential Artificials (lvl 30, ~1525 xp, sim lvl 31)
    { "turnin", 2929, xp = 1375, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- The Grand Betrayal (lvl 35, ~1375 xp, sim lvl 31)
    { "turnin", 2930, xp = 1825, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Data Rescue (lvl 30, ~1825 xp, sim lvl 31)
    { "accept", 2904, optional = true, dungeon = "Gnomeregan", note = "Starts inside the dungeon", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 31)
    { "complete", 2904, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 31)
    { "turnin", 2904, xp = 1225, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 31)
  },
})
