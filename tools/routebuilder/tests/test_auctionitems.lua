-- Tests de auctionitems.lua (objets de collecte achetables à l'HV -> AuctionItemData.lua), sur des données
-- synthétiques : aucun ne demande QuestieDB.
local ai = require("auctionitems")

local function fixture()
  local D = { quests = {}, items = {}, npcs = {}, objects = {} }
  D.items[1] = { name = "Turtle Meat", class = 7, vendors = {} }
  D.items[2] = { name = "Gnoll Paw", class = 12, vendors = {} }
  D.items[3] = { name = "Soothing Spices", class = 7, vendors = { 99 } }
  D.items[4] = { name = "Given Box", class = 15, vendors = {} }
  D.items[5] = { name = "Silk Cloth", class = 7, vendors = {} }
  local function q(id, items, text, extra)
    local list = {}
    for i, it in ipairs(items) do list[i] = { kind = "item", id = it, index = i } end
    D.quests[id] = { id = id, name = "Q" .. id, objectives = { list = list }, objectivesText = { text },
      requiredSourceItems = extra and extra.source or {} }
  end
  q(10, { 1, 2 }, "Bring 8 Turtle Meat and 5 Gnoll Paw.")
  q(11, { 3, 4 }, "Bring 2 Soothing Spices and the Given Box.", { source = { 4 } })
  q(12, { 5 }, "Collect Silk Cloth.")
  D.npcs[100] = { npcFlags = 4096 + 2, friendly = "A", spawns = { [1453] = { { 61, 70 } } } }
  D.npcs[101] = { npcFlags = 4096, friendly = "AH", spawns = { [1434] = { { 26, 76 } } } }
  D.npcs[102] = { npcFlags = 4096, friendly = "H", spawns = {} }   -- sans position
  D.npcs[103] = { npcFlags = 2, friendly = "H", spawns = { [1454] = { { 50, 50 } } } }
  return D
end

return {
  rejects_quest_items_vendor_items_and_given_items = function(t)
    local D = fixture()
    t.eq(ai.reject(D, D.quests[10], 1), nil)
    t.eq(ai.reject(D, D.quests[10], 2), "quest item")
    t.eq(ai.reject(D, D.quests[11], 3), "vendor")
    t.eq(ai.reject(D, D.quests[11], 4), "given by the quest")
    t.eq(ai.reject(D, D.quests[10], 999), "unknown item")
  end,

  lists_items_in_step_order_with_counts_once = function(t)
    local D = fixture()
    local def = { id = "T", steps = {
      { "accept", 12 }, { "complete", 12 }, { "complete", 10, obj = 1 }, { "turnin", 10 }, { "turnin", 12 },
      { "complete", 11 } } }
    local list = ai.forGuide(D, def)
    t.eq(#list, 2)
    t.eq(list[1].item, 5); t.eq(list[1].quest, 12); t.eq(list[1].count, nil)
    t.eq(list[2].item, 1); t.eq(list[2].quest, 10); t.eq(list[2].obj, 1); t.eq(list[2].count, 8)
  end,

  auctioneers_by_friendly_faction_with_positions = function(t)
    local a = ai.auctioneers(fixture())
    t.eq(table.concat(a.A, ","), "100,101")
    t.eq(table.concat(a.H, ","), "101")
  end,

  emits_loadable_data = function(t)
    local D = fixture()
    local list = ai.forGuide(D, { id = "T", steps = { { "complete", 10 } } })
    local text = ai.emit({ { id = "T", list = list }, { id = "EMPTY", list = {} } }, ai.auctioneers(D),
      { commit = "abc", date = "2026-11-16" })
    local fn = assert(loadstring(text))
    local Q = {}
    fn("Questify", Q)
    t.eq(Q.AuctionItemData.guides.T[1].item, 1)
    t.eq(Q.AuctionItemData.guides.T[1].count, 8)
    t.eq(Q.AuctionItemData.guides.EMPTY, nil)
    t.eq(Q.AuctionItemData.auctioneers.H[1], 101)
  end,
}
