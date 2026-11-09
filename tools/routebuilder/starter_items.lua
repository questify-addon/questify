-- tools/routebuilder/starter_items.lua : liste des objets qui démarrent une quête (niveau <= 60, vue Forever des
-- deux factions) et qui tombent d'un PNJ, un identifiant par ligne. Entrée de tools/routebuilder/fetch_drops.py.
--   luajit tools/routebuilder/starter_items.lua [--db PATH] [--questie PATH] > liste.txt
local function scriptDir()
  local src = debug.getinfo(1, "S").source or ""
  return src:match("^@(.*)[/\\]starter_items%.lua$") or "tools/routebuilder"
end
package.path = scriptDir() .. "/?.lua;" .. package.path
local qdb = require("qdb")

local opts = {}
local i = 1
while i <= #arg do
  local name = arg[i]:match("^%-%-(%w+)$")
  if name and arg[i + 1] then opts[name] = arg[i + 1]; i = i + 2
  else io.stderr:write("unknown argument " .. arg[i] .. "\n"); os.exit(2) end
end

local seen, ids = {}, {}
for _, f in ipairs({ "Alliance", "Horde" }) do
  local D = qdb.load({ db = opts.db, questie = opts.questie, faction = f })
  for _, q in pairs(D.quests) do
    if q.level and q.level <= 60 then
      for _, it in ipairs(q.starters.items) do
        local item = D.items[it]
        if item and #(item.npcDrops or {}) > 0 and not seen[it] then seen[it] = true; ids[#ids + 1] = it end
      end
    end
  end
end
table.sort(ids)
for _, id in ipairs(ids) do print(id) end
