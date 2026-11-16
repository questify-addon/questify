# Routeur intégré : plan de mise en œuvre

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Questify guide seul sur de vrais chemins (routeur Polestar_Nav copié, planificateur de voyage
Questify, flèche, ligne de route), avec les liaisons de la pierre de foyer choisies sur toute la route.

**Architecture:** trois addons LoadOnDemand copiés de Polestar_Nav (routeur + cartes, globales
renommées). Questify y ajoute un pont de marche (`Nav/Walk.lua`), un planificateur Dijkstra
(`Nav/Travel.lua`) sur des données générées par le route builder (`Data/Travel.lua`), une flèche
(`UI/Arrow.lua`) et une ligne de route (`UI/RouteLine.lua`, épingles HereBeDragons). `Nav/Navigation.lua`
gagne le fournisseur `questify` et deux réglages `nav.router` / `nav.display`.

**Tech Stack:** Lua 5.1 (client WoW Forever 1.60.1, Interface 16001), LuaJIT pour les tests et le
route builder, HereBeDragons-2.0 et HereBeDragons-Pins-2.0 (déjà dans `Questify/Libs`).

**Spec:** `docs/superpowers/specs/2026-11-16-routeur-integre-design.md`

## Global Constraints

- Commits sous l'auteur `questify-addon` ; jamais de nom ni de courriel réels dans les commits, fichiers, PR.
- `git -c core.fileMode=false` pour `add`, `commit`, `rm`, `pull` dans ce worktree.
- Aucune couleur codée en dur dans l'interface : couleurs lues par `Q.Themes:TextColor(role)`
  (rôles `title` = accent, `body`, `dim`) ; un rôle `accent` est pris s'il existe (`Q.Themes:Current().text.accent`).
- Le code copié de Polestar_Nav garde ses en-têtes de copyright tels quels ; aucun fichier GPL-3.0-only
  de Polestar n'est copié.
- Aucune globale `Polestar*` dans les dossiers `Questify_Nav*` (contrôle `grep` à l'étape 1).
- Toute chaîne visible passe par `Q.L` avec ses clés en enUS et frFR (`Questify/Locales/StringsNav.lua`).
- Route builder sans `--jit`. Maquette validée avant toute interface en jeu ; l'interface la suit.
- Le lien `AddOns/Questify` du jeu n'est pas modifié sans l'accord de l'utilisateur.
- Garder les changements hors `Nav/`, `UI/Arrow.lua`, `UI/RouteLine.lua`, `Data/Travel.lua` au minimum
  (sept autres sessions touchent l'interface).

## Review Focus

1. Polestar ou SPF installé en même temps : aucune globale ni addon partagé, les deux routeurs tournent.
2. Cartes absentes ou décodage impossible (`C_EncodingUtil` manquant) : flèche en ligne droite, aucun
   message d'erreur Lua, `/qf check` le dit.
3. Combat, écran de chargement, changement de continent en plein calcul : calcul annulé puis relancé,
   rien ne reste dessiné à tort.
4. Personnage sans aucun point de vol connu, pierre en recharge ou liée à une auberge inconnue : plan
   à pied, jamais de vol ni de pierre proposés.
5. Cible sur l'autre continent : plan bateau / zeppelin, la ligne n'est tracée que sur la carte affichée.

Chaque ligne a son test dans la tâche qui possède le code (tâches 1, 4, 5).

---

### Task 0: Maquette HTML

**Files:**
- Create: `docs/superpowers/specs/2026-11-16-routeur-integre-maquette.html`

- [ ] **Step 1:** Maquette en une page, icônes et atlas réels du jeu (comme `2026-11-04-builds-talents-maquette.html`) :
  la flèche (flèche, distance, temps restant, icône et légende du trajet en cours, cadenas), le suivi avec
  une ligne par trajet sous l'étape (« ✈ Vol vers Hurlevent · 2 min »), la ligne de route en trois styles
  (`dots`, `solid`, `dashes`) sur une carte et une minicarte, et le bloc d'options (routeur, affichage,
  style de ligne, verrouiller la flèche). Deux thèmes montrés : `parchment` et `dark`.
- [ ] **Step 2:** La montrer à l'utilisateur et attendre son accord. Les tâches 6 à 8 suivent la maquette validée.
- [ ] **Step 3:** Commit `docs(nav): maquette du guidage intégré`.

### Task 1: Copie du routeur (Questify_Nav, _EK, _Kalimdor)

**Files:**
- Create: `tools/nav/import_polestar_nav.sh` (copie + renommages, rejouable sur une nouvelle version)
- Create: `tools/nav/check_nav.lua` (contrôles)
- Create: `Questify_Nav/`, `Questify_Nav_EK/`, `Questify_Nav_Kalimdor/` (générés), `Questify_Nav/CREDITS.md`
- Modify: `tools/package.sh` (quatre dossiers dans le zip), `tools/check_syntax.sh` (scanne `Questify_Nav`)
- Test: `tests/test_navpack.lua`

**Interfaces:**
- Produces: globale `Questify_NavEngine` (= `Path` de Polestar : `Find(map, from, to, cb, opts)`,
  `FindCost`, `Cancel(job)`, `Busy()`, `Available(map)`, `Sight(...)`) ; données `QuestifyPathData[map]`
  avec `part = "Questify_Nav_EK"` / `"Questify_Nav_Kalimdor"` ; `Questify_NavCosts` ; `QuestifyNavChokepoints`.
  Points `{ x, y, z? }` dans le repère de `UnitPosition` ; `map` = 0, 1 ou 2991. Callback
  `cb(points, cost, job)` (points `{ map, x, y, z }`) ou `cb(nil, reason, job)`, `reason` ∈
  `nodata|outside|offmesh|unreachable|error`. `opts = { profile = "Alliance"|"Horde", style = "fastest"|"balanced"|"roads" }`.

- [ ] **Step 1: Test qui échoue** `tests/test_navpack.lua` :
  - `no_polestar_globals` : aucun fichier `Questify_Nav*/**/*.lua` ne contient `PolestarPathData`,
    `Polestar_NavEngine`, `Polestar_NavCosts`, `PolestarNavChokepoints`, `"Polestar_Nav_EK"`, `"Polestar_Nav_Kalimdor"`
    (lecture binaire).
  - `tocs` : `Questify_Nav.toc` a `## LoadOnDemand: 1`, `## Dependencies: Questify`, `## Interface: 16001`,
    `## X-License: GPL-3.0-or-later` ; `_EK` et `_Kalimdor` dépendent de `Questify_Nav` ; chaque fichier
    listé existe.
  - `parts_complete` : nombre de fichiers `Nav0_*.lua` = 41, `Nav1_*.lua` = 51 (comptés dans la source 0.3.7.2).
  - `credits` : `Questify_Nav/CREDITS.md` cite Polestar 0.3.7.2, Cillian Berragan, SPF v1.16.0 `b1ad5bd`, Leffe.
- [ ] **Step 2:** `luajit tests/run.lua navpack` → FAIL (dossiers absents).
- [ ] **Step 3:** `import_polestar_nav.sh <source AddOns>` : copie les trois dossiers, renomme
  (`LC_ALL=C perl -pi` octet à octet sur les jetons exacts ci-dessus), réécrit les trois TOC (titre
  « Questify Nav », notes en/fr, auteur « Questify; router: Polestar, from Shortest Path Forever by
  Cillian Berragan; maps: Leffe »), recalcule `PACK.json` (sha256) en notant l'origine, copie `LICENSE`.
  Il compte chaque jeton avant/après et échoue si un remplacement touche une ligne hors code
  (nombre d'occurrences différent du nombre attendu).
- [ ] **Step 4:** `CREDITS.md` adapté de celui de Polestar_Nav (origine, permission de Cillian
  Berragan, renommages faits par Questify).
- [ ] **Step 5:** `package.sh` : stage et zippe `Questify_Nav*` à côté de `Questify/`, `checkZip`
  accepte ces racines et exige leurs TOC.
- [ ] **Step 6:** `luajit tests/run.lua navpack` → PASS ; `tools/check_syntax.sh` → aucune sortie.
- [ ] **Step 7:** Commit `feat(nav): routeur de marche Polestar_Nav embarqué (Questify_Nav)`.

### Task 2: Données de voyage générées

**Files:**
- Create: `tools/routebuilder/gen_travel.lua`, `Questify/Data/Travel.lua` (généré), ajouté au TOC après `Data/Caves.lua`
- Modify: `Questify/Questify.toc`, `Questify/Questify_Camelot.toc`
- Test: `tools/routebuilder/tests/test_gen_travel.lua`

**Interfaces:**
- Consumes: `transport.linksFor(faction, race)`, `transport.REGION`, `world` (taxi nodes, `W.taxi.edges`), `sim.hearthInns` (QuestieDB).
- Produces: `Q.TravelData = {`
  `taxi = { [nodeId] = { m, x, y, side } }` (`side` = `"A"|"H"|"N"`),
  `edges = { [a] = { [b] = seconds } }`,
  `links = { { kind = "boat"|"zeppelin"|"tram"|"portal", from = { m, x, y }, to = { m, x, y }, seconds, side, races = { ... } | nil, name } }`,
  `regions = { [uiMapID] = "EK_N"|"EK_S"|"KAL"|"TELD"|... }`,
  `inns = { { m, x, y, side, name } } }`. Coordonnées en 0-100.

- [ ] **Step 1: Test qui échoue** : `taxi` contient Stormwind et Orgrimmar avec le bon côté ;
  `edges` symétriques et positives ; le tram Stormwind ↔ Ironforge et le zeppelin Orgrimmar ↔ Undercity
  sont dans `links` avec le bon `kind` ; chaque `regions[m]` existe pour les uiMapID de `transport.REGION` ;
  sortie identique sur deux exécutions (déterministe, tri par id).
- [ ] **Step 2:** `luajit tools/routebuilder/tests/run.lua gen_travel` → FAIL.
- [ ] **Step 3:** `gen_travel.lua [--db PATH] [--out Questify/Data/Travel.lua] [--date YYYY-MM-DD]` ; en-tête
  « Généré par … ne pas modifier ».
- [ ] **Step 4:** Générer, lancer le test → PASS ; `luajit tests/run.lua boot` → PASS (le fichier charge).
- [ ] **Step 5:** Commit `feat(nav): données de voyage générées depuis le route builder`.

### Task 3: Réglages, migration, fournisseurs

**Files:**
- Modify: `Questify/Core/Settings.lua` (défauts), `Questify/Core/Profiles.lua` (migration dans `normalizeProfile`),
  `Questify/Core/OptionsSchema.lua`, `Questify/UI/Wizard.lua:614-626,758-759`, `Questify/Core/Diagnostics.lua:190-200,298`,
  `Questify/Nav/Navigation.lua`, `Questify/Locales/StringsNav.lua`
- Test: `tests/test_nav.lua` (mis à jour), `tests/test_options.lua`, `tests/test_wizard.lua`

**Interfaces:**
- Produces: défauts `nav = { router = "questify", display = "arrow", lineStyle = "dots", arrowLocked = false,
  arrowPos = nil }` ; `Nav:Detect()` gagne `questify = Questify_Nav installable` (`C_AddOns.GetAddOnInfo("Questify_Nav")`) ;
  `Nav:Active() -> router ("questify"|"shortestpath"|nil), display ("arrow"|"waypointui"|"tomtom"|"native")` ;
  message `Q:Fire("NAV_TARGET", target|nil)` à chaque pose ou retrait de cible (la tâche 5 l'écoute).
- Migration (une fois par profil, marqueur `nav.migrated = 1`) : `routing == true` → `router = "spf"` ;
  `routing == false`/absent → `router = "questify"` ; `display == "native"` ou absent → `"arrow"` ; `routing` retiré.

- [ ] **Step 1: Tests qui échouent** (`test_nav.lua`) :
  - `questify_by_default` : sans réglage, `Nav:Active()` → `"questify", "arrow"` ; aucun `C_Map.SetUserWaypoint` ; `NAV_TARGET` émis avec la cible de l'étape.
  - `migrate_spf_profile` : profil `{ nav = { routing = true, display = "tomtom" } }` → `router = "spf"`, `display = "tomtom"`.
  - `migrate_wizard_false` : `{ nav = { routing = false, display = "native" } }` → `"questify"`, `"arrow"`.
  - `spf_router_unchanged` : les tests SPF existants passent avec `["nav.router"] = "spf"` au lieu de `["nav.routing"] = true`.
  - `questify_with_tomtom_display` : `router = "questify"`, `display = "tomtom"` → `TomTom:AddWaypoint` reçoit la cible (la tâche 5 y mettra le prochain virage).
  - `router_none` : `router = "none"` → comportement actuel sans routage (affichage seul).
- [ ] **Step 2:** `luajit tests/run.lua nav` → FAIL.
- [ ] **Step 3:** Implémenter : fournisseur `questify` (pose la cible et émet `NAV_TARGET` ; l'affichage
  `arrow` ne pose rien d'autre, les autres affichages reçoivent la cible via les fournisseurs existants) ;
  options `nav.router` (radio : questify / spf grisé si absent / none), `nav.display` (arrow / waypointui / tomtom / native),
  `nav.lineStyle` (dots / solid / dashes), `nav.arrowLocked` (toggle) ; assistant et diagnostics sur `nav.router`.
- [ ] **Step 4:** `luajit tests/run.lua` → PASS (toute la suite).
- [ ] **Step 5:** Commit `feat(nav): fournisseur questify par défaut, réglages routeur et affichage`.

### Task 4: Planificateur de voyage

**Files:**
- Create: `Questify/Nav/Travel.lua` (TOC après `Nav/Caves.lua`)
- Modify: `Questify/Engine/Hearth.lua` (mémorise l'auberge liée), `Questify/Locales/StringsNav.lua`
- Test: `tests/test_travel.lua`

**Interfaces:**
- Consumes: `Q.TravelData` (tâche 2), `Q.Maps:WorldPos/Distance`, `Q.Hearth:Remaining()`.
- Produces: `Q.Travel:Plan(from, to) -> legs | nil` où `from`, `to` = `{ mapId, x, y }` (0-100) et
  `legs = { { kind = "walk"|"fly"|"boat"|"zeppelin"|"tram"|"portal"|"hearth", from = {mapId,x,y}, to = {mapId,x,y},
  seconds, caption, icon } }` ; `Q.Travel:KnownTaxi() -> { [nodeId] = true }` ;
  `Q.Hearth:BindPos() -> mapId, x, y | nil`.
- Coûts (copiés de `tools/routebuilder/sim.lua`, constantes `C`) : marche `yards / WALK`, vol `edges + FLY_PENALTY`,
  pierre `HEARTH_CAST + HEARTH_PENALTY` (temps affiché `HEARTH_CAST + HEARTH_LOAD`), liaison `seconds`.
  Noter les valeurs exactes en tête de `Travel.lua` avec le renvoi à `sim.lua`.
- Points de vol connus : `C_TaxiMap.GetTaxiNodesForMap(continent)` hors `isUndiscovered`, mis en cache et
  rafraîchis à `TAXIMAP_OPENED` et `UI_INFO_MESSAGE`. Un point de vol non appris peut être rejoint à pied,
  appris puis quitté en vol, jamais rejoint en vol.
- Auberge liée : position du joueur enregistrée à `HEARTHSTONE_BOUND` dans `Q.char.hearthBind`, sinon
  `GetBindLocation()` comparé aux `inns` ; inconnue → pas de pierre.

- [ ] **Step 1: Tests qui échouent** :
  - `walk_only_close` : deux points à 300 yd → une étape `walk`.
  - `fly_when_known` : Elwynn → Westfall avec Stormwind et Sentinel Hill connus → `walk, fly, walk`, légende « Vol vers Sentinel Hill » (frFR « Vol vers … »).
  - `no_unknown_flight` : même trajet sans Sentinel Hill connu → aucun `fly` qui y arrive.
  - `hearth_ready` / `hearth_cooldown` : pierre prête et auberge à destination → étape `hearth` ; `Remaining() > 0` → pas de `hearth`.
  - `other_faction_link` : un Horde ne prend pas le tram ; un Alliance ne prend pas le zeppelin.
  - `other_continent` : Stormwind → Darnassus (Alliance) → contient `boat`.
  - `unknown_bind` (Review Focus 4) : `GetBindLocation` inconnu des `inns` et pas de `hearthBind` → pas de `hearth`.
- [ ] **Step 2:** `luajit tests/run.lua travel` → FAIL.
- [ ] **Step 3:** Implémenter `Travel:Plan` : Dijkstra comme `sim.route` (nœuds : départ, arrivée, points de vol
  connus du continent, quais, auberge si pierre prête) ; régions de `regions` pour savoir si deux points se
  rejoignent à pied ; icône par mode (atlas du client, une table `ICONS` en tête de fichier).
- [ ] **Step 4:** `luajit tests/run.lua` → PASS.
- [ ] **Step 5:** Commit `feat(nav): planificateur de voyage (vols, bateaux, zeppelins, tram, portails, pierre)`.

### Task 5: Pont de marche

**Files:**
- Create: `Questify/Nav/Walk.lua` (TOC après `Nav/Travel.lua`)
- Test: `tests/test_walk.lua` (faux `Questify_NavEngine`)

**Interfaces:**
- Consumes: `Questify_NavEngine` (tâche 1), `Q.Travel:Plan` (tâche 4), message `NAV_TARGET` (tâche 3).
- Produces: `Q.Walk:Route() -> route | nil`, `route = { legs = <legs de Travel>, path = { { instance, x, y } }`
  (monde, marche en cours), `nextPoint = { instance, x, y }`, `leg = index du trajet en cours`, `straight = bool }` ;
  message `Q:Fire("NAV_ROUTE", route|nil)` à chaque changement ; `Q.Walk:Status() -> { loaded, maps = { [0]=bool, [1]=bool }, reason }`
  (lu par `/qf check`).
- Règles : charge `Questify_Nav` puis la partie du continent (`C_AddOns.LoadAddOn`) à la première route ;
  relance si la cible change, si le joueur s'écarte de plus de `OFF_PATH = 25` yd du chemin, ou à la fin d'un
  trajet ; au plus un calcul par seconde ; `Cancel` du calcul en cours avant d'en lancer un ; rien en combat
  si le moteur le refuse (relance à `COMBAT_ENDED`) ; `opts = { profile = faction du joueur, style = "balanced" }`.
  `nextPoint` = premier point du chemin à plus de `LOOKAHEAD = 12` yd. Grotte connue (`Nav/Caves.lua`) : on
  garde ses arrêts en `via`, comme aujourd'hui.

- [ ] **Step 1: Tests qui échouent** :
  - `loads_parts_on_demand` : première route en Royaumes de l'Est → `LoadAddOn("Questify_Nav")` puis `LoadAddOn("Questify_Nav_EK")`, jamais `_Kalimdor`.
  - `follows_path` : faux moteur renvoyant 3 points → `nextPoint` = le 2ᵉ quand le joueur est sur le 1ᵉʳ.
  - `off_path_recompute` : joueur à 30 yd du chemin → nouveau `Find` ; à 10 yd → aucun.
  - `throttle` : dix changements de cible en 0,5 s → un seul `Find` en cours, l'ancien annulé.
  - `no_data_straight` (Review Focus 2) : `LoadAddOn` échoue ou `Available(0) == false` → `route.straight = true`, `nextPoint` = cible, aucune erreur dans `Mock.errors`.
  - `loading_screen_cancel` (Review Focus 3) : `PLAYER_ENTERING_WORLD` pendant un calcul → `Cancel` appelé, `NAV_ROUTE` nil puis nouvelle route.
- [ ] **Step 2:** `luajit tests/run.lua walk` → FAIL.
- [ ] **Step 3:** Implémenter `Walk.lua` (repère monde par `Q.Maps:WorldPos`, instance = continent renvoyé).
- [ ] **Step 4:** `luajit tests/run.lua` → PASS.
- [ ] **Step 5:** Commit `feat(nav): marche sur les chemins du routeur intégré`.

### Task 6: Flèche

**Files:**
- Create: `Questify/UI/Arrow.lua` (TOC après `UI/MapPins.lua`)
- Test: `tests/test_arrow.lua`

**Interfaces:**
- Consumes: `NAV_ROUTE` (tâche 5), réglages `nav.display`, `nav.arrowLocked`, `nav.arrowPos` (tâche 3), `Q.Themes`.
- Produces: `Q.Arrow:Frame()` (pour les tests et `/qf demo`), commande `/qf arrow reset` (position par défaut).
- Visible seulement si `router == "questify"` et `display == "arrow"` et une route existe. Texture
  `Interface\\Minimap\\MinimapArrow` tournée par `SetRotation` toutes les images ; distance, temps restant et
  légende du trajet en cours avec son icône, selon la maquette. Glisser-déposer si non verrouillée ; position
  enregistrée dans `nav.arrowPos = { point, x, y }` ; couleurs par `Q.Themes:TextColor`.

- [ ] **Step 1: Tests qui échouent** : `hidden_without_route`, `shows_leg_caption` (légende « Vol vers Sentinel Hill » et icône du `fly`),
  `drag_saves_position`, `locked_no_drag` (`arrowLocked = true` → `EnableMouse(false)` ou pas de `StartMoving`),
  `theme_colors` (changement de thème → `SetTextColor` reçoit la couleur du rôle), `hidden_with_tomtom_display`.
- [ ] **Step 2:** `luajit tests/run.lua arrow` → FAIL.
- [ ] **Step 3:** Implémenter selon la maquette validée.
- [ ] **Step 4:** `luajit tests/run.lua` → PASS ; comparer à la maquette section par section.
- [ ] **Step 5:** Commit `feat(nav): flèche Questify déplaçable et verrouillable`.

### Task 7: Ligne de route sur la carte et la minicarte

**Files:**
- Create: `Questify/UI/RouteLine.lua` (TOC après `UI/Arrow.lua`)
- Test: `tests/test_routeline.lua` (s'appuie sur `tests/mock_ext_mappins.lua`)

**Interfaces:**
- Consumes: `NAV_ROUTE`, `nav.lineStyle`, `Q.Themes`, HereBeDragons-Pins (`AddWorldMapIconWorld`, `AddMinimapIconWorld`,
  `RemoveAllWorldMapIcons`, `RemoveAllMinimapIcons`, réf `"Questify_RouteLine"`).
- Points posés tous les `SPACING` yd le long de `route.path` (marche) et le long des segments `fly`/`boat`/… :
  `dots` 12 yd, `solid` 4 yd (points serrés qui se touchent), `dashes` 10 yd (tirets orientés par `SetRotation`).
  Au plus `MAX_PINS = 400` sur la carte, `MAX_MINIMAP = 60` sur la minicarte (les plus proches du joueur).
  Les points dépassés par le joueur sont retirés à chaque `NAV_ROUTE`. Pool de textures réutilisées.

- [ ] **Step 1: Tests qui échouent** : `draws_dots`, `style_switch` (passer à `dashes` redessine avec un autre pas),
  `cleared_on_nil_route`, `pin_cap`, `other_continent_only_current` (Review Focus 5 : les points d'une autre instance
  ne sont pas posés sur la minicarte), `not_drawn_with_spf`.
- [ ] **Step 2:** `luajit tests/run.lua routeline` → FAIL.
- [ ] **Step 3:** Implémenter.
- [ ] **Step 4:** `luajit tests/run.lua` → PASS.
- [ ] **Step 5:** Commit `feat(nav): ligne de route sur la carte et la minicarte`.

### Task 8: Trajets dans le suivi

**Files:**
- Modify: `Questify/UI/Tracker.lua:1152` (une ligne : `comfort("Travel", "Lines", entry)` à côté de celle de la pierre), `Questify/Nav/Travel.lua`
- Test: `tests/test_tracker.lua` (un test ajouté)

**Interfaces:**
- Produces: `Q.Travel:Lines(entry) -> { "texte coloré", ... } | nil` : une ligne par trajet non-marche du plan en cours
  (icône `|T…|t`, légende, durée), rien quand le plan est tout à pied ; `Q:Fire("TRACKER_REFRESH")` (ou le message
  que `Hearth:Check` utilise) quand le plan change.

- [ ] **Step 1:** Test `tracker_shows_travel_legs` : route avec un `fly` → la ligne « Vol vers Sentinel Hill · 2 min » apparaît sous l'étape.
- [ ] **Step 2:** FAIL, puis implémenter, puis `luajit tests/run.lua` → PASS.
- [ ] **Step 3:** Commit `feat(nav): trajets du voyage dans le suivi`.

### Task 9: Liaisons de la pierre de foyer sur toute la route

**Files:**
- Modify: `tools/routebuilder/sim.lua` (`planHearth`), `tools/routebuilder/build.lua` (`simulateFaction`), `tools/routebuilder/README.md` (section Binds)
- Test: `tools/routebuilder/tests/test_hearth.lua`

**Interfaces:**
- `sim.planHearth` gagne `fopts.lookahead = { { entry = {m,x,y}, hubs = {...}, tasks = seq } , ... }` : les
  chapitres suivants du parcours (au plus `HEARTH_LOOKAHEAD = 2`), tels que simulés au premier passage.
  Le coût d'un plan = coût du chapitre + pour chaque chapitre suivant, `order.hearthCost` de sa séquence avec
  l'auberge liée en fin de chapitre courant en entrée (sans relier dans ce chapitre-là), + le trajet de fin actuel.
- `build.lua` : premier passage inchangé, qui garde chaque `ordered` ; second passage : `planHearth` rejoué
  avec `lookahead`, liaisons imposées, puis émission des étapes. Variable `ROUTEBUILDER_HEARTH_LOOKAHEAD=0`
  pour revenir à l'ancien calcul (mesure).

- [ ] **Step 1: Test qui échoue** `lookahead_prefers_next_hub` : chapitre fixture avec deux auberges A (proche
  de la fin) et B (hub du chapitre suivant, où le chapitre suivant revient deux fois de loin) ; sans
  lookahead le plan lie A, avec lookahead il lie B.
- [ ] **Step 2:** `luajit tools/routebuilder/tests/run.lua hearth` → FAIL.
- [ ] **Step 3:** Implémenter.
- [ ] **Step 4:** Tests du route builder → PASS.
- [ ] **Step 5:** Mesure, sans `--jit`, au plus 4 en parallèle :
  `ROUTEBUILDER_HEARTH_LOOKAHEAD=0 luajit tools/routebuilder/build.lua --faction Alliance --out <tmp>/before --report <tmp>/before-rep --date 2026-11-16`
  puis la même chose sans la variable vers `<tmp>/after`, pour les deux factions. Comparer la somme des minutes par
  parcours de race. Noter les chiffres dans le README (section Binds), même si le gain est nul.
- [ ] **Step 6:** Si le gain est positif : rebuild dans le worktree (`--date 2026-11-16`), annuler les diffs de
  date seule et le bruit de `ClassQuestData` / `BagQuestData`, `luajit tools/validate_guides.lua` → OK.
  Sinon : garder le code derrière la variable désactivée par défaut, ne pas régénérer les guides.
- [ ] **Step 7:** Commit `feat(routebuilder): liaisons de la pierre choisies avec les chapitres suivants`.

### Task 10: Vérification finale et livraison

- [ ] **Step 1:** `tools/check_syntax.sh`, `luajit tests/run.lua`, `luajit tools/routebuilder/tests/run.lua`,
  `luajit tools/validate_guides.lua` → tout vert ; `tools/package.sh` produit un zip avec les quatre dossiers.
- [ ] **Step 2:** Revue de toute la branche (relecteur neuf).
- [ ] **Step 3:** Demander à l'utilisateur s'il veut tester en jeu : liens `AddOns/Questify_Nav*` et
  repointage de `AddOns/Questify` vers ce worktree, seulement avec son accord.
- [ ] **Step 4:** `git push -u origin claude/nav-router-1110f9`. Pas de publication, pas de fusion dans `main`.
- [ ] **Step 5:** Note de passation dans le dossier partagé des sessions (chiffres de la pierre, fichiers touchés hors `Nav/`).
