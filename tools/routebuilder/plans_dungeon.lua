-- tools/routebuilder/plans_dungeon.lua : chapitres du mode « Donjons » (Alliance).
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
local plansm = require("plans")

local M = {}

local IRONFORGE, STORMWIND, DUN_MOROGH, REDRIDGE, DUSKWOOD = 1455, 1453, 1426, 1433, 1431
local HILLSBRAD, ALTERAC, ARATHI, WETLANDS, LOCH_MODAN = 1424, 1416, 1417, 1437, 1432
local SWAMP, WINTERSPRING = 1435, 1452
local RIVERGLADES = 2548
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

-- Champs d'un chapitre habituel qui ne passent pas dans sa copie (suites et choix de la route habituelle).
local DROP = { "next", "nextByRace", "choices", "id", "title", "minLevel", "maxLevel" }

-- build(classicList, rungs) -> liste de plans du mode (départs noEmit puis tronc), prête pour
-- build.simulateFaction. rungs : échelons de build_dungeon_route.build (clé -> entrée du donjon).
-- giverAt(questId) -> { mapId, x, y } du donneur d'une quête de donjon (DungeonData.lua), ou nil.
function M.build(classicList, rungs, giverAt)
  M.classicList = classicList
  local byKey = {}
  for _, r in ipairs(rungs) do byKey[r.key] = r end
  local out = {}
  for _, s in ipairs(STARTS) do
    local p = deepcopy(classic(s.id))
    p.noEmit = true
    p.choices = nil
    if s.next then p.next, p.nextByRace = s.next, nil end
    out[#out + 1] = p
  end
  for i, t in ipairs(M.TRUNK) do
    local p = t.base and deepcopy(classic(t.base)) or { faction = "Alliance" }
    for _, k in ipairs(DROP) do p[k] = nil end
    p.id, p.title, p.minLevel, p.maxLevel = t.id, t.title, t.min, t.max
    p.faction = "Alliance"
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
    local nxt = M.TRUNK[i + 1]
    -- AD_NightElf_03 est le premier du tronc mais propre à une race : sa suite est AD_01
    p.next = nxt and nxt.id or nil
    out[#out + 1] = p
  end
  return out
end

-- check(rungs) -> liste d'erreurs : échelon inconnu, fait deux fois, jamais fait, sans alternative, ou
-- alternative placée avant l'échelon.
function M.check(rungs)
  local errs, known, ranAt, altAt = {}, {}, {}, {}
  for _, r in ipairs(rungs) do known[r.key] = true end
  for i, t in ipairs(M.TRUNK) do
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
