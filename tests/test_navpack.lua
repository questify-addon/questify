-- Tests du routeur de marche embarqué (Questify_Nav, _EK, _Kalimdor), copié de Polestar_Nav 0.3.7.2.
local function root() return Mock.root end

local function read(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local s = f:read("*a"); f:close()
  return s
end

local function lines(path)
  local out = {}
  local s = read(path)
  if not s then return out end
  for l in s:gmatch("[^\r\n]+") do out[#out + 1] = l end
  return out
end

local function sh(cmd)
  local p = io.popen(cmd)
  local out = p:read("*a"); p:close()
  return out
end

-- Fichiers Lua d'un dossier (récursif), chemins complets.
local function luaFiles(dir)
  local out = {}
  for f in sh('find "' .. root() .. "/" .. dir .. '" -name "*.lua" -type f'):gmatch("[^\n]+") do out[#out + 1] = f end
  return out
end

local function tocFiles(dir, name)
  local out = {}
  for _, l in ipairs(lines(root() .. "/" .. dir .. "/" .. name .. ".toc")) do
    l = l:gsub("\r", "")
    if l ~= "" and l:sub(1, 1) ~= "#" then out[#out + 1] = (l:gsub("\\", "/")) end
  end
  return out
end

local function tocHas(dir, name, line)
  for _, l in ipairs(lines(root() .. "/" .. dir .. "/" .. name .. ".toc")) do
    if l:gsub("%s+$", "") == line then return true end
  end
  return false
end

local function countFiles(dir, pat)
  local n = 0
  for f in sh('ls "' .. root() .. "/" .. dir .. '"'):gmatch("[^\n]+") do
    if f:match(pat) then n = n + 1 end
  end
  return n
end

return {
  no_polestar_globals = function(t)
    local tokens = { "PolestarPathData", "Polestar_NavEngine", "Polestar_NavCosts", "PolestarNavChokepoints",
      '"Polestar_Nav_EK"', '"Polestar_Nav_Kalimdor"' }
    local seen = 0
    for _, dir in ipairs({ "Questify_Nav", "Questify_Nav_EK", "Questify_Nav_Kalimdor" }) do
      for _, f in ipairs(luaFiles(dir)) do
        seen = seen + 1
        local s = read(f)
        for _, tok in ipairs(tokens) do
          t.ok(not s:find(tok, 1, true), f .. " contient " .. tok)
        end
      end
    end
    t.ok(seen > 90, "fichiers Lua trouvés : " .. seen)
  end,

  tocs = function(t)
    local nav = "Questify_Nav"
    t.ok(tocHas(nav, nav, "## LoadOnDemand: 1"))
    t.ok(tocHas(nav, nav, "## Dependencies: Questify"))
    t.ok(tocHas(nav, nav, "## Interface: 16001"))
    t.ok(tocHas(nav, nav, "## X-License: GPL-3.0-or-later"))
    t.ok(tocHas(nav, nav, "## Title: Questify Nav"))
    for _, p in ipairs({ "Questify_Nav_EK", "Questify_Nav_Kalimdor" }) do
      t.ok(tocHas(p, p, "## Dependencies: Questify_Nav"), p .. " dépend de Questify_Nav")
      t.ok(tocHas(p, p, "## LoadOnDemand: 1"))
    end
    for _, p in ipairs({ "Questify_Nav", "Questify_Nav_EK", "Questify_Nav_Kalimdor" }) do
      local files = tocFiles(p, p)
      t.ok(#files > 0, p .. " liste des fichiers")
      for _, f in ipairs(files) do
        t.ok(read(root() .. "/" .. p .. "/" .. f) ~= nil, p .. " : fichier absent " .. f)
      end
    end
  end,

  parts_complete = function(t)
    t.eq(countFiles("Questify_Nav_EK", "^Nav0_%d+%.lua$"), 41)
    t.eq(countFiles("Questify_Nav_Kalimdor", "^Nav1_%d+%.lua$"), 51)
  end,

  credits = function(t)
    local s = read(root() .. "/Questify_Nav/CREDITS.md")
    t.ok(s, "CREDITS.md présent")
    t.ok(s:find("Polestar", 1, true) and s:find("0.3.7.2", 1, true))
    t.ok(s:find("Cillian Berragan", 1, true))
    t.ok(s:find("v1.16.0", 1, true) and s:find("b1ad5bd", 1, true))
    t.ok(s:find("Leffe", 1, true))
  end,
}
