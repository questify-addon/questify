-- Tests du conseil « quête peu rentable » (Engine/QuestValue.lua, UI/QuestValue.lua) : signaux (grise, trop
-- haute, groupe), XP perdue, chaîne passée d'un coup, abandon différé, annulation, retour en arrière, bash,
-- zone de secours, bloc du suivi.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

-- 9101 (18) -> 9102 (21, preSingle) -> 9103 (21, preGroup) ; 9105 (22) : 9101 OU 9104, hors de la chaîne.
-- 9110 (23) : nagas 23-24. 9120 (30) : un élite. 9130 (24) : objet lâché par un élite et un monstre normal.
local QDB = {
  quests = {
    [9101] = { name = "Old Tower", questLevel = 18, requiredLevel = 10, objectives = { { { 9501 } } } },
    [9102] = { name = "Old Tower II", questLevel = 21, requiredLevel = 10, preQuestSingle = { 9101 } },
    [9103] = { name = "Old Tower III", questLevel = 21, requiredLevel = 10, preQuestGroup = { 9102 } },
    [9104] = { name = "Side Errand", questLevel = 25, requiredLevel = 10 },
    [9105] = { name = "Either Way", questLevel = 22, requiredLevel = 10, preQuestSingle = { 9101, 9104 } },
    [9110] = { name = "Stardust Ruins", questLevel = 23, requiredLevel = 15, objectives = { { { 9510 } } } },
    [9120] = { name = "Insane Druids", questLevel = 30, requiredLevel = 20, objectives = { { { 9520 } } } },
    [9130] = { name = "Paw", questLevel = 24, requiredLevel = 15, objectives = { nil, nil, { { 9630 } } } },
  },
  npcs = {
    [9501] = { name = "Old Wolf", minLevel = 17, maxLevel = 18 },
    [9510] = { name = "Naga", minLevel = 23, maxLevel = 24 },
    [9520] = { name = "Taneel", minLevel = 30, maxLevel = 30, rank = 1 },
    [9530] = { name = "Ursa", minLevel = 26, maxLevel = 26, rank = 1 },
    [9531] = { name = "Bear", minLevel = 22, maxLevel = 23 },
  },
  items = {
    [9630] = { name = "Paw", npcDrops = { 9530, 9531 } },
  },
}

local STEPS = {
  { "accept", 9101 }, { "turnin", 9101, xp = 1000 },
  { "accept", 9102 }, { "turnin", 9102, xp = 1650 },
  { "accept", 9103 }, { "turnin", 9103, xp = 500 },
  { "accept", 9104 }, { "turnin", 9104, xp = 800 },
  { "accept", 9105 }, { "turnin", 9105, xp = 900 },
}

local function load(level, steps, opts)
  opts = opts or {}
  Mock.reset()
  if opts.locale then Mock.locale = opts.locale end
  Mock.player.level = level
  for id, q in pairs(opts.log or {}) do Mock.quests.log[id] = q end
  local Q = Mock.loadAddon(TOC, { skipGuides = true, extraFiles = { GUIDES }, qdb = QDB, beforeLogin = function(Q)
    Q:RegisterGuide({ id = "T_QV", title = "Ashenvale", faction = "Alliance", minLevel = 18, maxLevel = 30,
      steps = steps or STEPS })
  end })
  Q.Progress:SetGuide("T_QV")
  return Q
end

local function cur(Q)
  local e = Q.Progress:Current()
  return e and (e.step.action .. " " .. tostring(e.step.questId or e.step.level))
end

local function state(Q, i)
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.key == "g:T_QV:" .. i then return table.concat({ Q.Progress:State(e) }, " ") end
  end
end

local function recordAbandon()
  local abandoned = {}
  local selected
  C_QuestLog.SetSelectedQuest = function(id) selected = id end
  C_QuestLog.SetAbandonQuest = function() end
  C_QuestLog.AbandonQuest = function()
    abandoned[#abandoned + 1] = selected
    Mock.quests.log[selected] = nil
  end
  return abandoned
end

local IN_LOG = { [9101] = { complete = true, objectives = {} } }

local tests = {}

function tests.gray_level_and_xp_factor(t)
  local Q = load(26)
  local V = Q.QuestValue
  t.ok(V:IsGray(18, 26), "18 is gray at 26 (gray from 19 down)")
  t.ok(V:IsGray(19, 26))
  t.ok(not V:IsGray(20, 26))
  t.ok(not V:IsGray(1, 5), "nothing is gray before level 6")
  t.ok(V:IsGray(39, 50), "50: gray from 39 down")
  t.ok(not V:IsGray(40, 50))
  t.ok(V:IsGray(51, 60) and not V:IsGray(52, 60))
  t.eq(V:XPFactor(21, 26), 1)
  t.eq(V:XPFactor(18, 26), 0.4)
  t.eq(V:XPFactor(10, 26), 0.1)
  GetQuestGreenRange = function() return 9 end
  t.ok(not V:IsGray(18, 26), "the game's green range wins")
  GetQuestGreenRange = nil
end

function tests.gray_quest_in_log_offers_skip_and_abandon_with_its_chain(t)
  local Q = load(26, nil, { log = IN_LOG })
  t.eq(cur(Q), "turnin 9101")
  local a = Q.QuestValue:Current()
  t.eq(a.kind, "gray")
  t.eq(a.xpNow, 400)
  t.eq(a.xpBase, 1000)
  t.eq(a.chain, { 9101, 9102, 9103 }, "9105 also follows 9104: not in the chain")
  t.eq(a.lost, 400 + 1650 + 500)
  t.eq(a.abandon, true)
  t.eq(a.steps, 5, "turnin 9101, accept and turnin 9102 and 9103")
end

function tests.skip_drops_the_chain_then_abandons_after_ten_seconds(t)
  local Q = load(26, nil, { log = IN_LOG })
  local abandoned = recordAbandon()
  t.ok(Q.QuestValue:Skip(Q.QuestValue:Current()))
  t.eq(cur(Q), "accept 9104")
  t.eq(state(Q, 2), "skipped dropped")
  t.eq(state(Q, 3), "skipped dropped")
  t.eq(state(Q, 6), "skipped dropped")
  t.eq(state(Q, 9), "active", "9105 still reachable through 9104")
  t.eq(Q.QuestValue:Pending().left, 10)
  t.eq(Q.QuestValue:Current(), nil, "no advice while the skip can be undone")
  Mock.advance(4)
  t.eq(Q.QuestValue:Pending().left, 6)
  t.eq(#abandoned, 0, "nothing abandoned yet")
  Mock.advance(6)
  t.eq(abandoned, { 9101 })
  t.eq(Q.QuestValue:Pending(), nil)
  t.eq(Q.Progress:DroppedRoot(9103), 9101)
  t.eq(cur(Q), "accept 9104", "still skipped once out of the log")
  t.eq(#Mock.errors, 0)
end

function tests.undo_puts_everything_back_and_abandons_nothing(t)
  local Q = load(26, nil, { log = IN_LOG })
  local abandoned = recordAbandon()
  Q.QuestValue:Skip(Q.QuestValue:Current())
  Mock.advance(3)
  t.ok(Q.QuestValue:Undo())
  t.eq(cur(Q), "turnin 9101")
  t.eq(Q.Progress:DroppedRoot(9102), nil)
  Mock.advance(20)
  t.eq(#abandoned, 0)
end

function tests.back_and_journal_click_reopen_the_chain(t)
  local Q = load(26, nil, { log = IN_LOG })
  recordAbandon()
  Q.QuestValue:Skip(Q.QuestValue:Current())
  Mock.advance(10)
  Q.Progress:Back()
  t.eq(Q.Progress:DroppedRoot(9101), nil)
  t.eq(state(Q, 3), "active", "follow-up back in the route")
  Q.QuestValue:Skip({ questId = 9101, kind = "gray", chain = { 9101, 9102, 9103 } })
  Mock.advance(10)
  t.ok(Q.Progress:JumpTo("g:T_QV:4"), "turnin of a follow-up, clicked in the journal")
  t.eq(Q.Progress:DroppedRoot(9101), nil, "the whole chain is reopened")
  t.eq(state(Q, 6), "skipped notinlog")
  t.eq(Q.Progress:DroppedRoot(9103), nil)
end

function tests.chapter_reset_reopens_dropped_quests(t)
  local Q = load(26, nil, { log = IN_LOG })
  Q.QuestValue:Skip(Q.QuestValue:Current())
  Q.QuestValue:Undo()
  Q.QuestValue:Skip({ questId = 9101, kind = "gray", chain = { 9101, 9102, 9103 } })
  t.ok(Q.Progress:ResetGuide("T_QV"))
  t.eq(Q.Progress:DroppedRoot(9102), nil)
  t.eq(cur(Q), "turnin 9101")
end

function tests.keep_hides_the_advice_for_this_quest(t)
  local Q = load(26, nil, { log = IN_LOG })
  Q.QuestValue:Keep(Q.QuestValue:Current())
  t.eq(Q.QuestValue:Current(), nil)
  t.eq(Q.char.questValueKeep[9101], "gray")
end

function tests.gray_accept_skips_without_abandon(t)
  local Q = load(26)
  t.eq(cur(Q), "accept 9101")
  local a = Q.QuestValue:Current()
  t.eq(a.kind, "gray")
  t.eq(a.abandon, false)
end

function tests.green_quest_gives_no_advice(t)
  local Q = load(20, nil, { log = IN_LOG })
  t.eq(Q.QuestValue:Current(), nil)
end

function tests.too_high_offers_bash_to_the_right_level(t)
  local Q = load(20, { { "accept", 9110 }, { "complete", 9110 }, { "turnin", 9110, xp = 1850 } })
  local a = Q.QuestValue:Current()
  t.eq(a.kind, "high")
  t.eq(a.mobLo, 23); t.eq(a.mobHi, 24)
  t.eq(a.bashLevel, 22, "every monster at most 2 levels above")
  t.eq(a.lost, 1850)
  t.ok(Q.QuestValue:Bash(a))
  t.eq(cur(Q), "level 22")
  Mock.player.level = 22
  Mock.fire("PLAYER_LEVEL_UP", 22)
  t.eq(cur(Q), "accept 9110")
  t.eq(Q.QuestValue:Current(), nil, "2 levels above: fine")
end

function tests.too_high_skip_drops_every_step_of_the_quest(t)
  local Q = load(20, { { "accept", 9110 }, { "complete", 9110 }, { "turnin", 9110, xp = 1850 }, { "accept", 9104 } })
  Q.QuestValue:Skip(Q.QuestValue:Current())
  t.eq(cur(Q), "accept 9104")
  t.eq(Q.QuestValue:Pending().abandon, {}, "only gray quests leave the log")
end

function tests.elite_without_group(t)
  local Q = load(30, { { "accept", 9120 }, { "turnin", 9120, xp = 3200 } })
  local a = Q.QuestValue:Current()
  t.eq(a.kind, "group")
  t.eq(a.elites, 1)
  IsInGroup = function() return true end
  Mock.fire("GROUP_ROSTER_UPDATE")
  t.eq(Q.QuestValue:Current(), nil, "grouped: fine")
end

function tests.item_from_elite_and_normal_mob_is_not_a_group_quest(t)
  -- l'objet tombe aussi d'un monstre normal (22-23) : pas de groupe, et 22 n'est pas trop haut à 20
  local Q = load(20, { { "accept", 9130 }, { "turnin", 9130, xp = 1000 } })
  t.eq(Q.QuestValue:Current(), nil)
  local targets = Q.QuestValue:Targets(Q.QDB:Quest(9130))
  t.eq(targets, { { lo = 22, hi = 26, elite = false } })
end

function tests.option_off_instance_and_dungeon_steps_give_nothing(t)
  local Q = load(26, nil, { log = IN_LOG })
  Q.Settings:Set("questValue", false)
  t.eq(Q.QuestValue:Current(), nil)
  Q.Settings:Set("questValue", true)
  Mock.player.instance = true
  t.eq(Q.QuestValue:Current(), nil)
  Mock.player.instance = false
  t.ok(Q.QuestValue:Current())
end

function tests.find_group_opens_the_chat_line(t)
  local Q = load(30, { { "accept", 9120 }, { "turnin", 9120, xp = 3200 } })
  local opened
  ChatFrame_OpenChat = function(text) opened = text end
  t.ok(Q.QuestValue:FindGroup(Q.QuestValue:Current()))
  t.eq(opened, "LFG Insane Druids")
  ChatFrame_OpenChat = nil
end

function tests.detour_without_candidate_prints(t)
  local Q = load(30, { { "accept", 9120 }, { "turnin", 9120, xp = 3200 } })
  t.eq(Q.QuestValue:Current().detour, false)
  t.eq(Q.QuestValue:Detour(), nil)
  t.ok(Mock.printed(Q.L.QV_NO_DETOUR))
end

---------------------------------------------------------------------------
-- Suivi
---------------------------------------------------------------------------
local function shown(Q)
  local V = Q.UI.QuestValue
  local out = {}
  for id, b in pairs(V.buttons or {}) do if b:IsShown() then out[#out + 1] = id end end
  table.sort(out)
  return table.concat(out, ",")
end

function tests.tracker_block_for_a_gray_quest_then_undo(t)
  local Q = load(26, nil, { log = IN_LOG, locale = "frFR" })
  recordAbandon()
  local V = Q.UI.QuestValue
  t.eq(V.why:GetText(), "Quête grise : 400 XP au lieu de 1 000.")
  t.eq(V.lost:GetText(), "Avec ses 2 suites : -2 550 XP.")
  t.eq(shown(Q), "abandon,keep")
  Mock.click(V.buttons.abandon)
  t.eq(V.why:GetText(), "Old Tower passée, avec sa suite (5 étapes). Abandon dans 10 s.")
  t.eq(shown(Q), "undo")
  Mock.advance(2)
  t.eq(V.why:GetText(), "Old Tower passée, avec sa suite (5 étapes). Abandon dans 8 s.")
  Mock.click(V.buttons.undo)
  t.eq(V.why:GetText(), "Quête grise : 400 XP au lieu de 1 000.")
  Mock.click(V.buttons.keep)
  t.ok(not V.why:IsShown())
  t.eq(shown(Q), "")
  t.eq(#Mock.errors, 0)
end

function tests.tracker_block_one_follow_up_names_it(t)
  local Q = load(26, { { "accept", 9101 }, { "turnin", 9101, xp = 1000 }, { "accept", 9102 }, { "turnin", 9102, xp = 1650 } },
    { log = IN_LOG, locale = "frFR" })
  t.eq(Q.UI.QuestValue.lost:GetText(), "Avec sa suite (Old Tower II, niv. 21) : -2 050 XP.")
end

function tests.tracker_block_for_too_high_and_group(t)
  local Q = load(20, { { "accept", 9110 }, { "complete", 9110 }, { "turnin", 9110, xp = 1850 } })
  local V = Q.UI.QuestValue
  t.eq(V.why:GetText(), "Too high: monsters level 23-24 (you: 20).")
  t.eq(V.lost:GetText(), "Skip: -1,850 XP.")
  t.eq(shown(Q), "bash,keep,skip")
  t.eq(V.buttons.bash:GetText(), "Grind to 22")
  Mock.click(V.buttons.bash)
  t.eq(cur(Q), "level 22")
  Q = load(30, { { "accept", 9120 }, { "turnin", 9120, xp = 3200 } }, { locale = "frFR" })
  V = Q.UI.QuestValue
  t.eq(V.why:GetText(), "Quête de groupe : un élite à tuer, vous êtes seul.")
  t.eq(shown(Q), "group,keep,skip")
end

function tests.options_window_has_the_option(t)
  local Q = load(26, nil, { log = IN_LOG })
  t.eq(Q.Settings:Get("questValue"), true)
  Q.UI.Options:Open("comfort")
  local cb = Q.UI.Options:Widget("questValue").check
  t.ok(cb, "checkbox")
  t.eq(cb:GetChecked(), true)
  cb:SetChecked(false)
  Mock.click(cb, "LeftButton")
  t.eq(Q.Settings:Get("questValue"), false)
  t.ok(not Q.UI.QuestValue.why:IsShown(), "tracker block gone")
  t.eq(#Mock.errors, 0)
end

return tests
