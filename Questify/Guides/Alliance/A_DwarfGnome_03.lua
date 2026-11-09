local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit 4d31c10394b11bd133069ecf1662062cdf4d8691, généré le 2026-11-09.
-- Simulation : 53 étapes, niveau final 14.28, ~19667 xp/h, 77 min.
Q:RegisterGuide({
  id = "A_DwarfGnome_03",
  title = "Loch Modan",
  faction = "Alliance",
  races = { "Dwarf", "Gnome" },
  minLevel = 11, maxLevel = 13,
  next = "A_DwarfGnome_04",
  choices = {
    { id = "A_DwarfGnome_04", travel = { kind = "walk", minutes = 3 } },
    { id = "A_01", travel = { kind = "boat", minutes = 7 } },
  },
  sim = { steps = 53, endLevel = 14.28, xpPerHour = 19667, minutes = 77 },
  steps = {
    { "accept", 1339 }, -- Mountaineer Stormpike's Task (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 298 }, -- Excavation Progress Report (lvl 15, ~270 xp, sim lvl 12)
    { "turnin", 298, xp = 270 }, -- Excavation Progress Report (lvl 15, ~270 xp, sim lvl 12)
    { "accept", 301 }, -- Report to Ironforge (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 6387 }, -- Honor Students (lvl 10, ~210 xp, sim lvl 12)
    { "turnin", 6387, xp = 210 }, -- Honor Students (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 6391 }, -- Ride to Ironforge (lvl 10, ~420 xp, sim lvl 12)
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "turnin", 301, xp = 540 }, -- Report to Ironforge (lvl 15, ~540 xp, sim lvl 12)
    { "note", "The Hall of Thanes is under Ironforge (levels 13-18): run it on this visit, or abandon Old Ironforge Incursion", optional = true, dungeon = "The Hall of Thanes" },
    { "accept", 302 }, -- Powder to Ironband (lvl 15, ~270 xp, sim lvl 12)
    { "turnin", 6391, xp = 420 }, -- Ride to Ironforge (lvl 10, ~420 xp, sim lvl 12)
    { "accept", 6388 }, -- Gryth Thurden (lvl 10, ~210 xp, sim lvl 12)
    { "turnin", 6388, xp = 210 }, -- Gryth Thurden (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 6392 }, -- Return to Brock (lvl 10, ~1050 xp, sim lvl 12)
    { "accept", 2039 }, -- Find Bingles (lvl 15, ~270 xp, sim lvl 12)
    { "accept", 307 }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "turnin", 1339, xp = 540 }, -- Mountaineer Stormpike's Task (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 1338 }, -- Stormpike's Order (lvl 14, ~980 xp, sim lvl 12)
    { "complete", 307, at = { 1432, 35.5, 24.64 } }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "turnin", 307, xp = 1350 }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "turnin", 302, xp = 270 }, -- Powder to Ironband (lvl 15, ~270 xp, sim lvl 12)
    { "accept", 273 }, -- Resupplying the Excavation (lvl 15, ~270 xp, sim lvl 12)
    { "turnin", 6392, xp = 1050 }, -- Return to Brock (lvl 10, ~1050 xp, sim lvl 12)
    { "accept", 224 }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 12)
    { "complete", 224, at = { 1432, 31.8, 73.61 } }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 12)
    { "turnin", 224, xp = 910 }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 12)
    { "accept", 237 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 12)
    { "complete", 237, at = { 1432, 35.7, 85.02 } }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 12)
    { "turnin", 237, xp = 1050 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 12)
    { "accept", 263 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 263, at = { 1432, 36.01, 91.83 } }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 263, xp = 1050 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 273, at = { 1432, 52.2, 69.37 } }, -- Resupplying the Excavation (lvl 15, ~270 xp, sim lvl 13)
    { "turnin", 273, xp = 270 }, -- Resupplying the Excavation (lvl 15, ~270 xp, sim lvl 13)
    { "accept", 454 }, -- After the Ambush (lvl 15, ~105 xp, sim lvl 13)
    { "turnin", 454, xp = 105 }, -- After the Ambush (lvl 15, ~105 xp, sim lvl 13)
    { "accept", 309 }, -- Protecting the Shipment (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 309, at = { 1432, 65.12, 65.77 } }, -- Protecting the Shipment (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 309, xp = 1050 }, -- Protecting the Shipment (lvl 15, ~1050 xp, sim lvl 13)
    { "accept", 86758 }, -- Twisting the Knife (lvl 16, ~1150 xp, sim lvl 13)
    { "accept", 385 }, -- Crocolisk Hunting (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 86758, at = { 1432, 63.26, 44.98 } }, -- Twisting the Knife (lvl 16, ~1150 xp, sim lvl 13)
    { "complete", 385, at = { 1432, 63.23, 44.97 } }, -- Crocolisk Hunting (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 2039, xp = 270 }, -- Find Bingles (lvl 15, ~270 xp, sim lvl 13)
    { "turnin", 385, xp = 1050 }, -- Crocolisk Hunting (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 86758, xp = 1150 }, -- Twisting the Knife (lvl 16, ~1150 xp, sim lvl 13)
    { "accept", 257, note = "Timed quest: do it right away" }, -- A Hunter's Boast (lvl 16, ~880 xp, sim lvl 14)
    { "complete", 257, at = { 1432, 76.53, 71.82 } }, -- A Hunter's Boast (lvl 16, ~880 xp, sim lvl 14)
    { "turnin", 257, xp = 880 }, -- A Hunter's Boast (lvl 16, ~880 xp, sim lvl 14)
    { "goto", 1432, 33.94, 50.95, note = "Flight master" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "boat", 1455, 78, 51.4, note = "Take the Deeprun Tram to Stormwind" }, -- bateau
    { "turnin", 1338, xp = 980 }, -- Stormpike's Order (lvl 14, ~980 xp, sim lvl 14)
  },
})
