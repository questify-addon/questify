local addonName, Q = ...

-- Textes du mode « Donjons » (Engine/DungeonMode.lua, UI/DungeonModePanel.lua, options). Toutes les clés
-- commencent par DGMODE_.
Q:RegisterStrings({
  enUS = {
    DGMODE_OPT = "Dungeon mode: level through every 5-player dungeon",
    DGMODE_OPT_TIP = "A second route for this character: it picks up the dungeon quests first, then runs each "
      .. "dungeon and wing, and clears a zone between two dungeons. The usual route is kept and you can come back to it.",
    DGMODE_OPT_OPEN = "Choose the dungeons of the route",
    DGMODE_OPT_OPEN_TIP = "One box per dungeon or wing, with its stars. Untick a dungeon to skip it and take "
      .. "the open-world alternative.",
    DGMODE_TITLE = "Dungeon mode",
    DGMODE_ENABLE = "Use the dungeon route for this character",
    DGMODE_UNAVAILABLE = "The dungeon route does not exist for this character yet.",
    DGMODE_HELP = "Ticked: the route takes every quest of the dungeon, then sends you inside. "
      .. "Unticked: the dungeon and its detours are skipped, and the open-world alternative is played.",
    DGMODE_STARS_HELP = "Stars: share of a level given by the quests of the dungeon (monster XP not counted).",
    DGMODE_ROW_WING = "%s: %s",
    DGMODE_ROW_LEVEL = "lvl %d",
    DGMODE_ROW_QUESTS = "%d/%d",
    DGMODE_BYPASS = "Skip instance",
    DGMODE_RESUME = "Run it",
    DGMODE_BYPASS_TIP = "No group? Keep the quests you picked up and move on: the instance steps are skipped "
      .. "and the open-world alternative is played. Click again to run the dungeon after all.",
    DGMODE_STATE_BYPASSED = "instance skipped",
    DGMODE_ROW_TIP_XP = "Quest XP: %d (%d%% of level %d)",
    DGMODE_ROW_TIP_XP_EST = "Quest XP: about %d (%d%% of level %d)",
    DGMODE_ROW_TIP_NOQUEST = "No quest for your faction.",
    DGMODE_ROW_TIP_RANGE = "Dungeon levels: %d-%d",
    DGMODE_ALL = "Tick all",
    DGMODE_NONE = "Untick all",
    DGMODE_WING_Graveyard = "Graveyard", DGMODE_WING_Library = "Library", DGMODE_WING_Armory = "Armory",
    DGMODE_WING_Cathedral = "Cathedral", DGMODE_WING_East = "East", DGMODE_WING_West = "West",
    DGMODE_WING_North = "North", DGMODE_WING_Live = "Live side", DGMODE_WING_Undead = "Undead side",
  },
  frFR = {
    DGMODE_OPT = "Mode Donjons : monter de niveau par tous les donjons 5 joueurs",
    DGMODE_OPT_TIP = "Un second parcours pour ce personnage : il prend d'abord les quêtes de donjon, enchaîne "
      .. "chaque donjon et chaque aile, et vide une zone entre deux donjons. Le parcours habituel est gardé, tu peux y revenir.",
    DGMODE_OPT_OPEN = "Choisir les donjons du parcours",
    DGMODE_OPT_OPEN_TIP = "Une case par donjon ou par aile, avec ses étoiles. Décoche un donjon pour le "
      .. "contourner et prendre l'alternative en extérieur.",
    DGMODE_TITLE = "Mode Donjons",
    DGMODE_ENABLE = "Suivre le parcours Donjons avec ce personnage",
    DGMODE_UNAVAILABLE = "Le parcours Donjons n'existe pas encore pour ce personnage.",
    DGMODE_HELP = "Case cochée : la route prend toutes les quêtes du donjon, puis t'y envoie. "
      .. "Case décochée : le donjon et ses détours sont sautés, et l'alternative en extérieur est jouée.",
    DGMODE_STARS_HELP = "Étoiles : part d'un niveau que donnent les quêtes du donjon (XP des monstres non comptée).",
    DGMODE_ROW_WING = "%s : %s",
    DGMODE_ROW_LEVEL = "niv. %d",
    DGMODE_ROW_QUESTS = "%d/%d",
    DGMODE_BYPASS = "Contourner",
    DGMODE_RESUME = "Le faire",
    DGMODE_BYPASS_TIP = "Pas de groupe ? Garde les quêtes prises et continue : les étapes de l'instance sont "
      .. "passées et l'alternative en extérieur est jouée. Clique à nouveau pour faire le donjon quand même.",
    DGMODE_STATE_BYPASSED = "instance contournée",
    DGMODE_ROW_TIP_XP = "XP de quêtes : %d (%d %% du niveau %d)",
    DGMODE_ROW_TIP_XP_EST = "XP de quêtes : environ %d (%d %% du niveau %d)",
    DGMODE_ROW_TIP_NOQUEST = "Aucune quête pour ta faction.",
    DGMODE_ROW_TIP_RANGE = "Niveaux du donjon : %d-%d",
    DGMODE_ALL = "Tout cocher",
    DGMODE_NONE = "Tout décocher",
    DGMODE_WING_Graveyard = "Cimetière", DGMODE_WING_Library = "Bibliothèque", DGMODE_WING_Armory = "Armurerie",
    DGMODE_WING_Cathedral = "Cathédrale", DGMODE_WING_East = "Est", DGMODE_WING_West = "Ouest",
    DGMODE_WING_North = "Nord", DGMODE_WING_Live = "Côté vivant", DGMODE_WING_Undead = "Côté mort-vivant",
  },
})
