# Mode « Donjons » : à vérifier en jeu

Le client Forever n'est pas simulable : rien ci-dessous n'a été vu en jeu. Les points propres à un échelon
sont aussi listés dans [ECHELLE.md](ECHELLE.md).

## Données

- **Plages des ailes** (Monastère écarlate 28-38 / 29-39 / 32-42 / 35-45, Hache-Tripes 55-60 / 56-60 / 56-60) :
  plages usuelles de Classic, pas des données de QuestieDB.
- **Quêtes par aile** : QuestieDB ne connaît que le donjon entier. La répartition vient des cibles des quêtes
  (boss, objets) et reste à confirmer, surtout :
  - Past Due (96800, Forever) : livre « The Lost Magic of the Runemasters », placé en Bibliothèque ;
  - Anthion's Old Friend (8948) : placée à Hache-Tripes Nord ;
  - Stratholme : The Restless Souls, Houses of the Holy et The Flesh Does Not Lie se font des deux côtés.
- **Aucune quête Alliance** pour le Donjon d'Ombrecroc, le Cimetière et l'Armurerie du Monastère : zéro étoile.
  Ces échelons restent cochés par défaut, comme demandé ; à décider s'ils doivent l'être.
- **Plages des donjons de Forever** (Hall of Thanes 13-18, Excavation Site 24-29, City of Dalaran 28-33) :
  plages annoncées, alors que leurs quêtes sont de niveau 15-16, 28-31 et 33.
- **XP estimées** (« ~ ») : les nouvelles quêtes de Forever sans valeur QuestXP.
- **XP d'une instance** (monstres) : non mesurée. À relever en jeu pour chaque échelon afin de caler les
  niveaux d'entrée et les étapes de rattrapage (`below`).

## Accès

- Cavernes des Lamentations : accès Alliance par Ashenvale puis les Tarides à pied. Les quatre quêtes de
  ville se prennent à Ratchet et à l'entrée de la caverne.
- Donjon d'Ombrecroc : long trajet depuis Southshore, sans quête.
- Monastère écarlate : trajet depuis Southshore par les monts d'Alterac.
- The Hall of Thanes pour les Humains et les Elfes de la nuit : la suite d'accès (96391, 96392) est à
  Dun Morogh.
- Bateau d'Auberdine à Stormwind : supposé par les guides actuels (A_01), à confirmer au niveau 15.
- Zones de Forever (Riverglades, Shen'dralas, Darkspear Islands, Mount Hyjal) : accès et points de vol.

## Routes

- **Quêtes de donjon hors route** : la route ne prend qu'une partie des quêtes de chaque donjon (tableau de
  [routes/ROUTES.md](routes/ROUTES.md)). Les autres ont un donneur hors des zones traversées, une suite
  trop longue, ou ne s'ouvrent qu'après un premier passage dans l'instance. La fenêtre Donjons du journal
  permet toujours de les ajouter.
- **Bateau de Ratchet à Baie-du-Butin au niveau 21** (début de `AD_05`, alternative des trois premiers
  donjons) : le simulateur prend le chemin le plus court vers les Carmines, à travers Strangleronce. À jouer
  pour voir si c'est acceptable à ce niveau.
- **Farm de niveau** : comme dans les guides habituels, le simulateur complète par du farm quand une zone ne
  suffit pas. Chapitres les plus touchés : Féralas (`AD_22`), gorge des Vents brûlants et Terres foudroyées
  (`AD_25`), cratère d'Un'Goro (`AD_27`). Ce farm disparaît pour qui fait les donjons (étape « niveau N »
  déjà atteinte).
- **Niveau à l'entrée** : la route arrive aux Lamentations au niveau 21 (entrée conseillée 19), à Ombrecroc
  au niveau 30 (27), à la Bibliothèque et à l'Armurerie au niveau 37 (31 et 34), à Stratholme au niveau 60 pour qui a tout contourné.
- **Monastère écarlate** : les quatre ailes sont faites en deux passages pour limiter les trajets : le
  Cimetière en fin de Hautebrande (niveau 30), puis la Bibliothèque, l'Armurerie et la Cathédrale en fin
  d'Arathi (niveau 37). Voir dans ROUTES.md lesquelles de ses quêtes la route prend.
- **Chapitre d'alternative passé** : ses points de vol ne sont pas découverts ; à vérifier que les étapes
  de vol des chapitres suivants s'en accommodent.
- **Rendus déplacés** : un rendu de quête de donjon dont le PNJ est loin est repoussé au prochain chapitre
  qui passe par sa zone (nombre dans ROUTES.md) ; les autres rendus lointains restent juste après l'instance.
- **Riverglades** (`AD_19`) : point d'entrée calculé (PNJ qui donne le plus de quêtes), accès à vérifier.

## Interface

- Fenêtre `/qf donjons` : gabarit `ButtonFrameTemplate`, cases `UICheckButtonTemplate`, étoiles
  (`tradeskills-star`), hauteur avec 26 lignes sur un petit écran.
- Option « Mode Donjons » visible seulement pour un personnage de l'Alliance, une fois les routes livrées.

## Outillage

- Les guides Alliance du dépôt ne se régénèrent pas à l'identique depuis QuestieDB `c7ccd23e` avec le
  générateur du dépôt (A_03 : 131 étapes obtenues, 151 livrées ; 16 chapitres diffèrent). Cause non trouvée.
  Tant qu'elle ne l'est pas, ne pas relancer `build.lua` sans `--out` vers un autre dossier.
- Trois tests du générateur échouent sans rapport avec ce mode (`classquests_*` de `test_review.lua`).
