local addonName, Q = ...

-- Fenêtre d'un donjon conseillé, ouverte depuis l'alerte du suivi (ou le journal) : nom, plage de
-- niveaux, zone de l'entrée, quêtes avec leur donneur, puis deux choix : « Ajouter à la route » et
-- « Ignorer ». Les deux marquent le donjon comme vu. Même modèle que UI/ClassQuestPopup.lua.
-- Habillage du thème (UI/Themes.lua) : bandeau avec blason et titre, textes et boutons aux couleurs du
-- thème (« Ajouter à la route » en action principale), repeints à chaque changement de thème.
Q.UI = Q.UI or {}
local Popup = { lines = {} }
Q.UI.DungeonPopup = Popup

local L = Q.L

local FRAME_NAME = "QuestifyDungeonPopup"
local WIDTH = 380
local INNER = WIDTH - 40
local MAX_LINES = 10
local OK_COLOR = "|cffffffff"
local LOCKED_COLOR = "|cff909090"
local GIVER_COLOR = "|cff00ff96"

---------------------------------------------------------------------------
-- Textes
---------------------------------------------------------------------------
function Popup.DungeonName(d)
  local D = Q.Dungeons
  if D and D.Name then return D:Name(d) end
  return tostring(type(d) == "table" and (d.name or d.key) or "?")
end

local function giverName(row)
  if row.giver then return Q.QDB:NpcName(row.giver) end
  if row.obj then return Q.QDB:ObjectName(row.obj) end
  return nil
end

-- Raison d'une quête bloquée par une chaîne de préquêtes : « demande 6 quêtes avant, chez Gryan (Westfall) ».
function Popup.ChainText(chain)
  if chain.reason then return L.DUNGEON_LOCKED_PREREQ end
  local n = tonumber(chain.count) or 0
  if n == 0 then return string.format(L.DUNGEON_LOCKED_LEVEL, tonumber(chain.readyLevel) or 1) end
  local who = chain.giver and Q.QDB:NpcName(chain.giver) or chain.obj and Q.QDB:ObjectName(chain.obj) or nil
  local zone = type(chain.mapId) == "number" and Q.Maps:MapName(chain.mapId) or nil
  if not who or not zone then return string.format(L.DUNGEON_CHAIN_LOCKED_NOZONE, n) end
  if n == 1 then return string.format(L.DUNGEON_CHAIN_LOCKED_ONE, who, zone) end
  return string.format(L.DUNGEON_CHAIN_LOCKED, n, who, zone)
end

-- Ligne d'une quête : « Nom - Donneur (Zone) », grisée avec la raison quand elle n'est pas à prendre.
-- opts.box : le journal montre la suite de préquêtes, le niveau ou la raison dans un encadré sous la ligne
-- (pas de raison ici).
function Popup.QuestLine(row, opts)
  local name = Q.QDB:QuestName(row.id)
  local who = giverName(row)
  -- donneur en couleur seulement pour une quête à prendre (une ligne grisée reste grise)
  if who and row.ok then who = GIVER_COLOR .. who .. OK_COLOR end
  local text
  if who and type(row.at) == "table" and type(row.at[1]) == "number" then
    text = string.format(L.DUNGEON_QUEST_GIVER, name, who, Q.Maps:MapName(row.at[1]))
  elseif who then
    text = string.format(L.DUNGEON_QUEST_GIVER_NOZONE, name, who)
  else
    text = name
  end
  if row.done then return LOCKED_COLOR .. text .. " (" .. L.DUNGEON_DONE_TAG .. ")|r" end
  local chain = type(row.chain) == "table" and row.chain or nil
  opts = opts or {}
  if chain and opts.box then return (row.ok and OK_COLOR or LOCKED_COLOR) .. text .. "|r" end
  if row.ok and row.reason ~= "log" then
    -- prise après une chaîne de préquêtes ajoutée à la route
    if chain then
      return OK_COLOR .. text .. "|r |cffaaaaaa(" .. string.format(L.DUNGEON_CHAIN_ADDED, chain.count or 0) .. ")|r"
    end
    return OK_COLOR .. text .. "|r"
  end
  local why
  if row.reason == "log" then
    why = L.DUNGEON_IN_LOG
  elseif row.reason == "level" then
    why = string.format(L.DUNGEON_LOCKED_LEVEL, tonumber(row.level) or 1)
  elseif chain then
    why = Popup.ChainText(chain)
  else
    why = L.DUNGEON_LOCKED_PREREQ
  end
  if row.ok then return OK_COLOR .. text .. "|r |cffaaaaaa(" .. why .. ")|r" end
  return LOCKED_COLOR .. text .. " (" .. why .. ")|r"
end

---------------------------------------------------------------------------
-- Habillage du thème (UI/Themes.lua, maquette docs/media/apercus/src/themes/maquette.html, popup(t)) :
-- gabarit de Blizzard caché, bordure de 1 px, fond, bandeau illustré de 46 px avec blason et titre,
-- coins, liseré, croix plate et pied aux couleurs du thème. Sans module de thèmes, le gabarit reste.
---------------------------------------------------------------------------
local HEADER_H, FOOTER_H = 36, 34
local TEXT_ROLES = { text = "body", textDim = "dim", textMuted = "muted" }

-- Couleur, ombre et police d'une ligne de texte ; rôles des jetons (text, textDim, textMuted) ou du
-- texte (title, quest, npc, xp, accent…).
local function paint(fs, role)
  local T = Q.Themes
  if T and fs then T:StyleText(fs, TEXT_ROLES[role] or role) end
end

-- Codes de couleur des textes remplacés par ceux du thème.
local function recolor(text)
  local T = Q.Themes
  if T then return T:Recolor(text) end
  return text
end

-- Bouton plat du thème : "primary" (action principale), "secondary" ou "ghost".
local function skin(btn, kind)
  btn.qvButtonKind = kind
  if Q.Themes then Q.Themes:SkinButton(btn, kind) end
  return btn
end

-- Habille la fenêtre f ; title : FontString posé dans le bandeau. -> pied { bg, line }, nil sans thème.
local function skinWindow(f, title)
  local T = Q.Themes
  if not T then return nil end
  T:StripTemplate(f)
  -- bordure de 1 px : le gabarit n'a pas de BackdropTemplate (Q.Themes:Apply ne pose alors que le fond)
  if not f.SetBackdrop and type(Mixin) == "function" and type(BackdropTemplateMixin) == "table" then
    Mixin(f, BackdropTemplateMixin)
    if f.OnBackdropSizeChanged then f:HookScript("OnSizeChanged", f.OnBackdropSizeChanged) end
  end
  T:Apply(f, T:CurrentKey(), 1)
  T:Decorate(f, { header = HEADER_H, title = title })
  local foot = { bg = f:CreateTexture(nil, "BACKGROUND", nil, -3), line = f:CreateTexture(nil, "BORDER") }
  foot.bg:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
  foot.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
  foot.bg:SetHeight(FOOTER_H)
  foot.line:SetPoint("BOTTOMLEFT", foot.bg, "TOPLEFT", 0, 0)
  foot.line:SetPoint("BOTTOMRIGHT", foot.bg, "TOPRIGHT", 0, 0)
  foot.line:SetHeight(1)
  return foot
end

-- Croix et pied aux couleurs du thème (à la création et à chaque changement de thème).
local function paintChrome(f, foot)
  local T = Q.Themes
  if not (T and f) then return end
  T:SkinClose(f)
  if foot then
    foot.bg:SetColorTexture(T:Color("footer"))
    foot.line:SetColorTexture(T:Color("line"))
  end
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function newFrame()
  local ok, f = pcall(CreateFrame, "Frame", FRAME_NAME, UIParent, "ButtonFrameTemplate")
  if not ok or not f then
    f = CreateFrame("Frame", FRAME_NAME, UIParent, "BackdropTemplate")
  end
  return f
end

local function text(parent, font, width)
  local fs = parent:CreateFontString(nil, "OVERLAY", font)
  fs:SetJustifyH("LEFT")
  if width then fs:SetWidth(width) end
  return fs
end

function Popup:Create()
  if self.frame then return self.frame end
  local f = newFrame()
  self.frame = f
  f:SetSize(WIDTH, 300)
  f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
  f:SetFrameStrata("DIALOG")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:EnableMouse(true)
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  if f.SetTitle then f:SetTitle(L.DUNGEON_POPUP_TITLE) end
  if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, "Interface\\Icons\\INV_Misc_Bone_HumanSkull_01") end
  if UISpecialFrames then tinsert(UISpecialFrames, FRAME_NAME) end
  local head = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  head:SetText(L.DUNGEON_POPUP_TITLE)
  self.headText = head
  self.foot = skinWindow(f, head)
  if not self.foot then head:Hide() end
  -- haut du contenu : sous le bandeau du thème, sinon dans le cadre intérieur du modèle
  self.top = self.foot and HEADER_H + 12 or 68

  local c = CreateFrame("Frame", nil, f)
  c:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -self.top)
  c:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 32)
  self.content = c

  self.title = text(c, "GameFontNormalLarge", INNER - 70)
  local counter = c:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  counter:SetPoint("TOPRIGHT", c, "TOPRIGHT", 0, -2)
  counter:SetJustifyH("RIGHT")
  self.counter = counter
  self.level = text(c, "GameFontHighlightSmall")
  self.entrance = text(c, "GameFontHighlight", INNER)
  self.questsHeader = text(c, "GameFontNormal")
  self.questsHeader:SetText(L.DUNGEON_QUESTS)
  self.empty = text(c, "GameFontDisable", INNER)
  self.empty:SetText(L.DUNGEON_NO_QUEST)
  self.more = text(c, "GameFontDisableSmall", INNER)

  local add = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  add:SetSize(150, 22)
  add:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, self.foot and (FOOTER_H - 22) / 2 + 1 or 4)
  add:SetText(L.UI_BTN_ADD_ROUTE)
  add:SetScript("OnClick", function() Q.SafeCall(function() Popup:Choose("Add") end) end)
  self.addButton = skin(add, "primary")
  local ignore = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
  ignore:SetSize(110, 22)
  ignore:SetPoint("RIGHT", add, "LEFT", -6, 0)
  ignore:SetText(L.UI_BTN_IGNORE)
  ignore:SetScript("OnClick", function() Q.SafeCall(function() Popup:Choose("Ignore") end) end)
  self.ignoreButton = skin(ignore, "secondary")

  self:ApplyTheme()
  f:Hide()
  return f
end

-- Rôle de couleur de chaque texte fixe de la fenêtre.
local TEXT_COLORS = {
  headText = "title", title = "title", counter = "textMuted", level = "textDim", entrance = "text",
  questsHeader = "textMuted", empty = "textMuted", more = "textMuted",
}

-- Couleurs du thème : textes, lignes de quête, boutons, croix et pied.
function Popup:ApplyTheme()
  if not (self.frame and Q.Themes) then return end
  for key, role in pairs(TEXT_COLORS) do paint(self[key], role) end
  for _, fs in ipairs(self.lines) do paint(fs, "text") end
  skin(self.addButton, "primary")
  skin(self.ignoreButton, "secondary")
  paintChrome(self.frame, self.foot)
end

local function line(i)
  local fs = Popup.lines[i]
  if fs then return fs end
  fs = text(Popup.content, "GameFontHighlightSmall", INNER)
  fs:SetWordWrap(true)
  paint(fs, "text")
  Popup.lines[i] = fs
  return fs
end

local function place(region, y)
  region:ClearAllPoints()
  region:SetPoint("TOPLEFT", Popup.content, "TOPLEFT", 0, -y)
end

---------------------------------------------------------------------------
-- Affichage
---------------------------------------------------------------------------
-- Show(d, index, total) : accepte aussi une ligne { dungeon, state } de Q.Dungeons:List().
function Popup:Show(d, index, total)
  if type(d) == "table" and type(d.dungeon) == "table" then d = d.dungeon end
  if type(d) ~= "table" then return end
  self:Create()
  self.dungeon = d
  self.shownWith = { index, total }
  self.demo = d.demo == true   -- scène /qf demo : les boutons ferment sans agir (UI/Demo.lua)
  local y = 0
  if tonumber(total) and total > 1 then
    self.counter:SetFormattedText(L.UI_POPUP_COUNTER, tonumber(index) or 1, total)
    self.counter:Show()
  else
    self.counter:SetText("")
    self.counter:Hide()
  end
  self.title:SetText(Popup.DungeonName(d))
  place(self.title, y)
  y = y + (self.title:GetStringHeight() or 16) + 4
  self.level:SetFormattedText(L.DUNGEON_LEVELS, tonumber(d.minLevel) or 1, tonumber(d.maxLevel) or 60)
  place(self.level, y)
  y = y + 18
  local ent = type(d.entrance) == "table" and d.entrance[1]
  if type(ent) == "number" then
    self.entrance:SetFormattedText(L.DUNGEON_ENTRANCE, Q.Maps:MapName(ent))
    place(self.entrance, y)
    self.entrance:Show()
    y = y + (self.entrance:GetStringHeight() or 14) + 10
  else
    self.entrance:Hide()
  end

  place(self.questsHeader, y)
  y = y + 18
  local rows = {}
  if Q.Dungeons and Q.Dungeons.Details then
    local ok, res = pcall(Q.Dungeons.Details, Q.Dungeons, d)
    if ok and type(res) == "table" then rows = res elseif not ok then Q:ReportError(res) end
  end
  -- quêtes à prendre d'abord, puis les autres ; les quêtes déjà rendues restent au journal
  local sorted = {}
  for _, r in ipairs(rows) do if r.ok then sorted[#sorted + 1] = r end end
  for _, r in ipairs(rows) do if not r.ok and not r.done then sorted[#sorted + 1] = r end end
  local shown = math.min(#sorted, MAX_LINES)
  for i = 1, shown do
    local fs = line(i)
    fs:SetText("- " .. recolor(Popup.QuestLine(sorted[i])))
    place(fs, y)
    fs:Show()
    y = y + (fs:GetStringHeight() or 13) + 3
  end
  for i = shown + 1, #self.lines do self.lines[i]:Hide() end
  if #sorted > shown then
    self.more:SetFormattedText(L.DUNGEON_MORE, #sorted - shown)
    place(self.more, y)
    self.more:Show()
    y = y + 16
  else
    self.more:Hide()
  end
  local any = false
  for _, r in ipairs(rows) do if r.ok then any = true end end
  if any then
    self.empty:Hide()
    self.addButton:Enable()
  else
    place(self.empty, y)
    self.empty:Show()
    y = y + 18
    self.addButton:Disable()
  end

  self.frame:SetHeight(math.max(220, y + self.top + 40))
  self.frame:Show()
  self.frame:Raise()
end

function Popup:Hide()
  if self.frame then self.frame:Hide() end
end

-- Choix du joueur : le donjon est marqué vu (l'alerte disparaît), puis ajouté ou ignoré (le module
-- envoie DUNGEONS_CHANGED), puis la fenêtre se ferme.
function Popup:Choose(action)
  if self.demo then return self:Hide() end   -- démo : rien n'est marqué ni ajouté
  local d = self.dungeon
  local D = Q.Dungeons
  if d and D then
    if D.MarkSeen then D:MarkSeen(d.key) end
    if D[action] then D[action](D, d.key) end
  end
  self:Hide()
  if Q.UI.Tracker and Q.UI.Tracker.Refresh then Q.UI.Tracker:Refresh() end
end

-- Changement de thème : couleurs repeintes ; fenêtre ouverte : lignes de quête refaites.
Q:On("THEME_CHANGED", function()
  if not Popup.frame then return end
  Q.SafeCall(Popup.ApplyTheme, Popup)
  if Popup.frame:IsShown() and Popup.dungeon then
    local w = Popup.shownWith or {}
    Q.SafeCall(Popup.Show, Popup, Popup.dungeon, w[1], w[2])
  end
end)
