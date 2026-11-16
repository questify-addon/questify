local addonName, Q = ...

-- Commandes /questify et /qf, et bouton du compartiment d'addons.
--   /qf            ouvre ou ferme le journal
--   /qf skip       passe l'étape courante
--   /qf back       rouvre l'étape précédente
--   /qf classe     journal sur l'onglet Quêtes de classe (alias /qf class)
--   /qf sacs       quêtes qui donnent un sac, avec leur état (alias /qf bags) ; /qf sacs reset repropose les ignorées
--   /qf hv         objets de quête achetables à l'hôtel des ventes (alias /qf ah) ; /qf hv reset recoche tout
--   /qf options    fenêtre d'options (/qf options <texte> : avec cette recherche)
--   /qf wizard     assistant de navigation
--   /qf export     mesures de temps, prêtes à copier
--   /qf session    résumé de la session de jeu (temps actif, temps mort, XP/h par zone)
--   /qf debug      messages de débogage (QuestifyDB.debug)
--   /qf navperf    mesures du routeur intégré (pire image, moyenne, calculs, mémoire) ; « reset » : à zéro
--   /qf arrow reset     flèche Questify (UI/Arrow.lua) remise à sa place par défaut
--   /qf check      autodiagnostic du client (API, QuestieDB, navigation, route) ; alias /qf diag
--   /qf bug        rapport de bug prêt à copier (alias /qf report) ; /qf bug clear vide les erreurs gardées
--   /qf theme <clé>     thème du suivi (parchment, dark, transparent, gradient) ; seul : la liste
--   /qf opacity <0-100> opacité du fond et de la bordure du suivi ; seul : la valeur actuelle
--   /qf reset      efface la progression du personnage (après confirmation)
local L = Q.L

local RESET_DIALOG = "QUESTIFY_RESET"

-- Efface Q.char (même table : c'est la SavedVariable), remet les valeurs par défaut et
-- relance le choix du chapitre.
local function resetCharacter()
  local c = Q.char
  if type(c) ~= "table" then return end
  for k in pairs(c) do c[k] = nil end
  Q.Util.CopyDefaults(c, Q.charDefaults)
  c.wizardDone = nil
  if Q.Progress.Invalidate then Q.Progress.Invalidate() end
  -- ResetGuide (flux A) efface aussi les validations de position gardées pour la session.
  if Q.Progress.ResetGuide then
    for _, g in ipairs(Q.Guides:All()) do Q.Progress:ResetGuide(g.id) end
  end
  local P = Q.Player or {}
  local g = Q.Progress:IsEnabled() and Q.Guides:ForPlayer(P.faction, P.raceKey, P.level)
  if g then
    Q.Progress:SetGuide(g.id)
  else
    Q.Progress:Update()
  end
  Q:Fire("CLASSQUESTS_CHANGED")
  Q:Print(L.UI_RESET_DONE)
end

if StaticPopupDialogs then
  StaticPopupDialogs[RESET_DIALOG] = {
    text = L.UI_RESET_CONFIRM,
    button1 = YES or L.UI_BTN_YES,
    button2 = NO or L.UI_BTN_NO,
    OnAccept = function() Q.SafeCall(resetCharacter) end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    showAlert = true,
    preferredIndex = 3,
  }
end

local function journal() return Q.UI and Q.UI.Journal end

local COMMANDS = {}

COMMANDS[""] = function()
  local J = journal()
  if J then J:Toggle() end
end

COMMANDS.skip = function()
  local cur = Q.Progress:Current()
  if cur then Q.Progress:Skip(cur.key) else Q:Print(L.UI_SLASH_NO_STEP) end
end

COMMANDS.back = function()
  if not Q.Progress:Back() then Q:Print(L.UI_SLASH_NO_BACK) end
end

-- Choix de la suite : le chapitre en attente, sinon le chapitre courant (choix d'avance) ou le dernier
-- chapitre où une suite a été choisie (UI/RouteChoicePopup.lua).
COMMANDS.route = function()
  local P = Q.UI and Q.UI.RouteChoicePopup
  if P then P:OpenForPlayer() end
end

-- Quêtes de classe : retrouver une quête en retard et l'ajouter à la route.
-- Zone de secours (Engine/Detour.lua) : /qf alt passe sur une autre zone du niveau du personnage (ou sur la
-- suivante), /qf alt back revient à la route.
local function detour(back)
  local D = Q.Detour
  if not D then return end
  if back then
    local g = D:Return()
    if g then Q:Print(L.DETOUR_BACK, Q.Guides:DisplayTitle(g)) else Q:Print(L.DETOUR_NOT_ACTIVE) end
    return
  end
  local g = D:Start()
  if g then
    Q:Print(L.DETOUR_STARTED, Q.Guides:DisplayTitle(g), tonumber(g.minLevel) or 1, tonumber(g.maxLevel) or 60)
  else
    Q:Print(L.DETOUR_NONE)
  end
end
Q.UI = Q.UI or {}
Q.UI.Detour = detour
COMMANDS.alt = function(rest)
  local arg = tostring(rest or ""):lower():match("^%s*(%S*)")
  detour(arg == "back" or arg == "retour")
end

-- Mode « Donjons » : cases des échelons, étoiles, contournement (UI/DungeonModePanel.lua).
COMMANDS.donjons = function()
  local P = Q.UI and Q.UI.DungeonModePanel
  if P then P:Show() end
end
COMMANDS.dungeons = COMMANDS.donjons

COMMANDS.classe = function()
  local J = journal()
  if J then J:ShowTab("class") end
end
COMMANDS.class = COMMANDS.classe

-- Anciens rangs sur les barres d'action (Engine/ActionRanks.lua) : ouvre l'assistant ; « reset » repropose
-- les rangs ignorés.
COMMANDS.rangs = function(rest)
  local R = Q.ActionRanks
  if not R then return end
  local arg = tostring(rest or ""):lower():match("^%s*(%S*)")
  if arg == "reset" then
    R:ForgetIgnored()
    Q:Print(L.RANKS_FORGOTTEN)
  end
  if not R:Check(true) then Q:Print(L.RANKS_NONE) end
end
COMMANDS.ranks = COMMANDS.rangs

-- Quêtes de sac (Engine/BagQuests.lua) : liste dans la discussion ; « reset » repropose les quêtes ignorées.
local function bagsText(eq)
  local parts = {}
  for _, n in ipairs(eq.sizes) do parts[#parts + 1] = tostring(n) end
  for _ = 1, eq.empty do parts[#parts + 1] = L.UI_BAG_EMPTY end
  return table.concat(parts, ", ")
end

COMMANDS.sacs = function(rest)
  local BQ = Q.BagQuests
  if not BQ then return end
  if rest == "reset" then
    Q:Print(L.UI_BAGS_RESET, BQ:UnignoreAll())
    return
  end
  local rows = BQ:List()
  if #rows == 0 then
    Q:Print(L.UI_BAGS_NONE)
    return
  end
  Q:Print(L.UI_BAGS_HEADER, bagsText(BQ:Equipped()))
  for _, row in ipairs(rows) do
    local useful, slots = BQ:Useful(row.entry)
    local size = slots and L.UI_BAGS_SIZE:format(slots) or L.UI_BAGS_SIZE_UNKNOWN
    local state = L["UI_BQ_STATE_" .. row.state] or row.state
    if row.state == "available" then state = state .. " (" .. (useful and L.UI_BAGS_USEFUL or L.UI_BAGS_NOT_USEFUL) .. ")" end
    Q:Print(L.UI_BAGS_LINE, tonumber(row.entry.level) or 1, BQ:Title(row.entry), size, state)
  end
  Q:Print(L.UI_BAGS_HINT)
end
COMMANDS.bags = COMMANDS.sacs

-- Objets achetables à l'hôtel des ventes (Engine/AuctionItems.lua) : liste ; « reset » recoche les objets.
COMMANDS.hv = function(rest)
  local AI, P = Q.AuctionItems, Q.UI.AuctionPanel
  if not (AI and P) then return end
  if rest == "reset" then
    Q:Print(L.AH_SLASH_RESET, AI:ResetChoices())
    return
  end
  if not AI:Enabled() then
    Q:Print(L.AH_SLASH_OFF)
    return
  end
  P:ToggleList()
end
COMMANDS.ah = COMMANDS.hv

COMMANDS.options = function(rest)
  local O = Q.UI and Q.UI.Options
  if not O then return end
  O:Open()
  if rest and rest ~= "" then O:SetSearch(rest) end
end
COMMANDS.config = COMMANDS.options

COMMANDS.wizard = function()
  if Q.UI and Q.UI.Wizard then Q.UI.Wizard:Show() end
end

COMMANDS.export = function()
  local O = Q.UI and Q.UI.Options
  if O then
    O:ShowTelemetryExport()
    Q:Print(L.UI_SLASH_EXPORTED)
  end
end

-- Résumé de la session (Engine/Pace.lua) : temps de jeu, actif, temps mort, XP/h par zone ; la
-- session précédente suit si elle existe.
COMMANDS.session = function()
  local P = Q.Pace
  if not P then return end
  Q:Print(L.PACE_SESSION_HEADER)
  for _, line in ipairs(P:SessionLines()) do Q:Print("%s", line) end
  local last = P:LastSession()
  if last then
    Q:Print(L.PACE_SESSION_PREVIOUS)
    for _, line in ipairs(P:SessionLines(last)) do Q:Print("%s", line) end
  end
end

COMMANDS.debug = function()
  QuestifyDB = QuestifyDB or {}
  QuestifyDB.debug = not QuestifyDB.debug
  Q:Print(QuestifyDB.debug and L.UI_SLASH_DEBUG_ON or L.UI_SLASH_DEBUG_OFF)
end

-- Réglages rapides du suivi (UI/Themes.lua), aussi dans la fenêtre d'options (section Thème).
local function themeList()
  local parts = {}
  for _, th in ipairs(Q.Themes:List()) do parts[#parts + 1] = th.key .. " (" .. th.label .. ")" end
  return table.concat(parts, ", ")
end

COMMANDS.theme = function(rest)
  local T = Q.Themes
  if not T then return end
  if rest == "" then
    Q:Print(L.UI_SLASH_THEME_LIST, themeList(), L[T:Current().label])
    return
  end
  -- « /qf theme race » : le thème suit de nouveau la race du personnage
  if rest:lower() == "race" or rest:lower() == L.UI_THEME_MY_RACE:lower() then
    Q.Settings:Set("theme.followRace", true)
    Q:Print(L.UI_SLASH_THEME_SET, L[T:Current().label])
    return
  end
  local key = T:Find(rest)
  if not key then
    Q:Print(L.UI_SLASH_THEME_UNKNOWN, rest, themeList())
    return
  end
  T:Choose(key)
  Q:Print(L.UI_SLASH_THEME_SET, L[T:Get(key).label])
end

COMMANDS.opacity = function(rest)
  local T = Q.Themes
  if not T then return end
  local n = tonumber((rest:gsub("%%", "")))
  if not n then
    Q:Print(L.UI_SLASH_OPACITY_HELP, math.floor(T:Opacity(Q.Settings:Get("tracker.opacity")) * 100 + 0.5))
    return
  end
  n = math.max(0, math.min(100, math.floor(n + 0.5)))
  Q.Settings:Set("tracker.opacity", n / 100)
  Q:Print(L.UI_SLASH_OPACITY_SET, n)
end

-- Mesures du routeur intégré (Nav/Walk.lua, spec § 3 bis) ; « reset » les remet à zéro.
COMMANDS.navperf = function(rest)
  local W = Q.Walk
  if not W then return end
  if rest == "reset" then
    W:ResetPerf()
    Q:Print(L.UI_NAVPERF_RESET)
    return
  end
  local p = W:Perf()
  local m = p.memKB
  Q:Print(L.UI_NAVPERF, p.worstMs, p.avgMs, p.frames, p.searches, (m.Questify or 0) / 1024,
    (m.Questify_Nav or 0) / 1024, ((m.Questify_Nav_EK or 0) + (m.Questify_Nav_Kalimdor or 0)) / 1024,
    p.loadMs or 0)
end

-- Flèche Questify (UI/Arrow.lua) : « reset » la remet à sa place par défaut.
COMMANDS.arrow = function(rest)
  local A = Q.Arrow
  if not A then return end
  if rest == "reset" then
    A:ResetPosition()
    Q:Print(L.UI_ARROW_RESET)
    return
  end
  Q:Print(L.UI_ARROW_HELP)
end

COMMANDS.check = function()
  Q.Diagnostics:PrintChecks()
end
COMMANDS.diag = COMMANDS.check

COMMANDS.bug = function(rest)
  if rest == "clear" then
    Q:ClearErrors()
    Q:Print(L.REPORT_CLEARED)
    return
  end
  if Q.UI and Q.UI.Report then Q.UI.Report:Show() end
end
COMMANDS.report = COMMANDS.bug

COMMANDS.reset = function()
  if StaticPopup_Show then StaticPopup_Show(RESET_DIALOG) end
end

-- Commande cachée (absente de l'aide) : scènes d'exemple pour les captures en jeu (UI/Demo.lua).
COMMANDS.demo = function(rest)
  if Q.UI and Q.UI.Demo then Q.UI.Demo:Handle(rest) end
end

COMMANDS.help = function()
  Q:Print(L.UI_SLASH_HELP)
end

local function handle(msg)
  local cmd, rest = tostring(msg or ""):match("^%s*(%S*)%s*(.-)%s*$")
  cmd, rest = (cmd or ""):lower(), (rest or ""):lower()
  local fn = COMMANDS[cmd] or COMMANDS.help
  fn(rest)
end

SLASH_QUESTIFY1 = "/questify"
SLASH_QUESTIFY2 = "/qf"
-- Seule une clé est ajoutée : réaffecter la globale SlashCmdList la contaminerait (taint).
SlashCmdList.QUESTIFY = function(msg) Q.SafeCall(handle, msg) end

-- Bouton du compartiment d'addons (## AddonCompartmentFunc dans le TOC).
function Questify_OnAddonCompartmentClick()
  Q.SafeCall(function()
    local J = journal()
    if J then J:Toggle() end
  end)
end
