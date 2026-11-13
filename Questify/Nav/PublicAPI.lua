local addonName, Q = ...

-- API publique, en lecture seule, pour les addons de navigation (AzerothGPS et les autres) : où le
-- guide envoie le joueur maintenant. Pensée pour être lue à intervalle régulier (toutes les 0,5 s par
-- exemple), comme la flèche de RestedXP (RXPG_ARROW.element) ou celle de Zygor : rien n'est à appeler
-- pour s'abonner, rien n'est modifié chez Questify. Documentation : docs/API.md.
--
--   QuestifyAPI.version         -> 1
--   QuestifyAPI.Destination()   -> nil | {
--     key    = texte qui change dès que le lieu change (étape, objectif, cible qui se déplace) ;
--              même clé = même arrêt. Une clé qui change : l'ancien arrêt est fini.
--     mapID  = uiMapID de la carte du point,
--     x, y   = position sur cette carte, de 0 à 1,
--     title  = texte de l'étape (« Parler à Gryan Stoutmantle »), peut être vide,
--     manual = true si le joueur a choisi ce point lui-même sur la carte,
--     step   = { guide = id du chapitre, index = rang de l'étape, action = "accept" / "turnin" /
--               "complete" / ... } ou nil (point choisi hors étape),
--     via    = détours de Questify par une grotte (Nav/Caves.lua), à faire dans l'ordre avant le point :
--              { { mapID, x, y (0-1), kind = "exit" | "enter", cave = clé de la grotte }, ... }, ou nil.
--              Facultatif : un routeur qui connaît déjà les grottes peut l'ignorer.
--   }
-- nil : aucun lieu où aller (étape sur place, guide fini ou en pause).
-- Chaque appel rend une table neuve : la garder ou la modifier ne touche pas Questify.
local API = { version = 1 }
Q.PublicAPI = API

local function tenth(v) return math.floor(v * 10 + 0.5) end

local function copyVia(mapId, x, y)
  local C = Q.Caves
  if not (C and C.Plan) then return nil end
  local ok, plan = pcall(C.Plan, C, mapId, x, y)
  if not ok or type(plan) ~= "table" or type(plan.stops) ~= "table" or #plan.stops == 0 then return nil end
  local via = {}
  for i, s in ipairs(plan.stops) do
    via[i] = { mapID = s.mapId, x = s.x / 100, y = s.y / 100, kind = s.kind,
      cave = type(s.cave) == "table" and s.cave.key or nil }
  end
  return via
end

function API.Destination()
  local Nav = Q.Nav
  if not (Nav and Nav.Status) then return nil end
  local ok, st = pcall(Nav.Status, Nav)
  local t = ok and type(st) == "table" and st.target
  if type(t) ~= "table" or type(t.mapId) ~= "number" or type(t.x) ~= "number" or type(t.y) ~= "number" then
    return nil
  end
  local step
  if not st.manual and Q.Progress and Q.Progress.Current then
    local okC, cur = pcall(Q.Progress.Current, Q.Progress)
    if okC and type(cur) == "table" and type(cur.step) == "table" then
      local guide = type(cur.key) == "string" and cur.key:match("^g:(.+):%d+$") or nil
      step = { key = cur.key, guide = guide, index = cur.index, action = cur.step.action }
    end
  end
  local title = type(t.title) == "string" and t.title or ""
  local key = table.concat({ step and step.key or "manual", t.mapId, tenth(t.x), tenth(t.y), title }, "|")
  if step then step.key = nil end
  return {
    key = key,
    mapID = t.mapId,
    x = t.x / 100,
    y = t.y / 100,
    title = title,
    manual = st.manual == true,
    step = step,
    via = copyVia(t.mapId, t.x, t.y),
  }
end

-- Globale : un seul Questify est chargé à la fois ; on n'écrase pas une table posée par un autre.
if _G.QuestifyAPI == nil then _G.QuestifyAPI = API end
