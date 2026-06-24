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

**Pending:** Add public key to GitHub (Settings → SSH and GPG keys → New SSH key)

#### aleph (`192.168.1.192`, user: `chives`)
- New key installed and tested — `ssh aleph` works
- A separate pre-existing key was used to bootstrap access — deleted from this machine after install

### Git (`~/.gitconfig`)

- `user.name` — David Reyburn
- `user.email` — reyburn.david@gmail.com
- `core.editor` — nano
- `init.defaultBranch` — main
- `core.excludesfile` — `~/.gitignore_global` (ignores `.DS_Store` system-wide)

### Aliases

| Alias | Action |
|-------|--------|
| `z` | SSH into aleph and connect to openclaw agent via Docker |

### Shell (`~/.zshrc`)

- **zsh-autosuggestions** — grey inline suggestions from history; right arrow to accept (brew)
- **zsh-syntax-highlighting** — live command coloring green/red (brew)
- **fzf** — fuzzy `Ctrl+R` history search, `Ctrl+T` file search, `Alt+C` dir jump (brew)
- **History** — 10k entries, persisted to `~/.zsh_history`, shared across tabs, deduped

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

## To Do / Not Yet Done

- [x] Document how JetBrains Mono was installed
- [x] Shell setup
- [x] Git config
- [x] SSH keys (key generated; GitHub not yet configured)
