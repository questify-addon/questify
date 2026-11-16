-- tools/routebuilder/auctionitems.lua : objets de collecte des routes qui peuvent s'acheter à l'hôtel des
-- ventes, pour Questify/Guides/AuctionItemData.lua :
--   Q.AuctionItemData = {
--     guides = { [guideId] = { { item = itemId, quest = questId, obj = index, count = n }, ... } },
--     auctioneers = { A = { npcId, ... }, H = { npcId, ... } },
--   }
-- Une entrée par objectif « objet » d'une quête que le chapitre fait progresser (étape « complete » ou
-- « turnin »), dans l'ordre des étapes. `obj` est le rang de l'objectif dans le journal du client,
-- `count` la quantité lue dans le texte des objectifs (absente si le texte ne la donne pas).
--
-- Écartés : objets de quête (classe 12 : liés à la quête ou ne tombant que pendant celle-ci), objets vendus
-- par un marchand (moins chers chez lui, et la route ne les farme pas), objets donnés par la quête elle-même.
-- QuestieDB ne dit pas si un objet est lié : le jeu (Engine/AuctionItems.lua) relit le type de lien avec
-- GetItemInfo et écarte encore les objets liés quand on les ramasse.
--
-- Encanteurs : PNJ qui portent le drapeau AUCTIONEER et ont au moins une position, par faction amie.
-- Les positions sont relues dans le QuestieDB du joueur à l'exécution.

local sim = require("sim")
local emitm = require("emit")

local ai = {}
ai.ITEM_CLASS_QUEST = 12
ai.NPC_FLAG_AUCTIONEER = 4096

local function hasBit(v, bit)
  return bit and bit > 0 and math.floor((v or 0) / bit) % 2 == 1
end

local function hasSpawn(npc)
  for _, list in pairs(npc.spawns or {}) do
    if type(list) == "table" and #list > 0 then return true end
  end
  return false
end

-- Raison d'écarter l'objet `id` demandé par la quête q, ou nil s'il peut s'acheter.
function ai.reject(D, q, id)
  local it = D.items[id]
  if not it then return "unknown item" end
  if it.class == ai.ITEM_CLASS_QUEST then return "quest item" end
  if #(it.vendors or {}) > 0 then return "vendor" end
  if q.sourceItem == id then return "given by the quest" end
  for _, s in ipairs(q.requiredSourceItems or {}) do
    if s == id then return "given by the quest" end
  end
  return nil
end

-- Objets achetables d'un guide (définition RegisterGuide) : liste dans l'ordre des étapes, sans doublon
-- (même quête et même objet).
function ai.forGuide(D, def)
  local out, seen = {}, {}
  for _, s in ipairs(def.steps or {}) do
    local action, qid = s[1], s[2]
    if (action == "complete" or action == "turnin") and type(qid) == "number" then
      local q = D.quests[qid]
      if q and q.objectives then
        local counts
        for _, o in ipairs(q.objectives.list or {}) do
          if o.kind == "item" and not ai.reject(D, q, o.id) then
            local key = qid .. ":" .. o.id
            if not seen[key] then
              seen[key] = true
              counts = counts or sim.parseCounts(D, q)
              out[#out + 1] = { item = o.id, quest = qid, obj = o.index, count = counts[o.index] }
            end
          end
        end
      end
    end
  end
  return out
end

-- Encanteurs par faction amie : { A = { id, ... }, H = { id, ... } } (IDs triés).
function ai.auctioneers(D)
  local A, H = {}, {}
  for id, n in pairs(D.npcs or {}) do
    if hasBit(n.npcFlags, ai.NPC_FLAG_AUCTIONEER) and hasSpawn(n) then
      local f = n.friendly
      if f == "A" or f == "AH" then A[#A + 1] = id end
      if f == "H" or f == "AH" then H[#H + 1] = id end
    end
  end
  table.sort(A); table.sort(H)
  return { A = A, H = H }
end

-- Texte du fichier AuctionItemData.lua. guides : { { id, list }, ... } dans l'ordre voulu.
function ai.emit(guides, auctioneers, meta)
  meta = meta or {}
  local out = {}
  local function w(s) out[#out + 1] = s end
  w("local addonName, Q = ...")
  w("-- Généré par tools/routebuilder/build_auction_items.lua. Ne pas modifier à la main.")
  w(("-- Source : QuestieDB commit %s, généré le %s."):format(meta.commit or "unknown", meta.date or os.date("%Y-%m-%d")))
  w("-- Objets de collecte des routes qui peuvent s'acheter à l'hôtel des ventes (par chapitre, dans l'ordre des")
  w("-- étapes : objet, quête, rang de l'objectif dans le journal, quantité), puis les encanteurs par faction.")
  w("Q.AuctionItemData = {")
  w("  guides = {")
  for _, g in ipairs(guides) do
    if #g.list > 0 then
      local rows = {}
      for _, e in ipairs(g.list) do
        local parts = { ("item = %d"):format(e.item), ("quest = %d"):format(e.quest), ("obj = %d"):format(e.obj) }
        if e.count then parts[#parts + 1] = ("count = %d"):format(e.count) end
        rows[#rows + 1] = "{ " .. table.concat(parts, ", ") .. " }"
      end
      w(("    [%s] = { %s },"):format(emitm.value(g.id), table.concat(rows, ", ")))
    end
  end
  w("  },")
  w("  auctioneers = {")
  w(("    A = %s,"):format(emitm.value(auctioneers.A or {})))
  w(("    H = %s,"):format(emitm.value(auctioneers.H or {})))
  w("  },")
  w("}")
  return table.concat(out, "\n") .. "\n"
end

return ai
