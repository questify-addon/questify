local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit e1652ce62113c152da682baf2d6fb85f1396bcfb, généré le 2026-11-17.
-- Simulation : 84 étapes, niveau final 37.00, ~41019 xp/h, 381 min.
Q:RegisterGuide({
  id = "H_09",
  title = "Stranglethorn Vale",
  faction = "Horde",
  minLevel = 33, maxLevel = 37,
  next = "H_31",
  sim = { steps = 84, endLevel = 37.00, xpPerHour = 41019, minutes = 381 },
  steps = {
    { "note", "Not running Blackfathom Deeps? Abandon Amongst the Ruins", optional = true, dungeon = "Blackfathom Deeps" },
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "boat", 1420, 61.78, 59.18, note = "Take the zeppelin to Grom'gol (Stranglethorn Vale)" }, -- bateau
    { "fp", 1434, 32.54, 29.35 }, -- point de vol
    { "accept", 97453 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 33)
    { "accept", 596 }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 33)
    { "accept", 581 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 33)
    { "accept", 568 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 570 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 33)
    { "fp", 1434, 26.87, 77.1 }, -- point de vol
    { "accept", 189 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 33)
    { "accept", 213 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 201 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 33)
    { "accept", 605 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 33)
    { "sethearth", 1434, 27.04, 77.31 }, -- lier la pierre de foyer
    { "accept", 575 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 33)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "complete", 568, at = { 1434, 38.49, 20.44 } }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 583 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 33)
    { "turnin", 583, xp = 245 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 33)
    { "accept", 194 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 33)
    { "accept", 185 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "accept", 190 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "complete", 201, at = { 1434, 35.65, 10.59 } }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 33)
    { "complete", 185, at = { 1434, 34.28, 11.84 } }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "turnin", 185, xp = 1250 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "accept", 186 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 575, at = { 1434, 40.47, 13.2 } }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 33)
    { "complete", 190, at = { 1434, 41.8, 12.69 } }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "turnin", 190, xp = 1250 }, -- Panther Mastery (lvl 31, ~1250 xp, sim lvl 33)
    { "accept", 191 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 191, at = { 1434, 29.62, 10.42 } }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 186, at = { 1434, 29.8, 10.25 } }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "complete", 581, at = { 1434, 25.24, 10.4 } }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 33)
    { "complete", 189, at = { 1434, 25.2, 10.38 } }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 186, xp = 1300 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "accept", 187 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 191, xp = 1300 }, -- Panther Mastery (lvl 33, ~1300 xp, sim lvl 33)
    { "accept", 192 }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 33)
    { "complete", 187, at = { 1434, 35.01, 18.88 } }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 33)
    { "turnin", 581, xp = 2000 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 33)
    { "accept", 582 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 33)
    { "turnin", 568, xp = 2800 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 33)
    { "accept", 569 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 33)
    { "complete", 194, at = { 1434, 26.88, 16.33 } }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 33)
    { "complete", 605, at = { 1434, 24.73, 17.49 } }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 33)
    { "complete", 596, at = { 1434, 25.12, 10.34 } }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 34)
    { "complete", 582, at = { 1434, 23.53, 9.81 } }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 34)
    { "turnin", 79007, xp = 175 }, -- ... and that note you found (lvl 22, ~175 xp, sim lvl 34)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 189, xp = 2050 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 34)
    { "turnin", 605, xp = 2750 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 34)
    { "turnin", 201, xp = 255 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 34)
    { "turnin", 575, xp = 1250 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 34)
    { "accept", 577 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 34)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "turnin", 187, xp = 2050 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 34)
    { "accept", 188 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 34)
    { "turnin", 194, xp = 1350 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 34)
    { "accept", 195 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 34)
    { "turnin", 596, xp = 2100 }, -- Bloody Bone Necklaces (lvl 37, ~2100 xp, sim lvl 34)
    { "turnin", 582, xp = 2100 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 34)
    { "complete", 570, at = { 1434, 40.06, 39.97 } }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 35)
    { "complete", 569, at = { 1434, 37.32, 31 } }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 35)
    { "complete", 577, at = { 1434, 39.33, 29.86 } }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 35)
    { "complete", 192, at = { 1434, 49.19, 21.6 } }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 35)
    { "complete", 213, at = { 1434, 43.95, 22.24 } }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "complete", 195, at = { 1434, 38.49, 20.44 } }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 35)
    { "complete", 188, at = { 1434, 31.84, 16.45 } }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 35)
    { "turnin", 192, xp = 2150 }, -- Panther Mastery (lvl 38, ~2150 xp, sim lvl 35)
    { "turnin", 188, xp = 2850 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 195, xp = 1400 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 36)
    { "complete", 97453, at = { 1434, 34.3, 27.27 } }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "turnin", 97453, xp = 1450 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "accept", 95141 }, -- Report to Rog'mar (lvl 38, ~0 xp, sim lvl 36)
    { "turnin", 569, xp = 2850 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 570, xp = 2150 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 36)
    { "hearth", 1434 }, -- pierre de foyer
    { "turnin", 213, xp = 2800 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 36)
    { "turnin", 577, xp = 1400 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 36)
    { "level", 37, at = { 1434, 34.3, 27.27 }, note = "About 230 more mobs near the last objective" }, -- farm de niveau
  },
})
