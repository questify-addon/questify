# A_Human_01 — Northshire

Generated on 2026-11-10 from QuestieDB commit `4d31c10394b11bd133069ecf1662062cdf4d8691` by `tools/routebuilder/build.lua`. Simulated race: Human.

| Item | Value |
|---|---|
| Level band | 1-6 |
| Simulated level | 1.00 -> 6.22 |
| Time | 44 min |
| XP gained | 8383 |
| XP/h | 11418 |
| Steps | 71 |
| Quests turned in | 21 |
| Hubs | 2 |
| Median ratio (XP/s) | 3.11 |
| Hearthstone | no new bind; 0 return(s) planned, 0 bundle(s) |

## Kept quests (turn-in order)

XP marked `est.` is an estimate (no QuestXP value: new Forever quest).

| # | Quest | Name | Lvl | XP | Sim lvl |
|---|---|---|---|---|---|
| 1 | 783 | A Threat Within | 1 | 40 | 1 |
| 2 | 91741 | Nibbled-On Book | 2 | 85 est. | 2 |
| 3 | 92124 | Book Inventory | 2 | 85 est. | 2 |
| 4 | 7 | Kobold Camp Cleanup | 2 | 170 | 2 |
| 5 | 5261 | Eagan Peltskinner | 2 | 85 | 2 |
| 6 | 18 | Brotherhood of Thieves | 4 | 355 | 4 |
| 7 | 3903 | Milly Osworth | 4 | 35 | 4 |
| 8 | 91743 | Rascally Rodents | 2 | 170 est. | 4 |
| 9 | 15 | Investigate Echo Ridge | 3 | 250 | 4 |
| 10 | 33 | Wolves Across the Border | 2 | 170 | 5 |
| 11 | 91745 | Mining Consultant | 3 | 250 est. | 5 |
| 12 | 21 | Skirmish at Echo Ridge | 5 | 450 | 5 |
| 13 | 91752 | The Big Picture | 3 | 250 est. | 5 |
| 14 | 91758 | Follow That Kobold! | 4 | 180 est. | 5 |
| 15 | 3904 | Milly's Harvest | 4 | 180 | 5 |
| 16 | 3905 | Grape Manifest | 4 | 355 | 5 |
| 17 | 6 | Bounty on Garrick Padfoot | 5 | 335 | 5 |
| 18 | 96627 | The Adventurer | 6 | 135 est. | 6 |
| 19 | 2158 | Rest and Relaxation | 5 | 110 | 6 |
| 20 | 54 | Report to Goldshire | 5 | 225 | 6 |
| 21 | 91772 | Shhh! We're Hunting Kobolds | 4 | 355 est. | 6 |

## Dropped quests

| Quest | Name | Lvl | Reason |
|---|---|---|---|
| 345 | Ink Supplies | 24 | quest level 24 above the band |
| 346 | Return to Kristoff | 24 | quest level 24 above the band |
| 1598 | The Stolen Tome | 4 | class quest (ClassQuestData.lua) |
| 3100 | Simple Letter | 1 | class quest (ClassQuestData.lua) |
| 3101 | Consecrated Letter | 1 | class quest (ClassQuestData.lua) |
| 3102 | Encrypted Letter | 1 | class quest (ClassQuestData.lua) |
| 3103 | Hallowed Letter | 1 | class quest (ClassQuestData.lua) |
| 3104 | Glyphic Letter | 1 | class quest (ClassQuestData.lua) |
| 3105 | Tainted Letter | 1 | class quest (ClassQuestData.lua) |
| 5623 | In Favor of the Light | 4 | class quest (ClassQuestData.lua) |
| 92479 | A Scribbled Letter | 1 | class quest (ClassQuestData.lua) |

## Class quests

Class quests whose giver, objectives and turn-in are in the chapter region become `classes` steps next to the nearest route steps (the simulated route does not change); the others stay offered in game.

| Quest | Name | Lvl | Classes | Result |
|---|---|---|---|---|
| 3100 | Simple Letter | 1 | WARRIOR | woven, detour 19 s |
| 3101 | Consecrated Letter | 1 | PALADIN | woven, detour 20 s |
| 3102 | Encrypted Letter | 1 | ROGUE | woven, detour 15 s |
| 3103 | Hallowed Letter | 1 | PRIEST | woven, detour 16 s |
| 3104 | Glyphic Letter | 1 | MAGE | woven, detour 17 s |
| 3105 | Tainted Letter | 1 | WARLOCK | woven, detour 18 s |
| 92479 | A Scribbled Letter | 1 | HUNTER | woven, detour 10 s |
| 1598 | The Stolen Tome | 4 | WARLOCK | woven, detour 106 s |
| 5623 | In Favor of the Light | 4 | PRIEST | woven, detour 24 s |

## Candidate ratios

Value = quest XP at the simulated level + mob XP + strategic bonus. Ratio = chain value / isolated time;
marginal ratio uses the detour from places the route visits anyway. A quest is dropped when both ratios are
below 0.35 × the median ratio, or when an objective is more than 900 yd from every hub.

| Quest | Name | Lvl | Value | Bonus | Isolated s | Marginal s | Ratio | Marginal ratio | Sites | Dropped |
|---|---|---|---|---|---|---|---|---|---|---|
| 6 | Bounty on Garrick Padfoot | 5 | 395 | 0 | 144 | 74 | 2.73 | 5.33 | 1 |  |
| 7 | Kobold Camp Cleanup | 2 | 670 | 0 | 249 | 218 | 3.07 | 3.93 | 1 |  |
| 15 | Investigate Echo Ridge | 3 | 800 | 0 | 264 | 234 | 3.31 | 4.55 | 1 |  |
| 18 | Brotherhood of Thieves | 4 | 1510 | 0 | 511 | 496 | 2.67 | 3.11 | 1 |  |
| 21 | Skirmish at Echo Ridge | 5 | 1110 | 0 | 341 | 262 | 3.53 | 5.91 | 1 |  |
| 33 | Wolves Across the Border | 2 | 920 | 0 | 345 | 327 | 2.66 | 2.81 | 1 |  |
| 54 | Report to Goldshire | 5 | 459 | 234 | 99 | 14 | 4.63 | 32.72 | 0 |  |
| 783 | A Threat Within | 1 | 40 | 0 | 25 | 25 | 2.81 | 3.31 | 0 |  |
| 2158 | Rest and Relaxation | 5 | 272 | 162 | 98 | 34 | 2.76 | 7.82 | 0 |  |
| 3903 | Milly Osworth | 4 | 81 | 46 | 44 | 44 | 2.08 | 2.57 | 0 |  |
| 3904 | Milly's Harvest | 4 | 180 | 0 | 177 | 127 | 2.15 | 2.89 | 1 |  |
| 3905 | Grape Manifest | 4 | 355 | 0 | 30 | 30 | 11.57 | 11.57 | 0 |  |
| 5261 | Eagan Peltskinner | 2 | 111 | 26 | 31 | 31 | 2.77 | 2.89 | 0 |  |
| 91741 | Nibbled-On Book | 2 | 345 | 0 | 143 | 116 | 2.91 | 3.57 | 0 |  |
| 91743 | Rascally Rodents | 2 | 1002 | 0 | 376 | 343 | 3.11 | 3.84 | 1 |  |
| 91745 | Mining Consultant | 3 | 250 | 0 | 43 | 16 | 4.55 | 9.42 | 0 |  |
| 91752 | The Big Picture | 3 | 305 | 0 | 94 | 34 | 4.12 | 7.96 | 1 |  |
| 91758 | Follow That Kobold! | 4 | 180 | 0 | 33 | 33 | 5.10 | 7.36 | 0 |  |
| 91772 | Shhh! We're Hunting Kobolds | 4 | 609 | 254 | 121 | 69 | 5.00 | 8.74 | 1 |  |
| 92124 | Book Inventory | 2 | 85 | 0 | 16 | 16 | 3.20 | 3.91 | 0 |  |
| 96627 | The Adventurer | 6 | 335 | 200 | 86 | 14 | 3.88 | 23.91 | 0 |  |

## Itinerary

One line per task (A accept, O objective, T turn-in, C timed quest, F flight path). Leg = straight-line
yards from the previous task (blank after a flight, boat or zone change). Returns: the task is within
150 yd of an earlier task after the route went more than 600 yd away from it.

| # | Task | Quest | Name | Map | x, y | Leg yd | Return |
|---|---|---|---|---|---|---|---|
| 1 | A | 783 | A Threat Within | 1429 | 48.2, 42.9 | 40 |  |
| 2 | T | 783 | A Threat Within | 1429 | 48.9, 41.6 | 40 |  |
| 3 | A | 7 | Kobold Camp Cleanup | 1429 | 48.9, 41.6 | 0 |  |
| 4 | A | 5261 | Eagan Peltskinner | 1429 | 48.2, 42.9 | 40 |  |
| 5 | A | 91741 | Nibbled-On Book | 1429 | 48.5, 34.6 | 193 |  |
| 6 | O | 7 | Kobold Camp Cleanup | 1429 | 48.8, 36.2 | 38 |  |
| 7 | T | 91741 | Nibbled-On Book | 1429 | 49.6, 40.4 | 101 |  |
| 8 | A | 92124 | Book Inventory | 1429 | 49.6, 40.4 | 0 |  |
| 9 | T | 92124 | Book Inventory | 1429 | 49.5, 40.7 | 7 |  |
| 10 | A | 91743 | Rascally Rodents | 1429 | 49.6, 40.4 | 7 |  |
| 11 | T | 7 | Kobold Camp Cleanup | 1429 | 48.9, 41.6 | 36 |  |
| 12 | A | 15 | Investigate Echo Ridge | 1429 | 48.9, 41.6 | 0 |  |
| 13 | T | 5261 | Eagan Peltskinner | 1429 | 48.9, 40.2 | 33 |  |
| 14 | A | 33 | Wolves Across the Border | 1429 | 48.9, 40.2 | 0 |  |
| 15 | A | 18 | Brotherhood of Thieves | 1429 | 48.2, 42.9 | 69 |  |
| 16 | O | 18 | Brotherhood of Thieves | 1429 | 54.0, 47.7 | 229 |  |
| 17 | T | 18 | Brotherhood of Thieves | 1429 | 48.2, 42.9 | 229 |  |
| 18 | A | 6 | Bounty on Garrick Padfoot | 1429 | 48.2, 42.9 | 0 |  |
| 19 | A | 3903 | Milly Osworth | 1429 | 48.2, 42.9 | 0 |  |
| 20 | O | 15 | Investigate Echo Ridge | 1429 | 48.3, 34.0 | 206 |  |
| 21 | O | 91743 | Rascally Rodents | 1429 | 48.5, 34.6 | 14 |  |
| 22 | O | 33 | Wolves Across the Border | 1429 | 47.0, 37.2 | 79 |  |
| 23 | T | 3903 | Milly Osworth | 1429 | 50.7, 39.4 | 138 |  |
| 24 | A | 3904 | Milly's Harvest | 1429 | 50.7, 39.4 | 0 |  |
| 25 | T | 91743 | Rascally Rodents | 1429 | 49.6, 40.4 | 44 |  |
| 26 | A | 91745 | Mining Consultant | 1429 | 49.6, 40.4 | 0 |  |
| 27 | T | 15 | Investigate Echo Ridge | 1429 | 48.9, 41.6 | 36 |  |
| 28 | A | 21 | Skirmish at Echo Ridge | 1429 | 48.9, 41.6 | 0 |  |
| 29 | T | 33 | Wolves Across the Border | 1429 | 48.9, 40.2 | 33 |  |
| 30 | T | 91745 | Mining Consultant | 1429 | 47.2, 32.2 | 194 |  |
| 31 | A | 91752 | The Big Picture | 1429 | 47.2, 32.2 | 0 |  |
| 32 | O | 21 | Skirmish at Echo Ridge | 1429 | 48.9, 28.3 | 105 |  |
| 33 | O | 91752 | The Big Picture | 1429 | 49.2, 28.0 | 14 |  |
| 34 | T | 21 | Skirmish at Echo Ridge | 1429 | 48.9, 41.6 | 314 |  |
| 35 | A | 54 | Report to Goldshire | 1429 | 48.9, 41.6 | 0 |  |
| 36 | T | 91752 | The Big Picture | 1429 | 48.9, 41.6 | 0 |  |
| 37 | A | 91758 | Follow That Kobold! | 1429 | 48.9, 41.6 | 0 |  |
| 38 | A | 96627 | The Adventurer | 1429 | 48.9, 41.6 | 0 |  |
| 39 | O | 3904 | Milly's Harvest | 1429 | 54.0, 48.6 | 239 |  |
| 40 | O | 6 | Bounty on Garrick Padfoot | 1429 | 57.5, 48.2 | 123 |  |
| 41 | T | 91758 | Follow That Kobold! | 1429 | 51.2, 40.8 | 278 |  |
| 42 | A | 91772 | Shhh! We're Hunting Kobolds | 1429 | 51.2, 40.8 | 0 |  |
| 43 | T | 3904 | Milly's Harvest | 1429 | 50.7, 39.4 | 38 |  |
| 44 | A | 3905 | Grape Manifest | 1429 | 50.7, 39.4 | 0 |  |
| 45 | T | 3905 | Grape Manifest | 1429 | 49.5, 41.6 | 66 |  |
| 46 | T | 6 | Bounty on Garrick Padfoot | 1429 | 48.2, 42.9 | 54 |  |
| 47 | O | 91772 | Shhh! We're Hunting Kobolds | 1429 | 47.7, 45.9 | 69 |  |
| 48 | A | 2158 | Rest and Relaxation | 1429 | 45.6, 47.7 | 86 |  |
| 49 | T | 96627 | The Adventurer | 1429 | 44.9, 63.4 | 362 |  |
| 50 | T | 2158 | Rest and Relaxation | 1429 | 43.8, 65.8 | 68 |  |
| 51 | T | 54 | Report to Goldshire | 1429 | 42.1, 65.9 | 57 |  |
| 52 | T | 91772 | Shhh! We're Hunting Kobolds | 1429 | 42.1, 65.9 | 0 |  |

Walking between tasks: 3697 yd (~9 min at 7 yd/s).

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

None.

## Warnings

None.
