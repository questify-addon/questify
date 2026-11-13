local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 92 étapes, niveau final 26.28, ~29228 xp/h, 155 min.
Q:RegisterGuide({
  id = "AD_06",
  title = "Duskwood",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 24, maxLevel = 26,
  next = "AD_07",
  sim = { steps = 92, endLevel = 26.28, xpPerHour = 29228, minutes = 155 },
  steps = {
    { "goto", 1433, 25.5, 59.41, note = "Flight master" }, -- déplacement
    { "fly", 1431, node = 12, note = "Darkshire, Duskwood" }, -- vol
    { "accept", 164 }, -- Deliveries to Sven (lvl 23, ~920 xp, sim lvl 24)
    { "accept", 165 }, -- The Hermit (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 56 }, -- The Night Watch (lvl 24, ~1450 xp, sim lvl 24)
    { "sethearth", 1431, 73.87, 44.41 }, -- lier la pierre de foyer
    { "accept", 96139 }, -- The Valor Family (lvl 23, ~1400 xp, sim lvl 24)
    { "accept", 377, optional = true, dungeon = "The Stockade", phase = "prep", rung = "STOCKADE" }, -- Crime and Punishment (lvl 26, ~0 xp, sim lvl 24)
    { "turnin", 165, xp = 1000 }, -- The Hermit (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 148 }, -- Supplies from Darkshire (lvl 24, ~485 xp, sim lvl 24)
    { "turnin", 164, xp = 920 }, -- Deliveries to Sven (lvl 23, ~920 xp, sim lvl 24)
    { "accept", 95 }, -- Sven's Revenge (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 226 }, -- Wolves at Our Heels (lvl 21, ~1250 xp, sim lvl 24)
    { "complete", 226, obj = 2, at = { 1431, 20.5, 27.4 } }, -- Wolves at Our Heels (lvl 21, ~1250 xp, sim lvl 24)
    { "complete", 226, at = { 1431, 34.02, 23.77 } }, -- Wolves at Our Heels (lvl 21, ~1250 xp, sim lvl 24)
    { "hearth", 1431 }, -- pierre de foyer
    { "accept", 101 }, -- The Totem of Infliction (lvl 25, ~2550 xp, sim lvl 24)
    { "accept", 66 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 24)
    { "turnin", 148, xp = 485 }, -- Supplies from Darkshire (lvl 24, ~485 xp, sim lvl 24)
    { "accept", 149 }, -- Ghost Hair Thread (lvl 24, ~485 xp, sim lvl 24)
    { "complete", 101, obj = 3, at = { 1431, 78.36, 70.5 } }, -- The Totem of Infliction (lvl 25, ~2550 xp, sim lvl 24)
    { "complete", 56, at = { 1431, 78.99, 70.97 } }, -- The Night Watch (lvl 24, ~1450 xp, sim lvl 24)
    { "turnin", 149, xp = 485 }, -- Ghost Hair Thread (lvl 24, ~485 xp, sim lvl 24)
    { "accept", 154 }, -- Return the Comb (lvl 24, ~195 xp, sim lvl 24)
    { "turnin", 154, xp = 195 }, -- Return the Comb (lvl 24, ~195 xp, sim lvl 24)
    { "accept", 157 }, -- Deliver the Thread (lvl 24, ~1450 xp, sim lvl 24)
    { "turnin", 56, xp = 1450 }, -- The Night Watch (lvl 24, ~1450 xp, sim lvl 24)
    { "accept", 57 }, -- The Night Watch (lvl 26, ~2100 xp, sim lvl 24)
    { "turnin", 66, xp = 230 }, -- The Legend of Stalvan (lvl 28, ~230 xp, sim lvl 24)
    { "accept", 96137, at = { 1431, 54.57, 62.04 }, note = "Loot Ira's Dagger to start the quest" }, -- Ira's Dagger (lvl 25, ~2000 xp, sim lvl 24)
    { "complete", 96137, obj = 1, at = { 1431, 54.53, 64.18 } }, -- Ira's Dagger (lvl 25, ~2000 xp, sim lvl 24)
    { "turnin", 95, xp = 1000 }, -- Sven's Revenge (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 230 }, -- Sven's Camp (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 245 }, -- Eight-Legged Menaces (lvl 21, ~1250 xp, sim lvl 24)
    { "complete", 96139, at = { 1431, 21.1, 55.6 } }, -- The Valor Family (lvl 23, ~1400 xp, sim lvl 24)
    { "complete", 245, at = { 1431, 10.42, 58.3 } }, -- Eight-Legged Menaces (lvl 21, ~1250 xp, sim lvl 24)
    { "turnin", 230, xp = 1000 }, -- Sven's Camp (lvl 25, ~1000 xp, sim lvl 24)
    { "accept", 262 }, -- The Shadowy Figure (lvl 25, ~510 xp, sim lvl 24)
    { "turnin", 226, xp = 1250 }, -- Wolves at Our Heels (lvl 21, ~1250 xp, sim lvl 24)
    { "complete", 101, obj = 1, at = { 1431, 24.06, 35.68 } }, -- The Totem of Infliction (lvl 25, ~2550 xp, sim lvl 24)
    { "turnin", 157, xp = 1450 }, -- Deliver the Thread (lvl 24, ~1450 xp, sim lvl 24)
    { "accept", 158 }, -- Zombie Juice (lvl 24, ~485 xp, sim lvl 24)
    { "complete", 96137, at = { 1431, 68.56, 33.5 } }, -- Ira's Dagger (lvl 25, ~2000 xp, sim lvl 24)
    { "turnin", 158, xp = 485 }, -- Zombie Juice (lvl 24, ~485 xp, sim lvl 24)
    { "accept", 156 }, -- Gather Rot Blossoms (lvl 24, ~970 xp, sim lvl 24)
    { "turnin", 262, xp = 510 }, -- The Shadowy Figure (lvl 25, ~510 xp, sim lvl 24)
    { "accept", 265 }, -- The Shadowy Search Continues (lvl 25, ~200 xp, sim lvl 24)
    { "complete", 57, at = { 1431, 22.47, 43.72 } }, -- The Night Watch (lvl 26, ~2100 xp, sim lvl 24)
    { "complete", 156, at = { 1431, 21.66, 45.32 } }, -- Gather Rot Blossoms (lvl 24, ~970 xp, sim lvl 25)
    { "complete", 101, at = { 1431, 28.4, 49.5 } }, -- The Totem of Infliction (lvl 25, ~2550 xp, sim lvl 25)
    { "hearth", 1431 }, -- pierre de foyer
    { "turnin", 96137, xp = 2000 }, -- Ira's Dagger (lvl 25, ~2000 xp, sim lvl 25)
    { "turnin", 96139, xp = 1400 }, -- The Valor Family (lvl 23, ~1400 xp, sim lvl 25)
    { "turnin", 57, xp = 2100 }, -- The Night Watch (lvl 26, ~2100 xp, sim lvl 25)
    { "turnin", 265, xp = 200 }, -- The Shadowy Search Continues (lvl 25, ~200 xp, sim lvl 25)
    { "accept", 266 }, -- Inquire at the Inn (lvl 25, ~200 xp, sim lvl 25)
    { "turnin", 266, xp = 200 }, -- Inquire at the Inn (lvl 25, ~200 xp, sim lvl 25)
    { "turnin", 156, xp = 970 }, -- Gather Rot Blossoms (lvl 24, ~970 xp, sim lvl 25)
    { "turnin", 101, xp = 2550 }, -- The Totem of Infliction (lvl 25, ~2550 xp, sim lvl 25)
    { "accept", 159 }, -- Juice Delivery (lvl 24, ~970 xp, sim lvl 25)
    { "accept", 453 }, -- Finding the Shadowy Figure (lvl 25, ~1000 xp, sim lvl 25)
    { "turnin", 245, xp = 1250 }, -- Eight-Legged Menaces (lvl 21, ~1250 xp, sim lvl 25)
    { "turnin", 159, xp = 970 }, -- Juice Delivery (lvl 24, ~970 xp, sim lvl 25)
    { "accept", 133 }, -- Ghoulish Effigy (lvl 27, ~1650 xp, sim lvl 25)
    { "complete", 133, at = { 1431, 23.87, 32.26 } }, -- Ghoulish Effigy (lvl 27, ~1650 xp, sim lvl 25)
    { "turnin", 133, xp = 1650 }, -- Ghoulish Effigy (lvl 27, ~1650 xp, sim lvl 26)
    { "turnin", 453, xp = 1000 }, -- Finding the Shadowy Figure (lvl 25, ~1000 xp, sim lvl 26)
    { "accept", 268 }, -- Return to Sven (lvl 25, ~510 xp, sim lvl 26)
    { "turnin", 268, xp = 510 }, -- Return to Sven (lvl 25, ~510 xp, sim lvl 26)
    { "turnin", 1075, xp = 830 }, -- A Scroll from Mauren (lvl 21, ~830 xp, sim lvl 26)
    { "accept", 92489, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- Power Overwhelming (lvl 33, ~0 xp, sim lvl 26)
    { "turnin", 78149, xp = 1240 }, -- Fury of the Land (lvl 20, ~1240 xp, sim lvl 26)
    { "accept", 1939, race = { "Human", "Gnome" }, classes = { "MAGE" } }, -- High Sorcerer Andromath (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 1939, xp = 1050, race = { "Human", "Gnome" }, classes = { "MAGE" } }, -- High Sorcerer Andromath (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 79097, xp = 1240 }, -- Baxtan: On Destructive Magics (lvl 20, ~1240 xp, sim lvl 26)
    { "accept", 92456, optional = true, dungeon = "City of Dalaran", phase = "prep", rung = "DALARAN" }, -- A Green Sample (lvl 33, ~0 xp, sim lvl 26)
    { "accept", 2923, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Tinkmaster Overspark (lvl 26, ~0 xp, sim lvl 26)
    { "accept", 78090, race = { "Human", "Dwarf" }, classes = { "PALADIN" } }, -- A Second Opinion (lvl 30, ~1200 xp, sim lvl 26)
    { "turnin", 97914, xp = 125 }, -- Expanding Horizons (lvl 17, ~125 xp, sim lvl 26)
    { "accept", 2928, optional = true, dungeon = "Gnomeregan", phase = "prep", rung = "GNOMER" }, -- Gyrodrillmatic Excavationators (lvl 30, ~0 xp, sim lvl 26)
    { "accept", 388, optional = true, dungeon = "The Stockade", phase = "prep", rung = "STOCKADE" }, -- The Color of Blood (lvl 26, ~0 xp, sim lvl 26)
    { "accept", 387, optional = true, dungeon = "The Stockade", phase = "prep", rung = "STOCKADE" }, -- Quell The Uprising (lvl 26, ~0 xp, sim lvl 26)
    { "turnin", 78090, xp = 1200, race = { "Human", "Dwarf" }, classes = { "PALADIN" } }, -- A Second Opinion (lvl 30, ~1200 xp, sim lvl 26)
    { "goto", 1453, 52.41, 70.01, optional = true, dungeon = "The Stockade", note = "Dungeon: The Stockade (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "STOCKADE" }, -- déplacement
    { "complete", 377, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- Crime and Punishment (lvl 26, ~1050 xp, sim lvl 26)
    { "complete", 386, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- What Comes Around... (lvl 25, ~1000 xp, sim lvl 26)
    { "complete", 387, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- Quell The Uprising (lvl 26, ~1325 xp, sim lvl 26)
    { "complete", 388, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- The Color of Blood (lvl 26, ~1325 xp, sim lvl 26)
    { "turnin", 377, xp = 1050, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- Crime and Punishment (lvl 26, ~1050 xp, sim lvl 26)
    { "turnin", 387, xp = 1325, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- Quell The Uprising (lvl 26, ~1325 xp, sim lvl 26)
    { "turnin", 388, xp = 1325, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- The Color of Blood (lvl 26, ~1325 xp, sim lvl 26)
    { "turnin", 386, xp = 1000, optional = true, dungeon = "The Stockade", phase = "run", rung = "STOCKADE" }, -- What Comes Around... (lvl 25, ~1000 xp, sim lvl 26)
  },
})
