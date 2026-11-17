-- Tests de l'onglet Classe : données générées (Data/ClassGuides.lua, Data/ClassMacros.lua,
-- Data/ClassText_*.lua), guide de talents (Engine/ClassGuide.lua), macros (Engine/ClassMacros.lua),
-- panneau des options (UI/ClassPanel.lua) et encart « point de talent » (UI/TalentAdvice.lua).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")
local Traits = dofile(Mock.root .. "/tests/mock_ext_traits.lua")

local CLASSES = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID" }

-- Données brutes, sans l'addon (toutes les classes, aucune taille réduite).
local function rawData(locale)
  local ns = {}
  local saved = GetLocale
  GetLocale = function() return locale or "enUS" end
  for _, f in ipairs({ "ClassGuides", "ClassMacros", "ClassText_frFR", "ClassText_deDE", "ClassText_esES" }) do
    assert(loadfile(Mock.root .. "/Questify/Data/" .. f .. ".lua"))("Questify", ns)
  end
  GetLocale = saved
  return ns
end

local function readFile(p)
  local f = assert(io.open(Mock.root .. "/" .. p, "rb"))
  local s = f:read("*a")
  f:close()
  return s
end

-- Arbre C_Traits simulé d'après les données de la classe ; ranks[spellID], unspent.
local function installTree(cf, ranks, unspent)
  local data = rawData().ClassGuideData[cf]
  local groups = {}
  for _, s in ipairs(data) do
    local talents = {}
    for _, n in ipairs(s.nodes) do talents[#talents + 1] = { n.spell, n.row + 1, n.col + 1, n.max } end
    groups[s.group] = { name = s.name, talents = talents }
  end
  return Traits.install({ groups = groups, ranks = ranks or {}, unspent = unspent or 0 })
end

-- Rangs du guide au niveau donné (points des niveaux 10 à level).
local function ranksAt(spec, level)
  local out = {}
  for i, spellID in ipairs(spec.steps) do
    if 9 + i <= level then out[spellID] = (out[spellID] or 0) + 1 end
  end
  return out
end

local function frostSpec()
  for _, s in ipairs(rawData().ClassGuideData.MAGE) do
    if s.key == "frost" then return s end
  end
end

-- Macros du jeu simulées.
local macros
local function installMacros(opts)
  opts = opts or {}
  macros = { acc = {}, char = {} }
  local function all()
    local out = {}
    for _, m in ipairs(macros.acc) do out[#out + 1] = m end
    for _, m in ipairs(macros.char) do out[#out + 1] = m end
    return out
  end
  MAX_ACCOUNT_MACROS, MAX_CHARACTER_MACROS = 120, 18
  GetNumMacros = function() return opts.accUsed or #macros.acc, opts.charUsed or #macros.char end
  GetMacroIndexByName = function(name)
    for i, m in ipairs(all()) do if m.name == name then return i end end
    return 0
  end
  GetMacroInfo = function(i)
    local m = all()[i]
    if m then return m.name, m.icon, m.body end
  end
  CreateMacro = function(name, icon, body, perChar)
    Mock.record("CreateMacro", name, icon, body, perChar)
    local list = perChar and macros.char or macros.acc
    list[#list + 1] = { name = name, icon = icon, body = body }
    return #list
  end
  EditMacro = function(i, name, icon, body)
    Mock.record("EditMacro", i, name, icon, body)
    local m = all()[i]
    if m then m.body = body; m.name = name or m.name end
    return i
  end
end

local FR = { [116] = "Éclair de givre", [122] = "Nova de givre", [30455] = "Javelot de glace", [2139] = "Contresort" }

local function load(opts)
  opts = opts or {}
  Ext.install()
  Mock.player.classFile = opts.class or "MAGE"
  Mock.player.level = opts.level or 23
  if opts.locale then Mock.locale = opts.locale end
  installTree(Mock.player.classFile, opts.ranks, opts.unspent)
  installMacros(opts.macros)
  local names = opts.spellNames
  C_Spell = C_Spell or {}
  C_Spell.GetSpellName = function(id)
    if names and names[id] then return names[id] end
    return nil
  end
  return Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true })
end

return {
  ---------------------------------------------------------------------------
  -- Données générées
  ---------------------------------------------------------------------------
  data_has_three_guides_per_class_with_a_point_per_level = function(t)
    local d = rawData().ClassGuideData
    t.eq(d.source.license, "CC BY 4.0")
    for _, cf in ipairs(CLASSES) do
      t.eq(#d[cf], 3, cf .. " : trois spécialisations")
      local bySpell = {}
      for g, s in ipairs(d[cf]) do
        t.eq(s.group, g, cf .. " : arbres dans l'ordre du jeu")
        t.ok(s.url:match("^https://classicwowforever.com/class%-guides/"), "url " .. s.key)
        t.ok(#s.nodes >= 10, cf .. " " .. s.key .. " : arbre")
        for _, n in ipairs(s.nodes) do bySpell[n.spell] = n end
      end
      for _, s in ipairs(d[cf]) do
        t.eq(#s.steps, 51, cf .. " " .. s.key .. " : niveaux 10 à 60")
        local count = {}
        for _, spellID in ipairs(s.steps) do
          local n = bySpell[spellID]
          t.ok(n, cf .. " " .. s.key .. " : talent " .. spellID .. " dans un arbre")
          count[spellID] = (count[spellID] or 0) + 1
          t.ok(not n or count[spellID] <= n.max, "rang maximal " .. spellID)
        end
        t.ok(#s.stages > 5, "étapes commentées")
        for _, st in ipairs(s.stages) do t.ok(st.why ~= "", "explication " .. s.key .. " " .. st.level) end
      end
    end
  end,

  data_macros_by_class_with_origin_and_markers = function(t)
    local d = rawData().ClassMacroData
    local total, pvp = 0, 0
    for _, cf in ipairs(CLASSES) do
      local seen = {}
      for _, m in ipairs(d[cf]) do
        total = total + 1
        if m.pvp then pvp = pvp + 1 end
        t.ok(not seen[m.id], "id unique " .. m.id)
        seen[m.id] = true
        t.ok(m.origin == "classic" or m.origin == "adapted" or m.origin == "forever", "origine " .. m.id)
        t.ok(m.title ~= "" and m.use ~= "", "textes " .. m.id)
        -- texte anglais reconstruit : 255 caractères au plus
        local en = m.code:gsub("{([si])(%d+)}", function(k, id) return d.names[k .. id] or "?" end):gsub("{r}", "Rank")
        t.ok(#en <= 255, "longueur " .. m.id)
        for k in m.code:gmatch("{([si]%d+)}") do t.ok(d.names[k], "nom anglais de " .. k) end
      end
    end
    t.eq(total, 670)
    t.eq(pvp, 315)
  end,

  data_files_carry_the_attribution = function(t)
    for _, f in ipairs({ "ClassGuides", "ClassMacros", "ClassText_frFR", "ClassText_deDE", "ClassText_esES" }) do
      local s = readFile("Questify/Data/" .. f .. ".lua")
      t.ok(s:find("classicwowforever.com", 1, true), f .. " : source")
      t.ok(s:find("CC BY 4.0", 1, true), f .. " : licence")
      t.ok(s:find("creativecommons.org/licenses/by/4.0", 1, true), f .. " : lien de la licence")
      t.ok(s:find("Modifié par Questify", 1, true), f .. " : mention de modification")
      t.ok(s:find("GÉNÉRÉ par tools/classguides/build.py", 1, true), f .. " : généré")
    end
  end,

  data_french_texts_follow_the_english_order = function(t)
    local ns = rawData("frFR")
    local fr = ns.ClassGuideText
    t.ok(fr, "textes français chargés pour frFR")
    for _, cf in ipairs(CLASSES) do
      for _, s in ipairs(ns.ClassGuideData[cf]) do
        local g = fr[cf].guides[s.key]
        t.ok(g and g.name and g.tagline, cf .. " " .. s.key .. " : nom et accroche")
        t.eq(#g.why, #s.stages, cf .. " " .. s.key .. " : une explication par étape")
      end
    end
    t.ok(fr.MAGE.macros["class-wide-counterspell"].title:find("Contresort", 1, true), "macro traduite")
    t.eq(rawData("enUS").ClassGuideText, nil, "rien chargé pour un client anglais")
  end,

  ---------------------------------------------------------------------------
  -- Guide de talents
  ---------------------------------------------------------------------------
  next_point_follows_the_guide = function(t)
    local spec = frostSpec()
    local Q = load({ level = 23, ranks = ranksAt(spec, 22), unspent = 1 })
    local G = Q.ClassGuide
    local cur, how = G:Current()
    t.eq(cur.key, "frost")
    t.eq(how, "auto", "arbre où il a le plus de points")
    local st = G:State(cur)
    t.eq(st.next.level, 23)
    t.eq(st.next.spell, spec.steps[14])
    t.eq(st.next.rank, 3)
    t.ok(st.due, "un point à dépenser")
    t.eq(#st.extra, 0)
    t.eq(st.upcoming[1].from, 24)
    -- rangs consécutifs d'un même talent réunis (Fracasser, 26 à 28)
    local grouped
    for _, u in ipairs(st.upcoming) do if u.to > u.from then grouped = u end end
    t.ok(grouped and grouped.to - grouped.from == 2, "rangs consécutifs réunis")
    local a = G:Advice()
    t.eq(a.spell, spec.steps[14])
    t.ok(a.why ~= "", "explication du guide")
    t.eq(#Mock.errors, 0)
  end,

  choice_extra_ranks_and_no_unspent_point = function(t)
    local spec = frostSpec()
    local ranks = ranksAt(spec, 22)
    local blizzard
    for _, n in ipairs(spec.nodes) do if n.name == "Improved Blizzard" then blizzard = n.spell end end
    ranks[blizzard] = 1
    local Q = load({ level = 23, ranks = ranks, unspent = 0 })
    local G = Q.ClassGuide
    local st = G:State((G:Current()))
    t.ok(not st.due, "aucun point à dépenser")
    t.eq(G:Advice(), nil)
    t.eq(st.extra[1].spell, blizzard, "rang hors du guide")
    G:Choose("fire")
    local cur, how = G:Current()
    t.eq(cur.key, "fire")
    t.eq(how, "choice")
    t.eq(Q.char.classGuide.spec, "fire", "choix gardé pour le personnage")
  end,

  game_nodes_matched_by_name_when_the_spell_differs = function(t)
    local spec = frostSpec()
    local frostbite
    for _, n in ipairs(spec.nodes) do if n.name == "Frostbite" then frostbite = n end end
    local Q = load({ level = 23, ranks = ranksAt(spec, 22), unspent = 1,
      spellNames = { [frostbite.spell] = "Morsure de givre", [990001] = "Morsure de givre" } })
    -- l'arbre du jeu donne un autre sort de rang 1 au même talent
    local tree = Q.ClassGuide:Tree()
    local node = tree.nodes[frostbite.spell]
    tree.nodes[frostbite.spell] = nil
    node.spellID = 990001
    tree.nodes[990001] = node
    tree.qvMatch = nil
    local ranks = Q.ClassGuide:Ranks(tree)
    t.eq(ranks[frostbite.spell], 2, "rang lu par le nom")
  end,

  only_the_player_class_stays_in_memory = function(t)
    local Q = load({ class = "PRIEST" })
    t.ok(Q.ClassGuideData.PRIEST and Q.ClassMacroData.PRIEST, "classe du joueur")
    t.eq(Q.ClassGuideData.MAGE, nil)
    t.eq(Q.ClassMacroData.WARRIOR, nil)
    t.ok(Q.ClassMacroData.names, "noms gardés")
  end,

  ---------------------------------------------------------------------------
  -- Macros
  ---------------------------------------------------------------------------
  macro_text_uses_the_client_names = function(t)
    local Q = load({ locale = "frFR", spellNames = FR })
    local M = Q.ClassMacros
    local m
    for _, x in ipairs(M:All()) do if x.id == "frost-frostbolt" then m = x end end
    t.ok(m, "macro Éclair de givre rang 1")
    local body = M:Body(m)
    t.ok(body:find("Éclair de givre(Rang 1)", 1, true), "nom et rang traduits")
    t.ok(not body:find("{", 1, true), "plus de marqueur")
    t.eq(M:Text(m).title:sub(1, 15), "Ralentissement ")
    t.ok(#M:DefaultName(m) <= 16)
    t.eq(M:DefaultName(m):sub(1, 3), "QF ")
  end,

  filters_by_pvp_spec_and_origin = function(t)
    local Q = load()
    local M = Q.ClassMacros
    local c = M:Counts(false)
    t.eq(c.pve + c.pvp, #M:All())
    for _, m in ipairs(M:List({ pvp = true, spec = "frost" })) do t.ok(m.pvp and m.spec == "frost") end
    for _, m in ipairs(M:List({ pvp = false, spec = "class" })) do t.eq(m.spec, nil) end
    for _, m in ipairs(M:List({ origin = "forever" })) do t.eq(m.origin, "forever") end
    t.eq(#M:List({ pvp = false, spec = "frost" }), c.frost)
  end,

  create_update_and_limits = function(t)
    local Q = load({ spellNames = { [2139] = "Counterspell" } })
    local M = Q.ClassMacros
    local m
    for _, x in ipairs(M:All()) do if x.id == "class-wide-counterspell" then m = x end end
    t.eq(M:Status(m), "new")
    -- en combat : refusé
    Mock.player.combat = true
    local ok, why = M:Create(m, true)
    t.ok(not ok and why == "combat")
    Mock.player.combat = false
    ok = M:Create(m, true)
    t.ok(ok, "créée")
    local call = Mock.lastCall("CreateMacro")
    t.eq(call.args[3], "#showtooltip Counterspell\n/stopcasting\n/cast Counterspell")
    t.eq(call.args[4], true, "macro du personnage")
    t.eq(M:Status(m), "ok")
    -- le site change la macro : à mettre à jour
    m.code = m.code .. "\n/say {s2139}"
    t.eq(M:Status(m), "outdated")
    t.ok(M:Update(m))
    t.eq(Mock.countCalls("EditMacro"), 1)
    t.eq(M:Status(m), "ok")
    -- retouchée à la main
    macros.char[1].body = "/say hello"
    t.eq(M:Status(m), "edited")
    -- supprimée dans le jeu
    macros.char = {}
    t.eq(M:Status(m), "deleted")
    -- plus de place
    installMacros({ charUsed = 18, accUsed = 120 })
    local ok2, why2 = M:CanWrite(m, true, false)
    t.ok(not ok2 and why2 == "full")
    t.eq(#Mock.errors, 0)
  end,

  translates_a_macro_made_in_another_language = function(t)
    local names = { [2139] = "Contresort" }
    local Q = load({ spellNames = names })
    local M = Q.ClassMacros
    local m
    for _, x in ipairs(M:All()) do if x.id == "class-wide-counterspell" then m = x end end
    t.ok(M:Create(m, true))
    t.ok(not M:Foreign(m), "même langue : rien à traduire")
    -- retouche à la main, puis le jeu passe en anglais
    macros.char[1].body = macros.char[1].body .. "\n/say Contresort !"
    names[2139] = "Counterspell"
    t.eq(M:Status(m), "edited")
    t.ok(M:Foreign(m), "créée dans une autre langue")
    t.ok(M:Translate(m))
    t.eq(macros.char[1].body, "#showtooltip Counterspell\n/stopcasting\n/cast Counterspell\n/say Counterspell !")
    t.ok(not M:Foreign(m), "traduite")
    t.eq(M:Status(m), "edited", "la retouche à la main est gardée")
    -- sans retouche : la traduction la remet à jour
    macros.char[1].body = "#showtooltip Contresort\n/stopcasting\n/cast Contresort"
    Q.char.classMacros[m.id].body = macros.char[1].body
    t.ok(M:Foreign(m))
    t.ok(M:Translate(m))
    t.eq(M:Status(m), "ok")
    t.eq(#Mock.errors, 0)
  end,

  ---------------------------------------------------------------------------
  -- Panneau et encart
  ---------------------------------------------------------------------------
  class_section_shows_talents_then_macros = function(t)
    local spec = frostSpec()
    local Q = load({ level = 23, ranks = ranksAt(spec, 22), unspent = 1 })
    local O, P = Q.UI.Options, Q.UI.ClassPanel
    P:Open("talents")
    t.ok(O:IsShown() and O.section == "classguide")
    t.ok(P:IsShown(), "panneau à la place de la liste")
    t.ok(not O.scroll:IsShown(), "liste cachée")
    t.ok(O.sectionButtons[5].text:GetText():find(Q.L.OPT_SEC_CLASSGUIDE, 1, true))
    for i = 1, 3 do t.ok(P.cards[i]:IsShown(), "spé " .. i) end
    t.eq(P.cards[3].key, "frost")
    t.ok(P.cards[3].auto:IsShown(), "pastille « tes points »")
    t.ok(P.nextCard.name:GetText():find("3/3", 1, true), "point suivant")
    t.eq(P.nextHead.right:GetText(), Q.L.CLASS_UNSPENT_ONE)
    local shown = 0
    for _, n in ipairs(P.nodes) do if n:IsShown() then shown = shown + 1 end end
    t.eq(shown, #spec.nodes, "arbre Givre entier")
    local credit = P.talentCredit.text:GetText()
    t.ok(credit:find("CC BY 4.0", 1, true) and credit:find("classicwowforever.com", 1, true), "crédit")
    Mock.click(P.talentCredit)
    t.eq(P.copied, spec.url, "lien à copier")
    -- mode : « mes points » au départ ; clic sur une spé : choix gardé, badge « ton choix »
    t.eq(P.specMode.items[1].on, true, "following the points")
    Mock.click(P.cards[2])
    t.eq(Q.char.classGuide.spec, "fire")
    t.eq(P.specMode.items[2].on, true, "manual choice")
    t.eq(P.cards[2].auto.text:GetText(), Q.L.CLASS_SPEC_CHOSEN, "badge on the chosen spec")
    -- retour aux points
    Mock.click(P.specMode.items[1])
    t.eq(Q.char.classGuide.spec, nil, "back to the points")
    t.eq(P.cards[3].auto.text:GetText(), Q.L.CLASS_SPEC_AUTO)
    -- choix manuel par le sélecteur : la spé suivie devient le choix
    Mock.click(P.specMode.items[2])
    t.eq(Q.char.classGuide.spec, "frost")
    -- onglets de l'arbre : icône et points (le nom en infobulle), lisibles à leur largeur
    for i = 1, 3 do
      local b = P.treeTabs[i]
      t.ok(b.icon:IsShown(), "tab icon " .. i)
      t.ok(not b.label:GetText():find("%a"), "tab label: points only, got " .. tostring(b.label:GetText()))
    end
    Mock.click(P.cards[2])
    -- Macros
    P:ShowTab("macros")
    t.ok(P.macros:IsShown() and not P.talents:IsShown())
    t.ok(P.macroCards[1]:IsShown(), "cartes")
    Mock.click(P.macroCards[1].main)
    t.eq(Mock.countCalls("CreateMacro"), 1, "Créer")
    t.eq(P.macroCards[1].state.kind, "done")
    t.ok(P.macroCredit.text:GetText():find("CC BY 4.0", 1, true))
    t.ok(P.untested:GetText() ~= "", "mise en garde du site")
    -- filtre PvP
    Mock.click(P.fPvp.items[2])
    t.eq(Q.char.classGuide.macroPvp, true)
    for _, c in ipairs(P.macroCards) do
      if c:IsShown() then t.ok(c.macro.pvp, "PvP seulement") end
    end
    -- retour à une autre section : le panneau se cache
    O:SelectSection("loot")
    t.ok(not P:IsShown() and O.scroll:IsShown())
    t.eq(#Mock.errors, 0)
  end,

  french_client_reads_french_guide_texts = function(t)
    local spec = frostSpec()
    local Q = load({ locale = "frFR", level = 23, ranks = ranksAt(spec, 22), unspent = 1 })
    local P = Q.UI.ClassPanel
    P:Open("talents")
    t.eq(P.title:GetText(), string.format(Q.L.CLASS_TITLE, (UnitClass("player"))))
    local why = P.nextCard.why:GetText()
    t.ok(why ~= "" and why ~= spec.stages[1].why, "explication traduite")
    t.eq(P.cards[3].tag:GetText(), Q.ClassGuideText.MAGE.guides.frost.tagline, "accroche en français")
    t.eq(#Mock.errors, 0)
  end,

  level_up_box_names_the_next_talent = function(t)
    local spec = frostSpec()
    local Q = load({ level = 23, ranks = ranksAt(spec, 22), unspent = 1 })
    local A = Q.UI.TalentAdvice
    Mock.fire("PLAYER_LEVEL_UP", 23)
    Mock.advance(1.5)
    t.ok(A.frame and A.frame:IsShown(), "encart affiché")
    t.ok(A.name:GetText():find("3/3", 1, true))
    Mock.click(A.openButton)
    t.ok(not A.frame:IsShown(), "fermé")
    t.ok(Q.UI.Options:IsShown() and Q.UI.Options.section == "classguide", "guide ouvert")
    -- option désactivée : rien
    Q.Settings:Set("classGuide.levelUp", false)
    Mock.fire("PLAYER_LEVEL_UP", 23)
    Mock.advance(1.5)
    t.ok(not A.frame:IsShown(), "option désactivée")
    t.eq(#Mock.errors, 0)
  end,
}
