-- tools/routebuilder/plans_dungeon.lua : chapitres du mode « Donjons » (Alliance et Horde).
--
-- Les chapitres réutilisent les réglages des chapitres habituels (plans.lua : zones, rectangles, point
-- d'entrée, points de vol, quêtes forcées ou écartées) par copie : plans.lua n'est jamais modifié et ses
-- guides ne sont pas régénérés. Chaque ligne de TRUNK donne :
--   id, base (chapitre habituel copié) ou zones + entryFrom, title, min, max,
--   run = { échelons faits en fin de chapitre }   -- le chapitre finit à l'entrée du premier quand elle est
--                                                 -- dans ses zones ; le niveau visé (max) est le niveau d'entrée
--   alt = { échelons }  -- chapitre d'alternative en extérieur : joué quand l'un de ces échelons est décoché
--                       -- ou contourné, ou tant que le personnage est sous le niveau max du chapitre
--   noLevel = true : chapitre de passage (prises de quêtes, restes d'une zone déjà faite) : aucun niveau à
--                    atteindre, donc aucun farm ; la tranche sert seulement au choix des quêtes
--   prepFor = "échelon" : chapitre qui ne sert qu'à ce donjon : toutes ses étapes sont des étapes d'accès
--                         (passées quand la case est décochée)
--   set = { champ = valeur } : réglages remplacés ; unset = { "champ", ... } : réglages retirés
--
-- Départs (1-15) : les chapitres habituels, tels quels. Ils sont simulés ici pour l'état du personnage
-- (niveau, quêtes faites, points de vol) mais ne sont pas réécrits (noEmit). En jeu, le mode prend la suite
-- du chapitre habituel nommé dans `after`. Seul l'Elfe de la nuit a un chapitre propre (Sombrivage raccourci,
-- pour rejoindre Stormwind au niveau 16 au lieu de 20).
--
-- Ordre : un échelon est toujours fait avant son chapitre d'alternative. Contrôlé par M.check.
--
-- Horde : HORDE_STARTS et HORDE_TRUNK, mêmes champs (chapitres HD_*, copies des chapitres H_* de plans.lua).
-- Les départs se rejoignent aux Tarides (HD_01) au niveau 12.
local plansm = require("plans")

local M = {}

local IRONFORGE, STORMWIND, DUN_MOROGH, REDRIDGE, DUSKWOOD = 1455, 1453, 1426, 1433, 1431
local HILLSBRAD, ALTERAC, ARATHI, WETLANDS, LOCH_MODAN = 1424, 1416, 1417, 1437, 1432
local SWAMP, WINTERSPRING = 1435, 1452
local RIVERGLADES = 2548
local ORGRIMMAR, UNDERCITY, SILVERPINE, BADLANDS, SEARING, BURNING = 1454, 1458, 1421, 1418, 1427, 1428
local GIVER_MARGIN = 2   -- demi-côté (en % de carte) du rectangle ajouté autour d'un donneur

local function deepcopy(v)
  if type(v) ~= "table" then return v end
  local o = {}
  for k, x in pairs(v) do o[k] = deepcopy(x) end
  return o
end

local function classic(id)
  for _, p in ipairs(M.classicList) do if p.id == id then return p end end
  error("unknown classic plan " .. tostring(id))
end

-- Départs habituels simulés sans être réécrits, et leur suite dans le mode.
local STARTS = {
  { id = "A_DwarfGnome_01" }, { id = "A_DwarfGnome_02" }, { id = "A_DwarfGnome_03" },
  { id = "A_DwarfGnome_04", next = "AD_01" },
  { id = "A_Human_01" }, { id = "A_Human_02" }, { id = "A_Human_03", next = "AD_01" },
  { id = "A_NightElf_01" }, { id = "A_NightElf_02", next = "AD_NightElf_03" },
  { id = "A_Skyborne_01", next = "AD_01" },
}

M.TRUNK = {
  -- Elfe de la nuit : Sombrivage jusqu'au niveau 16, puis le bateau d'Auberdine à Stormwind
  { id = "AD_NightElf_03", base = "A_NightElf_03", title = "Darkshore", min = 12, max = 16,
    after = { "A_NightElf_02" }, set = { races = { "NightElf" }, endZones = { STORMWIND } } },

  { id = "AD_01", zones = { IRONFORGE }, entryRung = "THANES", title = "Ironforge", min = 15, max = 16, noLevel = true,
    prepFor = "THANES", after = { "A_Human_03", "A_DwarfGnome_04", "A_Skyborne_01" }, run = { "THANES" } },
  { id = "AD_02", base = "A_01", title = "Darkshore", min = 16, max = 19 },
  -- Marche de l'Ouest : déjà faite par les départs Humain et Nain / Gnome ; restes et quêtes des Mortemines
  { id = "AD_03", base = "A_DwarfGnome_04", title = "Westfall", min = 18, max = 19, noLevel = true, run = { "DM" },
    unset = { "races", "force" },
    -- chasse au trésor du Cozy Sleeping Bag : commencée dans les départs Humain et Nain / Gnome
    set = { drop = { [79008] = "started in the race starts" } } },
  { id = "AD_04", base = "A_02", title = "Ashenvale and Stonetalon Mountains", min = 19, max = 21, run = { "WC" } },
  { id = "AD_05", base = "A_03", title = "Redridge Mountains", min = 20, max = 24, alt = { "THANES", "DM", "WC" },
    set = { zones = { REDRIDGE }, endZones = { REDRIDGE } }, unset = { "optional" } },
  -- Bois de la Pénombre à partir de 24 (1er décile des niveaux de quête : 24), plus à 22
  { id = "AD_06", base = "A_03", title = "Duskwood", min = 24, max = 26, run = { "STOCKADE" },
    set = { zones = { DUSKWOOD, STORMWIND }, endZones = { STORMWIND } } },
  { id = "AD_07", base = "A_08", title = "Ashenvale", min = 25, max = 27, run = { "BFD" } },
  -- Paluns, avec Ironforge au passage : quêtes de Gnomeregan et de la Bibliothèque du Monastère
  { id = "AD_08", base = "A_04", title = "Wetlands", min = 26, max = 28, run = { "EXCAVATION" },
    set = { zones = { WETLANDS, LOCH_MODAN, IRONFORGE } } },
  { id = "AD_09", base = "A_06", title = "Hillsbrad Foothills and Alterac Mountains", min = 28, max = 30,
    run = { "DALARAN", "SFK", "SM_GY" }, set = { zones = { HILLSBRAD, ALTERAC } } },
  { id = "AD_10", base = "A_07", title = "Duskwood", min = 29, max = 31, alt = { "STOCKADE", "BFD", "EXCAVATION" } },
  { id = "AD_11", zones = { IRONFORGE, DUN_MOROGH }, entryRung = "GNOMER", title = "Dun Morogh", min = 30, max = 31,
    noLevel = true, prepFor = "GNOMER", run = { "GNOMER" } },
  { id = "AD_12", base = "A_09", title = "Thousand Needles", min = 31, max = 33, run = { "RFK" } },
  { id = "AD_13", base = "A_10", title = "Stranglethorn Vale", min = 32, max = 34,
    alt = { "SFK", "DALARAN", "SM_GY", "GNOMER" } },
  { id = "AD_14", base = "A_11", title = "Desolace", min = 33, max = 36 },
  -- Hautes-terres d'Arathi, avec Southshore pour In the Name of the Light (1053). La Bibliothèque est faite
  -- ici avec l'Armurerie et la Cathédrale : Mythology of the Titans (1050) se prend à Ironforge en AD_11.
  { id = "AD_15", base = "A_13", title = "Arathi Highlands", min = 35, max = 37, run = { "SM_LIB", "SM_ARM", "SM_CATH" },
    set = { zones = { ALTERAC, ARATHI, HILLSBRAD } } },
  { id = "AD_16", base = "A_12", title = "Stranglethorn Vale and Swamp of Sorrows", min = 36, max = 38,
    alt = { "RFK", "SM_LIB", "SM_ARM", "SM_CATH" } },
  { id = "AD_17", base = "A_16", title = "Badlands", min = 37, max = 39, run = { "ULDAMAN" } },
  { id = "AD_18", base = "A_15", title = "Dustwallow Marsh", min = 38, max = 40, run = { "RFD" } },
  -- Riverglades (Forever, 150 quêtes de niveau 38-44) : zone absente des guides habituels
  { id = "AD_19", zones = { RIVERGLADES }, entryHub = RIVERGLADES, title = "Riverglades", min = 39, max = 43,
    alt = { "ULDAMAN", "RFD" }, set = { logCap = 17 } },
  -- Désolace : déjà faite en AD_15 ; restes et quêtes de Maraudon
  { id = "AD_20", base = "A_11", title = "Desolace", min = 42, max = 43, noLevel = true, prepFor = "MARAUDON",
    run = { "MARAUDON" } },
  -- Hinterlands : passage pour les quêtes du Temple englouti (une seule quête de zone à ce niveau)
  { id = "AD_21", base = "A_14", title = "Aerie Peak", min = 43, max = 45, noLevel = true, prepFor = "ST" },
  { id = "AD_22", base = "A_19", title = "Feralas", min = 44, max = 46 },
  { id = "AD_23", base = "A_18", title = "Tanaris", min = 45, max = 47, run = { "ZF" } },
  { id = "AD_24", base = "A_17", title = "Stranglethorn Vale", min = 46, max = 48, alt = { "MARAUDON", "ZF" } },
  { id = "AD_25", base = "A_22", title = "Searing Gorge and Blasted Lands", min = 48, max = 51 },
  { id = "AD_26", base = "A_21", title = "Swamp of Sorrows", min = 50, max = 52, noLevel = true,
    prepFor = "ST", run = { "ST" }, set = { zones = { SWAMP } } },
  { id = "AD_27", base = "A_26", title = "Un'Goro Crater", min = 51, max = 54, alt = { "ST" } },
  { id = "AD_28", base = "A_28", title = "Burning Steppes", min = 53, max = 55, run = { "BRD" } },
  { id = "AD_29", base = "A_24", title = "Felwood", min = 54, max = 56, alt = { "BRD" } },
  { id = "AD_30", base = "A_25", title = "Feralas and Azshara", min = 55, max = 57,
    run = { "DM_EAST", "DM_WEST", "DM_NORTH" } },
  { id = "AD_31", base = "A_23", title = "Western Plaguelands", min = 56, max = 58, run = { "SCHOLO" } },
  { id = "AD_32", base = "A_27", title = "Winterspring", min = 57, max = 58,
    alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" }, set = { zones = { WINTERSPRING } } },
  { id = "AD_33", base = "A_29", title = "Eastern Plaguelands", min = 58, max = 59, run = { "STRAT_LIVE", "STRAT_UD" } },
  { id = "AD_34", base = "A_30", title = "Silithus", min = 59, max = 60, alt = { "STRAT_LIVE", "STRAT_UD" } },
}

-- Horde : départs habituels simulés sans être réécrits, et leur suite dans le mode.
local HORDE_STARTS = {
  { id = "H_OrcTroll_01" }, { id = "H_OrcTroll_02", next = "HD_01" },
  { id = "H_Tauren_01" }, { id = "H_Tauren_02", next = "HD_01" },
  { id = "H_Undead_01" }, { id = "H_Undead_02" }, { id = "H_Undead_03", next = "HD_01" },
  { id = "H_Skyborne_01", next = "HD_01" },
}

M.HORDE_TRUNK = {
  { id = "HD_01", base = "H_01", title = "The Barrens", min = 12, max = 15,
    after = { "H_OrcTroll_02", "H_Tauren_02", "H_Undead_03", "H_Skyborne_01" } },
  { id = "HD_02", zones = { ORGRIMMAR }, entryRung = "RFC", title = "Orgrimmar", min = 15, max = 16, noLevel = true,
    prepFor = "RFC", run = { "RFC" } },
  -- Tarides : la suite, jusqu'à l'entrée des Cavernes des lamentations
  { id = "HD_03", base = "H_01", title = "The Barrens", min = 15, max = 19, run = { "WC" } },
  { id = "HD_04", base = "H_02", title = "Stonetalon Mountains and The Barrens", min = 19, max = 21,
    alt = { "RFC", "WC" } },
  -- Fossoyeuse par le zeppelin d'Orgrimmar : quêtes des Ruines de Lordaeron prises en ville, puis retour
  { id = "HD_05", zones = { UNDERCITY }, entryRung = "LORDAERON", title = "Undercity", min = 20, max = 21,
    noLevel = true, prepFor = "LORDAERON", run = { "LORDAERON" } },
  -- logCap : un Tauren paladin (quêtes de classe en cours) remplissait le journal à Shadumbra's Head (24)
  { id = "HD_06", base = "H_03", title = "Ashenvale", min = 21, max = 25, run = { "BFD" }, set = { logCap = 18 } },
  { id = "HD_07", base = "H_04", title = "Southern Barrens and Thousand Needles", min = 25, max = 27,
    alt = { "LORDAERON", "BFD" } },
  -- Contreforts d'Hautebrande, avec Fossoyeuse et le Sépulcre pour les quêtes du Donjon d'Ombrecroc
  { id = "HD_08", base = "H_05", title = "Hillsbrad Foothills", min = 27, max = 29, run = { "SFK" },
    set = { zones = { HILLSBRAD, UNDERCITY, SILVERPINE }, bounds = { [SILVERPINE] = { 40, 37, 47, 44 } } } },
  -- Alterac et Arathi, avec Fossoyeuse pour les quêtes du Monastère ; instances du sud au nord
  { id = "HD_09", base = "H_06", title = "Alterac Mountains and Arathi Highlands", min = 29, max = 31,
    run = { "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB" },
    -- Going, Going, Guano! (1109, Kraal de Tranchebauge) : prise et rendue à Fossoyeuse, où la route ne repasse
    -- qu'en HD_14, après son abandon (quête de donjon de niveau 33, chapitre de niveau 37)
    set = { zones = { HILLSBRAD, ALTERAC, ARATHI, UNDERCITY },
            drop = { [1109] = "turned in at Undercity, off the route after Razorfen Kraul" } } },
  { id = "HD_10", base = "H_07", title = "Thousand Needles", min = 31, max = 33, run = { "RFK" } },
  { id = "HD_11", base = "H_08", title = "Desolace", min = 33, max = 35,
    alt = { "SFK", "EXCAVATION", "DALARAN", "SM_GY", "SM_LIB", "RFK" } },
  -- Strangleronce : Gnomeregan par le transpondeur de Booty Bay
  { id = "HD_12", base = "H_09", title = "Stranglethorn Vale", min = 35, max = 37, run = { "GNOMER" } },
  { id = "HD_13", base = "H_10", title = "Dustwallow Marsh", min = 37, max = 38, run = { "RFD" } },
  -- Arathi, avec Fossoyeuse pour Into The Scarlet Monastery (1048)
  { id = "HD_14", base = "H_11", title = "Arathi Highlands", min = 38, max = 39, run = { "SM_ARM", "SM_CATH" },
    -- Hearts of Zeal (1113) : suite de Going, Going, Guano! (1109), et le Cimetière est fait en HD_09
    set = { zones = { ARATHI, HILLSBRAD, ALTERAC, LOCH_MODAN, UNDERCITY },
            drop = { [1109] = "turned in at Undercity, off the route after Razorfen Kraul",
                     [1113] = "follows Going, Going, Guano! (1109); the Graveyard is run in HD_09" } } },
  { id = "HD_15", base = "H_12", title = "Badlands", min = 39, max = 40, run = { "ULDAMAN" } },
  -- Riverglades (Forever, quêtes de niveau 38-44) : zone absente des guides habituels
  { id = "HD_16", zones = { RIVERGLADES }, entryHub = RIVERGLADES, title = "Riverglades", min = 39, max = 43,
    alt = { "RFD", "ULDAMAN" }, set = { logCap = 17 } },
  { id = "HD_17", base = "H_13", title = "Stranglethorn Vale", min = 40, max = 42,
    alt = { "GNOMER", "SM_ARM", "SM_CATH" } },
  -- Désolace : déjà faite en HD_11 ; restes et quêtes de Maraudon
  { id = "HD_18", base = "H_08", title = "Desolace", min = 42, max = 44, noLevel = true, prepFor = "MARAUDON",
    run = { "MARAUDON" } },
  { id = "HD_19", base = "H_16", title = "Tanaris", min = 44, max = 45, run = { "ZF" } },
  { id = "HD_20", base = "H_17", title = "Feralas", min = 45, max = 47, alt = { "MARAUDON", "ZF" } },
  { id = "HD_21", base = "H_18", title = "Stranglethorn Vale", min = 47, max = 49 },
  { id = "HD_22", base = "H_21", title = "The Hinterlands", min = 49, max = 51 },
  { id = "HD_23", base = "H_14", title = "Swamp of Sorrows", min = 50, max = 52, noLevel = true,
    prepFor = "ST", run = { "ST" } },
  { id = "HD_24", base = "H_23", title = "Blasted Lands", min = 51, max = 52, alt = { "ST" } },
  -- Gorge des Vents brûlants et Steppes ardentes, avec Kargath pour les quêtes des Profondeurs de Rochenoire
  { id = "HD_25", base = "H_24", title = "Searing Gorge and Burning Steppes", min = 52, max = 53, run = { "BRD" },
    set = { zones = { SEARING, BURNING, BADLANDS }, bounds = { [BADLANDS] = { 1, 43, 8, 51 } } } },
  { id = "HD_26", base = "H_25", title = "Azshara", min = 53, max = 54, alt = { "BRD" } },
  { id = "HD_27", base = "H_26", title = "Felwood", min = 54, max = 55 },
  { id = "HD_28", base = "H_27", title = "Un'Goro Crater", min = 55, max = 56 },
  -- Féralas : déjà faite en HD_20 ; restes et quêtes de Hache-Tripes
  { id = "HD_29", base = "H_17", title = "Feralas", min = 56, max = 57, noLevel = true,
    run = { "DM_EAST", "DM_WEST", "DM_NORTH" } },
  { id = "HD_30", base = "H_29", title = "Western Plaguelands", min = 57, max = 58, run = { "SCHOLO" } },
  { id = "HD_31", base = "H_28", title = "Felwood and Winterspring", min = 57, max = 58,
    alt = { "DM_EAST", "DM_WEST", "DM_NORTH", "SCHOLO" } },
  { id = "HD_32", base = "H_29", title = "Eastern Plaguelands", min = 58, max = 59, run = { "STRAT_LIVE", "STRAT_UD" } },
  { id = "HD_33", base = "H_30", title = "Silithus", min = 59, max = 60, alt = { "STRAT_LIVE", "STRAT_UD" } },
}

-- Départs et tronc d'une faction. M.TRUNK (Alliance) est relu à chaque appel : les tests le remplacent.
function M.startsOf(faction)
  if faction == "Horde" then return HORDE_STARTS end
  return STARTS
end

function M.trunkOf(faction)
  if faction == "Horde" then return M.HORDE_TRUNK end
  return M.TRUNK
end

-- Dossier des guides du mode pour une faction.
M.FOLDER = { Alliance = "AllianceDungeon", Horde = "HordeDungeon" }

-- Champs d'un chapitre habituel qui ne passent pas dans sa copie (suites et choix de la route habituelle).
local DROP = { "next", "nextByRace", "choices", "id", "title", "minLevel", "maxLevel" }

-- build(classicList, rungs) -> liste de plans du mode (départs noEmit puis tronc), prête pour
-- build.simulateFaction. rungs : échelons de build_dungeon_route.build (clé -> entrée du donjon).
-- giverAt(questId) -> { mapId, x, y } du donneur d'une quête de donjon (DungeonData.lua), ou nil.
-- faction : "Alliance" par défaut.
function M.build(classicList, rungs, giverAt, faction)
  faction = faction or "Alliance"
  local trunk = M.trunkOf(faction)
  M.classicList = classicList
  local byKey = {}
  for _, r in ipairs(rungs) do byKey[r.key] = r end
  local out = {}
  for _, s in ipairs(M.startsOf(faction)) do
    local p = deepcopy(classic(s.id))
    p.noEmit = true
    p.choices = nil
    if s.next then p.next, p.nextByRace = s.next, nil end
    out[#out + 1] = p
  end
  for i, t in ipairs(trunk) do
    local p = t.base and deepcopy(classic(t.base)) or { faction = faction }
    for _, k in ipairs(DROP) do p[k] = nil end
    p.id, p.title, p.minLevel, p.maxLevel = t.id, t.title, t.min, t.max
    p.faction = faction
    if t.zones then p.zones = deepcopy(t.zones) end
    for k, v in pairs(t.set or {}) do p[k] = deepcopy(v) end
    for _, k in ipairs(t.unset or {}) do p[k] = nil end
    p.mode, p.after_ = "dungeon", t.after
    p.run, p.alt = t.run, t.alt
    p.entryHub, p.noLevel, p.prepFor = t.entryHub, t.noLevel, t.prepFor
    -- entrée du chapitre : celle du donjon (fait de DungeonData.lua) quand le chapitre n'a pas de modèle
    if t.entryRung then
      local r = assert(byKey[t.entryRung], "unknown rung " .. t.entryRung)
      p.entry = deepcopy(assert(r.entrance, "no entrance for " .. t.entryRung))
    end
    -- le chapitre finit à l'entrée du premier donjon quand elle est dans ses zones
    if t.run then
      local r = assert(byKey[t.run[1]], "unknown rung " .. tostring(t.run[1]))
      for _, z in ipairs(p.zones or {}) do
        if r.entrance and r.entrance[1] == z then p.exit = deepcopy(r.entrance); p.endZones = { z } end
      end
    end
    -- donneurs des quêtes du donjon placés sur la carte de son entrée : ajoutés aux rectangles du chapitre
    -- quand cette carte est limitée (Ratchet et l'entrée des Cavernes des lamentations aux Tarides)
    for _, key in ipairs(t.run or {}) do
      local r = byKey[key]
      local m = r.entrance and r.entrance[1]
      local b = m and p.bounds and p.bounds[m]
      if b and giverAt then
        if type(b[1]) ~= "table" then b = { b } end
        for _, id in ipairs(r.quests) do
          local at = giverAt(id)
          if at and at[1] == m then
            b[#b + 1] = { math.max(0, at[2] - GIVER_MARGIN), math.max(0, at[3] - GIVER_MARGIN),
                          math.min(100, at[2] + GIVER_MARGIN), math.min(100, at[3] + GIVER_MARGIN) }
          end
        end
        b[#b + 1] = { math.max(0, r.entrance[2] - GIVER_MARGIN), math.max(0, r.entrance[3] - GIVER_MARGIN),
                      math.min(100, r.entrance[2] + GIVER_MARGIN), math.min(100, r.entrance[3] + GIVER_MARGIN) }
        p.bounds[m] = b
      end
    end
    local nxt = trunk[i + 1]
    -- AD_NightElf_03 est le premier du tronc mais propre à une race : sa suite est AD_01
    p.next = nxt and nxt.id or nil
    out[#out + 1] = p
  end
  return out
end

-- check(rungs) -> liste d'erreurs : échelon inconnu, fait deux fois, jamais fait, sans alternative, ou
-- alternative placée avant l'échelon.
function M.check(rungs, faction)
  local errs, known, ranAt, altAt = {}, {}, {}, {}
  for _, r in ipairs(rungs) do known[r.key] = true end
  for i, t in ipairs(M.trunkOf(faction)) do
    for _, k in ipairs(t.run or {}) do
      if not known[k] then errs[#errs + 1] = ("%s: unknown rung %s"):format(t.id, k) end
      if ranAt[k] then errs[#errs + 1] = ("%s: rung %s is run twice"):format(t.id, k) end
      ranAt[k] = i
    end
    for _, k in ipairs(t.alt or {}) do
      if not known[k] then errs[#errs + 1] = ("%s: unknown rung %s in alt"):format(t.id, k) end
      if not ranAt[k] then errs[#errs + 1] = ("%s: alternative of %s before its run"):format(t.id, k) end
      altAt[k] = altAt[k] or i
    end
    if t.prepFor and not known[t.prepFor] then errs[#errs + 1] = ("%s: unknown rung %s in prepFor"):format(t.id, t.prepFor) end
    if t.run and t.alt then errs[#errs + 1] = ("%s: a chapter either runs dungeons or is an alternative"):format(t.id) end
    if t.min >= t.max then errs[#errs + 1] = ("%s: empty level band"):format(t.id) end
  end
  for _, r in ipairs(rungs) do
    if not ranAt[r.key] then errs[#errs + 1] = ("rung %s is never run"):format(r.key) end
    if not altAt[r.key] then errs[#errs + 1] = ("rung %s has no open-world alternative"):format(r.key) end
  end
  return errs
end

return M
