-- Tests des objets de collecte achetables à l'hôtel des ventes (Engine/AuctionItems.lua, UI/AuctionPanel.lua,
-- alerte et ligne d'indice du suivi) : liste du chapitre en cours et du suivant, quantités (données, journal,
-- sacs), objets liés écartés, choix du joueur, prix des addons, alerte, recherche de l'HV, /qf hv.
local TOC = "Questify/Questify.toc"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local MEAT, CLOTH, BOOK, FANG = 7001, 7002, 7003, 7004
local AUCTIONEER = 90500

local function quest(name, items)
  local list = {}
  for _, id in ipairs(items) do list[#list + 1] = { id } end
  return { name = name, startedBy = { { 90501 } }, finishedBy = { { 90501 } }, requiredLevel = 1, questLevel = 2,
    objectives = { nil, nil, list } }
end

local QDB = {
  quests = {
    [9801] = quest("Meat Run", { MEAT }),
    [9802] = quest("Cloth Drive", { CLOTH }),
    [9803] = quest("Old Book", { BOOK }),
    [9804] = quest("Second Meat Run", { MEAT, FANG }),
  },
  npcs = {
    [90501] = { name = "Giver", spawns = { [1] = { { 50, 50 } } }, zoneID = 1, friendlyToFaction = "A" },
    [AUCTIONEER] = { name = "Auctioneer", spawns = { [1] = { { 80, 20 } } }, zoneID = 1, friendlyToFaction = "A",
      npcFlags = 4096 },
  },
  items = {
    [MEAT] = { name = "Turtle Meat", class = 7 }, [CLOTH] = { name = "Silk Cloth", class = 7 },
    [BOOK] = { name = "Old Book", class = 15 }, [FANG] = { name = "Wolf Fang", class = 7 },
  },
}

local function data()
  return {
    guides = {
      T_AH_1 = { { item = MEAT, quest = 9801, obj = 1, count = 10 }, { item = BOOK, quest = 9803, obj = 1 } },
      T_AH_2 = { { item = CLOTH, quest = 9802, obj = 1, count = 15 }, { item = MEAT, quest = 9804, obj = 1, count = 4 },
        { item = FANG, quest = 9804, obj = 2 } },
    },
    auctioneers = { A = { AUCTIONEER }, H = {} },
  }
end

local GUIDES = {
  { id = "T_AH_1", faction = "Alliance", minLevel = 1, maxLevel = 10, next = "T_AH_2", steps = {
    { "accept", 9801 }, { "accept", 9803 }, { "goto", 1426, 50, 50 }, { "complete", 9801, obj = 1 },
    { "complete", 9803 }, { "turnin", 9801 }, { "turnin", 9803 } } },
  { id = "T_AH_2", faction = "Alliance", minLevel = 10, maxLevel = 20, steps = {
    { "accept", 9802 }, { "accept", 9804 }, { "complete", 9802 }, { "complete", 9804 },
    { "turnin", 9802 }, { "turnin", 9804 } } },
}

local bags = {}
local function setBags(t) bags = t end

-- Objets connus du client : bindType 0 (aucun) sauf le livre (lié quand ramassé).
local function items()
  Mock.items[MEAT] = { name = "Turtle Meat", classID = 7, bindType = 0, texture = 1001 }
  Mock.items[CLOTH] = { name = "Silk Cloth", classID = 7, bindType = 0, texture = 1002 }
  Mock.items[BOOK] = { name = "Old Book", classID = 15, bindType = 1, texture = 1003 }
  Mock.items[FANG] = { name = "Wolf Fang", classID = 7, bindType = 2, texture = 1004 }
end

local function load(opts)
  opts = opts or {}
  Ext.install()
  setBags(opts.bags or {})
  if not opts.noItems then items() end
  local Q = Mock.loadAddon(TOC, { skipGuides = true, qdb = QDB,
    savedVariables = { QuestifyCharDB = { wizardDone = true } },
    beforeLogin = function(Q)
      Q.AuctionItemData = opts.data or data()
      Q.ClassQuestData, Q.BagQuestData = {}, {}
      for _, g in ipairs(GUIDES) do Q:RegisterGuide(g) end
    end })
  C_Item.GetItemCount = function(id) return bags[id] or 0 end
  Q.Progress:SetGuide("T_AH_1")
  Q.Progress:Update()
  return Q
end

local function rowFor(rows, item)
  for _, r in ipairs(rows) do if r.item == item then return r end end
  return nil
end
local function plain(s) return (tostring(s or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|H.-|h", ""):gsub("|h", "")) end
local function qf(msg) SlashCmdList.QUESTIFY(msg) end

-- Joueur à `yards` à l'est de l'encanteur.
local function nearAuctioneer(Q, yards)
  local m, x, y
  for mapId, list in pairs(Q.QDB:Npc(AUCTIONEER).spawns) do m, x, y = mapId, list[1][1], list[1][2] end
  local unit = Q.Maps:Distance(m, x, y, m, x + 1, y)
  Mock.player.map, Mock.player.x, Mock.player.y = m, x + yards / unit, y
end

return {
  lists_current_then_next_chapter_with_bag_counts = function(t)
    local Q = load({ bags = { [MEAT] = 3 } })
    local rows = Q.AuctionItems:Rows()
    local meat, cloth = rowFor(rows, MEAT), rowFor(rows, CLOTH)
    t.ok(meat and cloth, "meat and cloth listed")
    t.eq(meat.chapter, "current")
    -- 10 (chapitre en cours) + 4 (chapitre suivant) - 3 dans les sacs
    t.eq(meat.total, 14)
    t.eq(meat.have, 3)
    t.eq(meat.need, 11)
    t.eq(meat.quests, { 9801, 9804 })
    t.eq(cloth.chapter, "next")
    t.eq(cloth.need, 15)
    t.eq(rows[1].item, MEAT, "current chapter first")
  end,

  bound_items_are_left_out = function(t)
    local Q = load()
    t.eq(rowFor(Q.AuctionItems:Rows(), BOOK), nil, "bind on pickup")
    Mock.items[CLOTH].classID = 12
    t.eq(rowFor(Q.AuctionItems:Rows(), CLOTH), nil, "quest item class")
    Mock.items[CLOTH].classID, Mock.items[CLOTH].bindType = 7, 4
    t.eq(rowFor(Q.AuctionItems:Rows(), CLOTH), nil, "quest bind")
    t.ok(rowFor(Q.AuctionItems:Rows(), FANG), "bind on equip stays")
  end,

  unknown_count_counts_one_and_is_marked = function(t)
    local Q = load()
    local fang = rowFor(Q.AuctionItems:Rows(), FANG)
    t.eq(fang.need, 1)
    t.eq(fang.approx, true)
  end,

  item_not_cached_waits_for_the_server = function(t)
    local asked = {}
    C_Item.RequestLoadItemDataByID = function(id) asked[id] = true end
    local Q = load({ noItems = true })
    local meat = rowFor(Q.AuctionItems:Rows(), MEAT)
    t.eq(meat.state, "loading")
    t.ok(asked[MEAT], "item data requested")
    t.eq(#Q.AuctionItems:Wanted(), 0, "nothing offered while loading")
    items()
    Mock.fire("GET_ITEM_INFO_RECEIVED", MEAT, true)
    t.eq(rowFor(Q.AuctionItems:Wanted(), MEAT).need, 14)
  end,

  quest_in_log_uses_client_counts_and_partial_buy_keeps_the_step = function(t)
    local Q = load({ bags = { [MEAT] = 6 } })
    Mock.quests.log[9801] = { complete = false,
      objectives = { { text = "Turtle Meat: 6/12", type = "item", numRequired = 12, numFulfilled = 6 } } }
    Q.Progress:Update()
    local meat = rowFor(Q.AuctionItems:Rows(), MEAT)
    t.eq(meat.total, 16, "12 from the journal + 4 from the next chapter")
    t.eq(meat.need, 10)
    -- achat partiel : l'étape de collecte reste à faire, avec le reste à farmer
    local entries = Q.Progress:Entries()
    local gotoE, complete = entries[3], entries[4]
    t.eq(complete.step.action, "complete")
    t.eq(Q.Progress:State(complete), "active")
    -- tout est couvert : l'objectif est fait, l'étape aussi (et le « goto » qui la précède est dépassé)
    setBags({ [MEAT] = 12 })
    Mock.quests.log[9801].objectives[1] = { text = "Turtle Meat: 12/12", type = "item", numRequired = 12,
      numFulfilled = 12, finished = true }
    Q.Progress:Invalidate()
    Q.Progress:Update()
    t.eq(Q.Progress:State(complete), "done", "collect step done")
    t.eq(Q.Progress:State(gotoE), "done", "travel to the farm spot passed")
    meat = rowFor(Q.AuctionItems:Rows(), MEAT)
    t.eq(meat.quests, { 9804 }, "only the next chapter still needs meat")
    t.eq(meat.need, 4, "bag items stay reserved for the filled quest")
    t.eq(meat.chapter, "next")
  end,

  turned_in_quests_and_covered_items_drop_out = function(t)
    local Q = load({ bags = { [CLOTH] = 15 } })
    t.eq(rowFor(Q.AuctionItems:Rows(), CLOTH), nil, "covered by bags")
    Mock.quests.completed[9801] = true
    Q.Progress:Invalidate()
    Q.Progress:Update()
    t.eq(rowFor(Q.AuctionItems:Rows(), MEAT).quests, { 9804 })
  end,

  unchecked_items_are_kept_in_the_list_but_not_offered = function(t)
    local Q = load()
    Q.AuctionItems:SetSkipped(MEAT, true)
    t.eq(rowFor(Q.AuctionItems:Rows(), MEAT).skipped, true)
    t.eq(rowFor(Q.AuctionItems:Wanted(), MEAT), nil)
    t.eq(Q.char.auction.skip[MEAT], true, "saved per character")
    qf("hv reset")
    t.ok(Mock.printed("1"), "reset count printed")
    t.ok(rowFor(Q.AuctionItems:Wanted(), MEAT), "offered again")
  end,

  prices_come_from_the_first_price_addon = function(t)
    local Q = load()
    t.eq(Q.AuctionItems:Price(MEAT), nil, "no price addon")
    LOA_DATA = { houses = { ["1A"] = { latS = "7002,250,200,5,3,0\n7001,180,0,4,2,0" } } }
    local p, src = Q.AuctionItems:Price(MEAT)
    t.eq(p, 180); t.eq(src, "LifeOnAzeroth")
    t.eq((Q.AuctionItems:Price(CLOTH)), 200, "cheapest listing when lower")
    LOA_DATA.houses["1A"] = { lat = { [MEAT] = { 170, 160 } } }
    t.eq((Q.AuctionItems:Price(MEAT)), 160, "parsed table")
    TSM_API = { GetCustomPriceValue = function(src, key) if key == "i:" .. MEAT then return 150 end end }
    p, src = Q.AuctionItems:Price(MEAT)
    t.eq(p, 150); t.eq(src, "TSM")
    Auctionator = { API = { v1 = { GetAuctionPriceByItemID = function(caller, id) return id == MEAT and 140 or nil end } } }
    p, src = Q.AuctionItems:Price(MEAT)
    t.eq(p, 140); t.eq(src, "Auctionator")
    Auctionator.API.v1.GetAuctionPriceByItemID = function() error("boom") end
    t.eq((select(2, Q.AuctionItems:Price(MEAT))), "TSM", "a failing addon is skipped")
    LOA_DATA = { houses = "garbage" }
    TSM_API, Auctionator = nil, nil
    t.eq(Q.AuctionItems:Price(MEAT), nil, "unexpected format: no price")
    t.eq(#Mock.errors, 0)
  end,

  chapter_start_alert_and_chat_line_once = function(t)
    local Q = load()
    Q.Progress:SetGuide("T_AH_2")
    Q.Progress:SetGuide("T_AH_1")
    t.ok(Mock.printed("Turtle Meat"), "chat line")
    t.eq(Mock.countPrinted("can be bought at the auction house"), 2, "one per chapter")
    local a = Q.AuctionItems:Alert()
    t.ok(a and a.count >= 2, "alert at chapter start")
    local tr = Q.UI.Tracker
    tr:Refresh()
    t.ok(tr.ahAlert:IsShown())
    t.ok(plain(tr.ahText:GetText()):find("quest items at the auction house"), plain(tr.ahText:GetText()))
    Mock.advance(16 * 60)
    t.eq(Q.AuctionItems:Alert(), nil, "gone after the start window")
    Q.Progress:SetGuide("T_AH_2")
    Q.Progress:SetGuide("T_AH_1")
    t.eq(Mock.countPrinted("can be bought at the auction house"), 2, "not repeated")
  end,

  alert_near_an_auctioneer_and_right_click_hides_it = function(t)
    local Q = load()
    Mock.advance(16 * 60)
    nearAuctioneer(Q, 400)
    Mock.advance(6)
    t.eq(Q.AuctionItems:Alert(), nil, "far")
    nearAuctioneer(Q, 40)
    Mock.advance(6)
    t.ok(Q.AuctionItems:Alert(), "near")
    local tr = Q.UI.Tracker
    tr:Refresh()
    Mock.click(tr.ahAlert, "RightButton")
    t.eq(Q.AuctionItems:Alert(), nil, "hidden for the chapter")
    t.ok(not tr.ahAlert:IsShown())
  end,

  hint_line_under_the_step_shows_the_item_tooltip = function(t)
    local Q = load({ bags = { [MEAT] = 2 } })
    local tr = Q.UI.Tracker
    -- étape « Prendre » de la quête 9801
    t.eq(Q.Progress:Current().step.action, "accept")
    tr:Refresh()
    local h = tr.ahHints and tr.ahHints[1]
    t.ok(h and h.row:IsShown(), "hint shown")
    t.ok(plain(h.text:GetText()):find("or at the auction house: 12 × Turtle Meat", 1, true), plain(h.text:GetText()))
    h.row:GetScript("OnEnter")(h.row)
    t.eq(Mock.tooltip.items[#Mock.tooltip.items], MEAT, "bag-like item tooltip")
    t.ok(Ext.tooltipHas("12 missing for Meat Run"))
    Mock.click(h.row)
    t.ok(Q.UI.AuctionPanel.list:IsShown(), "click opens the list")
    -- objet décoché : plus de ligne
    Q.AuctionItems:SetSkipped(MEAT, true)
    tr:Refresh()
    t.ok(not h.row:IsShown(), "hint hidden once unchecked")
  end,

  list_window_rows_checkboxes_and_total = function(t)
    local Q = load()
    Auctionator = { API = { v1 = { GetAuctionPriceByItemID = function(_, id) return id == MEAT and 168 or nil end } } }
    local P = Q.UI.AuctionPanel
    qf("hv")
    t.ok(P.list:IsShown())
    local r1 = P.rows[1]
    t.eq(r1.item, MEAT)
    t.eq(r1.name:GetText(), "Turtle Meat")
    t.eq(r1.qty:GetText(), "14")
    t.ok(r1.check:GetChecked())
    t.ok(plain(P.sum:GetText()):find("Auctionator", 1, true), plain(P.sum:GetText()))
    t.ok(plain(P.scope:GetText()):find("T_AH_1", 1, true) or plain(P.scope:GetText()) ~= "", "chapters line")
    t.eq(P.heads[1]:GetText(), "Current chapter")
    t.eq(P.heads[2]:GetText(), "Next chapter")
    r1.check:SetChecked(false)
    Mock.click(r1.check)
    t.eq(Q.char.auction.skip[MEAT], true, "unchecking saves the choice")
    t.eq(P.rows[1].item, MEAT, "unchecked rows stay in the list")
    Mock.click(P.allButton)
    t.eq(Q.char.auction.skip[CLOTH], true, "uncheck all")
    t.eq(P.allButton:GetText(), "Check all")
    Mock.click(P.allButton)
    t.eq(Q.char.auction.skip[MEAT], nil, "check all")
    t.eq(Q.char.auction.skip[CLOTH], nil)
    qf("hv")
    t.ok(not P.list:IsShown(), "/qf hv toggles")
    Auctionator = nil
  end,

  auction_house_panel_searches_and_tracks_bags = function(t)
    local Q = load()
    local searched, started = nil, 0
    AuctionHouseFrame = CreateFrame("Frame", "AuctionHouseFrame", UIParent)
    AuctionHouseFrame.SearchBar = { SearchBox = { SetText = function(_, s) searched = s end },
      StartSearch = function() started = started + 1 end }
    Mock.fire("AUCTION_HOUSE_SHOW")
    Mock.advance(0.1)
    local P = Q.UI.AuctionPanel
    t.ok(P.shop and P.shop:IsShown(), "shopping list beside the auction house")
    t.eq(Q.AuctionItems:Alert(), nil, "no tracker alert while the AH is open")
    local r = P.shopRows[1]
    t.eq(r.item, MEAT)
    Mock.click(r.search)
    t.eq(searched, '"Turtle Meat"')
    t.eq(started, 1)
    t.eq(Mock.countCalls("PlaceBid") + Mock.countCalls("StartCommoditiesPurchase"), 0, "never buys")
    -- achat : la ligne reste, faite, jusqu'à la fermeture
    setBags({ [MEAT] = 14 })
    Mock.fire("BAG_UPDATE_DELAYED")
    t.eq(P.shopRows[1].item, MEAT)
    t.ok(plain(P.shopRows[1].prog:GetText()):find("14/14", 1, true), plain(P.shopRows[1].prog:GetText()))
    t.ok(not P.shopRows[1].search:IsEnabled(), "search disabled once covered")
    Mock.fire("AUCTION_HOUSE_CLOSED")
    t.ok(not P.shop:IsShown())
    AuctionHouseFrame = nil
  end,

  option_off_hides_everything = function(t)
    local Q = load()
    Q.Settings:Set("auctionItems", false)
    t.eq(#Q.AuctionItems:Wanted(), 0)
    t.eq(Q.AuctionItems:Alert(), nil)
    t.eq(Q.AuctionItems:HintFor(Q.Progress:Current()), nil)
    qf("hv")
    t.ok(Mock.printed("turned off"), "slash explains")
  end,

  strings_exist_in_english_and_french = function(t)
    local Q = load()
    local src = io.open(Mock.root .. "/Questify/Locales/StringsAuction.lua"):read("*a")
    local en = src:match("enUS = (%b{})")
    local fr = src:match("frFR = (%b{})")
    local keys = {}
    for k in en:gmatch("\n%s*([%u_]+) = ") do keys[#keys + 1] = k end
    t.ok(#keys > 20, "keys found")
    for _, k in ipairs(keys) do
      t.ok(fr:find("\n%s*" .. k .. " = "), "frFR misses " .. k)
      t.ok(type(Q.L[k]) == "string", "missing " .. k)
    end
  end,
}
