# Questify Nav: credits / crédits

Questify's walking router is a copy of **Polestar Nav** 0.3.7.2 (GPL-3.0-or-later),
which started from [Shortest Path Forever](https://github.com/cjber/shortest-path-forever)
by **Cillian Berragan** ([cjber](https://github.com/cjber)). Thank you, Cillian, and thank
you, Polestar. / Le routeur de marche de Questify est une copie de **Polestar Nav** 0.3.7.2
(GPL-3.0-or-later), lui-même issu de Shortest Path Forever de Cillian Berragan.

## Shortest Path Forever (Cillian Berragan)

Version v1.16.0, commit [b1ad5bd](https://github.com/cjber/shortest-path-forever/commit/b1ad5bd4bf579c781937af0e25f5233cc94b3726),
GPL-3.0-or-later, Copyright (C) 2026 Cillian Berragan.

`Routing/PathGrid.lua`, `Routing/Path.lua` and `Routing/PathJobs.lua` began as his files of
that commit; Polestar has since changed them (a step is priced by the ground class of the node
it enters and the player's faction, `Routing/Costs.lua`). Each keeps his copyright and the GPL
notice under a header line saying where it started. Polestar's walking maps are written in a
format grown from his (`tools/baker/gen_nav.py` and `tools/pack_nav.py`).

He gave his permission to Polestar: "Definitely feel free to use my pathing logic" (2026-10-15),
recorded in [shortest-path-forever#143](https://github.com/cjber/shortest-path-forever/issues/143).
If you like walking routes, try his addon too:
[Shortest Path Forever on CurseForge](https://www.curseforge.com/wow/addons/shortest-path-forever)
plans whole journeys with flights, boats, zeppelins and portals.

## Polestar

The router as it stands (`Routing/*.lua`, `API.lua`, `Nav/Chokepoints.lua`), the walking-map
format 2 and the build of the maps are Polestar's work: <https://github.com/fitzforge/polestar>.
Everything here is GPL-3.0-or-later (`LICENSE`).

## Leffe's navigation maps

The surfaces, floors, ground classes, zones, entrance graph, jumps and drops in the walking
maps (`Questify_Nav_EK`, `Questify_Nav_Kalimdor`; maps format 5) are **Leffe's navigation
maps**, used with his permission. Thank you, Leffe. / Les cartes de marche sont les cartes de
navigation de Leffe.

## What Questify changed / Ce que Questify a changé

Only the names, so the copy does not clash with an installed Polestar. The script
`tools/nav/import_polestar_nav.sh` renames, byte for byte, the code tokens `PolestarPathData`,
`Polestar_NavEngine`, `Polestar_NavCosts`, `PolestarNavChokepoints` and the part names
`"Polestar_Nav_EK"` and `"Polestar_Nav_Kalimdor"` into their `Questify` twins (same length, so
the compressed data is untouched), rewrites the three `.toc` files and recomputes the sha256
sums of `PACK.json`. Copyright headers and prose naming Polestar stay as they are. Questify
reads its own maps (`QuestifyPathData`), never those of Polestar or Shortest Path Forever.

Questify uses the router only for walking legs: `Questify_NavEngine:Find(map, from, to, cb, opts)`.
