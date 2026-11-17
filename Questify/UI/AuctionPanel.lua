local addonName, Q = ...

-- Objets de collecte achetables à l'hôtel des ventes (Engine/AuctionItems.lua), deux fenêtres
-- (maquette docs/superpowers/specs/2026-11-16-hv-objets-quete-maquette.html) :
--   Liste (Panel:ShowList) : chapitre en cours puis suivant ; par objet une case (cochée = à acheter),
--     l'icône (infobulle complète du jeu, comme un objet des sacs : les addons de prix y ajoutent leurs
--     lignes), le nom et la quête, la quantité à acheter et les exemplaires des sacs, le prix unitaire et le
--     total (premier addon de prix trouvé) ; en bas le total de la sélection, la source des prix,
--     « Tout décocher » / « Tout cocher » et « Fermer ».
--   Liste d'achats (Panel:ShowShop) : accrochée à droite de la fenêtre de l'hôtel des ventes quand elle
--     s'ouvre et qu'il reste des objets cochés ; « Chercher » remplit et lance la recherche (nom exact),
--     la quantité suit les sacs, un objet couvert reste affiché comme fait jusqu'à la fermeture de l'HV.
-- Questify n'achète rien : chaque achat reste un clic du joueur dans l'hôtel des ventes.
Q.UI = Q.UI or {}
local Panel = { rows = {}, heads = {}, shopRows = {} }
Q.UI.AuctionPanel = Panel

local L = Q.L

local LIST_W = 560
local ROW_H = 36
local HEAD_H = 20
local SCOPE_H = 20         -- ligne des chapitres en haut de la liste
local MAX_ROWS = 14
local SHOP_W = 250
local SHOP_ROW_H = 34
local MAX_SHOP = 12
local ICON = 28

local function AI() return Q.AuctionItems end
local function popup() return Q.UI.ClassQuestPopup end

-- Bouton d'objet partagé avec la fenêtre des quêtes de classe (infobulle et clics d'un objet des sacs).
local function itemButton(parent, size)
  local P = popup()
  if P and P.CreateItemButton then return P.CreateItemButton(parent, size) end
  local b = CreateFrame("Button", nil, parent)
  b:SetSize(size, size)
  b.icon = b:CreateTexture(nil, "ARTWORK")
  b.icon:SetAllPoints(b)
  return b
end

local function setItem(b, itemId)
  local P = popup()
  if P and P.SetItemButton then return P.SetItemButton(b, itemId) end
  b.itemId = itemId
  b.icon:SetTexture(AI():Icon(itemId))
  b:Show()
end

local function questNames(row)
  local out = {}
  for _, q in ipairs(row.quests or {}) do out[#out + 1] = Q.QDB:QuestName(q) end
  return table.concat(out, ", ")
end
Panel.QuestNames = questNames

local function newWindow(name, w, h)
  local ok, f = pcall(CreateFrame, "Frame", name, UIParent, "ButtonFrameTemplate")
  if not ok or not f then f = CreateFrame("Frame", name, UIParent, "BackdropTemplate") end
  f:SetSize(w, h)
  f:SetFrameStrata("DIALOG")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  if ButtonFrameTemplate_HidePortrait then pcall(ButtonFrameTemplate_HidePortrait, f) end
  return f
end

local function text(parent, font, justify)
  local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  fs:SetJustifyH(justify or "LEFT")
  fs:SetWordWrap(false)
  return fs
end

---------------------------------------------------------------------------
-- Liste
---------------------------------------------------------------------------
local function newRow(parent)
  local r = CreateFrame("Frame", nil, parent)
  r:SetSize(LIST_W - 40, ROW_H)
  local cb = CreateFrame("CheckButton", nil, r, "UICheckButtonTemplate")
  cb:SetSize(22, 22)
  cb:SetPoint("LEFT", r, "LEFT", 0, 0)
  cb:SetScript("OnClick", function(self)
    Q.SafeCall(function()
      if r.item then AI():SetSkipped(r.item, not self:GetChecked()) end
    end)
  end)
  r.check = cb
  local icon = itemButton(r, ICON)
  icon:SetPoint("LEFT", r, "LEFT", 28, 0)
  r.icon = icon
  local name = text(r, "GameFontHighlight")
  name:SetPoint("TOPLEFT", r, "TOPLEFT", 64, -3)
  name:SetWidth(210)
  r.name = name
  local quest = text(r, "GameFontDisableSmall")
  quest:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
  quest:SetWidth(210)
  r.quest = quest
  local qty = text(r, "GameFontHighlight", "RIGHT")
  qty:SetPoint("TOPRIGHT", r, "TOPRIGHT", -194, -3)
  qty:SetWidth(80)
  r.qty = qty
  local bags = text(r, "GameFontDisableSmall", "RIGHT")
  bags:SetPoint("TOPRIGHT", qty, "BOTTOMRIGHT", 0, -2)
  bags:SetWidth(90)
  r.bags = bags
  local unit = text(r, "GameFontHighlightSmall", "RIGHT")
  unit:SetPoint("RIGHT", r, "RIGHT", -98, 0)
  unit:SetWidth(92)
  r.unit = unit
  local total = text(r, "GameFontHighlightSmall", "RIGHT")
  total:SetPoint("RIGHT", r, "RIGHT", 0, 0)
  total:SetWidth(92)
  r.total = total
  local line = r:CreateTexture(nil, "BACKGROUND")
  line:SetColorTexture(1, 1, 1, 0.06)
  line:SetHeight(1)
  line:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 0, 0)
  line:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", 0, 0)
  r:Hide()
  return r
end

local function chapterHead(parent)
  local fs = text(parent, "GameFontNormalSmall")
  fs:SetWidth(LIST_W - 40)
  fs:Hide()
  return fs
end

function Panel:CreateList()
  if self.list then return self.list end
  local f = newWindow("QuestifyAuctionList", LIST_W, 200)
  self.list = f
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  if f.SetTitle then f:SetTitle(L.AH_LIST_TITLE) end
  if UISpecialFrames then tinsert(UISpecialFrames, "QuestifyAuctionList") end

  local c = CreateFrame("Frame", nil, f)
  c:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -32)
  c:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -20, 34)
  self.content = c

  -- chapitres couverts : en cours (doré), puis suivant
  local scope = text(c, "GameFontNormalSmall")
  scope:SetPoint("TOPLEFT", c, "TOPLEFT", 0, 0)
  scope:SetWidth(LIST_W - 40)
  self.scope = scope

  -- en-têtes de colonnes
  local cols = {}
  cols.item = text(c, "GameFontDisableSmall"); cols.item:SetPoint("TOPLEFT", c, "TOPLEFT", 64, -SCOPE_H)
  cols.item:SetText(L.AH_COL_ITEM)
  cols.buy = text(c, "GameFontDisableSmall", "RIGHT"); cols.buy:SetPoint("TOPRIGHT", c, "TOPRIGHT", -194, -SCOPE_H)
  cols.buy:SetText(L.AH_COL_BUY)
  cols.unit = text(c, "GameFontDisableSmall", "RIGHT"); cols.unit:SetPoint("TOPRIGHT", c, "TOPRIGHT", -98, -SCOPE_H)
  cols.unit:SetText(L.AH_COL_UNIT)
  cols.total = text(c, "GameFontDisableSmall", "RIGHT"); cols.total:SetPoint("TOPRIGHT", c, "TOPRIGHT", 0, -SCOPE_H)
  cols.total:SetText(L.AH_COL_TOTAL)
  self.cols = cols

  local empty = text(c, "GameFontDisable")
  empty:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -24 - SCOPE_H)
  self.empty = empty

  local explain = c:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  explain:SetJustifyH("LEFT")
  explain:SetWordWrap(true)
  explain:SetWidth(LIST_W - 40)
  explain:SetText(L.AH_EXPLAIN)
  self.explain = explain

  local sum = text(f, "GameFontNormal")
  sum:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 10)
  sum:SetWidth(300)
  self.sum = sum

  local close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  close:SetSize(90, 22)
  close:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 4)
  close:SetText(L.AH_CLOSE)
  close:SetScript("OnClick", function() f:Hide() end)
  self.closeButton = close
  local all = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  all:SetSize(120, 22)
  all:SetPoint("RIGHT", close, "LEFT", -6, 0)
  all:SetScript("OnClick", function() Q.SafeCall(Panel.ToggleAll, Panel) end)
  self.allButton = all

  f:Hide()
  return f
end

-- Tout décocher (s'il reste une case cochée), sinon tout cocher.
function Panel:ToggleAll()
  local rows = AI():Rows()
  local anyOn = false
  for _, row in ipairs(rows) do if not row.skipped then anyOn = true end end
  for _, row in ipairs(rows) do AI():SetSkipped(row.item, anyOn) end
end

local function rowAt(self, i)
  local r = self.rows[i]
  if not r then r = newRow(self.content); self.rows[i] = r end
  return r
end

local function headAt(self, i)
  local h = self.heads[i]
  if not h then h = chapterHead(self.content); self.heads[i] = h end
  return h
end

function Panel:RefreshList()
  local f = self.list
  if not (f and f:IsShown()) then return end
  local c = self.content
  local rows = AI():Rows()
  local g = Q.Progress:Guide()
  local nxt = Q.Progress.NextGuide and Q.Progress:NextGuide()
  local scope = g and ("|cffffd100" .. Q.Guides:DisplayTitle(g) .. "|r") or ""
  if nxt then scope = scope .. "  |cff808080·|r  " .. Q.Guides:DisplayTitle(nxt) end
  self.scope:SetText(scope)
  local y = 16 + SCOPE_H
  local nRow, nHead, lastChapter = 0, 0, nil
  local sum, source, loading = 0, nil, false
  for _, row in ipairs(rows) do
    if row.state == "loading" then
      loading = true
    elseif nRow < MAX_ROWS then
      if row.chapter ~= lastChapter then
        lastChapter = row.chapter
        nHead = nHead + 1
        local h = headAt(self, nHead)
        h:SetText(row.chapter == "next" and L.AH_CHAPTER_NEXT or L.AH_CHAPTER_CURRENT)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y - 4)
        h:Show()
        y = y + HEAD_H
      end
      nRow = nRow + 1
      local r = rowAt(self, nRow)
      r.item = row.item
      r:ClearAllPoints()
      r:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
      r.check:SetChecked(not row.skipped)
      setItem(r.icon, row.item)
      r.icon:SetAlpha(row.skipped and 0.45 or 1)
      r.name:SetText(row.name or "")
      r.quest:SetText(questNames(row))
      r.qty:SetText(row.approx and (row.need .. "?") or tostring(row.need))
      r.bags:SetFormattedText(L.AH_IN_BAGS, row.have or 0)
      if row.price then
        r.unit:SetText(AI():Money(row.price))
        r.total:SetText(AI():Money(row.price * row.need))
        if not row.skipped then
          sum = sum + row.price * row.need
          source = source or row.source
        end
      else
        r.unit:SetText("—")
        r.total:SetText("—")
      end
      local a = row.skipped and 0.5 or 1
      r.name:SetAlpha(a); r.qty:SetAlpha(a); r.unit:SetAlpha(a); r.total:SetAlpha(a)
      r:Show()
      y = y + ROW_H
    end
  end
  for i = nRow + 1, #self.rows do self.rows[i].item = nil; self.rows[i]:Hide() end
  for i = nHead + 1, #self.heads do self.heads[i]:Hide() end
  if nRow == 0 then
    self.empty:SetText(loading and L.AH_LOADING or L.AH_EMPTY)
    self.empty:Show()
    y = y + 28
  else
    self.empty:Hide()
  end
  self.explain:ClearAllPoints()
  self.explain:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y - 8)
  y = y + 8 + (self.explain:GetStringHeight() or 24)
  local anyOn = false
  for _, row in ipairs(rows) do if not row.skipped then anyOn = true end end
  self.allButton:SetText(anyOn and L.AH_UNCHECK_ALL or L.AH_CHECK_ALL)
  self.allButton:SetShown(nRow > 0)
  self.sum:SetText(string.format(L.AH_SELECTION, AI():Money(sum)) .. "  ·  "
    .. string.format(L.AH_PRICES_FROM, source or L.AH_NO_PRICE_SOURCE))
  self.sum:SetShown(nRow > 0)
  f:SetHeight(32 + y + 44)
end

function Panel:ShowList()
  local f = self:CreateList()
  f:Show()
  if f.Raise then f:Raise() end
  self:RefreshList()
end

function Panel:ToggleList()
  local f = self:CreateList()
  if f:IsShown() then f:Hide() else self:ShowList() end
end

---------------------------------------------------------------------------
-- Liste d'achats à côté de l'hôtel des ventes
---------------------------------------------------------------------------
local shopItems = {}    -- objets affichés depuis l'ouverture de l'HV : [itemId] = { total, order }
local shopOrder = 0

local function newShopRow(parent)
  local r = CreateFrame("Frame", nil, parent)
  r:SetSize(SHOP_W - 24, SHOP_ROW_H)
  local icon = itemButton(r, 20)
  icon:SetPoint("LEFT", r, "LEFT", 0, 0)
  r.icon = icon
  local name = text(r, "GameFontHighlightSmall")
  name:SetPoint("TOPLEFT", r, "TOPLEFT", 26, -4)
  name:SetWidth(130)
  r.name = name
  local prog = text(r, "GameFontDisableSmall")
  prog:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
  prog:SetWidth(130)
  r.prog = prog
  local b = CreateFrame("Button", nil, r, "UIPanelButtonTemplate")
  b:SetSize(70, 20)
  b:SetPoint("RIGHT", r, "RIGHT", 0, 0)
  b:SetText(L.AH_SEARCH)
  b:SetScript("OnClick", function()
    Q.SafeCall(function()
      if r.item and not AI():Search(r.item) then Q:Print(L.AH_SEARCH_FAILED, AI():Name(r.item)) end
    end)
  end)
  r.search = b
  r:Hide()
  return r
end

function Panel:CreateShop()
  if self.shop then return self.shop end
  local f = newWindow("QuestifyAuctionShop", SHOP_W, 200)
  self.shop = f
  if f.SetTitle then f:SetTitle(L.AH_SHOP_TITLE) end
  if f.CloseButton then f.CloseButton:SetScript("OnClick", function() f:Hide() end) end
  local c = CreateFrame("Frame", nil, f)
  c:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -30)
  c:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 8)
  self.shopContent = c
  local sub = text(c, "GameFontDisableSmall")
  sub:SetPoint("TOPLEFT", c, "TOPLEFT", 0, 0)
  self.shopSub = sub
  local edit = CreateFrame("Button", nil, c, "UIPanelButtonTemplate")
  edit:SetSize(130, 20)
  edit:SetText(L.AH_EDIT_LIST)
  edit:SetScript("OnClick", function() Q.SafeCall(Panel.ShowList, Panel) end)
  self.editButton = edit
  local foot = c:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  foot:SetJustifyH("LEFT")
  foot:SetWordWrap(true)
  foot:SetWidth(SHOP_W - 24)
  foot:SetText(L.AH_SHOP_FOOT)
  self.shopFoot = foot
  f:Hide()
  return f
end

-- Lignes du panneau : objets cochés à acheter, puis ceux couverts depuis l'ouverture de l'HV (faits).
function Panel:ShopRows()
  local out, seen = {}, {}
  for _, row in ipairs(AI():Wanted()) do
    local s = shopItems[row.item]
    if not s then
      shopOrder = shopOrder + 1
      s = { order = shopOrder }
      shopItems[row.item] = s
    end
    s.total = row.total
    seen[row.item] = true
    out[#out + 1] = { item = row.item, name = row.name, have = row.have, total = row.total, approx = row.approx,
      order = s.order }
  end
  for item, s in pairs(shopItems) do
    if not seen[item] and s.total then
      local have = AI():Count(item)
      out[#out + 1] = { item = item, name = AI():Name(item), have = math.min(have, s.total), total = s.total,
        done = true, order = s.order }
    end
  end
  table.sort(out, function(a, b) return a.order < b.order end)
  return out
end

function Panel:RefreshShop()
  local f = self.shop
  if not f then return end
  local AHF = rawget(_G, "AuctionHouseFrame") or rawget(_G, "AuctionFrame")
  local rows = (AI():Enabled() and AI():IsOpen()) and self:ShopRows() or {}
  local open = 0
  for _, r in ipairs(rows) do if not r.done then open = open + 1 end end
  if #rows == 0 or (open == 0 and not f:IsShown()) then
    f:Hide()
    return
  end
  if type(AHF) == "table" and AHF.IsShown and AHF:IsShown() then
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", AHF, "TOPRIGHT", 4, 0)
  elseif not f:GetPoint() then
    f:SetPoint("LEFT", UIParent, "CENTER", 220, 0)
  end
  local c = self.shopContent
  self.shopSub:SetFormattedText(L.AH_SHOP_SUB, open)
  local y = 18
  local n = 0
  for _, row in ipairs(rows) do
    if n >= MAX_SHOP then break end
    n = n + 1
    local r = self.shopRows[n]
    if not r then r = newShopRow(c); self.shopRows[n] = r end
    r.item = row.item
    r:ClearAllPoints()
    r:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
    setItem(r.icon, row.item)
    r.name:SetText(row.name or "")
    if row.done then
      r.prog:SetFormattedText(L.AH_SHOP_DONE, row.have, row.total)
      r.name:SetAlpha(0.5)
      r.search:Disable()
    else
      r.prog:SetFormattedText(L.AH_SHOP_PROGRESS, row.have or 0, row.total)
      r.name:SetAlpha(1)
      r.search:Enable()
    end
    r:Show()
    y = y + SHOP_ROW_H
  end
  for i = n + 1, #self.shopRows do self.shopRows[i].item = nil; self.shopRows[i]:Hide() end
  self.editButton:ClearAllPoints()
  self.editButton:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y - 6)
  y = y + 32
  self.shopFoot:ClearAllPoints()
  self.shopFoot:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
  y = y + (self.shopFoot:GetStringHeight() or 24) + 4
  f:SetHeight(30 + y + 8)
  f:Show()
end

function Panel:ShowShop()
  self:CreateShop()
  self:RefreshShop()
end

local function refreshAll()
  if Panel.list and Panel.list:IsShown() then Panel:RefreshList() end
  if Panel.shop and AI() and AI():IsOpen() then Panel:RefreshShop() end
end

Q:On("AUCTION_ITEMS_CHANGED", refreshAll)
Q:On("PROGRESS_UPDATED", refreshAll)
Q:On("AUCTION_HOUSE_OPENED", function()
  shopItems, shopOrder = {}, 0
  -- la fenêtre de l'HV (chargée à la demande) s'affiche après l'évènement : on s'y accroche ensuite
  Q:After(0, function()
    if AI():Enabled() and AI():IsOpen() and #AI():Wanted() > 0 then Panel:ShowShop() end
  end)
end)
-- Lien « [Voir la liste] » du message de début de chapitre.
if EventRegistry and EventRegistry.RegisterCallback then
  EventRegistry:RegisterCallback("SetItemRef", function(_, link)
    if link == Q.AuctionItems.CHAT_LINK then Q.SafeCall(Panel.ShowList, Panel) end
  end, Panel)
end
Q:On("AUCTION_HOUSE_CLOSED", function()
  shopItems, shopOrder = {}, 0
  if Panel.shop then Panel.shop:Hide() end
end)
