/* Bandeaux illustrés (style B « Bannière ») : silhouette de la terre natale de chaque thème, dessin
   libre pour Questify. Couleurs posées par le thème : la silhouette prend --far (plan lointain) et
   --near (premier plan), les fenêtres allumées --glow. Rendu en TGA (512 x 64) pour le jeu :
   Questify/Media/Themes/Banners/<clé>.tga, teinté en jeu par SetVertexColor. */
const BAN = {
  /* Questify : chaîne de montagnes et chemin pointillé */
  neutral: `<path class="far" d="M0 64V40l40-20 30 14 46-30 40 28 28-12 50 26 40-22 46 20 36-16 50 24 40-14 46 20 60-26V64z"/>
    <path class="near" d="M0 64V52l60-10 50 8 70-14 60 12 80-8 70 10 60-12 50 10V64z"/>
    <path class="glow" d="M30 60c60-8 110 2 170-10s120-6 180-14 90 2 120-6" fill="none" stroke-dasharray="4 4" stroke-width="1.6"/>`,
  /* Alliance : bannières sur des remparts */
  alliance: `<path class="far" d="M0 64V44h30v-6h8v6h40v-6h8v6h60V30h6v-8l10-10 10 10v8h6v14h60v-6h8v6h40v-6h8v6h70V26h6v-8l10-12 10 12v8h6v18h80v-6h8v6h48V64z"/>
    <path class="glow" d="M196 14h-10v14l5-3 5 3zM356 8h-10v16l5-3 5 3z"/>
    <path class="near" d="M0 64V56h512v8z"/>`,
  /* Humain : Hurlevent, tours et flèches */
  human: `<path class="far" d="M0 64V50h20v-8h10v8h16V34l6-10 6 10v16h14V42h22v8h10V24l8-16 8 16v26h12V46h18v4h16V32h6V22l7-12 7 12v10h6v18h20V42h30v8h12V28l10-18 10 18v22h18V46h22v4h14V36l5-8 5 8v14h20V30h8V16l9-14 9 14v14h8v20h16V44h26v6h12V38l6-10 6 10v12h20v14z"/>
    <path class="near" d="M0 64V58h40v-4h30v4h60v-6h40v6h80v-4h50v4h90v-6h60v6h62V64z"/>
    <g class="glow"><rect x="126" y="34" width="2" height="4"/><rect x="241" y="38" width="2" height="4"/><rect x="339" y="34" width="2" height="4"/><rect x="433" y="30" width="2" height="5"/></g>`,
  /* Nain : montagne de Forgefer, grande porte et forge */
  dwarf: `<path class="far" d="M0 64V50l60-20 50 14 70-24 76 30 50-26 60 22 56-34 50 24 40-10V64z"/>
    <path class="near" d="M360 64V40l20-12h80l20 12v24h-30V44a20 20 0 00-40 0v20z"/>
    <path class="glow" d="M400 64V46a10 10 0 0120 0v18z"/>
    <path class="near" d="M0 64V58h360v6zM480 64v-6h32v6z"/>`,
    /* Elfe de la nuit : arbre-monde, lune et feuillage */
  nightelf: `<circle class="glow" cx="420" cy="18" r="11"/>
    <path class="far" d="M0 64V48c30-8 50-4 70-12 20 8 40 6 60 14 20-10 40-6 60 2 10-30 20-44 40-46 18 2 30 16 40 46 20-8 40-10 60-2 20-8 40-12 70-4 30-6 60-2 82 4V64z"/>
    <path class="near" d="M232 64V30c-8-4-20-2-30 2 10-10 24-12 34-8-4-8-14-12-24-12 12-4 24 0 30 8 6-8 18-12 30-8-10 0-20 4-24 12 10-4 24-2 34 8-10-4-22-6-30-2v34z"/>
    <path class="near" d="M0 64V58c80-6 160 0 240-4s180 2 272-2v12z"/>`,
  /* Gnome : rouages et tuyaux de Gnomeregan */
  gnome: `<path class="far" d="M0 64V40h40V26h10v14h30V34h60V20h8v14h40v6h50V28h12v12h60V22h10v18h50v-8h40v8h60v24z"/>
    <g class="near" transform="translate(130 44)"><circle r="16"/><path d="M-3-20h6v6h-6zM-3 14h6v6h-6zM14-3h6v6h-6zM-20-3h6v6h-6zM9-15l5 5-4 4-5-5zM-14 10l5 5-4 4-5-5zM10 9l5 5-4 4-5-5zM-15-10l5-5 4 4-5 5z"/></g>
    <g class="near" transform="translate(380 50)"><circle r="11"/><path d="M-2-14h4v4h-4zM-2 10h4v4h-4zM10-2h4v4h-4zM-14-2h4v4h-4z"/></g>
    <circle class="glow" cx="130" cy="44" r="5"/><circle class="glow" cx="380" cy="50" r="3.5"/>
    <path class="near" d="M0 64V58h512v6z"/>`,
  /* Skyborne : îles flottantes et nuages */
  skyborneA: `<path class="far" d="M60 30h90l-10 10-20 6-14 10-12-10-20-6zM300 18h120l-14 12-26 6-14 12-14-12-26-6zM180 40h60l-8 8-12 4-8 8-8-8-12-4z"/>
    <path class="near" d="M0 64V54c20-8 40-8 60-2 16-10 40-12 60-2 20-8 46-8 66 2 20-10 50-10 70 0 22-8 48-8 70 2 20-10 46-10 66 0 20-6 40-6 60 0 20-6 40-4 60 2v8z"/>
    <path class="glow" d="M96 30l4-10 4 10zM356 18l5-12 5 12z"/>`,
  /* Horde : palissades et tentes à pointes */
  horde: `<path class="far" d="M0 64V44l6-8 6 8 6-8 6 8 6-8 6 8v-4h40l30-26 30 26h30l6-8 6 8 6-8 6 8 6-8 6 8h50l36-32 36 32h40l6-8 6 8 6-8 6 8 6-8 6 8h40l26-20 26 20h40V64z"/>
    <path class="glow" d="M106 30l4-14 4 14zM248 22l5-18 5 18z"/>
    <path class="near" d="M0 64V56h512v8z"/>`,
  /* Orc : Orgrimmar, huttes et pics */
  orc: `<path class="far" d="M0 64V48l40-24 10 6 36-14 40 32h20l30-30 8-14 8 14 30 30h30l40-30 40 30h20l50-36 50 36 50-20 30 14V64z"/>
    <path class="near" d="M60 64V52l26-14 26 14v12zM300 64V50l34-20 34 20v14z"/>
    <path class="glow" d="M78 56h16v8H78zM322 54h24v10h-24z"/>
    <path class="near" d="M0 64V60h512v4z"/>`,
  /* Troll : jungle, masque et totem */
  troll: `<path class="far" d="M0 64V40c20-12 30-6 40-16 10 14 30 6 40 18 20-16 40-10 56 0 10-14 30-18 46-6 20-12 40-10 56 4 20-10 40-12 60 0 16-12 36-10 50 2 20-14 46-8 60 4 20-8 40-8 60 2 16-6 30-4 44 2V64z"/>
    <path class="near" d="M240 64V20l10-8h20l10 8v44z"/>
    <path class="glow" d="M248 26h8v6h-8zM264 26h8v6h-8zM252 40h16l-4 6h-8z"/>
    <path class="near" d="M0 64V58h512v6z"/>`,
  /* Tauren : mesas de Mulgore et totems */
  tauren: `<path class="far" d="M0 64V46h40l10-16h70l12 16h60V40l14-18h80l16 18v6h70l10-14h70l12 14h48V64z"/>
    <path class="near" d="M150 64V24h8l2-6h8l2 6h8v40zM340 64V30h6l2-5h6l2 5h6v34z"/>
    <path class="glow" d="M156 30h16v4h-16zM156 40h16v4h-16zM346 36h14v3h-14z"/>
    <path class="near" d="M0 64V58h512v6z"/>`,
  /* Mort-vivant : ruines de Lordaeron, flèches brisées */
  undead: `<path class="far" d="M0 64V44h30V30l6-12 6 12v14h40V36h20v8h30V20l8-16 6 10 2-4v30h40V40h16v4h50V26l6-6 4 8 6-14 6 16v14h40V38h30v6h50V24l8-14 8 14v20h50v20z"/>
    <path class="glow" d="M36 36h3v5h-3zM146 30h3v5h-3zM292 32h3v5h-3zM430 30h3v5h-3z"/>
    <path class="near" d="M0 64V56h120l10-4 10 4h372v8z"/>`,
  /* Skyborne (Horde) : îles flottantes au crépuscule */
  skyborneH: `<path class="far" d="M40 26h110l-12 12-24 6-16 12-14-12-24-6zM280 14h140l-16 12-30 8-16 14-16-14-30-8zM190 42h50l-6 6-10 4-8 8-8-8-10-4z"/>
    <path class="near" d="M0 64V54c24-8 46-8 70-2 18-10 44-12 66-2 22-8 50-8 72 2 22-10 52-10 74 0 24-8 50-8 74 2 22-10 48-10 70 0 22-6 44-4 86 2v8z"/>
    <circle class="glow" cx="470" cy="20" r="9"/>`,
};
function bannerSVG(key, t) {
  const glow = t.glow || t.trim;
  return `data:image/svg+xml;utf8,${encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 64" preserveAspectRatio="xMidYMax slice"><style>.far{fill:${t.far}}.near{fill:${t.near}}.glow{fill:${glow};stroke:${glow};opacity:.7}</style>${BAN[key] || BAN.neutral}</svg>`)}`;
}
