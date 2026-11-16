local addonName, Q = ...

-- Onglet « Rythme » du journal (UI/Journal.lua) : rythme face à la route simulée (Engine/Pace.lua).
-- Maquette : docs/media/apercus/src/12-rythme.html. Quatre parties de haut en bas :
--   Chapitre       écart, fin du chapitre et prochain niveau prévus au rythme du joueur ;
--   Toute la route écart cumulé et rapport de vitesse sur la simulation ;
--   Chapitres      simulé, ce personnage, meilleur passage du compte, écart (survol : 5 derniers passages) ;
--   Session        temps de jeu, actif, temps mort, XP, XP/h par zone ; bouton session précédente.
-- Le journal garde le style des fenêtres du jeu (pas de thème) : codes de couleur d'origine.
Q.UI = Q.UI or {}
local Panel = { chapterRows = {}, zoneRows = {} }
Q.UI.PacePanel = Panel

local L = Q.L

local W = 470            -- largeur des parties
local KEY_X, VALUE_X = 6, 136
local KV_H = 15
local ROW_H = 18
local ROWS = 6           -- lignes de chapitres visibles
local ZONE_ROWS = 3      -- zones montrées (les plus jouées)
local ZONE_H = 17
local BAR_X, BAR_W = 296, 100

local DIM = "|cffaaaaaa"
local CURRENT = "|cffffd100"

-- Colonnes du tableau des chapitres : { x, largeur, alignement }
local COLS = {
  { 6, 150, "LEFT" },     -- chapitre
  { 160, 54, "RIGHT" },   -- simulé
  { 220, 64, "RIGHT" },   -- ce personnage
  { 290, 80, "RIGHT" },   -- ton meilleur
  { 380, 86, "RIGHT" },   -- écart
}

local function fmt(template, ...)
  local ok, s = pcall(string.format, template, ...)
  if ok then return s end
  return tostring(template)
end

local function safe(fn)
  return function(...) return Q.SafeCall(fn, ...) end
end

local function showTooltip(owner, lines)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  GameTooltip:ClearLines()
  for i, line in ipairs(lines) do
    if i == 1 then GameTooltip:AddLine(line, 1, 0.82, 0, true) else GameTooltip:AddLine(line, 1, 1, 1, true) end
  end
  GameTooltip:Show()
end
local function hideTooltip() if GameTooltip then GameTooltip:Hide() end end

local function paint(text, code)
  if not text then return "" end
  return "|c" .. code .. text .. "|r"
end

-- Couleur des barres d'XP/h : celle de la barre du thème sombre du suivi (UI/Themes.lua).
local function barColor()
  local T = Q.Themes
  local th = T and T.Get and T:Get("dark")
  local c = th and th.bar and th.bar.fill
  if type(c) == "table" then return c[1], c[2], c[3] end
  return 0.26, 0.56, 0.95
end

---------------------------------------------------------------------------
-- Noms de classe et de race
---------------------------------------------------------------------------
function Panel.ClassName(classFile)
  if type(classFile) ~= "string" then return "?" end
  local names = LOCALIZED_CLASS_NAMES_MALE
  if type(names) == "table" and type(names[classFile]) == "string" then return names[classFile] end
  return classFile:sub(1, 1) .. classFile:sub(2):lower()
end

function Panel.RaceName(raceKey)
  if type(raceKey) ~= "string" then return "" end
  if C_CreatureInfo and C_CreatureInfo.GetRaceInfo then
    for id, r in pairs(Q.RACE_BY_ID or {}) do
      if r.key == raceKey then
        local ok, info = pcall(C_CreatureInfo.GetRaceInfo, id)
        if ok and type(info) == "table" and type(info.raceName) == "string" then return info.raceName end
        break
      end
    end
  end
  return raceKey
end

local function shortDate(t)
  if type(t) ~= "number" or not date then return "" end
  local ok, s = pcall(date, L.PACE_DATE, t)
  return ok and s or ""
end

local function hourOf(t)
  if type(t) ~= "number" or not date then return "" end
  local ok, s = pcall(date, "%H:%M", t)
  return ok and s or ""
end

-- Ligne d'un passage pour l'infobulle : "1 h 31 · Chaman nain · 20 → 22 · 16/11".
function Panel.RunLine(run)
  local P = Q.Pace
  local line = fmt(L.PACE_RUN_LINE, P.Clock(run.sec or 0), Panel.ClassName(run.class), Panel.RaceName(run.race),
    math.floor(tonumber(run.lvlIn) or 0), math.floor(tonumber(run.lvlOut) or 0), shortDate(run.date))
  if run.partial then line = line .. L.PACE_RUN_PARTIAL end
  return line
end

---------------------------------------------------------------------------
-- Données des chapitres
---------------------------------------------------------------------------
-- Chapitres à montrer : mesurés par le personnage ou passés sur le compte, de la faction du joueur,
-- par niveau puis identifiant ; -> { { guide, sim, char, open, current, best, delta } }.
function Panel.ChapterData()
  local P = Q.Pace
  local wanted = {}
  local charData = P:CharData()
  for id in pairs(charData and charData.chapters or {}) do wanted[id] = true end
  local acc = P:AccountData()
  for _, r in ipairs(acc and acc.runs or {}) do
    if type(r) == "table" and type(r.guide) == "string" then wanted[r.guide] = true end
  end
  local cur = Q.Progress and Q.Progress:IsEnabled() and Q.Progress:Guide()
  local faction = Q.Player and Q.Player.faction
  local list = {}
  for _, g in ipairs(Q.Guides:All()) do
    if wanted[g.id] and (not faction or not g.faction or g.faction == faction) then list[#list + 1] = g end
  end
  table.sort(list, function(a, b)
    local la, lb = a.minLevel or 0, b.minLevel or 0
    if la ~= lb then return la < lb end
    return a.id < b.id
  end)
  local out = {}
  for _, g in ipairs(list) do
    local ch = P:Chapter(g.id)
    local sim = P.SimOf(g)
    local best = P:Best(g.id)
    local active = ch and (ch.active or 0) > 0 and ch.active or nil
    out[#out + 1] = {
      guide = g, sim = sim and sim.minutes * 60 or nil,
      char = active, open = ch ~= nil and not ch.closed, current = cur ~= nil and cur.id == g.id,
      best = best and best.sec or nil,
      delta = active and P:ChapterDelta(g.id, ch) or nil,
    }
  end
  return out
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function text(parent, template, x, y, width, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
  fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, -y)
  if width then fs:SetWidth(width) end
  fs:SetJustifyH(justify or "LEFT")
  fs:SetWordWrap(false)
  return fs
end

-- Titre de partie (doré) souligné d'un filet.
local function header(parent, y)
  local fs = text(parent, "GameFontNormal", 4, y, W)
  local line = parent:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(1, 0.82, 0, 0.28)
  line:SetHeight(1)
  line:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -(y + 16))
  line:SetWidth(W)
  return fs
end

-- Ligne clé / valeur.
local function kv(parent, y, key)
  local k = text(parent, "GameFontHighlightSmall", KEY_X, y + 1, VALUE_X - KEY_X - 4)
  k:SetText(DIM .. key .. "|r")
  local v = text(parent, "GameFontHighlightSmall", VALUE_X, y + 1, W - VALUE_X)
  return v, k
end

function Panel:Build(panel)
  self.panel = panel

  -- Chapitre
  self.chapterTitle = header(panel, 2)
  self.delta = kv(panel, 22, L.PACE_K_DELTA)
  self.chapterEnd = kv(panel, 22 + KV_H, L.PACE_K_CHAPTER_END)
  self.nextLevel = kv(panel, 22 + 2 * KV_H, L.PACE_K_NEXT_LEVEL)

  -- Toute la route
  self.routeTitle = header(panel, 72)
  self.routeTitle:SetText(L.PACE_SEC_ROUTE)
  self.routeDelta = kv(panel, 92, L.PACE_K_DELTA)
  self.ratio = kv(panel, 92 + KV_H, L.PACE_K_RATIO)

  -- Chapitres
  self.chaptersTitle = header(panel, 126)
  self.chaptersTitle:SetText(L.PACE_SEC_CHAPTERS)
  local heads = { L.PACE_COL_CHAPTER, L.PACE_COL_SIM, L.PACE_COL_CHAR, L.PACE_COL_BEST, L.PACE_COL_DELTA }
  self.columnHeads = {}
  for i, c in ipairs(COLS) do
    local fs = text(panel, "GameFontDisableSmall", 4 + c[1], 149, c[2], c[3])
    fs:SetText(heads[i])
    self.columnHeads[i] = fs
  end
  local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
  scroll:SetPoint("TOPLEFT", panel, "TOPLEFT", 4, -164)
  scroll:SetSize(W, ROWS * ROW_H)
  local child = CreateFrame("Frame", nil, scroll)
  child:SetSize(W, 1)
  scroll:SetScrollChild(child)
  self.scroll, self.scrollChild = scroll, child
  self.chaptersEmpty = text(panel, "GameFontDisableSmall", 10, 168, W - 12)
  self.chaptersEmpty:SetText(L.PACE_CHAPTERS_EMPTY)
  self.chaptersHint = text(panel, "GameFontDisableSmall", 10, 166 + ROWS * ROW_H + 2, W - 12)
  self.chaptersHint:SetWordWrap(true)
  self.chaptersHint:SetText(L.PACE_CHAPTERS_HINT)

  -- Session
  self.sessionTitle = header(panel, 302)
  local toggle = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
  toggle:SetSize(140, 20)
  toggle:SetPoint("TOPRIGHT", panel, "TOPLEFT", 4 + W, -298)
  toggle:SetText(L.PACE_BTN_PREVIOUS)
  toggle:SetScript("OnClick", safe(function()
    Panel.showPrevious = not Panel.showPrevious
    Panel:Refresh()
  end))
  self.sessionToggle = toggle
  self.played = kv(panel, 322, L.PACE_K_PLAYED)
  self.xp = kv(panel, 322 + KV_H, L.PACE_K_XP)
  local zoneHeads = {
    { L.PACE_COL_ZONE, 6, 150, "LEFT" }, { L.PACE_COL_TIME, 160, 54, "RIGHT" },
    { L.PACE_COL_XP, 220, 64, "RIGHT" }, { L.PACE_COL_RATE, 400, 66, "RIGHT" },
  }
  self.zoneHeads = {}
  for i, h in ipairs(zoneHeads) do
    local fs = text(panel, "GameFontDisableSmall", 4 + h[2], 358, h[3], h[4])
    fs:SetText(h[1])
    self.zoneHeads[i] = fs
  end
  self.sessionEmpty = text(panel, "GameFontDisableSmall", 10, 374, W - 12)
  self.sessionEmpty:SetText(L.PACE_SESSION_EMPTY)
  local r, g, b = barColor()
  for i = 1, ZONE_ROWS do
    local y = 372 + (i - 1) * ZONE_H
    local row = {
      name = text(panel, "GameFontHighlightSmall", 4 + 6, y + 1, 150),
      time = text(panel, "GameFontHighlightSmall", 4 + 160, y + 1, 54, "RIGHT"),
      xp = text(panel, "GameFontHighlightSmall", 4 + 220, y + 1, 64, "RIGHT"),
      rate = text(panel, "GameFontHighlightSmall", 4 + 400, y + 1, 66, "RIGHT"),
    }
    local bar = panel:CreateTexture(nil, "ARTWORK")
    bar:SetColorTexture(r, g, b, 1)
    bar:SetHeight(7)
    bar:SetPoint("TOPLEFT", panel, "TOPLEFT", 4 + BAR_X, -(y + 4))
    row.bar = bar
    self.zoneRows[i] = row
  end
end

local function chapterRow(self, i)
  local row = self.chapterRows[i]
  if row then return row end
  local child = self.scrollChild
  row = CreateFrame("Button", nil, child)
  row:SetSize(W - 20, ROW_H)
  row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -(i - 1) * ROW_H)
  local bg = row:CreateTexture(nil, "BACKGROUND")
  bg:SetAllPoints(row)
  bg:SetColorTexture(1, 1, 1, i % 2 == 1 and 0.035 or 0)
  row.cells = {}
  for c, col in ipairs(COLS) do
    local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    fs:SetPoint("TOPLEFT", row, "TOPLEFT", col[1], -3)
    fs:SetWidth(c == #COLS and col[2] - 20 or col[2])
    fs:SetJustifyH(col[3])
    fs:SetWordWrap(false)
    row.cells[c] = fs
  end
  row:SetScript("OnEnter", safe(function(btn)
    local g = btn.guide
    if not g then return end
    local lines = { Q.Guides:DisplayTitle(g) }
    local runs = Q.Pace:Recent(g.id, Q.Pace.RECENT)
    for _, run in ipairs(runs) do lines[#lines + 1] = Panel.RunLine(run) end
    if #runs == 0 then lines[#lines + 1] = DIM .. L.PACE_RUNS_NONE .. "|r" end
    showTooltip(btn, lines)
  end))
  row:SetScript("OnLeave", hideTooltip)
  self.chapterRows[i] = row
  return row
end

---------------------------------------------------------------------------
-- Mise à jour
---------------------------------------------------------------------------
function Panel:RefreshChapter()
  local P = Q.Pace
  local g = Q.Progress and Q.Progress:IsEnabled() and Q.Progress:Guide()
  if not g then
    self.chapterTitle:SetText(L.PACE_SEC_NO_CHAPTER)
    self.delta:SetText(DIM .. "-|r")
    self.chapterEnd:SetText(DIM .. "-|r")
  else
    self.chapterTitle:SetText(fmt(L.PACE_SEC_CHAPTER, Q.Guides:DisplayTitle(g)))
    local ch = P:Chapter(g.id)
    local d, expected = P:ChapterDelta(g.id, ch)
    if not P.SimOf(g) then
      self.delta:SetText(DIM .. L.PACE_V_NO_SIM .. "|r")
    elseif not ch or (ch.active or 0) < P.MIN_SHOW then
      self.delta:SetText(DIM .. L.PACE_V_WAIT .. "|r")
    else
      local t, code = P.DeltaText(d)
      self.delta:SetText(paint(t, code) .. " " .. DIM .. fmt(L.PACE_V_DELTA_DETAIL, P.Clock(expected), P.Clock(ch.active)) .. "|r")
    end
    local eta, simLeft = P:ChapterETA()
    if eta then
      self.chapterEnd:SetText("~" .. P.Duration(eta) .. " " .. DIM .. fmt(L.PACE_V_SIM, P.Clock(simLeft)) .. "|r")
    else
      self.chapterEnd:SetText(DIM .. "-|r")
    end
  end
  local lvlEta, nextLevel, rate = P:LevelETA()
  if lvlEta then
    self.nextLevel:SetText(fmt(L.PACE_V_NEXT_LEVEL, nextLevel, P.Duration(lvlEta)) .. " " .. DIM .. fmt(L.PACE_V_RATE, P.Short(rate)) .. "|r")
  else
    self.nextLevel:SetText(DIM .. "-|r")
  end

  local route, n = P:RouteDelta()
  if route then
    local t, code = P.DeltaText(route)
    local over = n == 1 and L.PACE_V_ROUTE_ONE or fmt(L.PACE_V_ROUTE_N, n)
    self.routeDelta:SetText(paint(t, code) .. " " .. DIM .. over .. "|r")
  else
    self.routeDelta:SetText(DIM .. "-|r")
  end
  local ratio, source = P:Ratio()
  if ratio then
    local note = source == "account" and L.PACE_V_RATIO_ACCOUNT or L.PACE_V_RATIO_NOTE
    self.ratio:SetText(fmt(L.PACE_V_RATIO, math.floor(ratio * 100 + 0.5)) .. " " .. DIM .. note .. "|r")
  else
    self.ratio:SetText(DIM .. L.PACE_V_RATIO_NONE .. "|r")
  end
end

function Panel:RefreshChapters()
  local P = Q.Pace
  local data = Panel.ChapterData()
  for i, d in ipairs(data) do
    local row = chapterRow(self, i)
    row.guide = d.guide
    local c = row.cells
    local title = Q.Guides:DisplayTitle(d.guide)
    c[1]:SetText(d.current and (CURRENT .. title .. "|r") or title)
    c[2]:SetText(d.sim and (DIM .. P.Clock(d.sim) .. "|r") or (DIM .. "-|r"))
    if d.open and d.current then
      c[3]:SetText(DIM .. L.PACE_IN_PROGRESS .. "|r")
    elseif d.char then
      local _, code = P.DeltaText(d.delta)
      c[3]:SetText(code and paint(P.Clock(d.char), code) or P.Clock(d.char))
    else
      c[3]:SetText("|cff666666-|r")
    end
    c[4]:SetText(d.best and P.Clock(d.best) or "|cff666666-|r")
    if d.delta and d.char then
      local t, code = P.DeltaShort(d.delta)
      c[5]:SetText(paint(t, code))
    else
      c[5]:SetText("|cff666666-|r")
    end
    row:Show()
  end
  for i = #data + 1, #self.chapterRows do
    self.chapterRows[i].guide = nil
    self.chapterRows[i]:Hide()
  end
  self.scrollChild:SetHeight(math.max(1, #data * ROW_H))
  if #data == 0 then self.chaptersEmpty:Show() else self.chaptersEmpty:Hide() end
end

function Panel:RefreshSession()
  local P = Q.Pace
  local last = P:LastSession()
  if not last then self.showPrevious = false end
  local s = self.showPrevious and last or P:Session()
  if last then self.sessionToggle:Enable() else self.sessionToggle:Disable() end
  self.sessionToggle:SetText(self.showPrevious and L.PACE_BTN_CURRENT or L.PACE_BTN_PREVIOUS)
  local when = self.showPrevious and fmt(L.PACE_SESSION_PREV, shortDate(s and s.startedAt) .. " " .. hourOf(s and s.startedAt))
    or fmt(L.PACE_SESSION_SINCE, hourOf(s and s.startedAt))
  self.sessionTitle:SetText(L.PACE_SEC_SESSION .. " |cffaaaaaa" .. when .. "|r")
  s = s or {}
  local down = s.down or {}
  local afk, dead, idle = down.afk or 0, down.dead or 0, down.idle or 0
  local D = P.Duration
  local played = fmt(L.PACE_V_PLAYED, D(s.wall or 0), D(s.active or 0), D(afk + dead + idle), D(afk), D(idle), D(dead))
  -- temps de jeu en blanc, détail en gris (maquette)
  local first, rest = played:match("^(.-)( · .*)$")
  self.played:SetText(first and (first .. DIM .. rest .. "|r") or played)
  local rate = (s.active or 0) > 0 and (s.xp or 0) * 3600 / s.active or 0
  local xpText = fmt(L.PACE_V_XP, P.Short(s.xp or 0), P.Short(rate))
  local levels = tonumber(s.levels) or 0
  if levels > 0 then xpText = xpText .. " · " .. (levels == 1 and L.PACE_LEVELS_ONE or fmt(L.PACE_LEVELS, levels)) end
  local xpFirst, xpRest = xpText:match("^(.-)( · .*)$")
  self.xp:SetText(xpFirst and (xpFirst .. DIM .. xpRest .. "|r") or xpText)

  local zones = P.ZoneRows(s)
  local maxRate = 0
  for i = 1, math.min(ZONE_ROWS, #zones) do maxRate = math.max(maxRate, zones[i].rate) end
  for i, row in ipairs(self.zoneRows) do
    local z = zones[i]
    if z then
      row.name:SetText(z.name)
      row.time:SetText(D(z.sec))
      row.xp:SetText(P.Short(z.xp))
      row.rate:SetText(P.Short(z.rate))
      local w = maxRate > 0 and math.max(1, math.floor(BAR_W * z.rate / maxRate + 0.5)) or 1
      row.bar:SetWidth(w)
      row.name:Show(); row.time:Show(); row.xp:Show(); row.rate:Show(); row.bar:Show()
    else
      row.name:Hide(); row.time:Hide(); row.xp:Hide(); row.rate:Hide(); row.bar:Hide()
    end
  end
  if #zones == 0 then self.sessionEmpty:Show() else self.sessionEmpty:Hide() end
end

function Panel:Refresh()
  if not (self.panel and Q.Pace) then return end
  self:RefreshChapter()
  self:RefreshChapters()
  self:RefreshSession()
end

-- Journal ouvert sur cet onglet : mise à jour à chaque tranche mesurée.
Q:On("PACE_UPDATED", function()
  local J = Q.UI.Journal
  if J and J.IsShown and J:IsShown() and J.tab == "pace" then Panel:Refresh() end
end)
