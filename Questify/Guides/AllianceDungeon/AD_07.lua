local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 57 étapes, niveau final 27.00, ~14445 xp/h, 110 min.
Q:RegisterGuide({
  id = "AD_07",
  title = "Ashenvale",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 25, maxLevel = 27,
  next = "AD_08",
  sim = { steps = 57, endLevel = 27.00, xpPerHour = 14445, minutes = 110 },
  steps = {
    { "boat", 1453, 24.1, 55.4, note = "Take the boat to Auberdine (Stormwind Harbor)" }, -- bateau
    { "goto", 1439, 36.34, 45.58, note = "Flight master" }, -- déplacement
    { "fly", 1440, node = 28, note = "Astranaar, Ashenvale" }, -- vol
    { "accept", 970 }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 26)
    { "complete", 970, at = { 1440, 31.4, 30.64 } }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 26)
    { "turnin", 970, xp = 1650 }, -- The Tower of Althalaxx (lvl 21, ~1650 xp, sim lvl 26)
    { "accept", 973 }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 26)
    { "accept", 1023 }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 26)
    { "complete", 1023, at = { 1440, 20.54, 42.9 } }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 26)
    { "complete", 973, at = { 1440, 25.28, 60.69 } }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 26)
    { "turnin", 973, xp = 1950 }, -- The Tower of Althalaxx (lvl 24, ~1950 xp, sim lvl 26)
    { "accept", 1140 }, -- The Tower of Althalaxx (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 4581 }, -- Kayneth Stillwind (lvl 29, ~590 xp, sim lvl 26)
    { "accept", 95737, optional = true, dungeon = "Excavation Site: Wetlands", phase = "prep", rung = "EXCAVATION" }, -- Seeking Caitlin (lvl 31, ~0 xp, sim lvl 26)
    { "turnin", 1023, xp = 1250 }, -- Raene's Cleansing (lvl 21, ~1250 xp, sim lvl 26)
    { "accept", 1054 }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 26)
    { "accept", 1024 }, -- Raene's Cleansing (lvl 21, ~830 xp, sim lvl 26)
    { "complete", 1054, at = { 1440, 39.61, 36.31 } }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 26)
    { "turnin", 1024, xp = 830 }, -- Raene's Cleansing (lvl 21, ~830 xp, sim lvl 26)
    { "accept", 1026 }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 26)
    { "complete", 1026, at = { 1440, 54.42, 35.4 } }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 26)
    { "turnin", 1026, xp = 2200 }, -- Raene's Cleansing (lvl 27, ~2200 xp, sim lvl 26)
    { "accept", 1027 }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 98027 }, -- Gleaming Crescent Necklace (lvl 26, ~1600 xp, sim lvl 26)
    { "complete", 1027, at = { 1440, 75.72, 69.27 } }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 78093, race = { "Human", "Dwarf" }, classes = { "PALADIN" } }, -- Return to Delgren (lvl 30, ~1200 xp, sim lvl 26)
    { "accept", 98417 }, -- Vengeful Trail (lvl 28, ~1700 xp, sim lvl 26)
    { "complete", 98417, at = { 1440, 81.17, 49.78 } }, -- Vengeful Trail (lvl 28, ~1700 xp, sim lvl 26)
    { "complete", 1140, obj = 2, at = { 1440, 81.6, 48.57 } }, -- The Tower of Althalaxx (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 98417, xp = 1700 }, -- Vengeful Trail (lvl 28, ~1700 xp, sim lvl 26)
    { "turnin", 4581, xp = 590 }, -- Kayneth Stillwind (lvl 29, ~590 xp, sim lvl 26)
    { "complete", 1140, at = { 1440, 66.62, 57 } }, -- The Tower of Althalaxx (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 1027, xp = 2300 }, -- Raene's Cleansing (lvl 28, ~2300 xp, sim lvl 26)
    { "accept", 1028 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 26)
    { "turnin", 1028, xp = 1700 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 26)
    { "accept", 1055 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 26)
    { "turnin", 1055, xp = 230 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 26)
    { "accept", 1029 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 26)
    { "turnin", 1054, xp = 2000 }, -- Culling the Threat (lvl 25, ~2000 xp, sim lvl 26)
    { "turnin", 1029, xp = 230 }, -- Raene's Cleansing (lvl 28, ~230 xp, sim lvl 26)
    { "accept", 1030 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 26)
    { "turnin", 98027, xp = 1600 }, -- Gleaming Crescent Necklace (lvl 26, ~1600 xp, sim lvl 26)
    { "turnin", 1030, xp = 1700 }, -- Raene's Cleansing (lvl 28, ~1700 xp, sim lvl 26)
    { "turnin", 1140, xp = 2300 }, -- The Tower of Althalaxx (lvl 28, ~2300 xp, sim lvl 26)
    { "turnin", 78093, xp = 1200, race = { "Human", "Dwarf" }, classes = { "PALADIN" } }, -- Return to Delgren (lvl 30, ~1200 xp, sim lvl 26)
    { "accept", 1007 }, -- The Ancient Statuette (lvl 20, ~920 xp, sim lvl 26)
    { "complete", 1007, at = { 1440, 14.2, 20.64 } }, -- The Ancient Statuette (lvl 20, ~920 xp, sim lvl 26)
    { "turnin", 1007, xp = 920 }, -- The Ancient Statuette (lvl 20, ~920 xp, sim lvl 26)
    { "accept", 1009 }, -- Ruuzel (lvl 25, ~2550 xp, sim lvl 26)
    { "complete", 1009, at = { 1440, 7.22, 13.06 } }, -- Ruuzel (lvl 25, ~2550 xp, sim lvl 26)
    { "turnin", 1009, xp = 2550 }, -- Ruuzel (lvl 25, ~2550 xp, sim lvl 26)
    { "goto", 1440, 14.5, 14.2, optional = true, dungeon = "Blackfathom Deeps", note = "Dungeon: Blackfathom Deeps (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "BFD" }, -- déplacement
    { "complete", 1275, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Researching the Corruption (lvl 24, ~1200 xp, sim lvl 27)
    { "turnin", 1275, xp = 1200, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Researching the Corruption (lvl 24, ~1200 xp, sim lvl 27)
    { "accept", 1200, optional = true, dungeon = "Blackfathom Deeps", note = "Starts inside the dungeon", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 27)
    { "complete", 1200, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 27)
    { "turnin", 1200, xp = 825, optional = true, dungeon = "Blackfathom Deeps", phase = "run", rung = "BFD" }, -- Blackfathom Villainy (lvl 27, ~825 xp, sim lvl 27)
  },
})
