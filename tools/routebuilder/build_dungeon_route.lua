-- tools/routebuilder/build_dungeon_route.lua : échelle du mode « Donjons » (Alliance) pour l'addon.
-- Lua 5.1 / LuaJIT, hors jeu, lancé depuis la racine du projet :
--   luajit tools/routebuilder/build_dungeon_route.lua [--data FILE] [--out FILE] [--plan FILE] [--date YYYY-MM-DD]
--
-- Lit l'échelle écrite à la main (dungeon_ladder.lua) et les faits déjà générés de
-- Questify/Guides/DungeonData.lua (donjons, quêtes Alliance, XP de base de Q.QuestRewardData), sans
-- QuestieDB. Écrit :
--   * Questify/Guides/DungeonRouteData.lua : échelons dans l'ordre joué, niveau d'entrée, quêtes, XP et
--     étoiles (cases à cocher de l'addon, Engine/DungeonMode.lua) ;
--   * docs/dungeon-mode/ECHELLE.md : le plan écrit (niveau × donjon ou aile × zones entre deux).
-- Ne touche à aucun guide existant ni à DungeonData.lua.
--
-- Étoiles (rentabilité en XP de quêtes) : somme de l'XP de base des quêtes de l'échelon (XP de
-- QuestieDB, déjà divisée par deux en donjon par Forever, « ~ » quand elle est estimée) rapportée à l'XP
-- du niveau d'entrée (xp.LEVEL_XP). Seuils dans dungeon_ladder.lua (STARS). Aucune quête : aucune étoile.
-- L'XP des monstres de l'instance n'est pas comptée : QuestieDB ne donne pas leur nombre.
package.path = "tools/routebuilder/?.lua;" .. package.path
local xpm = require("xp")

local M = {}

local function parseArgs(argv)
  local o = { data = "Questify/Guides/DungeonData.lua", out = "Questify/Guides/DungeonRouteData.lua",
              plan = "docs/dungeon-mode/ECHELLE.md", date = os.date("%Y-%m-%d") }
  local i = 1
  while i <= #argv do
    local k, v = argv[i], argv[i + 1]
    if k == "--data" then o.data = v elseif k == "--out" then o.out = v
    elseif k == "--plan" then o.plan = v elseif k == "--date" then o.date = v
    else error("option inconnue : " .. tostring(k)) end
    i = i + 2
  end
  return o
end

-- Charge DungeonData.lua hors jeu -> { dungeons = Q.DungeonData, rewards = Q.QuestRewardData, names, source }.
-- names : noms des quêtes lus dans les commentaires de fin de ligne (plan écrit seulement).
function M.loadData(path)
  local Q = {}
  local chunk = assert(loadfile(path))
  chunk("Questify", Q)
  local names, source = {}, nil
  for line in io.lines(path) do
    local id, name = line:match("{ id = (%d+),.*%-%- (.+)$")
    if id then names[tonumber(id)] = name end
    source = source or line:match("QuestieDB commit (%x+)")
  end
  return { dungeons = assert(Q.DungeonData, "no Q.DungeonData in " .. path),
           rewards = Q.QuestRewardData or {}, names = names, source = source }
end

function M.stars(ladder, pct, questCount)
  if questCount == 0 then return 0 end
  for _, t in ipairs(ladder.STARS) do
    if pct >= t.min then return t.stars end
  end
  return 1
end

-- build(ladder, data) -> échelons dans l'ordre joué ; lève une erreur sur une échelle incohérente.
function M.build(ladder, data)
  local byKey = {}
  for _, d in ipairs(data.dungeons) do byKey[d.key] = d end
  local assigned, seenKey, out = {}, {}, {}
  for order, r in ipairs(ladder.rungs) do
    assert(type(r.key) == "string" and not seenKey[r.key], "duplicate or missing rung key " .. tostring(r.key))
    seenKey[r.key] = true
    local d = assert(byKey[r.dungeon], ("rung %s: unknown dungeon %s"):format(r.key, tostring(r.dungeon)))
    local all, known = d.quests and d.quests.Alliance or {}, {}
    for _, q in ipairs(all) do known[q.id] = q end
    assert((r.wing ~= nil) == (r.quests ~= nil), ("rung %s: a wing lists its quests, a whole dungeon does not"):format(r.key))
    local ids = {}
    if r.quests then
      for _, id in ipairs(r.quests) do
        assert(known[id], ("rung %s: quest %d is not an Alliance quest of %s"):format(r.key, id, r.dungeon))
        ids[#ids + 1] = id
      end
    else
      for _, q in ipairs(all) do ids[#ids + 1] = q.id end
    end
    local skip = r.skip or {}
    for id in pairs(skip) do
      assert(known[id], ("rung %s: skipped quest %d is not an Alliance quest of %s"):format(r.key, id, r.dungeon))
    end
    assigned[r.dungeon] = assigned[r.dungeon] or { skip = {}, wings = 0 }
    local a = assigned[r.dungeon]
    if r.wing then a.wings = a.wings + 1 end
    local quests, xp, est = {}, 0, false
    for _, id in ipairs(ids) do
      assert(not a[id], ("quest %d of %s is in two rungs"):format(id, r.dungeon))
      a[id] = r.key
      if not skip[id] then
        local rw = data.rewards[id] or {}
        quests[#quests + 1] = id
        xp = xp + (rw.xp or 0)
        if rw.est then est = true end
      end
    end
    for id in pairs(skip) do a.skip[id] = true; a[id] = a[id] or r.key end
    local min, max = r.min or d.minLevel, r.max or d.maxLevel
    local entry = r.entry or math.min(min + ladder.ENTRY_OFFSET, ladder.ENTRY_CAP)
    assert(entry >= min and entry <= max, ("rung %s: entry %d outside %d-%d"):format(r.key, entry, min, max))
    local need = assert(xpm.LEVEL_XP[entry], "no level xp for " .. entry)
    local pct = xp / need
    table.sort(quests)
    out[#out + 1] = { key = r.key, dungeon = r.dungeon, wing = r.wing, name = d.name, areaId = d.areaId,
      minLevel = min, maxLevel = max, entry = entry, entryWhy = r.entryWhy, quests = quests, xp = xp, est = est,
      pct = pct, stars = M.stars(ladder, pct, #quests), order = order, rung = r }
  end
  -- un donjon découpé en ailes : chaque quête Alliance va dans une aile (ou est écartée)
  for key, a in pairs(assigned) do
    if a.wings > 0 then
      for _, q in ipairs(byKey[key].quests and byKey[key].quests.Alliance or {}) do
        assert(a[q.id], ("quest %d of %s is in no wing"):format(q.id, key))
      end
    end
  end
  table.sort(out, function(x, y)
    if x.entry ~= y.entry then return x.entry < y.entry end
    return x.order < y.order
  end)
  return out
end

local function list(ids)
  local parts = {}
  for i, id in ipairs(ids) do parts[i] = tostring(id) end
  return table.concat(parts, ", ")
end

function M.emitLua(rungs, ladder, data, date)
  local o = {}
  local function w(s) o[#o + 1] = s end
  w("local addonName, Q = ...")
  w("-- Généré par tools/routebuilder/build_dungeon_route.lua. Ne pas modifier à la main :")
  w("-- corriger tools/routebuilder/dungeon_ladder.lua, puis relancer le script.")
  w(("-- Source : Questify/Guides/DungeonData.lua (QuestieDB commit %s), généré le %s."):format(data.source or "?", date))
  w("-- Échelle du mode « Donjons » (Alliance) : un échelon par donjon 5 joueurs ou par aile, dans l'ordre joué.")
  w("-- entry = niveau d'entrée conseillé ; quests = quêtes Alliance de l'échelon ; xp = somme de leur XP de base")
  w("-- (est = au moins une valeur estimée) ; pct = part du niveau d'entrée ; stars = 0 à 3 (0 : aucune quête).")
  w("-- Méthode : docs/dungeon-mode/README.md. L'XP des monstres de l'instance n'est pas comptée.")
  w("Q.DungeonRouteData = {")
  w(("  faction = \"Alliance\", entryOffset = %d, entryCap = %d,"):format(ladder.ENTRY_OFFSET, ladder.ENTRY_CAP))
  w("  rungs = {")
  for _, r in ipairs(rungs) do
    w(("    { key = %q, dungeon = %q,%s name = %q, areaId = %d, minLevel = %d, maxLevel = %d, entry = %d,")
      :format(r.key, r.dungeon, r.wing and (" wing = %q,"):format(r.wing) or "", r.name, r.areaId, r.minLevel,
              r.maxLevel, r.entry))
    w(("      quests = { %s }, xp = %d,%s pct = %.3f, stars = %d },")
      :format(list(r.quests), r.xp, r.est and " est = true," or "", r.pct, r.stars))
  end
  w("  },")
  w("}")
  w("")
  return table.concat(o, "\n")
end

local STAR = { [0] = "—", "★", "★★", "★★★" }

local function blocks(bl)
  local parts = {}
  for _, b in ipairs(bl or {}) do
    local lv = b.from == b.to and tostring(b.from) or (b.from .. "-" .. b.to)
    parts[#parts + 1] = ("%s (%s%s)"):format(b.zone, lv, b.role == "prep" and ", accès" or "")
  end
  return table.concat(parts, " ; ")
end

function M.emitPlan(rungs, ladder, data, date)
  local o = {}
  local function w(s) o[#o + 1] = s or "" end
  w("# Mode « Donjons » Alliance : échelle 1-60")
  w()
  w(("Généré par `tools/routebuilder/build_dungeon_route.lua` le %s à partir de"):format(date))
  w(("`tools/routebuilder/dungeon_ladder.lua` et de `Questify/Guides/DungeonData.lua` (QuestieDB commit `%s`)."):format(data.source or "?"))
  w("Ne pas modifier à la main. Méthode et limites : [README.md](README.md).")
  w()
  w("## Départs par race (1-15)")
  w()
  w("| Races | Zones (niveaux) | Remarque |")
  w("|---|---|---|")
  for _, s in ipairs(ladder.starts) do
    local parts = {}
    for _, b in ipairs(s.blocks) do
      parts[#parts + 1] = ("%s (%d-%d)%s"):format(b.zone, b.from, b.to, b.note and (" : " .. b.note) or "")
    end
    w(("| %s | %s | %s |"):format(table.concat(s.races, ", "), table.concat(parts, " ; "), s.note or ""))
  end
  w()
  w("Les trois départs se rejoignent à Stormwind au niveau 15 (tram d'Ironforge, bateau d'Auberdine).")
  w()
  w("## Échelle")
  w()
  w(("Niveau d'entrée = bas de la plage + %d, plafonné à %d, sauf mention. « Accès » : zone traversée pour les suites")
    :format(ladder.ENTRY_OFFSET, ladder.ENTRY_CAP))
  w("et les quêtes du donjon ; les autres zones sont vidées (suites d'abord, puis quêtes à accès direct).")
  w("XP de quêtes : XP de base de QuestieDB, « ~ » quand une valeur est estimée ; % = part du niveau d'entrée.")
  w()
  w("| # | Entrée | Échelon | Plage | Quêtes | XP de quêtes | % niveau | Étoiles | Zones avant l'échelon | Alternative en extérieur |")
  w("|---|---|---|---|---|---|---|---|---|---|")
  for i, r in ipairs(rungs) do
    local alt = r.rung.alt and ("%s (%d-%d)"):format(r.rung.alt.zone, r.rung.alt.from, r.rung.alt.to) or ""
    w(("| %d | %d | %s%s | %d-%d | %d | %s%d | %.0f %% | %s | %s | %s |"):format(i, r.entry, r.name,
      r.wing and (" : " .. r.wing) or "", r.minLevel, r.maxLevel, #r.quests, r.est and "~" or "", r.xp,
      r.pct * 100, STAR[r.stars], blocks(r.rung.before), alt))
  end
  w()
  w("## Quêtes par échelon")
  w()
  for _, r in ipairs(rungs) do
    w(("### %s%s (`%s`, entrée %d)"):format(r.name, r.wing and (" : " .. r.wing) or "", r.key, r.entry))
    w()
    if r.entryWhy then w("Niveau d'entrée imposé : " .. r.entryWhy .. "."); w() end
    if #r.quests == 0 then w("Aucune quête Alliance."); w() end
    for _, id in ipairs(r.quests) do
      local rw = data.rewards[id] or {}
      w(("- %d %s : %s%d XP"):format(id, data.names[id] or "?", rw.est and "~" or "", rw.xp or 0))
    end
    local skipped = {}
    for id in pairs(r.rung.skip or {}) do skipped[#skipped + 1] = id end
    table.sort(skipped)
    for _, id in ipairs(skipped) do
      w(("- hors route : %d %s (%s)"):format(id, data.names[id] or "?", r.rung.skip[id]))
    end
    if #r.quests > 0 or #skipped > 0 then w() end
    for _, v in ipairs(r.rung.verify or {}) do w("- à vérifier en jeu : " .. v) end
    if r.rung.verify then w() end
  end
  w("## Contenu écarté")
  w()
  for _, x in ipairs(ladder.omitted) do w(("- %s : %s."):format(x.name, x.why)) end
  w()
  return table.concat(o, "\n")
end

local function writeFile(path, text)
  local f = assert(io.open(path, "wb"))
  f:write(text)
  f:close()
end

function M.main(argv)
  local o = parseArgs(argv)
  local ladder = require("dungeon_ladder")
  local data = M.loadData(o.data)
  local rungs = M.build(ladder, data)
  writeFile(o.out, M.emitLua(rungs, ladder, data, o.date))
  writeFile(o.plan, M.emitPlan(rungs, ladder, data, o.date))
  for _, r in ipairs(rungs) do
    print(("%-11s entry %2d  quests %2d  xp %6d  %5.1f %%  stars %d"):format(r.key, r.entry, #r.quests, r.xp, r.pct * 100, r.stars))
  end
  print(("wrote %s and %s (%d rungs)"):format(o.out, o.plan, #rungs))
end

-- Lancé comme script (pas chargé par un test).
if arg and arg[0] and arg[0]:match("build_dungeon_route%.lua$") then M.main(arg) end

return M
