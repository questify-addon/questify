local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 64 étapes, niveau final 30.00, ~24649 xp/h, 208 min.
Q:RegisterGuide({
  id = "H_05",
  title = "Hillsbrad Foothills",
  faction = "Horde",
  minLevel = 28, maxLevel = 30,
  next = "H_06",
  sim = { steps = 64, endLevel = 30.00, xpPerHour = 24649, minutes = 208 },
  steps = {
    { "fp", 1454, 45.12, 63.89 }, -- point de vol
    { "boat", 1411, 50.8, 13.5, note = "Take the zeppelin to Undercity (Tirisfal Glades)" }, -- bateau
    { "fp", 1458, 63.25, 48.56 }, -- point de vol
    { "fp", 1424, 60.14, 18.62 }, -- point de vol
    { "accept", 527 }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 28)
    { "accept", 98094 }, -- Scout Support (lvl 25, ~1000 xp, sim lvl 28)
    { "accept", 549 }, -- WANTED: Syndicate Personnel (lvl 22, ~1400 xp, sim lvl 28)
    { "accept", 498 }, -- The Rescue (lvl 22, ~1760 xp, sim lvl 28)
    { "accept", 567 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "sethearth", 1424, 62.78, 19.03 }, -- lier la pierre de foyer
    { "accept", 97287 }, -- Shrewd Negotiations (lvl 33, ~0 xp, sim lvl 28)
    { "accept", 509 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 501 }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 28)
    { "complete", 527, at = { 1424, 33.86, 37.58 } }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 28)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 527, xp = 1950 }, -- Battle of Hillsbrad (lvl 24, ~1950 xp, sim lvl 28)
    { "accept", 528 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 28)
    { "complete", 501, at = { 1424, 51.78, 34.17 } }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 28)
    { "complete", 567, obj = 4, at = { 1424, 35.88, 46.57 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "complete", 528, at = { 1424, 35, 45.59 } }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 28)
    { "turnin", 528, xp = 2000 }, -- Battle of Hillsbrad (lvl 25, ~2000 xp, sim lvl 28)
    { "accept", 529 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "turnin", 501, xp = 1950 }, -- Elixir of Pain (lvl 24, ~1950 xp, sim lvl 28)
    { "complete", 529, at = { 1424, 32.11, 44.42 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "complete", 567, at = { 1424, 29.51, 42.41 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "complete", 567, at = { 1424, 31.8, 52.7 } }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 98095 }, -- Valuable Vantages (lvl 25, ~1000 xp, sim lvl 28)
    { "turnin", 98094, xp = 1000 }, -- Scout Support (lvl 25, ~1000 xp, sim lvl 28)
    { "turnin", 98095, xp = 1000 }, -- Valuable Vantages (lvl 25, ~1000 xp, sim lvl 28)
    { "complete", 509, at = { 1424, 64.39, 61.33 } }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 28)
    { "turnin", 79974, xp = 640 }, -- Wet Job (lvl 32, ~640 xp, sim lvl 28)
    { "accept", 79975 }, -- Eagle's Fist (lvl 32, ~640 xp, sim lvl 28)
    { "turnin", 79975, xp = 640 }, -- Eagle's Fist (lvl 32, ~640 xp, sim lvl 28)
    { "accept", 79976 }, -- This Must Be The Place (lvl 32, ~640 xp, sim lvl 28)
    { "turnin", 79976, xp = 640 }, -- This Must Be The Place (lvl 32, ~640 xp, sim lvl 28)
    { "complete", 549, at = { 1424, 80.07, 45.06 } }, -- WANTED: Syndicate Personnel (lvl 22, ~1400 xp, sim lvl 28)
    { "complete", 498, at = { 1424, 75.33, 41.5 } }, -- The Rescue (lvl 22, ~1760 xp, sim lvl 28)
    { "turnin", 498, xp = 1760 }, -- The Rescue (lvl 22, ~1760 xp, sim lvl 28)
    { "accept", 96986, optional = true, dungeon = "City of Dalaran" }, -- The Grave Knight (lvl 33, ~0 xp, sim lvl 28)
    { "turnin", 529, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "accept", 532 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "turnin", 549, xp = 1400 }, -- WANTED: Syndicate Personnel (lvl 22, ~1400 xp, sim lvl 28)
    { "turnin", 567, xp = 2300 }, -- Dangerous! (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 546 }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 28)
    { "turnin", 509, xp = 2300 }, -- Elixir of Agony (lvl 28, ~2300 xp, sim lvl 28)
    { "accept", 513 }, -- Elixir of Agony (lvl 28, ~1150 xp, sim lvl 28)
    { "accept", 502 }, -- Elixir of Pain (lvl 24, ~1450 xp, sim lvl 28)
    { "turnin", 502, xp = 1450 }, -- Elixir of Pain (lvl 24, ~1450 xp, sim lvl 28)
    { "complete", 532, at = { 1424, 29.67, 41.64 } }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 28)
    { "complete", 546, at = { 1424, 32.04, 42.96 } }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 28)
    { "hearth", 1424 }, -- pierre de foyer
    { "turnin", 532, xp = 2100 }, -- Battle of Hillsbrad (lvl 26, ~2100 xp, sim lvl 29)
    { "accept", 539 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 29)
    { "turnin", 546, xp = 2550 }, -- Souvenirs of Death (lvl 25, ~2550 xp, sim lvl 29)
    { "complete", 539, at = { 1424, 31.21, 56.01 } }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 29)
    { "turnin", 539, xp = 2300 }, -- Battle of Hillsbrad (lvl 28, ~2300 xp, sim lvl 29)
    { "goto", 1424, 60.14, 18.62, note = "Flight master" }, -- déplacement
    { "fly", 1458, node = 11, note = "Undercity, Tirisfal" }, -- vol
    { "turnin", 513, xp = 1150 }, -- Elixir of Agony (lvl 28, ~1150 xp, sim lvl 29)
    { "turnin", 78143, xp = 310 }, -- Secrets of the Dreamers (lvl 20, ~310 xp, sim lvl 29)
    { "turnin", 79097, xp = 310 }, -- Baxtan: On Destructive Magics (lvl 20, ~310 xp, sim lvl 29)
    { "turnin", 78149, xp = 310 }, -- Fury of the Land (lvl 20, ~310 xp, sim lvl 29)
    { "turnin", 78145, xp = 310 }, -- Arcanic Systems Manual (lvl 20, ~310 xp, sim lvl 29)
    { "level", 30, at = { 1458, 61.29, 33.4 }, note = "About 170 more mobs here (Malus, level 29)" }, -- farm de niveau
  },
})
