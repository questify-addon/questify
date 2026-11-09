# A_DwarfGnome_01 — Coldridge Valley

Generated on 2026-11-09 from QuestieDB commit `4d31c10394b11bd133069ecf1662062cdf4d8691` by `tools/routebuilder/build.lua`. Simulated race: Dwarf.

| Item | Value |
|---|---|
| Level band | 1-6 |
| Simulated level | 1.00 -> 6.02 |
| Time | 36 min |
| XP gained | 7660 |
| XP/h | 12667 |
| Steps | 74 |
| Quests turned in | 15 |
| Hubs | 5 |
| Median ratio (XP/s) | 4.30 |
| Grinding (level steps) | ~10 mobs |
| Hearthstone | no new bind; 0 return(s) planned, 0 bundle(s) |

## Kept quests (turn-in order)

XP marked `est.` is an estimate (no QuestXP value: new Forever quest).

| # | Quest | Name | Lvl | XP | Sim lvl |
|---|---|---|---|---|---|
| 1 | 183 | The Boar Hunter | 3 | 250 | 3 |
| 2 | 182 | The Troll Cave | 4 | 355 | 4 |
| 3 | 3364 | Scalding Mornbrew Delivery | 5 | 225 | 4 |
| 4 | 179 | Dwarven Outfitters | 1 | 80 | 4 |
| 5 | 233 | Coldridge Valley Mail Delivery | 3 | 190 | 4 |
| 6 | 3365 | Bring Back the Mug | 5 | 450 | 4 |
| 7 | 218 | The Stolen Journal | 5 | 560 | 4 |
| 8 | 234 | Coldridge Valley Mail Delivery | 4 | 270 | 5 |
| 9 | 97277 | Grund and Gozwin | 6 | 540 est. | 5 |
| 10 | 3361 | A Refugee's Quandary | 3 | 250 | 5 |
| 11 | 170 | A New Threat | 2 | 170 | 5 |
| 12 | 282 | Senir's Observations | 5 | 335 | 5 |
| 13 | 96628 | The Adventurer | 6 | 135 est. | 5 |
| 14 | 420 | Senir's Observations | 5 | 335 | 5 |
| 15 | 2160 | Supplies to Tannok | 5 | 110 | 5 |

## Dropped quests

| Quest | Name | Lvl | Reason |
|---|---|---|---|
| 1599 | Beginnings | 4 | class quest (ClassQuestData.lua) |
| 3106 | Simple Rune | 1 | class quest (ClassQuestData.lua) |
| 3107 | Consecrated Rune | 1 | class quest (ClassQuestData.lua) |
| 3108 | Etched Rune | 1 | class quest (ClassQuestData.lua) |
| 3109 | Encrypted Rune | 1 | class quest (ClassQuestData.lua) |
| 3110 | Hallowed Rune | 1 | class quest (ClassQuestData.lua) |
| 3112 | Simple Memorandum | 1 | class quest (ClassQuestData.lua) |
| 3113 | Encrypted Memorandum | 1 | class quest (ClassQuestData.lua) |
| 3114 | Glyphic Memorandum | 1 | class quest (ClassQuestData.lua) |
| 3115 | Tainted Memorandum | 1 | class quest (ClassQuestData.lua) |
| 5626 | In Favor of the Light | 4 | class quest (ClassQuestData.lua) |
| 94373 | Call of Earth | 4 | class quest (ClassQuestData.lua) |
| 94374 | Call of Earth | 4 | class quest (ClassQuestData.lua) |
| 94375 | Call of Earth | 4 | class quest (ClassQuestData.lua) |
| 94449 | Call of Fire | 10 | class quest (ClassQuestData.lua) |
| 94472 | Earth Sapta | 4 | class quest (ClassQuestData.lua) |
| 98574 | Hallowed Memorandum | 1 | class quest (ClassQuestData.lua) |
| 98581 | Archaic Rune | 1 | class quest (ClassQuestData.lua) |

## Class quests

Class quests whose giver, objectives and turn-in are in the chapter region become `classes` steps next to the nearest route steps (the simulated route does not change); the others stay offered in game.

| Quest | Name | Lvl | Classes | Result |
|---|---|---|---|---|
| 3106 | Simple Rune | 1 | WARRIOR | woven, detour 13 s |
| 3107 | Consecrated Rune | 1 | PALADIN | woven, detour 18 s |
| 3108 | Etched Rune | 1 | HUNTER | woven, detour 17 s |
| 3109 | Encrypted Rune | 1 | ROGUE | woven, detour 13 s |
| 3110 | Hallowed Rune | 1 | PRIEST | woven, detour 21 s |
| 3112 | Simple Memorandum | 1 | WARRIOR | woven, detour 13 s |
| 3113 | Encrypted Memorandum | 1 | ROGUE | woven, detour 13 s |
| 3114 | Glyphic Memorandum | 1 | MAGE | woven, detour 21 s |
| 3115 | Tainted Memorandum | 1 | WARLOCK | woven, detour 23 s |
| 98574 | Hallowed Memorandum | 1 | PRIEST | woven, detour 21 s |
| 98581 | Archaic Rune | 1 | SHAMAN | woven, detour 23 s |
| 1599 | Beginnings | 4 | WARLOCK | woven, detour 182 s |
| 5626 | In Favor of the Light | 4 | PRIEST | woven, detour 14 s |
| 94373 | Call of Earth | 4 | SHAMAN | woven, detour 126 s |
| 94374 | Call of Earth | 4 | SHAMAN | woven, detour 98 s |
| 94375 | Call of Earth | 4 | SHAMAN | woven, detour 38 s |
| 94449 | Call of Fire | 10 | SHAMAN | quest level 10 above the band |
| 94472 | Earth Sapta | 4 | SHAMAN | repeatable |

## Candidate ratios

Value = quest XP at the simulated level + mob XP + strategic bonus. Ratio = chain value / isolated time;
marginal ratio uses the detour from places the route visits anyway. A quest is dropped when both ratios are
below 0.35 × the median ratio, or when an objective is more than 900 yd from every hub.

| Quest | Name | Lvl | Value | Bonus | Isolated s | Marginal s | Ratio | Marginal ratio | Sites | Dropped |
|---|---|---|---|---|---|---|---|---|---|---|
| 170 | A New Threat | 2 | 782 | 0 | 298 | 285 | 2.62 | 2.74 | 1 |  |
| 179 | Dwarven Outfitters | 1 | 730 | 0 | 305 | 305 | 2.68 | 2.97 | 1 |  |
| 182 | The Troll Cave | 4 | 1125 | 0 | 358 | 315 | 3.78 | 6.11 | 1 |  |
| 183 | The Boar Hunter | 3 | 910 | 0 | 266 | 266 | 3.42 | 3.42 | 1 |  |
| 218 | The Stolen Journal | 5 | 620 | 0 | 117 | 33 | 4.87 | 27.27 | 1 |  |
| 233 | Coldridge Valley Mail Delivery | 3 | 190 | 0 | 62 | 11 | 4.30 | 20.23 | 0 |  |
| 234 | Coldridge Valley Mail Delivery | 4 | 270 | 0 | 36 | 10 | 7.31 | 25.27 | 0 |  |
| 282 | Senir's Observations | 5 | 335 | 0 | 72 | 12 | 4.61 | 42.62 | 0 |  |
| 420 | Senir's Observations | 5 | 730 | 395 | 136 | 11 | 5.35 | 62.92 | 0 |  |
| 2160 | Supplies to Tannok | 5 | 527 | 417 | 145 | 14 | 3.63 | 35.63 | 0 |  |
| 3361 | A Refugee's Quandary | 3 | 250 | 0 | 204 | 124 | 1.22 | 2.01 | 3 |  |
| 3364 | Scalding Mornbrew Delivery | 5 | 225 | 0 | 67 | 19 | 4.73 | 16.07 | 0 |  |
| 3365 | Bring Back the Mug | 5 | 450 | 0 | 67 | 19 | 6.70 | 22.77 | 0 |  |
| 96628 | The Adventurer | 6 | 528 | 393 | 136 | 11 | 3.88 | 45.53 | 0 |  |
| 97277 | Grund and Gozwin | 6 | 602 | 0 | 87 | 87 | 6.85 | 6.85 | 1 |  |

## Itinerary

One line per task (A accept, O objective, T turn-in, C timed quest, F flight path). Leg = straight-line
yards from the previous task (blank after a flight, boat or zone change). Returns: the task is within
150 yd of an earlier task after the route went more than 600 yd away from it.

| # | Task | Quest | Name | Map | x, y | Leg yd | Return |
|---|---|---|---|---|---|---|---|
| 1 | A | 179 | Dwarven Outfitters | 1426 | 29.9, 71.2 | 0 |  |
| 2 | O | 179 | Dwarven Outfitters | 1426 | 28.9, 74.5 | 119 |  |
| 3 | A | 183 | The Boar Hunter | 1426 | 22.6, 71.4 | 324 |  |
| 4 | O | 183 | The Boar Hunter | 1426 | 21.5, 71.1 | 56 |  |
| 5 | T | 183 | The Boar Hunter | 1426 | 22.6, 71.4 | 56 |  |
| 6 | A | 182 | The Troll Cave | 1426 | 25.1, 75.7 | 186 |  |
| 7 | O | 182 | The Troll Cave | 1426 | 28.8, 80.3 | 236 |  |
| 8 | T | 182 | The Troll Cave | 1426 | 25.1, 75.7 | 236 |  |
| 9 | A | 218 | The Stolen Journal | 1426 | 25.1, 75.7 | 0 |  |
| 10 | C | 3364 | Scalding Mornbrew Delivery | 1426 | 25.0, 76.0 | 9 |  |
| 11 | A | 3365 | Bring Back the Mug | 1426 | 28.8, 66.4 | 0 |  |
| 12 | A | 97277 | Grund and Gozwin | 1426 | 28.7, 67.5 | 38 |  |
| 13 | A | 3361 | A Refugee's Quandary | 1426 | 28.6, 67.6 | 7 |  |
| 14 | T | 179 | Dwarven Outfitters | 1426 | 29.9, 71.2 | 135 |  |
| 15 | A | 233 | Coldridge Valley Mail Delivery | 1426 | 29.9, 71.2 | 0 |  |
| 16 | A | 170 | A New Threat | 1426 | 29.7, 71.2 | 10 |  |
| 17 | O | 170 | A New Threat | 1426 | 31.0, 75.7 | 161 |  |
| 18 | O | 218 | The Stolen Journal | 1426 | 30.5, 80.2 | 147 |  |
| 19 | O | 3361 | A Refugee's Quandary | 1426 | 26.3, 79.3 | 206 |  |
| 20 | O | 3361 | A Refugee's Quandary | 1426 | 22.8, 80.0 | 176 |  |
| 21 | O | 3361 | A Refugee's Quandary | 1426 | 20.9, 76.1 | 159 |  |
| 22 | T | 233 | Coldridge Valley Mail Delivery | 1426 | 22.6, 71.4 | 174 |  |
| 23 | A | 234 | Coldridge Valley Mail Delivery | 1426 | 22.6, 71.4 | 0 |  |
| 24 | T | 3365 | Bring Back the Mug | 1426 | 25.0, 76.0 | 189 |  |
| 25 | T | 218 | The Stolen Journal | 1426 | 25.1, 75.7 | 9 |  |
| 26 | T | 234 | Coldridge Valley Mail Delivery | 1426 | 25.1, 75.7 | 0 |  |
| 27 | A | 282 | Senir's Observations | 1426 | 25.1, 75.7 | 0 |  |
| 28 | O | 97277 | Grund and Gozwin | 1426 | 27.3, 62.9 | 435 | near #11 (went 604 yd away) |
| 29 | T | 97277 | Grund and Gozwin | 1426 | 28.7, 67.5 | 167 |  |
| 30 | T | 3361 | A Refugee's Quandary | 1426 | 28.6, 67.6 | 7 |  |
| 31 | T | 170 | A New Threat | 1426 | 29.7, 71.2 | 131 |  |
| 32 | T | 282 | Senir's Observations | 1426 | 33.5, 71.8 | 186 |  |
| 33 | A | 420 | Senir's Observations | 1426 | 33.5, 71.8 | 0 |  |
| 34 | A | 96628 | The Adventurer | 1426 | 33.5, 71.8 | 0 |  |
| 35 | A | 2160 | Supplies to Tannok | 1426 | 33.9, 72.2 | 22 |  |
| 36 | T | 96628 | The Adventurer | 1426 | 46.6, 53.9 | 872 |  |
| 37 | T | 420 | Senir's Observations | 1426 | 46.7, 53.8 | 4 |  |
| 38 | T | 2160 | Supplies to Tannok | 1426 | 47.2, 52.2 | 59 |  |

Walking between tasks: 4527 yd (~11 min at 7 yd/s).

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

- step 74: `level 6` — About 10 more mobs here (Wendigo, level 6)

## Warnings

None.
