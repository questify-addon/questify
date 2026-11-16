/* Art de l'Alliance (dessiné pour Questify, SVG). Chaque dessin sera rendu tel quel en texture TGA
   pour le jeu (Questify/Media/Themes/Alliance/*.tga) : la maquette et le jeu partagent la même
   source. Le blason central est l'icône du jeu Interface\Icons\INV_Misc_Tournaments_Symbol_Human
   (repli : UI_AllianceIcon), posée dans un médaillon rond. */
const GOLD = `<linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#fbeab0"/><stop offset=".45" stop-color="#d9b257"/><stop offset="1" stop-color="#8c6524"/></linearGradient>`;
const svg = (vb, body) => `data:image/svg+xml;utf8,${encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${vb}"><defs>${GOLD}</defs>${body}</svg>`)}`;

const ART_ALLIANCE = {
  /* coin en filigrane (en haut à gauche ; les autres coins par symétrie) */
  corner: svg("0 0 64 64", `
    <path d="M3 62V16Q3 3 16 3H62" fill="none" stroke="url(#g)" stroke-width="3.2"/>
    <path d="M9 62V19Q9 9 19 9H62" fill="none" stroke="#8c6524" stroke-width="1.2"/>
    <path d="M15 40c0-14 10-25 25-25" fill="none" stroke="url(#g)" stroke-width="1.8"/>
    <path d="M15 40c4-2 6-6 4-10M40 15c-2 4-6 6-10 4" fill="none" stroke="url(#g)" stroke-width="1.6" stroke-linecap="round"/>
    <circle cx="15" cy="44" r="2.4" fill="url(#g)"/><circle cx="44" cy="15" r="2.4" fill="url(#g)"/>
    <path d="M3 -3l7 7-7 7-7-7z" transform="translate(3 3)" fill="url(#g)" stroke="#5a3f12" stroke-width=".8"/>
    <circle cx="6" cy="6" r="2" fill="#2f5fb8"/>`),
  /* ailes du médaillon (largeur 120, le médaillon rond se pose au centre) */
  wings: svg("0 0 160 80", `
    <g id="w" stroke="#4a3410" stroke-width=".9" fill="url(#g)">
      <path d="M58 30C42 18 22 14 4 20c14 3 26 8 36 15C28 33 15 35 6 41c14 0 27-1 38 1-10 4-18 9-24 16 13-3 25-7 36-13z"/>
      <path d="M50 33c-9-5-20-7-31-6M46 41c-9-1-18 0-26 3M50 48c-8 2-15 6-21 10" fill="none" stroke="#6b4c18" stroke-width="1"/>
    </g>
    <use href="#w" transform="translate(160 0) scale(-1 1)"/>`),
  /* anneau doré du médaillon et des icônes rondes */
  ring: svg("0 0 64 64", `
    <circle cx="32" cy="32" r="29" fill="none" stroke="url(#g)" stroke-width="4.5"/>
    <circle cx="32" cy="32" r="26.2" fill="none" stroke="#3a2a0c" stroke-width="1.2"/>
    <circle cx="32" cy="32" r="31.2" fill="none" stroke="#3a2a0c" stroke-width="1"/>`),
  /* trait d'ornement : ◆ entre deux traits */
  flourish: svg("0 0 200 12", `
    <path d="M2 6H86M114 6H198" stroke="url(#g)" stroke-width="1.4"/>
    <path d="M100 0l6 6-6 6-6-6z" fill="url(#g)"/><circle cx="88" cy="6" r="1.8" fill="url(#g)"/><circle cx="112" cy="6" r="1.8" fill="url(#g)"/>`),
  /* cartouche du titre (pointe en losange de chaque côté) */
  plaque: svg("0 0 240 34", `
    <path d="M14 2H226L238 17 226 32H14L2 17z" fill="#0d1a38" stroke="url(#g)" stroke-width="2"/>
    <path d="M18 6H222L230 17 222 28H18L10 17z" fill="none" stroke="#8c6524" stroke-width=".8"/>`),
  /* silhouette de ville (Hurlevent, dessin libre) pour le bandeau illustré */
  skyline: svg("0 0 600 80", `
    <path fill="#16295a" d="M0 80V62h20v-8h10v8h16V44l6-10 6 10v18h14V50h22v12h10V30l8-18 8 18v32h12V56h18v6h16V40h6V26l7-14 7 14v14h6v22h20V52h30v10h12V34l10-22 10 22v28h18V58h22v4h14V46l5-8 5 8v16h20V36h8V18l9-16 9 16v18h8v26h16V54h26v8h12V48l6-12 6 12v14h20V60h20V80z"/>
    <path fill="#0f1f47" d="M0 80V70h40v-6h30v6h60v-8h40v8h80v-6h50v6h90v-8h60v8h70v-6h50v6h30V80z"/>
    <g fill="#e2bd62" opacity=".55"><rect x="126" y="40" width="2" height="4"/><rect x="241" y="46" width="2" height="4"/><rect x="339" y="40" width="2" height="4"/><rect x="433" y="38" width="2" height="5"/><rect x="511" y="50" width="2" height="4"/></g>`),
  /* motif de fond : treillis de losanges et fleurons, très discret */
  pattern: svg("0 0 32 32", `
    <path d="M16 0L32 16 16 32 0 16z" fill="none" stroke="#8fb0ff" stroke-width=".6" opacity=".55"/>
    <path d="M16 12c1.5 2 1.5 6 0 8-1.5-2-1.5-6 0-8zM12 16c2-1.5 6-1.5 8 0-2 1.5-6 1.5-8 0z" fill="#8fb0ff" opacity=".5"/>`),
};
