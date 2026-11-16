local addonName, Q = ...

-- Thèmes de Questify (maquettes validées : docs/media/apercus/src/themes/maquette.html, valeurs dans
-- tokens.js). Un seul jeu de jetons de couleur et de textures pour toutes les fenêtres : les
-- modules lisent les jetons (Color, Hex, TextColor, StyleText) et posent les décorations
-- communes (Decorate, Emblem, SkinButton) sans coder de couleur en dur.
--
-- Thèmes de couleur seulement (choix de l'utilisateur, 2026-11-16) : fond, bordure de 1 px, liseré
-- de 2 px, en-tête en aplat, accent ; pas de bandeau illustré, de blason, de coins ni de cadre orné.
-- Quatorze thèmes, tous sur fond sombre : Questify (neutre, par défaut), Contraste élevé (noir,
-- texte blanc, accent jaune : lisibilité), Alliance, Humain, Nain,
-- Elfe de la nuit, Gnome, Skyborne (Alliance), Horde, Orc, Troll, Tauren, Mort-vivant, Skyborne
-- (Horde).
--
-- Réglages :
--   tracker.theme        clé du thème choisi (les anciennes clés parchment, dark, transparent et
--                        gradient valent Questify) ;
--   theme.followRace     vrai : le thème de la race du personnage s'applique (défaut) ;
--   tracker.style        fond du suivi : "solid" (bandeau et fond), "fade" (fondu), "none" (texte seul) ;
--   tracker.opacity      opacité du fond et de la bordure (0 à 1), le texte reste opaque ;
--   theme.font           "game" (police du jeu) ou "clean" (Inter, Media/Fonts) ;
--   theme.icons          "flat" (glyphes plats teintés) ou "game" (icônes jaunes du jeu) ;
--   theme.fontScale      taille du texte de toutes les fenêtres (0,8 à 1,5) ;
--   arrow.show, arrow.color   flèche flottante (UI/Arrow.lua) et sa couleur.
-- Changement de thème : Q:Fire("THEME_CHANGED", theme) ; les cadres passés à Decorate sont
-- repeints tout seuls.
Q.UI = Q.UI or {}
local Themes = {}
Q.Themes = Themes

local L = Q.L

local DEFAULT_KEY = "neutral"
local DEFAULT_OPACITY = 0.9
Themes.DEFAULT_KEY, Themes.DEFAULT_OPACITY = DEFAULT_KEY, DEFAULT_OPACITY

local MEDIA = "Interface\\AddOns\\Questify\\Media\\"
Themes.MEDIA = MEDIA
local TEX = {
  ring = MEDIA .. "Themes\\ring",              -- anneau du blason (blanc ombré, teinté métal)
  logo = MEDIA .. "Themes\\logo",              -- boussole de Questify (blason du thème neutre)
  skyborne = MEDIA .. "Themes\\skyborne",      -- blason Skyborne de secours (dessin Questify)
  mask = "Interface\\CharacterFrame\\TempPortraitAlphaMask",
  white = "Interface\\Buttons\\WHITE8X8",
}
Themes.TEX = TEX

---------------------------------------------------------------------------
-- Couleurs
---------------------------------------------------------------------------
-- "#rrggbb" (ou "rrggbb") et alpha -> { r, g, b, a }.
local function hex(s, a)
  s = s:gsub("^#", "")
  return { tonumber(s:sub(1, 2), 16) / 255, tonumber(s:sub(3, 4), 16) / 255, tonumber(s:sub(5, 6), 16) / 255, a or 1 }
end
Themes.HexColor = hex

-- Couleurs de sens, communes à tous les thèmes (tous les fonds sont sombres : une quête a la même
-- couleur partout).
local SHARED = {
  quest = hex("ffd773"), npc = hex("94caff"), mob = hex("f57a7a"), item = hex("c7adff"),
  object = hex("7cc4ff"), success = hex("6bd99a"), warning = hex("fabf4d"), danger = hex("f57373"),
  xp = hex("9fc4ff"), zone = hex("7fe08a"), orange = hex("ffa060"),
}
Themes.SHARED = SHARED

-- Palettes (maquette : tokens.js). Rôles :
--   bg fond des fenêtres, panel panneaux et info-bulles, panelAlt contrôles, sidebar barre latérale,
--   footer pied, sky haut du bandeau, edge bordure de 1 px, line filets (alpha), text / textDim /
--   textMuted texte principal, secondaire, discret, accent couleur du thème, onAccent texte sur
--   l'accent, trim second accent, metal coins, anneau et liseré.
local P = {
  neutral = { bg = "0c1724", panel = "102030", panelAlt = "15283b", sidebar = "09121c", footer = "0a141f",
    sky = "183a58", edge = "2a4258", line = { "82c8eb", 0.12 }, text = "eef3f7", textDim = "b9c7d3",
    textMuted = "8fa0b0", accent = "3fd0e6", onAccent = "04161d", trim = "d4a94f", metal = "d4a94f" },
  contrast = { bg = "000000", panel = "0b0b0b", panelAlt = "161616", sidebar = "000000", footer = "050505",
    sky = "1a1a1a", edge = "ffffff", line = { "ffffff", 0.45 }, text = "ffffff", textDim = "f0f0f0",
    textMuted = "d4d4d4", accent = "ffd60a", onAccent = "000000", trim = "ffd60a", metal = "ffffff" },
  alliance = { bg = "141b2b", panel = "182136", panelAlt = "1f2a44", sidebar = "10162a", footer = "121929",
    sky = "21345c", edge = "2f3f63", line = { "c8d7ff", 0.10 }, text = "f2f5fb", textDim = "c0c9dc",
    textMuted = "97a2ba", accent = "5e93ea", onAccent = "08111f", trim = "d9b45a", metal = "d9b45a" },
  human = { bg = "171c25", panel = "1c222d", panelAlt = "252d3b", sidebar = "12171f", footer = "151a22",
    sky = "2a3a55", edge = "36435a", line = { "d2def5", 0.10 }, text = "f3f5f9", textDim = "c3cbd8",
    textMuted = "9aa4b5", accent = "86a9d8", onAccent = "0c1220", trim = "dcc27a", metal = "dcc27a" },
  dwarf = { bg = "1c1d20", panel = "222327", panelAlt = "2c2d32", sidebar = "17181b", footer = "19191c",
    sky = "38322c", edge = "45403a", line = { "fff0e1", 0.09 }, text = "f5f4f2", textDim = "cbc7c1",
    textMuted = "a39e97", accent = "d68f4c", onAccent = "150c04", trim = "d68f4c", metal = "c98a4a" },
  nightelf = { bg = "18162a", panel = "1e1b33", panelAlt = "272342", sidebar = "131124", footer = "151327",
    sky = "2e2658", edge = "3b3463", line = { "dcd2ff", 0.10 }, text = "f4f2fb", textDim = "c9c3de",
    textMuted = "a19abb", accent = "ae92ee", onAccent = "120c24", trim = "6fd3c6", metal = "c9d2e6" },
  gnome = { bg = "151c20", panel = "1a2227", panelAlt = "222d33", sidebar = "11171b", footer = "13191d",
    sky = "1d3a41", edge = "2d444b", line = { "c8f5f0", 0.09 }, text = "f1f7f7", textDim = "bfd0d1",
    textMuted = "95a9ab", accent = "45c4b2", onAccent = "04140f", trim = "e48ac1", metal = "d08a5a" },
  skyborneA = { bg = "141c26", panel = "19232f", panelAlt = "212e3d", sidebar = "10171f", footer = "121a23",
    sky = "244a68", edge = "2f475e", line = { "cde8ff", 0.10 }, text = "f2f7fc", textDim = "bfd0e0",
    textMuted = "94a8bc", accent = "6ec8f2", onAccent = "04121b", trim = "eef4fb", metal = "dfe6f0" },
  horde = { bg = "1d1918", panel = "241f1e", panelAlt = "2e2826", sidebar = "171413", footer = "1a1615",
    sky = "3e211e", edge = "4a3330", line = { "ffe1dc", 0.09 }, text = "f7f3f2", textDim = "d0c6c4",
    textMuted = "a99d9a", accent = "e0574b", onAccent = "170605", trim = "b98a52", metal = "b98a52" },
  orc = { bg = "1a1c18", panel = "20231e", panelAlt = "292d26", sidebar = "151713", footer = "171915",
    sky = "33392a", edge = "3f4536", line = { "ebf5dc", 0.09 }, text = "f4f6f1", textDim = "c8cdc0",
    textMuted = "a0a697", accent = "d86a3d", onAccent = "170802", trim = "8db455", metal = "a8957a" },
  troll = { bg = "131d1c", panel = "182423", panelAlt = "1f2e2c", sidebar = "0f1817", footer = "111a19",
    sky = "183c38", edge = "284541", line = { "c8faf0", 0.09 }, text = "f0f8f6", textDim = "bcd3ce",
    textMuted = "92aca6", accent = "3fc2a0", onAccent = "03140f", trim = "e5734d", metal = "d8c49a" },
  tauren = { bg = "1e1c19", panel = "25221e", panelAlt = "2f2b26", sidebar = "181613", footer = "1a1815",
    sky = "3d3124", edge = "4a3f33", line = { "fff0d7", 0.09 }, text = "f6f4f0", textDim = "cfc8bd",
    textMuted = "a79f93", accent = "d9a85e", onAccent = "160e03", trim = "4fb5ab", metal = "c99a5a" },
  undead = { bg = "171918", panel = "1d201e", panelAlt = "262a27", sidebar = "121413", footer = "141615",
    sky = "2a3029", edge = "373e37", line = { "e1f5dc", 0.09 }, text = "f2f5f1", textDim = "c4cbc2",
    textMuted = "9ca499", accent = "a2d164", onAccent = "0b1403", trim = "9481cc", metal = "a9aab8" },
  skyborneH = { bg = "1b1823", panel = "211d2b", panelAlt = "2a2537", sidebar = "16131d", footer = "18151f",
    sky = "45304d", edge = "463d55", line = { "f0dcff", 0.10 }, text = "f6f3fa", textDim = "cdc4d9",
    textMuted = "a69cb4", accent = "ec9165", onAccent = "1a0904", trim = "ac90e6", metal = "d0a6e8" },
}

-- Identité de chaque thème : nom, groupe (picker), races qui le suivent (raceFile d'UnitRace et
-- identifiant de race), blason.
--   emblem : candidats essayés dans l'ordre, le premier présent dans le client gagne :
--     { atlas = "…" } (C_Texture.GetAtlasInfo), { file = "…" } (GetFileIDFromPath quand il existe).
--     %s dans un nom = "male" / "female" (Male / Female pour les fichiers) selon le personnage.
local function raceEmblem(atlasName, fileName, extra)
  local list = {
    { atlas = "raceicon128-" .. atlasName .. "-%s" },
    { atlas = "raceicon-" .. atlasName .. "-%s" },
    { file = "Interface\\Icons\\Achievement_Character_" .. fileName .. "_%S" },
    { file = "Interface\\CharacterFrame\\TemporaryPortrait-%S-" .. fileName },
  }
  if extra then list[#list + 1] = extra end
  return list
end
local IDENTITY = {
  neutral = { label = "UI_THEME_NEUTRAL", group = "neutral", emblem = { { file = TEX.logo } } },
  contrast = { label = "UI_THEME_CONTRAST", group = "neutral", emblem = { { file = TEX.logo } } },
  alliance = { label = "UI_THEME_ALLIANCE", group = "alliance", faction = "Alliance",
    emblem = { { file = "Interface\\Icons\\Achievement_PVP_A_A" }, { file = "Interface\\Icons\\INV_BannerPVP_02" } } },
  human = { label = "UI_THEME_HUMAN", group = "alliance", faction = "Alliance", races = { Human = true },
    emblem = raceEmblem("human", "Human") },
  dwarf = { label = "UI_THEME_DWARF", group = "alliance", faction = "Alliance", races = { Dwarf = true },
    emblem = raceEmblem("dwarf", "Dwarf") },
  nightelf = { label = "UI_THEME_NIGHTELF", group = "alliance", faction = "Alliance", races = { NightElf = true },
    emblem = raceEmblem("nightelf", "NightElf") },
  gnome = { label = "UI_THEME_GNOME", group = "alliance", faction = "Alliance", races = { Gnome = true },
    emblem = raceEmblem("gnome", "Gnome") },
  skyborneA = { label = "UI_THEME_SKYBORNE", group = "alliance", faction = "Alliance", raceIds = { [95] = true },
    emblem = raceEmblem("skyborne", "Skyborne", { file = TEX.skyborne }) },
  horde = { label = "UI_THEME_HORDE", group = "horde", faction = "Horde",
    emblem = { { file = "Interface\\Icons\\Achievement_PVP_H_H" }, { file = "Interface\\Icons\\INV_BannerPVP_01" } } },
  orc = { label = "UI_THEME_ORC", group = "horde", faction = "Horde", races = { Orc = true },
    emblem = raceEmblem("orc", "Orc") },
  troll = { label = "UI_THEME_TROLL", group = "horde", faction = "Horde", races = { Troll = true },
    emblem = raceEmblem("troll", "Troll") },
  tauren = { label = "UI_THEME_TAUREN", group = "horde", faction = "Horde", races = { Tauren = true },
    emblem = raceEmblem("tauren", "Tauren") },
  undead = { label = "UI_THEME_UNDEAD", group = "horde", faction = "Horde", races = { Scourge = true, Undead = true },
    emblem = raceEmblem("undead", "Undead", { file = "Interface\\CharacterFrame\\TemporaryPortrait-%S-Scourge" }) },
  skyborneH = { label = "UI_THEME_SKYBORNE", group = "horde", faction = "Horde", raceIds = { [96] = true },
    emblem = raceEmblem("skyborne", "Skyborne", { file = TEX.skyborne }) },
}
local ORDER = { "neutral", "contrast", "alliance", "human", "dwarf", "nightelf", "gnome", "skyborneA",
  "horde", "orc", "troll", "tauren", "undead", "skyborneH" }
Themes.ORDER = ORDER

-- Anciennes clés (thèmes du suivi avant la refonte) : elles valent Questify ; transparent et
-- gradient gardent leur fond (style "none" / "fade") tant que le joueur n'a pas choisi de style.
local LEGACY = { parchment = "solid", dark = "solid", transparent = "none", gradient = "fade" }
Themes.LEGACY = LEGACY

---------------------------------------------------------------------------
-- Construction des thèmes
---------------------------------------------------------------------------
local function toHex(c)
  return string.format("ff%02x%02x%02x", math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5),
    math.floor(c[3] * 255 + 0.5))
end
Themes.ToHex = toHex

local function mix(a, b, k)
  return { a[1] + (b[1] - a[1]) * k, a[2] + (b[2] - a[2]) * k, a[3] + (b[3] - a[3]) * k, 1 }
end

-- Bordure de 1 px (BackdropTemplate, bordure seule : le fond est une texture à part). Table
-- constante : SetBackdrop ne refait rien quand on lui redonne la même table.
local HAIRLINE = { edgeFile = TEX.white, edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 } }
Themes.HAIRLINE = HAIRLINE
-- Une bordure d'un pixel écran exact, quelle que soit l'échelle de l'interface (ElvUI la change :
-- un filet de 1 unité deviendrait flou ou disparaîtrait). Tables en cache par taille.
local hairlines = { [1] = HAIRLINE }
local function hairline(size)
  if not size or size == 1 then return HAIRLINE end
  size = math.floor(size * 1000 + 0.5) / 1000
  local h = hairlines[size]
  if not h then
    h = { edgeFile = TEX.white, edgeSize = size, insets = { left = size, right = size, top = size, bottom = size } }
    hairlines[size] = h
  end
  return h
end
-- Taille d'un pixel écran dans l'échelle de frame (PixelUtil du jeu), 1 sans cette API.
local function pixel(frame)
  local PU = PixelUtil
  if type(PU) == "table" and type(PU.GetPixelToUIUnitFactor) == "function" and frame and frame.GetEffectiveScale then
    local ok, factor = pcall(PU.GetPixelToUIUnitFactor)
    local scale = frame:GetEffectiveScale()
    if ok and tonumber(factor) and tonumber(scale) and scale > 0 then
      local px = factor / scale
      if px > 0 and px < 4 then return px end
    end
  end
  return 1
end
Themes.Pixel, Themes.Hairline = pixel, hairline

local SHADOW = { color = { 0, 0, 0, 1 }, x = 1, y = -1 }
local NO_SHADOW = { color = { 0, 0, 0, 0 }, x = 0, y = 0 }

local function build(key)
  local p, id = P[key], IDENTITY[key]
  local c = {}
  for role, v in pairs(p) do
    if type(v) == "table" then c[role] = hex(v[1], v[2]) else c[role] = hex(v) end
  end
  for role, v in pairs(SHARED) do c[role] = v end
  c.sel = { c.accent[1], c.accent[2], c.accent[3], 0.16 }
  c.line2 = { 1, 1, 1, 0.13 }
  -- fond des blocs de code (macros) : plus sombre que le fond, pour un texte clair
  c.code = c.code or mix(c.bg, { 0, 0, 0 }, 0.45)
  -- bandeau : silhouette lointaine et premier plan (cuits dans la texture, gardés pour l'aperçu)
  c.far = mix(c.bg, { 0, 0, 0 }, 0.05)
  c.near = mix(c.bg, { 0, 0, 0 }, 0.3)

  -- Rôles de texte du suivi et des fenêtres (compatibles avec les rôles d'avant la refonte).
  local text = {
    title = c.text, body = c.text, dim = c.textDim, muted = c.textMuted, levels = c.textDim,
    distance = c.textDim, bar = c.textDim, xp = c.xp, warn = c.warning, classAlert = c.warning,
    dungeonAlert = c.orange, trainerAlert = c.npc, accent = c.accent, quest = c.quest, npc = c.npc,
    mob = c.mob, item = c.item, success = c.success, danger = c.danger, onAccent = c.onAccent,
  }
  -- Codes de couleur intégrés aux textes (Engine/Format.lua, textes, modules de confort, suivi)
  -- remplacés par la teinte de même sens du thème.
  local codes = {
    ffffffff = toHex(c.text),        -- objectif à faire, objectif suivi par la flèche
    ffffd100 = toHex(c.quest),       -- nom de quête, groupes du mode zone
    ff00ff96 = toHex(c.npc),         -- PNJ
    ffff6060 = toHex(c.mob),         -- monstre
    ff66bbff = toHex(c.object),      -- objet du monde
    ff999999 = toHex(c.textMuted),   -- note
    ff808080 = toHex(mix(c.textMuted, c.bg, 0.25)),   -- fait
    ffaaaaaa = toHex(c.textDim),     -- niveau, texte gris
    ffc8c8c8 = toHex(c.textDim),     -- objectif du mode zone, rythme dans les temps
    ff40e050 = toHex(c.zone),        -- ligne de la zone, gain, avance
    ff40ff40 = toHex(c.success),     -- pierre de foyer prête
    ffff5555 = toHex(c.danger),      -- raison du blocage, perte
    ffffb040 = toHex(c.warning),     -- pierre de foyer en recharge, retard
    ffff8040 = toHex(c.orange),      -- danger
    ffffd040 = toHex(c.warning),     -- sacs, réparation
  }
  return {
    key = key, label = id.label, group = id.group, faction = id.faction, races = id.races,
    raceIds = id.raceIds, emblemCandidates = id.emblem,
    colors = c, text = text, codes = codes,
    background = { kind = "color", color = c.bg },
    border = { backdrop = HAIRLINE, color = c.edge, inset = 1 },
    shadow = SHADOW,
    bar = { fill = c.accent, bg = { c.line2[1], c.line2[2], c.line2[3], c.line2[4] } },
    glowBlend = "ADD",
    style = "solid",
    decor = true,      -- bandeau, blason, coins et liseré
  }
end

local THEMES = {}
for _, key in ipairs(ORDER) do THEMES[key] = build(key) end
Themes.themes = THEMES

-- Variante d'un thème pour le fond du suivi ("fade" : fondu vers le bas, sans bandeau ; "none" :
-- ni fond ni bordure, texte cerné de noir). Mise en cache : même table pour le même couple.
local variants = {}
local function variant(theme, style)
  if style ~= "fade" and style ~= "none" then return theme end
  local id = theme.key .. ":" .. style
  local v = variants[id]
  if v then return v end
  v = {}
  for k, val in pairs(theme) do v[k] = val end
  local bg = theme.colors.bg
  v.style, v.decor = style, false
  v.border = nil
  if style == "fade" then
    v.background = { kind = "gradient", orientation = "VERTICAL",
      from = { bg[1], bg[2], bg[3], 0 }, to = { bg[1], bg[2], bg[3], 1 } }
  else
    v.background = { kind = "none" }
    v.outline = true
  end
  -- sur le monde, le texte discret est éclairci
  v.text = {}
  for role, col in pairs(theme.text) do v.text[role] = col end
  v.text.dim = mix(theme.colors.textDim, { 1, 1, 1 }, 0.15)
  v.text.muted = theme.colors.textDim
  variants[id] = v
  return v
end

---------------------------------------------------------------------------
-- Accès
---------------------------------------------------------------------------
-- Clé valide, sinon nil. Accepte le nom affiché (sans tenir compte de la casse) ; les anciennes
-- clés valent Questify.
function Themes:Find(key)
  if type(key) ~= "string" then return nil end
  if THEMES[key] then return key end
  if LEGACY[key] then return DEFAULT_KEY end
  local wanted = key:lower()
  for _, k in ipairs(ORDER) do
    if k:lower() == wanted or tostring(L[THEMES[k].label]):lower() == wanted then return k end
  end
  return nil
end

-- Clé valide (Questify pour une clé inconnue ou absente).
function Themes:Resolve(key)
  return self:Find(key) or DEFAULT_KEY
end

-- Q.Themes:Get(key[, style]) -> thème ; clé inconnue : Questify.
function Themes:Get(key, style)
  return variant(THEMES[self:Resolve(key)], style)
end

-- Q.Themes:List() -> { { key, label, group } } dans l'ordre d'affichage.
function Themes:List()
  local out = {}
  for _, k in ipairs(ORDER) do
    local th = THEMES[k]
    out[#out + 1] = { key = k, label = L[th.label], group = th.group, faction = th.faction }
  end
  return out
end

-- Opacité du fond et de la bordure, ramenée entre 0 et 1 (0,9 si absente ou illisible).
function Themes:Opacity(value)
  local v = tonumber(value)
  if not v or v ~= v then return DEFAULT_OPACITY end
  return math.max(0, math.min(1, v))
end

local function setting(path)
  return Q.Settings and Q.Settings:Get(path)
end

-- Clé du thème de la race du personnage (nil si la race n'a pas de thème).
function Themes:RaceKey()
  if type(UnitRace) ~= "function" then return nil end
  local _, raceFile, raceId = UnitRace("player")
  for _, k in ipairs(ORDER) do
    local th = THEMES[k]
    if (th.races and raceFile and th.races[raceFile]) or (th.raceIds and raceId and th.raceIds[raceId]) then
      return k
    end
  end
  return nil
end

-- Vrai si le thème suit la race du personnage (réglage theme.followRace).
function Themes:FollowsRace()
  return setting("theme.followRace") ~= false
end

-- Clé du thème en vigueur : celui de la race (si suivi et connu), sinon le réglage tracker.theme.
function Themes:CurrentKey()
  if self:FollowsRace() then
    local race = self:RaceKey()
    if race then return race end
  end
  return self:Resolve(setting("tracker.theme"))
end

-- Fond du suivi : "solid", "fade" ou "none". Une ancienne clé transparent / gradient garde son
-- fond tant que tracker.theme n'a pas été rechoisi.
function Themes:Style()
  local legacy = LEGACY[setting("tracker.theme") or ""]
  if legacy and legacy ~= "solid" and not self:FollowsRace() then return legacy end
  local s = setting("tracker.style")
  if s == "fade" or s == "none" then return s end
  return "solid"
end

-- Thème en vigueur (fenêtres) ; avec style, sa variante (suivi).
function Themes:Current(style)
  return self:Get(self:CurrentKey(), style)
end

-- Choix d'un thème par le joueur : enregistre la clé et décoche « suivre la race » si le thème
-- choisi n'est pas celui de sa race.
function Themes:Choose(key)
  key = self:Find(key)
  if not key then return nil end
  Q.Settings:Set("tracker.theme", key)
  if key ~= self:RaceKey() and self:FollowsRace() then Q.Settings:Set("theme.followRace", false) end
  return key
end

---------------------------------------------------------------------------
-- Jetons de couleur
---------------------------------------------------------------------------
-- Q.Themes:Color(role[, theme]) -> r, g, b, a (rôles des palettes, couleurs de sens, sel, line2).
function Themes:Color(role, theme)
  theme = theme or self:Current()
  local c = theme.colors[role] or theme.colors.text
  return c[1], c[2], c[3], c[4] or 1
end

-- Q.Themes:Hex(role[, theme]) -> "ffrrggbb" pour les codes |c des textes.
function Themes:Hex(role, theme)
  theme = theme or self:Current()
  return toHex(theme.colors[role] or theme.colors.text)
end

-- Couleur de la flèche flottante (réglage arrow.color) -> r, g, b.
local ARROW_COLORS = {
  cyan = hex("3fd0e6"), gold = hex("f0c75a"), green = hex("5fe08a"), white = hex("f2f4f7"), pink = hex("ff7ab8"),
}
Themes.ARROW_COLORS = ARROW_COLORS
Themes.ARROW_ORDER = { "cyan", "theme", "gold", "green", "white", "pink" }
function Themes:ArrowColor(theme)
  local key = setting("arrow.color") or "cyan"
  local c = ARROW_COLORS[key]
  if not c then c = (theme or self:Current()).colors.accent end
  return c[1], c[2], c[3]
end

-- Icône d'une étape (réglage theme.icons) : glyphe plat teint de la couleur des quêtes pour
-- prendre et rendre, sinon l'icône du jeu (Q.Format:ActionIcon). -> texture, r, g, b (nil : pas de
-- teinte).
local GLYPHS = { accept = MEDIA .. "Themes\\glyph-accept", turnin = MEDIA .. "Themes\\glyph-turnin" }
Themes.GLYPHS = GLYPHS
function Themes:StepIcon(action, theme)
  local glyph = GLYPHS[action]
  if glyph and setting("theme.icons") ~= "game" then
    local c = (theme or self:Current()).colors.quest
    return glyph, c[1], c[2], c[3]
  end
  return Q.Format and Q.Format:ActionIcon(action) or nil
end

---------------------------------------------------------------------------
-- Texte
---------------------------------------------------------------------------
-- Remplace les codes de couleur connus par ceux du thème (texte inchangé sans table de codes).
function Themes:Recolor(text, theme)
  if type(text) ~= "string" then return text end
  theme = theme or self:Current()
  local map = theme and theme.codes
  if not map or not text:find("|c", 1, true) then return text end
  return (text:gsub("|c(%x%x%x%x%x%x%x%x)", function(h)
    local to = map[h:lower()]
    if to then return "|c" .. to end
  end))
end

-- Couleur d'un rôle : { r, g, b } (body pour un rôle inconnu).
function Themes:TextColor(role, theme)
  theme = theme or self:Current()
  return theme.text[role] or theme.text.body
end

-- Police lisible (Inter, OFL) livrée avec Questify.
local CLEAN_FONT = MEDIA .. "Fonts\\Inter-Medium.ttf"
local CLEAN_FONT_BOLD = MEDIA .. "Fonts\\Inter-SemiBold.ttf"
Themes.CLEAN_FONT, Themes.CLEAN_FONT_BOLD = CLEAN_FONT, CLEAN_FONT_BOLD
function Themes:FontKind()
  return setting("theme.font") == "clean" and "clean" or "game"
end

-- Taille du texte (réglage theme.fontScale), ramenée entre 0,8 et 1,5.
function Themes:FontScale()
  local v = tonumber(setting("theme.fontScale"))
  if not v or v ~= v then return 1 end
  return math.max(0.8, math.min(1.5, v))
end

-- Police d'une ligne de texte : fichier du jeu ou Inter, taille d'origine × taille du texte,
-- contour éventuel. La police d'origine est gardée la première fois (fs.qvBaseFont).
local function baseFont(fs)
  local base = fs.qvBaseFont
  if not base and fs.GetFont then
    local file, size, flags = fs:GetFont()
    if type(file) == "string" and tonumber(size) then
      base = { file, size, flags or "" }
      fs.qvBaseFont = base
      fs.qvFontFlags, fs.qvFontFile, fs.qvFontSize = base[3], base[1], base[2]
    end
  end
  return base
end
local function applyFont(fs, flags, bold)
  local base = baseFont(fs)
  if not (base and fs.SetFont) then return end
  flags = flags or fs.qvFontFlagsWanted or base[3]
  local file = base[1]
  if Themes:FontKind() == "clean" then file = bold and CLEAN_FONT_BOLD or CLEAN_FONT end
  local size = math.floor(base[2] * Themes:FontScale() * 2 + 0.5) / 2
  if fs.qvFontFlags ~= flags or fs.qvFontFile ~= file or fs.qvFontSize ~= size then
    local ok = pcall(fs.SetFont, fs, file, size, flags)
    if not ok then fs:SetFont(base[1], size, flags); file = base[1] end
    fs.qvFontFlags, fs.qvFontFile, fs.qvFontSize = flags, file, size
  end
end
Themes.ApplyFont = applyFont

-- Police (taille du texte, police lisible) sur toutes les lignes de texte d'un arbre de cadres.
function Themes:ScaleTree(root, depth)
  if not root or (depth or 0) > 14 then return end
  for _, r in ipairs({ root:GetRegions() }) do
    if r.GetObjectType and r:GetObjectType() == "FontString" then applyFont(r, nil, r.qvBold) end
  end
  for _, child in ipairs({ root:GetChildren() }) do
    if child.GetFontString then
      local fs = child:GetFontString()
      if fs then applyFont(fs) end
    end
    self:ScaleTree(child, (depth or 0) + 1)
  end
end

-- Couleur, ombre, contour et police d'une ligne de texte. Le texte reste opaque quelle que soit
-- l'opacité. La police d'origine est gardée pour revenir à la police du jeu ou retirer le contour.
function Themes:StyleText(fs, role, theme)
  if not fs then return end
  theme = theme or self:Current()
  local c = self:TextColor(role, theme)
  fs:SetTextColor(c[1], c[2], c[3], 1)
  local sh = theme.shadow or SHADOW
  if theme.outline then sh = SHADOW end
  if fs.SetShadowColor then fs:SetShadowColor(sh.color[1], sh.color[2], sh.color[3], sh.color[4]) end
  if fs.SetShadowOffset then fs:SetShadowOffset(sh.x, sh.y) end
  local base = baseFont(fs)
  if base then
    local flags = theme.outline and "OUTLINE" or base[3]
    fs.qvFontFlagsWanted, fs.qvBold = flags, role == "title"
    applyFont(fs, flags, role == "title")
  end
end
Themes.NO_SHADOW = NO_SHADOW

---------------------------------------------------------------------------
-- Textures du client
---------------------------------------------------------------------------
-- Vrai si l'atlas existe dans le client (C_Texture.GetAtlasInfo) ; sans cette API, SetAtlas est
-- tenté sous pcall.
local function atlasAvailable(atlas)
  if type(atlas) ~= "string" or atlas == "" then return false end
  local CT = C_Texture
  if type(CT) == "table" and type(CT.GetAtlasInfo) == "function" then
    local ok, info = pcall(CT.GetAtlasInfo, atlas)
    return ok and info ~= nil
  end
  return true
end
Themes.AtlasAvailable = atlasAvailable

-- Vrai si le fichier existe dans le client (GetFileIDFromPath) ; sans cette API, on suppose que oui.
-- Les fichiers de Questify sont toujours là.
local function fileAvailable(path)
  if type(path) ~= "string" or path == "" then return false end
  if path:find(MEDIA, 1, true) == 1 then return true end
  if type(GetFileIDFromPath) == "function" then
    local ok, id = pcall(GetFileIDFromPath, path)
    return ok and id ~= nil
  end
  return true
end
Themes.FileAvailable = fileAvailable

local function playerSex()
  local s = type(UnitSex) == "function" and UnitSex("player") or 2
  return s == 3 and "female" or "male"
end

-- Blason d'un thème : { atlas = … } ou { file = … }, choisi une fois par thème et par sexe.
local emblemCache = {}
function Themes:ResetEmblems() emblemCache = {} end
function Themes:EmblemSource(theme)
  theme = theme or self:Current()
  local sex = playerSex()
  local id = theme.key .. sex
  if emblemCache[id] then return emblemCache[id] end
  local Sex = sex == "female" and "Female" or "Male"
  local chosen
  for _, cand in ipairs(theme.emblemCandidates or {}) do
    if cand.atlas then
      local name = cand.atlas:gsub("%%s", sex)
      if atlasAvailable(name) and C_Texture and C_Texture.GetAtlasInfo then chosen = { atlas = name }; break end
    elseif cand.file then
      local path = cand.file:gsub("%%S", Sex)
      if fileAvailable(path) then chosen = { file = path }; break end
    end
  end
  chosen = chosen or { file = TEX.logo }
  emblemCache[id] = chosen
  return chosen
end

local function setEmblemTexture(tex, theme)
  local src = Themes:EmblemSource(theme)
  if src.atlas then
    if not pcall(tex.SetAtlas, tex, src.atlas) then tex:SetTexture(TEX.logo) end
    tex:SetTexCoord(0, 1, 0, 1)
  else
    tex:SetTexture(src.file)
    -- les icônes du jeu ont un bord : on rogne un peu
    if src.file:find("Interface\\Icons\\", 1, true) then tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    else tex:SetTexCoord(0, 1, 0, 1) end
  end
end
Themes.SetEmblemTexture = setEmblemTexture

---------------------------------------------------------------------------
-- Fond et bordure (compatibles avec l'ancien Apply)
---------------------------------------------------------------------------
local function backgroundTexture(frame, field, subLevel)
  local tx = frame[field]
  if not tx then
    tx = frame:CreateTexture(nil, "BACKGROUND", nil, subLevel)
    frame[field] = tx
  end
  return tx
end

local function fit(tx, frame, inset)
  tx:ClearAllPoints()
  tx:SetPoint("TOPLEFT", frame, "TOPLEFT", inset, -inset)
  tx:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -inset, inset)
end

-- Fond en dégradé : texture blanche teintée par SetGradient (CreateColor). Sans ces API :
-- couleur unie à mi-chemin.
local function applyGradient(tx, spec)
  local from, to = spec.from, spec.to
  tx:SetColorTexture(1, 1, 1, 1)
  if type(CreateColor) == "function" and tx.SetGradient then
    local ok = pcall(tx.SetGradient, tx, spec.orientation or "VERTICAL",
      CreateColor(from[1], from[2], from[3], from[4]), CreateColor(to[1], to[2], to[3], to[4]))
    if ok then return "gradient" end
  end
  tx:SetColorTexture(to[1], to[2], to[3], ((from[4] or 1) + (to[4] or 1)) / 2)
  return "color"
end
Themes.ApplyGradient = applyGradient

-- Q.Themes:Apply(frame, themeKey, opacity[, style]) -> thème appliqué.
-- Pose le fond et la bordure de 1 px du thème sur frame (BackdropTemplate pour la bordure). Le fond
-- et la bordure prennent l'opacité ; frame garde un alpha de 1, le texte n'est jamais atténué.
-- style ("solid", "fade", "none") : fond du suivi ; les autres fenêtres le laissent vide.
-- frame.qvThemeBackground = "color" | "gradient" | "none". Les décorations (Decorate) suivent.
function Themes:Apply(frame, themeKey, opacity, style)
  local theme = self:Get(themeKey, style)
  if not frame then return theme end
  -- gabarits de Blizzard sans BackdropTemplate (ButtonFrameTemplate…) : la bordure de 1 px passe
  -- par le mixin du jeu
  if not frame.SetBackdrop and type(Mixin) == "function" and type(BackdropTemplateMixin) == "table" then
    Mixin(frame, BackdropTemplateMixin)
    if frame.HookScript and frame.OnBackdropSizeChanged then
      frame:HookScript("OnSizeChanged", frame.OnBackdropSizeChanged)
    end
  end
  local alpha = self:Opacity(opacity)
  local spec = theme.background or { kind = "none" }
  local inset = theme.border and theme.border.inset or 0
  local solid = backgroundTexture(frame, "qvThemeBg", -8)
  local grad = backgroundTexture(frame, "qvThemeGradient", -7)
  fit(solid, frame, inset)
  fit(grad, frame, inset)
  solid:Hide()
  grad:Hide()
  local used = "none"
  if spec.kind == "color" then
    local c = spec.color
    solid:SetColorTexture(c[1], c[2], c[3], 1)
    solid:Show()
    used = "color"
  elseif spec.kind == "gradient" then
    used = applyGradient(grad, spec)
    grad:Show()
  end
  solid:SetAlpha(alpha)
  grad:SetAlpha(alpha)
  frame.qvThemeBackground = used

  if frame.SetBackdrop then
    local border = theme.border
    if border then
      frame:SetBackdrop(border.backdrop == HAIRLINE and hairline(pixel(frame)) or border.backdrop)
      local c = border.color
      if frame.SetBackdropBorderColor then
        frame:SetBackdropBorderColor(c[1], c[2], c[3], (c[4] or 1) * alpha)
      end
    else
      frame:SetBackdrop(nil)
    end
  end
  frame.qvThemeKey, frame.qvThemeOpacity = theme.key, alpha
  if frame.qvDecor then self:Paint(frame, theme, alpha) end
  return theme
end

---------------------------------------------------------------------------
-- Couleurs de signal (marques posées hors du suivi, par exemple sur les récompenses de quête,
-- UI/RewardMarks.lua) : upgrade (amélioration), value (plus cher à la revente), muted (neutre).
-- Un thème peut les remplacer par sa table signals = { [rôle] = { r, g, b } } ; sinon ces valeurs,
-- choisies pour rester lisibles sur le parchemin comme sur une interface sombre (glyphes cernés
-- de noir).
---------------------------------------------------------------------------
local SIGNALS = {
  upgrade = { 0.25, 0.88, 0.25 },
  value = { 1, 0.78, 0.10 },
  muted = { 0.62, 0.62, 0.62 },
}
Themes.SIGNALS = SIGNALS

-- Q.Themes:SignalColor(role, theme) -> r, g, b (muted pour un rôle inconnu).
function Themes:SignalColor(role, theme)
  theme = theme or self:Current()
  local c = (theme and theme.signals and theme.signals[role]) or SIGNALS[role] or SIGNALS.muted
  return c[1], c[2], c[3]
end

---------------------------------------------------------------------------
-- Couleur d'un code (suivi des objectifs, zones sur la carte)
---------------------------------------------------------------------------
-- Couleur { r, g, b } (0 à 1) d'un code de couleur Questify (« ffff6060 », avec ou sans « |c ») tel
-- que le thème l'affiche : remplacé par theme.codes s'il y figure, sinon lu tel quel. Les objectifs
-- et les zones de la carte n'ont pas de teintes propres : ils reprennent ces codes.
-- Code illisible : nil.
function Themes:CodeColor(hex, theme)
  if type(hex) ~= "string" then return nil end
  hex = hex:gsub("^|c", ""):lower()
  if not hex:match("^%x%x%x%x%x%x%x%x$") then return nil end
  theme = theme or self:Current()
  local to = theme and theme.codes and theme.codes[hex] or hex
  local r, g, b = tonumber(to:sub(3, 4), 16), tonumber(to:sub(5, 6), 16), tonumber(to:sub(7, 8), 16)
  return { r / 255, g / 255, b / 255 }
end

---------------------------------------------------------------------------
-- Décorations : blason, bandeau illustré, coins et liseré de métal, filigrane
---------------------------------------------------------------------------
-- Couleur de métal ombrée : les textures d'anneau et de coin sont blanches et ombrées, la couleur
-- de sommet les teinte.
local function tintMetal(tex, theme)
  local m = theme.colors.metal
  tex:SetVertexColor(m[1], m[2], m[3], 1)
end

-- Q.Themes:Emblem(parent, size) -> cadre du blason (portrait ou écu dans un anneau de métal).
-- emblem:SetTheme(theme) le repeint (fait par Paint pour les cadres décorés).
function Themes:Emblem(parent, size)
  local e = CreateFrame("Frame", nil, parent)
  e:SetSize(size, size)
  local disc = e:CreateTexture(nil, "ARTWORK", nil, 1)
  disc:SetPoint("TOPLEFT", size * 0.09, -size * 0.09)
  disc:SetPoint("BOTTOMRIGHT", -size * 0.09, size * 0.09)
  if e.CreateMaskTexture and disc.AddMaskTexture then
    local mask = e:CreateMaskTexture()
    mask:SetAllPoints(disc)
    mask:SetTexture(TEX.mask, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    disc:AddMaskTexture(mask)
    e.mask = mask
  end
  local ring = e:CreateTexture(nil, "ARTWORK", nil, 3)
  ring:SetAllPoints(e)
  ring:SetTexture(TEX.ring)
  e.disc, e.ring = disc, ring
  function e:SetTheme(theme)
    setEmblemTexture(disc, theme)
    tintMetal(ring, theme)
    e.qvThemeKey = theme.key
  end
  e:SetTheme(self:Current())
  return e
end

local decorated = setmetatable({}, { __mode = "k" })

-- Q.Themes:Decorate(frame, opts) : pose les décorations communes sur frame (cadre construit par
-- l'appelant ; le fond et la bordure viennent d'Apply). opts :
--   header = hauteur de l'en-tête en aplat (nil : pas d'en-tête) ;
--   title = FontString à placer dans l'en-tête (à gauche), sub = sous-titre ;
--   trim (liseré de 2 px en haut, défaut vrai). emblem, watermark, corners : ignorés (retirés).
-- Renvoie frame.qvDecor : { header, sky, headerLine, trim }.
-- Le cadre est repeint à chaque changement de thème (THEME_CHANGED) et à chaque Apply.
function Themes:Decorate(frame, opts)
  if not frame then return nil end
  opts = opts or {}
  local d = frame.qvDecor
  if d then return d end
  d = { opts = opts }
  frame.qvDecor = d
  local level = (frame.GetFrameLevel and frame:GetFrameLevel() or 1)

  if opts.header then
    local h = CreateFrame("Frame", nil, frame)
    h:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    h:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    h:SetHeight(opts.header)
    if h.SetClipsChildren then h:SetClipsChildren(true) end
    if h.SetFrameLevel then h:SetFrameLevel(level) end
    local sky = h:CreateTexture(nil, "BACKGROUND", nil, -6)
    sky:SetAllPoints(h)
    local line = h:CreateTexture(nil, "BORDER")
    line:SetPoint("BOTTOMLEFT", h, "BOTTOMLEFT", 0, 0)
    line:SetPoint("BOTTOMRIGHT", h, "BOTTOMRIGHT", 0, 0)
    line:SetHeight(1)
    d.header, d.sky, d.headerLine = h, sky, line
    if opts.title then
      opts.title:SetParent(h)
      opts.title:ClearAllPoints()
      if opts.sub then opts.title:SetPoint("TOPLEFT", h, "TOPLEFT", 12, -8)
      else opts.title:SetPoint("LEFT", h, "LEFT", 12, 0) end
      if opts.sub then
        opts.sub:SetParent(h)
        opts.sub:ClearAllPoints()
        opts.sub:SetPoint("TOPLEFT", opts.title, "BOTTOMLEFT", 0, -2)
      end
    end
  end

  -- coins et liseré dans un cadre au-dessus du contenu
  local over = CreateFrame("Frame", nil, frame)
  over:SetAllPoints(frame)
  if over.SetFrameLevel then over:SetFrameLevel(level + 20) end
  if over.EnableMouse then over:EnableMouse(false) end
  d.over = over
  if opts.trim ~= false then
    local trim = over:CreateTexture(nil, "OVERLAY", nil, 1)
    trim:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    trim:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    trim:SetHeight(2)
    d.trim = trim
  end
  decorated[frame] = true
  self:Paint(frame, frame.qvTheme or self:Current(), frame.qvThemeOpacity or 1)
  return d
end

-- Repeint les décorations de frame avec theme (sans décorations : rien). Les décorations
-- disparaissent dans les variantes sans fond du suivi (theme.decor faux).
function Themes:Paint(frame, theme, alpha)
  local d = frame and frame.qvDecor
  if not d then return end
  theme = theme or self:Current()
  alpha = alpha or 1
  frame.qvTheme = theme
  local c = theme.colors
  local on = theme.decor ~= false
  if d.header then
    if on then
      -- en-tête en aplat : couleur des panneaux, filet dessous
      d.sky:SetColorTexture(c.panel[1], c.panel[2], c.panel[3], 1)
      d.sky:SetAlpha(alpha)
      d.headerLine:SetColorTexture(c.line[1], c.line[2], c.line[3], c.line[4])
      d.sky:Show(); d.headerLine:Show()
    else
      d.sky:Hide(); d.headerLine:Hide()
    end
  end
  if d.trim then
    d.trim:SetColorTexture(c.metal[1], c.metal[2], c.metal[3], alpha)
    if on then d.trim:Show() else d.trim:Hide() end
  end
end

-- Repeint tous les cadres décorés avec le thème en vigueur (les cadres du suivi gardent leur
-- variante : le suivi se repeint lui-même par Apply).
function Themes:RepaintAll()
  local theme = self:Current()
  for frame in pairs(decorated) do
    if not frame.qvOwnTheme then
      if frame.qvThemeBg then self:Apply(frame, theme.key, frame.qvThemeOpacity or 1)
      else self:Paint(frame, theme, frame.qvThemeOpacity or 1) end
    end
    self:ScaleTree(frame)
  end
end

---------------------------------------------------------------------------
-- Boutons et cadres des gabarits de Blizzard
---------------------------------------------------------------------------
-- Objets de police des boutons, un par sorte (et un grisé) : le jeu remet la police de l'objet à
-- chaque changement d'état (survol, appui, grisé), la couleur doit donc vivre dans l'objet.
-- Recolorés à chaque thème : tous les boutons suivent.
local buttonFonts = {}
local function buttonFont(kind, c)
  if type(CreateFont) ~= "function" then return nil end
  local fo = buttonFonts[kind]
  if not fo then
    fo = CreateFont("QuestifyButtonFont_" .. kind)
    if fo and fo.CopyFontObject and GameFontNormal then fo:CopyFontObject(GameFontNormal) end
    buttonFonts[kind] = fo
  end
  if fo and fo.SetTextColor and c then fo:SetTextColor(c[1], c[2], c[3], 1) end
  return fo
end

-- Habille un bouton (UIPanelButtonTemplate ou simple Button) : fond plat, bordure de 1 px, texte
-- du thème. kind : "primary" (accent plein) ou "secondary" (défaut), "ghost" (sans fond).
function Themes:SkinButton(btn, kind, theme)
  if not btn then return end
  theme = theme or self:Current()
  local c = theme.colors
  kind = kind or btn.qvButtonKind or "secondary"
  btn.qvButtonKind = kind
  if not btn.qvSkin then
    for _, key in ipairs({ "Left", "Middle", "Right", "LeftDisabled", "MiddleDisabled", "RightDisabled" }) do
      local r = rawget(btn, key) or btn[key]
      if r and r.SetAlpha then r:SetAlpha(0) end
    end
    for _, getter in ipairs({ "GetNormalTexture", "GetPushedTexture", "GetDisabledTexture" }) do
      local t = btn[getter] and btn[getter](btn)
      if t and t.SetAlpha then t:SetAlpha(0) end
    end
    local bg = btn:CreateTexture(nil, "BACKGROUND", nil, 1)
    bg:SetAllPoints(btn)
    local hl = btn:CreateTexture(nil, "HIGHLIGHT")
    hl:SetAllPoints(btn)
    local edges = {}
    for i, pts in ipairs({ { "TOPLEFT", "TOPRIGHT", nil, 1 }, { "BOTTOMLEFT", "BOTTOMRIGHT", nil, 1 },
      { "TOPLEFT", "BOTTOMLEFT", 1, nil }, { "TOPRIGHT", "BOTTOMRIGHT", 1, nil } }) do
      local e = btn:CreateTexture(nil, "BORDER")
      e:SetPoint(pts[1], btn, pts[1], 0, 0)
      e:SetPoint(pts[2], btn, pts[2], 0, 0)
      if pts[3] then e:SetWidth(pts[3]) else e:SetHeight(pts[4]) end
      edges[i] = e
    end
    btn.qvSkin = { bg = bg, hl = hl, edges = edges }
  end
  local s = btn.qvSkin
  local fill, edge, txt
  if kind == "primary" then
    fill, edge, txt = c.accent, c.accent, c.onAccent
  elseif kind == "ghost" then
    fill, edge, txt = { 0, 0, 0, 0 }, c.edge, c.text
  else
    fill, edge, txt = c.panelAlt, c.edge, c.text
  end
  s.bg:SetColorTexture(fill[1], fill[2], fill[3], fill[4] or 1)
  s.hl:SetColorTexture(1, 1, 1, 0.08)
  for _, e in ipairs(s.edges) do e:SetColorTexture(edge[1], edge[2], edge[3], 1) end
  local fo, foDis = buttonFont(kind, txt), buttonFont("disabled", c.textMuted)
  if fo and btn.SetNormalFontObject then
    btn:SetNormalFontObject(fo)
    if btn.SetHighlightFontObject then btn:SetHighlightFontObject(fo) end
    if btn.SetDisabledFontObject and foDis then btn:SetDisabledFontObject(foDis) end
  end
  local fs = btn.GetFontString and btn:GetFontString()
  if fs then
    fs:SetTextColor(txt[1], txt[2], txt[3], 1)
    if fs.SetShadowColor then fs:SetShadowColor(0, 0, 0, kind == "primary" and 0 or 1) end
  end
  btn.qvButtonTheme = theme.key
end

-- Habille une case à cocher ou un bouton radio (radio vrai) : case plate de 14 px bordée de 1 px,
-- coche (ou point) à la couleur de l'accent. Garde les scripts et l'état du bouton.
local GLYPH_CHECK, GLYPH_DOT = MEDIA .. "Themes\\glyph-check", MEDIA .. "Themes\\glyph-dot"
local GLYPH_CLOSE, GLYPH_CIRCLE = MEDIA .. "Themes\\glyph-close", MEDIA .. "Themes\\glyph-circle"
Themes.GLYPH_CHECK, Themes.GLYPH_DOT, Themes.GLYPH_CLOSE = GLYPH_CHECK, GLYPH_DOT, GLYPH_CLOSE
function Themes:SkinCheck(cb, radio, theme)
  if not cb then return end
  theme = theme or self:Current()
  local c = theme.colors
  radio = radio or cb.qvRadio
  if not cb.qvSkin then
    for _, getter in ipairs({ "GetNormalTexture", "GetPushedTexture", "GetDisabledTexture", "GetHighlightTexture" }) do
      local t = cb[getter] and cb[getter](cb)
      if t and t.SetAlpha then t:SetAlpha(0) end
    end
    local size = 14
    local edge = cb:CreateTexture(nil, "BACKGROUND", nil, 1)
    edge:SetSize(size, size)
    edge:SetPoint("CENTER", cb, "CENTER", 0, 0)
    local fill = cb:CreateTexture(nil, "BACKGROUND", nil, 2)
    fill:SetSize(size - 2, size - 2)
    fill:SetPoint("CENTER", cb, "CENTER", 0, 0)
    local mark = cb:CreateTexture(nil, "ARTWORK")
    mark:SetSize(radio and 12 or 14, radio and 12 or 14)
    mark:SetPoint("CENTER", cb, "CENTER", 0, 0)
    mark:SetTexture(radio and GLYPH_DOT or GLYPH_CHECK)
    if cb.SetCheckedTexture then cb:SetCheckedTexture(mark) end
    local dis = cb.GetDisabledCheckedTexture and cb:GetDisabledCheckedTexture()
    if dis and dis.SetAlpha then dis:SetAlpha(0) end
    if radio then
      edge:SetTexture(GLYPH_CIRCLE)
      fill:SetTexture(GLYPH_DOT)
      fill:SetSize(size, size)
    end
    cb.qvSkin = { edge = edge, fill = fill, mark = mark }
    cb.qvRadio = radio
  end
  local k = cb.qvSkin
  if radio then
    k.edge:SetVertexColor(c.edge[1] * 1.6, c.edge[2] * 1.6, c.edge[3] * 1.6, 1)
    k.fill:SetVertexColor(c.panelAlt[1], c.panelAlt[2], c.panelAlt[3], 0)
  else
    k.edge:SetColorTexture(c.edge[1] * 1.4, c.edge[2] * 1.4, c.edge[3] * 1.4, 1)
    k.fill:SetColorTexture(c.panelAlt[1], c.panelAlt[2], c.panelAlt[3], 1)
  end
  k.mark:SetVertexColor(c.accent[1], c.accent[2], c.accent[3], 1)
end

-- Bouton de fermeture plat (croix teintée du texte discret, plus claire au survol) : celui du
-- gabarit (frame.CloseButton) est habillé, sinon un bouton est créé. -> bouton.
function Themes:SkinClose(frame, theme)
  if not frame then return nil end
  theme = theme or self:Current()
  local c = theme.colors
  local b = rawget(frame, "CloseButton") or frame.qvClose
  if not b then
    b = CreateFrame("Button", nil, frame)
    b:SetScript("OnClick", function() frame:Hide() end)
    frame.qvClose = b
  end
  if not b.qvSkin then
    for _, getter in ipairs({ "GetNormalTexture", "GetPushedTexture", "GetDisabledTexture", "GetHighlightTexture" }) do
      local t = b[getter] and b[getter](b)
      if t and t.SetAlpha then t:SetAlpha(0) end
    end
    local x = b:CreateTexture(nil, "ARTWORK")
    x:SetSize(14, 14)
    x:SetPoint("CENTER", b, "CENTER", 0, 0)
    x:SetTexture(GLYPH_CLOSE)
    b.qvSkin = { x = x }
    b:HookScript("OnEnter", function() local t = frame.qvTheme or Themes:Current(); local tc = t.colors.text; x:SetVertexColor(tc[1], tc[2], tc[3], 1) end)
    b:HookScript("OnLeave", function() local t = frame.qvTheme or Themes:Current(); local m = t.colors.textMuted; x:SetVertexColor(m[1], m[2], m[3], 1) end)
  end
  b:SetSize(24, 24)
  if frame.qvDecor and frame.qvDecor.header then
    b:ClearAllPoints()
    b:SetPoint("RIGHT", frame.qvDecor.header, "RIGHT", -8, 0)
    if b.SetFrameLevel then b:SetFrameLevel((frame.qvDecor.header:GetFrameLevel() or 1) + 5) end
  end
  b.qvSkin.x:SetVertexColor(c.textMuted[1], c.textMuted[2], c.textMuted[3], 1)
  return b
end

-- Habille d'un coup les boutons, cases et radios d'un arbre de cadres (fenêtres construites avec
-- les gabarits de Blizzard). Un bouton de gabarit est reconnu à ses textures Left / Middle / Right.
function Themes:SkinTree(root, theme, depth)
  if not root or (depth or 0) > 12 then return end
  theme = theme or self:Current()
  for _, child in ipairs({ root:GetChildren() }) do
    local kind = child.GetObjectType and child:GetObjectType()
    if kind == "CheckButton" then
      self:SkinCheck(child, child.qvRadio, theme)
    elseif kind == "Button" and (child.qvSkin and child.qvSkin.bg or (rawget(child, "Left") and rawget(child, "Middle"))) then
      self:SkinButton(child, child.qvButtonKind, theme)
    end
    self:SkinTree(child, theme, (depth or 0) + 1)
  end
end

-- Cache l'habillage des gabarits de Blizzard (ButtonFrameTemplate, PortraitFrameTemplate,
-- BasicFrameTemplate) : cadre, portrait, fonds et encart. La fenêtre garde ses scripts et son
-- bouton de fermeture.
local TEMPLATE_PARTS = { "NineSlice", "Bg", "Background", "TitleBg", "TopTileStreaks", "PortraitContainer",
  "portrait", "Portrait", "PortraitFrame", "PortraitButton", "TitleContainer" }
function Themes:StripTemplate(frame)
  if not frame then return end
  for _, key in ipairs(TEMPLATE_PARTS) do
    local r = rawget(frame, key)
    if r and r.Hide then r:Hide(); if r.SetAlpha then r:SetAlpha(0) end end
  end
  local inset = rawget(frame, "Inset")
  if inset then
    for _, key in ipairs({ "NineSlice", "Bg", "Background" }) do
      local r = rawget(inset, key)
      if r and r.Hide then r:Hide() end
    end
  end
  for _, name in ipairs({ "TitleText" }) do
    local r = rawget(frame, name)
    if r and r.Hide then r:Hide() end
  end
end

---------------------------------------------------------------------------
-- Changements
---------------------------------------------------------------------------
local WATCHED = {
  ["tracker.theme"] = true, ["theme.followRace"] = true, ["theme.font"] = true, ["theme.icons"] = true,
  ["theme.fontScale"] = true,
  ["tracker.style"] = true, ["arrow.color"] = true,
}
local lastKey
local function onSettings(path)
  if path and not WATCHED[path] and path ~= "profile" then return end
  local key = Themes:CurrentKey()
  Themes:RepaintAll()
  if key ~= lastKey or path ~= "tracker.theme" then
    lastKey = key
    Q:Fire("THEME_CHANGED", Themes:Current())
  end
end
if Q.On then
  Q:On("SETTINGS_CHANGED", function(path) onSettings(path) end)
  Q:On("PROFILE_CHANGED", function() onSettings("profile") end)
  Q:On("LOGIN", function() lastKey = Themes:CurrentKey() end)
end
