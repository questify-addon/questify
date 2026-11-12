local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 59 étapes, niveau final 14.26, ~19003 xp/h, 73 min.
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
  sim = { steps = 59, endLevel = 14.26, xpPerHour = 19003, minutes = 73 },
  steps = {
    { "accept", 416 }, -- Rat Catching (lvl 11, ~880 xp, sim lvl 12)
    { "sethearth", 1432, 35.53, 48.4 }, -- lier la pierre de foyer
    { "accept", 1339 }, -- Mountaineer Stormpike's Task (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 298 }, -- Excavation Progress Report (lvl 15, ~270 xp, sim lvl 12)
    { "turnin", 298, xp = 270 }, -- Excavation Progress Report (lvl 15, ~270 xp, sim lvl 12)
    { "accept", 301 }, -- Report to Ironforge (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 6387 }, -- Honor Students (lvl 10, ~210 xp, sim lvl 12)
    { "turnin", 6387, xp = 210 }, -- Honor Students (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 6391 }, -- Ride to Ironforge (lvl 10, ~420 xp, sim lvl 12)
    { "turnin", 1339, xp = 540 }, -- Mountaineer Stormpike's Task (lvl 15, ~540 xp, sim lvl 12)
    { "accept", 307 }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "accept", 1338 }, -- Stormpike's Order (lvl 14, ~980 xp, sim lvl 12)
    { "complete", 307, at = { 1432, 35.5, 24.64 } }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "complete", 416, at = { 1432, 36.76, 22.21 } }, -- Rat Catching (lvl 11, ~880 xp, sim lvl 12)
    { "turnin", 307, xp = 1350 }, -- Filthy Paws (lvl 15, ~1350 xp, sim lvl 12)
    { "turnin", 301, xp = 540 }, -- Report to Ironforge (lvl 15, ~540 xp, sim lvl 12)
    { "note", "The Hall of Thanes is under Ironforge (levels 13-18): run it on this visit, or abandon Old Ironforge Incursion", optional = true, dungeon = "The Hall of Thanes" },
    { "accept", 302 }, -- Powder to Ironband (lvl 15, ~270 xp, sim lvl 12)
    { "turnin", 6391, xp = 420 }, -- Ride to Ironforge (lvl 10, ~420 xp, sim lvl 12)
    { "accept", 1715, classes = { "WARLOCK" } }, -- The Slaughtered Lamb (lvl 10, ~420 xp, sim lvl 12)
    { "accept", 5639, race = { "Dwarf" }, classes = { "PRIEST" } }, -- Desperate Prayer (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 2999, race = { "Dwarf" }, classes = { "PALADIN" } }, -- Tome of Divinity (lvl 12, ~90 xp, sim lvl 12)
    { "turnin", 2999, xp = 90, race = { "Dwarf" }, classes = { "PALADIN" } }, -- Tome of Divinity (lvl 12, ~90 xp, sim lvl 12)
    { "accept", 6388 }, -- Gryth Thurden (lvl 10, ~210 xp, sim lvl 12)
    { "turnin", 6388, xp = 210 }, -- Gryth Thurden (lvl 10, ~210 xp, sim lvl 12)
    { "accept", 6392 }, -- Return to Brock (lvl 10, ~1050 xp, sim lvl 12)
    { "accept", 2039 }, -- Find Bingles (lvl 15, ~270 xp, sim lvl 12)
    { "goto", 1455, 55.5, 47.74, note = "Flight master" }, -- déplacement
    { "fly", 1432, node = 8, note = "Thelsamar, Loch Modan" }, -- vol
    { "turnin", 416, xp = 880 }, -- Rat Catching (lvl 11, ~880 xp, sim lvl 12)
    { "turnin", 6392, xp = 1050 }, -- Return to Brock (lvl 10, ~1050 xp, sim lvl 12)
    { "turnin", 302, xp = 270 }, -- Powder to Ironband (lvl 15, ~270 xp, sim lvl 12)
    { "accept", 273 }, -- Resupplying the Excavation (lvl 15, ~270 xp, sim lvl 13)
    { "accept", 224 }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 13)
    { "complete", 224, at = { 1432, 31.8, 73.61 } }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 13)
    { "turnin", 224, xp = 910 }, -- In Defense of the King's Lands (lvl 12, ~910 xp, sim lvl 13)
    { "accept", 237 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
    { "complete", 237, at = { 1432, 35.7, 85.02 } }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
    { "turnin", 237, xp = 1050 }, -- In Defense of the King's Lands (lvl 15, ~1050 xp, sim lvl 13)
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
    { "turnin", 2039, xp = 270 }, -- Find Bingles (lvl 15, ~270 xp, sim lvl 13)
    { "complete", 86758, at = { 1432, 63.89, 47.82 } }, -- Twisting the Knife (lvl 16, ~1150 xp, sim lvl 13)
    { "turnin", 86758, xp = 1150 }, -- Twisting the Knife (lvl 16, ~1150 xp, sim lvl 14)
    { "hearth", 1432 }, -- pierre de foyer
    { "goto", 1432, 33.94, 50.95, note = "Flight master" }, -- déplacement
    { "fly", 1455, node = 6, note = "Ironforge, Dun Morogh" }, -- vol
    { "boat", 1455, 78, 51.4, note = "Take the Deeprun Tram to Stormwind" }, -- bateau
    { "turnin", 1338, xp = 980 }, -- Stormpike's Order (lvl 14, ~980 xp, sim lvl 14)
    { "turnin", 1715, xp = 420, classes = { "WARLOCK" } }, -- The Slaughtered Lamb (lvl 10, ~420 xp, sim lvl 14)
    { "turnin", 5639, xp = 210, race = { "Dwarf" }, classes = { "PRIEST" } }, -- Desperate Prayer (lvl 10, ~210 xp, sim lvl 14)
  },
})
