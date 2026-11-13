-- Tests de la zone de secours (Engine/Detour.lua) : choix selon le niveau et la barre d'XP, zones du
-- chapitre courant évitées, retour au chemin (bouton, fin de zone), bouton du journal et /qf alt.
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

local function guide(id, title, min, max, rate, extra)
  local g = { id = id, title = title, faction = "Alliance", minLevel = min, maxLevel = max,
    sim = { steps = 2, endLevel = max, xpPerHour = rate, minutes = 60 },
    steps = { { "accept", 9000 + min }, { "turnin", 9000 + min, xp = 100 } } }
  for k, v in pairs(extra or {}) do g[k] = v end
  return g
end

-- Route : Duskwood 24-26 (courant), puis Wetlands. Autres zones : Ashenvale 25-27 (meilleure XP/h),
-- Redridge 22-25, Duskwood bis (même zone), Desolace 33-36 (trop haut), Westfall 12-16 (trop bas).
local function load(level, xp)
  Mock.reset()
  Mock.player.level = level or 25
  local Q = Mock.loadAddon(TOC, { skipGuides = true, extraFiles = { GUIDES }, beforeLogin = function(Q)
    Q:RegisterGuide(guide("T_DUSK", "Duskwood", 24, 26, 30000, { next = "T_WET" }))
    Q:RegisterGuide(guide("T_WET", "Wetlands", 26, 28, 28000))
    Q:RegisterGuide(guide("T_ASH", "Ashenvale", 25, 27, 26000))
    Q:RegisterGuide(guide("T_RED", "Redridge Mountains", 22, 25, 20000))
    Q:RegisterGuide(guide("T_DUSK2", "Duskwood", 25, 27, 40000))
    Q:RegisterGuide(guide("T_DESO", "Desolace", 33, 36, 50000))
    Q:RegisterGuide(guide("T_WEST", "Westfall", 12, 16, 50000))
    Q:RegisterGuide(guide("T_HORDE", "The Barrens", 24, 26, 60000, { faction = "Horde" }))
    Q:RegisterGuide(guide("T_HUMAN", "Stonetalon Mountains", 24, 26, 60000, { races = { "Human" } }))
  end })
  if xp then UnitXP = function() return xp end; UnitXPMax = function() return 1000 end end
  Q.Progress:SetGuide("T_DUSK")
  return Q
end

local function ids(list)
  local out = {}
  for i, c in ipairs(list) do out[i] = c.guide.id end
  return table.concat(out, ",")
end

local tests = {}

function tests.candidates_fit_the_level_and_leave_the_zone(t)
  local Q = load(25)
  -- Wetlands (26-28) : un niveau trop haut au plus ; même zone, autre faction, autre race, hors tranche : exclus
  t.eq(ids(Q.Detour:Candidates()), "T_ASH,T_RED,T_WET")
  t.eq(Q.Detour:Current(), nil)
end

function tests.the_xp_bar_moves_the_choice(t)
  -- niveau 25 à 0 % : Wetlands est un niveau entier au-dessus (pénalité 0,5) ; à 90 % : presque à portée
  local Q = load(25, 0)
  local low = Q.Detour:Candidates()
  Q = load(25, 900)
  local high = Q.Detour:Candidates()
  local function score(list, id) for _, c in ipairs(list) do if c.guide.id == id then return c.score end end end
  t.ok(score(high, "T_WET") > score(low, "T_WET"), "closer to level 26: Wetlands fits better")
  t.ok(score(high, "T_RED") < score(low, "T_RED"), "closer to level 26: Redridge is more outleveled")
end

function tests.level_changes_the_candidates(t)
  local Q = load(23)
  t.eq(ids(Q.Detour:Candidates()), "T_RED", "level 23: Ashenvale and Wetlands are too high")
  Q = load(28)
  t.eq(ids(Q.Detour:Candidates()), "T_WET,T_ASH", "level 28: Redridge is outleveled")
  Q = load(45)
  t.eq(#Q.Detour:Candidates(), 0)
  t.eq(Q.Detour:Start(), nil)
  t.eq(Q.Progress:Guide().id, "T_DUSK", "nothing fits: the route does not move")
end

function tests.finished_chapters_are_not_offered(t)
  local Q = load(25)
  Mock.quests.completed[9025] = true
  Mock.fire("QUEST_TURNED_IN", 9025)
  t.eq(ids(Q.Detour:Candidates()), "T_RED,T_WET", "Ashenvale is done")
end

function tests.start_then_return_to_the_route(t)
  local Q = load(25)
  local g = Q.Detour:Start()
  t.eq(g.id, "T_ASH")
  t.eq(Q.Progress:Guide().id, "T_ASH")
  t.eq(Q.Detour:Current().from, "T_DUSK")
  -- encore une : la suivante, sans revenir sur la zone quittée ; le chapitre à retrouver ne change pas
  t.eq(ids(Q.Detour:Candidates()), "T_RED,T_WET", "neither the zone left nor the current one")
  t.eq(Q.Detour:Start().id, "T_RED")
  t.eq(Q.Detour:Current().from, "T_DUSK")
  t.eq(Q.Detour:Return().id, "T_DUSK")
  t.eq(Q.Progress:Guide().id, "T_DUSK")
  t.eq(Q.Detour:Current(), nil)
  t.eq(Q.Detour:Return(), nil, "not on an alternative zone")
end

function tests.return_follows_the_level(t)
  local Q = load(25)
  Q.Detour:Start()
  -- le personnage a dépassé le chapitre quitté (24-26) : retour au chapitre de son niveau
  Mock.player.level = 27
  Mock.fire("PLAYER_LEVEL_UP", 27)
  t.eq(Q.Detour:ReturnTarget().id, "T_WET")
  t.eq(Q.Detour:Return().id, "T_WET")
end

function tests.end_of_the_alternative_zone_goes_back_to_the_route(t)
  local Q = load(25)
  Q.Detour:Start()
  local ash = Q.Guides:Get("T_ASH")
  t.eq(Q.Guides:Next(ash, "Dwarf").id, "T_DUSK")
  local opts = Q.Guides:Choices(ash, "Dwarf", "Alliance")
  t.eq(#opts, 1); t.eq(opts[1].guide.id, "T_DUSK")
  -- hors zone de secours : la suite habituelle
  t.eq(Q.Guides:Next(Q.Guides:Get("T_DUSK"), "Dwarf").id, "T_WET")
  -- chapitre fini : la route revient d'elle-même
  for _, e in ipairs(Q.Progress:Entries()) do
    if e.source == "guide" then Q.Progress:Skip(e.key) end
  end
  t.eq(Q.Progress:Guide().id, "T_DUSK")
  t.eq(Q.Detour:Current(), nil)
  t.eq(QuestifyCharDB.detour, nil)
end

function tests.changing_chapter_by_hand_closes_the_detour(t)
  local Q = load(25)
  Q.Detour:Start()
  Q.Progress:SetGuide("T_WET", true)
  t.eq(Q.Detour:Current(), nil)
  t.eq(Q.Guides:Next(Q.Guides:Get("T_ASH"), "Dwarf"), nil, "usual next chapter again (none here)")
end

function tests.detour_survives_reload(t)
  local Q = load(25)
  Q.Detour:Start()
  Q = Mock.reload({ skipGuides = true, extraFiles = { GUIDES }, beforeLogin = Mock.lastOpts.beforeLogin })
  t.eq(Q.Progress:Guide().id, "T_ASH")
  t.eq(Q.Detour:Current().from, "T_DUSK")
end

function tests.journal_button_and_slash(t)
  local Q = load(25)
  local J = Q.UI.Journal
  J:ShowTab("route")
  t.eq(J.detourButton:GetText(), Q.L.DETOUR_BTN)
  Mock.click(J.detourButton)
  t.eq(Q.Progress:Guide().id, "T_ASH")
  t.eq(J.detourButton:GetText(), Q.L.DETOUR_BTN_BACK)
  t.ok(Mock.printed("Ashenvale"), "the alternative zone is announced")
  Mock.click(J.detourButton)
  t.eq(Q.Progress:Guide().id, "T_DUSK")
  t.eq(J.detourButton:GetText(), Q.L.DETOUR_BTN)
  SlashCmdList.QUESTIFY("alt")
  t.eq(Q.Progress:Guide().id, "T_ASH")
  SlashCmdList.QUESTIFY("alt")
  t.eq(Q.Progress:Guide().id, "T_RED", "again: next alternative")
  SlashCmdList.QUESTIFY("alt back")
  t.eq(Q.Progress:Guide().id, "T_DUSK")
  SlashCmdList.QUESTIFY("alt retour")
  t.ok(Mock.printed(Q.L.DETOUR_NOT_ACTIVE))
  t.eq(#Mock.errors, 0)
end

function tests.automatic_mode_chapters_only_when_the_mode_is_on(t)
  Mock.reset()
  Mock.player.level = 25
  local Q = Mock.loadAddon(TOC, { skipGuides = true, extraFiles = { GUIDES }, beforeLogin = function(Q)
    Q.DungeonRouteData = { faction = "Alliance", rungs = {} }
    Q:RegisterGuide(guide("T_DUSK", "Duskwood", 24, 26, 30000))
    Q:RegisterGuide(guide("T_ASH", "Ashenvale", 25, 27, 26000))
    Q:RegisterGuide(guide("AD_T1", "Wetlands", 24, 26, 50000, { mode = "dungeon" }))
  end })
  Q.Progress:SetGuide("T_DUSK")
  t.eq(ids(Q.Detour:Candidates()), "T_ASH", "manual route: no automatic chapter")
  Q.DungeonMode:SetOn(true)
  Q.Progress:SetGuide("T_DUSK")
  t.eq(ids(Q.Detour:Candidates()), "AD_T1,T_ASH")
end

return tests
