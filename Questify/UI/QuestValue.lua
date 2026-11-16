local addonName, Q = ...

-- Conseil « quête peu rentable » sous l'étape courante du suivi (Engine/QuestValue.lua, maquette
-- docs/media/apercus/src/12-skip-quest.html) : raison, XP perdue, puis les choix en petits boutons
--   grise        : « Passer » (ou « Passer et abandonner » si elle est dans le journal), « Garder » ;
--   trop haute   : « Zone de secours », « Bash jusqu'au N », puis « Passer », « Garder » ;
--   de groupe    : « Chercher un groupe », « Zone de secours », puis « Passer », « Garder ».
-- Juste après « Passer » : rappel du saut, compte à rebours de l'abandon et « Annuler ».
-- Tracker:LayoutAdvice(entry, y) est appelé par Tracker:Refresh après les boutons de l'étape courante.
Q.UI = Q.UI or {}
local Tracker = Q.UI.Tracker
local View = {}
Q.UI.QuestValue = View

local L = Q.L

local PAD = 8
local ICON_COL = 38     -- même colonne que le texte de l'étape courante (UI/Tracker.lua)
local LINE_H = 12       -- GameFontHighlightSmall
local BTN_H = 18
local BTN_GAP = 4
local ROW_GAP = 3

local function fmtNumber(n)
  local s = tostring(math.floor((tonumber(n) or 0) + 0.5))
  local sep = L.QV_THOUSANDS
  local out = s:reverse():gsub("(%d%d%d)", "%1" .. sep:reverse()):reverse()
  if out:sub(1, #sep) == sep then out = out:sub(#sep + 1) end
  return out
end
View.FormatNumber = fmtNumber

local function style(fs, role)
  local T = Q.Themes
  if T and fs then T:StyleText(fs, role, Tracker.theme) end
end

local function hideTooltip() GameTooltip:Hide() end

local function showTooltip(owner, title, text)
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:ClearLines()
  GameTooltip:AddLine(title, 1, 0.82, 0, true)
  if text then GameTooltip:AddLine(text, 1, 1, 1, true) end
  GameTooltip:Show()
end

---------------------------------------------------------------------------
-- Textes
---------------------------------------------------------------------------
local function levelRange(lo, hi)
  if lo and hi and hi ~= lo then return lo .. "-" .. hi end
  return tostring(lo or hi or "?")
end

-- Ligne de raison (couleur d'avertissement).
function View:WhyText(a)
  local level = tonumber(Q.Player and Q.Player.level) or 1
  if a.kind == "gray" then
    if a.xpNow and a.xpBase then return string.format(L.QV_WHY_GRAY, fmtNumber(a.xpNow), fmtNumber(a.xpBase)) end
    return L.QV_WHY_GRAY_NOXP
  elseif a.kind == "high" then
    if a.mobLo then return string.format(L.QV_WHY_HIGH, levelRange(a.mobLo, a.mobHi), level) end
    local q = Q.QDB:Quest(a.questId)
    return string.format(L.QV_WHY_HIGH_QUEST, q and q.level or 0, level)
  elseif a.kind == "group" then
    if (a.elites or 0) > 1 then return string.format(L.QV_WHY_GROUP_ELITES, a.elites) end
    if (a.elites or 0) == 1 then return L.QV_WHY_GROUP_ELITE end
    return string.format(L.QV_WHY_GROUP_SUGGESTED, a.group or 2)
  end
  return ""
end

-- Ligne d'XP perdue (couleur atténuée), ou nil.
function View:LostText(a)
  local follow = #(a.chain or {}) - 1
  if not a.lost then return nil end
  local lost = fmtNumber(a.lost)
  if a.kind == "gray" then
    if follow < 1 then return nil end
    if follow == 1 then
      local id = a.chain[2]
      local q = Q.QDB:Quest(id)
      local name = Q.API.QuestTitle(id) or Q.QDB:QuestName(id)
      return string.format(L.QV_LOST_SUITE, name, q and q.level or 0, lost)
    end
    return string.format(L.QV_LOST_SUITES, follow, lost)
  end
  if follow == 1 then return string.format(L.QV_LOST_WITH_SUITE, lost) end
  if follow > 1 then return string.format(L.QV_LOST_WITH_SUITES, follow, lost) end
  return string.format(L.QV_LOST, lost)
end

-- Ligne du saut en attente d'annulation.
function View:PendingText(p)
  local key
  if #p.ids > 1 then key = #p.abandon > 0 and "QV_PENDING_SUITE_ABANDON" or "QV_PENDING_SUITE"
  else key = #p.abandon > 0 and "QV_PENDING_ABANDON" or "QV_PENDING" end
  return string.format(L[key], p.name, p.steps, p.left)
end

---------------------------------------------------------------------------
-- Cadres (créés à la demande sur le cadre du suivi)
---------------------------------------------------------------------------
local BUTTONS = {
  skip    = { text = "QV_BTN_SKIP", tip = "QV_TIP_SKIP" },
  abandon = { text = "QV_BTN_SKIP_ABANDON", tip = "QV_TIP_SKIP_ABANDON" },
  keep    = { text = "QV_BTN_KEEP", tip = "QV_TIP_KEEP" },
  detour  = { text = "QV_BTN_DETOUR", tip = "QV_TIP_DETOUR" },
  bash    = { text = "QV_BTN_BASH", tip = "QV_TIP_BASH" },
  group   = { text = "QV_BTN_GROUP", tip = "QV_TIP_GROUP" },
  undo    = { text = "QV_BTN_UNDO", tip = "QV_TIP_UNDO" },
}

local ACTIONS = {
  skip = function(a) Q.QuestValue:Skip(a) end,
  abandon = function(a) Q.QuestValue:Skip(a) end,
  keep = function(a) Q.QuestValue:Keep(a) end,
  detour = function() Q.QuestValue:Detour() end,
  bash = function(a) Q.QuestValue:Bash(a) end,
  group = function(a) Q.QuestValue:FindGroup(a) end,
  undo = function() Q.QuestValue:Undo() end,
}

local function newButton(parent, id)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(60, BTN_H)
  if b.SetNormalFontObject then b:SetNormalFontObject("GameFontNormalSmall") end
  if b.SetHighlightFontObject then b:SetHighlightFontObject("GameFontHighlightSmall") end
  b.qvId = id
  b:SetScript("OnClick", function()
    Q.SafeCall(ACTIONS[id], View.advice)
  end)
  b:SetScript("OnEnter", function(btn)
    local d = BUTTONS[id]
    showTooltip(btn, btn:GetText() or "", L[d.tip])
  end)
  b:SetScript("OnLeave", hideTooltip)
  b:Hide()
  return b
end

local function setText(b, text)
  b:SetText(text)
  local fs = b.GetFontString and b:GetFontString()
  local w = fs and fs.GetStringWidth and fs:GetStringWidth()
  b:SetWidth(math.max(60, math.floor((tonumber(w) or 90) + 18)))
end

function View:Ensure(f)
  if self.why then return end
  self.why = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  self.lost = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  for _, fs in ipairs({ self.why, self.lost }) do
    fs:SetJustifyH("LEFT")
    if fs.SetWordWrap then fs:SetWordWrap(true) end
    fs:Hide()
  end
  self.buttons = {}
  for id in pairs(BUTTONS) do self.buttons[id] = newButton(f, id) end
end

local function hideAll(self)
  if not self.why then return end
  self.why:Hide()
  self.lost:Hide()
  for _, b in pairs(self.buttons) do b:Hide() end
end

-- Place une ligne de texte ; -> nouvelle hauteur.
local function placeText(f, fs, text, x, y, w)
  fs:SetWidth(w)
  fs:SetText(text)
  fs:ClearAllPoints()
  fs:SetPoint("TOPLEFT", f, "TOPLEFT", x, -y)
  fs:Show()
  local h = tonumber(fs.GetStringHeight and fs:GetStringHeight()) or LINE_H
  return y + math.max(LINE_H, math.ceil(h)) + 1
end

-- Place une rangée de boutons (ids) ; -> nouvelle hauteur.
local function placeRow(self, f, ids, x, y, gap)
  if #ids == 0 then return y end
  y = y + gap
  local cx = x
  for _, id in ipairs(ids) do
    local b = self.buttons[id]
    local d = BUTTONS[id]
    if id == "bash" then
      setText(b, string.format(L[d.text], self.advice.bashLevel or 0))
    else
      setText(b, L[d.text])
    end
    b:ClearAllPoints()
    b:SetPoint("TOPLEFT", f, "TOPLEFT", cx, -y)
    b:Show()
    cx = cx + (b:GetWidth() or 60) + BTN_GAP
  end
  return y + BTN_H
end

-- Rangées de boutons d'un conseil : { alternatives }, { passer, garder }.
function View:Rows(a)
  local alt = {}
  if a.kind == "group" then alt[#alt + 1] = "group" end
  if a.kind ~= "gray" and a.detour then alt[#alt + 1] = "detour" end
  if a.kind == "high" and a.bashLevel then alt[#alt + 1] = "bash" end
  local main = { a.abandon and "abandon" or "skip", "keep" }
  return alt, main
end

-- Bloc sous l'étape courante ; -> nouvelle hauteur.
function View:Layout(tracker, entry, y)
  local f = tracker.frame
  local QV = Q.QuestValue
  local pending = QV and QV:Pending()
  local advice = not pending and QV and QV:Current() or nil
  self.advice, self.pendingShown = advice, pending ~= nil
  if not (pending or advice) then
    hideAll(self)
    return y
  end
  self:Ensure(f)
  hideAll(self)
  local x = PAD + ICON_COL
  local w = (Tracker.Width and Tracker.Width() or 260) - 2 * PAD - ICON_COL - 2
  if pending then
    style(self.why, "dim")
    y = placeText(f, self.why, self:PendingText(pending), x, y, w)
    y = placeRow(self, f, { "undo" }, x, y, 3)
    return y + 6
  end
  style(self.why, "warn")
  style(self.lost, "dim")
  y = placeText(f, self.why, self:WhyText(advice), x, y, w)
  local lost = self:LostText(advice)
  if lost then y = placeText(f, self.lost, lost, x, y, w) end
  local alt, main = self:Rows(advice)
  y = placeRow(self, f, alt, x, y, 3)
  y = placeRow(self, f, main, x, y, #alt > 0 and ROW_GAP or 3)
  return y + 6
end

-- Appelé par Tracker:Refresh, après « Passer ce donjon » et « Quêtes supplémentaires ».
function Tracker:LayoutAdvice(entry, y)
  local ok, res = pcall(View.Layout, View, self, entry, y)
  if ok then return res end
  Q:ReportError(res)
  return y
end

-- Message à la place de la route (pas de QuestieDB, pas de chapitre) : le bloc disparaît aussi.
local showMessage = Tracker.ShowMessage
function Tracker:ShowMessage(...)
  hideAll(View)
  View.advice, View.pendingShown = nil, false
  return showMessage(self, ...)
end

-- Compte à rebours : seul le texte change ; le reste redessine le suivi.
Q:On("QUESTVALUE_CHANGED", function(what)
  if not Tracker.frame then return end
  if what == "tick" and View.pendingShown and View.why then
    local p = Q.QuestValue:Pending()
    if p then
      View.why:SetText(View:PendingText(p))
      return
    end
  end
  Tracker:Refresh()
end)
