# Textures des thèmes : cahier des charges pour le designer

Les fichiers actuels de `Questify/Media/Themes/` et `Questify/Media/Icon.tga` sont des brouillons
générés depuis la maquette (`tools/themes/`). Ils seront remplacés par les fichiers du designer,
sous les mêmes noms.

## Règles communes

- Format : **TGA 32 bits (RGBA), non compressé**, fond transparent. PNG accepté en livraison, converti ensuite.
- Dimensions : **puissances de 2** obligatoires (64, 128, 256, 512, 1024). Pas plus de 1024.
- Fichiers livrés au double (ou plus) de la taille affichée, pour rester nets en grande échelle d'interface.
- Les textures « teintées » sont en **niveaux de gris** (blanc = partie la plus claire) : le jeu les
  colore avec la couleur du thème. Pas de couleur dedans.
- Aucun texte dans les images.

## Liste

| Fichier | Taille | Type | Affiché à | Rôle |
|---|---|---|---|---|
| `banner-<thème>.tga` × 14 | 1024 × 128 | couleur, alpha | 352 × 44 à 416 × 52 | Bandeau illustré en haut des fenêtres |
| `corner.tga` | 128 × 128 | gris, teinté | 22 × 22 | Coin de cadre en filigrane |
| `ring.tga` | 128 × 128 | gris, teinté | 28 à 34 px | Anneau de métal autour du blason |
| `logo.tga` | 256 × 256 | couleur | 28 à 34 px | Blason du thème neutre « Questify » (boussole) |
| `Icon.tga` (dans `Media/`) | 256 × 256 | couleur | 16 à 64 px | Icône de l'addon (minicarte, liste des addons) |
| `skyborne.tga` | 256 × 256 | couleur | 28 à 34 px | Blason Skyborne (le jeu n'en a pas) |
| `glyph-accept.tga` | 64 × 64 | blanc, teinté | 12 à 16 px | « ! » prendre une quête |
| `glyph-turnin.tga` | 64 × 64 | blanc, teinté | 12 à 16 px | « ? » rendre une quête |
| `glyph-check.tga` | 64 × 64 | blanc, teinté | 14 px | Coche des cases et des cartes |
| `glyph-dot.tga` | 64 × 64 | blanc, teinté | 12 px | Point du bouton radio |
| `glyph-circle.tga` | 64 × 64 | blanc, teinté | 14 px | Cercle du bouton radio |
| `glyph-close.tga` | 64 × 64 | blanc, teinté | 14 px | Croix de fermeture |
| `arrow.tga` | 256 × 256 | blanc, teinté | ~64 px | Flèche flottante, pointe vers le haut |
| `arrow-glow.tga` | 256 × 256 | blanc flou, teinté | ~64 px | Halo de la flèche |

Thèmes des bandeaux : `neutral`, `contrast`, `alliance`, `human`, `dwarf`, `nightelf`, `gnome`, `skyborneA`,
`horde`, `orc`, `troll`, `tauren`, `undead`, `skyborneH`.

## Détails

**Bandeaux (1024 × 128, ratio 8:1).** Silhouette de la terre natale (Hurlevent, Forgefer, Teldrassil,
Gnomeregan, îles flottantes, Orgrimmar, jungle troll, Mulgore, Fossoyeuse…), Questify : montagnes et
chemin pointillé ; Contraste élevé : décor très discret, le texte prime. Calé en bas à droite ; la fenêtre coupe ce qui dépasse à gauche. Les **45 % de gauche
s'effacent vers le transparent** : le blason et le titre y sont posés. Ciel transparent (le jeu peint
un dégradé dessous). Tons sombres proches du fond du thème, un ou deux points lumineux de la couleur
« liseré ».

**Coin (128 × 128).** Coin haut-gauche seulement (les trois autres par symétrie) : équerre double,
volute, petit losange à la pointe. Gris clair à gris foncé pour le relief.

**Anneau (128 × 128).** Anneau plein bord à bord (diamètre extérieur = 100 %), intérieur vide à ~82 %
du diamètre (le portrait rond est dessous). Relief en niveaux de gris.

**Logo, Skyborne (256 × 256).** Composition ronde : le jeu masque en disque à ~82 % du diamètre.

**Icône de l'addon (256 × 256).** Parchemin, boussole dorée à gemme bleue, chemin cyan lumineux
(référence fournie par l'utilisateur). Doit rester lisible à 32 px.

**Flèche (256 × 256).** Centrée, pointe vers le haut : elle tourne autour du centre de l'image.

## Couleurs des thèmes (fond, ciel du bandeau, accent, liseré, métal)

| Thème | Fond | Ciel | Accent | Liseré | Métal |
|---|---|---|---|---|---|
| neutral (Questify) | #0c1724 | #183a58 | #3fd0e6 | #d4a94f | #d4a94f |
| contrast (Contraste élevé) | #000000 | #1a1a1a | #ffd60a | #ffd60a | #ffffff |
| alliance | #141b2b | #21345c | #5e93ea | #d9b45a | #d9b45a |
| human | #171c25 | #2a3a55 | #86a9d8 | #dcc27a | #dcc27a |
| dwarf | #1c1d20 | #38322c | #d68f4c | #d68f4c | #c98a4a |
| nightelf | #18162a | #2e2658 | #ae92ee | #6fd3c6 | #c9d2e6 |
| gnome | #151c20 | #1d3a41 | #45c4b2 | #e48ac1 | #d08a5a |
| skyborneA | #141c26 | #244a68 | #6ec8f2 | #eef4fb | #dfe6f0 |
| horde | #1d1918 | #3e211e | #e0574b | #b98a52 | #b98a52 |
| orc | #1a1c18 | #33392a | #d86a3d | #8db455 | #a8957a |
| troll | #131d1c | #183c38 | #3fc2a0 | #e5734d | #d8c49a |
| tauren | #1e1c19 | #3d3124 | #d9a85e | #4fb5ab | #c99a5a |
| undead | #171918 | #2a3029 | #a2d164 | #9481cc | #a9aab8 |
| skyborneH | #1b1823 | #45304d | #ec9165 | #ac90e6 | #d0a6e8 |

Rendu de référence : `docs/media/apercus/maquettes-themes/v4/*.png`.
