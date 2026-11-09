# Questify vs APR Forever: comparison

Generated on 2026-11-09 by `luajit tools/apr/compare.lua`. APR (Azeroth Pilot Reloaded, free software under GPL-3.0) v7.5.5, commit `c5960471d63f836c57c6973148eacdc8f748b6f9`, read at run time from a local clone (`.cache/apr`, outside the repository) through a sandbox: nothing from APR is copied here. This page holds only counts, map IDs and quest IDs; an APR route is named by its rank in APR's play order (`nextRoute` graph), its map and its level band.

Questify: 73 chapters from `Questify/Guides/Guides.xml` (QuestieDB commit `4d31c10394b11bd133069ecf1662062cdf4d8691`). APR: 96 route files of the Forever client list, 127 routes. XP: QuestieDB Forever view of the route builder (quest XP for a player in the chapter's band, nearest to the quest level).

## Summary

A side is **clearly ahead** on a chapter when, on the same slice of the route, the quests that only it does (that the other addon does nowhere for the faction) are worth at least 15 % of the chapter's quest XP more than the other side's, with at least 5 such quests. "APR-only": general quests (not class quests) that APR does in the slice and no Questify chapter of the faction does, except those of a level more than 2 above the chapter's band. "Questify-only": general quests of the chapter that no APR route of the faction does. Only quest XP is compared: travel time, kill time and grinding are not.

- APR clearly ahead: A_Skyborne_01 (APR-only 25 quests / 12 315 XP, Questify-only 6 / 4 070 XP, chapter 46 335 XP); A_01 (APR-only 10 quests / 12 030 XP, Questify-only 5 / 5 345 XP, chapter 44 000 XP); A_03 (APR-only 26 quests / 29 240 XP, Questify-only 4 / 6 800 XP, chapter 64 850 XP); A_04 (APR-only 25 quests / 38 885 XP, Questify-only 13 / 16 720 XP, chapter 26 065 XP); A_07 (APR-only 9 quests / 13 490 XP, Questify-only 1 / 2 450 XP, chapter 39 125 XP); A_09 (APR-only 11 quests / 22 410 XP, Questify-only 1 / 630 XP, chapter 17 650 XP); A_10 (APR-only 28 quests / 38 160 XP, Questify-only 0 / 0 XP, chapter 26 030 XP); A_11 (APR-only 11 quests / 26 750 XP, Questify-only 4 / 10 300 XP, chapter 34 275 XP); A_12 (APR-only 31 quests / 54 715 XP, Questify-only 3 / 4 785 XP, chapter 78 050 XP); A_13 (APR-only 20 quests / 48 540 XP, Questify-only 3 / 7 725 XP, chapter 41 340 XP); A_15 (APR-only 7 quests / 17 760 XP, Questify-only 3 / 6 725 XP, chapter 41 285 XP); A_16 (APR-only 15 quests / 33 900 XP, Questify-only 6 / 11 100 XP, chapter 39 655 XP); A_17 (APR-only 16 quests / 38 685 XP, Questify-only 0 / 0 XP, chapter 49 800 XP); A_18 (APR-only 11 quests / 18 120 XP, Questify-only 3 / 7 050 XP, chapter 43 115 XP); A_19 (APR-only 9 quests / 23 345 XP, Questify-only 0 / 0 XP, chapter 68 945 XP); A_20 (APR-only 16 quests / 70 550 XP, Questify-only 1 / 975 XP, chapter 27 555 XP); A_21 (APR-only 5 quests / 26 450 XP, Questify-only 1 / 975 XP, chapter 37 295 XP); A_24 (APR-only 18 quests / 82 610 XP, Questify-only 1 / 580 XP, chapter 60 850 XP); A_26 (APR-only 25 quests / 99 300 XP, Questify-only 1 / 580 XP, chapter 104 870 XP); A_27 (APR-only 64 quests / 300 075 XP, Questify-only 2 / 1 220 XP, chapter 105 810 XP); A_23 (APR-only 29 quests / 137 860 XP, Questify-only 4 / 9 900 XP, chapter 74 590 XP); A_29 (APR-only 23 quests / 114 900 XP, Questify-only 7 / 27 050 XP, chapter 88 680 XP); A_30 (APR-only 12 quests / 61 250 XP, Questify-only 2 / 13 200 XP, chapter 79 350 XP); H_Tauren_01 (APR-only 6 quests / 2 820 XP, Questify-only 0 / 0 XP, chapter 6 665 XP); H_Tauren_02 (APR-only 8 quests / 4 515 XP, Questify-only 2 / 1 120 XP, chapter 21 395 XP); H_Undead_03 (APR-only 13 quests / 9 090 XP, Questify-only 4 / 3 400 XP, chapter 12 885 XP); H_01 (APR-only 23 quests / 19 630 XP, Questify-only 2 / 2 920 XP, chapter 46 715 XP); H_02 (APR-only 17 quests / 19 370 XP, Questify-only 9 / 12 435 XP, chapter 38 040 XP); H_03 (APR-only 31 quests / 41 815 XP, Questify-only 5 / 5 190 XP, chapter 41 895 XP); H_04 (APR-only 22 quests / 40 740 XP, Questify-only 5 / 8 050 XP, chapter 49 510 XP); H_07 (APR-only 15 quests / 31 835 XP, Questify-only 1 / 640 XP, chapter 20 250 XP); H_08 (APR-only 6 quests / 9 985 XP, Questify-only 1 / 2 750 XP, chapter 36 365 XP); H_09 (APR-only 13 quests / 20 450 XP, Questify-only 1 / 275 XP, chapter 41 035 XP); H_11 (APR-only 5 quests / 12 150 XP, Questify-only 2 / 2 525 XP, chapter 43 750 XP); H_12 (APR-only 12 quests / 26 420 XP, Questify-only 3 / 5 050 XP, chapter 21 750 XP); H_13 (APR-only 14 quests / 36 495 XP, Questify-only 0 / 0 XP, chapter 61 440 XP); H_14 (APR-only 13 quests / 30 895 XP, Questify-only 2 / 4 560 XP, chapter 34 670 XP); H_15 (APR-only 12 quests / 37 995 XP, Questify-only 1 / 4 850 XP, chapter 29 390 XP); H_16 (APR-only 22 quests / 48 880 XP, Questify-only 3 / 7 050 XP, chapter 44 800 XP); H_18 (APR-only 10 quests / 38 340 XP, Questify-only 5 / 18 120 XP, chapter 64 280 XP); H_21 (APR-only 14 quests / 61 850 XP, Questify-only 2 / 10 800 XP, chapter 53 730 XP); H_25 (APR-only 6 quests / 23 100 XP, Questify-only 0 / 0 XP, chapter 58 860 XP); H_26 (APR-only 21 quests / 86 180 XP, Questify-only 1 / 4 200 XP, chapter 70 890 XP); H_27 (APR-only 5 quests / 23 950 XP, Questify-only 0 / 0 XP, chapter 98 130 XP); H_28 (APR-only 54 quests / 230 835 XP, Questify-only 1 / 580 XP, chapter 96 350 XP); H_29 (APR-only 33 quests / 140 890 XP, Questify-only 19 / 58 640 XP, chapter 226 160 XP); H_30 (APR-only 25 quests / 122 540 XP, Questify-only 2 / 13 200 XP, chapter 91 950 XP)
- Questify clearly ahead: A_DwarfGnome_04 (APR-only 5 quests / 4 650 XP, Questify-only 10 / 9 050 XP, chapter 21 025 XP); A_Human_03 (APR-only 9 quests / 7 230 XP, Questify-only 11 / 10 600 XP, chapter 19 480 XP); H_05 (APR-only 1 quest / 2 500 XP, Questify-only 11 / 9 025 XP, chapter 34 335 XP); H_06 (APR-only 3 quests / 7 800 XP, Questify-only 8 / 14 035 XP, chapter 33 445 XP)
- Close: A_DwarfGnome_01 (APR-only 1 quest / 630 XP, Questify-only 0 / 0 XP, chapter 4 255 XP); A_DwarfGnome_02 (APR-only 8 quests / 5 510 XP, Questify-only 6 / 3 805 XP, chapter 22 825 XP); A_DwarfGnome_03 (APR-only 7 quests / 5 060 XP, Questify-only 5 / 3 525 XP, chapter 13 625 XP); A_Human_01 (APR-only 4 quests / 2 160 XP, Questify-only 0 / 0 XP, chapter 4 270 XP); A_Human_02 (APR-only 10 quests / 6 440 XP, Questify-only 6 / 4 115 XP, chapter 24 540 XP); A_NightElf_01 (APR-only 3 quests / 1 665 XP, Questify-only 0 / 0 XP, chapter 4 110 XP); A_NightElf_02 (APR-only 14 quests / 8 680 XP, Questify-only 10 / 6 045 XP, chapter 23 190 XP); A_NightElf_03 (APR-only 16 quests / 14 810 XP, Questify-only 6 / 6 545 XP, chapter 60 270 XP); A_02 (APR-only 21 quests / 19 550 XP, Questify-only 14 / 16 945 XP, chapter 35 530 XP); A_05 (APR-only 1 quest / 2 500 XP, Questify-only 4 / 3 480 XP, chapter 16 040 XP); A_08 (APR-only 5 quests / 9 080 XP, Questify-only 4 / 9 150 XP, chapter 42 140 XP); A_22 (APR-only 1 quest / 4 400 XP, Questify-only 5 / 4 180 XP, chapter 111 600 XP); H_OrcTroll_01 (APR-only 2 quests / 810 XP, Questify-only 1 / 170 XP, chapter 5 165 XP); H_OrcTroll_02 (APR-only 3 quests / 1 265 XP, Questify-only 2 / 1 540 XP, chapter 27 530 XP); H_Undead_01 (APR-only 2 quests / 1 080 XP, Questify-only 0 / 0 XP, chapter 3 710 XP); H_Undead_02 (APR-only 9 quests / 6 020 XP, Questify-only 7 / 4 400 XP, chapter 24 340 XP); H_Skyborne_01 (APR-only 27 quests / 13 185 XP, Questify-only 18 / 12 950 XP, chapter 47 225 XP); H_10 (APR-only 2 quests / 6 300 XP, Questify-only 0 / 0 XP, chapter 24 575 XP); H_17 (APR-only 4 quests / 12 750 XP, Questify-only 1 / 4 400 XP, chapter 83 250 XP); H_23 (APR-only 0 quests / 0 XP, Questify-only 1 / 780 XP, chapter 24 280 XP); H_24 (APR-only 4 quests / 15 590 XP, Questify-only 6 / 10 605 XP, chapter 78 105 XP)
- No APR counterpart: A_28

Alliance: 354 distinct APR-only quests over all slices. Why our route builder left them out (its chapter report, `docs/routes/<chapter>.md`): not a candidate of the chapter 175; prerequisite unavailable 48; level band reached 28; manual drop (overrides.lua) 24; objective item source not in zone 19; finisher outside the chapter zones 17; quest level below the band 16; requires a profession 15; exclusive with another quest 2; far 2; objective npc not in zone 2; repeatable 2; dungeon quest not picked up 1; exploration point not in zone 1; low ratio 1; prerequisite dropped 1.

Horde: 286 distinct APR-only quests over all slices. Why our route builder left them out (its chapter report, `docs/routes/<chapter>.md`): not a candidate of the chapter 119; manual drop (overrides.lua) 42; level band reached 32; objective item source not in zone 19; prerequisite unavailable 19; finisher outside the chapter zones 18; requires a profession 11; prerequisite dropped 6; far 5; low ratio 4; objective npc not in zone 4; required level not reached in time 2; dungeon quest not picked up 1; exclusive with another quest 1; exploration point not in zone 1; not a candidate of the chapter (QuestieDB: blacklisted) 1; repeatable 1.

## Chapters

Matching: APR leveling routes of the same faction, open to a race of the chapter and to at least 4 classes, whose level band is within 2 levels of the chapter's, sharing at least 3 general quests with the chapter and at least 10 % of them or 25 % of the route's quests. The APR *slice* runs from the first to the last APR step that names a general quest of the chapter, over the matched routes in play order. Class quests (open to at most 3 classes at APR, or in a chain of `ClassQuestData.lua`) are left out of the coverage columns and counted on their own.

| Chapter | Band | APR routes | Quests | Q in matched APR | Q anywhere in APR | APR slice in chapter | APR-only | Q-only | Order: same pairs | Kendall tau | Class quests APR / Q | Hearth use APR / Q | Hearth bind APR / Q |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A_DwarfGnome_01 | 1-6 | #6 | 15 | 15 (100 %) | 15 (100 %) | 15 / 19 (79 %) | 1 | 0 | 77 % | 0.55 | 0-4 / 0 | 1 / 0 | 0 / 0 |
| A_DwarfGnome_02 | 6-11 | #6 | 38 | 32 (84 %) | 32 (84 %) | 32 / 46 (70 %) | 8 | 6 | 92 % | 0.84 | 0-5 / 0 | 1 / 0 | 2 / 0 |
| A_DwarfGnome_03 | 11-13 | #6, #24 | 20 | 8 (40 %) | 15 (75 %) | 8 / 17 (47 %) | 7 | 5 | 73 % | 0.46 | 0-8 / 0 | 0 / 0 | 1-2 / 0 |
| A_DwarfGnome_04 | 13-16 | #18, #31 | 23 | 9 (39 %) | 13 (57 %) | 9 / 21 (43 %) | 5 | 10 | 78 % | 0.57 | 0-5 / 0 | 0-1 / 0 | 1 / 0 |
| A_Human_01 | 1-6 | #1 | 21 | 21 (100 %) | 21 (100 %) | 19 / 27 (70 %) | 4 | 0 | 90 % | 0.79 | 0-4 / 0 | 0 / 0 | 0 / 0 |
| A_Human_02 | 6-11 | #1 | 45 | 36 (80 %) | 39 (87 %) | 33 / 52 (63 %) | 10 | 6 | 79 % | 0.57 | 0-6 / 0 | 1 / 0 | 1-2 / 0 |
| A_Human_03 | 11-16 | #1, #31 | 22 | 11 (50 %) | 11 (50 %) | 11 / 36 (31 %) | 9 | 11 | 63 % | 0.25 | 0-8 / 0 | 0 / 0 | 1-2 / 0 |
| A_NightElf_01 | 1-6 | #2 | 17 | 17 (100 %) | 17 (100 %) | 17 / 25 (68 %) | 3 | 0 | 79 % | 0.59 | 0-4 / 0 | 0 / 0 | 0-1 / 0 |
| A_NightElf_02 | 6-11 | #2 | 38 | 28 (74 %) | 28 (74 %) | 28 / 45 (62 %) | 14 | 10 | 82 % | 0.63 | 0-6 / 0 | 0-1 / 0 | 0-1 / 0 |
| A_NightElf_03 | 11-20 | #32, #45, #49 | 61 | 55 (90 %) | 55 (90 %) | 54 / 92 (59 %) | 16 | 6 | 83 % | 0.65 | 0-7 / 0 | 1-5 / 3 | 2-4 / 1 |
| A_Skyborne_01 | 1-15 | #4 | 73 | 67 (92 %) | 67 (92 %) | 67 / 92 (73 %) | 25 | 6 | 82 % | 0.63 | 0-5 / 0 | 1-3 / 0 | 2 / 0 |
| A_01 | 16-19 | #32, #45, #49 | 42 | 36 (86 %) | 37 (88 %) | 35 / 76 (46 %) | 10 | 5 | 81 % | 0.61 | 0-6 / 0 | 2-5 / 2 | 1-3 / 1 |
| A_02 | 20-22 | #32, #45, #49 | 29 | 15 (52 %) | 15 (52 %) | 15 / 86 (17 %) | 21 | 14 | 81 % | 0.61 | 0-7 / 0 | 3-6 / 1 | 1-3 / 0 |
| A_03 | 22-26 | #43, #57 | 50 | 43 (86 %) | 46 (92 %) | 43 / 80 (54 %) | 26 | 4 | 69 % | 0.38 | 0-10 / 0 | 2-3 / 1 | 1-3 / 1 |
| A_04 | 26-29 | #52, #61 | 21 | 7 (33 %) | 8 (38 %) | 7 / 33 (21 %) | 25 | 13 | 47 % | -0.06 | 0-1 / 0 | 2 / 0 | 1 / 1 |
| A_05 | 29-30 | #68 | 11 | 7 (64 %) | 7 (64 %) | 7 / 8 (88 %) | 1 | 4 | 88 % | 0.75 | 0 / 0 | 0 / 1 | 1 / 0 |
| A_08 | 30-32 | #63 | 24 | 16 (67 %) | 20 (83 %) | 16 / 22 (73 %) | 5 | 4 | 78 % | 0.56 | 0 / 0 | 0 / 0 | 0 / 0 |
| A_07 | 32-33 | #64 | 27 | 21 (78 %) | 26 (96 %) | 21 / 38 (55 %) | 9 | 1 | 79 % | 0.58 | 0 / 0 | 2 / 2 | 1 / 1 |
| A_09 | 33-34 | #69, #74 | 12 | 11 (92 %) | 11 (92 %) | 11 / 38 (29 %) | 11 | 1 | 72 % | 0.45 | 0-4 / 0 | 2-3 / 0 | 1 / 0 |
| A_10 | 34-35 | #64, #72, #77 | 18 | 18 (100 %) | 18 (100 %) | 18 / 66 (27 %) | 28 | 0 | 81 % | 0.62 | 0-4 / 0 | 2 / 1 | 2 / 0 |
| A_11 | 35-37 | #74 | 14 | 9 (64 %) | 10 (71 %) | 9 / 21 (43 %) | 11 | 4 | 74 % | 0.49 | 0 / 0 | 1-2 / 2 | 0 / 0 |
| A_12 | 37-39 | #72, #77, #80, #89 | 39 | 36 (92 %) | 36 (92 %) | 36 / 93 (39 %) | 31 | 3 | 73 % | 0.47 | 0-1 / 0 | 4-5 / 4 | 3-5 / 1 |
| A_13 | 39-40 | #83 | 17 | 13 (76 %) | 14 (82 %) | 13 / 33 (39 %) | 20 | 3 | 83 % | 0.66 | 0-3 / 0 | 7 / 0 | 1 / 0 |
| A_15 | 40-41 | #85 | 23 | 7 (30 %) | 20 (87 %) | 7 / 14 (50 %) | 7 | 3 | 70 % | 0.40 | 0 / 0 | 0 / 1 | 0 / 0 |
| A_16 | 41-42 | #88 | 17 | 10 (59 %) | 11 (65 %) | 10 / 25 (40 %) | 15 | 6 | 73 % | 0.45 | 0 / 0 | 0 / 2 | 0 / 0 |
| A_17 | 42-44 | #89 | 16 | 13 (81 %) | 16 (100 %) | 13 / 45 (29 %) | 16 | 0 | 65 % | 0.29 | 0 / 0 | 1-2 / 0 | 1 / 0 |
| A_18 | 44-45 | #93 | 15 | 6 (40 %) | 12 (80 %) | 6 / 17 (35 %) | 11 | 3 | 100 % | 1.00 | 0-1 / 0 | 0 / 2 | 0 / 1 |
| A_19 | 45-46 | #96 | 24 | 22 (92 %) | 24 (100 %) | 22 / 31 (71 %) | 9 | 0 | 74 % | 0.47 | 0 / 0 | 4 / 0 | 1 / 0 |
| A_20 | 46-48 | #101 | 9 | 8 (89 %) | 8 (89 %) | 8 / 30 (27 %) | 16 | 1 | 84 % | 0.67 | 0 / 0 | 2 / 1 | 0 / 0 |
| A_21 | 48-50 | #104 | 12 | 8 (67 %) | 11 (92 %) | 8 / 14 (57 %) | 5 | 1 | 65 % | 0.30 | 0 / 0 | 0 / 1 | 0 / 0 |
| A_22 | 50-52 | #105, #106 | 32 | 26 (81 %) | 27 (84 %) | 26 / 27 (96 %) | 1 | 5 | 57 % | 0.14 | 0 / 0 | 1 / 0 | 0 / 0 |
| A_28 | 52-53 | none | 10 | - | - | - | - | - | - | - | - | - | - |
| A_24 | 53-54 | #109, #115 | 15 | 14 (93 %) | 14 (93 %) | 14 / 38 (37 %) | 18 | 1 | 70 % | 0.40 | 0-2 / 0 | 1 / 0 | 0 / 0 |
| A_26 | 54-56 | #113, #115 | 27 | 21 (78 %) | 26 (96 %) | 21 / 51 (41 %) | 25 | 1 | 75 % | 0.50 | 0 / 0 | 1 / 1 | 0 / 0 |
| A_27 | 56-57 | #115, #120, #122 | 25 | 22 (88 %) | 23 (92 %) | 22 / 117 (19 %) | 64 | 2 | 66 % | 0.32 | 0-1 / 0 | 5 / 0 | 4 / 1 |
| A_23 | 57-58 | #120 | 21 | 15 (71 %) | 17 (81 %) | 15 / 57 (26 %) | 29 | 4 | 78 % | 0.57 | 0 / 0 | 1 / 1 | 1 / 0 |
| A_29 | 58-59 | #120 | 20 | 13 (65 %) | 13 (65 %) | 13 / 40 (33 %) | 23 | 7 | 80 % | 0.60 | 0 / 0 | 2 / 0 | 1 / 0 |
| A_30 | 59-60 | #122 | 12 | 10 (83 %) | 10 (83 %) | 10 / 22 (45 %) | 12 | 2 | 81 % | 0.63 | 0 / 0 | 0 / 1 | 0 / 0 |
| H_OrcTroll_01 | 1-6 | #7 | 15 | 14 (93 %) | 14 (93 %) | 14 / 31 (45 %) | 2 | 1 | 93 % | 0.86 | 0-5 / 0 | 0 / 0 | 1 / 0 |
| H_OrcTroll_02 | 6-12 | #7 | 42 | 39 (93 %) | 40 (95 %) | 36 / 43 (84 %) | 3 | 2 | 86 % | 0.72 | 0-11 / 0 | 0-1 / 0 | 1 / 0 |
| H_Tauren_01 | 1-6 | #5 | 15 | 15 (100 %) | 15 (100 %) | 15 / 35 (43 %) | 6 | 0 | 84 % | 0.68 | 0-4 / 0 | 0 / 0 | 1 / 0 |
| H_Tauren_02 | 6-12 | #5 | 34 | 32 (94 %) | 32 (94 %) | 31 / 46 (67 %) | 8 | 2 | 82 % | 0.65 | 0-7 / 0 | 0-1 / 0 | 2 / 0 |
| H_Undead_01 | 1-6 | #3 | 13 | 13 (100 %) | 13 (100 %) | 13 / 23 (57 %) | 2 | 0 | 95 % | 0.90 | 0-4 / 0 | 0 / 0 | 1 / 0 |
| H_Undead_02 | 6-12 | #3 | 43 | 35 (81 %) | 36 (84 %) | 34 / 46 (74 %) | 9 | 7 | 80 % | 0.61 | 0-10 / 0 | 1-2 / 0 | 1-2 / 0 |
| H_Undead_03 | 12-14 | #25 | 19 | 14 (74 %) | 15 (79 %) | 13 / 27 (48 %) | 13 | 4 | 87 % | 0.74 | 0-4 / 0 | 0-1 / 1 | 0 / 1 |
| H_Skyborne_01 | 1-15 | #4, #14 | 73 | 55 (75 %) | 55 (75 %) | 55 / 87 (63 %) | 27 | 18 | 91 % | 0.82 | 0-10 / 0 | 1-3 / 1 | 3 / 1 |
| H_01 | 12-17 | #5, #27, #37 | 49 | 45 (92 %) | 47 (96 %) | 43 / 77 (56 %) | 23 | 2 | 74 % | 0.47 | 0-12 / 0 | 3-4 / 0 | 4-5 / 2 |
| H_02 | 17-21 | #27, #37 | 28 | 16 (57 %) | 19 (68 %) | 16 / 61 (26 %) | 17 | 9 | 80 % | 0.59 | 0-11 / 0 | 1-2 / 2 | 2-3 / 1 |
| H_03 | 21-25 | #37, #58, #59 | 26 | 21 (81 %) | 21 (81 %) | 19 / 89 (21 %) | 31 | 5 | 63 % | 0.26 | 0-12 / 0 | 4 / 0 | 3 / 0 |
| H_04 | 25-28 | #58, #62 | 28 | 19 (68 %) | 23 (82 %) | 19 / 55 (35 %) | 22 | 5 | 67 % | 0.34 | 0-3 / 0 | 2-3 / 2 | 4 / 1 |
| H_05 | 28-30 | #65 | 24 | 7 (29 %) | 13 (54 %) | 7 / 11 (64 %) | 1 | 11 | 69 % | 0.38 | 0-2 / 0 | 0 / 2 | 0 / 1 |
| H_06 | 30-32 | #65 | 18 | 8 (44 %) | 10 (56 %) | 8 / 17 (47 %) | 3 | 8 | 70 % | 0.41 | 0-2 / 0 | 0 / 3 | 0 / 0 |
| H_07 | 32-33 | #62, #70 | 12 | 11 (92 %) | 11 (92 %) | 11 / 34 (32 %) | 15 | 1 | 77 % | 0.55 | 0-3 / 0 | 2 / 1 | 2 / 1 |
| H_08 | 33-35 | #73 | 15 | 14 (93 %) | 14 (93 %) | 14 / 22 (64 %) | 6 | 1 | 65 % | 0.30 | 0 / 0 | 0 / 1 | 0 / 1 |
| H_09 | 35-37 | #70, #76 | 25 | 24 (96 %) | 24 (96 %) | 24 / 43 (56 %) | 13 | 1 | 90 % | 0.80 | 0-1 / 0 | 1-3 / 2 | 2 / 1 |
| H_10 | 37-38 | #79 | 13 | 13 (100 %) | 13 (100 %) | 13 / 16 (81 %) | 2 | 0 | 79 % | 0.58 | 0 / 0 | 0 / 0 | 0 / 0 |
| H_11 | 38-39 | #81 | 19 | 16 (84 %) | 17 (89 %) | 16 / 24 (67 %) | 5 | 2 | 77 % | 0.54 | 0-4 / 0 | 0 / 2 | 0 / 1 |
| H_12 | 39-40 | #82 | 9 | 6 (67 %) | 6 (67 %) | 6 / 18 (33 %) | 12 | 3 | 73 % | 0.47 | 0 / 0 | 0 / 0 | 0 / 0 |
| H_13 | 40-42 | #87, #90, #97 | 22 | 20 (91 %) | 22 (100 %) | 20 / 44 (45 %) | 14 | 0 | 65 % | 0.30 | 0 / 0 | 2 / 1 | 1 / 1 |
| H_14 | 42-43 | #90, #98 | 11 | 9 (82 %) | 9 (82 %) | 9 / 28 (32 %) | 13 | 2 | 74 % | 0.47 | 0 / 0 | 1 / 0 | 1 / 0 |
| H_15 | 43-44 | #92, #99 | 9 | 7 (78 %) | 8 (89 %) | 7 / 27 (26 %) | 12 | 1 | 68 % | 0.37 | 0 / 0 | 2-3 / 1 | 1 / 0 |
| H_16 | 44-45 | #92, #99 | 13 | 10 (77 %) | 10 (77 %) | 10 / 35 (29 %) | 22 | 3 | 75 % | 0.50 | 0 / 0 | 2-3 / 1 | 2 / 1 |
| H_17 | 45-47 | #95 | 23 | 20 (87 %) | 22 (96 %) | 20 / 24 (83 %) | 4 | 1 | 80 % | 0.60 | 0 / 0 | 2-3 / 0 | 1 / 0 |
| H_18 | 47-49 | #97, #103 | 18 | 11 (61 %) | 13 (72 %) | 11 / 35 (31 %) | 10 | 5 | 67 % | 0.33 | 0 / 0 | 0 / 2 | 0 / 1 |
| H_21 | 49-51 | #100 | 12 | 10 (83 %) | 10 (83 %) | 10 / 24 (42 %) | 14 | 2 | 68 % | 0.35 | 0 / 0 | 0 / 0 | 0 / 0 |
| H_23 | 51-52 | #103 | 6 | 5 (83 %) | 5 (83 %) | 5 / 5 (100 %) | 0 | 1 | 56 % | 0.11 | 0 / 0 | 0 / 1 | 0 / 0 |
| H_24 | 52-53 | #108 | 24 | 18 (75 %) | 18 (75 %) | 18 / 22 (82 %) | 4 | 6 | 92 % | 0.83 | 0 / 0 | 0 / 0 | 0 / 0 |
| H_25 | 53-54 | #110, #114 | 15 | 14 (93 %) | 15 (100 %) | 14 / 31 (45 %) | 6 | 0 | 56 % | 0.13 | 0-3 / 0 | 1 / 1 | 0 / 1 |
| H_26 | 54-55 | #114, #117 | 16 | 15 (94 %) | 15 (94 %) | 15 / 52 (29 %) | 21 | 1 | 75 % | 0.49 | 0-2 / 0 | 3-4 / 1 | 2 / 0 |
| H_27 | 55-56 | #116 | 23 | 18 (78 %) | 23 (100 %) | 18 / 23 (78 %) | 5 | 0 | 75 % | 0.50 | 0 / 0 | 0 / 1 | 0 / 0 |
| H_28 | 56-57 | #114, #117, #119, #121 | 23 | 22 (96 %) | 22 (96 %) | 22 / 126 (17 %) | 54 | 1 | 77 % | 0.53 | 0-2 / 0 | 5-7 / 3 | 3 / 1 |
| H_29 | 57-59 | #119 | 58 | 39 (67 %) | 39 (67 %) | 39 / 72 (54 %) | 33 | 19 | 72 % | 0.44 | 0 / 0 | 0 / 0 | 0 / 0 |
| H_30 | 59-60 | #121 | 14 | 11 (79 %) | 12 (86 %) | 10 / 41 (24 %) | 25 | 2 | 69 % | 0.38 | 0-1 / 0 | 0-1 / 2 | 0 / 0 |

Quests: general quests of the chapter. Class quests, hearth use and hearth bind are per class (`a-b` = lowest-highest over the 9 classes; one number when every class has the same). Hearth use at APR includes the "use it if it is ready" steps. Order: first `accept`, `complete` and `turnin` of each quest, steps open to at least 4 classes, compared on the events present on both sides (Kendall tau: 1 = same order, 0 = unrelated, -1 = reversed).

## Details per chapter

### A_DwarfGnome_01 — Coldridge Valley (1-6)

- Races: Dwarf, Gnome. APR routes: #6 (Dun Morogh (1426), 1-11): 15 shared of 95. Slice: 133 of 401 steps.
- Questify -> APR: 15 of 15 general quests in the matched routes (100 %), 15 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 15 of 19 general quests in this chapter (79 %).
  - In another Questify chapter: 96608, 96629, 98322
  - In no Questify chapter (APR-only): 384 (630 XP)
    - not a candidate of the chapter: 384
- Order: 37 shared events, 516 of 666 pairs in the same order (77 %), Kendall tau 0.55.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 3364 | turnin 170 | 19 | 19 |
  | accept 3365 | turnin 234 | 13 | 13 |
  | accept 3364 | accept 234 | 12 | 13 |
  | complete 182 | complete 170 | 11 | 11 |
  | accept 218 | turnin 233 | 12 | 10 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | PALADIN | 1 | 0 | 0 | 1 | none |
  | HUNTER | 1 | 0 | 0 | 1 | none |
  | ROGUE | 2 | 0 | 0 | 2 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | SHAMAN | 4 | 0 | 0 | 4 | none |
  | MAGE | 1 | 0 | 0 | 1 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### A_DwarfGnome_02 — Dun Morogh (6-11)

- Races: Dwarf, Gnome. APR routes: #6 (Dun Morogh (1426), 1-11): 32 shared of 95. Slice: 231 of 401 steps.
- Questify -> APR: 32 of 38 general quests in the matched routes (84 %), 32 anywhere in APR (84 %).
  - Absent from APR (Questify-only): 415, 95212, 98326, 99159, 99160, 99161 (3 805 XP)
  - In another APR route: none
- APR -> Questify (slice): 32 of 46 general quests in this chapter (70 %).
  - In another Questify chapter: 224, 420, 2160, 6387, 6388, 6391
  - In no Questify chapter (APR-only): 267, 308, 384, 400, 412, 416, 418, 98321 (5 510 XP)
  - Left out, quest level above 13 (band + 2): 307, 1338, 1339
    - level band reached: 384, 400, 412, 98321
    - not a candidate of the chapter: 267, 416, 418
    - repeatable: 308
- Order: 80 shared events, 2909 of 3160 pairs in the same order (92 %), Kendall tau 0.84.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 287 | turnin 313 | 21 | 22 |
  | accept 95214 | complete 314 | 16 | 16 |
  | turnin 95213 | turnin 314 | 18 | 14 |
  | accept 312 | complete 313 | 11 | 11 |
  | accept 95213 | complete 96392 | 8 | 9 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 5 | 0 | 0 | 4 | 86667 |
  | PRIEST | 2 | 0 | 0 | 2 | none |
  | SHAMAN | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 2 times (maps Dun Morogh (1426), Loch Modan (1432)); Questify uses it 0 times and binds it 0 times (maps none).

### A_DwarfGnome_03 — Loch Modan (11-13)

- Races: Dwarf, Gnome. APR routes: #6 (Dun Morogh (1426), 1-11): 8 shared of 95; #24 (Loch Modan (1432), 12-14): 3 shared of 26. Slice: 205 of 567 steps.
- Questify -> APR: 8 of 20 general quests in the matched routes (40 %), 15 anywhere in APR (75 %).
  - Absent from APR (Questify-only): 237, 263, 273, 309, 454 (3 525 XP)
  - In another APR route: 257, 298, 301, 302, 385, 2039, 86758
- APR -> Questify (slice): 8 of 17 general quests in this chapter (47 %).
  - In another Questify chapter: 291, 414
  - In no Questify chapter (APR-only): 267, 353, 416, 418, 6661, 6662, 86667 (5 060 XP)
    - level band reached: 267, 416, 418
    - not a candidate of the chapter: 353, 6661, 6662
    - objective item source not in zone: 86667
- Order: 18 shared events, 112 of 153 pairs in the same order (73 %), Kendall tau 0.46.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 6388 | accept 224 | 9 | 9 |
  | turnin 6391 | turnin 1339 | 5 | 5 |
  | turnin 6388 | accept 1338 | 4 | 6 |
  | turnin 307 | turnin 1338 | 5 | 3 |
  | accept 6391 | accept 307 | 5 | 2 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 4 | 0 | 0 | 4 | none |
  | PALADIN | 8 | 0 | 0 | 7 | 1645 |
  | HUNTER | 1 | 0 | 0 | 1 | none |
  | PRIEST | 1 | 0 | 0 | 1 | none |
  | SHAMAN | 5 | 0 | 0 | 5 | none |
  | WARLOCK | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1-2 times (maps Loch Modan (1432), Ironforge (1455)); Questify uses it 0 times and binds it 0 times (maps none).

### A_DwarfGnome_04 — Westfall (13-16)

- Races: Dwarf, Gnome. APR routes: #18 (Elwynn Forest (1429), 11-12): 7 shared of 28; #31 (Westfall (1436), 13-15): 8 shared of 17. Slice: 112 of 178 steps.
- Questify -> APR: 9 of 23 general quests in the matched routes (39 %), 13 anywhere in APR (57 %).
  - Absent from APR (Questify-only): 13, 14, 136, 138, 139, 140, 79192, 92745, 92747, 92748 (9 050 XP)
  - In another APR route: 103, 167, 168, 2040
- APR -> Questify (slice): 9 of 21 general quests in this chapter (43 %).
  - In another Questify chapter: 22, 36, 39, 88, 184, 91733, 91740
  - In no Questify chapter (APR-only): 38, 65, 244, 399, 92909 (4 650 XP)
    - finisher outside the chapter zones: 65
    - level band reached: 38, 92909
    - not a candidate of the chapter: 244, 399
- Order: 24 shared events, 216 of 276 pairs in the same order (78 %), Kendall tau 0.57.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 151 | turnin 109 | 6 | 9 |
  | turnin 12 | turnin 64 | 7 | 6 |
  | turnin 153 | turnin 151 | 5 | 6 |
  | accept 12 | accept 109 | 5 | 5 |
  | accept 153 | accept 9 | 4 | 4 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARLOCK | 5 | 0 | 0 | 2 | 123, 147, 176 |

- Hearthstone: APR uses it 0-1 times (WARRIOR 1, PALADIN 1, HUNTER 0, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 0; 1 "if ready" steps open to all) and binds it 1 times (maps Stormwind City (1453)); Questify uses it 0 times and binds it 0 times (maps none).

### A_Human_01 — Northshire (1-6)

- Races: Human. APR routes: #1 (Elwynn Forest (1429), 1-11): 21 shared of 119. Slice: 162 of 633 steps.
- Questify -> APR: 21 of 21 general quests in the matched routes (100 %), 21 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 19 of 27 general quests in this chapter (70 %).
  - In another Questify chapter: 60, 62, 95998, 96626
  - In no Questify chapter (APR-only): 91775, 97921, 97923, 97924 (2 160 XP)
    - not a candidate of the chapter: 91775, 97921, 97923, 97924
- Order: 46 shared events, 928 of 1035 pairs in the same order (90 %), Kendall tau 0.79.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 18 | turnin 33 | 13 | 13 |
  | accept 3903 | turnin 15 | 8 | 7 |
  | accept 6 | accept 21 | 8 | 7 |
  | complete 7 | accept 33 | 7 | 7 |
  | complete 18 | complete 33 | 6 | 8 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | PALADIN | 1 | 0 | 0 | 1 | none |
  | HUNTER | 1 | 0 | 0 | 1 | none |
  | ROGUE | 1 | 0 | 0 | 1 | none |
  | PRIEST | 4 | 0 | 2 | 2 | none |
  | MAGE | 3 | 0 | 2 | 1 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### A_Human_02 — Elwynn Forest (6-11)

- Races: Human. APR routes: #1 (Elwynn Forest (1429), 1-11): 36 shared of 119. Slice: 352 of 633 steps.
- Questify -> APR: 36 of 45 general quests in the matched routes (80 %), 39 anywhere in APR (87 %).
  - Absent from APR (Questify-only): 46, 91723, 91724, 91732, 99130, 99131 (4 115 XP)
  - In another APR route: 147, 97220, 97222
- APR -> Questify (slice): 33 of 52 general quests in this chapter (63 %).
  - In another Questify chapter: 12, 22, 36, 54, 64, 2158, 6181, 6281, 91772
  - In no Questify chapter (APR-only): 38, 47, 52, 5545, 91751, 91775, 91777, 97921, 97923, 97924 (6 440 XP)
  - Left out, quest level above 13 (band + 2): 9, 102, 151, 244, 1097
    - level band reached: 47, 52, 5545, 91775, 91777
    - not a candidate of the chapter: 38
    - requires a profession: 91751, 97921, 97923, 97924
- Order: 75 shared events, 2179 of 2775 pairs in the same order (79 %), Kendall tau 0.57.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 71 | turnin 87 | 30 | 32 |
  | accept 45 | turnin 84 | 30 | 30 |
  | accept 83 | accept 87 | 30 | 30 |
  | accept 91733 | complete 87 | 30 | 29 |
  | complete 76 | accept 84 | 27 | 29 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | PALADIN | 1 | 0 | 0 | 1 | none |
  | HUNTER | 4 | 0 | 0 | 4 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | WARLOCK | 6 | 0 | 3 | 2 | 59 |

- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 1-2 times (maps Elwynn Forest (1429), Stormwind City (1453)); Questify uses it 0 times and binds it 0 times (maps none).

### A_Human_03 — Westfall (11-16)

- Races: Human. APR routes: #1 (Elwynn Forest (1429), 1-11): 9 shared of 119; #31 (Westfall (1436), 13-15): 8 shared of 19. Slice: 244 of 712 steps.
- Questify -> APR: 11 of 22 general quests in the matched routes (50 %), 11 anywhere in APR (50 %).
  - Absent from APR (Questify-only): 13, 14, 136, 138, 139, 140, 79093, 79192, 92745, 92747, 92748 (10 600 XP)
  - In another APR route: none
- APR -> Questify (slice): 11 of 36 general quests in this chapter (31 %).
  - In another Questify chapter: 61, 109, 153, 184, 314, 417, 419, 432, 433, 95213, 95214, 96390, 96391, 96392, 96393, 96408
  - In no Questify chapter (APR-only): 38, 65, 353, 399, 1097, 6261, 6285, 6661, 92909 (7 230 XP)
    - finisher outside the chapter zones: 65
    - level band reached: 38, 92909
    - not a candidate of the chapter: 353, 399, 1097, 6261, 6285, 6661
- Order: 27 shared events, 220 of 351 pairs in the same order (63 %), Kendall tau 0.25.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 12 | turnin 6181 | 14 | 14 |
  | turnin 12 | turnin 6281 | 11 | 13 |
  | accept 92744 | accept 9 | 10 | 10 |
  | accept 92742 | turnin 36 | 10 | 8 |
  | accept 6181 | accept 64 | 8 | 8 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 4 | 0 | 0 | 4 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | WARLOCK | 8 | 0 | 0 | 3 | 59, 83, 123, 176, 244 |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1-2 times (maps Stormwind City (1453)); Questify uses it 0 times and binds it 0 times (maps none).

### A_NightElf_01 — Shadowglen (1-6)

- Races: NightElf. APR routes: #2 (Teldrassil (1438), 1-11): 17 shared of 82. Slice: 138 of 495 steps.
- Questify -> APR: 17 of 17 general quests in the matched routes (100 %), 17 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 17 of 25 general quests in this chapter (68 %).
  - In another Questify chapter: 475, 488, 997, 96606, 96634
  - In no Questify chapter (APR-only): 932, 2438, 87288 (1 665 XP)
  - Left out, quest level above 8 (band + 2): 99046
    - not a candidate of the chapter: 932, 2438, 87288
- Order: 35 shared events, 472 of 595 pairs in the same order (79 %), Kendall tau 0.59.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2159 | turnin 459 | 30 | 20 |
  | turnin 920 | turnin 97977 | 11 | 11 |
  | accept 97236 | complete 97977 | 7 | 8 |
  | turnin 97236 | turnin 3521 | 8 | 7 |
  | accept 920 | turnin 3522 | 7 | 5 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | HUNTER | 1 | 0 | 0 | 1 | none |
  | PRIEST | 4 | 0 | 0 | 3 | 97979 |
  | DRUID | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0-1 times (maps Teldrassil (1438)); Questify uses it 0 times and binds it 0 times (maps none).

### A_NightElf_02 — Teldrassil (6-11)

- Races: NightElf. APR routes: #2 (Teldrassil (1438), 1-11): 28 shared of 82. Slice: 387 of 495 steps.
- Questify -> APR: 28 of 38 general quests in the matched routes (74 %), 28 anywhere in APR (74 %).
  - Absent from APR (Questify-only): 483, 2498, 2499, 2519, 2541, 2561, 98046, 98065, 98391, 99053 (6 045 XP)
  - In another APR route: none
- APR -> Questify (slice): 28 of 45 general quests in this chapter (62 %).
  - In another Questify chapter: 928, 2159, 96630
  - In no Questify chapter (APR-only): 487, 919, 930, 932, 940, 2399, 2438, 2459, 4161, 6343, 87288, 98067, 99050, 99073 (8 680 XP)
  - Left out, quest level above 13 (band + 2): 952
    - level band reached: 487, 919, 930, 932, 940, 2399, 2438, 87288, 98067
    - not a candidate of the chapter: 6343
    - objective item source not in zone: 2459, 99050
    - prerequisite unavailable: 99073
    - requires a profession: 4161
- Order: 44 shared events, 772 of 946 pairs in the same order (82 %), Kendall tau 0.63.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 929 | turnin 997 | 12 | 14 |
  | accept 933 | complete 918 | 12 | 13 |
  | complete 933 | accept 922 | 13 | 12 |
  | turnin 933 | turnin 918 | 11 | 14 |
  | complete 7383 | complete 489 | 17 | 10 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | HUNTER | 4 | 0 | 0 | 4 | none |
  | ROGUE | 2 | 0 | 0 | 2 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | DRUID | 6 | 0 | 0 | 6 | none |

- Hearthstone: APR uses it 0-1 times (WARRIOR 1, PALADIN 0, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0-1 times (maps Teldrassil (1438)); Questify uses it 0 times and binds it 0 times (maps none).

### A_NightElf_03 — Darkshore (11-20)

- Races: NightElf. APR routes: #32 (Darkshore (1439), 11-19): 55 shared of 107; #45 (Darkshore (1439), 20-21): 18 shared of 33; #49 (Stonetalon Mountains (1442), 21-23): 8 shared of 32. Slice: 936 of 1040 steps.
- Questify -> APR: 55 of 61 general quests in the matched routes (90 %), 55 anywhere in APR (90 %).
  - Absent from APR (Questify-only): 990, 1275, 5713, 87760, 98013, 98028 (6 545 XP)
  - In another APR route: none
- APR -> Questify (slice): 54 of 92 general quests in this chapter (59 %).
  - In another Questify chapter: 224, 257, 298, 301, 307, 314, 385, 991, 1007, 1008, 1010, 1020, 1023, 1033, 1070, 1134, 1338, 1339, 2039, 6342, 86758, 97914
  - In no Questify chapter (APR-only): 267, 416, 418, 436, 730, 952, 968, 970, 995, 1056, 1141, 2178, 5321, 86614, 95065, 97926 (14 810 XP)
  - Left out, quest level above 22 (band + 2): 973, 1009, 1025, 1034, 1054, 3765
    - exclusive with another quest: 995
    - exploration point not in zone: 5321
    - finisher outside the chapter zones: 968
    - not a candidate of the chapter: 267, 416, 418, 436, 730, 952, 970, 1056, 86614, 95065, 97926
    - objective item source not in zone: 1141
    - requires a profession: 2178
- Order: 140 shared events, 8030 of 9730 pairs in the same order (83 %), Kendall tau 0.65.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 4811 | accept 1138 | 53 | 53 |
  | accept 4733 | turnin 1138 | 52 | 52 |
  | complete 1002 | turnin 953 | 51 | 56 |
  | accept 4732 | turnin 1003 | 43 | 47 |
  | turnin 4732 | complete 945 | 40 | 43 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 0 | 97220, 97222 |
  | HUNTER | 5 | 0 | 1 | 0 | 741, 942, 97220, 97222 |
  | ROGUE | 2 | 0 | 0 | 0 | 97220, 97222 |
  | DRUID | 7 | 0 | 0 | 6 | 6343 |

- Hearthstone: APR uses it 1-5 times (WARRIOR 5, PALADIN 1, HUNTER 5, ROGUE 5, PRIEST 5, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 5; 4 "if ready" steps open to all) and binds it 2-4 times (maps Darkshore (1439), Ashenvale (1440)); Questify uses it 3 times and binds it 1 times (maps Darkshore (1439)).

### A_Skyborne_01 — Zephras Isle (1-15)

- Races: Skyborne. APR routes: #4 (Zephras Isle (2521), 1-13): 67 shared of 114. Slice: 714 of 773 steps.
- Questify -> APR: 67 of 73 general quests in the matched routes (92 %), 67 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 92947, 93089, 93835, 93958, 94369, 94493 (4 070 XP)
  - In another APR route: none
- APR -> Questify (slice): 67 of 92 general quests in this chapter (73 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 92461, 92463, 92473, 92474, 92515, 92516, 92544, 92553, 92597, 93319, 93552, 93951, 94484, 94897, 97963, 97964, 97965, 97967, 97968, 97969, 97970, 97971, 97973, 98285, 98286 (12 315 XP)
    - exclusive with another quest: 94484
    - level band reached: 92461, 92463, 92473, 92474, 92515, 92516, 92544, 92553, 92597, 93319, 93951
    - low ratio: 93552
    - objective item source not in zone: 94897
    - requires a profession: 97963, 97964, 97965, 97967, 97968, 97969, 97970, 97971, 97973, 98285, 98286
- Order: 174 shared events, 12295 of 15051 pairs in the same order (82 %), Kendall tau 0.63.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 94491 | turnin 92703 | 79 | 65 |
  | complete 94489 | turnin 92693 | 63 | 63 |
  | turnin 94486 | turnin 92698 | 62 | 64 |
  | complete 94486 | turnin 92684 | 63 | 62 |
  | accept 94488 | complete 92685 | 61 | 62 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | HUNTER | 5 | 0 | 0 | 5 | none |
  | ROGUE | 1 | 0 | 0 | 1 | none |
  | MAGE | 3 | 0 | 0 | 2 | 93797 |
  | DRUID | 3 | 0 | 0 | 3 | none |

- Hearthstone: APR uses it 1-3 times (WARRIOR 3, PALADIN 1, HUNTER 3, ROGUE 3, PRIEST 1, SHAMAN 1, MAGE 3, WARLOCK 1, DRUID 3; 3 "if ready" steps open to all) and binds it 2 times (maps Zephras Isle (2521)); Questify uses it 0 times and binds it 0 times (maps none).

### A_01 — Darkshore (16-19)

- Races: Dwarf, Gnome, Human, Skyborne. APR routes: #32 (Darkshore (1439), 11-19): 36 shared of 81; #45 (Darkshore (1439), 20-21): 15 shared of 32; #49 (Stonetalon Mountains (1442), 21-23): 6 shared of 36. Slice: 908 of 953 steps.
- Questify -> APR: 36 of 42 general quests in the matched routes (86 %), 37 anywhere in APR (88 %).
  - Absent from APR (Questify-only): 990, 5713, 78124, 98013, 98028 (5 345 XP)
  - In another APR route: 97914
- APR -> Questify (slice): 35 of 76 general quests in this chapter (46 %).
  - In another Questify chapter: 953, 954, 955, 956, 957, 958, 963, 982, 983, 991, 1001, 1002, 1003, 1007, 1008, 1010, 1020, 1023, 1070, 1071, 1075, 1085, 1093, 1134, 1138, 4722, 4723, 4725, 4728, 4730, 98025
  - In no Questify chapter (APR-only): 741, 942, 968, 970, 995, 1056, 1072, 1141, 2178, 5321 (12 030 XP)
  - Left out, quest level above 21 (band + 2): 973, 1009, 1025, 1033, 1034, 1054, 3765
    - exclusive with another quest: 995
    - exploration point not in zone: 5321
    - finisher outside the chapter zones: 741, 968
    - not a candidate of the chapter: 942, 970, 1056, 1072
    - objective item source not in zone: 1141
    - quest level below the band: 2178
- Order: 89 shared events, 3161 of 3916 pairs in the same order (81 %), Kendall tau 0.61.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2098 | accept 2139 | 48 | 41 |
  | accept 966 | turnin 2138 | 36 | 37 |
  | turnin 965 | turnin 4681 | 31 | 50 |
  | accept 967 | accept 4763 | 32 | 31 |
  | turnin 966 | turnin 4762 | 32 | 31 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 1 | 0 | none |
  | WARLOCK | 4 | 0 | 0 | 3 | 1094 |
  | DRUID | 6 | 0 | 0 | 6 | none |

- Hearthstone: APR uses it 2-5 times (WARRIOR 4, PALADIN 2, HUNTER 4, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 5; 2 "if ready" steps open to all) and binds it 1-3 times (maps Darkshore (1439), Ashenvale (1440)); Questify uses it 2 times and binds it 1 times (maps Darkshore (1439)).

### A_02 — Ashenvale and Stonetalon Mountains (20-22)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #32 (Darkshore (1439), 11-19): 9 shared of 107; #45 (Darkshore (1439), 20-21): 7 shared of 33; #49 (Stonetalon Mountains (1442), 21-23): 11 shared of 36. Slice: 1023 of 1202 steps.
- Questify -> APR: 15 of 29 general quests in the matched routes (52 %), 15 anywhere in APR (52 %).
  - Absent from APR (Questify-only): 990, 1090, 1092, 5713, 78124, 78132, 78133, 78134, 78149, 78270, 79192, 79974, 79980, 86574 (16 945 XP)
  - In another APR route: none
- APR -> Questify (slice): 15 of 86 general quests in this chapter (17 %).
  - In another Questify chapter: 224, 257, 298, 301, 307, 314, 385, 729, 731, 944, 947, 948, 949, 950, 951, 957, 963, 965, 966, 982, 986, 993, 1002, 1003, 1007, 1033, 1034, 1138, 1338, 1339, 2039, 2078, 2098, 2138, 2139, 4723, 4725, 4727, 4728, 4730, 4731, 4732, 4733, 4740, 4762, 4763, 4812, 4813, 86758, 98042
  - In no Questify chapter (APR-only): 267, 416, 418, 436, 730, 741, 942, 952, 968, 970, 973, 995, 1016, 1056, 1072, 2178, 3765, 5321, 86614, 95065, 97926 (19 550 XP)
  - Left out, quest level above 24 (band + 2): 1009, 1054
    - finisher outside the chapter zones: 1072
    - level band reached: 970, 973
    - manual drop (overrides.lua): 1056
    - not a candidate of the chapter: 267, 416, 418, 436, 730, 741, 942, 952, 968, 995, 2178, 3765, 5321, 86614, 95065, 97926
    - objective item source not in zone: 1016
- Order: 33 shared events, 426 of 528 pairs in the same order (81 %), Kendall tau 0.61.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1134 | turnin 97914 | 17 | 18 |
  | accept 1085 | turnin 945 | 10 | 10 |
  | accept 1023 | accept 1020 | 7 | 8 |
  | turnin 991 | turnin 1010 | 7 | 8 |
  | accept 991 | turnin 967 | 7 | 7 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 0 | 97220, 97222 |
  | HUNTER | 3 | 0 | 0 | 0 | 994, 97220, 97222 |
  | ROGUE | 2 | 0 | 0 | 0 | 97220, 97222 |
  | WARLOCK | 4 | 0 | 0 | 3 | 1094 |
  | DRUID | 7 | 0 | 0 | 6 | 6343 |

- Hearthstone: APR uses it 3-6 times (WARRIOR 5, PALADIN 3, HUNTER 6, ROGUE 5, PRIEST 5, SHAMAN 3, MAGE 3, WARLOCK 3, DRUID 6; 5 "if ready" steps open to all) and binds it 1-3 times (maps Darkshore (1439), Ashenvale (1440)); Questify uses it 1 times and binds it 0 times (maps none).

### A_03 — Redridge Mountains and Duskwood (22-26)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #43 (Redridge Mountains (1433), 19-20): 5 shared of 49; #57 (Duskwood (1431), 24-27): 41 shared of 71. Slice: 518 of 576 steps.
- Questify -> APR: 43 of 50 general quests in the matched routes (86 %), 46 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 178, 78147, 96137, 96139 (6 800 XP)
  - In another APR route: 133, 337, 377
- APR -> Questify (slice): 43 of 80 general quests in this chapter (54 %).
  - In another Questify chapter: 68, 69, 70, 72, 74, 103, 167, 168, 173, 1075, 2040
  - In no Questify chapter (APR-only): 34, 65, 89, 90, 92, 94, 104, 118, 119, 120, 121, 122, 124, 125, 126, 129, 130, 131, 244, 246, 323, 1076, 1078, 3741, 3765, 98407 (29 240 XP)
  - Left out, quest level above 28 (band + 2): 58, 269, 335
    - manual drop (overrides.lua): 34, 323
    - not a candidate of the chapter: 65, 94, 104, 119, 121, 1076, 1078, 3765
    - prerequisite unavailable: 89, 124, 126
    - quest level below the band: 92, 118, 120, 122, 125, 129, 130, 131, 244, 246, 3741, 98407
    - requires a profession: 90
- Order: 92 shared events, 2882 of 4186 pairs in the same order (69 %), Kendall tau 0.38.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 57 | turnin 98387 | 64 | 64 |
  | turnin 57 | turnin 20 | 59 | 70 |
  | turnin 245 | complete 127 | 51 | 50 |
  | accept 230 | complete 98387 | 48 | 47 |
  | turnin 95 | complete 20 | 46 | 47 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | PALADIN | 4 | 0 | 0 | 4 | none |
  | ROGUE | 4 | 0 | 0 | 4 | none |
  | WARLOCK | 5 | 0 | 0 | 5 | none |
  | DRUID | 10 | 0 | 0 | 7 | 98341, 98404, 98738 |

- Hearthstone: APR uses it 2-3 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 3, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 3; 2 "if ready" steps open to all) and binds it 1-3 times (maps Duskwood (1431), Stormwind City (1453)); Questify uses it 1 times and binds it 1 times (maps Duskwood (1431)).

### A_04 — Wetlands (26-29)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #52 (Wetlands (1437), 22-24): 4 shared of 16; #61 (Wetlands (1437), 27-29): 7 shared of 42. Slice: 230 of 298 steps.
- Questify -> APR: 7 of 21 general quests in the matched routes (33 %), 8 anywhere in APR (38 %).
  - Absent from APR (Questify-only): 304, 79974, 79975, 95646, 95647, 98189, 98216, 98223, 98230, 98240, 98245, 98815, 98824 (16 720 XP)
  - In another APR route: 288
- APR -> Questify (slice): 7 of 33 general quests in this chapter (21 %).
  - In another Questify chapter: 337
  - In no Questify chapter (APR-only): 269, 270, 275, 276, 277, 279, 281, 284, 285, 286, 290, 292, 295, 296, 299, 335, 463, 464, 465, 469, 471, 484, 943, 968, 2923 (38 885 XP)
  - Left out, quest level above 31 (band + 2): 538
    - manual drop (overrides.lua): 290, 292, 295, 296, 299, 464, 465
    - not a candidate of the chapter: 269, 270, 335, 968, 2923
    - objective item source not in zone: 943
    - prerequisite unavailable: 275, 277, 281, 284, 285, 286, 471
    - quest level below the band: 276, 279, 463, 469, 484
- Order: 17 shared events, 64 of 136 pairs in the same order (47 %), Kendall tau -0.06.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 98221 | complete 294 | 14 | 12 |
  | accept 98221 | turnin 294 | 16 | 10 |
  | turnin 472 | turnin 470 | 5 | 8 |
  | accept 289 | turnin 305 | 5 | 5 |
  | accept 472 | complete 470 | 6 | 4 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 474 |
  | MAGE | 1 | 0 | 0 | 0 | 474 |
  | WARLOCK | 1 | 0 | 0 | 0 | 474 |

- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps Wetlands (1437)); Questify uses it 0 times and binds it 1 times (maps Wetlands (1437)).

### A_05 — Hillsbrad Foothills (29-30)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #68 (Hillsbrad Foothills (1424), 32-33): 7 shared of 27. Slice: 48 of 104 steps.
- Questify -> APR: 7 of 11 general quests in the matched routes (64 %), 7 anywhere in APR (64 %).
  - Absent from APR (Questify-only): 79975, 79976, 98059, 98071 (3 480 XP)
  - In another APR route: none
- APR -> Questify (slice): 7 of 8 general quests in this chapter (88 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 689 (2 500 XP)
  - Left out, quest level above 32 (band + 2): 505, 510, 511, 514, 522, 564, 565
    - not a candidate of the chapter: 689
- Order: 16 shared events, 105 of 120 pairs in the same order (88 %), Kendall tau 0.75.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 555 | turnin 560 | 7 | 7 |
  | turnin 555 | accept 563 | 2 | 2 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1 times (maps Hillsbrad Foothills (1424)); Questify uses it 1 times and binds it 0 times (maps none).

### A_08 — Ashenvale (30-32)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #63 (Ashenvale (1440), 29-30): 16 shared of 26. Slice: 85 of 132 steps.
- Questify -> APR: 16 of 24 general quests in the matched routes (67 %), 20 anywhere in APR (83 %).
  - Absent from APR (Questify-only): 1012, 86757, 98027, 98418 (9 150 XP)
  - In another APR route: 1007, 1009, 1033, 1034
- APR -> Questify (slice): 16 of 22 general quests in this chapter (73 %).
  - In another Questify chapter: 1025
  - In no Questify chapter (APR-only): 973, 1016, 1037, 1046, 1140 (9 080 XP)
    - finisher outside the chapter zones: 1037
    - objective item source not in zone: 1016, 1046
    - prerequisite dropped: 973, 1140
- Order: 41 shared events, 640 of 820 pairs in the same order (78 %), Kendall tau 0.56.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 1026 | accept 4581 | 18 | 20 |
  | accept 1027 | turnin 1054 | 16 | 16 |
  | complete 1011 | accept 1035 | 16 | 16 |
  | accept 1055 | turnin 4581 | 15 | 15 |
  | turnin 1029 | complete 1035 | 11 | 12 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### A_07 — Duskwood (32-33)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #64 (Duskwood (1431), 29-32): 21 shared of 66. Slice: 124 of 237 steps.
- Questify -> APR: 21 of 27 general quests in the matched routes (78 %), 26 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 96138 (2 450 XP)
  - In another APR route: 68, 69, 70, 72, 563
- APR -> Questify (slice): 21 of 38 general quests in this chapter (55 %).
  - In another Questify chapter: 101, 133, 159, 185, 190, 215, 377, 583
  - In no Questify chapter (APR-only): 55, 228, 229, 231, 325, 335, 1243, 1244, 1245 (13 490 XP)
    - manual drop (overrides.lua): 228, 229, 231
    - not a candidate of the chapter: 325, 335
    - prerequisite unavailable: 55, 1243, 1244, 1245
- Order: 50 shared events, 967 of 1225 pairs in the same order (79 %), Kendall tau 0.58.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 251 | accept 78 | 19 | 18 |
  | turnin 160 | complete 75 | 18 | 19 |
  | turnin 251 | turnin 75 | 17 | 20 |
  | accept 401 | accept 75 | 14 | 23 |
  | accept 222 | accept 97 | 14 | 15 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps Duskwood (1431)); Questify uses it 2 times and binds it 1 times (maps Duskwood (1431)).

### A_09 — Thousand Needles (33-34)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #69 (Thousand Needles (1441), 33-34): 9 shared of 41; #74 (Desolace (1443), 35-37): 3 shared of 30. Slice: 201 of 264 steps.
- Questify -> APR: 11 of 12 general quests in the matched routes (92 %), 11 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 1221 (630 XP)
  - In another APR route: none
- APR -> Questify (slice): 11 of 38 general quests in this chapter (29 %).
  - In another Questify chapter: 1219, 1220, 1253, 1282, 1284, 1319, 1320, 1387, 1437, 1438, 1439, 1440, 1465, 5561, 5741, 6161
  - In no Questify chapter (APR-only): 1039, 1040, 1104, 1135, 1179, 1370, 1382, 1384, 1453, 1458, 1459 (22 410 XP)
  - Left out, quest level above 36 (band + 2): 1183, 1186, 1187, 1252, 1259, 1285, 1373, 1454, 1455, 1456, 1457, 5501, 6027
    - manual drop (overrides.lua): 1104
    - not a candidate of the chapter: 1039, 1135, 1179, 1370, 1382, 1384, 1453, 1458, 1459
    - prerequisite unavailable: 1040
- Order: 23 shared events, 183 of 253 pairs in the same order (72 %), Kendall tau 0.45.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1112 | turnin 1175 | 11 | 10 |
  | accept 5762 | complete 1105 | 9 | 9 |
  | accept 1111 | complete 1175 | 14 | 7 |
  | turnin 1111 | turnin 1105 | 9 | 6 |
  | accept 1178 | complete 1110 | 6 | 3 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 4 | 0 | 0 | 4 | none |
  | WARLOCK | 4 | 0 | 0 | 4 | none |

- Hearthstone: APR uses it 2-3 times (WARRIOR 3, PALADIN 3, HUNTER 3, ROGUE 3, PRIEST 3, SHAMAN 3, MAGE 3, WARLOCK 2, DRUID 3; 3 "if ready" steps open to all) and binds it 1 times (maps Desolace (1443)); Questify uses it 0 times and binds it 0 times (maps none).

### A_10 — Stranglethorn Vale (34-35)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #64 (Duskwood (1431), 29-32): 4 shared of 66; #72 (Stranglethorn Vale (1434), 34-35): 15 shared of 46; #77 (Stranglethorn Vale (1434), 36-38): 6 shared of 26. Slice: 324 of 495 steps.
- Questify -> APR: 18 of 18 general quests in the matched routes (100 %), 18 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 18 of 66 general quests in this chapter (27 %).
  - In another Questify chapter: 188, 189, 201, 213, 222, 223, 253, 337, 563, 575, 577, 578, 601, 605, 616, 1115, 1180, 1181, 1182, 1183
  - In no Questify chapter (APR-only): 55, 198, 228, 229, 231, 325, 335, 336, 514, 622, 627, 689, 690, 700, 1040, 1041, 1042, 1043, 1078, 1245, 1246, 1247, 1248, 1301, 1447, 1453, 2904, 2923 (38 160 XP)
  - Left out, quest level above 37 (band + 2): 192, 193, 196, 202, 205, 207, 538, 574
    - not a candidate of the chapter: 55, 198, 228, 229, 231, 325, 335, 336, 514, 622, 627, 689, 690, 700, 1040, 1041, 1042, 1043, 1078, 1245, 1246, 1247, 1248, 1301, 1447, 1453, 2904, 2923
- Order: 43 shared events, 733 of 903 pairs in the same order (81 %), Kendall tau 0.62.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 194 | complete 185 | 16 | 18 |
  | accept 329 | turnin 203 | 19 | 15 |
  | turnin 328 | turnin 204 | 21 | 13 |
  | accept 210 | turnin 190 | 11 | 14 |
  | turnin 200 | turnin 185 | 8 | 9 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | HUNTER | 1 | 0 | 0 | 0 | 1107 |
  | WARLOCK | 4 | 0 | 0 | 4 | none |

- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 2 times (maps Stranglethorn Vale (1434)); Questify uses it 1 times and binds it 0 times (maps none).

### A_11 — Desolace (35-37)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #74 (Desolace (1443), 35-37): 9 shared of 30. Slice: 78 of 142 steps.
- Questify -> APR: 9 of 14 general quests in the matched routes (64 %), 10 anywhere in APR (71 %).
  - Absent from APR (Questify-only): 5821, 5943, 79950, 92743 (10 300 XP)
  - In another APR route: 635
- APR -> Questify (slice): 9 of 21 general quests in this chapter (43 %).
  - In another Questify chapter: 5501
  - In no Questify chapter (APR-only): 1370, 1373, 1382, 1384, 1454, 1455, 1456, 1457, 1458, 1459, 6027 (26 750 XP)
    - manual drop (overrides.lua): 1370, 1373, 1382, 1384, 6027
    - prerequisite unavailable: 1454, 1455, 1456, 1457, 1458, 1459
- Order: 24 shared events, 205 of 276 pairs in the same order (74 %), Kendall tau 0.49.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1440 | accept 6161 | 10 | 11 |
  | turnin 1439 | complete 6161 | 12 | 9 |
  | complete 1439 | complete 1387 | 9 | 6 |
  | accept 1439 | accept 5561 | 7 | 6 |
  | turnin 1465 | accept 5741 | 5 | 5 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1-2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 1, DRUID 2; 2 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 0 times (maps none).

### A_12 — Stranglethorn Vale and Swamp of Sorrows (37-39)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #72 (Stranglethorn Vale (1434), 34-35): 14 shared of 46; #77 (Stranglethorn Vale (1434), 36-38): 11 shared of 26; #80 (Swamp of Sorrows (1435), 38-39): 6 shared of 18; #89 (Stranglethorn Vale (1434), 41-43): 12 shared of 48. Slice: 510 of 555 steps.
- Questify -> APR: 36 of 39 general quests in the matched routes (92 %), 36 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 79535, 79953, 93176 (4 785 XP)
  - In another APR route: none
- APR -> Questify (slice): 36 of 93 general quests in this chapter (39 %).
  - In another Questify chapter: 185, 186, 187, 190, 191, 193, 194, 195, 196, 200, 202, 203, 204, 215, 328, 329, 330, 331, 337, 563, 583, 587, 669, 1117, 1183, 5762
  - In no Questify chapter (APR-only): 55, 198, 228, 229, 231, 325, 338, 340, 514, 525, 538, 542, 543, 603, 610, 611, 622, 627, 689, 700, 1040, 1041, 1042, 1043, 1260, 1363, 1364, 1373, 1453, 1457, 2904 (54 715 XP)
  - Left out, quest level above 41 (band + 2): 197, 208, 209, 576, 604, 609, 617, 621, 624, 1118, 1448, 1449, 1477
    - level band reached: 198, 340
    - not a candidate of the chapter: 55, 228, 229, 231, 325, 514, 525, 538, 542, 543, 603, 689, 700, 1040, 1042, 1043, 1260, 1363, 1364, 1373, 1453, 1457, 2904
    - objective item source not in zone: 338, 627
    - prerequisite unavailable: 610, 611, 622, 1041
- Order: 89 shared events, 2872 of 3916 pairs in the same order (73 %), Kendall tau 0.47.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 341 | turnin 1182 | 62 | 62 |
  | accept 339 | turnin 213 | 60 | 64 |
  | accept 342 | complete 192 | 61 | 53 |
  | accept 606 | complete 574 | 33 | 34 |
  | accept 600 | complete 601 | 33 | 27 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | HUNTER | 1 | 0 | 0 | 0 | 1107 |
  | WARLOCK | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 4-5 times (WARRIOR 4, PALADIN 4, HUNTER 4, ROGUE 4, PRIEST 4, SHAMAN 4, MAGE 4, WARLOCK 5, DRUID 4; 4 "if ready" steps open to all) and binds it 3-5 times (maps Stranglethorn Vale (1434), Stormwind City (1453)); Questify uses it 4 times and binds it 1 times (maps Stranglethorn Vale (1434)).

### A_13 — Arathi Highlands (39-40)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #83 (Arathi Highlands (1417), 39-40): 13 shared of 49. Slice: 196 of 246 steps.
- Questify -> APR: 13 of 17 general quests in the matched routes (76 %), 14 anywhere in APR (82 %).
  - Absent from APR (Questify-only): 682, 79949, 96800 (7 725 XP)
  - In another APR route: 681
- APR -> Questify (slice): 13 of 33 general quests in this chapter (39 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 500, 512, 522, 523, 525, 537, 538, 540, 543, 551, 603, 652, 653, 657, 658, 659, 660, 661, 694, 1052 (48 540 XP)
  - Left out, quest level above 42 (band + 2): 1449, 1450, 1451, 1452
    - finisher outside the chapter zones: 551, 661
    - low ratio: 603
    - manual drop (overrides.lua): 652, 653, 694
    - not a candidate of the chapter: 500, 512, 522, 523, 525, 537, 538, 540, 543, 659, 1052
    - prerequisite unavailable: 657, 658, 660
- Order: 31 shared events, 386 of 465 pairs in the same order (83 %), Kendall tau 0.66.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 666 | turnin 602 | 13 | 12 |
  | complete 666 | turnin 651 | 10 | 11 |
  | complete 662 | turnin 693 | 10 | 10 |
  | turnin 665 | complete 693 | 11 | 9 |
  | complete 691 | accept 651 | 3 | 2 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 3 | 0 | 0 | 3 | none |
  | HUNTER | 1 | 0 | 0 | 0 | 684 |
  | ROGUE | 1 | 0 | 0 | 0 | 684 |
  | DRUID | 1 | 0 | 0 | 0 | 684 |

- Hearthstone: APR uses it 7 times (WARRIOR 7, PALADIN 7, HUNTER 7, ROGUE 7, PRIEST 7, SHAMAN 7, MAGE 7, WARLOCK 7, DRUID 7; 7 "if ready" steps open to all) and binds it 1 times (maps Hillsbrad Foothills (1424)); Questify uses it 0 times and binds it 0 times (maps none).

### A_15 — Dustwallow Marsh (40-41)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #85 (Wetlands (1437), 40-40): 7 shared of 22. Slice: 45 of 65 steps.
- Questify -> APR: 7 of 23 general quests in the matched routes (30 %), 20 anywhere in APR (87 %).
  - Absent from APR (Questify-only): 6132, 7070, 79952 (6 725 XP)
  - In another APR route: 261, 1219, 1220, 1252, 1253, 1259, 1282, 1284, 1285, 1319, 1320, 5501, 6134
- APR -> Questify (slice): 7 of 14 general quests in this chapter (50 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 1187, 1203, 1258, 1260, 1266, 1267, 1324 (17 760 XP)
    - not a candidate of the chapter: 1187, 1260
    - objective item source not in zone: 1203, 1258
    - prerequisite unavailable: 1266, 1267, 1324
- Order: 17 shared events, 95 of 136 pairs in the same order (70 %), Kendall tau 0.40.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 1222 | complete 1204 | 8 | 11 |
  | accept 1222 | complete 1177 | 7 | 6 |
  | complete 1222 | turnin 1218 | 4 | 4 |
  | accept 1287 | turnin 1206 | 4 | 3 |
  | accept 1204 | accept 1286 | 4 | 1 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### A_16 — Badlands (41-42)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #88 (Badlands (1418), 41-41): 10 shared of 30. Slice: 61 of 116 steps.
- Questify -> APR: 10 of 17 general quests in the matched routes (59 %), 11 anywhere in APR (65 %).
  - Absent from APR (Questify-only): 721, 2198, 2418, 79949, 79951, 79952 (11 100 XP)
  - In another APR route: 669
- APR -> Questify (slice): 10 of 25 general quests in this chapter (40 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 687, 692, 705, 713, 714, 715, 716, 734, 738, 739, 777, 1106, 1108, 1137, 2500 (33 900 XP)
  - Left out, quest level above 44 (band + 2): 778
    - not a candidate of the chapter: 687, 738, 1106, 2500
    - objective item source not in zone: 705, 713, 714, 715, 716
    - prerequisite unavailable: 692, 734, 739, 777, 1108, 1137
- Order: 27 shared events, 255 of 351 pairs in the same order (73 %), Kendall tau 0.45.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 710 | accept 720 | 10 | 11 |
  | complete 711 | turnin 719 | 10 | 10 |
  | accept 711 | accept 733 | 9 | 10 |
  | complete 710 | turnin 718 | 10 | 9 |
  | turnin 710 | complete 719 | 7 | 12 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 0 times (maps none).

### A_17 — Stranglethorn Vale (42-44)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #89 (Stranglethorn Vale (1434), 41-43): 13 shared of 48. Slice: 152 of 184 steps.
- Questify -> APR: 13 of 16 general quests in the matched routes (81 %), 16 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: 348, 1117, 1183
- APR -> Questify (slice): 13 of 45 general quests in this chapter (29 %).
  - In another Questify chapter: 205, 339, 341, 342, 595, 597, 599, 600, 606, 607, 624, 628, 669, 1116, 1398, 1425
  - In no Questify chapter (APR-only): 338, 340, 603, 610, 611, 622, 623, 625, 627, 1118, 1119, 1258, 1364, 1395, 1477, 2864 (38 685 XP)
  - Left out, quest level above 46 (band + 2): 580
    - dungeon quest not picked up: 2864
    - finisher outside the chapter zones: 623, 625
    - low ratio: 340
    - not a candidate of the chapter: 603, 1118, 1258, 1364, 1395, 1477
    - objective item source not in zone: 338, 627
    - prerequisite unavailable: 610, 611, 622, 1119
- Order: 34 shared events, 363 of 561 pairs in the same order (65 %), Kendall tau 0.29.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2872 | complete 197 | 24 | 26 |
  | turnin 587 | turnin 202 | 16 | 17 |
  | complete 576 | complete 196 | 15 | 14 |
  | complete 621 | turnin 193 | 11 | 11 |
  | turnin 621 | accept 197 | 9 | 16 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1-2 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 2, DRUID 1; 1 "if ready" steps open to all) and binds it 1 times (maps Stranglethorn Vale (1434)); Questify uses it 0 times and binds it 0 times (maps none).

### A_18 — Tanaris (44-45)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #93 (Tanaris (1446), 43-44): 6 shared of 24. Slice: 56 of 88 steps.
- Questify -> APR: 6 of 15 general quests in the matched routes (40 %), 12 anywhere in APR (80 %).
  - Absent from APR (Questify-only): 2768, 2865, 3042 (7 050 XP)
  - In another APR route: 992, 1117, 1183, 1691, 2781, 2875
- APR -> Questify (slice): 6 of 17 general quests in this chapter (35 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 1119, 1120, 1122, 1137, 1188, 1189, 1190, 1194, 2864, 3022, 3520 (18 120 XP)
    - finisher outside the chapter zones: 1122, 3022
    - not a candidate of the chapter: 1119, 1137, 2864
    - objective npc not in zone: 3520
    - prerequisite unavailable: 1120, 1188, 1189, 1190, 1194
- Order: 10 shared events, 45 of 45 pairs in the same order (100 %), Kendall tau 1.00.
- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 3161 |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 1 times (maps Tanaris (1446)).

### A_19 — Feralas (45-46)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #96 (Feralas (1444), 44-48): 22 shared of 32. Slice: 173 of 179 steps.
- Questify -> APR: 22 of 24 general quests in the matched routes (92 %), 24 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: 7721, 7733
- APR -> Questify (slice): 22 of 31 general quests in this chapter (71 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 1452, 2939, 2940, 2941, 2972, 3022, 3520, 3661, 4267 (23 345 XP)
  - Left out, quest level above 48 (band + 2): 3445
    - finisher outside the chapter zones: 2939, 2972, 4267
    - not a candidate of the chapter: 1452, 2940, 2941, 3022, 3520, 3661
- Order: 51 shared events, 940 of 1275 pairs in the same order (74 %), Kendall tau 0.47.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2970 | complete 2870 | 29 | 21 |
  | accept 2969 | complete 2869 | 22 | 21 |
  | complete 2969 | turnin 2869 | 22 | 21 |
  | turnin 2821 | turnin 2870 | 22 | 21 |
  | turnin 2969 | accept 2870 | 22 | 21 |

- Class quests: none on either side.
- Hearthstone: APR uses it 4 times (WARRIOR 4, PALADIN 4, HUNTER 4, ROGUE 4, PRIEST 4, SHAMAN 4, MAGE 4, WARLOCK 4, DRUID 4; 4 "if ready" steps open to all) and binds it 1 times (maps Feralas (1444)); Questify uses it 0 times and binds it 0 times (maps none).

### A_20 — Tanaris (46-48)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #101 (Tanaris (1446), 48-50): 8 shared of 54. Slice: 102 of 200 steps.
- Questify -> APR: 8 of 9 general quests in the matched routes (89 %), 8 anywhere in APR (89 %).
  - Absent from APR (Questify-only): 81949 (975 XP)
  - In another APR route: none
- APR -> Questify (slice): 8 of 30 general quests in this chapter (27 %).
  - In another Questify chapter: 1691, 2781, 2873, 2875, 8365, 8366
  - In no Questify chapter (APR-only): 485, 580, 836, 1452, 1469, 2605, 2876, 2877, 2880, 2944, 2988, 2989, 3362, 3520, 3661, 5863 (70 550 XP)
  - Left out, quest level above 50 (band + 2): 626, 3444, 3445
    - far: 2605, 3362
    - finisher outside the chapter zones: 2944
    - manual drop (overrides.lua): 5863
    - not a candidate of the chapter: 485, 580, 836, 1452, 1469, 2876, 2877, 2880, 2988, 2989, 3661
    - objective npc not in zone: 3520
- Order: 18 shared events, 128 of 153 pairs in the same order (84 %), Kendall tau 0.67.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 3161 | complete 648 | 7 | 7 |
  | turnin 110 | accept 2874 | 3 | 3 |
  | turnin 351 | complete 3161 | 3 | 3 |
  | accept 351 | complete 10 | 3 | 1 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### A_21 — Stranglethorn Vale (48-50)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #104 (Stranglethorn Vale (1434), 50-50): 8 shared of 15. Slice: 53 of 87 steps.
- Questify -> APR: 8 of 12 general quests in the matched routes (67 %), 11 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 81947 (975 XP)
  - In another APR route: 624, 1398, 1425
- APR -> Questify (slice): 8 of 14 general quests in this chapter (57 %).
  - In another Questify chapter: 348
  - In no Questify chapter (APR-only): 580, 630, 836, 1122, 3721 (26 450 XP)
    - manual drop (overrides.lua): 630
    - not a candidate of the chapter: 836, 1122
    - objective item source not in zone: 580
    - prerequisite unavailable: 3721
- Order: 14 shared events, 59 of 91 pairs in the same order (65 %), Kendall tau 0.30.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 8552 | turnin 2767 | 7 | 7 |
  | accept 8553 | accept 594 | 7 | 6 |
  | turnin 8553 | turnin 594 | 7 | 5 |
  | turnin 608 | turnin 8551 | 1 | 4 |
  | accept 608 | turnin 2874 | 1 | 1 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### A_22 — Searing Gorge and Blasted Lands (50-52)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #105 (Searing Gorge (1427), 50-51): 21 shared of 26; #106 (Blasted Lands (1419), 51-51): 5 shared of 10. Slice: 173 of 195 steps.
- Questify -> APR: 26 of 32 general quests in the matched routes (81 %), 27 anywhere in APR (84 %).
  - Absent from APR (Questify-only): 4128, 81947, 81949, 81955, 81956 (4 180 XP)
  - In another APR route: 1425
- APR -> Questify (slice): 26 of 27 general quests in this chapter (96 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 3182 (4 400 XP)
  - Left out, quest level above 54 (band + 2): 2783, 2801, 7791, 7793, 7794, 7795
    - not a candidate of the chapter: 3182
- Order: 63 shared events, 1114 of 1953 pairs in the same order (57 %), Kendall tau 0.14.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2581 | complete 7727 | 50 | 48 |
  | accept 2583 | accept 3454 | 36 | 35 |
  | accept 2585 | accept 3453 | 36 | 35 |
  | turnin 2581 | accept 3463 | 35 | 34 |
  | turnin 2583 | turnin 3462 | 33 | 33 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### A_28 — Burning Steppes (52-53)

No APR leveling route shares enough quests with this chapter.

### A_24 — Felwood (53-54)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #109 (Felwood (1448), 52-52): 8 shared of 29; #115 (Felwood (1448), 54-56): 6 shared of 47. Slice: 280 of 484 steps.
- Questify -> APR: 14 of 15 general quests in the matched routes (93 %), 14 anywhere in APR (93 %).
  - Absent from APR (Questify-only): 5249 (580 XP)
  - In another APR route: none
- APR -> Questify (slice): 14 of 38 general quests in this chapter (37 %).
  - In another Questify chapter: 980, 5082, 5084, 5085, 5086, 5156
  - In no Questify chapter (APR-only): 978, 3908, 3909, 3912, 3913, 3914, 3941, 3942, 4261, 4441, 4442, 4512, 5158, 5159, 5165, 6031, 8467, 8470 (82 610 XP)
  - Left out, quest level above 56 (band + 2): 5242
    - finisher outside the chapter zones: 5158
    - manual drop (overrides.lua): 6031, 8470
    - not a candidate of the chapter: 978, 3908, 3909, 3912, 3913, 3914, 3941, 3942, 4512, 5159
    - objective item source not in zone: 4441
    - prerequisite unavailable: 4261, 4442, 5165
    - repeatable: 8467
- Order: 35 shared events, 417 of 595 pairs in the same order (70 %), Kendall tau 0.40.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 5083 | complete 5157 | 19 | 20 |
  | accept 8465 | turnin 5157 | 18 | 13 |
  | accept 8461 | complete 4906 | 13 | 15 |
  | complete 8461 | complete 939 | 12 | 14 |
  | turnin 8461 | turnin 4906 | 16 | 11 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 979 |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### A_26 — Un'Goro Crater (54-56)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #113 (Un'Goro Crater (1449), 53-54): 19 shared of 44; #115 (Felwood (1448), 54-56): 3 shared of 47. Slice: 245 of 478 steps.
- Questify -> APR: 21 of 27 general quests in the matched routes (78 %), 26 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 5249 (580 XP)
  - In another APR route: 3844, 4141, 4290, 4291, 4808
- APR -> Questify (slice): 21 of 51 general quests in this chapter (41 %).
  - In another Questify chapter: 5082, 5202, 5203, 5882, 8461
  - In no Questify chapter (APR-only): 978, 979, 1047, 3763, 3764, 3781, 3908, 3909, 3912, 4244, 4245, 4261, 4441, 4442, 4496, 4502, 4513, 5159, 5165, 5250, 6031, 6761, 6762, 8467, 8470 (99 300 XP)
  - Left out, quest level above 58 (band + 2): 7792, 7798, 7799, 7800
    - not a candidate of the chapter: 978, 979, 1047, 3763, 3764, 3781, 3909, 3912, 4261, 4441, 4442, 4496, 4502, 4513, 5159, 5165, 5250, 6031, 6761, 6762, 8467, 8470
    - objective item source not in zone: 4244
    - prerequisite unavailable: 3908, 4245
- Order: 51 shared events, 958 of 1275 pairs in the same order (75 %), Kendall tau 0.50.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 4243 | complete 4287 | 25 | 30 |
  | turnin 4243 | complete 4288 | 24 | 23 |
  | complete 4503 | accept 4285 | 18 | 19 |
  | accept 3884 | complete 4285 | 17 | 25 |
  | accept 974 | turnin 4284 | 17 | 18 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### A_27 — Felwood and Winterspring (56-57)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #115 (Felwood (1448), 54-56): 16 shared of 47; #120 (Eastern Plaguelands (1423), 57-59): 4 shared of 66; #122 (Winterspring (1452), 59-60): 7 shared of 57. Slice: 742 of 882 steps.
- Questify -> APR: 22 of 25 general quests in the matched routes (88 %), 23 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 6603, 6604 (1 220 XP)
  - In another APR route: 5156
- APR -> Questify (slice): 22 of 117 general quests in this chapter (19 %).
  - In another Questify chapter: 4808, 4971, 4984, 4985, 5058, 5060, 5083, 5092, 5203, 5211, 5215, 5216, 5217, 5219, 5220, 5401, 5542, 5543, 5544, 5742, 5781, 5845, 6004, 6021, 6023, 8277, 8280, 8281, 8283, 8284, 8285
  - In no Questify chapter (APR-only): 978, 979, 1124, 1125, 1126, 3378, 3912, 3913, 3914, 3941, 3942, 3961, 3962, 4005, 4084, 4261, 4504, 4507, 4508, 4513, 4901, 4972, 4986, 5050, 5051, 5059, 5066, 5097, 5121, 5142, 5149, 5152, 5153, 5154, 5163, 5165, 5168, 5181, 5210, 5222, 5223, 5225, 5226, 5237, 5241, 5242, 5250, 5533, 5537, 5846, 5903, 5904, 6025, 6026, 6389, 6762, 6844, 8275, 8278, 8282, 8307, 8313, 8317, 8323 (300 075 XP)
  - Left out, quest level above 59 (band + 2): 969, 5281, 5527, 6024, 6184, 6185, 6186, 7791, 7793, 7794, 7795, 8279, 8287, 8304, 8308, 8318, 9124, 9126, 9128, 9131, 9136
    - finisher outside the chapter zones: 3912, 4005, 4261, 4901
    - manual drop (overrides.lua): 5121
    - not a candidate of the chapter: 978, 979, 1124, 1125, 1126, 3378, 3913, 3914, 3941, 3942, 3961, 3962, 4504, 4507, 4508, 4513, 4972, 4986, 5050, 5051, 5059, 5066, 5097, 5142, 5149, 5152, 5153, 5154, 5168, 5181, 5210, 5222, 5223, 5225, 5226, 5237, 5241, 5250, 5533, 5537, 5846, 5903, 5904, 6025, 6026, 6389, 6762, 6844, 8275, 8278, 8282, 8307, 8313, 8317, 8323
    - objective npc not in zone: 5163
    - prerequisite unavailable: 4084, 5165, 5242
- Order: 49 shared events, 775 of 1176 pairs in the same order (66 %), Kendall tau 0.32.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 3783 | turnin 5082 | 37 | 33 |
  | accept 4809 | accept 5204 | 43 | 26 |
  | accept 8464 | complete 5204 | 28 | 24 |
  | turnin 5087 | turnin 5204 | 27 | 21 |
  | complete 4809 | accept 5385 | 19 | 37 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 4902 |

- Hearthstone: APR uses it 5 times (WARRIOR 5, PALADIN 5, HUNTER 5, ROGUE 5, PRIEST 5, SHAMAN 5, MAGE 5, WARLOCK 5, DRUID 5; 5 "if ready" steps open to all) and binds it 4 times (maps Eastern Plaguelands (1423), Hillsbrad Foothills (1424), Winterspring (1452)); Questify uses it 0 times and binds it 1 times (maps Winterspring (1452)).

### A_23 — Western Plaguelands (57-58)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #120 (Eastern Plaguelands (1423), 57-59): 15 shared of 66. Slice: 204 of 276 steps.
- Questify -> APR: 15 of 21 general quests in the matched routes (71 %), 17 anywhere in APR (81 %).
  - Absent from APR (Questify-only): 5343, 5382, 84395, 84402 (9 900 XP)
  - In another APR route: 5021, 5022
- APR -> Questify (slice): 15 of 57 general quests in this chapter (26 %).
  - In another Questify chapter: 5211, 5245, 5281, 5542, 5543, 5544, 5601, 5742, 5781, 5845, 6021, 6024, 6030
  - In no Questify chapter (APR-only): 4972, 4986, 5050, 5051, 5059, 5097, 5142, 5149, 5152, 5153, 5154, 5168, 5181, 5210, 5222, 5223, 5225, 5226, 5241, 5533, 5537, 5846, 5903, 5904, 6026, 6184, 6185, 6186, 6389 (137 860 XP)
    - finisher outside the chapter zones: 4986
    - manual drop (overrides.lua): 4972, 5097, 5222, 5223, 5225, 5226, 5533, 5537
    - not a candidate of the chapter: 5050, 5149, 5152, 5168, 5181, 5241, 5846, 6026, 6184
    - objective item source not in zone: 5051, 5903, 6185
    - prerequisite unavailable: 5142, 5153, 5154, 5210, 5904, 6186, 6389
    - repeatable: 5059
- Order: 36 shared events, 494 of 630 pairs in the same order (78 %), Kendall tau 0.57.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 6004 | accept 5058 | 14 | 15 |
  | complete 6004 | turnin 5060 | 14 | 14 |
  | accept 4971 | turnin 5217 | 14 | 13 |
  | complete 4971 | turnin 5058 | 17 | 10 |
  | complete 4984 | accept 5219 | 7 | 8 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 1 times (maps Eastern Plaguelands (1423)); Questify uses it 1 times and binds it 0 times (maps none).

### A_29 — Eastern Plaguelands (58-59)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #120 (Eastern Plaguelands (1423), 57-59): 13 shared of 66. Slice: 179 of 276 steps.
- Questify -> APR: 13 of 20 general quests in the matched routes (65 %), 13 anywhere in APR (65 %).
  - Absent from APR (Questify-only): 5212, 5214, 5243, 5251, 5282, 6164, 9664 (27 050 XP)
  - In another APR route: none
- APR -> Questify (slice): 13 of 40 general quests in this chapter (33 %).
  - In another Questify chapter: 4971, 4985, 6004, 6023
  - In no Questify chapter (APR-only): 4972, 4986, 5142, 5149, 5152, 5153, 5154, 5168, 5181, 5210, 5223, 5225, 5226, 5241, 5537, 5846, 5903, 5904, 6025, 6026, 6185, 6186, 6389 (114 900 XP)
    - finisher outside the chapter zones: 5152, 5846
    - not a candidate of the chapter: 4972, 4986, 5142, 5153, 5154, 5210, 5223, 5225, 5226, 5537, 5903, 5904, 6025, 6185, 6186, 6389
    - objective item source not in zone: 5149, 5168, 6026
    - prerequisite unavailable: 5181, 5241
- Order: 32 shared events, 396 of 496 pairs in the same order (80 %), Kendall tau 0.60.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 5211 | turnin 5601 | 25 | 25 |
  | complete 5742 | turnin 5245 | 8 | 7 |
  | accept 5211 | accept 5542 | 6 | 7 |
  | turnin 5281 | complete 5542 | 6 | 7 |
  | accept 5281 | accept 5544 | 6 | 6 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps Eastern Plaguelands (1423)); Questify uses it 0 times and binds it 0 times (maps none).

### A_30 — Silithus (59-60)

- Races: Dwarf, Gnome, Human, NightElf, Skyborne. APR routes: #122 (Winterspring (1452), 59-60): 10 shared of 57. Slice: 65 of 267 steps.
- Questify -> APR: 10 of 12 general quests in the matched routes (83 %), 10 anywhere in APR (83 %).
  - Absent from APR (Questify-only): 9415, 9419 (13 200 XP)
  - In another APR route: none
- APR -> Questify (slice): 10 of 22 general quests in this chapter (45 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 1125, 1126, 5527, 6844, 8275, 8278, 8282, 8307, 8313, 8317, 8318, 8323 (61 250 XP)
    - finisher outside the chapter zones: 6844
    - manual drop (overrides.lua): 8278, 8282, 8318, 8323
    - not a candidate of the chapter: 5527, 8275
    - prerequisite unavailable: 1125, 1126
    - requires a profession: 8307, 8313, 8317
- Order: 27 shared events, 286 of 351 pairs in the same order (81 %), Kendall tau 0.63.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 8304 | accept 8277 | 5 | 9 |
  | accept 8279 | accept 8308 | 8 | 5 |
  | complete 8279 | complete 8283 | 5 | 7 |
  | turnin 8285 | accept 8281 | 5 | 6 |
  | accept 8287 | turnin 8304 | 4 | 4 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### H_OrcTroll_01 — Valley of Trials (1-6)

- Races: Orc, Troll. APR routes: #7 (Durotar (1411), 1-12): 14 shared of 93. Slice: 333 of 681 steps.
- Questify -> APR: 14 of 15 general quests in the matched routes (93 %), 14 anywhere in APR (93 %).
  - Absent from APR (Questify-only): 97279 (170 XP)
  - In another APR route: none
- APR -> Questify (slice): 14 of 31 general quests in this chapter (45 %).
  - In another Questify chapter: 784, 786, 791, 815, 817, 818, 823, 825, 830, 831, 96604, 96655, 96821, 96822, 96825
  - In no Questify chapter (APR-only): 2161, 96873 (810 XP)
  - Left out, quest level above 8 (band + 2): 806, 808, 826, 837, 97223, 97225
    - not a candidate of the chapter: 2161, 96873
- Order: 37 shared events, 618 of 666 pairs in the same order (93 %), Kendall tau 0.86.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 789 | complete 792 | 6 | 5 |
  | complete 99123 | turnin 805 | 5 | 5 |
  | complete 789 | accept 4402 | 7 | 4 |
  | turnin 5441 | turnin 4402 | 4 | 4 |
  | accept 789 | accept 804 | 3 | 4 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | HUNTER | 2 | 0 | 0 | 2 | none |
  | ROGUE | 2 | 0 | 0 | 2 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | SHAMAN | 5 | 0 | 0 | 5 | none |
  | MAGE | 2 | 0 | 0 | 2 | none |
  | WARLOCK | 4 | 0 | 0 | 4 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1 times (maps Durotar (1411)); Questify uses it 0 times and binds it 0 times (maps none).

### H_OrcTroll_02 — Durotar (6-12)

- Races: Orc, Troll. APR routes: #7 (Durotar (1411), 1-12): 39 shared of 93. Slice: 493 of 681 steps.
- Questify -> APR: 39 of 42 general quests in the matched routes (93 %), 40 anywhere in APR (95 %).
  - Absent from APR (Questify-only): 99051, 99052 (1 540 XP)
  - In another APR route: 5727
- APR -> Questify (slice): 36 of 43 general quests in this chapter (84 %).
  - In another Questify chapter: 805, 96652, 96876, 99123
  - In no Questify chapter (APR-only): 809, 2161, 96873 (1 265 XP)
    - exploration point not in zone: 809
    - low ratio: 2161
    - requires a profession: 96873
- Order: 96 shared events, 3929 of 4560 pairs in the same order (86 %), Kendall tau 0.72.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 97223 | turnin 96655 | 35 | 34 |
  | accept 99048 | turnin 791 | 23 | 31 |
  | complete 818 | turnin 96821 | 19 | 32 |
  | turnin 815 | turnin 96825 | 19 | 21 |
  | turnin 817 | turnin 825 | 19 | 18 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 10 | 0 | 3 | 4 | 812, 813, 816 |
  | ROGUE | 1 | 0 | 0 | 1 | none |
  | PRIEST | 4 | 0 | 0 | 4 | none |
  | SHAMAN | 11 | 0 | 3 | 4 | 812, 813, 816, 842 |
  | WARLOCK | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 0-1 times (WARRIOR 1, PALADIN 0, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 0; 1 "if ready" steps open to all) and binds it 1 times (maps Durotar (1411)); Questify uses it 0 times and binds it 0 times (maps none).

### H_Tauren_01 — Camp Narache (1-6)

- Races: Tauren. APR routes: #5 (Mulgore (1412), 1-12): 15 shared of 90. Slice: 194 of 457 steps.
- Questify -> APR: 15 of 15 general quests in the matched routes (100 %), 15 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 15 of 35 general quests in this chapter (43 %).
  - In another Questify chapter: 743, 748, 751, 754, 756, 767, 771, 772, 96605, 96659, 96661, 98430, 99108, 99411
  - In no Questify chapter (APR-only): 746, 761, 766, 1656, 95805, 96130 (2 820 XP)
    - level band reached: 761, 95805
    - low ratio: 1656
    - not a candidate of the chapter: 766, 96130
    - objective item source not in zone: 746
- Order: 33 shared events, 444 of 528 pairs in the same order (84 %), Kendall tau 0.68.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 99079 | complete 780 | 8 | 8 |
  | complete 745 | turnin 763 | 10 | 7 |
  | turnin 99079 | turnin 781 | 7 | 7 |
  | accept 745 | turnin 780 | 12 | 6 |
  | accept 99081 | accept 763 | 7 | 6 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | HUNTER | 1 | 0 | 0 | 1 | none |
  | SHAMAN | 4 | 0 | 0 | 4 | none |
  | DRUID | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1 times (maps Mulgore (1412)); Questify uses it 0 times and binds it 0 times (maps none).

### H_Tauren_02 — Mulgore (6-12)

- Races: Tauren. APR routes: #5 (Mulgore (1412), 1-12): 32 shared of 90. Slice: 351 of 457 steps.
- Questify -> APR: 32 of 34 general quests in the matched routes (94 %), 32 anywhere in APR (94 %).
  - Absent from APR (Questify-only): 98427, 98435 (1 120 XP)
  - In another APR route: none
- APR -> Questify (slice): 31 of 46 general quests in this chapter (67 %).
  - In another Questify chapter: 745, 749, 763, 870, 99079, 99081, 99101
  - In no Questify chapter (APR-only): 746, 761, 766, 768, 854, 1656, 76160, 96130 (4 515 XP)
    - level band reached: 746, 761, 766, 96130
    - low ratio: 1656
    - not a candidate of the chapter: 854
    - objective item source not in zone: 76160
    - requires a profession: 768
- Order: 82 shared events, 2737 of 3321 pairs in the same order (82 %), Kendall tau 0.65.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 759 | turnin 99411 | 31 | 39 |
  | accept 99080 | accept 99108 | 29 | 25 |
  | accept 751 | accept 99411 | 25 | 25 |
  | complete 98430 | complete 99108 | 24 | 23 |
  | accept 98430 | turnin 99108 | 26 | 21 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | HUNTER | 5 | 0 | 0 | 4 | 76240 |
  | SHAMAN | 4 | 0 | 0 | 3 | 76240 |
  | DRUID | 7 | 0 | 1 | 5 | 76240 |

- Hearthstone: APR uses it 0-1 times (WARRIOR 1, PALADIN 0, HUNTER 1, ROGUE 0, PRIEST 0, SHAMAN 1, MAGE 0, WARLOCK 0, DRUID 1; 0 "if ready" steps open to all) and binds it 2 times (maps Mulgore (1412), Thunder Bluff (1456)); Questify uses it 0 times and binds it 0 times (maps none).

### H_Undead_01 — Deathknell (1-6)

- Races: Undead. APR routes: #3 (Tirisfal Glades (1420), 1-12): 13 shared of 97. Slice: 191 of 750 steps.
- Questify -> APR: 13 of 13 general quests in the matched routes (100 %), 13 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 13 of 23 general quests in this chapter (57 %).
  - In another Questify chapter: 365, 404, 427, 5481, 86784, 96607, 96658, 99134
  - In no Questify chapter (APR-only): 367, 99141 (1 080 XP)
    - not a candidate of the chapter: 367, 99141
- Order: 33 shared events, 502 of 528 pairs in the same order (95 %), Kendall tau 0.90.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 6395 | complete 380 | 5 | 7 |
  | turnin 6395 | turnin 380 | 6 | 5 |
  | accept 6395 | turnin 3901 | 3 | 2 |
  | turnin 98389 | accept 381 | 2 | 1 |
  | complete 364 | accept 376 | 1 | 1 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | PALADIN | 4 | 0 | 0 | 4 | none |
  | ROGUE | 1 | 0 | 0 | 1 | none |
  | PRIEST | 2 | 0 | 0 | 2 | none |
  | MAGE | 1 | 0 | 0 | 1 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 1 times (maps Tirisfal Glades (1420)); Questify uses it 0 times and binds it 0 times (maps none).

### H_Undead_02 — Tirisfal Glades (6-12)

- Races: Undead. APR routes: #3 (Tirisfal Glades (1420), 1-12): 35 shared of 97. Slice: 549 of 750 steps.
- Questify -> APR: 35 of 43 general quests in the matched routes (81 %), 36 anywhere in APR (84 %).
  - Absent from APR (Questify-only): 357, 366, 372, 408, 409, 411, 590 (4 400 XP)
  - In another APR route: 97891
- APR -> Questify (slice): 34 of 46 general quests in this chapter (74 %).
  - In another Questify chapter: 8, 383, 96656
  - In no Questify chapter (APR-only): 367, 368, 369, 445, 492, 95314, 95328, 99141, 99152 (6 020 XP)
    - far: 367
    - manual drop (overrides.lua): 95314, 95328, 99152
    - objective item source not in zone: 99141
    - prerequisite dropped: 368, 369, 492
    - required level not reached in time: 445
- Order: 92 shared events, 3361 of 4186 pairs in the same order (80 %), Kendall tau 0.61.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 407 | complete 97558 | 61 | 60 |
  | complete 374 | accept 97558 | 30 | 51 |
  | accept 398 | turnin 86784 | 28 | 28 |
  | accept 358 | complete 96607 | 30 | 27 |
  | complete 99142 | turnin 97558 | 25 | 32 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 3 | 0 | 0 | 3 | none |
  | PALADIN | 10 | 0 | 0 | 10 | none |
  | ROGUE | 5 | 0 | 0 | 5 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | MAGE | 4 | 0 | 1 | 2 | 79095 |
  | WARLOCK | 4 | 0 | 1 | 3 | none |

- Hearthstone: APR uses it 1-2 times (WARRIOR 2, PALADIN 2, HUNTER 1, ROGUE 2, PRIEST 2, SHAMAN 1, MAGE 2, WARLOCK 2, DRUID 1; 2 "if ready" steps open to all) and binds it 1-2 times (maps Tirisfal Glades (1420), Undercity (1458)); Questify uses it 0 times and binds it 0 times (maps none).

### H_Undead_03 — Silverpine Forest (12-14)

- Races: Undead. APR routes: #25 (Silverpine Forest (1421), 12-14): 14 shared of 34. Slice: 314 of 341 steps.
- Questify -> APR: 14 of 19 general quests in the matched routes (74 %), 15 anywhere in APR (79 %).
  - Absent from APR (Questify-only): 460, 461, 491, 78150 (3 400 XP)
  - In another APR route: 6324
- APR -> Questify (slice): 13 of 27 general quests in this chapter (48 %).
  - In another Questify chapter: 97891
  - In no Questify chapter (APR-only): 421, 422, 423, 424, 425, 437, 438, 439, 445, 447, 481, 482, 91920 (9 090 XP)
    - level band reached: 421, 422, 423, 424, 425, 447, 481, 482
    - manual drop (overrides.lua): 437, 438, 439, 91920
    - not a candidate of the chapter: 445
- Order: 27 shared events, 306 of 351 pairs in the same order (87 %), Kendall tau 0.74.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1358 | turnin 478 | 6 | 7 |
  | turnin 1359 | accept 478 | 6 | 7 |
  | accept 6323 | turnin 477 | 8 | 4 |
  | complete 429 | accept 6321 | 6 | 4 |
  | turnin 6321 | turnin 91921 | 3 | 4 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | ROGUE | 4 | 0 | 0 | 4 | none |
  | PRIEST | 1 | 0 | 1 | 0 | none |
  | MAGE | 1 | 0 | 1 | 0 | none |
  | WARLOCK | 1 | 0 | 1 | 0 | none |

- Hearthstone: APR uses it 0-1 times (WARRIOR 1, PALADIN 1, HUNTER 0, ROGUE 1, PRIEST 1, SHAMAN 0, MAGE 1, WARLOCK 1, DRUID 0; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 1 times (maps Undercity (1458)).

### H_Skyborne_01 — Zephras Isle (1-15)

- Races: Skyborne. APR routes: #4 (Zephras Isle (2521), 1-13): 52 shared of 113; #14 (Zephras Isle (2521), 10-13): 4 shared of 7. Slice: 715 of 744 steps.
- Questify -> APR: 55 of 73 general quests in the matched routes (75 %), 55 anywhere in APR (75 %).
  - Absent from APR (Questify-only): 92640, 92642, 92643, 92644, 92645, 92646, 92693, 92880, 92881, 92947, 93065, 93090, 93320, 93836, 93949, 93958, 94493, 94568 (12 950 XP)
  - In another APR route: none
- APR -> Questify (slice): 55 of 87 general quests in this chapter (63 %).
  - In another Questify chapter: 97242, 97246, 97249, 97275, 97326
  - In no Questify chapter (APR-only): 1061, 92461, 92463, 92473, 92474, 92515, 92516, 92544, 92553, 93319, 93552, 93951, 94484, 94897, 95350, 97963, 97964, 97965, 97967, 97968, 97969, 97970, 97971, 97973, 98024, 98285, 98286 (13 185 XP)
    - exclusive with another quest: 94484
    - level band reached: 92461, 92463, 92473, 92474, 92515, 92516, 92544, 92553, 93319, 93951
    - low ratio: 93552
    - not a candidate of the chapter: 1061, 95350, 97973, 98024, 98286
    - objective item source not in zone: 94897
    - requires a profession: 97963, 97964, 97965, 97967, 97968, 97969, 97970, 97971, 98285
- Order: 135 shared events, 8253 of 9045 pairs in the same order (91 %), Kendall tau 0.82.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 93737 | turnin 92703 | 34 | 36 |
  | accept 93738 | turnin 98512 | 31 | 34 |
  | turnin 93738 | complete 98512 | 29 | 37 |
  | accept 98512 | accept 94896 | 25 | 27 |
  | accept 93746 | turnin 93160 | 26 | 25 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 6 | 0 | 0 | 2 | 445, 96895, 96897, 96898 |
  | HUNTER | 7 | 0 | 0 | 5 | 840, 842 |
  | ROGUE | 5 | 0 | 0 | 1 | 445, 96895, 96897, 96898 |
  | SHAMAN | 10 | 0 | 0 | 8 | 840, 842 |
  | DRUID | 9 | 0 | 0 | 5 | 445, 96895, 96897, 96898 |

- Hearthstone: APR uses it 1-3 times (WARRIOR 3, PALADIN 1, HUNTER 3, ROGUE 3, PRIEST 1, SHAMAN 3, MAGE 3, WARLOCK 1, DRUID 3; 3 "if ready" steps open to all) and binds it 3 times (maps Orgrimmar (1454), Zephras Isle (2521)); Questify uses it 1 times and binds it 1 times (maps Zephras Isle (2521)).

### H_01 — The Barrens (12-17)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #5 (Mulgore (1412), 1-12): 9 shared of 90; #27 (The Barrens (1413), 12-17): 42 shared of 82; #37 (Stonetalon Mountains (1442), 17-22): 13 shared of 96. Slice: 954 of 1581 steps.
- Questify -> APR: 45 of 49 general quests in the matched routes (92 %), 47 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 898, 79192 (2 920 XP)
  - In another APR route: 1486, 1487
- APR -> Questify (slice): 43 of 77 general quests in this chapter (56 %).
  - In another Questify chapter: 860, 882, 905, 907, 3261, 3281, 6523, 97242, 97246, 97249, 97275
  - In no Questify chapter (APR-only): 264, 821, 853, 854, 855, 865, 872, 924, 1061, 1062, 1490, 3301, 5041, 6362, 6363, 6364, 6384, 6385, 6386, 6461, 6548, 6629, 98024 (19 630 XP)
  - Left out, quest level above 19 (band + 2): 868, 874, 876, 878, 884, 913, 1069, 1093, 1094, 1095, 1483, 4021, 5052, 6284, 92706, 95774, 97003
    - exclusive with another quest: 854
    - far: 865
    - finisher outside the chapter zones: 853, 3301, 6362, 6384
    - level band reached: 821, 855
    - manual drop (overrides.lua): 872, 5041
    - not a candidate of the chapter: 264, 1061, 1490, 6363, 6364, 6385, 6386, 6461, 98024
    - objective npc not in zone: 1062, 6548, 6629
    - prerequisite unavailable: 924
- Order: 112 shared events, 4582 of 6216 pairs in the same order (74 %), Kendall tau 0.47.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 880 | turnin 819 | 64 | 61 |
  | complete 877 | accept 895 | 53 | 55 |
  | complete 875 | turnin 895 | 52 | 52 |
  | accept 95508 | turnin 888 | 50 | 63 |
  | turnin 877 | turnin 892 | 52 | 50 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 5 | 0 | 0 | 5 | none |
  | HUNTER | 3 | 0 | 2 | 0 | 6382 |
  | ROGUE | 5 | 0 | 0 | 5 | none |
  | PRIEST | 2 | 0 | 0 | 2 | none |
  | SHAMAN | 10 | 0 | 0 | 9 | 840 |
  | WARLOCK | 4 | 0 | 0 | 4 | none |
  | DRUID | 12 | 0 | 0 | 8 | 886, 98341, 98404, 98738 |

- Hearthstone: APR uses it 3-4 times (WARRIOR 3, PALADIN 3, HUNTER 3, ROGUE 3, PRIEST 3, SHAMAN 4, MAGE 3, WARLOCK 3, DRUID 4; 3 "if ready" steps open to all) and binds it 4-5 times (maps The Barrens (1413), Thunder Bluff (1456)); Questify uses it 0 times and binds it 2 times (maps The Barrens (1413)).

### H_02 — Stonetalon Mountains and The Barrens (17-21)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #27 (The Barrens (1413), 12-17): 4 shared of 82; #37 (Stonetalon Mountains (1442), 17-22): 14 shared of 96. Slice: 569 of 1124 steps.
- Questify -> APR: 16 of 28 general quests in the matched routes (57 %), 19 anywhere in APR (68 %).
  - Absent from APR (Questify-only): 1090, 1092, 3513, 6421, 6481, 6542, 78270, 79192, 79980 (12 435 XP)
  - In another APR route: 885, 897, 959
- APR -> Questify (slice): 16 of 61 general quests in this chapter (26 %).
  - In another Questify chapter: 848, 851, 852, 863, 868, 875, 877, 878, 880, 881, 883, 896, 899, 902, 903, 1489, 4921, 5052, 6284, 6301, 6562, 95494, 95495, 95507, 95508, 95621, 95774, 97003
  - In no Questify chapter (APR-only): 264, 821, 853, 855, 865, 1061, 1062, 1063, 1068, 1069, 1490, 3301, 4021, 6386, 6461, 6548, 6629 (19 370 XP)
  - Left out, quest level above 23 (band + 2): 874, 1058, 6393
    - finisher outside the chapter zones: 853, 1063, 3301
    - level band reached: 865, 1062, 1069, 6461, 6548, 6629
    - low ratio: 821, 855
    - manual drop (overrides.lua): 1068
    - not a candidate of the chapter: 264, 1061, 1490, 6386
    - objective item source not in zone: 4021
- Order: 41 shared events, 653 of 820 pairs in the same order (80 %), Kendall tau 0.59.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 92706 | complete 3281 | 17 | 17 |
  | complete 876 | turnin 3281 | 16 | 26 |
  | accept 6401 | turnin 92706 | 15 | 15 |
  | turnin 6523 | complete 92706 | 15 | 15 |
  | accept 876 | complete 6523 | 8 | 14 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 1 | 0 | 0 | 1 | none |
  | HUNTER | 5 | 0 | 0 | 0 | 3921, 6382, 6383, 6541, 6544 |
  | ROGUE | 2 | 0 | 0 | 2 | none |
  | PRIEST | 2 | 0 | 0 | 2 | none |
  | SHAMAN | 5 | 0 | 0 | 4 | 869 |
  | WARLOCK | 5 | 0 | 0 | 5 | none |
  | DRUID | 11 | 0 | 0 | 8 | 98341, 98404, 98738 |

- Hearthstone: APR uses it 1-2 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 2; 1 "if ready" steps open to all) and binds it 2-3 times (maps The Barrens (1413), Thunder Bluff (1456)); Questify uses it 2 times and binds it 1 times (maps The Barrens (1413)).

### H_03 — Ashenvale and Stonetalon Mountains (21-25)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #37 (Stonetalon Mountains (1442), 17-22): 11 shared of 96; #58 (The Barrens (1413), 24-26): 5 shared of 40; #59 (Ashenvale (1440), 26-28): 14 shared of 27. Slice: 811 of 839 steps.
- Questify -> APR: 21 of 26 general quests in the matched routes (81 %), 21 anywhere in APR (81 %).
  - Absent from APR (Questify-only): 78132, 78133, 78134, 78149, 79974 (5 190 XP)
  - In another APR route: none
- APR -> Questify (slice): 19 of 89 general quests in this chapter (21 %).
  - In another Questify chapter: 843, 846, 849, 852, 868, 873, 874, 875, 876, 878, 879, 880, 882, 883, 884, 885, 893, 897, 899, 906, 907, 913, 1060, 1093, 1094, 1095, 1483, 1489, 3261, 5052, 6401, 6523, 92706, 95494, 95495, 95507, 95508, 95621, 95774
  - In no Questify chapter (APR-only): 25, 235, 264, 742, 821, 824, 853, 855, 865, 1058, 1062, 1063, 1064, 1065, 1067, 1068, 1069, 1086, 1096, 1195, 1490, 1918, 3301, 4021, 6282, 6283, 6382, 6393, 6441, 6461, 6629 (41 815 XP)
  - Left out, quest level above 27 (band + 2): 1088, 1153, 2842, 5881, 6504
    - low ratio: 6461
    - manual drop (overrides.lua): 824, 1058, 1096, 1918, 6282, 6283, 6393, 6441
    - not a candidate of the chapter: 235, 264, 742, 821, 853, 855, 865, 1062, 1063, 1064, 1065, 1067, 1068, 1069, 1086, 1195, 1490, 3301, 4021, 6382, 6629
    - required level not reached in time: 25
- Order: 49 shared events, 741 of 1176 pairs in the same order (63 %), Kendall tau 0.26.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 6482 | complete 1087 | 26 | 27 |
  | complete 216 | turnin 98252 | 25 | 30 |
  | complete 6462 | turnin 98251 | 23 | 29 |
  | complete 6482 | turnin 6641 | 23 | 22 |
  | accept 6482 | complete 98251 | 21 | 31 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |
  | HUNTER | 2 | 0 | 0 | 0 | 3921, 6541 |
  | ROGUE | 9 | 0 | 2 | 5 | 6564, 6922 |
  | PRIEST | 2 | 0 | 0 | 2 | none |
  | SHAMAN | 5 | 0 | 0 | 5 | none |
  | WARLOCK | 8 | 0 | 0 | 8 | none |
  | DRUID | 12 | 0 | 0 | 9 | 98341, 98404, 98738 |

- Hearthstone: APR uses it 4 times (WARRIOR 4, PALADIN 4, HUNTER 4, ROGUE 4, PRIEST 4, SHAMAN 4, MAGE 4, WARLOCK 4, DRUID 4; 4 "if ready" steps open to all) and binds it 3 times (maps The Barrens (1413), Thunder Bluff (1456)); Questify uses it 0 times and binds it 0 times (maps none).

### H_04 — Southern Barrens and Thousand Needles (25-28)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #58 (The Barrens (1413), 24-26): 9 shared of 40; #62 (Thousand Needles (1441), 28-30): 10 shared of 40. Slice: 449 of 564 steps.
- Questify -> APR: 19 of 28 general quests in the matched routes (68 %), 23 anywhere in APR (82 %).
  - Absent from APR (Questify-only): 891, 78143, 78145, 79097, 97250 (8 050 XP)
  - In another APR route: 878, 5052, 95774, 97003
- APR -> Questify (slice): 19 of 55 general quests in this chapter (35 %).
  - In another Questify chapter: 884, 885, 897, 1060, 1087, 1095, 1150, 1151, 5151, 6284, 6301, 6381, 6401, 6562
  - In no Questify chapter (APR-only): 235, 742, 857, 1058, 1068, 1086, 1088, 1096, 1131, 1153, 1195, 1196, 1197, 4966, 5062, 5088, 5147, 5881, 6282, 6283, 6382, 6393 (40 740 XP)
  - Left out, quest level above 30 (band + 2): 1136
    - finisher outside the chapter zones: 5062, 6382
    - manual drop (overrides.lua): 857, 1153, 4966, 5147
    - not a candidate of the chapter: 235, 742, 1058, 1086, 1088, 1096, 1131, 1195, 1196, 5088, 5881, 6282, 6283, 6393
    - objective npc not in zone: 1068
    - prerequisite unavailable: 1197
- Order: 49 shared events, 785 of 1176 pairs in the same order (67 %), Kendall tau 0.34.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 4904 | turnin 893 | 30 | 32 |
  | complete 5064 | turnin 873 | 23 | 23 |
  | complete 4821 | complete 849 | 20 | 21 |
  | turnin 4865 | complete 873 | 20 | 21 |
  | turnin 4821 | accept 906 | 20 | 20 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 3 | 0 | 0 | 3 | none |
  | SHAMAN | 3 | 0 | 0 | 3 | none |

- Hearthstone: APR uses it 2-3 times (WARRIOR 3, PALADIN 3, HUNTER 3, ROGUE 3, PRIEST 3, SHAMAN 3, MAGE 3, WARLOCK 3, DRUID 2; 3 "if ready" steps open to all) and binds it 4 times (maps The Barrens (1413), Thousand Needles (1441), Thunder Bluff (1456)); Questify uses it 2 times and binds it 1 times (maps The Barrens (1413)).

### H_05 — Hillsbrad Foothills (28-30)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #65 (Hillsbrad Foothills (1424), 30-33): 7 shared of 29. Slice: 129 of 248 steps.
- Questify -> APR: 7 of 24 general quests in the matched routes (29 %), 13 anywhere in APR (54 %).
  - Absent from APR (Questify-only): 78143, 78145, 78149, 79097, 79974, 79975, 79976, 96986, 97287, 98094, 98095 (9 025 XP)
  - In another APR route: 498, 501, 502, 527, 528, 549
- APR -> Questify (slice): 7 of 11 general quests in this chapter (64 %).
  - In another Questify chapter: 556, 676, 677
  - In no Questify chapter (APR-only): 7321 (2 500 XP)
  - Left out, quest level above 32 (band + 2): 533, 544, 552, 642, 655, 671, 672, 674, 675, 1136, 1164
    - requires a profession: 7321
- Order: 16 shared events, 83 of 120 pairs in the same order (69 %), Kendall tau 0.38.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 509 | turnin 532 | 8 | 7 |
  | accept 513 | complete 539 | 6 | 7 |
  | turnin 509 | accept 539 | 5 | 7 |
  | turnin 567 | complete 532 | 3 | 7 |
  | complete 567 | accept 532 | 3 | 2 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 1 times (maps Hillsbrad Foothills (1424)).

### H_06 — Alterac Mountains and Arathi Highlands (30-32)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #65 (Hillsbrad Foothills (1424), 30-33): 8 shared of 29. Slice: 89 of 248 steps.
- Questify -> APR: 8 of 18 general quests in the matched routes (44 %), 10 anywhere in APR (56 %).
  - Absent from APR (Questify-only): 535, 541, 550, 1361, 79948, 79949, 96984, 97287 (14 035 XP)
  - In another APR route: 545, 557
- APR -> Questify (slice): 8 of 17 general quests in this chapter (47 %).
  - In another Questify chapter: 509, 532, 539, 546, 567, 677
  - In no Questify chapter (APR-only): 552, 671, 7321 (7 800 XP)
  - Left out, quest level above 34 (band + 2): 642, 1164
    - level band reached: 552, 671
    - requires a profession: 7321
- Order: 21 shared events, 148 of 210 pairs in the same order (70 %), Kendall tau 0.41.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 655 | complete 544 | 10 | 9 |
  | turnin 655 | complete 556 | 9 | 9 |
  | accept 672 | turnin 556 | 9 | 8 |
  | complete 672 | turnin 544 | 9 | 8 |
  | accept 676 | complete 533 | 4 | 4 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 3 times and binds it 0 times (maps none).

### H_07 — Thousand Needles (32-33)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #62 (Thousand Needles (1441), 28-30): 7 shared of 40; #70 (Thousand Needles (1441), 33-34): 6 shared of 28. Slice: 288 of 421 steps.
- Questify -> APR: 11 of 12 general quests in the matched routes (92 %), 11 anywhere in APR (92 %).
  - Absent from APR (Questify-only): 1361 (640 XP)
  - In another APR route: none
- APR -> Questify (slice): 11 of 34 general quests in this chapter (32 %).
  - In another Questify chapter: 4767, 4770, 4821, 4841, 4865, 4881, 4904, 5064
  - In no Questify chapter (APR-only): 1104, 1105, 1106, 1110, 1131, 1147, 1153, 1175, 1176, 1197, 2842, 4966, 5062, 5088, 5147 (31 835 XP)
  - Left out, quest level above 35 (band + 2): 1111, 1112, 1114, 1115, 1136, 1178
    - dungeon quest not picked up: 2842
    - finisher outside the chapter zones: 1106
    - level band reached: 1104, 1105, 1110, 1147, 1175, 1176, 5062, 5147
    - manual drop (overrides.lua): 4966
    - not a candidate of the chapter: 1131, 1153, 5088
    - prerequisite unavailable: 1197
- Order: 22 shared events, 179 of 231 pairs in the same order (77 %), Kendall tau 0.55.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 5361 | turnin 1151 | 15 | 7 |
  | accept 5762 | accept 1431 | 6 | 9 |
  | complete 1148 | turnin 1431 | 5 | 5 |
  | turnin 1148 | accept 1432 | 4 | 6 |
  | accept 1151 | complete 5151 | 3 | 3 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 3 | 0 | 0 | 3 | none |
  | SHAMAN | 3 | 0 | 0 | 3 | none |

- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 2 times (maps The Barrens (1413), Thousand Needles (1441)); Questify uses it 1 times and binds it 1 times (maps Thousand Needles (1441)).

### H_08 — Desolace (33-35)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #73 (Desolace (1443), 34-35): 14 shared of 27. Slice: 107 of 159 steps.
- Questify -> APR: 14 of 15 general quests in the matched routes (93 %), 14 anywhere in APR (93 %).
  - Absent from APR (Questify-only): 5821 (2 750 XP)
  - In another APR route: none
- APR -> Questify (slice): 14 of 22 general quests in this chapter (64 %).
  - In another Questify chapter: 1432, 5361
  - In no Questify chapter (APR-only): 1368, 1370, 1373, 1482, 1484, 5386 (9 985 XP)
  - Left out, quest level above 37 (band + 2): 5381, 5501, 6027
    - far: 1482
    - manual drop (overrides.lua): 1368, 1370, 1373
    - objective item source not in zone: 5386
    - prerequisite dropped: 1484
- Order: 36 shared events, 409 of 630 pairs in the same order (65 %), Kendall tau 0.30.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 5763 | turnin 1434 | 27 | 21 |
  | accept 6161 | complete 1434 | 16 | 16 |
  | complete 6161 | turnin 1481 | 22 | 15 |
  | accept 6143 | accept 1481 | 14 | 15 |
  | accept 6142 | turnin 1480 | 12 | 16 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 1 times (maps Desolace (1443)).

### H_09 — Stranglethorn Vale (35-37)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #70 (Thousand Needles (1441), 33-34): 6 shared of 28; #76 (Stranglethorn Vale (1434), 35-37): 24 shared of 35. Slice: 212 of 295 steps.
- Questify -> APR: 24 of 25 general quests in the matched routes (96 %), 24 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 635 (275 XP)
  - In another APR route: none
- APR -> Questify (slice): 24 of 43 general quests in this chapter (56 %).
  - In another Questify chapter: 596, 629, 1148, 1184, 1436, 5361
  - In no Questify chapter (APR-only): 1104, 1105, 1106, 1115, 1116, 1175, 1176, 1178, 1180, 1181, 1182, 1183, 2842 (20 450 XP)
  - Left out, quest level above 39 (band + 2): 193, 196, 209, 600
    - finisher outside the chapter zones: 1183
    - not a candidate of the chapter: 1104, 1105, 1106, 1115, 1175, 1176, 1178, 1180, 2842
    - objective item source not in zone: 1116
    - prerequisite unavailable: 1181, 1182
- Order: 62 shared events, 1698 of 1891 pairs in the same order (90 %), Kendall tau 0.80.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 638 | accept 195 | 25 | 24 |
  | turnin 575 | turnin 582 | 14 | 19 |
  | complete 575 | complete 568 | 16 | 14 |
  | accept 577 | complete 605 | 12 | 23 |
  | complete 189 | complete 187 | 8 | 8 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | SHAMAN | 1 | 0 | 0 | 1 | none |

- Hearthstone: APR uses it 1-3 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 3, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 2 times (maps The Barrens (1413), Stranglethorn Vale (1434), Orgrimmar (1454)); Questify uses it 2 times and binds it 1 times (maps Stranglethorn Vale (1434)).

### H_10 — Dustwallow Marsh (37-38)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #79 (Dustwallow Marsh (1445), 37-38): 13 shared of 18. Slice: 37 of 140 steps.
- Questify -> APR: 13 of 13 general quests in the matched routes (100 %), 13 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: none
- APR -> Questify (slice): 13 of 16 general quests in this chapter (81 %).
  - In another Questify chapter: 1276
  - In no Questify chapter (APR-only): 1203, 1270 (6 300 XP)
    - finisher outside the chapter zones: 1270
    - objective item source not in zone: 1203
- Order: 31 shared events, 368 of 465 pairs in the same order (79 %), Kendall tau 0.58.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1238 | turnin 1268 | 11 | 11 |
  | turnin 1238 | complete 1273 | 9 | 10 |
  | complete 1201 | accept 1322 | 9 | 9 |
  | complete 1177 | turnin 1321 | 9 | 8 |
  | turnin 1201 | accept 1273 | 7 | 10 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### H_11 — Arathi Highlands (38-39)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #81 (Arathi Highlands (1417), 38-39): 16 shared of 35. Slice: 116 of 148 steps.
- Questify -> APR: 16 of 19 general quests in the matched routes (84 %), 17 anywhere in APR (89 %).
  - Absent from APR (Questify-only): 518, 635 (2 525 XP)
  - In another APR route: 677
- APR -> Questify (slice): 16 of 24 general quests in this chapter (67 %).
  - In another Questify chapter: 545, 557, 675
  - In no Questify chapter (APR-only): 508, 651, 687, 688, 7321 (12 150 XP)
  - Left out, quest level above 41 (band + 2): 507, 652, 6622
    - low ratio: 651
    - manual drop (overrides.lua): 508, 687, 688
    - requires a profession: 7321
- Order: 39 shared events, 571 of 741 pairs in the same order (77 %), Kendall tau 0.54.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 665 | complete 642 | 14 | 14 |
  | complete 665 | turnin 642 | 14 | 14 |
  | accept 702 | turnin 506 | 12 | 12 |
  | complete 701 | accept 506 | 12 | 11 |
  | turnin 678 | turnin 566 | 10 | 13 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | WARRIOR | 4 | 0 | 0 | 3 | 1714 |
  | ROGUE | 1 | 0 | 0 | 0 | 673 |

- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 1 times (maps Arathi Highlands (1417)).

### H_12 — Badlands (39-40)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #82 (Badlands (1418), 39-40): 6 shared of 20. Slice: 45 of 101 steps.
- Questify -> APR: 6 of 9 general quests in the matched routes (67 %), 6 anywhere in APR (67 %).
  - Absent from APR (Questify-only): 709, 2202, 2418 (5 050 XP)
  - In another APR route: none
- APR -> Questify (slice): 6 of 18 general quests in this chapter (33 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 687, 705, 712, 713, 714, 715, 716, 734, 777, 1106, 1108, 1137 (26 420 XP)
  - Left out, quest level above 42 (band + 2): 778, 782
    - finisher outside the chapter zones: 1137
    - manual drop (overrides.lua): 712
    - not a candidate of the chapter: 687, 1106
    - objective item source not in zone: 705, 713, 714, 715, 716
    - prerequisite unavailable: 734, 777, 1108
- Order: 15 shared events, 77 of 105 pairs in the same order (73 %), Kendall tau 0.47.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 703 | accept 2258 | 7 | 7 |
  | accept 1420 | turnin 703 | 5 | 5 |
  | accept 711 | complete 2258 | 4 | 2 |
  | turnin 710 | accept 1419 | 2 | 4 |
  | complete 1419 | complete 711 | 1 | 1 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### H_13 — Stranglethorn Vale (40-42)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #87 (Stranglethorn Vale (1434), 40-41): 6 shared of 13; #90 (Swamp of Sorrows (1435), 41-400): 4 shared of 22; #97 (Stranglethorn Vale (1434), 44-45): 14 shared of 29. Slice: 248 of 298 steps.
- Questify -> APR: 20 of 22 general quests in the matched routes (91 %), 22 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: 596, 629
- APR -> Questify (slice): 20 of 44 general quests in this chapter (45 %).
  - In another Questify chapter: 196, 197, 208, 572, 577, 698, 699, 1276, 1420, 1424
  - In no Questify chapter (APR-only): 571, 573, 1116, 1117, 1118, 1119, 1183, 1261, 1270, 1372, 1373, 1389, 1392, 1393 (36 495 XP)
  - Left out, quest level above 44 (band + 2): 348, 349, 580, 586, 588, 589, 608, 1205, 2767, 2864, 2872, 8551
    - finisher outside the chapter zones: 1117, 1119, 1183
    - not a candidate of the chapter: 1118, 1270, 1372, 1373, 1389, 1392, 1393
    - objective item source not in zone: 571, 1116, 1261
    - prerequisite unavailable: 573
- Order: 48 shared events, 735 of 1128 pairs in the same order (65 %), Kendall tau 0.30.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 576 | turnin 209 | 26 | 28 |
  | complete 617 | turnin 600 | 24 | 29 |
  | accept 576 | complete 209 | 22 | 22 |
  | accept 599 | complete 600 | 21 | 20 |
  | accept 604 | complete 193 | 20 | 20 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 2, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps The Barrens (1413)); Questify uses it 1 times and binds it 1 times (maps Stranglethorn Vale (1434)).

### H_14 — Swamp of Sorrows (42-43)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #90 (Swamp of Sorrows (1435), 41-400): 4 shared of 22; #98 (Swamp of Sorrows (1435), 45-46): 6 shared of 16. Slice: 145 of 176 steps.
- Questify -> APR: 9 of 11 general quests in the matched routes (82 %), 9 anywhere in APR (82 %).
  - Absent from APR (Questify-only): 1430, 93176 (4 560 XP)
  - In another APR route: none
- APR -> Questify (slice): 9 of 28 general quests in this chapter (32 %).
  - In another Questify chapter: 209, 577, 600, 628, 669, 1276
  - In no Questify chapter (APR-only): 1116, 1117, 1183, 1205, 1270, 1373, 1389, 1392, 1393, 1428, 1429, 2864, 2872 (30 895 XP)
  - Left out, quest level above 45 (band + 2): 2621, 2622, 2623, 2784, 2801
    - finisher outside the chapter zones: 1429
    - level band reached: 1389, 1392, 1393, 1428
    - not a candidate of the chapter: 1116, 1117, 1183, 1205, 1270, 1373, 2864, 2872
- Order: 19 shared events, 126 of 171 pairs in the same order (74 %), Kendall tau 0.47.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 625 | turnin 1424 | 17 | 11 |
  | turnin 624 | complete 699 | 9 | 9 |
  | complete 1424 | accept 699 | 2 | 1 |

- Class quests: none on either side.
- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 1 times (maps The Barrens (1413)); Questify uses it 0 times and binds it 0 times (maps none).

### H_15 — Dustwallow Marsh (43-44)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #92 (Tanaris (1446), 41-43): 3 shared of 25; #99 (Tanaris (1446), 46-48): 4 shared of 37. Slice: 191 of 304 steps.
- Questify -> APR: 7 of 9 general quests in the matched routes (78 %), 8 anywhere in APR (89 %).
  - Absent from APR (Questify-only): 1173 (4 850 XP)
  - In another APR route: 1276
- APR -> Questify (slice): 7 of 27 general quests in this chapter (26 %).
  - In another Questify chapter: 992, 1691, 2781, 2873, 2874, 2875, 8365, 8366
  - In no Questify chapter (APR-only): 654, 864, 1119, 1120, 1122, 1187, 1188, 1205, 1261, 1262, 2876, 3520 (37 995 XP)
  - Left out, quest level above 46 (band + 2): 10, 32, 82, 110, 113, 351, 626, 648, 1560, 2605, 2606, 2641, 3161, 3362, 3380, 5863
    - not a candidate of the chapter: 654, 864, 1119, 1120, 1122, 1187, 1188, 1205, 1261, 2876, 3520
    - prerequisite unavailable: 1262
- Order: 17 shared events, 93 of 136 pairs in the same order (68 %), Kendall tau 0.37.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 1170 | complete 1166 | 8 | 6 |
  | accept 1171 | complete 1168 | 6 | 7 |
  | accept 1172 | turnin 1166 | 7 | 6 |
  | turnin 625 | turnin 1168 | 6 | 6 |
  | turnin 1170 | accept 1168 | 4 | 8 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2-3 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 3, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps Tanaris (1446)); Questify uses it 1 times and binds it 0 times (maps none).

### H_16 — Tanaris (44-45)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #92 (Tanaris (1446), 41-43): 4 shared of 25; #99 (Tanaris (1446), 46-48): 6 shared of 37. Slice: 197 of 304 steps.
- Questify -> APR: 10 of 13 general quests in the matched routes (77 %), 10 anywhere in APR (77 %).
  - Absent from APR (Questify-only): 2768, 2865, 3042 (7 050 XP)
  - In another APR route: none
- APR -> Questify (slice): 10 of 35 general quests in this chapter (29 %).
  - In another Questify chapter: 1166, 1168, 1169
  - In no Questify chapter (APR-only): 82, 243, 379, 654, 1117, 1118, 1119, 1120, 1122, 1137, 1183, 1186, 1187, 1188, 1190, 1194, 1205, 1261, 1262, 2872, 2876, 3520 (48 880 XP)
  - Left out, quest level above 47 (band + 2): 1560, 2605, 3161, 3362, 3380, 5863
    - manual drop (overrides.lua): 82
    - not a candidate of the chapter: 243, 654, 1117, 1118, 1119, 1120, 1122, 1137, 1183, 1186, 1187, 1188, 1190, 1194, 1205, 1261, 1262, 2872, 2876
    - objective npc not in zone: 3520
    - prerequisite unavailable: 379
- Order: 28 shared events, 284 of 378 pairs in the same order (75 %), Kendall tau 0.50.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2875 | turnin 1690 | 12 | 11 |
  | turnin 992 | accept 1691 | 9 | 9 |
  | accept 2873 | turnin 1691 | 13 | 8 |
  | accept 8365 | complete 1691 | 9 | 8 |
  | accept 992 | complete 1690 | 8 | 9 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2-3 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 3, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 2 times (maps Tanaris (1446)); Questify uses it 1 times and binds it 1 times (maps Tanaris (1446)).

### H_17 — Feralas (45-47)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #95 (Feralas (1444), 43-44): 20 shared of 26. Slice: 112 of 132 steps.
- Questify -> APR: 20 of 23 general quests in the matched routes (87 %), 22 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 7721 (4 400 XP)
  - In another APR route: 3062, 7734
- APR -> Questify (slice): 20 of 24 general quests in this chapter (83 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 1205, 1262, 3520, 7541 (12 750 XP)
    - not a candidate of the chapter: 1205, 1262, 3520, 7541
- Order: 51 shared events, 1021 of 1275 pairs in the same order (80 %), Kendall tau 0.60.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 3121 | turnin 2987 | 25 | 34 |
  | turnin 2822 | complete 2974 | 22 | 24 |
  | accept 2766 | accept 2979 | 17 | 20 |
  | complete 2822 | accept 2980 | 15 | 21 |
  | accept 2767 | accept 2976 | 10 | 11 |

- Class quests: none on either side.
- Hearthstone: APR uses it 2-3 times (WARRIOR 2, PALADIN 2, HUNTER 2, ROGUE 2, PRIEST 2, SHAMAN 3, MAGE 2, WARLOCK 2, DRUID 2; 2 "if ready" steps open to all) and binds it 1 times (maps Feralas (1444)); Questify uses it 0 times and binds it 0 times (maps none).

### H_18 — Stranglethorn Vale (47-49)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #97 (Stranglethorn Vale (1434), 44-45): 9 shared of 29; #103 (Blasted Lands (1419), 50-51): 3 shared of 20. Slice: 125 of 209 steps.
- Questify -> APR: 11 of 18 general quests in the matched routes (61 %), 13 anywhere in APR (72 %).
  - Absent from APR (Questify-only): 591, 592, 594, 613, 8553 (18 120 XP)
  - In another APR route: 196, 572
- APR -> Questify (slice): 11 of 35 general quests in this chapter (31 %).
  - In another Questify chapter: 576, 587, 595, 597, 598, 599, 604, 606, 607, 609, 617, 621, 624, 628
  - In no Questify chapter (APR-only): 349, 571, 573, 580, 615, 648, 836, 1118, 1119, 3721 (38 340 XP)
    - finisher outside the chapter zones: 1119
    - not a candidate of the chapter: 648, 836, 1118
    - not a candidate of the chapter (QuestieDB: blacklisted): 615
    - objective item source not in zone: 571, 580
    - prerequisite unavailable: 573, 3721
    - repeatable: 349
- Order: 25 shared events, 200 of 300 pairs in the same order (67 %), Kendall tau 0.33.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 2874 | accept 208 | 13 | 20 |
  | accept 608 | complete 197 | 13 | 13 |
  | accept 8551 | turnin 197 | 10 | 8 |
  | turnin 589 | turnin 348 | 8 | 8 |
  | accept 348 | complete 586 | 5 | 8 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 1 times (maps Stranglethorn Vale (1434)).

### H_21 — The Hinterlands (49-51)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #100 (The Hinterlands (1425), 48-49): 10 shared of 33. Slice: 64 of 149 steps.
- Questify -> APR: 10 of 12 general quests in the matched routes (83 %), 10 anywhere in APR (83 %).
  - Absent from APR (Questify-only): 7845, 7850 (10 800 XP)
  - In another APR route: none
- APR -> Questify (slice): 10 of 24 general quests in this chapter (42 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 77, 81, 580, 626, 650, 2641, 2742, 2782, 2934, 2995, 3123, 7841, 7842, 7843 (61 850 XP)
    - far: 2742, 7841, 7843
    - finisher outside the chapter zones: 81
    - not a candidate of the chapter: 580, 626, 650, 2641, 2934, 2995, 3123
    - prerequisite dropped: 2782, 7842
    - prerequisite unavailable: 77
- Order: 28 shared events, 256 of 378 pairs in the same order (68 %), Kendall tau 0.35.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | complete 7844 | accept 2933 | 15 | 17 |
  | accept 485 | turnin 7816 | 12 | 17 |
  | complete 7830 | turnin 7815 | 10 | 10 |
  | turnin 485 | turnin 7839 | 7 | 7 |
  | complete 7828 | turnin 7840 | 10 | 6 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### H_23 — Blasted Lands (51-52)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #103 (Blasted Lands (1419), 50-51): 5 shared of 20. Slice: 46 of 99 steps.
- Questify -> APR: 5 of 6 general quests in the matched routes (83 %), 5 anywhere in APR (83 %).
  - Absent from APR (Questify-only): 81956 (780 XP)
  - In another APR route: none
- APR -> Questify (slice): 5 of 5 general quests in this chapter (100 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): none (0 XP)
- Order: 10 shared events, 25 of 45 pairs in the same order (56 %), Kendall tau 0.11.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 2581 | turnin 2601 | 5 | 7 |
  | accept 2583 | turnin 2603 | 4 | 3 |
  | accept 2585 | accept 2601 | 2 | 4 |
  | turnin 2581 | turnin 2583 | 2 | 2 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### H_24 — Searing Gorge and Burning Steppes (52-53)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #108 (Searing Gorge (1427), 51-52): 18 shared of 22. Slice: 94 of 147 steps.
- Questify -> APR: 18 of 24 general quests in the matched routes (75 %), 18 anywhere in APR (75 %).
  - Absent from APR (Questify-only): 4123, 4136, 7701, 81953, 81955, 81956 (10 605 XP)
  - In another APR route: none
- APR -> Questify (slice): 18 of 22 general quests in this chapter (82 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 3821, 4022, 4449, 4808 (15 590 XP)
    - finisher outside the chapter zones: 4808
    - low ratio: 4449
    - manual drop (overrides.lua): 4022
    - not a candidate of the chapter: 3821
- Order: 48 shared events, 1033 of 1128 pairs in the same order (92 %), Kendall tau 0.83.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 4451 | complete 7724 | 27 | 21 |
  | complete 7723 | accept 3453 | 9 | 9 |
  | turnin 7722 | turnin 4451 | 6 | 8 |
  | accept 7722 | accept 7724 | 3 | 4 |
  | complete 7727 | turnin 3442 | 4 | 2 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### H_25 — Azshara (53-54)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #110 (Azshara (1447), 52-53): 13 shared of 26; #114 (Felwood (1448), 53-54): 3 shared of 22. Slice: 192 of 217 steps.
- Questify -> APR: 14 of 15 general quests in the matched routes (93 %), 15 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: 649
- APR -> Questify (slice): 14 of 31 general quests in this chapter (45 %).
  - In another Questify chapter: 4102, 4505, 5082, 5083, 5084, 5155, 5156, 5157, 6162, 8460, 8462
  - In no Questify chapter (APR-only): 3568, 3908, 3909, 4120, 4808, 5158 (23 100 XP)
    - not a candidate of the chapter: 3568, 3908, 3909, 4120, 4808, 5158
- Order: 33 shared events, 297 of 528 pairs in the same order (56 %), Kendall tau 0.13.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 3565 | turnin 5536 | 22 | 22 |
  | turnin 3561 | turnin 5535 | 22 | 22 |
  | turnin 3541 | complete 3506 | 14 | 16 |
  | accept 3563 | accept 5534 | 15 | 14 |
  | accept 3541 | accept 3601 | 14 | 14 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 2 | 0 | 0 | 2 | none |
  | PRIEST | 3 | 0 | 0 | 3 | none |
  | MAGE | 3 | 0 | 0 | 3 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 1 times (WARRIOR 1, PALADIN 1, HUNTER 1, ROGUE 1, PRIEST 1, SHAMAN 1, MAGE 1, WARLOCK 1, DRUID 1; 1 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 1 times (maps Azshara (1447)).

### H_26 — Felwood (54-55)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #114 (Felwood (1448), 53-54): 8 shared of 22; #117 (Felwood (1448), 55-56): 7 shared of 45. Slice: 320 of 355 steps.
- Questify -> APR: 15 of 16 general quests in the matched routes (94 %), 15 anywhere in APR (94 %).
  - Absent from APR (Questify-only): 5887 (4 200 XP)
  - In another APR route: none
- APR -> Questify (slice): 15 of 52 general quests in this chapter (29 %).
  - In another Questify chapter: 980, 3507, 3541, 3563, 3783, 4521, 5054, 5082, 5084, 5085, 5086, 5087, 5156, 5601, 6029, 6030
  - In no Questify chapter (APR-only): 3542, 3562, 3908, 3909, 3912, 3913, 3914, 3941, 3942, 4084, 4120, 4147, 4494, 4502, 4808, 4842, 5158, 5159, 5165, 6031, 8470 (86 180 XP)
  - Left out, quest level above 57 (band + 2): 4721, 4741, 5055, 5121, 5242, 8464
    - finisher outside the chapter zones: 5158
    - manual drop (overrides.lua): 6031, 8470
    - not a candidate of the chapter: 3542, 3562, 3908, 3909, 3912, 3913, 3914, 3941, 3942, 4120, 4147, 4494, 4502, 4808, 4842, 5159
    - prerequisite unavailable: 4084, 5165
- Order: 38 shared events, 525 of 703 pairs in the same order (75 %), Kendall tau 0.49.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 5204 | accept 5083 | 18 | 17 |
  | turnin 5203 | turnin 8462 | 17 | 17 |
  | accept 5202 | complete 4505 | 16 | 16 |
  | complete 5203 | complete 5157 | 12 | 12 |
  | accept 5203 | accept 5157 | 11 | 12 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 969 |
  | PRIEST | 1 | 0 | 0 | 1 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 3-4 times (WARRIOR 3, PALADIN 3, HUNTER 3, ROGUE 3, PRIEST 3, SHAMAN 4, MAGE 3, WARLOCK 3, DRUID 3; 3 "if ready" steps open to all) and binds it 2 times (maps The Barrens (1413), Winterspring (1452)); Questify uses it 1 times and binds it 0 times (maps none).

### H_27 — Un'Goro Crater (55-56)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #116 (Un'Goro Crater (1449), 54-55): 18 shared of 36. Slice: 80 of 156 steps.
- Questify -> APR: 18 of 23 general quests in the matched routes (78 %), 23 anywhere in APR (100 %).
  - Absent from APR (Questify-only): none (0 XP)
  - In another APR route: 3844, 3884, 4284, 4290, 4291
- APR -> Questify (slice): 18 of 23 general quests in this chapter (78 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 4147, 4244, 4245, 4496, 4502 (23 950 XP)
    - finisher outside the chapter zones: 4147
    - not a candidate of the chapter: 4496, 4502
    - objective item source not in zone: 4244
    - prerequisite unavailable: 4245
- Order: 47 shared events, 813 of 1081 pairs in the same order (75 %), Kendall tau 0.50.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 4243 | complete 4288 | 19 | 20 |
  | complete 4285 | accept 980 | 15 | 17 |
  | accept 4491 | complete 4287 | 15 | 15 |
  | accept 4285 | complete 3883 | 14 | 18 |
  | turnin 4491 | turnin 4292 | 14 | 15 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 1 times and binds it 0 times (maps none).

### H_28 — Felwood and Winterspring (56-57)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #114 (Felwood (1448), 53-54): 4 shared of 22; #117 (Felwood (1448), 55-56): 15 shared of 45; #119 (Western Plaguelands (1422), 56-58): 3 shared of 74; #121 (Winterspring (1452), 58-60): 6 shared of 54. Slice: 771 of 999 steps.
- Questify -> APR: 22 of 23 general quests in the matched routes (96 %), 22 anywhere in APR (96 %).
  - Absent from APR (Questify-only): 6603 (580 XP)
  - In another APR route: none
- APR -> Questify (slice): 22 of 126 general quests in this chapter (17 %).
  - In another Questify chapter: 3507, 3541, 3563, 4102, 4505, 4506, 4971, 4984, 4985, 5021, 5023, 5049, 5050, 5055, 5058, 5060, 5096, 5121, 5155, 5157, 5202, 5203, 5204, 5211, 5228, 5229, 5230, 5231, 5232, 5385, 5542, 5543, 5544, 5742, 5781, 5845, 5846, 5901, 5902, 5961, 6004, 6021, 6023, 6042, 6162, 6164, 6390, 8460, 8461, 8462
  - In no Questify chapter (APR-only): 838, 964, 1123, 1124, 3542, 3562, 3564, 3568, 3569, 3570, 3908, 3909, 3912, 3913, 3914, 3941, 3942, 4005, 4084, 4120, 4147, 4494, 4502, 4808, 4809, 4842, 4883, 4972, 4987, 5051, 5059, 5095, 5098, 5149, 5152, 5153, 5154, 5158, 5159, 5163, 5165, 5210, 5233, 5234, 5235, 5236, 5238, 5241, 5242, 5405, 6022, 6025, 6031, 8470 (230 835 XP)
  - Left out, quest level above 59 (band + 2): 5281, 5527, 6024, 6133, 7813, 7814, 7817, 7818, 9124, 9126, 9128, 9131, 9136
    - far: 4842
    - finisher outside the chapter zones: 3912, 4005, 4883, 5158
    - manual drop (overrides.lua): 6031, 8470
    - not a candidate of the chapter: 838, 964, 1123, 1124, 3542, 3562, 3564, 3568, 3569, 3570, 3908, 3913, 3914, 3941, 3942, 4120, 4147, 4494, 4502, 4808, 4972, 4987, 5051, 5059, 5095, 5098, 5149, 5152, 5153, 5154, 5159, 5210, 5233, 5234, 5235, 5236, 5238, 5241, 5405, 6022, 6025
    - objective item source not in zone: 3909
    - objective npc not in zone: 5163
    - prerequisite unavailable: 4084, 4809, 5165, 5242
- Order: 49 shared events, 900 of 1176 pairs in the same order (77 %), Kendall tau 0.53.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 5601 | turnin 5082 | 26 | 24 |
  | complete 5086 | turnin 5156 | 25 | 24 |
  | accept 6030 | complete 5082 | 17 | 24 |
  | complete 4521 | complete 5156 | 16 | 17 |
  | accept 3783 | accept 5082 | 12 | 14 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 0 | 0 | 969 |
  | PRIEST | 1 | 0 | 0 | 1 | none |
  | WARLOCK | 2 | 0 | 0 | 2 | none |

- Hearthstone: APR uses it 5-7 times (WARRIOR 5, PALADIN 5, HUNTER 5, ROGUE 5, PRIEST 5, SHAMAN 7, MAGE 5, WARLOCK 5, DRUID 5; 5 "if ready" steps open to all) and binds it 3 times (maps The Barrens (1413), Winterspring (1452)); Questify uses it 3 times and binds it 1 times (maps Winterspring (1452)).

### H_29 — Western Plaguelands and Eastern Plaguelands (57-59)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #119 (Western Plaguelands (1422), 56-58): 39 shared of 74. Slice: 292 of 312 steps.
- Questify -> APR: 39 of 58 general quests in the matched routes (67 %), 39 anywhere in APR (67 %).
  - Absent from APR (Questify-only): 4293, 4294, 5094, 5212, 5214, 5243, 5251, 5282, 5341, 5382, 5503, 5529, 5848, 9665, 84395, 84398, 84400, 84401, 84402 (58 640 XP)
  - In another APR route: none
- APR -> Questify (slice): 39 of 72 general quests in this chapter (54 %).
  - In another Questify chapter: none
  - In no Questify chapter (APR-only): 838, 964, 3542, 3564, 3568, 3569, 3570, 4972, 4987, 5051, 5059, 5098, 5149, 5152, 5153, 5154, 5210, 5233, 5234, 5235, 5236, 5241, 5405, 6022, 6025, 7813, 7814, 7818, 9124, 9126, 9128, 9131, 9136 (140 890 XP)
    - exclusive with another quest: 5405
    - finisher outside the chapter zones: 3564, 4987
    - manual drop (overrides.lua): 838, 964, 4972, 5098, 5233, 5234, 5235, 5236, 6025, 9124, 9126, 9128, 9131, 9136
    - not a candidate of the chapter: 3542
    - objective item source not in zone: 3568, 5051, 5149, 6022, 7813, 7814, 7818
    - prerequisite unavailable: 3569, 3570, 5152, 5153, 5154, 5210, 5241
    - repeatable: 5059
- Order: 96 shared events, 3278 of 4560 pairs in the same order (72 %), Kendall tau 0.44.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | accept 7817 | turnin 5232 | 50 | 52 |
  | accept 5961 | accept 6023 | 49 | 48 |
  | accept 5050 | turnin 6004 | 49 | 46 |
  | turnin 5023 | accept 5232 | 45 | 55 |
  | accept 5049 | turnin 5231 | 43 | 57 |

- Class quests: none on either side.
- Hearthstone: APR uses it 0 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 0, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 0 times and binds it 0 times (maps none).

### H_30 — Silithus (59-60)

- Races: Orc, Skyborne, Tauren, Troll, Undead. APR routes: #121 (Winterspring (1452), 58-60): 11 shared of 54. Slice: 221 of 332 steps.
- Questify -> APR: 11 of 14 general quests in the matched routes (79 %), 12 anywhere in APR (86 %).
  - Absent from APR (Questify-only): 9416, 9422 (13 200 XP)
  - In another APR route: 5055
- APR -> Questify (slice): 10 of 41 general quests in this chapter (24 %).
  - In another Questify chapter: 977, 4721, 4882, 5123, 5128, 8464
  - In no Questify chapter (APR-only): 1123, 1124, 1125, 1126, 3564, 3961, 3962, 4005, 4084, 4504, 4507, 4809, 4883, 4987, 5163, 5527, 6844, 7820, 7821, 7822, 7823, 8278, 8282, 8318, 8323 (122 540 XP)
    - finisher outside the chapter zones: 6844
    - manual drop (overrides.lua): 8278, 8282, 8318, 8323
    - not a candidate of the chapter: 1123, 1124, 3564, 3961, 3962, 4005, 4084, 4504, 4507, 4883, 4987, 5527, 7820, 7821, 7822, 7823
    - objective npc not in zone: 5163
    - prerequisite unavailable: 1125, 1126, 4809
- Order: 26 shared events, 225 of 325 pairs in the same order (69 %), Kendall tau 0.38.
  Most costly inversions (each event once; gap = distance in ranks among the shared events):

  | Questify does first | then | Questify gap | APR does them the other way, gap |
  |---|---|---|---|
  | turnin 8285 | turnin 5121 | 16 | 16 |
  | accept 8279 | complete 5121 | 14 | 18 |
  | accept 8285 | accept 8308 | 12 | 5 |
  | complete 8279 | turnin 8308 | 4 | 6 |
  | complete 8284 | accept 8277 | 4 | 5 |

- Class quests:

  | Class | APR (slice) | Questify class steps | APR's done by this chapter | APR's offered by `ClassQuestData.lua` | APR's in neither |
  |---|---|---|---|---|---|
  | HUNTER | 1 | 0 | 1 | 0 | none |
  | MAGE | 1 | 0 | 1 | 0 | none |
  | WARLOCK | 1 | 0 | 1 | 0 | none |

- Hearthstone: APR uses it 0-1 times (WARRIOR 0, PALADIN 0, HUNTER 0, ROGUE 0, PRIEST 0, SHAMAN 1, MAGE 0, WARLOCK 0, DRUID 0; 0 "if ready" steps open to all) and binds it 0 times (maps none); Questify uses it 2 times and binds it 0 times (maps none).

## Indoor notes per zone (APR) and Questify cave entrances

APR steps of leveling routes with a note about a cave (cave, mine, tunnel, crypt...), a building (inside, inn, tower, barn...) or a floor (upstairs, downstairs, ramp, elevator...), on the maps our guides use; the notes are classified by keyword, never copied. A step can count in several categories. "Our quests": quest IDs of those steps that a Questify chapter of the faction also does: there an entrance or a floor hint may be missing on our side. Cave entrances: entries of `Questify/Data/Caves.lua` on that map.

### Alliance

| Map | Cave steps | Building steps | Floor steps | Our quests: cave | Our quests: building | Our quests: floor | Questify cave entrances |
|---|---|---|---|---|---|---|---|
| Alterac Mountains (1416) | 0 | 2 | 0 | none | none | none | 0 |
| Arathi Highlands (1417) | 6 | 3 | 5 | 642, 651, 691 | 665 | 662 | 0 |
| Western Plaguelands (1422) | 0 | 25 | 9 | none | 5021, 5022, 5058, 5060, 6023 | 5021, 5060 | 0 |
| Eastern Plaguelands (1423) | 1 | 3 | 0 | none | none | none | 0 |
| Hillsbrad Foothills (1424) | 3 | 4 | 1 | none | 555 | 555 | 0 |
| Dun Morogh (1426) | 20 | 2 | 9 | 218, 287, 313, 413, 414, 432, 433 | 170 | 310, 311 | 1 |
| Searing Gorge (1427) | 6 | 0 | 8 | none | none | 7722 | 0 |
| Elwynn Forest (1429) | 9 | 10 | 35 | 21, 62, 76, 91743 | 60, 69, 70 | 70, 75, 3905 | 1 |
| Duskwood (1431) | 7 | 25 | 2 | 134, 181 | 66, 78, 79, 101, 148, 149, 154, 160, 163, 164, 165, 175, 177, 223, 251, 253 | none | 0 |
| Loch Modan (1432) | 9 | 30 | 10 | 307 | 298, 301, 302, 6387, 6392 | none | 0 |
| Redridge Mountains (1433) | 1 | 13 | 2 | none | 91 | none | 0 |
| Stranglethorn Vale (1434) | 2 | 2 | 5 | none | 202, 608 | 200, 328 | 0 |
| Westfall (1436) | 0 | 6 | 2 | none | 67, 68 | none | 0 |
| Wetlands (1437) | 12 | 14 | 18 | 305, 306 | 98221 | none | 0 |
| Teldrassil (1438) | 3 | 0 | 0 | 917 | none | none | 0 |
| Darkshore (1439) | 20 | 6 | 30 | 947, 994 | 982 | 947, 965, 982, 983 | 0 |
| Ashenvale (1440) | 0 | 0 | 2 | none | none | none | 0 |
| Desolace (1443) | 0 | 6 | 2 | none | 5741 | 5741 | 0 |
| Feralas (1444) | 4 | 0 | 3 | none | none | none | 0 |
| Dustwallow Marsh (1445) | 0 | 5 | 6 | none | 1204, 1206, 1286 | 1220, 1286 | 0 |
| Tanaris (1446) | 1 | 3 | 1 | 10 | none | 2873 | 0 |
| Un'Goro Crater (1449) | 2 | 0 | 0 | 3883 | none | none | 0 |
| Silithus (1451) | 0 | 2 | 0 | none | none | none | 0 |
| Winterspring (1452) | 6 | 0 | 0 | 5087 | none | none | 0 |
| Stormwind City (1453) | 0 | 10 | 61 | none | none | 97222 | 0 |
| Ironforge (1455) | 0 | 8 | 16 | none | 6388, 6391 | none | 0 |
| Darnassus (1457) | 0 | 1 | 1 | none | none | none | 0 |
| Zephras Isle (2521) | 26 | 106 | 92 | 92849, 94489 | 93927, 94414 | 92645, 93927, 94414 | 0 |

Other maps with indoor notes at APR (no Questify step there yet): 1.

### Horde

| Map | Cave steps | Building steps | Floor steps | Our quests: cave | Our quests: building | Our quests: floor | Questify cave entrances |
|---|---|---|---|---|---|---|---|
| Durotar (1411) | 12 | 29 | 12 | none | none | 830 | 2 |
| Mulgore (1412) | 6 | 3 | 1 | 76156 | 3376, 76156 | 76156 | 0 |
| The Barrens (1413) | 2 | 24 | 9 | none | 858, 867, 871, 875, 876, 95508 | 876, 887 | 0 |
| Alterac Mountains (1416) | 14 | 3 | 6 | none | 503, 544 | 503, 506, 544 | 0 |
| Arathi Highlands (1417) | 7 | 3 | 0 | 642, 676 | 662 | none | 0 |
| Tirisfal Glades (1420) | 17 | 13 | 8 | 380 | 354, 371, 375 | 375 | 1 |
| Silverpine Forest (1421) | 39 | 9 | 3 | none | none | none | 0 |
| Western Plaguelands (1422) | 0 | 25 | 7 | none | 5021, 5023, 5050, 5058, 5060, 5902, 6023, 6390 | 5021, 5050, 5060, 5902, 6390 | 0 |
| Eastern Plaguelands (1423) | 3 | 7 | 1 | 6021, 6024 | 5281, 6021, 6164 | 6164 | 0 |
| Hillsbrad Foothills (1424) | 3 | 15 | 4 | 539, 567 | 498, 527, 532, 549, 567 | 527, 539 | 0 |
| The Hinterlands (1425) | 1 | 0 | 0 | none | none | none | 0 |
| Searing Gorge (1427) | 14 | 5 | 6 | 7722, 7727 | 3463 | 3463, 7727 | 0 |
| Stranglethorn Vale (1434) | 2 | 3 | 2 | none | 608 | 624 | 0 |
| Swamp of Sorrows (1435) | 1 | 0 | 0 | none | none | none | 0 |
| Ashenvale (1440) | 2 | 6 | 5 | 6482 | 6544 | 6544 | 0 |
| Thousand Needles (1441) | 5 | 4 | 3 | none | 5064 | none | 0 |
| Stonetalon Mountains (1442) | 1 | 2 | 0 | none | none | none | 0 |
| Desolace (1443) | 0 | 1 | 0 | none | none | none | 0 |
| Feralas (1444) | 0 | 2 | 0 | none | 7731 | none | 0 |
| Dustwallow Marsh (1445) | 6 | 0 | 0 | 625, 1166, 1168 | none | none | 0 |
| Tanaris (1446) | 0 | 3 | 1 | none | none | 2873 | 0 |
| Azshara (1447) | 0 | 4 | 0 | none | none | none | 0 |
| Felwood (1448) | 3 | 0 | 0 | 5203, 5204 | none | none | 0 |
| Un'Goro Crater (1449) | 10 | 0 | 1 | 4285, 4287, 4288, 4321 | none | none | 0 |
| Silithus (1451) | 0 | 2 | 0 | none | none | none | 0 |
| Winterspring (1452) | 7 | 0 | 0 | 5087 | none | none | 0 |
| Orgrimmar (1454) | 0 | 12 | 4 | none | 3541, 3563, 7732 | 97246 | 0 |
| Thunder Bluff (1456) | 9 | 0 | 12 | none | none | none | 0 |
| Undercity (1458) | 16 | 0 | 70 | none | none | 5049, 5050 | 0 |
| Zephras Isle (2521) | 5 | 21 | 24 | 94489 | 93927 | 93927 | 0 |

Other maps with indoor notes at APR (no Questify step there yet): 2.

## APR leveling routes without a Questify chapter

General leveling routes (open to at least 4 classes) that no chapter of the faction matches: ground still to cover (levels 30-60), or a zone or variant our route skips.

### Alliance (8 routes)

| APR route | Quests | Done by a Questify chapter |
|---|---|---|
| #14 (Zephras Isle (2521), 10-13) | 4 | 0 |
| #16 (Loch Modan (1432), 11-13) | 17 | 4 |
| #55 (Wetlands (1437), 23-24) | 12 | 2 |
| #86 (Desolace (1443), 40-41) | 16 | 3 |
| #107 (Western Plaguelands (1422), 51-52) | 35 | 8 |
| #111 (Feralas (1444), 52-53) | 12 | 2 |
| #112 (Azshara (1447), 53-53) | 13 | 0 |
| #118 (Burning Steppes (1428), 56-57) | 38 | 7 |

### Horde (4 routes)

| APR route | Quests | Done by a Questify chapter |
|---|---|---|
| #13 (Tirisfal Glades (1420), 10-12) | 11 | 4 |
| #54 (Hillsbrad Foothills (1424), 22-24) | 26 | 10 |
| #91 (Desolace (1443), 41-41) | 8 | 0 |
| #102 (Feralas (1444), 49-50) | 26 | 9 |
