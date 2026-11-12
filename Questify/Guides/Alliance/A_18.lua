local addonName, Q = ...
-- Généré par tools/routebuilder (générateur de routes de Questify). Ne pas modifier à la main :
-- corriger tools/routebuilder/plans.lua ou overrides.lua, puis relancer tools/routebuilder/build.lua.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-12.
-- Simulation : 58 étapes, niveau final 45.00, ~50693 xp/h, 132 min.
Q:RegisterGuide({
  id = "A_18",
  title = "Tanaris",
  faction = "Alliance",
  minLevel = 44, maxLevel = 45,
  next = "A_19",
  sim = { steps = 58, endLevel = 45.00, xpPerHour = 50693, minutes = 132 },
  steps = {
    { "note", "Not running Uldaman? Abandon Solution to Doom", optional = true, dungeon = "Uldaman" },
    { "hearth", 1434 }, -- pierre de foyer
    { "boat", 1434, 26.08, 73.35, note = "Take the boat to Ratchet (The Barrens)" }, -- bateau
    { "goto", 1413, 63.08, 37.16, note = "Flight master" }, -- déplacement
    { "fly", 1445, node = 32, note = "Theramore, Dustwallow Marsh" }, -- vol
    { "fp", 1446, 51.01, 29.34 }, -- point de vol
    { "accept", 3042, optional = true, dungeon = "Zul'Farrak" }, -- Troll Temper (lvl 45, ~0 xp, sim lvl 44)
    { "accept", 1690 }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 44)
    { "accept", 1707 }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 44)
    { "sethearth", 1446, 52.51, 27.91 }, -- lier la pierre de foyer
    { "accept", 8365 }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 44)
    { "accept", 95383 }, -- Shipping and Handling (lvl 40, ~315 xp, sim lvl 44)
    { "turnin", 2872, xp = 390 }, -- Stoley's Debt (lvl 45, ~390 xp, sim lvl 44)
    { "turnin", 95383, xp = 315 }, -- Shipping and Handling (lvl 40, ~315 xp, sim lvl 44)
    { "accept", 97530 }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 44)
    { "accept", 8366 }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 44)
    { "accept", 2873 }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 44)
    { "accept", 95312 }, -- Coming to Collect (lvl 40, ~315 xp, sim lvl 44)
    { "complete", 1690, at = { 1446, 63.5, 29.99 } }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 44)
    { "complete", 1707, at = { 1446, 62.85, 33.86 } }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 44)
    { "turnin", 1690, xp = 3600 }, -- Wastewander Justice (lvl 43, ~3600 xp, sim lvl 44)
    { "accept", 1691 }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 44)
    { "turnin", 1707, xp = 2800 }, -- Water Pouch Bounty (lvl 44, ~2800 xp, sim lvl 44)
    { "accept", 97536 }, -- Gnomish Garbage (lvl 45, ~2900 xp, sim lvl 44)
    { "turnin", 97536, xp = 2900 }, -- Gnomish Garbage (lvl 45, ~2900 xp, sim lvl 44)
    { "accept", 2875 }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 44)
    { "accept", 2781 }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 44)
    { "accept", 95321 }, -- Tazzik's Dues (lvl 40, ~3150 xp, sim lvl 44)
    { "turnin", 95312, xp = 315 }, -- Coming to Collect (lvl 40, ~315 xp, sim lvl 44)
    { "accept", 2865, optional = true, dungeon = "Zul'Farrak" }, -- Scarab Shells (lvl 45, ~0 xp, sim lvl 44)
    { "accept", 992 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 44)
    { "complete", 992, at = { 1446, 39, 29 } }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 44)
    { "complete", 97530, at = { 1446, 39.24, 52.74 } }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 44)
    { "accept", 95753 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 95753, at = { 1446, 45.73, 37.76 } }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 44)
    { "turnin", 95753, xp = 3900 }, -- Challenge of the Desert Wolf (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 2781, at = { 1446, 61.77, 38.17 } }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 44)
    { "complete", 1691, at = { 1446, 63.75, 38.86 } }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 44)
    { "complete", 2873, at = { 1446, 72.15, 46.77 } }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 8366, at = { 1446, 73.04, 47.24 } }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 2875, at = { 1446, 73.37, 47.14 } }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 8365, at = { 1446, 73.86, 47.21 } }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 8366, at = { 1446, 75.27, 45.64 } }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 44)
    { "complete", 95321, at = { 1446, 67.35, 23.98 } }, -- Tazzik's Dues (lvl 40, ~3150 xp, sim lvl 44)
    { "turnin", 95321, xp = 3150 }, -- Tazzik's Dues (lvl 40, ~3150 xp, sim lvl 44)
    { "turnin", 2873, xp = 3900 }, -- Stoley's Shipment (lvl 45, ~3900 xp, sim lvl 44)
    { "turnin", 8366, xp = 3900 }, -- Southsea Shakedown (lvl 45, ~3900 xp, sim lvl 44)
    { "turnin", 2875, xp = 3900 }, -- WANTED: Andre Firebeard (lvl 45, ~3900 xp, sim lvl 44)
    { "turnin", 97530, xp = 4200 }, -- Dunemaul Dues (lvl 47, ~4200 xp, sim lvl 44)
    { "turnin", 8365, xp = 3900 }, -- Pirate Hats Ahoy! (lvl 45, ~3900 xp, sim lvl 44)
    { "hearth", 1446 }, -- pierre de foyer
    { "accept", 2768, optional = true, dungeon = "Zul'Farrak" }, -- Divino-matic Rod (lvl 47, ~0 xp, sim lvl 44)
    { "turnin", 1691, xp = 3750 }, -- More Wastewander Justice (lvl 44, ~3750 xp, sim lvl 44)
    { "turnin", 2781, xp = 5050 }, -- WANTED: Caliph Scorpidsting (lvl 46, ~5050 xp, sim lvl 44)
    { "turnin", 992, xp = 3050 }, -- Gadgetzan Water Survey (lvl 46, ~3050 xp, sim lvl 44)
    { "accept", 2770, optional = true, dungeon = "Zul'Farrak" }, -- Gahz'rilla (lvl 50, ~0 xp, sim lvl 44)
    { "turnin", 1183, xp = 425 }, -- Goblin Sponsorship (lvl 37, ~425 xp, sim lvl 44)
    { "level", 45, at = { 1446, 67.35, 23.98 }, note = "About 80 more mobs near the last objective" }, -- farm de niveau
  },
})
