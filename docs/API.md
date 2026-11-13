# Questify public API

Questify publishes where its guide is sending the player, for navigation addons (map routers, arrows).
It is read only: nothing in Questify changes when you read it.

```lua
local api = _G.QuestifyAPI          -- nil when Questify isn't loaded
api.version                         -- 1
local d = api.Destination()         -- nil, or the table below
```

Read it on a timer, every 0.5 s for instance, the same way you would read RestedXP's or Zygor's arrow.
You don't need to subscribe to anything.

| Field | Meaning |
|---|---|
| `key` | A string that changes as soon as the place changes: the next step, another objective, a moving target (the nearest mob of a "kill" step). Same key means same stop. When the key changes, the previous stop is done. |
| `mapID` | The `uiMapID` of the point. |
| `x`, `y` | Position on that map, from 0 to 1. |
| `title` | The step's text, such as "Talk to Gryan Stoutmantle". It may be empty. |
| `manual` | `true` when the player picked this point on Questify's map pins. |
| `step` | `{ guide = chapter id, index = step number, action = "accept" / "turnin" / "complete" / "goto" / ... }`, or `nil` for a point picked by hand. |
| `via` | Questify's cave detours, to take in order before the point: `{ { mapID, x, y (0-1), kind = "exit" or "enter", cave = cave id }, ... }`, or `nil`. This field is optional: a router that already knows the caves can ignore it. |

`Destination()` returns `nil` when there is nowhere to go: a step done where the player stands, the guide finished, or the guide paused.

Each call returns a new table, so you can keep it or change it.

Questify keeps a moving target on the same mob until the player reaches it or a much closer one appears, so `key` does not change on every call.

`version` goes up only when a field changes meaning or is removed. New fields can appear without a version change.
