local addonName, Q = ...

-- Guide de talents de la classe du joueur (onglet Options › Classe › Talents, UI/ClassPanel.lua ;
-- encart au passage de niveau, UI/TalentAdvice.lua ; bouton Classe du suivi).
-- Données : Q.ClassGuideData (Data/ClassGuides.lua, généré par tools/classguides/build.py depuis
-- classicwowforever.com, CC BY 4.0), textes traduits dans Q.ClassGuideText (Data/ClassText_<locale>.lua).
-- Un guide = une spécialisation : arbre (nœuds : sort de rang 1, palier, colonne, rangs), un sort par
-- niveau de 10 à 60 (steps) et des étapes commentées (stages : niveaux, talent, rang visé, explication).
-- Les talents sont désignés par le sort de rang 1 : le nom vient du jeu, donc de la langue du client.
-- Rien n'est appris à la place du joueur : Questify montre le point suivant et l'écart au guide.
-- Spécialisation suivie : le choix du personnage (Q.char.classGuide.spec), sinon l'arbre où il a le
-- plus de points (Auto), sinon la première.
local Guide = {}
Q.ClassGuide = Guide

local FIRST, LAST = 10, 60

local function classFile()
  local cf = Q.Player and Q.Player.classFile
  if not cf and UnitClass then cf = select(2, UnitClass("player")) end
  return cf
end

local function level() return (Q.Player and Q.Player.level) or (UnitLevel and UnitLevel("player")) or 1 end

-- État du personnage (créé au besoin : hors des profils d'options).
function Guide:CharState()
  local c = Q.char
  if type(c) ~= "table" then return {} end
  if type(c.classGuide) ~= "table" then c.classGuide = {} end
  return c.classGuide
end

-- Guides de la classe (ou de la classe donnée) : liste des trois spécialisations, dans l'ordre du jeu.
function Guide:Specs(cf)
  local data = Q.ClassGuideData
  return data and data[cf or classFile() or ""] or nil
end

function Guide:SpecByKey(key, cf)
  for _, s in ipairs(self:Specs(cf) or {}) do
    if s.key == key then return s end
  end
  return nil
end

-- Textes dans la langue du client (Q.ClassGuideText), sinon anglais.
local function localText(cf, key)
  local T = Q.ClassGuideText
  local c = T and T[cf or classFile() or ""]
  return c and c.guides and c.guides[key] or nil
end

function Guide:SpecName(spec, tree)
  if tree and tree.groups and tree.groups[spec.group] and tree.groups[spec.group].name ~= "?" then
    return tree.groups[spec.group].name
  end
  local t = localText(nil, spec.key)
  return (t and t.name) or spec.name
end

function Guide:Tagline(spec)
  local t = localText(nil, spec.key)
  return (t and t.tagline) or spec.tagline
end

-- Explication de l'étape n° i du guide (stage), traduite si possible.
function Guide:Why(spec, i)
  local t = localText(nil, spec.key)
  local w = t and t.why and t.why[i]
  if w and w ~= "" then return w end
  local st = spec.stages[i]
  return st and st.why or ""
end

-- Nom d'un talent (sort de rang 1) dans la langue du client.
function Guide:TalentName(spellID, spec)
  local n
  if type(C_Spell) == "table" and type(C_Spell.GetSpellName) == "function" then
    local ok, v = pcall(C_Spell.GetSpellName, spellID)
    if ok and type(v) == "string" and not Q.Util.IsSecret(v) then n = v end
  end
  if not n and type(GetSpellInfo) == "function" then
    local ok, v = pcall(GetSpellInfo, spellID)
    if ok and type(v) == "string" then n = v end
  end
  if n then return n end
  for _, s in ipairs(self:Specs() or {}) do
    for _, node in ipairs(s.nodes) do
      if node.spell == spellID then return node.name end
    end
  end
  return "#" .. tostring(spellID)
end

-- Nœud (données) d'un sort de talent, parmi les trois arbres -> node, spec.
function Guide:Node(spellID, cf)
  for _, s in ipairs(self:Specs(cf) or {}) do
    for _, node in ipairs(s.nodes) do
      if node.spell == spellID then return node, s end
    end
  end
  return nil
end

---------------------------------------------------------------------------
-- Talents du personnage
---------------------------------------------------------------------------
-- Arbre lu dans le jeu (Engine/TalentTree.lua), gardé jusqu'au prochain TALENTS_CHANGED.
function Guide:Tree()
  if self.cache == nil then
    local TT = Q.TalentTree
    local ok, tree = false, nil
    if TT and TT.Read then ok, tree = pcall(TT.Read, TT) end
    self.cache = (ok and tree) or false
  end
  return self.cache or nil
end

function Guide:Invalidate() self.cache = nil end

local function gameSpellName(id)
  if type(C_Spell) == "table" and type(C_Spell.GetSpellName) == "function" then
    local ok, v = pcall(C_Spell.GetSpellName, id)
    if ok and type(v) == "string" and not Q.Util.IsSecret(v) then return v end
  end
  return nil
end

-- Nœud du jeu de chaque talent du guide -> { [spellID du guide] = nœud du jeu }. Le sort de rang 1 relevé
-- hors ligne (table Talent, sinon nom) peut différer de celui de l'arbre C_Traits pour un talent propre à
-- Forever : même sort, sinon même nom dans le même arbre (nom donné par le jeu), sinon même palier et
-- même colonne dans le même arbre.
function Guide:Match(tree)
  if not tree then return {} end
  if tree.qvMatch then return tree.qvMatch end
  local out, byName, byPos = {}, {}, {}
  for spellID, n in pairs(tree.nodes) do
    local name = gameSpellName(spellID)
    if name and n.group then byName[n.group .. ":" .. name] = n end
    if n.group and n.tier and n.col then byPos[n.group .. ":" .. n.tier .. ":" .. n.col] = n end
  end
  for _, s in ipairs(self:Specs() or {}) do
    for _, node in ipairs(s.nodes) do
      local name = gameSpellName(node.spell)
      out[node.spell] = tree.nodes[node.spell] or (name and byName[s.group .. ":" .. name])
        or byPos[s.group .. ":" .. (node.row + 1) .. ":" .. (node.col + 1)]
    end
  end
  tree.qvMatch = out
  return out
end

-- Rangs du personnage : { [spellID du guide] = rang } et points par arbre { [1..3] = n }. Sans arbre
-- lisible : tables vides.
function Guide:Ranks(tree)
  if type(tree) ~= "table" then tree = self:Tree() end
  local ranks, spent = {}, { 0, 0, 0 }
  if tree then
    for spellID, n in pairs(self:Match(tree)) do
      if (n.rank or 0) > 0 then ranks[spellID] = n.rank end
    end
    for _, n in pairs(tree.nodes) do
      if (n.rank or 0) > 0 and n.group and spent[n.group] then spent[n.group] = spent[n.group] + n.rank end
    end
  end
  return ranks, spent
end

-- Arbre où le personnage a le plus de points -> clé de la spécialisation, ou nil (aucun point, égalité).
function Guide:AutoSpec(tree)
  local _, spent = self:Ranks(tree)
  local best, bestN, tie = nil, 0, false
  for g = 1, 3 do
    if spent[g] > bestN then best, bestN, tie = g, spent[g], false
    elseif spent[g] == bestN and bestN > 0 then tie = true end
  end
  if not best or tie then return nil end
  for _, s in ipairs(self:Specs() or {}) do
    if s.group == best then return s.key end
  end
  return nil
end

-- Spécialisation suivie -> spec (données), "choice" | "auto" | "default".
function Guide:Current(tree)
  local specs = self:Specs()
  if not specs or #specs == 0 then return nil end
  local chosen = self:CharState().spec
  local s = chosen and self:SpecByKey(chosen)
  if s then return s, "choice" end
  s = self:SpecByKey(self:AutoSpec(tree) or "")
  if s then return s, "auto" end
  return specs[1], "default"
end

function Guide:Choose(key)
  self:CharState().spec = key
  Q:Fire("CLASS_GUIDE_CHANGED")
end

---------------------------------------------------------------------------
-- Plan
---------------------------------------------------------------------------
-- Points du guide : { { level, spell, rank } } du niveau 10 au niveau 60.
function Guide:Plan(spec)
  if spec.plan then return spec.plan end
  local out, count = {}, {}
  for i, spellID in ipairs(spec.steps) do
    count[spellID] = (count[spellID] or 0) + 1
    out[i] = { level = FIRST + i - 1, spell = spellID, rank = count[spellID] }
  end
  spec.plan = out
  return out
end

-- Rangs visés par le guide au niveau donné (60 par défaut) : { [spellID] = rang }.
function Guide:PlannedRanks(spec, atLevel)
  local out = {}
  for _, p in ipairs(self:Plan(spec)) do
    if p.level <= (atLevel or LAST) then out[p.spell] = p.rank end
  end
  return out
end

-- Étape commentée qui couvre un point (même talent, niveau dans [level, to]) -> stage, index.
function Guide:StageFor(spec, point)
  local fallback, fi
  for i, st in ipairs(spec.stages) do
    if st.spell == point.spell then
      if point.level >= st.level and point.level <= st.to then return st, i end
      if not fallback or math.abs(st.level - point.level) < math.abs(fallback.level - point.level) then
        fallback, fi = st, i
      end
    end
  end
  return fallback, fi
end

-- État du guide pour le personnage :
--   { spec, unspent, next = point | nil, due = bool (point à dépenser maintenant), upcoming = { groupe },
--     extra = { { spell, rank, planned } } (rangs au-delà du guide), ranks, planned }
--   groupe d'« à venir » : { from, to, spell, rank } (rangs consécutifs d'un même talent réunis).
-- Le point suivant est le premier point du guide que le personnage n'a pas encore (même si ses talents
-- ne suivent pas l'ordre du guide) ; « due » : il a au moins un point à dépenser.
function Guide:State(spec, tree, opts)
  opts = opts or {}
  if type(tree) ~= "table" then tree = self:Tree() end
  local ranks = self:Ranks(tree)
  local unspent = opts.unspent
  if unspent == nil then unspent = Q.Talents and Q.Talents:Unspent() or 0 end
  local plan = self:Plan(spec)
  local st = { spec = spec, unspent = unspent, ranks = ranks, planned = self:PlannedRanks(spec), upcoming = {},
    extra = {} }
  local nextIndex
  for i, p in ipairs(plan) do
    if (ranks[p.spell] or 0) < p.rank then nextIndex = i; break end
  end
  if nextIndex then
    st.next = plan[nextIndex]
    st.due = unspent > 0 and level() >= FIRST
    local limit = opts.upcoming or 5
    local i = nextIndex + 1
    while i <= #plan and #st.upcoming < limit do
      local p = plan[i]
      if (ranks[p.spell] or 0) < p.rank then
        local last = st.upcoming[#st.upcoming]
        if last and last.spell == p.spell and last.to == p.level - 1 then
          last.to, last.rank = p.level, p.rank
        else
          st.upcoming[#st.upcoming + 1] = { from = p.level, to = p.level, spell = p.spell, rank = p.rank }
        end
      end
      i = i + 1
    end
  end
  for spellID, r in pairs(ranks) do
    local planned = st.planned[spellID] or 0
    if r > planned then st.extra[#st.extra + 1] = { spell = spellID, rank = r, planned = planned } end
  end
  table.sort(st.extra, function(a, b) return a.spell < b.spell end)
  return st
end

-- État de chaque nœud d'un arbre pour le dessin : "done" (rang posé, dans le guide), "extra" (au-delà
-- du guide), "next" (point suivant), "plan" (à venir : niveau du premier point manquant), "off" (hors
-- guide, aucun rang). -> { [spellID] = { state, rank, level } }
function Guide:NodeStates(spec, st)
  local out = {}
  local plan = self:Plan(spec)
  for _, s in ipairs(self:Specs() or {}) do
    for _, node in ipairs(s.nodes) do
      local r = st.ranks[node.spell] or 0
      local planned = st.planned[node.spell] or 0
      local e = { rank = r, planned = planned }
      if st.next and st.next.spell == node.spell then
        e.state = "next"
      elseif r > planned then
        e.state = "extra"
      elseif r > 0 then
        e.state = "done"
      elseif planned > 0 then
        e.state = "plan"
      else
        e.state = "off"
      end
      if r < planned then
        for _, p in ipairs(plan) do
          if p.spell == node.spell and p.rank > r then e.level = p.level; break end
        end
      end
      out[node.spell] = e
    end
  end
  return out
end

-- Points que le guide met dans chaque arbre au niveau 60 : { [1..3] = n }.
function Guide:PlanTotals(spec)
  local out = { 0, 0, 0 }
  for _, p in ipairs(self:Plan(spec)) do
    local _, s = self:Node(p.spell)
    if s and out[s.group] then out[s.group] = out[s.group] + 1 end
  end
  return out
end

-- Conseil pour le niveau atteint (encart TalentAdvice, bouton du suivi) : point suivant dû, avec son
-- explication -> { spell, rank, level, why, spec, max } ou nil.
function Guide:Advice()
  if level() < FIRST then return nil end
  local spec = self:Current()
  if not spec then return nil end
  local st = self:State(spec)
  if not (st.next and st.due) then return nil end
  local stage, i = self:StageFor(spec, st.next)
  local node = self:Node(st.next.spell)
  return { spell = st.next.spell, rank = st.next.rank, level = st.next.level, spec = spec,
    max = node and node.max or st.next.rank, why = i and self:Why(spec, i) or "", icon = node and node.icon }
end

Q:On("TALENTS_CHANGED", function() Guide:Invalidate() end)
Q:RegisterEvent("PLAYER_LEVEL_UP", function() Guide:Invalidate() end)

-- Seule la classe du joueur est gardée en mémoire (guides, macros, textes traduits des neuf classes).
function Guide:Prune(cf)
  cf = cf or classFile()
  if not cf then return end
  for _, t in ipairs({ Q.ClassGuideData, Q.ClassMacroData, Q.ClassGuideText }) do
    if type(t) == "table" then
      for k in pairs(t) do
        if k ~= cf and k ~= "source" and k ~= "names" and type(k) == "string" and k:match("^%u+$") then t[k] = nil end
      end
    end
  end
end
Q:On("INIT", function() Guide:Prune() end)
