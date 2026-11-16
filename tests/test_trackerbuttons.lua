-- Tests des boutons d'accès rapide du suivi (UI/TrackerButtons.lua) et du repli du suivi d'objectifs
-- de Blizzard (UI/BlizzardTracker.lua).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local function load(opts)
  Ext.install()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end   -- routes générées : contenu changeant
  return Mock.loadAddon(TOC, opts)
end

-- Remplace les listes des quêtes de classe et des donjons, puis redessine le suivi.
local function lists(Q, classRows, dungeonRows, suggested)
  Q.ClassQuests.List = function() return classRows or {} end
  Q.Dungeons.List = function() return dungeonRows or {} end
  Q.Dungeons.Suggested = function() return suggested or {} end
  Q.UI.Tracker:Refresh()
  return Q.UI.TrackerButtons
end

local function row(state, key) return { state = state, chain = { key = key or state }, dungeon = { key = key or state } } end

-- Faux suivi d'objectifs de Blizzard (SetCollapsed du conteneur moderne ; Update affiche le cadre
-- comme le gestionnaire du jeu quand il a des quêtes à montrer).
local function blizzardTracker()
  local otf = CreateFrame("Frame", "ObjectiveTrackerFrame", UIParent)
  otf.isCollapsed = false
  otf.calls = 0
  otf.updates = 0
  function otf:SetCollapsed(c) self.isCollapsed = c; self.calls = self.calls + 1 end
  function otf:IsCollapsed() return self.isCollapsed end
  function otf:Update() self.updates = self.updates + 1; self:Show() end
  return otf
end

-- Chargement avec tracker.hideBlizzard déjà coché dans le profil (comme après un /reload).
local function loadHidden()
  return load({ beforeLogin = function(Q) Q.Settings:Set("tracker.hideBlizzard", true) end })
end

return {
  four_buttons_right_of_the_title = function(t)
    local Q = load()
    local T, B = Q.UI.Tracker, Q.UI.TrackerButtons
    t.eq(#B.ORDER, 4)
    t.eq(B.ORDER, { "route", "dungeons", "class", "options" })
    local x = {}
    for i, key in ipairs(B.ORDER) do
      local b = B.buttons[key]
      t.ok(b and b:IsShown(), key .. " shown")
      local p, rel, rp, bx, by = b:GetPoint(1)
      t.eq(p, "TOPRIGHT"); t.ok(rel == T.frame, key .. " anchored to the tracker"); t.eq(rp, "TOPRIGHT")
      t.eq(by, -6)
      x[i] = bx
    end
    t.eq(x[4], -8, "options at the right edge")
    t.ok(x[1] < x[2] and x[2] < x[3] and x[3] < x[4], "left to right in ORDER")
    -- le titre s'arrête avant les boutons ; les niveaux passent dans la barre
    t.eq(T.title:GetWidth(), T.Width() - 16 - B:Width() - 6)
    t.ok(not T.levels:IsShown(), "levels no longer beside the title")
    t.ok(T.barText:GetText():find("lvl 1-6", 1, true), "levels in the progress bar")
    t.eq(#Mock.errors, 0)
  end,

  buttons_stay_when_tracker_shows_a_message = function(t)
    Mock.addons.QuestieDB = false
    local Q = load()
    local T, B = Q.UI.Tracker, Q.UI.TrackerButtons
    t.ok(T.message:IsShown(), "message shown")
    t.ok(B.buttons.route:IsShown(), "route button still there to open the journal")
    t.eq(T.message:GetWidth(), T.Width() - 16 - B:Width() - 6)
    t.eq(#Mock.errors, 0)
  end,

  route_button_opens_and_closes_the_journal = function(t)
    local Q = load()
    local B, J = Q.UI.TrackerButtons, Q.UI.Journal
    Mock.click(B.buttons.route)
    t.ok(J:IsShown(), "journal opened")
    t.eq(J.tab, "route")
    Mock.click(B.buttons.route)
    t.ok(not J:IsShown(), "second click closes it")
    t.eq(#Mock.errors, 0)
  end,

  class_button_switches_tab_before_closing = function(t)
    local Q = load()
    local B, J = Q.UI.TrackerButtons, Q.UI.Journal
    Mock.click(B.buttons.route)
    Mock.click(B.buttons.class)
    t.ok(J:IsShown(), "still open")
    t.eq(J.tab, "class")
    Mock.click(B.buttons.class)
    t.ok(not J:IsShown(), "closed on the second click")
    t.eq(#Mock.errors, 0)
  end,

  dungeons_button_opens_the_dungeon_tab = function(t)
    local Q = load()
    local B, J = Q.UI.TrackerButtons, Q.UI.Journal
    Mock.click(B.buttons.dungeons)
    t.ok(J:IsShown(), "journal opened")
    t.eq(J.tab, "dungeons")
    Mock.click(B.buttons.dungeons)
    t.ok(not J:IsShown(), "second click closes it")
    t.eq(#Mock.errors, 0)
  end,

  options_button_toggles_options = function(t)
    local Q = load()
    local B, O = Q.UI.TrackerButtons, Q.UI.Options
    Mock.click(B.buttons.options)
    t.ok(O:IsShown(), "options opened")
    Mock.click(B.buttons.options)
    t.ok(not O:IsShown(), "options closed")
    t.eq(#Mock.errors, 0)
  end,

  class_glow_while_a_chain_is_available_and_none_followed = function(t)
    local Q = load()
    local B = lists(Q, { row("available", "a"), row("upcoming", "b") })
    t.ok(B.buttons.class.glow:IsShown(), "glows")
    t.ok(B.buttons.class.pulse:IsPlaying(), "pulses")
    t.eq(B.classCount, 1)
    lists(Q, { row("available", "a"), row("added", "b") })
    t.ok(not B.buttons.class.glow:IsShown(), "a chain added to the route: no glow")
    lists(Q, { row("available", "a"), row("available", "c"), row("inprogress", "b") })
    t.ok(not B.buttons.class.glow:IsShown(), "a chain in the quest log: no glow")
    t.ok(not B.buttons.class.pulse:IsPlaying(), "pulse stopped")
    lists(Q, { row("ignored", "a"), row("done", "b"), row("inroute", "c") })
    t.ok(not B.buttons.class.glow:IsShown(), "nothing available: no glow")
    t.eq(#Mock.errors, 0)
  end,

  dungeon_glow_while_suggested_and_none_added = function(t)
    local Q = load()
    local B = lists(Q, {}, { row("available", "rfc") }, { row("available", "rfc") })
    t.ok(B.buttons.dungeons.glow:IsShown(), "glows")
    t.eq(B.dungeonCount, 1)
    lists(Q, {}, { row("available", "rfc"), row("added", "wc") }, { row("available", "rfc") })
    t.ok(not B.buttons.dungeons.glow:IsShown(), "a dungeon added to the route: no glow")
    lists(Q, {}, { row("past", "rfc") }, {})
    t.ok(not B.buttons.dungeons.glow:IsShown(), "nothing suggested: no glow")
    t.ok(not B.buttons.class.glow:IsShown(), "class button unaffected")
    t.eq(#Mock.errors, 0)
  end,

  class_icon_from_the_class_sheet = function(t)
    CLASS_ICON_TCOORDS = { WARRIOR = { 0, 0.25, 0, 0.25 } }
    local Q = load()
    local B = Q.UI.TrackerButtons
    t.eq(B.buttons.class.icon:GetTexture(), B.TEXTURES.classSheet)
    CLASS_ICON_TCOORDS = nil
    B:SetClassIcon()
    t.eq(B.buttons.class.icon:GetTexture(), B.TEXTURES.classFallback, "unknown class: question mark")
    t.eq(#Mock.errors, 0)
  end,

  dungeon_icon_uses_the_map_portal_atlas = function(t)
    C_Texture = { GetAtlasInfo = function(name) if name == "dungeon" then return { width = 32 } end end }
    local Q = load()
    local b = Q.UI.TrackerButtons.buttons.dungeons
    t.eq(b.icon:GetAtlas(), "dungeon")
    t.ok(b.mark and b.mark:GetTexture() == Q.UI.TrackerButtons.TEXTURES.questMark, "quest mark in the corner")
    t.eq(#Mock.errors, 0)
  end,

  dungeon_icon_fallback_without_atlas = function(t)
    C_Texture = nil
    local Q = load()
    local B = Q.UI.TrackerButtons
    t.eq(B.buttons.dungeons.icon:GetAtlas(), nil)
    t.eq(B.buttons.dungeons.icon:GetTexture(), B.TEXTURES.dungeonFallback)
    t.eq(B.buttons.route.icon:GetTexture(), B.TEXTURES.routePath)
    t.eq(#Mock.errors, 0)
  end,

  -- Une erreur des boutons ne casse pas le suivi : le titre reprend toute la largeur.
  tracker_survives_a_button_error = function(t)
    local Q = load()
    local T, B = Q.UI.Tracker, Q.UI.TrackerButtons
    B.Layout = function() error("boom") end
    T:Refresh()
    t.ok(T.current:IsShown(), "current step still shown")
    t.eq(T.title:GetWidth(), T.Width() - 16)
    t.eq(#Mock.errors, 1)
  end,

  ---------------------------------------------------------------------------
  -- Suivi d'objectifs de Blizzard
  ---------------------------------------------------------------------------
  blizzard_tracker_folded_after_login = function(t)
    local otf = blizzardTracker()
    load()
    Mock.fire("PLAYER_ENTERING_WORLD", true, false)
    t.ok(not otf.isCollapsed, "waits for Blizzard's own setup")
    Mock.advance(1.1)
    t.ok(otf.isCollapsed, "folded")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_folded_after_reload_not_on_zone_change = function(t)
    local otf = blizzardTracker()
    load()
    Mock.fire("PLAYER_ENTERING_WORLD", false, false)
    Mock.advance(2)
    t.ok(not otf.isCollapsed, "zone change: left alone")
    Mock.fire("PLAYER_ENTERING_WORLD", false, true)
    Mock.advance(2)
    t.ok(otf.isCollapsed, "reload: folded")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_left_open_when_option_off = function(t)
    local otf = blizzardTracker()
    local Q = load()
    Q.Settings:Set("tracker.foldBlizzard", false)
    Mock.fire("PLAYER_ENTERING_WORLD", true, false)
    Mock.advance(2)
    t.ok(not otf.isCollapsed, "not folded")
    t.eq(otf.calls, 0)
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_folded_after_combat = function(t)
    local otf = blizzardTracker()
    load()
    Mock.player.combat = true
    Mock.fire("PLAYER_ENTERING_WORLD", false, true)
    Mock.advance(2)
    t.ok(not otf.isCollapsed, "not during combat")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(otf.isCollapsed, "folded once combat ends")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_already_folded_untouched = function(t)
    local otf = blizzardTracker()
    otf.isCollapsed = true
    load()
    Mock.fire("PLAYER_ENTERING_WORLD", true, false)
    Mock.advance(2)
    t.eq(otf.calls, 0)
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_shown_by_default = function(t)
    local otf = blizzardTracker()
    local Q = load()
    t.eq(Q.Settings:Get("tracker.hideBlizzard"), false, "off by default")
    t.ok(otf:IsShown(), "left alone")
    t.ok(not Q.UI.BlizzardTracker:IsHidden())
    t.eq(otf.updates, 0, "nothing handed back when never hidden")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_hidden_at_login_and_kept_hidden = function(t)
    local otf = blizzardTracker()
    local Q = loadHidden()
    t.ok(not otf:IsShown(), "hidden at login")
    t.ok(Q.UI.BlizzardTracker:IsHidden())
    otf:Show()   -- le jeu le réaffiche (nouvelle quête suivie, changement de zone)
    t.ok(not otf:IsShown(), "hidden again each time the game shows it")
    Mock.fire("PLAYER_ENTERING_WORLD", true, false)
    Mock.advance(2)
    t.eq(otf.calls, 0, "no fold while hidden")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_hidden_again_after_reload = function(t)
    blizzardTracker()
    local Q = load()
    Q.Settings:Set("tracker.hideBlizzard", true)
    t.ok(not ObjectiveTrackerFrame:IsShown(), "hidden as soon as ticked")
    local otf2
    local Q2 = Mock.reload({ skipGuides = true, extraFiles = { GUIDES },
      beforeLogin = function() otf2 = blizzardTracker() end })
    t.eq(Q2.Settings:Get("tracker.hideBlizzard"), true, "kept in the profile")
    t.ok(not otf2:IsShown(), "hidden again after /reload")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_comes_back_when_option_off = function(t)
    local otf = blizzardTracker()
    local Q = loadHidden()
    Q.Settings:Set("tracker.hideBlizzard", false)
    t.ok(otf:IsShown(), "back")
    t.eq(otf.updates, 1, "handed back to the game's own Update")
    t.ok(not Q.UI.BlizzardTracker:IsHidden())
    otf:Hide()
    otf:Show()
    t.ok(otf:IsShown(), "the OnShow hook no longer hides it")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_protected_waits_for_combat_end = function(t)
    local otf = blizzardTracker()
    function otf:IsProtected() return true end
    local Q = load()
    Mock.player.combat = true
    Q.Settings:Set("tracker.hideBlizzard", true)
    t.ok(otf:IsShown(), "not touched in combat")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(not otf:IsShown(), "hidden once combat ends")
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_not_hidden_with_gamepad_interface = function(t)
    local otf = blizzardTracker()
    Enum = Enum or {}
    Enum.InputDeviceInterfaceType = { KeyboardAndMouse = 0, Gamepad = 1 }
    C_InputInterfaceStyle = { GetCurrentStyle = function() return 1 end }
    local Q = loadHidden()
    t.ok(otf:IsShown(), "gamepad HUD navigation starts at the tracker")
    t.ok(not Q.UI.BlizzardTracker:IsHidden())
    t.eq(#Mock.errors, 0)
  end,

  blizzard_tracker_without_frame_is_silent = function(t)
    local Q = loadHidden()
    t.ok(not Q.UI.BlizzardTracker:IsHidden())
    Q.Settings:Set("tracker.hideBlizzard", false)
    t.eq(#Mock.errors, 0)
  end,

  questify_tracker_takes_the_place_of_the_hidden_one = function(t)
    blizzardTracker()
    local Q = load()
    local f = Q.UI.Tracker.frame
    local p, rel, rp, x = f:GetPoint(1)
    t.eq({ p, rp, x }, { "TOPRIGHT", "TOPLEFT", -8 }, "beside it while shown")
    t.ok(rel == ObjectiveTrackerFrame)
    Q.Settings:Set("tracker.hideBlizzard", true)
    p, rel, rp, x = f:GetPoint(1)
    t.eq({ p, rp, x }, { "TOPRIGHT", "TOPRIGHT", 0 }, "in its place while hidden")
    t.ok(rel == ObjectiveTrackerFrame)
    Q.Settings:Set("tracker.hideBlizzard", false)
    p, rel, rp = f:GetPoint(1)
    t.eq({ p, rp }, { "TOPRIGHT", "TOPLEFT" }, "beside it again")
    t.eq(#Mock.errors, 0)
  end,

  fold_option_greyed_while_hidden = function(t)
    local Q = load()
    local S = Q.OptionsSchema
    local fold = S:Entry("tracker.foldBlizzard")
    t.ok(S:Enabled(fold), "available by default")
    Q.Settings:Set("tracker.hideBlizzard", true)
    t.ok(not S:Enabled(fold), "greyed while the tracker is hidden")
    t.ok(S:Entry("tracker.hideBlizzard"), "hide option in the schema")
    t.eq(S:Entry("tracker.hideBlizzard").section, "tracker")
    t.eq(#Mock.errors, 0)
  end,
}
