local addonName, Q = ...

-- Boîte « Amélioration trouvée » sous le suivi (UI/Tracker.lua) quand un objet qui arrive dans les
-- sacs (butin, récompense de quête, achat) améliore l'équipement : icône, nom, ce qu'il apporte (les
-- deux plus forts gains de stats pour la classe), l'objet qu'il remplace, boutons « Équiper » et
-- « Non », barre qui se vide en 5 secondes. Au survol, la barre s'arrête et le comparatif avant →
-- après s'ouvre à côté de la boîte (UI/UpgradeCompare.lua). Clic droit sur la boîte : « Non ».
-- Plusieurs objets : une file, un objet à la fois, avec un compteur « 1/N ».
-- Position : collée sous le cadre du suivi (même largeur, même échelle), au-dessus quand la place
-- manque en bas de l'écran ; suivi caché : en haut au milieu de l'écran. Fond, bordure, texte et
-- barre suivent le thème du suivi (Q.Themes, réglages tracker.theme et tracker.opacity).
-- Détection : les sacs sont relus après chaque BAG_UPDATE_DELAYED et comparés au relevé précédent
-- (pas de lecture du chat, dont le texte peut être secret en combat). Le gain vient des poids de
-- stats par classe de Q.Rewards (le moins bon des emplacements comparés).
-- Arme à deux mains portée : une arme à une main ou une main gauche qui ne la bat qu'avec l'autre
-- moitié prise dans les sacs est proposée avec elle (« [masse] + [bouclier] »), et « Équiper »
-- équipe les deux : la main droite, puis la main gauche une fois la main droite en place (vue par
-- PLAYER_EQUIPMENT_CHANGED ou par un regard régulier ; plus long si le jeu demande de confirmer la
-- liaison). Les deux objets sont cherchés dans les sacs par ID d'objet.
-- Objet lié quand équipé : le jeu ouvre sa confirmation de liaison, rien n'est confirmé à la place
-- du joueur. Option upgradePopup.
-- Les objets proposés sont retenus un moment (Q.Rewards:Recommend) : la vente automatique les garde.
-- Jamais affichée en combat : la boîte attend PLAYER_REGEN_ENABLED (celle à l'écran au début d'un
-- combat est remise en tête de file, et repart avec 5 secondes pleines). « Équiper » ne fait rien
-- en combat.
Q.UI = Q.UI or {}
local Popup = { queue = {}, snapshot = nil, pendingItems = {}, shownCount = 0 }
Q.UI.UpgradePopup = Popup

local L = Q.L

local SHOW_TIME = 5          -- secondes avant de disparaître (souris dessus : en pause)
local RETRY_DELAY = 0.5      -- objet pas encore en cache : nouvel essai
local MAX_RETRIES = 6
local WIDTH = 260            -- largeur sans suivi visible (sinon celle du suivi)
local PAD = 8
local GAP = 4                -- écart avec le suivi
local ICON_SIZE = 36
local BTN_H = 20
local BAR_H = 4
local SOUND = 862            -- SOUNDKIT.IG_BACKPACK_OPEN : son discret
local EQUIP_CHECK = 0.2      -- paire : délai entre deux regards sur la main droite
local EQUIP_TRIES = 15       -- paire : 3 s au plus pour voir la main droite en place (latence)
local EQUIP_BIND_WAIT = 30   -- paire : secondes d'attente au plus tant que la confirmation de liaison est ouverte
-- Confirmations que le jeu ouvre avant d'équiper un objet lié quand équipé (StaticPopup).
local BIND_POPUPS = { "EQUIP_BIND", "EQUIP_BIND_TRADEABLE", "EQUIP_BIND_REFUNDABLE" }
local BAGS = { 0, 1, 2, 3, 4 }
Popup.SHOW_TIME = SHOW_TIME

-- Boutons : « Équiper » plein, « Non » discret ; parchemin à l'encre brune, sinon doré sur sombre.
local BUTTONS = {
  parchment = {
    primary = { bg = { 0.48, 0.24, 0, 1 }, border = { 0.30, 0.13, 0, 1 }, text = { 0.96, 0.90, 0.77 } },
    secondary = { bg = { 0, 0, 0, 0 }, border = { 0.72, 0.55, 0.25, 1 }, text = { 0.17, 0.10, 0.03 } },
  },
  dark = {
    primary = { bg = { 0.54, 0.42, 0, 1 }, border = { 1, 0.82, 0, 1 }, text = { 1, 1, 1 } },
    secondary = { bg = { 0.13, 0.13, 0.13, 0.9 }, border = { 0.33, 0.33, 0.33, 1 }, text = { 0.87, 0.87, 0.87 } },
  },
}
local WHITE = "Interface\\Buttons\\WHITE8x8"
local BUTTON_BACKDROP = { bgFile = WHITE, edgeFile = WHITE, edgeSize = 1 }

local function setting(path) return Q.Settings:Get(path) end
local function inCombat() return InCombatLockdown and InCombatLockdown() end

---------------------------------------------------------------------------
-- Sacs
---------------------------------------------------------------------------
local function numSlots(bag)
  if C_Container and C_Container.GetContainerNumSlots then return C_Container.GetContainerNumSlots(bag) or 0 end
  if GetContainerNumSlots then return GetContainerNumSlots(bag) or 0 end
  return 0
end

local function slotLink(bag, slot)
  if C_Container and C_Container.GetContainerItemLink then return C_Container.GetContainerItemLink(bag, slot) end
  if GetContainerItemLink then return GetContainerItemLink(bag, slot) end
  return nil
end

local function itemId(link)
  return type(link) == "string" and tonumber(link:match("item:(%d+)")) or nil
end

-- { [lien] = nombre d'exemplaires } de tous les sacs.
local function readBags()
  local counts = {}
  for _, bag in ipairs(BAGS) do
    for slot = 1, numSlots(bag) do
      local link = slotLink(bag, slot)
      if type(link) == "string" and not Q.Util.IsSecret(link) then counts[link] = (counts[link] or 0) + 1 end
    end
  end
  return counts
end
Popup.ReadBags = function() return readBags() end

---------------------------------------------------------------------------
-- Évaluation
---------------------------------------------------------------------------
local function itemIcon(link)
  local id = itemId(link)
  if C_Item and C_Item.GetItemIconByID and id then return C_Item.GetItemIconByID(id) end
  if GetItemIcon and id then return GetItemIcon(id) end
  return "Interface\\Icons\\INV_Misc_QuestionMark"
end

-- -> "upgrade" (gain, objet, paire), "no", ou "wait" si l'objet n'est pas encore en cache.
-- paire = { main = objet, off = objet } quand le gain demande aussi l'autre moitié, prise dans les
-- sacs (arme à deux mains portée).
function Popup:Evaluate(link)
  local item = Q.Rewards:ReadItem(link)
  local verdict, gain, pair = Q.Rewards:UpgradeVerdict(item, Q.Player)
  if verdict == "upgrade" then return "upgrade", gain, item, pair end
  return verdict
end

local function consider(link, tries)
  local verdict, gain, item, pair = Popup:Evaluate(link)
  if verdict == "wait" then
    if tries >= MAX_RETRIES then return end
    local id = itemId(link)
    if id and C_Item and C_Item.RequestLoadItemDataByID then C_Item.RequestLoadItemDataByID(id) end
    Q:After(RETRY_DELAY, function() consider(link, tries + 1) end)
    return
  end
  if verdict == "upgrade" then
    local entry = { link = link, name = item.name, gain = gain }
    if pair then entry.pair = { main = pair.main.link, off = pair.off.link } end
    Popup:Push(entry)
  end
end

-- Nouveaux objets depuis le relevé précédent (le premier relevé, à la connexion, n'annonce rien).
function Popup:ScanBags()
  local now = readBags()
  local before = self.snapshot
  self.snapshot = now
  if not before or setting("upgradePopup") == false then return end
  for link, n in pairs(now) do
    if n > (before[link] or 0) then consider(link, 0) end
  end
end

---------------------------------------------------------------------------
-- Cadre
---------------------------------------------------------------------------
local function makeButton(parent, label)
  local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
  b:SetHeight(BTN_H)
  if b.SetBackdrop then b:SetBackdrop(BUTTON_BACKDROP) end
  local text = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  text:SetPoint("CENTER", b, "CENTER", 0, 0)
  text:SetText(label)
  b.label = text
  local hl = b:CreateTexture(nil, "HIGHLIGHT")
  hl:SetAllPoints(b)
  hl:SetColorTexture(1, 1, 1, 0.12)
  b:RegisterForClicks("LeftButtonUp")
  return b
end

local function styleButton(b, s)
  if b.SetBackdropColor then
    b:SetBackdropColor(s.bg[1], s.bg[2], s.bg[3], s.bg[4] or 1)
    b:SetBackdropBorderColor(s.border[1], s.border[2], s.border[3], s.border[4] or 1)
  end
  b.label:SetTextColor(s.text[1], s.text[2], s.text[3], 1)
  b.qvStyle = s
end

function Popup:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyUpgradePopup", UIParent, "BackdropTemplate")
  f:SetSize(WIDTH, 100)
  f:SetFrameStrata("MEDIUM")
  f:EnableMouse(true)
  if f.SetClampedToScreen then f:SetClampedToScreen(true) end

  -- icône, et un filet de la couleur de la qualité derrière elle
  local iconBorder = f:CreateTexture(nil, "BORDER")
  iconBorder:SetSize(ICON_SIZE + 2, ICON_SIZE + 2)
  iconBorder:SetPoint("TOPLEFT", f, "TOPLEFT", PAD - 1, -PAD + 1)
  local icon = f:CreateTexture(nil, "ARTWORK")
  icon:SetSize(ICON_SIZE, ICON_SIZE)
  icon:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)

  local textX = PAD + ICON_SIZE + 8
  local header = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  header:SetJustifyH("LEFT")
  header:SetText(L.UI_UPGRADE_FOUND)
  local counter = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  counter:SetJustifyH("RIGHT")
  counter:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, -PAD + 2)
  local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  local gains = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  local instead = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  for _, fs in ipairs({ name, gains, instead }) do
    fs:SetJustifyH("LEFT")
    if fs.SetWordWrap then fs:SetWordWrap(true) end
  end

  local equip = makeButton(f, L.UI_UPGRADE_EQUIP)
  local no = makeButton(f, L.UI_UPGRADE_NO)
  equip:SetScript("OnClick", function() Q.SafeCall(Popup.Accept, Popup) end)
  no:SetScript("OnClick", function() Q.SafeCall(Popup.Decline, Popup) end)

  local bar = CreateFrame("StatusBar", nil, f)
  bar:SetHeight(BAR_H)
  bar:SetStatusBarTexture(WHITE)
  bar:SetMinMaxValues(0, SHOW_TIME)
  bar:SetValue(SHOW_TIME)
  local barBg = bar:CreateTexture(nil, "BACKGROUND")
  barBg:SetAllPoints(bar)

  f:SetScript("OnMouseUp", function(_, button)
    if button == "RightButton" then Q.SafeCall(Popup.Decline, Popup) end
  end)
  f:SetScript("OnUpdate", function(_, elapsed) Q.SafeCall(Popup.Tick, Popup, elapsed) end)
  f:Hide()
  self.frame, self.icon, self.iconBorder = f, icon, iconBorder
  self.header, self.counter, self.name, self.gains, self.instead = header, counter, name, gains, instead
  self.equipButton, self.noButton, self.bar, self.barBg = equip, no, bar, barBg
  self.textX = textX
  return f
end

-- Couleurs du thème du suivi : fond, bordure, textes, boutons, barre.
function Popup:ApplyTheme()
  local f = self.frame
  local T = Q.Themes
  if not (f and T) then return end
  -- thème en vigueur (race du personnage ou tracker.theme), comme le suivi
  local th = T:Apply(f, T.CurrentKey and T:CurrentKey() or setting("tracker.theme"), setting("tracker.opacity"))
  self.theme = th
  T:StyleText(self.header, "dim", th)
  T:StyleText(self.counter, "dim", th)
  T:StyleText(self.name, "body", th)
  T:StyleText(self.gains, "body", th)
  T:StyleText(self.instead, "dim", th)
  local styles = BUTTONS[th.key] or BUTTONS.dark
  styleButton(self.equipButton, styles.primary)
  styleButton(self.noButton, styles.secondary)
  local bar = th.bar or { fill = { 0.26, 0.56, 0.95 }, bg = { 0, 0, 0, 0.5 } }
  self.bar:SetStatusBarColor(bar.fill[1], bar.fill[2], bar.fill[3])
  self.barBg:SetColorTexture(bar.bg[1], bar.bg[2], bar.bg[3], bar.bg[4] or 1)
end

local function textHeight(fs)
  local h = fs:GetText() and fs:GetText() ~= "" and tonumber(fs:GetStringHeight()) or 0
  return h or 0
end

-- Place les lignes de texte à droite de l'icône, puis les boutons et la barre ; hauteur du cadre.
function Popup:Layout()
  local f, x = self.frame, self.textX
  local y = PAD
  local function line(fs, gapAfter)
    fs:ClearAllPoints()
    fs:SetPoint("TOPLEFT", f, "TOPLEFT", x, -y)
    fs:SetPoint("RIGHT", f, "RIGHT", -PAD, 0)
    y = y + textHeight(fs) + (gapAfter or 1)
  end
  line(self.header, 1)
  self.header:SetPoint("RIGHT", f, "RIGHT", -PAD - 30, 0)   -- place pour le compteur
  line(self.name, 1)
  line(self.gains, 0)
  line(self.instead, 0)
  y = math.max(y, PAD + ICON_SIZE) + 6
  local half = PAD / 2 - 1
  self.equipButton:ClearAllPoints()
  self.equipButton:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
  self.equipButton:SetPoint("TOPRIGHT", f, "TOP", -half, -y)
  self.noButton:ClearAllPoints()
  self.noButton:SetPoint("TOPLEFT", f, "TOP", half, -y)
  self.noButton:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, -y)
  y = y + BTN_H + 6
  self.bar:ClearAllPoints()
  self.bar:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -y)
  self.bar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PAD, -y)
  f:SetHeight(y + BAR_H + PAD)
end

-- Sous le suivi (même largeur et même échelle), au-dessus s'il touche le bas de l'écran ; suivi caché
-- ou absent : en haut au milieu de l'écran.
function Popup:Anchor()
  local f = self.frame
  local tracker = Q.UI.Tracker and Q.UI.Tracker.frame
  f:ClearAllPoints()
  if tracker and tracker:IsShown() then
    f:SetScale(tracker:GetScale() or 1)
    local bottom = tonumber(tracker:GetBottom()) or 0
    local need = (f:GetHeight() + GAP) * (f:GetScale() or 1)
    if bottom * (tracker:GetScale() or 1) < need then
      f:SetPoint("BOTTOMLEFT", tracker, "TOPLEFT", 0, GAP)
      f:SetPoint("BOTTOMRIGHT", tracker, "TOPRIGHT", 0, GAP)
      self.placement = "above"
    else
      f:SetPoint("TOPLEFT", tracker, "BOTTOMLEFT", 0, -GAP)
      f:SetPoint("TOPRIGHT", tracker, "BOTTOMRIGHT", 0, -GAP)
      self.placement = "below"
    end
  else
    f:SetScale(1)
    f:SetWidth(WIDTH)
    f:SetPoint("TOP", UIParent, "TOP", 0, -180)
    self.placement = "screen"
  end
end

-- Même paire (main droite et main gauche de mêmes ID d'objet) ?
local function samePair(a, b)
  if not (a and b) then return false end
  local am, ao = itemId(a.main), itemId(a.off)
  return am ~= nil and ao ~= nil and am == itemId(b.main) and ao == itemId(b.off)
end

-- Ajoute une annonce : un même objet, ou une même paire (masse et bouclier arrivés ensemble donnent
-- deux évaluations), n'est annoncé qu'une fois dans la file. L'objet, et l'autre moitié d'une paire,
-- sont retenus comme recommandés.
function Popup:Push(entry)
  Q.Rewards:Recommend(entry.link, entry.pair and entry.pair.main, entry.pair and entry.pair.off)
  local function dup(e)
    return e.link == entry.link or samePair(e.pair, entry.pair)
  end
  for _, e in ipairs(self.queue) do
    if dup(e) then return end
  end
  if self.current and dup(self.current) then return end
  self.queue[#self.queue + 1] = entry
  if self.current then return self:UpdateCounter() end
  self:Next()
end

-- « 2/3 » : rang de l'objet affiché parmi ceux de la série ; rien pour un objet seul.
function Popup:UpdateCounter()
  if not self.counter then return end
  local total = self.shownCount + #self.queue
  self.counter:SetText(total > 1 and (self.shownCount .. "/" .. total) or "")
end

local EMPTY = { before = {}, after = {}, fromBags = {}, stats = {}, summary = {}, effects = {} }

function Popup:ShowEntry(entry)
  local f = self:Create()
  local C = Q.UI.UpgradeCompare
  self.current = entry
  self.shownCount = self.shownCount + 1
  local ok, data = pcall(C.Build, C, entry)
  if not ok or type(data) ~= "table" then data = EMPTY end
  entry.compare = data
  self:ApplyTheme()
  local th = self.theme

  self.icon:SetTexture(itemIcon(entry.pair and entry.pair.main or entry.link))
  local main = data.after[1] or Q.Rewards:ReadItem(entry.link)
  local label = C:ItemLabel(main, th)
  if entry.pair and data.after[2] then label = label .. " + " .. C:ItemLabel(data.after[2], th) end
  self.name:SetText(label)
  -- filet de l'icône : couleur de la qualité (celle du nom)
  local rr, gg, bb = label:match("^|c%x%x(%x%x)(%x%x)(%x%x)")
  if rr then
    self.iconBorder:SetColorTexture(tonumber(rr, 16) / 255, tonumber(gg, 16) / 255, tonumber(bb, 16) / 255, 1)
  else
    self.iconBorder:SetColorTexture(0.6, 0.6, 0.6, 1)
  end

  local gains = #data.summary > 0 and table.concat(data.summary, ", ") or L.UI_UPGRADE_BETTER
  self.gains:SetText(Q.Themes and Q.Themes:Recolor(C.GAIN .. gains .. "|r", th) or gains)
  if #data.before > 0 then
    local names = {}
    for i, it in ipairs(data.before) do names[i] = C:ItemLabel(it, th) end
    self.instead:SetText(string.format(L.UI_UPGRADE_INSTEAD, table.concat(names, " + ")))
  else
    self.instead:SetText(L.UI_UPGRADE_EMPTY_SLOT)
  end
  self:UpdateCounter()
  -- largeur d'abord (celle du suivi) pour couper les lignes, puis la place selon la hauteur finale
  self:Anchor()
  self:Layout()
  self:Anchor()

  self.remaining = SHOW_TIME
  self.bar:SetValue(SHOW_TIME)
  self.hovering = false
  C:Hide()
  f:Show()
  if PlaySound then pcall(PlaySound, (SOUNDKIT and SOUNDKIT.IG_BACKPACK_OPEN) or SOUND) end
  self.serial = (self.serial or 0) + 1
end

-- Survol : comparatif ouvert et minuterie en pause ; sinon la barre se vide, puis l'objet suivant.
-- Une boîte de démonstration (UI/Demo.lua) reste affichée.
function Popup:Tick(elapsed)
  local cur, f = self.current, self.frame
  if not (cur and f and f:IsShown()) then return end
  local over = f:IsMouseOver() and true or false
  if over ~= self.hovering then
    self.hovering = over
    local C = Q.UI.UpgradeCompare
    if over then C:Show(f, cur.compare or EMPTY) else C:Hide() end
  end
  if over or cur.demo then return end
  self.remaining = (self.remaining or SHOW_TIME) - (tonumber(elapsed) or 0)
  self.bar:SetValue(math.max(0, self.remaining))
  if self.remaining <= 0 then self:Next() end
end

-- « Équiper » : rien en combat (la boîte reste) ; sinon l'objet (ou la paire), puis le suivant.
function Popup:Accept()
  if inCombat() then return end
  self:EquipCurrent()
  self:Next()
end

-- « Non » ou clic droit : l'objet suivant.
function Popup:Decline()
  self:Next()
end

local function hideFrame()
  if Popup.frame then Popup.frame:Hide() end
  if Q.UI.UpgradeCompare then Q.UI.UpgradeCompare:Hide() end
  Popup.hovering = false
end

-- Annonce suivante, ou fermeture. En combat : rien ne s'affiche, la file attend la fin du combat.
function Popup:Next()
  self.serial = (self.serial or 0) + 1
  local entry = table.remove(self.queue, 1)
  if entry and inCombat() then
    table.insert(self.queue, 1, entry)
    entry = nil
  end
  if entry then return self:ShowEntry(entry) end
  self.current = nil
  if #self.queue == 0 then self.shownCount = 0 end
  hideFrame()
end

-- Début de combat : l'annonce affichée repart en tête de file, sans être perdue.
function Popup:Suspend()
  local cur = self.current
  if not cur then return end
  self.serial = (self.serial or 0) + 1
  self.current = nil
  self.shownCount = math.max(0, self.shownCount - 1)
  table.insert(self.queue, 1, cur)
  hideFrame()
end

-- Fin de combat : reprise de la file.
function Popup:Resume()
  if self.current or #self.queue == 0 or inCombat() then return end
  self:Next()
end

-- Lien de l'objet dans les sacs : le même lien de préférence, sinon un objet de même ID (le lien
-- retenu par l'annonce peut différer de celui du sac) ; nil s'il n'y est plus.
local function findInBags(link)
  local inBags = readBags()
  if inBags[link] then return link end
  local id = itemId(link)
  if not id then return nil end
  for l in pairs(inBags) do
    if itemId(l) == id then return l end
  end
  return nil
end

-- Confirmation de liaison ouverte (objet lié quand équipé) : le jeu n'équipe qu'après le clic du joueur.
local function bindConfirmOpen()
  if type(StaticPopup_Visible) ~= "function" then return false end
  for _, which in ipairs(BIND_POPUPS) do
    local ok, shown = pcall(StaticPopup_Visible, which)
    if ok and shown then return true end
  end
  return false
end

-- Paire : les deux objets doivent être dans les sacs, sinon rien n'est équipé. La main droite
-- d'abord (elle remplace l'arme à deux mains) ; la main gauche seulement quand l'emplacement 16
-- porte la main droite (sinon le bouclier retirerait l'arme à deux mains et laisserait la main
-- droite vide), hors combat et si elle est toujours dans les sacs. La main droite en place se voit à
-- PLAYER_EQUIPMENT_CHANGED (emplacement 16) ou à un regard toutes les EQUIP_CHECK secondes : au plus
-- EQUIP_TRIES regards, ou jusqu'à EQUIP_BIND_WAIT secondes tant que la confirmation de liaison est
-- ouverte. Un message dit ce qui bloque.
local function equipPair(equip, main, off)
  for _, link in ipairs({ main, off }) do
    if not findInBags(link) then
      Q:Print(L.UI_UPGRADE_PAIR_MISSING, link)
      return false
    end
  end
  equip(findInBags(main), 16)
  local job = { done = false }
  Popup.pairJob = job
  local function finish()
    job.done = true
    if Popup.pairJob == job then Popup.pairJob = nil end
  end
  -- main droite en place ? alors la main gauche (une seule fois) ; -> vrai quand c'est réglé
  function job.mainInPlace()
    if job.done then return true end
    if itemId(GetInventoryItemLink("player", 16)) ~= itemId(main) then return false end
    finish()
    if inCombat() then
      Q:Print(L.UI_UPGRADE_PAIR_COMBAT, off)
      return true
    end
    local offLink = findInBags(off)
    if not offLink then
      Q:Print(L.UI_UPGRADE_PAIR_MISSING, off)
      return true
    end
    equip(offLink, 17)
    return true
  end
  local tries, waited = 0, 0
  local function check()
    if job.done or job.mainInPlace() then return end
    tries, waited = tries + 1, waited + EQUIP_CHECK
    if bindConfirmOpen() then
      if waited < EQUIP_BIND_WAIT then
        tries = 0   -- la latence se compte depuis la fermeture de la confirmation
        return Q:After(EQUIP_CHECK, check)
      end
    elseif tries < EQUIP_TRIES then
      return Q:After(EQUIP_CHECK, check)
    end
    finish()
    Q:Print(L.UI_UPGRADE_PAIR_FAILED, off)
  end
  Q:After(EQUIP_CHECK, check)
  return true
end

-- Équipe l'objet affiché (hors combat : le jeu refuse d'équiper en combat). Une paire : voir
-- equipPair.
function Popup:EquipCurrent()
  local cur = self.current
  if not cur or inCombat() or cur.demo then return false end   -- annonce de démo (UI/Demo.lua) : rien n'est équipé
  local equip = (C_Item and C_Item.EquipItemByName) or EquipItemByName
  if not equip then return false end
  if cur.pair then return equipPair(equip, cur.pair.main, cur.pair.off) end
  equip(cur.link)
  return true
end

-- Recommended(link) : objet annoncé il y a peu (seul ou dans une paire) ; voir Q.Rewards:Recommended.
function Popup:Recommended(link)
  return Q.Rewards:Recommended(link)
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
Q:On("LOGIN", function()
  Popup.snapshot = readBags()
end)
Q:RegisterEvent("BAG_UPDATE_DELAYED", function()
  Q.SafeCall(Popup.ScanBags, Popup)
end)
-- Paire en cours : la main droite vient d'arriver, la main gauche suit sans attendre le regard suivant.
Q:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", function(_, slot)
  local job = Popup.pairJob
  if slot == 16 and job and not job.done then job.mainInPlace() end
end)
Q:RegisterEvent("PLAYER_REGEN_DISABLED", function()
  Q.SafeCall(Popup.Suspend, Popup)
end)
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  Q.SafeCall(Popup.Resume, Popup)
end)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "upgradePopup" and setting("upgradePopup") == false then
    Popup.queue = {}
    Popup:Next()
  elseif (path == "tracker.theme" or path == "tracker.opacity") and Popup.current and Popup.frame then
    -- nouveau thème du suivi : la boîte affichée le prend tout de suite (le comparatif à son ouverture)
    Popup:ApplyTheme()
  end
end)
Q:On("THEME_CHANGED", function()
  if Popup.current and Popup.frame then Q.SafeCall(Popup.ApplyTheme, Popup) end
end)
