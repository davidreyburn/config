# radio

Terminal internet radio player. Wraps `mpv` with a channel list, in-process station switching, and live track metadata in the tab title.

## Dependencies

- `mpv` — `brew install mpv`

## Installation

Copy or symlink the script somewhere on your PATH:

```bash
cp radio /opt/homebrew/bin/radio
# or
ln -sf "$PWD/radio" /opt/homebrew/bin/radio
```

## Usage

```
radio          # list channels
radio 0        # random channel
radio <n>      # play channel n
```

While playing:
- `>` / `<` — next / previous station (terminal focused)
- `NEXT` / `PREV` media keys — next / previous (works system-wide while mpv holds the audio session)
- `Ctrl-C` — stop

Stations wrap around at both ends.

## Channels

| # | Name |
|---|------|
| 1 | Groove Salad — SomaFM |
| 2 | Space Station Soma — SomaFM |
| 3 | Deep Space One — SomaFM |
| 4 | Drone Zone — SomaFM |
| 5 | Synphaera — SomaFM |
| 6 | Fluid — SomaFM |
| 7 | Beat Blender — SomaFM |
| 8 | Mellow Mix — Radio Paradise |
| 9 | Nonstop Casiopea |
| 10 | SmoothLounge.com |
| 11 | Echoes of Bluemars |
| 12 | Cryosleep — Bluemars |
| 13 | Klassik Radio — Pure Piano |

## Adding a channel

Append to both `NAMES` and `URLS` arrays at the top of the script — they must stay in sync. Numbering and random selection update automatically.

```bash
NAMES=(
  ...
  "New Station — Source"   # ← add here
)

URLS=(
  ...
  "https://example.com/stream.mp3"   # ← and here
)
```

## How it works

On each invocation `play()` writes a Lua script to `/tmp/radio_$$.lua` (PID-scoped to avoid conflicts) and passes it to mpv via `--script`. The script is deleted when mpv exits.

The Lua script embeds the full channel list and starting index so it can manage state across station switches without restarting the mpv process. It:

- Observes the `media-title` property (ICY stream metadata) and prints each new track to stdout
- Sets the terminal tab title via OSC escape sequence: `Station: Artist - Track`
- Resets the tab title on shutdown
- Binds `NEXT`/`PREV` media keys and `>`/`<` keyboard shortcuts to `mp.commandv("loadfile", ...)` for seamless in-process switching

mpv is launched with `--no-video --really-quiet` (audio only, no terminal noise).

> macOS `mktemp` doesn't support filename suffixes, so the temp file is named directly with `$$` rather than using `mktemp`.
