local addonName, Q = ...

-- Flèche Questify (spec du routeur intégré, § 4 ; maquette validée :
-- docs/superpowers/specs/2026-11-16-routeur-integre-maquette.html, bloc « Flèche »).
--
-- Un cadre aux couleurs du thème du suivi (tracker.theme, tracker.opacity), de haut en bas :
-- la flèche (Media/Themes/arrow.tga, blanche, teinte par SetVertexColor, tournée par SetRotation à
-- chaque image) sur son ombre (arrow-glow.tga), la distance, le temps restant, puis l'icône et la
-- légende du trajet en cours ; un cadenas en haut à droite (fermé : verrouillée ; ouvert, pâle :
-- déplaçable). Sous la légende, un avertissement passager (ville hostile, zone de haut niveau).
--
-- Ce qu'elle suit :
--   * routeur Questify (Q.Nav:Active() == "questify") : la route du pont de marche (message NAV_ROUTE,
--     Nav/Walk.lua) ; elle pointe vers route.nextPoint, rafraîchi par Q.Walk:Route() ;
--   * sans routeur (« none », ou Questify_Nav absent) : la cible (message NAV_TARGET, ou
--     Q.Nav:Status().target), droit dessus, pour que le joueur soit toujours guidé.
-- Visible seulement si l'affichage effectif est la flèche (nav.display == "arrow", ou affichage choisi
-- absent ; hors SPF),
-- arrow.show n'est pas désactivé, une route ou une cible existe, le joueur n'est pas en vol (taxi) et
-- sa position est connue.
--
-- Avertissements (route.warnings, refaits à chaque calcul) : chacun n'est montré qu'une fois par
-- trajet (par cible), pendant WARN_SECONDS.
--
-- Réglages : arrow.show, arrow.color (Q.Themes:ArrowColor quand il existe), nav.arrowLocked (la souris
-- traverse la flèche verrouillée ; le cadenas reste cliquable), nav.arrowPos = { point, point relatif,
-- x, y } par rapport à UIParent (centre du cadre, en unités d'UIParent, comme la position du suivi).
--   Q.Arrow:Frame()          cadre (créé au premier appel ; tests et /qf demo)
--   Q.Arrow:Update()         visibilité, textes et cible de la flèche
--   Q.Arrow:ResetPosition()  position par défaut (/qf arrow reset)
Q.UI = Q.UI or {}
local Arrow = {}
Q.Arrow = Arrow
Q.UI.Arrow = Arrow

local L = Q.L

local MEDIA = "Interface\\AddOns\\" .. addonName .. "\\Media\\Themes\\"
local ARROW_TEXTURE = MEDIA .. "arrow"
local GLOW_TEXTURE = MEDIA .. "arrow-glow"
local LOCKED_TEXTURE = "Interface\\Buttons\\LockButton-Locked-Up"
local UNLOCKED_TEXTURE = "Interface\\Buttons\\LockButton-Unlocked-Up"

-- Mise en page de la maquette (.arrow : 210 px de large, marges 10/12/8, flèche 64 px, icône 18 px).
local WIDTH = 210
local PAD_TOP, PAD_BOTTOM, PAD_X = 10, 8, 12
local ARROW_SIZE = 64
local GLOW_SIZE = 76              -- ombre un peu plus grande que la flèche (contour et ombre portée)
local GAP = 2                     -- entre flèche, distance et temps
local DIST_H, ETA_H = 20, 13
local LEG_GAP = 6                 -- gap 2 + margin-top 4 de la légende
local ICON_SIZE, ICON_GAP = 18, 6
local WARN_GAP, WARN_H = 4, 14
local LOCK_SIZE = 12
local LOCK_ALPHA_ON, LOCK_ALPHA_OFF = 0.85, 0.35
local SHADOW_ALPHA = 0.55
local DEFAULT_POINT = { "TOP", "TOP", 0, -140 }

local UPDATE_EVERY = 0.2          -- secondes : textes, visibilité, prochain point
local POSITION_EVERY = 0.05       -- secondes : position du joueur relue au plus à ce rythme (rotation)
local WARN_SECONDS = 10           -- durée d'un avertissement
local WALK_SPEED = 7              -- yards/s, si Q.Travel:Speed manque

-- Repli jusqu'à Q.Themes:ArrowColor (session ui-themes, mêmes valeurs) : seule palette propre à ce
-- fichier, à retirer quand ArrowColor est fusionné. "theme" : couleur title du thème.
local FALLBACK_COLORS = {
  cyan = { 0x3f / 255, 0xd0 / 255, 0xe6 / 255 },
  gold = { 0xf0 / 255, 0xc7 / 255, 0x5a / 255 },
  green = { 0x5f / 255, 0xe0 / 255, 0x8a / 255 },
  white = { 0xf2 / 255, 0xf4 / 255, 0xf7 / 255 },
  pink = { 0xff / 255, 0x7a / 255, 0xb8 / 255 },
}

local frame
local route          -- dernière route reçue (NAV_ROUTE), lue sans la modifier
local target         -- dernière cible reçue (NAV_TARGET) : { mapId, x, y, title }
local ticker         -- Update toutes les UPDATE_EVERY s tant qu'une route ou une cible existe
local moving         -- glisser-déposer en cours
local aimC, aimX, aimY   -- point visé (repère monde), lu à chaque image pour la rotation
local posC, posX, posY, posAt   -- position du joueur en cache (monde) et instant de la lecture
local seen, seenKey = {}, nil   -- avertissements déjà montrés pour la cible seenKey
local warnText, warnUntil

local sqrt, floor, max, min = math.sqrt, math.floor, math.max, math.min
local atan2 = math.atan2 or math.atan

local function setting(path) return Q.Settings:Get(path) end
local function now() return GetTime and GetTime() or 0 end
local function isSecret(v) return Q.Util.IsSecret(v) end

---------------------------------------------------------------------------
-- Position du joueur et calculs
---------------------------------------------------------------------------
-- Joueur en repère monde (instance, x vers le nord, y vers l'ouest), ou nil.
local function playerWorld()
  local M = Q.Maps
  local m, x, y = M:PlayerPos()
  if not m then return nil end
  return M:WorldPos(m, x, y)
end

-- Position du joueur en cache, relue au plus toutes les POSITION_EVERY s (fresh : relue maintenant).
local function cachedPlayer(fresh)
  local t = now()
  if fresh or not posAt or t - posAt >= POSITION_EVERY then
    posC, posX, posY = playerWorld()
    posAt = t
  end
  return posC, posX, posY
end

local function worldOf(p)
  if type(p) ~= "table" then return nil end
  local c, X, Y = Q.Maps:WorldPos(p.mapId, p.x, p.y)
  if not c then return nil end
  return { instance = c, x = X, y = Y }
end

local function dist(ax, ay, bx, by)
  local dx, dy = ax - bx, ay - by
  return sqrt(dx * dx + dy * dy)
end

-- Longueur du chemin après `point` (même table que l'un des points de path), 0 sinon.
local function restOfPath(path, point)
  if type(path) ~= "table" then return 0 end
  local n, k = #path, nil
  for i = 1, n do
    if path[i] == point then k = i; break end
  end
  if not k then return 0 end
  local total = 0
  for i = k, n - 1 do
    local a, b = path[i], path[i + 1]
    total = total + dist(a.x, a.y, b.x, b.y)
  end
  return total
end

local function speed()
  local T = Q.Travel
  local s = T and T.Speed and T:Speed()
  if type(s) == "number" and s > 0 then return s end
  return WALK_SPEED
end

local function onTaxi()
  if not UnitOnTaxi then return false end
  local ok, v = pcall(UnitOnTaxi, "player")
  if not ok or isSecret(v) then return false end
  return v == true
end

---------------------------------------------------------------------------
-- Textes
---------------------------------------------------------------------------
local function formatDistance(yards)
  if type(yards) ~= "number" then return "" end
  if yards < 1000 then return string.format(L.NAV_ARROW_YARDS, floor(yards + 0.5)) end
  local km = string.format("%.1f", yards / 1000):gsub("%.", L.DECIMAL_SEP or ".", 1)
  return string.format(L.NAV_ARROW_KM, km)
end

-- « environ 2 min », « environ 30 s » (dizaines de secondes sous la minute).
local function formatEta(seconds)
  if type(seconds) ~= "number" or seconds ~= seconds or seconds == math.huge then return "" end
  if seconds < 55 then
    return string.format(L.NAV_ARROW_ETA_SEC, max(10, floor(seconds / 10 + 0.5) * 10))
  end
  return string.format(L.NAV_ARROW_ETA_MIN, max(1, floor(seconds / 60 + 0.5)))
end

local function warningText(w) return Q.Travel and Q.Travel:WarningText(w) end

local function tenth(v) return type(v) == "number" and floor(v * 10 + 0.5) or "" end

local function targetKey(t)
  if type(t) ~= "table" then return "" end
  return table.concat({ tostring(t.mapId), tenth(t.x), tenth(t.y), tostring(t.title or "") }, "|")
end

-- Nouveaux avertissements de la route : montrés une seule fois par cible.
local function noteWarnings(r)
  local key = targetKey(r.target)
  if key ~= seenKey then
    seen, seenKey = {}, key
    warnText, warnUntil = nil, nil
  end
  local fresh = {}
  for _, w in ipairs(r.warnings or {}) do
    local k = type(w) == "table" and (tostring(w.kind) .. ":" .. tostring(w.name or w.level)) or nil
    if k and not seen[k] then
      seen[k] = true
      local text = warningText(w)
      if text then fresh[#fresh + 1] = text end
    end
  end
  if #fresh > 0 then
    warnText, warnUntil = table.concat(fresh, " · "), now() + WARN_SECONDS
  end
end

---------------------------------------------------------------------------
-- Ce que la flèche suit
---------------------------------------------------------------------------
-- "route" (routeur Questify), "target" (aucun routeur), ou nil (autre affichage, SPF).
local function mode()
  local N = Q.Nav
  if not (N and N.Active) then return nil end
  local router, display = N:Active()
  if display ~= "arrow" then return nil end
  if router == "questify" then return "route" end
  if router == nil then return "target" end
  return nil
end

local function currentTarget()
  if target then return target end
  local N = Q.Nav
  local st = N and N.Status and N:Status()
  return st and st.target or nil
end

-- Mode à afficher, ou nil (flèche cachée).
local function wanted()
  if setting("arrow.show") == false then return nil end
  local m = mode()
  if m == "route" and not route then return nil end
  if m == "target" and not currentTarget() then return nil end
  if not m or onTaxi() then return nil end
  return m
end

---------------------------------------------------------------------------
-- Apparence
---------------------------------------------------------------------------
local function arrowColor()
  local T = Q.Themes
  if T and type(T.ArrowColor) == "function" then
    local r, g, b = T:ArrowColor()
    if type(r) == "number" then return r, g, b end
  end
  local c = FALLBACK_COLORS[setting("arrow.color")]
  if not c then
    local theme = T and T:Current()
    c = (theme and theme.text and theme.text.accent) or (T and T:TextColor("title")) or FALLBACK_COLORS.cyan
  end
  return c[1], c[2], c[3]
end

local function applyStyle()
  local f = frame
  if not f then return end
  local T = Q.Themes
  -- thème en vigueur (race du personnage ou tracker.theme), comme le suivi
  local theme = T:Apply(f, T.CurrentKey and T:CurrentKey() or setting("tracker.theme"), setting("tracker.opacity"))
  T:StyleText(f.dist, "distance", theme)
  T:StyleText(f.eta, "dim", theme)
  T:StyleText(f.caption, "body", theme)
  T:StyleText(f.warn, "warn", theme)
  local d = T:TextColor("dim", theme)
  f.lock:SetVertexColor(d[1], d[2], d[3], 1)
  local r, g, b = arrowColor()
  f.arrow:SetVertexColor(r, g, b, 1)
  f.glow:SetVertexColor(0, 0, 0, SHADOW_ALPHA)
end

local function applyLock()
  local f = frame
  if not f then return end
  local locked = setting("nav.arrowLocked") == true
  f:EnableMouse(not locked)
  f.lock:SetTexture(locked and LOCKED_TEXTURE or UNLOCKED_TEXTURE)
  f.lock:SetAlpha(locked and LOCK_ALPHA_ON or LOCK_ALPHA_OFF)
end

local function scaleRatio(f)
  local ui = UIParent and UIParent:GetEffectiveScale() or 1
  local own = f:GetEffectiveScale() or 1
  if not ui or ui == 0 or not own or own == 0 then return 1 end
  return own / ui
end

-- nav.arrowPos = { point, point relatif, x, y } (aussi accepté : { point, x, y }), sinon en haut au centre.
local function applyPosition()
  local f = frame
  if not f then return end
  f:ClearAllPoints()
  local p = setting("nav.arrowPos")
  if type(p) == "table" and type(p[1]) == "string" then
    local rel, x, y = p[2], p[3], p[4]
    if type(rel) ~= "string" then rel, x, y = p[1], p[2], p[3] end
    local k = scaleRatio(f)
    f:SetPoint(p[1], UIParent, rel, (tonumber(x) or 0) / k, (tonumber(y) or 0) / k)
  else
    local d = DEFAULT_POINT
    f:SetPoint(d[1], UIParent, d[2], d[3], d[4])
  end
end

local function savePosition(f)
  local cx, cy = f:GetCenter()
  if not (cx and cy) then return end
  local k = scaleRatio(f)
  Q.Settings:Set("nav.arrowPos", { "CENTER", "BOTTOMLEFT", Q.Util.Round(cx * k, 1), Q.Util.Round(cy * k, 1) })
end

-- Ligne de la légende centrée : icône + texte, texte tronqué à la largeur du cadre.
local function layoutLeg(f, caption, icon)
  local row = f.legRow
  if type(caption) ~= "string" or caption == "" then
    row:Hide()
    return false
  end
  f.caption:SetWidth(0)
  f.caption:SetText(caption)
  local hasIcon = type(icon) == "string" or type(icon) == "number"
  if hasIcon then f.icon:SetTexture(icon); f.icon:Show() else f.icon:Hide() end
  local lead = hasIcon and (ICON_SIZE + ICON_GAP) or 0
  local textW = min(f.caption:GetStringWidth() or 0, WIDTH - 2 * PAD_X - lead)
  f.caption:SetWidth(textW)
  f.caption:ClearAllPoints()
  if hasIcon then
    f.caption:SetPoint("LEFT", f.icon, "RIGHT", ICON_GAP, 0)
  else
    f.caption:SetPoint("LEFT", row, "LEFT", 0, 0)
  end
  row:SetWidth(lead + textW)
  row:Show()
  return true
end

local function layout(f, hasLeg, hasWarn)
  local h = PAD_TOP + ARROW_SIZE + GAP + DIST_H + GAP + ETA_H + PAD_BOTTOM
  if hasLeg then h = h + LEG_GAP + ICON_SIZE end
  f.warn:ClearAllPoints()
  if hasLeg then
    f.warn:SetPoint("TOP", f.legRow, "BOTTOM", 0, -WARN_GAP)
  else
    f.warn:SetPoint("TOP", f.eta, "BOTTOM", 0, -WARN_GAP)
  end
  if hasWarn then h = h + WARN_GAP + WARN_H end
  f:SetHeight(h)
end

---------------------------------------------------------------------------
-- Rotation (chaque image)
---------------------------------------------------------------------------
local function rotate()
  local f = frame
  if not f then return end
  local c, px, py = cachedPlayer()
  local facing = GetPlayerFacing and GetPlayerFacing()
  if not aimC or not c or c ~= aimC or isSecret(facing) or type(facing) ~= "number" then
    f.arrow:Hide()
    f.glow:Hide()
    return
  end
  -- angle vers le point, compté comme l'orientation du joueur (0 = nord, sens inverse des aiguilles)
  local a = atan2(aimY - py, aimX - px) - facing
  f.arrow:SetRotation(a)
  f.glow:SetRotation(a)
  f.arrow:Show()
  f.glow:Show()
end

local function onUpdate()
  local ok, err = pcall(rotate)
  if not ok then Q:ReportError(err) end
end

---------------------------------------------------------------------------
-- Construction
---------------------------------------------------------------------------
local function showLockTooltip(owner)
  if not GameTooltip then return end
  GameTooltip:SetOwner(owner, "ANCHOR_LEFT")
  GameTooltip:SetText(L.OPT_NAV_ARROW_LOCKED)
  GameTooltip:AddLine(L.OPT_TIP_NAV_ARROW_LOCKED, 1, 1, 1, true)
  GameTooltip:AddLine(L.NAV_ARROW_LOCK_CLICK, 0.6, 0.6, 0.6, true)
  GameTooltip:Show()
end

function Arrow:Frame()
  if frame then return frame end
  local f = CreateFrame("Frame", "QuestifyArrow", UIParent, "BackdropTemplate")
  frame = f
  f:Hide()
  f:SetSize(WIDTH, 120)
  f:SetFrameStrata("MEDIUM")
  f:SetClampedToScreen(true)
  if f.SetDontSavePosition then f:SetDontSavePosition(true) end
  f:SetMovable(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", function(self)
    if setting("nav.arrowLocked") == true then return end
    moving = true
    self:StartMoving()
  end)
  f:SetScript("OnDragStop", function(self)
    if not moving then return end
    moving = false
    self:StopMovingOrSizing()
    Q.SafeCall(savePosition, self)
  end)
  f:SetScript("OnHide", function(self)
    if moving then
      moving = false
      self:StopMovingOrSizing()
      Q.SafeCall(savePosition, self)
    end
  end)
  f:SetScript("OnUpdate", onUpdate)

  -- flèche et son ombre (texture blanche qui pointe vers le haut)
  local glow = f:CreateTexture(nil, "ARTWORK", nil, 0)
  glow:SetTexture(GLOW_TEXTURE)
  glow:SetSize(GLOW_SIZE, GLOW_SIZE)
  glow:SetPoint("CENTER", f, "TOP", 0, -(PAD_TOP + ARROW_SIZE / 2) - 1)
  f.glow = glow
  local arrow = f:CreateTexture(nil, "ARTWORK", nil, 1)
  arrow:SetTexture(ARROW_TEXTURE)
  arrow:SetSize(ARROW_SIZE, ARROW_SIZE)
  arrow:SetPoint("TOP", f, "TOP", 0, -PAD_TOP)
  f.arrow = arrow

  local d = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
  d:SetPoint("TOP", arrow, "BOTTOM", 0, -GAP)
  d:SetHeight(DIST_H)
  f.dist = d
  local eta = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  eta:SetPoint("TOP", d, "BOTTOM", 0, -GAP)
  eta:SetHeight(ETA_H)
  f.eta = eta

  local row = CreateFrame("Frame", nil, f)
  row:SetSize(ICON_SIZE, ICON_SIZE)
  row:SetPoint("TOP", eta, "BOTTOM", 0, -LEG_GAP)
  f.legRow = row
  local icon = row:CreateTexture(nil, "ARTWORK")
  icon:SetSize(ICON_SIZE, ICON_SIZE)
  icon:SetPoint("LEFT", row, "LEFT", 0, 0)
  icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
  f.icon = icon
  local caption = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
  caption:SetJustifyH("LEFT")
  caption:SetWordWrap(false)
  f.caption = caption

  local warn = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  warn:SetWidth(WIDTH - 2 * PAD_X)
  warn:SetJustifyH("CENTER")
  warn:SetWordWrap(false)
  warn:Hide()
  f.warn = warn

  -- cadenas : fermé = verrouillée, ouvert et pâle = déplaçable ; clic = bascule
  local lb = CreateFrame("Button", nil, f)
  lb:SetSize(LOCK_SIZE + 4, LOCK_SIZE + 4)
  lb:SetPoint("TOPRIGHT", f, "TOPRIGHT", -5, -4)
  lb:SetScript("OnClick", function()
    Q.Settings:Set("nav.arrowLocked", setting("nav.arrowLocked") ~= true)
  end)
  lb:SetScript("OnEnter", function(self) Q.SafeCall(showLockTooltip, self) end)
  lb:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
  f.lockButton = lb
  local lock = lb:CreateTexture(nil, "OVERLAY")
  lock:SetSize(LOCK_SIZE, LOCK_SIZE)
  lock:SetPoint("CENTER", lb, "CENTER", 0, 0)
  if lock.SetDesaturated then lock:SetDesaturated(true) end
  f.lock = lock

  applyPosition()
  applyStyle()
  applyLock()
  return f
end

---------------------------------------------------------------------------
-- Mise à jour
---------------------------------------------------------------------------
local function hide()
  aimC = nil
  if frame then frame:Hide() end
end

function Arrow:Update()
  local m = wanted()
  if not m then return hide() end
  local c, px, py = cachedPlayer(true)
  if not c then return hide() end
  local point, caption, icon, yards, seconds
  if m == "route" then
    local r = route
    local W = Q.Walk
    if W and W.Route then W:Route() end          -- nextPoint suit le joueur
    local leg = r.legs and r.legs[r.leg]
    point = r.nextPoint
    caption = leg and leg.caption
    icon = leg and leg.icon
    if (type(caption) ~= "string" or caption == "") and type(r.target) == "table" then caption = r.target.title end
    if type(point) == "table" and point.instance == c then
      local d = dist(point.x, point.y, px, py)
      if leg and leg.kind ~= "walk" then
        -- vol, bateau… : temps du trajet, plus la marche jusqu'au départ tant qu'on y va
        local path = r.path
        local toStart = type(path) == "table" and #path > 1 and point == path[1]
        local ride = tonumber(leg.seconds)
        yards = d
        if toStart then seconds = d / speed() + (ride or 0) else seconds = ride or d / speed() end
      else
        yards = d + (r.straight and 0 or restOfPath(r.path, point))
        seconds = yards / speed()
      end
    end
  else
    local t = currentTarget()
    point = worldOf(t)
    local title = type(t.title) == "string" and t.title or ""
    if title ~= "" then caption = string.format(L.NAV_TRAVEL_WALK, title) end
    icon = Q.Travel and Q.Travel.ICONS and Q.Travel.ICONS.walk
    if point and point.instance == c then
      yards = dist(point.x, point.y, px, py)
      seconds = yards / speed()
    end
  end

  local f = self:Frame()
  if yards then
    aimC, aimX, aimY = point.instance, point.x, point.y
  else
    aimC = nil      -- autre continent, point inconnu : légende seule, sans flèche
  end
  f.dist:SetText(formatDistance(yards))
  f.eta:SetText(formatEta(seconds))
  local hasLeg = layoutLeg(f, caption, icon)
  local hasWarn = warnText ~= nil and warnUntil ~= nil and now() < warnUntil
  if hasWarn then
    f.warn:SetText(warnText)
    f.warn:Show()
  else
    warnText, warnUntil = nil, nil
    f.warn:Hide()
  end
  layout(f, hasLeg, hasWarn)
  f:Show()
  rotate()
end

-- Minuterie active (tests).
function Arrow:Ticking() return ticker ~= nil end

function Arrow:ResetPosition()
  Q.Settings:Set("nav.arrowPos", nil)
  applyPosition()
end

---------------------------------------------------------------------------
-- Messages et évènements
---------------------------------------------------------------------------
-- Minuterie tant qu'il y a quelque chose à suivre (aussi pendant un vol : réapparition à l'atterrissage).
-- Seulement si la flèche peut s'afficher : affichage « flèche » effectif et arrow.show actif.
local function syncTicker()
  local need = (route ~= nil or target ~= nil) and setting("arrow.show") ~= false and mode() ~= nil
  if need and not ticker then
    ticker = Q:NewTicker(UPDATE_EVERY, function() Arrow:Update() end)
  elseif not need and ticker then
    ticker:Cancel()
    ticker = nil
  end
end

Q:On("NAV_ROUTE", function(r)
  route = type(r) == "table" and r or nil
  if route then noteWarnings(route) end
  syncTicker()
  Arrow:Update()
end)

Q:On("NAV_TARGET", function(t)
  target = type(t) == "table" and t or nil
  syncTicker()
  Arrow:Update()
end)

local STYLE_PATHS = { tracker = true, ["tracker.theme"] = true, ["tracker.opacity"] = true,
  arrow = true, ["arrow.color"] = true }
Q:On("THEME_CHANGED", function() if frame then Q.SafeCall(applyStyle) end end)
Q:On("SETTINGS_CHANGED", function(path)
  if frame then
    if path == "nav.arrowPos" or path == "nav" then
      if not moving then applyPosition() end
    end
    if path == nil or STYLE_PATHS[path] then applyStyle() end
    if path == nil or path == "nav" or path == "nav.arrowLocked" then applyLock() end
  end
  if path == nil or path == "nav" or path == "arrow" or tostring(path):find("^nav%.") or path == "arrow.show" then
    syncTicker()
    Arrow:Update()
  end
end)

-- TomTom ou WaypointUI chargé après nous : l'affichage effectif change (la flèche le remplaçait).
Q:RegisterEvent("ADDON_LOADED", function(_, name)
  if name == "TomTom" or name == "WaypointUI" then
    syncTicker()
    Arrow:Update()
  end
end)

-- Fin de vol, écran de chargement : réapparition sans attendre la minuterie.
for _, event in ipairs({ "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST", "PLAYER_ENTERING_WORLD" }) do
  Q:RegisterEvent(event, function() Arrow:Update() end)
end
