# topo-viz

Audio-reactive topographic ASCII terrain visualizer. Renders an animated landscape driven by live audio via cava. Bass drives terrain drift, volume controls scroll speed, spectral content steers direction.

Runs standalone alongside `radio` as a music visualizer, or in the bottom-left pane of the `live` livecoding session.

## Dependencies

- `python3` with `numpy` — `pip install numpy`
- `cava` — `brew install cava`

## Installation

1. Install dependencies above.
2. Copy `audio-feed.conf` to `~/.config/cava/audio-feed.conf`
3. Create a launcher on your PATH:

```bash
# ~/bin/topo-viz
#!/usr/bin/env bash
exec python3 /Users/dj/config/utilities/topo-viz/topo-viz.py "$@"
```

4. `chmod +x ~/bin/topo-viz`

## Usage

```
topo-viz    # start — cava launches and is managed automatically
```

| Key | Action |
|-----|--------|
| `q` / `Esc` | Quit |
| `c` | Cycle character mode |

**Character modes:** STRATA (contour lines + fill) → BLOCKS (density blocks) → STIPPLE (punctuation texture)

## Audio mapping

| Signal | Effect |
|--------|--------|
| Bass | Terrain drift angle / wander rate |
| Volume (RMS) | Scroll speed |
| Spectral centroid | Direction bias |

Steep power curves mean only near-peak levels produce significant motion — quiet passages leave the terrain nearly still.

## Notes

- Audio is read from a FIFO at `/tmp/topo-audio`. The FIFO and cava process are created fresh on each launch and cleaned up on exit.
- cava `autosens` calibrates over the first ~2 seconds; a warmup period discards those frames to prevent a startup speed burst.
- Palette: Verdigris — dark warm charcoal with phosphor green terrain peaks.
