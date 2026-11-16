-- Tests de la flèche Questify (UI/Arrow.lua) : visibilité, légende du trajet, glisser-déposer,
-- verrou, couleurs du thème, ligne droite sans routeur, avertissements une fois par trajet.
-- Repère du mock : Elwynn (1429) mesure 3470 × 2314 yd : 1 unité de x vaut 34,7 yd.
local TOC = "Questify/Questify.toc"
local ELWYNN = 1429
local ARROW_TEXTURE = "Interface\\AddOns\\Questify\\Media\\Themes\\arrow"

-- Charge l'addon, Questify_Nav installé (routeur Questify), joueur à Elwynn 40,50, sans guides.
-- settings : réglages posés avant la connexion.
local function load(settings)
  Mock.addons.Questify_Nav = "demand"
  Mock.player.map, Mock.player.x, Mock.player.y = ELWYNN, 40, 50
  return Mock.loadAddon(TOC, { skipGuides = true, beforeLogin = function(Q)
    for path, value in pairs(settings or {}) do Q.Settings:Set(path, value) end
  end })
end

local function world(Q, m, x, y)
  local c, X, Y = Q.Maps:WorldPos(m, x, y)
  return { instance = c, x = X, y = Y }
end

-- Route factice publiée comme le pont de marche (Nav/Walk.lua) : trajet `leg` des legs donnés,
-- prochain point à Elwynn 60,50 (à l'est du joueur).
local function fakeRoute(Q, legs, leg, warnings, target)
  local p = world(Q, ELWYNN, 60, 50)
  local r = {
    legs = legs, leg = leg or 1, path = { world(Q, ELWYNN, 40, 50), p }, nextPoint = p,
    straight = false, warnings = warnings or {},
    target = target or { mapId = ELWYNN, x = 60, y = 50, title = "East" },
  }
  return r
end

local function walkLegs(Q)
  return { { kind = "walk", caption = Q.L.NAV_TRAVEL_WALK_FM, icon = Q.Travel.ICONS.walk,
    from = { mapId = ELWYNN, x = 40, y = 50 }, to = { mapId = ELWYNN, x = 60, y = 50 }, seconds = 99 } }
end

local function shown(Q)
  local f = Q.Arrow:Frame()
  return f ~= nil and f:IsShown()
end

local function noErrors(t) t.eq(Mock.errors, {}, "no Lua error") end

local function sameColor(t, actual, c, msg)
  t.ok(actual, (msg or "color") .. " set")
  t.near(actual[1], c[1], 0.001, msg)
  t.near(actual[2], c[2], 0.001, msg)
  t.near(actual[3], c[3], 0.001, msg)
end

return {
  hidden_without_route = function(t)
    local Q = load()
    t.ok(Q.Arrow, "Q.Arrow exists")
    t.eq(shown(Q), false, "no target, no route: hidden")
    Mock.advance(1)
    t.eq(shown(Q), false)
    noErrors(t)
  end,

  shows_route_with_distance_and_eta = function(t)
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    Mock.advance(0.3)
    t.ok(shown(Q), "a route: shown")
    local f = Q.Arrow:Frame()
    t.eq(f.arrow:GetTexture(), ARROW_TEXTURE, "Questify's own arrow texture")
    t.eq(f.dist:GetText(), "694 yd", "straight distance to the target (20 x 34.7 yd)")
    t.eq(f.eta:GetText(), string.format(Q.L.NAV_ARROW_ETA_MIN, 2), "694 yd at 7 yd/s: about 2 min")
    -- facing north, target to the east: rotated a quarter turn clockwise
    t.near(f.arrow:GetRotation(), -math.pi / 2, 0.01, "points east")
    GetPlayerFacing = function() return -math.pi / 2 end      -- facing east
    Mock.advance(0.05)
    t.near(f.arrow:GetRotation(), 0, 0.01, "facing the target: points up")
    Q.Nav:Clear()
    t.eq(shown(Q), false, "target cleared: hidden")
    noErrors(t)
  end,

  shows_leg_caption = function(t)
    local Q = load()
    local legs = walkLegs(Q)
    legs[2] = { kind = "fly", caption = string.format(Q.L.NAV_TRAVEL_FLY, "Sentinel Hill"),
      icon = Q.Travel.ICONS.fly, seconds = 120,
      from = { mapId = ELWYNN, x = 40, y = 50 }, to = { mapId = ELWYNN, x = 60, y = 50 } }
    Q:Fire("NAV_ROUTE", fakeRoute(Q, legs, 2))
    t.ok(shown(Q))
    local f = Q.Arrow:Frame()
    t.eq(f.caption:GetText(), "Fly to Sentinel Hill")
    t.eq(f.icon:GetTexture(), "Interface\\Icons\\Ability_Mount_Gryphon_01", "flight icon")
    t.eq(f.eta:GetText(), string.format(Q.L.NAV_ARROW_ETA_MIN, 2), "ride time of the flight")
    Q:Fire("NAV_ROUTE", nil)
    t.eq(shown(Q), false, "route withdrawn: hidden")
    noErrors(t)
  end,

  drag_saves_position = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    local f = Q.Arrow:Frame()
    t.eq(f:IsMouseEnabled(), true, "unlocked: takes the mouse")
    t.eq(f:IsMovable(), true)
    f:GetScript("OnDragStart")(f)
    t.eq(Mock.countCalls("StartMoving"), 1, "drag starts moving")
    rawset(f, "GetCenter", function() return 300, 400 end)
    f:GetScript("OnDragStop")(f)
    t.eq(Mock.countCalls("StopMovingOrSizing"), 1)
    t.eq(Q.Settings:Get("nav.arrowPos"), { "CENTER", "BOTTOMLEFT", 300, 400 }, "centre saved in the profile")
    -- après /reload, la position est reprise
    Q = Mock.reload()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    f = Q.Arrow:Frame()
    t.eq({ f:GetPoint(1) }, { "CENTER", UIParent, "BOTTOMLEFT", 300, 400 }, "position restored")
    noErrors(t)
  end,

  locked_no_drag = function(t)
    local Q = load({ ["nav.arrowLocked"] = true })
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    local f = Q.Arrow:Frame()
    t.eq(f:IsMouseEnabled(), false, "locked: clicks go through")
    f:GetScript("OnDragStart")(f)
    t.eq(Mock.countCalls("StartMoving"), 0, "locked: does not move")
    t.ok(f.lock:GetTexture():find("Locked", 1, true), "padlock closed")
    t.near(f.lock:GetAlpha(), 0.85, 0.001)
    -- clic sur le cadenas : déverrouille
    Mock.click(f.lockButton)
    t.eq(Q.Settings:Get("nav.arrowLocked"), false, "padlock click unlocks")
    t.eq(f:IsMouseEnabled(), true)
    t.ok(f.lock:GetTexture():find("Unlocked", 1, true), "padlock open")
    t.near(f.lock:GetAlpha(), 0.35, 0.001, "open padlock is faint")
    noErrors(t)
  end,

  theme_colors = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    local f = Q.Arrow:Frame()
    local T = Q.Themes
    local parchment = T:Get("parchment")
    sameColor(t, f.caption._textColor, T:TextColor("body", parchment), "caption: body")
    sameColor(t, f.dist._textColor, T:TextColor("distance", parchment), "distance: distance")
    sameColor(t, f.eta._textColor, T:TextColor("dim", parchment), "eta: dim")
    t.eq(f.qvThemeKey, "parchment", "panel themed like the tracker")
    Q.Settings:Set("tracker.theme", "dark")
    local dark = T:Get("dark")
    sameColor(t, f.caption._textColor, T:TextColor("body", dark), "caption follows the theme")
    sameColor(t, f.dist._textColor, T:TextColor("distance", dark))
    t.eq(f.qvThemeKey, "dark")
    noErrors(t)
  end,

  arrow_color_setting = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    local f = Q.Arrow:Frame()
    sameColor(t, f.arrow._vertex, { 0x3f / 255, 0xd0 / 255, 0xe6 / 255 }, "cyan by default")
    Q.Settings:Set("arrow.color", "theme")
    sameColor(t, f.arrow._vertex, Q.Themes:TextColor("title"), "theme: title colour")
    Q.Settings:Set("arrow.color", "gold")
    sameColor(t, f.arrow._vertex, { 0xf0 / 255, 0xc7 / 255, 0x5a / 255 }, "gold")
    -- Themes:ArrowColor (session ui-themes) prend le pas quand il existe
    Q.Themes.ArrowColor = function() return 0.1, 0.2, 0.3 end
    Q.Settings:Set("arrow.color", "pink")
    sameColor(t, f.arrow._vertex, { 0.1, 0.2, 0.3 }, "Themes:ArrowColor wins")
    noErrors(t)
  end,

  hidden_with_tomtom_display = function(t)
    Mock.addons.TomTom = true
    local Q = load({ ["nav.display"] = "tomtom" })
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    t.eq(shown(Q), false, "TomTom shows the way: no Questify arrow")
    Q.Settings:Set("nav.display", "arrow")
    t.eq(shown(Q), true, "back to the arrow")
    Q.Settings:Set("arrow.show", false)
    t.eq(shown(Q), false, "arrow.show off: hidden")
    noErrors(t)
  end,

  hidden_on_taxi = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    t.ok(shown(Q))
    Mock.player.onTaxi = true
    Mock.advance(0.3)
    t.eq(shown(Q), false, "on a flight: hidden")
    Mock.player.onTaxi = false
    Mock.fire("PLAYER_CONTROL_GAINED")
    t.eq(shown(Q), true, "landed: shown again")
    noErrors(t)
  end,

  -- Sans routeur (« none » ou Questify_Nav absent) : la flèche pointe droit sur la cible.
  straight_without_router = function(t)
    local Q = load({ ["nav.router"] = "none" })
    t.eq((Q.Nav:Active()), nil, "no router")
    Q.Nav:SetTarget(ELWYNN, 60, 50, "Gryan Stoutmantle")
    t.ok(shown(Q), "target only: shown")
    local f = Q.Arrow:Frame()
    t.near(f.arrow:GetRotation(), -math.pi / 2, 0.01, "points east, straight at the target")
    t.eq(f.dist:GetText(), "694 yd")
    t.eq(f.caption:GetText(), string.format(Q.L.NAV_TRAVEL_WALK, "Gryan Stoutmantle"))
    t.eq(f.icon:GetTexture(), Q.Travel.ICONS.walk)
    Q.Nav:Clear()
    t.eq(shown(Q), false)
    noErrors(t)
  end,

  straight_without_questify_nav = function(t)
    local Q = load()
    Mock.addons.Questify_Nav = nil
    Q.Settings:Set("nav.router", "questify")     -- relu : Questify_Nav absent, aucun routeur
    t.eq((Q.Nav:Active()), nil, "Questify_Nav missing: no router")
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    t.ok(shown(Q), "still guided, straight")
    noErrors(t)
  end,

  -- Avertissements : une fois par trajet (par cible), pas à chaque nouveau calcul.
  warnings_once_per_trip = function(t)
    local Q = load()
    local w = { { kind = "hostile", name = "Orgrimmar" }, { kind = "level", level = 45 } }
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q), 1, w))
    local f = Q.Arrow:Frame()
    local text = f.warn:GetText() or ""
    t.ok(f.warn:IsShown(), "warning shown")
    t.ok(text:find(string.format(Q.L.NAV_WARN_HOSTILE, "Orgrimmar"), 1, true), "hostile town")
    t.ok(text:find(string.format(Q.L.NAV_WARN_LEVEL, 45), 1, true), "high level zone")
    Mock.advance(11)
    t.eq(f.warn:IsShown(), false, "the warning fades out")
    -- nouveau calcul, mêmes avertissements (nouvelle table) : rien de nouveau
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q), 1,
      { { kind = "hostile", name = "Orgrimmar" }, { kind = "level", level = 45 } }))
    t.eq(f.warn:IsShown(), false, "not flashed again on a recompute")
    -- un nouvel avertissement sur le même trajet : lui seul
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q), 1,
      { { kind = "hostile", name = "Orgrimmar" }, { kind = "hostile", name = "Undercity" } }))
    t.ok(f.warn:IsShown())
    t.eq(f.warn:GetText(), string.format(Q.L.NAV_WARN_HOSTILE, "Undercity"), "only the new one")
    Mock.advance(11)
    -- autre cible : de nouveau montré
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q), 1, { { kind = "hostile", name = "Orgrimmar" } },
      { mapId = ELWYNN, x = 70, y = 40, title = "Elsewhere" }))
    t.ok(f.warn:IsShown(), "new trip: shown again")
    noErrors(t)
  end,

  -- Budget : la position du joueur est lue au plus toutes les 0,05 s ; chaque image ne lit que
  -- l'orientation.
  rotation_reads_position_sparingly = function(t)
    local Q = load()
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    local f = Q.Arrow:Frame()
    local orig, reads, facings = Q.Maps.PlayerPos, 0, 0
    Q.Maps.PlayerPos = function(...) reads = reads + 1; return orig(...) end
    local origFacing = GetPlayerFacing
    GetPlayerFacing = function() facings = facings + 1; return origFacing() end
    local onUpdate = f:GetScript("OnUpdate")
    for _ = 1, 10 do onUpdate(f, 0.004) end     -- dix images, même instant (GetTime inchangé)
    t.ok(reads <= 1, "at most one position read, got " .. reads)
    t.eq(facings, 10, "facing read every frame")
    t.near(f.arrow:GetRotation(), -math.pi / 2, 0.01, "still points east")
    Q.Maps.PlayerPos = orig
    noErrors(t)
  end,

  -- Pas de minuterie quand la flèche ne peut pas s'afficher (autre affichage, arrow.show coupé).
  no_ticker_when_arrow_cannot_show = function(t)
    Mock.addons.TomTom = true
    local Q = load({ ["nav.display"] = "tomtom" })
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    t.eq(Q.Arrow:Ticking(), false, "TomTom display: no ticker")
    Q.Settings:Set("nav.display", "arrow")
    t.eq(Q.Arrow:Ticking(), true, "arrow display: ticking")
    Q.Settings:Set("arrow.show", false)
    t.eq(Q.Arrow:Ticking(), false, "arrow.show off: no ticker")
    Q.Settings:Set("arrow.show", true)
    t.eq(Q.Arrow:Ticking(), true)
    Q.Nav:Clear()
    t.eq(Q.Arrow:Ticking(), false, "nothing to follow: no ticker")
    noErrors(t)
  end,

  -- Distances localisées : virgule décimale en français.
  french_decimal_separator = function(t)
    Mock.locale = "frFR"
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 75, 50, "Loin")       -- 35 x 34,7 = 1214,5 yd
    local f = Q.Arrow:Frame()
    t.eq(f.dist:GetText(), "1,2 km")
    Q.Nav:SetTarget(ELWYNN, 60, 50, "Près")
    t.eq(f.dist:GetText(), "694 m")
    noErrors(t)
  end,

  english_decimal_separator = function(t)
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 75, 50, "Far")
    t.eq(Q.Arrow:Frame().dist:GetText(), "1.2 km")
    noErrors(t)
  end,

  slash_arrow_reset = function(t)
    local Q = load({ ["nav.arrowPos"] = { "CENTER", "BOTTOMLEFT", 300, 400 } })
    Q:Fire("NAV_ROUTE", fakeRoute(Q, walkLegs(Q)))
    SlashCmdList.QUESTIFY("arrow reset")
    t.eq(Q.Settings:Get("nav.arrowPos"), nil, "position forgotten")
    local f = Q.Arrow:Frame()
    t.eq(f:GetNumPoints(), 1)
    t.eq((f:GetPoint(1)), "TOP", "default place")
    t.ok(Mock.printed(Q.L.UI_ARROW_RESET), "confirmation printed")
    noErrors(t)
  end,
}
