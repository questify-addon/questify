-- Tests de l'annonce d'amélioration d'équipement (Q.UI.UpgradePopup).
local TOC = "Questify/Questify.toc"
local GUIDES = "tests/fixtures/guide_fixture.lua"

local STR, STA, INT = "ITEM_MOD_STRENGTH_SHORT", "ITEM_MOD_STAMINA_SHORT", "ITEM_MOD_INTELLECT_SHORT"

local bags   -- { [bag] = { [slot] = lien } }
local equipped
local equipLands   -- faux : le jeu n'équipe rien (l'emplacement ne change pas)

local function installBags()
  bags = { [0] = {}, [1] = {}, [2] = {}, [3] = {}, [4] = {} }
  equipped = {}
  equipLands = true
  C_Container = {
    GetContainerNumSlots = function(bag) return bag == 0 and 16 or 0 end,
    GetContainerItemLink = function(bag, slot) return bags[bag] and bags[bag][slot] end,
  }
  -- un emplacement demandé est noté « lien@emplacement » ; l'objet quitte le sac pour l'emplacement
  C_Item.EquipItemByName = function(link, slot)
    equipped[#equipped + 1] = slot and (link .. "@" .. slot) or link
    if slot and equipLands then
      for s, l in pairs(bags[0]) do
        if l == link then bags[0][s] = nil; break end
      end
      Mock.inventory[slot] = link
    end
  end
end

local function item(id, def)
  def.id = id
  def.name = def.name or ("Item " .. id)
  def.link = "item:" .. id
  def.minLevel = def.minLevel or 0
  Mock.items[id] = def
  return def.link
end

local function load()
  local Q = Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true })
  installBags()
  Mock.player.level = 5
  Mock.fire("PLAYER_LEVEL_UP", 5)
  Q.UI.UpgradePopup.snapshot = Q.UI.UpgradePopup.ReadBags()
  -- porté : une chemise de mailles faible
  Mock.inventory[5] = item(3001, { name = "Worn Mail Vest", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
    stats = { [STR] = 1 } })
  return Q
end

local function receive(slot, link)
  bags[0][slot] = link
  Mock.fire("BAG_UPDATE_DELAYED")
end

-- Hache à deux mains portée, masse dans le sac (case 1), bouclier ramassé (case 3) : annonce de paire.
local function announcePair()
  local Q = load()
  Mock.inventory[16] = item(3070, { name = "Rusty Axe", equipLoc = "INVTYPE_2HWEAPON", classID = 2, subclassID = 1,
    stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4 } })
  receive(1, item(3071, { name = "Wooden Mace", equipLoc = "INVTYPE_WEAPON", classID = 2, subclassID = 4,
    stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3 } }))
  receive(3, item(3073, { name = "Wooden Shield", equipLoc = "INVTYPE_SHIELD", classID = 4, subclassID = 6,
    stats = { ["RESISTANCE0_NAME"] = 150, [STR] = 1 } }))
  assert(Q.UI.UpgradePopup.current and Q.UI.UpgradePopup.current.pair, "pair announced")
  return Q
end

local function shown(Q)
  local f = Q.UI.UpgradePopup.frame
  return f ~= nil and f:IsShown()
end

return {
  upgrade_announced_with_icon_and_text = function(t)
    local Q = load()
    receive(1, item(3002, { name = "Ringmail Hauberk", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
      texture = 132624, stats = { [STR] = 4, [STA] = 3 } }))
    local P = Q.UI.UpgradePopup
    t.ok(shown(Q), "popup in the middle of the screen")
    t.eq(P.icon:GetTexture(), 132624)
    t.eq(P.header:GetText(), Q.L.UI_UPGRADE_FOUND)
    t.ok(P.name:GetText():find("[Ringmail Hauberk]", 1, true), "item name")
    t.ok(P.gains:GetText():find("+3 Strength, +3 Stamina", 1, true), "what it improves (worn vest has 1 strength)")
    t.ok(P.instead:GetText():find("[Worn Mail Vest]", 1, true), "item it replaces")
    t.eq(P.counter:GetText(), "", "no counter for a single item")
    t.eq(P.equipButton.label:GetText(), Q.L.UI_UPGRADE_EQUIP)
    t.eq(P.noButton.label:GetText(), Q.L.UI_UPGRADE_NO)
    Mock.advance(4.9)
    t.ok(shown(Q), "still there before 5 seconds")
    Mock.advance(0.2)
    t.ok(not shown(Q), "closes by itself after 5 seconds")
    t.eq(#Mock.errors, 0)
  end,

  no_popup_for_worse_unusable_or_non_gear = function(t)
    local Q = load()
    receive(1, item(3003, { name = "Rusty Vest", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
      stats = {} }))
    t.ok(not shown(Q), "worse than what is worn")
    receive(2, item(3004, { name = "Silk Robe", equipLoc = "INVTYPE_ROBE", classID = 4, subclassID = 1,
      stats = { [INT] = 20 } }))
    t.ok(not shown(Q), "no strength for a warrior: no gain")
    receive(3, item(3005, { name = "Plate Chest", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 4,
      stats = { [STR] = 30 } }))
    t.ok(not shown(Q), "plate before level 40")
    receive(4, item(3006, { name = "Wolf Meat", equipLoc = "", classID = 7, subclassID = 8 }))
    t.ok(not shown(Q), "not gear")
  end,

  items_present_at_login_not_announced = function(t)
    Mock.loadAddon(TOC, { extraFiles = { GUIDES }, skipGuides = true })
    installBags()
    bags[0][1] = item(3010, { name = "Big Axe", equipLoc = "INVTYPE_2HWEAPON", classID = 2, subclassID = 1,
      stats = { [STR] = 10 } })
    local Q = Mock.reload()
    Mock.fire("BAG_UPDATE_DELAYED")
    t.ok(not shown(Q), "only new items")
  end,

  moving_items_is_not_new = function(t)
    local Q = load()
    local link = item(3011, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } })
    receive(1, link)
    Q.UI.UpgradePopup:Next()
    bags[0][1] = nil
    receive(5, link)
    t.ok(not shown(Q), "same item, other slot")
  end,

  click_equips_right_click_closes_queue_follows = function(t)
    local Q = load()
    local a = item(3020, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } })
    local b = item(3021, { name = "Ringmail Boots", equipLoc = "INVTYPE_FEET", classID = 4, subclassID = 3,
      stats = { [STA] = 2 } })
    bags[0][1], bags[0][2] = a, b
    Mock.fire("BAG_UPDATE_DELAYED")
    local P = Q.UI.UpgradePopup
    local first = P.current.link
    P.equipButton:Click()
    t.eq(equipped, { first }, "left click equips")
    t.ok(shown(Q), "next upgrade in the queue")
    t.ok(P.current.link ~= first)
    P.frame:GetScript("OnMouseUp")(P.frame, "RightButton")
    t.eq(#equipped, 1, "right click only closes")
    t.ok(not shown(Q))
  end,

  no_equip_in_combat = function(t)
    local Q = load()
    receive(1, item(3030, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    Mock.player.combat = true
    t.eq(Q.UI.UpgradePopup:EquipCurrent(), false)
    t.eq(equipped, {})
    Mock.player.combat = false
  end,

  waits_for_item_cache = function(t)
    local Q = load()
    receive(1, "item:3040")             -- pas encore en cache
    t.ok(not shown(Q))
    item(3040, { name = "Ringmail Belt", equipLoc = "INVTYPE_WAIST", classID = 4, subclassID = 3,
      stats = { [STR] = 3 } })
    Mock.advance(0.5)
    t.ok(shown(Q), "announced once the item is loaded")
  end,

  option_off = function(t)
    local Q = load()
    Q.Settings:Set("upgradePopup", false)
    receive(1, item(3050, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    t.ok(not shown(Q))
  end,

  -- Jamais affichée en combat : l'annonce attend la fin du combat.
  never_shown_in_combat_waits_for_regen = function(t)
    local Q = load()
    Mock.player.combat = true
    Mock.fire("PLAYER_REGEN_DISABLED")
    receive(1, item(3060, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    local P = Q.UI.UpgradePopup
    t.ok(not shown(Q), "not in combat")
    t.eq(#P.queue, 1, "queued")
    Mock.advance(10)
    t.eq(#P.queue, 1, "still waiting after the display time")
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(shown(Q), "shown after the fight")
    t.eq(P.current.link, "item:3060")
    t.eq(#Mock.errors, 0)
  end,

  -- Combat qui commence pendant l'annonce : cachée, remise en tête de file, puis de retour.
  fight_starting_hides_and_requeues = function(t)
    local Q = load()
    receive(1, item(3061, { name = "Ringmail Boots", equipLoc = "INVTYPE_FEET", classID = 4, subclassID = 3,
      stats = { [STA] = 2 } }))
    t.ok(shown(Q))
    Mock.player.combat = true
    Mock.fire("PLAYER_REGEN_DISABLED")
    t.ok(not shown(Q), "hidden during the fight")
    Mock.advance(10)
    Mock.player.combat = false
    Mock.fire("PLAYER_REGEN_ENABLED")
    t.ok(shown(Q), "back after the fight")
    t.eq(Q.UI.UpgradePopup.current.link, "item:3061")
    t.eq(#Mock.errors, 0)
  end,

  -- Arme à deux mains portée, masse à une main dans les sacs, bouclier ramassé : la paire bat la
  -- hache, l'annonce cite les deux objets et le clic équipe les deux.
  pair_with_bag_main_hand_announced_and_equipped = function(t)
    local Q = load()
    Mock.inventory[16] = item(3070, { name = "Rusty Axe", equipLoc = "INVTYPE_2HWEAPON", classID = 2, subclassID = 1,
      stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4 } })                -- guerrier : 12
    local mace = item(3071, { name = "Wooden Mace", equipLoc = "INVTYPE_WEAPON", classID = 2, subclassID = 4,
      stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3 } })                -- 9
    receive(1, mace)
    t.ok(not shown(Q), "the mace alone does not beat the axe")
    receive(2, item(3072, { name = "Thin Buckler", equipLoc = "INVTYPE_SHIELD", classID = 4, subclassID = 6,
      stats = { ["RESISTANCE0_NAME"] = 50 } }))                            -- 1 : 9 + 1 < 12
    t.ok(not shown(Q), "mace + weak shield do not beat the axe")
    local shield = item(3073, { name = "Wooden Shield", equipLoc = "INVTYPE_SHIELD", classID = 4, subclassID = 6,
      stats = { ["RESISTANCE0_NAME"] = 150, [STR] = 1 } })                 -- 3 + 1 = 4 : 13 > 12
    receive(3, shield)
    local P = Q.UI.UpgradePopup
    t.ok(shown(Q), "mace + shield beat the axe")
    t.eq(P.current.link, shield)
    t.ok(P.name:GetText():find("[Wooden Mace]", 1, true) and P.name:GetText():find("[Wooden Shield]", 1, true),
      "both items named")
    t.ok(P.instead:GetText():find("[Rusty Axe]", 1, true), "instead of the two-handed axe")
    P.equipButton:Click()
    t.eq(equipped, { mace .. "@16" }, "main hand first")
    Mock.advance(1)
    t.eq(equipped, { mace .. "@16", shield .. "@17" }, "then the off-hand, once the main hand is in place")
    t.ok(P:Recommended(mace) and P:Recommended(shield), "both remembered as recommended")
    t.eq(#Mock.errors, 0)
  end,

  pair_not_equipped_when_a_half_left_the_bags = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    bags[0][1] = nil                                   -- la masse n'est plus là
    P.equipButton:Click()
    Mock.advance(2)
    t.eq(equipped, {}, "nothing equipped")
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_MISSING, "item:3071")), 1)
  end,

  pair_off_hand_not_equipped_when_the_main_hand_does_not_land = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    equipLands = false
    P.equipButton:Click()
    Mock.advance(3)
    t.eq(equipped, { "item:3071@16" }, "the shield would remove the axe and leave the main hand empty")
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 1)
  end,

  pair_off_hand_not_equipped_if_combat_starts = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    P.equipButton:Click()
    Mock.player.combat = true
    Mock.advance(2)
    t.eq(equipped, { "item:3071@16" })
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_COMBAT, "item:3073")), 1)
    Mock.player.combat = false
  end,

  -- Clic gauche en combat : rien n'est équipé et l'annonce reste.
  left_click_in_combat_keeps_popup = function(t)
    local Q = load()
    receive(1, item(3062, { name = "Ringmail Belt", equipLoc = "INVTYPE_WAIST", classID = 4, subclassID = 3,
      stats = { [STR] = 3 } }))
    local P = Q.UI.UpgradePopup
    Mock.player.combat = true                    -- combat sans PLAYER_REGEN_DISABLED encore reçu
    P.equipButton:Click()
    t.eq(equipped, {}, "nothing equipped in combat")
    t.ok(shown(Q), "not dismissed")
    t.eq(P.current.link, "item:3062")
    Mock.player.combat = false
    P.equipButton:Click()
    t.eq(equipped, { "item:3062" })
    t.ok(not shown(Q))
  end,

  -- M3 : masse et bouclier arrivés ensemble : une seule annonce pour la même paire.
  same_pair_announced_once = function(t)
    local Q = load()
    Mock.inventory[16] = item(3070, { name = "Rusty Axe", equipLoc = "INVTYPE_2HWEAPON", classID = 2, subclassID = 1,
      stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4 } })
    local mace = item(3071, { name = "Wooden Mace", equipLoc = "INVTYPE_WEAPON", classID = 2, subclassID = 4,
      stats = { ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3 } })
    local shield = item(3073, { name = "Wooden Shield", equipLoc = "INVTYPE_SHIELD", classID = 4, subclassID = 6,
      stats = { ["RESISTANCE0_NAME"] = 150, [STR] = 1 } })
    bags[0][1], bags[0][3] = mace, shield
    Mock.fire("BAG_UPDATE_DELAYED")
    local P = Q.UI.UpgradePopup
    t.ok(P.current and P.current.pair, "pair announced")
    t.eq(#P.queue, 0, "only one announcement for the pair")
    -- même paire poussée avec l'autre objet en tête : ignorée aussi
    P:Push({ link = mace, pair = { main = mace .. ":0:0", off = shield } })
    t.eq(#P.queue, 0, "same pair (by item ID) ignored")
  end,

  -- M1 : le lien de l'objet dans le sac diffère de celui de l'annonce (mêmes ID) : la paire s'équipe,
  -- avec le lien trouvé dans le sac.
  pair_found_in_bags_by_item_id = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    bags[0][1] = "item:3071:0:0:0:0:0:0:0:5"
    bags[0][3] = "item:3073:0:0:0:0:0:0:0:5"
    P.equipButton:Click()
    Mock.advance(1)
    t.eq(equipped, { "item:3071:0:0:0:0:0:0:0:5@16", "item:3073:0:0:0:0:0:0:0:5@17" })
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_MISSING, "item:3071")), 0)
    t.ok(P:Recommended("item:3071:0:0:0:0:0:0:0:5"), "recommended by item ID")
  end,

  -- M2 : la main droite arrive (PLAYER_EQUIPMENT_CHANGED, emplacement 16) : la main gauche suit
  -- aussitôt, une seule fois.
  pair_off_hand_follows_the_equipment_event = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    equipLands = false
    P.equipButton:Click()
    t.eq(equipped, { "item:3071@16" })
    Mock.inventory[16] = "item:3071"
    bags[0][1] = nil
    Mock.fire("PLAYER_EQUIPMENT_CHANGED", 17, true)
    t.eq(equipped, { "item:3071@16" }, "another slot: nothing")
    Mock.fire("PLAYER_EQUIPMENT_CHANGED", 16, true)
    t.eq(equipped, { "item:3071@16", "item:3073@17" }, "off-hand at once")
    Mock.advance(5)
    Mock.fire("PLAYER_EQUIPMENT_CHANGED", 16, true)
    t.eq(equipped, { "item:3071@16", "item:3073@17" }, "only once")
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 0)
    t.eq(#Mock.errors, 0)
  end,

  -- M2 : main droite liée quand équipée : tant que la confirmation de liaison est ouverte, on attend
  -- (jusqu'à 30 s) au lieu d'échouer.
  pair_waits_while_the_bind_confirmation_is_open = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    local saved = StaticPopup_Visible
    local bindOpen = true
    StaticPopup_Visible = function(which) return bindOpen and which == "EQUIP_BIND" and {} or nil end
    equipLands = false
    P.equipButton:Click()
    Mock.advance(20)
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 0, "still waiting at 20 s")
    -- le joueur accepte : la main droite arrive un peu plus tard
    bindOpen = false
    Mock.advance(1)
    Mock.inventory[16] = "item:3071"
    bags[0][1] = nil
    Mock.advance(1)
    t.eq(equipped, { "item:3071@16", "item:3073@17" }, "off-hand once the main hand is in place")
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 0)
    StaticPopup_Visible = saved
  end,

  pair_gives_up_after_30_seconds_of_bind_confirmation = function(t)
    local Q = announcePair()
    local P = Q.UI.UpgradePopup
    local saved = StaticPopup_Visible
    StaticPopup_Visible = function(which) return which == "EQUIP_BIND" and {} or nil end
    equipLands = false
    P.equipButton:Click()
    Mock.advance(29)
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 0)
    Mock.advance(5)
    t.eq(Mock.countPrinted(string.format(Q.L.UI_UPGRADE_PAIR_FAILED, "item:3073")), 1, "gives up after 30 s")
    t.eq(equipped, { "item:3071@16" })
    StaticPopup_Visible = saved
  end,

  -- Boîte collée sous le suivi, même largeur (deux points d'ancrage) et même échelle ; au-dessus
  -- quand le suivi touche le bas de l'écran ; suivi caché : en haut de l'écran.
  box_sits_under_the_tracker = function(t)
    local Q = load()
    local tracker = Q.UI.Tracker.frame
    t.ok(tracker, "tracker frame")
    tracker.GetBottom = function() return 500 end
    tracker:SetScale(1.2)
    receive(1, item(3080, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    local P = Q.UI.UpgradePopup
    t.eq(P.placement, "below")
    local p1, rel1, r1 = P.frame:GetPoint(1)
    local p2, rel2, r2 = P.frame:GetPoint(2)
    t.eq({ p1, r1, p2, r2 }, { "TOPLEFT", "BOTTOMLEFT", "TOPRIGHT", "BOTTOMRIGHT" })
    t.ok(rel1 == tracker and rel2 == tracker, "anchored to the tracker frame")
    t.eq(P.frame:GetScale(), 1.2, "same scale as the tracker")
    P:Next()
    tracker.GetBottom = function() return 20 end
    receive(2, item(3081, { name = "Ringmail Boots", equipLoc = "INVTYPE_FEET", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    t.eq(P.placement, "above", "no room below: above the tracker")
    t.eq(select(3, P.frame:GetPoint(1)), "TOPLEFT")
    P:Next()
    tracker:Hide()
    receive(3, item(3082, { name = "Ringmail Belt", equipLoc = "INVTYPE_WAIST", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    t.eq(P.placement, "screen", "tracker hidden: top of the screen")
    t.eq(#Mock.errors, 0)
  end,

  -- Souris sur la boîte : la barre s'arrête et le comparatif s'ouvre ; souris partie : la barre
  -- reprend là où elle en était.
  hover_pauses_the_timer_and_opens_the_comparison = function(t)
    local Q = load()
    receive(1, item(3083, { name = "Ringmail Hauberk", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
      stats = { [STR] = 4 } }))
    local P, C = Q.UI.UpgradePopup, Q.UI.UpgradeCompare
    Mock.advance(2)
    t.eq(P.bar:GetValue(), 3, "bar empties with time")
    local over = true
    P.frame.IsMouseOver = function() return over end
    Mock.advance(0.1)
    t.ok(C:IsShown(), "comparison opened")
    Mock.advance(30)
    t.ok(shown(Q), "paused while hovered")
    t.eq(P.bar:GetValue(), 3)
    over = false
    Mock.advance(0.1)
    t.ok(not C:IsShown(), "comparison closed")
    t.ok(shown(Q))
    Mock.advance(3)
    t.ok(not shown(Q), "closes once the rest of the time is over")
    t.eq(#Mock.errors, 0)
  end,

  -- Plusieurs objets : un à la fois, compteur « 1/2 » puis « 2/2 » ; « Non » passe au suivant sans
  -- rien équiper ; un son discret à chaque objet.
  queue_counter_no_button_and_sound = function(t)
    local Q = load()
    bags[0][1] = item(3084, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } })
    bags[0][2] = item(3085, { name = "Ringmail Boots", equipLoc = "INVTYPE_FEET", classID = 4, subclassID = 3,
      stats = { [STA] = 2 } })
    Mock.fire("BAG_UPDATE_DELAYED")
    local P = Q.UI.UpgradePopup
    t.eq(P.counter:GetText(), "1/2")
    t.eq(#Mock.callsTo("PlaySound"), 1)
    t.eq(Mock.callsTo("PlaySound")[1][2][1], "IG_BACKPACK_OPEN", "discreet bag sound")
    P.noButton:Click()
    t.eq(equipped, {}, "No equips nothing")
    t.ok(shown(Q), "next item")
    t.eq(P.counter:GetText(), "2/2")
    Mock.advance(5.1)
    t.ok(not shown(Q))
    t.eq(P.shownCount, 0, "counter reset once the queue is empty")
    t.eq(#Mock.callsTo("PlaySound"), 2)
  end,

  -- Comparatif : stats avant / après / écart triées par poids de la classe, résumé des deux plus
  -- forts gains, effets « Équipé : » perdus ou nouveaux (lus dans l'infobulle), gain au score.
  comparison_lists_stats_effects_and_score = function(t)
    local Q = load()
    Mock.inventory[5] = item(3090, { name = "Old Breastplate", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
      stats = { [STR] = 3, [STA] = 6, ["RESISTANCE0_NAME"] = 100, ["ITEM_MOD_SPIRIT_SHORT"] = 2 } })
    local new = item(3091, { name = "Stromgarde Hauberk", equipLoc = "INVTYPE_CHEST", classID = 4, subclassID = 3,
      quality = 3, stats = { [STR] = 8, [STA] = 5, ["RESISTANCE0_NAME"] = 140 } })
    ITEM_SPELL_TRIGGER_ONEQUIP, ITEM_SPELL_TRIGGER_ONUSE = "Equip:", "Use:"
    local lines = {
      ["item:3090"] = { "Old Breastplate", "Equip: Increases your chance to hit by 1%." },
      [new] = { "Stromgarde Hauberk", "|cff00ff00Equip: Improves your chance to get a critical strike by 1%.|r",
        "Use: Increases run speed by 40% for 6 sec." },
    }
    C_TooltipInfo = { GetHyperlink = function(link)
      local out = {}
      for i, l in ipairs(lines[link] or {}) do out[i] = { leftText = l } end
      return { lines = out }
    end }
    receive(1, new)
    local P, C = Q.UI.UpgradePopup, Q.UI.UpgradeCompare
    t.ok(shown(Q))
    local d = P.current.compare
    t.eq(d.before[1].name, "Old Breastplate")
    t.eq(d.after[1].name, "Stromgarde Hauberk")
    local rows = {}
    for i, s in ipairs(d.stats) do rows[i] = { s.name, s.before, s.after, s.delta } end
    t.eq(rows, {
      { "Strength", 3, 8, 5 },          -- 5 x 1
      { "Armor", 100, 140, 40 },        -- 40 x 0,02
      { "Stamina", 6, 5, -1 },          -- 1 x 0,5
      { "Spirit", 2, 0, -2 },           -- sans poids pour le guerrier
    })
    t.eq(d.summary, { "+5 Strength", "+40 Armor" })
    t.eq(d.effects, {
      { text = "Equip: Increases your chance to hit by 1%.", kind = "lost" },
      { text = "Equip: Improves your chance to get a critical strike by 1%.", kind = "new" },
      { text = "Use: Increases run speed by 40% for 6 sec.", kind = "new" },
    })
    t.ok(P.name:GetText():find("|cff1d4f8c[Stromgarde Hauberk]", 1, true), "rare: dark blue on parchment")
    P.frame.IsMouseOver = function() return true end
    Mock.advance(0.1)
    t.ok(C:IsShown())
    t.eq(#C.statRows, 4)
    t.ok(C.statRows[3].diff:GetText():find("−1", 1, true), "loss shown with a minus sign")
    t.eq(#C.effectRows, 3)
    t.ok(C.scoreText:GetText():find("+5.3|r (Warrior)", 1, true), "class score gain (5 + 0.8 - 0.5), automatic role: class only")
    t.eq(C.side, "right", "box on the left half: comparison on the right")
    t.eq(#Mock.errors, 0)
  end,

  -- Paire : avant = l'arme à deux mains, après = la masse (des sacs) et le bouclier.
  pair_comparison_shows_both_halves = function(t)
    local Q = announcePair()
    local d = Q.UI.UpgradePopup.current.compare
    t.eq(#d.before, 1)
    t.eq(d.before[1].name, "Rusty Axe")
    t.eq({ d.after[1].name, d.after[2].name }, { "Wooden Mace", "Wooden Shield" })
    t.ok(d.fromBags[1] and not d.fromBags[2], "the mace comes from the bags")
  end,

  -- Thème du suivi : parchemin (défaut) ou sombre ; la boîte affichée suit un changement de thème.
  box_follows_the_tracker_theme = function(t)
    local Q = load()
    receive(1, item(3086, { name = "Ringmail Gloves", equipLoc = "INVTYPE_HAND", classID = 4, subclassID = 3,
      stats = { [STR] = 2 } }))
    local P = Q.UI.UpgradePopup
    t.eq(P.frame.qvThemeKey, "parchment")
    local parchment = P.equipButton.qvStyle
    Q.Settings:Set("tracker.theme", "dark")
    t.eq(P.frame.qvThemeKey, "dark")
    t.ok(P.equipButton.qvStyle ~= parchment, "buttons restyled")
    t.eq(#Mock.errors, 0)
  end,
}
