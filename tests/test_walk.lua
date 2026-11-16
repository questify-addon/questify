-- Tests du pont de marche (Q.Walk, Nav/Walk.lua) avec le routeur factice du mock
-- (Mock.newNavEngine : Find note la demande, le test y répond).
-- Repère du mock : monde = (top - y * height, left - x * width) ; Elwynn (1429) mesure
-- 3470 × 2314 yd : 1 unité de x vaut 34,7 yd, 1 unité de y 23,14 yd.
local TOC = "Questify/Questify.toc"
local ELWYNN = 1429
local YARD_Y = 2314 / 100        -- yards par unité de y sur Elwynn

-- Charge l'addon, Questify_Nav installé mais pas chargé (comme en jeu), joueur à Elwynn 40,50.
-- opts.settings : réglages posés avant la connexion ; opts.level : niveau du joueur.
local function load(opts)
  opts = opts or {}
  Mock.addons.Questify_Nav = "demand"
  Mock.player.map, Mock.player.x, Mock.player.y = ELWYNN, 40, 50
  if opts.level then Mock.player.level = opts.level end
  local routes = {}
  local Q = Mock.loadAddon(TOC, { skipGuides = true, beforeLogin = function(Q)
    for path, value in pairs(opts.settings or {}) do Q.Settings:Set(path, value) end
    Q:On("NAV_ROUTE", function(r) routes[#routes + 1] = r or false end)
  end })
  return Q, routes
end

local function world(Q, m, x, y)
  local c, X, Y = Q.Maps:WorldPos(m, x, y)
  return { map = c, x = X, y = Y }
end

local function loads()
  local out = {}
  for _, c in ipairs(Mock.callsTo("C_AddOns.LoadAddOn")) do out[#out + 1] = c.args[1] end
  return out
end

local function finds() return Mock.navEngine and Mock.navEngine.finds or {} end

-- Cible à Elwynn 60,50 et réponse du routeur : départ, Elwynn 45,50, cible.
local function routeEast(Q, hubs)
  Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
  local job = finds()[#finds()]
  local pts = { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 45, 50), world(Q, ELWYNN, 60, 50) }
  Mock.navEngine.resolve(job, pts, 700, hubs)
  return pts, job
end

local function samePoint(t, p, w, msg)
  t.ok(p, (msg or "point") .. " present")
  t.eq(p.instance, w.map, msg)
  t.near(p.x, w.x, 0.01, msg)
  t.near(p.y, w.y, 0.01, msg)
end

return {
  loads_parts_on_demand = function(t)
    local Q = load()
    t.eq(loads(), {}, "nothing loaded before the first route")
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    t.eq(loads(), { "Questify_Nav", "Questify_Nav_EK" }, "router, then the Eastern Kingdoms part only")
    t.eq(#finds(), 1)
    t.eq(finds()[1].map, 0, "search on the Eastern Kingdoms (instance 0)")
    local st = Q.Walk:Status()
    t.eq(st.loaded, true)
    t.eq(st.maps[0], true)
    t.eq(st.maps[1], false, "Kalimdor not loaded")
    t.eq(#Mock.errors, 0)
  end,

  follows_path = function(t)
    local Q, routes = load()
    local pts = routeEast(Q)
    local r = Q.Walk:Route()
    t.ok(r, "route")
    t.eq(r.straight, false)
    t.eq(#r.path, 3)
    t.eq(r.leg, 1)
    t.eq(r.legs[1].kind, "walk")
    samePoint(t, r.nextPoint, pts[2], "next point = the second one")
    t.ok(routes[#routes] and routes[#routes].path and #routes[#routes].path == 3, "NAV_ROUTE carries the path")
    -- passé le deuxième point : la cible
    Mock.player.x = 45.2
    samePoint(t, Q.Walk:Route().nextPoint, pts[3], "next point = the target")
    t.eq(#Mock.errors, 0)
  end,

  off_path_recompute = function(t)
    local Q = load()
    routeEast(Q)
    Mock.player.x = 42
    Mock.player.y = 50 + 10 / YARD_Y          -- 10 yd du chemin
    Mock.advance(2)
    t.eq(#finds(), 1, "10 yd off: no new search")
    Mock.player.y = 50 + 30 / YARD_Y          -- 30 yd du chemin
    Mock.advance(1.1)
    t.eq(#finds(), 2, "30 yd off: new search")
    t.near(finds()[2].from.x, world(Q, ELWYNN, 42, 50 + 30 / YARD_Y).x, 0.01, "from the player")
    t.eq(#Mock.errors, 0)
  end,

  throttle = function(t)
    local Q = load()
    for i = 1, 10 do
      Q.Nav:SetTarget(ELWYNN, 50 + i, 50, "T" .. i)
      Mock.advance(0.05)
    end
    t.ok(#finds() <= 2, "at most one search launched in the first second")
    t.ok(#Mock.navEngine.pending() <= 1, "one search running at most")
    Mock.advance(1)
    t.eq(#Mock.navEngine.pending(), 1, "one search running")
    t.eq(finds()[1].cancelled, true, "the first one cancelled")
    local last = finds()[#finds()]
    t.near(last.to.x, world(Q, ELWYNN, 60, 50).x, 0.01, "for the last target")
    t.near(last.to.y, world(Q, ELWYNN, 60, 50).y, 0.01)
    t.ok(#finds() <= 2, "no search per change")
    t.eq(#Mock.errors, 0)
  end,

  no_data_straight_when_load_fails = function(t)
    local Q = load()
    Mock.onLoadAddOn.Questify_Nav = function() return false end
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local r = Q.Walk:Route()
    t.ok(r, "a route all the same")
    t.eq(r.straight, true)
    samePoint(t, r.nextPoint, world(Q, ELWYNN, 60, 50), "points at the target")
    t.eq(Q.Walk:Status().loaded, false)
    t.ok(Q.Walk:Status().reason, "reason given")
    t.eq(#Mock.errors, 0)
  end,

  no_data_straight_when_map_missing = function(t)
    local Q = load()
    Mock.onLoadAddOn.Questify_Nav = function()
      Mock.navEngine = Mock.newNavEngine()
      Mock.navEngine.available[0] = false
      Questify_NavEngine = Mock.navEngine
    end
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local r = Q.Walk:Route()
    t.eq(r.straight, true)
    samePoint(t, r.nextPoint, world(Q, ELWYNN, 60, 50), "points at the target")
    t.eq(#finds(), 0, "no search without maps")
    t.eq(Q.Walk:Status().maps[0], false)
    t.eq(Q.Walk:Status().reason, "nodata")
    t.eq(#Mock.errors, 0)
  end,

  search_failure_straight = function(t)
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    Mock.navEngine.fail(finds()[1], "unreachable")
    local r = Q.Walk:Route()
    t.eq(r.straight, true)
    t.eq(r.reason, "unreachable")
    samePoint(t, r.nextPoint, world(Q, ELWYNN, 60, 50))
    Mock.advance(3)
    t.eq(#finds(), 1, "no search loop while the player stands still")
    t.eq(#Mock.errors, 0)
  end,

  safe_style_danger = function(t)
    local Q = load({ level = 10 })
    Q.TravelData.zoneLevels = { [ELWYNN] = 30, [1436] = 30, [1426] = 12, [1432] = 16 }
    local d = Q.Walk:DangerTable(ELWYNN, ELWYNN)
    t.eq(d, { [1436] = 4, [1432] = 2 }, "x4 from 10 levels, x2 from 5, never the start or goal zone")
    t.eq(Q.Walk:DangerTable(1436, ELWYNN), { [1432] = 2 })
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local opts = finds()[1].opts
    t.eq(opts.profile, "Alliance")
    t.eq(opts.style, "balanced")
    t.eq(opts.danger, { [1436] = 4, [1432] = 2 })
    t.eq(finds()[1].danger, { [1436] = 4, [1432] = 2 }, "job as the router starts it")
    -- style changé : nouveau calcul, sans danger
    Q.Settings:Set("nav.routeStyle", "fastest")
    Mock.advance(1.1)
    local last = finds()[#finds()]
    t.eq(last.opts.style, "fastest")
    t.eq(last.opts.profile, "Alliance")
    t.eq(last.opts.danger, nil)
    -- le job, tel que le routeur le lit au début du calcul (après le retour du pont) : sans danger
    t.eq(last.danger, nil, "fastest: no zone pricing")
    t.eq(finds()[1].cancelled, true)
    Q.Settings:Set("nav.routeStyle", "roads")
    Mock.advance(1.1)
    t.eq(finds()[#finds()].opts.style, "roads")
    t.eq(#Mock.errors, 0)
  end,

  level_warning = function(t)
    local Q = load({ level = 10 })
    Q.TravelData.zoneLevels = { [1436] = 30 }
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local job = finds()[1]
    -- le deuxième point du chemin est dans la zone de niveau 30
    Mock.navEngine.zones = function(_, _, y)
      return math.abs(y - world(Q, ELWYNN, 45, 50).y) < 1 and 1436 or ELWYNN
    end
    Mock.navEngine.resolve(job, { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 45, 50), world(Q, ELWYNN, 60, 50) })
    local w = Q.Walk:Route().warnings
    t.eq(w, { { kind = "level", level = 30 } }, "one warning for the zone crossed")
    t.eq(#Mock.errors, 0)
  end,

  hostile_warning = function(t)
    local Q = load()
    routeEast(Q, { { id = 1, name = "Orgrimmar" } })
    local w = Q.Walk:Route().warnings
    t.eq(w[1].kind, "hostile")
    t.eq(w[1].name, "Orgrimmar")
    -- nom localisé par la zone du jeu quand il est connu
    Mock.areaNames[1637] = "Orgrimmar (fr)"
    Q.Nav:SetTarget(ELWYNN, 70, 50, "Far")
    Mock.advance(1.1)
    local job = finds()[#finds()]
    Mock.navEngine.resolve(job, { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 70, 50) }, 1000,
      { { id = 1, name = "Orgrimmar", areaId = 1637 } })
    t.eq(Q.Walk:Route().warnings[1].name, "Orgrimmar (fr)")
    t.eq(#Mock.errors, 0)
  end,

  perf_counters = function(t)
    local Q = load()
    Mock.addonMemory.Questify, Mock.addonMemory.Questify_Nav = 2048, 9000
    routeEast(Q)
    Q.Nav:SetTarget(ELWYNN, 70, 50, "Far")
    Mock.advance(1.1)
    local p = Q.Walk:Perf()
    t.eq(p.searches, 2)
    t.ok(p.worstMs >= 0)
    t.ok(p.avgMs >= 0)
    t.ok(p.frames > 0, "frames counted")
    t.eq(p.memKB.Questify, 2048)
    t.eq(p.memKB.Questify_Nav, 9000)
    Q.Walk:ResetPerf()
    p = Q.Walk:Perf()
    t.eq(p.searches, 0)
    t.eq(p.frames, 0)
    t.eq(p.worstMs, 0)
    t.eq(#Mock.errors, 0)
  end,

  -- Budget par image : deux mesures dans la même image n'en font qu'une (leur somme) ; une mesure
  -- imbriquée dans une autre n'est comptée qu'une fois.
  perf_per_frame = function(t)
    local Q = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local job = finds()[1]
    Mock.advance(1)
    Q.Walk:ResetPerf()
    local orig = Q.Maps.PlayerPos
    local slow = function(...) Mock.cpuMs = Mock.cpuMs + 3; return orig(...) end
    -- un abonné de NAV_ROUTE (appelé dans le rappel mesuré) lit la route : mesure imbriquée
    Q:On("NAV_ROUTE", function()
      Mock.cpuMs = Mock.cpuMs + 2
      Q.Maps.PlayerPos = slow
      Q.Walk:Route()
      Q.Maps.PlayerPos = orig
    end)
    Mock.navEngine.resolve(job, { world(Q, ELWYNN, 40, 50), world(Q, ELWYNN, 45, 50), world(Q, ELWYNN, 60, 50) })
    Mock.advance(0.1)
    local p = Q.Walk:Perf()
    t.eq(p.frames, 1, "one frame")
    t.near(p.worstMs, 5, 1e-6, "nested Route counted once: 2 + 3 ms")
    -- deux lectures dans une même image : une image, la somme
    Q.Walk:ResetPerf()
    Q.Maps.PlayerPos = slow
    Q.Walk:Route()
    Q.Walk:Route()
    Q.Maps.PlayerPos = orig
    Mock.advance(0.1)
    p = Q.Walk:Perf()
    t.eq(p.frames, 1)
    t.near(p.worstMs, 6, 1e-6, "3 + 3 ms in one frame")
    t.near(p.avgMs, 6, 1e-6)
    t.eq(#Mock.errors, 0)
  end,

  -- Cartes livrées entières (pas de champ part) : aucune partie chargée.
  whole_data_loads_no_part = function(t)
    local Q = load()
    Mock.onLoadAddOn.Questify_Nav = function()
      Mock.navEngine = Mock.newNavEngine()
      Questify_NavEngine = Mock.navEngine
      QuestifyPathData = { [0] = {} }
    end
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    t.eq(loads(), { "Questify_Nav" })
    t.eq(Q.Walk:Status().maps[0], true)
    t.eq(#finds(), 1)
    t.eq(#Mock.errors, 0)
  end,

  navperf_command = function(t)
    local Q = load()
    routeEast(Q)
    SlashCmdList.QUESTIFY("navperf")
    t.ok(Mock.printed(Q.L.UI_NAVPERF:sub(1, 12)), "counters printed")
    SlashCmdList.QUESTIFY("navperf reset")
    t.ok(Mock.printed(Q.L.UI_NAVPERF_RESET))
    t.eq(Q.Walk:Perf().searches, 0)
    t.eq(#Mock.errors, 0)
  end,

  loading_screen_cancel = function(t)
    local Q, routes = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local job = finds()[1]
    local before = #routes
    Mock.fire("PLAYER_ENTERING_WORLD", false, false)
    t.eq(job.cancelled, true, "search cancelled")
    t.eq(routes[before + 1], false, "NAV_ROUTE nil")
    t.eq(Q.Walk:Route(), nil)
    Mock.advance(1.1)
    t.eq(#finds(), 2, "new search")
    t.ok(routes[#routes], "then a new route")
    t.ok(Q.Walk:Route(), "route again")
    t.eq(#Mock.errors, 0)
  end,

  other_router_no_route = function(t)
    local Q, routes = load()
    routeEast(Q)
    t.ok(Q.Walk:Route())
    Q.Settings:Set("nav.router", "none")
    t.eq(Q.Walk:Route(), nil, "route cleared")
    t.eq(routes[#routes], false)
    Q.Nav:SetTarget(ELWYNN, 70, 50, "Far")
    Mock.advance(2)
    t.eq(#finds(), 1, "no search for another router")
    t.eq(Q.Walk:Route(), nil)
    Q.Settings:Set("nav.router", "questify")
    Mock.advance(1.1)
    t.eq(#finds(), 2, "back to Questify: search again")
    t.eq(#Mock.errors, 0)
  end,

  clear_target_clears_route = function(t)
    local Q, routes = load()
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    local job = finds()[1]
    Q.Nav:Clear()
    t.eq(job.cancelled, true)
    t.eq(Q.Walk:Route(), nil)
    t.eq(routes[#routes], false)
    t.eq(#Mock.errors, 0)
  end,

  no_load_in_combat = function(t)
    local Q = load()
    Mock.player.combat = true
    Q.Nav:SetTarget(ELWYNN, 60, 50, "East")
    t.eq(loads(), {}, "no addon loaded in combat")
    t.eq(Q.Walk:Route().straight, true, "straight meanwhile")
    t.eq(Q.Walk:Status().reason, "combat")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    Mock.advance(1.1)
    t.eq(loads(), { "Questify_Nav", "Questify_Nav_EK" })
    t.eq(#finds(), 1)
    t.eq(#Mock.errors, 0)
  end,

  -- Cible dans une grotte (Nav:CavePlan) : on marche d'abord jusqu'à l'entrée ; dans la grotte de la
  -- cible, flèche directe sans calcul.
  cave_stop_goal = function(t)
    local Q = load()
    local plan = { stops = { { mapId = ELWYNN, x = 55, y = 50, kind = "enter" } }, direct = false }
    Q.Nav.CavePlan = function() return plan end
    Q.Nav:SetTarget(ELWYNN, 60, 50, "Den")
    t.near(finds()[1].to.y, world(Q, ELWYNN, 55, 50).y, 0.01, "to the cave entrance")
    plan = { stops = {}, direct = true }
    Mock.advance(1.1)
    local r = Q.Walk:Route()
    t.eq(r.straight, true)
    t.eq(r.reason, "cave")
    t.eq(finds()[1].cancelled, true)
    t.eq(#finds(), 1, "no search inside the cave")
    samePoint(t, r.nextPoint, world(Q, ELWYNN, 60, 50), "straight to the target")
    t.eq(#Mock.errors, 0)
  end,

  -- Voyage en plusieurs trajets : seul le trajet à pied en cours est calculé ; le vol est montré tel
  -- quel ; à son arrivée, la marche suivante est calculée.
  legs_advance = function(t)
    local Q, routes = load()
    local legs = {
      { kind = "walk", from = { mapId = ELWYNN, x = 40, y = 50 }, to = { mapId = ELWYNN, x = 45, y = 50 } },
      { kind = "fly", from = { mapId = ELWYNN, x = 45, y = 50 }, to = { mapId = 1436, x = 50, y = 50 } },
      { kind = "walk", from = { mapId = 1436, x = 50, y = 50 }, to = { mapId = 1436, x = 60, y = 50 } },
    }
    Q.Travel.Plan = function() return legs end
    Q.Nav:SetTarget(1436, 60, 50, "Far")
    t.eq(#finds(), 1)
    t.near(finds()[1].to.y, world(Q, ELWYNN, 45, 50).y, 0.01, "walk to the flight master")
    t.eq(Q.Walk:Route().leg, 1)
    Mock.player.x = 45
    Mock.advance(1.1)
    local r = Q.Walk:Route()
    t.eq(r.leg, 2, "flight")
    t.eq(r.straight, false)
    t.eq(#r.path, 2, "shown as it is")
    t.eq(finds()[1].cancelled, true)
    t.eq(#finds(), 1, "no search for a flight")
    t.eq(routes[#routes], r, "announced")
    Mock.player.map, Mock.player.x, Mock.player.y = 1436, 50, 50
    Mock.advance(1.1)
    t.eq(Q.Walk:Route().leg, 3)
    t.eq(#finds(), 2, "the last walk is searched")
    t.near(finds()[2].to.y, world(Q, 1436, 60, 50).y, 0.01)
    t.eq(#Mock.errors, 0)
  end,

  diagnostics_report_walk = function(t)
    local Q = load()
    local function walkCheck()
      for _, r in ipairs(Q.Diagnostics:Run()) do if r.id == "walk" then return r end end
    end
    t.eq(walkCheck().status, "info", "not loaded yet")
    routeEast(Q)
    local r = walkCheck()
    t.eq(r.status, "ok")
    t.ok(r.detail:find("Eastern Kingdoms", 1, true), r.detail)
    t.eq(#Mock.errors, 0)
  end,
}
