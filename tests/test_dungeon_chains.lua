-- Chaînes de préquêtes trop longues pour être enchaînées d'office (Q.Dungeons:ChainInfo, AddChain, RemoveChain) :
-- la fenêtre Donjons dit combien de quêtes il faut faire avant, où, pour quelle XP et quelles récompenses, et le
-- joueur peut les ajouter à la route avec le donjon. Cas réel : The Defias Brotherhood (166) et Red Silk Bandanas
-- (214) des Mortemines demandent l'escorte du Defias Traitor (155), au bout de six quêtes entre la Marche de
-- l'Ouest, Lakeshire et Stormwind.
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local ALLIANCE = 4294967373
local HORDE = 8589934770

local function testData()
  return {
    { key = "DM", name = "The Deadmines", areaId = 1581, minLevel = 17, maxLevel = 26,
      factions = { "Alliance" }, entrance = { 1436, 42.5, 71.7 }, entranceSource = "questiedb",
      quests = {
        Alliance = {
          { id = 166, giver = 234, at = { 1436, 56.33, 47.52 }, ender = 234, endAt = { 1436, 56.33, 47.52 },
            level = 22, reqLevel = 14, races = ALLIANCE, pre = { 155 } },
          { id = 214, giver = 820, at = { 1436, 56.67, 47.35 }, ender = 820, endAt = { 1436, 56.67, 47.35 },
            level = 17, reqLevel = 14, races = ALLIANCE, pre = { 155 } },
          { id = 167, giver = 656, at = { 1453, 70.31, 40.82 }, ender = 656, endAt = { 1453, 70.31, 40.82 },
            level = 20, reqLevel = 15, races = ALLIANCE },
          { id = 2040, giver = 6579, at = { 1453, 62.63, 34.11 }, ender = 6579, endAt = { 1453, 62.63, 34.11 },
            level = 24, reqLevel = 20, races = ALLIANCE },
        },
      },
    },
  }
end

local function rewardData()
  return {
    [65] = { xp = 1350, items = {} }, [132] = { xp = 680, items = {} }, [135] = { xp = 680, items = {} },
    [141] = { xp = 340, items = {} }, [142] = { xp = 1350, items = { 5000 } }, [155] = { xp = 1700, items = {} },
    [166] = { xp = 1300, items = { 2041, 2042, 6087 } }, [214] = { xp = 625, items = { 2074 } },
    [167] = { xp = 900, items = {} }, [2040] = { xp = 1500, items = { 6085 } },
  }
end

local function talk(name, giver, ender, level, pre)
  return { name = name, startedBy = { { giver } }, finishedBy = { { ender } }, requiredLevel = 14, questLevel = level,
    requiredRaces = ALLIANCE, preQuestSingle = pre, zoneOrSort = 40 }
end

local function qdbData()
  local q142 = talk("The Defias Brotherhood", 234, 234, 18, { 141 })
  q142.objectives = { nil, nil, { { 1923 } } }                       -- message du Defias Messenger
  local q155 = talk("The Defias Brotherhood", 467, 234, 18, { 142 })
  q155.triggerEnd = { "Escort the Defias Traitor", { [40] = { { 42.0, 71.0 } } } }
  return {
    quests = {
      [65] = talk("The Defias Brotherhood", 234, 1095, 18, nil),
      [132] = talk("The Defias Brotherhood", 1095, 234, 18, { 65 }),
      [135] = talk("The Defias Brotherhood", 234, 332, 18, { 132 }),
      [141] = talk("The Defias Brotherhood", 332, 234, 18, { 135 }),
      [142] = q142,
      [155] = q155,
      [166] = { name = "The Defias Brotherhood", startedBy = { { 234 } }, finishedBy = { { 234 } }, requiredLevel = 14,
        questLevel = 22, requiredRaces = ALLIANCE, preQuestSingle = { 155 }, zoneOrSort = 1581,
        objectives = { { { 639 } } } },
      [214] = { name = "Red Silk Bandanas", startedBy = { { 820 } }, finishedBy = { { 820 } }, requiredLevel = 14,
        questLevel = 17, requiredRaces = ALLIANCE, preQuestSingle = { 155 }, zoneOrSort = 1581,
        objectives = { nil, nil, { { 1360 } } } },
      [167] = { name = "Oh Brother. . .", startedBy = { { 656 } }, finishedBy = { { 656 } }, requiredLevel = 15,
        questLevel = 20, requiredRaces = ALLIANCE, zoneOrSort = 1581, objectives = { { { 645 } } } },
      [2040] = { name = "Underground Assault", startedBy = { { 6579 } }, finishedBy = { { 6579 } }, requiredLevel = 20,
        questLevel = 24, requiredRaces = ALLIANCE, zoneOrSort = 1581, objectives = { nil, nil, { { 7365 } } } },
      [9001] = { name = "Horde Only", startedBy = { { 234 } }, finishedBy = { { 234 } }, requiredLevel = 10,
        questLevel = 18, requiredRaces = HORDE, zoneOrSort = 40 },
    },
    npcs = {
      [234] = { name = "Gryan Stoutmantle", spawns = { [40] = { { 56.33, 47.52 } } }, friendlyToFaction = "A" },
      [820] = { name = "Scout Riell", spawns = { [40] = { { 56.67, 47.35 } } }, friendlyToFaction = "A" },
      [467] = { name = "The Defias Traitor", spawns = { [40] = { { 55.68, 47.5 } } }, friendlyToFaction = "A" },
      [1095] = { name = "Wiley the Black", spawns = { [44] = { { 21.39, 45.35 } } }, friendlyToFaction = "A" },
      [332] = { name = "Master Mathias Shaw", spawns = { [1519] = { { 78.31, 70.74 } } }, friendlyToFaction = "A" },
      [656] = { name = "Wilder Thistlenettle", spawns = { [1519] = { { 70.31, 40.82 } } }, friendlyToFaction = "A" },
      [6579] = { name = "Shoni the Shilent", spawns = { [1519] = { { 62.63, 34.11 } } }, friendlyToFaction = "A" },
    },
    zones = { areaIdToUiMapId = { [44] = 1433 } },
  }
end

local function load(opts)
  opts = opts or {}
  Mock.maps[1433] = { name = "Redridge Mountains", continent = 0, left = -6000, top = 8500, width = 2170,
    height = 1447, parent = 1415 }
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  opts.qdb = opts.qdb or qdbData()
  local data, rewards = opts.data or testData(), opts.rewards or rewardData()
  opts.data, opts.rewards = nil, nil
  opts.beforeLogin = function(Q) Q.DungeonData = data; Q.QuestRewardData = rewards end
  return Mock.loadAddon(TOC, opts)
end

local function alliance(level)
  Mock.player.raceId, Mock.player.faction, Mock.player.level = 3, "Alliance", level or 17
  Mock.player.map, Mock.player.x, Mock.player.y = 1436, 56, 47
end

local function turnIn(id)
  Mock.quests.log[id] = nil
  Mock.quests.completed[id] = true
  Mock.fire("QUEST_TURNED_IN", id)
end

local function ids(list, field)
  local out = {}
  for _, x in ipairs(list or {}) do out[#out + 1] = field and x[field] or x end
  return out
end

local function tagged(Q, tag)
  local out = {}
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.tag == tag then out[#out + 1] = e.step.action .. " " .. tostring(e.step.questId or "") end
  end
  return out
end

local function indexOf(list, v)
  for i, x in ipairs(list) do if x == v then return i end end
end

local function noErrors(t)
  for _, e in ipairs(Mock.errors) do t.ok(false, "unexpected error: " .. tostring(e)) end
end

return {
  chain_info_lists_the_missing_quests = function(t)
    alliance(17)
    local Q = load()
    local c = Q.Dungeons:ChainInfo("DM", 166)
    t.ok(c, "chain found")
    t.eq(ids(c.quests, "id"), { 65, 132, 135, 141, 142, 155 })
    t.eq(c.unlocks, { 166, 214 }, "the same chain unlocks Red Silk Bandanas")
    t.eq({ c.readyLevel, c.ready }, { 14, true })
    t.eq(c.zones, { 1436, 1433, 1453 }, "Westfall, Redridge, Stormwind")
    t.eq(c.quests[1].giver, 234)
    t.eq(c.quests[1].at, { 1436, 56.33, 47.52 })
    t.eq(c.xp, 1350 + 680 + 680 + 340 + 1350 + 1700 + 1300 + 625, "chain and unlocked quests")
    t.eq(c.items, { 2041, 2042, 6087, 2074 }, "rewards of the unlocked dungeon quests only (not 5000, from 142)")
    t.eq(#c.rewards, 2)
    t.eq({ c.rewards[1].quest, c.rewards[2].quest }, { 166, 214 })
    t.eq(c.rewards[2].items, { 2074 })
    t.eq(c.chosen, false)
    t.eq(c.path, { 1436, 1433, 1436, 1453, 1436 }, "order of passage, returns included")
    t.eq({ c.minLevel, c.maxLevel }, { 14, 18 })
    t.eq(ids(c.quests, "kind"), { "talk", "talk", "talk", "talk", "objectives", "event" })
    t.eq(c.xpChain, 1350 + 680 + 680 + 340 + 1350 + 1700)
    t.eq(c.dungeon, "The Deadmines")
    t.eq(type(c.onRoute), "table")
    noErrors(t)
  end,

  chain_info_skips_turned_in_quests_and_scales_xp = function(t)
    alliance(17)
    for _, id in ipairs({ 65, 132, 135, 141 }) do Mock.quests.completed[id] = true end
    local Q = load()
    local c = Q.Dungeons:ChainInfo("DM", 214)
    t.eq(ids(c.quests, "id"), { 142, 155 })
    t.eq(c.unlocks, { 214, 166 })
    -- niveau 24 : 142 et 155 (niveau 18) à 0,8, 214 (17) à 0,6, 166 (22) entière
    Mock.reset()
    alliance(24)
    for _, id in ipairs({ 65, 132, 135, 141 }) do Mock.quests.completed[id] = true end
    Q = load()
    c = Q.Dungeons:ChainInfo("DM", 166)
    t.eq(c.xp, 1080 + 1360 + 1300 + 375)
    noErrors(t)
  end,

  details_row_names_the_first_giver = function(t)
    alliance(17)
    local Q = load()
    local rows = Q.Dungeons:Details(Q.DungeonData[1])
    local r166
    for _, r in ipairs(rows) do if r.id == 166 then r166 = r end end
    t.eq(r166.reason, "prereq")
    t.eq(r166.chain and r166.chain.count, 6)
    t.eq(r166.chain and r166.chain.giver, 234)
    t.eq(r166.chain and r166.chain.mapId, 1436)
    local line = Q.UI.DungeonPopup.QuestLine(r166)
    t.ok(line:find("6", 1, true) and line:find("Gryan Stoutmantle", 1, true) and line:find("Westfall", 1, true), line)
    noErrors(t)
  end,

  add_chain_puts_the_quests_before_the_dungeon = function(t)
    alliance(17)
    local Q = load()
    t.eq(Q.Dungeons:AddChain("DM", 166), true)
    t.eq(Q.char.dungeons.chains[166], true)
    t.eq(Q.char.dungeons.added.DM, true, "the dungeon comes with its chain")
    local s = tagged(Q, "dg:DM")
    local want = { "accept 65", "turnin 65", "accept 132", "turnin 132", "accept 135", "turnin 135", "accept 141",
      "turnin 141", "accept 142", "complete 142", "turnin 142", "accept 155", "complete 155", "turnin 155",
      "accept 166", "accept 214" }
    local at = indexOf(s, "accept 65")
    t.ok(at, table.concat(s, " | "))
    for i, w in ipairs(want) do t.eq(s[at + i - 1], w, "chain step " .. i .. ": " .. table.concat(s, " | ")) end
    t.ok(indexOf(s, "complete 166") > indexOf(s, "accept 166"), "dungeon objectives after the chain")
    t.ok(indexOf(s, "turnin 214"), "Red Silk Bandanas done with the dungeon")
    t.ok(indexOf(s, "accept 167"), "the other dungeon quests stay")
    t.eq(indexOf(s, "accept 166"), indexOf(s, "turnin 155") + 1, "taken right after the last quest of the chain")
    t.eq(indexOf(s, "accept 214"), indexOf(s, "turnin 155") + 2, "both unlocked quests taken before the dungeon")
    t.ok(indexOf(s, "accept 214") < indexOf(s, "goto "), "before going to the dungeon")
    if Q.AutoQuest and Q.AutoQuest.IsRouteQuest then
      for _, id in ipairs({ 65, 155, 166, 214 }) do t.ok(Q.AutoQuest:IsRouteQuest(id), "AutoQuest takes " .. id) end
    end
    t.eq(Q.Dungeons:ChainInfo("DM", 166).chosen, true)
    noErrors(t)
  end,

  add_chain_rebuilds_an_added_dungeon = function(t)
    alliance(17)
    local Q = load()
    t.eq(Q.Dungeons:Add("DM"), true)
    t.ok(not indexOf(tagged(Q, "dg:DM"), "accept 166"), "locked before the chain")
    t.eq(Q.Dungeons:AddChain("DM", 214), true)
    local s = tagged(Q, "dg:DM")
    t.ok(indexOf(s, "accept 155") and indexOf(s, "accept 166") and indexOf(s, "accept 214"), table.concat(s, " | "))
    local n = 0
    for _, x in ipairs(s) do if x == "accept 167" then n = n + 1 end end
    t.eq(n, 1, "no duplicate step")
    t.eq(Q.Dungeons:RemoveChain("DM", 214), true)
    s = tagged(Q, "dg:DM")
    t.ok(not indexOf(s, "accept 65") and not indexOf(s, "accept 166"), table.concat(s, " | "))
    t.ok(indexOf(s, "accept 167"), "dungeon kept")
    t.eq(Q.char.dungeons.chains[214], nil)
    noErrors(t)
  end,

  -- Onglet Donjons : encadré sous la quête grisée (une seule fois pour deux quêtes de la même suite), survol,
  -- « Voir la suite » ouvre l'annexe collée au journal, « Ajouter la suite » / « Retirer la suite ».
  journal_box_and_docked_annex = function(t)
    alliance(17)
    Ext.install()
    local Q = load()
    local J = Q.UI.Journal
    J:ShowTab("dungeons")
    J.dungeonSel = "DM"
    J:RefreshDungeonTab()
    -- un encadré par suite : 166 et 214 (même suite) ensemble, en tête ; 2040 (niveau seul) garde sa ligne
    local boxes = {}
    for _, b in ipairs(J.dgChains or {}) do if b.box:IsShown() then boxes[b.box.row.id] = b end end
    t.ok(boxes[166] and not boxes[214] and boxes[2040], "one box for the shared chain, one for the level-only quest")
    local w = boxes[166]
    t.eq(#w.box.rows, 2)
    t.eq(w.text:GetText(), string.format(Q.L.DUNGEON_CHAIN_BOX_PL, "|cffffffffThe Defias Brotherhood, Red Silk Bandanas|r",
      6, "Westfall, Redridge Mountains, Stormwind City"))
    t.eq(boxes[2040].text:GetText(), string.format(Q.L.DUNGEON_CHAIN_BOX_LEVEL, 20))
    local shown = {}
    for _, fs in ipairs(J.dgLines) do if fs:IsShown() then shown[#shown + 1] = fs:GetText() end end
    t.eq(#shown, 2, "lines: Underground Assault and Oh Brother only")
    t.ok(not table.concat(shown, "|"):find("Red Silk Bandanas", 1, true), "shared-chain quests named in the box only")
    for _, b in pairs(boxes) do
      t.eq(b.add:GetText(), Q.L.DUNGEON_CHAIN_ADD)
      t.eq(b.info:GetText(), Q.L.DUNGEON_CHAIN_INFO)
      t.ok(b.add:IsShown() and b.info:IsShown(), "two buttons")
      -- dans la colonne de détail (226 px), boutons compris
      local x = select(4, b.box:GetPoint(1))
      t.ok(x + b.box:GetWidth() <= 226, "box inside the column")
      t.ok(b.info:GetWidth() <= b.box:GetWidth() - 14 and b.add:GetWidth() <= b.box:GetWidth() - 14, "buttons fit")
    end
    -- survol de l'encadré : nombre de quêtes, zones, XP, récompenses
    w.box:GetScript("OnEnter")(w.box)
    local all = table.concat(Mock.tooltip and Mock.tooltip.lines or {}, "\n")
    t.ok(all:find(string.format(Q.L.DUNGEON_CHAIN_COUNT, 6), 1, true), all)
    t.ok(all:find("Redridge Mountains", 1, true), all)
    t.ok(all:find("8 025", 1, true), all)
    -- « Voir la suite » : annexe collée à droite du journal, même hauteur
    Mock.click(w.info, "LeftButton")
    local P = Q.UI.DungeonChainPopup
    t.ok(P.frame and P.frame:IsShown(), "annex shown")
    local point, rel, relPoint = P.frame:GetPoint(1)
    t.eq({ point, rel == J.frame, relPoint }, { "TOPLEFT", true, "TOPRIGHT" }, "docked to the journal")
    t.eq(P.title:GetText(), "The Defias Brotherhood")
    t.eq(P.meta:GetText(), "6 quests · levels 14 to 18 · before The Deadmines")
    -- trajet : Westfall » Redridge » Westfall » Stormwind » Westfall
    local path = {}
    for _, p in ipairs(P.pills) do if p:IsShown() then path[#path + 1] = p.text:GetText() end end
    t.eq(path, { "Westfall", "Redridge Mountains", "Westfall", "Stormwind City", "Westfall" })
    -- pastilles en gélule : 16 px de haut, disques masqués aux extrémités, fond rentré de 1 px, largeur texte + 16
    local p1 = P.pills[1]
    t.eq(p1:GetHeight(), 16)
    t.eq({ p1.edge.left:GetWidth(), p1.edge.left:GetHeight() }, { 16, 16 })
    t.eq({ p1.fill.left:GetWidth(), p1.fill.left:GetHeight() }, { 14, 14 })
    for _, part in ipairs({ p1.edge.left, p1.edge.right, p1.fill.left, p1.fill.right }) do
      t.ok(part.mask and part.mask:GetPoint(1), "round end masked")
    end
    t.eq({ p1.edge.left:GetPoint(1) }, { "LEFT", p1, "LEFT", 0, 0 })
    t.eq({ p1.fill.right:GetPoint(1) }, { "RIGHT", p1, "RIGHT", -1, 0 })
    t.eq(select(4, p1.fill.mid:GetPoint(1)), 8, "middle from the centre of the left end")
    t.eq(p1:GetWidth(), p1.text:GetStringWidth() + 16)
    for _, p in ipairs(P.pills) do
      if p:IsShown() then
        local r = p.text:GetTextColor()
        t.eq(r, p.onRoute and 0.6 or 0.910, "text colour follows the route")
      end
    end
    t.ok(P.lines[6]:IsShown() and not (P.lines[7] and P.lines[7]:IsShown()), "six steps")
    t.ok(P.lines[1]:GetText():find("Gryan Stoutmantle", 1, true) and P.lines[1]:GetText():find("Wiley the Black", 1, true),
      P.lines[1]:GetText())
    t.ok(P.lines[6]:GetText():find("Ability_Rogue_Sprint", 1, true), "escort step icon")
    t.ok(P.xps[1]:GetText():find("1 350", 1, true), P.xps[1]:GetText())
    t.ok(P.unlocks:GetText():find("Red Silk Bandanas", 1, true), P.unlocks:GetText())
    t.eq(P.xpChain:GetText(), string.format(Q.L.DUNGEON_CHAIN_XP_CHAIN, "6 100"))
    t.eq(P.xpAll:GetText(), string.format(Q.L.DUNGEON_CHAIN_XP_ALL, "8 025"))
    t.ok(P.items[4]:IsShown() and not P.items[5]:IsShown(), "four reward items")
    t.eq(P.rewardHeads[1]:GetText(), "The Defias Brotherhood:")
    t.eq(P.rewardHeads[2]:GetText(), "Red Silk Bandanas:")
    P.items[1]:GetScript("OnEnter")(P.items[1])
    t.eq(Mock.tooltip.items[#Mock.tooltip.items], 2041, "item stats on hover")
    t.eq(P.toggleButton:GetText(), Q.L.DUNGEON_CHAIN_ADD_ROUTE)
    -- ajout depuis l'annexe, puis retrait depuis le journal
    Mock.click(P.toggleButton, "LeftButton")
    t.eq(Q.char.dungeons.chains[166], true)
    t.eq(P.toggleButton:GetText(), Q.L.DUNGEON_CHAIN_REMOVE_ROUTE)
    boxes = {}
    for _, b in ipairs(J.dgChains or {}) do if b.box:IsShown() then boxes[b.box.row.id] = b end end
    t.eq(boxes[166].add:GetText(), Q.L.DUNGEON_CHAIN_REMOVE, "journal refreshed")
    t.eq(boxes[166].text:GetText(), string.format(Q.L.DUNGEON_CHAIN_BOX_ADDED,
      "|cffffffffThe Defias Brotherhood, Red Silk Bandanas|r", 6, "Westfall, Redridge Mountains, Stormwind City"))
    t.ok(not boxes[214], "still one box once added")
    Mock.click(boxes[166].add, "LeftButton")
    t.eq(Q.char.dungeons.chains[166], nil)
    -- l'annexe se ferme avec le journal
    boxes = {}
    for _, b in ipairs(J.dgChains or {}) do if b.box:IsShown() then boxes[b.box.row.id] = b end end
    Mock.click(boxes[166].info, "LeftButton")
    t.ok(P.frame:IsShown())
    J.frame:Hide()
    t.ok(not P.frame:IsShown(), "closed with the journal")
    noErrors(t)
  end,

  no_chain_when_a_prerequisite_is_out_of_reach = function(t)
    alliance(17)
    local q = qdbData()
    q.quests[65].preQuestSingle = { 9001 }      -- préquête Horde : chaîne impossible pour l'Alliance
    local Q = load({ qdb = q })
    t.eq(Q.Dungeons:ChainInfo("DM", 166), nil)
    t.eq(Q.Dungeons:AddChain("DM", 166), false)
    for _, r in ipairs(Q.Dungeons:Details(Q.DungeonData[1])) do
      if r.id == 166 then
        t.eq(r.reason, "prereq")
        t.eq(r.chain and r.chain.reason, "race")
        t.eq(r.chain and r.chain.reasonQuest, 9001)
      end
    end
    -- encadré : la raison en une ligne, sans bouton
    local J = Q.UI.Journal
    J:ShowTab("dungeons")
    J.dungeonSel = "DM"
    J:RefreshDungeonTab()
    local box
    for _, b in ipairs(J.dgChains or {}) do if b.box:IsShown() and b.box.row.id == 166 then box = b end end
    t.ok(box, "box with the reason")
    t.eq(box.text:GetText(), string.format(Q.L.DUNGEON_CHAIN_WHY_RACE, "Horde Only"))
    t.ok(not box.add:IsShown() and not box.info:IsShown(), "no button")
    noErrors(t)
  end,

  -- Détail d'un donjon : quêtes manquantes, puis celles du journal, puis celles rendues (cochées, hors des
  -- compteurs et des étoiles).
  details_grouped_missing_log_done = function(t)
    alliance(17)
    Mock.quests.completed[167] = true
    Mock.quests.log[214] = { complete = false, objectives = {} }
    local Q = load()
    local ids2 = {}
    local rows = Q.Dungeons:Details(Q.DungeonData[1])
    for _, r in ipairs(rows) do ids2[#ids2 + 1] = r.id .. ":" .. tostring(r.reason) end
    t.eq(ids2, { "166:prereq", "2040:level", "214:log", "167:done" })
    t.eq(rows[4].done, true)
    local J = Q.UI.Journal
    J:ShowTab("dungeons")
    J.dungeonSel = "DM"
    J:RefreshDungeonTab()
    local item
    for _, it in ipairs(J.DungeonItems()) do if it.dungeon.key == "DM" then item = it end end
    t.eq({ item.todo, item.now }, { 3, 0 }, "turned-in quest out of the counters")
    local last
    for _, fs in ipairs(J.dgLines) do if fs:IsShown() then last = fs:GetText() end end
    t.ok(last:find("ReadyCheck-Ready", 1, true) and last:find("(" .. Q.L.DUNGEON_DONE_TAG .. ")", 1, true), last)
    noErrors(t)
  end,

  -- Suite ajoutée depuis une quête, retirée depuis l'autre : une seule suite, état partagé.
  shared_chain_is_added_once = function(t)
    alliance(17)
    local Q = load()
    t.eq(Q.Dungeons:AddChain("DM", 166), true)
    t.eq(Q.Dungeons:ChainInfo("DM", 214).chosen, true, "214 sees the chain added from 166")
    t.eq(Q.Dungeons:AddChain("DM", 214), false, "already added")
    t.eq(Q.Dungeons:RemoveChain("DM", 214), true)
    t.eq(Q.char.dungeons.chains[166], nil)
    t.ok(not indexOf(tagged(Q, "dg:DM"), "accept 65"), "chain steps gone")
    noErrors(t)
  end,

  -- Quête bloquée seulement par le niveau : ajout possible, gardée de côté (la route n'attend pas), puis ajoutée
  -- au passage du niveau voulu.
  level_locked_quest_joins_at_its_level = function(t)
    alliance(17)
    local Q = load()
    local c = Q.Dungeons:ChainInfo("DM", 2040)
    t.ok(c, "level-locked quest offered")
    t.eq(#c.quests, 0)
    t.eq({ c.readyLevel, c.ready }, { 20, false })
    t.eq(Q.Dungeons:AddChain("DM", 2040), true)
    t.eq(Q.char.dungeons.chains[2040], true)
    t.ok(not indexOf(tagged(Q, "dg:DM"), "accept 2040"), "not on the route before level 20")
    local P = Q.UI.DungeonChainPopup
    t.ok(P:Show("DM", 2040), "annex for a level-only quest")
    t.eq(P.levelOnly:GetText(), string.format(Q.L.DUNGEON_CHAIN_LEVEL_ONLY, 20))
    t.eq(P.foot:GetText(), string.format(Q.L.DUNGEON_CHAIN_FOOT_LATER, 20))
    t.eq(P.toggleButton:GetText(), Q.L.DUNGEON_CHAIN_REMOVE_ROUTE)
    Mock.player.level = 20
    Mock.fire("PLAYER_LEVEL_UP", 20)
    t.ok(indexOf(tagged(Q, "dg:DM"), "accept 2040"), "joins the route at level 20")
    t.eq(Q.char.dungeons.added.DM, true)
    noErrors(t)
  end,
}
