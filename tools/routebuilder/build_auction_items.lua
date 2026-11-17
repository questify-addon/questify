-- tools/routebuilder/build_auction_items.lua : objets de collecte achetables à l'hôtel des ventes.
-- Lua 5.1 / LuaJIT, hors jeu, lancé depuis la racine du projet :
--   luajit tools/routebuilder/build_auction_items.lua [--db PATH] [--questie PATH] [--guides DIR] [--out FILE]
--                                                     [--date YYYY-MM-DD]
-- Lit les guides listés par <guides>/Guides.xml (guides livrés, après build.lua) et la vue Forever de
-- QuestieDB, puis écrit <guides>/AuctionItemData.lua (voir auctionitems.lua). À relancer après chaque
-- régénération des routes.
package.path = "tools/routebuilder/?.lua;" .. package.path
local qdb = require("qdb")
local ai = require("auctionitems")

local function parseArgs(argv)
  local o = { db = qdb.DEFAULT_DB, questie = qdb.DEFAULT_QUESTIE, guides = "Questify/Guides", out = nil,
    date = os.date("%Y-%m-%d") }
  local i = 1
  while i <= #argv do
    local k, v = argv[i], argv[i + 1]
    if k == "--db" then o.db = v elseif k == "--questie" then o.questie = v
    elseif k == "--guides" then o.guides = v elseif k == "--out" then o.out = v
    elseif k == "--date" then o.date = v
    else error("option inconnue : " .. tostring(k)) end
    i = i + 2
  end
  o.out = o.out or (o.guides .. "/AuctionItemData.lua")
  return o
end

local function readFile(path)
  local f = assert(io.open(path, "rb"), "cannot open " .. path)
  local s = f:read("*a"); f:close()
  return s
end

-- Définitions RegisterGuide des fichiers de guide listés par Guides.xml (fichiers de données exclus).
local function loadGuides(dir)
  local defs = {}
  local xml = readFile(dir .. "/Guides.xml"):gsub("<!%-%-.-%-%->", "")
  for rel in xml:gmatch('<Script%s+file%s*=%s*"([^"]+)"') do
    rel = rel:gsub("\\", "/")
    if rel:find("/", 1, true) then
      local fn = assert(loadstring(readFile(dir .. "/" .. rel), "@" .. rel))
      local Q = { RegisterGuide = function(_, def) defs[#defs + 1] = def end }
      setfenv(fn, {})
      fn("Questify", Q)
    end
  end
  return defs
end

local o = parseArgs(arg or {})
local Ds = {}
local function D(faction)
  if not Ds[faction] then Ds[faction] = qdb.load({ db = o.db, questie = o.questie, faction = faction }) end
  return Ds[faction]
end

local guides, total = {}, 0
for _, def in ipairs(loadGuides(o.guides)) do
  local list = ai.forGuide(D(def.faction == "Horde" and "Horde" or "Alliance"), def)
  guides[#guides + 1] = { id = def.id, list = list }
  total = total + #list
end
table.sort(guides, function(a, b) return a.id < b.id end)
local A = ai.auctioneers(D("Alliance"))
local f = assert(io.open(o.out, "wb"))
f:write(ai.emit(guides, A, { commit = D("Alliance").commit, date = o.date }))
f:close()
print(("wrote %s: %d item(s) in %d guide(s), %d + %d auctioneer(s)"):format(o.out, total, #guides, #A.A, #A.H))
