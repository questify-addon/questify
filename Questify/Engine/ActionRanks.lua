local addonName, Q = ...

-- Anciens rangs sur les barres d'action.
-- Dans ce client, un bouton garde le rang exact qu'on y a posé : après l'achat d'un rang plus haut chez
-- le maître, les barres lancent toujours l'ancien. Après chaque achat (SPELLS_CHANGED, regroupés sur une
-- seconde), on relève les emplacements d'action 1 à SLOTS (barre principale et ses pages, barres de
-- formes et de postures, barres latérales, et les addons de barres qui utilisent ces emplacements) :
-- un emplacement qui porte un sort dont un rang plus haut (même nom, « Rang N » plus grand) est dans le
-- grimoire est listé. Macros, objets, sorts sans rang : jamais touchés.
-- L'assistant (UI/RanksWizard.lua) les propose un sort à la fois : Modifier ou Ignorer ce sort,
-- Appliquer tous ou Ignorer tous (les sorts restants). Un sort traité sort de l'assistant.
-- Ignorer garde ce rang : la paire (ancien rang -> meilleur rang) est retenue par personnage
-- (Q.char.actionRanks.ignored) et n'est plus proposée ; un rang encore plus haut appris plus tard l'est.
-- Combat : PlaceAction est interdit en combat ; un choix fait en combat attend la fin du combat
-- (PLAYER_REGEN_ENABLED), chaque emplacement est relu avant d'être changé.
-- Inspiré de QoL/Spells.lua de Polestar (github.com/fitzforge/polestar, GPL-3.0).
-- Client : GetActionInfo, HasAction / C_ActionBar.HasAction, C_Spell.PickupSpell / PickupSpell,
-- PlaceAction, ClearCursor, GetCursorInfo, C_Spell.GetSpellSubtext, C_Spell.GetSpellName,
-- C_SpellBook (ou GetNumSpellTabs / GetSpellTabInfo / GetSpellBookItemInfo).
local Ranks = {}
Q.ActionRanks = Ranks

Ranks.SLOTS = 180       -- emplacements d'action relus
Ranks.SETTLE = 1        -- secondes après le dernier changement du grimoire
Ranks.LOGIN_DELAY = 5   -- secondes après la connexion avant de suivre le grimoire
Ranks.SLOTS_PER_BAR = 12

local function setting(path) return Q.Settings:Get(path) end

local function state()
  if not Q.char then return nil end
  local t = Q.char.actionRanks
  if type(t) ~= "table" then
    t = {}
    Q.char.actionRanks = t
  end
  if type(t.ignored) ~= "table" then t.ignored = {} end
  return t
end

local function clean(v)
  if Q.Util.IsSecret(v) then return nil end
  return v
end

---------------------------------------------------------------------------
-- Sorts
---------------------------------------------------------------------------
local function spellName(id)
  if not (C_Spell and C_Spell.GetSpellName) then return nil end
  local ok, name = pcall(C_Spell.GetSpellName, id)
  name = ok and clean(name) or nil
  return type(name) == "string" and name ~= "" and name or nil
end

-- « Rang 3 » (dans toutes les langues : son nombre) -> 3 ; nil sans rang.
function Ranks.RankOf(id)
  local fn = (C_Spell and C_Spell.GetSpellSubtext) or GetSpellSubtext
  if type(fn) ~= "function" then return nil end
  local ok, text = pcall(fn, id)
  text = ok and clean(text) or nil
  if type(text) ~= "string" then return nil end
  return tonumber(text:match("(%d+)"))
end

function Ranks.Icon(id)
  if not (C_Spell and C_Spell.GetSpellTexture) then return nil end
  local ok, tex = pcall(C_Spell.GetSpellTexture, id)
  return ok and clean(tex) or nil
end

function Ranks.Link(id)
  if C_Spell and C_Spell.GetSpellLink then
    local ok, link = pcall(C_Spell.GetSpellLink, id)
    link = ok and clean(link) or nil
    if type(link) == "string" and link ~= "" then return link end
  end
  return spellName(id) or ("#" .. tostring(id))
end

-- Chaque sort du grimoire du joueur (pas celui du familier) : fn(spellID).
local function eachBookSpell(fn)
  local SB = C_SpellBook
  if SB and SB.GetNumSpellBookSkillLines and SB.GetSpellBookSkillLineInfo and SB.GetSpellBookItemInfo then
    local bank = Enum and Enum.SpellBookSpellBank and Enum.SpellBookSpellBank.Player or 0
    local spellType = Enum and Enum.SpellBookItemType and Enum.SpellBookItemType.Spell or 1
    for i = 1, SB.GetNumSpellBookSkillLines() or 0 do
      local line = SB.GetSpellBookSkillLineInfo(i)
      if type(line) == "table" then
        local off = line.itemIndexOffset or 0
        for k = off + 1, off + (line.numSpellBookItems or 0) do
          local info = SB.GetSpellBookItemInfo(k, bank)
          if type(info) == "table" and info.spellID and info.itemType == spellType and not info.isPassive then
            fn(info.spellID)
          end
        end
      end
    end
  elseif type(GetNumSpellTabs) == "function" and type(GetSpellTabInfo) == "function"
      and type(GetSpellBookItemInfo) == "function" then
    for i = 1, GetNumSpellTabs() or 0 do
      local _, _, off, n = GetSpellTabInfo(i)
      for k = (off or 0) + 1, (off or 0) + (n or 0) do
        local kind, id = GetSpellBookItemInfo(k, "spell")
        if kind == "SPELL" and id then fn(id) end
      end
    end
  end
end

-- nom -> { rank, id } du rang le plus haut dans le grimoire.
function Ranks.BookBest()
  local best = {}
  eachBookSpell(function(id)
    local name, rank = spellName(id), Ranks.RankOf(id)
    if name and rank then
      local b = best[name]
      if not b or rank > b.rank then best[name] = { rank = rank, id = id } end
    end
  end)
  return best
end

---------------------------------------------------------------------------
-- Emplacements d'action
---------------------------------------------------------------------------
local function hasAction(slot)
  local fn = (C_ActionBar and C_ActionBar.HasAction) or HasAction
  if type(fn) ~= "function" then return false end
  local ok, v = pcall(fn, slot)
  return ok and clean(v) and true or false
end

-- Sort de l'emplacement slot, nil pour tout le reste (macro, objet, vide).
local function slotSpell(slot)
  if type(GetActionInfo) ~= "function" or not hasAction(slot) then return nil end
  local ok, kind, id = pcall(GetActionInfo, slot)
  if not ok then return nil end
  kind, id = clean(kind), clean(id)
  if kind == "spell" and type(id) == "number" then return id end
  return nil
end
Ranks.SlotSpell = slotSpell

-- Emplacement -> barre et bouton : { bar, button } (barres de 12 boutons, dans l'ordre du jeu).
function Ranks.SlotPlace(slot)
  local n = Ranks.SLOTS_PER_BAR
  return math.floor((slot - 1) / n) + 1, (slot - 1) % n + 1
end

local function isIgnored(e)
  local t = state()
  return t and t.ignored[e.id] == e.bestId
end

-- Scan() -> liste des anciens rangs : { { id, bestId, name, have, best, icon, slots = { slot… } } },
-- dans l'ordre du premier emplacement ; nombre d'emplacements. Les paires ignorées n'y sont pas.
function Ranks:Scan()
  local book = Ranks.BookBest()
  local byId, list, n = {}, {}, 0
  for slot = 1, Ranks.SLOTS do
    local id = slotSpell(slot)
    if id then
      local e = byId[id]
      if e == nil then
        e = false
        local name, have = spellName(id), Ranks.RankOf(id)
        local b = name and book[name]
        if have and b and b.rank > have and b.id ~= id then
          e = { id = id, bestId = b.id, name = name, have = have, best = b.rank, icon = Ranks.Icon(id), slots = {} }
          if isIgnored(e) then e = false end
        end
        byId[id] = e
        if e then list[#list + 1] = e end
      end
      if e then
        e.slots[#e.slots + 1] = slot
        n = n + 1
      end
    end
  end
  return list, n
end

---------------------------------------------------------------------------
-- Assistant : sorts restant à décider
---------------------------------------------------------------------------
Ranks.pending = {}   -- entrées de Scan() pas encore décidées
local queued = {}    -- entrées à appliquer à la fin du combat
local told           -- clé de la dernière liste proposée (pas deux fois la même)

local function key(list)
  local parts = {}
  for _, e in ipairs(list) do parts[#parts + 1] = e.id .. ">" .. e.bestId .. "@" .. table.concat(e.slots, ".") end
  return table.concat(parts, ",")
end

-- Pending() -> entrées restant à décider (la table de l'assistant).
function Ranks:Pending() return self.pending end

-- Après un choix, la liste restante compte comme proposée : un SPELLS_CHANGED quelconque ne rouvre pas
-- l'assistant fermé par sa croix.
local function setPending(list)
  Ranks.pending = list
  told = #list > 0 and key(list) or nil
end

local function removePending(ids)
  local keep = {}
  for _, e in ipairs(Ranks.pending) do
    if not ids[e.id] then keep[#keep + 1] = e end
  end
  setPending(keep)
end

local function inCombat()
  return type(InCombatLockdown) == "function" and InCombatLockdown() and true or false
end

function Ranks:InCombat() return inCombat() end

-- Check(force) : relève les barres ; s'il y a des anciens rangs pas encore proposés, l'assistant les
-- propose (message RANKS_PENDING). -> true si l'assistant a de quoi s'ouvrir.
function Ranks:Check(force)
  if setting("oldRanks") == false and not force then return false end
  local list = self:Scan()
  self.pending = list
  if #list == 0 then
    told = nil
    Q:Fire("RANKS_PENDING", list)
    return false
  end
  local k = key(list)
  if k == told and not force then return false end
  told = k
  Q:Fire("RANKS_PENDING", list)
  return true
end

---------------------------------------------------------------------------
-- Application
---------------------------------------------------------------------------
local function cursorFree()
  if type(GetCursorInfo) ~= "function" then return true end
  local ok, kind = pcall(GetCursorInfo)
  return ok and not clean(kind)
end

local function pickup(id)
  local fn = (C_Spell and C_Spell.PickupSpell) or PickupSpell
  if type(fn) == "function" then fn(id) end
end

local function slotsText(slots)
  local parts = {}
  for _, slot in ipairs(slots) do
    local bar, button = Ranks.SlotPlace(slot)
    parts[#parts + 1] = string.format(Q.L.RANKS_SLOT, bar, button)
  end
  return table.concat(parts, ", ")
end
Ranks.SlotsText = slotsText

-- Pose le meilleur rang dans les emplacements des entrées ; chaque emplacement est relu (il doit
-- toujours porter l'ancien rang). -> { { entry, slots = { emplacements changés } } }, total ; nil si le
-- curseur est occupé.
local function placeNow(entries)
  if type(PlaceAction) ~= "function" then return {}, 0 end
  if not cursorFree() then return nil end
  local done, total = {}, 0
  for _, e in ipairs(entries) do
    local changed = {}
    for _, slot in ipairs(e.slots) do
      if slotSpell(slot) == e.id then
        pickup(e.bestId)
        PlaceAction(slot)
        if type(ClearCursor) == "function" then ClearCursor() end   -- l'ancien rang revient sur le curseur
        if slotSpell(slot) == e.bestId then changed[#changed + 1] = slot end
      end
    end
    if #changed > 0 then
      done[#done + 1] = { entry = e, slots = changed }
      total = total + #changed
    end
  end
  return done, total
end

-- Message de la discussion : nombre de boutons, puis une ligne par sort.
local function report(done, total)
  if total == 0 then
    Q:Print(Q.L.RANKS_NOTHING)
    return
  end
  Q:Print(total == 1 and Q.L.RANKS_DONE_ONE or Q.L.RANKS_DONE, total)
  for _, d in ipairs(done) do
    local e = d.entry
    Q:Print(Q.L.RANKS_DONE_LINE, Ranks.Link(e.bestId), e.have, e.best, slotsText(d.slots))
  end
end

local function apply(entries)
  if #entries == 0 then return 0 end
  if inCombat() then
    for _, e in ipairs(entries) do queued[#queued + 1] = e end
    Q:Print(Q.L.RANKS_COMBAT)
    Q:Fire("RANKS_QUEUED", #queued)
    return nil
  end
  local done, total = placeNow(entries)
  if not done then
    Q:Print(Q.L.RANKS_CURSOR)
    return false
  end
  report(done, total)
  return total
end

local function ignore(entries)
  local t = state()
  if not t then return end
  local names = {}
  for _, e in ipairs(entries) do
    t.ignored[e.id] = e.bestId
    names[#names + 1] = string.format(Q.L.RANKS_KEPT_ITEM, Ranks.Link(e.id), e.have)
  end
  if #names > 0 then Q:Print(Q.L.RANKS_KEPT, table.concat(names, ", ")) end
end

local function find(id)
  for _, e in ipairs(Ranks.pending) do
    if e.id == id then return e end
  end
  return nil
end

-- Modifier ce sort. -> boutons changés, nil s'il attend la fin du combat, false si le curseur est
-- occupé (le sort reste alors dans l'assistant).
function Ranks:Apply(id)
  local e = find(id)
  if not e then return 0 end
  local res = apply({ e })
  if res ~= false then removePending({ [id] = true }) end
  Q:Fire("RANKS_PENDING", self.pending)
  return res
end

function Ranks:Ignore(id)
  local e = find(id)
  if not e then return end
  ignore({ e })
  removePending({ [id] = true })
  Q:Fire("RANKS_PENDING", self.pending)
end

-- Appliquer tous / Ignorer tous : seulement les sorts restants.
function Ranks:ApplyAll()
  local list = self.pending
  local res = apply(list)
  if res ~= false then setPending({}) end
  Q:Fire("RANKS_PENDING", self.pending)
  return res
end

function Ranks:IgnoreAll()
  ignore(self.pending)
  setPending({})
  Q:Fire("RANKS_PENDING", self.pending)
end

function Ranks:Queued() return #queued end

-- Oublie les rangs ignorés : ils seront proposés de nouveau.
function Ranks:ForgetIgnored()
  local t = state()
  if t then t.ignored = {} end
end

---------------------------------------------------------------------------
-- Évènements
---------------------------------------------------------------------------
Q:RegisterEvent("PLAYER_REGEN_ENABLED", function()
  if #queued == 0 then return end
  local list = queued
  queued = {}
  Q:After(0.5, function()
    if inCombat() then
      for _, e in ipairs(list) do queued[#queued + 1] = e end
      return
    end
    local done, total = placeNow(list)
    if not done then
      Q:Print(Q.L.RANKS_CURSOR)
      for _, e in ipairs(list) do Ranks.pending[#Ranks.pending + 1] = e end
      Q:Fire("RANKS_PENDING", Ranks.pending)
      return
    end
    report(done, total)
    Q:Fire("RANKS_QUEUED", 0)
  end)
end)

-- Le grimoire change par rafales chez le maître : une relecture une seconde après le dernier changement.
local ready = false
local changes = 0
local function spellbookChanged()
  if not ready then return end
  changes = changes + 1
  local this = changes
  Q:After(Ranks.SETTLE, function()
    if this == changes and not inCombat() then Ranks:Check() end
  end)
end
Q:RegisterEvent("SPELLS_CHANGED", spellbookChanged)
Q:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE", spellbookChanged)

-- À la connexion, la liste présente est notée sans être proposée : l'assistant n'arrive qu'après un achat
-- (ou /qf ranks).
Q:On("LOGIN", function()
  Q:After(Ranks.LOGIN_DELAY, function()
    local list = Ranks:Scan()
    told = #list > 0 and key(list) or nil
    ready = true
  end)
end)
