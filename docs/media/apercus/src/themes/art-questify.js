/* Art « Questify » (dessiné pour Questify, SVG) : icône de l'addon, coins et filets dorés fins,
   badge de la flèche. Rendu tel quel en TGA pour le jeu (Questify/Media/Themes/Questify/*.tga). */
const QGOLD = `<linearGradient id="qg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#f7e2a2"/><stop offset=".5" stop-color="#d4a94f"/><stop offset="1" stop-color="#8a6324"/></linearGradient>`;
const qsvg = (vb, body, defs = "") => `data:image/svg+xml;utf8,${encodeURIComponent(`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${vb}"><defs>${QGOLD}${defs}</defs>${body}</svg>`)}`;

/* étoile de boussole à 8 branches (centre 0,0, rayon r) */
function compass(r, gem) {
  const pts = (rr, a0, n, inner) => {
    const out = [];
    for (let i = 0; i < n * 2; i++) {
      const a = a0 + (Math.PI * i) / n;
      const d = i % 2 === 0 ? rr : inner;
      out.push(`${(Math.cos(a) * d).toFixed(2)},${(Math.sin(a) * d).toFixed(2)}`);
    }
    return out.join(" ");
  };
  return `
    <polygon points="${pts(r * 0.62, -Math.PI / 2 + Math.PI / 4, 4, r * 0.16)}" fill="url(#qg)" stroke="#4a330c" stroke-width="${r * 0.025}"/>
    <polygon points="${pts(r, -Math.PI / 2, 4, r * 0.2)}" fill="url(#qg)" stroke="#4a330c" stroke-width="${r * 0.03}"/>
    <path d="M0 ${-r}L${r * 0.2 * 0.7} ${-r * 0.2 * 0.7}L0 0z M${r} 0L${r * 0.14} ${r * 0.14}L0 0z M0 ${r}L${-r * 0.14} ${r * 0.14}L0 0z M${-r} 0L${-r * 0.14} ${-r * 0.14}L0 0z" fill="#8a6324" opacity=".55"/>
    <circle r="${r * 0.36}" fill="none" stroke="url(#qg)" stroke-width="${r * 0.06}"/>
    ${gem ? `<circle r="${r * 0.17}" fill="url(#gem)" stroke="#4a330c" stroke-width="${r * 0.03}"/><circle cx="${-r * 0.05}" cy="${-r * 0.06}" r="${r * 0.05}" fill="#e8fbff" opacity=".8"/>` : ""}`;
}
const GEM = `<radialGradient id="gem" cx=".4" cy=".35" r=".7"><stop offset="0" stop-color="#7fe9ff"/><stop offset=".55" stop-color="#1689b3"/><stop offset="1" stop-color="#06304a"/></radialGradient>
  <linearGradient id="parch" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ead2a0"/><stop offset=".6" stop-color="#c9a76b"/><stop offset="1" stop-color="#9c7a45"/></linearGradient>
  <filter id="glow" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="3.2" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>`;

const ART_Q = {
  /* icône de l'addon (minicarte, liste des addons) : parchemin + boussole + chemin lumineux */
  icon: qsvg("0 0 256 256", `
    <rect x="6" y="6" width="244" height="244" rx="36" fill="#081626"/>
    <rect x="6" y="6" width="244" height="244" rx="36" fill="none" stroke="url(#qg)" stroke-width="10"/>
    <rect x="20" y="20" width="216" height="216" rx="26" fill="none" stroke="#8a6324" stroke-width="2"/>
    <path d="M62 52h128c-6 10-6 22 0 32v110c-6 10-6 22 0 32H62c6-10 6-22 0-32V84c6-10 6-22 0-32z" fill="url(#parch)" stroke="#6d4f22" stroke-width="3"/>
    <rect x="48" y="44" width="160" height="16" rx="8" fill="#b8925a" stroke="#6d4f22" stroke-width="3"/>
    <rect x="48" y="200" width="160" height="16" rx="8" fill="#b8925a" stroke="#6d4f22" stroke-width="3"/>
    <path d="M84 196c-14-26 30-30 22-56-6-20 26-26 40-12 12 12 30 6 34-20" fill="none" stroke="#38e6ff" stroke-width="7" stroke-linecap="round" filter="url(#glow)"/>
    <path d="M168 102l14 6-2 15" fill="none" stroke="#38e6ff" stroke-width="7" stroke-linecap="round" stroke-linejoin="round" filter="url(#glow)"/>
    <g transform="translate(128 112)">${compass(64, true)}</g>`, GEM),
  /* coin fin : équerre dorée + losange (panneaux) */
  corner: qsvg("0 0 32 32", `
    <path d="M1.5 30V6Q1.5 1.5 6 1.5H30" fill="none" stroke="url(#qg)" stroke-width="1.6"/>
    <path d="M5 30V8Q5 5 8 5H30" fill="none" stroke="#8a6324" stroke-width=".8"/>
    <path d="M9 9l3.5-3.5L16 9l-3.5 3.5z" fill="url(#qg)" transform="translate(-4 -4)"/>`),
  /* filet avec losange au centre */
  rule: qsvg("0 0 400 10", `
    <path d="M0 5H190M210 5H400" stroke="#c9a04a" stroke-width="1.4"/>
    <path d="M200 1l4 4-4 4-4-4z" fill="url(#qg)"/>`),
  /* petite boussole de titre */
  logo: qsvg("-50 -50 100 100", `<circle r="47" fill="#0a1a2b" stroke="url(#qg)" stroke-width="3"/>${compass(40, true)}`, GEM),
  /* badge de la flèche (écu) */
  badge: qsvg("0 0 200 220", `
    <path d="M100 6l20 14h56l14 18v86c0 40-40 70-90 90-50-20-90-50-90-90V38l14-18h56z" fill="#0b1724" stroke="url(#qg)" stroke-width="3"/>
    <path d="M100 16l17 12h52l11 14v82c0 35-35 62-80 80-45-18-80-45-80-80V42l11-14h52z" fill="none" stroke="#8a6324" stroke-width="1"/>
    <path d="M100 2l8 12-8 12-8-12z" fill="url(#qg)"/>
    <path d="M70 186h24M106 186h24" stroke="url(#qg)" stroke-width="1.2"/><path d="M100 181l5 5-5 5-5-5z" fill="url(#qg)"/>`),
};
