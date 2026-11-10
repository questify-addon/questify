-- Tests des corrections manuelles de overrides.lua appliquées par build.lua.
local H = require("helpers")

local function build() return assert(loadfile(H.ROOT .. "/build.lua"))("--as-module") end

return {
  -- notes : texte ajouté à l'étape accept / turnin d'une quête, partout où elle est générée. Cas de Stepping
  -- Stones (79192) : aux Tarides, la Nailed Plank la donne, pas les Burned-Out Remains voisines (même quête au
  -- départ dans QuestieDB), et le suivi nomme l'objet le plus proche du joueur.
  notes_on_accept_and_turnin = function(t)
    local b = build()
    local ov = { notes = { [79192] = { accept = "Click the Nailed Plank" }, [79008] = { turnin = "Either object" } } }
    local steps = {
      { "turnin", 79008 },
      { "accept", 79192 },
      { "turnin", 79192, xp = 970 },
      { "accept", 96137, note = "Loot Ira's Dagger to start the quest" },
    }
    b.applyNotes(steps, ov)
    t.eq(steps[1].note, "Either object")
    t.eq(steps[2].note, "Click the Nailed Plank")
    t.eq(steps[3].note, nil, "turnin of 79192 has no note")
    t.eq(steps[4].note, "Loot Ira's Dagger to start the quest", "other quests untouched")
    -- une note déjà générée (objet de départ lâché par un mob) est gardée, la correction s'y ajoute
    local s2 = { { "accept", 79192, note = "Loot X to start the quest" } }
    b.applyNotes(s2, ov)
    t.eq(s2[1].note, "Loot X to start the quest. Click the Nailed Plank")
    -- fichier de corrections sans `notes`
    b.applyNotes(s2, {})
  end,

  loaded_overrides_have_notes_for_stepping_stones = function(t)
    local b = build()
    local ov = b.loadOverrides(H.ROOT .. "/overrides.lua")
    t.eq(type(ov.notes), "table")
    t.ok(type(ov.notes[79192]) == "table" and type(ov.notes[79192].accept) == "string", "accept note of 79192")
    t.ok(ov.notes[79192].accept:find("Nailed Plank", 1, true), ov.notes[79192].accept)
  end,
}
