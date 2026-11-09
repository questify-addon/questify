local addonName, Q = ...

-- Offre de quête à sac : quand le joueur passe près du donneur d'une quête qui donne un sac (Engine/BagQuests.lua),
-- encore « disponible » et dont le sac est plus grand que le plus petit sac porté (ou qu'un emplacement de sac est
-- vide), une étape « bagquest » s'insère avant la route, comme l'offre de quête de classe
-- (Engine/ClassQuestOffer.lua). Un clic sur la ligne du suivi ouvre la fenêtre de la quête (« Ajouter à la route »
-- / « Ignorer ») ; ajoutée ou ignorée, l'offre disparaît. Passée (clic droit, /qf skip), elle reste passée jusqu'à
-- ce que le joueur s'éloigne.
-- Hystérésis : l'offre s'insère à OFFER_NEAR yards du donneur ou moins, et ne part qu'au-delà de OFFER_FAR yards,
-- au changement de zone si le joueur est alors à plus de OFFER_NEAR, ou quand le sac ne sert plus (sac acheté ou
-- ramassé entre-temps). Rien en combat, rien dans une grotte, au plus MAX_OFFERS offre à la fois (le plus grand
-- sac d'abord). Aucune étape « bagquest » n'est écrite dans les guides : elles n'existent qu'à l'exécution.
local Offer = {}
Q.BagQuestOffer = Offer

local TAG_PREFIX = "bqo:"
local CHECK_INTERVAL = 5
local OFFER_NEAR = 250
local OFFER_FAR = 600
local MAX_OFFERS = 1

local function char() return Q.char end

local function enabled()
  return Q.Settings and Q.Settings:Get("bagQuestOffer") ~= false
end

function Offer:Title(key)
  local BQ = Q.BagQuests
  local entry = BQ and BQ:Find(key)
  if not entry then return tostring(key) end
  return BQ:Title(entry)
end

local function offered()
  local out = {}
  local c = char()
  for _, group in ipairs(c and c.inserted or {}) do
    if type(group) == "table" and type(group.tag) == "string" and group.tag:sub(1, #TAG_PREFIX) == TAG_PREFIX then
      out[group.tag:sub(#TAG_PREFIX + 1)] = true
    end
  end
  return out
end

function Offer:Has(key)
  local c = char()
  for _, group in ipairs(c and c.inserted or {}) do
    if type(group) == "table" and group.tag == TAG_PREFIX .. tostring(key) then return true end
  end
  return false
end

function Offer:Remove(key)
  if self:Has(key) then Q.Progress:RemoveInserted(TAG_PREFIX .. key) end
end

local function inCave()
  local C = Q.Caves
  return C ~= nil and type(C.PlayerCave) == "function" and C:PlayerCave() ~= nil
end

-- Distance (yards) au donneur de la première quête restante, ou nil si inconnue.
local function giverDistance(entry)
  local BQ, CQ = Q.BagQuests, Q.ClassQuests
  local ok, s = pcall(function() return CQ:Starter(BQ:FirstQuest(entry)) end)
  if ok and s and type(s.dist) == "number" then return s.dist end
  return nil
end

local zoneChanged = false

function Offer:Check()
  local zone = zoneChanged
  zoneChanged = false
  if not (Q.Progress and Q.Progress:IsEnabled() and Q.BagQuests and Q.ClassQuests and char()) then return end
  local have = offered()
  if not enabled() then
    for key in pairs(have) do self:Remove(key) end
    return
  end
  local rows = {}
  for i, row in ipairs(Q.BagQuests:List()) do
    if row.state == "available" then
      local useful, slots = Q.BagQuests:Useful(row.entry)
      if useful then
        rows[#rows + 1] = { entry = row.entry, index = i, slots = slots or 0, dist = giverDistance(row.entry) }
      end
    end
  end
  local byKey = {}
  for _, r in ipairs(rows) do byKey[r.entry.key] = r end
  local kept = 0
  for key in pairs(have) do
    local r = byKey[key]
    if not r or not r.dist or r.dist > OFFER_FAR or (zone and r.dist > OFFER_NEAR) then
      self:Remove(key)
    else
      kept = kept + 1
    end
  end
  if kept >= MAX_OFFERS or inCave() then return end
  local cands = {}
  for _, r in ipairs(rows) do
    if not have[r.entry.key] and r.dist and r.dist <= OFFER_NEAR and not self:Has(r.entry.key) then
      cands[#cands + 1] = r
    end
  end
  -- le plus grand sac d'abord, puis le donneur le plus proche, puis l'ordre des données
  table.sort(cands, function(a, b)
    if a.slots ~= b.slots then return a.slots > b.slots end
    if a.dist ~= b.dist then return a.dist < b.dist end
    return a.index < b.index
  end)
  for _, r in ipairs(cands) do
    if kept >= MAX_OFFERS then break end
    Q.Progress:InsertSteps(TAG_PREFIX .. r.entry.key, { { "bagquest", key = r.entry.key } })
    kept = kept + 1
  end
end

local function check()
  if InCombatLockdown and InCombatLockdown() then return end
  Q.SafeCall(Offer.Check, Offer)
end

Q:On("LOGIN", function()
  Q:NewTicker(CHECK_INTERVAL, check)
end)
for _, event in ipairs({ "ZONE_CHANGED_NEW_AREA", "PLAYER_LEVEL_UP", "BAG_UPDATE_DELAYED" }) do
  Q:RegisterEvent(event, function(ev)
    if ev == "ZONE_CHANGED_NEW_AREA" then zoneChanged = true end
    check()
  end)
end
Q:On("SETTINGS_CHANGED", function(path)
  if path == "bagQuestOffer" then check() end
end)
