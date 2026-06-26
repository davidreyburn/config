# Mac Setup Tracker

New MacBook — setup started 2026-06-15.

## Goal

This machine is intentionally underpowered. The constraint is the point — it forces maximum efficiency through terminal tools, keyboard shortcuts, aliases, and lightweight workflows. The aim is to minimize resource usage and time-to-task across everything.

This document tracks what has been set up, what worked, and what didn't. The long-term goal is a fully deployable config: scripts, dotfiles, and tool lists that can reproduce this environment on any machine from scratch.

Every tool added here should earn its place. Prefer CLI over GUI, keyboard over mouse, lean over full-featured.

---

## macOS Preferences

- **Finder default view**: List view (set via View → Show View Options → Always open in list view)
- **Finder icon view**: Snap to grid enabled

---

## Core Tools

### Homebrew
- Package manager for macOS
- Install: https://brew.sh
- Used to install: mpv, and anything else going into `/opt/homebrew/bin/`

### Ghostty
- Terminal emulator
- Config: `~/.config/ghostty/config`
- Docs: `../ghostty/CLAUDE.md`

### mpv
- Installed via Homebrew
- Used as the audio backend for the `radio` script

---

## Applications

### radio
- Custom terminal internet radio player
- Location: `/opt/homebrew/bin/radio` (in PATH, runnable as `radio`)
- Docs: `../radio/CLAUDE.md`
- Depends on: mpv, Ghostty (for tab title via OSC escape)

---

## Configuration

### SSH (`~/.ssh/`)

- Key type: ed25519, tagged `reyburn.david@gmail.com`
- Private key: `~/.ssh/id_ed25519` (stays on this machine)
- Public key: `~/.ssh/id_ed25519.pub` (paste this into external services)
- Config: `~/.ssh/config` — auto-adds key to agent, uses macOS Keychain
- Added to macOS Keychain — persists across reboots

**GitHub:** SSH key added via `gh auth login`

#### aleph (`192.168.1.192`, user: `chives`)
- New key installed and tested — `ssh aleph` works
- A separate pre-existing key was used to bootstrap access — deleted from this machine after install

### Git (`~/.gitconfig`)

- `user.name` — David Reyburn
- `user.email` — reyburn.david@gmail.com
- `core.editor` — nano
- `init.defaultBranch` — main
- `core.excludesfile` — `~/.gitignore_global` (ignores `.DS_Store` system-wide)

### Shell (`~/.zshrc`)

- **zsh-autosuggestions** — grey inline suggestions from history; right arrow to accept (brew)
- **zsh-syntax-highlighting** — live command coloring green/red (brew)
- **fzf** — fuzzy `Ctrl+R` history search, `Ctrl+T` file search (with bat preview), `Alt+C` dir jump (brew)
- **History** — 10k entries, persisted to `~/.zsh_history`, shared across tabs, deduped

### Aliases

| Alias | Command | Notes |
|-------|---------|-------|
| `z` | SSH → aleph → openclaw Docker | Connects to openclaw agent |
| `ls` | `eza --icons` | Replaces ls |
| `ll` | `eza --icons -la --git` | Long list with git status |
| `lt` | `eza --icons --tree --level=2` | Tree view |
| `cat` | `bat --style=plain` | Replaces cat with syntax highlighting |
| `lg` | `lazygit` | TUI git client |
| `j` | `zoxide` | Smart directory jump (learns habits) |
| `live` | `~/bin/live` | Start full Tidal livecoding session |

### Ghostty theme
- Phosphor green CRT aesthetic tuned for the MacBook Neo Citrus colorway
- Font: JetBrains Mono 14pt
- Colors: `#39FF39` foreground on `#141a03` background, 95% opacity
- Quick terminal: right edge, `Cmd+\``
- Scanline shader written but disabled (performance/battery)
- Full details: `../ghostty/CLAUDE.md`

---

## Fonts

- JetBrains Mono — installed via Homebrew (`brew install --cask font-jetbrains-mono`)
- JetBrainsMono Nerd Font — installed via Homebrew (`brew install --cask font-jetbrains-mono-nerd-font`), active in Ghostty (required for Neovim icons)

---

### GitHub CLI (`gh`)

- Installed via Homebrew
- Authenticated via `gh auth login`
- SSH key added to GitHub during auth

### Neovim (`~/.config/nvim/`)

- Installed via Homebrew (`brew install neovim`) — v0.12.3
- Config: kickstart.nvim (cloned from `nvim-lua/kickstart.nvim`)
- Plugin manager: `vim.pack` (built into Neovim 0.12 — no lazy.nvim)
- Dependencies: `ripgrep`, `fd` (for Telescope), `tree-sitter-cli` (for Treesitter parsers)
- To install/update plugins: open nvim and run `:lua vim.pack.update()`
- Nerd Font flag set to `true` in init.lua

### ripgrep + fd

- Installed via Homebrew as Neovim/Telescope dependencies
- `ripgrep` — fast grep, also useful standalone (`rg`)
- `fd` — fast `find` alternative, also useful standalone

### eza

- Installed via Homebrew
- Modern `ls` replacement with icons, colors, git status
- Aliased: `ls`, `ll` (long + git), `lt` (tree)

### bat

- Installed via Homebrew
- `cat` replacement with syntax highlighting and line numbers
- Aliased as `cat`; used as fzf file preview
- Theme: **Verdigris** — retro refined; bone text, muted phosphor green, aged teal/orange/blue/purple
  - File: `~/.config/bat/themes/Verdigris.tmTheme`
  - Config: `~/.config/bat/config`
  - Palette: bone `#D0CAB8` · green `#44BB44` · orange `#C4834A` · teal `#4AACA4` · blue `#5B8DB8` · purple `#8855BB` · lime `#AAFF00` (numbers)

### zoxide

- Installed via Homebrew
- Smart `cd` that learns frequent directories
- Invoked as `j` (avoids conflict with `z` SSH alias)
- Example: `j know` → `~/knowledge`, `j dun` → `~/dungeonworld`

### lazygit

- Installed via Homebrew (`lg` alias)
- Full TUI for git: stage hunks, browse diffs, view history, resolve conflicts

### Starship

- Installed via Homebrew
- Config: `~/.config/starship.toml` — phosphor-themed two-line prompt
- **Line 1:** directory (bright green) · git branch (amber) · git status · Python/Haskell version when relevant · background jobs · time (right-aligned) · battery
- **Line 2:** `❯` character (amber on error, shows exit code)
- Battery icon changes shape (█ → ▄ → ▂) and goes amber under 20%
- Username/hostname only appear when SSH'd (e.g. into aleph)

### btop

- Installed via Homebrew
- TUI system monitor — CPU, memory, processes, network. Run: `btop`

### glow

- Installed via Homebrew
- Renders markdown in the terminal. Run: `glow <file.md>` or `glow` to browse
- Useful for reading `~/knowledge` and `~/dungeonworld` notes without opening Neovim

### yazi

- Installed via Homebrew
- TUI file manager with preview panes (markdown, images, code via bat)
- Run: `yazi`

### posting

- Installed via Homebrew
- TUI HTTP client (terminal Postman). Run: `posting`

### ncdu

- Installed via Homebrew
- TUI disk usage analyser. Run: `ncdu` to scan current directory
- Useful for finding space hogs on a constrained machine

### tmux

- Installed via Homebrew
- Config: `~/.tmux.conf`
- Prefix: `Ctrl+a`
- Docs: `cheatsheet.md` (tmux section)

### tmux-resurrect

- Cloned to `~/.tmux/plugins/tmux-resurrect`
- Saves and restores tmux sessions across reboots
- `Ctrl+a Ctrl+s` — save, `Ctrl+a Ctrl+r` — restore

### Node + Prettier

- Node installed via Homebrew (required for Prettier)
- Prettier installed globally via npm
- Used by conform.nvim to format markdown on `Space+f`

---

## Music / Livecoding

### FluidSynth

- Installed via Homebrew
- Soundfont: `/usr/local/share/soundfonts/GeneralUser-GS.sf2`
- Used as MIDI synth backend for ORCA
- Docs: `../livecode/CLAUDE.md`

### SuperCollider / SuperDirt

- Installed as `/Applications/SuperCollider.app`
- `sclang` and `scsynth` symlinked to `~/bin/` for terminal use
- Startup file: `~/Library/Application Support/SuperCollider/startup.scd` — boots SuperDirt automatically
- `sclang_conf.yaml` includes SCClassLibrary path explicitly (required for CLI)
- Docs: `../livecode/CLAUDE.md`

### TidalCycles

- Installed via `cabal install --lib tidal` (tidal 1.10.2, GHC 9.14.1)
- GHC + cabal installed via Homebrew; Hackage mirror fixed to use HTTPS
- Boot file: `~/.config/tidal/BootTidal.hs`
- Docs: `../livecode/CLAUDE.md`

### ORCA

- Built from source at `~/code/orca-c`
- Launcher: `~/bin/orca` — runs with `--initial-size 57x25`
- Quit: `Ctrl+Q` (not `Ctrl+C` — TUI app)
- Docs: `../livecode/CLAUDE.md`

### live (session launcher)

- Location: `~/bin/live`
- Starts (or reattaches to) a tmux session with sclang, GHCi, and nvim pre-arranged
- Run: `live`

---

## Neovim plugins summary

| Plugin | Purpose |
|--------|---------|
| kickstart.nvim | Base config |
| vim.pack | Built-in plugin manager (Neovim 0.12+) |
| Telescope | Fuzzy finder (`Space+s*`) |
| neo-tree | File browser (`\`) |
| nvim-treesitter | Syntax parsing (markdown, haskell, lua, etc.) |
| markview.nvim | In-buffer markdown rendering |
| conform.nvim | Formatting (`Space+f`) — prettier for markdown, black for Python |
| vim-tidal | Send `.tidal` patterns to GHCi |
| LSP (pyright, lua-ls) | Code intelligence for Python and Lua |
| blink.cmp | Autocomplete |
| which-key | Keymap hints |
| gitsigns | Git status in gutter |

---

## To Do / Not Yet Done

- [x] Document how JetBrains Mono was installed
- [x] Shell setup
- [x] Git config
- [x] SSH keys (key generated; GitHub not yet configured)
- [x] sc3plugins — built from source (`~/code/sc3-plugins`), installed to `~/Library/Application Support/SuperCollider/Extensions/SC3plugins`
