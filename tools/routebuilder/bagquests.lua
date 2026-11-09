-- tools/routebuilder/bagquests.lua : quêtes qui donnent un sac (niveau < 60) pour
-- Questify/Guides/BagQuestData.lua :
--   Q.BagQuestData = { { key, title, faction, races, level, bag = itemId, quests = { prérequis..., quête },
--                        rewards = { [questId] = { items = {...}, xp = n } } }, ... }
-- Une entrée par quête à sac : `quests` est la chaîne à faire, prérequis obligatoires d'abord (preQuestSingle :
-- le premier possible pour la faction ; preQuestGroup : tous), la quête à sac en dernier. Le jeu
-- (Engine/BagQuests.lua) ne la propose que si le sac est plus grand que le plus petit sac porté (ou qu'un
-- emplacement de sac est vide) : la taille d'un sac n'est pas dans QuestieDB, elle est lue en jeu.
--
-- Écartées : quêtes de classe (ClassQuestData), de donjon (zone de QuestieDB dans une instance), de réputation,
-- de métier ou de sort, répétables, en liste noire, de niveau 60 (récompenses de réputation, tickets de foire),
-- sans donneur connu, et toute chaîne dont un prérequis obligatoire est dans un de ces cas. Seuls les sacs
-- ordinaires comptent (classe 1, sous-classe 0) : pas de sac d'âmes, de carquois ni de sac de métier.

local qdb = require("qdb")
local emitm = require("emit")
local cq = require("classquests")

local bq = {}
bq.MAX_LEVEL = 59      -- niveau de quête maximal (les quêtes à sac de niveau 60 sont de réputation ou de foire)
bq.MAX_CHAIN = 8       -- quêtes au plus dans une chaîne (prérequis compris)
local ITEM_CLASS_CONTAINER, ITEM_SUBCLASS_BAG = 1, 0

local FACTION_BITS = {
  Alliance = 1 + 4 + 8 + 64 + 4294967296,
  Horde = 2 + 16 + 32 + 128 + 8589934592,
}

local function questLevel(q)
  if q.level and q.level > 0 then return q.level end
  return q.reqLevel or 0
end

-- Masque de races (0 = toutes) qui laisse au moins une race de la faction.
local function factionAllows(mask, faction)
  if not mask or mask == 0 then return true end
  local bits = FACTION_BITS[faction]
  for _, b in ipairs({ 1, 2, 4, 8, 16, 32, 64, 128, 4294967296, 8589934592 }) do
    if qdb.hasBit(bits, b) and qdb.hasBit(mask, b) then return true end
  end
  return false
end

-- Intersection de deux masques de races (0 = toutes).
local function andMask(a, b)
  if not a or a == 0 then return b or 0 end
  if not b or b == 0 then return a end
  local out = 0
  for _, bit in ipairs({ 1, 2, 4, 8, 16, 32, 64, 128, 4294967296, 8589934592 }) do
    if qdb.hasBit(a, bit) and qdb.hasBit(b, bit) then out = out + bit end
  end
  return out
end

local function hasStarter(q)
  local s = q.starters or {}
  return #(s.npcs or {}) > 0 or #(s.objects or {}) > 0 or #(s.items or {}) > 0
end

-- Raison d'écarter une quête de la chaîne, ou nil si elle peut être proposée.
function bq.rejectReason(D, q, faction)
  if not q then return "unknown quest" end
  if q.blacklisted then return "blacklist" end
  if qdb.isClassQuest(q) then return "class quest" end
  if qdb.hasBit(q.specialFlags or 0, 1) then return "repeatable" end
  if not factionAllows(q.races, faction) then return "other faction" end
  local z = q.zoneOrSort or 0
  if z > 0 and D.dungeonAreas and D.dungeonAreas[z] then return "dungeon" end
  if q.requiredMinRep or q.requiredMaxRep then return "reputation" end
  if q.requiredSkill or q.requiredSpell or q.requiredSpecialization then return "profession or spell" end
  if questLevel(q) > bq.MAX_LEVEL or (q.reqLevel or 0) > bq.MAX_LEVEL then return "level" end
  if not hasStarter(q) then return "no starter" end
  return nil
end

-- Chaîne à faire pour une quête : prérequis obligatoires (en profondeur, dans l'ordre) puis la quête.
-- -> liste d'IDs, ou nil + raison.
function bq.chainFor(D, id, faction)
  local order, seen = {}, {}
  local function visit(qid, depth)
    if seen[qid] then return true end
    if depth > bq.MAX_CHAIN then return false, "chain too long" end
    local q = D.quests[qid]
    local why = bq.rejectReason(D, q, faction)
    if why then return false, ("%s (%d)"):format(why, qid) end
    seen[qid] = true
    -- preQuestSingle : une au choix, la première possible pour la faction (IDs croissants)
    if #q.preSingle > 0 then
      local pres = {}
      for _, p in ipairs(q.preSingle) do pres[#pres + 1] = p end
      table.sort(pres)
      local okAny, lastWhy = false, nil
      for _, p in ipairs(pres) do
        local snapshot = #order
        local ok, w = visit(p, depth + 1)
        if ok then okAny = true; break end
        lastWhy = w
        for k = #order, snapshot + 1, -1 do seen[order[k]] = nil; order[k] = nil end
      end
      if not okAny then return false, lastWhy end
    end
    for _, p in ipairs(q.preGroup) do
      local ok, w = visit(p, depth + 1)
      if not ok then return false, w end
    end
    order[#order + 1] = qid
    return true
  end
  local ok, why = visit(id, 1)
  if not ok then return nil, why end
  if #order > bq.MAX_CHAIN then return nil, "chain too long" end
  return order
end

-- bq.build(D, faction) -> { entry, ... }, rejected = { { quest, item, reason }, ... }
function bq.build(D, faction)
  local rewards = {}
  for _, itemId in ipairs(qdb.sortedKeys(D.items)) do
    for _, qid in ipairs(D.items[itemId].questRewards or {}) do
      rewards[qid] = rewards[qid] or {}
      table.insert(rewards[qid], itemId)
    end
  end
  local out, rejected = {}, {}
  for _, itemId in ipairs(qdb.sortedKeys(D.items)) do
    local it = D.items[itemId]
    if it.class == ITEM_CLASS_CONTAINER and (it.subClass or 0) == ITEM_SUBCLASS_BAG then
      local qids = {}
      for _, qid in ipairs(it.questRewards or {}) do qids[#qids + 1] = qid end
      table.sort(qids)
      for _, qid in ipairs(qids) do
        local q = D.quests[qid]
        local chain, why = nil, nil
        if q and factionAllows(q.races, faction) then
          chain, why = bq.chainFor(D, qid, faction)
        end
        if chain then
          local mask = 0
          for _, c in ipairs(chain) do mask = andMask(mask, D.quests[c].races) end
          local first = D.quests[chain[1]]
          local fac = cq.factionOf(mask)
          local entry = {
            -- clé suffixée par la faction quand la chaîne lui est propre (même quête, prérequis différents
            -- selon la faction : The Problem With Prideclaws 92515)
            key = "BAG_" .. qid .. (fac and ("_" .. fac:sub(1, 1)) or ""), title = q.name, faction = fac,
            races = (mask ~= 0) and mask or nil,
            level = (first.reqLevel and first.reqLevel > 0) and first.reqLevel or questLevel(first),
            bag = itemId, quests = chain, rewards = {},
          }
          for _, c in ipairs(chain) do
            entry.rewards[c] = { items = rewards[c] or {}, xp = D.xp[c] and D.xp[c][2] or nil }
          end
          out[#out + 1] = entry
        elseif q and factionAllows(q.races, faction) then
          rejected[#rejected + 1] = { quest = qid, item = itemId, reason = why }
        end
      end
    end
  end
  table.sort(out, function(a, b)
    if a.level ~= b.level then return a.level < b.level end
    return a.key < b.key
  end)
  return out, rejected
end

-- Fusionne les listes de l'Alliance (a) et de la Horde (b) : même clé et même chaîne, une seule entrée ;
-- même clé mais chaîne différente (corrections propres à une faction), chacune garde sa faction.
function bq.merge(a, b)
  local out, byKey = {}, {}
  local function same(x, y)
    if #x.quests ~= #y.quests then return false end
    for i = 1, #x.quests do if x.quests[i] ~= y.quests[i] then return false end end
    return true
  end
  for i, src in ipairs({ a or {}, b or {} }) do
    local faction = i == 1 and "Alliance" or "Horde"
    for _, e in ipairs(src) do
      local prev = byKey[e.key]
      if not prev then
        byKey[e.key] = e; out[#out + 1] = e
      elseif not same(prev, e) then
        if not prev.faction then prev.faction = "Alliance"; prev.key = prev.key .. "_A" end
        local copy = {}
        for k, v in pairs(e) do copy[k] = v end
        copy.faction = faction
        copy.key = e.key .. "_" .. faction:sub(1, 1)
        out[#out + 1] = copy
      end
    end
  end
  table.sort(out, function(x, y)
    if x.level ~= y.level then return x.level < y.level end
    return x.key < y.key
  end)
  return out
end

-- Texte du fichier BagQuestData.lua.
function bq.emit(data, meta)
  meta = meta or {}
  local out = {}
  local function w(s) out[#out + 1] = s end
  w("local addonName, Q = ...")
  w("-- Généré par tools/routebuilder/bagquests.lua (via build.lua). Ne pas modifier à la main.")
  w(("-- Source : QuestieDB commit %s, généré le %s."):format(meta.commit or "unknown", meta.date or os.date("%Y-%m-%d")))
  w("-- Quêtes qui donnent un sac : chaîne à faire (prérequis puis quête), niveau requis, ID du sac et des récompenses.")
  w("Q.BagQuestData = {")
  for _, e in ipairs(data) do
    local parts = {
      ("key = %s"):format(emitm.value(e.key)),
      ("title = %s"):format(emitm.value(e.title or "")),
    }
    if e.faction then parts[#parts + 1] = ("faction = %s"):format(emitm.value(e.faction)) end
    if e.races then parts[#parts + 1] = ("races = %s"):format(("%.0f"):format(e.races)) end
    parts[#parts + 1] = ("level = %d"):format(e.level)
    parts[#parts + 1] = ("bag = %d"):format(e.bag)
    parts[#parts + 1] = ("quests = %s"):format(emitm.value(e.quests))
    local rw = {}
    for _, q in ipairs(e.quests) do
      local r = e.rewards[q] or { items = {} }
      local fields = { ("items = %s"):format(emitm.value(r.items or {})) }
      if r.xp then fields[#fields + 1] = ("xp = %d"):format(r.xp) end
      rw[#rw + 1] = ("[%d] = { %s }"):format(q, table.concat(fields, ", "))
    end
    parts[#parts + 1] = ("rewards = { %s }"):format(table.concat(rw, ", "))
    w("  { " .. table.concat(parts, ", ") .. " },")
  end
  w("}")
  return table.concat(out, "\n") .. "\n"
end

return bq
