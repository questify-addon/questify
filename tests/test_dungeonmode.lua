-- Tests du mode « Donjons » : champs des étapes et des chapitres (Engine/Guides.lua), choix du mode, cases
-- des échelons, contournement de l'instance et alternative en extérieur (Engine/DungeonMode.lua,
-- Engine/Progress.lua), options, fenêtre (UI/DungeonModePanel.lua), /qf donjons, et contrôle des données
-- générées (Guides/DungeonRouteData.lua).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local DATA_FILE = "Questify/Guides/DungeonRouteData.lua"
local DUNGEON_FILE = "Questify/Guides/DungeonData.lua"

local function testData()
  return { faction = "Alliance", entryOffset = 2, entryCap = 58, rungs = {
    { key = "DM", dungeon = "DM", name = "The Deadmines", areaId = 1581, minLevel = 17, maxLevel = 26, entry = 19,
      quests = { 166, 167 }, xp = 2075, pct = 0.098, stars = 1 },
    { key = "SM_LIB", dungeon = "SM", wing = "Library", name = "Scarlet Monastery", areaId = 796, minLevel = 29,
      maxLevel = 39, entry = 31, quests = { 1050 }, xp = 1775, est = true, pct = 0.35, stars = 3 },
    { key = "SFK", dungeon = "SFK", name = "Shadowfang Keep", areaId = 209, minLevel = 22, maxLevel = 30, entry = 27,
      quests = {}, xp = 0, pct = 0, stars = 0 },
  } }
end

-- Chapitre du mode : prises (prep), instance (run), alternative en extérieur, rattrapage.
local function dungeonGuide(extra)
  local g = { id = "AD_T1", title = "Westfall", faction = "Alliance", mode = "dungeon", minLevel = 1, maxLevel = 20,
    steps = {
      { "note", "zone quest" },
      { "note", "pick up", rung = "DM", phase = "prep" },
      { "note", "enter", rung = "DM", phase = "run" },
      { "note", "open world", alt = "DM" },
      { "note", "catch up", alt = "DM", below = 12 },
      { "note", "filler", below = 5 },
      { "note", "end" },
    } }
  for k, v in pairs(extra or {}) do g[k] = v end
  return g
end

local function load(opts)
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  local data = opts.data == nil and testData() or opts.data
  local guides = opts.guides
  opts.data, opts.guides = nil, nil
  opts.beforeLogin = function(Q)
    Q.DungeonRouteData = data or nil
    for _, g in ipairs(guides or { dungeonGuide() }) do Q:RegisterGuide(g) end
  end
  return Mock.loadAddon(TOC, opts)
end

-- Texte des étapes « note » du chapitre courant qui ne sont pas passées.
local function live(Q)
  local out = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.source == "guide" and e.step.action == "note" then
      local st = Q.Progress:State(e)
      if st ~= "skipped" then out[#out + 1] = e.step.text end
    end
  end
  return table.concat(out, ",")
end

local function setLevel(level)
  Mock.player.level = level
  Mock.fire("PLAYER_LEVEL_UP", level)
end

local tests = {}

function tests.step_fields_are_normalized(t)
  local Q = load()
  local s = Q.Guides:Normalize({ "accept", 166, rung = "DM", phase = "prep" })
  t.eq(s.rung, "DM"); t.eq(s.phase, "prep")
  s = Q.Guides:Normalize({ "note", "x", alt = "DM", below = 21 })
  t.eq(#s.alt, 1); t.eq(s.alt[1], "DM"); t.eq(s.below, 21)
  s = Q.Guides:Normalize({ "note", "x", alt = { "DM", "SM_LIB" } })
  t.eq(#s.alt, 2); t.eq(s.alt[2], "SM_LIB")
  t.eq(Q.Guides:Normalize({ "note", "x", alt = {} }), nil)
  t.eq(Q.Guides:Normalize({ "note", "x", alt = { "" } }), nil)
  t.eq(Q.Guides:Normalize({ "note", "x", alt = 3 }), nil)
  local bad, err = Q.Guides:Normalize({ "accept", 166, rung = "DM" })
  t.eq(bad, nil); t.ok(err:find("phase", 1, true), err)
  bad = Q.Guides:Normalize({ "accept", 166, rung = "DM", phase = "later" })
  t.eq(bad, nil)
  bad = Q.Guides:Normalize({ "accept", 166, phase = "prep" })
  t.eq(bad, nil)
  bad = Q.Guides:Normalize({ "note", "x", alt = "DM", rung = "DM", phase = "run" })
  t.eq(bad, nil)
  bad = Q.Guides:Normalize({ "note", "x", below = "ten" })
  t.eq(bad, nil)
end

function tests.guide_mode_is_validated(t)
  local Q = load()
  t.eq(Q:RegisterGuide({ id = "X_BAD", faction = "Alliance", mode = "raid", steps = {} }), false)
  t.ok(Q.Guides:Get("AD_T1").mode == "dungeon")
  t.ok(Q.Guides:HasMode("dungeon", "Alliance"))
  t.ok(not Q.Guides:HasMode("dungeon", "Horde"))
end

function tests.usual_route_ignores_dungeon_chapters(t)
  local Q = load()
  t.ok(not Q.DungeonMode:IsOn(), "mode is off by default")
  t.eq(Q.DungeonMode:Mode(), nil)
  local g = Q.Guides:ForPlayer("Alliance", "Dwarf", 1)
  t.ok(g ~= nil and g.mode == nil, "usual chapter chosen")
  t.ok(Q.Progress:Guide().mode == nil, "login chapter is a usual chapter")
end

function tests.turning_the_mode_on_switches_route_and_back(t)
  local Q = load()
  local usual = Q.Progress:Guide().id
  t.ok(Q.DungeonMode:SetOn(true))
  t.ok(Q.DungeonMode:IsOn())
  t.eq(Q.Progress:Guide().id, "AD_T1")
  t.ok(not Q.DungeonMode:SetOn(true), "no change the second time")
  t.ok(Q.DungeonMode:SetOn(false))
  t.eq(Q.Progress:Guide().id, usual)
end

function tests.mode_survives_reload(t)
  local Q = load()
  Q.DungeonMode:SetOn(true)
  Q.DungeonMode:SetChecked("DM", false)
  Q = Mock.reload()
  t.ok(Q.DungeonMode:IsOn())
  t.eq(Q.DungeonMode:State("DM"), "off")
  t.eq(Q.Progress:Guide().id, "AD_T1")
end

function tests.mode_needs_chapters_and_matching_faction(t)
  local Q = load({ guides = {} })
  t.ok(not Q.DungeonMode:Available(), "no dungeon chapter")
  t.ok(not Q.DungeonMode:SetOn(true))
  t.ok(not Q.DungeonMode:IsOn())
  Mock.reset()
  Mock.player.faction, Mock.player.raceId = "Horde", 2
  Q = load()
  t.ok(not Q.DungeonMode:Available(), "Alliance data, Horde character")
  t.ok(not Q.DungeonMode:SetOn(true))
  Mock.reset()
  Q = load({ data = false })
  t.ok(not Q.DungeonMode:Available(), "no data")
  t.eq(#Q.DungeonMode:Rungs(), 0)
  t.eq(#Mock.errors, 0)
end

function tests.dungeon_mode_falls_back_to_usual_chapters(t)
  local Q = load()
  -- chapitre du mode réservé aux Humains : un Nain reste sur les guides habituels
  local g = Q.Guides:ForPlayer("Alliance", "Dwarf", 1, "dungeon")
  t.eq(g.id, "AD_T1")
  Q:RegisterGuide(dungeonGuide({ id = "AD_T1", races = { "Human" } }))
  g = Q.Guides:ForPlayer("Alliance", "Dwarf", 1, "dungeon")
  t.ok(g ~= nil and g.mode == nil, "falls back to a usual chapter")
end

function tests.checked_rung_plays_dungeon_steps_and_hides_alternative(t)
  local Q = load()
  setLevel(15)
  Q.DungeonMode:SetOn(true)
  t.eq(live(Q), "zone quest,pick up,enter,end")
end

function tests.unchecked_rung_skips_dungeon_and_plays_alternative(t)
  local Q = load()
  setLevel(15)
  Q.DungeonMode:SetOn(true)
  t.ok(Q.DungeonMode:SetChecked("DM", false))
  t.eq(Q.DungeonMode:State("DM"), "off")
  t.eq(live(Q), "zone quest,open world,catch up,end")
  Q.DungeonMode:SetChecked("DM", true)
  t.eq(live(Q), "zone quest,pick up,enter,end")
end

function tests.bypass_keeps_pickups_and_skips_instance(t)
  local Q = load()
  setLevel(15)
  Q.DungeonMode:SetOn(true)
  t.ok(Q.DungeonMode:SetBypassed("DM", true))
  t.eq(Q.DungeonMode:State("DM"), "bypassed")
  t.eq(live(Q), "zone quest,pick up,open world,catch up,end")
  Q.DungeonMode:SetBypassed("DM", false)
  t.eq(live(Q), "zone quest,pick up,enter,end")
  -- pas de contournement d'un échelon décoché ; recocher efface le contournement
  Q.DungeonMode:SetBypassed("DM", true)
  Q.DungeonMode:SetChecked("DM", false)
  t.ok(not Q.DungeonMode:SetBypassed("DM", false))
  Q.DungeonMode:SetChecked("DM", true)
  t.eq(Q.DungeonMode:State("DM"), "on")
end

function tests.catch_up_steps_follow_the_level(t)
  local Q = load()
  setLevel(3)
  Q.DungeonMode:SetOn(true)
  t.eq(live(Q), "zone quest,pick up,enter,catch up,filler,end")
  setLevel(5)
  t.eq(live(Q), "zone quest,pick up,enter,catch up,end")
  setLevel(12)
  t.eq(live(Q), "zone quest,pick up,enter,end")
end

function tests.shared_alternative_plays_when_any_of_its_dungeons_is_skipped(t)
  local Q = load()
  local D = Q.DungeonMode
  local step = { action = "note", alt = { "DM", "SM_LIB" }, below = 20 }
  t.eq(D:StepSkip(step, 25), "rung-alt", "both dungeons done, level reached")
  t.eq(D:StepSkip(step, 19), nil, "under the level")
  D:SetBypassed("SM_LIB", true)
  t.eq(D:StepSkip(step, 25), nil, "one instance skipped")
  D:SetBypassed("SM_LIB", false)
  D:SetChecked("DM", false)
  t.eq(D:StepSkip(step, 25), nil, "one dungeon unticked")
  -- un échelon inconnu dans la liste est ignoré, pas bloquant
  D:SetChecked("DM", true)
  t.eq(D:StepSkip({ action = "note", alt = { "NOPE", "DM" } }, 25), "rung-alt")
end

function tests.a_quest_in_the_log_is_always_finished(t)
  local Q = load()
  local D = Q.DungeonMode
  local turnin = { action = "turnin", questId = 4242, alt = "DM", below = 20 }
  local complete = { action = "complete", questId = 4242, below = 20 }
  local accept = { action = "accept", questId = 4242, alt = "DM", below = 20 }
  t.eq(D:StepSkip(turnin, 25), "rung-alt")
  t.eq(D:StepSkip(complete, 25), "rung-level")
  Mock.quests.log[4242] = { complete = false, objectives = {} }
  Mock.fire("QUEST_LOG_UPDATE")
  Mock.advance(1)
  t.eq(D:StepSkip(turnin, 25), nil, "turn in the quest you carry")
  t.eq(D:StepSkip(complete, 25), nil, "finish the quest you carry")
  t.eq(D:StepSkip(accept, 25), "rung-alt", "no new quest")
end

function tests.mode_takes_over_after_a_usual_start_chapter(t)
  local Q = load({ guides = {
    { id = "T_START", faction = "Alliance", races = { "Dwarf" }, minLevel = 1, maxLevel = 5, next = "T_USUAL",
      choices = { { id = "T_USUAL" }, { id = "T_OTHER" } }, steps = { { "note", "start" } } },
    { id = "T_USUAL", faction = "Alliance", minLevel = 5, maxLevel = 9, steps = { { "note", "usual" } } },
    { id = "T_OTHER", faction = "Alliance", minLevel = 5, maxLevel = 9, steps = { { "note", "other" } } },
    { id = "AD_T2", faction = "Alliance", mode = "dungeon", after = { "T_START" }, minLevel = 5, maxLevel = 9,
      steps = { { "note", "dungeon" } } },
    { id = "AD_T3", faction = "Alliance", mode = "dungeon", races = { "Human" }, after = { "T_START" }, minLevel = 5,
      maxLevel = 9, steps = { { "note", "human" } } },
  } })
  local start = Q.Guides:Get("T_START")
  t.eq(Q.Guides:Next(start, "Dwarf").id, "T_USUAL", "mode off: usual next chapter")
  t.eq(#Q.Guides:Choices(start, "Dwarf", "Alliance"), 2)
  Q.DungeonMode:SetOn(true)
  t.eq(Q.Guides:Next(start, "Dwarf").id, "AD_T2", "mode on: the dungeon route takes over")
  local opts = Q.Guides:Choices(start, "Dwarf", "Alliance")
  t.eq(#opts, 1); t.eq(opts[1].guide.id, "AD_T2"); t.ok(opts[1].default)
  t.eq(Q.Guides:Handoff(start, "Human", "dungeon").id, "AD_T2", "smallest id among the matching chapters")
  t.eq(Q.Guides:Handoff(Q.Guides:Get("AD_T2"), "Dwarf", "dungeon"), nil, "no handoff from a mode chapter")
  -- after sans mode : refusé
  t.eq(Q:RegisterGuide({ id = "X_BAD2", faction = "Alliance", after = { "T_START" }, steps = {} }), false)
end

function tests.unknown_rung_never_blocks_the_route(t)
  local Q = load()
  local D = Q.DungeonMode
  t.eq(D:StepSkip({ rung = "NOPE", phase = "run" }, 10), nil)
  t.eq(D:StepSkip({ alt = "NOPE" }, 10), nil)
  t.ok(not D:SetChecked("NOPE", false))
  t.ok(not D:SetBypassed("NOPE", true))
  t.eq(D:StepSkip({}, 10), nil)
  t.eq(D:StepSkip(nil, 10), nil)
end

function tests.rungs_list_states_stars_and_progress(t)
  local Q = load()
  Mock.quests.completed[166] = true
  Mock.fire("QUEST_TURNED_IN", 166)
  Q.DungeonMode:SetChecked("SFK", false)
  local list = Q.DungeonMode:Rungs()
  t.eq(#list, 3)
  t.eq(list[1].key, "DM"); t.eq(list[1].stars, 1); t.eq(list[1].done, 1); t.eq(list[1].total, 2)
  t.eq(list[2].stars, 3); t.eq(list[2].state, "on")
  t.eq(list[3].stars, 0); t.eq(list[3].state, "off"); t.eq(list[3].total, 0)
end

function tests.route_choices_stay_in_their_route(t)
  local Q = load()
  Q:RegisterGuide({ id = "T_USUAL", faction = "Alliance", minLevel = 1, maxLevel = 5, next = "T_NEXT",
    choices = { { id = "T_NEXT" }, { id = "AD_T1" } }, steps = { { "note", "a" } } })
  Q:RegisterGuide({ id = "T_NEXT", faction = "Alliance", minLevel = 5, maxLevel = 9, steps = { { "note", "b" } } })
  local opts = Q.Guides:Choices(Q.Guides:Get("T_USUAL"), "Dwarf", "Alliance")
  t.eq(#opts, 1)
  t.eq(opts[1].guide.id, "T_NEXT")
end

function tests.options_entry_follows_availability(t)
  local Q = load()
  local S = Q.OptionsSchema
  local e = S:Entry("route.dungeonMode")
  t.ok(e ~= nil and e.visible(), "visible with dungeon chapters")
  t.eq(S:Get(e), false)
  t.ok(S:Set(e, true))
  t.ok(Q.DungeonMode:IsOn())
  t.eq(S:Get(e), true)
  t.ok(S:Entry("openDungeonMode") ~= nil)
  Mock.reset()
  Q = load({ guides = {} })
  t.ok(not Q.OptionsSchema:Entry("route.dungeonMode").visible(), "hidden without dungeon chapters")
  t.ok(not Q.OptionsSchema:Entry("openDungeonMode").visible())
end

-- Vue « Automatique » de l'onglet Route du journal.
local function openAuto(Q)
  Q.UI.Journal:ShowRouteMode("auto")
  return Q.UI.DungeonModePanel, Q.UI.Journal
end

function tests.route_tab_has_manual_and_automatic_views(t)
  local Q = load()
  local J = Q.UI.Journal
  J:ShowTab("route")
  t.eq(J:RouteMode(), "manual", "manual view by default")
  t.ok(J.routePanels.manual:IsShown() and not J.routePanels.auto:IsShown())
  t.ok(J.routeModeButtons.manual:IsShown() and J.routeModeButtons.auto:IsShown())
  t.ok(not J.routeModeButtons.manual:IsEnabled(), "open view: pressed button")
  Mock.click(J.routeModeButtons.auto)
  t.eq(J:RouteMode(), "auto")
  t.ok(J.routePanels.auto:IsShown() and not J.routePanels.manual:IsShown())
  t.ok(not J.routeModeButtons.auto:IsEnabled() and J.routeModeButtons.manual:IsEnabled())
  -- les boutons ne sont que sur l'onglet Route
  J:ShowTab("class")
  t.ok(not J.routeModeButtons.auto:IsShown())
  J:ShowTab("route")
  t.ok(J.routeModeButtons.auto:IsShown())
  t.eq(J:RouteMode(), "auto", "view kept")
  Mock.click(J.routeModeButtons.manual)
  t.ok(J.routePanels.manual:IsShown())
  t.eq(#Mock.errors, 0)
end

function tests.automatic_view_starts_and_stops_the_mode(t)
  local Q = load()
  local P = openAuto(Q)
  t.eq(P.startButton:GetText(), Q.L.DGMODE_START)
  t.eq(P.status:GetText(), Q.L.DGMODE_STATUS_OFF)
  Mock.click(P.startButton)
  t.ok(Q.DungeonMode:IsOn())
  t.eq(P.startButton:GetText(), Q.L.DGMODE_STOP)
  t.eq(P.status:GetText(), Q.L.DGMODE_STATUS_ON)
  t.eq(Q.Progress:Guide().id, "AD_T1")
  Mock.click(P.startButton)
  t.ok(not Q.DungeonMode:IsOn())
  t.eq(#Mock.errors, 0)
end

function tests.automatic_view_folds_the_dungeons(t)
  local Q = load()
  local P = openAuto(Q)
  -- replié par défaut : compteur dans l'en-tête, aucune ligne
  t.eq(P.fold.text:GetText(), string.format(Q.L.DGMODE_FOLD_CLOSED, 3, 3))
  t.eq(#P.rows, 0)
  t.ok(not P.allButton:IsShown())
  Mock.click(P.fold)
  t.eq(P.fold.text:GetText(), string.format(Q.L.DGMODE_FOLD_OPEN, 3, 3))
  t.eq(#P.rows, 3)
  t.ok(P.allButton:IsShown() and P.noneButton:IsShown())
  t.eq(P.rows[2].name:GetText(), "Scarlet Monastery: Library")
  t.ok(P.rows[1].check:GetChecked())
  t.eq(P.rows[1].bypass, nil, "no skip button: an unticked dungeon is skipped")
  -- une case décochée : donjon sauté
  P.rows[1].check:SetChecked(false)
  Mock.click(P.rows[1].check)
  t.eq(Q.DungeonMode:State("DM"), "off")
  t.eq(P.fold.text:GetText(), string.format(Q.L.DGMODE_FOLD_OPEN, 2, 3))
  Mock.click(P.noneButton)
  for _, it in ipairs(Q.DungeonMode:Rungs()) do t.eq(it.state, "off") end
  Mock.click(P.allButton)
  for _, it in ipairs(Q.DungeonMode:Rungs()) do t.eq(it.state, "on") end
  Mock.click(P.fold)
  t.ok(not P.rows[1]:IsShown(), "folded again")
  t.eq(#Mock.errors, 0)
end

function tests.automatic_view_lists_the_zones_in_order(t)
  local Q = load({ guides = {
    { id = "T_START", faction = "Alliance", minLevel = 1, maxLevel = 5, next = "T_USUAL", steps = { { "note", "s" } } },
    { id = "T_USUAL", faction = "Alliance", minLevel = 5, maxLevel = 9, steps = { { "note", "u" } } },
    { id = "AD_T1", title = "Westfall", faction = "Alliance", mode = "dungeon", after = { "T_START" }, minLevel = 5,
      maxLevel = 9, next = "AD_T2", steps = { { "note", "zone" }, { "goto", 1436, 42.5, 71.7, rung = "DM", phase = "run" },
        { "goto", 1436, 42.5, 71.7, rung = "SM_LIB", phase = "run" } } },
    { id = "AD_T2", title = "Redridge Mountains", faction = "Alliance", mode = "dungeon", minLevel = 9, maxLevel = 12,
      steps = { { "note", "alt", alt = { "DM", "SM_LIB" }, below = 12 } } },
  } })
  local chain = Q.DungeonMode:Chain("Dwarf")
  t.eq(#chain, 2)
  t.eq(chain[1].guide.id, "AD_T1"); t.eq(table.concat(chain[1].runs, ","), "DM,SM_LIB"); t.eq(chain[1].alt, nil)
  t.eq(chain[2].guide.id, "AD_T2"); t.eq(#chain[2].runs, 0); t.eq(chain[2].alt, true)
  local P = openAuto(Q)
  t.eq(#P.zoneRows, 2)
  t.eq(P.zoneRows[1].level:GetText(), "5-9")
  t.eq(P.zoneRows[1].name:GetText(), "Westfall")
  t.eq(P.zoneRows[1].detail:GetText(), "The Deadmines, Scarlet Monastery: Library")
  t.eq(P.zoneRows[2].detail:GetText(), Q.L.DGMODE_ZONE_ALT)
  -- un donjon décoché n'est plus annoncé dans sa zone
  Q.DungeonMode:SetChecked("DM", false)
  t.eq(P.zoneRows[1].detail:GetText(), "Scarlet Monastery: Library")
  t.eq(#Mock.errors, 0)
end

function tests.panel_tooltip_lines(t)
  local Q = load()
  local P = Q.UI.DungeonModePanel
  local data = Q.DungeonRouteData.rungs
  local lines = P.RungTip(data[1])
  t.eq(lines[1], "The Deadmines")
  t.ok(lines[3]:find("2075", 1, true), lines[3])
  t.ok(P.RungTip(data[2])[3]:find("about", 1, true), "estimated XP is flagged")
  t.eq(P.RungTip(data[3])[3], Q.L.DGMODE_ROW_TIP_NOQUEST)
end

function tests.automatic_view_is_hidden_without_the_mode(t)
  local Q = load({ guides = {} })
  local J = Q.UI.Journal
  J:ShowRouteMode("auto")
  t.eq(J:RouteMode(), "manual", "no automatic route for this character")
  t.ok(J.routePanels.manual:IsShown() and not J.routePanels.auto:IsShown())
  t.ok(not J.routeModeButtons.auto:IsShown() and not J.routeModeButtons.manual:IsShown())
  -- la vue elle-même reste sûre
  Q.UI.DungeonModePanel:Refresh()
  t.ok(not Q.UI.DungeonModePanel.startButton:IsEnabled())
  t.eq(Q.UI.DungeonModePanel.status:GetText(), Q.L.DGMODE_UNAVAILABLE)
  t.eq(#Mock.errors, 0)
end

function tests.slash_opens_the_automatic_view(t)
  local Q = load()
  SlashCmdList.QUESTIFY("donjons")
  t.ok(Q.UI.Journal:IsShown())
  t.eq(Q.UI.Journal.tab, "route"); t.eq(Q.UI.Journal:RouteMode(), "auto")
  Q.UI.Journal.frame:Hide()
  Q.UI.Journal.routeMode = "manual"
  SlashCmdList.QUESTIFY("dungeons")
  t.ok(Q.UI.Journal:IsShown())
  t.eq(Q.UI.Journal:RouteMode(), "auto")
end

-- Mode automatique : les donjons sont dans la route, plus de donjon suggéré.
function tests.no_suggested_dungeon_in_automatic_mode(t)
  local Q = load()
  local calls = 0
  local list = Q.Dungeons.List
  Q.Dungeons.List = function(self) calls = calls + 1; return list(self) end
  Q.Dungeons:Suggested()
  t.ok(calls > 0, "manual mode: dungeons are looked up")
  calls = 0
  local fired = 0
  Q:On("DUNGEONS_CHANGED", function() fired = fired + 1 end)
  Q.DungeonMode:SetOn(true)
  t.ok(fired > 0, "the tracker alert is refreshed")
  calls = 0
  t.eq(#Q.Dungeons:Suggested(), 0)
  t.eq(#Q.Dungeons:Alerts(), 0)
  t.eq(calls, 0, "automatic mode: nothing is suggested")
end

function tests.french_strings_cover_english(t)
  Mock.locale = "frFR"
  local Q = load()
  t.eq(Q.L.DGMODE_TAB_AUTO, "Automatique")
  t.eq(Q.UI.DungeonModePanel.RungName(Q.DungeonRouteData.rungs[2]), "Scarlet Monastery : Bibliothèque")
end

---------------------------------------------------------------------------
-- Données livrées
---------------------------------------------------------------------------
local function shipped()
  local Q = {}
  assert(loadfile(Mock.root .. "/" .. DATA_FILE))("Questify", Q)
  assert(loadfile(Mock.root .. "/" .. DUNGEON_FILE))("Questify", Q)
  return Q
end

function tests.shipped_data_is_consistent(t)
  local Q = shipped()
  local d = Q.DungeonRouteData
  t.eq(d.faction, "Alliance")
  local byKey, quests = {}, {}
  for _, dg in ipairs(Q.DungeonData) do
    byKey[dg.key] = dg
    quests[dg.key] = {}
    for _, q in ipairs(dg.quests.Alliance or {}) do quests[dg.key][q.id] = true end
  end
  local seenKey, seenQuest, last = {}, {}, 0
  for _, r in ipairs(d.rungs) do
    t.ok(not seenKey[r.key], "duplicate rung " .. r.key)
    seenKey[r.key] = true
    local dg = byKey[r.dungeon]
    t.ok(dg ~= nil, "unknown dungeon of " .. r.key)
    t.eq(r.areaId, dg.areaId)
    t.ok(r.entry >= r.minLevel and r.entry <= r.maxLevel, "entry inside the range: " .. r.key)
    t.ok(r.entry >= last, "rungs in entry order: " .. r.key)
    last = r.entry
    t.ok(r.stars >= 0 and r.stars <= 3)
    t.eq(r.stars == 0, #r.quests == 0)
    local xp = 0
    for _, id in ipairs(r.quests) do
      t.ok(quests[r.dungeon][id], ("quest %d of %s is an Alliance quest of %s"):format(id, r.key, r.dungeon))
      t.ok(not seenQuest[id], "quest in two rungs: " .. id)
      seenQuest[id] = true
      xp = xp + ((Q.QuestRewardData[id] or {}).xp or 0)
    end
    t.eq(r.xp, xp)
  end
  -- tous les donjons 5 joueurs ouverts à l'Alliance ont un échelon ; les Horde seulement n'en ont pas
  for _, key in ipairs({ "THANES", "WC", "DM", "SFK", "BFD", "STOCKADE", "EXCAVATION", "DALARAN", "GNOMER", "RFK",
                         "ULDAMAN", "RFD", "MARAUDON", "ZF", "ST", "BRD", "SCHOLO" }) do
    t.ok(seenKey[key], "missing rung " .. key)
  end
  for _, key in ipairs({ "SM_GY", "SM_LIB", "SM_ARM", "SM_CATH", "DM_EAST", "DM_WEST", "DM_NORTH", "STRAT_LIVE",
                         "STRAT_UD" }) do
    t.ok(seenKey[key], "missing wing " .. key)
  end
  t.ok(not seenKey.RFC and not seenKey.LORDAERON, "Horde-only dungeons are left out")
end

function tests.shipped_wings_have_strings(t)
  local Q = load()
  local d = shipped().DungeonRouteData
  for _, r in ipairs(d.rungs) do
    if r.wing then t.ok(rawget(Q.L, "DGMODE_WING_" .. r.wing) ~= nil, "no text for wing " .. r.wing) end
  end
end

function tests.shipped_guides_load_with_the_mode_files(t)
  -- chargement complet (guides livrés) : aucun guide rejeté, aucune erreur, route habituelle inchangée
  local Q = Mock.loadAddon(TOC, {})
  t.eq(#Mock.errors, 0)
  t.eq(Mock.countPrinted("AD_"), 0, "no dungeon chapter rejected")
  t.ok(Q.DungeonRouteData ~= nil and #Q.DungeonRouteData.rungs > 20)
  t.ok(Q.Progress:Guide().mode == nil)
  t.eq(Q.Progress:Guide().id, "A_DwarfGnome_01")
  t.ok(Q.DungeonMode:Available(), "dungeon chapters are shipped")
end

-- Chapitres livrés du mode : chaque échelon a son bloc « instance » puis une alternative, toutes les
-- étiquettes nomment un échelon connu, la chaîne va jusqu'au niveau 60.
function tests.shipped_dungeon_chapters_cover_every_rung(t)
  local Q = Mock.loadAddon(TOC, {})
  local known, ran, alt = {}, {}, {}
  for _, r in ipairs(Q.DungeonRouteData.rungs) do known[r.key] = true end
  local g, seen, n, last = Q.Guides:Get("AD_01"), {}, 0, nil
  t.ok(g ~= nil, "AD_01 is shipped")
  while g and not seen[g.id] do
    seen[g.id] = true
    n = n + 1
    last = g
    t.eq(g.mode, "dungeon")
    t.eq(g.faction, "Alliance")
    for i, s in ipairs(g.steps) do
      if s.rung then
        t.ok(known[s.rung], ("%s step %d: unknown rung %s"):format(g.id, i, s.rung))
        if s.phase == "run" and s.action == "goto" then
          t.ok(not alt[s.rung], "instance after its alternative: " .. s.rung)
          ran[s.rung] = true
        end
      end
      for _, k in ipairs(s.alt or {}) do
        t.ok(known[k], ("%s step %d: unknown rung %s in alt"):format(g.id, i, k))
        t.ok(ran[k], ("%s: alternative of %s before its instance"):format(g.id, k))
        alt[k] = true
      end
    end
    g = Q.Guides:Next(g, "Human")
  end
  t.ok(n >= 30, "chapters in the chain: " .. n)
  t.eq(last.maxLevel, 60)
  for key in pairs(known) do
    t.ok(ran[key], "no instance block for " .. key)
    t.ok(alt[key], "no open-world alternative for " .. key)
  end
end

function tests.shipped_mode_joins_after_the_race_starts(t)
  local Q = Mock.loadAddon(TOC, {})
  local G = Q.Guides
  -- sous le niveau des chapitres du mode : les départs habituels
  t.eq(G:ForPlayer("Alliance", "Human", 5, "dungeon").mode, nil)
  t.eq(G:ForPlayer("Alliance", "NightElf", 13, "dungeon").id, "AD_NightElf_03")
  t.eq(G:ForPlayer("Alliance", "Human", 13, "dungeon").mode, nil, "the night elf chapter is not for humans")
  t.eq(G:ForPlayer("Alliance", "Human", 30, "dungeon").mode, "dungeon")
  t.eq(G:ForPlayer("Alliance", "Human", 30).mode, nil, "usual route untouched")
  t.eq(G:ForPlayer("Horde", "Orc", 30, "dungeon").mode, nil, "Horde: usual route")
  Q.DungeonMode:SetOn(true)
  t.eq(G:Next(G:Get("A_Human_03"), "Human").id, "AD_01")
  t.eq(G:Next(G:Get("A_DwarfGnome_04"), "Dwarf").id, "AD_01")
  t.eq(G:Next(G:Get("A_NightElf_02"), "NightElf").id, "AD_NightElf_03")
  t.eq(G:Next(G:Get("AD_NightElf_03"), "NightElf").id, "AD_01")
  Q.DungeonMode:SetOn(false)
  t.eq(G:Next(G:Get("A_Human_03"), "Human").id, "A_01")
end

return tests
