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
