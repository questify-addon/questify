-- tools/routebuilder/build_dungeon_guides.lua : génère les routes du mode « Donjons » (Alliance).
-- Lua 5.1 / LuaJIT, hors jeu, lancé depuis la racine du projet :
--   luajit tools/routebuilder/build_dungeon_guides.lua [--db PATH] [--questie PATH] [--out DIR] [--report DIR]
--          [--date AAAA-MM-JJ] [--jit]
--
-- Écrit <out>/AllianceDungeon/AD_*.lua, <out>/DungeonGuides.xml et <report>/*.md (un rapport par chapitre
-- et ROUTES.md). N'écrit ni les guides habituels, ni Guides.xml, ni ClassQuestData.lua, ni BagQuestData.lua.
--
-- Principe : les chapitres de plans_dungeon.lua sont simulés par le générateur habituel (build.lua, sim.lua),
-- à la place des plans de l'Alliance. La simulation de référence est celle d'un personnage qui contourne
-- toutes les instances et joue toutes les alternatives : aucune XP d'instance n'est supposée. Puis :
--   * en fin de chapitre, un bloc « instance » par échelon (plan.after) : aller à l'entrée, objectifs et
--     rendus des quêtes de l'échelon qui sont dans le journal (étapes rung + phase = "run") ;
--   * les prises de quêtes de donjon et leurs suites d'accès reçoivent rung + phase = "prep" ;
--   * les étapes d'un chapitre d'alternative reçoivent alt = { échelons } et below = niveau visé ;
--   * un rendu lointain est déplacé au début du prochain chapitre qui passe par la zone du PNJ.
local here = (arg and arg[0] or ""):match("^(.*)[/\\]build_dungeon_guides%.lua$") or "tools/routebuilder"
package.path = here .. "/?.lua;" .. package.path

local qdb = require("qdb")
local world = require("world")
local plansm = require("plans")
local emit = require("emit")
local PD = require("plans_dungeon")
local build = assert(loadfile(here .. "/build.lua"))("--as-module")
local BR = assert(loadfile(here .. "/build_dungeon_route.lua"))("--as-module")

local M = {}

local TRAVEL = { ["goto"] = true, fly = true, boat = true, hearth = true }
local QUEST = { accept = true, complete = true, turnin = true }
local DEFER_SPAN = 5      -- chapitres suivants examinés pour déplacer un rendu lointain
local CHAIN_DEPTH = 6     -- niveaux de préquêtes remontés depuis une quête de donjon

local function parseArgs(argv)
  local o = { db = qdb.DEFAULT_DB, questie = qdb.DEFAULT_QUESTIE, out = "Questify/Guides",
              report = "docs/dungeon-mode/routes", data = "Questify/Guides/DungeonData.lua",
              overrides = here .. "/overrides.lua", date = os.date("%Y-%m-%d") }
  local i = 1
  while i <= #argv do
    local a, v = argv[i], argv[i + 1]
    if a == "--db" then o.db = v elseif a == "--questie" then o.questie = v
    elseif a == "--out" then o.out = v elseif a == "--report" then o.report = v
    elseif a == "--date" then o.date = v elseif a == "--data" then o.data = v
    elseif a == "--jit" then o.jit = true; i = i - 1
    else error("unknown argument " .. tostring(a)) end
    i = i + 2
  end
  return o
end

local function contains(list, v)
  for _, x in ipairs(list or {}) do if x == v then return true end end
  return false
end

-- Index des échelons : quête -> échelon, préquête d'une quête d'échelon -> échelon, nom de donjon -> échelons,
-- quête -> entrée de DungeonData (inside, endAt...).
function M.index(D, rungs, data)
  local ix = { byKey = {}, questRung = {}, prereqRung = {}, byName = {}, dq = {} }
  for _, d in ipairs(data.dungeons) do
    for _, q in ipairs(d.quests and d.quests.Alliance or {}) do ix.dq[q.id] = q end
  end
  for _, r in ipairs(rungs) do
    ix.byKey[r.key] = r
    ix.byName[r.name] = ix.byName[r.name] or {}
    table.insert(ix.byName[r.name], r.key)
    for _, id in ipairs(r.quests) do ix.questRung[id] = r.key end
  end
  for _, r in ipairs(rungs) do
    local frontier = {}
    for _, id in ipairs(r.quests) do frontier[#frontier + 1] = id end
    for _ = 1, CHAIN_DEPTH do
      local nextF = {}
      for _, id in ipairs(frontier) do
        local q = D.quests[id]
        for _, list in ipairs(q and { q.preSingle, q.preGroup } or {}) do
          for _, p in ipairs(list) do
            if not ix.questRung[p] and not ix.prereqRung[p] then
              ix.prereqRung[p] = r.key
              nextF[#nextF + 1] = p
            end
          end
        end
      end
      frontier = nextF
    end
  end
  return ix
end

-- Échelon d'une étape de prise ou de suite d'accès (étape `dungeon` du simulateur), ou nil.
function M.prepRung(ix, step)
  local id = step[2]
  if ix.questRung[id] then return ix.questRung[id] end
  if ix.prereqRung[id] then return ix.prereqRung[id] end
  local keys = ix.byName[step.dungeon or ""]
  if keys and #keys == 1 then return keys[1] end
  return nil
end

local function prereqsDone(q, done)
  for _, p in ipairs(q.preGroup or {}) do if not done[p] then return false end end
  if #(q.preSingle or {}) > 0 then
    local any = false
    for _, p in ipairs(q.preSingle) do if done[p] then any = true end end
    if not any then return false end
  end
  return true
end

local function rungLabel(r)
  return r.wing and (r.name .. ": " .. r.wing) or r.name
end

-- Bloc « instance » d'un échelon, ajouté à la fin des étapes ; l'état du personnage simulé est mis à jour
-- (quêtes rendues, sans XP : la simulation de référence contourne l'instance).
-- -> { taken = n, total = n, missing = { ids } }
function M.runBlock(D, ix, data, r, state, steps, zones)
  local name = r.name
  local function tag(step, q)
    step.rung, step.phase, step.optional, step.dungeon = r.key, "run", true, name
    if q then
      local rw = data.rewards[q.id] or {}
      step._c = { name = q.name, level = q.level, xp = rw.xp or 0, simLevel = math.floor(state.level) }
    end
    steps[#steps + 1] = step
    return step
  end
  if r.entrance then
    tag({ "goto", r.entrance[1], r.entrance[2], r.entrance[3],
          note = ("Dungeon: %s (5 players). No group? Skip the instance in /qf dungeons"):format(rungLabel(r)) })
  end
  local entranceMap = r.entrance and r.entrance[1]
  local function endMap(id)
    local e = ix.dq[id]
    return e and e.endAt and e.endAt[1] or nil
  end
  local function near(id)
    local m = endMap(id)
    return m == nil or m == entranceMap or contains(zones, m)
  end
  local function turninOrder(a, b)
    local na, nb = near(a) and 0 or 1, near(b) and 0 or 1
    if na ~= nb then return na < nb end
    local ma, mb = endMap(a) or 0, endMap(b) or 0
    if ma ~= mb then return ma < mb end
    return a < b
  end
  local function finish(ids)
    table.sort(ids)
    for _, id in ipairs(ids) do
      local q = D.quests[id]
      if #q.objectives.list > 0 then tag({ "complete", id }, q) end
    end
    table.sort(ids, turninOrder)
    for _, id in ipairs(ids) do
      local q = D.quests[id]
      local s = tag({ "turnin", id, xp = (data.rewards[id] or {}).xp }, q)
      s._endMap, s._far = endMap(id), not near(id)
      state.done[id] = true
      state.log[id] = nil
    end
  end
  local taken, handled = 0, {}
  local inLog = {}
  for _, id in ipairs(r.quests) do
    if state.log[id] and D.quests[id] then inLog[#inLog + 1] = id; handled[id] = true end
  end
  taken = #inLog
  finish(inLog)
  -- quêtes prises dans l'instance (ou suites des précédentes) dont les préquêtes sont maintenant rendues
  for _ = 1, 4 do
    local more = {}
    for _, id in ipairs(r.quests) do
      local q, e = D.quests[id], ix.dq[id]
      if q and e and e.inside and not handled[id] and not state.done[id] and prereqsDone(q, state.done)
        and (q.races == 0 or state.raceBits == nil or qdb.hasBit(q.races, state.raceBits)) then
        more[#more + 1] = id
        handled[id] = true
      end
    end
    if #more == 0 then break end
    table.sort(more)
    for _, id in ipairs(more) do
      tag({ "accept", id, note = "Starts inside the dungeon" }, D.quests[id])
    end
    taken = taken + #more
    finish(more)
  end
  local missing = {}
  for _, id in ipairs(r.quests) do if not handled[id] then missing[#missing + 1] = id end end
  return { taken = taken, total = #r.quests, missing = missing }
end

-- PNJ qui donne le plus de quêtes de la tranche sur une carte : point d'entrée d'un chapitre sans modèle.
function M.hub(D, mapId, minLevel, maxLevel)
  local count, best = {}, nil
  for _, id in ipairs(qdb.sortedKeys(D.quests)) do
    local q = D.quests[id]
    if q.level >= minLevel - 3 and q.level <= maxLevel + 3 then
      for _, n in ipairs(q.starters.npcs or {}) do
        local npc = D.npcs[n]
        if npc and npc.spawns and npc.spawns[mapId] and npc.spawns[mapId][1] then count[n] = (count[n] or 0) + 1 end
      end
    end
  end
  for _, n in ipairs(qdb.sortedKeys(count)) do
    if not best or count[n] > count[best] then best = n end
  end
  if not best then return nil end
  local p = D.npcs[best].spawns[mapId][1]
  return { mapId, math.floor(p[1] * 100 + 0.5) / 100, math.floor(p[2] * 100 + 0.5) / 100 }, best
end

-- Étiquettes des étapes d'un chapitre (après la simulation et les filtres de race).
function M.tagSteps(ix, plan, steps)
  if plan.alt then
    local alt = #plan.alt == 1 and plan.alt[1] or plan.alt
    for _, s in ipairs(steps) do
      s.alt, s.below = alt, plan.maxLevel
    end
    return
  end
  local firstRun
  for i, s in ipairs(steps) do
    if s.rung then firstRun = firstRun or i
    elseif s.dungeon and QUEST[s[1]] then
      local key = M.prepRung(ix, s)
      if key then s.rung, s.phase = key, "prep" end
    end
  end
  -- chapitre qui ne sert qu'à un donjon : tout le reste est du trajet d'accès
  if plan.prepFor then
    for _, s in ipairs(steps) do
      if not s.rung then s.rung, s.phase = plan.prepFor, "prep" end
    end
  end
  -- trajet final vers l'entrée : détour qui ne sert qu'au donjon
  if firstRun and plan.run then
    local i = firstRun - 1
    while i >= 1 and TRAVEL[steps[i][1]] and not steps[i].rung do
      steps[i].rung, steps[i].phase = plan.run[1], "run"
      i = i - 1
    end
  end
end

-- Déplace les rendus lointains d'un bloc « instance » au début du prochain chapitre joué d'office (pas une
-- alternative) qui passe par la zone du PNJ. -> nombre de rendus déplacés.
function M.deferTurnins(chapters)
  local moved = 0
  for i, ch in ipairs(chapters) do
    local keep = {}
    for _, s in ipairs(ch.steps) do
      local target
      if s._far and s[1] == "turnin" and s._endMap then
        for j = i + 1, math.min(i + DEFER_SPAN, #chapters) do
          local c = chapters[j]
          if not c.plan.alt and (contains(c.plan.zones, s._endMap) or contains(c.plan.endZones, s._endMap)) then
            target = c
            break
          end
        end
      end
      if target then
        local at = 1
        while target.steps[at] and TRAVEL[target.steps[at][1]] do at = at + 1 end
        table.insert(target.steps, at, s)
        s._far = nil
        moved = moved + 1
      else
        keep[#keep + 1] = s
      end
    end
    ch.steps = keep
  end
  return moved
end

-- Texte du guide : celui de emit.guide, avec l'en-tête du mode et les champs mode et after.
function M.guideText(plan, steps, report, meta)
  local text = emit.guide(plan, steps, report, meta)
  text = text:gsub("%-%- corriger tools/routebuilder/plans%.lua ou overrides%.lua, puis relancer tools/routebuilder/build%.lua%.",
    "-- corriger tools/routebuilder/plans_dungeon.lua ou dungeon_ladder.lua, puis relancer\n"
    .. "-- tools/routebuilder/build_dungeon_guides.lua. Chapitre du mode « Donjons » (docs/dungeon-mode/README.md).", 1)
  local extra = '  mode = "dungeon",\n'
  if plan.after_ then extra = extra .. ("  after = %s,\n"):format(emit.value(plan.after_)) end
  local n
  text, n = text:gsub('(\n  faction = "Alliance",\n)', function(l) return l .. extra end, 1)
  assert(n == 1, "faction line not found in " .. plan.id)
  return text
end

local function fmtMin(s) return math.floor((s or 0) / 60 + 0.5) end

function M.main(argv)
  local o = parseArgs(argv)
  if jit and not o.jit then jit.off() end
  local ladder = require("dungeon_ladder")
  local data = BR.loadData(o.data)
  local rungs = BR.build(ladder, data)
  local errs = PD.check(rungs)
  if #errs > 0 then
    for _, e in ipairs(errs) do io.stderr:write("plans_dungeon.lua: " .. e .. "\n") end
    return 1
  end
  local ov = build.loadOverrides(o.overrides)
  local W = world.load(here .. "/data")
  local D = qdb.addPrereqs(qdb.load({ db = o.db, questie = o.questie, faction = "Alliance" }), ov.pre)
  local ix = M.index(D, rungs, data)
  local list = PD.build(plansm.Alliance, rungs, function(id)
    local e = ix.dq[id]
    return e and e.at or nil
  end)
  local runInfo, notes = {}, {}
  for _, p in ipairs(list) do
    if not p.noEmit then
      p.before = function(plan, state)
        if plan.entryHub and not plan.entry then
          local entry, npc = M.hub(D, plan.entryHub, plan.minLevel, plan.maxLevel)
          plan.entry = assert(entry, "no quest hub on map " .. plan.entryHub)
          notes[plan.id] = ("entry at the busiest quest giver of the band (NPC %d)"):format(npc)
        end
        -- personnage simulé déjà au-dessus de la tranche : la tranche suit son niveau
        local lvl = math.floor(state.level)
        if plan.noLevel then
          -- chapitre de passage : simulé sans niveau à atteindre ; tranche écrite rétablie par plan.after
          plan._band = { math.min(plan.minLevel, lvl), math.max(plan.maxLevel, math.min(lvl + 1, 60)) }
          plan.minLevel, plan.maxLevel = math.min(plan.minLevel, lvl), lvl
        elseif lvl >= plan.maxLevel then
          notes[plan.id] = (notes[plan.id] and notes[plan.id] .. "; " or "")
            .. ("band %d-%d moved to %d-%d (simulated level %.2f)"):format(plan.minLevel, plan.maxLevel,
               math.min(lvl, 59), math.min(lvl + 1, 60), state.level)
          plan.minLevel, plan.maxLevel = math.min(lvl, 59), math.min(lvl + 1, 60)
        end
        plan._startLevel = state.level
      end
      p.after = function(plan, state, steps)
        plan._endLevel = state.level
        if plan._band then plan.minLevel, plan.maxLevel = plan._band[1], plan._band[2] end
        for _, key in ipairs(plan.run or {}) do
          runInfo[key] = M.runBlock(D, ix, data, ix.byKey[key], state, steps, plan.zones)
          runInfo[key].chapter, runInfo[key].level = plan.id, state.level
        end
      end
    end
  end
  local classicAlliance, classicHorde = plansm.Alliance, plansm.Horde
  plansm.Alliance, plansm.Horde = list, {}
  local results, order = build.simulateFaction(D, W, "Alliance", ov)
  plansm.Alliance, plansm.Horde = classicAlliance, classicHorde

  local chapters = {}
  for _, id in ipairs(order) do
    local r = results[id]
    if not r.plan.noEmit then chapters[#chapters + 1] = r end
  end
  -- ordre du tronc (le parcours de l'Elfe de la nuit est simulé après les autres départs)
  local pos = {}
  for i, t in ipairs(PD.TRUNK) do pos[t.id] = i end
  table.sort(chapters, function(a, b) return pos[a.plan.id] < pos[b.plan.id] end)
  for _, ch in ipairs(chapters) do M.tagSteps(ix, ch.plan, ch.steps) end
  local moved = M.deferTurnins(chapters)

  local dir = o.out .. "/AllianceDungeon"
  build.mkdir(dir)
  build.mkdir(o.report)
  local meta = { commit = D.commit, date = o.date }
  local xml = { '<Ui xmlns="http://www.blizzard.com/wow/ui/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                '    xsi:schemaLocation="http://www.blizzard.com/wow/ui/ ..\\FrameXML\\UI.xsd">',
                '  <!-- Fichier réécrit par tools/routebuilder/build_dungeon_guides.lua : chapitres du mode « Donjons ». -->' }
  local rows = {}
  for _, ch in ipairs(chapters) do
    local plan, rep = ch.plan, ch.report
    rep.steps = #ch.steps
    build.writeFile(dir .. "/" .. plan.id .. ".lua", M.guideText(plan, ch.steps, rep, meta))
    build.writeFile(o.report .. "/" .. plan.id .. ".md", build.reportText(D, plan, ch.steps, rep, meta))
    xml[#xml + 1] = ('  <Script file="AllianceDungeon\\%s.lua"/>'):format(plan.id)
    local role = plan.alt and ("alternative de " .. table.concat(plan.alt, ", "))
      or plan.run and ("instance : " .. table.concat(plan.run, ", ")) or "zone"
    rows[#rows + 1] = ("| %s | %s | %d-%d | %.2f → %.2f | %d | %d | %d | %s | %s |"):format(plan.id, plan.title,
      plan.minLevel, plan.maxLevel, rep.startLevel or 0, rep.endLevel or 0, #ch.steps, #rep.quests, fmtMin(rep.time),
      role, notes[plan.id] or "")
    print(("%-15s steps %3d  quests %3d  lvl %5.2f -> %5.2f  %4d min  %s%s"):format(plan.id, #ch.steps, #rep.quests,
      rep.startLevel or 0, rep.endLevel or 0, fmtMin(rep.time), role,
      (rep.endLevel or 0) < plan.maxLevel - 1 and "  [below maxLevel-1]" or ""))
  end
  xml[#xml + 1] = "</Ui>"
  build.writeFile(o.out .. "/DungeonGuides.xml", table.concat(xml, "\n") .. "\n")

  local doc = {}
  local function w(s) doc[#doc + 1] = s or "" end
  w("# Mode « Donjons » Alliance : routes générées")
  w()
  w(("Généré par `tools/routebuilder/build_dungeon_guides.lua` le %s (QuestieDB commit `%s`). Ne pas modifier à la main."):format(o.date, D.commit or "?"))
  w()
  w("Niveaux simulés : ceux d'un personnage qui **contourne toutes les instances** et joue toutes les")
  w("alternatives en extérieur. Aucune XP d'instance n'est supposée ; un personnage qui fait les donjons est")
  w("donc au-dessus de ces niveaux, et les chapitres d'alternative sont passés dès qu'il atteint leur niveau visé.")
  w()
  w("## Chapitres")
  w()
  w("| Chapitre | Zone | Tranche | Niveau simulé | Étapes | Quêtes | Minutes | Rôle | Remarque |")
  w("|---|---|---|---|---|---|---|---|---|")
  for _, r in ipairs(rows) do w(r) end
  w()
  w("## Échelons")
  w()
  w("Quêtes prises : quêtes de l'échelon dans le journal du personnage simulé au moment de l'instance, plus")
  w("celles qui commencent dans l'instance. Les autres ne sont pas sur la route (donneur hors des zones")
  w("traversées, suite trop longue, niveau requis) : la fenêtre Donjons du journal permet de les ajouter.")
  w()
  w("| Échelon | Chapitre | Niveau simulé | Entrée conseillée | Quêtes prises | Hors route |")
  w("|---|---|---|---|---|---|")
  for _, r in ipairs(rungs) do
    local info = runInfo[r.key] or { taken = 0, total = #r.quests, missing = {}, chapter = "?", level = 0 }
    local miss = {}
    for _, id in ipairs(info.missing) do miss[#miss + 1] = ("%d %s"):format(id, data.names[id] or "?") end
    w(("| %s | %s | %.1f | %d | %d/%d | %s |"):format(rungLabel(r), info.chapter, info.level, r.entry, info.taken,
      info.total, table.concat(miss, " ; ")))
  end
  w()
  w(("Rendus lointains déplacés vers un chapitre suivant : %d."):format(moved))
  w()
  build.writeFile(o.report .. "/ROUTES.md", table.concat(doc, "\n"))
  print(("wrote %d chapter(s) in %s, DungeonGuides.xml, reports in %s; %d far turn-in(s) moved"):format(#chapters, dir, o.report, moved))
  return 0
end

if select(1, ...) == "--as-module" then return M end
os.exit(M.main(arg or {}))
