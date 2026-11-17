local addonName, Q = ...

-- Textes du conseil « quête peu rentable » (Engine/QuestValue.lua, UI/QuestValue.lua). Les clés
-- commencent par QV_, sauf la raison d'étape (REASON_DROPPED) et l'aide de l'option (OPT_TIP_QUESTVALUE).
Q:RegisterStrings({
  enUS = {
    QV_OPT = "Offer to skip quests no longer worth it (gray, too high, elites without a group)",
    OPT_TIP_QUESTVALUE = "Under the current step, the tracker says why a quest is no longer worth your time and the XP you would lose, and offers to skip it with its follow-ups, keep it, grind, change zone or look for a group. Nothing is ever skipped without a click.",
    REASON_DROPPED = "Skipped: not worth it",
    QV_THOUSANDS = ",",

    QV_WHY_GRAY = "Gray quest: %s XP instead of %s.",
    QV_WHY_GRAY_NOXP = "Gray quest for your level.",
    QV_WHY_HIGH = "Too high: monsters level %s (you: %d).",
    QV_WHY_HIGH_QUEST = "Too high: quest level %d (you: %d).",
    QV_WHY_GROUP_ELITES = "Group quest: %d elites to kill, you are alone.",
    QV_WHY_GROUP_ELITE = "Group quest: an elite to kill, you are alone.",
    QV_WHY_GROUP_SUGGESTED = "Group quest (%d players suggested), you are alone.",

    QV_LOST = "Skip: -%s XP.",
    QV_LOST_WITH_SUITE = "Skip, with its follow-up: -%s XP.",
    QV_LOST_WITH_SUITES = "Skip, with its %d follow-ups: -%s XP.",
    QV_LOST_SUITE = "With its follow-up (%s, lvl %d): -%s XP.",
    QV_LOST_SUITES = "With its %d follow-ups: -%s XP.",

    QV_BTN_SKIP = "Skip",
    QV_BTN_SKIP_ABANDON = "Skip and abandon",
    QV_BTN_KEEP = "Keep",
    QV_BTN_DETOUR = "Backup zone",
    QV_BTN_BASH = "Grind to %d",
    QV_BTN_GROUP = "Find a group",
    QV_BTN_UNDO = "Undo",

    QV_TIP_SKIP = "Skips this quest and its follow-ups in the route. Undo for 10 s, then click the step in the journal or /qf back.",
    QV_TIP_SKIP_ABANDON = "Skips this quest and its follow-ups in the route, and abandons them in your quest log after 10 s to free room. Undo until then.",
    QV_TIP_KEEP = "Keeps the quest: this advice will not come back for it.",
    QV_TIP_DETOUR = "Plays another zone suited to your level for a while, then comes back to the route.",
    QV_TIP_BASH = "Adds a step before the route: kill monsters around here until this level.",
    QV_TIP_GROUP = "Opens the chat line with a ready message: pick the channel and send it yourself.",
    QV_TIP_UNDO = "Puts the quest and its follow-ups back in the route.",

    QV_PENDING = "%s skipped (%d steps).",
    QV_PENDING_ABANDON = "%s skipped (%d steps). Abandoned in %d s.",
    QV_PENDING_SUITE = "%s skipped, with its follow-ups (%d steps).",
    QV_PENDING_SUITE_ABANDON = "%s skipped, with its follow-ups (%d steps). Abandoned in %d s.",

    QV_BASH_NOTE = "Kill monsters around here until this level, then the route resumes.",
    QV_LFG_MESSAGE = "LFG %s",
    QV_NO_DETOUR = "No backup zone fits your level right now.",
  },
  frFR = {
    QV_OPT = "Proposer de passer les quêtes peu rentables (grises, trop hautes, élites sans groupe)",
    OPT_TIP_QUESTVALUE = "Sous l'étape en cours, le suivi dit pourquoi une quête ne vaut plus le détour et l'XP perdue, et propose de la passer avec ses suites, de la garder, de bash, de changer de zone ou de chercher un groupe. Rien n'est jamais passé sans clic.",
    REASON_DROPPED = "Passée : peu rentable",
    QV_THOUSANDS = " ",

    QV_WHY_GRAY = "Quête grise : %s XP au lieu de %s.",
    QV_WHY_GRAY_NOXP = "Quête grise pour ton niveau.",
    QV_WHY_HIGH = "Trop haute : monstres niveau %s (vous : %d).",
    QV_WHY_HIGH_QUEST = "Trop haute : quête niveau %d (vous : %d).",
    QV_WHY_GROUP_ELITES = "Quête de groupe : %d élites à tuer, vous êtes seul.",
    QV_WHY_GROUP_ELITE = "Quête de groupe : un élite à tuer, vous êtes seul.",
    QV_WHY_GROUP_SUGGESTED = "Quête de groupe (%d joueurs conseillés), vous êtes seul.",

    QV_LOST = "Passer : -%s XP.",
    QV_LOST_WITH_SUITE = "Passer, avec sa suite : -%s XP.",
    QV_LOST_WITH_SUITES = "Passer, avec ses %d suites : -%s XP.",
    QV_LOST_SUITE = "Avec sa suite (%s, niv. %d) : -%s XP.",
    QV_LOST_SUITES = "Avec ses %d suites : -%s XP.",

    QV_BTN_SKIP = "Passer",
    QV_BTN_SKIP_ABANDON = "Passer et abandonner",
    QV_BTN_KEEP = "Garder",
    QV_BTN_DETOUR = "Zone de secours",
    QV_BTN_BASH = "Bash jusqu'au %d",
    QV_BTN_GROUP = "Chercher un groupe",
    QV_BTN_UNDO = "Annuler",

    QV_TIP_SKIP = "Passe la quête et ses suites dans la route. « Annuler » pendant 10 s, puis clic sur l'étape dans le journal ou /qf back.",
    QV_TIP_SKIP_ABANDON = "Passe la quête et ses suites dans la route, et les abandonne dans le journal de quêtes au bout de 10 s pour faire de la place. « Annuler » jusque-là.",
    QV_TIP_KEEP = "Garde la quête : ce conseil ne reviendra plus pour elle.",
    QV_TIP_DETOUR = "Joue un moment une autre zone adaptée à ton niveau, puis revient à la route.",
    QV_TIP_BASH = "Ajoute une étape avant la route : tuer les monstres du coin jusqu'à ce niveau.",
    QV_TIP_GROUP = "Ouvre la ligne de discussion avec un message prêt : choisis le canal et envoie-le toi-même.",
    QV_TIP_UNDO = "Remet la quête et ses suites dans la route.",

    QV_PENDING = "%s passée (%d étapes).",
    QV_PENDING_ABANDON = "%s passée (%d étapes). Abandon dans %d s.",
    QV_PENDING_SUITE = "%s passée, avec sa suite (%d étapes).",
    QV_PENDING_SUITE_ABANDON = "%s passée, avec sa suite (%d étapes). Abandon dans %d s.",

    QV_BASH_NOTE = "Tue les monstres du coin jusqu'à ce niveau, puis la route reprend.",
    QV_LFG_MESSAGE = "Cherche groupe pour %s",
    QV_NO_DETOUR = "Aucune zone de secours n'est adaptée à ton niveau pour l'instant.",
  },
})
