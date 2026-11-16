/* Jetons de couleur des thèmes de Questify (maquette). Source de vérité de la maquette : les mêmes
   valeurs sont reprises dans Questify/UI/Themes.lua une fois les thèmes validés.
   Rôles :
     bg        fond des fenêtres            panel     panneaux surélevés, info-bulles, popups
     panelAlt  contrôles (champs, boutons)  sidebar   barre latérale et liste des chapitres
     footer    pied des fenêtres            sky       haut du bandeau de titre (fondu vers bg)
     edge      bordure de 1 px des fenêtres line      filets et séparateurs
     text      texte principal              textDim   texte secondaire   textMuted  texte discret
     accent    couleur du thème (sélection, bouton principal, barre)   onAccent  texte sur accent
     trim      liseré de 2 px en haut des fenêtres et second accent (emblème)
   Les couleurs de sens (quête, PNJ, monstre, objet, succès, alerte, danger, XP) sont communes à
   tous les thèmes : tous les fonds sont sombres, une quête a la même couleur partout. */
const SHARED = {
  quest: "#ffd773", npc: "#94caff", mob: "#f57a7a", item: "#c7adff", success: "#6bd99a",
  warning: "#fabf4d", danger: "#f57373", xp: "#9fc4ff", zone: "#7fe08a",
};

/* Blason : portrait de race (selon le sexe du personnage en jeu), écu de faction, boussole pour Questify.
   Skyborne : plume provisoire, en attendant une icône propre à la race. */
const ICON = (n) => `https://wow.zamimg.com/images/wow/icons/large/${n}.jpg`;

const THEMES = {
  neutral: {
    name: "Questify", group: "Neutre", note: "par défaut", emblem: "logo", metal: "#d4a94f",
    bg: "#0c1724", panel: "#102030", panelAlt: "#15283b", sidebar: "#09121c", footer: "#0a141f",
    sky: "#183a58", edge: "#2a4258", line: "rgba(130,200,235,.12)",
    text: "#eef3f7", textDim: "#b9c7d3", textMuted: "#8fa0b0",
    accent: "#3fd0e6", onAccent: "#04161d", trim: "#d4a94f",
  },
  contrast: {
    name: "Contraste élevé", group: "Neutre", note: "lisibilité", emblem: "logo", metal: "#ffffff",
    bg: "#000000", panel: "#0b0b0b", panelAlt: "#161616", sidebar: "#000000", footer: "#050505",
    sky: "#1a1a1a", edge: "#ffffff", line: "rgba(255,255,255,.45)",
    text: "#ffffff", textDim: "#f0f0f0", textMuted: "#d4d4d4",
    accent: "#ffd60a", onAccent: "#000000", trim: "#ffd60a",
  },
  alliance: {
    name: "Alliance", group: "Alliance", emblem: ICON("achievement_pvp_a_a"), metal: "#d9b45a",
    bg: "#141b2b", panel: "#182136", panelAlt: "#1f2a44", sidebar: "#10162a", footer: "#121929",
    sky: "#21345c", edge: "#2f3f63", line: "rgba(200,215,255,.10)",
    text: "#f2f5fb", textDim: "#c0c9dc", textMuted: "#97a2ba",
    accent: "#5e93ea", onAccent: "#08111f", trim: "#d9b45a",
  },
  human: {
    name: "Humain", group: "Alliance", emblem: ICON("achievement_character_human_male"), emblemF: ICON("achievement_character_human_female"), metal: "#dcc27a",
    bg: "#171c25", panel: "#1c222d", panelAlt: "#252d3b", sidebar: "#12171f", footer: "#151a22",
    sky: "#2a3a55", edge: "#36435a", line: "rgba(210,222,245,.10)",
    text: "#f3f5f9", textDim: "#c3cbd8", textMuted: "#9aa4b5",
    accent: "#86a9d8", onAccent: "#0c1220", trim: "#dcc27a",
  },
  dwarf: {
    name: "Nain", group: "Alliance", emblem: ICON("achievement_character_dwarf_male"), emblemF: ICON("achievement_character_dwarf_female"), metal: "#c98a4a",
    bg: "#1c1d20", panel: "#222327", panelAlt: "#2c2d32", sidebar: "#17181b", footer: "#19191c",
    sky: "#38322c", edge: "#45403a", line: "rgba(255,240,225,.09)",
    text: "#f5f4f2", textDim: "#cbc7c1", textMuted: "#a39e97",
    accent: "#d68f4c", onAccent: "#150c04", trim: "#d68f4c",
  },
  nightelf: {
    name: "Elfe de la nuit", group: "Alliance", emblem: ICON("achievement_character_nightelf_male"), emblemF: ICON("achievement_character_nightelf_female"), metal: "#c9d2e6",
    bg: "#18162a", panel: "#1e1b33", panelAlt: "#272342", sidebar: "#131124", footer: "#151327",
    sky: "#2e2658", edge: "#3b3463", line: "rgba(220,210,255,.10)",
    text: "#f4f2fb", textDim: "#c9c3de", textMuted: "#a19abb",
    accent: "#ae92ee", onAccent: "#120c24", trim: "#6fd3c6",
  },
  gnome: {
    name: "Gnome", group: "Alliance", emblem: ICON("achievement_character_gnome_male"), emblemF: ICON("achievement_character_gnome_female"), metal: "#d08a5a",
    bg: "#151c20", panel: "#1a2227", panelAlt: "#222d33", sidebar: "#11171b", footer: "#13191d",
    sky: "#1d3a41", edge: "#2d444b", line: "rgba(200,245,240,.09)",
    text: "#f1f7f7", textDim: "#bfd0d1", textMuted: "#95a9ab",
    accent: "#45c4b2", onAccent: "#04140f", trim: "#e48ac1",
  },
  skyborneA: {
    name: "Skyborne", group: "Alliance", emblem: ICON("inv_feather_15"), metal: "#dfe6f0",
    bg: "#141c26", panel: "#19232f", panelAlt: "#212e3d", sidebar: "#10171f", footer: "#121a23",
    sky: "#244a68", edge: "#2f475e", line: "rgba(205,232,255,.10)",
    text: "#f2f7fc", textDim: "#bfd0e0", textMuted: "#94a8bc",
    accent: "#6ec8f2", onAccent: "#04121b", trim: "#eef4fb",
  },
  horde: {
    name: "Horde", group: "Horde", emblem: ICON("achievement_pvp_h_h"), metal: "#b98a52",
    bg: "#1d1918", panel: "#241f1e", panelAlt: "#2e2826", sidebar: "#171413", footer: "#1a1615",
    sky: "#3e211e", edge: "#4a3330", line: "rgba(255,225,220,.09)",
    text: "#f7f3f2", textDim: "#d0c6c4", textMuted: "#a99d9a",
    accent: "#e0574b", onAccent: "#170605", trim: "#b98a52",
  },
  orc: {
    name: "Orc", group: "Horde", emblem: ICON("achievement_character_orc_male"), emblemF: ICON("achievement_character_orc_female"), metal: "#a8957a",
    bg: "#1a1c18", panel: "#20231e", panelAlt: "#292d26", sidebar: "#151713", footer: "#171915",
    sky: "#33392a", edge: "#3f4536", line: "rgba(235,245,220,.09)",
    text: "#f4f6f1", textDim: "#c8cdc0", textMuted: "#a0a697",
    accent: "#d86a3d", onAccent: "#170802", trim: "#8db455",
  },
  troll: {
    name: "Troll", group: "Horde", emblem: ICON("achievement_character_troll_male"), emblemF: ICON("achievement_character_troll_female"), metal: "#d8c49a",
    bg: "#131d1c", panel: "#182423", panelAlt: "#1f2e2c", sidebar: "#0f1817", footer: "#111a19",
    sky: "#183c38", edge: "#284541", line: "rgba(200,250,240,.09)",
    text: "#f0f8f6", textDim: "#bcd3ce", textMuted: "#92aca6",
    accent: "#3fc2a0", onAccent: "#03140f", trim: "#e5734d",
  },
  tauren: {
    name: "Tauren", group: "Horde", emblem: ICON("achievement_character_tauren_male"), emblemF: ICON("achievement_character_tauren_female"), metal: "#c99a5a",
    bg: "#1e1c19", panel: "#25221e", panelAlt: "#2f2b26", sidebar: "#181613", footer: "#1a1815",
    sky: "#3d3124", edge: "#4a3f33", line: "rgba(255,240,215,.09)",
    text: "#f6f4f0", textDim: "#cfc8bd", textMuted: "#a79f93",
    accent: "#d9a85e", onAccent: "#160e03", trim: "#4fb5ab",
  },
  undead: {
    name: "Mort-vivant", group: "Horde", emblem: ICON("achievement_character_undead_male"), emblemF: ICON("achievement_character_undead_female"), metal: "#a9aab8",
    bg: "#171918", panel: "#1d201e", panelAlt: "#262a27", sidebar: "#121413", footer: "#141615",
    sky: "#2a3029", edge: "#373e37", line: "rgba(225,245,220,.09)",
    text: "#f2f5f1", textDim: "#c4cbc2", textMuted: "#9ca499",
    accent: "#a2d164", onAccent: "#0b1403", trim: "#9481cc",
  },
  skyborneH: {
    name: "Skyborne", group: "Horde", emblem: ICON("inv_feather_15"), metal: "#d0a6e8",
    bg: "#1b1823", panel: "#211d2b", panelAlt: "#2a2537", sidebar: "#16131d", footer: "#18151f",
    sky: "#45304d", edge: "#463d55", line: "rgba(240,220,255,.10)",
    text: "#f6f3fa", textDim: "#cdc4d9", textMuted: "#a69cb4",
    accent: "#ec9165", onAccent: "#1a0904", trim: "#ac90e6",
  },
};
const ORDER = ["neutral", "contrast", "alliance", "human", "dwarf", "nightelf", "gnome", "skyborneA",
  "horde", "orc", "troll", "tauren", "undead", "skyborneH"];

/* Contraste WCAG (couleurs #rrggbb). */
function lum(hex) {
  const n = parseInt(hex.slice(1), 16);
  return [16, 8, 0].map((s) => {
    const c = ((n >> s) & 255) / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  }).reduce((a, c, i) => a + c * [0.2126, 0.7152, 0.0722][i], 0);
}
function contrast(a, b) {
  const x = lum(a), y = lum(b);
  return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05);
}
if (typeof module !== "undefined") module.exports = { THEMES, ORDER, SHARED, contrast };
