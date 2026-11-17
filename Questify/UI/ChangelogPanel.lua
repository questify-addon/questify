local addonName, Q = ...

-- Journal des versions dans la fenêtre d'options (UI/Options.lua, bouton du pied du menu) : à la place de la
-- liste défilante, les dernières versions de Q.ChangelogData (Data/Changelog.lua, généré depuis CHANGELOG.md par
-- tools/build_changelog.lua), en français pour un client français, sinon en anglais. Titre de version à l'accent,
-- titres de rubrique dorés, puces. Couleurs du thème (UI/Themes.lua).
Q.UI = Q.UI or {}
local Panel = { rows = {} }
Q.UI.ChangelogPanel = Panel

local L = Q.L
local GAP_VERSION, GAP_HEAD, GAP_ITEM = 14, 8, 3
local BULLET_W = 12

local function lang()
  local loc = GetLocale and GetLocale() or "enUS"
  return loc == "frFR" and "fr" or "en"
end

local function color(role)
  local T = Q.Themes
  if T then return T:Color(role, T:Current()) end
  return 1, 1, 1, 1
end

function Panel:Create(owner)
  if self.frame then return self.frame end
  local scroll = CreateFrame("ScrollFrame", "QuestifyChangelogScroll", owner, "UIPanelScrollFrameTemplate")
  local child = CreateFrame("Frame", nil, scroll)
  child:SetSize(400, 1)
  scroll:SetScrollChild(child)
  scroll:Hide()
  self.frame, self.child = scroll, child
  return scroll
end

-- Ligne n : texte (et puce), réutilisée d'un affichage à l'autre.
local function row(self, n)
  local r = self.rows[n]
  if r then return r end
  r = {}
  r.text = self.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  r.text:SetJustifyH("LEFT")
  r.text:SetWordWrap(true)
  r.bullet = self.child:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  r.bullet:SetText("•")
  self.rows[n] = r
  return r
end

-- Refresh() : réécrit le journal, de la version la plus récente à la plus ancienne.
function Panel:Refresh()
  if not self.frame then return end
  local width = math.max(200, (tonumber(self.frame:GetWidth()) or 400) - 24)
  self.child:SetWidth(width)
  local lg = lang()
  local y, n = 2, 0
  local function put(kind, text)
    n = n + 1
    local r = row(self, n)
    local fs = r.text
    fs:ClearAllPoints()
    if kind == "version" then
      fs:SetFontObject("GameFontNormalLarge")
      fs:SetTextColor(color("accent"))
      if n > 1 then y = y + GAP_VERSION end
    elseif kind == "head" then
      fs:SetFontObject("GameFontNormal")
      fs:SetTextColor(color("quest"))
      y = y + GAP_HEAD
    else
      fs:SetFontObject("GameFontHighlightSmall")
      fs:SetTextColor(color("text"))
      y = y + GAP_ITEM
    end
    local x = kind == "item" and BULLET_W + 4 or 4
    fs:SetPoint("TOPLEFT", self.child, "TOPLEFT", x, -y)
    fs:SetWidth(width - x - 4)
    fs:SetText(text)
    fs:Show()
    if kind == "item" then
      r.bullet:ClearAllPoints()
      r.bullet:SetPoint("TOPLEFT", self.child, "TOPLEFT", 6, -y)
      r.bullet:SetTextColor(color("accent"))
      r.bullet:Show()
    else
      r.bullet:Hide()
    end
    y = y + (tonumber(fs:GetStringHeight()) or 12)
  end
  local data = Q.ChangelogData or {}
  if #data == 0 then put("item", L.OPT_CHANGELOG_EMPTY) end
  for _, v in ipairs(data) do
    put("version", v.title == "Unreleased" and L.OPT_CHANGELOG_UNRELEASED or v.title)
    for _, l in ipairs(v[lg] or v.en or {}) do put(l.kind == "head" and "head" or "item", l.text) end
  end
  for i = n + 1, #self.rows do
    self.rows[i].text:Hide()
    self.rows[i].bullet:Hide()
  end
  self.child:SetHeight(y + 8)
  if self.frame.SetVerticalScroll then self.frame:SetVerticalScroll(0) end
  self.count = n
end

-- Attach(fenêtre, zone) : appelé par Options:ShowPanel ; le journal prend la place de la liste.
function Panel:Attach(owner, area)
  local f = self:Create(owner)
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", area, "TOPLEFT", 0, 0)
  f:SetPoint("BOTTOMRIGHT", area, "BOTTOMRIGHT", 0, 0)
  f:Show()
  self:Refresh()
  if Q.Themes then Q.Themes:SkinTree(f) end
end

function Panel:Detach()
  if self.frame then self.frame:Hide() end
end

function Panel:IsShown() return self.frame ~= nil and self.frame:IsShown() end
