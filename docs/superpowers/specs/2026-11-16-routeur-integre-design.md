# Routeur intégré : Questify guide seul, sur de vrais chemins

Date : 2026-11-16. Branche : `claude/nav-router-1110f9`.

## Intention

Aujourd'hui Questify ne dessine rien lui-même : `Questify/Nav/Navigation.lua` confie la cible à
Shortest Path Forever (SPF), WaypointUI, TomTom ou au repère natif du jeu. Sans SPF, le joueur n'a
qu'un repère en ligne droite. Polestar guide mieux entre deux objectifs : il embarque son propre
routeur de marche, trace la route sur la carte et la minicarte, et prévoit vols, bateaux et
zeppelins avec une légende par trajet.

Le joueur doit pouvoir installer Questify seul et être guidé sur de vrais chemins, sans pile d'addons.
Cette décision annule celle du 2026-11-12 (« SPF seul routeur, pas de pathfinder natif »).

## Objectifs

1. Routeur de marche embarqué, cartes chargées à la demande par continent.
2. Planificateur de voyage : marche, vol, tram, bateau, zeppelin, portail et pierre de foyer. Chaque
   trajet a une icône et une légende, dans le suivi et sous la flèche.
3. Route tracée sur la carte du monde et la minicarte, aux couleurs du thème Questify.
4. Flèche propre à Questify, déplaçable à la souris, avec une option de verrouillage.
5. Liaisons de la pierre de foyer choisies avec les chapitres suivants en vue : le retour doit faire
   gagner le plus de temps sur toute la route, mesuré au route builder.
6. Guidage tout automatique par défaut : routeur, ligne et flèche actifs sans aucun réglage.
7. Style de trajet au choix : « sûr » (défaut), « plus rapide », « routes ». Le style « sûr » évite
   les zones bien au-dessus du niveau du personnage et les villes de l'autre faction, et prévient
   quand le chemin doit y entrer (comme « Hostile town » chez Polestar).
8. Vitesse de monture comptée dans les temps de trajet, en jeu comme dans le route builder.
9. Budget mémoire et processeur mesuré : aucune saccade en jeu (SPF a eu des rapports de 100 à
   120 ms, issues #759 et #772), cartes chargées seulement à la demande, par continent.

## Non-objectifs

- Horaires en direct des bateaux et zeppelins : on garde les temps moyens du route builder.
- Copier le planificateur, la flèche ou les calques de Polestar (GPL-3.0-only, liés à son `ns`).
- Pas de nouvelle source de données de quêtes. Pas de nouvelle publication ni de fusion dans `main`
  sans accord.

## Anti-objectifs (échec même si « ça marche »)

- Le jeu saccade pendant un calcul : le routeur doit rester découpé par image, comme chez Polestar.
- Conflit quand Polestar ou SPF est aussi installé : globales et noms d'addons partagés.
- Une couleur codée en dur dans l'interface : le thème est refondu en parallèle (session `ui-themes`).
- L'interface en jeu ne ressemble pas à la maquette validée.
- Un trajet proposé en jeu utilise un moyen que le joueur n'a pas : point de vol non appris,
  transport d'une autre faction, pierre en recharge ou liée ailleurs.

## Contraintes

- Licences : Questify est GPL-3.0-or-later. `Polestar_Nav` (routeur et cartes) est GPL-3.0-or-later,
  copiable. Le reste de Polestar est GPL-3.0-only et n'est pas copié. Les en-têtes de copyright
  (Polestar, Cillian Berragan) sont gardés tels quels, et un fichier de crédits est ajouté.
- Taille : environ +37 Mo (1,3 + 16 + 20). Les cartes sont déjà compressées en zlib : le zip ne
  les réduira presque pas. Accord de l'utilisateur sur ce budget.
- Identité : commits sous `questify-addon`, sans nom ni courriel réels.
- Lien du jeu : `AddOns/Questify` est un lien vers un autre worktree. Les nouveaux dossiers
  `Questify_Nav*` demandent leurs propres liens. On demande à l'utilisateur avant d'en poser.
- Sept autres sessions travaillent sur l'interface. Les changements restent dans la navigation et la
  carte autant que possible (`Nav/`, `UI/` nouveaux fichiers, `Data/` nouveau fichier, réglages `nav.*`).

## Approches considérées

1. **Routeur Polestar copié + planificateur Questify (retenue par l'utilisateur).** Les données de
   transport viennent du route builder (`tools/routebuilder/transport.lua`, `data/TaxiNodes.csv`,
   `data/TaxiPath.csv`). Un générateur en tire `Questify/Data/Travel.lua`, et un Dijkstra en jeu
   reprend le modèle de `sim.route`. Le guide suit le même modèle que les routes calculées. Pas de
   code GPL-3.0-only, environ 1 500 lignes à écrire.
2. Tout Polestar copié (routeur, `Travel.lua`, `Transit.lua`, `Walk.lua`, flèche, calques) :
   environ 9 000 lignes GPL-3.0-only, liées au `ns` de Polestar, avec un modèle différent du nôtre.
   Écartée.
3. Routeur seul, sans planificateur : pas d'icône ni de légende par trajet. Écartée.

Source du routeur : Polestar_Nav plutôt que SPF 1.37. SPF a des cartes moins fines (8 yd contre
4,17 yd), est lié à ForeverCore et n'a pas de coût par faction (villes hostiles évitées).

## Décisions de l'utilisateur

Ajouts du 2026-11-16, approuvés par l'utilisateur via la session parente : style « sûr », vitesse
de monture, budget mémoire et processeur (objectifs 7 à 9).

- Routeur : copie à l'identique de `Polestar_Nav`, `Polestar_Nav_EK` et `Polestar_Nav_Kalimdor`
  (version 0.3.7.2), renommés pour Questify.
- Planificateur : celui de Questify (approche 1).
- Fournisseurs gardés en option : WaypointUI (affichage), SPF, TomTom et le repère natif du jeu.
- Ligne de route : style au choix du joueur, pointillés par défaut.
- Guidage tout automatique par défaut.

## Conception

### 1. Routeur (`Questify_Nav`, `Questify_Nav_EK`, `Questify_Nav_Kalimdor`)

- Trois dossiers d'addon à la racine du dépôt, à côté de `Questify/`, tous en `LoadOnDemand`.
  `Questify_Nav` dépend de `Questify` ; `_EK` et `_Kalimdor` dépendent de `Questify_Nav`.
- Fichiers copiés à l'octet près, sauf ces renommages mécaniques, notés dans `CREDITS.md` :
  - globale de données `PolestarPathData` → `QuestifyPathData` ;
  - globale exportée `Polestar_NavEngine` → `Questify_NavEngine` ;
  - noms des parties chargées à la demande `Polestar_Nav_EK` / `_Kalimdor` → `Questify_Nav_EK` /
    `_Kalimdor` (champ `part` des cartes et `EnsurePart`) ;
  - autres globales exportées, pour ne jamais entrer en conflit avec Polestar installé :
    `Polestar_NavCosts` → `Questify_NavCosts`, `PolestarNavChokepoints` → `QuestifyNavChokepoints`
    (toutes les globales `Polestar*` du code copié, listées par un contrôle `grep`) ;
  - TOC réécrits (titre, notes, auteur « Questify ; router: Polestar, from Shortest Path Forever »).
- `PACK.json` est gardé, avec un script de contrôle qui vérifie les sha256 après les renommages
  (les sommes changent : on les recalcule et on note l'origine).
- `CREDITS.md` de Questify_Nav : Polestar (fitzforge/polestar, version 0.3.7.2), Cillian Berragan
  (SPF v1.16.0, b1ad5bd), les cartes de Leffe, la licence GPL-3.0-or-later.
- API utilisée : `Find(map, from, to, callback, opts)`, `FindCost`, `Cancel`, `Busy`,
  `Available(map)`, `Sight`. Points dans le repère de `UnitPosition` (x nord, y ouest).
  `opts.profile` = faction du joueur, pour éviter les villes hostiles.
- `tools/package.sh` zippe les quatre dossiers ; les TOC sont contrôlés de la même façon.

### 2. Pont de marche (`Questify/Nav/Walk.lua`, nouveau)

- Charge `Questify_Nav` puis la partie du continent courant à la première demande
  (`C_AddOns.LoadAddOn`). Sans cartes, ou si l'API de décodage manque, la flèche pointe en ligne
  droite et le statut le dit (`/qf check`).
- Conversion entre les coordonnées carte (uiMapID, 0-100) et le repère monde, via HereBeDragons
  (déjà embarqué).
- Recalcule la marche quand le joueur s'écarte du chemin ou quand la cible change. Le nombre de
  recalculs est limité (au plus un par seconde, comme la minuterie actuelle des grottes).
- Remplace la logique « grotte » quand le routeur a le niveau souterrain. Sinon, `Nav/Caves.lua`
  reste en premier, comme aujourd'hui.

### 2 bis. Style de trajet (`nav.routeStyle`)

- Valeurs : `safe` (défaut), `fastest`, `roads`. Le routeur de Polestar connaît `fastest`,
  `balanced` et `roads` (`Routing/Costs.lua`) ; `safe` = `balanced` + `profile` (faction du joueur :
  villes hostiles évitées) + `danger` (table `{ [uiMapID] = multiplicateur }`).
- Table de danger : niveau minimal de chaque zone (`Data/Travel.lua`, champ `zoneLevels`, tiré des
  chapitres du route builder). Écart d'au moins 5 niveaux au-dessus du personnage : ×2 ; au moins 10 :
  ×4. Les zones de départ et d'arrivée n'entrent jamais dans la table (sinon on ne pourrait pas y aller).
- `fastest` et `roads` passent aussi `profile` (une ville hostile reste plus chère à traverser), sans `danger`.
- Avertissement : quand le chemin retenu entre dans une ville hostile (`job.hubs` non vide) ou dans
  une zone de la table de danger, la flèche et le suivi l'affichent (« Ville hostile : Orgrimmar »,
  « Zone de niveau 45+ »). Une fois par trajet, pas de message répété.

### 3. Planificateur (`Questify/Nav/Travel.lua` + `Questify/Data/Travel.lua`)

- `Data/Travel.lua` est généré par `tools/routebuilder/gen_travel.lua` (nouveau) à partir de
  `transport.lua` et des CSV des vols : maîtres de vol (nœud, position, faction), temps de vol entre
  nœuds voisins, liaisons (bateau, zeppelin, tram, portail) avec quai de départ, d'arrivée et durée,
  et régions de marche.
- `Travel.lua` : Dijkstra sur le joueur, la cible, les maîtres de vol connus
  (`Q.Taxi:Nodes()` / `GetTaxi…` appris), les quais et l'auberge liée (pierre prête,
  `Q.Hearth:Remaining()`). Coûts = ceux de `sim.route` (`WALK`, `FLY_PENALTY`, `HEARTH_CAST +
  HEARTH_PENALTY`). Les trajets à pied du plan sont ensuite affinés par le routeur.
- Vitesse : à pied 7 yd/s (`WALK` du route builder). Monture : ×1,6 (60 %) quand le personnage a
  la monte apprentie (compétence Monte ≥ 75), ×2,0 (100 %) avec la monte compagnon (≥ 150). En jeu,
  la compétence est lue (`GetSkillLineInfo`) ; à défaut, aucune monture n'est supposée. Dans le route
  builder, le personnage simulé l'achète au niveau 40 (×1,6) et à 60 (×2,0), avec son coût en temps
  (trajet jusqu'au maître de monte non compté, achat supposé en ville). Les marches du chapitre
  après le niveau 40 vont plus vite : les routes 40-60 sont régénérées et le gain mesuré.
- Résultat : une liste de trajets `{ kind = "walk"|"fly"|"tram"|"boat"|"zeppelin"|"portal"|"hearth",
  from, to, seconds, caption }`. Chaque trajet a une icône (atlas ou icône du jeu, sans fichier
  ajouté si possible) et une légende localisée, par exemple « Vol vers Hurlevent » ou « Bateau
  pour Auberdine ».
- Le planificateur optimise toujours, quelle que soit l'étape du guide : il prend le trajet le plus
  rapide avec ce que le personnage a débloqué (points de vol appris, transports de sa faction,
  pierre prête et son auberge liée). Décision de l'utilisateur.
- Il ne propose jamais un moyen absent : point de vol non appris (il peut y marcher, l'apprendre
  et s'envoler, comme `sim.route`), transport d'une autre faction, pierre en recharge.
- Les étapes du guide restent des cibles : une étape « apprendre le point de vol » mène toujours au
  maître de vol, donc les points de vol du guide sont appris.

### 3 bis. Budget mémoire et processeur

- Le routeur de Polestar découpe ses calculs par image (`Routing/PathJobs.lua`) et plafonne la
  mémoire décodée (`API.lua` : 8 Mo de grilles, 16 Mo de graphe pendant un calcul, 1 Mo au repos).
  On garde ces plafonds et le découpage.
- Budget : au plus **4 ms** de calcul de routeur par image (moyenne) et aucune image au-delà de
  **16 ms** due à Questify ; mémoire de Questify et Questify_Nav au repos ≤ **30 Mo** après un trajet
  sur un continent, ≤ **45 Mo** pendant un calcul.
- Mesure : commande `/qf navperf` qui affiche, depuis la dernière remise à zéro, la pire image et la
  moyenne passées dans le routeur et le pont (`debugprofilestop`), la mémoire de chaque addon
  (`UpdateAddOnMemoryUsage`, `GetAddOnMemoryUsage`) et le nombre de calculs. Résultats en jeu notés
  dans le README de `Questify_Nav`.
- Le pont ne relance jamais plus d'un calcul par seconde, annule le précédent et ne calcule rien en
  combat si le routeur le refuse.

### 4. Affichage

- **Flèche** (`Questify/UI/Arrow.lua`, nouveau) : tourne vers le prochain virage, avec la distance,
  le temps restant et la légende du trajet en cours avec son icône. Déplaçable à la souris, avec
  l'option « Verrouiller la flèche » (`nav.arrowLocked`). Position enregistrée dans le profil.
  Couleurs lues dans `Q.Themes` (rôles existants : `title` pour l'accent, `body`, `dim`).
  Si la session `ui-themes` ajoute un rôle d'accent, on le prend.
- **Ligne** (`Questify/UI/RouteLine.lua`, nouveau) : points posés par HereBeDragons-Pins sur la carte
  du monde et la minicarte, le long des virages, et un trait de vol entre maîtres de vol. Styles au
  choix (`nav.lineStyle` : `dots` par défaut, `solid`, `dashes`), couleur du thème.
- **Suivi** : une ligne par trajet sous l'étape courante, avec icône et légende
  (« ✈ Vol vers Hurlevent · 2 min »). Ajout limité dans `UI/Tracker.lua`, à coordonner avec les
  autres sessions.
- **Maquette d'abord** : une maquette HTML (flèche, légende, lignes du suivi, trois styles de ligne)
  est validée avant d'écrire l'interface. L'interface en jeu doit lui correspondre.

### 5. Fournisseurs (`Nav/Navigation.lua`)

- Deux réglages (décision de l'utilisateur) :
  - `nav.router` : `questify` (défaut), `spf` (s'il est installé) ou `none` ;
  - `nav.display` : `arrow` (flèche Questify, défaut), `waypointui`, `tomtom` ou `native`.
- Avec le routeur Questify, la ligne de route est toujours tracée, et l'affichage choisi reçoit le
  prochain virage (la flèche Questify, ou WaypointUI, TomTom, le repère natif). Avec SPF, c'est SPF
  qui calcule et dessine, comme aujourd'hui : ni ligne ni flèche Questify.
- Migration (décision de l'utilisateur) : `nav.routing = true` (SPF) devient `nav.router = "spf"`.
  `false` ou absent devient `questify` : ce `false` venait de l'assistant chez les joueurs sans SPF.
  `nav.display = "native"` (ancien défaut) devient `arrow`. Les autres valeurs d'affichage restent.
- L'assistant et les options exposent le choix ; `/qf check` dit quel routeur est actif et si les
  cartes sont chargées.

### 6. Pierre de foyer (`tools/routebuilder/sim.lua`)

- Aujourd'hui, `planHearth` choisit 0, 1 ou 2 liaisons par chapitre, en ne voyant que l'entrée du
  chapitre suivant (`opts.nextEntry`).
- Nouveau : les liaisons sont choisies avec la suite de la route en vue. Le coût d'un plan inclut
  les retours possibles dans les N chapitres suivants (au moins jusqu'au prochain changement de hub),
  avec l'auberge liée en entrée de chacun. Méthode à fixer dans le plan : programmation dynamique sur
  les chapitres (état = auberge liée) ou anticipation fixe. Mesure du temps total de la route sans
  `--jit`, avant et après, par faction ; le gain est rapporté tel quel, même nul.
- Les étapes `sethearth` émises suivent le nouveau plan ; `tools/validate_guides.lua` reste vert.

### 7. Tests

- `luajit tests/run.lua` : planificateur (Dijkstra, vol contre marche, pierre prête ou non, point
  de vol non appris, transport d'une autre faction), conversion de coordonnées, choix et migration des fournisseurs, réglages de
  la flèche et de la ligne. Le routeur est remplacé par un faux moteur : les cartes zlib ne se
  décodent pas sous LuaJIT.
- `tools/routebuilder/tests` : nouveau plan de liaisons, générateur de `Data/Travel.lua`.
- `luajit tools/validate_guides.lua` vert ; `tools/check_syntax.sh` sur les quatre dossiers.

## Laissé au constructeur

- L'icône exacte de chaque mode, dans les atlas déjà présents dans le client Forever.
- Le seuil d'écart au chemin qui relance un calcul.
- La méthode exacte des liaisons de la pierre de foyer, si le gain mesuré la justifie.
- Le découpage des lots de commits.
