-- Tests de la commande cachée /qf demo (UI/Demo.lua) : scènes d'exemple pour les captures en jeu.
-- Les vraies fenêtres s'ouvrent avec des données d'exemple ; rien n'est écrit, aucun bouton n'agit.
local TOC = "Questify/Questify.toc"
local Ext = dofile(Mock.root .. "/tests/mock_ext_comfort.lua")

local function load(opts)
  Ext.install()
  opts = opts or {}
  if opts.skipGuides == nil then opts.skipGuides = false end   -- vrais guides et vraies données
  RaidWarningFrame = Mock.newObject("Frame", "RaidWarningFrame")
  RaidWarningUtil = {
    AddMessage = function(text, color) Mock.record("RaidWarningUtil.AddMessage", text, color) end,
  }
  C_Item.EquipItemByName = function(link, slot) Mock.record("C_Item.EquipItemByName", link, slot) end
  return Mock.loadAddon(TOC, opts)
end

local function qf(msg) SlashCmdList.QUESTIFY(msg) end

local function plain(s) return (tostring(s or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")) end

-- Objets d'exemple connus du client (le premier de chaque liste suffit).
local function stubItems(Q)
  local D = Q.UI.Demo
  local function def(id, name, equipLoc)
    Mock.items[id] = { id = id, name = name, link = "|cff1eff00|Hitem:" .. id .. "::::::::|h[" .. name .. "]|h|r",
      equipLoc = equipLoc, classID = 2, subclassID = 4, itemType = "Armor", minLevel = 1 }
  end
  def(D.ITEMS.upgrade[1], "Exemple d'objet", "INVTYPE_SHIELD")
  def(D.ITEMS.main[1], "Exemple de masse", "INVTYPE_WEAPONMAINHAND")
  def(D.ITEMS.off[1], "Exemple de bouclier", "INVTYPE_SHIELD")
end

local function noErrors(t)
  t.eq(Mock.errors, {}, "no error")
end

local function shown(frame) return frame ~= nil and frame:IsShown() end

local function warnTexts(Q)
  local out = {}
  for _, line in ipairs(Q.UI.Tracker.warnLines or {}) do
    if line:IsShown() then out[#out + 1] = plain(line:GetText()) end
  end
  return out
end

local function centerTexts()
  local out = {}
  for _, c in ipairs(Mock.callsTo("RaidWarningUtil.AddMessage")) do out[#out + 1] = c.args[1] end
  return out
end

return {
  -- /qf demo seul : la liste des scènes dans la discussion ; la commande reste absente de l'aide.
  demo_lists_scenes_and_is_hidden = function(t)
    local Q = load()
    qf("demo")
    for _, name in ipairs(Q.UI.Demo.SCENES) do
      t.ok(Mock.printed("/qf demo " .. name), "listed: " .. name)
    end
    t.ok(Mock.printed("/qf demo all"), "all listed")
    t.ok(Mock.printed("/qf demo off"), "off listed")
    qf("help")
    t.ok(not Q.L.UI_SLASH_HELP:lower():find("demo", 1, true), "absent from the help")
    for _, key in ipairs({ "UI_SLASH_HELP", "UI_MINIMAP_TIP", "UI_MINIMAP_MENU" }) do
      t.ok(not tostring(Q.L[key]):lower():find("demo", 1, true), key)
    end
    t.eq(#Mock.errors, 0)
  end,

  demo_unknown_scene_lists_them = function(t)
    local Q = load()
    qf("demo nothing")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_UNKNOWN, "nothing")))
    noErrors(t)
  end,

  -- Chaque scène s'ouvre sans erreur et montre quelque chose.
  classquest_scene_opens_the_real_window = function(t)
    local Q = load()
    qf("demo classquest")
    local P = Q.UI.ClassQuestPopup
    t.ok(shown(P.frame), "window shown")
    t.ok(P.chain and P.chain.demo, "demo chain")
    t.eq(P.title:GetText(), P.ChainTitle(P.chain))
    t.ok(P.chain.key:find("^WARRIOR_"), "chain of the player's class: " .. tostring(P.chain.key))
    t.ok(#Q.UI.Tracker.ClassAlerts() == 1, "the tracker shows the alert too")
    t.ok(Q.UI.TrackerButtons.buttons.class.glow:IsShown(), "class button glows")
    qf("demo off")
    t.ok(not Q.UI.TrackerButtons.buttons.class.glow:IsShown(), "glow gone after off")
    noErrors(t)
  end,

  classlate_scene_shows_the_overdue_alert = function(t)
    local Q = load()
    Mock.player.level = 20
    Mock.fire("PLAYER_LEVEL_UP", 20)
    qf("demo classlate")
    local Tk = Q.UI.Tracker
    t.ok(shown(Tk.alert), "alert shown")
    t.eq(Tk.alertText:GetText(), string.format(Q.L.UI_CLASS_ALERT_LATE_ONE, Tk.ClassAlerts()[1] and
      Q.UI.ClassQuestPopup.ChainTitle(Tk.ClassAlerts()[1])))
    t.ok(not shown(Q.UI.ClassQuestPopup.frame), "window not opened by itself")
    -- un clic sur l'alerte ouvre la fenêtre, toujours en démonstration
    Tk:OpenAlert()
    t.ok(shown(Q.UI.ClassQuestPopup.frame))
    t.ok(Q.UI.ClassQuestPopup.chain.demo)
    noErrors(t)
  end,

  -- Sans chapitre en cours (assistant pas terminé), le suivi ne dessine pas l'alerte : la scène le dit.
  classlate_without_a_chapter_says_why = function(t)
    local Q = load()
    Q.Progress.Guide = function() return nil end
    qf("demo classlate")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_MISSING, "classlate", Q.L.UI_DEMO_WHY_TRACKER)), "reason printed")
    t.ok(not shown(Q.UI.Tracker.alert), "no alert drawn")
    noErrors(t)
  end,

  dungeon_scene_opens_the_faction_dungeon = function(t)
    local Q = load()
    qf("demo dungeon")
    local P = Q.UI.DungeonPopup
    t.ok(shown(P.frame), "window shown")
    t.eq(P.dungeon.key, "DM", "Alliance: The Deadmines")
    t.ok(P.dungeon.demo)
    t.eq(P.title:GetText(), P.DungeonName(P.dungeon))
    t.ok(#Q.UI.Tracker.DungeonAlerts() == 1, "alert in the tracker")
    t.ok(Q.UI.TrackerButtons.buttons.dungeons.glow:IsShown(), "dungeons button glows")
    Q.Player.faction = "Horde"
    qf("demo dungeon")
    t.eq(P.dungeon.key, "RFC", "Horde: Ragefire Chasm")
    noErrors(t)
  end,

  upgrade_and_pair_scenes = function(t)
    local Q = load()
    stubItems(Q)
    local P = Q.UI.UpgradePopup
    qf("demo upgrade")
    t.ok(shown(P.frame), "announcement shown")
    t.ok(P.current.demo)
    t.ok(P.name:GetText():find("Exemple d'objet", 1, true), "item named")
    Mock.advance(10)
    t.ok(shown(P.frame), "the demo box stays without a countdown")
    -- survol : le comparatif s'ouvre à côté
    P.frame.IsMouseOver = function() return true end
    Mock.advance(0.1)
    t.ok(Q.UI.UpgradeCompare:IsShown(), "before/after comparison on hover")
    P.frame.IsMouseOver = nil
    qf("demo pair")
    t.ok(shown(P.frame))
    t.ok(P.current.pair and P.current.demo, "pair announcement")
    t.ok(P.name:GetText():find(Mock.items[Q.UI.Demo.ITEMS.main[1]].name, 1, true)
      and P.name:GetText():find(Mock.items[Q.UI.Demo.ITEMS.off[1]].name, 1, true), "both items named")
    noErrors(t)
  end,

  -- Objet pas encore connu du client : on attend son chargement, puis on affiche ; jamais connu : un message.
  upgrade_scene_waits_for_the_item = function(t)
    local Q = load()
    local P = Q.UI.UpgradePopup
    qf("demo upgrade")
    t.ok(not shown(P.frame), "nothing yet")
    stubItems(Q)
    Mock.advance(1)
    t.ok(shown(P.frame), "shown once loaded")
    qf("demo off")
    Mock.reset()
    Q = load()
    P = Q.UI.UpgradePopup
    qf("demo upgrade")
    Mock.advance(30)
    t.ok(not shown(P.frame), "never loaded: nothing shown")
    t.ok(Mock.printed(Q.L.UI_DEMO_WHY_ITEM), "says why")
    noErrors(t)
  end,

  route_scene_shows_the_loch_modan_choice = function(t)
    local Q = load()
    qf("demo route")
    local P = Q.UI.RouteChoicePopup
    t.ok(P:IsShown(), "window shown")
    t.eq(#P.cards, 2, "two cards")
    t.eq(P.fromId, "A_DwarfGnome_03")
    local rec = 0
    for _, c in ipairs(P.cards) do if c.recommended then rec = rec + 1 end end
    t.eq(rec, 1, "one recommended card, ranked as in real life")
    t.eq(P.subtitle:GetText(), string.format(Q.L.UI_ROUTECHOICE_SUBTITLE, Q.Guides:DisplayTitle("A_DwarfGnome_03")))
    noErrors(t)
  end,

  auction_scene_fills_the_shopping_list_and_off_restores = function(t)
    local Q = load()
    local D = Q.UI.Demo
    for _, e in ipairs(D.AUCTION) do
      Mock.items[e.item] = { id = e.item, name = "Item " .. e.item,
        link = "|cffffffff|Hitem:" .. e.item .. "::::::::|h[Item " .. e.item .. "]|h|r", classID = 12 }
    end
    local before = #Q.AuctionItems:Rows()
    qf("demo auction")
    Mock.advance(1)
    local P = Q.UI.AuctionPanel
    t.ok(P.list and P.list:IsShown(), "list shown")
    local rows = Q.AuctionItems:Rows()
    t.eq(#rows, #D.AUCTION, "one row per example item")
    t.eq(rows[1].chapter, "current")
    t.eq(rows[#rows].chapter, "next")
    for _, r in ipairs(rows) do t.ok(r.need > 0, r.item .. ": something to buy") end
    qf("demo off")
    t.ok(not P.list:IsShown(), "list closed")
    t.eq(#Q.AuctionItems:Rows(), before, "real rows back")
    noErrors(t)
  end,

  route_scene_ranks_at_the_chapter_end_level = function(t)
    local Q = load()
    Q.Player.level = 34
    qf("demo route")
    local P = Q.UI.RouteChoicePopup
    t.ok(P:IsShown(), "window shown")
    for _, c in ipairs(P.cards) do t.eq(c.over, 0, c.id .. ": not too low for the chapter's end level") end
    noErrors(t)
  end,

  supplies_scene_shows_line_message_and_chat = function(t)
    local Q = load()
    qf("demo supplies")
    local lines = {}
    for _, l in ipairs(Q.Supplies:Lines()) do lines[#lines + 1] = plain(l) end
    local slots = string.format(Q.L.COMFORT_SLOTS_FREE, 4, 64)
    t.eq(lines, { string.format(Q.L.COMFORT_BAGS_FULL, slots), Q.L.COMFORT_NO_DRINK })
    local msg = string.format(Q.L.COMFORT_SUPPLY_ALERT, slots .. Q.L.COMFORT_LIST_SEP .. Q.L.COMFORT_PART_DRINK)
    t.eq(centerTexts(), { msg })
    t.ok(Mock.printed(msg), "chat line")
    t.eq(warnTexts(Q), lines, "tracker lines")
    noErrors(t)
  end,

  cave_scene_places_the_titled_waypoint = function(t)
    local Q = load()
    qf("demo cave")
    local st = Q.Nav:Status()
    local cave
    for _, c in ipairs(Q.CaveData) do if c.key == "dunmorogh_grizzled_den" then cave = c end end
    t.ok(cave, "real cave data")
    t.eq(st.target.mapId, cave.mapId)
    t.eq(st.target.x, cave.entrance[1])
    t.eq(st.target.y, cave.entrance[2])
    t.eq(st.target.title, Q.L.NAV_CAVE_ENTER .. " — The Grizzled Den")
    noErrors(t)
  end,

  profession_scene_shows_the_step_text_without_inserting_it = function(t)
    local Q = load()
    local before = Mock.deepcopy(Q.char.inserted)
    qf("demo profession")
    local title = Q.Format:StepTitle({ step = { action = "trainprof", prof = "HERBALISM", rank = 2 } })
    t.ok(Mock.printed(title), "title in the chat")
    local found = false
    for _, text in ipairs(warnTexts(Q)) do
      if text:find(Q.Professions:Name("HERBALISM"), 1, true) and text:find(Q.L.PROF_RANK_2, 1, true) then found = true end
    end
    t.ok(found, "step text in the tracker")
    t.eq(Q.char.inserted, before, "no step inserted into the route")
    noErrors(t)
  end,

  -- Aucune écriture dans la progression ni dans les réglages, scène après scène.
  no_scene_writes_progress = function(t)
    local Q = load()
    stubItems(Q)
    -- tables créées à la demande par la lecture des modules : on les fait exister avant la photo
    Q.ClassQuests:Alerts()
    Q.Dungeons:Alerts()
    Q.UI.Tracker:Refresh()
    Mock.advance(10)   -- minuteries du démarrage (assistant, relevés) avant la photo
    local char, db = Mock.deepcopy(Q.char), Mock.deepcopy(QuestifyDB)
    for _, name in ipairs(Q.UI.Demo.SCENES) do
      qf("demo " .. name)
      Mock.advance(1)
      t.eq(Q.char, char, "Q.char unchanged after " .. name)
      t.eq(QuestifyDB, db, "QuestifyDB unchanged after " .. name)
    end
    qf("demo off")
    t.eq(Q.char, char, "Q.char unchanged after off")
    t.eq(QuestifyDB, db, "QuestifyDB unchanged after off")
    noErrors(t)
  end,

  -- Les boutons des fenêtres ferment sans agir.
  buttons_are_inert = function(t)
    local Q = load()
    stubItems(Q)
    local char = Mock.deepcopy(Q.char)
    local function inert(label)
      t.eq(Q.char, char, label .. ": nothing written")
    end
    local cq, dg = Q.UI.ClassQuestPopup, Q.UI.DungeonPopup
    qf("demo classquest")
    Mock.click(cq.addButton)
    t.ok(not shown(cq.frame), "class window closed")
    inert("class add")
    qf("demo classquest")
    Mock.click(cq.ignoreButton)
    t.ok(not shown(cq.frame))
    inert("class ignore")
    t.eq(#Q.UI.Tracker.ClassAlerts(), 1, "the alert is still there")

    qf("demo dungeon")
    Mock.click(dg.addButton)
    t.ok(not shown(dg.frame), "dungeon window closed")
    inert("dungeon add")
    qf("demo dungeon")
    Mock.click(dg.ignoreButton)
    t.ok(not shown(dg.frame))
    inert("dungeon ignore")

    local up = Q.UI.UpgradePopup
    qf("demo upgrade")
    Mock.click(up.equipButton)
    t.eq(Mock.countCalls("C_Item.EquipItemByName"), 0, "nothing equipped")
    t.ok(not shown(up.frame), "announcement closed")
    qf("demo pair")
    Mock.click(up.equipButton)
    Mock.advance(2)
    t.eq(Mock.countCalls("C_Item.EquipItemByName"), 0, "pair: nothing equipped")

    local rp = Q.UI.RouteChoicePopup
    for _, which in ipairs({ "card", "keep", "later" }) do
      qf("demo route")
      if which == "card" then Mock.click(rp.cardFrames[1].frame)
      elseif which == "keep" then Mock.click(rp.keepButton)
      else Mock.click(rp.laterButton) end
      t.ok(not rp:IsShown(), "route window closed by " .. which)
      inert("route " .. which)
      t.eq(Q.Progress:PendingChoice(), nil)
    end
    t.eq(#Mock.callsTo("RaidWarningUtil.AddMessage"), 0)
    noErrors(t)
  end,

  -- En combat : un message, rien d'ouvert.
  refused_in_combat = function(t)
    local Q = load()
    local nav = Q.Nav:Status().target
    Mock.player.combat = true
    for _, name in ipairs(Q.UI.Demo.SCENES) do
      qf("demo " .. name)
    end
    t.eq(Mock.countPrinted(Q.L.UI_DEMO_COMBAT), #Q.UI.Demo.SCENES, "message each time")
    t.ok(not shown(Q.UI.ClassQuestPopup.frame))
    t.ok(not shown(Q.UI.DungeonPopup.frame))
    t.ok(not shown(Q.UI.UpgradePopup.frame))
    t.ok(not Q.UI.RouteChoicePopup:IsShown())
    t.eq(Q.Supplies:Lines(), {})
    t.eq(Q.Nav:Status().target, nav, "waypoint untouched")
    noErrors(t)
  end,

  -- Début de combat pendant une scène : tout se range.
  combat_closes_the_demo = function(t)
    local Q = load()
    qf("demo route")
    t.ok(Q.UI.RouteChoicePopup:IsShown())
    Mock.player.combat = true
    Mock.fire("PLAYER_REGEN_DISABLED")
    t.ok(not Q.UI.RouteChoicePopup:IsShown())
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(not Q.UI.RouteChoicePopup:IsShown(), "not reopened after the fight")
    noErrors(t)
  end,

  -- /qf demo off : fenêtres fermées, lignes, alertes et repère comme avant.
  off_restores_the_previous_state = function(t)
    local Q = load()
    stubItems(Q)
    Q.Nav:SetTarget(1426, 30, 70, "Avant")
    local nav = Q.Nav:Status().target
    local alertsBefore = #Q.UI.Tracker.ClassAlerts()
    for _, name in ipairs(Q.UI.Demo.SCENES) do
      qf("demo " .. name)
      qf("demo off")
      t.ok(not shown(Q.UI.ClassQuestPopup.frame), name .. ": class window")
      t.ok(not shown(Q.UI.DungeonPopup.frame), name .. ": dungeon window")
      t.ok(not shown(Q.UI.UpgradePopup.frame), name .. ": upgrade window")
      t.ok(not Q.UI.RouteChoicePopup:IsShown(), name .. ": route window")
      t.eq(Q.Supplies:Lines(), {}, name .. ": lines")
      t.eq(#Q.UI.Tracker.ClassAlerts(), alertsBefore, name .. ": class alerts")
      t.eq(#Q.UI.Tracker.DungeonAlerts(), 0, name .. ": dungeon alerts")
      t.eq(Q.Nav:Status().target, nav, name .. ": waypoint")
      t.eq(warnTexts(Q), {}, name .. ": tracker warnings")
    end
    t.ok(Mock.printed(Q.L.UI_DEMO_OFF))
    -- sans repère avant : rien après
    Q.Nav:Clear()
    qf("demo cave")
    qf("demo off")
    t.eq(Q.Nav:Status().target, nil, "no waypoint left")
    noErrors(t)
  end,

  -- Les méthodes remplacées sont rendues telles quelles.
  off_gives_the_original_functions_back = function(t)
    local Q = load()
    local fns = { Q.Supplies.Lines, Q.ClassQuests.Alerts, Q.ClassQuests.IsLate, Q.Dungeons.Alerts }
    for _, name in ipairs({ "supplies", "classlate", "dungeon", "profession" }) do
      qf("demo " .. name)
      qf("demo off")
    end
    t.ok(Q.Supplies.Lines == fns[1] and Q.ClassQuests.Alerts == fns[2] and Q.ClassQuests.IsLate == fns[3]
      and Q.Dungeons.Alerts == fns[4], "originals restored")
  end,

  -- Couverture : le suivi passe sur une étape « tuer » avec ses monstres et la ligne XP/h ; « off »
  -- rend l'étape réelle.
  tracker_scene_shows_a_kill_step = function(t)
    local Q = load()
    local before = Q.Progress:Current()
    local original = Q.Progress.Current
    qf("demo tracker")
    local cur = Q.Progress:Current()
    t.ok(cur and cur.step.action == "complete", "kill step")
    t.ok(#Q.Targets:MobsForEntry(cur) > 0, "with monsters")
    t.ok(Q.UI.Tracker.xpLine:IsShown(), "XP per hour line")
    t.ok(plain(Q.UI.Tracker.xpLine:GetText()):find("11.8k", 1, true), "example rate without data")
    qf("demo off")
    t.ok(Q.Progress.Current == original, "original restored")
    t.ok(Q.Progress:Current() == before, "real step back")
    noErrors(t)
  end,

  questitem_scene_shows_the_button = function(t)
    local Q = load()
    local B = Q.UI.QuestItemButton
    qf("demo questitem")
    t.eq(B.itemId, Q.UI.Demo.ITEMS.quest)
    t.ok(B.button:IsShown(), "button next to the tracker")
    qf("demo off")
    t.ok(not B.button:IsShown(), "hidden after off")
    noErrors(t)
  end,

  -- Thèmes : chaque appel montre le suivant, le réglage enregistré ne change pas.
  theme_scene_cycles_themes = function(t)
    local Q = load()
    local list = Q.Themes:List()
    local saved = Q.Settings:Get("tracker.theme")
    qf("demo theme")
    t.eq(Q.UI.Tracker.themeKey, list[1].key)
    qf("demo theme")
    t.eq(Q.UI.Tracker.themeKey, list[2].key, "next theme")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_THEME, list[2].label, 2, #list)))
    qf("demo off")
    t.eq(Q.Settings:Get("tracker.theme"), saved, "setting untouched")
    t.eq(Q.UI.Tracker.themeKey, Q.Themes:CurrentKey(), "tracker back to its theme")
    noErrors(t)
  end,

  options_scene_opens_automation = function(t)
    local Q = load()
    qf("demo options")
    t.ok(QuestifyOptions and QuestifyOptions:IsShown(), "options shown")
    t.eq(Q.UI.Options.section, "automation")
    qf("demo off")
    t.ok(not QuestifyOptions:IsShown(), "closed after off")
    noErrors(t)
  end,

  -- all / next : une scène à la fois.
  all_and_next_walk_through_the_scenes = function(t)
    local Q = load()
    stubItems(Q)
    local D = Q.UI.Demo
    t.eq(D.SCENES[1], "tracker")
    t.eq(D.SCENES[2], "zone")
    t.eq(D.SCENES[3], "classquest")
    qf("demo all")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_STEP, D.SCENES[1], 1, #D.SCENES)), "first scene named")
    qf("demo next")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_STEP, D.SCENES[2], 2, #D.SCENES)))
    qf("demo next")
    t.ok(shown(Q.UI.ClassQuestPopup.frame), "class quest scene shown")
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_STEP, D.SCENES[3], 3, #D.SCENES)))
    qf("demo next")
    t.ok(not shown(Q.UI.ClassQuestPopup.frame), "previous scene closed")
    for _ = 5, #D.SCENES do qf("demo next") end
    t.ok(Mock.printed(string.format(Q.L.UI_DEMO_STEP, D.SCENES[#D.SCENES], #D.SCENES, #D.SCENES)))
    qf("demo next")
    t.ok(Mock.printed(Q.L.UI_DEMO_LAST), "end of the sequence")
    qf("demo off")
    qf("demo next")
    t.ok(Mock.printed(Q.L.UI_DEMO_NO_SEQUENCE), "next without a sequence")
    noErrors(t)
  end,

  -- Donnée ou API absente : la scène le dit, rien ne plante.
  missing_data_is_reported_not_raised = function(t)
    local Q = load()
    Q.ClassQuestData = nil
    Q.DungeonData = nil
    Q.CaveData = nil
    Q.Professions = nil
    for _, name in ipairs({ "classquest", "classlate", "dungeon", "route", "cave", "profession" }) do
      qf("demo " .. name)
    end
    t.ok(Mock.countPrinted(string.format(Q.L.UI_DEMO_MISSING, "classquest", Q.L.UI_DEMO_WHY_DATA)) == 1)
    t.ok(Mock.countPrinted(Q.L.UI_DEMO_WHY_DATA) >= 4, "each missing scene says why")
    noErrors(t)
  end,

  -- Textes visibles dans les deux langues.
  demo_texts_exist_in_both_languages = function(t)
    local f = assert(io.open(Mock.root .. "/Questify/Locales/StringsUI.lua", "rb"))
    local src = f:read("*a"); f:close()
    local en, fr = src:match("enUS = (.-)\n  frFR = (.*)$")
    t.ok(en and fr, "two blocks")
    local keys = {}
    for key in en:gmatch("(UI_DEMO_[%w_]+) =") do keys[key] = true end
    local n = 0
    for key in pairs(keys) do
      n = n + 1
      t.ok(fr:find(key .. " =", 1, true), key .. " in frFR")
    end
    t.ok(n >= 12, "demo texts present: " .. n)
    local _, count = en:gsub("UI_DEMO_", "")
    local _, countFr = fr:gsub("UI_DEMO_", "")
    t.eq(count, countFr, "same number of keys")
  end,

  -- Aucun chemin personnel, nom ou adresse dans le module.
  module_has_no_personal_data = function(t)
    local f = assert(io.open(Mock.root .. "/Questify/UI/Demo.lua", "rb"))
    local src = f:read("*a"); f:close()
    t.ok(not src:find("/Users/", 1, true))
    t.ok(not src:find("@", 1, true) or not src:find("%w@%w"), "no address")
  end,

  -- Zone d'exemple : suivi dedans (pastille, groupes, numéros), contour sur la carte, tout revient.
  zone_scene_draws_tracker_and_map = function(t)
    local Q = load()
    Minimap:SetSize(140, 140)   -- taille de la minicarte du jeu (le mock part de 0)
    qf("demo zone")
    local T = Q.UI.Tracker
    local text = T:CurrentText()
    t.ok(text:find(Q.L.UI_DEMO_ZONE_NAME, 1, true), "zone pill: " .. text)
    t.ok(text:find("OBJECTS", 1, true) and text:find("MONSTERS", 1, true), "groups")
    t.eq(T.currentIcon:GetTexture(), T.ZONE_ICON)
    t.ok(T.host.objRows[1].num:IsShown(), "numbered objectives")
    Mock.advance(0.3)
    t.ok(Q.UI.ZoneOverlay:DrawsWorld(), "outline on the world map")
    t.ok((Q.UI.ZoneOverlay.active.mini.dots or 0) > 0, "dots on the minimap")
    qf("demo off")
    Mock.advance(0.3)
    t.ok(not T:CurrentText():find(Q.L.UI_DEMO_ZONE_NAME, 1, true), "tracker back to the step")
    t.ok(not Q.UI.ZoneOverlay:DrawsWorld(), "outline gone")
    noErrors(t)
  end,
}
