# Mode « Donjons » (Alliance, 1-60)

Un second parcours de montée de niveau, à côté des guides Alliance habituels : il vise d'abord les quêtes de
donjon, enchaîne tous les donjons 5 joueurs (chaque aile comprise) et vide une zone entre deux donjons.
Les guides Alliance et Horde existants, `ClassQuestData.lua` et `DungeonData.lua` ne sont ni modifiés ni
régénérés.

**État : infrastructure et échelle livrées, routes à écrire.** Tant qu'aucun chapitre du mode n'est livré,
l'option et la fenêtre restent cachées en jeu : rien ne change pour les joueurs.

- Échelle (niveau × donjon ou aile × zones entre deux) : [ECHELLE.md](ECHELLE.md), généré.
- Points à vérifier en jeu : [A-VERIFIER.md](A-VERIFIER.md).

## Ce que voit le joueur

- Options, section Parcours : « Mode Donjons » (par personnage) et « Choisir les donjons du parcours ».
  Aussi `/qf donjons`.
- Une case par donjon ou par aile, toutes cochées par défaut, avec zéro à trois étoiles.
- Case cochée : la route prend toutes les quêtes du donjon (suites et quêtes d'accès d'abord), puis envoie
  dans l'instance. Bouton « Contourner » : pas de groupe, on garde les quêtes prises, les étapes de
  l'instance sont passées et l'alternative en extérieur est jouée. Le donjon ne bloque jamais la route.
- Case décochée : le donjon et les détours qui ne servent qu'à lui sont sautés, l'alternative en extérieur
  est jouée.
- Les quêtes de classe restent dans `ClassQuestData.lua` et sont proposées chez le donneur ou le maître,
  comme dans les guides habituels.

## Architecture

| Fichier | Rôle |
|---|---|
| `tools/routebuilder/dungeon_ladder.lua` | L'échelle, écrite à la main : échelons, ailes et leurs quêtes, zones avant chaque échelon, alternative, contenu écarté, points à vérifier. |
| `tools/routebuilder/build_dungeon_route.lua` | Génère `Questify/Guides/DungeonRouteData.lua` et `ECHELLE.md` à partir de l'échelle et de `DungeonData.lua` (sans QuestieDB). Refuse une échelle incohérente. |
| `Questify/Guides/DungeonRouteData.lua` | Échelons dans l'ordre joué : niveau d'entrée, quêtes, XP, étoiles. |
| `Questify/Engine/DungeonMode.lua` | Choix du mode, cases, contournement, filtre des étapes. État par personnage : `Q.char.dungeonMode`. |
| `Questify/UI/DungeonModePanel.lua` | Fenêtre des cases et des étoiles. |
| `Questify/Engine/Guides.lua` | Champ `mode` des chapitres ; champs `rung`, `phase`, `alt`, `below` des étapes. |
| `Questify/Engine/Progress.lua` | Une ligne dans le filtre des étapes ; chapitre de départ selon le mode. |
| `tools/validate_guides.lua` | Contrôle des nouveaux champs (`rungProblem`). |

### Chapitres et étapes du mode

Un chapitre du mode porte `mode = "dungeon"`. Il n'est jamais choisi, listé au journal ni proposé comme suite
pour un personnage qui suit les guides habituels, et inversement. Les fichiers de routes iront dans
`Questify/Guides/AllianceDungeon/` (identifiants `AD_<Départ>_<NN>` et `AD_<NN>`), à part des guides actuels.

| Champ d'étape | Sens |
|---|---|
| `rung = "<échelon>", phase = "prep"` | Suite, quête d'accès, prise d'une quête du donjon, détour qui ne sert qu'à lui. Passée si la case est décochée. |
| `rung = "<échelon>", phase = "run"` | Aller à l'entrée, objectif dans l'instance, rendu. Passée si la case est décochée ou l'instance contournée. |
| `alt = "<échelon>"` | Alternative en extérieur : jouée si la case est décochée ou l'instance contournée. |
| `alt = "<échelon>", below = N` | Comme ci-dessus, et jouée aussi tant que le personnage est sous le niveau N. |
| `below = N` | Étape de rattrapage, passée dès le niveau N. |

`below` règle l'inconnue du mode : l'XP gagnée dans l'instance n'est pas connue d'avance (voir plus bas). La
route garde donc des étapes en extérieur qui ne se jouent que si le personnage arrive sous le niveau prévu.

## Méthode

### Niveau d'entrée

Bas de la plage du donjon + 2, plafonné à 58 (`ENTRY_OFFSET`, `ENTRY_CAP`). Les plages viennent du catalogue
existant (`dungeon_catalog.lua`) ; celles des ailes sont dans l'échelle et à vérifier en jeu. Un niveau imposé
porte sa raison (`entryWhy`).

### Étoiles

Rentabilité en XP de quêtes, calculée, jamais saisie :

    part = somme de l'XP de base des quêtes Alliance de l'échelon / XP du niveau d'entrée

- XP de base : `Q.QuestRewardData` de `DungeonData.lua`, c'est-à-dire la valeur QuestXP de QuestieDB, déjà
  divisée par deux pour une quête de donjon (règle de Forever). Une valeur estimée par le générateur est
  marquée `est` (« ~ » dans le plan, « environ » en jeu).
- XP du niveau : table `LEVEL_XP` de `tools/routebuilder/xp.lua`.
- Trois étoiles à partir de 30 %, deux à partir de 12 %, une en dessous, aucune sans quête Alliance
  (`STARS` dans l'échelle).

Limites, à lire avant de s'y fier :

- **L'XP des monstres de l'instance n'est pas comptée.** QuestieDB ne donne pas le nombre de monstres d'une
  instance. Les quêtes ne valent que 2 à 33 % d'un niveau par échelon : l'essentiel de l'XP d'un donjon
  vient des monstres, et cette part n'est pas mesurée ici.
- Le temps de détour n'entre pas encore dans le calcul : il demande les routes générées
  (`tools/routebuilder/travel.lua`). À ajouter avec les routes.

### Zones entre deux donjons

Niveaux par zone tirés de QuestieDB (quêtes ouvertes à l'Alliance, hors quêtes de classe, zones d'au moins
8 quêtes) : 1er décile, médiane, 9e décile des niveaux de quête.

| Zone | Quêtes | 1er décile | Médiane | 9e décile |
|---|---|---|---|---|
| Westfall | 53 | 10 | 15 | 22 |
| Loch Modan | 46 | 10 | 16 | 22 |
| Darkshore | 79 | 12 | 17 | 21 |
| Redridge Mountains | 43 | 14 | 20 | 26 |
| Stonetalon Mountains | 53 | 18 | 22 | 28 |
| Duskwood | 99 | 24 | 27 | 35 |
| Ashenvale | 73 | 20 | 27 | 30 |
| Wetlands | 65 | 21 | 29 | 33 |
| Hillsbrad Foothills | 58 | 22 | 32 | 40 |
| Thousand Needles | 68 | 27 | 34 | 42 |
| Alterac Mountains | 24 | 33 | 36 | 60 |
| Desolace | 86 | 32 | 37 | 42 |
| Dustwallow Marsh | 63 | 35 | 38 | 53 |
| Arathi Highlands | 58 | 34 | 39 | 42 |
| Badlands | 45 | 37 | 40 | 50 |
| Swamp of Sorrows | 30 | 35 | 40 | 50 |
| Stranglethorn Vale | 132 | 34 | 40 | 51 |
| Riverglades (Forever) | 150 | 38 | 40 | 44 |
| Shen'dralas (Forever) | 19 | 38 | 42 | 43 |
| Feralas | 80 | 43 | 46 | 50 |
| The Hinterlands | 47 | 43 | 48 | 51 |
| Darkspear Islands (Forever) | 18 | 39 | 49 | 60 |
| Searing Gorge | 31 | 47 | 50 | 60 |
| Azshara | 66 | 48 | 53 | 60 |
| Un'Goro Crater | 54 | 52 | 53 | 55 |
| Blasted Lands | 34 | 50 | 54 | 60 |
| Burning Steppes | 24 | 52 | 54 | 55 |
| Tanaris | 96 | 45 | 54 | 60 |
| Western Plaguelands | 92 | 53 | 55 | 60 |
| Felwood | 85 | 54 | 55 | 56 |
| Mount Hyjal (Forever) | 36 | 56 | 58 | 59 |
| Winterspring | 60 | 54 | 59 | 60 |
| Eastern Plaguelands | 111 | 56 | 60 | 60 |
| Silithus | 110 | 59 | 60 | 60 |

Conséquences pour l'échelle : le Bois de la Pénombre commence à 24 (1er décile 24, médiane 27), plus à 22 ;
Riverglades et Shen'dralas portent la tranche 38-44 ; Mount Hyjal sert de 56 à 59.

Règle d'un bloc de zone, à appliquer par le générateur de routes : les suites et les quêtes d'accès du donjon
suivant d'abord, puis les quêtes à accès direct sans suite ; une quête devenue verte est laissée, sauf si
elle ouvre une suite ou un donjon ; les élites de zone sont facultatifs.

## Commandes

```sh
# Régénérer l'échelle après une modification de dungeon_ladder.lua ou de DungeonData.lua
luajit tools/routebuilder/build_dungeon_route.lua

# Tests
luajit tests/run.lua test_dungeonmode
luajit tools/routebuilder/tests/run.lua dungeon_route
```
