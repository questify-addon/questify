-- Cible des prises et des rendus d'un donjon dont le donneur a plusieurs points d'apparition : cas réel de la
-- Cité de Dalaran (Alliance). L'image de l'archimage Modera (269127) a trois points dans QuestieDB : Austrebrune
-- (Contreforts de Hautebrande), la rive du lac Lordamere devant l'entrée (noté sur la carte des Pins-Argentés) et
-- un point des Montagnes d'Alterac à ~185 yd de l'entrée. Géométrie des cartes : UiMapAssignment de Forever.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_mappins.lua")

local ALLIANCE = 4294967373
local ENTRANCE = { 1416, 8.46, 59.21 }
local LAKE = { 1421, 68.62, 45.13 }            -- même lieu que Alterac 7.69, 58.77 : 23 yd de l'entrée
local SOUTHSHORE = { 1424, 48.33, 60.14 }
local ALTERAC = { 1416, 14.3, 59.57 }

local function data()
  return {
    { key = "DALARAN", name = "City of Dalaran", areaId = 16544, minLevel = 28, maxLevel = 33,
      factions = { "Alliance" }, entrance = ENTRANCE, entranceSource = "questiedb",
      quests = { Alliance = {
        { id = 92456, giver = 5502, at = { 1453, 31.5, 62.61 }, ender = 5502, endAt = { 1453, 31.5, 62.61 },
          level = 33, reqLevel = 24, races = ALLIANCE },
        { id = 92457, giver = 269127, at = ALTERAC, ender = 269127, endAt = ALTERAC, level = 33, reqLevel = 24,
          races = ALLIANCE },
        { id = 92458, giver = 269127, at = ALTERAC, ender = 269127, endAt = ALTERAC, level = 33, reqLevel = 24,
          races = ALLIANCE },
      } },
    },
  }
end

local QDB = {
  quests = {
    [92456] = { name = "A Green Sample", startedBy = { { 5502 } }, finishedBy = { { 5502 } }, requiredLevel = 24,
      questLevel = 33, requiredRaces = ALLIANCE, objectives = { nil, nil, { { 251983 } } }, zoneOrSort = 16544 },
    [92457] = { name = "Starving Arcane", startedBy = { { 269127 } }, finishedBy = { { 269127 } }, requiredLevel = 24,
      questLevel = 33, requiredRaces = ALLIANCE, objectives = { { { 247003 } } }, zoneOrSort = 16544 },
    [92458] = { name = "Heart of Disruption", startedBy = { { 269127 } }, finishedBy = { { 269127 } },
      requiredLevel = 24, questLevel = 33, requiredRaces = ALLIANCE, objectives = { nil, nil, { { 251961 } } },
      zoneOrSort = 16544 },
  },
  npcs = {
    [269127] = { name = "Image of Archmage Modera", friendlyToFaction = "AH",
      spawns = { [36] = { { ALTERAC[2], ALTERAC[3] } }, [130] = { { LAKE[2], LAKE[3] } },
                 [267] = { { SOUTHSHORE[2], SOUTHSHORE[3] } } } },
    [5502] = { name = "Shylamiir", friendlyToFaction = "A", spawns = { [1519] = { { 31.5, 62.61 } } } },
    [247003] = { name = "Seeking Remnant", spawns = {} },
  },
  zones = { areaIdToUiMapId = { [36] = 1416, [130] = 1421, [267] = 1424, [1519] = 1453 } },
}

local function setupMaps()
  Mock.maps[1416] = { name = "Alterac Mountains", continent = 0, left = 783.33, top = 1500, width = 2800,
    height = 1866.67, parent = 1415 }
  Mock.maps[1421] = { name = "Silverpine Forest", continent = 0, left = 3450, top = 1666.67, width = 4200,
    height = 2800, parent = 1415 }
  Mock.maps[1424] = { name = "Hillsbrad Foothills", continent = 0, left = 1066.67, top = 400, width = 3200,
    height = 2133.33, parent = 1415 }
  Mock.maps[1453] = { name = "Stormwind City", continent = 0, left = 1722.92, top = -7995.83, width = 1737.5,
    height = 1158.34, parent = 1415 }
end

local function load()
  setupMaps()
  Mock.player.raceId, Mock.player.faction, Mock.player.level = 1, "Alliance", 30
  Mock.player.map, Mock.player.x, Mock.player.y = 1424, 49.3, 52.3       -- Austrebrune, point de vol
  local d = data()
  local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true, qdb = QDB,
    beforeLogin = function(Q) Q.DungeonData = d; Ext.spy(Q) end })
  Mock.advance(0.3)
  return Q
end

local function entryOf(Q, action, id)
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.step.action == action and e.step.questId == id then return e end
  end
end

local function yardsFrom(Q, p, m, x, y)
  return Q.Maps:Distance(p[1], p[2], p[3], m, x, y)
end

local function accept(id, complete)
  Mock.quests.log[id] = { complete = complete == true, objectives = {} }
  Mock.fire("QUEST_ACCEPTED", id)
end

local function noErrors(t)
  for _, e in ipairs(Mock.errors) do t.ok(false, "unexpected error: " .. tostring(e)) end
end

return {
  -- Prise à Austrebrune : le donneur le plus proche du joueur (là où l'utilisateur a pris les quêtes).
  accept_targets_the_nearest_image = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Add("DALARAN"), true)
    local tg = Q.Targets:ForEntry(entryOf(Q, "accept", 92457))
    t.ok(tg and yardsFrom(Q, SOUTHSHORE, tg.mapId, tg.x, tg.y) < 5, "accept at Southshore")
    noErrors(t)
  end,

  -- Rendu dans l'instance (position du joueur inconnue) : l'image devant l'entrée, pas le premier point connu.
  turnin_inside_the_instance_targets_the_image_by_the_entrance = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Add("DALARAN"), true)
    accept(92457, true); accept(92458, true)
    Mock.player.instance = true
    local tg = Q.Targets:ForEntry(entryOf(Q, "turnin", 92457))
    t.ok(tg, "a target")
    local d = tg and yardsFrom(Q, ENTRANCE, tg.mapId, tg.x, tg.y)
    t.ok(d and d < 60, ("turn-in by the entrance, got %s at %s yd"):format(tg and (tg.mapId .. " " .. tg.x .. "," .. tg.y) or "nil", tostring(d)))
    noErrors(t)
  end,

  -- Repères des étapes à venir : le rendu après le donjon vise l'image de l'entrée, même quand le joueur est
  -- encore à Austrebrune (avant : le point le plus proche du joueur, celui d'Austrebrune).
  upcoming_turnin_pin_is_anchored_on_the_route = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Add("DALARAN"), true)
    accept(92456); accept(92457); accept(92458)
    Mock.advance(0.5)
    local seen = false
    for _, p in ipairs(Q.UI.MapPins.active) do
      local e = p.frame and p.frame.pinData and p.frame.pinData.entry
      if p.where == "world" and e and e.step.action == "turnin" and e.step.questId == 92457 then
        seen = true
        local d = yardsFrom(Q, ENTRANCE, p.mapId, p.x, p.y)
        t.ok(d and d < 60, ("turn-in pin by the entrance, got %s yd"):format(tostring(d)))
      end
    end
    t.ok(seen, "turn-in pin shown")
    noErrors(t)
  end,

  -- Étapes insérées : le rendu porte le point du receveur le plus proche de l'entrée.
  inserted_turnin_carries_the_point_by_the_entrance = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Add("DALARAN"), true)
    local e = entryOf(Q, "turnin", 92458)
    t.ok(e and e.step.at, "turn-in has a point")
    local d = e and e.step.at and yardsFrom(Q, ENTRANCE, e.step.at[1], e.step.at[2], e.step.at[3])
    t.ok(d and d < 60, "point by the entrance: " .. tostring(d))
    noErrors(t)
  end,

  -- Ordre des prises depuis Austrebrune : l'image d'Austrebrune d'abord (sur place), puis Hurlevent, puis
  -- l'entrée ; jamais Hurlevent puis un retour à Austrebrune.
  pickups_start_where_the_player_is = function(t)
    local Q = load()
    t.eq(Q.Dungeons:Add("DALARAN"), true)
    local order = {}
    for _, e in ipairs(Q.Progress:Entries()) do
      if e.tag == "dg:DALARAN" and e.step.action == "accept" then order[#order + 1] = e.step.questId end
    end
    t.eq(#order, 3)
    t.eq(order[3], 92456, "Stormwind last before the entrance: " .. table.concat(order, ","))
    noErrors(t)
  end,

  -- Joueur devant l'entrée : les quêtes de l'image se prennent sur la rive du lac, pas à Austrebrune.
  pickups_use_the_nearest_spawn_of_the_giver = function(t)
    local Q = load()
    Mock.player.map, Mock.player.x, Mock.player.y = 1416, 9.0, 59.5
    local info = Q.Dungeons:Plan(Q.Dungeons:List()[1].dungeon)
    local units = Q.Dungeons:OrderUnits(info.units, { 1416, 9.0, 59.5 }, ENTRANCE)
    local first = units[1]
    t.ok(first.quest.id == 92457 or first.quest.id == 92458, "image first")
    t.ok(yardsFrom(Q, ENTRANCE, first.at[1], first.at[2], first.at[3]) < 60, "lake spawn")
    noErrors(t)
  end,
}
