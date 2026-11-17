local addonName, Q = ...

-- Suivi d'objectifs de Blizzard (ObjectiveTrackerFrame), deux options :
--
-- tracker.foldBlizzard (activée par défaut) : replié à chaque connexion et à chaque /reload. Le suivi
-- de Questify fait le même travail, et les deux côte à côte encombrent l'écran. Replié seulement : le
-- bouton du suivi de Blizzard le rouvre, et il reste ouvert jusqu'au chargement suivant.
-- Le gestionnaire du suivi de Blizzard range ses modules après PLAYER_ENTERING_WORLD : on replie une
-- seconde plus tard. En combat, on attend la fin du combat (le suivi de Blizzard porte des boutons
-- d'objets de quête).
--
-- tracker.hideBlizzard (désactivée par défaut, proposée par l'assistant) : masqué en permanence, comme
-- le font Polestar et Questie sur Forever. Hide() à la connexion, puis de nouveau chaque fois que le
-- jeu le réaffiche (HookScript OnShow : le script de Blizzard n'est pas remplacé). Option décochée :
-- le cadre est rendu à l'Update du jeu, qui ne l'affiche que s'il a quelque chose à montrer. Un cadre
-- rendu protégé par un autre addon attend la fin du combat. Jamais avec l'interface manette : sa
-- navigation à l'écran commence au suivi de Blizzard. Tant qu'il est masqué, le repli n'est pas
-- appliqué (inutile), et le suivi de Questify prend sa place (UI/Tracker.lua, événement
-- BLIZZARD_TRACKER_HIDDEN).
-- Polestar, Questie ou un autre addon peuvent masquer le même cadre : chacun garde son propre crochet,
-- et décocher l'option ici ne force pas l'affichage contre eux (Update, pas Show, quand il existe).
-- Sauf sous la colonne de ForeverCore (ShortestPath Forever et les autres addons Forever) : attachée
-- au suivi de Blizzard (son réglage par défaut), elle se cache dès qu'il est replié
-- (ForeverCore/UI/TrackerHost.lua 1.7.4, NativeCollapsed), et le trajet de ShortestPath avec elle.
Q.UI = Q.UI or {}
local Fold = { hidden = false }
Q.UI.BlizzardTracker = Fold

local DELAY = 1   -- secondes après l'entrée dans le monde

local function frame() return ObjectiveTrackerFrame end

local function inCombat() return InCombatLockdown and InCombatLockdown() and true or false end

-- Interface manette (C_InputInterfaceStyle ; sinon la CVar InputDeviceInterfaceStyle).
local function gamepadUI()
  local E = Enum and Enum.InputDeviceInterfaceType
  if not (E and E.Gamepad) then return false end
  local S = C_InputInterfaceStyle
  if S and S.GetCurrentStyle then
    local ok, style = pcall(S.GetCurrentStyle)
    return ok and style == E.Gamepad
  end
  local get = (C_CVar and C_CVar.GetCVar) or GetCVar
  return get and tonumber(get("InputDeviceInterfaceStyle")) == E.Gamepad or false
end

-- Vrai si l'option demande le masquage et qu'il est possible.
function Fold:WantsHidden()
  return Q.Settings:Get("tracker.hideBlizzard") == true and not gamepadUI()
end

-- Vrai tant que Questify garde le suivi de Blizzard masqué.
function Fold:IsHidden()
  return self.hidden == true
end

-- La colonne de ForeverCore est-elle attachée au suivi de Blizzard ?
local function foreverColumnAttached()
  local core = ForeverCore
  local host = type(core) == "table" and core.TrackerHost
  if type(host) ~= "table" or type(host.IsAttachedToQuestTracker) ~= "function" then return false end
  local ok, attached = pcall(host.IsAttachedToQuestTracker)
  return ok and attached == true
end

-- Apply() -> vrai si le suivi de Blizzard vient d'être replié.
function Fold:Apply()
  self.pending = nil
  if Q.Settings:Get("tracker.foldBlizzard") == false then return false end
  if self.hidden then return false end
  local otf = frame()
  if not (otf and otf.SetCollapsed) then return false end
  if otf.IsCollapsed and otf:IsCollapsed() then return false end
  if foreverColumnAttached() then return false end
  if inCombat() then
    self.pending = true
    return false
  end
  otf:SetCollapsed(true)
  return true
end

local function setHidden(value)
  if Fold.hidden == value then return end
  Fold.hidden = value
  Q:Fire("BLIZZARD_TRACKER_HIDDEN", value)
end

-- ApplyHide() : masque ou rend le suivi de Blizzard selon tracker.hideBlizzard.
function Fold:ApplyHide()
  local otf = frame()
  if not (otf and otf.Hide) then return end
  local want = self:WantsHidden()
  if want == self.hidden and not (want and otf:IsShown()) then return end
  if otf.IsProtected and otf:IsProtected() and inCombat() then
    self.pendingHide = true
    return
  end
  self.pendingHide = nil
  if want then
    if not self.hooked then
      self.hooked = true
      otf:HookScript("OnShow", function()
        if Fold.hidden then Q.SafeCall(Fold.ApplyHide, Fold) end
      end)
    end
    setHidden(true)
    if otf:IsShown() then otf:Hide() end
  else
    setHidden(false)
    if otf.Update then otf:Update() else otf:Show() end
  end
end

local function applyHide() Q.SafeCall(Fold.ApplyHide, Fold) end

Q:On("LOGIN", applyHide)

-- Suivi de Blizzard chargé après Questify (addon Blizzard_ObjectiveTracker chargé à la demande).
Q:RegisterEvent("ADDON_LOADED", function(_, name)
  if name == "Blizzard_ObjectiveTracker" and Q.loggedIn then applyHide() end
end)

Q:On("SETTINGS_CHANGED", function(path)
  if path == "tracker.hideBlizzard" or path == "tracker" then applyHide() end
end)

Q:On("PROFILE_CHANGED", applyHide)

-- Connexion et /reload seulement : pas à chaque changement de zone ou entrée en instance.
Q:RegisterEvent("PLAYER_ENTERING_WORLD", function(_, isInitialLogin, isReloadingUi)
  if not (isInitialLogin or isReloadingUi) then return end
  local function run() Q.SafeCall(Fold.Apply, Fold) end
  if C_Timer and C_Timer.After then C_Timer.After(DELAY, run) else run() end
end)

Q:On("COMBAT_ENDED", function()
  if Fold.pendingHide then applyHide() end
  if Fold.pending then Fold:Apply() end
end)
