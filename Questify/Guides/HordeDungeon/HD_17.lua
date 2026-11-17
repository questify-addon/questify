local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-17.
-- Simulation : 70 étapes, niveau final 44.13, ~62987 xp/h, 115 min.
Q:RegisterGuide({
  id = "HD_17",
  title = "Stranglethorn Vale",
  faction = "Horde",
  mode = "dungeon",
  minLevel = 43, maxLevel = 44,
  next = "HD_18",
  sim = { steps = 70, endLevel = 44.13, xpPerHour = 62987, minutes = 115 },
  steps = {
    { "note", "Not running Razorfen Downs? Abandon An Unholy Alliance", optional = true, dungeon = "Razorfen Downs", alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 },
    { "hearth", 1434, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- pierre de foyer
    { "fly", 1434, node = 20, note = "Grom'gol, Stranglethorn", alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- vol
    { "accept", 95770, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 43)
    { "accept", 95748, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 43)
    { "accept", 584, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 43)
    { "complete", 95770, at = { 1434, 22.4, 27.18 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 95748, at = { 1434, 22.95, 12.02 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 584, at = { 1434, 23.44, 8.12 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 43)
    { "accept", 196, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "turnin", 584, xp = 3300, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Bloodscalp Clan Heads (lvl 41, ~3300 xp, sim lvl 43)
    { "accept", 586, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 43)
    { "accept", 585, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 43)
    { "turnin", 95770, xp = 3150, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Locating the Lost City (lvl 40, ~3150 xp, sim lvl 43)
    { "turnin", 95748, xp = 3150, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Gurubashi Legends of Old (lvl 40, ~3150 xp, sim lvl 43)
    { "complete", 196, at = { 1434, 31.35, 42.55 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "complete", 585, obj = 2, at = { 1434, 42.21, 36.11 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 43)
    { "complete", 586, at = { 1434, 45.64, 42.96 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 43)
    { "complete", 585, obj = 3, at = { 1434, 47.65, 39.54 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 43)
    { "complete", 585, at = { 1434, 46.13, 32.33 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 43)
    { "turnin", 196, xp = 2450, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 197, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 586, xp = 4050, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Gan'zulah (lvl 46, ~4050 xp, sim lvl 43)
    { "turnin", 585, xp = 2350, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Speaking with Nezzliok (lvl 40, ~2350 xp, sim lvl 43)
    { "accept", 588, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Fate of Yenniku (lvl 45, ~390 xp, sim lvl 43)
    { "turnin", 588, xp = 390, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Fate of Yenniku (lvl 45, ~390 xp, sim lvl 43)
    { "accept", 589, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 43)
    { "complete", 197, at = { 1434, 31.85, 42 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 628, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 43)
    { "accept", 606, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 43)
    { "accept", 2872, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Stoley's Debt (lvl 45, ~0 xp, sim lvl 43)
    { "accept", 348, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "accept", 595, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 600, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 43)
    { "accept", 621, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "accept", 79236, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 43)
    { "accept", 2864, optional = true, dungeon = "Zul'Farrak", alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Tran'rek (lvl 45, ~0 xp, sim lvl 43)
    { "complete", 606, at = { 1434, 32.62, 66.62 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 43)
    { "turnin", 595, xp = 2450, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 597, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 43)
    { "turnin", 606, xp = 3300, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Scaring Shaky (lvl 41, ~3300 xp, sim lvl 43)
    { "accept", 607, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 43)
    { "turnin", 95295, xp = 315, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- I Know a Guy (lvl 40, ~315 xp, sim lvl 43)
    { "turnin", 597, xp = 2450, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 599, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 43)
    { "turnin", 607, xp = 2450, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Return to MacKinley (lvl 41, ~2450 xp, sim lvl 43)
    { "accept", 609, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 599, xp = 820, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 41, ~820 xp, sim lvl 43)
    { "accept", 604, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 43)
    { "accept", 587, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 43)
    { "complete", 604, at = { 1434, 26.87, 83.26 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 43)
    { "complete", 587, at = { 1434, 29.97, 89.12 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 43)
    { "complete", 621, at = { 1434, 39.62, 58.31 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 609, obj = 3, at = { 1434, 40, 58.24 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 589, at = { 1434, 43.11, 48.08 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 43)
    { "complete", 600, at = { 1434, 41.63, 44.07 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 43)
    { "turnin", 197, xp = 3600, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Raptor Mastery (lvl 43, ~3600 xp, sim lvl 43)
    { "turnin", 589, xp = 3900, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Singing Crystals (lvl 45, ~3900 xp, sim lvl 43)
    { "complete", 628, at = { 1434, 33.43, 32.53 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 43)
    { "complete", 609, at = { 1434, 35.26, 51.27 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "complete", 348, at = { 1434, 35.05, 60.88 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "turnin", 628, xp = 2850, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Excelsior (lvl 38, ~2850 xp, sim lvl 43)
    { "turnin", 609, xp = 3750, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Voodoo Dues (lvl 44, ~3750 xp, sim lvl 43)
    { "turnin", 348, xp = 5850, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Stranglethorn Fever (lvl 45, ~5850 xp, sim lvl 43)
    { "turnin", 604, xp = 3600, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- The Bloodsail Buccaneers (lvl 43, ~3600 xp, sim lvl 44)
    { "turnin", 600, xp = 3300, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Venture Company Mining (lvl 41, ~3300 xp, sim lvl 44)
    { "turnin", 621, xp = 3750, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Zanzil's Secret (lvl 44, ~3750 xp, sim lvl 44)
    { "turnin", 587, xp = 1650, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Up to Snuff (lvl 41, ~1650 xp, sim lvl 44)
    { "complete", 79236, at = { 1434, 27.04, 77.17 }, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 44)
    { "turnin", 79236, xp = 1550, alt = { "GNOMER", "SM_ARM", "SM_CATH" }, below = 44 }, -- Cherry for Your Thoughts? (lvl 40, ~1550 xp, sim lvl 44)
  },
})
