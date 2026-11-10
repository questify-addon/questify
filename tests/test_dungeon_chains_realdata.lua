-- Suites de préquêtes sur les données réelles : DungeonData.lua livré et QuestieDB de .cache/ (vue Forever du
-- générateur, convertie au format du faux QuestieDB). Tous les donjons, quatre races par faction, plusieurs
-- niveaux : chaque quête laissée de côté a un encadré (suite, niveau ou raison), chaque suite proposée s'ajoute
-- (ses étapes dans le donjon quand elle est prête) puis se retire, sans erreur. Sauté sans clone QuestieDB (CI).
local ROOT = Mock.root
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local DATA_FILE = "Questify/Guides/DungeonData.lua"

local RACES = { Alliance = { 1, 3, 4, 7 }, Horde = { 2, 5, 6, 8 } }   -- Humain, Nain, Elfe, Gnome ; Orc, Mort-vivant, Tauren, Troll
local LEVELS = { 16, 22, 30, 38, 46, 55 }
local MAX_DEPTH = 25

local function exists(path)
  local f = io.open(path, "rb")
  if f then f:close(); return true end
  return false
end

-- Faux QuestieDB : quêtes des donjons de la faction et toutes leurs préquêtes, PNJ et objets qui les donnent
-- ou les reçoivent ; apparitions indexées par uiMapID (zones : table identité).
local function buildQdb(D, data, faction)
  local wanted, order = {}, {}
  local function want(id, depth)
    if wanted[id] or depth > MAX_DEPTH then return end
    local q = D.quests[id]
    if not q then return end
    wanted[id] = true
    order[#order + 1] = id
    for _, p in ipairs(q.preSingle) do want(p, depth + 1) end
    for _, p in ipairs(q.preGroup) do want(p, depth + 1) end
  end
  for _, d in ipairs(data) do
    for _, e in ipairs(d.quests[faction] or {}) do want(e.id, 0) end
  end
  local out = { quests = {}, npcs = {}, objects = {}, zones = { areaIdToUiMapId = {} } }
  local maps = {}
  local function spawns(sp)
    local o = {}
    for m, pts in pairs(sp or {}) do
      o[m] = pts
      maps[m] = true
      out.zones.areaIdToUiMapId[m] = m
    end
    return o
  end
  local npcs, objs = {}, {}
  for _, id in ipairs(order) do
    local q = D.quests[id]
    local cre, obj, itm = {}, {}, {}
    for _, o in ipairs(q.objectives and q.objectives.list or {}) do
      if o.kind == "kill" or o.kind == "killCredit" then cre[#cre + 1] = { o.id or 1 }
      elseif o.kind == "object" then obj[#obj + 1] = { o.id or 1 }
      elseif o.kind == "item" then itm[#itm + 1] = { o.id or 1 } end
    end
    local objectives = (#cre + #obj + #itm > 0) and { cre, obj, itm } or nil
    out.quests[id] = {
      name = q.name, startedBy = { q.starters.npcs, q.starters.objects, q.starters.items },
      finishedBy = { q.finishers.npcs, q.finishers.objects }, requiredLevel = q.reqLevel, questLevel = q.level,
      requiredRaces = q.races, requiredClasses = q.classes, objectives = objectives,
      preQuestSingle = q.preSingle, preQuestGroup = q.preGroup, exclusiveTo = q.exclusiveTo,
      zoneOrSort = q.zoneOrSort, specialFlags = q.specialFlags,
      requiredSkill = q.requiredSkill and { q.requiredSkill, 1 } or nil,
      triggerEnd = q.triggerEnd and { q.triggerEnd.text or "event", {} } or nil,
    }
    for _, n in ipairs(q.starters.npcs) do npcs[n] = true end
    for _, n in ipairs(q.finishers.npcs) do npcs[n] = true end
    for _, n in ipairs(q.starters.objects) do objs[n] = true end
    for _, n in ipairs(q.finishers.objects) do objs[n] = true end
  end
  for id in pairs(npcs) do
    local n = D.npcs[id]
    if n then out.npcs[id] = { name = n.name, spawns = spawns(n.spawns), friendlyToFaction = "AH" } end
  end
  for id in pairs(objs) do
    local o = D.objects[id]
    if o then out.objects[id] = { name = o.name, spawns = spawns(o.spawns) } end
  end
  for _, d in ipairs(data) do
    maps[d.entrance[1]] = true
    for _, e in ipairs(d.quests[faction] or {}) do
      if e.at then maps[e.at[1]] = true end
      if e.endAt then maps[e.endAt[1]] = true end
    end
  end
  return out, maps, #order
end

-- Cartes du faux client d'après les bornes monde (UiMapAssignment) de tools/routebuilder/data.
local function setupMaps(W, maps)
  for m in pairs(maps) do
    local w = W.maps[m]
    if w and w.minX and not Mock.maps[m] then
      Mock.maps[m] = { name = w.name or ("map " .. m), continent = w.continent or 0, top = w.maxX, left = w.maxY,
        height = w.maxX - w.minX, width = w.maxY - w.minY, parent = w.parent }
    end
  end
end

local function tagged(Q, tag)
  local out = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.tag == tag then out[e.step.action .. " " .. tostring(e.step.questId or "")] = true end
  end
  return out
end

return {
  every_left_out_dungeon_quest_has_a_box_both_factions = function(t)
    package.path = ROOT .. "/tools/routebuilder/?.lua;" .. package.path
    local qdb = require("qdb")
    if not exists(qdb.DEFAULT_DB .. "/QuestieDB.toc") then return end   -- pas de clone QuestieDB (CI) : sauté
    local W = require("world").load(ROOT .. "/tools/routebuilder/data")
    local real = {}
    assert(loadfile(ROOT .. "/" .. DATA_FILE))("Questify", real)
    local summary = {}
    for _, faction in ipairs({ "Alliance", "Horde" }) do
      local D = qdb.load({ db = qdb.DEFAULT_DB, questie = qdb.DEFAULT_QUESTIE, faction = faction })
      local fake, maps, nQuests = buildQdb(D, real.DungeonData, faction)
      t.ok(nQuests > 100, faction .. ": dungeon quests and prerequisites")
      local stats = { rows = 0, chain = 0, ready = 0, later = 0, levelOnly = 0, reason = {}, longest = 0,
                      added = 0, dungeons = {} }
      for _, race in ipairs(RACES[faction]) do
        for _, level in ipairs(LEVELS) do
          Mock.reset()
          Mock.player.raceId, Mock.player.faction, Mock.player.level = race, faction, level
          setupMaps(W, maps)
          local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true, qdb = fake,
            beforeLogin = function(q) q.DungeonData = real.DungeonData; q.QuestRewardData = real.QuestRewardData end })
          for _, item in ipairs(Q.Dungeons:List()) do
            local d = item.dungeon
            for _, r in ipairs(Q.Dungeons:Details(d)) do
              if not r.ok then
                stats.rows = stats.rows + 1
                t.ok(type(r.chain) == "table", ("%s %s lvl %d: quest %d left out without a box"):format(faction, d.key,
                  level, r.id))
              end
              local c = r.chain
              if type(c) == "table" and not r.ok then
                stats.dungeons[d.key] = true
                if c.reason then
                  stats.reason[c.reason] = (stats.reason[c.reason] or 0) + 1
                  t.eq(Q.Dungeons:ChainInfo(d.key, r.id), nil, "no annex for an out-of-reach chain")
                else
                  local info = Q.Dungeons:ChainInfo(d.key, r.id)
                  t.ok(info, ("%s %s: chain info for %d"):format(faction, d.key, r.id))
                  if info then
                    if #info.quests == 0 then stats.levelOnly = stats.levelOnly + 1
                    else stats.chain = stats.chain + 1 end
                    if info.ready then stats.ready = stats.ready + 1 else stats.later = stats.later + 1 end
                    if #info.quests > stats.longest then stats.longest = #info.quests end
                    if not info.chosen then
                      t.eq(Q.Dungeons:AddChain(d.key, r.id), true, ("%s %s: add %d"):format(faction, d.key, r.id))
                      stats.added = stats.added + 1
                      if info.ready then
                        local steps = tagged(Q, "dg:" .. d.key)
                        for _, row in ipairs(info.quests) do
                          t.ok(steps["turnin " .. row.id], ("%s %s: chain quest %d on the route"):format(faction,
                            d.key, row.id))
                        end
                        t.ok(steps["accept " .. r.id], ("%s %s: %d taken after its chain"):format(faction, d.key, r.id))
                      end
                      t.eq(Q.Dungeons:RemoveChain(d.key, r.id), true)
                    end
                  end
                end
              end
            end
          end
          for _, e in ipairs(Mock.errors) do t.ok(false, faction .. " lvl " .. level .. ": " .. tostring(e)) end
        end
      end
      local n = 0
      for _ in pairs(stats.dungeons) do n = n + 1 end
      local reasons = {}
      for k, v in pairs(stats.reason) do reasons[#reasons + 1] = k .. " " .. v end
      table.sort(reasons)
      summary[#summary + 1] = ("%s: %d left-out rows in %d dungeons; chains %d (longest %d), level only %d, ready %d, "
        .. "later %d, added and removed %d; out of reach: %s"):format(faction, stats.rows, n, stats.chain,
        stats.longest, stats.levelOnly, stats.ready, stats.later, stats.added, table.concat(reasons, ", "))
      t.ok(stats.chain > 0 and stats.added > 0, faction .. ": chains offered and added")
    end
    if os.getenv("QF_VERBOSE") then io.stderr:write(table.concat(summary, "\n"), "\n") end
  end,
}
