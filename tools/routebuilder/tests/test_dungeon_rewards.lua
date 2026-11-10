-- XP et récompenses des quêtes de donjon et de leurs préquêtes (build_dungeons.lua, table Q.QuestRewardData de
-- Questify/Guides/DungeonData.lua) : la fenêtre Donjons les montre avant d'ajouter une chaîne de préquêtes.
local H = require("helpers")

-- Égalité profonde (t.eq compare les valeurs) : texte stable, clés triées.
local function ser(v)
  if type(v) ~= "table" then return tostring(v) end
  local keys = {}
  for k in pairs(v) do keys[#keys + 1] = k end
  table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
  local parts = {}
  for _, k in ipairs(keys) do parts[#parts + 1] = tostring(k) .. "=" .. ser(v[k]) end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function bd() return assert(loadfile(H.ROOT .. "/build_dungeons.lua"))("--as-module") end

local function quest(id, level, pre, preAll, extra)
  local q = { id = id, name = "Q" .. id, level = level, reqLevel = level - 4, preSingle = pre or {},
              preGroup = preAll or {}, zoneOrSort = 40, objectives = { list = { { kind = "monster" } } } }
  for k, v in pairs(extra or {}) do q[k] = v end
  return q
end

return {
  -- toute la chaîne de préquêtes d'une quête de donjon (préquête au choix et préquêtes obligatoires, sur
  -- plusieurs niveaux), XP de base connue (QuestXP), -50 % pour une quête de donjon, objets de récompense
  rewards_follow_the_whole_prerequisite_chain = function(t)
    local B = bd()
    local D = {
      quests = {
        [166] = quest(166, 22, { 155 }, nil, { zoneOrSort = 1581 }),
        [155] = quest(155, 18, { 142 }),
        [142] = quest(142, 18, { 141 }, { 99 }),
        [141] = quest(141, 18),
        [99] = quest(99, 12),
        [500] = quest(500, 30),                         -- sans lien : absente
      },
      items = { [2000] = { questRewards = { 166 } }, [1999] = { questRewards = { 166, 142 } },
                [3000] = { questRewards = { 500 } } },
      xp = { [166] = { 22, 3300 }, [155] = { 18, 1350 }, [142] = { 18, 1350 }, [141] = { 18, 1050 }, [99] = { 12, 450 } },
      dungeonAreas = { [1581] = "The Deadmines" },
    }
    local r = B.rewards(D, { 166 })
    t.eq(ser(r[166]), ser({ xp = 1650, items = { 1999, 2000 } }), "dungeon quest: half XP, sorted items")
    t.eq(ser(r[155]), ser({ xp = 1350, items = {} }))
    t.eq(ser(r[142]), ser({ xp = 1350, items = { 1999 } }))
    t.eq(ser(r[141]), ser({ xp = 1050, items = {} }))
    t.eq(ser(r[99]), ser({ xp = 450, items = {} }), "required prerequisite (preGroup)")
    t.eq(r[500], nil, "quest outside the chain")
    -- deux appels (Alliance puis Horde) se cumulent dans la même table
    local r2 = B.rewards(D, { 500 }, r)
    t.ok(r2 == r and r[500] ~= nil and r[166] ~= nil)
  end,

  -- XP inconnue : estimée par le simulateur et marquée est = true
  rewards_mark_estimated_xp = function(t)
    local B = bd()
    local D = { quests = { [1] = quest(1, 20), [2] = quest(2, 20), [3] = quest(3, 20) }, items = {},
                xp = { [2] = { 20, 1000 }, [3] = { 20, 1200 } } }
    local r = B.rewards(D, { 1 })
    t.eq(r[1].est, true)
    t.ok(r[1].xp > 0, "estimated from quests of the same level")
  end,

  emitted_table_is_valid_lua = function(t)
    local B = bd()
    local text = B.emitRewards({ [166] = { xp = 1650, items = { 1999, 2000 } }, [65] = { xp = 900, est = true, items = {} } })
    local Q = {}
    local fn = assert(loadstring("local addonName, Q = ...\n" .. text))
    fn("Questify", Q)
    t.eq(ser(Q.QuestRewardData[166]), ser({ xp = 1650, items = { 1999, 2000 } }))
    t.eq(ser(Q.QuestRewardData[65]), ser({ xp = 900, est = true, items = {} }))
    t.ok(text:find("%[65%].-%[166%]") ~= nil, "sorted by quest id")
  end,
}
