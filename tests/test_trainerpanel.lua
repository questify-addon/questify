-- Tests du panneau « Sorts du maître » (Q.UI.TrainerPanel) et de ses données (Q.Trainer:PanelData).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local TRAINERS = {
  [912] = { name = "Thran Khorman", minLevel = 10, maxLevel = 10, spawns = { [1] = { { 28.83, 67.84 } } },
    zoneID = 1, friendlyToFaction = "A", subName = "Warrior Trainer", npcFlags = 51 },
}

-- Fenêtre du maître simulée : { nom, rang, type, niveau, coût, icône }.
local services = {}
local function installTrainerApi()
  GetNumTrainerServices = function() return #services end
  GetTrainerServiceInfo = function(i)
    local s = services[i]
    if s then return s[1], s[3], s[6], s[4], s[2], "" end
  end
  GetTrainerServiceCost = function(i) local s = services[i]; return s and s[5] or 0, false end
  IsTradeskillTrainer = function() return false end
end

local money = 0

local function load()
  Ext.install()
  installTrainerApi()
  money = 1000
  GetMoney = function() return money end
  GetCoinTextureString = function(c) return "<" .. tostring(c) .. ">" end
  ClassTrainerFrame = CreateFrame("Frame", "ClassTrainerFrame", UIParent)
  ClassTrainerFrame:Show()
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true, qdb = { npcs = TRAINERS } })
end

local function levelUp(lvl)
  Mock.player.level = lvl
  Mock.fire("PLAYER_LEVEL_UP", lvl)
end

local function talkTo(npcId, list)
  Mock.units.npc = { guid = "Creature-0-1-0-1-" .. npcId .. "-0000ABCD", name = "Trainer" }
  services = list
  Mock.fire("TRAINER_SHOW")
end

local LIST = {
  { "Abilities", "", "header", nil, 0 },
  { "Battle Shout", "Rank 1", "used", 1, 10, 132333 },
  { "Rend", "Rank 1", "available", 4, 100, 132155 },
  { "Charge", "", "available", 4, 800, 132337 },
  { "Hamstring", "", "available", 4, 300, 132316 },
  { "Thunder Clap", "Rank 1", "unavailable", 6, 100, 136105 },
  { "Heroic Strike", "Rank 2", "unavailable", 8, 200, 132282 },
  { "Sunder Armor", "Rank 1", "unavailable", 8, 200, 132363 },
  { "Shield Bash", "Rank 1", "unavailable", 10, 600, 132357 },
}

return {
  panel_data_sorts_and_marks_what_gold_covers = function(t)
    local Q = load()
    levelUp(4)
    talkTo(912, LIST)
    local d = Q.Trainer:PanelData()
    t.eq(d.level, 4)
    t.eq(#d.now, 3)
    t.eq({ d.now[1].name, d.now[2].name, d.now[3].name }, { "Rend", "Hamstring", "Charge" }, "cheapest first")
    t.eq({ d.now[1].affordable, d.now[2].affordable, d.now[3].affordable }, { true, true, false })
    t.eq(d.cost, 1200)
    t.eq(d.missing, 800)
    t.eq(d.money, 1000)
    t.eq(d.now[1].icon, 132155, "trainer icon kept")
    t.eq(d.now[1].rank, "Rank 1")
    t.eq(#d.later, Q.Trainer.LATER_LEVELS, "two next levels")
    t.eq(d.later[1].level, 6)
    t.eq(d.later[2].level, 8)
    t.eq(#d.later[2].spells, 2)
    t.eq(#Mock.errors, 0)
  end,

  panel_opens_beside_class_trainer_and_closes_with_it = function(t)
    local Q = load()
    local P = Q.UI.TrainerPanel
    levelUp(4)
    talkTo(912, LIST)
    t.ok(P:IsShown(), "opened with the trainer window")
    local point, rel, relPoint = P.frame:GetPoint(1)
    t.eq({ point, rel, relPoint }, { "TOPLEFT", ClassTrainerFrame, "TOPRIGHT" })
    t.eq(P.title:GetText(), Q.L.TRAINER_PANEL_TITLE)
    t.eq(P.kick:GetText(), "LEVEL 4 · WARRIOR")
    -- trois sorts maintenant, puis Thunder Clap (6), Heroic Strike et Sunder Armor (8)
    t.eq(P.rows[1].name:GetText(), "Rend")
    t.eq(P.rows[1].rank:GetText(), "Rank 1")
    t.eq(P.rows[1].cost:GetText(), "<100>")
    t.eq(P.rows[1].lvl:GetText(), "lvl 4")
    t.eq(P.rows[1].icon:GetTexture(), 132155)
    t.eq(P.rows[3].name:GetText(), "Charge")
    local r, g, b = P.rows[3].cost:GetTextColor()
    t.ok(r > 0.8 and g < 0.2 and b < 0.2, "too expensive: red")
    t.eq(P.nowHeader.right:GetText(), "3 · <1200>")
    t.eq(P.levels[1]:GetText(), "Level 6")
    t.eq(P.levels[2]:GetText(), "Level 8")
    t.eq(P.rows[4].name:GetText(), "Thunder Clap")
    t.ok(P.rows[6]:IsShown() and not (P.rows[7] and P.rows[7]:IsShown()), "six rows")
    t.eq(P.foot.left:GetText(), "Your gold: <1000>")
    t.eq(P.foot.right:GetText(), "Still to pay: <800>")
    Mock.fire("TRAINER_CLOSED")
    t.ok(not P:IsShown(), "closed with the trainer window")
    t.eq(#Mock.errors, 0)
  end,

  panel_refreshes_after_buying_and_money = function(t)
    local Q = load()
    local P = Q.UI.TrainerPanel
    levelUp(4)
    talkTo(912, LIST)
    LIST[3][3] = "used"                        -- Rend appris
    Mock.fire("TRAINER_UPDATE")
    Mock.advance(Q.Trainer.UPDATE_DELAY + 0.05)
    t.eq(P.rows[1].name:GetText(), "Hamstring")
    money = 5000
    Mock.fire("PLAYER_MONEY")
    t.eq(P.foot.right:GetText(), "", "nothing missing")
    local r = P.rows[2].cost:GetTextColor()
    t.ok(r < 0.8, "Charge affordable now")
    LIST[3][3] = "available"
  end,

  nothing_to_learn_and_other_trainers = function(t)
    local Q = load()
    local P = Q.UI.TrainerPanel
    levelUp(2)
    talkTo(912, { { "Rend", "Rank 1", "unavailable", 4, 100, 132155 } })
    t.ok(P:IsShown())
    t.ok(P.none:IsShown(), "nothing now")
    t.eq(P.levels[1]:GetText(), "Level 4")
    Mock.fire("TRAINER_CLOSED")
    talkTo(460, LIST)                          -- maître démoniste
    t.ok(not P:IsShown(), "not for another class trainer")
  end,

  option_off_and_close_button = function(t)
    local Q = load()
    local P = Q.UI.TrainerPanel
    levelUp(4)
    talkTo(912, LIST)
    P.closeButton:Click()
    t.ok(not P:IsShown(), "closed by its button")
    Mock.fire("TRAINER_CLOSED")
    Q.Settings:Set("trainerPanel", false)
    talkTo(912, LIST)
    t.ok(not P:IsShown(), "option off")
  end,

  french_strings = function(t)
    Mock.locale = "frFR"
    local Q = load()
    levelUp(4)
    talkTo(912, LIST)
    local P = Q.UI.TrainerPanel
    t.eq(P.title:GetText(), "Sorts du maître")
    t.eq(P.rows[1].lvl:GetText(), "niv. 4")
    t.eq(P.levels[1]:GetText(), "Niveau 6")
    t.eq(P.foot.left:GetText(), "Ton or : <1000>")
  end,
}
