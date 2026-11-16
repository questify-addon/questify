-- Tests de la navigation (Q.Nav) : fournisseurs, repli, déduplication, combat.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

-- Charge l'addon ; `settings` est appliqué avant la connexion, donc avant la première cible.
-- opts.onLoad(Q) : appelé au même moment (abonnement à un message avant la première cible).
local function load(settings, opts)
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  local onLoad = opts.onLoad
  opts.beforeLogin = function(Q)
    for path, value in pairs(settings or {}) do Q.Settings:Set(path, value) end
    if onLoad then onLoad(Q) end
  end
  return Mock.loadAddon(TOC, opts)
end

-- Affichage « Repère du jeu » (l'ancien défaut) : les tests du repère natif.
local function loadNative(settings, opts)
  local s = { ["nav.display"] = "native" }
  for k, v in pairs(settings or {}) do s[k] = v end
  return load(s, opts)
end

-- Charge l'addon en notant chaque NAV_TARGET (false pour un retrait).
local function loadWatching(settings)
  local seen = {}
  local Q = load(settings, { onLoad = function(Q)
    Q:On("NAV_TARGET", function(target) seen[#seen + 1] = target or false end)
  end })
  return Q, seen
end

-- Profil enregistré d'une version précédente (réglages `nav` donnés).
local function loadSavedNav(nav)
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES }, savedVariables = {
    QuestifyDB = { profiles = { Default = { settings = { nav = nav } } } } } })
end

local function useGuide(Q, id, steps)
  Q:RegisterGuide({ id = id, faction = "Alliance", minLevel = 1, maxLevel = 60, steps = steps })
  Q.Progress:SetGuide(id)
end

local function accept179()
  Mock.quests.log[179] = { complete = false, objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
  Mock.fire("QUEST_ACCEPTED", 179)
end

-- Aucune erreur venue de notre fichier (les erreurs des autres flux ne nous concernent pas).
local function noNavErrors(t)
  for _, e in ipairs(Mock.errors) do
    t.ok(not tostring(e):find("Navigation.lua", 1, true), "Navigation error: " .. tostring(e))
  end
end

return {
  -- Défaut : routeur Questify et flèche Questify. Navigation pose la cible et l'annonce (NAV_TARGET) ;
  -- la flèche ne pose rien chez un autre addon ni dans le jeu.
  questify_by_default = function(t)
    local Q, seen = loadWatching()
    local router, display = Q.Nav:Active()
    t.eq(router, "questify"); t.eq(display, "arrow")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0, "no game pin")
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 0)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), 0)
    t.eq(#seen, 1, "target announced at login")
    t.eq(seen[1].mapId, 1426); t.eq(seen[1].x, 29.93); t.eq(seen[1].y, 71.2)
    t.ok(seen[1].title:find("Dwarven Outfitters", 1, true), "step title")
    local st = Q.Nav:Status()
    t.eq(st.provider, "arrow"); t.eq(st.wanted, "arrow")
    Q.Nav:SetTarget(1426, 29.93, 71.2, seen[1].title)   -- même cible : pas de nouvelle annonce
    t.eq(#seen, 1)
    accept179()                                          -- autre étape, autre cible
    t.eq(#seen, 2)
    t.ok(seen[2] and seen[2].title ~= seen[1].title, "new target announced")
    Q.Nav:Clear()
    t.eq(seen[3], false, "removal announced")
    Q.Nav:Clear()
    t.eq(#seen, 3, "nothing left to remove")
    noNavErrors(t)
  end,

  -- Routeur Questify sans le dossier Questify_Nav : pas de calcul, l'affichage reste.
  questify_router_needs_questify_nav = function(t)
    Mock.addons.Questify_Nav = false
    local Q = load()
    t.eq(Q.Nav:Detect().questify, false)
    local router, display = Q.Nav:Active()
    t.eq(router, nil); t.eq(display, "arrow")
    noNavErrors(t)
  end,

  -- Routeur Questify, affichage TomTom : TomTom reçoit le prochain virage, ici la cible (calcul en cours).
  questify_with_tomtom_display = function(t)
    Mock.addons.TomTom = true
    local Q, seen = loadWatching({ ["nav.router"] = "questify", ["nav.display"] = "tomtom" })
    local router, display = Q.Nav:Active()
    t.eq(router, "questify"); t.eq(display, "tomtom")
    local add = Mock.callsTo("TomTom:AddWaypoint")
    t.eq(#add, 1)
    t.eq(add[1].args[1], 1426); t.near(add[1].args[2], 0.2993, 0.001); t.near(add[1].args[3], 0.712, 0.001)
    t.eq(#seen, 1, "target announced too")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    noNavErrors(t)
  end,

  -- Sans routeur : comportement d'avant (affichage seul).
  router_none = function(t)
    local Q = load({ ["nav.router"] = "none", ["nav.display"] = "native" })
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1, "game pin only")
    local router, display = Q.Nav:Active()
    t.eq(router, nil); t.eq(display, "native")
    -- flèche sans routeur : rien n'est posé ailleurs
    Mock.reset()
    local Q2 = load({ ["nav.router"] = "none" })
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    router, display = Q2.Nav:Active()
    t.eq(router, nil); t.eq(display, "arrow")
    noNavErrors(t)
  end,

  -- SPF calcule et dessine : la flèche Questify n'apparaît pas, SPF a le repère du jeu (ou WaypointUI).
  spf_with_arrow_display_uses_the_game_pin = function(t)
    Mock.addons.ShortestPathForever = true
    local Q = load({ ["nav.router"] = "spf" })
    local router, display = Q.Nav:Active()
    t.eq(router, "shortestpath"); t.eq(display, "native")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 1)
    noNavErrors(t)
  end,

  -- Position de la flèche, style de ligne… : la cible posée ne bouge pas (TomTom ne la repose pas).
  other_nav_settings_do_not_repost = function(t)
    Mock.addons.TomTom = true
    local Q, seen = loadWatching({ ["nav.display"] = "tomtom" })
    Q.Settings:Set("nav.arrowPos", { "CENTER", "CENTER", 10, 20 })
    Q.Settings:Set("nav.lineStyle", "solid")
    Q.Settings:Set("nav.routeStyle", "roads")
    Q.Settings:Set("nav.arrowLocked", true)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 1)
    t.eq(Mock.countCalls("TomTom:RemoveWaypoint"), 0)
    t.eq(#seen, 1)
    noNavErrors(t)
  end,

  -- Routeur changé en cours d'étape : la cible est annoncée de nouveau pour le routeur qui prend la main.
  router_switch_reannounces = function(t)
    Mock.addons.ShortestPathForever = true
    local Q, seen = loadWatching({ ["nav.router"] = "spf" })
    t.eq(#seen, 1)
    Q.Settings:Set("nav.router", "questify")
    t.eq(#seen, 2, "announced again")
    t.eq(seen[2].mapId, seen[1].mapId); t.eq(seen[2].x, seen[1].x); t.eq(seen[2].y, seen[1].y)
    t.eq(seen[2].title, seen[1].title)
    t.eq((Q.Nav:Active()), "questify")
    Q.Settings:Set("nav.display", "native")   -- affichage seul : pas de nouvelle annonce
    t.eq(#seen, 2)
    Q.Nav:Clear()
    Q.Settings:Set("nav.router", "none")      -- pas de cible : rien à annoncer
    t.eq(#seen, 3); t.eq(seen[3], false)
    noNavErrors(t)
  end,

  defaults = function(t)
    local Q = load()
    t.eq(Q.Settings:Get("nav.router"), "questify")
    t.eq(Q.Settings:Get("nav.display"), "arrow")
    t.eq(Q.Settings:Get("nav.routeStyle"), "safe")
    t.eq(Q.Settings:Get("nav.lineStyle"), "dots")
    t.eq(Q.Settings:Get("nav.arrowLocked"), false)
    t.eq(Q.Settings:Get("nav.arrowPos"), nil)
    t.eq(Q.Settings:Get("nav.routing"), nil, "old setting gone")
  end,

  -- Migration (une fois par profil) : SPF choisi reste SPF, son affichage reste.
  migrate_spf_profile = function(t)
    local Q = loadSavedNav({ routing = true, display = "tomtom" })
    t.eq(Q.Settings:Get("nav.router"), "spf")
    t.eq(Q.Settings:Get("nav.display"), "tomtom")
    local nav = QuestifyDB.profiles.Default.settings.nav
    t.eq(nav.routing, nil, "old setting removed")
    t.eq(nav.migrated, 1)
  end,

  -- `routing = false` venait de l'assistant chez les joueurs sans SPF ; « Repère du jeu » était le défaut.
  migrate_wizard_false = function(t)
    local Q = loadSavedNav({ routing = false, display = "native" })
    t.eq(Q.Settings:Get("nav.router"), "questify")
    t.eq(Q.Settings:Get("nav.display"), "arrow")
    t.eq(QuestifyDB.profiles.Default.settings.nav.routing, nil)
    -- une seule fois : un « Repère du jeu » choisi après la migration reste
    Q.Settings:Set("nav.display", "native")
    local Q2 = Mock.reload()
    t.eq(Q2.Settings:Get("nav.display"), "native", "migrated once")
    t.eq(Q2.Settings:Get("nav.router"), "questify")
  end,

  -- Ancien défaut « Repère du jeu » passé à la flèche : le repère laissé par l'ancienne version est
  -- retiré une fois par personnage, à la connexion.
  migrated_native_pin_cleared_once = function(t)
    local Q = loadSavedNav({ routing = false, display = "native" })
    t.eq(Q.Settings:Get("nav.display"), "arrow")
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "old game pin removed")
    t.eq(Q.char.navPinCleared, true)
    Mock.reload()
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "once per character")
    -- autre affichage gardé : son repère reste
    Mock.reset()
    Mock.addons.TomTom = true
    loadSavedNav({ routing = false, display = "tomtom" })
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 0)
    noNavErrors(t)
  end,

  -- Tous les profils, et les réglages d'avant les profils (QuestifyDB.settings).
  migrate_every_profile = function(t)
    local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, savedVariables = {
      QuestifyDB = { settings = { nav = { routing = true } } } } })
    t.eq(Q.Settings:Get("nav.router"), "spf")
    t.eq(Q.Settings:Get("nav.display"), "arrow", "absent display: the new default")
    Mock.reset()
    Mock.loadAddon(TOC, { extraFiles = { GUIDES }, savedVariables = {
      QuestifyDB = { profiles = { Default = { settings = {} },
        Raid = { settings = { nav = { routing = true, display = "native" } } } } } } })
    local raid = QuestifyDB.profiles.Raid.settings.nav
    t.eq(raid.router, "spf"); t.eq(raid.display, "arrow"); t.eq(raid.routing, nil); t.eq(raid.migrated, 1)
  end,

  native_display = function(t)
    local Q = loadNative()
    local calls = Mock.callsTo("C_Map.SetUserWaypoint")
    t.eq(#calls, 1, "one native waypoint at login")
    local point = calls[1].args[1]
    t.eq(point.uiMapID, 1426)
    t.near(point.position.x, 0.2993, 0.001)
    t.near(point.position.y, 0.712, 0.001)
    t.eq(Mock.lastCall("C_SuperTrack.SetSuperTrackedUserWaypoint").args[1], true)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 0)
    noNavErrors(t)
  end,

  tomtom_replaces_previous = function(t)
    Mock.addons.TomTom = true
    local Q = load({ ["nav.display"] = "tomtom" })
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 1, "first step")
    t.eq(Mock.countCalls("TomTom:RemoveWaypoint"), 0)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0, "no native marker")
    local first = Mock.lastCall("TomTom:AddWaypoint").args
    t.eq(first[1], 1426); t.near(first[2], 0.2993, 0.001); t.near(first[3], 0.712, 0.001)
    t.eq(first[4].crazy, true); t.eq(first[4].persistent, false)
    t.ok(first[4].title:find("Dwarven Outfitters", 1, true), "title")
    accept179()   -- l'étape courante devient « complete 179 » : autre cible
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 2)
    local removed = Mock.callsTo("TomTom:RemoveWaypoint")
    t.eq(#removed, 1)
    t.eq(removed[1].args[1].uid, 1, "the previous uid is removed")
    noNavErrors(t)
  end,

  waypointui_uses_0_100 = function(t)
    Mock.addons.WaypointUI = true
    local Q = load({ ["nav.display"] = "waypointui" })
    local call = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation")
    t.ok(call, "WaypointUI called")
    local arg = call.args[1]
    t.eq(arg.x, 29.93); t.eq(arg.y, 71.2); t.eq(arg.mapID, 1426)
    t.ok(arg.name:find("Dwarven Outfitters", 1, true), "name")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
  end,

  -- Repère du jeu avec WaypointUI chargé : posé par WaypointUI, qui affiche le titre de l'étape
  -- au lieu de « Repère cartographique ».
  native_with_waypointui_names_the_pin = function(t)
    Mock.addons.WaypointUI = true
    local Q = loadNative()
    local call = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation")
    t.ok(call, "WaypointUI called")
    local arg = call.args[1]
    t.eq(arg.mapID, 1426); t.eq(arg.x, 29.93); t.eq(arg.y, 71.2)
    t.ok(arg.name:find("Dwarven Outfitters", 1, true), "step title as name")
    t.eq(arg.suppressAudio, true, "no sound on every target update")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0, "WaypointUI sets the game pin itself")
    t.eq(select(2, Q.Nav:Active()), "native")
    accept179()   -- autre étape, autre titre
    t.ok(Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1].name ~= arg.name, "renamed")
    Q.Nav:Clear()
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.ClearUserNavigation"), 1)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1)
    noNavErrors(t)
  end,

  native_with_waypointui_refused_map = function(t)
    Mock.addons.WaypointUI = true
    local Q = loadNative()
    Q.Nav:SetTarget(99999, 10, 10, "Nowhere")   -- carte sans repère possible : WaypointUI renvoie nil
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.ClearUserNavigation"), 1, "old named pin removed")
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "no stale marker left")
    noNavErrors(t)
  end,

  -- Affichage choisi absent : la flèche Questify le remplace (pas le repère du jeu).
  missing_provider_falls_back_arrow = function(t)
    local Q = load({ ["nav.display"] = "tomtom" })
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 0)
    local routing, display = Q.Nav:Active()
    t.eq(routing, "questify"); t.eq(display, "arrow")
    -- WaypointUI absent : même repli
    Mock.reset()
    local Q2 = load({ ["nav.display"] = "waypointui" })
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    t.eq(select(2, Q2.Nav:Active()), "arrow")
    -- avec SPF, qui calcule : le repère du jeu (la flèche ne suit pas ses trajets)
    Mock.reset()
    Mock.addons.ShortestPathForever = true
    local Q3 = load({ ["nav.router"] = "spf", ["nav.display"] = "tomtom" })
    t.eq(select(2, Q3.Nav:Active()), "native")
  end,

  shortestpath_retries_after_combat = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.navigateResult = false
    local Q = load({ ["nav.router"] = "spf" })
    local first = Mock.callsTo("ShortestPathForever.API.Navigate")
    t.eq(#first, 1, "refused in combat")
    local a = first[1].args
    t.eq(a[1], "Questify"); t.eq(a[2], 1426)
    t.near(a[3], 0.2993, 0.0001); t.near(a[4], 0.712, 0.0001)
    t.ok(a[5]:find("Dwarven Outfitters", 1, true), "title"); t.eq(a[6], "quest")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0, "ShortestPath only")
    Mock.navigateResult = true
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 2, "retried once")
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 2, "nothing left to retry")
    noNavErrors(t)
  end,

  shortestpath_retry_is_only_once = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.navigateResult = false
    local Q = load({ ["nav.router"] = "spf" })
    Mock.fire("PLAYER_REGEN_ENABLED")
    Mock.fire("PLAYER_REGEN_ENABLED")
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 2, "one retry, no more")
  end,

  shortestpath_does_nothing_else = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.addons.TomTom = true
    local Q = load({ ["nav.router"] = "spf", ["nav.display"] = "tomtom" })
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 1)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 0, "ShortestPath handles the display")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 0)
    local routing, display = Q.Nav:Active()
    t.eq(routing, "shortestpath"); t.eq(display, "tomtom")
  end,

  -- Calcul ShortestPath + WaypointUI : une navigation WaypointUI nommée est lancée d'abord, pour que
  -- ShortestPath lui confie ses virages (avec le nom) au lieu de poser des repères sans nom.
  shortestpath_seeds_a_named_waypointui_navigation = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    local Q = load({ ["nav.router"] = "spf", ["nav.display"] = "waypointui" })
    local seed = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation")
    t.ok(seed, "WaypointUI navigation started")
    t.ok(seed.args[1].name:find("Dwarven Outfitters", 1, true), "named after the step")
    t.eq(seed.args[1].suppressAudio, true)
    t.eq(seed.args[1].mapID, 1426); t.eq(seed.args[1].x, 29.93); t.eq(seed.args[1].y, 71.2)
    local nav = Mock.lastCall("ShortestPathForever.API.Navigate")
    t.ok(nav, "ShortestPath still computes the route")
    local pos = {}
    for i, c in ipairs(Mock.calls) do pos[c] = i end
    t.ok(pos[seed] < pos[nav], "seeded before the route starts")
    Q.Nav:Clear()
    t.eq(Mock.countCalls("ShortestPathForever.API.Cancel"), 1)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.ClearUserNavigation"), 1)
    noNavErrors(t)

    -- affichage « Repère du jeu » : même chose ; TomTom : rien chez WaypointUI
    Mock.reset()
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    load({ ["nav.router"] = "spf" })
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), 1)
    Mock.reset()
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    Mock.addons.TomTom = true
    load({ ["nav.router"] = "spf", ["nav.display"] = "tomtom" })
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), 0)
  end,

  -- ShortestPath confie ses virages à WaypointUI en coordonnées 0-1, que l'API de WaypointUI lit en 0-100 :
  -- le virage tombait au coin nord-ouest de la carte (« Trajet vers … 2129 yds » pour un PNJ à 65 yd).
  -- Avec les deux addons, NewUserNavigation est enveloppée : 0-1 converti, 0-100 inchangé.
  waypointui_input_scaled_for_shortestpath_turns = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    local Q = load({ ["nav.router"] = "spf" })
    local nav = WaypointUIAPI.Navigation
    -- le virage tel que ShortestPath le transmet (C_Map, 0-1)
    local res = nav.NewUserNavigation({ name = "Trajet vers Rejold", mapID = 1426, x = 0.3019, y = 0.4573 })
    local call = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1]
    t.near(call.x, 30.19, 0.0001); t.near(call.y, 45.73, 0.0001)
    t.eq(call.name, "Trajet vers Rejold"); t.eq(call.mapID, 1426)
    t.ok(res, "WaypointUI's return value passed through")
    -- un appel en 0-100 (le nôtre, ou un autre addon) passe tel quel
    nav.NewUserNavigation({ name = "Camp", mapID = 1426, x = 22.6, y = 71.4 })
    call = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1]
    t.eq(call.x, 22.6); t.eq(call.y, 71.4)
    -- enveloppée une seule fois, même après d'autres cibles
    local wrapped = nav.NewUserNavigation
    Q.Nav:SetTarget(1426, 22.6, 71.4, "Camp")
    t.eq(nav.NewUserNavigation, wrapped, "not wrapped twice")
    -- la navigation nommée de Questify reste en 0-100
    t.eq(Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1].x, 22.6)
    noNavErrors(t)
  end,

  -- Les virages de ShortestPath passent en silence (WaypointUI sonnait à chaque virage), et un virage
  -- identique au précédent, que WaypointUI suit encore, n'est pas reposé.
  shortestpath_turns_are_silent_and_not_repeated = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    load({ ["nav.router"] = "spf" })
    local nav = WaypointUIAPI.Navigation
    local current
    nav.IsUserNavigationTracked = function() return current ~= nil end
    nav.GetUserNavigation = function() return current end
    local function turn(x, y)
      return nav.NewUserNavigation({ name = "Trajet vers Rejold", mapID = 1426, x = x, y = y })
    end
    local before = Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation")
    current = turn(0.3019, 0.4573)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), before + 1)
    t.eq(Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1].suppressAudio, true, "silent")
    local same = turn(0.3019, 0.4573)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), before + 1, "same turn not re-placed")
    t.eq(same, current, "current navigation returned")
    current = turn(0.3050, 0.4600)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), before + 2, "next turn placed")
    current = nil                                -- WaypointUI ne suit plus rien : le même virage repasse
    turn(0.3050, 0.4600)
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), before + 3)
    noNavErrors(t)
  end,

  -- WaypointUI suit déjà une navigation (un virage, ou le repère du jeu qu'il adopte) : à chaque nouvelle
  -- cible, Questify ne repose pas la sienne avant le calcul (le repère sautait cible -> virage).
  shortestpath_does_not_reseed_a_tracking_waypointui = function(t)
    Mock.addons.ShortestPathForever = true
    Mock.addons.WaypointUI = true
    load({ ["nav.router"] = "spf" })
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), 1, "first target: seeded")
    WaypointUIAPI.Navigation.IsUserNavigationTracked = function() return true end
    local navs = Mock.countCalls("ShortestPathForever.API.Navigate")
    accept179()                                   -- nouvelle cible
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), navs + 1, "routed to the new target")
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.NewUserNavigation"), 1, "not re-seeded")
    noNavErrors(t)
  end,

  -- WaypointUI seul (sans ShortestPath) : son API n'est pas touchée.
  waypointui_untouched_without_shortestpath = function(t)
    Mock.addons.WaypointUI = true
    load()
    WaypointUIAPI.Navigation.NewUserNavigation({ name = "Corner", mapID = 1426, x = 0.5, y = 0.5 })
    local call = Mock.lastCall("WaypointUIAPI.Navigation.NewUserNavigation").args[1]
    t.eq(call.x, 0.5); t.eq(call.y, 0.5)
  end,

  -- SPF choisi mais absent : le routeur Questify le remplace (s'il est installé), sinon aucun.
  routing_without_shortestpath_falls_back_questify = function(t)
    local Q = loadNative({ ["nav.router"] = "spf" })
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1)
    t.eq((Q.Nav:Active()), "questify")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 0)
    Mock.reset()
    Mock.addons.Questify_Nav = false
    local Q2 = loadNative({ ["nav.router"] = "spf" })
    t.eq((Q2.Nav:Active()), nil)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1)
  end,

  -- Routeur Questify, affichage TomTom : TomTom reçoit le prochain virage du trajet (en point de
  -- carte, titre de l'étape), reposé seulement quand il bouge de plus de 12 yd.
  questify_router_turns_to_display = function(t)
    Mock.addons.TomTom = true
    Mock.addons.Questify_Nav = "demand"
    Mock.player.map, Mock.player.x, Mock.player.y = 1429, 40, 50
    local Q = load({ ["nav.display"] = "tomtom" })
    Q.Nav:SetTarget(1429, 60, 50, "East")
    local add = Mock.callsTo("TomTom:AddWaypoint")
    local before = #add
    t.eq(add[before].args[1], 1429); t.near(add[before].args[2], 0.60, 0.001, "straight: the target")
    Mock.advance(1.1)                           -- calcul lancé (un par seconde)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), before, "same turn while computing")
    local job = Mock.navEngine.finds[#Mock.navEngine.finds]
    local function w(x, y) local c, X, Y = Q.Maps:WorldPos(1429, x, y); return { map = c, x = X, y = Y } end
    Mock.navEngine.resolve(job, { w(40, 50), w(45, 50), w(60, 50) }, 700)
    add = Mock.callsTo("TomTom:AddWaypoint")
    t.eq(#add, before + 1, "next turn posted")
    local a = add[#add].args
    t.eq(a[1], 1429); t.near(a[2], 0.45, 0.0001); t.near(a[3], 0.50, 0.0001)
    t.eq(a[4].title, "East", "step title")
    Mock.player.x = 40.2                        -- 7 yd : même virage
    Mock.advance(1)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), before + 1, "not reposted")
    Mock.player.x = 45.2                        -- virage passé : la cible
    Mock.advance(1)
    add = Mock.callsTo("TomTom:AddWaypoint")
    t.eq(#add, before + 2, "next turn")
    t.near(add[#add].args[2], 0.60, 0.0001)
    Mock.advance(3)
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), before + 2, "throttled")
    noNavErrors(t)
  end,

  -- Repère du jeu : le virage du trajet en cours, puis celui du trajet suivant.
  questify_router_turns_to_native = function(t)
    Mock.addons.Questify_Nav = "demand"
    Mock.player.map, Mock.player.x, Mock.player.y = 1429, 40, 50
    local Q = loadNative()
    Q.Travel.Plan = function() return {
      { kind = "walk", from = { mapId = 1429, x = 40, y = 50 }, to = { mapId = 1429, x = 45, y = 50 } },
      { kind = "fly", from = { mapId = 1429, x = 45, y = 50 }, to = { mapId = 1436, x = 50, y = 50 } },
    } end
    Q.Nav:SetTarget(1436, 50, 50, "Far")
    local p = Mock.lastCall("C_Map.SetUserWaypoint").args[1]
    t.eq(p.uiMapID, 1429, "flight master first"); t.near(p.position.x, 0.45, 0.0001)
    local before = Mock.countCalls("C_Map.SetUserWaypoint")
    Mock.player.x = 45
    Mock.advance(1.1)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 1, "flight leg")
    p = Mock.lastCall("C_Map.SetUserWaypoint").args[1]
    t.eq(p.uiMapID, 1436, "at the flight master: the landing"); t.near(p.position.x, 0.50, 0.0001)
    t.near(p.position.y, 0.50, 0.0001)
    noNavErrors(t)
  end,

  dedupe_same_target = function(t)
    local Q = loadNative()
    local before = Mock.countCalls("C_Map.SetUserWaypoint")
    Q.Nav:SetTarget(1426, 22.6, 71.4, "Camp")
    Q.Nav:SetTarget(1426, 22.6, 71.4, "Camp")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 1, "same target once")
    Q.Nav:SetTarget(1426, 22.61, 71.4, "Camp")   -- même dixième
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 1, "rounded to 0.1")
    Q.Nav:SetTarget(1426, 22.8, 71.4, "Camp")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 2, "moved by 0.2")
    Q.Nav:SetTarget(1426, 22.8, 71.4, "Other title")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 3, "new title")
    Q.Nav:SetTarget(1432, 22.8, 71.4, "Other title")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 4, "new map")
  end,

  clear_clears_the_provider_in_use = function(t)
    local Q = loadNative()
    Q.Nav:Clear()
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1)
    Q.Nav:Clear()
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "nothing left to clear")

    Mock.reset()
    Mock.addons.TomTom = true
    local Q2 = load({ ["nav.display"] = "tomtom" })
    Q2.Nav:Clear()
    t.eq(Mock.countCalls("TomTom:RemoveWaypoint"), 1)

    Mock.reset()
    Mock.addons.WaypointUI = true
    local Q3 = load({ ["nav.display"] = "waypointui" })
    Q3.Nav:Clear()
    t.eq(Mock.countCalls("WaypointUIAPI.Navigation.ClearUserNavigation"), 1)

    Mock.reset()
    Mock.addons.ShortestPathForever = true
    local Q4 = load({ ["nav.router"] = "spf" })
    Q4.Nav:Clear()
    local cancel = Mock.lastCall("ShortestPathForever.API.Cancel")
    t.ok(cancel and cancel.args[1] == "Questify", "Cancel(owner)")
  end,

  clears_when_there_is_no_current_step = function(t)
    local Q = loadNative()
    -- guide vide : plus d'étape courante
    useGuide(Q, "empty", { { "level", 1 } })
    t.eq(Q.Progress:Current(), nil)
    t.ok(Mock.countCalls("C_Map.ClearUserWaypoint") >= 1, "cleared")
    local sets = Mock.countCalls("C_Map.SetUserWaypoint")
    Q.Nav:Refresh()
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), sets)
  end,

  step_without_target_clears = function(t)
    local Q = loadNative()
    useGuide(Q, "t_note", { { "note", "Read this" }, { "accept", 179 } })
    t.eq(Q.Progress:Current().step.action, "note")
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "a note has no target")
  end,

  settings_change_switches_provider = function(t)
    Mock.addons.TomTom = true
    local Q = loadNative()
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 1)
    Q.Settings:Set("nav.display", "tomtom")
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "old provider cleared")
    t.eq(Mock.countCalls("TomTom:AddWaypoint"), 1, "target re-applied")
    Q.Settings:Set("nav.display", "native")
    t.eq(Mock.countCalls("TomTom:RemoveWaypoint"), 1)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 2)
    Q.Settings:Set("tracker.locked", true)   -- réglage étranger : rien ne bouge
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 2)
    noNavErrors(t)
  end,

  settings_change_enables_routing = function(t)
    Mock.addons.ShortestPathForever = true
    local Q = loadNative()
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 0)
    Q.Settings:Set("nav.router", "spf")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 1)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "native marker removed")
    Q.Settings:Set("nav.router", "questify")
    t.eq(Mock.countCalls("ShortestPathForever.API.Cancel"), 1)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 2)
    Q.Settings:Set("nav.router", "none")
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), 3, "re-applied after the change")
    t.eq(Mock.countCalls("ShortestPathForever.API.Navigate"), 1)
  end,

  detect_lists_installed_providers = function(t)
    local Q = load()
    t.eq(Q.Nav:Detect(), { questify = true, shortestpath = false, waypointui = false, tomtom = false, native = true })
    Mock.reset()
    Mock.addons.TomTom = true
    Mock.addons.ShortestPathForever = true
    local Q2 = load()
    t.eq(Q2.Nav:Detect(), { questify = true, shortestpath = true, waypointui = false, tomtom = true, native = true })
    t.eq(Q2.Nav:ProviderLabel("native"), "Built-in waypoint")
    t.eq(Q2.Nav:ProviderLabel("arrow"), "Questify arrow")
    t.eq(Q2.Nav:ProviderLabel("questify"), "Questify Nav")
  end,

  -- Questify_Nav est chargé à la demande : installé et activé suffit (pas encore chargé).
  detect_questify_nav_on_demand = function(t)
    Mock.addons.Questify_Nav = "demand"
    local Q = load()
    t.eq(Q.Nav:Detect().questify, true)
    t.eq((Q.Nav:Active()), "questify")
    Mock.reset()
    Mock.addons.Questify_Nav = "disabled"
    local Q2 = load()
    t.eq(Q2.Nav:Detect().questify, false)
  end,

  strings_nav_in_both_languages = function(t)
    local captured
    local fake = { RegisterStrings = function(_, tables) captured = tables end }
    assert(loadfile(Mock.root .. "/Questify/Locales/StringsNav.lua"))("Questify", fake)
    for k in pairs(captured.enUS) do t.ok(captured.frFR[k], "frFR has " .. k) end
    for k in pairs(captured.frFR) do t.ok(captured.enUS[k], "enUS has " .. k) end
    t.eq(captured.frFR.NAV_ROUTER_QUESTIFY, "Questify (intégré)")
    t.eq(captured.frFR.UI_NAV_ARROW, "Flèche Questify")
  end,

  step_target_follows_the_current_step = function(t)
    local Q = loadNative()
    accept179()
    local call = Mock.lastCall("C_Map.SetUserWaypoint").args[1]
    -- cible du « complete 179 » : un loup, pas Sten Stoutarm
    t.ok(math.abs(call.position.x - 0.2993) > 0.001 or math.abs(call.position.y - 0.712) > 0.001, "moved to a wolf")
    local title = Q.Targets:ForEntry(Q.Progress:Current()).title
    t.ok(title and title ~= "", "has a title")
  end,

  complete_target_is_recomputed_every_3s = function(t)
    local Q = loadNative()
    accept179()
    local before = Mock.countCalls("C_Map.SetUserWaypoint")
    Mock.advance(6)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before, "same nearest wolf: deduplicated")
    -- le joueur traverse la vallée : le loup le plus proche change
    Mock.player.x, Mock.player.y = 22.6, 79.5
    Mock.advance(2)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before, "not yet")
    Mock.advance(1)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before + 1, "recomputed after 3 s")
    t.near(Mock.lastCall("C_Map.SetUserWaypoint").args[1].position.x, 0.2257, 0.001)
    noNavErrors(t)
  end,

  spawn_under_the_player_skipped = function(t)
    local Q = loadNative()
    accept179()
    Mock.player.x, Mock.player.y = 22.58, 78.22   -- sur un point d'apparition de loup (22.57, 78.23)
    Mock.advance(3)
    local x = Mock.lastCall("C_Map.SetUserWaypoint").args[1].position.x
    t.ok(math.abs(x - 0.2257) > 0.001, "next wolf, not the one under the player")
    noNavErrors(t)
  end,

  site_step_follows_nearest_mob_once_inside = function(t)
    local Q = load()
    Q:RegisterGuide({ id = "T_site", faction = "Alliance", steps = { { "complete", 179, at = { 1426, 30.0, 72.0 } } } })
    Mock.quests.log[179] = { objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
    Q.Progress:SetGuide("T_site")
    Mock.player.x, Mock.player.y = 45.0, 50.0      -- loin de la zone : centre de la zone
    Mock.advance(3)
    local tg = Q.Targets:ForEntry(Q.Progress:Current())
    t.eq(tg.kind, "area"); t.near(tg.x, 30.0, 0.001)
    Mock.player.x, Mock.player.y = 30.1, 72.1      -- dans la zone : le loup le plus proche
    tg = Q.Targets:ForEntry(Q.Progress:Current())
    t.eq(tg.kind, "npc"); t.eq(tg.id, 705)
    noNavErrors(t)
  end,

  no_recompute_for_other_steps = function(t)
    local Q = loadNative()
    local before = Mock.countCalls("C_Map.SetUserWaypoint")
    Mock.player.x, Mock.player.y = 26.0, 74.0
    Mock.advance(30)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before, "accept steps are not tracked")
    -- et le minuteur s'arrête quand on quitte une étape « complete »
    accept179()
    Mock.quests.completed[179] = true
    Mock.quests.log[179] = nil
    Mock.fire("QUEST_TURNED_IN", 179)
    local after = Mock.countCalls("C_Map.SetUserWaypoint")
    Mock.player.x, Mock.player.y = 22.6, 78.0
    Mock.advance(30)
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), after)
  end,

  -- Cible mouvante gardée (WaypointUI rejoue animation et bruitage à chaque nouveau repère) : un
  -- loup un peu plus proche ne remplace pas celui qui est visé ; un loup atteint, oui.
  -- Dun Morogh : 1 point de x = 49,25 yards, 1 point de y = 32,83 yards.
  moving_target_kept_until_reached = function(t)
    Mock.addons.WaypointUI = true
    local Q = load({ ["nav.display"] = "waypointui" })
    accept179()
    local NEW = "WaypointUIAPI.Navigation.NewUserNavigation"
    local first = Mock.lastCall(NEW).args[1]
    t.near(first.x, 28.73, 0.01, "nearest wolf from the start (69 yd)")
    local before = Mock.countCalls(NEW)
    -- un autre loup devient le plus proche (40 yd contre 58) : moins de 60 yd gagnés, on garde
    Mock.player.x, Mock.player.y = 29.9, 72.2
    Mock.advance(6)
    t.eq(Mock.countCalls(NEW), before, "no new waypoint for an 18 yd gain")
    -- loup visé atteint : le suivant
    Mock.player.x, Mock.player.y = 28.75, 72.35
    Mock.advance(3)
    t.eq(Mock.countCalls(NEW), before + 1, "next wolf once reached")
    t.near(Mock.lastCall(NEW).args[1].x, 27.6, 0.01)
    noNavErrors(t)
  end,

  -- Bord de la zone d'objectif : entrée à 200 yards, sortie au-delà de 260 (pas de va-et-vient).
  site_edge_has_a_margin = function(t)
    local Q = load()
    Q:RegisterGuide({ id = "T_site", faction = "Alliance", steps = { { "complete", 179, at = { 1426, 30.0, 72.0 } } } })
    Mock.quests.log[179] = { objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
    Mock.player.x, Mock.player.y = 45.0, 50.0                 -- loin de la zone
    Q.Progress:SetGuide("T_site")
    local function kind() return Q.Targets:ForEntry(Q.Progress:Current()).kind end
    Mock.player.x, Mock.player.y = 30.0 + 220 / 49.25, 72.0   -- 220 yd : pas encore entré
    t.eq(kind(), "area")
    Mock.player.x, Mock.player.y = 30.1, 72.1                 -- dedans
    t.eq(kind(), "npc")
    Mock.player.x, Mock.player.y = 30.0 + 220 / 49.25, 72.0   -- 220 yd : on y reste
    t.eq(kind(), "npc")
    Mock.player.x, Mock.player.y = 30.0 + 280 / 49.25, 72.0   -- 280 yd : sorti
    t.eq(kind(), "area")
    Mock.player.x, Mock.player.y = 30.0 + 220 / 49.25, 72.0   -- 220 yd en revenant : pas encore rentré
    t.eq(kind(), "area")
    noNavErrors(t)
  end,

  native_skips_maps_without_waypoints = function(t)
    local Q = loadNative()
    local before = Mock.countCalls("C_Map.SetUserWaypoint")
    Q.Nav:SetTarget(99999, 10, 10, "Nowhere")   -- carte inconnue : pas de marqueur possible
    t.eq(Mock.countCalls("C_Map.SetUserWaypoint"), before)
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1, "no stale marker left")
  end,

  invalid_target_clears = function(t)
    local Q = loadNative()
    Q.Nav:SetTarget(nil, 10, 10, "x")
    t.eq(Mock.countCalls("C_Map.ClearUserWaypoint"), 1)
    noNavErrors(t)
  end,
}
