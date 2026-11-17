# Captures de la v1 (CurseForge)

Quinze images en anglais, 1920 × 1080, dans l'ordre de la page CurseForge. Pour chacune : ce qu'on capture,
comment le mettre en scène, et le nom du fichier à déposer dans `docs/media/apercus/src/en/captures/`.
Les captures d'écran brutes (plein écran, 2560 × 1440 chez toi) suffisent : je découpe la partie utile, je
l'insère dans le gabarit (`docs/media/apercus/src/en/<nom>.html`) puis je rends l'image finale avec
`sh docs/media/apercus/src/render.sh`.

## Avant de capturer
- Client **en anglais**, interface visible (pas Alt+Z), autres addons d'interface fermés sauf ceux que la
  capture montre (QuestieDB toujours ; Auctionator pour l'image 12).
- Thème Questify (Options > Theme > Questify), taille du texte 100 %, fond « Full ». Pour l'image 14, un
  autre thème (race ou faction) montre la variété.
- Disposition des objectifs « With bars » et détail « Targetable monsters » (Options > Tracker), sauf mention.
- Un personnage autour du niveau 20 à 35 donne les exemples les plus parlants (donjons, talents, routes).
- Hors combat. `/qf demo off` remet tout en place après une scène de démonstration.

## Liste

| # | Fichier | Ce qu'on voit | Mise en scène |
|---|---|---|---|
| 1 | `01-tracker.png` | Le suivi : barre du chapitre, étape « tuer » avec barres d'objectifs, monstres à tuer, XP/h et avance, boutons de l'en-tête (dont pièces d'or). | En pleine nature sur une étape « tuer », ou `/qf demo tracker`. |
| 2 | `20-navigation.png` | Le guidage intégré : la flèche à l'écran avec la distance et le temps, le trajet tracé sur la minicarte. | Une étape à 200-600 yd, en marchant ; capture avec la minicarte visible. |
| 3 | `20b-navigation-map.png` | Le trajet sur la carte du monde : marche, vol ou bateau jusqu'à l'étape. | Même étape, carte du monde ouverte (M) ; idéalement une étape qui demande un vol. |
| 4 | `16-route-choice.png` | « Change route » : le chapitre en cours et les chapitres du niveau, carte conseillée. | Journal (`/qf`), bouton « Change route », personnage de niveau 25-35. |
| 5 | `08-journal-route.png` | Le journal, onglet Route (vue Manuel) : chapitres par niveau, étapes, onglets en haut. | `/qf`, onglet Route, vue Manual. |
| 6 | `08c-journal-dungeons.png` | Onglet Donjons revu : itinéraire de prise depuis ta position, quêtes par arrêt, boutons « i » et carte. | `/qf`, onglet Dungeons, un donjon **avec des quêtes à faire** (pas un donjon déjà vidé comme Deadmines) ; ouvrir un « i ». Nain 34 : Gnomeregan (quêtes à Forgefer et Dun Morogh) ou Scarlet Monastery. Personnage horde 13-18 : Ragefire Chasm. L'onglet ne liste que les donjons de la faction du personnage. |
| 7 | `21-class-talents.png` | Options > Class > Talents : spés, « My points / My choice », arbre, point suivant. | `/qf options`, section Class, onglet Talents. |
| 8 | `22-class-macros.png` | Options > Class > Macros : filtres, cartes de macro, bouton Create. | Même section, onglet Macros. |
| 9 | `23-trainer.png` | Chez l'entraîneur de classe : sorts à apprendre avec le prix, puis l'offre de remplacer les anciens rangs. | Parler à ton entraîneur de classe avec des sorts à apprendre. |
| 10 | `24-raid-marks.png` | Icônes de raid sur les monstres d'objectif visibles. | Zone d'objectif avec plusieurs monstres, plaques ennemies affichées (V), appuyer sur la touche de marquage. |
| 11 | `12-pace.png` | Journal, onglet Pace : avance sur la route, temps par chapitre, session. | `/qf`, onglet Pace, après au moins 10 min de jeu. |
| 12 | `25-auction.png` | La liste des objets de quête à acheter, collée à l'hôtel des ventes, avec les prix. | Chez un encanteur avec un chapitre qui a des objets à acheter, puis le bouton pièces d'or du suivi. |
| 13 | `14-equip-pair.png` | Récompenses et butin : flèche verte sur la récompense, annonce « Equip ». | `/qf demo pair` (ou une vraie récompense de quête). |
| 14 | `26-themes.png` | Options > Theme : cartes des 13 thèmes et aperçu en direct à droite. | `/qf options`, section Theme. |
| 15 | `27-news.png` | La fenêtre des nouveautés de la 1.0, étape par étape. | `/qf news`. |

Images de l'ancienne série gardées si elles restent justes : `11-zone-mode` (mode zone), `13-cave-entrance`
(grottes), `10-quest-item` (bouton d'objet de quête). Retirées : `02-wizard`, `08b-journal-options`,
`06-class-quest`, `07-dungeon`, `17-outpost-alert`, `18-quest-chain` et `bonus-themes` (l'interface a changé).

Dépose les captures sous ces noms (ou garde les noms du Bureau et dis-moi lequel est lequel) : je fais le
découpage, les gabarits et le rendu, puis je mets à jour la section 4 de `docs/CURSEFORGE.md`.
