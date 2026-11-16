local addonName, Q = ...

local Settings = {}
Q.Settings = Settings

-- Valeurs par défaut. Les valeurs choisies sont gardées dans le profil actif
-- (Core/Profiles.lua : QuestifyDB.profiles[nom].settings) ; une valeur absente du profil vaut
-- sa valeur par défaut. Chaque valeur a son entrée dans Core/OptionsSchema.lua (vérifié par un test).
Settings.defaults = {
  autoQuest = true,
  autoReward = true,
  rewardPick = "upgrade",   -- Automation/Rewards.lua : "upgrade" (amélioration d'abord) ou "value" (le plus cher)
  rewardMarks = true,       -- UI/RewardMarks.lua : flèche et pièce sur les choix de récompense
  dungeonQuests = true,
  nav = { routing = false, display = "native" },
  tracker = { locked = false, scale = 1, width = 260, nextSteps = 3, showMobs = true, autoTarget = false,
    theme = "parchment", opacity = 0.9,     -- UI/Themes.lua : thème et opacité du fond (0 à 1)
    foldBlizzard = true,                    -- UI/BlizzardTracker.lua : suivi de Blizzard replié
    hideBlizzard = false,                 -- UI/BlizzardTracker.lua : suivi de Blizzard masqué
    objLayout = "list", objDetail = "mobs" },   -- Engine/Objectives.lua : objectifs de l'étape
  nameplates = true,
  objectGlow = true,
  trainerAlert = true,
  trainerPanel = true,      -- UI/TrainerPanel.lua : panneau des sorts à côté du maître de classe
  oldRanks = true,          -- Engine/ActionRanks.lua : assistant des anciens rangs sur les barres
  upgradePopup = true,
  sellJunk = true,
  questItemButton = true,
  telemetry = true,
  -- Confort de jeu
  autoFly = true,           -- Automation/Taxi.lua
  hearthHints = true,       -- Engine/Hearth.lua
  dangerAlert = true,       -- Engine/Danger.lua
  supplyReminders = true,   -- Engine/Supplies.lua
  showXPRate = true,        -- Engine/XPRate.lua
  -- Donjons selon le niveau et la faction (alerte du suivi)
  dungeonSuggest = true,    -- Engine/Dungeons.lua
  classQuestOffer = true,   -- Engine/ClassQuestOffer.lua
  bagQuestOffer = true,     -- Engine/BagQuestOffer.lua
  -- Objets de collecte achetables à l'hôtel des ventes (alerte, liste, panneau à côté de l'HV)
  auctionItems = true,      -- Engine/AuctionItems.lua
  -- Repères des étapes sur la carte du monde et la minicarte
  mapPins = true,           -- UI/MapPins.lua
  zoneOverlay = true,       -- UI/ZoneOverlay.lua : zone du mode zone tracée sur la carte et la minicarte
  -- Objectifs proches de plusieurs quêtes regroupés en une seule visite
  zoneMode = true,          -- Engine/ZoneMode.lua
  -- Fin de chapitre à plusieurs suites : cartes à choisir (sinon la suite par défaut, sans demander)
  route = { choicePopup = true },   -- UI/RouteChoicePopup.lua
  -- Bouton de la minicarte (profil de butin, choix rapides, journal)
  minimapButton = true,     -- UI/MinimapButton.lua
  -- Proposition du profil de butin de la spécialisation choisie
  specRolePrompt = true,    -- Automation/SpecRole.lua
}

local function split(path)
  local parts = {}
  for p in tostring(path):gmatch("[^%.]+") do parts[#parts + 1] = p end
  return parts
end

local function walk(t, parts)
  for _, p in ipairs(parts) do
    if type(t) ~= "table" then return nil end
    t = t[p]
  end
  return t
end

-- Arbre des valeurs enregistrées : celui du profil actif (nil avant le chargement des
-- SavedVariables).
function Settings:Store()
  if not Q.db then return nil end
  local P = Q.Profiles
  if P and P.Store then return P:Store() end
  return nil
end

-- Get("nav.display") : valeur enregistrée dans le profil actif, sinon valeur par défaut.
function Settings:Get(path)
  local parts = split(path)
  local saved = self:Store()
  if saved then
    local v = walk(saved, parts)
    if v ~= nil then return v end
  end
  return walk(self.defaults, parts)
end

-- Set("nav.display", "tomtom") : enregistre dans le profil actif puis envoie
-- "SETTINGS_CHANGED"(path, value).
function Settings:Set(path, value)
  local store = self:Store()
  if not store then return end
  local parts = split(path)
  if #parts == 0 then return end
  local t = store
  for i = 1, #parts - 1 do
    local p = parts[i]
    if type(t[p]) ~= "table" then t[p] = {} end
    t = t[p]
  end
  t[parts[#parts]] = value
  Q:Fire("SETTINGS_CHANGED", path, value)
end
