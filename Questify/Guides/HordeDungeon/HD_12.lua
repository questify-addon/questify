local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 106 étapes, niveau final 37.58, ~37993 xp/h, 289 min.
Q:RegisterGuide({
  id = "HD_12",
  title = "Stranglethorn Vale",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 35, maxLevel = 37,
  next = "HD_13",
  sim = { steps = 106, endLevel = 37.58, xpPerHour = 37993, minutes = 289 },
  steps = {
    { "goto", 1442, 45.12, 59.84, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "boat", 1411, 50.69, 12.89, note = "Take the zeppelin to Grom'gol (Stranglethorn Vale)" }, -- bateau
    { "fp", 1434, 32.54, 29.35 }, -- point de vol
    { "accept", 97453 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 35)
    { "accept", 581 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 35)
    { "accept", 568 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 35)
    { "accept", 570 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 35)
    { "fp", 1434, 26.87, 77.1 }, -- point de vol
    { "accept", 189 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 35)
    { "accept", 213 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "accept", 201 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 35)
    { "sethearth", 1434, 27.04, 77.31 }, -- lier la pierre de foyer
    { "turnin", 1115, xp = 1400 }, -- The Rumormonger (lvl 36, ~1400 xp, sim lvl 35)
    { "accept", 575 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 79535 }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~0 xp, sim lvl 35)
    { "complete", 79535, at = { 1434, 41.45, 50.9 } }, -- Basilisks: Should Petrification be Feared? (lvl 35, ~0 xp, sim lvl 35)
    { "complete", 213, at = { 1434, 43.95, 22.24 } }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "complete", 568, at = { 1434, 38.49, 20.44 } }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 35)
    { "accept", 583 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 35)
    { "turnin", 583, xp = 245 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 35)
    { "accept", 194 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 35)
    { "accept", 185 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 190 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 339 }, -- Chapter I (lvl 40, ~780 xp, sim lvl 35)
    { "accept", 341 }, -- Chapter III (lvl 40, ~780 xp, sim lvl 35)
    { "accept", 342 }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 35)
    { "turnin", 5762, xp = 1250 }, -- Hemet Nesingwary (lvl 31, ~1250 xp, sim lvl 35)
    { "turnin", 5763, xp = 1250 }, -- Hunting in Stranglethorn (lvl 31, ~1250 xp, sim lvl 35)
    { "complete", 201, at = { 1434, 35.65, 10.59 } }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 35)
    { "complete", 185, at = { 1434, 34.28, 11.84 } }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "turnin", 185, xp = 1250 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 186 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 35)
    { "complete", 575, at = { 1434, 40.47, 13.2 } }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 35)
    { "complete", 190, at = { 1434, 41.8, 12.69 } }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "turnin", 190, xp = 1250 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 191 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 35)
    { "complete", 186, at = { 1434, 29.8, 10.25 } }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 35)
    { "complete", 191, at = { 1434, 29.62, 10.42 } }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 35)
    { "complete", 581, at = { 1434, 25.24, 10.4 } }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 35)
    { "complete", 189, at = { 1434, 25.2, 10.38 } }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 35)
    { "complete", 194, at = { 1434, 26.88, 16.33 } }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 35)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 189, xp = 2050 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 35)
    { "turnin", 213, xp = 2800 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "turnin", 201, xp = 255 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 35)
    { "accept", 605 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 35)
    { "turnin", 575, xp = 1250 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 577 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 35)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "complete", 570, at = { 1434, 40.06, 39.97 } }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 35)
    { "complete", 577, at = { 1434, 39.33, 29.86 } }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 36)
    { "complete", 97453, at = { 1434, 34.3, 27.27 } }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "turnin", 97453, xp = 1450 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "turnin", 570, xp = 2150 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 36)
    { "turnin", 568, xp = 2800 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 36)
    { "accept", 569 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 581, xp = 2000 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 36)
    { "accept", 582 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 36)
    { "accept", 638 }, -- Trollbane (lvl 37, ~0 xp, sim lvl 36)
    { "complete", 605, at = { 1434, 24.73, 17.49 } }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 36)
    { "complete", 582, at = { 1434, 23.53, 9.81 } }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 36)
    { "turnin", 79007, xp = 175 }, -- ... and that note you found (lvl 22, ~175 xp, sim lvl 36)
    { "accept", 79192, note = "Click the Nailed Plank: the Burned-Out Remains next to it do not give this quest" }, -- Stepping Stones (lvl 24, ~0 xp, sim lvl 36)
    { "turnin", 191, xp = 1300 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 36)
    { "accept", 192 }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 36)
    { "turnin", 186, xp = 1300 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 36)
    { "accept", 187 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 36)
    { "turnin", 194, xp = 1350 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 36)
    { "accept", 195 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 36)
    { "level", 37, at = { 1434, 48.71, 6.21 }, note = "About 3 mobs here (Kurzen Subchief, level 35)" }, -- farm de niveau
    { "complete", 339, at = { 1434, 44.83, 9.73 } }, -- Chapter I (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 342, obj = 2, at = { 1434, 44.83, 9.73 } }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 192, at = { 1434, 49.19, 21.6 } }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 37)
    { "complete", 195, at = { 1434, 38.49, 20.44 } }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 37)
    { "complete", 341, obj = 2, at = { 1434, 37.37, 31.22 } }, -- Chapter III (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 569, at = { 1434, 37.32, 31 } }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 37)
    { "complete", 342, at = { 1434, 34.75, 22.74 } }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 341, at = { 1434, 34.75, 22.74 } }, -- Chapter III (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 339, at = { 1434, 34.75, 22.74 } }, -- Chapter I (lvl 40, ~780 xp, sim lvl 37)
    { "complete", 187, at = { 1434, 35.01, 18.88 } }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 37)
    { "turnin", 195, xp = 1400 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 37)
    { "turnin", 187, xp = 2050 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 37)
    { "accept", 188 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 342, xp = 780 }, -- Chapter IV (lvl 40, ~780 xp, sim lvl 37)
    { "turnin", 341, xp = 780 }, -- Chapter III (lvl 40, ~780 xp, sim lvl 37)
    { "turnin", 339, xp = 780 }, -- Chapter I (lvl 40, ~780 xp, sim lvl 37)
    { "turnin", 192, xp = 2150 }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 37)
    { "complete", 188, at = { 1434, 31.84, 16.45 } }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 188, xp = 2850 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 582, xp = 2100 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 37)
    { "turnin", 569, xp = 2850 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 37)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 577, xp = 1400 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 37)
    { "turnin", 605, xp = 2750 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "goto", 1434, 27.6, 77.48, optional = true, dungeon = "Gnomeregan", note = "Dungeon: Gnomeregan (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "GNOMER" }, -- déplacement
    { "complete", 2841, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Rig Wars (lvl 35, ~1375 xp, sim lvl 37)
    { "turnin", 2842, at = { 1434, 27.6, 77.48 }, xp = 135, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Chief Engineer Scooty (lvl 35, ~135 xp, sim lvl 37)
    { "turnin", 2841, at = { 1454, 75.99, 25.41 }, xp = 1375, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- Rig Wars (lvl 35, ~1375 xp, sim lvl 37)
    { "accept", 2904, optional = true, dungeon = "Gnomeregan", note = "Starts inside the dungeon", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 37)
    { "accept", 2951, optional = true, dungeon = "Gnomeregan", note = "Starts inside the dungeon", phase = "run", rung = "GNOMER" }, -- The Sparklematic 5200! (lvl 30, ~1225 xp, sim lvl 37)
    { "complete", 2904, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 37)
    { "complete", 2951, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- The Sparklematic 5200! (lvl 30, ~1225 xp, sim lvl 37)
    { "turnin", 2951, xp = 1225, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- The Sparklematic 5200! (lvl 30, ~1225 xp, sim lvl 37)
    { "turnin", 2904, at = { 1434, 27.6, 77.48 }, xp = 1225, optional = true, dungeon = "Gnomeregan", phase = "run", rung = "GNOMER" }, -- A Fine Mess (lvl 30, ~1225 xp, sim lvl 37)
  },
})
