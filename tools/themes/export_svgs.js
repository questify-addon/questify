// Exporte en SVG l'art des thèmes à partir des sources de la maquette (une seule source pour la
// maquette et le jeu) : docs/media/apercus/src/themes/{tokens,art-alliance,art-questify,art-banners}.js.
// Usage : node tools/themes/export_svgs.js <dossier de sortie>
// Puis tools/themes/build_textures.py rend chaque SVG en PNG (Chrome sans interface) et en TGA.
"use strict";
const fs = require("fs");
const path = require("path");
const vm = require("vm");

const root = path.resolve(__dirname, "../..");
const src = path.join(root, "docs/media/apercus/src/themes");
const out = process.argv[2];
if (!out) { console.error("usage: node export_svgs.js <out>"); process.exit(1); }
fs.mkdirSync(out, { recursive: true });

const ctx = { console, encodeURIComponent, decodeURIComponent, module: undefined };
vm.createContext(ctx);
for (const f of ["tokens.js", "art-alliance.js", "art-questify.js", "art-banners.js"]) {
  // les const des scripts de navigateur deviennent des propriétés du contexte
  const code = fs.readFileSync(path.join(src, f), "utf8").replace(/^const (\w+)/gm, "var $1");
  vm.runInContext(code, ctx, { filename: f });
}
const { THEMES, ORDER, ART_ALLIANCE, ART_Q, BAN } = ctx;
const decode = (uri) => decodeURIComponent(uri.replace(/^data:image\/svg\+xml;utf8,/, ""));
const write = (name, svg, w, h) => {
  fs.writeFileSync(path.join(out, name + ".svg"), svg);
  fs.appendFileSync(path.join(out, "list.txt"), `${name} ${w} ${h}\n`);
};
fs.writeFileSync(path.join(out, "list.txt"), "");

// Métal en niveaux de gris : la couleur de sommet du jeu (theme.colors.metal) le teinte.
const grey = (svg) => svg
  .replace(/#fbeab0|#f7e2a2/g, "#ffffff").replace(/#d9b257|#d4a94f/g, "#cfcfcf")
  .replace(/#8c6524|#8a6324/g, "#7a7a7a").replace(/#5a3f12|#4a3410|#3a2a0c|#4a330c/g, "#3c3c3c")
  .replace(/#2f5fb8/g, "#9a9a9a").replace(/#6b4c18/g, "#5a5a5a");

write("ring", grey(decode(ART_ALLIANCE.ring)), 64, 64);
write("logo", decode(ART_Q.logo), 128, 128);
write("icon", decode(ART_Q.icon), 128, 128);

// Blason Skyborne de secours (dessin Questify) : ailes et nuage dans un disque bleu ciel.
write("skyborne", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <defs><radialGradient id="s" cx=".5" cy=".35" r=".75"><stop offset="0" stop-color="#9fe0ff"/><stop offset=".6" stop-color="#2f6f9e"/><stop offset="1" stop-color="#12304a"/></radialGradient>
  <linearGradient id="w" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#ffffff"/><stop offset="1" stop-color="#c9dcec"/></linearGradient></defs>
  <circle cx="64" cy="64" r="64" fill="url(#s)"/>
  <g fill="url(#w)" stroke="#1d4766" stroke-width="2">
    <path d="M62 66C48 50 30 44 10 48c14 4 24 9 32 16-12 0-22 3-30 9 14 0 26 0 36 3-8 4-14 9-18 15 12-3 24-8 34-16z"/>
    <path d="M66 66C80 50 98 44 118 48c-14 4-24 9-32 16 12 0 22 3 30 9-14 0-26 0-36 3 8 4 14 9 18 15-12-3-24-8-34-16z"/>
  </g>
  <path d="M38 98c0-8 8-12 14-10 2-8 14-12 20-4 8-4 18 2 16 12 6 0 10 4 10 8H34c0-4 2-6 4-6z" fill="#ffffff" stroke="#1d4766" stroke-width="2"/>
  <circle cx="64" cy="58" r="7" fill="#fff6c8" stroke="#1d4766" stroke-width="2"/>
</svg>`, 128, 128);

// Glyphes plats (blancs, teintés en jeu) : prendre (!) et rendre (?).
write("glyph-accept", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><rect x="6.4" y="1.2" width="3.2" height="9.4" rx="1.3" fill="#fff"/><circle cx="8" cy="13.5" r="1.8" fill="#fff"/></svg>`, 32, 32);
write("glyph-turnin", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M4.4 5.4C4.4 3.2 6 1.8 8.1 1.8c2.2 0 3.7 1.4 3.7 3.3 0 1.6-1 2.4-2 3-.8.5-1 .8-1 1.6v.7H6.4v-.9c0-1.4.6-2.1 1.6-2.7.8-.5 1.2-.8 1.2-1.5S8.7 4.1 8 4.1c-.8 0-1.4.5-1.5 1.3z" fill="#fff"/><circle cx="7.7" cy="13.5" r="1.8" fill="#fff"/></svg>`, 32, 32);

// Contrôles : coche, point de bouton radio, croix de fermeture (blancs, teintés en jeu).
write("glyph-check", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3 8.6l3.2 3.2L13 4.6" fill="none" stroke="#fff" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/></svg>`, 32, 32);
write("glyph-dot", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="4" fill="#fff"/></svg>`, 32, 32);
write("glyph-close", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="M3.5 3.5l9 9M12.5 3.5l-9 9" stroke="#fff" stroke-width="1.8" stroke-linecap="round"/></svg>`, 32, 32);
write("glyph-circle", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><circle cx="8" cy="8" r="6.6" fill="none" stroke="#fff" stroke-width="1.2"/></svg>`, 32, 32);

// Flèche flottante (blanche à bord clair, teintée en jeu), pointe vers le haut.
write("arrow", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128">
  <path d="M64 8L104 70H80V120H48V70H24z" fill="#ffffff" stroke="#ffffff" stroke-width="2" stroke-linejoin="round"/>
  <path d="M64 18L94 64H72V112H56V64H34z" fill="#e6e6e6"/>
  <path d="M64 22V110" stroke="#ffffff" stroke-width="2" opacity=".7"/></svg>`, 128, 128);
write("arrow-glow", `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 128"><defs><filter id="b" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="7"/></filter></defs>
  <path d="M64 12L100 68H78V116H50V68H28z" fill="#ffffff" filter="url(#b)"/></svg>`, 128, 128);

console.log("ok", out);
