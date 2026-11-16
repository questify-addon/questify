local addonName, Q = ...

-- Flèche flottante (maquette validée : docs/media/apercus/src/themes/maquette.html, « Flèche
-- flottante ») : une flèche lumineuse sans cadre qui montre la direction de l'étape en cours (cible
-- du suivi, Q.UI.Tracker.target), la distance dessous et le nom de la cible en petit.
--   arrow.show : affichée (défaut vrai) ; arrow.color : couleur (Q.Themes:ArrowColor : cyan, couleur
--   du thème, or, vert, blanc, rose) ; arrow.point : position (glisser pour la déplacer).
-- Direction : coordonnées monde (Q.Maps:WorldPos : X vers le nord, Y vers l'ouest) et orientation
-- du joueur (GetPlayerFacing : 0 = nord, sens antihoraire), comme la texture (SetRotation).
-- Cachée sans cible, sur un autre continent, ou quand la position du joueur est inconnue.
Q.UI = Q.UI or {}
local Arrow = { interval = 0.05 }
Q.UI.Arrow = Arrow

local L = Q.L
local MEDIA = "Interface\\AddOns\\" .. addonName .. "\\Media\\Themes\\"
local SIZE = 64
local ARRIVED = 6   -- yards : « arrivé »

local function setting(path) return Q.Settings:Get(path) end

function Arrow:Create()
  if self.frame then return self.frame end
  local f = CreateFrame("Frame", "QuestifyArrow", UIParent)
  f:SetSize(SIZE + 40, SIZE + 34)
  f:SetFrameStrata("LOW")
  f:SetClampedToScreen(true)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self) if not InCombatLockdown or not InCombatLockdown() then self:StartMoving() end end)
  f:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, rp, x, y = self:GetPoint(1)
    Q.SafeCall(function() Q.Settings:Set("arrow.point", { p, rp, x, y }) end)
  end)
  local glow = f:CreateTexture(nil, "BACKGROUND")
  glow:SetSize(SIZE + 14, SIZE + 14)
  glow:SetPoint("TOP", f, "TOP", 0, 7)
  glow:SetTexture(MEDIA .. "arrow-glow")
  glow:SetAlpha(0.55)
  local tex = f:CreateTexture(nil, "ARTWORK")
  tex:SetSize(SIZE, SIZE)
  tex:SetPoint("TOP", f, "TOP", 0, 0)
  tex:SetTexture(MEDIA .. "arrow")
  local dist = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
  dist:SetPoint("TOP", tex, "BOTTOM", 0, -2)
  dist:SetShadowColor(0, 0, 0, 1)
  dist:SetShadowOffset(1, -1)
  local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  name:SetPoint("TOP", dist, "BOTTOM", 0, -1)
  name:SetWidth(180)
  name:SetWordWrap(false)
  name:SetShadowColor(0, 0, 0, 1)
  name:SetShadowOffset(1, -1)
  self.frame, self.texture, self.glow, self.distance, self.name = f, tex, glow, dist, name
  self:Place()
  self:ApplyColor()
  f:Hide()
  local elapsed = 0
  f:SetScript("OnUpdate", function(_, dt)
    elapsed = elapsed + (dt or 0)
    if elapsed < Arrow.interval then return end
    elapsed = 0
    Q.SafeCall(Arrow.Update, Arrow)
  end)
  return f
end

function Arrow:Place()
  local f = self.frame
  local pt = setting("arrow.point")
  f:ClearAllPoints()
  if type(pt) == "table" and pt[1] then
    f:SetPoint(pt[1], UIParent, pt[2] or pt[1], tonumber(pt[3]) or 0, tonumber(pt[4]) or 0)
  else
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 220)
  end
end

-- Couleur choisie (arrow.color) sur la flèche et son halo.
function Arrow:ApplyColor()
  if not self.frame then return end
  local r, g, b = 0.25, 0.82, 0.9
  if Q.Themes and Q.Themes.ArrowColor then r, g, b = Q.Themes:ArrowColor() end
  self.texture:SetVertexColor(r, g, b, 1)
  self.glow:SetVertexColor(r, g, b, 1)
  self.color = { r, g, b }
end

-- Cible de l'étape en cours : celle du suivi (mapId, x, y en 0-100), avec un nom à afficher.
function Arrow:Target()
  local T = Q.UI.Tracker
  local tg = T and T.target
  if not (T and T.entry and tg and tg.mapId and tg.x and tg.y) then return nil end
  return tg
end

-- Angle de la flèche (radians, sens antihoraire, 0 = droit devant) vers (tx, ty) monde depuis
-- (px, py) monde, le joueur regardant vers facing. Exposé pour les tests.
function Arrow.Angle(px, py, tx, ty, facing)
  local dx, dy = tx - px, ty - py   -- X vers le nord, Y vers l'ouest
  local bearing = math.atan2(dy, dx)
  local a = bearing - (facing or 0)
  local twoPi = 2 * math.pi
  a = a % twoPi
  if a > math.pi then a = a - twoPi end
  return a
end

function Arrow:Update()
  local f = self.frame
  if not f then return end
  if setting("arrow.show") == false then f:Hide(); return end
  local tg = self:Target()
  local M = Q.Maps
  if not (tg and M) then f:Hide(); return end
  local pm, px, py = M:PlayerPos()
  if not pm then f:Hide(); return end
  local c1, wx, wy = M:WorldPos(pm, px, py)
  local c2, tx, ty = M:WorldPos(tg.mapId, tg.x, tg.y)
  if not (c1 and c2 and c1 == c2) then f:Hide(); return end
  local facing = type(GetPlayerFacing) == "function" and GetPlayerFacing() or nil
  if Q.Util.IsSecret and Q.Util.IsSecret(facing) then facing = nil end
  local d = math.sqrt((tx - wx) ^ 2 + (ty - wy) ^ 2)
  if facing then
    self.texture:SetRotation(Arrow.Angle(wx, wy, tx, ty, facing))
    self.glow:SetRotation(Arrow.Angle(wx, wy, tx, ty, facing))
  end
  self.angle = facing and Arrow.Angle(wx, wy, tx, ty, facing) or nil
  self.distance:SetText(Q.Util.FormatDistance(d))
  self.name:SetText(Q.Util.StripColors and Q.Util.StripColors(tg.title or "") or (tg.title or ""))
  self.yards = d
  if d < ARRIVED then self.texture:SetAlpha(0.6) else self.texture:SetAlpha(1) end
  f:Show()
end

function Arrow:Refresh()
  self:Create()
  self:Place()
  self:ApplyColor()
  self:Update()
end

Q:On("LOGIN", function() Q.SafeCall(Arrow.Refresh, Arrow) end)
Q:On("SETTINGS_CHANGED", function(path)
  if not Arrow.frame then return end
  if path == "arrow.show" or path == "arrow.color" or path == "arrow.point" or path == "profile" then
    Q.SafeCall(Arrow.Refresh, Arrow)
  end
end)
Q:On("THEME_CHANGED", function() if Arrow.frame then Arrow:ApplyColor() end end)
