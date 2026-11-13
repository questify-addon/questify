Hi AzerothGPS team,

I maintain Questify, a free leveling guide for WoW: Forever (1-60).
Several of our players also use AzerothGPS.
They would like it to follow Questify the way it already follows RestedXP and Zygor.

To make that easy, Questify now publishes a small read-only API.
It works the same way as the RestedXP arrow you already read:

```lua
local d = QuestifyAPI and QuestifyAPI.Destination()
-- nil, or { key, mapID, x, y (0-1), title, manual, step = { guide, index, action }, via }
```

- `key` changes as soon as the place changes. When it changes, the previous stop is done.
- `x` and `y` use the same scale as Zygor's waypoint. `Import.ToStop({ mapID = d.mapID, x = d.x * 100, y = d.y * 100 })` gives the stop directly.
- `via` lists Questify's cave mouths (exit, then enter). It is optional, because your router already knows the caves.

There is nothing to subscribe to and nothing to call in Questify.
You only need to poll it every 0.5 s, as RestedXP.lua does.
The full description is in Questify's `docs/API.md`.

I also wrote a ready-to-use `Questify.lua` for AzerothGPS, attached to this message.
It is a copy of your Zygor.lua adapted to Questify:
- It is on by default when Questify is loaded.
- Only one guide runs at a time.
- It uses the same floor heights as Zygor (Data/GuideFloors.lua, NPCs the player talked to).
- The stop is done when Questify moves on, not when the player arrives.

To wire it in, you need these small changes:

1. `AzerothGPS.toc`: add `Questify.lua` after `Zygor.lua`.
2. `Nav.lua`, `Copy()`: keep `questify = d.questify` and `questifyVia = d.questifyVia`.
3. `Nav.lua`, near line 3714: `if d.rxp or d.zygor or d.questify then at = false end`.
4. `GPSFrame.lua`, `QUICK`: add a `questifyRoute` button, built like `zygorRoute`, that calls `ns.Questify.Toggle()`.
5. `RestedXP.lua` and `Zygor.lua`: in `On()`, return false by default when `cdb.questifyFollow == true`. In `Toggle()`, also turn Questify Route off (one guide at a time).
6. `Tutorial.lua`: add `"questifyFollow"` to `CHAR_KEYS` and to the two resets that clear `rxpFollow` and `zygorFollow`.
7. Locales: add the new "Questify Route" strings.

The API is versioned (`QuestifyAPI.version`, now 1).
We will keep its fields stable.

If anything is missing, or if you would prefer another format, tell me and I will change it on our side.

Thanks for AzerothGPS!

The Questify team
