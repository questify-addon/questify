-- Tests de la touche qui marque les monstres d'objectif visibles (Q.UI.RaidMarks).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

local HEAD = "/stopmacro [combat]\n"

local function load(opts)
  Ext.install()
  opts = opts or {}
  opts.extraFiles = opts.extraFiles or { GUIDES }
  if opts.skipGuides == nil then opts.skipGuides = true end
  return Mock.loadAddon(TOC, opts)
end

local function acceptWolves()
  Mock.quests.log[179] = { objectives = { { text = "Tough Wolf Meat: 0/8", finished = false } } }
  Mock.fire("QUEST_ACCEPTED", 179)
end

-- npcId 705 : monstre de l'objectif de la quête 179 ; 707 : autre monstre.
local function addPlate(unit, npcId, extra)
  local u = { npcId = npcId, name = "Ragged Young Wolf", level = 1, hostile = true }
  for k, v in pairs(extra or {}) do u[k] = v end
  Mock.units[unit] = u
  Mock.nameplates[unit] = CreateFrame("Frame", nil, WorldFrame)
  Mock.fire("NAME_PLATE_UNIT_ADDED", unit)
end

local function removePlate(unit)
  Mock.units[unit], Mock.nameplates[unit] = nil, nil
  Mock.fire("NAME_PLATE_UNIT_REMOVED", unit)
end

local function macro() return QuestifyMarkObjectives:GetAttribute("macrotext") end

-- Macros du jeu simulées (comme tests/test_classguide.lua) : macros.acc et macros.char.
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
  ShowMacroFrame = function() Mock.record("ShowMacroFrame") end
  GetFileIDFromPath = opts.files and function(path) return opts.files[path] end or nil
end

local function enable(Q, inGroup)
  Q.Settings:Set("raidMarks.enabled", true)
  if inGroup ~= nil then Q.Settings:Set("raidMarks.inGroup", inGroup) end
  Mock.advance(0.3)
end

return {
  hidden_button_off_by_default = function(t)
    local Q = load()
    acceptWolves()
    addPlate("nameplate1", 705)
    Mock.advance(0.3)
    local b = QuestifyMarkObjectives
    t.ok(b, "hidden button for the key binding")
    t.eq(b._template, "SecureActionButtonTemplate")
    t.eq(b:GetAttribute("type"), "macro")
    t.ok(not b:IsShown())
    t.eq(macro(), "", "does nothing while the option is off")
    t.eq(Q.Settings:Get("raidMarks.enabled"), false)
    t.eq(Q.Settings:Get("raidMarks.inGroup"), false)
    t.eq(_G["BINDING_NAME_CLICK QuestifyMarkObjectives:LeftButton"], Q.L.UI_RAIDMARKS_BINDING)
    t.eq(#Mock.errors, 0)
  end,

  binding_and_options_declared = function(t)
    local Q = load()
    local f = io.open(Mock.root .. "/Questify/Bindings.xml")
    local xml = f:read("*a"); f:close()
    t.ok(xml:find('name="CLICK QuestifyMarkObjectives:LeftButton"', 1, true), "binding in Bindings.xml")
    local byId = {}
    for _, e in ipairs(Q.OptionsSchema.entries) do byId[e.id] = e end
    t.eq(byId["raidMarks.enabled"].type, "toggle")
    t.eq(byId["raidMarks.enabled"].category, "targeting")
    t.eq(byId["keyRaidMarks"].binding, "CLICK QuestifyMarkObjectives:LeftButton")
    t.eq(byId["raidMarks.inGroup"].type, "toggle")
    for _, key in ipairs({ "OPT_RAIDMARKS", "OPT_TIP_RAIDMARKS", "OPT_KEY_RAIDMARKS", "OPT_TIP_KEY_RAIDMARKS",
      "OPT_RAIDMARKS_GROUP", "OPT_TIP_RAIDMARKS_GROUP", "UI_RAIDMARKS_BINDING" }) do
      t.ok(type(Q.L[key]) == "string" and Q.L[key] ~= key, key)
    end
  end,

  macro_follows_visible_objective_plates = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    t.eq(macro(), "", "no plate")
    addPlate("nameplate1", 705)
    addPlate("nameplate2", 707)              -- pas un monstre d'objectif
    addPlate("nameplate3", 705)
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate1,harm] ~8\n/tm [@nameplate3,harm] ~7", "skull then cross")
    removePlate("nameplate1")
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate3,harm] ~8")
    -- objectif terminé : plus rien à marquer
    Mock.quests.log[179] = { complete = true, objectives = { { text = "Tough Wolf Meat: 8/8", finished = true } } }
    Mock.fire("QUEST_LOG_UPDATE")
    Mock.advance(0.6)                        -- délai de la progression, puis celui de la réécriture
    t.eq(macro(), "", "objective done")
    t.eq(#Mock.errors, 0)
  end,

  rewrites_are_grouped = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    addPlate("nameplate1", 705)
    addPlate("nameplate2", 705)
    addPlate("nameplate3", 705)
    t.eq(macro(), "", "not yet: grouped with a short delay")
    Mock.advance(0.3)
    t.ok(macro():find("nameplate3", 1, true), "one rewrite for the three plates")
  end,

  icons_already_taken_are_skipped = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    Mock.units.target = { npcId = 707, hostile = true, raidMark = 8 }   -- crâne déjà posé ailleurs
    addPlate("nameplate1", 705, { raidMark = 7 })                       -- déjà marqué : laissé tel quel
    addPlate("nameplate2", 705)
    Mock.fire("RAID_TARGET_UPDATE")
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate2,harm] ~3", "first free icon: diamond")
    Mock.units.target.raidMark = nil
    Mock.fire("RAID_TARGET_UPDATE")
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate2,harm] ~8", "skull free again")
  end,

  tapped_dead_friendly_and_secret_skipped = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    addPlate("nameplate1", 705, { tapDenied = true })
    addPlate("nameplate2", 705, { dead = true })
    addPlate("nameplate3", 705, { hostile = false })
    addPlate("nameplate4", Mock.secret(705))
    addPlate("nameplate5", 705, { tapDenied = Mock.secret(false) })
    addPlate("nameplate6", 705, { raidMark = Mock.secret(nil) })
    Mock.advance(0.3)
    t.eq(macro(), "")
    addPlate("nameplate7", 705)
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate7,harm] ~8")
    t.eq(#Mock.errors, 0, "no error on secret values")
  end,

  nothing_changes_in_combat = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    addPlate("nameplate1", 705)
    Mock.advance(0.3)
    local before = macro()
    t.ok(before:find("^/stopmacro %[combat%]\n"), "macro stops in combat")
    local calls = Ext.spyCombat({ QuestifyMarkObjectives })
    Mock.player.combat = true
    addPlate("nameplate2", 705)
    removePlate("nameplate1")
    Mock.fire("RAID_TARGET_UPDATE")
    Q.Settings:Set("raidMarks.enabled", false)
    Mock.advance(0.3)
    t.eq(calls, {})
    t.eq(macro(), before, "untouched in combat")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.eq(macro(), "", "rewritten right after combat")
    Q.Settings:Set("raidMarks.enabled", true)
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate2,harm] ~8")
  end,

  group_and_instance_off_by_default = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    addPlate("nameplate1", 705)
    Mock.player.group = true
    Mock.fire("GROUP_ROSTER_UPDATE")
    Mock.advance(0.3)
    t.eq(macro(), "", "nothing in a group")
    Q.Settings:Set("raidMarks.inGroup", true)
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate1,harm] ~8", "allowed in a group")
    Q.Settings:Set("raidMarks.inGroup", false)
    Mock.player.group = false
    Mock.player.instance = true
    Mock.fire("PLAYER_ENTERING_WORLD")
    Mock.advance(0.3)
    t.eq(macro(), "", "nothing in an instance")
    Mock.player.instance = false
    Mock.fire("PLAYER_ENTERING_WORLD")
    Mock.advance(0.3)
    t.eq(macro(), HEAD .. "/tm [@nameplate1,harm] ~8", "solo again")
  end,

  option_off_clears_the_macro = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    addPlate("nameplate1", 705)
    Mock.advance(0.3)
    t.ok(macro() ~= "")
    Q.Settings:Set("raidMarks.enabled", false)
    Mock.advance(0.3)
    t.eq(macro(), "")
  end,

  eight_marks_at_most_within_255_chars = function(t)
    local Q = load()
    acceptWolves()
    enable(Q)
    for i = 30, 41 do addPlate("nameplate" .. i, 705) end
    Mock.advance(0.3)
    local m = macro()
    t.ok(#m <= 255, #m)
    local icons = {}
    for icon in m:gmatch("~(%d)") do icons[#icons + 1] = tonumber(icon) end
    t.eq(icons, { 8, 7, 3, 6, 5, 4, 2, 1 }, "skull, cross, diamond… one each")
    t.ok(m:find("@nameplate30,", 1, true) and m:find("@nameplate37,", 1, true))
    t.ok(not m:find("@nameplate38,", 1, true), "past 8 left out")
    -- découpe pure : la limite de longueur est tenue même avec des lignes longues
    local list = {}
    for i = 1, 8 do list[i] = { unit = "nameplate" .. (1000 + i), icon = i } end
    local long = Q.UI.RaidMarks:BuildMacro(list)
    t.ok(#long <= 255, #long)
    t.ok(long:find("^/stopmacro %[combat%]\n/tm %[@nameplate1001,harm%] ~1"))
    t.eq(Q.UI.RaidMarks:BuildMacro({}), "")
  end,

  macro_created_with_marker_icon_and_message = function(t)
    installMacros({ files = { ["Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"] = 137008 } })
    local Q = load()
    local R = Q.UI.RaidMarks
    t.eq(R:HasMacro(), false)
    local state = R:CreateMacroAndTell()
    t.eq(state, "created")
    t.eq(macros.acc[1], { name = Q.L.UI_RAIDMARKS_MACRO_NAME, icon = 137008, body = "/click QuestifyMarkObjectives" },
      "account macro, raid marker icon")
    t.ok(#Q.L.UI_RAIDMARKS_MACRO_NAME <= 16, "macro name fits")
    t.eq(Q.Settings:Get("raidMarks.enabled"), true, "the macro turns the option on")
    t.eq(Mock.countPrinted("/macro"), 1, "tells where to get it")
    t.eq(R:HasMacro(), true)
    t.eq(R:CreateMacroAndTell(), "exists", "no duplicate")
    t.eq(Mock.countCalls("CreateMacro"), 1)
    t.eq(#Mock.errors, 0)
  end,

  macro_icon_fallbacks = function(t)
    installMacros({ files = { ["Interface\\Icons\\INV_Misc_Spyglass_03"] = 134441 } })
    local Q = load()
    t.eq(Q.UI.RaidMarks:MacroIcon(), 134441, "spyglass when the marker texture is missing")
    GetFileIDFromPath = nil
    t.eq(Q.UI.RaidMarks:MacroIcon(), "INV_Misc_Spyglass_03", "icon name without the file API")
  end,

  macro_full_combat_and_character_slots = function(t)
    installMacros({ accUsed = 120 })
    local Q = load()
    local R = Q.UI.RaidMarks
    t.eq(R:CreateMacro(), "created", "character macros when the account ones are full")
    t.eq(#macros.char, 1)
    installMacros({ accUsed = 120, charUsed = 18 })
    t.eq(R:CreateMacro(), "full")
    t.ok(R:MacroMessage("full"):find("/macro", 1, true), "full: says to make room")
    installMacros()
    Mock.player.combat = true
    t.eq(R:CreateMacro(), "combat")
    t.eq(Mock.countCalls("CreateMacro"), 1, "only the character macro was created")
    Mock.player.combat = false
    CreateMacro = nil
    t.eq(R:CreateMacro(), "noapi")
    t.eq(#Mock.errors, 0)
  end,

  options_button_creates_the_macro = function(t)
    installMacros()
    local Q = load()
    local e = Q.OptionsSchema:Entry("raidMarksMacro")
    t.eq(e.type, "action")
    t.eq(e.category, "targeting")
    e.run()
    t.eq(macros.acc[1].body, "/click QuestifyMarkObjectives")
  end,
}
