# Changelog

---

## 2026-06-27

### topo-viz — moved to ~/config/utilities/topo-viz/
- **What:** Source at `~/config/utilities/topo-viz/topo-viz.py`; `~/bin/topo-viz` launcher updated
- **Why:** Qualifies as a deployable utility; config repo is canonical home for anything working

### topo-viz — stale FIFO startup burst fixed
- **What:** `_start_audio_feed()` now always kills any existing cava process and recreates the FIFO before starting fresh
- **Why:** If topo-viz was killed without clean exit, cava kept running and buffered output in the FIFO. Next launch read stale data (up to ~430 frames), causing a burst-then-slow motion artifact

### cava (main config) — switched to mono
- **What:** `channels = stereo` → `channels = mono` in `~/.config/cava/config`
- **Why:** Stereo display mirrors the spectrum (low frequencies on both edges); mono gives a clean single sweep from low to high

### CLAUDE.md + CHANGELOG.md — created
- **What:** Operating procedure documented in `CLAUDE.md`; `CHANGELOG.md` started (this file)
- **Why:** Establish durable process so future sessions log changes, maintain docs, and sync to ~/config

### guides — synced to ~/config/mac-config/docs/
- **What:** `guide-tidal.md` and `guide-orca.md` copied to `~/config/mac-config/docs/`
- **Why:** Manuals belong in the deployable config repo

---

## 2026-06-26

### topo-viz — autosens warmup added
- **What:** `_audio_thread` discards first 120 frames from cava before feeding the Audio EMA
- **Why:** `autosens = 1` produces uncalibrated high values at cava startup (~2s); warmup prevents these from driving a false speed spike

### topo-viz — direction experiments reverted
- **What:** Rolled back `base_angle` direction-randomization attempt; current code: noise wander + centroid bias only
- **Why:** Adding a random base direction caused oscillation (angle swung ±126° around base, terrain reversed); visual quality degraded

### topo-viz — centroid → direction added
- **What:** Spectral centroid (EMA 0.04) steers drift angle with ±90° bias
- **Why:** User requested that overall frequency content influence travel direction, so different music produces different paths

### topo-viz — audio reactivity tuned
- **What:** Bass → wander angle (power 1.5), RMS → scroll speed (power 2.5, target 0.009); silence floor 0.025
- **Why:** User requested subtle curves where only near-peak levels produce significant motion; quiet passages leave terrain still

### topo-viz — FIFO fix (cava raw output on macOS)
- **What:** `AUDIO_FILE` created as a named FIFO (`os.mkfifo`); removed `seek(0,2)` from audio thread; inner loop breaks on EOF
- **Why:** cava's raw output method silently writes nothing to a regular file on macOS; FIFO is required

### topo-viz — renamed from topo-term.py
- **What:** Script renamed to `topo-viz.py`; launcher at `~/bin/topo-viz` created
- **Why:** Name better reflects what it does; launcher puts it on PATH

### live-orca — session launcher created
- **What:** `~/bin/live-orca` — tmux session with ORCA (main pane), sclang (right 25%), scratch pane
- **Why:** Dedicated ORCA livecoding environment; MIDI routed via IAC Driver to SuperCollider

### live — session updated to 4-pane layout
- **What:** `~/bin/live` rebuilt for 4 panes: sclang (TL), GHCi/Tidal (TR), topo-viz (BL), nvim (BR)
- **Why:** Previous script only created 3 panes; added topo-viz to bottom-left

### glow — doc alias added
- **What:** `alias doc='glow -p -w 80'` in `~/.zshrc`
- **Why:** Default width in a full terminal is too wide for comfortable reading; 80-column paged output is the right default

### guide-tidal.md + guide-orca.md — created
- **What:** Comprehensive livecoding manuals covering full syntax, effects, recipes (ambient / dub techno / breakbeat), session arc, performance tips
- **Why:** Offline reference for live sessions; tailored to this setup (SuperDirt, IAC Driver, tmux pane layout)

### Tidal — dub techno recipes fixed
- **What:** Kick updated to use `808bd` for sub weight; chord stab uses `cat[]` for variation across measures; texture track added
- **Why:** `bd` sample was too thin; chord was static; recipes in guide needed to match genre conventions

### Tidal — breakbeat recipe fixed
- **What:** Replaced non-existent `break` sample with `breaks125`/`breaks152`
- **Why:** `break` does not exist in default SuperDirt library; correct names follow `breaks<bpm>` convention

---

## 2026-06-15 to 2026-06-25 (initial setup)

### topo-viz — initial creation
- **What:** `topo-viz.py` — audio-reactive topographic ASCII terrain; warped fBm noise, half-resolution upsampling, ANSI cursor positioning, Verdigris palette
- **Why:** Music visualizer for terminal; complements the livecoding and radio setup

### cava — audio-feed config
- **What:** `~/.config/cava/audio-feed.conf` — raw ASCII output, 32 bars, 60fps, `/tmp/topo-audio` FIFO
- **Why:** Dedicated cava instance for topo-viz, separate from the interactive visualizer

### Ghostty — Verdigris theme applied
- **What:** `foreground = #D0CAB8`, `background = #161614`, `minimum-contrast = 1.2`, `palette = 8=#6e6860`; font JetBrains Mono Nerd 14pt
- **Why:** Switched from phosphor green to Verdigris design system; minimum-contrast 1.2 keeps ORCA grid visible without overbearing dim text

### ORCA — built and configured
- **What:** Built from source at `~/code/orca-c`; launcher `~/bin/orca` with `--initial-size 57x25`; IAC Driver enabled for CoreMIDI virtual bus
- **Why:** ORCA requires terminal MIDI bridge; IAC Driver is the macOS native solution

### SuperCollider / SuperDirt — installed
- **What:** `/Applications/SuperCollider.app`; `sclang`/`scsynth` symlinked to `~/bin`; startup.scd auto-boots SuperDirt; sc3plugins built from source
- **Why:** Audio backend for TidalCycles; sc3plugins adds extended synth library (supersaw, superpiano, superfm, etc.)

### TidalCycles — installed
- **What:** `cabal install --lib tidal` (1.10.2, GHC 9.14.1); boot file `~/.config/tidal/BootTidal.hs`; vim-tidal for nvim integration
- **Why:** Primary livecoding environment; Haskell-based pattern language

### bat — Verdigris theme
- **What:** `~/.config/bat/themes/Verdigris.tmTheme`; aliased as `cat`
- **Why:** Consistent color palette across all terminal output; replaces default syntax highlighting

### Core tools installed
- **What:** eza, bat, fzf, zoxide, lazygit, ripgrep, fd, btop, ncdu, yazi, posting, glow, tmux + tmux-resurrect, Starship, Node + Prettier
- **Why:** Terminal-first workflow; replaces GUI tools where possible; each earns its place by reducing friction on a constrained machine
