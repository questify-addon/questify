# Fiche du projet CurseForge

Tout ce qu'il faut pour créer le projet sur CurseForge (formulaire « Create project »), puis brancher
l'envoi automatique des versions.

## 1. Formulaire de création

| Champ | Valeur |
|---|---|
| **Project name** | `Questify` |
| **Logo** | [`docs/curseforge/logo-400.png`](curseforge/logo-400.png) (400 × 400). Grande version : [`logo-1024.png`](curseforge/logo-1024.png), source : [`logo.svg`](curseforge/logo.svg). Dessin original : un « Q » en boussole dont la queue mène à un repère ; ni logo du jeu, ni élément de Blizzard. |
| **Summary** (anglais, une ligne, 256 caractères au plus) | `Free, open-source leveling guide for WoW: Forever. Levels 1 to 60, every race, both factions: step-by-step routes that follow your quest log, waypoints, class quests and dungeons.` |
| **Class** | Addons |
| **Main category** | Quests & Leveling |
| **Additional categories** | Map & Minimap ; Class (si la catégorie est proposée) |
| **Allow Comments** | coché |
| **Unlisted project** | décoché (cocher seulement pour un essai privé avant les premiers retours en jeu) |
| **Social Links** | GitHub : `https://github.com/questify-addon/questify` |

Après la création, dans les réglages du projet :
- **License** : GNU General Public License version 3 (GPLv3), comme le dépôt.
- **Source / Issues / Wiki** : `https://github.com/questify-addon/questify`,
  `https://github.com/questify-addon/questify/issues`, `https://github.com/questify-addon/questify/wiki`.
- **Description** : le texte de la section 3 ci-dessous (éditeur WYSIWYG : coller le rendu de
  [`curseforge/description.html`](curseforge/description.html)).
- **Images** : les aperçus anglais de `docs/media/apercus/en/`, dans l'ordre et avec les légendes de la
  section 4 (marqués « Interface preview » ; les captures en jeu de `docs/media/` les remplaceront).
  Vidéos : liens YouTube.

## 2. Envoi automatique des versions

Le workflow `.github/workflows/release.yml` envoie le zip sur CurseForge à chaque tag `vX.Y.Z`, dès que
deux secrets existent. À faire une fois, par toi (les jetons ne passent jamais par moi) :

1. Note l'**ID du projet** : encadré « About Project » de la page du projet (un nombre).
2. Crée un **jeton d'API** : <https://authors.curseforge.com/#/settings/api-tokens>.
3. Enregistre les deux secrets dans le dépôt GitHub (chaque commande demande la valeur, à coller) :

```bash
gh secret set CF_PROJECT_ID --repo questify-addon/questify
```

```bash
gh secret set CF_API_KEY --repo questify-addon/questify
```

La version du jeu envoyée est `1.60.1` (WoW: Forever) ; pour une autre, crée la variable
`CF_GAME_VERSION` dans les réglages du dépôt (Settings > Secrets and variables > Actions > Variables).
Type de fichier : « release » pour un tag `vX.Y.Z`, « beta » pour `vX.Y.Z-beta.N`, « alpha » pour
`vX.Y.Z-alpha.N`. Si les secrets sont posés après un tag, relance le job : `gh run rerun <id> --failed`.

## 3. Description (à coller)

Anglais d'abord, français ensuite. À coller dans l'onglet « Description » du projet. L'éditeur du projet
est en mode WYSIWYG : y coller le texte mis en forme, pas le Markdown brut. Le plus simple : ouvrir
[`curseforge/description.html`](curseforge/description.html) dans un navigateur, tout sélectionner, copier,
coller. Chaque onglet de l'espace auteur s'enregistre à part : enregistrer « General » avant de passer à
« Description ». Garder ce texte et `description.html` identiques.

---

# Questify — free 1-60 leveling guide for WoW: Forever

A **free and open-source** leveling guide for World of Warcraft: Forever, **levels 1 to 60**, for every race
(Skyborne included) and both factions. Questify plans your whole route, follows your quest log on its own and
always shows you the next thing to do.

## What Questify does
- **Optimised 1-60 routes.** Every chapter is built from QuestieDB and measured with a route simulator: all of a
  hub's quests picked up at once, one pass per objective area, grouped turn-ins, smart hearthstone use, minimal
  grinding, one continent at a time. About 93 to 96 hours of simulated play from 1 to 60, depending on your race.
- **Follows your quest log.** Steps tick themselves; steps your character cannot do are skipped.
  `/qf skip` and `/qf back` when you want to go your own way.
- **Navigation your way.** Native 3D waypoint, or ShortestPath Forever, WaypointUI or TomTom. Flight paths, boats
  and zeppelins are part of the route, caves are entered by their entrance, and the next steps are pinned on the
  world map and minimap.
- **Zone mode and mob targeting.** When several quests share an area, their objectives are grouped into one
  visit; the monsters to kill are listed under the objective, and one click (or a key) targets them and marks
  them with a skull.
- **Class quests and dungeons.** Class quests up to level 60: the ones along your route are steps of the route, the
  others are in the journal with a one-click "Add to route". Dungeon quests are picked up along the way; 22 dungeons
  from Ragefire Chasm to Stratholme are suggested for your level and faction, and one click adds every quest to pick
  up (with the quests that unlock them), the dungeon, the turn-ins and the way back to your route.
- **Comfort.** Optional auto accept, turn-in and reward choice (following a loot profile: Elemental, Healer,
  Tank…), gear upgrades announced and equipped in one click, junk sold, quest item button (also for an item that
  starts a quest, with an alert when you loot it), profession training reminders.
- **Your style.** Four tracker themes, adjustable transparency, shareable option profiles, a first-run wizard,
  English and French.

## Requirements
- **Required:** [QuestieDB](https://www.curseforge.com/wow/addons/questiedb).
- **Optional:** [ShortestPath Forever](https://www.curseforge.com/wow/addons/shortest-path-forever),
  [WaypointUI](https://www.curseforge.com/wow/addons/waypointui), [TomTom](https://www.curseforge.com/wow/addons/tomtom).

The first-run wizard detects them and gives the link for the missing ones.

## Commands
`/qf` journal · `/qf route` change route · `/qf class` class quests · `/qf options` options ·
`/qf skip` / `/qf back` skip or reopen a step · `/qf bug` bug report · `/qf help` all commands

Code, issues, wiki and install guide: <https://github.com/questify-addon/questify> — feedback welcome, in
English or French.

---

# Questify — guide de leveling 1-60 gratuit pour WoW: Forever

Guide de leveling **gratuit et open source** pour World of Warcraft: Forever, **niveaux 1 à 60**, toutes les races
(Skyborne compris) et les deux factions. Questify prévoit toute ta route, suit ton journal de quêtes tout seul et
t'indique toujours quoi faire ensuite.

## Ce que fait Questify
- **Routes 1-60 optimisées** : chaque chapitre est construit à partir de QuestieDB et mesuré au simulateur ; toutes
  les quêtes d'un avant-poste prises d'un coup, un seul passage par zone d'objectifs, rendus groupés, pierre de
  foyer bien utilisée, farm minimal, un continent à la fois. Environ 93 à 96 h de jeu simulé de 1 à 60 selon la
  race.
- **Suit ton journal** : les étapes se cochent seules ; celles que ton personnage ne peut pas faire sont sautées.
  `/qf skip` et `/qf back` quand tu veux faire à ta façon.
- **Navigation au choix** : repère 3D du jeu, ou ShortestPath Forever, WaypointUI ou TomTom. Points de vol, bateaux
  et zeppelins font partie de la route, les grottes se prennent par leur entrée, les étapes suivantes sont
  épinglées sur la carte du monde et la minicarte.
- **Mode zone et ciblage** : quand plusieurs quêtes partagent un endroit, leurs objectifs sont regroupés en une
  visite ; les monstres à tuer sont listés sous l'objectif, un clic (ou une touche) les cible et pose le crâne.
- **Quêtes de classe et donjons** : quêtes de classe jusqu'au niveau 60 : celles sur ton chemin sont des étapes de
  la route, les autres sont dans le journal avec « Ajouter à la route » en un clic. Les quêtes de donjon se prennent
  en chemin ; 22 donjons, du Gouffre de Ragefeu à Stratholme, sont conseillés selon ton niveau et ta faction, et un
  clic ajoute toutes les quêtes à prendre (avec celles qui les débloquent), le donjon, les rendus et le retour à ta
  route.
- **Confort** : acceptation, rendu et choix de la récompense automatiques et désactivables (selon un profil de
  butin : Élémentaire, Soigneur, Tank…), améliorations d'équipement annoncées et équipées en un clic, camelote
  vendue, bouton d'objet de quête (aussi pour un objet qui lance une quête, avec une alerte quand tu le ramasses),
  rappels de métiers.
- **À ton goût** : quatre thèmes du suivi, transparence réglable, profils d'options partageables, assistant de
  premier démarrage, anglais et français.

## Prérequis
- **Requis :** [QuestieDB](https://www.curseforge.com/wow/addons/questiedb).
- **Optionnels :** [ShortestPath Forever](https://www.curseforge.com/wow/addons/shortest-path-forever),
  [WaypointUI](https://www.curseforge.com/wow/addons/waypointui), [TomTom](https://www.curseforge.com/wow/addons/tomtom).

L'assistant de premier démarrage les détecte et donne le lien de ceux qui manquent.

## Commandes
`/qf` journal · `/qf route` changer de route · `/qf classe` quêtes de classe · `/qf options` options ·
`/qf skip` / `/qf back` passer ou rouvrir une étape · `/qf bug` rapport de bug · `/qf help` toutes les commandes

Code, tickets, wiki et guide d'installation : <https://github.com/questify-addon/questify> — retours bienvenus,
en français ou en anglais.

---

## 4. Images à téléverser

Images en anglais, 1920 × 1080, dans l'ordre conseillé : la première sert de couverture. Deux sortes :
- **aperçus** (maquettes tirées du code, marqués « Interface preview ») : sources
  `docs/media/apercus/src/en/*.html` ;
- **captures en jeu** (marquées « In-game capture ») : les mêmes pages HTML, avec les morceaux utiles
  des captures d'écran découpés dans `docs/media/apercus/src/en/captures/`.

Rendu avec `sh docs/media/apercus/src/render.sh docs/media/apercus/src/en/*.html`. Colle la légende dans
le champ « Description » de chaque image (le titre peut reprendre sa première partie).

| # | Fichier | Légende (anglais) |
|---|---|---|
| 1 (couverture) | [`en/01-tracker.png`](media/apercus/en/01-tracker.png) | The tracker: chapter progress, levels, XP left and XP per hour, the current step with its distance and the monsters to kill, then the next steps. Four buttons open the route, the dungeons, the class quests and the options. |
| 2 | [`en/11-zone-mode.png`](media/apercus/en/11-zone-mode.png) | Zone mode: objectives of several quests in the same place are grouped into one visit, objects first, then elites and named, then monsters. |
| 3 | [`en/16-route-choice.png`](media/apercus/en/16-route-choice.png) | Choose your next zone: at the end of a chapter, one card per zone with levels, quests, simulated time and XP per hour, travel and highlights. The recommended one glows. |
| 4 | [`en/08-journal-route.png`](media/apercus/en/08-journal-route.png) | The journal (/qf): your faction's chapters grouped by level, a green check on finished ones, and every step of the route. Click a step to make it the current one. |
| 5 | [`en/08c-journal-dungeons.png`](media/apercus/en/08c-journal-dungeons.png) | Dungeons tab: every dungeon of your faction, rated with one to three stars for the quests left to do, with the quests to pick up and one click to add it to your route. |
| 6 | [`en/18-quest-chain.png`](media/apercus/en/18-quest-chain.png) | Quest chains off your route: when dungeon quests need earlier quests elsewhere, an annex docked to the journal shows the zones in order, every step with its giver and XP, what it unlocks and the dungeon rewards, and one click adds it all to your route. |
| 7 | [`en/13-cave-entrance.png`](media/apercus/en/13-cave-entrance.png) | Caves: when the objective is inside a known cave, the waypoint leads to the entrance first, titled "Cave entrance — The Grizzled Den". |
| 8 | [`en/10-quest-item.png`](media/apercus/en/10-quest-item.png) | Quest item button next to the tracker: click to use the item the current step needs, or bind it to a key. |
| 9 | [`en/14-equip-pair.png`](media/apercus/en/14-equip-pair.png) | Gear upgrades announced in the middle of the screen and equipped in one click. With a two-hander equipped, a better one-hander and shield pair is offered too. |
| 10 | [`en/17-outpost-alert.png`](media/apercus/en/17-outpost-alert.png) | Outpost alert: in town, Questify warns you before you head out when your bags are nearly full, you have no food or drink, or your gear needs repairs. |
| 11 | [`en/06-class-quest.png`](media/apercus/en/06-class-quest.png) | Class quests: the class button of the tracker glows while a chain is available; the window shows where it starts, its objectives and rewards, and one click adds it to your route. |
| 12 | [`en/07-dungeon.png`](media/apercus/en/07-dungeon.png) | Suggested dungeons for your level and faction: the dungeon button glows, and the window gives the entrance, the quests to pick up with their givers, and one click to add them to your route. |
| 13 | [`en/02-wizard.png`](media/apercus/en/02-wizard.png) | First-run wizard: required and optional addons are detected, with a CurseForge link for the missing ones. |
| 14 | [`en/08b-journal-options.png`](media/apercus/en/08b-journal-options.png) | The options window: eleven sections, search, an "i" help on every setting, keys set in one click, and profiles you can share. |
| 15 | [`en/bonus-themes.png`](media/apercus/en/bonus-themes.png) | Four tracker themes: Parchment (default), Black, Transparent and Grey fade. |

Captures en jeu faites : 01 (suivi), 06 (quêtes de classe), 07 (donjon), 08 (journal, onglet Route),
08b (options), 08c (journal, onglet Donjons), 10 (objet de quête), 18 (suite de quêtes hors route), 14 (équipement), 16 (choix de suite),
17 (alerte d'avant-poste) et les thèmes. Encore en maquettes : 02, 11 et 13 ; les remplacer au fur et à
mesure (voir docs/media/CAPTURES-EN-JEU.md).
