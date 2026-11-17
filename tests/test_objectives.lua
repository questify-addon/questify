-- Tests des objectifs de l'étape courante (Engine/Objectives.lua) et de leur rendu dans le suivi
-- (UI/ObjectiveRows.lua, UI/Tracker.lua) : libellé et compteur, type et icône, objectif visé,
-- repli des objectifs finis, mise en page et détail choisis par le joueur.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local function load(opts)
  Ext.install()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  return Mock.loadAddon(TOC, opts)
end

-- Quête 179 dans le journal : le loup (705) lâche la viande demandée.
local function acceptWolves(have)
  Mock.quests.log[179] = { objectives = { { text = "Tough Wolf Meat: " .. (have or 3) .. "/8", type = "item",
    finished = (have or 3) >= 8 } } }
  Mock.fire("QUEST_ACCEPTED", 179)
  Mock.advance(0.3)
end

-- Route courte : trolls (170, deux objectifs) seuls.
local function loadTroggs()
  local Q = load()
  Q:RegisterGuide({ id = "T_trogg", faction = "Alliance", steps = { { "complete", 170 } } })
  Q.Progress:SetGuide("T_trogg")
  Mock.quests.log[170] = { objectives = {
    { text = "Rockjaw Trogg slain: 0/6", finished = false },
    { text = "Burly Rockjaw Trogg slain: 0/6", finished = false },
  } }
  Mock.fire("QUEST_ACCEPTED", 170)
  Mock.advance(0.3)
  return Q
end

local function shown(list, field)
  local n = 0
  for _, r in ipairs(list or {}) do
    local region = field and r[field] or r
    if region:IsShown() then n = n + 1 end
  end
  return n
end

return {
  split_reads_label_and_counter = function(t)
    local Q = load()
    local O = Q.Objectives
    t.eq({ O:Split("Kobold Vermin slain: 3/8") }, { "Kobold Vermin slain", 3, 8 })
    t.eq({ O:Split("Loup tué : 2/6") }, { "Loup tué", 2, 6 })
    t.eq({ O:Split("3/8 Viande de loup") }, { "Viande de loup", 3, 8 })
    t.eq({ O:Split("Explore the cave") }, { "Explore the cave" })
    t.eq(O:CountText({ have = 9, need = 8 }), "8/8", "never over the total")
    t.eq(O:CountText({}), nil)
    t.near(O:Fraction({ have = 3, need = 8 }), 0.375)
    t.eq(O:Fraction({ done = true }), 1)
  end,

  kind_from_log_and_questie = function(t)
    local Q = load()
    local O = Q.Objectives
    t.eq(O:KindOf("monster", nil, "x"), "kill")
    t.eq(O:KindOf("item", { { kind = "npc", id = 1, viaItem = 9 } }, "x"), "loot", "item dropped by a monster")
    t.eq(O:KindOf("item", { { kind = "object", id = 1, viaItem = 9 } }, "x"), "object", "item from a chest")
    t.eq(O:KindOf("object", nil, "x"), "object")
    t.eq(O:KindOf("event", nil, "Speak with Grelin"), "talk")
    t.eq(O:KindOf("event", nil, "Totem burnt", 5000), "use", "event with a usable quest item")
    t.eq(O:KindOf("event", nil, "Find the cave"), "explore")
    t.eq(O:KindOf("reputation", nil, "x"), "rep")
    t.eq(O:IconOf("kill"), "Interface\\Cursor\\Attack")
    t.eq(O:IconOf("done"), "Interface\\RaidFrame\\ReadyCheck-Ready")
  end,

  tracker_lists_one_line_per_objective = function(t)
    local Q = load()
    acceptWolves(3)
    local T = Q.UI.Tracker
    local row = T.host.objRows[1]
    t.ok(row.label:IsShown(), "objective line")
    t.eq(Q.Util.StripColors(row.label:GetText()), "Tough Wolf Meat")
    t.eq(row.count:GetText(), "3/8")
    t.eq(row.icon:GetTexture(), Q.Objectives.ICONS.loot, "loot icon")
    t.ok(row.mark:IsShown(), "followed by the arrow")
    t.ok(not row.barBg:IsShown(), "compact list: no bar")
    t.ok(T:CurrentText():find("Tough Wolf Meat: 3/8", 1, true))
    t.eq(#Mock.errors, 0)
  end,

  done_objective_turns_green_then_folds = function(t)
    local Q = loadTroggs()
    local T = Q.UI.Tracker
    Mock.quests.log[170].objectives[1] = { text = "Rockjaw Trogg slain: 6/6", finished = true }
    Mock.fire("QUEST_LOG_UPDATE")
    Mock.advance(0.3)
    local row = T.host.objRows[1]
    t.eq(row.count:GetText(), "6/6")
    t.eq(row.icon:GetTexture(), Q.Objectives.ICONS.done, "check mark")
    local ok = Q.Themes:CodeColor("ff40e050")
    local r, g, b = row.count:GetTextColor()
    t.near(r, ok[1]); t.near(g, ok[2]); t.near(b, ok[3])
    t.eq(shown(T.host.foldLines, "text"), 0, "not folded yet")
    -- au bout du délai : replié dans « 1 done: … »
    Mock.advance(Q.Objectives.FOLD_DELAY + 0.2)
    t.eq(shown(T.host.objRows, "label"), 1, "one line left")
    t.ok(T:CurrentText():find("1 done: Rockjaw Trogg slain", 1, true), T:CurrentText())
    t.eq(#Mock.errors, 0)
  end,

  no_fold_in_combat = function(t)
    local Q = loadTroggs()
    local T = Q.UI.Tracker
    Mock.player.combat = true
    Mock.quests.log[170].objectives[1] = { text = "Rockjaw Trogg slain: 6/6", finished = true }
    Mock.fire("QUEST_LOG_UPDATE")
    Mock.advance(Q.Objectives.FOLD_DELAY + 1)
    t.eq(shown(T.host.objRows, "label"), 2, "lines stay during the fight")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    Mock.advance(0.3)
    t.eq(shown(T.host.objRows, "label"), 1, "folded after the fight")
  end,

  layout_bars_and_quest = function(t)
    local Q = loadTroggs()
    local T = Q.UI.Tracker
    Q.Settings:Set("tracker.objLayout", "bars")
    t.eq(shown(T.host.objRows, "barBg"), 2, "one bar per objective")
    Q.Settings:Set("tracker.objLayout", "quest")
    t.eq(shown(T.host.objRows, "barBg"), 0)
    t.eq(shown(T.host.questHeads), 1, "quest heading")
    t.ok(T:CurrentText():find("· 0/2", 1, true), T:CurrentText())
    t.ok(not T.currentText:IsShown() or not T:CurrentText():find("Do:", 1, true), "no step title")
    t.eq(#Mock.errors, 0)
  end,

  detail_count_mobs_distance = function(t)
    local Q = loadTroggs()
    local T = Q.UI.Tracker
    t.eq(Q.Objectives:Detail(), "mobs")
    t.eq(shown(T.mobRows, "name"), 2, "targetable monsters by default")
    Q.Settings:Set("tracker.objDetail", "count")
    t.eq(shown(T.mobRows, "name"), 0, "counter only")
    Q.Settings:Set("tracker.objDetail", "distance")
    t.eq(shown(T.mobRows, "name"), 2)
    t.ok(T:CurrentText():find("yd", 1, true), "distance per objective: " .. T:CurrentText())
  end,

  old_show_mobs_setting_means_count = function(t)
    local Q = load()
    Q.Settings:Set("tracker.showMobs", false)
    t.eq(Q.Objectives:Detail(), "count", "migrated")
    Q.Settings:Set("tracker.objDetail", "distance")
    t.eq(Q.Objectives:Detail(), "distance", "explicit choice wins")
    Q.Settings:Set("tracker.objLayout", "nonsense")
    t.eq(Q.Objectives:Layout(), "list", "unknown layout: list")
  end,

  theme_colours_only = function(t)
    local Q = loadTroggs()
    local T = Q.UI.Tracker
    Q.Settings:Set("tracker.objLayout", "bars")
    Q.Settings:Set("tracker.theme", "dark")
    -- thème en vigueur du suivi (celui de la race tant que « suivre la race » est coché)
    local fill = T.theme.bar.fill
    local bar = T.host.objRows[1].bar
    -- 0/6 : pas de remplissage ; le fond suit le thème
    t.ok(not bar:IsShown(), "empty bar")
    local row2 = T.host.objRows[2]
    local got
    rawset(row2.bar, "SetColorTexture", function(_, ...) got = { ... } end)
    Mock.quests.log[170].objectives[2] = { text = "Burly Rockjaw Trogg slain: 3/6", finished = false }
    Mock.fire("QUEST_LOG_UPDATE")
    Mock.advance(0.3)
    t.ok(row2.bar:IsShown())
    t.eq(got, { fill[1], fill[2], fill[3], 1 }, "bar fill of the theme")
    t.eq(#Mock.errors, 0)
  end,
}
