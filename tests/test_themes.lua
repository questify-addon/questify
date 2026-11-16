-- Tests des thèmes (Q.Themes, UI/Themes.lua) : treize thèmes, jetons de couleur et contraste,
-- thème de la race, choix du joueur, anciennes clés, fond du suivi (plein, fondu, sans fond),
-- décorations (bandeau, blason, coins, liseré), blason choisi dans le client, boutons, police,
-- commandes /qf theme et /qf opacity.
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

local function qf(msg) SlashCmdList.QUESTIFY(msg) end

-- Espion : chaque appel des méthodes nommées est noté dans log[nom] = { { args... }, ... }, puis
-- passé à la méthode d'origine (celle du mock, ou un appel sans effet).
local function spy(obj, names, log)
  for _, name in ipairs(names) do
    local orig = obj[name]
    log[name] = log[name] or {}
    rawset(obj, name, function(self, ...)
      table.insert(log[name], { ... })
      if type(orig) == "function" then return orig(self, ...) end
    end)
  end
  return log
end

local TEXTURE_CALLS = { "SetColorTexture", "SetGradient", "SetAtlas", "SetTexture", "SetAlpha", "SetVertexColor" }

-- Cadre BackdropTemplate dont la bordure et les textures créées ensuite sont espionnées.
local function spyFrame()
  local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
  local log = spy(f, { "SetBackdrop", "SetBackdropBorderColor", "SetAlpha" }, {})
  log.textures = {}
  local create = f.CreateTexture
  rawset(f, "CreateTexture", function(self, ...)
    local tx = create(self, ...)
    log.textures[tx] = spy(tx, TEXTURE_CALLS, {})
    return tx
  end)
  return f, log
end

local function last(list) return list and list[#list] end
local function color(fs) return { fs:GetTextColor() } end

-- Contraste WCAG entre deux couleurs { r, g, b }.
local function lum(c)
  local function ch(v) return v <= 0.03928 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4 end
  return 0.2126 * ch(c[1]) + 0.7152 * ch(c[2]) + 0.0722 * ch(c[3])
end
local function contrast(a, b)
  local x, y = lum(a), lum(b)
  return (math.max(x, y) + 0.05) / (math.min(x, y) + 0.05)
end

local KEYS = { "neutral", "contrast", "alliance", "human", "dwarf", "nightelf", "gnome", "skyborneA",
  "horde", "orc", "troll", "tauren", "undead", "skyborneH" }

return {
  defaults_follow_the_race_on_questify = function(t)
    local Q = load()
    t.eq(Q.Settings.defaults.tracker.theme, "neutral")
    t.eq(Q.Settings.defaults.tracker.opacity, 0.9)
    t.eq(Q.Settings.defaults.tracker.style, "solid")
    t.eq(Q.Settings.defaults.theme, { followRace = true, font = "game", icons = "flat", fontScale = 1 })
    t.eq(Q.Settings.defaults.arrow, { show = true, color = "cyan" })
    -- le personnage de test est un Nain : son thème s'applique
    t.eq(Q.Themes:RaceKey(), "dwarf")
    t.eq(Q.Themes:CurrentKey(), "dwarf")
    local T = Q.UI.Tracker
    t.eq(T.themeKey, "dwarf", "tracker on the race theme")
    t.eq(T.themeStyle, "solid")
    t.eq(T.frame.qvThemeBackground, "color")
    t.eq(T.frame.qvThemeBg:GetAlpha(), 0.9)
    -- sans suivre la race : le réglage
    Q.Settings:Set("theme.followRace", false)
    t.eq(T.themeKey, "neutral")
    t.eq(#Mock.errors, 0)
  end,

  every_race_has_its_theme = function(t)
    local Q = load()
    local want = { [1] = "human", [2] = "orc", [3] = "dwarf", [4] = "nightelf", [5] = "undead", [6] = "tauren",
      [7] = "gnome", [8] = "troll", [95] = "skyborneA", [96] = "skyborneH" }
    for id, key in pairs(want) do
      Mock.player.raceId = id
      t.eq(Q.Themes:RaceKey(), key, "race " .. id)
    end
    Mock.player.raceId = 99
    t.eq(Q.Themes:RaceKey(), nil, "unknown race")
    t.eq(Q.Themes:CurrentKey(), "neutral", "unknown race: the setting")
  end,

  list_order_groups_and_french_labels = function(t)
    Mock.locale = "frFR"
    local Q = load()
    local list = Q.Themes:List()
    local keys, labels, groups = {}, {}, {}
    for i, th in ipairs(list) do keys[i], labels[i], groups[i] = th.key, th.label, th.group end
    t.eq(keys, KEYS)
    t.eq(labels, { "Questify", "Contraste élevé", "Alliance", "Humain", "Nain", "Elfe de la nuit", "Gnome", "Skyborne",
      "Horde", "Orc", "Troll", "Tauren", "Mort-vivant", "Skyborne" })
    t.eq(groups[1], "neutral"); t.eq(groups[2], "neutral"); t.eq(groups[3], "alliance"); t.eq(groups[9], "horde")
  end,

  every_theme_has_its_tokens_and_reads_well = function(t)
    local Q = load()
    local th = Q.Themes
    local ROLES = { "bg", "panel", "panelAlt", "sidebar", "footer", "sky", "edge", "line", "text", "textDim",
      "textMuted", "accent", "onAccent", "trim", "metal", "sel", "quest", "npc", "mob", "item", "success",
      "warning", "danger", "xp", "zone" }
    for _, key in ipairs(KEYS) do
      local theme = th:Get(key)
      t.eq(theme.key, key)
      for _, role in ipairs(ROLES) do
        local r, g, b, a = th:Color(role, theme)
        t.ok(r and g and b and a, key .. " " .. role)
      end
      t.eq(th:Hex("text", theme):len(), 8)
      local c = theme.colors
      -- lisibilité (maquette : 7:1 pour le texte, 4,5:1 pour le reste)
      t.ok(contrast(c.text, c.bg) >= 7, key .. " text")
      t.ok(contrast(c.textDim, c.bg) >= 7, key .. " secondary text")
      t.ok(contrast(c.textMuted, c.bg) >= 4.5, key .. " muted text")
      t.ok(contrast(c.textMuted, c.panelAlt) >= 4.5, key .. " muted on controls")
      t.ok(contrast(c.accent, c.onAccent) >= 4.5, key .. " text on the accent")
      for _, role in ipairs({ "quest", "npc", "mob", "item", "success", "warning", "danger", "xp", "zone" }) do
        t.ok(contrast(c[role], c.panelAlt) >= 4.5, key .. " " .. role)
      end
      for _, role in ipairs({ "title", "body", "dim", "levels", "distance", "bar", "xp", "warn", "classAlert",
        "dungeonAlert", "trainerAlert" }) do
        t.eq(#th:TextColor(role, theme), 4, key .. " text role " .. role)
      end
      t.eq(theme.banner, "Interface\\AddOns\\Questify\\Media\\Themes\\banner-" .. key)
      t.ok(theme.bar.fill and theme.bar.bg, "bar colours for the other modules")
      t.ok(theme.border and theme.border.color, "border colour for the other modules")
    end
  end,

  legacy_and_unknown_keys = function(t)
    local Q = load()
    local th = Q.Themes
    for _, old in ipairs({ "parchment", "dark", "transparent", "gradient" }) do
      t.eq(th:Find(old), "neutral", old)
      t.eq(th:Get(old).key, "neutral")
    end
    t.eq(th:Get("nope").key, "neutral")
    t.eq(th:Get(nil).key, "neutral")
    t.eq(th:Get(42).key, "neutral")
    t.eq(th:Find("nope"), nil)
    t.eq(th:Find("Night Elf"), "nightelf", "by label, any case")
    t.ok(th:Get("dark").bar.fill, "Get(\"dark\").bar.fill still works (journal pace bars)")
    -- un ancien fond transparent ou dégradé est gardé tant que le joueur n'a rien rechoisi
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "transparent")
    t.eq(th:Style(), "none")
    t.eq(Q.UI.Tracker.themeStyle, "none")
    Q.Settings:Set("tracker.theme", "gradient")
    t.eq(th:Style(), "fade")
    Q.Settings:Set("tracker.theme", "horde")
    t.eq(th:Style(), "solid")
  end,

  choose_unticks_follow_race_unless_it_is_the_race = function(t)
    local Q = load()
    local th = Q.Themes
    t.eq(th:Choose("dwarf"), "dwarf")
    t.eq(Q.Settings:Get("theme.followRace"), true, "own race: still following")
    t.eq(th:Choose("horde"), "horde")
    t.eq(Q.Settings:Get("theme.followRace"), false)
    t.eq(Q.Settings:Get("tracker.theme"), "horde")
    t.eq(Q.UI.Tracker.themeKey, "horde")
    t.eq(th:Choose("bogus"), nil)
    t.eq(Q.Settings:Get("tracker.theme"), "horde", "unchanged")
    Q.Settings:Set("theme.followRace", true)
    t.eq(Q.UI.Tracker.themeKey, "dwarf", "back to the race")
  end,

  apply_solid_fade_and_none = function(t)
    local Q = load()
    local th = Q.Themes
    CreateColor = function(r, g, b, a) return { r = r, g = g, b = b, a = a } end
    local f, log = spyFrame()
    local theme = th:Apply(f, "horde", 0.5)
    t.eq(f.qvThemeBackground, "color")
    t.eq(last(log.SetBackdrop)[1], th.HAIRLINE, "1 px border")
    t.eq(th.HAIRLINE.edgeFile, "Interface\\Buttons\\WHITE8X8")
    local bc = last(log.SetBackdropBorderColor)
    t.near(bc[4], 0.5, 1e-9, "border takes the opacity")
    local bg = last(log.textures[f.qvThemeBg].SetColorTexture)
    t.near(bg[1], theme.colors.bg[1], 1e-9)
    t.eq(f.qvThemeBg:GetAlpha(), 0.5)
    t.eq(#log.SetAlpha, 0, "the frame itself keeps alpha 1: text never dims")
    -- fondu : dégradé vertical du fond du thème, transparent en bas
    local fade = th:Apply(f, "horde", 0.8, "fade")
    t.eq(f.qvThemeBackground, "gradient")
    t.eq(fade.decor, false, "no banner on a fade")
    local call = last(log.textures[f.qvThemeGradient].SetGradient)
    t.eq(call[1], "VERTICAL")
    t.eq(call[2].a, 0); t.eq(call[3].a, 1)
    t.eq(last(log.SetBackdrop)[1], nil, "no border")
    -- sans fond : rien, texte cerné
    local none = th:Apply(f, "horde", 1, "none")
    t.eq(f.qvThemeBackground, "none")
    t.eq(none.outline, true)
    t.ok(th:Get("horde", "none") == none, "variant cached")
    -- sans les API de dégradé : couleur unie
    CreateColor = nil
    th:Apply(f, "horde", 1, "fade")
    t.eq(f.qvThemeBackground, "color")
    t.eq(#Mock.errors, 0)
  end,

  recolor_maps_codes_to_the_theme = function(t)
    local Q = load()
    local th = Q.Themes
    local horde = th:Get("horde")
    local s = "Accept |cffffd100Quest|r from |cff00ff96Npc|r, kill |cFFFF6060Mob|r"
    t.eq(th:Recolor(s, horde), "Accept |c" .. th:Hex("quest", horde) .. "Quest|r from |c" .. th:Hex("npc", horde)
      .. "Npc|r, kill |c" .. th:Hex("mob", horde) .. "Mob|r")
    t.eq(th:Recolor("plain text", horde), "plain text")
    t.eq(th:Recolor("|cff123456odd|r", horde), "|cff123456odd|r", "unknown code kept")
    t.eq(th:Recolor(nil), nil)
    -- codes lus par les autres modules (rythme, objectifs, butin) : tous remappés
    for _, code in ipairs({ "ff40e050", "ffffb040", "ffc8c8c8", "ff808080", "ffff6060", "ff66bbff", "ffffd100",
      "ffff5555", "ff999999", "ffaaaaaa", "ff40ff40", "ffff8040", "ffffd040", "ffffffff" }) do
      t.ok(horde.codes[code], code)
    end
  end,

  setting_change_reapplies_live = function(t)
    local Q = load()
    local T = Q.UI.Tracker
    local th = Q.Themes
    local dwarf = th:Get("dwarf")
    t.eq(color(T.currentText), dwarf.text.body)
    t.ok(T.currentText:GetText():find("|c" .. th:Hex("quest", dwarf) .. "Dwarven Outfitters", 1, true), "quest colour")
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "undead")
    t.eq(T.themeKey, "undead")
    t.eq(color(T.title), th:Get("undead").text.title)
    t.eq(color(T.nextLines[1].text), th:Get("undead").text.dim, "secondary next steps")
    -- style du fond
    Q.Settings:Set("tracker.style", "none")
    t.eq(T.themeStyle, "none")
    t.eq(T.frame.qvThemeBackground, "none")
    t.eq(T:HeaderHeight(), 20, "no banner without a background")
    Q.Settings:Set("tracker.style", "solid")
    t.eq(T:HeaderHeight(), 44)
    -- lignes créées après le changement : déjà aux couleurs du thème
    local chunk = T:TextChunk(#T.textChunks + 1)
    t.eq(color(chunk), th:Get("undead").text.body)
    t.eq(#Mock.errors, 0)
  end,

  unchanged_settings_do_not_reapply = function(t)
    local Q = load()
    local T = Q.UI.Tracker
    t.eq(T:ApplyTheme(), false, "nothing changed")
    Q.Settings:Set("tracker.nextSteps", 2)
    t.eq(T.themeKey, "dwarf")
    t.eq(T:ApplyTheme(true), true, "forced")
  end,

  decorate_paints_banner_emblem_corners_and_trim = function(t)
    local Q = load()
    local th = Q.Themes
    local f = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    local d = th:Decorate(f, { header = 52, emblem = 34, title = title, watermark = 200 })
    t.ok(d and d.header and d.emblem and d.trim and d.watermark, "parts")
    t.eq(#d.corners, 4)
    t.ok(th:Decorate(f) == d, "once per frame")
    t.eq(d.header:GetHeight(), 52)
    t.eq(d.banner:GetTexture(), th:Get("dwarf").banner)
    t.eq(d.corners[1]:GetTexture(), th.TEX.corner)
    t.eq(d.emblem.ring:GetTexture(), th.TEX.ring)
    local m = th:Get("dwarf").colors.metal
    t.eq({ d.corners[2]:GetVertexColor() }, { m[1], m[2], m[3], 1 }, "metal tint")
    -- nouveau thème : repeint tout seul
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "nightelf")
    t.eq(d.banner:GetTexture(), th:Get("nightelf").banner)
    t.eq(d.emblem.qvThemeKey, "nightelf")
    m = th:Get("nightelf").colors.metal
    t.eq({ d.corners[2]:GetVertexColor() }, { m[1], m[2], m[3], 1 })
    -- le suivi est décoré lui aussi, le titre est dans le bandeau
    local T = Q.UI.Tracker
    t.ok(T.decor and T.decor.header, "tracker banner")
    t.ok(T.title:GetParent() == T.decor.header, "title in the banner")
    t.eq(#Mock.errors, 0)
  end,

  emblem_prefers_the_client_atlas_then_files_then_questify = function(t)
    local Q = load()
    local th = Q.Themes
    -- atlas de création de personnage présent : choisi
    th:ResetEmblems()
    C_Texture = { GetAtlasInfo = function(name) return name == "raceicon128-dwarf-male" and { width = 1 } or nil end }
    t.eq(th:EmblemSource(th:Get("dwarf")), { atlas = "raceicon128-dwarf-male" })
    -- Skyborne : ni atlas ni fichier du jeu -> dessin de Questify
    C_Texture = { GetAtlasInfo = function() return nil end }
    GetFileIDFromPath = function() return nil end
    th:ResetEmblems()
    t.eq(th:EmblemSource(th:Get("skyborneA")), { file = th.TEX.skyborne })
    -- fichier présent : icône de haut fait du personnage
    GetFileIDFromPath = function(path) return path == "Interface\\Icons\\Achievement_Character_Orc_Male" and 1 or nil end
    th:ResetEmblems()
    t.eq(th:EmblemSource(th:Get("orc")), { file = "Interface\\Icons\\Achievement_Character_Orc_Male" })
    -- le thème neutre garde la boussole de Questify
    t.eq(th:EmblemSource(th:Get("neutral")), { file = th.TEX.logo })
    GetFileIDFromPath = nil
    C_Texture = nil
  end,

  skin_button_primary_and_secondary = function(t)
    local Q = load()
    local th = Q.Themes
    local b = CreateFrame("Button", nil, UIParent, "UIPanelButtonTemplate")
    th:SkinButton(b, "primary", th:Get("horde"))
    local a = th:Get("horde").colors.accent
    local bg = { b.qvSkin.bg:GetVertexColor() }
    t.ok(b.qvSkin and #b.qvSkin.edges == 4, "flat background and 1 px border")
    t.eq(b.qvButtonKind, "primary")
    th:SkinButton(b, nil, th:Get("alliance"))
    t.eq(b.qvButtonKind, "primary", "kind remembered")
    t.eq(b.qvButtonTheme, "alliance")
    t.ok(a and bg, "colours")
  end,

  clean_font_and_outline = function(t)
    local Q = load()
    local fs = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rawset(fs, "GetFont", function() return "Fonts\\FRIZQT__.TTF", 12, "" end)
    local log = spy(fs, { "SetFont", "SetShadowOffset" }, {})
    Q.Themes:StyleText(fs, "body", Q.Themes:Get("horde", "none"))
    t.eq(last(log.SetFont), { "Fonts\\FRIZQT__.TTF", 12, "OUTLINE" })
    t.eq(last(log.SetShadowOffset), { 1, -1 })
    Q.Themes:StyleText(fs, "body", Q.Themes:Get("horde"))
    t.eq(last(log.SetFont), { "Fonts\\FRIZQT__.TTF", 12, "" }, "outline removed")
    Q.Settings:Set("theme.font", "clean")
    Q.Themes:StyleText(fs, "body", Q.Themes:Get("horde"))
    t.eq(last(log.SetFont), { Q.Themes.CLEAN_FONT, 12, "" }, "Inter, same size")
    Q.Themes:StyleText(fs, "title", Q.Themes:Get("horde"))
    t.eq(last(log.SetFont), { Q.Themes.CLEAN_FONT_BOLD, 12, "" }, "titles in semibold")
    Q.Settings:Set("theme.font", "game")
    Q.Themes:StyleText(fs, "body", Q.Themes:Get("horde"))
    t.eq(last(log.SetFont), { "Fonts\\FRIZQT__.TTF", 12, "" }, "back to the game font")
  end,

  theme_changed_fires_once_per_change = function(t)
    local Q = load()
    local seen = {}
    Q:On("THEME_CHANGED", function(theme) seen[#seen + 1] = theme.key end)
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "troll")
    Q.Settings:Set("tracker.nextSteps", 2)
    t.eq(seen, { "neutral", "troll" })
  end,

  arrow_colour = function(t)
    local Q = load()
    local th = Q.Themes
    t.eq({ th:ArrowColor() }, { th.ARROW_COLORS.cyan[1], th.ARROW_COLORS.cyan[2], th.ARROW_COLORS.cyan[3] })
    Q.Settings:Set("arrow.color", "theme")
    local a = th:Current().colors.accent
    t.eq({ th:ArrowColor() }, { a[1], a[2], a[3] }, "the theme's accent")
    t.eq(th.ARROW_ORDER, { "cyan", "theme", "gold", "green", "white", "pink" })
  end,

  slash_theme = function(t)
    local Q = load()
    qf("theme horde")
    t.eq(Q.Settings:Get("tracker.theme"), "horde")
    t.eq(Q.Settings:Get("theme.followRace"), false)
    t.eq(Q.UI.Tracker.themeKey, "horde")
    t.ok(Mock.printed(string.format(Q.L.UI_SLASH_THEME_SET, "Horde")))
    qf("theme  night elf ")
    t.eq(Q.Settings:Get("tracker.theme"), "nightelf", "by label, any case")
    qf("theme bogus")
    t.eq(Q.Settings:Get("tracker.theme"), "nightelf", "unknown: unchanged")
    t.ok(Mock.printed('Unknown theme "bogus"'))
    qf("theme")
    t.ok(Mock.printed("neutral (Questify), contrast (High contrast), alliance (Alliance)"))
    t.ok(Mock.printed("Current theme: Night Elf"))
    qf("theme race")
    t.eq(Q.Settings:Get("theme.followRace"), true)
    t.eq(Q.UI.Tracker.themeKey, "dwarf")
    t.eq(#Mock.errors, 0)
  end,

  slash_opacity = function(t)
    local Q = load()
    local T = Q.UI.Tracker
    qf("opacity 50")
    t.eq(Q.Settings:Get("tracker.opacity"), 0.5)
    t.eq(T.frame.qvThemeBg:GetAlpha(), 0.5, "applied live")
    t.ok(Mock.printed(string.format(Q.L.UI_SLASH_OPACITY_SET, 50)))
    qf("opacity 75%")
    t.eq(Q.Settings:Get("tracker.opacity"), 0.75)
    qf("opacity 150")
    t.eq(Q.Settings:Get("tracker.opacity"), 1)
    qf("opacity -5")
    t.eq(Q.Settings:Get("tracker.opacity"), 0)
    qf("opacity")
    t.ok(Mock.printed(string.format(Q.L.UI_SLASH_OPACITY_HELP, 0)), "current value")
    qf("opacity abc")
    t.eq(Q.Settings:Get("tracker.opacity"), 0, "unchanged")
    t.ok(Q.L.UI_SLASH_HELP:find("/qf opacity", 1, true), "in the help")
    t.eq(#Mock.errors, 0)
  end,

  font_scale_grows_text_and_rows = function(t)
    local Q = load()
    local T = Q.UI.Tracker
    local fs = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    rawset(fs, "GetFont", function() return "Fonts\\FRIZQT__.TTF", 12, "" end)
    local log = spy(fs, { "SetFont" }, {})
    Q.Settings:Set("theme.fontScale", 1.3)
    t.eq(Q.Themes:FontScale(), 1.3)
    Q.Themes:StyleText(fs, "body", Q.Themes:Get("horde"))
    t.eq(last(log.SetFont), { "Fonts\\FRIZQT__.TTF", 15.5, "" }, "12 x 1.3, rounded to half a point")
    t.eq(T.themeScale, 1.3, "tracker restyled")
    t.eq(T:BodyTop(), 44 + 6 + 4 + 3 + 17 + 4, "bar text row grows with the text")
    Q.Settings:Set("theme.fontScale", 9)
    t.eq(Q.Themes:FontScale(), 1.5, "clamped")
    Q.Settings:Set("theme.fontScale", "junk")
    t.eq(Q.Themes:FontScale(), 1)
    local e = Q.OptionsSchema:Entry("theme.fontScale")
    t.eq({ e.min, e.max, e.step }, { 0.8, 1.5, 0.05 })
    t.eq(#Mock.errors, 0)
  end,

  hairline_is_one_screen_pixel = function(t)
    local Q = load()
    PixelUtil = { GetPixelToUIUnitFactor = function() return 0.5 end }
    local f, log = spyFrame()
    rawset(f, "GetEffectiveScale", function() return 0.8 end)
    Q.Themes:Apply(f, "horde", 1)
    local bd = last(log.SetBackdrop)[1]
    t.eq(bd.edgeSize, 0.625, "one screen pixel at this UI scale (ElvUI changes it)")
    t.ok(Q.Themes.Hairline(0.625) == bd, "cached")
    PixelUtil = nil
    Q.Themes:Apply(f, "horde", 1)
    t.eq(last(log.SetBackdrop)[1], Q.Themes.HAIRLINE, "without PixelUtil: 1 unit")
  end,
}
