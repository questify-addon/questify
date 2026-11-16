local addonName, Q = ...

-- Talents du personnage : points à dépenser et signal TALENTS_CHANGED. Forever (famille Mainline 12.x)
-- expose les talents par C_ClassTalents et C_Traits (Blizzard_PlayerSpells/Camelot/ClassTalents) : un
-- arbre de classe dont les trois « arbres » classiques sont des groupes de nœuds ; GetTalentInfo et
-- UnitCharacterPoints n'y existent pas (gardés en secours pour un autre client). La lecture de l'arbre
-- est dans Engine/TalentTree.lua, le guide de talents dans Engine/ClassGuide.lua.
local Talents = {}
Q.Talents = Talents

Talents.FIRST_LEVEL = 10

local function call(fn, ...)
  if type(fn) ~= "function" then return nil end
  local ok, a = pcall(fn, ...)
  if not ok then return nil end
  return a
end

local function plain(v)
  if Q.Util.IsSecret(v) then return nil end
  local k = type(v)
  if k == "number" or k == "string" or k == "boolean" then return v end
  return nil
end

local function readable(v) return type(v) == "table" and not Q.Util.IsSecret(v) end

-- Points à dépenser selon la monnaie des arbres de la configuration active (Forever ; points en attente
-- déjà comptés comme dépensés, excludeStagedChanges = false) ; nil si l'API manque ou ne répond pas. Une
-- monnaie présente dans plusieurs arbres n'est comptée qu'une fois.
function Talents:TreeCurrencyUnspent()
  if type(C_ClassTalents) ~= "table" or type(C_Traits) ~= "table"
      or type(C_Traits.GetTreeCurrencyInfo) ~= "function" then return nil end
  local configID = plain(call(C_ClassTalents.GetActiveConfigID))
  if type(configID) ~= "number" then return nil end
  local info = call(C_Traits.GetConfigInfo, configID)
  if not readable(info) or not readable(info.treeIDs) then return nil end
  local byCurrency, extra, any = {}, 0, false
  for _, treeID in ipairs(info.treeIDs) do
    treeID = plain(treeID)
    local list = treeID and call(C_Traits.GetTreeCurrencyInfo, configID, treeID, false)
    if readable(list) then
      for _, c in ipairs(list) do
        local q = readable(c) and plain(c.quantity)
        if type(q) == "number" then
          any = true
          local id = plain(c.traitCurrencyID)
          if id then byCurrency[id] = math.max(byCurrency[id] or 0, q) else extra = extra + q end
        end
      end
    end
  end
  if not any then return nil end
  local total = extra
  for _, q in pairs(byCurrency) do total = total + q end
  return math.max(0, total)
end

-- Points à dépenser : la monnaie des arbres (Forever), sinon l'ancienne API ; 0 si rien ne répond.
function Talents:Unspent()
  if (Q.Player and Q.Player.level or 1) < self.FIRST_LEVEL then return 0 end
  local v = self:TreeCurrencyUnspent()
  if type(v) == "number" then return v end
  v = plain(call(UnitCharacterPoints, "player"))
  if type(v) == "number" then return math.max(0, v) end
  v = plain(call(GetUnspentTalentPoints))
  if type(v) == "number" then return math.max(0, v) end
  return 0
end

-- TALENTS_CHANGED : points gagnés ou dépensés (TRAIT_* pour les arbres C_Traits de Forever).
for _, event in ipairs({ "CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE", "TRAIT_TREE_CURRENCY_INFO_UPDATED",
    "TRAIT_CONFIG_UPDATED", "TRAIT_NODE_CHANGED" }) do
  Q:RegisterEvent(event, function() Q:Fire("TALENTS_CHANGED") end)
end
