# Mode « Donjons » (Alliance, 1-60)

Un second parcours de montée de niveau, à côté des guides Alliance habituels : il vise d'abord les quêtes de
donjon, enchaîne tous les donjons 5 joueurs (chaque aile comprise) et vide une zone entre deux donjons.
Les guides Alliance et Horde existants, `ClassQuestData.lua` et `DungeonData.lua` ne sont ni modifiés ni
régénérés.

**État : infrastructure, échelle et routes 12-60 livrées ; rien n'a été joué en jeu.** Le mode est proposé
aux personnages de l'Alliance dans les options ; il est éteint par défaut et la route habituelle ne change pas.

- Échelle (niveau × donjon ou aile × zones entre deux) : [ECHELLE.md](ECHELLE.md), généré.
- Routes générées, niveaux simulés et quêtes prises par échelon : [routes/ROUTES.md](routes/ROUTES.md), généré,
  avec un rapport par chapitre dans le même dossier.
- Points à vérifier en jeu : [A-VERIFIER.md](A-VERIFIER.md).

## Ce que voit le joueur

Le mode s'appelle « mode automatique » en jeu.

- Assistant du premier lancement, page 2 « Ta route » : route automatique (présélectionnée quand elle
  existe pour le personnage) ou manuelle. « Terminer » lance ou arrête le mode.
- Journal, onglet Route : deux vues, « Manuel » (chapitres et étapes, comme avant) et « Automatique ».
  Aussi `/qf donjons` et les Options, section Parcours. Les deux boutons n'apparaissent que si le mode
  existe pour le personnage (Alliance). À chaque ouverture du journal, l'onglet Route s'ouvre sur la vue
  de la route choisie.
- Suivi : ligne « Mode : Manuel » ou « Mode : Automatique » sous la barre (si le mode existe pour le
  personnage). En automatique, bouton « Chemin alternatif » (zone alternative, ci-dessous), qui devient
  « Chemin normal » sur la zone alternative.
- Suivi, étape d'instance (phase « run ») : bouton « Passer ce donjon » (pas de groupe). L'instance est
  contournée (`bypassed`), les quêtes prises restent dans le journal, l'alternative en extérieur est
  jouée. Tant que le niveau est dans la tranche du donjon et que ses quêtes ne sont pas toutes rendues, le
  rappel « Revenir au donjon X » s'affiche en tête des objectifs ; un clic reprend le donjon (dans un
  chapitre suivant, ses étapes d'instance sont insérées en tête de la route, tag `dgresume:<échelon>`).
  Hors de la tranche, le rappel disparaît et le donjon reste passé.
- Suivi, même étape d'entrée : bouton « + Quêtes supplémentaires (N) » quand des quêtes de l'échelon ne sont pas
  dans le journal et peuvent être prises maintenant. La route ne prend que les quêtes vues par la simulation (un
  personnage qui joue toutes les alternatives) : un personnage qui a fait les donjons précédents passe
  l'alternative des Carmines et arrive à la Prison sans What Comes Around..., et The Fury Runs Deep (Paluns,
  après The Dark Iron War) n'est jamais sur le chemin. L'infobulle donne chaque quête avec son donneur, ses
  préquêtes (et leur niveau), le trajet estimé par ShortestPathForever depuis le point précédent (vol connu,
  bateau, tram, point de vol à découvrir en chemin), le retour à l'entrée et le total. Un clic insère un bloc
  `dg:<échelon>` (`Q.Dungeons:AddExtras`) : prises et préquêtes en phase `prep`, entrée, objectifs et rendus de
  toutes les quêtes de l'échelon en phase `run` ; la case de l'échelon et « Passer ce donjon » s'y appliquent.
  Sur les prises du bloc, le bouton devient « Retirer les quêtes en plus ». Les étapes d'instance de la route
  qui suivent sont validées par les rendus du bloc.
- Vue « Automatique » : un gros bouton centré lance ou arrête le mode ; dessous, le sous-menu repliable
  « Donjons » (une case et zéro à trois étoiles par donjon ou par aile, « Tout cocher » / « Tout
  décocher ») puis l'aperçu des zones à explorer, dans l'ordre, avec les donjons faits à la fin de chacune.
- Case cochée : la route prend les quêtes du donjon (suites et quêtes d'accès d'abord), puis envoie dans
  l'instance. Case décochée : le donjon et les détours qui ne servent qu'à lui sont sautés, la zone
  alternative en extérieur est jouée. Pas de bouton « Contourner » dans le journal : décocher suffit, à tout
  moment (« Passer ce donjon » du suivi est le contournement temporaire).
- Mode automatique actif : plus de « donjons suggérés » dans le suivi (ils sont dans la route).
- Les quêtes de classe restent dans `ClassQuestData.lua` et sont proposées chez le donneur ou le maître,
  comme dans les guides habituels.

### Zone alternative (les deux modes)

Zone trop dure ou envahie par l'autre faction : le bouton « Zone alternative » du journal (ou `/qf alt`)
passe sur une autre zone adaptée au niveau du personnage, un peu moins rentable. Un second appel passe à la
suivante. « Revenir à ma route » (ou `/qf alt back`), ou la fin de la zone alternative, ramène au chemin.

- Choix (`Questify/Engine/Detour.lua`) : chapitres de la faction et de la race, hors zones du chapitre
  quitté, hors chapitres finis, dont la tranche convient au niveau **avec la barre d'XP** (au plus un niveau
  sous le début de la tranche, deux au-dessus de sa fin). Classement : XP/h simulée du chapitre × part des
  quêtes restantes, moins 0,5 par niveau manquant et 0,35 par niveau en trop.
- Retour : le chapitre quitté s'il est encore à la portée du personnage, sinon le chapitre de son niveau.

## Architecture

| Fichier | Rôle |
|---|---|
| `tools/routebuilder/dungeon_ladder.lua` | L'échelle, écrite à la main : échelons, ailes et leurs quêtes, zones avant chaque échelon, alternative, contenu écarté, points à vérifier. |
| `tools/routebuilder/build_dungeon_route.lua` | Génère `Questify/Guides/DungeonRouteData.lua` et `ECHELLE.md` à partir de l'échelle et de `DungeonData.lua` (sans QuestieDB). Refuse une échelle incohérente. |
| `Questify/Guides/DungeonRouteData.lua` | Échelons dans l'ordre joué : niveau d'entrée, quêtes, XP, étoiles. |
| `Questify/Engine/DungeonMode.lua` | Choix du mode, cases, contournement, filtre des étapes. État par personnage : `Q.char.dungeonMode`. |
| `Questify/UI/DungeonModePanel.lua` | Vue « Automatique » de l'onglet Route du journal. |
| `Questify/Engine/Detour.lua` | Zone alternative : choix selon le niveau, retour au chemin. |
| `Questify/Engine/Guides.lua` | Champ `mode` des chapitres ; champs `rung`, `phase`, `alt`, `below` des étapes. |
| `Questify/Engine/Progress.lua` | Une ligne dans le filtre des étapes ; chapitre de départ selon le mode. |
| `tools/routebuilder/plans_dungeon.lua` | La chaîne des chapitres du mode : copies des réglages des chapitres habituels (jamais modifiés), redécoupés autour des échelons. |
| `tools/routebuilder/build_dungeon_guides.lua` | Génère les routes avec le simulateur habituel, ajoute les blocs « instance » et les étiquettes, écrit `AllianceDungeon/`, `DungeonGuides.xml` et les rapports. |
| `tools/routebuilder/build.lua` | Deux crochets (`plan.before`, `plan.after`), sans effet sur les plans habituels. |
| `tools/validate_guides.lua` | Contrôle des nouveaux champs (`rungProblem`) ; `--xml DungeonGuides.xml` rejoue les routes du mode à la suite des départs habituels, race par race. |

### Chapitres et étapes du mode

Un chapitre du mode porte `mode = "dungeon"`. Il n'est jamais choisi, listé au journal ni proposé comme suite
pour un personnage qui suit les guides habituels, et inversement. Les fichiers sont dans
`Questify/Guides/AllianceDungeon/` (35 chapitres `AD_*`), chargés par `Guides/DungeonGuides.xml`, à part des
guides actuels et de `Guides.xml`.

Départs : les niveaux 1 à 15 sont ceux des guides habituels (mêmes chapitres, non dupliqués). Le champ
`after` d'un chapitre du mode nomme les chapitres habituels dont il prend la suite : `AD_01` (Ironforge)
après la Marche de l'Ouest des Humains et des Nains / Gnomes et après l'île de Zephras, `AD_NightElf_03`
(Sombrivage jusqu'au niveau 16) après Teldrassil. Les trois départs se rejoignent en `AD_01`.

Trois rôles de chapitre :

- **zone** : toujours joué ; ses prises de quêtes de donjon et leurs suites d'accès sont des étapes `prep` ;
- **instance** : chapitre de zone qui finit par un bloc `run` par échelon (aller à l'entrée, objectifs,
  rendus) ; un rendu lointain est déplacé au début du prochain chapitre qui passe par la zone du PNJ ;
- **alternative** : toutes ses étapes portent `alt = { échelons }` et `below = niveau visé`.

| Champ d'étape | Sens |
|---|---|
| `rung = "<échelon>", phase = "prep"` | Suite, quête d'accès, prise d'une quête du donjon, détour qui ne sert qu'à lui. Passée si la case est décochée. |
| `rung = "<échelon>", phase = "run"` | Aller à l'entrée, objectif dans l'instance, rendu. Passée si la case est décochée ou l'instance contournée. |
| `alt = "<échelon>"` ou `{ "<échelon>", ... }` | Alternative en extérieur : jouée si la case de l'un de ces échelons est décochée ou son instance contournée. |
| `alt = ..., below = N` | Comme ci-dessus, et jouée aussi tant que le personnage est sous le niveau N. |
| `below = N` | Étape de rattrapage, passée dès le niveau N. |

Une quête déjà dans le journal est toujours finie : ses étapes « faire » et « rendre » restent jouées même
quand l'alternative ne l'est plus.

`below` règle l'inconnue du mode : l'XP gagnée dans l'instance n'est pas connue d'avance (voir plus bas). La
route garde donc des étapes en extérieur qui ne se jouent que si le personnage arrive sous le niveau prévu.

## Méthode

### Simulation de référence

Les routes sont simulées pour un personnage qui **contourne toutes les instances** et joue toutes les
alternatives : c'est le seul parcours dont l'XP est connue. Les niveaux écrits dans les chapitres sont donc
un plancher. Un personnage qui fait les donjons est au-dessus : les chapitres d'alternative se passent
d'eux-mêmes (`below`), les chapitres de zone restent joués.

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

# Régénérer les routes du mode (QuestieDB et Questie dans .cache/, environ 4 minutes)
luajit tools/routebuilder/build_dungeon_guides.lua

# Contrôler les routes du mode, rejouées à la suite des départs habituels
luajit tools/validate_guides.lua --xml DungeonGuides.xml

# Tests
luajit tests/run.lua test_dungeonmode
luajit tools/routebuilder/tests/run.lua dungeon
```
