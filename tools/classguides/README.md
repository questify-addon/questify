# Guides de classe et macros (classicwowforever.com)

Génère les données de l'onglet **Options › Classe** (Talents et Macros) depuis
[classicwowforever.com](https://classicwowforever.com) : les 27 guides de talents (`/class-guides/<classe>/<spé>/`,
niveaux 10 à 60, build 1.60.1) et les macros de chaque classe (`/macros/<classe>/`, 670 macros dont 315 PvP).

```sh
python3 tools/classguides/build.py --fetch   # télécharge pages et tables DB2 dans cache/, puis génère
python3 tools/classguides/build.py           # génère depuis cache/ (aucun accès réseau)
```

Bibliothèque standard de Python 3 seulement. Sortie déterministe : mêmes pages en cache, mêmes fichiers (aucune
date de relevé dans les fichiers). Les pages téléchargées sont des données : rien n'y est exécuté.

## Fichiers écrits

- `Questify/Data/ClassGuides.lua` : `Q.ClassGuideData[CLASSE]` = trois spécialisations dans l'ordre du jeu
  (`group` 1 à 3) : arbre (`nodes` : sort de rang 1, palier `row` et colonne `col` à partir de 0, rangs, icône, nom
  anglais), un sort par niveau de 10 à 60 (`steps`), étapes commentées (`stages` : niveaux, sort, rang visé,
  explication anglaise), auteur, build, date de mise à jour du guide sur le site, accroche.
- `Questify/Data/ClassMacros.lua` : `Q.ClassMacroData[CLASSE]` = macros (`id` = ancre de la carte sur le site,
  `spec` ou nil pour toute la classe, `pvp`, `origin` classic / adapted / forever, niveau, icône, texte, titre,
  usage, prérequis, touches) et `names` : nom anglais de chaque marqueur.
- `Questify/Data/ClassText_frFR.lua`, `_deDE.lua`, `_esES.lua` : textes des pages traduites du site (nom et
  accroche des spécialisations, explications des étapes, titres, usages, prérequis et touches des macros). Chaque
  fichier ne se charge que dans un client de sa langue.

## Extraction

- Anglais : flux RSC des pages (`.rsc.push("…")`) : objets `model`, `stages`, `steps`, `tree` des guides,
  `sections` des macros ; auteur dans le JSON-LD.
- Autres langues : HTML rendu (le flux reste en anglais) : `li[data-level] .sg-why` des guides, cartes
  `article.mc` des macros, accroches de `/class-guides/`. Alignés sur l'anglais (niveau de chaque étape, ancre et
  texte de chaque macro) ; une page qui ne s'aligne pas garde l'anglais (« attention » à la génération).
- Talents : la case (arbre, palier, colonne) de la table DB2 `Talent` donne le sort de rang 1 si son nom est celui
  du site ; sinon (talent propre à Forever) le sort de même nom parmi les talents et `TraitDefinition`. En jeu, le
  nœud C_Traits est retrouvé par ce sort, sinon par son nom dans le même arbre, sinon par sa position
  (`Engine/ClassGuide.lua`, `Guide:Match`).
- Macros : après `/cast`, `/castsequence`, `/use`, `#showtooltip`, `/cancelaura`, `/equip`…, chaque nom devient
  `{sID}` (sort de la classe de préférence) ou `{iID}` (objet, table `ItemSparse`) et `(Rank N)` devient
  `({r} N)` ; le jeu remet les noms de sa langue (`Engine/ClassMacros.lua`). Les noms à compléter par le joueur
  (« Off-Hand Name ») restent tels quels et la macro est marquée `fill`.
- Vérifications : un point par niveau de 10 à 60, rangs croissants, rang maximal, palier (avertissement),
  longueur des macros (255).

Tables DB2 (build `1.60.1.70862`, `https://wago.tools/db2/<Table>/csv?build=…`) : `SpellName`, `Talent`,
`TalentTab`, `TraitDefinition`, `ItemSparse`, `SkillLineAbility`.

## Licence et attribution

Les guides, données et images de classicwowforever.com sont sous licence
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) (« Our guides, data and images are licensed under CC BY
4.0 »). Questify garde l'attribution :

- en tête de chaque fichier généré : source, lien, licence, lien de la licence, mention « Modifié par Questify »
  et ce qui a été modifié ;
- dans l'onglet Classe : pied de page de chaque sous-menu (auteur du guide, adresse, licence, « mis en forme par
  Questify », build et date du guide ; pour les macros, « noms des sorts remplacés par ceux du jeu ») ; un clic
  donne le lien à copier.

Le site précise que les parcours de talents ne sont pas testés en jeu et que les macros ne sont pas encore
testées dans le client Forever : l'onglet le dit aussi.

## Mise à jour automatique

Une tâche de nuit relance `build.py --fetch`, puis les tests (`luajit tests/run.lua`). Si les fichiers de
`Questify/Data/Class*.lua` changent et que les tests passent, elle les commite sur la branche dédiée
`data/classguides` et la pousse, sans demander de validation ; l'intégration dans la version se fait avec les
autres branches. Les « attention » de la génération figurent dans le message de commit.
