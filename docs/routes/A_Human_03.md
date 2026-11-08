# A_Human_03 — Westfall

Generated on 2026-11-08 from QuestieDB commit `4d31c10394b11bd133069ecf1662062cdf4d8691` by `tools/routebuilder/build.lua`. Simulated race: Human.

| Item | Value |
|---|---|
| Level band | 11-16 |
| Simulated level | 12.00 -> 16.04 |
| Time | 127 min |
| XP gained | 49221 |
| XP/h | 23254 |
| Steps | 72 |
| Quests turned in | 23 |
| Hubs | 8 |
| Median ratio (XP/s) | 5.49 |
| Grinding (level steps) | ~20 mobs |
| Level band | grinding 102 mobs with quests up to level 19: band widened to level 22 |
| Hearthstone | bound to Innkeeper Heather after task 6; 1 return(s) planned, 1 bundle(s) |

## Kept quests (turn-in order)

XP marked `est.` is an estimate (no QuestXP value: new Forever quest).

| # | Quest | Name | Lvl | XP | Sim lvl |
|---|---|---|---|---|---|
| 1 | 12 | The People's Militia | 12 | 910 | 12 |
| 2 | 92744 | Murloc Gills | 12 | 910 est. | 12 |
| 3 | 92742 | Testing the Wells | 12 | 910 est. | 12 |
| 4 | 136 | Captain Sander's Hidden Treasure | 16 | 580 | 13 |
| 5 | 138 | Captain Sander's Hidden Treasure | 16 | 580 | 13 |
| 6 | 139 | Captain Sander's Hidden Treasure | 16 | 580 | 14 |
| 7 | 140 | Captain Sander's Hidden Treasure | 16 | 1150 | 14 |
| 8 | 92745 | The State of the Mines | 14 | 980 est. | 14 |
| 9 | 152 | The Coast Isn't Clear | 19 | 1450 | 14 |
| 10 | 103 | Keeper of the Flame | 16 | 1150 | 14 |
| 11 | 92747 | Moonbrook Espionage | 15 | 1050 est. | 14 |
| 12 | 13 | The People's Militia | 14 | 980 | 14 |
| 13 | 102 | Patrolling Westfall | 14 | 980 | 14 |
| 14 | 6181 | A Swift Message | 10 | 210 | 15 |
| 15 | 14 | The People's Militia | 17 | 1600 | 15 |
| 16 | 9 | The Killing Fields | 15 | 1050 | 15 |
| 17 | 22 | Goretusk Liver Pie | 12 | 910 | 15 |
| 18 | 151 | Poor Old Blanchy | 14 | 1250 | 15 |
| 19 | 64 | The Forgotten Heirloom | 12 | 910 | 15 |
| 20 | 79093 | Rumi of Gnomeregan: The Collected Works | 20 | 1550 est. | 15 |
| 21 | 78142 | Bewitchments and Glamours | 20 | 1550 est. | 15 |
| 22 | 6281 | Continue to Stormwind | 10 | 420 | 16 |
| 23 | 92748 | Explosive Consultation | 16 | 580 est. | 16 |

## Dropped quests

| Quest | Name | Lvl | Reason |
|---|---|---|---|
| 48 | Sweet Amber | 44 | quest level 44 above the band |
| 49 | Sweet Amber | 44 | quest level 44 above the band |
| 50 | Sweet Amber | 44 | quest level 44 above the band |
| 51 | Sweet Amber | 44 | quest level 44 above the band |
| 53 | Sweet Amber | 44 | quest level 44 above the band |
| 65 | The Defias Brotherhood | 18 | finisher outside the chapter zones |
| 68 | The Legend of Stalvan | 28 | quest level 28 above the band |
| 104 | The Coastal Menace | 20 | required level 15 not reached in time (~51 mobs to farm) |
| 117 | Thunderbrew | 15 | repeatable |
| 144 | Messenger to Westfall | 14 | finisher outside the chapter zones |
| 1651 | The Tome of Valor | 25 | class quest (ClassQuestData.lua) |
| 1652 | The Tome of Valor | 25 | class quest (ClassQuestData.lua) |
| 2359 | Klaven's Tower | 24 | class quest (ClassQuestData.lua) |
| 3861 | CLUCK! | 1 | quest level 1 below the band |
| 8675 | Skychaser the Elder | 60 | Questie blacklist |
| 79008 | ... and that note you found | 22 | finisher outside the chapter zones |
| 92109 | My First Alchemy Set | 10 | requires a profession |
| 92110 | My First Real Potion | 10 | requires a profession |
| 92910 | Harvesting the Harvesters | 15 | requires a profession |
| 92911 | Harvesting the Harvesters | 15 | requires a profession |
| 93928 | Of Mice and Milk | 15 | Questie blacklist |
| 94503 | Call of Water | 23 | class quest (ClassQuestData.lua) |
| 135 | The Defias Brotherhood | 18 | prerequisite unavailable |
| 142 | The Defias Brotherhood | 18 | prerequisite unavailable |
| 155 | The Defias Brotherhood | 18 | prerequisite unavailable |
| 166 | The Defias Brotherhood | 22 | prerequisite unavailable |
| 214 | Red Silk Bandanas | 17 | prerequisite unavailable |
| 92753 | Destruction in Deadmines | 18 | prerequisite unavailable |
| 92819 | Destruction in Deadmines | 18 | prerequisite unavailable |
| 36 | Westfall Stew | 10 | level band reached |
| 153 | Red Leather Bandanas | 15 | level band reached |
| 92909 | Harvesting the Harvesters | 15 | level band reached |
| 38 | Westfall Stew | 13 | level band reached |

## Candidate ratios

Value = quest XP at the simulated level + mob XP + strategic bonus. Ratio = chain value / isolated time;
marginal ratio uses the detour from places the route visits anyway. A quest is dropped when both ratios are
below 0.35 × the median ratio, or when an objective is more than 900 yd from every hub.

| Quest | Name | Lvl | Value | Bonus | Isolated s | Marginal s | Ratio | Marginal ratio | Sites | Dropped |
|---|---|---|---|---|---|---|---|---|---|---|
| 9 | The Killing Fields | 15 | 3350 | 0 | 633 | 448 | 5.29 | 7.46 | 1 |  |
| 12 | The People's Militia | 12 | 3850 | 0 | 911 | 683 | 5.04 | 6.27 | 2 |  |
| 13 | The People's Militia | 14 | 4355 | 0 | 808 | 696 | 5.84 | 6.82 | 1 |  |
| 14 | The People's Militia | 17 | 4795 | 0 | 732 | 620 | 6.55 | 7.73 | 1 |  |
| 22 | Goretusk Liver Pie | 12 | 3535 | 0 | 598 | 559 | 5.90 | 6.32 | 1 |  |
| 36 | Westfall Stew | 10 | 420 | 0 | 51 | 11 | 5.21 | 5.82 | 0 | level band reached |
| 38 | Westfall Stew | 13 | 4857 | 0 | 974 | 920 | 4.99 | 5.28 | 3 | level band reached |
| 64 | The Forgotten Heirloom | 12 | 910 | 0 | 122 | 41 | 7.43 | 22.19 | 1 |  |
| 102 | Patrolling Westfall | 14 | 4200 | 0 | 865 | 689 | 4.85 | 6.09 | 1 |  |
| 103 | Keeper of the Flame | 16 | 2470 | 0 | 723 | 250 | 3.41 | 9.88 | 1 |  |
| 136 | Captain Sander's Hidden Treasure | 16 | 1130 | 0 | 251 | 170 | 5.29 | 10.62 | 0 |  |
| 138 | Captain Sander's Hidden Treasure | 16 | 580 | 0 | 83 | 10 | 6.50 | 28.93 | 0 |  |
| 139 | Captain Sander's Hidden Treasure | 16 | 580 | 0 | 112 | 10 | 6.23 | 22.26 | 0 |  |
| 140 | Captain Sander's Hidden Treasure | 16 | 1150 | 0 | 156 | 74 | 7.34 | 15.42 | 0 |  |
| 151 | Poor Old Blanchy | 14 | 1250 | 0 | 133 | 133 | 9.36 | 9.36 | 1 |  |
| 152 | The Coast Isn't Clear | 19 | 5025 | 0 | 1255 | 793 | 4.00 | 6.33 | 4 |  |
| 153 | Red Leather Bandanas | 15 | 4326 | 0 | 961 | 800 | 4.50 | 5.40 | 1 | level band reached |
| 6181 | A Swift Message | 10 | 210 | 0 | 47 | 47 | 5.62 | 20.32 | 0 |  |
| 6281 | Continue to Stormwind | 10 | 1849 | 1429 | 314 | 38 | 5.88 | 48.62 | 0 |  |
| 78142 | Bewitchments and Glamours | 20 | 3038 | 1488 | 387 | 19 | 7.85 | 158.11 | 1 |  |
| 79093 | Rumi of Gnomeregan: The Collected Works | 20 | 2733 | 1183 | 259 | 26 | 10.55 | 104.45 | 1 |  |
| 79192 | Stepping Stones | 24 | 970 | 0 | 23 | 10 | 41.58 | 97.00 | 0 |  |
| 92742 | Testing the Wells | 12 | 910 | 0 | 283 | 33 | 3.97 | 12.05 | 2 |  |
| 92744 | Murloc Gills | 12 | 2450 | 0 | 592 | 356 | 4.22 | 8.29 | 1 |  |
| 92745 | The State of the Mines | 14 | 2090 | 0 | 560 | 297 | 4.30 | 10.16 | 2 |  |
| 92747 | Moonbrook Espionage | 15 | 1050 | 0 | 256 | 117 | 5.23 | 20.65 | 1 |  |
| 92748 | Explosive Consultation | 16 | 2229 | 1649 | 346 | 12 | 6.43 | 175.19 | 0 |  |
| 92909 | Harvesting the Harvesters | 15 | 4748 | 0 | 884 | 884 | 5.37 | 5.37 | 1 | level band reached |

## Itinerary

One line per task (A accept, O objective, T turn-in, C timed quest, F flight path). Leg = straight-line
yards from the previous task (blank after a flight, boat or zone change). Returns: the task is within
150 yd of an earlier task after the route went more than 600 yd away from it.

| # | Task | Quest | Name | Map | x, y | Leg yd | Return |
|---|---|---|---|---|---|---|---|
| 1 | A | 12 | The People's Militia | 1436 | 56.3, 47.5 | 0 |  |
| 2 | A | 6181 | A Swift Message | 1436 | 57.0, 47.2 | 24 |  |
| 3 | A | 102 | Patrolling Westfall | 1436 | 56.4, 47.6 | 22 |  |
| 4 | A | 92742 | Testing the Wells | 1436 | 52.5, 53.0 | 186 |  |
| 5 | A | 92744 | Murloc Gills | 1436 | 52.5, 53.0 | 0 |  |
| 6 | A | 79093 | Rumi of Gnomeregan: The Collected Works | 1436 | 52.7, 53.8 | 20 |  |
| 7 | O | 92742 | Testing the Wells | 1436 | 46.1, 38.1 | 433 |  |
| 8 | O | 12 | The People's Militia | 1436 | 31.6, 33.8 | 516 |  |
| 9 | O | 92744 | Murloc Gills | 1436 | 34.5, 17.0 | 404 |  |
| 10 | A | 136 | Captain Sander's Hidden Treasure | 1436 | 34.5, 17.0 | 0 |  |
| 11 | O | 12 | The People's Militia | 1436 | 44.8, 26.0 | 415 |  |
| 12 | O | 92742 | Testing the Wells | 1436 | 56.6, 18.7 | 447 |  |
| 13 | A | 64 | The Forgotten Heirloom | 1436 | 60.0, 19.4 | 117 |  |
| 14 | A | 151 | Poor Old Blanchy | 1436 | 59.9, 19.4 | 1 |  |
| 15 | A | 22 | Goretusk Liver Pie | 1436 | 56.4, 30.5 | 286 |  |
| 16 | A | 9 | The Killing Fields | 1436 | 56.0, 31.2 | 21 |  |
| 17 | T | 12 | The People's Militia | 1436 | 56.3, 47.5 | 380 | near #3 (went 1043 yd away) |
| 18 | A | 13 | The People's Militia | 1436 | 56.3, 47.5 | 0 | near #3 (went 1043 yd away) |
| 19 | T | 92744 | Murloc Gills | 1436 | 52.5, 53.0 | 185 | near #6 (went 1048 yd away) |
| 20 | T | 92742 | Testing the Wells | 1436 | 52.5, 53.0 | 0 | near #6 (went 1048 yd away) |
| 21 | A | 92745 | The State of the Mines | 1436 | 52.5, 53.0 | 0 |  |
| 22 | A | 78142 | Bewitchments and Glamours | 1436 | 45.4, 70.4 | 476 |  |
| 23 | O | 78142 | Bewitchments and Glamours | 1436 | 45.4, 70.4 | 0 |  |
| 24 | O | 13 | The People's Militia | 1436 | 43.7, 68.9 | 68 |  |
| 25 | A | 152 | The Coast Isn't Clear | 1436 | 30.0, 86.0 | 623 |  |
| 26 | A | 103 | Keeper of the Flame | 1436 | 30.0, 86.0 | 0 |  |
| 27 | O | 152 | The Coast Isn't Clear | 1436 | 27.3, 70.9 | 364 |  |
| 28 | O | 102 | Patrolling Westfall | 1436 | 31.0, 68.8 | 139 |  |
| 29 | O | 152 | The Coast Isn't Clear | 1436 | 27.2, 53.7 | 376 |  |
| 30 | T | 136 | Captain Sander's Hidden Treasure | 1436 | 25.9, 47.8 | 145 |  |
| 31 | A | 138 | Captain Sander's Hidden Treasure | 1436 | 25.9, 47.8 | 0 |  |
| 32 | O | 92745 | The State of the Mines | 1436 | 30.0, 47.3 | 143 |  |
| 33 | T | 138 | Captain Sander's Hidden Treasure | 1436 | 40.5, 47.8 | 368 |  |
| 34 | A | 139 | Captain Sander's Hidden Treasure | 1436 | 40.5, 47.8 | 0 |  |
| 35 | O | 103 | Keeper of the Flame | 1436 | 52.8, 23.8 | 706 |  |
| 36 | O | 64 | The Forgotten Heirloom | 1436 | 49.3, 19.3 | 161 |  |
| 37 | O | 92745 | The State of the Mines | 1436 | 45.3, 20.0 | 142 | near #11 (went 1629 yd away) |
| 38 | O | 152 | The Coast Isn't Clear | 1436 | 43.5, 9.6 | 251 |  |
| 39 | T | 139 | Captain Sander's Hidden Treasure | 1436 | 40.6, 17.0 | 201 |  |
| 40 | A | 140 | Captain Sander's Hidden Treasure | 1436 | 40.6, 17.0 | 0 |  |
| 41 | T | 140 | Captain Sander's Hidden Treasure | 1436 | 26.0, 16.9 | 513 |  |
| 42 | O | 152 | The Coast Isn't Clear | 1436 | 29.8, 27.6 | 283 |  |
| 43 | A | 79192 | Stepping Stones | 1436 | 37.4, 50.7 | 601 | near #34 (went 982 yd away) |
| 44 | O | 9 | The Killing Fields | 1436 | 38.8, 51.5 | 51 | near #34 (went 991 yd away) |
| 45 | T | 92745 | The State of the Mines | 1436 | 52.5, 53.0 | 480 | near #21 (went 1252 yd away) |
| 46 | A | 92747 | Moonbrook Espionage | 1436 | 52.5, 53.0 | 0 | near #21 (went 1252 yd away) |
| 47 | O | 92747 | Moonbrook Espionage | 1436 | 43.1, 68.8 | 494 | near #24 (went 1382 yd away) |
| 48 | T | 152 | The Coast Isn't Clear | 1436 | 30.0, 86.0 | 608 | near #26 (went 1844 yd away) |
| 49 | T | 103 | Keeper of the Flame | 1436 | 30.0, 86.0 | 0 | near #26 (went 1844 yd away) |
| 50 | O | 79093 | Rumi of Gnomeregan: The Collected Works | 1436 | 52.7, 53.8 | 1093 | near #46 (went 1093 yd away) |
| 51 | T | 92747 | Moonbrook Espionage | 1436 | 52.5, 53.0 | 20 | near #46 (went 1101 yd away) |
| 52 | A | 92748 | Explosive Consultation | 1436 | 52.5, 53.0 | 0 |  |
| 53 | T | 13 | The People's Militia | 1436 | 56.3, 47.5 | 185 | near #18 (went 1286 yd away) |
| 54 | A | 14 | The People's Militia | 1436 | 56.3, 47.5 | 0 | near #18 (went 1286 yd away) |
| 55 | T | 102 | Patrolling Westfall | 1436 | 56.4, 47.6 | 3 |  |
| 56 | T | 6181 | A Swift Message | 1436 | 56.5, 52.6 | 117 |  |
| 57 | A | 6281 | Continue to Stormwind | 1436 | 56.5, 52.6 | 0 |  |
| 58 | O | 14 | The People's Militia | 1436 | 52.1, 76.6 | 580 |  |
| 59 | T | 14 | The People's Militia | 1436 | 56.3, 47.5 | 694 | near #57 (went 694 yd away) |
| 60 | O | 22 | Goretusk Liver Pie | 1436 | 53.7, 42.9 | 141 | near #55 (went 787 yd away) |
| 61 | T | 9 | The Killing Fields | 1436 | 56.0, 31.2 | 285 | near #16 (went 1569 yd away) |
| 62 | T | 22 | Goretusk Liver Pie | 1436 | 56.4, 30.5 | 21 | near #16 (went 1591 yd away) |
| 63 | O | 151 | Poor Old Blanchy | 1436 | 57.3, 18.3 | 286 | near #14 (went 1845 yd away) |
| 64 | T | 151 | Poor Old Blanchy | 1436 | 59.9, 19.4 | 96 | near #14 (went 1873 yd away) |
| 65 | T | 64 | The Forgotten Heirloom | 1436 | 60.0, 19.4 | 1 |  |
| 66 | T | 79093 | Rumi of Gnomeregan: The Collected Works | 1453 | 48.9, 86.5 | 854 |  |
| 67 | T | 78142 | Bewitchments and Glamours | 1453 | 48.9, 86.5 | 0 |  |
| 68 | T | 6281 | Continue to Stormwind | 1453 | 77.2, 61.0 | 572 |  |
| 69 | T | 92748 | Explosive Consultation | 1453 | 61.9, 30.6 | 441 |  |

Walking between tasks: 16067 yd (~38 min at 7 yd/s).

## Qualité

Checks of the itinerary (see `tools/routebuilder/quality.lua`): avoidable revisits (a place left,
then returned to only for accepts or turn-ins possible on the earlier visit), missed pickups
(within 40 yd), missed passing turn-ins (within 60 yd) and split objective areas (within 120 yd).
A place counts as left when the route went more than 150 yd away (220 yd for an objective area).
Reason: why the ordering kept it: `log cap`, `level` or `chain` (a constraint later in the route),
`free` (no constraint: a defect).

| Check | Count |
|---|---|
| Avoidable revisits | 0 |
| Missed pickups | 0 |
| Split areas | 0 |
| Missed passing turn-ins | 0 |

## Logistics

- step 7: `sethearth 1436 52.86 53.71`
- step 25: `level 13` — About 20 mobs here (Defias Looter, level 13)
- step 52: `hearth 1436`

## Warnings

None.
