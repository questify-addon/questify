local addonName, Q = ...
-- Généré par tools/routebuilder/build_auction_items.lua. Ne pas modifier à la main.
-- Source : QuestieDB commit c7ccd23e17a222e083c4215144ef9db301db27ce, généré le 2026-11-16.
-- Objets de collecte des routes qui peuvent s'acheter à l'hôtel des ventes (par chapitre, dans l'ordre des
-- étapes : objet, quête, rang de l'objectif dans le journal, quantité), puis les encanteurs par faction.
Q.AuctionItemData = {
  guides = {
    ["A_02"] = { { item = 209851, quest = 78149, obj = 1 } },
    ["A_03"] = { { item = 2251, quest = 93, obj = 1, count = 6 }, { item = 209849, quest = 78147, obj = 1 } },
    ["A_05"] = { { item = 3712, quest = 555, obj = 1, count = 10 } },
    ["A_07"] = { { item = 219402, quest = 81741, obj = 1, count = 10 } },
    ["A_08"] = { { item = 279505, quest = 86757, obj = 1, count = 6 }, { item = 279507, quest = 86757, obj = 2, count = 4 } },
    ["A_10"] = { { item = 2633, quest = 204, obj = 1, count = 7 } },
    ["A_11"] = { { item = 215817, quest = 79950, obj = 1 }, { item = 13703, quest = 5501, obj = 1, count = 10 } },
    ["A_12"] = { { item = 213165, quest = 79535, obj = 1 } },
    ["A_13"] = { { item = 215816, quest = 79949, obj = 1 }, { item = 5040, quest = 691, obj = 3 } },
    ["A_17"] = { { item = 215816, quest = 79949, obj = 1 } },
    ["A_18"] = { { item = 8483, quest = 1707, obj = 1, count = 5 } },
    ["A_20"] = { { item = 220346, quest = 81949, obj = 1 } },
    ["A_21"] = { { item = 220345, quest = 81947, obj = 1 } },
    ["A_22"] = { { item = 4306, quest = 4449, obj = 2, count = 15 }, { item = 220352, quest = 81955, obj = 1 }, { item = 220353, quest = 81956, obj = 1 }, { item = 220345, quest = 81947, obj = 1 }, { item = 220346, quest = 81949, obj = 1 } },
    ["A_23"] = { { item = 228132, quest = 84395, obj = 1 }, { item = 228141, quest = 84402, obj = 1 } },
    ["A_26"] = { { item = 11186, quest = 4284, obj = 1, count = 7 }, { item = 11188, quest = 4284, obj = 2 }, { item = 11185, quest = 4284, obj = 3 }, { item = 11184, quest = 4284, obj = 4 } },
    ["A_28"] = { { item = 220349, quest = 81953, obj = 1 } },
    ["A_DwarfGnome_02"] = { { item = 769, quest = 317, obj = 1, count = 4 } },
    ["A_DwarfGnome_04"] = { { item = 814, quest = 103, obj = 1, count = 5 }, { item = 255007, quest = 92909, obj = 1, count = 14 }, { item = 723, quest = 22, obj = 1, count = 8 } },
    ["A_Human_02"] = { { item = 769, quest = 86, obj = 1, count = 4 }, { item = 6782, quest = 1667, obj = 1 } },
    ["A_Human_03"] = { { item = 255007, quest = 92909, obj = 1, count = 14 }, { item = 723, quest = 22, obj = 1, count = 8 }, { item = 814, quest = 103, obj = 1, count = 5 }, { item = 208860, quest = 79093, obj = 1 } },
    ["A_NightElf_02"] = { { item = 8048, quest = 2438, obj = 1 } },
    ["A_Skyborne_01"] = { { item = 6889, quest = 92553, obj = 1, count = 3 }, { item = 5469, quest = 92553, obj = 2, count = 8 } },
    ["H_03"] = { { item = 209851, quest = 78149, obj = 1 } },
    ["H_04"] = { { item = 5075, quest = 5052, obj = 1 }, { item = 208800, quest = 79097, obj = 1 }, { item = 5093, quest = 893, obj = 1 }, { item = 5092, quest = 893, obj = 2 }, { item = 5094, quest = 893, obj = 3 }, { item = 209846, quest = 78143, obj = 1 }, { item = 209847, quest = 78145, obj = 1 } },
    ["H_06"] = { { item = 215816, quest = 79949, obj = 1 }, { item = 215815, quest = 79948, obj = 1 }, { item = 209851, quest = 78149, obj = 1 }, { item = 208800, quest = 79097, obj = 1 }, { item = 209846, quest = 78143, obj = 1 }, { item = 209847, quest = 78145, obj = 1 } },
    ["H_16"] = { { item = 8483, quest = 1707, obj = 1, count = 5 } },
    ["H_23"] = { { item = 220353, quest = 81956, obj = 1 } },
    ["H_24"] = { { item = 220349, quest = 81953, obj = 1 }, { item = 220352, quest = 81955, obj = 1 }, { item = 220353, quest = 81956, obj = 1 } },
    ["H_27"] = { { item = 11186, quest = 4284, obj = 1, count = 7 }, { item = 11188, quest = 4284, obj = 2 }, { item = 11185, quest = 4284, obj = 3 }, { item = 11184, quest = 4284, obj = 4 } },
    ["H_29"] = { { item = 228132, quest = 84395, obj = 1 }, { item = 228140, quest = 84401, obj = 1 }, { item = 4338, quest = 7817, obj = 1 }, { item = 228138, quest = 84400, obj = 1 }, { item = 228135, quest = 84398, obj = 1 }, { item = 228141, quest = 84402, obj = 1 } },
    ["H_Skyborne_01"] = { { item = 6889, quest = 92553, obj = 1, count = 3 }, { item = 5469, quest = 92553, obj = 2, count = 8 } },
    ["H_Undead_02"] = { { item = 7227, quest = 1882, obj = 1 }, { item = 2589, quest = 94434, obj = 1, count = 10 } },
    ["H_Undead_03"] = { { item = 210177, quest = 79096, obj = 1 } },
  },
  auctioneers = {
    A = { 8661, 8669, 8670, 8671, 8719, 8720, 8723, 9857, 9858, 9859, 15659, 15677, 15678, 15679, 15681, 257037, 258878 },
    H = { 8661, 8672, 8673, 8674, 8721, 8722, 8724, 9856, 9857, 9858, 15675, 15676, 15677, 15681, 15682, 15683, 15684, 15686, 257037, 258878 },
  },
}
