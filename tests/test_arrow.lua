-- Tests de la flèche flottante (UI/Arrow.lua) et de l'aperçu en direct de la section Thème
-- (UI/ThemePreview.lua).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local function load(opts)
  Ext.install()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  return Mock.loadAddon(TOC, opts)
end

local function near(t, a, b, msg) t.ok(math.abs(a - b) < 1e-6, (msg or "") .. ": " .. tostring(a) .. " vs " .. tostring(b)) end

return {
  angle_follows_world_axes_and_facing = function(t)
    local Q = load()
    local A = Q.UI.Arrow
    -- X vers le nord, Y vers l'ouest ; facing 0 = nord, sens antihoraire
    near(t, A.Angle(0, 0, 10, 0, 0), 0, "north, facing north: straight ahead")
    near(t, A.Angle(0, 0, 0, 10, 0), math.pi / 2, "west: a quarter turn left")
    near(t, A.Angle(0, 0, 0, -10, 0), -math.pi / 2, "east: a quarter turn right")
    near(t, A.Angle(0, 0, 0, 10, math.pi / 2), 0, "west while facing west")
    near(t, math.abs(A.Angle(0, 0, -10, 0, 0)), math.pi, "behind")
  end,

  shows_distance_and_hides_without_target = function(t)
    GetPlayerFacing = function() return 0 end
    local Q = load()
    local A = Q.UI.Arrow
    t.ok(A.frame, "created at login")
    A:Update()
    t.ok(A.frame:IsShown(), "current step has a target")
    t.ok(A.distance:GetText():find("yd", 1, true), "distance: " .. tostring(A.distance:GetText()))
    t.ok(A.angle ~= nil, "rotated")
    -- position inconnue : cachée
    Mock.player.instance = true
    A:Update()
    t.ok(not A.frame:IsShown())
    Mock.player.instance = false
    -- désactivée
    Q.Settings:Set("arrow.show", false)
    A:Update()
    t.ok(not A.frame:IsShown(), "arrow.show off")
    GetPlayerFacing = nil
    t.eq(#Mock.errors, 0)
  end,

  colour_follows_the_setting = function(t)
    local Q = load()
    local A = Q.UI.Arrow
    local c = Q.Themes.ARROW_COLORS.cyan
    t.eq({ A.texture:GetVertexColor() }, { c[1], c[2], c[3], 1 })
    Q.Settings:Set("arrow.color", "gold")
    c = Q.Themes.ARROW_COLORS.gold
    t.eq({ A.texture:GetVertexColor() }, { c[1], c[2], c[3], 1 })
    Q.Settings:Set("arrow.color", "theme")
    local a = Q.Themes:Current().colors.accent
    t.eq({ A.texture:GetVertexColor() }, { a[1], a[2], a[3], 1 }, "theme accent")
    Q.Settings:Set("theme.followRace", false)
    Q.Settings:Set("tracker.theme", "horde")
    a = Q.Themes:Get("horde").colors.accent
    t.eq({ A.texture:GetVertexColor() }, { a[1], a[2], a[3], 1 }, "follows a theme change")
  end,

  live_preview_redraws_with_the_theme = function(t)
    local Q = load()
    local O, P = Q.UI.Options, Q.UI.ThemePreview
    O:Open("theme")
    t.ok(P.panel and O.preview:IsShown(), "preview built in the theme section")
    t.eq(P.trk.qvThemeKey, "dwarf", "the race theme")
    t.ok(P.trk.qvDecor and P.trk.qvDecor.header, "plain header")
    t.eq(P.scene, "kill")
    t.ok(P.lines[1]:IsShown() and not P.lines[5]:IsShown(), "kill scene: three lines")
    Mock.click(P.tabs[2], "LeftButton")
    t.eq(P.scene, "zone")
    t.ok(P.lines[8]:IsShown(), "zone scene: groups and monsters")
    Mock.click(P.tabs[3], "LeftButton")
    t.ok(P.item:IsShown(), "item button left of the tracker")
    Mock.click(P.tabs[1], "LeftButton")
    t.ok(not P.item:IsShown())
    -- changements : thème, fond, couleur de la flèche
    Q.Themes:Choose("troll")
    t.eq(P.trk.qvThemeKey, "troll")
    Q.Settings:Set("tracker.style", "none")
    t.eq(P.trk.qvThemeBackground, "none")
    t.ok(not P.trk.qvDecor.sky:IsShown(), "no header fill without a background")
    Q.Settings:Set("arrow.color", "pink")
    local c = Q.Themes.ARROW_COLORS.pink
    t.eq({ P.arrow:GetVertexColor() }, { c[1], c[2], c[3], 1 })
    t.eq(#Mock.errors, 0, tostring(Mock.errors[1]))
  end,
}
