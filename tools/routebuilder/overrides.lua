-- tools/routebuilder/overrides.lua : corrections manuelles appliquées par build.lua après relecture
-- des rapports (docs/routes/<planId>.md). Fichier de données pur (chargé dans un environnement vide).
--
--   force       = { [questId] = true }                 -- garder la quête même si écartée (rendement, niveau)
--   drop        = { [questId] = "raison" }             -- écarter la quête (raison reprise dans le rapport)
--   pin         = { [questId] = { mapId, x, y } }      -- site d'objectif imposé (0-100)
--   insertAfter = { [planId] = { { afterQuestTurnin = questId, step = { "note", "..." } }, ... } }
--                                                      -- étape ajoutée après le rendu d'une quête
--                                                      -- (afterQuestTurnin = 0 : en tête du chapitre)
--   pre         = { [questId] = { prérequis } }         -- prérequis absents de QuestieDB (un au choix, comme
--                                                      -- preQuestSingle) ; build.lua et validate_guides.lua
--   notes       = { [questId] = { accept = "...", turnin = "..." } }
--                                                      -- texte ajouté à l'étape accept / turnin de la quête
-- Les textes des étapes `note` sont en anglais, comme toutes les notes générées (affichées telles quelles).
-- Les notes de donjon sont `optional` : masquées quand les quêtes de donjon sont désactivées.
return {
  force = {
    [140] = true, -- Captain Sander's Hidden Treasure (2e étape de la chaîne, rendement 7.3), écartée par le budget d'XP
  },
  drop = {
    [34] = "Bellygrub is a level 24 elite; done at 22 it drags Worgen in the Woods forward",
    [631] = "The Thandol Span (31, req 28) gates a 157-170 mob grind at Dun Modr",
    [217] = "In Defense of the King's Lands, last part: Grawmug (17) and his guards (16), never at a safe level in Loch Modan (11-14)",
    [1056] = "Journey to Stonetalon Peak: 1,133 yd detour for a flight path the route never uses",
  },
  pin = {
    -- QuestieDB v1.0.15 : Chol'aruk (élite 20) et des Razormane Berserker (élites 19) relevés en 57.18, 28.79, à côté
    -- du groupe de Plainstriders retenu jusque-là (57.1, 29.5) : quête écartée comme trop dangereuse avec Zhevra,
    -- Prowlers et Echeyakee. Groupe le plus dense sans élite à moins de 2 % de carte : moyenne des apparitions de
    -- Greater / Fleeting Plainstrider (3244, 3246) de la case 56-58 x 30-32. À vérifier en jeu.
    [844] = { 1413, 57.05, 31.02 },
    [98071] = { 1424, 70.0, 79.0 }, -- Brewer's Trade : Dun Garok (aucune donnée d'objectif)
    [98059] = { 1424, 29.7, 41.6 }, -- Hillsbrad's Hoard : table de l'hôtel de ville de Hillsbrad
    [11] = { 1429, 26.46, 86.65 }, -- Riverpaw Gnoll Bounty : groupe ouest (apparition de Riverpaw Runt 97), près de Westbrook
  },
  -- Chasse au trésor du Cozy Sleeping Bag (Forever, niveau requis 14) : QuestieDB n'a aucun lien entre les six
  -- quêtes, chacune commence à l'objet où la précédente se rend. Départ croisé : « ... and that note you found »
  -- se prend aux Burned-Out Remains de sa faction (79008 Alliance : Marche de l'Ouest ; 79007 Horde : Tarides) et
  -- se rend de l'autre côté, où la Nailed Plank donne Stepping Stones (guide Wowhead Forever du Cozy Sleeping Bag,
  -- 2026-11-08). Puis Pocket Litter et Mound of Dirt aux Serres-Rocheuses -> Carved Figurine au barrage du Loch
  -- Modan -> Messenger Bag en Arathi, qui donne le sac. Sans ces liens, H_02 faisait prendre Scramble seule, et la
  -- route Alliance prendre Stepping Stones à la planche de la Marche de l'Ouest, qui ne la donne pas à l'Alliance.
  pre = {
    [79192] = { 79007, 79008 }, -- Stepping Stones après la note de sa faction (rendue à l'autre bout du monde)
    [79980] = { 79192 }, -- Scramble après Stepping Stones
    [79974] = { 79980 }, -- Wet Job après Scramble
    [79975] = { 79974 }, -- Eagle's Fist après Wet Job
    [79976] = { 79975 }, -- This Must Be The Place après Eagle's Fist (récompense : Cozy Sleeping Bag 211527)
    -- Cité de Dalaran : préquêtes absentes de QuestieDB (commit c7ccd23), relevées dans l'addon DungeonJournal
    -- 2.0.9 (listes « requises pour débloquer », sans les quêtes facultatives) et cohérentes avec QuestieDB : An
    -- Alarming Request (92432) se rend à l'image de Modera (269127) qui donne les deux quêtes ; Blood in the Streets
    -- (92434) aussi, côté Horde, après Dalaran Patrols (545, qui suit Prison Break In 544). À vérifier en jeu.
    [92457] = { 92432 }, -- Starving Arcane après An Alarming Request (Alliance)
    [92458] = { 92432 }, -- Heart of Disruption après An Alarming Request (Alliance)
    [96984] = { 92434 }, -- Heart of Disruption après Blood in the Streets (Horde)
    [92434] = { 545 }, -- Blood in the Streets après Dalaran Patrols (Horde)
    -- Site de fouilles des Paluns (Alliance) : préquêtes absentes de QuestieDB (c7ccd23), relevées dans DungeonJournal
    -- 2.0.9 et vues en jeu (Highland Hides n'est proposée qu'après Young Crocolisk Skins, chez James Halloran).
    [98815] = { 484 }, -- Highland Hides après Young Crocolisk Skins
    [95646] = { 275 }, -- Horrors in the Highland après Blisters on The Land (Tramping Paws 276 -> Fire Taboo 277 -> 275)
    -- Chaînes de donjon relevées dans DungeonJournal 2.0.9 (2026-11-17), gardées seulement quand QuestieDB (c7ccd23)
    -- n'a aucune préquête pour la quête et que le PNJ qui rend l'une donne la suivante. Écartées : celles que
    -- QuestieDB contredit (chaînes en parallèle mises bout à bout, ordre inversé) et celles sans indice.
    [95682] = { 95663 }, -- Open the Maw après Dragonmaw Rumors
    [93404] = { 93594 }, -- Rot and Regret après Word of the Woods
    [92744] = { 92742 }, -- Murloc Gills après Testing the Wells
    [8420] = { 8419 }, -- Hot and Itchy après An Imp's Request
    [79946] = { 79945 }, -- A Brother In Need après Orders from the Grand Crusader
    [79940] = { 79939 }, -- A Lost Brother après The Broken Hammer
    [78092] = { 78091 }, -- It Must Be Destroyed après Earning Your Salt
    [78091] = { 78090 }, -- Earning Your Salt après A Second Opinion
    [78090] = { 78089 }, -- A Second Opinion après Advice From Stormwind
    [78089] = { 78088 }, -- Advice From Stormwind après A Strange Artifact
    [7623] = { 7564 }, -- Lord Banehollow après Wildeyes
    [6042] = { 6133 }, -- Un-Life's Little Annoyances après The Ranger Lord's Behest
    [6022] = { 6042 }, -- To Kill With Purpose après Un-Life's Little Annoyances
    [5544] = { 5543 }, -- Carrion Grubbage après Blood Tinged Skies
    [5543] = { 5542 }, -- Blood Tinged Skies après Demon Dogs
  },
  -- Quêtes de donjon en plus, par zone du donjon (build_dungeons.lua) : celles que la règle de zone de QuestieDB
  -- manque, relevées dans DungeonJournal 2.0.9 (2026-11-17) et vérifiées dans QuestieDB (présentes, ni de classe
  -- ni en liste noire). Les cinq donjons absents du catalogue (Blackmaw Hold, Krol'dok, Alcaz, Shaper's Terrace,
  -- Drowned City) et le pic Rochenoire n'y sont pas.
  dungeonQuests = {
    [491] = { 1144 }, -- RFK : Willix the Importer
    [719] = { 3765 }, -- BFD : The Corruption Abroad
    [721] = { 2948, 2950, 2951 }, -- GNOMER : Gnome Improvement, Nogg's Ring Redo, The Sparklematic 5200!
    [722] = { 3525 }, -- RFD : Extinguishing the Idol
    [796] = { 1394, 6141 }, -- SM : Final Passage, Brother Anton
    [1176] = { 2769 }, -- ZF : The Brassbolts Brothers
    [1337] = { 707, 2201, 2278 }, -- ULDAMAN : Ironband Wants You!, Find the Gems, The Platinum Discs
    [1477] = { 3373, 4143, 4146 }, -- ST : The Essence of Eranikus, Haze of Evil, Zapper Fuel
    [1581] = { 373 }, -- DM : The Unsent Letter
    [1584] = { 3982, 4083, 4201, 7604, 7848 }, -- BRD : What Is Going On?, The Spectral Chalice, The Love Potion, A Binding Contract, Attunement to the Core
    [2017] = { 5122, 5125, 5961 }, -- STRAT : The Medallion of Faith, Aurius' Reckoning, The Champion of the Banshee Queen
    [2100] = { 7046, 93404 }, -- MARAUDON : The Scepter of Celebras, Rot and Regret
    [2557] = { 5247, 5250, 5518, 5525, 5526, 7461, 7483, 7484, 7485, 7703 }, -- DIREMAUL : Fragments of the Past, Starfall, The Gordok Ogre Suit, Free Knot!, Shards of the Felvine, The Madness Within, Libram of Rapidity, Libram of Focus, Libram of Protection, Unfinished Gordok Business
    [16544] = { 96987 }, -- DALARAN : Opportunistic Education
    [16611] = { 92415, 95189, 95195, 95250 }, -- LORDAERON : Remember That I Love You, Crest of Lordaeron, Bloodied Insignia, Abominable Creatures
    [16732] = { 95682, 95795, 95809 }, -- EXCAVATION : Open the Maw, Fallen in the Fen, Heartwoven
    [16919] = { 96395, 98423 }, -- THANES : An Ancient Grudge, The Treaty of Understanding
  },
  notes = {
    -- QuestieDB fait partir Stepping Stones des quatre objets (Burned-Out Remains et Nailed Plank, Tarides et Marche
    -- de l'Ouest) et le suivi nomme le plus proche : aux Tarides (Alliance) comme à la ferme d'Alexston (Horde), les deux
    -- sont à quelques mètres l'un de l'autre. Texte sans lieu : il sert aux deux factions.
    [79192] = { accept = "Click the Nailed Plank: the Burned-Out Remains next to it do not give this quest" },
  },
  insertAfter = {
    A_DwarfGnome_03 = {
      { afterQuestTurnin = 301, step = { "note", "The Hall of Thanes is under Ironforge (levels 13-18): run it on this visit, or abandon Old Ironforge Incursion",
          optional = true, dungeon = "The Hall of Thanes" } },
    },
    A_04 = {
      { afterQuestTurnin = 0, step = { "note", "You pass through Stormwind: run The Stockade now for Crime and Punishment and What Comes Around..., or abandon them",
          optional = true, dungeon = "The Stockade" } },
      { afterQuestTurnin = 292, step = { "note", "Last pass near the Excavation Site: run it now, or abandon Highland Hides, Horrors in the Highland, Lost in the Thicket Things and Prehistoric Prism",
          optional = true, dungeon = "Excavation Site: Wetlands" } },
    },
  },
}
