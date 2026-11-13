-- Mode automatique : quêtes en plus d'un échelon (Q.Dungeons:Extras, AddExtras, RemoveExtras, ExtraTarget, Trip)
-- et bouton « Quêtes supplémentaires » du suivi. Cas réel : un personnage qui a fait les donjons précédents passe
-- l'alternative des Carmines et arrive à l'entrée de la Prison sans « What Comes Around... » (Carmines) ni
-- « The Fury Runs Deep » (Paluns, après « The Dark Iron War », niveau 30 dans Forever).
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local ALLIANCE = 4294967373
local ENTRANCE = { 1453, 52.41, 70.01 }

local function testData()
  return {
    { key = "STOCKADE", name = "The Stockade", areaId = 717, minLevel = 24, maxLevel = 32,
      factions = { "Alliance" }, entrance = ENTRANCE, entranceSource = "questiedb",
      quests = {
        Alliance = {
          { id = 387, giver = 1719, at = { 1453, 51.49, 69.38 }, ender = 1719, endAt = { 1453, 51.49, 69.38 },
            level = 26, reqLevel = 22, races = ALLIANCE },
          { id = 386, giver = 859, at = { 1433, 21.17, 46.58 }, ender = 859, endAt = { 1433, 21.17, 46.58 },
            level = 25, reqLevel = 22, races = ALLIANCE },
          { id = 378, giver = 1074, at = { 1437, 49.67, 18.23 }, ender = 1074, endAt = { 1437, 49.67, 18.23 },
            level = 27, reqLevel = 22, races = ALLIANCE, pre = { 303 } },
          -- quête du donjon hors de l'échelon (autre aile) : jamais proposée en plus
          { id = 9100, giver = 1720, at = { 1453, 60, 60 }, ender = 1720, endAt = { 1453, 60, 60 },
            level = 26, reqLevel = 22, races = ALLIANCE },
        },
      },
    },
  }
end

local function routeData()
  return { faction = "Alliance", entryOffset = 2, entryCap = 58, rungs = {
    { key = "STOCKADE", dungeon = "STOCKADE", name = "The Stockade", areaId = 717, minLevel = 24, maxLevel = 32,
      entry = 26, quests = { 386, 387, 378 }, xp = 3700, pct = 0.2, stars = 2 },
  } }
end

-- Chapitre du mode : prise en ville (prep), entrée, objectifs et rendus (run) ; 386 n'a pas d'étape de prise
-- (l'alternative des Carmines a été passée).
local function modeGuide()
  return { id = "AD_X", title = "Duskwood", faction = "Alliance", mode = "dungeon", minLevel = 20, maxLevel = 30,
    steps = {
      { "accept", 387, rung = "STOCKADE", phase = "prep", optional = true, dungeon = "The Stockade" },
      { "goto", ENTRANCE[1], ENTRANCE[2], ENTRANCE[3], rung = "STOCKADE", phase = "run", optional = true,
        dungeon = "The Stockade", note = "enter" },
      { "complete", 387, rung = "STOCKADE", phase = "run", optional = true, dungeon = "The Stockade" },
      { "complete", 386, rung = "STOCKADE", phase = "run", optional = true, dungeon = "The Stockade" },
      { "turnin", 387, rung = "STOCKADE", phase = "run", optional = true, dungeon = "The Stockade" },
      { "turnin", 386, rung = "STOCKADE", phase = "run", optional = true, dungeon = "The Stockade" },
      { "note", "after the dungeon" },
    } }
end

local function npc(name, area, x, y)
  return { name = name, spawns = { [area] = { { x, y } } }, friendlyToFaction = "A" }
end

local function qdbData()
  local function quest(name, giver, reqLevel, level, extra)
    local q = { name = name, startedBy = { { giver } }, finishedBy = { { giver } }, requiredLevel = reqLevel,
      questLevel = level, requiredRaces = ALLIANCE, zoneOrSort = 717, objectives = { { { 1696 } } } }
    for k, v in pairs(extra or {}) do q[k] = v end
    return q
  end
  return {
    quests = {
      [387] = quest("Quell The Uprising", 1719, 22, 26),
      [386] = quest("What Comes Around...", 859, 22, 25),
      [378] = quest("The Fury Runs Deep", 1074, 22, 27, { preQuestSingle = { 303 } }),
      [303] = quest("The Dark Iron War", 1074, 22, 30, { zoneOrSort = 11, objectives = { { { 1051 } } } }),
      [9100] = quest("Other Wing", 1720, 22, 26),
    },
    npcs = {
      [1719] = npc("Warden Thelwater", 1519, 51.49, 69.38),
      [1720] = npc("Other Giver", 1519, 60, 60),
      [859] = npc("Guard Berton", 44, 21.17, 46.58),
      [1074] = npc("Motley Garmason", 11, 49.67, 18.23),
      [1051] = { name = "Dark Iron Dwarf", spawns = { [11] = { { 47.0, 17.0 } } } },
      [1696] = { name = "Targorr the Dread", spawns = {} },
    },
    zones = { areaIdToUiMapId = { [44] = 1433, [11] = 1437 } },
  }
end

local function load(opts)
  opts = opts or {}
  Ext.install()
  Mock.maps[1433] = { name = "Redridge Mountains", continent = 0, left = -6000, top = 8500, width = 2170,
    height = 1447, parent = 1415 }
  Mock.player.raceId, Mock.player.faction, Mock.player.level = 1, "Alliance", opts.level or 26
  Mock.player.map, Mock.player.x, Mock.player.y = 1453, 50, 60
  opts.level = nil
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  opts.qdb = opts.qdb or qdbData()
  opts.beforeLogin = function(Q)
    Q.DungeonData = testData()
    Q.DungeonRouteData = routeData()
    Q:RegisterGuide(modeGuide())
  end
  return Mock.loadAddon(TOC, opts)
end

local function accept(id, complete)
  Mock.quests.log[id] = { complete = complete == true, objectives = {} }
  Mock.fire("QUEST_ACCEPTED", id)
end

local function turnIn(id)
  Mock.quests.log[id] = nil
  Mock.quests.completed[id] = true
  Mock.fire("QUEST_TURNED_IN", id)
end

-- Mode automatique allumé, chapitre de la Prison, 387 prise : l'étape courante est l'entrée du donjon.
local function atEntrance(opts)
  local Q = load(opts)
  Q.DungeonMode:SetOn(true)
  Q.Progress:SetGuide("AD_X", true)
  accept(387)
  return Q
end

local function block(Q)
  local out = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.tag == "dg:STOCKADE" then out[#out + 1] = e end
  end
  return out
end

local function names(list)
  local out = {}
  for _, e in ipairs(list) do out[#out + 1] = e.step.action .. " " .. tostring(e.step.questId or "") end
  return out
end

local function noErrors(t)
  for _, e in ipairs(Mock.errors) do t.ok(false, "unexpected error: " .. tostring(e)) end
end

return {
  extras_list_the_quests_the_route_did_not_pick_up = function(t)
    local Q = atEntrance()
    local cur = Q.Progress:Current()
    t.eq(cur.step.action, "goto"); t.eq(cur.step.phase, "run")
    local info = Q.Dungeons:Extras("STOCKADE")
    t.ok(info, "something to add")
    local ids = {}
    for _, q in ipairs(info.quests) do ids[#ids + 1] = q.id end
    t.eq(ids, { 386, 378 }, "the closest first; 387 is already in the log, 9100 belongs to another wing")
    t.eq(info.quests[1].pre, {})
    t.eq(info.quests[2].pre, { 303 }, "The Dark Iron War first")
    t.eq(info.quests[1].at, { 1433, 21.17, 46.58 })
    local key, what, again = Q.Dungeons:ExtraTarget(cur)
    t.eq(key, "STOCKADE"); t.eq(what, "add")
    t.eq(#again.quests, 2)
    noErrors(t)
  end,

  add_extras_builds_one_block_before_the_dungeon = function(t)
    local Q = atEntrance()
    local changed = 0
    Q:On("DUNGEONS_CHANGED", function() changed = changed + 1 end)
    t.eq(Q.Dungeons:AddExtras("STOCKADE"), true)
    t.eq(changed, 1)
    t.ok(Q.Dungeons:ExtrasAdded("STOCKADE"))
    local steps = block(Q)
    t.eq(names(steps), {
      "accept 386", "accept 303", "complete 303", "turnin 303", "accept 378",
      "goto ", "complete 387", "complete 386", "complete 378",
      "turnin 387", "turnin 386", "turnin 378",
    })
    local gotoSeen = false
    for _, e in ipairs(steps) do
      local s = e.step
      t.eq(s.rung, "STOCKADE", "rung on " .. s.action)
      if s.action == "goto" then
        gotoSeen = true
        t.eq({ s.mapId, s.x, s.y }, ENTRANCE)
        t.eq(s.dungeon, nil, "the entrance is not a way back")
      end
      t.eq(s.phase, gotoSeen and "run" or "prep", "phase of " .. s.action .. " " .. tostring(s.questId))
    end
    t.eq(Q.Progress:Current().key, "i:dg:STOCKADE:1", "the extra quests come first")
    if Q.AutoQuest and Q.AutoQuest.IsRouteQuest then
      t.ok(Q.AutoQuest:IsRouteQuest(386), "automatic accept knows the extra quests")
    end
    for _, e in ipairs(steps) do t.ok(e.step.questId ~= 9100, "never the other wing's quest") end
    noErrors(t)
  end,

  remove_extras_goes_back_to_the_entrance = function(t)
    local Q = atEntrance()
    Q.Dungeons:AddExtras("STOCKADE")
    local key, what = Q.Dungeons:ExtraTarget(Q.Progress:Current())
    t.eq(key, "STOCKADE"); t.eq(what, "remove")
    t.eq(Q.Dungeons:RemoveExtras("STOCKADE"), true)
    t.eq(#block(Q), 0)
    t.ok(not Q.Dungeons:ExtrasAdded("STOCKADE"))
    t.eq(Q.Progress:Current().step.action, "goto", "back on the route's entrance step")
    t.eq(Q.Dungeons:RemoveExtras("STOCKADE"), false, "nothing left to remove")
    noErrors(t)
  end,

  block_follows_the_rung_checkbox_and_the_skip_button = function(t)
    local Q = atEntrance()
    Q.Dungeons:AddExtras("STOCKADE")
    -- « Passer ce donjon » : les prises restent, l'instance et les rendus sont passés
    Q.DungeonMode:SetBypassed("STOCKADE", true)
    for _, e in ipairs(block(Q)) do
      local st = Q.Progress:State(e)
      if e.step.phase == "run" then
        t.eq(st, "skipped", "bypassed: " .. e.step.action)
      elseif e.step.action == "accept" then
        -- (« faire » et « rendre » d'une préquête sont passés tant qu'elle n'est pas au journal)
        t.ok(st ~= "skipped", "pick-ups kept: accept " .. tostring(e.step.questId))
      end
    end
    t.eq(Q.Dungeons:Extras("STOCKADE"), nil, "nothing to add while the instance is skipped")
    -- case décochée : tout le bloc est passé, puis retiré
    Q.DungeonMode:SetChecked("STOCKADE", false)
    Q.Progress:Update()
    for _, e in ipairs(block(Q)) do t.eq(Q.Progress:State(e), "skipped") end
    t.eq(Q.Progress:Current().step.text, "after the dungeon")
    noErrors(t)
  end,

  block_removes_itself_once_everything_is_turned_in = function(t)
    local Q = atEntrance()
    Q.Dungeons:AddExtras("STOCKADE")
    accept(386)
    accept(303, true)
    turnIn(303)
    accept(378)
    for _, id in ipairs({ 386, 387, 378 }) do Mock.quests.log[id].complete = true end
    Mock.fire("QUEST_LOG_UPDATE")
    for _, id in ipairs({ 387, 386, 378 }) do turnIn(id) end
    t.eq(#block(Q), 0, "block gone")
    t.eq(Q.Progress:Current().step.text, "after the dungeon", "the route's own instance steps are done too")
    noErrors(t)
  end,

  nothing_to_add_means_no_extras = function(t)
    local Q = atEntrance()
    accept(386)
    accept(378)
    t.eq(Q.Dungeons:Extras("STOCKADE"), nil, "every rung quest is in the log")
    t.eq(Q.Dungeons:ExtraTarget(Q.Progress:Current()), nil)
    t.eq(Q.Dungeons:AddExtras("STOCKADE"), false)
    noErrors(t)
  end,

  extras_need_the_automatic_mode_and_dungeon_quests = function(t)
    local Q = load()
    Q.Progress:SetGuide("AD_X", true)
    t.eq(Q.Dungeons:Extras("STOCKADE"), nil, "mode off")
    Q.DungeonMode:SetOn(true)
    t.ok(Q.Dungeons:Extras("STOCKADE"))
    t.eq(Q.Dungeons:Extras("NOPE"), nil, "unknown rung")
    Q.Settings:Set("dungeonQuests", false)
    t.eq(Q.Dungeons:Extras("STOCKADE"), nil, "dungeon quests turned off")
    noErrors(t)
  end,

  extras_wait_for_the_level = function(t)
    local Q = atEntrance({ level = 21 })
    t.eq(Q.Dungeons:Extras("STOCKADE"), nil, "every extra quest needs level 22")
    noErrors(t)
  end,

  trip_reads_shortestpath_with_fractions = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Trip(1453, 50, 60, 1433, 21.17, 46.58), nil, "without ShortestPathForever")
    local args
    ShortestPathForever = { API = { EstimateDetail = function(...)
      args = { ... }
      return { seconds = 250, legs = { { mode = "walk", newFlightPath = true }, { mode = "flight" },
        { mode = "boat" }, { mode = "tram" } } }
    end } }
    local trip = Q.Dungeons:Trip(1453, 50, 60, 1433, 21.17, 46.58)
    local want = { 1453, 0.5, 0.6, 1433, 0.2117, 0.4658 }
    for i, v in ipairs(want) do t.ok(math.abs((args[i] or -1) - v) < 1e-9, "0-1 coordinates: argument " .. i) end
    t.eq(trip.seconds, 250)
    t.ok(trip.flight and trip.boat and trip.tram and trip.newFlightPath)
    ShortestPathForever.API.EstimateDetail = function() return nil, "loading" end
    t.eq(Q.Dungeons:Trip(1453, 50, 60, 1433, 21, 46), nil, "still loading")
    ShortestPathForever.API.EstimateDetail = function() error("boom") end
    t.eq(Q.Dungeons:Trip(1453, 50, 60, 1433, 21, 46), nil, "an error stays inside")
    t.eq(Q.Dungeons:Trip(nil, 50, 60, 1433, 21, 46), nil)
    ShortestPathForever = nil
    noErrors(t)
  end,

  tracker_button_adds_then_removes_the_extra_quests = function(t)
    local Q = atEntrance()
    local T = Q.UI.Tracker
    T:Refresh()
    t.ok(T.skipButton:IsShown(), "skip button on the entrance step")
    t.ok(T.extraButton:IsShown(), "extra quests button too")
    t.eq(T.extraButton:GetText(), string.format(Q.L.DGMODE_TRK_EXTRA, 2))
    -- infobulle sans ShortestPathForever : quêtes, préquête et son niveau, pas de trajet
    Mock.tooltip.lines = {}
    T.extraButton:GetScript("OnEnter")(T.extraButton)
    t.ok(Ext.tooltipHas(Q.L.DGMODE_TRK_EXTRA_TITLE), "title")
    t.ok(Ext.tooltipHas("What Comes Around..."), "Redridge quest")
    t.ok(Ext.tooltipHas("Guard Berton"), "its giver")
    t.ok(Ext.tooltipHas("The Fury Runs Deep"), "Wetlands quest")
    t.ok(Ext.tooltipHas(string.format(Q.L.DGMODE_TRK_EXTRA_PRE,
      string.format(Q.L.DGMODE_TRK_EXTRA_PRE_LEVEL, "The Dark Iron War", 30))), "pre-quest and its level")
    t.ok(Ext.tooltipHas(Q.L.DGMODE_TRK_EXTRA_NOTRIP), "travel times need ShortestPathForever")
    -- avec ShortestPathForever : trajet de chaque prise, retour à l'entrée, total
    ShortestPathForever = { API = { EstimateDetail = function()
      return { seconds = 240, legs = { { mode = "flight" }, { mode = "walk", newFlightPath = true } } }
    end } }
    Mock.tooltip.lines = {}
    T.extraButton:GetScript("OnEnter")(T.extraButton)
    local trip = T.TripText({ seconds = 240, flight = true, newFlightPath = true })
    t.eq(trip, string.format(Q.L.DGMODE_TRIP_MIN, 4) .. ", " .. Q.L.DGMODE_TRIP_FLIGHT .. ", "
      .. Q.L.DGMODE_TRIP_NEW_FP)
    t.ok(Ext.tooltipHas(trip), "trip with its flight and the new flight path")
    t.ok(Ext.tooltipHas(string.format(Q.L.DGMODE_TRK_EXTRA_BACK, trip)), "back to the entrance")
    t.ok(Ext.tooltipHas(string.format(Q.L.DGMODE_TRK_EXTRA_TOTAL, 12)), "three trips of 4 min")
    t.ok(not Ext.tooltipHas(Q.L.DGMODE_TRK_EXTRA_NOTRIP))
    ShortestPathForever = nil
    -- clic : le bloc est ajouté, le bouton propose de le retirer
    Mock.click(T.extraButton, "LeftButton")
    t.ok(Q.Dungeons:ExtrasAdded("STOCKADE"))
    t.eq(Q.Progress:Current().key, "i:dg:STOCKADE:1")
    t.ok(not T.skipButton:IsShown(), "no skip button on a pick-up")
    t.ok(T.extraButton:IsShown())
    t.eq(T.extraButton:GetText(), Q.L.DGMODE_TRK_EXTRA_REMOVE)
    Mock.click(T.extraButton, "LeftButton")
    t.ok(not Q.Dungeons:ExtrasAdded("STOCKADE"))
    t.eq(T.extraButton:GetText(), string.format(Q.L.DGMODE_TRK_EXTRA, 2), "back on the entrance: add again")
    noErrors(t)
  end,

  tracker_button_hidden_in_manual_mode_and_inside_the_dungeon = function(t)
    local Q = load()
    local T = Q.UI.Tracker
    Q.Progress:SetGuide("AD_X", true)
    accept(387)
    T:Refresh()
    t.ok(not T.extraButton:IsShown(), "manual mode")
    Q.DungeonMode:SetOn(true)
    Q.Progress:SetGuide("AD_X", true)
    T:Refresh()
    t.ok(T.extraButton:IsShown())
    -- dans l'instance (objectif courant) : plus de bouton
    Q.Progress:Skip(Q.Progress:Current().key)
    t.eq(Q.Progress:Current().step.action, "complete")
    T:Refresh()
    t.ok(not T.extraButton:IsShown(), "not on an objective step")
    noErrors(t)
  end,
}
