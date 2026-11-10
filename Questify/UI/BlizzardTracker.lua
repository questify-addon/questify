local addonName, Q = ...

-- Suivi d'objectifs de Blizzard replié à chaque connexion et à chaque /reload (option
-- tracker.foldBlizzard, activée par défaut) : le suivi de Questify fait le même travail, et les deux
-- côte à côte encombrent l'écran. Replié seulement : le bouton du suivi de Blizzard le rouvre, et il
-- reste ouvert jusqu'au chargement suivant.
-- Le gestionnaire du suivi de Blizzard range ses modules après PLAYER_ENTERING_WORLD : on replie une
-- seconde plus tard. En combat, on attend la fin du combat (le suivi de Blizzard porte des boutons
-- d'objets de quête).
Q.UI = Q.UI or {}
local Fold = {}
Q.UI.BlizzardTracker = Fold

local DELAY = 1   -- secondes après l'entrée dans le monde

-- Apply() -> vrai si le suivi de Blizzard vient d'être replié.
function Fold:Apply()
  self.pending = nil
  if Q.Settings:Get("tracker.foldBlizzard") == false then return false end
  local otf = ObjectiveTrackerFrame
  if not (otf and otf.SetCollapsed) then return false end
  if otf.IsCollapsed and otf:IsCollapsed() then return false end
  if InCombatLockdown and InCombatLockdown() then
    self.pending = true
    return false
  end
  otf:SetCollapsed(true)
  return true
end

-- Connexion et /reload seulement : pas à chaque changement de zone ou entrée en instance.
Q:RegisterEvent("PLAYER_ENTERING_WORLD", function(_, isInitialLogin, isReloadingUi)
  if not (isInitialLogin or isReloadingUi) then return end
  local function run() Q.SafeCall(Fold.Apply, Fold) end
  if C_Timer and C_Timer.After then C_Timer.After(DELAY, run) else run() end
end)

Q:On("COMBAT_ENDED", function()
  if Fold.pending then Fold:Apply() end
end)
