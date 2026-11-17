local addonName, Q = ...

-- Marques de raid sur les monstres d'objectif visibles (option raidMarks).
-- SetRaidTarget est protégée sur ce client : aucun marquage automatique n'est possible, et on ne
-- l'appelle jamais. Un raccourci clavier (Bindings.xml) clique un bouton sécurisé caché dont la
-- macro pose d'un coup une icône libre (crâne, croix, losange…) sur chaque monstre d'objectif dont
-- la barre de nom est affichée, 8 au plus.
-- La macro est réécrite hors combat seulement, avec un court délai pour regrouper les évènements
-- (barres qui apparaissent ou disparaissent, icônes posées, groupe, progression). Elle s'arrête en
-- combat ([combat]) ; en combat rien ne change, elle est réécrite à PLAYER_REGEN_ENABLED.
-- Chaque ligne vise une barre par son jeton : /tm [@nameplateN,harm] ~<icône>. « harm » demande
-- une unité qui existe et qu'on peut attaquer ; « ~ » ne touche pas une unité déjà marquée. Les
-- conditions « exists » et « nodead » sont omises pour tenir 8 lignes en 255 caractères : « harm »
-- couvre « exists », et les morts sont écartés à l'écriture (leur barre disparaît aussi).
-- Macro du joueur (page « Marquage » de l'assistant, bouton des options) : « /click
-- QuestifyMarkObjectives », créée par Q.ClassMacros:CreatePlain avec l'icône d'un marqueur de raid,
-- sinon une longue-vue ; le joueur la prend ensuite dans /macro pour sa barre d'actions.
-- Monstres écartés à l'écriture : déjà marqués, tagués par un autre joueur, morts, amicaux, et toute
-- valeur secrète (restrictions Midnight). Par défaut, rien en groupe ni en instance.
Q.UI = Q.UI or {}
local RaidMarks = { units = {}, afterCombat = false }
Q.UI.RaidMarks = RaidMarks

local L = Q.L

local BUTTON = "QuestifyMarkObjectives"
local BINDING = "CLICK " .. BUTTON .. ":LeftButton"
local MACRO_MAX = 255         -- longueur maximale d'une macro
local MAX_MARKS = 8
local REFRESH_DELAY = 0.2     -- secondes : plusieurs évènements d'affilée, une seule réécriture
local HEAD = "/stopmacro [combat]\n"
-- Ordre des icônes : crâne, croix, losange, carré, lune, triangle, cercle, étoile.
local ICON_ORDER = { 8, 7, 3, 6, 5, 4, 2, 1 }
-- Unités dont l'icône compte comme prise (hors barres de nom, lues à part).
local OTHER_UNITS = { "player", "pet", "target", "focus", "party1", "party2", "party3", "party4" }

-- Texte de la fenêtre des raccourcis du jeu (en-tête BINDING_HEADER_QUESTIFY : UI/MobPanel.lua)
_G["BINDING_NAME_" .. BINDING] = L.UI_RAIDMARKS_BINDING

local function setting(path) return Q.Settings:Get(path) end
local function inCombat() return InCombatLockdown and InCombatLockdown() end

-- Lecture protégée d'une API : valeur, ou nil et true si elle est absente, en erreur ou secrète.
local function read(fn, ...)
  if type(fn) ~= "function" then return nil, true end
  local ok, v = pcall(fn, ...)
  if not ok or Q.Util.IsSecret(v) then return nil, true end
  return v, false
end

---------------------------------------------------------------------------
-- Macro
---------------------------------------------------------------------------
-- list = { { unit, icon } } dans l'ordre voulu ; les lignes qui dépassent 255 caractères sont omises.
local function buildMacro(list)
  local lines, size = {}, #HEAD
  for _, m in ipairs(list) do
    if #lines >= MAX_MARKS then break end
    local line = string.format("/tm [@%s,harm] ~%d", m.unit, m.icon)
    local add = #line + (#lines > 0 and 1 or 0)
    if size + add > MACRO_MAX then break end
    lines[#lines + 1] = line
    size = size + add
  end
  if #lines == 0 then return "" end
  return HEAD .. table.concat(lines, "\n")
end
RaidMarks.BuildMacro = function(_, list) return buildMacro(list) end

---------------------------------------------------------------------------
-- Monstres à marquer
---------------------------------------------------------------------------
local function allowed()
  if setting("raidMarks.enabled") ~= true then return false end
  if not (Q.Progress and Q.Progress:IsEnabled()) then return false end
  if setting("raidMarks.inGroup") ~= true then
    if read(IsInGroup) == true then return false end
    if read(IsInInstance) == true then return false end
  end
  return true
end

-- Jetons nameplateN des barres affichées, triés par numéro.
local function plateUnits()
  local seen = {}
  for unit in pairs(RaidMarks.units) do seen[unit] = true end
  if C_NamePlate and C_NamePlate.GetNamePlates then
    local ok, plates = pcall(C_NamePlate.GetNamePlates)
    if ok and type(plates) == "table" then
      for _, plate in ipairs(plates) do
        local u = plate.namePlateUnitToken or plate.unitToken
        if type(u) == "string" and not Q.Util.IsSecret(u) then seen[u] = true end
      end
    end
  end
  local list = {}
  for unit in pairs(seen) do
    local n = tonumber(unit:match("^nameplate(%d+)$"))
    if n then list[#list + 1] = { unit = unit, n = n } end
  end
  table.sort(list, function(a, b) return a.n < b.n end)
  return list
end

-- Icône posée sur l'unité : nombre de 1 à 8, nil sinon ; unknown = vrai si illisible (secrète).
local function markOf(unit)
  local v, unknown = read(GetRaidTargetIndex, unit)
  if unknown and type(GetRaidTargetIndex) == "function" then return nil, true end
  v = tonumber(v)
  if v and v >= 1 and v <= 8 then return v, false end
  return nil, false
end

local function markable(unit, set)
  local N = Q.UI.Nameplates
  local id = N and N:NpcId(unit)
  if not (id and set[id]) then return false end
  local tapped, unknownTap = read(UnitIsTapDenied, unit)
  if (unknownTap and type(UnitIsTapDenied) == "function") or tapped == true then return false end
  local dead, unknownDead = read(UnitIsDead, unit)
  if unknownDead or dead == true then return false end
  local hostile, unknownHostile = read(UnitCanAttack, "player", unit)
  if unknownHostile or hostile ~= true then return false end
  return true
end

-- { { unit, icon } } : monstres d'objectif à marquer, avec chacun une icône libre.
function RaidMarks:Wanted()
  if not allowed() then return {} end
  local N = Q.UI.Nameplates
  local set = N and N.ObjectiveSet and N:ObjectiveSet() or Q.Targets:ObjectiveNpcSet()
  local taken, targets = {}, {}
  for _, unit in ipairs(OTHER_UNITS) do
    local mark = markOf(unit)
    if mark then taken[mark] = true end
  end
  for _, p in ipairs(plateUnits()) do
    local mark, unknown = markOf(p.unit)
    if mark then
      taken[mark] = true
    elseif not unknown and markable(p.unit, set) then
      targets[#targets + 1] = p.unit
    end
  end
  local out, i = {}, 1
  for _, unit in ipairs(targets) do
    while ICON_ORDER[i] and taken[ICON_ORDER[i]] do i = i + 1 end
    local icon = ICON_ORDER[i]
    if not icon then break end
    out[#out + 1] = { unit = unit, icon = icon }
    i = i + 1
  end
  return out
end

---------------------------------------------------------------------------
-- Bouton du raccourci : seule sa macro change, hors combat.
---------------------------------------------------------------------------
local function button()
  if RaidMarks.button then return RaidMarks.button end
  local b = CreateFrame("Button", BUTTON, UIParent, "SecureActionButtonTemplate")
  b:RegisterForClicks("AnyUp", "AnyDown")
  b:SetAttribute("type", "macro")
  b:SetAttribute("macrotext", "")
  -- « /click » envoie un clic relâché (down = false) : avec ActionButtonUseKeyDown (actif par défaut), un
  -- bouton sécurisé n'agit qu'à l'appui et la macro du joueur ne ferait rien. Le bouton agit donc au
  -- relâché, pour la macro comme pour le raccourci (SecureActionButton_ShouldUseOnKeyDown).
  b:SetAttribute("useOnKeyDown", false)
  b:Hide()
  RaidMarks.button = b
  return b
end

function RaidMarks:Apply()
  if inCombat() then
    self.afterCombat = true
    return
  end
  self.afterCombat = false
  local macro = buildMacro(self:Wanted())
  local b = button()
  if b:GetAttribute("macrotext") ~= macro then b:SetAttribute("macrotext", macro) end
end

local pending = false
local function schedule()
  if inCombat() then
    RaidMarks.afterCombat = true
    return
  end
  if pending then return end
  pending = true
  Q:After(REFRESH_DELAY, function()
    pending = false
    RaidMarks:Apply()
  end)
end
RaidMarks.Schedule = function() schedule() end

---------------------------------------------------------------------------
-- Macro du joueur
---------------------------------------------------------------------------
local MACRO_BODY = "/click " .. BUTTON
-- Icône : premier fichier présent dans le client (GetFileIDFromPath) ; sans cette API, le nom de la
-- longue-vue, que CreateMacro accepte comme les icônes de la liste des macros.
local MACRO_ICON_FILES = {
  "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",   -- crâne des marqueurs de raid
  "Interface\\Icons\\INV_Misc_Spyglass_03",              -- longue-vue
  "Interface\\Icons\\Ability_Hunter_SniperShot",          -- viseur
}
local MACRO_ICON_NAME = "INV_Misc_Spyglass_03"

function RaidMarks:MacroIcon()
  if type(GetFileIDFromPath) == "function" then
    for _, path in ipairs(MACRO_ICON_FILES) do
      local ok, id = pcall(GetFileIDFromPath, path)
      id = ok and not Q.Util.IsSecret(id) and tonumber(id) or nil
      if id and id > 0 then return id end
    end
  end
  return MACRO_ICON_NAME
end

function RaidMarks:MacroName() return L.UI_RAIDMARKS_MACRO_NAME end

function RaidMarks:HasMacro()
  return Q.ClassMacros ~= nil and Q.ClassMacros:Index(self:MacroName()) > 0
end

-- Crée la macro et active l'option (sans elle la macro ne fait rien).
-- -> "created", "exists" ou la raison de l'échec ("combat", "full", "long", "noapi", "failed").
function RaidMarks:CreateMacro()
  if not Q.ClassMacros then return "noapi" end
  if self:HasMacro() then return "exists" end
  local ok, why = Q.ClassMacros:CreatePlain(self:MacroName(), self:MacroIcon(), MACRO_BODY)
  if not ok then return why or "failed" end
  if setting("raidMarks.enabled") ~= true then Q.Settings:Set("raidMarks.enabled", true) end
  return "created"
end

-- Texte pour le joueur selon le résultat de CreateMacro.
function RaidMarks:MacroMessage(state)
  if state == "created" then return string.format(L.UI_RAIDMARKS_MACRO_CREATED, self:MacroName()) end
  if state == "exists" then return string.format(L.UI_RAIDMARKS_MACRO_EXISTS, self:MacroName()) end
  if state == "combat" then return L.UI_RAIDMARKS_MACRO_COMBAT end
  if state == "full" then return L.UI_RAIDMARKS_MACRO_FULL end
  return L.UI_RAIDMARKS_MACRO_FAILED
end

-- Crée la macro et dit dans la discussion où la récupérer. -> état, message
function RaidMarks:CreateMacroAndTell()
  local state = self:CreateMacro()
  local msg = self:MacroMessage(state)
  Q:Print(msg)
  return state, msg
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
Q:RegisterEvent("NAME_PLATE_UNIT_ADDED", function(_, unit)
  if type(unit) ~= "string" then return end
  RaidMarks.units[unit] = true
  schedule()
end)

Q:RegisterEvent("NAME_PLATE_UNIT_REMOVED", function(_, unit)
  if type(unit) ~= "string" then return end
  RaidMarks.units[unit] = nil
  schedule()
end)

for _, event in ipairs({ "RAID_TARGET_UPDATE", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD" }) do
  Q:RegisterEvent(event, schedule)
end

-- Fin du combat : réécriture tout de suite, les jetons des barres ont pu changer pendant le combat.
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function() RaidMarks:Apply() end)

Q:On("LOGIN", function() RaidMarks:Apply() end)
for _, msg in ipairs({ "PROGRESS_UPDATED", "GUIDE_CHANGED", "ZONEMODE_CHANGED" }) do
  Q:On(msg, schedule)
end
Q:On("SETTINGS_CHANGED", function(path)
  if type(path) == "string" and path:find("^raidMarks") then schedule() end
end)
