-- Tests des quêtes qui donnent un sac (Q.BagQuests, Q.BagQuestOffer) : taille d'un sac lue dans l'infobulle,
-- utilité selon les sacs portés, étape « bagquest » proposée près du donneur, ajout, refus, /qf sacs.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local DATA_FILE = "Questify/Guides/BagQuestData.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local NPCS = {
  [90400] = { name = "Bag Giver", minLevel = 10, maxLevel = 10, spawns = { [1] = { { 30.5, 71.0 } } },
    zoneID = 1, friendlyToFaction = "A" },
  [90401] = { name = "Far Bag Giver", minLevel = 10, maxLevel = 10, spawns = { [12] = { { 40, 60 } } },
    zoneID = 12, friendlyToFaction = "A" },
}
local function quest(name, giver, pre, reqLevel)
  return { name = name, startedBy = { { giver } }, finishedBy = { { giver } }, requiredLevel = reqLevel or 1,
    questLevel = (reqLevel or 1) + 1,
    objectivesText = { "Talk." }, preQuestSingle = pre }
end
local QDB = {
  npcs = NPCS,
  quests = {
    [9901] = quest("Bag Prelude", 90400), [9902] = quest("Bag Reward", 90400, { 9901 }),
    [9903] = quest("Far Bag Reward", 90401),
    [9904] = quest("Later Bag Reward", 90400, nil, 12),
  },
  items = { [5001] = { name = "Test Satchel" }, [5002] = { name = "Far Satchel" } },
}

local function entry(key, bag, quests, level)
  return { key = key, title = key, level = level or 1, bag = bag, quests = quests, rewards = {} }
end
local function data()
  return {
    entry("BAG_9902", 5001, { 9901, 9902 }),
    entry("BAG_FAR", 5002, { 9903 }),
  }
end

-- Sacs portés : sizes[1..4] (0 = emplacement vide), families[bag] (0 = sac ordinaire).
local function bags(sizes, families)
  C_Container = C_Container or {}
  C_Container.GetContainerNumSlots = function(bag)
    if bag == 0 then return 16 end
    return sizes[bag] or 0
  end
  C_Container.GetContainerNumFreeSlots = function(bag) return 0, (families or {})[bag] or 0 end
end

-- Infobulles des objets : [itemId] = nombre d'emplacements (ligne « N Slot Bag »).
local function tooltips(slots)
  C_TooltipInfo.GetItemByID = function(id)
    local n = slots[id]
    if not n then return nil end
    return { lines = { { leftText = "Item " .. id }, { leftText = n .. " Slot Bag" } } }
  end
end

local function load(opts)
  opts = opts or {}
  Ext.install()
  bags(opts.bags or { 6, 6, 6, 6 }, opts.families)
  tooltips(opts.slots or { [5001] = 8, [5002] = 8 })
  local d = opts.data or data()
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true, qdb = QDB,
    savedVariables = { QuestifyCharDB = { wizardDone = true } },
    beforeLogin = function(Q) Q.BagQuestData = d; Q.ClassQuestData = {} end })
end

-- Joueur à `yards` à l'est du donneur 90400.
local function away(Q, yards)
  local m, x, y
  for mapId, list in pairs(Q.QDB:Npc(90400).spawns) do m, x, y = mapId, list[1][1], list[1][2] end
  local unit = Q.Maps:Distance(m, x, y, m, x + 1, y)
  Mock.player.map, Mock.player.x, Mock.player.y = m, x + yards / unit, y
end

local function has(Q, key) return Q.BagQuestOffer:Has(key) end
local function plain(s) return (tostring(s or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")) end
local function qf(msg) SlashCmdList.QUESTIFY(msg) end

return {
  slots_read_from_game_strings = function(t)
    local Q = load()
    local BQ = Q.BagQuests
    CONTAINER_SLOTS = "%d Slot %s"
    t.eq(BQ.SlotsFromText("8 Slot Bag"), 8)
    t.eq(BQ.SlotsFromText("Bag"), nil)
    CONTAINER_SLOTS = "%s à %d emplacements"
    t.eq(BQ.SlotsFromText("Sac à 10 emplacements"), 10, "number after the text")
    CONTAINER_SLOTS = "%1$d Slot %2$s"
    t.eq(BQ.SlotsFromText("12 Slot Bag"), 12, "positional arguments")
    CONTAINER_SLOTS = nil
    t.eq(BQ.SlotsFromText("14 Slot Bag"), 14, "English fallback without the game string")
    t.eq(BQ:BagSlots(5001), 8, "read from the item tooltip")
    t.eq(BQ:BagSlots(4242), nil, "unknown item")
  end,

  useful_compares_with_the_smallest_regular_bag = function(t)
    local Q = load({ bags = { 6, 10, 10, 10 } })
    local BQ = Q.BagQuests
    local e = BQ:Find("BAG_9902")
    t.eq(BQ:Equipped(), { empty = 0, sizes = { 6, 10, 10, 10 } })
    t.eq((BQ:Useful(e)), true, "8 slots beat a 6-slot bag")
    bags({ 10, 10, 10, 10 })
    t.eq((BQ:Useful(e)), false, "every bag is bigger")
    bags({ 10, 10, 10, 0 })
    t.eq((BQ:Useful(e)), true, "an empty bag slot")
    bags({ 10, 10, 10, 4 }, { [4] = 1 })
    t.eq(BQ:Equipped(), { empty = 0, sizes = { 10, 10, 10 } }, "a quiver is neither counted nor replaced")
    t.eq((BQ:Useful(e)), false)
    -- taille inconnue : utile seulement avec un emplacement vide
    tooltips({})
    local Q2 = load({ bags = { 6, 6, 6, 6 }, slots = {} })
    t.eq((Q2.BagQuests:Useful(Q2.BagQuests:Find("BAG_9902"))), false, "unknown size, no empty slot")
    bags({ 6, 6, 6, 0 })
    t.eq((Q2.BagQuests:Useful(Q2.BagQuests:Find("BAG_9902"))), true, "unknown size, empty slot")
  end,

  states_follow_progress = function(t)
    local Q = load()
    local BQ = Q.BagQuests
    local function state(key)
      for _, row in ipairs(BQ:List()) do if row.entry.key == key then return row.state end end
    end
    t.eq(state("BAG_9902"), "available")
    t.eq(BQ:FirstQuest(BQ:Find("BAG_9902")), 9901)
    Mock.quests.completed[9901] = true
    t.eq(BQ:FirstQuest(BQ:Find("BAG_9902")), 9902, "prelude turned in: the bag quest is next")
    Mock.quests.completed[9902] = true
    t.eq(state("BAG_9902"), "done")
    local Q2 = load({ data = { entry("BAG_LATER", 5001, { 9904 }, 12) } })
    t.eq(Q2.BagQuests:List()[1].state, "upcoming", "required level 12 not reached")
    Mock.player.level = 12
    Mock.fire("PLAYER_LEVEL_UP", 12)
    t.eq(Q2.BagQuests:List()[1].state, "available")
  end,

  quest_already_in_the_route_is_not_offered = function(t)
    -- 3364 est rendue par le chapitre de test : la route fait déjà la quête
    local Q = load({ data = { entry("BAG_ROUTE", 5001, { 3364 }) } })
    t.eq(Q.BagQuests:List()[1].state, "inroute")
    t.eq(Q.BagQuests:Add("BAG_ROUTE"), false, "no copy of a quest of the route")
  end,

  offer_inserted_near_the_giver_when_useful = function(t)
    local Q = load()
    away(Q, 300)
    Mock.advance(5)
    t.ok(not has(Q, "BAG_9902"), "300 yards: no offer")
    away(Q, 100)
    Mock.advance(5)
    t.ok(has(Q, "BAG_9902"), "100 yards: offer")
    local cur = Q.Progress:Current()
    t.eq(cur.step.action, "bagquest")
    t.eq(cur.step.key, "BAG_9902")
    t.eq(plain(Q.Format:StepTitle(cur)), "Bag quest: Bag Reward")
    local target = Q.Targets:ForEntry(cur)
    t.ok(target and target.id == 90400, "the arrow points at the giver of the first quest")
    t.eq(#Mock.errors, 0)
  end,

  no_offer_when_the_bags_are_already_better = function(t)
    local Q = load({ bags = { 10, 10, 10, 10 } })
    away(Q, 100)
    Mock.advance(5)
    t.ok(not has(Q, "BAG_9902"), "bigger bags: nothing to offer")
    bags({ 6, 10, 10, 10 })
    Mock.advance(5)
    t.ok(has(Q, "BAG_9902"), "a smaller bag: offered")
    bags({ 12, 12, 12, 12 })
    Mock.advance(5)
    t.ok(not has(Q, "BAG_9902"), "bags bought in the meantime: the offer goes")
  end,

  click_opens_the_popup_and_add_inserts_the_chain = function(t)
    local Q = load()
    away(Q, 100)
    Mock.advance(5)
    Mock.click(Q.UI.Tracker.current, "LeftButton")
    local P = Q.UI.ClassQuestPopup
    t.ok(P.frame:IsShown(), "popup opened by the click")
    t.eq(P.kind, "bag")
    t.eq(P.chain.key, "BAG_9902")
    t.eq(plain(P.title:GetText()), "Bag Reward")
    t.ok(plain(P.bagInfo:GetText()):find("Test Satchel (8 slots)", 1, true), plain(P.bagInfo:GetText()))
    t.ok(plain(P.bagInfo:GetText()):find("Your bags: 6, 6, 6, 6", 1, true), plain(P.bagInfo:GetText()))
    Mock.click(P.addButton, "LeftButton")
    t.ok(not has(Q, "BAG_9902"), "offer gone")
    t.eq(Q.char.bagQuests.added.BAG_9902, true)
    local cur = Q.Progress:Current()
    t.eq(cur.step.action, "accept")
    t.eq(cur.step.questId, 9901, "prerequisite first")
    local found = false
    for _, p in ipairs(Mock.prints) do if plain(p):find("Bag quest added to the route: Bag Reward", 1, true) then found = true end end
    t.ok(found, "chat message")
    Mock.advance(10)
    t.ok(not has(Q, "BAG_9902"), "never offered again once added")
    t.eq(#Mock.errors, 0)
  end,

  class_popup_still_shows_class_chains = function(t)
    local Q = load()
    local P = Q.UI.ClassQuestPopup
    away(Q, 100)
    Mock.advance(5)
    Mock.click(Q.UI.Tracker.current, "LeftButton")
    t.eq(P.kind, "bag")
    P:Show({ key = "WARLOCK_X", title = "Chain X", level = 3, quests = { 9903 }, rewards = {} })
    t.eq(P.kind, nil, "class mode again")
    t.ok(not P.bagInfo:IsShown(), "no bag line for a class chain")
    t.eq(plain(P.title:GetText()), "Far Bag Reward", "class chains keep the first quest name")
  end,

  ignore_then_reset = function(t)
    local Q = load()
    away(Q, 100)
    Mock.advance(5)
    Mock.click(Q.UI.Tracker.current, "LeftButton")
    Mock.click(Q.UI.ClassQuestPopup.ignoreButton, "LeftButton")
    t.eq(Q.char.bagQuests.ignored.BAG_9902, true)
    t.ok(not has(Q, "BAG_9902"))
    Mock.advance(10)
    t.ok(not has(Q, "BAG_9902"), "ignored: not offered again")
    qf("sacs reset")
    t.eq(Q.char.bagQuests.ignored.BAG_9902, nil)
    Mock.advance(5)
    t.ok(has(Q, "BAG_9902"), "offered again after /qf sacs reset")
  end,

  slash_lists_the_bag_quests = function(t)
    local Q = load()
    Mock.prints = {}
    qf("bags")
    local text = {}
    for _, p in ipairs(Mock.prints) do text[#text + 1] = plain(p) end
    text = table.concat(text, "\n")
    t.ok(text:find("Bag quests (your bags: 6, 6, 6, 6):", 1, true), text)
    t.ok(text:find("Bag Reward: 8 slots, available (bigger than your bags)", 1, true), text)
    t.eq(#Mock.errors, 0)
  end,

  setting_off_removes_the_offer = function(t)
    local Q = load()
    away(Q, 100)
    Mock.advance(5)
    t.ok(has(Q, "BAG_9902"))
    Q.Settings:Set("bagQuestOffer", false)
    t.ok(not has(Q, "BAG_9902"), "option off: the offer goes")
    Mock.advance(10)
    t.ok(not has(Q, "BAG_9902"))
    Q.Settings:Set("bagQuestOffer", true)
    Mock.advance(5)
    t.ok(has(Q, "BAG_9902"), "option on again")
  end,

  generated_data_is_well_formed = function(t)
    local fn = assert(loadfile(Mock.root .. "/" .. DATA_FILE))
    local Q = {}
    setfenv(fn, {})
    fn("Questify", Q)
    t.ok(type(Q.BagQuestData) == "table" and #Q.BagQuestData > 0, "entries")
    local keys = {}
    for _, e in ipairs(Q.BagQuestData) do
      t.ok(type(e.key) == "string" and not keys[e.key], "unique key " .. tostring(e.key))
      keys[e.key] = e
      t.ok(type(e.bag) == "number" and type(e.level) == "number" and #e.quests > 0, e.key)
      t.ok(e.faction == nil or e.faction == "Alliance" or e.faction == "Horde", e.key)
      local last = e.quests[#e.quests]
      local items = e.rewards[last] and e.rewards[last].items or {}
      local rewarded = false
      for _, id in ipairs(items) do if id == e.bag then rewarded = true end end
      t.ok(rewarded, e.key .. ": the last quest rewards the bag")
    end
    t.ok(keys.BAG_791_H and keys.BAG_791_H.bag == 11845, "Carry Your Weight (Durotar)")
    t.ok(keys.BAG_151_A and keys.BAG_151_A.bag == 1537, "Poor Old Blanchy (Westfall)")
    t.ok(keys.BAG_92515_A and keys.BAG_92515_H, "faction-specific chains keep both factions")
  end,
}
