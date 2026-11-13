-- tools/routebuilder/dungeon_ladder.lua : échelle du mode « Donjons » (Alliance, 1-60).
--
-- Un échelon = un donjon 5 joueurs ou une aile. Écrit à la main ; build_dungeon_route.lua en tire
-- Questify/Guides/DungeonRouteData.lua (cases à cocher et étoiles de l'addon) et docs/dungeon-mode/ECHELLE.md.
-- Les guides Alliance et Horde existants ne lisent pas ce fichier.
--
-- Champs d'un échelon :
--   key      clé stable (sauvegardes de l'addon, champ `rung` des étapes des routes)
--   dungeon  clé de Questify/Guides/DungeonData.lua (les ailes partagent le donjon)
--   wing     nom de l'aile (anglais, comme les noms de QuestieDB), nil pour un donjon entier
--   min, max plage de l'aile, seulement quand elle diffère de celle du donjon (à vérifier en jeu)
--   quests   quêtes de l'aile : obligatoire pour une aile (QuestieDB ne connaît que le donjon entier),
--            nil pour un donjon entier (toutes ses quêtes Alliance de DungeonData.lua)
--   entry    niveau d'entrée imposé, avec entryWhy ; sinon min + ENTRY_OFFSET plafonné à ENTRY_CAP
--   before   zones jouées avant l'échelon : { zone, from, to, role } ; role = "prep" (suites et quêtes
--            d'accès du donjon), "zone" (zone vidée : suites puis quêtes à accès direct)
--   alt      alternative en extérieur quand la case est décochée ou l'instance contournée
--   races    départs concernés quand l'échelon ou un bloc ne vaut pas pour tous
--   verify   points à vérifier en jeu
--
--   skip     { [questId] = "raison" } : quêtes du donjon laissées hors route (hors étoiles)
--
-- Les niveaux des zones viennent de la répartition des niveaux de quêtes Alliance de QuestieDB par zone
-- (1er décile - 9e décile, tableau de docs/dungeon-mode/README.md) ; aucune coordonnée ici.
local L = {}

L.ENTRY_OFFSET = 2   -- niveau d'entrée = bas de la plage + 2 : ni rouge-orange à l'entrée, ni vert au fond
L.ENTRY_CAP = 58     -- les derniers échelons restent dans la montée de niveau
-- Étoiles : part d'un niveau que donnent les quêtes de l'échelon (XP de base, déjà divisée par deux
-- en donjon par Forever), au niveau d'entrée. Voir docs/dungeon-mode/README.md.
L.STARS = { { min = 0.30, stars = 3 }, { min = 0.12, stars = 2 }, { min = 0, stars = 1 } }

-- Départs par race, avant la convergence à Stormwind (niveau 15).
L.starts = {
  { races = { "Human" }, blocks = {
      { zone = "Northshire Valley", from = 1, to = 6 }, { zone = "Elwynn Forest", from = 6, to = 11 },
      { zone = "Westfall", from = 11, to = 15, note = "première moitié ; la suite après The Hall of Thanes" } } },
  { races = { "Dwarf", "Gnome" }, blocks = {
      { zone = "Coldridge Valley", from = 1, to = 6 },
      { zone = "Dun Morogh", from = 6, to = 11, note = "avec la suite d'accès de The Hall of Thanes (96391, 96392)" },
      { zone = "Loch Modan", from = 11, to = 15 } },
    note = "The Hall of Thanes se fait à Ironforge avant de prendre le tram pour Stormwind" },
  { races = { "NightElf" }, blocks = {
      { zone = "Shadowglen", from = 1, to = 6 }, { zone = "Teldrassil", from = 6, to = 11 },
      { zone = "Darkshore", from = 11, to = 15, note = "première moitié ; bateau d'Auberdine à Stormwind" } } },
}

L.rungs = {
  { key = "THANES", dungeon = "THANES",
    before = { { zone = "Ironforge", from = 15, to = 15, role = "prep" } },
    alt = { zone = "Loch Modan", from = 14, to = 17 },
    verify = { "plage 13-18 annoncée par Blizzard", "accès de 96393 par la suite de Dun Morogh pour les Humains et les Elfes de la nuit" } },
  { key = "DM", dungeon = "DM",
    before = { { zone = "Stormwind City", from = 15, to = 16, role = "prep" },
               { zone = "Westfall", from = 15, to = 19, role = "zone" } },
    alt = { zone = "Redridge Mountains", from = 17, to = 20 } },
  { key = "WC", dungeon = "WC",
    before = { { zone = "Darkshore", from = 19, to = 21, role = "zone" },
               { zone = "The Barrens", from = 19, to = 21, role = "prep" } },
    alt = { zone = "Redridge Mountains", from = 19, to = 22 },
    verify = { "accès Alliance par Ashenvale puis les Tarides à pied (zone Horde)",
               "les 4 quêtes de ville se prennent à Ratchet et à l'entrée de la caverne" } },
  { key = "STOCKADE", dungeon = "STOCKADE",
    before = { { zone = "Redridge Mountains", from = 21, to = 24, role = "zone" },
               { zone = "Duskwood", from = 24, to = 26, role = "zone" },
               { zone = "Stormwind City", from = 26, to = 26, role = "prep" } },
    alt = { zone = "Duskwood", from = 26, to = 28 },
    verify = { "The Fury Runs Deep (378) : suite des Paluns (303), prise au passage de l'échelon Excavation" } },
  { key = "BFD", dungeon = "BFD",
    before = { { zone = "Ashenvale", from = 24, to = 27, role = "zone" } },
    alt = { zone = "Stonetalon Mountains", from = 24, to = 27 } },
  { key = "EXCAVATION", dungeon = "EXCAVATION",
    before = { { zone = "Wetlands", from = 24, to = 28, role = "zone" } },
    alt = { zone = "Wetlands", from = 26, to = 29 },
    verify = { "plage 24-29 annoncée, quêtes de niveau 28-31 : niveau d'entrée à confirmer" } },
  { key = "SFK", dungeon = "SFK", entry = 27,
    entryWhy = "aucune quête Alliance ; joué au passage de Southshore plutôt qu'à 24 par un aller-retour",
    before = { { zone = "Hillsbrad Foothills", from = 26, to = 28, role = "zone" } },
    alt = { zone = "Hillsbrad Foothills", from = 27, to = 29 },
    verify = { "long trajet de Southshore à la forêt des Pins-Argentés", "aucune quête Alliance dans QuestieDB" } },
  { key = "DALARAN", dungeon = "DALARAN",
    before = { { zone = "Duskwood", from = 27, to = 30, role = "zone" },
               { zone = "Alterac Mountains", from = 30, to = 30, role = "prep" } },
    alt = { zone = "Hillsbrad Foothills", from = 29, to = 32 },
    verify = { "plage 28-33 annoncée, quêtes de niveau 33" } },
  { key = "SM_GY", dungeon = "SM", wing = "Graveyard", min = 28, max = 38, quests = {},
    before = { { zone = "Hillsbrad Foothills", from = 29, to = 31, role = "zone" } },
    alt = { zone = "Thousand Needles", from = 29, to = 32 },
    verify = { "plage de l'aile", "aucune quête Alliance ne vise le Cimetière" } },
  { key = "GNOMER", dungeon = "GNOMER",
    before = { { zone = "Ironforge", from = 30, to = 31, role = "prep" } },
    alt = { zone = "Thousand Needles", from = 30, to = 33 } },
  { key = "SM_LIB", dungeon = "SM", wing = "Library", min = 29, max = 39, quests = { 1050, 96800 },
    before = { { zone = "Ironforge", from = 31, to = 31, role = "prep" } },
    alt = { zone = "Arathi Highlands", from = 31, to = 34 },
    verify = { "plage de l'aile", "Past Due (96800) : livre « The Lost Magic of the Runemasters », aile à confirmer" } },
  { key = "RFK", dungeon = "RFK",
    before = { { zone = "Thousand Needles", from = 29, to = 32, role = "zone" } },
    alt = { zone = "Stranglethorn Vale", from = 31, to = 34 },
    verify = { "The Crone of the Kraul (1101) : niveau requis 29, suite 1100" } },
  { key = "SM_ARM", dungeon = "SM", wing = "Armory", min = 32, max = 42, quests = {},
    before = { { zone = "Arathi Highlands", from = 32, to = 35, role = "zone" } },
    alt = { zone = "Desolace", from = 33, to = 36 },
    verify = { "plage de l'aile", "Herod (In the Name of the Light, 1053) est compté avec la Cathédrale" } },
  { key = "SM_CATH", dungeon = "SM", wing = "Cathedral", min = 35, max = 45, quests = { 1052, 1053 },
    before = { { zone = "Desolace", from = 34, to = 37, role = "prep" },
               { zone = "Stranglethorn Vale", from = 35, to = 37, role = "zone" } },
    alt = { zone = "Alterac Mountains", from = 36, to = 39 },
    verify = { "plage de l'aile", "In the Name of the Light (1053) : Loksey (Bibliothèque), Herod (Armurerie), Mograine et Whitemane (Cathédrale) ; rendue après la Cathédrale" } },
  { key = "ULDAMAN", dungeon = "ULDAMAN",
    before = { { zone = "Badlands", from = 37, to = 39, role = "prep" },
               { zone = "Loch Modan", from = 38, to = 38, role = "prep" } },
    alt = { zone = "Riverglades", from = 38, to = 41 } },
  { key = "RFD", dungeon = "RFD",
    before = { { zone = "Dustwallow Marsh", from = 36, to = 39, role = "zone" } },
    alt = { zone = "Shen'dralas", from = 38, to = 42 } },
  { key = "MARAUDON", dungeon = "MARAUDON",
    before = { { zone = "Riverglades", from = 39, to = 43, role = "zone" },
               { zone = "Desolace", from = 42, to = 44, role = "prep" } },
    alt = { zone = "Swamp of Sorrows", from = 40, to = 44 },
    verify = { "Maraudon en un seul échelon (une seule zone 2100 dans QuestieDB) : parties orange, violette et intérieure à distinguer en jeu si besoin" } },
  { key = "ZF", dungeon = "ZF",
    before = { { zone = "Feralas", from = 43, to = 46, role = "zone" },
               { zone = "Tanaris", from = 45, to = 46, role = "prep" } },
    alt = { zone = "The Hinterlands", from = 44, to = 48 } },
  { key = "ST", dungeon = "ST",
    before = { { zone = "The Hinterlands", from = 46, to = 49, role = "prep" },
               { zone = "Searing Gorge", from = 48, to = 50, role = "zone" },
               { zone = "Tanaris", from = 49, to = 52, role = "zone" } },
    alt = { zone = "Azshara", from = 49, to = 53 },
    skip = { [8733] = "niveau requis 60" } },
  { key = "BRD", dungeon = "BRD",
    before = { { zone = "Un'Goro Crater", from = 52, to = 54, role = "zone" },
               { zone = "Burning Steppes", from = 53, to = 54, role = "prep" } },
    alt = { zone = "Felwood", from = 53, to = 56 },
    skip = { [9015] = "niveau requis 58, suite de l'ensemble de donjon" } },
  { key = "DM_EAST", dungeon = "DIREMAUL", wing = "East", min = 55, max = 60, quests = { 7441, 7488, 7494 },
    before = { { zone = "Felwood", from = 54, to = 56, role = "zone" },
               { zone = "Feralas", from = 56, to = 57, role = "prep" } },
    alt = { zone = "Western Plaguelands", from = 55, to = 58 },
    verify = { "plage de l'aile", "Pusillin et Lethtendris : aile Est" } },
  { key = "SCHOLO", dungeon = "SCHOLO",
    before = { { zone = "Western Plaguelands", from = 55, to = 57, role = "zone" } },
    alt = { zone = "Winterspring", from = 56, to = 59 } },
  { key = "DM_WEST", dungeon = "DIREMAUL", wing = "West", min = 56, max = 60, quests = { 7482 },
    before = { { zone = "Feralas", from = 58, to = 58, role = "prep" } },
    alt = { zone = "Winterspring", from = 57, to = 60 },
    verify = { "plage de l'aile", "Elven Legends (7482, restes de Telmius Dreamseeker) : aile Ouest" } },
  { key = "DM_NORTH", dungeon = "DIREMAUL", wing = "North", min = 56, max = 60, quests = { 8948 },
    before = { { zone = "Feralas", from = 58, to = 58, role = "prep" } },
    alt = { zone = "Mount Hyjal", from = 57, to = 60 },
    verify = { "plage de l'aile", "Anthion's Old Friend (8948, bibliothèque de Hache-Tripes) : niveau requis 58, suite 8947 ; aile à confirmer" } },
  { key = "STRAT_LIVE", dungeon = "STRAT", wing = "Live", quests = { 5214, 5243, 5251, 5262, 5281, 5282, 5846, 5848 },
    before = { { zone = "Eastern Plaguelands", from = 57, to = 59, role = "zone" } },
    alt = { zone = "Silithus", from = 58, to = 60 },
    verify = { "répartition des quêtes entre les deux côtés de Stratholme" } },
  { key = "STRAT_UD", dungeon = "STRAT", wing = "Undead", quests = { 5212, 5213, 5263, 5462, 5463, 8929, 8945 },
    before = { { zone = "Eastern Plaguelands", from = 58, to = 60, role = "prep" } },
    alt = { zone = "Silithus", from = 58, to = 60 },
    verify = { "répartition des quêtes entre les deux côtés de Stratholme",
               "Dead Man's Plea (8945) : niveau requis 58, suite 8929 à huit préquêtes, facultative" } },
}

-- Contenu écarté, avec la raison (repris dans le plan écrit).
L.omitted = {
  { name = "Ragefire Chasm", why = "entrée à Orgrimmar, aucune quête Alliance dans QuestieDB : Horde seulement" },
  { name = "Ruins of Lordaeron", why = "entrée à Undercity, aucune quête Alliance dans QuestieDB : Horde seulement" },
  { name = "Lower Blackrock Spire", why = "hors route à la demande ; QuestieDB ne sépare pas le bas du haut du Pic (zone 1583)" },
  { name = "Upper Blackrock Spire", why = "raid de 10, pas un donjon 5 joueurs" },
  { name = "Raids (Molten Core, Onyxia, Zul'Gurub, Ahn'Qiraj, Naxxramas)", why = "pas des donjons 5 joueurs" },
}

return L
