# Mode « Donjons » Horde : échelle 1-60

Généré par `tools/routebuilder/build_dungeon_route.lua` le 2026-11-17 à partir de
`tools/routebuilder/dungeon_ladder.lua` et de `Questify/Guides/DungeonData.lua` (QuestieDB commit `c7ccd23e17a222e083c4215144ef9db301db27ce`).
Ne pas modifier à la main. Méthode et limites : [README.md](README.md).

## Départs par race (1-12)

| Races | Zones (niveaux) | Remarque |
|---|---|---|
| Orc, Troll | Valley of Trials (1-6) ; Durotar (6-12) |  |
| Tauren | Camp Narache (1-6) ; Mulgore (6-12) |  |
| Undead | Deathknell (1-6) ; Tirisfal Glades (6-12) ; Silverpine Forest (12-14) : puis le zeppelin de Fossoyeuse à Orgrimmar |  |
| Skyborne | Zephras Isle (1-15) |  |

Les départs se rejoignent aux Tarides au niveau 12 (zeppelin de Fossoyeuse à Orgrimmar pour les Morts-vivants).

## Échelle

Niveau d'entrée = bas de la plage + 2, plafonné à 58, sauf mention. « Accès » : zone traversée pour les suites
et les quêtes du donjon ; les autres zones sont vidées (suites d'abord, puis quêtes à accès direct).
XP de quêtes : XP de base de QuestieDB, « ~ » quand une valeur est estimée ; % = part du niveau d'entrée.

| # | Entrée | Échelon | Plage | Quêtes | XP de quêtes | % niveau | Étoiles | Zones avant l'échelon | Alternative en extérieur |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 15 | Ragefire Chasm | 13-18 | 6 | 3440 | 24 % | ★★ | The Barrens (12-15) ; Orgrimmar (15, accès) | The Barrens (15-17) |
| 2 | 19 | Wailing Caverns | 17-24 | 9 | 6475 | 30 % | ★★★ | The Barrens (15-19) | Stonetalon Mountains (19-21) |
| 3 | 20 | Ruins of Lordaeron | 15-22 | 10 | ~8365 | 36 % | ★★★ | Undercity (20, accès) | Thousand Needles (20-27) |
| 4 | 26 | Blackfathom Deeps | 24-32 | 7 | 6790 | 19 % | ★★ | Ashenvale (21-26) | Thousand Needles (25-27) |
| 5 | 27 | Shadowfang Keep | 22-30 | 3 | 3700 | 10 % | ★ | Hillsbrad Foothills (27-29) | Desolace (28-35) |
| 6 | 28 | Excavation Site: Wetlands | 24-29 | 4 | ~3750 | 9 % | ★ | Arathi Highlands (29-31) | Desolace (28-35) |
| 7 | 30 | City of Dalaran | 28-33 | 4 | ~5300 | 11 % | ★ | Alterac Mountains (29-31) | Desolace (31-35) |
| 8 | 30 | Scarlet Monastery : Graveyard | 28-38 | 1 | 1650 | 3 % | ★ | Alterac Mountains (29-31) | Desolace (31-35) |
| 9 | 31 | Scarlet Monastery : Library | 29-39 | 3 | 4025 | 8 % | ★ | Arathi Highlands (30-31) | Desolace (32-35) |
| 10 | 31 | Razorfen Kraul | 29-38 | 3 | 4600 | 9 % | ★ | Thousand Needles (31-33) | Desolace (32-35) |
| 11 | 34 | Scarlet Monastery : Armory | 32-42 | 0 | 0 | 0 % | — | Arathi Highlands (37-38) | Stranglethorn Vale (35-42) |
| 12 | 35 | Gnomeregan | 29-38 | 7 | ~9435 | 14 % | ★★ | Stranglethorn Vale (35-37) | Stranglethorn Vale (36-42) |
| 13 | 37 | Scarlet Monastery : Cathedral | 35-45 | 1 | 2575 | 3 % | ★ | Arathi Highlands (37-38) | Stranglethorn Vale (38-42) |
| 14 | 38 | Uldaman | 36-47 | 13 | 20225 | 25 % | ★★ | Badlands (38-40) | Riverglades (39-43) |
| 15 | 39 | Razorfen Downs | 37-46 | 6 | ~11500 | 13 % | ★★ | Dustwallow Marsh (38-40) | Riverglades (39-43) |
| 16 | 44 | Maraudon | 42-52 | 11 | ~27710 | 25 % | ★★ | Riverglades (39-43) ; Desolace (42-44, accès) | Feralas (45-47) |
| 17 | 46 | Zul'Farrak | 44-54 | 11 | ~24495 | 20 % | ★★ | Tanaris (44-46) | Feralas (45-47) |
| 18 | 52 | The Temple of Atal'Hakkar | 50-60 | 10 | 32650 | 20 % | ★★ | Stranglethorn Vale (47-49) ; The Hinterlands (49-51) ; Swamp of Sorrows (50-52, accès) | Blasted Lands (51-53) |
| 19 | 54 | Blackrock Depths | 52-60 | 27 | ~67010 | 39 % | ★★★ | Searing Gorge (52-54) ; Burning Steppes (53-54, accès) | Azshara (53-55) |
| 20 | 57 | Dire Maul : East | 55-60 | 3 | 8400 | 4 % | ★ | Felwood (54-56) ; Un'Goro Crater (55-56) ; Feralas (56-57, accès) | Winterspring (57-58) |
| 21 | 57 | Scholomance | 55-60 | 10 | 37825 | 19 % | ★★ | Western Plaguelands (57-58) | Winterspring (57-58) |
| 22 | 58 | Dire Maul : West | 56-60 | 1 | 4150 | 2 % | ★ | Feralas (56-57, accès) | Winterspring (57-58) |
| 23 | 58 | Dire Maul : North | 56-60 | 1 | 3300 | 2 % | ★ | Feralas (56-57, accès) | Winterspring (57-58) |
| 24 | 58 | Stratholme : Live | 58-60 | 8 | 36000 | 18 % | ★★ | Eastern Plaguelands (58-59) | Silithus (59-60) |
| 25 | 58 | Stratholme : Undead | 58-60 | 8 | 33050 | 16 % | ★★ | Eastern Plaguelands (58-59, accès) | Silithus (59-60) |

## Quêtes par échelon

### Ragefire Chasm (`RFC`, entrée 15)

- 5722 Searching for the Lost Satchel : 440 XP
- 5723 Testing an Enemy's Strength : 400 XP
- 5724 Returning the Lost Satchel : 725 XP
- 5725 The Power to Destroy... : 725 XP
- 5728 Hidden Enemies : 575 XP
- 5761 Slaying the Beast : 575 XP

- à vérifier en jeu : The Power to Destroy... (5725) se prend à Fossoyeuse : hors route pour les départs de Kalimdor

### Wailing Caverns (`WC`, entrée 19)

- 914 Leaders of the Fang : 1100 XP
- 959 Trouble at the Docks : 675 XP
- 962 Serpentbloom : 675 XP
- 1486 Deviate Hides : 800 XP
- 1487 Deviate Eradication : 1025 XP
- 1489 Hamuul Runetotem : 145 XP
- 1490 Nara Wildmane : 55 XP
- 1491 Smart Drinks : 675 XP
- 6981 The Glowing Shard : 1325 XP

### Ruins of Lordaeron (`LORDAERON`, entrée 20)

Niveau d'entrée imposé : un seul aller-retour en zeppelin à Fossoyeuse, après les Cavernes des lamentations plutôt qu'à 17.

- 92401 A Frightened Request : ~875 XP
- 92421 Light's Justice : ~875 XP
- 92422 The Wrath of Rath'mael : ~875 XP
- 95204 Crest of Lordaeron : ~325 XP
- 95216 The New Plague : ~875 XP
- 97288 Unending Torment : ~415 XP
- 97289 Unending Torment : 825 XP
- 97290 Unending Torment : 1650 XP
- 97291 Unending Torment : 825 XP
- 97292 Unending Torment : 825 XP

- à vérifier en jeu : plage 15-22 annoncée par Blizzard
- à vérifier en jeu : donneurs à Fossoyeuse, à Tirisfal et au Sépulcre
- à vérifier en jeu : trajet : zeppelin d'Orgrimmar à Fossoyeuse et retour

### Blackfathom Deeps (`BFD`, entrée 26)

- 6561 Blackfathom Villainy : 825 XP
- 6562 Trouble in the Deeps : 215 XP
- 6563 The Essence of Aku'Mai : 875 XP
- 6564 Allegiance to the Old Gods : 650 XP
- 6565 Allegiance to the Old Gods : 1325 XP
- 6921 Amongst the Ruins : 1375 XP
- 6922 Baron Aquanis : 1525 XP

### Shadowfang Keep (`SFK`, entrée 27)

Niveau d'entrée imposé : joué à l'arrivée à Fossoyeuse, avant les Contreforts d'Hautebrande, plutôt qu'à 24 par un aller-retour de plus.

- 1013 The Book of Ur : 1050 XP
- 1014 Arugal Must Die : 1650 XP
- 1098 Deathstalkers in Shadowfang : 1000 XP

- à vérifier en jeu : donneurs à Fossoyeuse et au Sépulcre, long trajet depuis Tarren Mill

### Excavation Site: Wetlands (`EXCAVATION`, entrée 28)

Niveau d'entrée imposé : joué depuis Hammerfall, au passage des Hautes-terres d'Arathi.

- 95663 Dragonmaw Rumors : ~625 XP
- 95664 Elder Knowledge : ~1250 XP
- 95697 Changing Tastes : ~1250 XP
- 98823 Earthen Echo : ~625 XP

- à vérifier en jeu : plage 24-29 annoncée, quêtes de niveau 31
- à vérifier en jeu : accès Horde par Arathi puis les Paluns à pied (zone Alliance)
- à vérifier en jeu : donneurs à Orgrimmar, aux Pitons-du-Tonnerre et à Hammerfall

### City of Dalaran (`DALARAN`, entrée 30)

- 96984 Heart of Disruption : ~1325 XP
- 96986 The Grave Knight : ~1325 XP
- 96987 Opportunistic Education : ~1325 XP
- 96988 Source of Power : ~1325 XP

- à vérifier en jeu : plage 28-33 annoncée, quêtes de niveau 33

### Scarlet Monastery : Graveyard (`SM_GY`, entrée 30)

- 1051 Vorrel's Revenge : 1650 XP
- hors route : 1113 Hearts of Zeal (suite de Going, Going, Guano! (1109), laissée hors route)

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Vorrel's Revenge (1051) : prise dans le Cimetière

### Scarlet Monastery : Library (`SM_LIB`, entrée 31)

- 1049 Compendium of the Fallen : 1775 XP
- 1159 Test of Lore : 1200 XP
- 1160 Test of Lore : 1050 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Compendium of the Fallen (1049) : Pitons-du-Tonnerre, fermée aux Morts-vivants
- à vérifier en jeu : Test of Lore (1159, 1160) : suite de Brackenwall (6627)

### Razorfen Kraul (`RFK`, entrée 31)

- 1102 A Vengeful Fate : 2025 XP
- 1144 Willix the Importer : 1525 XP
- 1221 Blueleaf Tubers : 1050 XP
- hors route : 1109 Going, Going, Guano! (prise et rendue à Fossoyeuse, loin de la route après le Kraal)

### Scarlet Monastery : Armory (`SM_ARM`, entrée 34)

Aucune quête Horde.

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Herod (Into The Scarlet Monastery, 1048) est compté avec la Cathédrale

### Gnomeregan (`GNOMER`, entrée 35)

Niveau d'entrée imposé : accès Horde par le transpondeur de Booty Bay, au passage de Strangleronce.

- 2841 Rig Wars : 1375 XP
- 2842 Chief Engineer Scooty : 135 XP
- 2843 Gnomer-gooooone! : ~1375 XP
- 2904 A Fine Mess : 1225 XP
- 2949 Return of the Ring : 1350 XP
- 2950 Nogg's Ring Redo : 2750 XP
- 2951 The Sparklematic 5200! : ~1225 XP

- à vérifier en jeu : Chief Engineer Scooty (2842) puis Gnomer-gooooone! (2843) ouvrent le transpondeur de Booty Bay
- à vérifier en jeu : la route envoie à Scooty (Booty Bay), pas à l'entrée de Dun Morogh : position du transpondeur à vérifier

### Scarlet Monastery : Cathedral (`SM_CATH`, entrée 37)

- 1048 Into The Scarlet Monastery : 2575 XP
- hors route : 1394 Final Passage (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Into The Scarlet Monastery (1048) : niveau requis 33, Loksey, Herod, Mograine et Whitemane

### Uldaman (`ULDAMAN`, entrée 38)

- 709 Solution to Doom : 1575 XP
- 2202 Uldaman Reagent Run : 1725 XP
- 2278 The Platinum Discs : 2100 XP
- 2280 The Platinum Discs : 2625 XP
- 2283 Necklace Recovery : 1225 XP
- 2284 Necklace Recovery, Take 2 : 1225 XP
- 2318 Translating the Journal : 430 XP
- 2338 Translating the Journal : 170 XP
- 2339 Find the Gems and Power Source : 1875 XP
- 2340 Deliver the Gems : 925 XP
- 2341 Necklace Recovery, Take 3 : 2800 XP
- 2342 Reclaimed Treasures : 1800 XP
- 2418 Power Stones : 1750 XP

### Razorfen Downs (`RFD`, entrée 39)

- 3341 Bring the End : 2150 XP
- 3525 Extinguishing the Idol : 2125 XP
- 6521 An Unholy Alliance : 2100 XP
- 6522 An Unholy Alliance : 1750 XP
- 6626 A Host of Evil : 1725 XP
- 97196 The Coldbringer's Eye : ~1650 XP

### Maraudon (`MARAUDON`, entrée 44)

- 7028 Twisted Evils : 2625 XP
- 7029 Vyletongue Corruption : 2625 XP
- 7044 Legends of Maraudon : 1700 XP
- 7046 The Scepter of Celebras : 2850 XP
- 7064 Corruption of Earth and Seed : 3050 XP
- 7066 Seed of Life : 3050 XP
- 7067 The Pariah's Instructions : 2725 XP
- 7068 Shadowshard Fragments : 1725 XP
- 93404 Rot and Regret : ~4550 XP
- 93594 Word of the Woods : 360 XP
- 96776 An'she's Radiance : ~2450 XP

- à vérifier en jeu : Maraudon en un seul échelon (une seule zone 2100 dans QuestieDB)

### Zul'Farrak (`ZF`, entrée 46)

- 2768 Divino-matic Rod : 3150 XP
- 2770 Gahz'rilla : 3550 XP
- 2846 Tiara of the Deep : 3025 XP
- 2861 Tabetha's Task : 200 XP
- 2864 Tran'rek : 195 XP
- 2865 Scarab Shells : 1950 XP
- 2935 Consult Master Gadrin : 2900 XP
- 2936 The Spider God : 2425 XP
- 3042 Troll Temper : 1950 XP
- 3527 The Prophecy of Mosh'aru : 2625 XP
- 96775 Zum'rah's Head : ~2525 XP

### The Temple of Atal'Hakkar (`ST`, entrée 52)

- 1429 The Atal'ai Exile : 3750 XP
- 1444 Return to Fel'Zerul : 3750 XP
- 1445 The Temple of Atal'Hakkar : 2950 XP
- 1446 Jammal'an the Prophet : 3275 XP
- 3380 The Sunken Temple : 1825 XP
- 3446 Into the Depths : 2450 XP
- 3447 Secret of the Circle : 3050 XP
- 3528 The God Hakkar : 3950 XP
- 4146 Zapper Fuel : 5100 XP
- 4147 Marvon's Workshop : 2550 XP
- hors route : 8733 Eranikus, Tyrant of the Dream (niveau requis 60)

### Blackrock Depths (`BRD`, entrée 54)

- 3801 Dark Iron Legacy : 255 XP
- 3802 Dark Iron Legacy : 2550 XP
- 3907 Disharmony of Fire : 3650 XP
- 3981 Commander Gor'shak : 2550 XP
- 4001 What Is Going On? : 270 XP
- 4002 The Eastern Kingdom : ~2050 XP
- 4003 The Royal Rescue : 4025 XP
- 4004 The Princess Saved? : 4975 XP
- 4024 A Taste of Flame : 3100 XP
- 4062 The Rise of the Machines : 1350 XP
- 4063 The Rise of the Machines : 3100 XP
- 4081 KILL ON SIGHT: Dark Iron Dwarves : 2550 XP
- 4082 KILL ON SIGHT: High Ranking Dark Iron Officials : 2725 XP
- 4083 The Spectral Chalice : 280 XP
- 4121 Precarious Predicament : 3875 XP
- 4122 Grark Lorkrub : 3100 XP
- 4123 The Heart of the Mountain : 2825 XP
- 4132 Operation: Death to Angerforge : 3875 XP
- 4133 Vivian Lagrave : 280 XP
- 4134 Lost Thunderbrew Recipe : 2825 XP
- 4136 Ribbly Screwspigot : 1325 XP
- 4201 The Love Potion : 2725 XP
- 4324 Yuka Screwspigot : 1325 XP
- 7201 The Last Element : 2725 XP
- 7604 A Binding Contract : ~3300 XP
- 7848 Attunement to the Core : 3300 XP
- 97197 Fragment of the Firelands : ~2100 XP
- hors route : 9015 The Challenge (niveau requis 58, suite de l'ensemble de donjon)

- à vérifier en jeu : donneurs à Kargath (Badlands) : détour depuis la Gorge des Vents brûlants

### Dire Maul : East (`DM_EAST`, entrée 57)

- 7441 Pusillin and the Elder Azj'Tordin : 3875 XP
- 7489 Lethtendris's Web : 3775 XP
- 7492 Camp Mojache : 750 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Pusillin et Lethtendris : aile Est

### Scholomance (`SCHOLO`, entrée 57)

- 4771 Dawn's Gambit : 4975 XP
- 5341 Barov Family Fortune : 3300 XP
- 5382 Doctor Theolen Krastinov, the Butcher : 3300 XP
- 5384 Kirtonos the Herald : 4150 XP
- 5465 Soulbound Keepsake : 4950 XP
- 5466 The Lich, Ras Frostwhisper : 4975 XP
- 5515 Krastinov's Bag of Horrors : 3300 XP
- 5522 Leonid Barthalomew : 4950 XP
- 5529 Plagued Hatchlings : 3100 XP
- 5531 Betina Bigglezink : 825 XP

### Dire Maul : West (`DM_WEST`, entrée 58)

- 7481 Elven Legends : 4150 XP

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Elven Legends (7481) : aile Ouest

### Dire Maul : North (`DM_NORTH`, entrée 58)

- 8948 Anthion's Old Friend : 3300 XP
- hors route : 5518 The Gordok Ogre Suit (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)
- hors route : 5525 Free Knot! (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)
- hors route : 5526 Shards of the Felvine (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)
- hors route : 7461 The Madness Within (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)
- hors route : 7703 Unfinished Gordok Business (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)

- à vérifier en jeu : plage de l'aile
- à vérifier en jeu : Anthion's Old Friend (8948) : niveau requis 58, suite 8947 ; aile à confirmer

### Stratholme : Live (`STRAT_LIVE`, entrée 58)

- 5214 The Great Ezra Grimm : 4150 XP
- 5243 Houses of the Holy : 3300 XP
- 5251 The Archivist : 4150 XP
- 5262 The Truth Comes Crashing Down : 4150 XP
- 5281 The Restless Souls : 6600 XP
- 5282 The Restless Souls : 4150 XP
- 5846 Of Love and Family : 6200 XP
- 5848 Of Love and Family : 3300 XP
- hors route : 5961 The Champion of the Banshee Queen (quête en plus (DungeonJournal), aile à confirmer : hors route automatique, dans la fenêtre Donjons)

- à vérifier en jeu : répartition des quêtes entre les deux côtés de Stratholme

### Stratholme : Undead (`STRAT_UD`, entrée 58)

- 5212 The Flesh Does Not Lie : 3300 XP
- 5213 The Active Agent : 3300 XP
- 5263 Above and Beyond : 4150 XP
- 5462 The Dying, Ras Frostwhisper : 4950 XP
- 5463 Menethil's Gift : 3300 XP
- 6163 Ramstein : 3300 XP
- 8930 In Search of Anthion : 6600 XP
- 8945 Dead Man's Plea : 4150 XP

- à vérifier en jeu : répartition des quêtes entre les deux côtés de Stratholme
- à vérifier en jeu : Ramstein (6163) : suite de Nathanos Blightcaller, facultative
- à vérifier en jeu : Dead Man's Plea (8945) : niveau requis 58, suite 8930, facultative

## Contenu écarté

- The Hall of Thanes : entrée à Ironforge, aucune quête Horde dans QuestieDB : Alliance seulement.
- The Deadmines : aucune quête Horde dans QuestieDB : Alliance seulement.
- The Stockade : entrée à Stormwind, aucune quête Horde dans QuestieDB : Alliance seulement.
- Lower Blackrock Spire : hors route à la demande ; QuestieDB ne sépare pas le bas du haut du Pic (zone 1583).
- Upper Blackrock Spire : raid de 10, pas un donjon 5 joueurs.
- Raids (Molten Core, Onyxia, Zul'Gurub, Ahn'Qiraj, Naxxramas) : pas des donjons 5 joueurs.
