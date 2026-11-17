local addonName, Q = ...

-- Macros de la classe du joueur (onglet Options › Classe › Macros, UI/ClassPanel.lua).
-- Données : Q.ClassMacroData (Data/ClassMacros.lua, généré par tools/classguides/build.py depuis
-- classicwowforever.com/macros, CC BY 4.0) ; titres et explications traduits dans Q.ClassGuideText.
-- Le texte des macros porte des marqueurs : {sID} sort, {iID} objet, {r} mot « Rank » de la syntaxe
-- « Sort(Rank 1) ». Ils sont remplacés par les noms du client (C_Spell / C_Item), sinon par le nom
-- anglais relevé (ClassMacroData.names).
-- Créer : CreateMacro hors combat, dans les macros du personnage ou du compte, s'il reste de la place
-- (MAX_CHARACTER_MACROS / MAX_ACCOUNT_MACROS, 18 et 120 par défaut), 255 caractères au plus.
-- Questify retient les macros qu'il a créées (Q.char.classMacros[id] = { name, body, perChar }) pour
-- dire si elles sont à jour, modifiées à la main ou supprimées, et pour les mettre à jour (EditMacro).
local Macros = {}
Q.ClassMacros = Macros

local MAX_BODY = 255
local NAME_LEN = 16
local PREFIX = "QF "
local ICON = "INV_Misc_QuestionMark"
Macros.MAX_BODY, Macros.PREFIX = MAX_BODY, PREFIX

local function classFile()
  local cf = Q.Player and Q.Player.classFile
  if not cf and UnitClass then cf = select(2, UnitClass("player")) end
  return cf
end

local function inCombat() return InCombatLockdown and InCombatLockdown() and true or false end

local function plainString(v)
  if type(v) == "string" and not Q.Util.IsSecret(v) and v ~= "" then return v end
  return nil
end

function Macros:Store()
  local c = Q.char
  if type(c) ~= "table" then return {} end
  if type(c.classMacros) ~= "table" then c.classMacros = {} end
  return c.classMacros
end

-- Liste de la classe -> { macro } (données).
function Macros:All(cf)
  local d = Q.ClassMacroData and Q.ClassMacroData[cf or classFile() or ""]
  return d or {}
end

local function localText(m)
  local T = Q.ClassGuideText
  local c = T and T[classFile() or ""]
  return c and c.macros and c.macros[m.id] or nil
end

-- Textes dans la langue du client : title, use, requires, mods = { { key, does } }.
function Macros:Text(m)
  local t = localText(m)
  local mods = {}
  for i, mod in ipairs(m.mods or {}) do
    mods[i] = { key = mod[1], does = (t and t.mods and t.mods[i]) or mod[2] }
  end
  return {
    title = (t and t.title ~= "" and t.title) or m.title,
    use = (t and t.use ~= "" and t.use) or m.use,
    requires = (t and t.requires) or m.requires,
    mods = mods,
  }
end

-- Filtre : { pvp = bool, spec = clé | "class" | nil (toutes), origin = "classic" | "adapted" | "forever" | nil }.
function Macros:List(filter)
  filter = filter or {}
  local out = {}
  for _, m in ipairs(self:All()) do
    local ok = true
    if filter.pvp ~= nil and m.pvp ~= filter.pvp then ok = false end
    if ok and filter.spec == "class" and m.spec ~= nil then ok = false end
    if ok and filter.spec and filter.spec ~= "class" and m.spec ~= filter.spec then ok = false end
    if ok and filter.origin and m.origin ~= filter.origin then ok = false end
    if ok then out[#out + 1] = m end
  end
  return out
end

-- Compteurs pour les filtres : { pve, pvp, class, [spec] = n, classic, adapted, forever } (pour pvp donné).
function Macros:Counts(pvp)
  local c = { pve = 0, pvp = 0, class = 0, classic = 0, adapted = 0, forever = 0 }
  for _, m in ipairs(self:All()) do
    if m.pvp then c.pvp = c.pvp + 1 else c.pve = c.pve + 1 end
    if m.pvp == pvp then
      local k = m.spec or "class"
      c[k] = (c[k] or 0) + 1
    end
  end
  return c
end

---------------------------------------------------------------------------
-- Texte dans la langue du client
---------------------------------------------------------------------------
local function spellName(id)
  if type(C_Spell) == "table" and type(C_Spell.GetSpellName) == "function" then
    local ok, v = pcall(C_Spell.GetSpellName, id)
    if ok and plainString(v) then return v end
  end
  if type(GetSpellInfo) == "function" then
    local ok, v = pcall(GetSpellInfo, id)
    if ok and plainString(v) then return v end
  end
  return nil
end

local function itemName(id)
  if type(C_Item) == "table" and type(C_Item.GetItemNameByID) == "function" then
    local ok, v = pcall(C_Item.GetItemNameByID, id)
    if ok and plainString(v) then return v end
    if type(C_Item.RequestLoadItemDataByID) == "function" then pcall(C_Item.RequestLoadItemDataByID, id) end
  end
  if type(GetItemInfo) == "function" then
    local ok, v = pcall(GetItemInfo, id)
    if ok and plainString(v) then return v end
  end
  return nil
end

-- Mot du client pour « Rank » dans « Sort(Rank 1) ».
function Macros:RankWord()
  return Q.L.CLASS_MACRO_RANK or "Rank"
end

-- Texte de la macro pour ce client -> texte, { noms restés en anglais }.
function Macros:Body(m)
  local names = Q.ClassMacroData and Q.ClassMacroData.names or {}
  local missing = {}
  local body = m.code:gsub("{([si])(%d+)}", function(kind, id)
    id = tonumber(id)
    local n = kind == "s" and spellName(id) or itemName(id)
    if not n then
      n = names[kind .. id] or ("#" .. id)
      missing[#missing + 1] = n
    end
    return n
  end)
  body = body:gsub("{r}", self:RankWord())
  return body, missing
end

-- Nom d'un sort dans la langue du client, sinon le nom anglais relevé.
function Macros:SpellName(id)
  if not id then return nil end
  local names = Q.ClassMacroData and Q.ClassMacroData.names or {}
  return spellName(id) or names["s" .. id]
end

-- Texte de la macro pour l'affichage : noms de sorts et d'objets en couleur (code « ffrrggbb »).
function Macros:Highlight(m, _, colorHex)
  local names = Q.ClassMacroData and Q.ClassMacroData.names or {}
  local s = m.code:gsub("|", "||")
  s = s:gsub("{([si])(%d+)}", function(kind, id)
    id = tonumber(id)
    local n = (kind == "s" and spellName(id) or itemName(id)) or names[kind .. id] or ("#" .. id)
    return "|c" .. colorHex .. n .. "|r"
  end)
  return (s:gsub("{r}", self:RankWord()))
end

-- Sorts du texte (marqueurs {sID}), dans l'ordre -> { spellID }.
function Macros:Spells(m)
  local out, seen = {}, {}
  for id in m.code:gmatch("{s(%d+)}") do
    id = tonumber(id)
    if not seen[id] then seen[id] = true; out[#out + 1] = id end
  end
  return out
end

-- Le personnage connaît-il les sorts de la macro ? -> true, ou false et le premier sort inconnu.
function Macros:Known(m)
  local known = IsPlayerSpell or IsSpellKnown
  if type(known) ~= "function" then return true end
  for _, id in ipairs(self:Spells(m)) do
    local ok, v = pcall(known, id)
    if ok and v == false then return false, id end
  end
  return true
end

-- Coupe un texte UTF-8 à n caractères.
local function utf8Cut(s, n)
  local out, count = {}, 0
  for ch in s:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    if count >= n then break end
    out[#out + 1] = ch
    count = count + 1
  end
  return (table.concat(out):gsub("%s+$", ""))
end
Macros.Utf8Cut = utf8Cut

-- Nom de la macro dans le jeu : « QF » + début du titre traduit, 16 caractères au plus.
function Macros:DefaultName(m)
  local title = self:Text(m).title or m.id
  return PREFIX .. utf8Cut(title, NAME_LEN - #PREFIX)
end

---------------------------------------------------------------------------
-- Macros du jeu
---------------------------------------------------------------------------
-- Places : -> compte utilisées, compte max, perso utilisées, perso max.
function Macros:Slots()
  local acc, char = 0, 0
  if type(GetNumMacros) == "function" then
    local ok, a, c = pcall(GetNumMacros)
    if ok then acc, char = tonumber(a) or 0, tonumber(c) or 0 end
  end
  return acc, tonumber(MAX_ACCOUNT_MACROS) or 120, char, tonumber(MAX_CHARACTER_MACROS) or 18
end

local function macroIndex(name)
  if type(GetMacroIndexByName) ~= "function" or not name then return 0 end
  local ok, i = pcall(GetMacroIndexByName, name)
  return ok and tonumber(i) or 0
end

local function macroBody(index)
  if type(GetMacroInfo) ~= "function" or index == 0 then return nil end
  local ok, _, _, body = pcall(GetMacroInfo, index)
  return ok and body or nil
end

-- État d'une macro pour ce personnage :
--   "new" (jamais créée par Questify), "deleted" (créée puis supprimée), "ok" (à jour), "outdated" (le
--   site ou la langue a changé, pas de retouche à la main), "edited" (modifiée à la main).
function Macros:Status(m)
  local rec = self:Store()[m.id]
  if not rec then return "new" end
  local index = macroIndex(rec.name)
  if index == 0 then return "deleted" end
  local body = macroBody(index) or ""
  local want = self:Body(m)
  if body == want then return "ok" end
  if body == rec.body then return "outdated" end
  return "edited"
end

-- Texte body écrivable ? -> true ou false, raison ("combat", "full", "long", "noapi").
-- update : macro existante (pas de place à prendre).
local function canWrite(body, perChar, update)
  if type(CreateMacro) ~= "function" or type(GetNumMacros) ~= "function" then return false, "noapi" end
  if inCombat() then return false, "combat" end
  if #body > MAX_BODY then return false, "long" end
  if not update then
    local acc, accMax, char, charMax = Macros:Slots()
    if perChar and char >= charMax then return false, "full" end
    if not perChar and acc >= accMax then return false, "full" end
  end
  return true
end

-- Peut-on créer ou mettre à jour ? -> true ou false, raison ("combat", "full", "long", "noapi").
function Macros:CanWrite(m, perChar, update)
  return canWrite(self:Body(m), perChar, update)
end

-- Index d'une macro du jeu par son nom (0 : absente).
function Macros:Index(name) return macroIndex(name) end

-- Macro hors données de classe (UI/RaidMarks.lua) : dans les macros du compte, sinon dans celles du
-- personnage quand le compte est plein. icon : nom d'icône ou fileID.
-- -> true ou false, raison ("combat", "full", "long", "noapi", "failed").
function Macros:CreatePlain(name, icon, body)
  local acc, accMax = self:Slots()
  local perChar = acc >= accMax
  local ok, why = canWrite(body, perChar, false)
  if not ok then return false, why end
  local done, index = pcall(CreateMacro, name, icon, body, perChar and true or nil)
  if not done or not index or index == 0 then return false, "failed" end
  return true
end

-- Nom libre : le nom par défaut, sinon suffixé d'un chiffre si une autre macro le porte déjà.
local function freeName(base)
  if macroIndex(base) == 0 then return base end
  for i = 2, 9 do
    local n = utf8Cut(base, NAME_LEN - 2) .. " " .. i
    if macroIndex(n) == 0 then return n end
  end
  return base
end

-- Crée la macro (perChar : macros du personnage) -> true ou false, raison.
function Macros:Create(m, perChar)
  local ok, why = self:CanWrite(m, perChar, false)
  if not ok then return false, why end
  local body = self:Body(m)
  local name = freeName(self:DefaultName(m))
  local done, index = pcall(CreateMacro, name, ICON, body, perChar and true or nil)
  if not done or not index or index == 0 then return false, "failed" end
  self:Store()[m.id] = { name = name, body = body, perChar = perChar and true or false }
  Q:Fire("CLASS_MACROS_CHANGED")
  return true
end

-- Met à jour une macro créée par Questify (texte du site et de la langue actuels) -> true ou false, raison.
function Macros:Update(m)
  local rec = self:Store()[m.id]
  if not rec then return false, "missing" end
  local index = macroIndex(rec.name)
  if index == 0 then return self:Create(m, rec.perChar) end
  local ok, why = self:CanWrite(m, rec.perChar, true)
  if not ok then return false, why end
  if type(EditMacro) ~= "function" then return false, "noapi" end
  local body = self:Body(m)
  local done = pcall(EditMacro, index, rec.name, nil, body)
  if not done then return false, "failed" end
  rec.body = body
  Q:Fire("CLASS_MACROS_CHANGED")
  return true
end

---------------------------------------------------------------------------
-- Macro écrite dans une autre langue que le jeu
---------------------------------------------------------------------------
-- Nom actuel d'un marqueur (« s123 », « i45 », « r ») dans la langue du client.
local function currentName(key)
  if key == "r" then return Macros:RankWord() end
  local names = Q.ClassMacroData and Q.ClassMacroData.names or {}
  local kind, id = key:sub(1, 1), tonumber(key:sub(2))
  return (kind == "s" and spellName(id) or itemName(id)) or names[key] or ("#" .. id)
end

-- Noms que portait le texte enregistré à la création, retrouvés en le comparant au modèle du site :
-- -> { { old, new } } pour ceux qui diffèrent des noms du client, du plus long au plus court ; nil si le
-- texte ne suit plus le modèle (le site a changé la macro).
local function renames(m, body)
  if type(body) ~= "string" then return nil end
  local keys = {}
  local pat = m.code:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")
  pat = pat:gsub("{([sir])(%d*)}", function(kind, id)
    keys[#keys + 1] = kind .. id
    return "(.-)"
  end)
  if #keys == 0 or #keys > 32 then return nil end
  local ok, caps = pcall(function() return { body:match("^" .. pat .. "$") } end)
  if not ok or #caps ~= #keys then return nil end
  local out, seen = {}, {}
  for i, key in ipairs(keys) do
    local old, new = caps[i], currentName(key)
    if old ~= "" and old ~= new and not seen[old] then
      seen[old] = true
      out[#out + 1] = { old, new }
    end
  end
  table.sort(out, function(a, b) return #a[1] > #b[1] end)
  return out
end

-- La macro du jeu a-t-elle été créée dans une autre langue que celle du client ?
function Macros:Foreign(m)
  local rec = self:Store()[m.id]
  if not rec or macroIndex(rec.name) == 0 then return false end
  local list = renames(m, rec.body)
  return list ~= nil and #list > 0
end

-- Traduit la macro du jeu telle qu'elle est (retouches à la main gardées) : chaque nom de sort ou d'objet
-- de l'ancienne langue est remplacé par celui du client, et le nom de la macro suit s'il est libre.
-- -> true ou false, raison ("missing", "combat", "long", "noapi", "failed").
function Macros:Translate(m)
  local rec = self:Store()[m.id]
  if not rec then return false, "missing" end
  local index = macroIndex(rec.name)
  if index == 0 then return false, "missing" end
  if inCombat() then return false, "combat" end
  if type(EditMacro) ~= "function" then return false, "noapi" end
  local body = macroBody(index) or ""
  for _, pair in ipairs(renames(m, rec.body) or {}) do
    local old = pair[1]:gsub("%p", "%%%0")
    local new = pair[2]:gsub("%%", "%%%%")
    body = body:gsub(old, new)
  end
  if #body > MAX_BODY then return false, "long" end
  local name = rec.name
  local want = self:DefaultName(m)
  if want ~= name and macroIndex(want) == 0 then name = want end
  local done = pcall(EditMacro, index, name, nil, body)
  if not done then return false, "failed" end
  rec.name, rec.body = name, self:Body(m)
  Q:Fire("CLASS_MACROS_CHANGED")
  return true
end

-- Ouvre la fenêtre des macros du jeu (hors combat).
function Macros:OpenMacroFrame()
  if inCombat() then return end
  if type(ShowMacroFrame) == "function" then pcall(ShowMacroFrame) end
end

Q:RegisterEvent("UPDATE_MACROS", function() Q:Fire("CLASS_MACROS_CHANGED") end)
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function() Q:Fire("CLASS_MACROS_CHANGED") end)
Q:RegisterEvent("PLAYER_REGEN_DISABLED", function() Q:Fire("CLASS_MACROS_CHANGED") end)
