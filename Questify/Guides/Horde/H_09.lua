local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 84 étapes, niveau final 37.40, ~39901 xp/h, 254 min.
Q:RegisterGuide({
  id = "H_09",
  title = "Stranglethorn Vale",
  faction = "Horde",
  minLevel = 35, maxLevel = 37,
  next = "H_10",
  sim = { steps = 84, endLevel = 37.40, xpPerHour = 39901, minutes = 254 },
  steps = {
    { "goto", 1456, 47, 49.83, note = "Flight master" }, -- déplacement
    { "fly", 1454, node = 23, note = "Orgrimmar, Durotar" }, -- vol
    { "boat", 1411, 50.69, 12.89, note = "Take the zeppelin to Grom'gol (Stranglethorn Vale)" }, -- bateau
    { "fp", 1434, 32.54, 29.35 }, -- point de vol
    { "accept", 97453 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 35)
    { "accept", 638 }, -- Trollbane (lvl 37, ~0 xp, sim lvl 35)
    { "accept", 581 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 35)
    { "accept", 568 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 35)
    { "accept", 95773 }, -- Enemies in the Water (lvl 37, ~2850 xp, sim lvl 35)
    { "accept", 570 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 35)
    { "fp", 1434, 26.87, 77.1 }, -- point de vol
    { "accept", 95322 }, -- Get the Goods (lvl 40, ~2350 xp, sim lvl 35)
    { "accept", 95325 }, -- We've Been Robbed! (lvl 40, ~2350 xp, sim lvl 35)
    { "turnin", 95322, xp = 2350 }, -- Get the Goods (lvl 40, ~2350 xp, sim lvl 35)
    { "accept", 213 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "accept", 189 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 35)
    { "accept", 201 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 35)
    { "accept", 605 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 35)
    { "accept", 575 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 35)
    { "goto", 1434, 26.87, 77.1, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "complete", 570, at = { 1434, 40.06, 39.97 } }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 35)
    { "complete", 213, at = { 1434, 43.95, 22.24 } }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 35)
    { "turnin", 95325, xp = 2350 }, -- We've Been Robbed! (lvl 40, ~2350 xp, sim lvl 35)
    { "accept", 97048 }, -- Returning to Port (lvl 38, ~2850 xp, sim lvl 35)
    { "complete", 575, at = { 1434, 40.47, 13.2 } }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 583 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 35)
    { "turnin", 583, xp = 245 }, -- Welcome to the Jungle (lvl 30, ~245 xp, sim lvl 35)
    { "turnin", 5763, xp = 1250 }, -- Hunting in Stranglethorn (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 194 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 35)
    { "accept", 185 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "turnin", 5762, xp = 1250 }, -- Hemet Nesingwary (lvl 31, ~1250 xp, sim lvl 35)
    { "complete", 201, at = { 1434, 35.65, 10.59 } }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 35)
    { "complete", 185, at = { 1434, 34.28, 11.84 } }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "turnin", 185, xp = 1250 }, -- Tiger Mastery (lvl 31, ~1250 xp, sim lvl 35)
    { "accept", 186 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 35)
    { "complete", 194, at = { 1434, 26.88, 16.33 } }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 35)
    { "complete", 189, at = { 1434, 25.2, 10.38 } }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 35)
    { "complete", 581, at = { 1434, 25.24, 10.4 } }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 36)
    { "complete", 186, at = { 1434, 29.8, 10.25 } }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 36)
    { "turnin", 186, xp = 1300 }, -- Tiger Mastery (lvl 33, ~1300 xp, sim lvl 36)
    { "accept", 187 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 36)
    { "turnin", 194, xp = 1350 }, -- Raptor Mastery (lvl 34, ~1350 xp, sim lvl 36)
    { "accept", 195 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 36)
    { "complete", 568, at = { 1434, 38.49, 20.44 } }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 36)
    { "complete", 195, at = { 1434, 38.49, 20.44 } }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 36)
    { "complete", 97453, at = { 1434, 34.34, 28.72 } }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "turnin", 581, xp = 2000 }, -- Hunt for Yenniku (lvl 34, ~2000 xp, sim lvl 36)
    { "accept", 582 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 36)
    { "turnin", 568, xp = 2800 }, -- The Defense of Grom'gol (lvl 36, ~2800 xp, sim lvl 36)
    { "accept", 569 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 570, xp = 2150 }, -- Mok'thardin's Enchantment (lvl 38, ~2150 xp, sim lvl 36)
    { "turnin", 97453, xp = 1450 }, -- Weed Whacked (lvl 38, ~1450 xp, sim lvl 36)
    { "fly", 1434, node = 18, note = "Booty Bay, Stranglethorn" }, -- vol
    { "turnin", 97048, xp = 2850 }, -- Returning to Port (lvl 38, ~2850 xp, sim lvl 36)
    { "turnin", 575, xp = 1250 }, -- Supply and Demand (lvl 31, ~1250 xp, sim lvl 36)
    { "accept", 577 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 36)
    { "turnin", 189, xp = 2050 }, -- Bloodscalp Ears (lvl 35, ~2050 xp, sim lvl 36)
    { "turnin", 213, xp = 2800 }, -- Hostile Takeover (lvl 36, ~2800 xp, sim lvl 36)
    { "turnin", 201, xp = 255 }, -- Investigate the Camp (lvl 32, ~255 xp, sim lvl 36)
    { "accept", 79242 }, -- No Honor Among Thieves (lvl 40, ~0 xp, sim lvl 36)
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn" }, -- vol
    { "complete", 569, at = { 1434, 37.32, 31 } }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 36)
    { "complete", 577, at = { 1434, 39.33, 29.86 } }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 36)
    { "complete", 187, at = { 1434, 35.01, 18.88 } }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 36)
    { "turnin", 195, xp = 1400 }, -- Raptor Mastery (lvl 36, ~1400 xp, sim lvl 36)
    { "turnin", 187, xp = 2050 }, -- Tiger Mastery (lvl 35, ~2050 xp, sim lvl 36)
    { "accept", 188 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 36)
    { "complete", 188, at = { 1434, 31.84, 16.45 } }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 188, xp = 2850 }, -- Tiger Mastery (lvl 37, ~2850 xp, sim lvl 36)
    { "turnin", 79007, xp = 175 }, -- ... and that note you found (lvl 22, ~175 xp, sim lvl 36)
    { "accept", 79192, note = "Click the Nailed Plank: the Burned-Out Remains next to it do not give this quest" }, -- Stepping Stones (lvl 24, ~0 xp, sim lvl 36)
    { "complete", 582, at = { 1434, 23.53, 9.81 } }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 36)
    { "accept", 97331 }, -- Zimmix's Great Escape (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 605, at = { 1434, 24.73, 17.49 } }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "complete", 95773, at = { 1434, 26, 28.52 } }, -- Enemies in the Water (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 582, xp = 2100 }, -- Headhunting (lvl 37, ~2100 xp, sim lvl 37)
    { "turnin", 569, xp = 2850 }, -- The Defense of Grom'gol (lvl 37, ~2850 xp, sim lvl 37)
    { "turnin", 95773, xp = 2850 }, -- Enemies in the Water (lvl 37, ~2850 xp, sim lvl 37)
    { "goto", 1434, 32.54, 29.35, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 18, note = "Booty Bay, Stranglethorn" }, -- vol
    { "turnin", 97331, xp = 2750 }, -- Zimmix's Great Escape (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 605, xp = 2750 }, -- Singing Blue Shards (lvl 35, ~2750 xp, sim lvl 37)
    { "turnin", 577, xp = 1400 }, -- Some Assembly Required (lvl 36, ~1400 xp, sim lvl 37)
  },
})
