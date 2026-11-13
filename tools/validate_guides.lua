-- tools/validate_guides.lua : vérifie les guides générés contre QuestieDB (hors jeu, LuaJIT).
--
-- Usage : luajit tools/validate_guides.lua [--db PATH] [--questie PATH] [--guides DIR]
--   --guides : dossier qui contient Guides.xml (défaut Questify/Guides)
-- Chaque violation est affichée « <fichier>:<ligne> <message> » ; code de sortie 1 s'il y en a une.
--
-- Contrôles par étape : action valide ; quête connue ; quête éligible pour au moins une race du
-- chapitre (ou de la faction) ; coordonnées 0-100 sur une uiMap connue ; étape `fly` avec un `node`
-- (TaxiNodes.ID) connu et situé sur la carte de destination ; champ `classes` (étape propre à certaines
-- classes) : liste non vide de classFile connus (même règle que Q.Guides:Normalize), et pour une étape
-- de quête, chaque classe admise par le masque de classes de la quête.
-- Contrôles par parcours de race (tools/routebuilder/paths.lua, chaque race de chaque chapitre de
-- départ, en suivant next / nextByRace) : prérequis rendus avant l'accept, journal de 20 quêtes au
-- plus, complete / turnin seulement pour une quête du journal, pas d'accept après le rendu ni de
-- répétition d'un chapitre à l'autre, `obj` dans la liste des objectifs, vol vers un point de vol
-- découvert, pierre de foyer liée. Seule la suite par défaut est rejouée : les autres entrées de
-- `choices` ne le sont pas. Avec des étapes `classes` sur le parcours, il est rejoué une fois sans
-- elles (classes sans étape propre) puis une fois par classe nommée, avec les étapes de cette classe :
-- le journal de chaque classe est compté à part.
-- Contrôles des suites (plans.validate, comme build.lua sur plans.lua) : next / nextByRace vers des
-- guides chargés, `choices` de 2 à 4 guides de la même faction avec la suite par défaut ; champ `sim`
-- égal à l'en-tête « -- Simulation : » (tools/routebuilder/backfill.lua).

local here = (arg and arg[0] or ""):match("^(.*)[/\\]validate_guides%.lua$") or "tools"
package.path = here .. "/routebuilder/?.lua;" .. package.path

local qdb = require("qdb")
local world = require("world")
local paths = require("paths")
local plansm = require("plans")
local backfill = require("backfill")

local M = {}

local VALID = { accept = true, complete = true, turnin = true, ["goto"] = true, fp = true, sethearth = true,
                hearth = true, fly = true, boat = true, level = true, note = true }
local QUEST_ACTIONS = { accept = true, complete = true, turnin = true }
local POINT_ACTIONS = { ["goto"] = true, fp = true, sethearth = true, boat = true }

local RACE_BITS = { Human = 1, Orc = 2, Dwarf = 4, NightElf = 8, Undead = 16, Tauren = 32, Gnome = 64, Troll = 128 }
local FACTION_RACES = {
  Alliance = { "Human", "Dwarf", "NightElf", "Gnome", "Skyborne" },
  Horde = { "Orc", "Undead", "Tauren", "Troll", "Skyborne" },
}
local function raceBit(race, faction)
  if race == "Skyborne" then return faction == "Horde" and 8589934592 or 4294967296 end
  return RACE_BITS[race]
end

-- Étapes propres à une classe (champ `classes`) : mêmes noms que Q.CLASS_BITS (Data/Constants.lua).
local KNOWN_CLASSES = qdb.CLASS_BITS

local function classNames(v)
  if type(v) == "string" then return { v } end
  if type(v) == "table" then return v end
  return nil
end

-- classesProblem(valeur du champ classes) -> nil si valide (ou absent), sinon le message.
function M.classesProblem(v)
  if v == nil then return nil end
  local list = classNames(v)
  if not list then return "classes must be a list of class names" end
  for _, c in ipairs(list) do
    if type(c) ~= "string" then return "classes must be a list of class names" end
  end
  if #list == 0 then return "classes must name at least one class" end
  for _, c in ipairs(list) do
    if not KNOWN_CLASSES[c] then return ("unknown class '%s' in classes"):format(c) end
  end
  return nil
end

function M.contains(list, v)
  for _, x in ipairs(list or {}) do if x == v then return true end end
  return false
end

-- Mode « Donjons » (Engine/DungeonMode.lua) : échelons de <guides>/DungeonRouteData.lua.
-- -> { [clé] = true }, ou nil sans le fichier (les clés ne sont alors pas contrôlées).
function M.rungKeys(guidesDir)
  local fn = loadfile(guidesDir .. "/DungeonRouteData.lua")
  if not fn then return nil end
  local Q = {}
  setfenv(fn, {})
  if not pcall(fn, "Questify", Q) then return nil end
  local keys = {}
  for _, r in ipairs(type(Q.DungeonRouteData) == "table" and Q.DungeonRouteData.rungs or {}) do
    if type(r) == "table" and type(r.key) == "string" then keys[r.key] = true end
  end
  return keys
end

-- rungProblem(étape, mode du chapitre, clés connues) -> nil si les champs du mode « Donjons » (rung, phase,
-- alt, below) sont valides ou absents, sinon le message. Même règle que Q.Guides:Normalize, plus : ces champs
-- n'existent que dans un chapitre du mode, et l'échelon doit être dans DungeonRouteData.lua.
function M.rungProblem(step, mode, keys)
  if step.rung == nil and step.alt == nil and step.below == nil and step.phase == nil then return nil end
  if mode ~= "dungeon" then return "rung, phase, alt and below are only allowed in a dungeon mode chapter" end
  if step.rung ~= nil then
    if type(step.rung) ~= "string" or step.rung == "" then return "rung must be a rung key" end
    if step.phase ~= "prep" and step.phase ~= "run" then return "phase must be prep or run" end
    if step.alt ~= nil then return "alt and rung are exclusive" end
    if keys and not keys[step.rung] then return ("unknown rung '%s'"):format(step.rung) end
  elseif step.phase ~= nil then
    return "phase needs a rung"
  end
  if step.alt ~= nil then
    local list = type(step.alt) == "string" and { step.alt } or step.alt
    if type(list) ~= "table" or #list == 0 then return "alt must be a rung key or a list of rung keys" end
    for _, k in ipairs(list) do
      if type(k) ~= "string" or k == "" then return "alt must be a rung key or a list of rung keys" end
      if keys and not keys[k] then return ("unknown rung '%s' in alt"):format(k) end
    end
  end
  if step.below ~= nil and (type(step.below) ~= "number" or step.below < 2 or step.below > 60) then
    return "below must be a level between 2 and 60"
  end
  return nil
end

-- Variantes de classe d'un parcours et étapes vues par une classe : tools/routebuilder/paths.lua (aussi utilisé
-- par build.raceFilters).
M.classVariants = paths.classVariants
M.stepsForClass = paths.stepsForClass

local function readFile(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local s = f:read("*a"); f:close()
  return s
end

-- Lignes des étapes : la k-ième ligne qui commence par `{ "action"` dans le bloc steps.
local function stepLines(text)
  local lines, inSteps, n = {}, false, 0
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    n = n + 1
    if line:match("^%s*steps%s*=%s*{") then inSteps = true
    elseif inSteps and line:match('^%s*{%s*"') then lines[#lines + 1] = n end
  end
  return lines
end

local function loadGuide(path)
  local text = readFile(path)
  if not text then return nil, "cannot read file" end
  if text:byte(1) == 27 then return nil, "bytecode refused" end
  local fn, err = loadstring(text, "@" .. path)
  if not fn then return nil, err end
  local defs = {}
  local Q = {}
  function Q:RegisterGuide(def) defs[#defs + 1] = def end
  setfenv(fn, {})
  local ok, e = pcall(fn, "Questify", Q)
  if not ok then return nil, e end
  return defs, nil, stepLines(text), Q, text
end

-- Numéro de la première ligne du texte qui correspond au motif (0 si aucune).
local function lineOf(text, pattern)
  local n = 0
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    n = n + 1
    if line:match(pattern) then return n end
  end
  return 0
end

function M.run(argv)
  local opts = { db = qdb.DEFAULT_DB, questie = qdb.DEFAULT_QUESTIE, guides = "Questify/Guides", xml = "Guides.xml" }
  local i = 1
  while i <= #argv do
    local a = argv[i]
    if a == "--db" then opts.db = argv[i + 1]; i = i + 1
    elseif a == "--questie" then opts.questie = argv[i + 1]; i = i + 1
    elseif a == "--guides" then opts.guides = argv[i + 1]; i = i + 1
    -- liste de fichiers à contrôler, dans le dossier des guides (DungeonGuides.xml : mode « Donjons »)
    elseif a == "--xml" then opts.xml = argv[i + 1]; i = i + 1
    else io.stderr:write("unknown argument " .. a .. "\n"); return 2 end
    i = i + 1
  end
  local violations = {}
  -- context : guides habituels chargés seulement pour rejouer les parcours de race d'une autre liste
  -- (--xml DungeonGuides.xml : le mode « Donjons » prend la suite des départs habituels) ; rien n'y est relevé.
  local context = {}
  local function bad(file, line, msg)
    if context[file] then return end
    violations[#violations + 1] = ("%s:%d %s"):format(file, line or 0, msg)
  end

  local xml = readFile(opts.guides .. "/" .. opts.xml)
  if not xml then
    print(opts.guides .. "/" .. opts.xml .. ":0 missing " .. opts.xml)
    return 1
  end
  local files = {}
  if opts.xml ~= "Guides.xml" then
    local base = readFile(opts.guides .. "/Guides.xml") or ""
    for f in base:gmatch('<Script%s+file%s*=%s*"([^"]+)"') do
      local rel = (f:gsub("\\", "/"))
      files[#files + 1] = rel
      context[opts.guides .. "/" .. rel] = true
    end
  end
  for f in xml:gmatch('<Script%s+file%s*=%s*"([^"]+)"') do files[#files + 1] = (f:gsub("\\", "/")) end

  local W = world.load(here .. "/routebuilder/data")
  local Ds = {}
  -- prérequis ajoutés à la main (champ `pre` de routebuilder/overrides.lua, mêmes données que build.lua)
  local pre = {}
  do
    local f = io.open(here .. "/routebuilder/overrides.lua", "rb")
    if f then
      local text = f:read("*a"); f:close()
      local fn = text:byte(1) ~= 27 and loadstring(text, "@overrides.lua")
      if fn then
        setfenv(fn, {})
        local ok, ov = pcall(fn)
        if ok and type(ov) == "table" and type(ov.pre) == "table" then pre = ov.pre end
      end
    end
  end
  local function D(faction)
    faction = faction or "Alliance"
    if not Ds[faction] then
      Ds[faction] = qdb.addPrereqs(qdb.load({ db = opts.db, questie = opts.questie, faction = faction }), pre)
    end
    return Ds[faction]
  end

  -- chargement de tous les guides
  local guides, byId = {}, {}
  for _, rel in ipairs(files) do
    local path = opts.guides .. "/" .. rel
    local defs, err, lines, Q, text = loadGuide(path)
    if not defs then
      bad(path, 0, "load error: " .. tostring(err))
    elseif rel:match("ClassQuestData%.lua$") then
      if type(Q.ClassQuestData) ~= "table" then bad(path, 0, "ClassQuestData missing") end
    elseif rel:match("BagQuestData%.lua$") then
      -- quêtes à sac (tools/routebuilder/bagquests.lua) : forme des entrées et quêtes connues de QuestieDB
      if type(Q.BagQuestData) ~= "table" then
        bad(path, 0, "BagQuestData missing")
      else
        local keys = {}
        for i, e in ipairs(Q.BagQuestData) do
          if type(e) ~= "table" or type(e.key) ~= "string" then
            bad(path, 0, ("bag quest %d: no key"):format(i))
          elseif keys[e.key] then
            bad(path, 0, "duplicate bag quest key " .. e.key)
          else
            keys[e.key] = true
            if type(e.bag) ~= "number" or type(e.level) ~= "number" or type(e.quests) ~= "table" or #e.quests == 0 then
              bad(path, 0, e.key .. ": needs bag, level and quests")
            else
              for _, qid in ipairs(e.quests) do
                if not D(e.faction).quests[qid] then bad(path, 0, ("%s: unknown quest %s"):format(e.key, tostring(qid))) end
              end
            end
          end
        end
      end
    else
      if #defs ~= 1 then bad(path, 0, ("expected one RegisterGuide call, got %d"):format(#defs)) end
      for _, def in ipairs(defs) do
        if type(def.id) ~= "string" then bad(path, 0, "guide without id")
        elseif byId[def.id] then bad(path, 0, "duplicate guide id " .. def.id)
        else
          local g = { def = def, path = path, lines = lines, text = text }
          guides[#guides + 1] = g
          byId[def.id] = g
        end
      end
    end
  end

  -- suites (next, nextByRace, choices) : même contrôle que build.lua sur plans.lua
  local byFaction = { Alliance = {}, Horde = {} }
  for _, g in ipairs(guides) do table.insert(byFaction[g.def.faction == "Horde" and "Horde" or "Alliance"], g.def) end
  for _, e in ipairs(plansm.validate(byFaction)) do
    local g = byId[e.id]
    local line = g and lineOf(g.text, "^%s*choices%s*=")
    if g and line == 0 then line = lineOf(g.text, "^%s*next") end
    bad(g and g.path or "?", line, e.msg)
  end
  -- champ sim : valeurs de l'en-tête « -- Simulation : » (lu par le jeu, l'en-tête ne l'est pas)
  for _, g in ipairs(guides) do
    local want = backfill.parseSim(g.text)
    local got = g.def.sim
    if want then
      local same = type(got) == "table"
      for k, v in pairs(want) do
        if same and (type(got[k]) ~= "number" or math.abs(got[k] - v) > 1e-9) then same = false end
      end
      if not same then
        bad(g.path, lineOf(g.text, "^%s*sim%s*="), "sim field missing or different from the Simulation header (run tools/routebuilder/backfill.lua)")
      end
    end
  end

  -- quêtes prises / rendues par chapitre (pour les contrôles entre chapitres)
  local accepted, turned = {}, {}
  for _, g in ipairs(guides) do
    accepted[g.def.id], turned[g.def.id] = {}, {}
    for _, s in ipairs(g.def.steps or {}) do
      if type(s) == "table" then
        if s[1] == "accept" then accepted[g.def.id][s[2]] = true end
        if s[1] == "turnin" then turned[g.def.id][s[2]] = true end
      end
    end
  end

  -- Parcours par race : depuis chaque chapitre de départ (races + minLevel 1), on suit
  -- nextByRace[race] puis next, et on rejoue les étapes (paths.replay) : prérequis rendus, journal de
  -- 20 quêtes au plus, pas de complete / turnin hors du journal, pas d'accept après le rendu, index
  -- `obj` valide, vols vers des points de vol découverts, pierre de foyer liée. Une étape d'un
  -- chapitre commun qui n'est pas valide pour une race doit porter un filtre `race` sans elle.
  local onPath = {}
  local pathIssues, issueOrder = {}, {}
  for _, g in ipairs(guides) do
    local def = g.def
    if def.races and (def.minLevel or 1) <= 1 then
      local faction = def.faction == "Horde" and "Horde" or "Alliance"
      for _, race in ipairs(def.races) do
        local chain, seen = {}, {}
        local cur = g
        while cur and not seen[cur.def.id] do
          seen[cur.def.id] = true
          chain[#chain + 1] = cur
          onPath[cur.def.id] = true
          -- chapitre d'un mode qui prend la suite de celui-ci (champ after), sinon la suite habituelle
          local handoff
          if cur.def.mode == nil then
            for _, og in ipairs(guides) do
              local od = og.def
              if od.mode and type(od.after) == "table" and (not od.races or M.contains(od.races, race))
                and M.contains(od.after, cur.def.id) and (not handoff or od.id < handoff.def.id) then
                handoff = og
              end
            end
          end
          local nid = (cur.def.nextByRace and cur.def.nextByRace[race]) or cur.def.next
          cur = handoff or (nid and byId[nid]) or nil
        end
        local chapters = {}
        for _, cg in ipairs(chain) do
          chapters[#chapters + 1] = { id = cg.def.id, steps = cg.def.steps or {}, minLevel = cg.def.minLevel }
        end
        -- variante false : sans étape de classe ; puis une variante par classe nommée sur le parcours
        local variants = { false }
        for _, c in ipairs(M.classVariants(chapters)) do variants[#variants + 1] = c end
        for _, cls in ipairs(variants) do
          local vchapters, indexes = {}, {}
          for k, ch in ipairs(chapters) do
            local steps, index = M.stepsForClass(ch.steps, cls or nil)
            vchapters[k] = { id = ch.id, steps = steps, minLevel = ch.minLevel }
            indexes[k] = index
          end
          paths.replay(D(faction), W, faction, race, vchapters, function(ci, fsi, msg)
            local cg = chain[ci]
            local si = indexes[ci][fsi]
            local key = cg.path .. ":" .. tostring(si) .. ":" .. msg
            local it = pathIssues[key]
            if not it then
              it = { path = cg.path, line = cg.lines[si], msg = msg, races = {}, raceSeen = {}, classes = {},
                     classSeen = {}, base = false }
              pathIssues[key] = it
              issueOrder[#issueOrder + 1] = key
            end
            if not it.raceSeen[race] then it.raceSeen[race] = true; table.insert(it.races, race) end
            if not cls then
              it.base = true
            elseif not it.classSeen[cls] then
              it.classSeen[cls] = true; table.insert(it.classes, cls)
            end
          end)
        end
      end
    end
  end
  for _, key in ipairs(issueOrder) do
    local it = pathIssues[key]
    -- relevé seulement avec les étapes de certaines classes : on les nomme
    local cls = (not it.base and #it.classes > 0) and (", class: " .. table.concat(it.classes, ",")) or ""
    bad(it.path, it.line, ("%s (race path: %s%s)"):format(it.msg, table.concat(it.races, ","), cls))
  end

  local rungKeys = M.rungKeys(opts.guides)
  for _, g in ipairs(guides) do
    local def, path = g.def, g.path
    local faction = def.faction
    if faction ~= "Alliance" and faction ~= "Horde" then bad(path, 0, "invalid faction " .. tostring(faction)) end
    if def.mode ~= nil and def.mode ~= "dungeon" then bad(path, 0, "invalid mode " .. tostring(def.mode)) end
    local d = D(faction == "Horde" and "Horde" or "Alliance")
    local chapterRaces = def.races or FACTION_RACES[faction] or FACTION_RACES.Alliance
    local seenAccept, seenTurnin = {}, {}
    if type(def.steps) ~= "table" or #def.steps == 0 then bad(path, 0, "guide has no steps") end
    for k, s in ipairs(def.steps or {}) do
      local line = g.lines[k] or 0
      if type(s) ~= "table" then bad(path, line, "step is not a table")
      else
        local action = s[1]
        if not VALID[action] then bad(path, line, "invalid action " .. tostring(action))
        else
          local function checkPoint(m, x, y, label)
            if type(m) ~= "number" or not W.maps[m] or not W.maps[m].continent then
              bad(path, line, ("%s on unknown uiMap %s"):format(label, tostring(m)))
            elseif type(x) ~= "number" or type(y) ~= "number" or x < 0 or x > 100 or y < 0 or y > 100 then
              bad(path, line, ("%s coordinates out of 0-100: %s, %s"):format(label, tostring(x), tostring(y)))
            end
          end
          local classesErr = M.classesProblem(s.classes)
          if classesErr then bad(path, line, classesErr) end
          local rungErr = M.rungProblem(s, def.mode, rungKeys)
          if rungErr then bad(path, line, rungErr) end
          if s.at then checkPoint(s.at[1], s.at[2], s.at[3], "at") end
          if POINT_ACTIONS[action] then checkPoint(s[2], s[3], s[4], action) end
          if (action == "hearth" or action == "fly") and (type(s[2]) ~= "number" or not W.maps[s[2]]) then
            bad(path, line, action .. " to unknown uiMap " .. tostring(s[2]))
          end
          -- vol : nœud de destination (TaxiNodes.ID = nodeID de C_TaxiMap) présent sur la carte de destination
          if action == "fly" then
            local n = s.node
            if n == nil then bad(path, line, "fly step without node")
            elseif type(n) ~= "number" or not W.taxi.nodes[n] then bad(path, line, "fly to unknown flight node " .. tostring(n))
            else
              local node, m = W.taxi.nodes[n], W.maps[s[2]]
              local x, y
              if m and m.continent == node.continent then x, y = W.fromWorld(s[2], node.wx, node.wy) end
              if not x or x < 0 or x > 100 or y < 0 or y > 100 then
                bad(path, line, ("flight node %d (%s) is not on uiMap %s"):format(n, node.name, tostring(s[2])))
              end
            end
          end
          if action == "level" and type(s[2]) ~= "number" then bad(path, line, "level step without a level") end
          if action == "note" and type(s[2]) ~= "string" then bad(path, line, "note step without text") end
          if QUEST_ACTIONS[action] then
            local qid = s[2]
            local q = type(qid) == "number" and d.quests[qid]
            if not q then
              bad(path, line, "unknown quest " .. tostring(qid))
            else
              local races = s.race or chapterRaces
              local ok = (q.races or 0) == 0
              for _, r in ipairs(races) do
                local b = raceBit(r, faction)
                if b and qdb.hasBit(q.races, b) then ok = true end
              end
              if not ok then bad(path, line, ("quest %d not available to %s"):format(qid, table.concat(races, ","))) end
              -- étape de classe : chaque classe nommée doit pouvoir faire la quête
              if not classesErr and (q.classes or 0) ~= 0 then
                for _, c in ipairs(classNames(s.classes) or {}) do
                  if not qdb.hasBit(q.classes, KNOWN_CLASSES[c]) then
                    bad(path, line, ("quest %d not available to class %s"):format(qid, c))
                  end
                end
              end
              -- guide hors de tout parcours de race : contrôle limité au chapitre lui-même
              if not onPath[def.id] then
                if action == "accept" then
                  if seenTurnin[qid] then bad(path, line, ("accept after turnin of quest %d"):format(qid)) end
                  seenAccept[qid] = true
                else
                  if not seenAccept[qid] and #(q.starters.items or {}) == 0 then
                    bad(path, line, ("%s without accept (quest %d)"):format(action, qid))
                  end
                  if action == "turnin" then seenTurnin[qid] = true end
                end
              end
            end
          end
        end
      end
    end
  end

  for _, v in ipairs(violations) do print(v) end
  if #violations > 0 then
    print(("%d violation(s) in %d guide file(s)"):format(#violations, #guides))
    return 1
  end
  print(("OK: %d guide file(s), no violation"):format(#guides))
  return 0
end

if select(1, ...) == "--as-module" then return M end
os.exit(M.run(arg or {}))
