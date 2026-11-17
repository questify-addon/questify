local addonName, Q = ...

-- Marques sur les récompenses au choix d'une quête, partout où le jeu les affiche (QuestInfo_Display :
-- fenêtre du PNJ au détail et à la fin de la quête, journal de quêtes) :
--   * flèche verte (coin haut gauche de l'icône) sur chaque choix qui améliore l'équipé, selon le
--     test commun Q.Rewards:UpgradeVerdict (profil de butin du personnage) ;
--   * pièce dorée (coin haut droit) sur le choix qui se revend le plus cher (prix × quantité), à
--     partir de deux choix, quand tous les prix sont connus ; les ex æquo l'ont tous.
-- Un même choix peut porter les deux. Rien sur le nom de l'objet. L'infobulle du choix dit
-- pourquoi (« Amélioration pour Voleur (Mêlée) · Pieds », « Se revend le plus cher »).
-- Objet pas encore en cache : pas de flèche, et pas de pièce tant qu'un prix manque ; les marques
-- se redessinent à son arrivée (GET_ITEM_INFO_RECEIVED). Réglage rewardMarks.
-- Couleurs : Q.Themes:SignalColor("upgrade" | "value"). Glyphes Media/RewardUpgrade.tga et
-- Media/RewardCoin.tga, blancs cernés de noir, teintés par SetVertexColor.
--
-- Approche reprise de Polestar (QoL/Rewards.lua, https://github.com/fitzforge/polestar, GPL-3.0,
-- © The Polestar authors) : crochet sur QuestInfo_Display, boutons QuestInfoFrame.rewardsFrame.
-- RewardButtons de type « choice » (ID = numéro du choix, icône .Icon de 39 px), flèche et pièce
-- dans les coins opposés de l'icône. Code et glyphes propres à Questify.
Q.UI = Q.UI or {}
local Marks = {}
Q.UI.RewardMarks = Marks

local MEDIA = "Interface\\AddOns\\" .. addonName .. "\\Media\\"
local UP_TEXTURE = MEDIA .. "RewardUpgrade"
local COIN_TEXTURE = MEDIA .. "RewardCoin"
Marks.UP_TEXTURE, Marks.COIN_TEXTURE = UP_TEXTURE, COIN_TEXTURE

local BADGE = 18     -- taille des glyphes
local OUTSET = 5     -- débord des glyphes hors de l'icône, vers le coin
local ICON = 39      -- icône des boutons de récompense (LargeItemButtonTemplate), sans .Icon

local frames = {}    -- bouton -> cadre des marques
local state = {}     -- bouton -> { upgrade, coin, verdict, equipLoc } du dessin en cours

function Marks:Enabled()
  return Q.Settings:Get("rewardMarks") ~= false
end

---------------------------------------------------------------------------
-- Fenêtre et boutons du jeu
---------------------------------------------------------------------------
local function rewardsFrame()
  local f = (QuestInfoFrame and QuestInfoFrame.rewardsFrame) or QuestInfoRewardsFrame
  if type(f) ~= "table" then return nil end
  if f.IsShown and not f:IsShown() then return nil end
  return f
end
Marks.RewardsFrame = rewardsFrame

local function fromQuestLog()
  return QuestInfoFrame and QuestInfoFrame.questLog and true or false
end

local function isChoice(b)
  return type(b) == "table" and b.type == "choice" and (b.objectType == nil or b.objectType == "item")
    and b.IsShown and b:IsShown()
end

-- ChoiceButtons(frame) -> { [numéro du choix] = bouton } des choix affichés.
function Marks.ChoiceButtons(frame)
  local out = {}
  if not frame then return out end
  if type(frame.RewardButtons) == "table" then
    for _, b in pairs(frame.RewardButtons) do
      if isChoice(b) then out[b:GetID()] = b end
    end
    return out
  end
  -- repli : boutons nommés <cadre>QuestInfoItemN
  local name = frame.GetName and frame:GetName()
  for i = 1, 10 do
    local b = name and _G[name .. "QuestInfoItem" .. i]
    if isChoice(b) then out[b:GetID()] = b end
  end
  return out
end

---------------------------------------------------------------------------
-- Cadre des marques
---------------------------------------------------------------------------
local function iconOf(button)
  if button.Icon then return button.Icon end
  local name = button.GetName and button:GetName()
  return name and _G[name .. "IconTexture"] or nil
end

local function paint(m)
  local T = Q.Themes
  if not T then return end
  m.up:SetVertexColor(T:SignalColor("upgrade"))
  m.coin:SetVertexColor(T:SignalColor("value"))
end

local function frameFor(button)
  local m = frames[button]
  if m then return m end
  m = CreateFrame("Frame", nil, button)
  m:SetFrameLevel((button:GetFrameLevel() or 1) + 3)
  local icon = iconOf(button)
  if icon then
    m:SetPoint("TOPLEFT", icon, "TOPLEFT", 0, 0)
    m:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0)
  else
    m:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    m:SetSize(ICON, ICON)
  end
  m.up = m:CreateTexture(nil, "OVERLAY", nil, 2)
  m.up:SetSize(BADGE, BADGE)
  m.up:SetPoint("TOPLEFT", m, "TOPLEFT", -OUTSET, OUTSET)
  m.up:SetTexture(UP_TEXTURE)
  m.coin = m:CreateTexture(nil, "OVERLAY", nil, 2)
  m.coin:SetSize(BADGE, BADGE)
  m.coin:SetPoint("TOPRIGHT", m, "TOPRIGHT", OUTSET, OUTSET)
  m.coin:SetTexture(COIN_TEXTURE)
  frames[button] = m
  return m
end
-- FrameOf(button) -> cadre des marques du bouton, nil s'il n'en a jamais eu.
function Marks.FrameOf(button) return frames[button] end

function Marks:HideAll()
  for _, m in pairs(frames) do m:Hide() end
  for b in pairs(state) do state[b] = nil end
end

---------------------------------------------------------------------------
-- Dessin
---------------------------------------------------------------------------
-- Draw() -> marques calculées ({ [choix] = { upgrade, coin, verdict } }, Q.Rewards:Marks), ou nil
-- quand rien n'est affiché (réglage coupé, pas de fenêtre de récompense, aucun choix).
function Marks:Draw()
  self:HideAll()
  if not self:Enabled() then return nil end
  local frame = rewardsFrame()
  if not frame then return nil end
  local R = Q.Rewards
  local choices = R:CollectChoices(fromQuestLog())
  if #choices == 0 then return nil end
  local result = R:Marks(choices, Q.Player)
  local buttons = Marks.ChoiceButtons(frame)
  local missing = {}
  for pos, c in ipairs(choices) do
    local index = c.index or pos
    local r = result[index]
    -- seuls les objets inconnus du client sont redemandés (sans les stats, un objet connu reste
    -- « wait » : le redemander ferait boucler GET_ITEM_INFO_RECEIVED)
    if c.priced == false then missing[#missing + 1] = c end
    local b = buttons[index]
    if b then
      state[b] = { upgrade = r.upgrade, coin = r.coin, verdict = r.verdict, equipLoc = c.equipLoc }
      if r.upgrade or r.coin then
        local m = frameFor(b)
        m.up:SetShown(r.upgrade)
        m.coin:SetShown(r.coin)
        paint(m)
        m:Show()
      end
    end
  end
  -- objets absents du cache : le client les charge, GET_ITEM_INFO_RECEIVED redessine
  if #missing > 0 then R:RequestLoad(missing) end
  return result
end

local pending = false
local function redraw()
  pending = false
  Marks:Draw()
end

-- Schedule() : redessine à la prochaine image (le jeu place ses boutons dans le même appel).
function Marks:Schedule()
  if pending then return end
  pending = true
  if C_Timer and C_Timer.After then Q:After(0, redraw) else Q.SafeCall(redraw) end
end

---------------------------------------------------------------------------
-- Infobulle des choix
---------------------------------------------------------------------------
local function icon(texture, role)
  local r, g, b = Q.Themes:SignalColor(role)
  return string.format("|T%s:14:14:0:0:32:32:0:32:0:32:%d:%d:%d|t ", texture,
    math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end

-- Pour qui : la classe, avec le profil de butin s'il n'est pas automatique.
local function who()
  local className = UnitClass and UnitClass("player") or nil
  local R = Q.Rewards
  local cf = Q.Player and Q.Player.classFile
  local role = R:Role(cf)
  local label = role ~= "auto" and R:RoleLabel(role, cf) or nil
  className = className or cf or "?"
  if label then return string.format("%s (%s)", className, label) end
  return className
end

-- TooltipLines(button) -> { { text, r, g, b } } à ajouter à l'infobulle du choix, ou {}.
function Marks:TooltipLines(button)
  local st = state[button]
  if not (st and self:Enabled() and isChoice(button)) then return {} end
  local L, T = Q.L, Q.Themes
  local lines = {}
  if st.upgrade then
    local slot = type(st.equipLoc) == "string" and st.equipLoc ~= "" and rawget(_G, st.equipLoc) or nil
    local text = type(slot) == "string" and string.format(L.REWARD_MARK_UPGRADE_SLOT, who(), slot)
      or string.format(L.REWARD_MARK_UPGRADE, who())
    local r, g, b = T:SignalColor("upgrade")
    lines[#lines + 1] = { icon(UP_TEXTURE, "upgrade") .. text, r, g, b }
  elseif st.verdict == "no" and type(st.equipLoc) == "string" and st.equipLoc ~= "" then
    local r, g, b = T:SignalColor("muted")
    lines[#lines + 1] = { L.REWARD_MARK_NO_UPGRADE, r, g, b }
  end
  if st.coin then
    local r, g, b = T:SignalColor("value")
    lines[#lines + 1] = { icon(COIN_TEXTURE, "value") .. L.REWARD_MARK_COIN, r, g, b }
  end
  return lines
end

-- OnItemTooltip(tooltip) -> nombre de lignes ajoutées (infobulle d'objet d'un bouton de choix).
function Marks:OnItemTooltip(tooltip)
  if type(tooltip) ~= "table" or not tooltip.GetOwner then return 0 end
  if tooltip.IsForbidden and tooltip:IsForbidden() then return 0 end
  local owner = tooltip:GetOwner()
  if not (owner and state[owner]) then return 0 end
  local lines = self:TooltipLines(owner)
  for _, l in ipairs(lines) do tooltip:AddLine(l[1], l[2], l[3], l[4]) end
  return #lines
end

local function installTooltip()
  local P, T = TooltipDataProcessor, Enum and Enum.TooltipDataType
  if P and P.AddTooltipPostCall and T and T.Item then
    -- après les lignes du jeu, avant l'affichage : pas de Show() ici
    P.AddTooltipPostCall(T.Item, function(tooltip) Q.SafeCall(Marks.OnItemTooltip, Marks, tooltip) end)
    return
  end
  if GameTooltip and GameTooltip.HookScript then
    GameTooltip:HookScript("OnTooltipSetItem", function(tt)
      local ok, added = Q.SafeCall(Marks.OnItemTooltip, Marks, tt)
      if ok and (added or 0) > 0 and tt.Show then tt:Show() end
    end)
  end
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
local hooked = false
local function hook()
  if hooked or not (hooksecurefunc and type(QuestInfo_Display) == "function") then return end
  hooksecurefunc("QuestInfo_Display", function() Marks:Schedule() end)
  hooked = true
end
hook()
installTooltip()

local function scheduleIfShown()
  if rewardsFrame() then Marks:Schedule() end
end

Q:RegisterEvent("PLAYER_LOGIN", hook)
Q:RegisterEvent("QUEST_COMPLETE", function() Marks:Schedule() end)
Q:RegisterEvent("QUEST_DETAIL", function() Marks:Schedule() end)
Q:RegisterEvent("QUEST_FINISHED", function() Marks:HideAll() end)
-- objet arrivé en cache, équipement changé : la fenêtre ouverte se redessine
Q:RegisterEvent("GET_ITEM_INFO_RECEIVED", scheduleIfShown)
Q:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", scheduleIfShown)
Q:On("SETTINGS_CHANGED", function(path)
  if path == "rewardMarks" or path == "rewardRole" or path == nil then scheduleIfShown() end
end)
