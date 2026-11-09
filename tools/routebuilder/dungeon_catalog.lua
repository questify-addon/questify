-- tools/routebuilder/dungeon_catalog.lua : donjons de WoW: Forever retenus par Questify (jusqu'au niveau 60,
-- hors raids). Partagé par build_dungeons.lua (Questify/Guides/DungeonData.lua, fenêtre des donjons de l'addon)
-- et sim.lua (quêtes de donjon prises au passage dans chaque chapitre).
--
-- Clé stable (sauvegardes de l'addon), zone (AreaTable), niveaux conseillés. Niveaux des donjons classiques :
-- plages usuelles de l'outil de recherche de groupe de Classic ; donjons ajoutés par Forever : plages annoncées
-- par Blizzard. À vérifier en jeu. only = seule faction autorisée, quelles que soient les données.
local catalog = {}

catalog.list = {
  { key = "RFC", area = 2437, min = 13, max = 18, only = "Horde" },      -- Gouffre de Ragefeu (Orgrimmar)
  { key = "THANES", area = 16919, min = 13, max = 18 },                  -- The Hall of Thanes (Forever)
  { key = "LORDAERON", area = 16611, min = 15, max = 22 },               -- Ruins of Lordaeron (Forever)
  { key = "WC", area = 718, min = 17, max = 24 },                        -- Cavernes des lamentations
  { key = "DM", area = 1581, min = 17, max = 26 },                       -- Les Mortemines
  { key = "SFK", area = 209, min = 22, max = 30 },                       -- Donjon d'Ombrecroc
  { key = "BFD", area = 719, min = 24, max = 32 },                       -- Profondeurs de Brassenoire
  { key = "STOCKADE", area = 717, min = 24, max = 32, only = "Alliance" }, -- La Prison (Hurlevent)
  { key = "EXCAVATION", area = 16732, min = 24, max = 29 },              -- Excavation Site: Wetlands (Forever)
  { key = "DALARAN", area = 16544, min = 28, max = 33 },                 -- City of Dalaran (Forever)
  { key = "SM", area = 796, min = 28, max = 45 },                        -- Monastère écarlate (toutes les ailes)
  { key = "GNOMER", area = 721, min = 29, max = 38 },                    -- Gnomeregan
  { key = "RFK", area = 491, min = 29, max = 38 },                       -- Kraal de Tranchebauge
  -- Lot H (routes 30-60, 2026-11-06) : niveaux du plan « meta paths 1-60 », à vérifier en jeu.
  { key = "ULDAMAN", area = 1337, min = 36, max = 47 },                  -- Uldaman
  { key = "RFD", area = 722, min = 37, max = 46 },                       -- Souilles de Tranchebauge
  { key = "MARAUDON", area = 2100, min = 42, max = 52 },                 -- Maraudon
  { key = "ZF", area = 1176, min = 44, max = 54 },                       -- Zul'Farrak
  { key = "ST", area = 1477, min = 50, max = 60 },                       -- Temple d'Atal'Hakkar
  { key = "BRD", area = 1584, min = 52, max = 60 },                      -- Profondeurs de Rochenoire
  -- Hache-Tripes : une seule clé (est, ouest et nord ont le même nom et la même zone 2557 dans QuestieDB)
  { key = "DIREMAUL", area = 2557, min = 55, max = 60 },                 -- Hache-Tripes
  { key = "SCHOLO", area = 2057, min = 55, max = 60 },                   -- Scholomance
  { key = "STRAT", area = 2017, min = 58, max = 60 },                    -- Stratholme
  -- Raids (Cœur du Magma, Onyxia, Zul'Gurub, Ahn'Qiraj, Naxxramas...) et Pic Rochenoire (zone 1583
  -- commune à la partie basse et à la partie haute, raid de 10) : hors catalogue.
}

-- Donjons du catalogue par nom QuestieDB (D.dungeonAreas : zone et zones secondaires -> nom), mis en cache
-- dans D. Le nom est celui que sim.lua donne à une quête de donjon (zoneOrSort).
-- D.dungeonCatalog (nom -> donjon) remplace le catalogue : tests.
function catalog.byName(D)
  if D.dungeonCatalog then return D.dungeonCatalog end
  if D._dungeonCatalog then return D._dungeonCatalog end
  local out = {}
  for _, def in ipairs(catalog.list) do
    local name = D.dungeonAreas and D.dungeonAreas[def.area]
    if name then out[name] = def end
  end
  D._dungeonCatalog = out
  return out
end

-- Pré-requis (preSingle et preGroup, jusqu'à `depth` niveaux) des quêtes de donjon du catalogue : id -> nom du
-- donjon (le premier par id de quête de donjon), hors quêtes de donjon elles-mêmes. Mis en cache dans D.
function catalog.prerequisites(D, depth)
  if D._dungeonPrereqs then return D._dungeonPrereqs end
  local byName, out = catalog.byName(D), {}
  local function inDungeon(q)
    local z = q and q.zoneOrSort or 0
    return z > 0 and D.dungeonAreas and D.dungeonAreas[z] or nil
  end
  local function walk(q, name, d)
    if d > depth then return end
    local list = {}
    for _, p in ipairs(q.preSingle or {}) do list[#list + 1] = p end
    for _, p in ipairs(q.preGroup or {}) do list[#list + 1] = p end
    for _, p in ipairs(list) do
      local pq = D.quests[p]
      if pq and not inDungeon(pq) and not out[p] then
        out[p] = name
        walk(pq, name, d + 1)
      end
    end
  end
  local ids = {}
  for id in pairs(D.quests) do ids[#ids + 1] = id end
  table.sort(ids)
  for _, id in ipairs(ids) do
    local name = inDungeon(D.quests[id])
    if name and byName[name] then walk(D.quests[id], name, 1) end
  end
  D._dungeonPrereqs = out
  return out
end

return catalog
