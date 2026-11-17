# Fiche du projet CurseForge

Tout ce qu'il faut pour créer le projet sur CurseForge (formulaire « Create project »), puis brancher
l'envoi automatique des versions.

## 1. Formulaire de création

| Champ | Valeur |
|---|---|
| **Project name** | `Questify` |
| **Logo** | [`docs/curseforge/logo-400.png`](curseforge/logo-400.png) (400 × 400). Grande version : [`logo-1024.png`](curseforge/logo-1024.png), source : [`logo.svg`](curseforge/logo.svg). Dessin original : un « Q » en boussole dont la queue mène à un repère ; ni logo du jeu, ni élément de Blizzard. |
| **Summary** (anglais, une ligne, 256 caractères au plus) | `Free, open-source leveling guide for WoW: Forever. Levels 1 to 60, every race, both factions: optimised routes, built-in guidance with an arrow and map route, dungeons, class talents and macros.` |
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
- **Images** : les captures v1 de `docs/media/apercus/en/`, dans l'ordre et avec les légendes de la
  section 4 (plan des captures : `docs/media/CAPTURES-V1.md`). Vidéos : liens YouTube.

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
(Skyborne included) and both factions. Questify plans your whole route, guides you to every step on its own,
follows your quest log and always shows you the next thing to do.

## What Questify does
- **Optimised 1-60 routes.** Every chapter is built from QuestieDB, checked against the quest chains it traced from real players, and measured with a route simulator: all of a
  hub's quests picked up at once, one pass per objective area, grouped turn-ins, smart hearthstone use, minimal
  grinding. Steps tick themselves as you play; `/qf skip` and `/qf back` when you want to go your own way.
- **Your route, your choice.** At the end of a chapter, one card per possible zone with levels, quests, simulated
  time and XP per hour. "Change route" offers the chapters that fit your level at any time, and "Alternative
  zone" moves you elsewhere when a zone is too hard or overrun by the other faction.
- **Automatic route with dungeons.** A second route from level 12 to 60 built around the 5-player dungeons
  (every wing included), clearing a zone between two of them. One checkbox per dungeon, "Skip this dungeon" when
  you have no group, and the dungeon quests your route missed offered at the entrance.
- **Built-in guidance.** Questify works out the path by itself: an arrow on screen, the route drawn on the map
  and the minimap, flights, boats, zeppelins, trams, portals, hearthstone and Astral Recall, caves entered by
  their entrance. Prefer another addon? ShortestPath Forever, WaypointUI, TomTom or the game's map pin, and
  AzerothGPS follows every step with its own route.
- **A tracker that reads well.** Each objective on its own line (list, progress bars or by quest), the monsters
  to kill and their distance, zone mode for quests sharing an area, a quest item button, your XP per hour and
  how far ahead or behind the route you are. A key or a macro puts raid icons on the objective monsters so you
  see them from afar.
- **Dungeons.** 22 dungeons from Ragefire Chasm to Stratholme, suggested for your level and faction. The Dungeons
  tab gives the pick-up route from where you are, each quest with its objective, XP and rewards, the quests to
  do first, and one click to mark its giver on the map or add everything to your route.
- **Your class.** Class quests along your route or one click away; talent guides for the three specializations
  with the next point and the gap with your tree ("My points" or "My choice"); class macros to create in game;
  the spells to learn at your trainer, with an offer to replace the old ranks on your bars.
- **Loot and gold.** Optional auto accept, turn-in and reward choice following a loot profile, a green arrow on
  the reward that upgrades your gear, looted upgrades equipped in one click, junk sold, and the chapter's quest
  items you can buy at the auction house, with Auctionator or TSM prices.
- **Comfort.** Quests no longer worth it (grey, too high, elites without a group) flagged with the XP at stake,
  reminders before you leave town (bags, repairs, food and drink), hearthstone timing, profession training.
- **Your style.** 13 colour themes (your race, your faction, Questify, high contrast), text size, transparency,
  shareable option profiles, a first-run wizard and a What's new window after each update. English and French.

## Requirements
- **Required:** [QuestieDB](https://www.curseforge.com/wow/addons/questiedb) 1.1.2 or newer.
- **Optional:** [ShortestPath Forever](https://www.curseforge.com/wow/addons/shortest-path-forever),
  [WaypointUI](https://www.curseforge.com/wow/addons/waypointui), [TomTom](https://www.curseforge.com/wow/addons/tomtom),
  [AzerothGPS](https://www.curseforge.com/wow/addons/azerothgps), [Auctionator](https://www.curseforge.com/wow/addons/auctionator) or
  [TradeSkillMaster](https://www.curseforge.com/wow/addons/tradeskill-master) (prices).

## Commands
`/qf` journal · `/qf route` change route · `/qf options` options · `/qf skip` / `/qf back` skip or reopen a
step · `/qf hv` auction house list · `/qf news` what's new · `/qf bug` bug report · `/qf help` all commands

## Credits
Walking router: Polestar Nav, started from [Shortest Path Forever](https://github.com/cjber/shortest-path-forever)
by Cillian Berragan (GPL-3.0). Talent guides and class macros:
[classicwowforever.com](https://classicwowforever.com) (CC BY 4.0). Quest data: QuestieDB.

Code, issues, wiki and install guide: <https://github.com/questify-addon/questify> — feedback welcome, in
English or French.

---

# Questify — guide de leveling 1-60 gratuit pour WoW: Forever

Guide de leveling **gratuit et open source** pour World of Warcraft: Forever, **niveaux 1 à 60**, toutes les races
(Skyborne compris) et les deux factions. Questify prévoit toute ta route, te guide jusqu'à chaque étape tout seul,
suit ton journal de quêtes et t'indique toujours quoi faire ensuite.

## Ce que fait Questify
- **Routes 1-60 optimisées** : chaque chapitre est construit à partir de QuestieDB, vérifié sur les chaînes de quêtes relevées chez les joueurs et mesuré au simulateur ; toutes
  les quêtes d'un avant-poste prises d'un coup, un seul passage par zone d'objectifs, rendus groupés, pierre de
  foyer bien utilisée, farm minimal. Les étapes se cochent seules ; `/qf skip` et `/qf back` quand tu veux faire à
  ta façon.
- **Ta route, ton choix** : en fin de chapitre, une carte par zone possible avec niveaux, quêtes, temps simulé et
  XP par heure. « Changer de route » propose à tout moment les chapitres de ton niveau, et « Zone alternative »
  t'envoie ailleurs quand une zone est trop dure ou envahie par l'autre faction.
- **Route automatique avec les donjons** : un second parcours du niveau 12 au 60 construit autour des donjons à
  5 joueurs (chaque aile comprise), qui vide une zone entre deux. Une case par donjon, « Passer ce donjon » quand
  tu n'as pas de groupe, et les quêtes de donjon que ta route a manquées proposées à l'entrée.
- **Guidage intégré** : Questify calcule le chemin tout seul : une flèche à l'écran, le trajet tracé sur la carte et
  la minicarte, vols, bateaux, zeppelins, tram, portails, pierre de foyer et Rappel astral, grottes prises par
  leur entrée. Tu préfères un autre addon ? ShortestPath Forever, WaypointUI, TomTom ou le repère du jeu, et
  AzerothGPS suit chaque étape avec son propre trajet.
- **Un suivi lisible** : chaque objectif sur sa ligne (liste, barres ou par quête), les monstres à tuer et leur
  distance, le mode zone pour les quêtes d'un même endroit, un bouton d'objet de quête, ton XP par heure et ton
  avance ou ton retard sur la route. Une touche ou une macro pose des icônes de raid sur les monstres d'objectif
  pour les voir de loin.
- **Donjons** : 22 donjons, du Gouffre de Ragefeu à Stratholme, conseillés selon ton niveau et ta faction. L'onglet
  Donjons donne l'itinéraire de prise depuis ta position, chaque quête avec son objectif, son XP et ses
  récompenses, les quêtes à faire d'abord, et un clic pour marquer le donneur sur la carte ou tout ajouter à ta
  route.
- **Ta classe** : quêtes de classe sur ta route ou à un clic ; guides de talents des trois spécialisations avec le
  point suivant et l'écart avec ton arbre (« Mes points » ou « Mon choix ») ; macros de classe à créer en jeu ; les
  sorts à apprendre chez ton entraîneur, avec l'offre de remplacer les anciens rangs sur tes barres.
- **Butin et or** : acceptation, rendu et choix de la récompense automatiques et désactivables selon un profil de
  butin, une flèche verte sur la récompense qui améliore ton équipement, améliorations ramassées équipées en un
  clic, camelote vendue, et les objets de quête du chapitre achetables à l'hôtel des ventes, avec les prix
  d'Auctionator ou de TSM.
- **Confort** : les quêtes qui ne valent plus le coup (grises, trop hautes, élites sans groupe) signalées avec l'XP
  en jeu, rappels avant de quitter la ville (sacs, réparations, nourriture et boisson), recharge de la pierre de
  foyer, formations de métiers.
- **À ton goût** : 13 thèmes de couleurs (ta race, ta faction, Questify, contraste élevé), taille du texte,
  transparence, profils d'options partageables, assistant de premier démarrage et fenêtre des nouveautés après
  chaque mise à jour. Anglais et français.

## Prérequis
- **Requis :** [QuestieDB](https://www.curseforge.com/wow/addons/questiedb) 1.1.2 ou plus récent.
- **Optionnels :** [ShortestPath Forever](https://www.curseforge.com/wow/addons/shortest-path-forever),
  [WaypointUI](https://www.curseforge.com/wow/addons/waypointui), [TomTom](https://www.curseforge.com/wow/addons/tomtom),
  [AzerothGPS](https://www.curseforge.com/wow/addons/azerothgps), [Auctionator](https://www.curseforge.com/wow/addons/auctionator) ou
  [TradeSkillMaster](https://www.curseforge.com/wow/addons/tradeskill-master) (prix).

## Commandes
`/qf` journal · `/qf route` changer de route · `/qf options` options · `/qf skip` / `/qf back` passer ou rouvrir
une étape · `/qf hv` liste de l'hôtel des ventes · `/qf news` nouveautés · `/qf bug` rapport de bug · `/qf help`
toutes les commandes

## Crédits
Routeur de marche : Polestar Nav, issu de [Shortest Path Forever](https://github.com/cjber/shortest-path-forever)
de Cillian Berragan (GPL-3.0). Guides de talents et macros de classe :
[classicwowforever.com](https://classicwowforever.com) (CC BY 4.0). Données de quêtes : QuestieDB.

Code, tickets, wiki et guide d'installation : <https://github.com/questify-addon/questify> — retours bienvenus,
en français ou en anglais.

---

## 4. Images à téléverser

Images en anglais, 1920 × 1080, dans l'ordre conseillé : la première sert de couverture. Captures en jeu
découpées dans `docs/media/apercus/src/en/captures/` et posées dans les gabarits
`docs/media/apercus/src/en/*.html` (plan des captures v1 : [`media/CAPTURES-V1.md`](media/CAPTURES-V1.md)).
Rendu avec `sh docs/media/apercus/src/render.sh docs/media/apercus/src/en/*.html`. Colle la légende dans le
champ « Description » de chaque image (le titre peut reprendre sa première partie).

Pour la 1.0, on garde les huit images de l'essentiel. Les captures en jeu sont détourées au ras de l'interface ;
l'onglet Donjons vient de sa maquette validée et l'annonce d'équipement est redessinée d'après les captures,
avec un objet du niveau du personnage (badge « Interface preview »).

| # | Fichier | Légende (anglais) |
|---|---|---|
| 1 (couverture) | `en/01-tracker.png` | The tracker: chapter progress, the current step with its objectives as progress bars, the monsters to kill and their distance, your XP per hour and pace, and five buttons for the auction house list, the route, the dungeons, your class and the options. |
| 2 | `en/20-navigation.png` | Built-in guidance: an arrow on screen with the distance and the time left, the path drawn on the minimap around obstacles, and the whole trip on the world map. |
| 3 | `en/16-route-choice.png` | Your route, your choice: at the end of a chapter, one card per zone with levels, quests, simulated time and XP per hour. The recommended one glows. |
| 4 | `en/08c-journal-dungeons.png` | Dungeons tab: the pick-up route from where you are, each quest with its giver, objective, XP and rewards, the quests to do first, and one click to mark a giver on the map or add it all to your route. |
| 5 | `en/21-class-talents.png` | Talent guides for the three specializations: follow your points or your choice, see the next point and the gap with your tree. |
| 6 | `en/22-class-macros.png` | Class macros, filtered by spec and PvE or PvP, created in game in one click with your client's spell names. |
| 7 | `en/14-equip-upgrade.png` | Gear upgrades: a better item is announced with its main gain and the item it replaces, compared stat by stat for your class, and equipped in one click. |
| 8 | `en/10-quest-item.png` | The quest item button: use the item of the current step in one click, or with a key. |
