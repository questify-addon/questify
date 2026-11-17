-- Tests des anciens rangs sur les barres d'action (Q.ActionRanks) et de leur assistant (Q.UI.RanksWizard).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"
local Ext = dofile(Mock.root .. "/tests/mock_ext_d.lua")

-- Sorts du guerrier : id -> { nom, rang }
local SPELLS = {
  [78] = { "Heroic Strike", 1 }, [284] = { "Heroic Strike", 2 }, [285] = { "Heroic Strike", 3 },
  [772] = { "Rend", 1 }, [6546] = { "Rend", 2 },
  [6673] = { "Battle Shout", 1 }, [5242] = { "Battle Shout", 2 },
  [100] = { "Charge", 1 },
  [2457] = { "Battle Stance", nil },
}

local book    -- ids du grimoire
local slots   -- emplacement -> { kind, id }
local cursor  -- { kind, id } ou nil

local function installApi()
  book = { 78, 772, 6673, 100, 2457 }
  slots = {}
  cursor = nil
  C_Spell = {
    GetSpellName = function(id) return SPELLS[id] and SPELLS[id][1] end,
    GetSpellSubtext = function(id) local s = SPELLS[id]; return s and s[2] and ("Rank " .. s[2]) or "" end,
    GetSpellTexture = function(id) return 130000 + id end,
    GetSpellLink = function(id) return SPELLS[id] and ("[" .. SPELLS[id][1] .. "]") end,
    PickupSpell = function(id) cursor = { "spell", id } end,
  }
  GetNumSpellTabs = function() return 1 end
  GetSpellTabInfo = function() return "General", nil, 0, #book end
  GetSpellBookItemInfo = function(i) if book[i] then return "SPELL", book[i] end end
  HasAction = function(slot) return slots[slot] ~= nil end
  GetActionInfo = function(slot) local a = slots[slot]; if a then return a[1], a[2] end end
  GetCursorInfo = function() return cursor and cursor[1] end
  ClearCursor = function() cursor = nil end
  PlaceAction = function(slot)
    Mock.record("PlaceAction", slot)
    if InCombatLockdown() then error("ADDON_ACTION_BLOCKED PlaceAction") end
    local old = slots[slot]
    slots[slot] = cursor
    cursor = old
    Mock.fire("ACTIONBAR_SLOT_CHANGED", slot)
  end
end

local function load(opts)
  Ext.install()
  installApi()
  local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true })
  if not (opts and opts.notReady) then Mock.advance(Q.ActionRanks.LOGIN_DELAY + 0.1) end
  return Q
end

-- Achat chez le maître : le rang rejoint le grimoire (à la place de l'ancien), SPELLS_CHANGED.
local function learn(Q, id, replaces)
  for i, b in ipairs(book) do
    if b == replaces then table.remove(book, i); break end
  end
  book[#book + 1] = id
  Mock.fire("SPELLS_CHANGED")
  Mock.advance(Q.ActionRanks.SETTLE + 0.1)
end

local function spell(id) return { "spell", id } end

return {
  scan_lists_only_lower_ranks_of_known_spells = function(t)
    local Q = load()
    slots[1] = spell(78); slots[30] = spell(78)      -- Heroic Strike rang 1, deux boutons
    slots[2] = spell(772)                             -- Rend rang 1, déjà le meilleur
    slots[3] = { "macro", 5 }                         -- macro : jamais
    slots[4] = { "item", 6948 }                       -- objet : jamais
    slots[5] = spell(2457)                            -- sans rang
    book = { 284, 772, 6673, 100, 2457 }              -- Heroic Strike rang 2 appris
    local list, n = Q.ActionRanks:Scan()
    t.eq(#list, 1)
    t.eq(n, 2)
    t.eq(list[1].id, 78); t.eq(list[1].bestId, 284)
    t.eq(list[1].have, 1); t.eq(list[1].best, 2)
    t.eq(list[1].slots, { 1, 30 })
    t.eq(list[1].icon, 130078)
    t.eq(#Mock.errors, 0)
  end,

  slot_place_names_bar_and_button = function(t)
    local Q = load()
    t.eq({ Q.ActionRanks.SlotPlace(1) }, { 1, 1 })
    t.eq({ Q.ActionRanks.SlotPlace(12) }, { 1, 12 })
    t.eq({ Q.ActionRanks.SlotPlace(30) }, { 3, 6 })
    t.eq(Q.ActionRanks.SlotsText({ 3, 31 }), "bar 1 (button 3), bar 3 (button 7)")
  end,

  training_opens_wizard_and_modify_replaces_only_its_slots = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78); slots[30] = spell(78); slots[2] = spell(6673); slots[7] = spell(284)
    learn(Q, 284, 78)
    t.ok(W:IsShown(), "wizard after training")
    t.eq(W.title:GetText(), Q.L.RANKS_TITLE_ONE)
    t.eq(W.applyButton:GetText(), "Update Heroic Strike rank 1")
    t.eq(W.ignoreButton:GetText(), "Ignore Heroic Strike rank 1")
    t.eq(W.applyAllButton:GetText(), "Apply all (1)")
    W.applyButton:Click()
    t.eq(slots[1], spell(284)); t.eq(slots[30], spell(284))
    t.eq(slots[2], spell(6673), "other spell untouched")
    t.eq(slots[7], spell(284))
    t.eq(cursor, nil, "cursor left empty")
    t.ok(Mock.printed("2 action buttons updated:"))
    t.ok(Mock.printed("[Heroic Strike] rank 1 to 2: bar 1 (button 1), bar 3 (button 6)"))
    t.ok(not W:IsShown(), "nothing left: closed")
    t.eq(#Mock.errors, 0)
  end,

  wizard_steps_with_arrows_and_icons = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78); slots[2] = spell(772); slots[3] = spell(6673)
    book = { 284, 6546, 5242, 100, 2457 }
    Mock.fire("SPELLS_CHANGED")
    Mock.advance(Q.ActionRanks.SETTLE + 0.1)
    t.ok(W:IsShown())
    t.eq(W.title:GetText(), "3 spells at an old rank")
    t.eq(W.pos:GetText(), "1 / 3")
    t.ok(W.icons[1].mark:IsShown() and not W.icons[2].mark:IsShown(), "first spell highlighted")
    t.ok(not W.prev:IsEnabled() and W.next:IsEnabled())
    W.next:Click()
    t.eq(W.name:GetText(), "Rend")
    t.eq(W.pos:GetText(), "2 / 3")
    W.icons[3]:Click()
    t.eq(W.name:GetText(), "Battle Shout")
    t.ok(not W.next:IsEnabled())
    W.prev:Click()
    t.eq(W.name:GetText(), "Rend")
    t.eq(W.rank:GetText(), "Rank 1 on your bars, rank 2 learned")
    t.eq(W.slots:GetText(), "1 button: bar 1 (button 2)")
  end,

  decided_spells_leave_and_all_buttons_cover_the_rest = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78); slots[2] = spell(772); slots[3] = spell(6673)
    book = { 284, 6546, 5242, 100, 2457 }
    Mock.fire("SPELLS_CHANGED")
    Mock.advance(Q.ActionRanks.SETTLE + 0.1)
    W.next:Click()                 -- Rend
    W.ignoreButton:Click()         -- garde Rend rang 1
    t.ok(Mock.printed("Kept at their rank: [Rend] rank 1."))
    t.eq(W.title:GetText(), "2 spells at an old rank")
    t.eq(W.name:GetText(), "Battle Shout", "next spell takes its place")
    t.eq(W.applyAllButton:GetText(), "Apply all (2)")
    W.applyAllButton:Click()
    t.eq(slots[1], spell(284)); t.eq(slots[3], spell(5242))
    t.eq(slots[2], spell(772), "ignored spell left at its rank")
    t.ok(not W:IsShown())
    -- Rend ignoré n'est plus proposé…
    t.eq(#Q.ActionRanks:Scan(), 0)
    -- …sauf pour un rang encore plus haut
    SPELLS[11572] = { "Rend", 3 }
    learn(Q, 11572, 6546)
    t.ok(W:IsShown(), "higher rank offered again")
    t.eq(W.rank:GetText(), "Rank 1 on your bars, rank 3 learned")
    SPELLS[11572] = nil
  end,

  ignore_all_keeps_every_remaining_spell = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78); slots[2] = spell(772)
    book = { 284, 6546, 6673, 100, 2457 }
    Mock.fire("SPELLS_CHANGED")
    Mock.advance(Q.ActionRanks.SETTLE + 0.1)
    W.ignoreAllButton:Click()
    t.eq(Mock.countCalls("PlaceAction"), 0)
    t.ok(not W:IsShown())
    t.eq(Q.char.actionRanks.ignored[78], 284)
    t.eq(Q.char.actionRanks.ignored[772], 6546)
    Q.ActionRanks:ForgetIgnored()
    t.eq(#Q.ActionRanks:Scan(), 2, "offered again after forgetting")
  end,

  combat_queues_until_combat_ends = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78)
    learn(Q, 284, 78)
    t.ok(W:IsShown())
    Mock.player.combat = true
    Mock.fire("PLAYER_REGEN_DISABLED")
    t.ok(W.combat:IsShown(), "combat note")
    W.applyButton:Click()
    t.eq(Mock.countCalls("PlaceAction"), 0, "nothing during combat")
    t.ok(Mock.printed(Q.L.RANKS_COMBAT))
    t.eq(slots[1], spell(78))
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    Mock.advance(1)
    t.eq(slots[1], spell(284), "applied after combat")
    t.ok(Mock.printed("1 action button updated:"))
    t.eq(#Mock.errors, 0)
  end,

  no_check_during_combat_and_busy_cursor_refused = function(t)
    local Q = load()
    local W = Q.UI.RanksWizard
    slots[1] = spell(78)
    Mock.player.combat = true
    learn(Q, 284, 78)
    t.ok(not W:IsShown(), "not during combat")
    Mock.player.combat = false
    t.ok(Q.ActionRanks:Check(true))
    t.ok(W:IsShown())
    cursor = { "item", 6948 }
    W.applyButton:Click()
    t.ok(Mock.printed(Q.L.RANKS_CURSOR))
    t.eq(slots[1], spell(78), "nothing placed")
    t.ok(W:IsShown(), "spell still offered")
    t.eq(cursor, { "item", 6948 }, "player's cursor untouched")
  end,

  slot_changed_by_player_is_reread = function(t)
    local Q = load()
    slots[1] = spell(78)
    learn(Q, 284, 78)
    slots[1] = spell(100)          -- le joueur y a mis Charge entre-temps
    Q.UI.RanksWizard.applyButton:Click()
    t.eq(slots[1], spell(100), "slot re-read before placing")
    t.ok(Mock.printed(Q.L.RANKS_NOTHING))
  end,

  login_does_not_open_and_option_off = function(t)
    local Q = load({ notReady = true })
    slots[1] = spell(78)
    book = { 284, 772, 6673, 100, 2457 }
    Mock.fire("SPELLS_CHANGED")
    Mock.advance(1.5)
    t.ok(not Q.UI.RanksWizard:IsShown(), "spellbook loading at login")
    Mock.advance(Q.ActionRanks.LOGIN_DELAY)
    Mock.fire("SPELLS_CHANGED")
    Mock.advance(1.5)
    t.ok(not Q.UI.RanksWizard:IsShown(), "same list as at login: not offered")
    Q.Settings:Set("oldRanks", false)
    SPELLS[11572] = { "Rend", 3 }
    slots[2] = spell(772)
    learn(Q, 11572, 772)
    t.ok(not Q.UI.RanksWizard:IsShown(), "option off")
    SPELLS[11572] = nil
  end,

  slash_command_opens_wizard = function(t)
    local Q = load()
    slots[1] = spell(78)
    book = { 284, 772, 6673, 100, 2457 }
    SlashCmdList.QUESTIFY("ranks")
    t.ok(Q.UI.RanksWizard:IsShown())
    Q.UI.RanksWizard:Hide()
    slots[1] = spell(284)
    SlashCmdList.QUESTIFY("rangs")
    t.ok(Mock.printed(Q.L.RANKS_NONE))
  end,

  french_strings = function(t)
    Mock.locale = "frFR"
    local Q = load()
    slots[1] = spell(78)
    learn(Q, 284, 78)
    local W = Q.UI.RanksWizard
    t.eq(W.applyButton:GetText(), "Modifier Heroic Strike rang 1")
    t.eq(W.applyAllButton:GetText(), "Appliquer tous (1)")
    t.eq(W.slots:GetText(), "1 bouton : barre 1 (bouton 1)")
  end,
}
