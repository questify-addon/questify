local addonName, Q = ...

-- Textes du flux C : navigation, automatisation des quêtes, choix de récompense.
Q:RegisterStrings({
  enUS = {
    NAV_SHORTESTPATH = "ShortestPath Forever",
    NAV_WAYPOINTUI = "WaypointUI",
    NAV_TOMTOM = "TomTom",
    NAV_NATIVE = "Built-in waypoint",
    NAV_CAVE_ENTER = "Cave entrance",
    NAV_CAVE_EXIT = "Cave exit",

    REWARD_UPGRADE = "Reward: %s (an upgrade over your equipped item)",
    REWARD_VENDOR = "Reward: %s (nothing improves your gear, so the highest vendor price: %s)",
    REWARD_NOT_LOADED = "Reward items are not loaded yet: choose your reward yourself.",
    REWARD_VALUE = "Reward: %s (the highest vendor price, as set in the options: %s)",
    REWARD_MARK_UPGRADE = "Upgrade for %s",
    REWARD_MARK_UPGRADE_SLOT = "Upgrade for %s · %s",
    REWARD_MARK_NO_UPGRADE = "Not an upgrade",
    REWARD_MARK_COIN = "Sells for the most",
    COIN_GOLD = "g",
    COIN_SILVER = "s",
    COIN_COPPER = "c",
  },
  frFR = {
    NAV_SHORTESTPATH = "ShortestPath Forever",
    NAV_WAYPOINTUI = "WaypointUI",
    NAV_TOMTOM = "TomTom",
    NAV_NATIVE = "Marqueur du jeu",
    NAV_CAVE_ENTER = "Entrée de la grotte",
    NAV_CAVE_EXIT = "Sortie de la grotte",

    REWARD_UPGRADE = "Récompense : %s (meilleure que ton objet équipé)",
    REWARD_VENDOR = "Récompense : %s (rien n'améliore ton équipement, donc le plus gros prix de revente : %s)",
    REWARD_NOT_LOADED = "Les objets de récompense ne sont pas encore chargés : choisis ta récompense toi-même.",
    REWARD_VALUE = "Récompense : %s (le plus gros prix de revente, comme réglé dans les options : %s)",
    REWARD_MARK_UPGRADE = "Amélioration pour %s",
    REWARD_MARK_UPGRADE_SLOT = "Amélioration pour %s · %s",
    REWARD_MARK_NO_UPGRADE = "Pas une amélioration",
    REWARD_MARK_COIN = "Se revend le plus cher",
    COIN_GOLD = "po",
    COIN_SILVER = "pa",
    COIN_COPPER = "pc",
  },
})
