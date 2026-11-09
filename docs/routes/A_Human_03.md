# A_Human_03 — Westfall

Generated on 2026-11-09 from QuestieDB commit `4d31c10394b11bd133069ecf1662062cdf4d8691` by `tools/routebuilder/build.lua`. Simulated race: Human.

| Item | Value |
|---|---|
| Level band | 11-16 |
| Simulated level | 12.00 -> 16.00 |
| Time | 104 min |
| XP gained | 40014 |
| XP/h | 23083 |
| Steps | 60 |
| Quests turned in | 21 |
| Hubs | 7 |
| Median ratio (XP/s) | 5.55 |
| Grinding (level steps) | ~9 mobs |
| Level band | grinding 28 mobs with quests up to level 19: band widened to level 22 |
| Hearthstone | no new bind; 0 return(s) planned, 0 bundle(s) |

## Kept quests (turn-in order)

XP marked `est.` is an estimate (no QuestXP value: new Forever quest).

| # | Quest | Name | Lvl | XP | Sim lvl |
|---|---|---|---|---|---|
| 1 | 36 | Westfall Stew | 10 | 420 | 13 |
| 2 | 12 | The People's Militia | 12 | 910 | 13 |
| 3 | 92742 | Testing the Wells | 12 | 910 est. | 13 |
| 4 | 92744 | Murloc Gills | 12 | 910 est. | 13 |
| 5 | 136 | Captain Sander's Hidden Treasure | 16 | 580 | 14 |
| 6 | 138 | Captain Sander's Hidden Treasure | 16 | 580 | 14 |
| 7 | 139 | Captain Sander's Hidden Treasure | 16 | 580 | 14 |
| 8 | 140 | Captain Sander's Hidden Treasure | 16 | 1150 | 14 |
| 9 | 92745 | The State of the Mines | 14 | 980 est. | 14 |
| 10 | 13 | The People's Militia | 14 | 980 | 14 |
| 11 | 102 | Patrolling Westfall | 14 | 980 | 15 |
| 12 | 6181 | A Swift Message | 10 | 210 | 15 |
| 13 | 92747 | Moonbrook Espionage | 15 | 1050 est. | 15 |
| 14 | 14 | The People's Militia | 17 | 1600 | 15 |
| 15 | 9 | The Killing Fields | 15 | 1050 | 15 |
| 16 | 22 | Goretusk Liver Pie | 12 | 910 | 15 |
| 17 | 151 | Poor Old Blanchy | 14 | 1250 | 15 |
| 18 | 64 | The Forgotten Heirloom | 12 | 910 | 15 |
| 19 | 79093 | Rumi of Gnomeregan: The Collected Works | 20 | 1550 est. | 15 |
| 20 | 6281 | Continue to Stormwind | 10 | 420 | 15 |
| 21 | 92748 | Explosive Consultation | 16 | 580 est. | 15 |

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
| 104 | The Coastal Menace | 20 | required level 15 not reached in time (~245 mobs to farm) |
| 117 | Thunderbrew | 15 | repeatable |
| 144 | Messenger to Westfall | 14 | finisher outside the chapter zones |
| 152 | The Coast Isn't Clear | 19 | objective too dangerous before level 16 (not reached in this chapter) |
| 1651 | The Tome of Valor | 25 | class quest (ClassQuestData.lua) |
| 1652 | The Tome of Valor | 25 | class quest (ClassQuestData.lua) |
| 2359 | Klaven's Tower | 24 | class quest (ClassQuestData.lua) |
| 3861 | CLUCK! | 1 | quest level 1 below the band |
| 8675 | Skychaser the Elder | 60 | Questie blacklist |
| 78142 | Bewitchments and Glamours | 20 | objective too dangerous before level 17 (not reached in this chapter) |
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
| 153 | Red Leather Bandanas | 15 | level band reached |
| 92909 | Harvesting the Harvesters | 15 | level band reached |
| 38 | Westfall Stew | 13 | level band reached |
| 103 | Keeper of the Flame | 16 | level band reached |

## Candidate ratios

Value = quest XP at the simulated level + mob XP + strategic bonus. Ratio = chain value / isolated time;
marginal ratio uses the detour from places the route visits anyway. A quest is dropped when both ratios are
below 0.35 × the median ratio, or when an objective is more than 900 yd from every hub.

| Quest | Name | Lvl | Value | Bonus | Isolated s | Marginal s | Ratio | Marginal ratio | Sites | Dropped |
|---|---|---|---|---|---|---|---|---|---|---|
| 9 | The Killing Fields | 15 | 3350 | 0 | 633 | 448 | 5.29 | 7.46 | 1 |  |
| 12 | The People's Militia | 12 | 3850 | 0 | 911 | 791 | 5.04 | 5.84 | 2 |  |
| 13 | The People's Militia | 14 | 4355 | 0 | 808 | 696 | 5.84 | 6.82 | 1 |  |
| 14 | The People's Militia | 17 | 4795 | 0 | 732 | 620 | 6.55 | 7.73 | 1 |  |
| 22 | Goretusk Liver Pie | 12 | 3535 | 0 | 598 | 559 | 5.90 | 6.32 | 1 |  |
| 36 | Westfall Stew | 10 | 420 | 0 | 51 | 11 | 5.21 | 5.82 | 0 |  |
| 38 | Westfall Stew | 13 | 4857 | 0 | 974 | 920 | 4.99 | 5.28 | 3 | level band reached |
| 64 | The Forgotten Heirloom | 12 | 910 | 0 | 122 | 41 | 7.43 | 22.19 | 1 |  |
| 102 | Patrolling Westfall | 14 | 4200 | 0 | 865 | 689 | 4.85 | 6.09 | 1 |  |
| 103 | Keeper of the Flame | 16 | 2470 | 0 | 981 | 570 | 2.52 | 4.33 | 1 | level band reached |
| 136 | Captain Sander's Hidden Treasure | 16 | 1130 | 0 | 251 | 170 | 5.29 | 9.36 | 0 |  |
| 138 | Captain Sander's Hidden Treasure | 16 | 580 | 0 | 83 | 10 | 6.50 | 16.53 | 0 |  |
| 139 | Captain Sander's Hidden Treasure | 16 | 580 | 0 | 112 | 10 | 6.23 | 11.58 | 0 |  |
| 140 | Captain Sander's Hidden Treasure | 16 | 1150 | 0 | 156 | 156 | 7.34 | 7.34 | 0 |  |
| 151 | Poor Old Blanchy | 14 | 1250 | 0 | 133 | 133 | 9.36 | 9.36 | 1 |  |
| 153 | Red Leather Bandanas | 15 | 4326 | 0 | 961 | 800 | 4.50 | 5.40 | 1 | level band reached |
| 6181 | A Swift Message | 10 | 210 | 0 | 47 | 47 | 5.74 | 20.73 | 0 |  |
| 6281 | Continue to Stormwind | 10 | 1893 | 1473 | 314 | 38 | 6.02 | 49.78 | 0 |  |
| 79093 | Rumi of Gnomeregan: The Collected Works | 20 | 2769 | 1219 | 259 | 26 | 10.69 | 105.84 | 1 |  |
| 79192 | Stepping Stones | 24 | 970 | 0 | 23 | 10 | 41.58 | 97.00 | 0 |  |
| 92742 | Testing the Wells | 12 | 910 | 0 | 283 | 83 | 3.99 | 10.39 | 2 |  |
| 92744 | Murloc Gills | 12 | 2450 | 0 | 592 | 356 | 4.24 | 8.32 | 1 |  |
| 92745 | The State of the Mines | 14 | 2090 | 0 | 560 | 297 | 4.33 | 10.23 | 2 |  |
| 92747 | Moonbrook Espionage | 15 | 1050 | 0 | 256 | 117 | 5.30 | 20.93 | 1 |  |
| 92748 | Explosive Consultation | 16 | 2280 | 1700 | 346 | 12 | 6.58 | 179.18 | 0 |  |
| 92909 | Harvesting the Harvesters | 15 | 4748 | 0 | 884 | 884 | 5.37 | 5.37 | 1 | level band reached |

## Itinerary

One line per task (A accept, O objective, T turn-in, C timed quest, F flight path). Leg = straight-line
yards from the previous task (blank after a flight, boat or zone change). Returns: the task is within
150 yd of an earlier task after the route went more than 600 yd away from it.

| # | Task | Quest | Name | Map | x, y | Leg yd | Return |
|---|---|---|---|---|---|---|---|
| 1 | A | 12 | The People's Militia | 1436 | 56.3, 47.5 | 0 |  |
| 2 | A | 102 | Patrolling Westfall | 1436 | 56.4, 47.6 | 3 |  |
| 3 | A | 6181 | A Swift Message | 1436 | 57.0, 47.2 | 22 |  |
| 4 | A | 92742 | Testing the Wells | 1436 | 52.5, 53.0 | 208 |  |
| 5 | A | 92744 | Murloc Gills | 1436 | 52.5, 53.0 | 0 |  |
| 6 | A | 79093 | Rumi of Gnomeregan: The Collected Works | 1436 | 52.7, 53.8 | 20 |  |
| 7 | O | 92742 | Testing the Wells | 1436 | 46.1, 38.1 | 432 |  |
| 8 | O | 12 | The People's Militia | 1436 | 31.6, 33.8 | 516 |  |
| 9 | A | 136 | Captain Sander's Hidden Treasure | 1436 | 34.5, 17.0 | 404 |  |
| 10 | O | 92744 | Murloc Gills | 1436 | 34.5, 17.0 | 0 |  |
| 11 | O | 12 | The People's Militia | 1436 | 44.8, 26.0 | 415 |  |
| 12 | O | 92742 | Testing the Wells | 1436 | 56.6, 18.7 | 447 |  |
| 13 | A | 36 | Westfall Stew | 1436 | 59.9, 19.4 | 116 |  |
| 14 | A | 151 | Poor Old Blanchy | 1436 | 59.9, 19.4 | 0 |  |
| 15 | A | 64 | The Forgotten Heirloom | 1436 | 60.0, 19.4 | 1 |  |
| 16 | O | 151 | Poor Old Blanchy | 1436 | 57.3, 18.3 | 97 |  |
| 17 | A | 22 | Goretusk Liver Pie | 1436 | 56.4, 30.5 | 286 |  |
| 18 | T | 36 | Westfall Stew | 1436 | 56.4, 30.5 | 0 |  |
| 19 | A | 9 | The Killing Fields | 1436 | 56.0, 31.2 | 21 |  |
| 20 | O | 22 | Goretusk Liver Pie | 1436 | 53.7, 42.9 | 285 | near #2 (went 903 yd away) |
| 21 | T | 12 | The People's Militia | 1436 | 56.3, 47.5 | 141 | near #3 (went 1043 yd away) |
| 22 | A | 13 | The People's Militia | 1436 | 56.3, 47.5 | 0 |  |
| 23 | T | 92742 | Testing the Wells | 1436 | 52.5, 53.0 | 185 | near #6 (went 1048 yd away) |
| 24 | T | 92744 | Murloc Gills | 1436 | 52.5, 53.0 | 0 | near #6 (went 1048 yd away) |
| 25 | A | 92745 | The State of the Mines | 1436 | 52.5, 53.0 | 0 |  |
| 26 | O | 79093 | Rumi of Gnomeregan: The Collected Works | 1436 | 52.7, 53.8 | 20 |  |
| 27 | O | 13 | The People's Militia | 1436 | 43.7, 68.9 | 472 |  |
| 28 | O | 102 | Patrolling Westfall | 1436 | 31.0, 68.8 | 443 |  |
| 29 | T | 136 | Captain Sander's Hidden Treasure | 1436 | 25.9, 47.8 | 522 |  |
| 30 | A | 138 | Captain Sander's Hidden Treasure | 1436 | 25.9, 47.8 | 0 |  |
| 31 | O | 92745 | The State of the Mines | 1436 | 30.0, 47.3 | 143 |  |
| 32 | T | 138 | Captain Sander's Hidden Treasure | 1436 | 40.5, 47.8 | 368 |  |
| 33 | A | 139 | Captain Sander's Hidden Treasure | 1436 | 40.5, 47.8 | 0 |  |
| 34 | O | 64 | The Forgotten Heirloom | 1436 | 49.3, 19.3 | 733 |  |
| 35 | O | 92745 | The State of the Mines | 1436 | 45.3, 20.0 | 142 | near #11 (went 1241 yd away) |
| 36 | T | 139 | Captain Sander's Hidden Treasure | 1436 | 40.6, 17.0 | 177 |  |
| 37 | A | 140 | Captain Sander's Hidden Treasure | 1436 | 40.6, 17.0 | 0 |  |
| 38 | T | 140 | Captain Sander's Hidden Treasure | 1436 | 26.0, 16.9 | 513 |  |
| 39 | A | 79192 | Stepping Stones | 1436 | 37.4, 50.7 | 884 | near #33 (went 884 yd away) |
| 40 | O | 9 | The Killing Fields | 1436 | 38.8, 51.5 | 51 | near #33 (went 923 yd away) |
| 41 | T | 92745 | The State of the Mines | 1436 | 52.5, 53.0 | 480 | near #26 (went 1252 yd away) |
| 42 | A | 92747 | Moonbrook Espionage | 1436 | 52.5, 53.0 | 0 | near #26 (went 1252 yd away) |
| 43 | T | 13 | The People's Militia | 1436 | 56.3, 47.5 | 185 | near #22 (went 1280 yd away) |
| 44 | A | 14 | The People's Militia | 1436 | 56.3, 47.5 | 0 | near #22 (went 1280 yd away) |
| 45 | T | 102 | Patrolling Westfall | 1436 | 56.4, 47.6 | 3 |  |
| 46 | T | 6181 | A Swift Message | 1436 | 56.5, 52.6 | 117 |  |
| 47 | A | 6281 | Continue to Stormwind | 1436 | 56.5, 52.6 | 0 |  |
| 48 | O | 14 | The People's Militia | 1436 | 52.1, 76.6 | 580 |  |
| 49 | O | 92747 | Moonbrook Espionage | 1436 | 43.1, 68.8 | 362 | near #27 (went 1352 yd away) |
| 50 | T | 92747 | Moonbrook Espionage | 1436 | 52.5, 53.0 | 494 |  |
| 51 | A | 92748 | Explosive Consultation | 1436 | 52.5, 53.0 | 0 |  |
| 52 | T | 14 | The People's Militia | 1436 | 56.3, 47.5 | 185 | near #47 (went 694 yd away) |
| 53 | T | 9 | The Killing Fields | 1436 | 56.0, 31.2 | 380 | near #19 (went 1237 yd away) |
| 54 | T | 22 | Goretusk Liver Pie | 1436 | 56.4, 30.5 | 21 | near #19 (went 1259 yd away) |
| 55 | T | 151 | Poor Old Blanchy | 1436 | 59.9, 19.4 | 286 | near #16 (went 1532 yd away) |
| 56 | T | 64 | The Forgotten Heirloom | 1436 | 60.0, 19.4 | 1 | near #16 (went 1533 yd away) |
| 57 | T | 79093 | Rumi of Gnomeregan: The Collected Works | 1453 | 48.9, 86.5 | 854 |  |
| 58 | T | 6281 | Continue to Stormwind | 1453 | 77.2, 61.0 | 572 |  |
| 59 | T | 92748 | Explosive Consultation | 1453 | 61.9, 30.6 | 441 |  |

Walking between tasks: 13049 yd (~31 min at 7 yd/s).

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

- step 60: `level 16` — About 9 more mobs near the last objective

## Warnings

None.
