-- Contrôles du routeur embarqué : luajit tools/nav/check_nav.lua
-- Chaque fichier listé dans un TOC existe, chaque fichier de PACK.json existe, aucun jeton Polestar en code.
-- (Les sha256 de PACK.json sont recalculés par tools/nav/import_polestar_nav.sh.) Code de retour 1 si échec.
local root = (arg and arg[0] or "tools/nav/check_nav.lua"):match("^(.*)/tools/nav/[^/]*$") or "."
local errors = 0
local function bad(msg) errors = errors + 1; io.stderr:write(msg, "\n") end
local function exists(p) local f = io.open(p, "rb"); if f then f:close(); return true end end

local tokens = { "PolestarPathData", "Polestar_NavEngine", "Polestar_NavCosts", "PolestarNavChokepoints",
  '"Polestar_Nav_EK"', '"Polestar_Nav_Kalimdor"' }

for _, name in ipairs({ "Questify_Nav", "Questify_Nav_EK", "Questify_Nav_Kalimdor" }) do
  local dir = root .. "/" .. name
  local toc = io.open(dir .. "/" .. name .. ".toc", "rb")
  if not toc then bad("TOC absent : " .. name) else
    for l in toc:lines() do
      l = l:gsub("\r", "")
      if l ~= "" and l:sub(1, 1) ~= "#" then
        local rel = l:gsub("\\", "/")
        if not exists(dir .. "/" .. rel) then bad(name .. " : fichier absent " .. rel) end
        if rel:match("%.lua$") then
          local f = io.open(dir .. "/" .. rel, "rb")
          local s = f and f:read("*a") or ""
          if f then f:close() end
          for _, tok in ipairs(tokens) do
            if s:find(tok, 1, true) then bad(name .. "/" .. rel .. " contient " .. tok) end
          end
        end
      end
    end
    toc:close()
  end
end

local pack = io.open(root .. "/Questify_Nav/PACK.json", "rb")
if not pack then bad("PACK.json absent") else
  local s = pack:read("*a"); pack:close()
  for key in s:gmatch('"([^"]+%.lua)"%s*:%s*"%x+"') do
    local p = key:match("^Questify_Nav_") and key or ("Questify_Nav/" .. key)
    if not exists(root .. "/" .. p) then bad("PACK.json : fichier absent " .. key) end
  end
end

if errors > 0 then os.exit(1) end
print("check_nav : OK")
