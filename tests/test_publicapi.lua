-- Tests de l'API publique en lecture seule (Nav/PublicAPI.lua) : QuestifyAPI.Destination(), lue par
-- les addons de navigation (AzerothGPS) à intervalle régulier.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

local function load()
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES } })
end

local function useGuide(Q, id, steps)
  Q:RegisterGuide({ id = id, faction = "Alliance", minLevel = 1, maxLevel = 60, steps = steps })
  Q.Progress:SetGuide(id)
end

local function accept179()
  Mock.quests.log[179] = { complete = false, objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
  Mock.fire("QUEST_ACCEPTED", 179)
end

return {
  global_is_published = function(t)
    local Q = load()
    t.ok(type(_G.QuestifyAPI) == "table", "QuestifyAPI global")
    t.eq(_G.QuestifyAPI.version, 1)
    t.ok(_G.QuestifyAPI == Q.PublicAPI, "same table as Q.PublicAPI")
  end,

  destination_of_the_current_step = function(t)
    load()
    local d = QuestifyAPI.Destination()
    t.ok(d ~= nil, "a destination at login")
    -- étape 1 « accept 179 » : Sten Stoutarm, mêmes coordonnées que le repère du jeu (0-1)
    t.eq(d.mapID, 1426)
    t.near(d.x, 0.2993, 0.001)
    t.near(d.y, 0.712, 0.001)
    t.ok(type(d.title) == "string" and d.title ~= "", "has a title")
    t.eq(d.manual, false)
    t.eq(d.step.guide, "A_DwarfGnome_01")
    t.eq(d.step.index, 1)
    t.eq(d.step.action, "accept")
    t.eq(d.step.key, nil, "internal key not exposed")
    t.ok(type(d.key) == "string" and d.key ~= "", "has a key")
  end,

  key_is_stable_then_changes_with_the_step = function(t)
    load()
    local k1 = QuestifyAPI.Destination().key
    t.eq(QuestifyAPI.Destination().key, k1, "same place, same key")
    accept179()
    local d = QuestifyAPI.Destination()
    t.ok(d.key ~= k1, "next step: new key")
    t.eq(d.step.action, "complete")
  end,

  returns_a_fresh_copy = function(t)
    load()
    local d = QuestifyAPI.Destination()
    d.x, d.mapID, d.step.action = 0, 0, "x"
    local again = QuestifyAPI.Destination()
    t.eq(again.mapID, 1426)
    t.near(again.x, 0.2993, 0.001)
    t.eq(again.step.action, "accept")
  end,

  nil_when_there_is_nowhere_to_go = function(t)
    local Q = load()
    useGuide(Q, "t_note", { { "note", "Read this" }, { "accept", 179 } })
    t.eq(QuestifyAPI.Destination(), nil, "a note has no place")
    useGuide(Q, "empty", { { "level", 1 } })
    t.eq(QuestifyAPI.Destination(), nil, "no current step")
  end,

  manual_target_is_flagged = function(t)
    local Q = load()
    local before = QuestifyAPI.Destination().key
    Q.Nav:SetManualTarget(1426, 40, 60, "Picked")
    local d = QuestifyAPI.Destination()
    t.eq(d.manual, true)
    t.eq(d.step, nil)
    t.near(d.x, 0.4, 0.0001)
    t.near(d.y, 0.6, 0.0001)
    t.eq(d.title, "Picked")
    t.ok(d.key ~= before, "new key")
  end,

  cave_detours_are_listed_in_0_1 = function(t)
    local Q = load()
    Q.Caves.Plan = function(_, mapId, x, y)
      return { key = "route,exit:a,enter:b", direct = false, stops = {
        { mapId = 1426, x = 10, y = 20, kind = "exit", cave = { key = "a" } },
        { mapId = mapId, x = 30, y = 50, kind = "enter", cave = { key = "b" } },
      } }
    end
    local d = QuestifyAPI.Destination()
    t.eq(#d.via, 2)
    t.eq(d.via[1].kind, "exit")
    t.eq(d.via[1].cave, "a")
    t.near(d.via[1].x, 0.1, 0.0001)
    t.near(d.via[1].y, 0.2, 0.0001)
    t.eq(d.via[2].kind, "enter")
    t.eq(d.via[2].mapID, 1426)
    t.near(d.via[2].x, 0.3, 0.0001)
  end,

  no_via_outside_caves_and_errors_contained = function(t)
    local Q = load()
    t.eq(QuestifyAPI.Destination().via, nil, "no cave in play")
    Q.Caves.Plan = function() error("boom") end
    local d = QuestifyAPI.Destination()
    t.ok(d ~= nil, "still a destination")
    t.eq(d.via, nil)
  end,
}
