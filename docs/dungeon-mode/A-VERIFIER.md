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

## Interface

- Fenêtre `/qf donjons` : gabarit `ButtonFrameTemplate`, cases `UICheckButtonTemplate`, étoiles
  (`tradeskills-star`), hauteur avec 26 lignes sur un petit écran.
- Option « Mode Donjons » visible seulement pour un personnage de l'Alliance, une fois les routes livrées.

## Outillage

- Les guides Alliance du dépôt ne se régénèrent pas à l'identique depuis QuestieDB `c7ccd23e` avec le
  générateur du dépôt (A_03 : 131 étapes obtenues, 151 livrées ; 16 chapitres diffèrent). Cause non trouvée.
  Tant qu'elle ne l'est pas, ne pas relancer `build.lua` sans `--out` vers un autre dossier.
- Trois tests du générateur échouent sans rapport avec ce mode (`classquests_*` de `test_review.lua`).
