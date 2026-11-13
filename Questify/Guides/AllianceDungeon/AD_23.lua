local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer
-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-13.
-- Simulation : 69 étapes, niveau final 47.00, ~50651 xp/h, 146 min.
Q:RegisterGuide({
  id = "AD_23",
  title = "Tanaris",
  faction = "Alliance",
  mode = "dungeon",
  minLevel = 45, maxLevel = 47,
  next = "AD_24",
  sim = { steps = 69, endLevel = 47.00, xpPerHour = 50651, minutes = 146 },
  steps = {
    { "hearth", 1445 }, -- pierre de foyer
    { "accept", 2770, optional = true, dungeon = "Zul'Farrak", phase = "prep", rung = "ZF" }, -- Gahz'rilla (lvl 50, ~0 xp, sim lvl 46)
    { "fp", 1446, 51.01, 29.34 }, -- point de vol
    { "accept", 97536 }, -- Gnomish Garbage (lvl 45, ~2900 xp, sim lvl 46)
    { "turnin", 97536, xp = 2900 }, -- Gnomish Garbage (lvl 45, ~2900 xp, sim lvl 46)
    { "accept", 2781 }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 46)
    { "accept", 2875 }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 95321 }, -- Tazzik's Dues (lvl 40, ~2520 xp, sim lvl 46)
    { "accept", 2865, optional = true, dungeon = "Zul'Farrak", phase = "prep", rung = "ZF" }, -- Scarab Shells (lvl 45, ~0 xp, sim lvl 46)
    { "accept", 1690 }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 46)
    { "accept", 2768, optional = true, dungeon = "Zul'Farrak", phase = "prep", rung = "ZF" }, -- Divino-matic Rod (lvl 47, ~0 xp, sim lvl 46)
    { "accept", 1707 }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 46)
    { "sethearth", 1446, 52.51, 27.91 }, -- lier la pierre de foyer
    { "accept", 8365 }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 95383 }, -- Shipping and Handling (lvl 40, ~250 xp, sim lvl 46)
    { "turnin", 95383, xp = 250 }, -- Shipping and Handling (lvl 40, ~250 xp, sim lvl 46)
    { "accept", 97530 }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 46)
    { "accept", 8366 }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 2873 }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 95312 }, -- Coming to Collect (lvl 40, ~250 xp, sim lvl 46)
    { "complete", 1690, at = { 1446, 63.5, 29.99 } }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 46)
    { "complete", 1707, at = { 1446, 62.85, 33.86 } }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 46)
    { "turnin", 1690, xp = 3600 }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 46)
    { "accept", 1691 }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 46)
    { "turnin", 1707, xp = 2800 }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 46)
    { "accept", 3042, optional = true, dungeon = "Zul'Farrak", phase = "prep", rung = "ZF" }, -- Troll Temper (lvl 45, ~0 xp, sim lvl 46)
    { "turnin", 95312, xp = 250 }, -- Coming to Collect (lvl 40, ~250 xp, sim lvl 46)
    { "accept", 992 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "complete", 992, at = { 1446, 39, 29 } }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "turnin", 992, xp = 3050 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 46)
    { "accept", 82 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 82, at = { 1446, 31.97, 45.08 } }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "complete", 97530, at = { 1446, 39.24, 52.74 } }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 46)
    { "accept", 95753 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 95753, at = { 1446, 45.73, 37.76 } }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "turnin", 95753, xp = 3900 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 2781, at = { 1446, 61.77, 38.17 } }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 46)
    { "complete", 1691, at = { 1446, 63.75, 38.86 } }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 46)
    { "complete", 2873, at = { 1446, 72.15, 46.77 } }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 8366, at = { 1446, 73.04, 47.24 } }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 2875, at = { 1446, 73.37, 47.14 } }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 8365, at = { 1446, 73.86, 47.21 } }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 81949 }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "complete", 81949, at = { 1446, 72.6, 47.8 } }, -- Legends of the Tidesages (lvl 45, ~0 xp, sim lvl 46)
    { "complete", 8366, at = { 1446, 75.27, 45.64 } }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 46)
    { "complete", 95321, at = { 1446, 67.35, 23.98 } }, -- Tazzik's Dues (lvl 40, ~2520 xp, sim lvl 46)
    { "turnin", 95321, xp = 2520 }, -- Tazzik's Dues (lvl 40, ~2520 xp, sim lvl 46)
    { "turnin", 2873, xp = 3900 }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 46)
    { "accept", 2874 }, -- Deliver to MacKinley (lvl 45, ~0 xp, sim lvl 46)
    { "turnin", 2875, xp = 3900 }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 46)
    { "turnin", 97530, xp = 4200 }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 46)
    { "turnin", 8366, xp = 3900 }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 46)
    { "turnin", 8365, xp = 3900 }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 46)
    { "hearth", 1446 }, -- pierre de foyer
    { "turnin", 1691, xp = 3750 }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 46)
    { "turnin", 2781, xp = 5050 }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 46)
    { "turnin", 82, xp = 3150 }, -- Noxious Lair Investigation (lvl 47, ~3150 xp, sim lvl 46)
    { "level", 47, at = { 1446, 67.35, 23.98 }, note = "About 116 more mobs near the last objective" }, -- farm de niveau
    { "goto", 1446, 38.7, 20.1, optional = true, dungeon = "Zul'Farrak", note = "Dungeon: Zul'Farrak (5 players). No group? Untick it in /qf dungeons", phase = "run", rung = "ZF" }, -- déplacement
    { "complete", 2768, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Divino-matic Rod (lvl 47, ~3150 xp, sim lvl 47)
    { "complete", 2770, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Gahz'rilla (lvl 50, ~3550 xp, sim lvl 47)
    { "complete", 2846, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Tiara of the Deep (lvl 46, ~3025 xp, sim lvl 47)
    { "complete", 2865, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Scarab Shells (lvl 45, ~1950 xp, sim lvl 47)
    { "complete", 3042, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Troll Temper (lvl 45, ~1950 xp, sim lvl 47)
    { "turnin", 2770, xp = 3550, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Gahz'rilla (lvl 50, ~3550 xp, sim lvl 47)
    { "turnin", 2768, xp = 3150, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Divino-matic Rod (lvl 47, ~3150 xp, sim lvl 47)
    { "turnin", 2865, xp = 1950, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Scarab Shells (lvl 45, ~1950 xp, sim lvl 47)
    { "turnin", 3042, xp = 1950, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Troll Temper (lvl 45, ~1950 xp, sim lvl 47)
    { "turnin", 2846, xp = 3025, optional = true, dungeon = "Zul'Farrak", phase = "run", rung = "ZF" }, -- Tiara of the Deep (lvl 46, ~3025 xp, sim lvl 47)
  },
})
