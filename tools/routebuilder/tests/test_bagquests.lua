-- Tests de bagquests.lua (quêtes qui donnent un sac -> BagQuestData.lua), sur des données synthétiques :
-- aucun ne demande QuestieDB.
local bq = require("bagquests")

local ALLIANCE, HORDE = 4294967373, 8589934770

local function quest(id, t)
  t = t or {}
  return {
    id = id, name = t.name or ("Quest " .. id), level = t.level or 10, reqLevel = t.reqLevel or 8,
    races = t.races or 0, classes = t.classes or 0, specialFlags = t.specialFlags or 0,
    starters = { npcs = t.noStarter and {} or { 1 }, objects = {}, items = {} },
    preSingle = t.preSingle or {}, preGroup = t.preGroup or {}, zoneOrSort = t.zone or 0,
    requiredMinRep = t.rep, requiredSkill = t.skill, blacklisted = t.blacklisted or false,
  }
end

local function fixture()
  local D = { quests = {}, items = {}, xp = {}, dungeonAreas = { [718] = "Wailing Caverns" } }
  local function q(id, t) D.quests[id] = quest(id, t) end
  q(1, { name = "Prelude A", races = ALLIANCE })
  q(2, { name = "Prelude B", races = HORDE })
  q(3, { name = "Bag Quest", preSingle = { 2, 1 } })        -- A : 1 puis 3 ; H : 2 puis 3
  q(4, { name = "Group Pre 1" }); q(5, { name = "Group Pre 2" })
  q(6, { name = "Group Bag", preGroup = { 4, 5 }, reqLevel = 12 })
  q(10, { name = "Class Bag", classes = 256 })               -- Démoniste seul : quête de classe
  q(11, { name = "Dungeon Bag", zone = 718 })
  q(12, { name = "Rep Bag", rep = { 1, 9000 } })
  q(13, { name = "Repeatable Bag", specialFlags = 1 })
  q(14, { name = "Level 60 Bag", level = 60, reqLevel = 60 })
  q(15, { name = "Blacklisted Pre", blacklisted = true })
  q(16, { name = "Bad Chain Bag", preGroup = { 15 } })
  q(17, { name = "Horde Bag", races = HORDE })
  q(18, { name = "Quiver Quest" })
  D.items[100] = { class = 1, subClass = 0, questRewards = { 3, 6, 10, 11, 12, 13, 14, 16, 17 } }
  D.items[101] = { class = 1, subClass = 2, questRewards = { 18 } }   -- carquois : pas un sac ordinaire
  D.items[102] = { class = 4, subClass = 1, questRewards = { 3 } }    -- armure : récompense, pas un sac
  D.xp[3] = { 10, 875 }
  return D
end

local function byKey(list)
  local out = {}
  for _, e in ipairs(list) do out[e.key] = e end
  return out
end

return {
  keeps_bag_quests_with_their_prerequisites = function(t)
    local D = fixture()
    local list = bq.build(D, "Alliance")
    local k = byKey(list)
    t.ok(k.BAG_3_A, "chain limited to the Alliance by its prerequisite: suffixed key")
    t.eq(table.concat(k.BAG_3_A.quests, ","), "1,3", "preQuestSingle: the first possible one for the faction")
    t.eq(k.BAG_3_A.faction, "Alliance")
    t.eq(k.BAG_3_A.bag, 100)
    t.eq(k.BAG_3_A.rewards[3].xp, 875)
    t.eq(#k.BAG_3_A.rewards[3].items, 2, "every reward item is kept for the popup")
    t.ok(k.BAG_6 and k.BAG_6.faction == nil, "chain open to both factions: key without suffix")
    t.eq(table.concat(k.BAG_6.quests, ","), "4,5,6", "preQuestGroup: all of them, then the quest")
    t.eq(k.BAG_6.level, 8, "level of the first quest of the chain")
  end,

  rejects_quests_the_route_cannot_offer = function(t)
    local D = fixture()
    local list, rejected = bq.build(D, "Alliance")
    local k = byKey(list)
    for _, id in ipairs({ 10, 11, 12, 13, 14, 16, 17, 18 }) do t.ok(not k["BAG_" .. id], "not kept: " .. id) end
    local why = {}
    for _, r in ipairs(rejected) do why[r.quest] = r.reason end
    t.eq(why[11], "dungeon (11)")
    t.eq(why[12], "reputation (12)")
    t.eq(why[13], "repeatable (13)")
    t.eq(why[14], "level (14)")
    t.eq(why[16], "blacklist (15)", "a prerequisite in the blacklist drops the chain")
    t.eq(why[17], nil, "a quest of the other faction is not even a rejection")
  end,

  faction_chains_and_merge = function(t)
    local D = fixture()
    local a = bq.build(D, "Alliance")
    local h = bq.build(D, "Horde")
    local kh = byKey(h)
    t.ok(kh.BAG_17_H and kh.BAG_17_H.faction == "Horde", "Horde-only chain: suffixed key")
    t.eq(table.concat(kh.BAG_3_H.quests, ","), "2,3", "Horde takes its own prerequisite")
    local merged = byKey(bq.merge(a, h))
    t.ok(merged.BAG_3_A and merged.BAG_3_H, "same quest, different chains: one entry per faction")
    t.eq(merged.BAG_3_A.faction, "Alliance")
    t.eq(table.concat(merged.BAG_3_H.quests, ","), "2,3")
    t.ok(merged.BAG_6 and merged.BAG_6.faction == nil, "same chain for both factions: one entry")
    t.ok(merged.BAG_17_H, "Horde-only entry kept")
  end,

  emitted_file_loads = function(t)
    local D = fixture()
    local data = bq.merge(bq.build(D, "Alliance"), bq.build(D, "Horde"))
    local text = bq.emit(data, { commit = "abc", date = "2026-11-08" })
    t.ok(text:find("QuestieDB commit abc, généré le 2026-11-08", 1, true), "header")
    local fn = assert(loadstring(text, "=BagQuestData.lua"))
    local Q = {}
    setfenv(fn, {})
    fn("Questify", Q)
    t.eq(#Q.BagQuestData, #data)
    local k = byKey(Q.BagQuestData)
    t.eq(k.BAG_3_H.races, HORDE, "races mask written as an integer")
    t.eq(k.BAG_6.quests[3], 6)
  end,
}
