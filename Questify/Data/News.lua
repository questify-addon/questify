local addonName, Q = ...

-- Nouveautés de chaque version, montrées une fois par la fenêtre des nouveautés (UI/News.lua).
-- Une entrée par version, de la plus ancienne à la plus récente :
--   version : numéro comparé par Q.VersionCheck.Compare (« 1.0.0 ») ; label : numéro affiché (« 1.0 ») ;
--   steps : une étape par nouveauté, dans l'ordre de la fenêtre :
--     id : textes NEWS_<id>_TAG, _TITLE, _TEXT, _P1 à _P3 (facultatifs), _GO (bouton), _WHERE
--          (chemin affiché) dans Locales/StringsNews.lua, en anglais et en français ;
--     icon : texture du jeu, ou "class" pour l'icône de la classe du joueur ;
--     go : où mène le bouton : { options = section de Core/OptionsSchema.lua }, { wizard = nom d'une
--          page de l'assistant (Q.UI.Wizard.PAGE_*) }, { journal = onglet } ou { slash = "commande /qf" }.
-- Une version sans nouveautés n'a pas d'entrée : la fenêtre ne s'ouvre pas.
Q.NewsData = {
  { version = "1.0.0", label = "1.0", steps = {
    { id = "THEME", icon = "Interface\\Icons\\INV_Misc_Gem_Variety_01", go = { options = "theme" } },
    { id = "NAV", icon = "Interface\\Icons\\Ability_Tracking", go = { options = "navigation" } },
    { id = "OBJ", icon = "Interface\\Icons\\INV_Misc_Note_01", go = { wizard = "PAGE_OBJECTIVES" } },
    { id = "MARKS", icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8", go = { wizard = "PAGE_MARKS" } },
    { id = "CLASS", icon = "class", go = { options = "classguide" } },
    { id = "TRAINER", icon = "Interface\\Icons\\INV_Misc_Book_09", go = { options = "class" } },
    { id = "LOOT", icon = "Interface\\Icons\\INV_Misc_Bag_08", go = { options = "loot" } },
    { id = "PACE", icon = "Interface\\Icons\\INV_Misc_PocketWatch_01", go = { journal = "pace" } },
    { id = "VALUE", icon = "Interface\\Icons\\Spell_Holy_BorrowedTime", go = { options = "comfort" } },
    { id = "AH", icon = "Interface\\Icons\\INV_Misc_Coin_01", go = { slash = "hv" } },
  } },
}
