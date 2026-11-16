-- Tests de l'animation autour de l'objet à utiliser (Q.UI.ObjectGlow), accrochée au cadre d'écran
-- du marqueur 3D natif (C_Navigation, simulé ici).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local nav   -- état du C_Navigation simulé

local function installNav()
  nav = { frame = CreateFrame("Frame", "MockNavigationFrame", UIParent), clamped = false, distance = 4 }
  C_Navigation = {
    GetFrame = function() return nav.frame end,
    WasClampedToScreen = function() return nav.clamped end,
    GetDistance = function() return nav.distance end,
  }
end

-- Étape « Faire » 3361 objectif 2 : la cible est le coffre de Felix (objet 178084).
local function load(opts)
  Ext.install()
  installNav()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  -- la lueur suit le marqueur 3D du jeu : affichage « Repère du jeu »
  opts.beforeLogin = opts.beforeLogin or function(Q) Q.Settings:Set("nav.display", "native") end
  local Q = Mock.loadAddon(TOC, opts)
  Q:RegisterGuide({ id = "T_obj", faction = "Alliance", steps = { { "complete", 3361, obj = 2 }, { "complete", 179 } } })
  Mock.quests.log[3361] = { objectives = {
    { text = "Felix's Box: 0/1", finished = false },
    { text = "Felix's Chest: 0/1", finished = false },
    { text = "Felix's Bucket of Bolts: 0/1", finished = false },
  } }
  Q.Progress:SetGuide("T_obj")
  Mock.advance(0.2)
  return Q
end

local function glowing(Q)
  local G = Q.UI.ObjectGlow
  return G.frame ~= nil and G.frame:IsShown() and G.frame:GetAlpha() == 1
end

return {
  glow_around_object_target = function(t)
    local Q = load()
    t.eq(Q.UI.Tracker.target.kind, "object")
    local G = Q.UI.ObjectGlow
    t.ok(glowing(Q), "visible over the object")
    local p, rel, rp = G.frame:GetPoint(1)
    t.eq(p, "CENTER"); t.ok(rel == nav.frame, "follows the native 3D marker on screen"); t.eq(rp, "CENTER")
    t.ok(G.anims[1]:IsPlaying() and G.anims[2]:IsPlaying(), "spinning star and first wave")
    Mock.advance(0.7)
    t.ok(G.anims[3]:IsPlaying(), "second wave half a period later")
    t.eq({ G.frame:GetSize() }, { G:SizeFor(4), G:SizeFor(4) })
    t.eq(#Mock.errors, 0)
  end,

  size_shrinks_with_distance_and_hidden_far = function(t)
    local Q = load()
    local G = Q.UI.ObjectGlow
    t.eq(G:SizeFor(0), 150); t.eq(G:SizeFor(50), 60); t.eq(G:SizeFor(nil), 150)
    nav.distance = 25
    Mock.advance(0.2)
    t.eq(G.frame:GetWidth(), G:SizeFor(25))
    nav.distance = 80
    Mock.advance(0.2)
    t.ok(not glowing(Q), "too far: nothing")
    t.ok(not G.anims[1]:IsPlaying(), "animations stopped")
    nav.distance = 10
    Mock.advance(0.2)
    t.ok(glowing(Q), "back in range")
  end,

  hidden_when_marker_off_screen = function(t)
    local Q = load()
    nav.clamped = true
    Mock.advance(0.2)
    t.ok(not glowing(Q), "marker stuck to the screen edge: the object is not in view")
    nav.clamped = false
    nav.frame = nil
    Mock.advance(0.2)
    t.ok(not glowing(Q), "no navigation frame")
  end,

  no_glow_for_monsters_or_npcs = function(t)
    local Q = load()
    Mock.quests.log[3361] = { objectives = {
      { text = "Felix's Box: 0/1", finished = false },
      { text = "Felix's Chest: 1/1", finished = true },
      { text = "Felix's Bucket of Bolts: 0/1", finished = false },
    } }
    Mock.quests.log[179] = { objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
    Mock.fire("QUEST_LOG_UPDATE")
    Mock.advance(0.3)
    t.eq(Q.Progress:Current().step.questId, 179, "wolves now")
    t.ok(Q.UI.Tracker.target == nil or Q.UI.Tracker.target.kind ~= "object")
    t.ok(not glowing(Q))
  end,

  off_with_option_or_other_display = function(t)
    local Q = load()
    Q.Settings:Set("objectGlow", false)
    Mock.advance(0.2)
    t.ok(not glowing(Q), "option off")
    Q.Settings:Set("objectGlow", true)
    Mock.advance(0.2)
    t.ok(glowing(Q))
    rawset(Q.Nav, "Active", function() return nil, "tomtom" end)
    Mock.advance(0.2)
    t.ok(not glowing(Q), "TomTom: no native marker to follow")
  end,

  -- Affichage par défaut (flèche Questify) : pas de repère du jeu loin de l'objet ; à portée, la lueur
  -- pose le repère qui donne le cadre du marqueur 3D, et le retire en s'éloignant.
  glow_with_the_default_arrow_display = function(t)
    local Q = load({ beforeLogin = function() end })
    t.eq(select(2, Q.Nav:Active()), "arrow")
    local tg = Q.UI.Tracker.target
    t.eq(tg.kind, "object")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0, "far from the chest: no game pin")
    t.ok(not glowing(Q), "far: nothing")
    Mock.player.map, Mock.player.x, Mock.player.y = tg.mapId, tg.x + 0.4, tg.y   -- ~20 yd
    Mock.advance(0.2)
    local pin = Mock.lastCall("C_Map.SetUserWaypoint")
    t.ok(pin, "game pin posed on the object in range")
    t.eq(pin.args[1].uiMapID, tg.mapId); t.near(pin.args[1].position.x, tg.x / 100, 0.0001)
    t.ok(glowing(Q), "visible over the object, as with the game pin display")
    local p, rel = Q.UI.ObjectGlow.frame:GetPoint(1)
    t.eq(p, "CENTER"); t.ok(rel == nav.frame, "follows the native 3D marker")
    Mock.advance(1)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1, "posed once")
    Mock.player.x = tg.x + 3   -- ~150 yd
    Mock.advance(0.2)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "removed out of range")
    t.ok(not glowing(Q))
    -- de retour à portée puis option coupée : retiré aussi
    Mock.player.x = tg.x + 0.4
    Mock.advance(0.2)
    t.ok(glowing(Q))
    Q.Settings:Set("objectGlow", false)
    Mock.advance(0.2)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 2, "removed with the option")
    t.ok(not glowing(Q))
    t.eq(#Mock.errors, 0)
  end,

  -- Affichage changé pendant que le repère de la lueur est posé : il est retiré, et le nouvel affichage
  -- seul décide (TomTom : aucun repère du jeu ; Repère du jeu : celui de la navigation reste).
  glow_pin_removed_when_the_display_changes = function(t)
    Mock.addons.TomTom = true
    local Q = load({ beforeLogin = function() end })
    local tg = Q.UI.Tracker.target
    Mock.player.map, Mock.player.x, Mock.player.y = tg.mapId, tg.x + 0.4, tg.y
    Mock.advance(0.2)
    t.ok(Mock.userWaypoint, "glow pin posed")
    Q.Settings:Set("nav.display", "tomtom")
    Mock.advance(0.5)
    t.eq(Mock.userWaypoint, nil, "no game pin left with TomTom")
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 1)
    -- retour à la flèche puis « Repère du jeu » : le repère de la navigation reste posé
    Q.Settings:Set("nav.display", "arrow")
    Mock.advance(0.2)
    t.ok(Mock.userWaypoint, "glow pin posed again")
    Q.Settings:Set("nav.display", "native")
    Mock.advance(0.5)
    t.ok(Mock.userWaypoint, "the navigation's game pin stays")
    t.eq(Q.Nav:Status().provider, "native")
    t.eq(#Mock.errors, 0)
  end,

  -- Le repère de la lueur survit à une déconnexion ou un /reload : retiré à la connexion s'il est le
  -- sien (mêmes coordonnées) ; un repère posé ailleurs (par le joueur) reste.
  glow_pin_removed_after_reload = function(t)
    local Q = load({ beforeLogin = function() end })
    local tg = Q.UI.Tracker.target
    Mock.player.map, Mock.player.x, Mock.player.y = tg.mapId, tg.x + 0.4, tg.y
    Mock.advance(0.2)
    t.ok(Mock.userWaypoint, "glow pin posed")
    Mock.player.x = tg.x + 3                     -- déconnecté loin de l'objet, repère toujours là
    local function reload()
      return Mock.reload({ extraFiles = { GUIDES }, skipGuides = true, beforeLogin = function() installNav() end })
    end
    reload()
    t.eq(Mock.userWaypoint, nil, "stale glow pin removed at login")
    -- repère du joueur ailleurs : intact
    Mock.userWaypoint = { uiMapID = tg.mapId, position = { x = 0.5, y = 0.5 } }
    reload()
    t.ok(Mock.userWaypoint and Mock.userWaypoint.position.x == 0.5, "someone else's pin left alone")
    t.eq(#Mock.errors, 0)
  end,

  -- Repère refusé ou retiré par un autre addon : pas plus d'un nouvel essai toutes les 5 s.
  glow_pin_retry_is_throttled = function(t)
    local Q = load({ beforeLogin = function() end })
    local tg = Q.UI.Tracker.target
    Mock.player.map, Mock.player.x, Mock.player.y = tg.mapId, tg.x + 0.4, tg.y
    Mock.advance(0.2)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1)
    Mock.userWaypoint = nil                      -- retiré par un autre addon
    Mock.advance(2)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1, "not re-posed every 0.1 s")
    Mock.advance(3.2)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 2, "re-posed after 5 s")
  end,

  -- Le repère du jeu de l'affichage « Repère du jeu » appartient à la navigation : la lueur n'y touche pas.
  native_display_pin_is_not_touched = function(t)
    local Q = load()
    local sets, clears = Mock.countCalls("C_Map.SetUserWaypoint"), Mock.countCalls("C_Map.ClearUserWaypoint")
    Mock.player.x = Q.UI.Tracker.target.x + 3
    Mock.advance(0.5)
    Q.Settings:Set("objectGlow", false)
    Mock.advance(0.2)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), sets)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), clears)
  end,

  nothing_without_navigation_api = function(t)
    Ext.install()
    C_Navigation = nil
    local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true })
    Mock.advance(0.2)
    t.eq(Q.UI.ObjectGlow.frame, nil, "client without C_Navigation: no frame at all")
    t.eq(#Mock.errors, 0)
  end,
}
