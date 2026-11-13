local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 82 étapes, niveau final 40.07, ~43520 xp/h, 127 min.
Q:RegisterGuide({
  id = "AD_18",
  title = "Dustwallow Marsh",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 38, maxLevel = 40,
  next = "AD_19",
  sim = { steps = 82, endLevel = 40.07, xpPerHour = 43520, minutes = 127 },
  steps = {
    { "hearth", 1431 }, -- pierre de foyer
    { "goto", 1431, 77.49, 44.29, note = "Flight master" }, -- déplacement
    { "fly", 1434, node = 19, note = "Booty Bay, Stranglethorn" }, -- vol
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 32, note = "Theramore, Dustwallow Marsh" }, -- vol
    { "accept", 1282 }, -- They Call Him Smiling Jim (lvl 35, ~275 xp, sim lvl 39)
    { "accept", 1204 }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 39)
    { "sethearth", 1445, 66.59, 45.22 }, -- lier la pierre de foyer
    { "accept", 98233 }, -- Sword in the Slime (lvl 42, ~3450 xp, sim lvl 39)
    { "turnin", 1282, xp = 275 }, -- They Call Him Smiling Jim (lvl 35, ~275 xp, sim lvl 39)
    { "accept", 7070, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- Shadowshard Fragments (lvl 42, ~0 xp, sim lvl 39)
    { "complete", 1204, at = { 1445, 58.35, 50.98 } }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 39)
    { "complete", 98233, at = { 1445, 53.2, 54.08 } }, -- Sword in the Slime (lvl 42, ~3450 xp, sim lvl 39)
    { "accept", 1253 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 39)
    { "accept", 1252 }, -- Lieutenant Paval Reethe (lvl 40, ~780 xp, sim lvl 39)
    { "accept", 1284 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 39)
    { "accept", 1219 }, -- The Orc Report (lvl 35, ~690 xp, sim lvl 39)
    { "accept", 81570 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 39)
    { "turnin", 81570, xp = 1350 }, -- Jarl Needs a Blade (lvl 35, ~1350 xp, sim lvl 39)
    { "turnin", 1219, xp = 690 }, -- The Orc Report (lvl 35, ~690 xp, sim lvl 39)
    { "accept", 1220 }, -- Captain Vimes (lvl 35, ~2750 xp, sim lvl 39)
    { "turnin", 1220, xp = 2750 }, -- Captain Vimes (lvl 35, ~2750 xp, sim lvl 39)
    { "turnin", 1252, xp = 780 }, -- Lieutenant Paval Reethe (lvl 40, ~780 xp, sim lvl 39)
    { "turnin", 1253, xp = 690 }, -- The Black Shield (lvl 35, ~690 xp, sim lvl 39)
    { "accept", 1259 }, -- Lieutenant Paval Reethe (lvl 40, ~315 xp, sim lvl 39)
    { "turnin", 1259, xp = 315 }, -- Lieutenant Paval Reethe (lvl 40, ~315 xp, sim lvl 39)
    { "accept", 1285 }, -- Daelin's Men (lvl 38, ~285 xp, sim lvl 39)
    { "accept", 1319 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 39)
    { "turnin", 1285, xp = 285 }, -- Daelin's Men (lvl 38, ~285 xp, sim lvl 39)
    { "accept", 1286 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 39)
    { "turnin", 1284, xp = 1350 }, -- Suspicious Hoofprints (lvl 35, ~1350 xp, sim lvl 39)
    { "turnin", 1204, xp = 2850 }, -- Mudrock Soup and Bugs (lvl 38, ~2850 xp, sim lvl 39)
    { "turnin", 98233, xp = 3450 }, -- Sword in the Slime (lvl 42, ~3450 xp, sim lvl 39)
    { "goto", 1445, 67.48, 51.3, note = "Flight master" }, -- déplacement
    { "fly", 1443, node = 37, note = "Nijel's Point, Desolace" }, -- vol
    { "accept", 92841 }, -- Valley of Bones (lvl 40, ~315 xp, sim lvl 39)
    { "accept", 92743 }, -- A Conqueror's Crown (lvl 40, ~3150 xp, sim lvl 39)
    { "turnin", 92743, xp = 3150 }, -- A Conqueror's Crown (lvl 40, ~3150 xp, sim lvl 39)
    { "accept", 93224 }, -- Carved Centaur Totems (lvl 40, ~2350 xp, sim lvl 39)
    { "accept", 1387 }, -- Centaur Bounty (lvl 31, ~1500 xp, sim lvl 39)
    { "accept", 261 }, -- Down the Scarlet Path (lvl 39, ~3000 xp, sim lvl 39)
    { "accept", 94841 }, -- Lost Shipping Crate (lvl 38, ~0 xp, sim lvl 39)
    { "turnin", 93464, xp = 1450 }, -- The Visiting Mage (lvl 38, ~1450 xp, sim lvl 39)
    { "accept", 79229 }, -- Highway Robbery (lvl 40, ~1550 xp, sim lvl 39)
    { "accept", 6134 }, -- Ghost-o-plasm Round Up (lvl 39, ~2250 xp, sim lvl 39)
    { "complete", 1387, at = { 1443, 66.62, 78.25 } }, -- Centaur Bounty (lvl 31, ~1500 xp, sim lvl 39)
    { "complete", 93224, at = { 1443, 68.3, 78.18 } }, -- Carved Centaur Totems (lvl 40, ~2350 xp, sim lvl 39)
    { "accept", 92893 }, -- No Mercy for the Weak (lvl 42, ~2550 xp, sim lvl 39)
    { "accept", 92844 }, -- Mountain of Bones (lvl 42, ~3450 xp, sim lvl 39)
    { "accept", 92846 }, -- Outcast Necromancers (lvl 40, ~2350 xp, sim lvl 39)
    { "turnin", 92846, xp = 2350 }, -- Outcast Necromancers (lvl 40, ~2350 xp, sim lvl 39)
    { "accept", 92894 }, -- Bone Raising (lvl 40, ~2350 xp, sim lvl 39)
    { "turnin", 92893, xp = 2550 }, -- No Mercy for the Weak (lvl 42, ~2550 xp, sim lvl 39)
    { "accept", 92847 }, -- Corrupting Tears (lvl 42, ~3450 xp, sim lvl 39)
    { "turnin", 92894, xp = 2350 }, -- Bone Raising (lvl 40, ~2350 xp, sim lvl 39)
    { "accept", 92873 }, -- Proof of Concept (lvl 41, ~2450 xp, sim lvl 39)
    { "turnin", 92847, xp = 3450 }, -- Corrupting Tears (lvl 42, ~3450 xp, sim lvl 39)
    { "accept", 93196 }, -- Khan Jehn (lvl 42, ~3450 xp, sim lvl 39)
    { "turnin", 92873, xp = 2450 }, -- Proof of Concept (lvl 41, ~2450 xp, sim lvl 39)
    { "turnin", 92841, xp = 315 }, -- Valley of Bones (lvl 40, ~315 xp, sim lvl 39)
    { "turnin", 92844, xp = 3450 }, -- Mountain of Bones (lvl 42, ~3450 xp, sim lvl 39)
    { "complete", 261, at = { 1443, 63.98, 89.83 } }, -- Down the Scarlet Path (lvl 39, ~3000 xp, sim lvl 39)
    { "complete", 6134, at = { 1443, 64.18, 91.63 } }, -- Ghost-o-plasm Round Up (lvl 39, ~2250 xp, sim lvl 39)
    { "accept", 7067, optional = true, dungeon = "Maraudon", phase = "prep", rung = "MARAUDON" }, -- The Pariah's Instructions (lvl 48, ~0 xp, sim lvl 39)
    { "turnin", 6134, xp = 2250 }, -- Ghost-o-plasm Round Up (lvl 39, ~2250 xp, sim lvl 39)
    { "turnin", 79229, xp = 1550 }, -- Highway Robbery (lvl 40, ~1550 xp, sim lvl 39)
    { "turnin", 261, xp = 3000 }, -- Down the Scarlet Path (lvl 39, ~3000 xp, sim lvl 39)
    { "turnin", 1387, xp = 1500 }, -- Centaur Bounty (lvl 31, ~1500 xp, sim lvl 39)
    { "turnin", 93224, xp = 2350 }, -- Carved Centaur Totems (lvl 40, ~2350 xp, sim lvl 39)
    { "turnin", 93196, xp = 3450 }, -- Khan Jehn (lvl 42, ~3450 xp, sim lvl 39)
    { "hearth", 1445 }, -- pierre de foyer
    { "turnin", 1286, xp = 2850 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 39)
    { "accept", 1287 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "accept", 2846, optional = true, dungeon = "Zul'Farrak", phase = "prep", rung = "ZF" }, -- Tiara of the Deep (lvl 46, ~0 xp, sim lvl 40)
    { "turnin", 1319, xp = 275 }, -- The Black Shield (lvl 35, ~275 xp, sim lvl 40)
    { "accept", 1320 }, -- The Black Shield (lvl 35, ~1350 xp, sim lvl 40)
    { "turnin", 1320, xp = 1350 }, -- The Black Shield (lvl 35, ~1350 xp, sim lvl 40)
    { "turnin", 1287, xp = 2850 }, -- The Deserters (lvl 38, ~2850 xp, sim lvl 40)
    { "goto", 1413, 49, 93.9, optional = true, dungeon = "Razorfen Downs", note = "Dungeon: Razorfen Downs (5 players). No group? Skip the instance in /qf dungeons", phase = "run", rung = "RFD" }, -- déplacement
    { "complete", 96773, optional = true, dungeon = "Razorfen Downs", phase = "run", rung = "RFD" }, -- The Coldbringer's Eye (lvl 41, ~1650 xp, sim lvl 40)
    { "turnin", 96773, xp = 1650, optional = true, dungeon = "Razorfen Downs", phase = "run", rung = "RFD" }, -- The Coldbringer's Eye (lvl 41, ~1650 xp, sim lvl 40)
  },
})
