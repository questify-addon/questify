-- Tests des marques sur les récompenses au choix (Q.Rewards:Marks, UI/RewardMarks.lua), du test
-- d'amélioration commun (Q.Rewards:UpgradeVerdict) et du réglage rewardPick.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

local STR, STA, INT = "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_INTELLECT_SHORT"
local ARMOR = "RESISTANCE0_NAME"

-- Fenêtre de récompense du jeu (QuestInfoFrame.rewardsFrame.RewardButtons), un bouton par choix.
local function installQuestInfo(n, questLog)
  local rewards = Mock.newObject("Frame", "QuestInfoRewardsFrame", UIParent)
  rewards.RewardButtons = {}
  for i = 1, n do
    local b = Mock.newObject("Button", "QuestInfoRewardsFrameQuestInfoItem" .. i, rewards)
    b.type, b.objectType = "choice", "item"
    b:SetID(i)
    b.Icon = b:CreateTexture(nil, "ARTWORK")
    rewards.RewardButtons[i] = b
  end
  QuestInfoFrame = { rewardsFrame = rewards, questLog = questLog }
  QuestInfo_Display = function() end
  -- quantité des choix : Mock.questFrame.choices[i].count
  GetQuestItemInfo = function(kind, i)
    local c = kind == "choice" and Mock.questFrame.choices[i]
    if not c then return nil end
    return "x", 134400, c.count or 1, 1, true, nil
  end
  return rewards
end

local function load(n, setup)
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES }, beforeLogin = function()
    if n then installQuestInfo(n) end
    if setup then setup() end
  end })
end

local function item(id, def)
  def.id, def.link = id, "item:" .. id
  def.name = def.name or ("Item " .. id)
  def.minLevel = def.minLevel or 1
  Mock.items[id] = def
  return def.link
end

-- Guerrier niveau 10 : coiffe en mailles (amélioration), coiffe en tissu (moins bonne), anneau cher
-- (amélioration aussi : emplacements vides), viande (pas un équipement).
local function catalog()
  item(9001, { name = "Linen Cowl", equipLoc = "INVTYPE_HEAD", classID = 4, subclassID = 1, sellPrice = 30,
    stats = { [INT] = 4 } })
  item(9002, { name = "Ringmail Coif", equipLoc = "INVTYPE_HEAD", classID = 4, subclassID = 3, sellPrice = 60,
    stats = { [STR] = 5, [STA] = 2, [ARMOR] = 40 } })
  item(9003, { name = "Gold Ring", equipLoc = "INVTYPE_FINGER", classID = 4, subclassID = 0, sellPrice = 200,
    stats = { [STA] = 1 } })
  item(9004, { name = "Wolf Meat", equipLoc = "", classID = 7, subclassID = 8, sellPrice = 200 })
  item(9005, { name = "Old Helm", equipLoc = "INVTYPE_HEAD", classID = 4, subclassID = 3, sellPrice = 5,
    stats = { [STR] = 3, [STA] = 3, [ARMOR] = 30 } })
end

local warrior = { classFile = "WARRIOR", level = 10 }

local function choices(...)
  local list = {}
  for i, c in ipairs({ ... }) do
    list[i] = type(c) == "table" and c or { link = c }
  end
  Mock.questFrame.choices = list
end

local function marksOf(Q)
  return Q.Rewards:Marks(Q.Rewards:CollectChoices(), warrior)
end

return {
  verdict_upgrade_no_wait = function(t)
    local Q = load()
    catalog()
    local R = Q.Rewards
    local v, gain = R:UpgradeVerdict(R:ReadItem("item:9002"), warrior)
    t.eq(v, "upgrade"); t.ok(gain > 0)
    t.eq(R:UpgradeVerdict(R:ReadItem("item:9004"), warrior), "no", "not equippable")
    Mock.inventory[1] = "item:9002"
    t.eq(R:UpgradeVerdict(R:ReadItem("item:9005"), warrior), "no", "worse than the worn helm")
    t.eq(R:UpgradeVerdict(R:ReadItem("item:777"), warrior), "wait", "not cached yet")
  end,

  upgrade_popup_uses_shared_verdict = function(t)
    local Q = load()
    catalog()
    Q.Player.classFile, Q.Player.level = "WARRIOR", 10
    t.eq((Q.UI.UpgradePopup or Q.UpgradePopup):Evaluate("item:9002"), "upgrade")
    t.eq((Q.UI.UpgradePopup or Q.UpgradePopup):Evaluate("item:777"), "wait")
  end,

  marks_arrow_on_each_upgrade_coin_on_most_valuable = function(t)
    local Q = load()
    catalog()
    Mock.inventory[1] = "item:9005"   -- casque porté : la coiffe en tissu n'améliore pas
    choices("item:9001", "item:9002", "item:9003")
    local m = marksOf(Q)
    t.eq(m[1].upgrade, false); t.eq(m[1].verdict, "no")
    t.eq(m[2].upgrade, true); t.eq(m[3].upgrade, true)
    t.eq({ m[1].coin, m[2].coin, m[3].coin }, { false, false, true })
  end,

  marks_same_item_gets_both = function(t)
    local Q = load()
    catalog()
    Mock.inventory[11], Mock.inventory[12] = "item:9003", "item:9003"
    Mock.items[9002].sellPrice = 500
    choices("item:9001", "item:9002")
    local m = marksOf(Q)
    t.eq(m[2].upgrade, true); t.eq(m[2].coin, true)
    t.eq(m[1].coin, false)
  end,

  marks_tie_all_get_the_coin = function(t)
    local Q = load()
    catalog()
    choices("item:9003", "item:9004", "item:9001")
    local m = marksOf(Q)
    t.eq({ m[1].coin, m[2].coin, m[3].coin }, { true, true, false })
    t.eq(m[2].upgrade, false, "meat is never an upgrade")
  end,

  marks_value_counts_the_stack = function(t)
    local Q = load(3)
    catalog()
    item(9006, { name = "Healing Potion", equipLoc = "", classID = 0, subclassID = 1, sellPrice = 80 })
    choices({ link = "item:9003" }, { link = "item:9006", count = 3 })
    local c = Q.Rewards:CollectChoices()
    t.eq(c[2].count, 3)
    t.eq(Q.Rewards.Value(c[2]), 240)
    local m = Q.Rewards:Marks(c, warrior)
    t.eq({ m[1].coin, m[2].coin }, { false, true })
  end,

  marks_no_coin_while_a_price_is_unknown = function(t)
    local Q = load()
    catalog()
    choices("item:9002", "item:4242")
    local m = marksOf(Q)
    t.eq(m[2].verdict, "wait")
    t.eq({ m[1].coin, m[2].coin }, { false, false })
    t.eq(m[1].upgrade, true, "known upgrades still show")
  end,

  marks_no_coin_for_a_single_choice_or_zero_prices = function(t)
    local Q = load()
    catalog()
    choices("item:9003")
    t.eq(marksOf(Q)[1].coin, false)
    Mock.items[9001].sellPrice, Mock.items[9002].sellPrice = 0, 0
    choices("item:9001", "item:9002")
    local m = marksOf(Q)
    t.eq({ m[1].coin, m[2].coin }, { false, false })
  end,

  pick_value_mode_takes_most_expensive = function(t)
    local Q = load()
    catalog()
    choices("item:9002", "item:9004", "item:9001")
    local c = Q.Rewards:CollectChoices()
    t.eq(Q.Rewards:Pick(c, warrior), 1, "default: the upgrade")
    local index, reason, detail = Q.Rewards:Pick(c, warrior, nil, nil, "value")
    t.eq(index, 2); t.eq(reason, "value"); t.eq(detail, 200)
    t.ok(Q.Rewards:Describe("value", "item:9004", 200):find("2", 1, true))
  end,

  autoquest_follows_reward_pick_setting = function(t)
    local Q = load()
    catalog()
    Mock.player.level = 10
    Q.Player.level = 10
    Mock.questFrame = { questId = 179, completable = true, choices = { { link = "item:9002" }, { link = "item:9004" } } }
    Q.Settings:Set("rewardPick", "value")
    Mock.fire("QUEST_COMPLETE")
    t.eq(Mock.lastCall("GetQuestReward").args, { 2 })
  end,

  draw_shows_marks_on_buttons = function(t)
    local Q = load(3)
    catalog()
    Mock.inventory[1] = "item:9005"
    choices("item:9001", "item:9002", "item:9003")
    local RM = Q.UI.RewardMarks
    local res = RM:Draw()
    t.ok(res, "drawn")
    local b = QuestInfoFrame.rewardsFrame.RewardButtons
    local m2, m3 = RM.FrameOf(b[2]), RM.FrameOf(b[3])
    t.eq(RM.FrameOf(b[1]), nil, "no mark on the cowl")
    t.eq({ m2:IsShown(), m2.up:IsShown(), m2.coin:IsShown() }, { true, true, false })
    t.eq({ m3:IsShown(), m3.up:IsShown(), m3.coin:IsShown() }, { true, true, true })
    t.eq(m2.up:GetPoint(1), "TOPLEFT"); t.eq(m3.coin:GetPoint(1), "TOPRIGHT")
  end,

  draw_follows_setting_and_late_items = function(t)
    local Q = load(2)
    catalog()
    choices("item:9002", "item:4243")
    local RM = Q.UI.RewardMarks
    local b = QuestInfoFrame.rewardsFrame.RewardButtons
    Mock.fire("QUEST_COMPLETE")
    Mock.advance(0.01)
    t.eq(RM.FrameOf(b[1]).coin:IsShown(), false, "price of choice 2 unknown")
    item(4243, { name = "Late Belt", equipLoc = "INVTYPE_WAIST", classID = 4, subclassID = 1, sellPrice = 999,
      stats = { [STA] = 1 } })
    Mock.fire("GET_ITEM_INFO_RECEIVED", 4243, true)
    Mock.advance(0.01)
    t.eq(RM.FrameOf(b[2]).coin:IsShown(), true, "redrawn once the item arrives")
    Q.Settings:Set("rewardMarks", false)
    Mock.advance(0.01)
    t.eq(RM.FrameOf(b[1]):IsShown(), false); t.eq(RM.FrameOf(b[2]):IsShown(), false)
    Q.Settings:Set("rewardMarks", true)
    Mock.fire("QUEST_FINISHED")
    t.eq(RM.FrameOf(b[2]):IsShown(), false, "hidden when the window closes")
  end,

  draw_reads_the_quest_log = function(t)
    local Q = load(2)
    catalog()
    QuestInfoFrame.questLog = true
    local log = { "item:9002", "item:9003" }
    GetNumQuestLogChoices = function() return #log end
    GetQuestLogItemLink = function(kind, i) return kind == "choice" and log[i] or nil end
    GetQuestLogChoiceInfo = function() return "x", 134400, 1 end
    choices()   -- fenêtre du PNJ vide : seuls les choix du journal comptent
    local res = Q.UI.RewardMarks:Draw()
    t.ok(res and res[2] and res[2].coin, "quest log choices marked")
  end,

  tooltip_lines = function(t)
    local Q = load(2)
    catalog()
    Mock.inventory[1] = "item:9005"
    choices("item:9002", "item:9001")
    local RM = Q.UI.RewardMarks
    RM:Draw()
    local b = QuestInfoFrame.rewardsFrame.RewardButtons
    local l1 = RM:TooltipLines(b[1])
    t.eq(#l1, 2, "upgrade and coin")
    t.ok(l1[1][1]:find("Upgrade for", 1, true), l1[1][1])
    t.ok(l1[1][1]:find("RewardUpgrade", 1, true), "arrow glyph in the line")
    t.ok(l1[2][1]:find(Q.L.REWARD_MARK_COIN, 1, true))
    local l2 = RM:TooltipLines(b[2])
    t.eq(#l2, 1); t.eq(l2[1][1], Q.L.REWARD_MARK_NO_UPGRADE)
    -- infobulle d'objet dont le propriétaire est un bouton de choix
    local added = {}
    local tip = { GetOwner = function() return b[1] end, AddLine = function(_, s) added[#added + 1] = s end }
    t.eq(RM:OnItemTooltip(tip), 2); t.eq(#added, 2)
    local other = { GetOwner = function() return UIParent end, AddLine = function() error("no line") end }
    t.eq(RM:OnItemTooltip(other), 0)
  end,

  signal_colors_from_themes = function(t)
    local Q = load()
    local r, g, b = Q.Themes:SignalColor("upgrade")
    t.ok(g > r and g > b, "green")
    r, g, b = Q.Themes:SignalColor("value")
    t.ok(r > b and g > b, "gold")
    t.eq({ Q.Themes:SignalColor("nope") }, { Q.Themes:SignalColor("muted") })
  end,

  strings_in_both_locales = function(t)
    local keys = { "REWARD_VALUE", "REWARD_MARK_UPGRADE", "REWARD_MARK_UPGRADE_SLOT", "REWARD_MARK_NO_UPGRADE",
      "REWARD_MARK_COIN", "OPT_REWARD_PICK", "OPT_REWARD_PICK_UPGRADE", "OPT_REWARD_PICK_VALUE", "OPT_TIP_REWARD_PICK",
      "OPT_REWARD_MARKS", "OPT_TIP_REWARD_MARKS" }
    local en = Mock.loadAddon(TOC, { extraFiles = { GUIDES } })
    local english = {}
    for _, k in ipairs(keys) do
      t.ok(type(en.L[k]) == "string" and en.L[k] ~= k, "enUS " .. k)
      english[k] = en.L[k]
    end
    Mock.locale = "frFR"
    local fr = Mock.loadAddon(TOC, { extraFiles = { GUIDES } })
    for _, k in ipairs(keys) do t.ok(fr.L[k] ~= english[k], "frFR " .. k) end
  end,
}
