-- Contrôles du routeur embarqué : luajit tools/nav/check_nav.lua
-- Routeur et cartes dans Questify/NavEngine (chargés avec Questify) : chaque fichier listé par les XML des cartes et
-- par les TOC de Questify existe, chaque fichier de PACK.json existe, aucun jeton Polestar en code.
-- (Les sha256 de PACK.json sont recalculés par tools/nav/import_polestar_nav.sh.) Code de retour 1 si échec.
local root = (arg and arg[0] or "tools/nav/check_nav.lua"):match("^(.*)/tools/nav/[^/]*$") or "."
local NE = root .. "/Questify/NavEngine"
local errors = 0
local function bad(msg) errors = errors + 1; io.stderr:write(msg, "\n") end
local function read(p) local f = io.open(p, "rb"); if not f then return nil end local s = f:read("*a"); f:close(); return s end
local function exists(p) return read(p) ~= nil end

local tokens = { "PolestarPathData", "Polestar_NavEngine", "Polestar_NavCosts", "PolestarNavChokepoints",
  '"Polestar_Nav_EK"', '"Polestar_Nav_Kalimdor"' }

local function checkLua(path)
  local s = read(path)
  if not s then bad("fichier absent " .. path); return end
  for _, tok in ipairs(tokens) do
    if s:find(tok, 1, true) then bad(path .. " contient " .. tok) end
  end
end

-- fichiers NavEngine listés par les TOC de Questify
for _, toc in ipairs({ "Questify", "Questify_Camelot" }) do
  local s = read(root .. "/Questify/" .. toc .. ".toc")
  if not s then bad("TOC absent : " .. toc) else
    for l in s:gmatch("[^\r\n]+") do
      if l:sub(1, 10) == "NavEngine\\" then
        local rel = l:gsub("\\", "/")
        if rel:match("%.lua$") then checkLua(root .. "/Questify/" .. rel)
        elseif not exists(root .. "/Questify/" .. rel) then bad(toc .. " : fichier absent " .. rel) end
      end
    end
  end
end

-- fichiers listés par les XML des cartes
for _, x in ipairs({ "Maps/Nav.xml", "Maps/EK/EK.xml", "Maps/Kalimdor/Kalimdor.xml" }) do
  local s = read(NE .. "/" .. x)
  if not s then bad("XML absent : " .. x) else
    local dir = NE .. "/" .. (x:match("^(.*)/[^/]+$") or "")
    for f in s:gmatch('<Script file="([^"]+)"') do checkLua(dir .. "/" .. f) end
  end
end

-- PACK.json : clés de l'ancienne disposition (Questify_Nav/…, Questify_Nav_EK/…) vers NavEngine/
local function packPath(key)
  local ek = key:match("^Questify_Nav_EK/(.+)$")
  if ek then return NE .. "/Maps/EK/" .. ek end
  local kal = key:match("^Questify_Nav_Kalimdor/(.+)$")
  if kal then return NE .. "/Maps/Kalimdor/" .. kal end
  local nav = key:match("^Nav/(.+)$")
  if nav then return NE .. "/Maps/" .. nav end
  return NE .. "/" .. key
end
local pack = read(NE .. "/PACK.json")
if not pack then bad("PACK.json absent") else
  for key in pack:gmatch('"([^"]+%.lua)"%s*:%s*"%x+"') do
    if not exists(packPath(key)) then bad("PACK.json : fichier absent " .. key) end
  end
end

if errors > 0 then os.exit(1) end
print("check_nav : OK")
