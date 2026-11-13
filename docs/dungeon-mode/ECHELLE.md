# Mode « Donjons » Alliance : échelle 1-60

Généré par `tools/routebuilder/build_dungeon_route.lua` le 2026-11-13 à partir de
`tools/routebuilder/dungeon_ladder.lua` et de `Questify/Guides/DungeonData.lua` (QuestieDB commit `c7ccd23e17a222e083c4215144ef9db301db27ce`).
Ne pas modifier à la main. Méthode et limites : [README.md](README.md).

## Départs par race (1-15)

| Races | Zones (niveaux) | Remarque |
|---|---|---|
| Human | Northshire Valley (1-6) ; Elwynn Forest (6-11) ; Westfall (11-15) : première moitié ; la suite après The Hall of Thanes |  |
| Dwarf, Gnome | Coldridge Valley (1-6) ; Dun Morogh (6-11) : avec la suite d'accès de The Hall of Thanes (96391, 96392) ; Loch Modan (11-15) | The Hall of Thanes se fait à Ironforge avant de prendre le tram pour Stormwind |
| NightElf | Shadowglen (1-6) ; Teldrassil (6-11) ; Darkshore (11-15) : première moitié ; bateau d'Auberdine à Stormwind |  |

Les trois départs se rejoignent à Stormwind au niveau 15 (tram d'Ironforge, bateau d'Auberdine).

## Échelle

Niveau d'entrée = bas de la plage + 2, plafonné à 58, sauf mention. « Accès » : zone traversée pour les suites
et les quêtes du donjon ; les autres zones sont vidées (suites d'abord, puis quêtes à accès direct).
XP de quêtes : XP de base de QuestieDB, « ~ » quand une valeur est estimée ; % = part du niveau d'entrée.

| # | Entrée | Échelon | Plage | Quêtes | XP de quêtes | % niveau | Étoiles | Zones avant l'échelon | Alternative en extérieur |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 15 | The Hall of Thanes | 13-18 | 3 | ~1625 | 11 % | ★ | Ironforge (15, accès) | Loch Modan (14-17) |
| 2 | 19 | The Deadmines | 17-26 | 9 | ~5635 | 26 % | ★★ | Stormwind City (15-16, accès) ; Westfall (15-19) | Redridge Mountains (17-20) |
| 3 | 19 | Wailing Caverns | 17-24 | 5 | 4500 | 21 % | ★★ | Darkshore (19-21) ; The Barrens (19-21, accès) | Redridge Mountains (19-22) |
| 4 | 26 | The Stockade | 24-32 | 7 | 7985 | 22 % | ★★ | Redridge Mountains (21-24) ; Duskwood (24-26) ; Stormwind City (26, accès) | Duskwood (26-28) |
| 5 | 26 | Blackfathom Deeps | 24-32 | 5 | 5875 | 16 % | ★★ | Ashenvale (24-27) | Stonetalon Mountains (24-27) |
| 6 | 26 | Excavation Site: Wetlands | 24-29 | 7 | ~4950 | 14 % | ★★ | Wetlands (24-28) | Wetlands (26-29) |
| 7 | 27 | Shadowfang Keep | 22-30 | 0 | 0 | 0 % | — | Hillsbrad Foothills (26-28) | Hillsbrad Foothills (27-29) |
| 8 | 30 | City of Dalaran | 28-33 | 4 | ~5300 | 11 % | ★ | Duskwood (27-30) ; Alterac Mountains (30, accès) | Hillsbrad Foothills (29-32) |
| 9 | 30 | Scarlet Monastery : Graveyard | 28-38 | 0 | 0 | 0 % | — | Hillsbrad Foothills (29-31) | Thousand Needles (29-32) |
| 10 | 31 | Gnomeregan | 29-38 | 13 | 12625 | 25 % | ★★ | Ironforge (30-31, accès) | Thousand Needles (30-33) |
| 11 | 31 | Scarlet Monastery : Library | 29-39 | 2 | ~3200 | 6 % | ★ | Ironforge (31, accès) | Arathi Highlands (31-34) |
| 12 | 31 | Razorfen Kraul | 29-38 | 3 | 4250 | 8 % | ★ | Thousand Needles (29-32) | Stranglethorn Vale (31-34) |
| 13 | 34 | Scarlet Monastery : Armory | 32-42 | 0 | 0 | 0 % | — | Arathi Highlands (32-35) | Desolace (33-36) |
| 14 | 37 | Scarlet Monastery : Cathedral | 35-45 | 2 | 3900 | 5 % | ★ | Desolace (34-37, accès) ; Stranglethorn Vale (35-37) | Alterac Mountains (36-39) |
| 15 | 38 | Uldaman | 36-47 | 16 | 26295 | 33 % | ★★★ | Badlands (37-39, accès) ; Loch Modan (38, accès) | Riverglades (38-41) |
| 16 | 39 | Razorfen Downs | 37-46 | 3 | ~5525 | 6 % | ★ | Dustwallow Marsh (36-39) | Shen'dralas (38-42) |
| 17 | 44 | Maraudon | 42-52 | 7 | 17500 | 16 % | ★★ | Riverglades (39-43) ; Desolace (42-44, accès) | Swamp of Sorrows (40-44) |
| 18 | 46 | Zul'Farrak | 44-54 | 11 | ~23895 | 19 % | ★★ | Feralas (43-46) ; Tanaris (45-46, accès) | The Hinterlands (44-48) |
| 19 | 52 | The Temple of Atal'Hakkar | 50-60 | 6 | 18975 | 12 % | ★ | The Hinterlands (46-49, accès) ; Searing Gorge (48-50) ; Tanaris (49-52) | Azshara (49-53) |
| 20 | 54 | Blackrock Depths | 52-60 | 17 | 44860 | 26 % | ★★ | Un'Goro Crater (52-54) ; Burning Steppes (53-54, accès) | Felwood (53-56) |
| 21 | 57 | Dire Maul : East | 55-60 | 3 | 8400 | 4 % | ★ | Felwood (54-56) ; Feralas (56-57, accès) | Western Plaguelands (55-58) |
| 22 | 57 | Scholomance | 55-60 | 10 | 37825 | 19 % | ★★ | Western Plaguelands (55-57) | Winterspring (56-59) |
| 23 | 58 | Dire Maul : West | 56-60 | 1 | 4150 | 2 % | ★ | Feralas (58, accès) | Winterspring (57-60) |
| 24 | 58 | Dire Maul : North | 56-60 | 1 | 3300 | 2 % | ★ | Feralas (58, accès) | Mount Hyjal (57-60) |
| 25 | 58 | Stratholme : Live | 58-60 | 8 | 36000 | 18 % | ★★ | Eastern Plaguelands (57-59) | Silithus (58-60) |
| 26 | 58 | Stratholme : Undead | 58-60 | 7 | 29750 | 15 % | ★★ | Eastern Plaguelands (58-60, accès) | Silithus (58-60) |

## Quêtes par échelon

### The Hall of Thanes (`THANES`, entrée 15)

- 96393 Old Ironforge Incursion : ~575 XP
- 96394 The Restless Dead : ~525 XP
- 96403 Important Heirlooms : ~525 XP

- à vérifier en jeu : plage 13-18 annoncée par Blizzard
- à vérifier en jeu : accès de 96393 par la suite de Dun Morogh pour les Humains et les Elfes de la nuit

### The Deadmines (`DM`, entrée 19)

- 166 The Defias Brotherhood : 1300 XP
- 167 Oh Brother. . . : 775 XP
- 168 Collecting Memories : 675 XP
- 214 Red Silk Bandanas : 625 XP
- 2040 Underground Assault : 775 XP
- 92750 Detonation at a Distance : 115 XP
- 92751 Detonation at a Distance : 115 XP
- 92752 Explosive Consultation : 580 XP
- 92753 Destruction in Deadmines : ~675 XP

### Wailing Caverns (`WC`, entrée 19)

- 959 Trouble at the Docks : 675 XP
- 1486 Deviate Hides : 800 XP
- 1487 Deviate Eradication : 1025 XP
- 1491 Smart Drinks : 675 XP
- 6981 The Glowing Shard : 1325 XP

- à vérifier en jeu : accès Alliance par Ashenvale puis les Tarides à pied (zone Horde)
- à vérifier en jeu : les 4 quêtes de ville se prennent à Ratchet et à l'entrée de la caverne

### The Stockade (`STOCKADE`, entrée 26)

- 377 Crime and Punishment : 1050 XP
- 378 The Fury Runs Deep : 1375 XP
- 386 What Comes Around... : 1000 XP
- 387 Quell The Uprising : 1325 XP
- 388 The Color of Blood : 1325 XP
- 389 Bazil Thredd : 435 XP
- 391 The Stockade Riots : 1475 XP

- à vérifier en jeu : The Fury Runs Deep (378) : suite des Paluns (303), prise au passage de l'échelon Excavation

### Blackfathom Deeps (`BFD`, entrée 26)

- 971 Knowledge in the Deeps : 1375 XP
- 1198 In Search of Thaelrid : 1200 XP
- 1199 Twilight Falls : 1275 XP
- 1200 Blackfathom Villainy : 825 XP
- 1275 Researching the Corruption : 1200 XP

### Excavation Site: Wetlands (`EXCAVATION`, entrée 26)

- 95646 Horrors in the Highland : ~1250 XP
- 95647 Lost in the Thicket Things : ~625 XP
- 95737 Seeking Caitlin : 625 XP
- 95772 Songblade Search : ~625 XP
- 95810 Lost Relic Carry : 625 XP
- 98815 Highland Hides : 575 XP
- 98824 Prehistoric Prism : ~625 XP

- à vérifier en jeu : plage 24-29 annoncée, quêtes de niveau 28-31 : niveau d'entrée à confirmer

### Shadowfang Keep (`SFK`, entrée 27)

Niveau d'entrée imposé : aucune quête Alliance ; joué au passage de Southshore plutôt qu'à 24 par un aller-retour.

Aucune quête Alliance.

- à vérifier en jeu : long trajet de Southshore à la forêt des Pins-Argentés
- à vérifier en jeu : aucune quête Alliance dans QuestieDB

### City of Dalaran (`DALARAN`, entrée 30)

- 92456 A Green Sample : ~1325 XP
- 92457 Starving Arcane : ~1325 XP
- 92458 Heart of Disruption : ~1325 XP
- 92489 Power Overwhelming : ~1325 XP

- à vérifier en jeu : plage 28-33 annoncée, quêtes de niveau 33

### Scarlet Monastery : Graveyard (`SM_GY`, entrée 30)

Aucune quête Alliance.

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : aucune quête Alliance ne vise le Cimetière

### Gnomeregan (`GNOMER`, entrée 31)

- 2904 A Fine Mess : 1225 XP
- 2922 Save Techbot's Brain! : 1325 XP
- 2923 Tinkmaster Overspark : 105 XP
- 2924 Essential Artificials : 1525 XP
- 2925 Klockmort's Essentials : 120 XP
- 2926 Gnogaine : 1100 XP
- 2927 The Day After : 110 XP
- 2928 Gyrodrillmatic Excavationators : 1225 XP
- 2929 The Grand Betrayal : 1375 XP
- 2930 Data Rescue : 1825 XP
- 2931 Castpipe's Task : 115 XP
- 2947 Return of the Ring : 1350 XP
- 2962 The Only Cure is More Green Glow : 1225 XP

### Scarlet Monastery : Library (`SM_LIB`, entrée 31)

- 1050 Mythology of the Titans : 1775 XP
- 96800 Past Due : ~1425 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Past Due (96800) : livre « The Lost Magic of the Runemasters », aile à confirmer

### Razorfen Kraul (`RFK`, entrée 31)

- 1101 The Crone of the Kraul : 1675 XP
- 1142 Mortality Wanes : 1525 XP
- 1221 Blueleaf Tubers : 1050 XP

- à vérifier en jeu : The Crone of the Kraul (1101) : niveau requis 29, suite 1100

### Scarlet Monastery : Armory (`SM_ARM`, entrée 34)

Aucune quête Alliance.

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Herod (In the Name of the Light, 1053) est compté avec la Cathédrale

### Scarlet Monastery : Cathedral (`SM_CATH`, entrée 37)

- 1052 Down the Scarlet Path : 1550 XP
- 1053 In the Name of the Light : 2350 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : In the Name of the Light (1053) : Loksey (Bibliothèque), Herod (Armurerie), Mograine et Whitemane (Cathédrale) ; rendue après la Cathédrale

### Uldaman (`ULDAMAN`, entrée 38)

- 17 Uldaman Reagent Run : 1725 XP
- 704 Agmond's Fate : 1425 XP
- 709 Solution to Doom : 1575 XP
- 721 A Sign of Hope : 1375 XP
- 722 Amulet of Secrets : 1575 XP
- 1139 The Lost Tablets of Will : 2925 XP
- 1360 Reclaimed Treasures : 1800 XP
- 2198 The Shattered Necklace : 1650 XP
- 2199 Lore for a Price : 1225 XP
- 2200 Back to Uldaman : 1275 XP
- 2204 Restoring the Necklace : 465 XP
- 2240 The Hidden Chamber : 1950 XP
- 2279 The Platinum Discs : 2625 XP
- 2361 Restoring the Necklace : 2800 XP
- 2398 The Lost Dwarves : 155 XP
- 2418 Power Stones : 1750 XP

### Razorfen Downs (`RFD`, entrée 39)

- 3636 Bring the Light : 2150 XP
- 6626 A Host of Evil : 1725 XP
- 96773 The Coldbringer's Eye : ~1650 XP

### Maraudon (`MARAUDON`, entrée 44)

- 7028 Twisted Evils : 2625 XP
- 7041 Vyletongue Corruption : 2625 XP
- 7044 Legends of Maraudon : 1700 XP
- 7065 Corruption of Earth and Seed : 3050 XP
- 7066 Seed of Life : 3050 XP
- 7067 The Pariah's Instructions : 2725 XP
- 7070 Shadowshard Fragments : 1725 XP

- à vérifier en jeu : Maraudon en un seul échelon (une seule zone 2100 dans QuestieDB) : parties orange, violette et intérieure à distinguer en jeu si besoin

### Zul'Farrak (`ZF`, entrée 46)

- 2768 Divino-matic Rod : 3150 XP
- 2770 Gahz'rilla : 3550 XP
- 2846 Tiara of the Deep : 3025 XP
- 2861 Tabetha's Task : 200 XP
- 2864 Tran'rek : 195 XP
- 2865 Scarab Shells : 1950 XP
- 2990 Thadius Grimshade : 2100 XP
- 2991 Nekrum's Medallion : 2625 XP
- 3042 Troll Temper : 1950 XP
- 3527 The Prophecy of Mosh'aru : 2625 XP
- 96770 The Witch Doctor's Head : ~2525 XP

### The Temple of Atal'Hakkar (`ST`, entrée 52)

- 1446 Jammal'an the Prophet : 3275 XP
- 1469 Rhapsody's Tale : 2700 XP
- 1475 Into The Temple of Atal'Hakkar : 3550 XP
- 3446 Into the Depths : 2450 XP
- 3447 Secret of the Circle : 3050 XP
- 3528 The God Hakkar : 3950 XP
- hors route : 8733 Eranikus, Tyrant of the Dream (niveau requis 60)

### Blackrock Depths (`BRD`, entrée 54)

- 3801 Dark Iron Legacy : 255 XP
- 3802 Dark Iron Legacy : 2550 XP
- 4024 A Taste of Flame : 3100 XP
- 4123 The Heart of the Mountain : 2825 XP
- 4126 Hurley Blackbreath : 2825 XP
- 4128 Ragnar Thunderbrew : 280 XP
- 4136 Ribbly Screwspigot : 1325 XP
- 4241 Marshal Windsor : 2725 XP
- 4242 Abandoned Hope : 2725 XP
- 4263 Incendius! : 2900 XP
- 4286 The Good Stuff : 2900 XP
- 4322 Jail Break! : 3875 XP
- 4324 Yuka Screwspigot : 1325 XP
- 4341 Kharan Mighthammer : 3200 XP
- 4361 The Bearer of Bad News : 3200 XP
- 4362 The Fate of the Kingdom : 4025 XP
- 4363 The Princess's Surprise : 4825 XP
- hors route : 9015 The Challenge (niveau requis 58, suite de l'ensemble de donjon)

### Dire Maul : East (`DM_EAST`, entrée 57)

- 7441 Pusillin and the Elder Azj'Tordin : 3875 XP
- 7488 Lethtendris's Web : 3775 XP
- 7494 Feathermoon Stronghold : 750 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Pusillin et Lethtendris : aile Est

### Scholomance (`SCHOLO`, entrée 57)

- 4771 Dawn's Gambit : 4975 XP
- 5343 Barov Family Fortune : 3300 XP
- 5382 Doctor Theolen Krastinov, the Butcher : 3300 XP
- 5384 Kirtonos the Herald : 4150 XP
- 5465 Soulbound Keepsake : 4950 XP
- 5466 The Lich, Ras Frostwhisper : 4975 XP
- 5515 Krastinov's Bag of Horrors : 3300 XP
- 5522 Leonid Barthalomew : 4950 XP
- 5529 Plagued Hatchlings : 3100 XP
- 5531 Betina Bigglezink : 825 XP

### Dire Maul : West (`DM_WEST`, entrée 58)

- 7482 Elven Legends : 4150 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Elven Legends (7482, restes de Telmius Dreamseeker) : aile Ouest

### Dire Maul : North (`DM_NORTH`, entrée 58)

- 8948 Anthion's Old Friend : 3300 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Anthion's Old Friend (8948, bibliothèque de Hache-Tripes) : niveau requis 58, suite 8947 ; aile à confirmer

### Stratholme : Live (`STRAT_LIVE`, entrée 58)

- 5214 The Great Ezra Grimm : 4150 XP
- 5243 Houses of the Holy : 3300 XP
- 5251 The Archivist : 4150 XP
- 5262 The Truth Comes Crashing Down : 4150 XP
- 5281 The Restless Souls : 6600 XP
- 5282 The Restless Souls : 4150 XP
- 5846 Of Love and Family : 6200 XP
- 5848 Of Love and Family : 3300 XP

- à vérifier en jeu : répartition des quêtes entre les deux côtés de Stratholme

### Stratholme : Undead (`STRAT_UD`, entrée 58)

- 5212 The Flesh Does Not Lie : 3300 XP
- 5213 The Active Agent : 3300 XP
- 5263 Above and Beyond : 4150 XP
- 5462 The Dying, Ras Frostwhisper : 4950 XP
- 5463 Menethil's Gift : 3300 XP
- 8929 In Search of Anthion : 6600 XP
- 8945 Dead Man's Plea : 4150 XP

- à vérifier en jeu : répartition des quêtes entre les deux côtés de Stratholme
- à vérifier en jeu : Dead Man's Plea (8945) : niveau requis 58, suite 8929 à huit préquêtes, facultative

## Contenu écarté

- Ragefire Chasm : entrée à Orgrimmar, aucune quête Alliance dans QuestieDB : Horde seulement.
- Ruins of Lordaeron : entrée à Undercity, aucune quête Alliance dans QuestieDB : Horde seulement.
- Lower Blackrock Spire : hors route à la demande ; QuestieDB ne sépare pas le bas du haut du Pic (zone 1583).
- Upper Blackrock Spire : raid de 10, pas un donjon 5 joueurs.
- Raids (Molten Core, Onyxia, Zul'Gurub, Ahn'Qiraj, Naxxramas) : pas des donjons 5 joueurs.
