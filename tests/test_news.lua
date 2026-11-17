-- Tests de la fenêtre des nouveautés (Q.UI.News, données Q.NewsData).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")
local WExt = dofile(Mock.root .. "/tests/mock_ext_wizard.lua")

-- Personnage configuré (assistant fini) sur un compte qui n'a encore vu aucune nouveauté.
local CONFIGURED = { QuestifyCharDB = { wizardDone = true, wizardObjectivesSeen = true } }

local function load(opts)
  Ext.install()
  WExt.install()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  return Mock.loadAddon(TOC, opts)
end

local function plain(s) return (tostring(s or ""):gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")) end
local function shown(N) return N.frame ~= nil and N.frame:IsShown() end
local function latest(Q) local d = Q.NewsData; return d[#d] end

return {
  news_open_after_update_for_a_configured_character = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    local N = Q.UI.News
    t.ok(not shown(N), "not before 3 s")
    Mock.advance(3)
    t.ok(QuestifyNews and QuestifyNews:IsShown(), "shown 3 s after login")
    local v = latest(Q)
    t.eq(#N.steps, #v.steps, "one step per news item")
    t.eq(N.cur, 1)
    t.eq(plain(N.titleText:GetText()), string.format(Q.L.NEWS_TITLE, v.label))
    t.eq(N.stepText:GetText(), string.format(Q.L.NEWS_STEP, 1, #v.steps))
    t.eq(N.heading:GetText(), Q.L["NEWS_" .. v.steps[1].id .. "_TITLE"])
    t.eq(#N.chips, #v.steps, "one icon per step in the strip")
    t.ok(N.chips[1].current, "first icon is the current one")
    t.ok(not N.prevButton:IsEnabled(), "no previous step")
    t.eq(N.nextButton:GetText(), Q.L.UI_WIZ_NEXT)
    t.eq(Mock.countPrinted("/qf news"), 1, "chat line says how to reopen")
    t.eq(QuestifyDB.newsSeen, nil, "not marked seen just by opening")
    t.ok(not (Q.UI.Wizard.frame and Q.UI.Wizard.frame:IsShown()), "the start wizard stays closed")
    t.eq(#Mock.errors, 0)
  end,

  steps_navigation_and_finish = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    local N = Q.UI.News
    Mock.advance(3)
    Mock.click(N.nextButton, "LeftButton")
    t.eq(N.cur, 2)
    t.ok(N.chips[1].seen and not N.chips[1].current, "first icon dimmed as seen")
    Mock.click(N.prevButton, "LeftButton")
    t.eq(N.cur, 1)
    Mock.click(N.chips[4], "LeftButton")
    t.eq(N.cur, 4, "icon jumps to its step")
    t.eq(N.heading:GetText(), Q.L["NEWS_" .. N.steps[4].id .. "_TITLE"])
    while N.cur < #N.steps do Mock.click(N.nextButton, "LeftButton") end
    t.eq(N.nextButton:GetText(), Q.L.UI_WIZ_FINISH, "last step: Finish")
    Mock.click(N.nextButton, "LeftButton")
    t.ok(not shown(N), "closed")
    t.eq(QuestifyDB.newsSeen, latest(Q).version, "Finish counts as seen")
  end,

  hide_for_this_version_and_close_without_hiding = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    local N = Q.UI.News
    Mock.advance(3)
    N.frame:Hide()                                   -- croix ou Échap
    Mock.advance(10)
    t.ok(not shown(N), "once per session")
    t.eq(QuestifyDB.newsSeen, nil, "closing is not hiding")
    local Q2 = WExt.reload()
    Mock.advance(3)
    t.ok(shown(Q2.UI.News), "back at the next login")
    Mock.click(Q2.UI.News.hideButton, "LeftButton")
    t.ok(not shown(Q2.UI.News))
    t.eq(QuestifyDB.newsSeen, latest(Q2).version)
    t.eq(Mock.countPrinted(string.format(Q2.L.NEWS_HIDDEN, latest(Q2).label)), 1)
    local Q3 = WExt.reload()
    Mock.advance(5)
    t.ok(not shown(Q3.UI.News), "never again for this version")
    -- /qf news : toujours possible
    SlashCmdList.QUESTIFY("news")
    t.ok(shown(Q3.UI.News), "reopened by /qf news")
  end,

  nothing_in_combat = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    Mock.player.combat = true
    Mock.advance(3)
    t.ok(not shown(Q.UI.News), "not in combat")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(shown(Q.UI.News), "after combat")
    Q.UI.News.frame:Hide()
    Mock.player.combat = true
    SlashCmdList.QUESTIFY("news")
    t.ok(not shown(Q.UI.News), "/qf news waits too")
    t.eq(Mock.countPrinted(Q.L.NEWS_COMBAT), 1)
  end,

  new_character_gets_the_start_wizard_instead = function(t)
    local Q = load()
    Mock.advance(3)
    t.ok(not shown(Q.UI.News), "no news for a new character")
    local W = Q.UI.Wizard
    t.ok(W.frame and W.frame:IsShown(), "start wizard")
    while W.page < W.NUM_PAGES do Mock.click(W.nextButton, "LeftButton") end
    t.ok(W.newsButton and W.newsButton:IsShown(), "link to the news on the summary page")
    Mock.click(W.finishButton, "LeftButton")
    t.eq(QuestifyDB.newsSeen, latest(Q).version, "finishing the wizard counts as seen")
    local Q2 = WExt.reload()
    Mock.advance(5)
    t.ok(not shown(Q2.UI.News))
  end,

  news_replace_the_objectives_revisit = function(t)
    local Q = load({ savedVariables = { QuestifyCharDB = { wizardDone = true } } })
    Mock.advance(3)
    t.ok(shown(Q.UI.News), "news shown")
    t.ok(not (Q.UI.Wizard.frame and Q.UI.Wizard.frame:IsShown()), "no wizard on top")
    t.eq(Q.char.wizardObjectivesSeen, true, "the objectives step is in the news")
    t.eq(Mock.countPrinted(Q.L.UI_WIZ_NEW_OBJECTIVES), 0)
  end,

  wizard_summary_button_opens_the_news = function(t)
    local Q = load({ savedVariables = { QuestifyDB = { newsSeen = "999.0.0" },
      QuestifyCharDB = { wizardDone = true, wizardObjectivesSeen = true } } })
    Mock.advance(5)
    t.ok(not shown(Q.UI.News), "nothing newer than what was seen")
    local W = Q.UI.Wizard
    W:Show(W.NUM_PAGES)
    Mock.click(W.newsButton, "LeftButton")
    t.ok(shown(Q.UI.News), "opened from the wizard")
    t.eq(#Q.UI.News.steps, #latest(Q).steps, "shows the latest version")
  end,

  wizard_step_opens_its_page_alone_with_cancel_and_save = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    local N, W = Q.UI.News, Q.UI.Wizard
    Mock.advance(3)
    local idx
    for i, s in ipairs(N.steps) do if s.go and s.go.wizard == "PAGE_OBJECTIVES" then idx = i end end
    t.ok(idx, "a news step leads to the objectives page")
    local before = Q.Settings:Get("tracker.objLayout")
    local other = before == "bars" and "list" or "bars"
    local autoQuest = Q.Settings:Get("autoQuest")
    local function open()
      Mock.click(N.chips[idx], "LeftButton")
      Mock.click(N.goButton, "LeftButton")
      t.ok(W.frame:IsShown(), "wizard page shown")
      t.eq(W.page, W.PAGE_OBJECTIVES)
      t.ok(W.cancelButton:IsShown() and W.saveButton:IsShown(), "cancel and save")
      for _, b in ipairs({ W.prevButton, W.nextButton, W.skipButton, W.finishButton }) do
        t.ok(not b:IsShown(), "no wizard flow button")
      end
      W:SetChoice("objLayout", other)
      W:SelectObjectives()
    end
    open()
    Mock.click(W.cancelButton, "LeftButton")
    t.ok(not W.frame:IsShown(), "cancel closes")
    t.eq(Q.Settings:Get("tracker.objLayout"), before, "cancel keeps the setting")
    t.eq(Q.char.wizardPage, nil, "the start wizard's resume point is untouched")
    t.eq(Q.char.wizardDraft, nil, "no draft")
    open()
    Mock.click(W.saveButton, "LeftButton")
    t.ok(not W.frame:IsShown(), "save closes")
    t.eq(Q.Settings:Get("tracker.objLayout"), other, "save keeps the choice")
    t.eq(Q.Settings:Get("autoQuest"), autoQuest, "only the page's settings are saved")
    t.eq(Q.char.wizardDone, true)
    t.ok(shown(N), "the news window is still there")
    W:Show(2)
    t.ok(W.nextButton:IsShown() and W.prevButton:IsShown(), "the full wizard keeps its flow")
    t.ok(not W.cancelButton:IsShown() and not W.saveButton:IsShown())
    t.eq(#Mock.errors, 0)
  end,

  go_buttons_lead_to_each_place = function(t)
    local Q = load({ savedVariables = CONFIGURED })
    local N = Q.UI.News
    local got = {}
    rawset(Q.UI.Options, "Open", function(_, section) got[#got + 1] = "options:" .. tostring(section) end)
    rawset(Q.UI.Wizard, "ShowPage", function(_, page) got[#got + 1] = "wizard:" .. tostring(page) end)
    rawset(Q.UI.Journal, "ShowTab", function(_, tab) got[#got + 1] = "journal:" .. tostring(tab) end)
    local slash = SlashCmdList.QUESTIFY
    SlashCmdList.QUESTIFY = function(msg) got[#got + 1] = "slash:" .. tostring(msg) end
    Mock.advance(3)
    local want = {}
    for i, s in ipairs(N.steps) do
      Mock.click(N.chips[i], "LeftButton")
      t.ok(N.goButton:IsShown(), "go button on step " .. s.id)
      t.ok((N.goButton:GetText() or "") ~= "", "go label " .. s.id)
      Mock.click(N.goButton, "LeftButton")
      local g = s.go
      if g.options then want[i] = "options:" .. g.options
      elseif g.wizard then want[i] = "wizard:" .. tostring(Q.UI.Wizard[g.wizard])
      elseif g.journal then want[i] = "journal:" .. g.journal
      else want[i] = "slash:" .. g.slash end
    end
    SlashCmdList.QUESTIFY = slash
    t.eq(got, want)
    t.ok(shown(N), "stays open behind")
    t.eq(#Mock.errors, 0)
  end,

  every_text_in_english_and_french = function(t)
    local Q = load()
    local en = Q.L
    for _, v in ipairs(Q.NewsData) do
      t.ok(type(v.version) == "string" and Q.VersionCheck.Parse(v.version), "version " .. tostring(v.version))
      t.ok(type(v.label) == "string")
      for _, s in ipairs(v.steps) do
        t.ok(type(s.icon) == "string" and type(s.go) == "table", s.id)
        for _, suffix in ipairs({ "TAG", "TITLE", "TEXT", "P1", "GO", "WHERE" }) do
          local key = "NEWS_" .. s.id .. "_" .. suffix
          t.ok(type(rawget(en, key)) == "string", key)
        end
      end
    end
    Mock.reset()
    Mock.locale = "frFR"
    local QF = load()
    local fr = QF.L
    for _, v in ipairs(QF.NewsData) do
      for _, s in ipairs(v.steps) do
        for _, suffix in ipairs({ "TAG", "TITLE", "TEXT", "P1", "P2", "P3", "GO", "WHERE" }) do
          local key = "NEWS_" .. s.id .. "_" .. suffix
          local e, f = rawget(en, key), rawget(fr, key)
          t.eq(e == nil, f == nil, "same keys in both languages: " .. key)
          if e and (suffix == "TITLE" or suffix == "TEXT") then t.ok(e ~= f, "translated: " .. key) end
        end
      end
    end
    t.ok(QF.L.NEWS_TITLE ~= en.NEWS_TITLE, "French title")
  end,
}
