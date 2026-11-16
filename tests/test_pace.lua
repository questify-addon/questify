-- Tests du rythme face à la route simulée (Q.Pace, Engine/Pace.lua), de la ligne du suivi, de l'onglet
-- Rythme du journal (UI/PacePanel.lua) et de /qf session.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_comfort.lua")

local function load(opts)
  Ext.install()
  opts = opts or {}
  if opts.setup then opts.setup() end
  opts.extraFiles = opts.extraFiles or { GUIDES }
  opts.skipGuides = true
  return Mock.loadAddon(TOC, opts)
end

-- Deux chapitres de 10 notes : 20 minutes simulées chacun (2 minutes par étape).
local function guides(Q, minutes)
  local function notes()
    local s = {}
    for i = 1, 10 do s[i] = { "note", "N" .. i } end
    return s
  end
  Q:RegisterGuide({ id = "T_pace1", title = "Pace One", faction = "Alliance", minLevel = 1, maxLevel = 5,
    next = "T_pace2", sim = { steps = 10, endLevel = 5, xpPerHour = 7200, minutes = minutes or 20 }, steps = notes() })
  Q:RegisterGuide({ id = "T_pace2", title = "Pace Two", faction = "Alliance", minLevel = 5, maxLevel = 8,
    sim = { steps = 10, endLevel = 8, xpPerHour = 7200, minutes = minutes or 20 }, steps = notes() })
  Q.Progress:SetGuide("T_pace1")
end

-- n tranches de 10 s : le joueur bouge (sauf still) et gagne `gain` XP par tranche.
local function play(n, gain, still)
  for _ = 1, n do
    if gain and gain > 0 then
      Mock.comfort.xp = Mock.comfort.xp + gain
      Mock.fire("PLAYER_XP_UPDATE", "player")
    end
    if not still then Mock.player.x = Mock.player.x + 0.1 end
    Mock.advance(10)
  end
end

local function markDone(Q, n)
  for _ = 1, n do
    local cur = Q.Progress:Current()
    Q.Progress:MarkDone(cur.key)
  end
end

local function paint(Q, code, text) return "|c" .. code .. text .. "|r" end

return {
  ahead_of_the_route_in_the_tracker = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    markDone(Q, 4)                       -- 40 % de 20 min = 8 min simulées, 3 min jouées
    local ch = Q.Pace:Chapter("T_pace1")
    t.eq(ch.active, 180)
    local d, expected = Q.Pace:ChapterDelta("T_pace1")
    t.near(expected, 480)
    t.near(d, 300)
    local ahead = string.format(Q.L.PACE_AHEAD, "5 min")
    t.eq(Q.Pace:TrackerText(), paint(Q, Q.Pace.COLOR_AHEAD, ahead))
    local line = Q.UI.Tracker.xpLine
    t.ok(line:IsShown(), "header line shown")
    t.ok(line:GetText():find("XP/h · ", 1, true), "XP/h kept before the gap")
    t.ok(line:GetText():find(ahead, 1, true), "gap in the header line")
    t.ok(not line:GetText():find("level in", 1, true), "time to level moved to the tooltip")
    t.ok(Q.UI.Tracker.xpHover:IsShown(), "hover area over the line")
    t.eq(#Mock.errors, 0)
  end,

  behind_and_on_pace_wording = function(t)
    Mock.locale = "frFR"
    local Q = load()
    t.eq(Q.Pace.DeltaText(-480), "8 min de retard")
    t.eq(Q.Pace.DeltaText(720), "+12 min d'avance")
    t.eq(Q.Pace.DeltaText(90), "dans les temps")
    t.eq(Q.Pace.DeltaShort(-360), "-6 min")
    t.eq(Q.Pace.DeltaShort(660), "+11 min")
    t.eq(Q.Pace.Clock(5460), "1 h 31")
    guides(Q)
    play(60, 20)                          -- 10 min jouées
    markDone(Q, 1)                        -- 2 min simulées
    t.eq(select(2, Q.Pace.DeltaText(Q.Pace:ChapterDelta("T_pace1"))), Q.Pace.COLOR_BEHIND)
    t.ok(Q.UI.Tracker.xpLine:GetText():find("8 min de retard", 1, true), "French wording in the tracker")
  end,

  nothing_before_three_minutes_or_without_sim = function(t)
    local Q = load()
    guides(Q)
    play(17, 20)
    markDone(Q, 4)
    t.eq(Q.Pace:TrackerText(), nil, "under 3 minutes")
    Q:RegisterGuide({ id = "T_nosim", faction = "Alliance", minLevel = 1, maxLevel = 5,
      steps = { { "note", "A" }, { "note", "B" } } })
    Q.Progress:SetGuide("T_nosim")
    play(30, 20)
    t.eq(Q.Pace:TrackerText(), nil, "chapter without simulation")
    t.eq(#Mock.errors, 0)
  end,

  option_off_restores_time_to_level = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    markDone(Q, 4)
    Q.Settings:Set("showPace", false)
    t.eq(Q.Pace:TrackerText(), nil)
    t.eq(Q.UI.Tracker.xpLine:GetText(), Q.XPRate:Text(), "XP/h and time to level again")
  end,

  downtime_away_idle_dead = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    play(40, 0, true)       -- immobile : 5 min en attente, puis temps mort (les 5 min comprises)
    Mock.comfort.afk = true
    play(5, 0, true)
    Mock.comfort.afk = false
    Mock.comfort.dead = true
    play(3, 0, true)
    Mock.comfort.dead = false
    local s = Q.Pace:Session()
    t.eq(s.active, 180, "only moving time is active")
    t.eq(s.down.idle, 400)
    t.eq(s.down.afk, 50)
    t.eq(s.down.dead, 30)
    t.eq(s.wall, 660)
    t.eq(s.xp, 360)
    t.eq(Q.Pace:Chapter("T_pace1").active, 180, "chapter counts active time only")
  end,

  short_stop_counts_as_play = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    play(6, 0, true)        -- une minute sans bouger (lecture d'une quête)
    play(1, 20)
    t.eq(Q.Pace:Session().active, 250)
    t.eq(Q.Pace:Session().down.idle, 0)
  end,

  zones_of_the_session = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    Mock.player.map = 1429
    play(6, 10)
    local rows = Q.Pace.ZoneRows(Q.Pace:Session())
    t.eq(#rows, 2)
    t.eq(rows[1].map, 1426)
    t.eq(rows[1].sec, 180)
    t.eq(rows[1].xp, 360)
    t.near(rows[1].rate, 7200)
    t.eq(rows[2].map, 1429)
    t.eq(rows[2].sec, 60)
  end,

  finished_chapter_saves_an_account_run = function(t)
    local Q = load()
    guides(Q)
    Q.Player.raceKey = "Dwarf"
    play(30, 20)
    markDone(Q, 10)         -- chapitre fini : bascule vers T_pace2
    t.eq(Q.Progress:Guide().id, "T_pace2")
    local ch = Q.Pace:Chapter("T_pace1")
    t.ok(ch.closed, "chapter run closed")
    t.near(ch.delta, 1200 - 300)
    local runs = Q.Pace:Runs("T_pace1")
    t.eq(#runs, 1)
    local r = runs[1]
    t.eq(r.guide, "T_pace1")
    t.eq(r.sec, 300)
    t.eq(r.simMin, 20)
    t.eq(r.frac0, 0)
    t.eq(r.frac, 1)
    t.eq(r.partial, nil, "complete run")
    t.eq(r.faction, "Alliance")
    t.eq(r.class, "WARRIOR")
    t.eq(r.race, "Dwarf")
    t.eq(r.xp, 600)
    t.ok(type(r.id) == "string" and #r.id == 12, "anonymous run id")
    t.eq(r.zones[1426].sec, 300)
    t.eq(r.name, nil, "no character name")
    t.eq(r.realm, nil, "no realm")
    t.ok(QuestifyDB.pace.runs[1] == r, "kept account-wide")
    t.eq(Q.Pace:Best("T_pace1").sec, 300)
    -- le chapitre suivant démarre sa propre mesure
    play(2, 20)
    t.eq(Q.Pace:Chapter("T_pace2").active, 20)
    t.eq(#Mock.errors, 0)
  end,

  partial_run_when_started_mid_chapter = function(t)
    local Q = load()
    guides(Q)
    markDone(Q, 3)           -- avant toute mesure : la mesure part de 30 %
    play(30, 20)
    markDone(Q, 7)
    local r = Q.Pace:Runs("T_pace1")[1]
    t.near(r.frac0, 0.3)
    t.eq(r.partial, true)
    t.eq(Q.Pace:Best("T_pace1"), nil, "partial runs are not a best time")
    t.near(Q.Pace:Chapter("T_pace1").delta, 1200 * 0.7 - 300)
  end,

  telemetry_off_keeps_runs_local = function(t)
    local Q = load()
    guides(Q)
    Q.Settings:Set("telemetry", false)
    play(30, 20)
    markDone(Q, 10)
    t.ok(Q.Pace:Chapter("T_pace1").closed)
    t.eq(#Q.Pace:Runs("T_pace1"), 0, "no account run without telemetry")
  end,

  calibrated_predictions = function(t)
    local Q = load({ setup = function() Mock.comfort.xpMax = 100000 end })
    guides(Q)
    play(60, 20)             -- 10 min jouées pour 20 min simulées : rapport 2
    markDone(Q, 10)
    local ratio, source = Q.Pace:Ratio()
    t.near(ratio, 2)
    t.eq(source, "char")
    play(1, 20)
    markDone(Q, 5)           -- moitié de T_pace2 : 10 min simulées restantes, 5 min à ce rythme
    local eta, simLeft = Q.Pace:ChapterETA()
    t.near(simLeft, 600)
    -- rapport mis à jour par T_pace2 : (1200 + 600) s simulées pour (600 + 10) s jouées
    local now = Q.Pace:Ratio()
    t.near(now, 1800 / 610)
    t.near(eta, 600 / now, 0.01)
    -- prochain niveau : 7200 XP/h mesurées sur la session
    local lvl, nextLevel, rate = Q.Pace:LevelETA()
    t.near(rate, 7200, 1)
    t.eq(nextLevel, 2)
    t.near(lvl, (Mock.comfort.xpMax - Mock.comfort.xp) / 7200 * 3600, 1)
    local lines = Q.Pace:TooltipLines()
    t.eq(lines[1], Q.L.PACE_TITLE)
    local joined = table.concat(lines, "\n")
    t.ok(joined:find(string.format(Q.L.PACE_TIP_RATIO, 295), 1, true), "ratio line")
    t.ok(joined:find(string.format(Q.L.PACE_TIP_CHAPTER_ETA, "4 min"), 1, true), "chapter end line")
  end,

  ratio_from_other_characters = function(t)
    local Q = load({ savedVariables = { QuestifyDB = { pace = { v = 1, runs = {
      { id = "a", guide = "T_pace1", sec = 900, simMin = 20, frac0 = 0, frac = 1, class = "MAGE" },
    } } } } })
    guides(Q)
    local ratio, source = Q.Pace:Ratio()
    t.near(ratio, 1200 / 900)
    t.eq(source, "account")
  end,

  session_survives_reload_and_rotates_later = function(t)
    local Q = load()
    guides(Q)
    play(12, 20)
    Q = Mock.reload()
    t.eq(Q.Pace:Session().wall, 120, "reload keeps the session")
    t.eq(Q.Pace:LastSession(), nil)
    QuestifyCharDB.pace.session.lastTick = QuestifyCharDB.pace.session.lastTick - 3600
    Q = Mock.reload()
    t.eq(Q.Pace:Session().wall, 0, "new session after a long break")
    t.eq(Q.Pace:LastSession().wall, 120, "previous session kept")
  end,

  slash_session_prints_summary = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    SlashCmdList.QUESTIFY("session")
    t.ok(Mock.printed(Q.L.PACE_SESSION_HEADER), "header")
    t.ok(Mock.printed("XP 360"), "xp line")
    t.eq(#Mock.errors, 0)
  end,

  journal_pace_tab = function(t)
    local Q = load({ savedVariables = { QuestifyDB = { pace = { v = 1, runs = {
      { id = "a", guide = "T_pace1", sec = 900, simMin = 20, frac0 = 0, frac = 1, class = "MAGE", race = "Gnome",
        lvlIn = 1.2, lvlOut = 5.4, date = 1762300000 },
    } } } } })
    guides(Q)
    play(18, 20)
    markDone(Q, 4)
    Q.UI.Journal:ShowTab("pace")
    local J, P = Q.UI.Journal, Q.UI.PacePanel
    t.eq(J.tab, "pace")
    t.ok(J.panels.pace:IsShown())
    t.ok(P.delta:GetText():find(string.format(Q.L.PACE_AHEAD, "5 min"), 1, true), "chapter gap")
    t.ok(P.chapterTitle:GetText():find("Pace One", 1, true))
    local rows = Q.UI.PacePanel.ChapterData()
    t.eq(#rows, 1)
    t.eq(rows[1].best, 900)
    t.ok(rows[1].current and rows[1].open)
    t.eq(P.chapterRows[1].cells[3]:GetText(), "|cffaaaaaa" .. Q.L.PACE_IN_PROGRESS .. "|r")
    t.eq(P.chapterRows[1].cells[4]:GetText(), "0 h 15")
    t.ok(P.zoneRows[1].name:IsShown(), "zone row")
    t.ok(not P.zoneRows[2].name:IsShown())
    t.ok(not P.sessionToggle:IsEnabled(), "no previous session yet")
    -- survol d'un chapitre : derniers passages
    local row = P.chapterRows[1]
    row:GetScript("OnEnter")(row)
    t.eq(#Mock.errors, 0)
  end,

  tracker_line_click_opens_pace_tab = function(t)
    local Q = load()
    guides(Q)
    play(18, 20)
    markDone(Q, 4)
    Mock.click(Q.UI.Tracker.xpHover, "LeftButton")
    t.eq(Q.UI.Journal.tab, "pace")
    t.ok(Q.UI.Journal:IsShown())
  end,
}
