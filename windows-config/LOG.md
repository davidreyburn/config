# pc-config

## Goal
Optimize this Windows machine's setup and configuration over time. This repo/directory is the
working space for tracking, planning, and applying improvements to David's Windows environment —
terminal, shells, dev tooling, typing/productivity apps, and general system config. Future sessions
should treat "make the Windows setup better" as the standing objective and build on what's recorded here.

## Machine
- **OS:** Windows 10 Pro (10.0.19045)
- **User:** David (also uses macOS — generally prefers the modern, polished tooling he has on Mac)
- **Terminal:** Windows Terminal (current daily driver)
- **Shells available:** PowerShell, Git Bash (MINGW64), cmd
- **Package managers:** winget (built-in). Scoop and npm/npx also viable; Scoop not yet installed.

## Visual / aesthetic preferences
- **Color palette:** CRT phosphor green (`#00ff41` or similar) on black/dark background.
- **Additional colors:** use sparingly where needed for contrast/clarity (e.g. red for errors, amber/yellow for warnings).
- **Font:** retro feel with modern readability — e.g. a monospace with slight character personality (Courier Prime, Fira Code, Cascadia Mono, or a bitmap-style font).
- **Priority:** readable contrast first, aesthetic second. Not pure monochrome — color is welcome where it helps.
- Apply this palette to: Windows Terminal profiles, Starship prompt, bat themes, any future UI config.

### Applied
- **Windows Terminal** — "Phosphor" color scheme (`#0d0d0d` bg, `#00ff41` fg, amber/red/cyan accents).
  **CaskaydiaCove Nerd Font** 12pt (Nerd Font patched Cascadia — required for Neovim/LazyVim icons).
  Settings at `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.
- **Neovim** — custom `phosphor` colorscheme (`colors/phosphor.lua`) with `termguicolors = true`.
  Green text, amber keywords, cyan types, red errors — derived from the Windows Terminal Phosphor palette.

## Preferences & context
- Came from macOS tools and wants the closest/best Windows equivalents.
- Likes **Ghostty** (Mac) — no official Windows build yet (mid-2026); community forks (Winghostty,
  ghostty-windows) exist but are unofficial/fast-moving. Sticking with Windows Terminal for now.
- Likes **gtypist** (Mac) for learning to touch type. Best Windows equivalents: run gtypist via
  WSL (most faithful, structured lessons) or use native terminal typing tools. Currently trying
  `monkeytype-cli` (npm; run via `monkey test` if installed globally, or `npx monkeytype-cli test`).
  ttyper (Scoop/cargo) is another native option but is a speed test, not a tutor.
  **ttyper is installed and configured:** config at `%APPDATA%\ttyper\config.toml` (theme, rounded
  borders, cyan/green/red colors, default language `english1000`). Word count and no-backtrack are
  CLI-only flags — baked into a `ttyper` function in PS7 `$PROFILE` that shadows the binary with
  `-w 25 --no-backtrack`. Just run `ttyper`.

## Installed tools & config

### PowerShell
- **PS7** installed (`winget install Microsoft.PowerShell`). Use the "PowerShell" profile in Windows
  Terminal (not "Windows PowerShell"). Set as default in Terminal settings.
- **PSReadLine** configured in PS7 `$PROFILE` (`OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`):
  history+plugin predictions, ListView style, cyan commands, green parameters.
- **Starship** prompt active in PS7 profile.
- **ttyper** alias: `ttyper` function in PS7 profile runs with `-w 25 --no-backtrack`.

### Git Bash
- **ble.sh** installed at `~/.local/share/blesh/ble.sh` (pre-built v0.4.0-devel3). Sourced in `~/.bashrc`.
  Provides fish-style syntax highlighting + autosuggestions.
- **ble.sh config** at `~/.blerc`: exit code marker suppressed (`exec_errexit_mark=`), autocomplete
  popup delay set to 800ms (`complete_auto_delay=800`; default 300ms).
- `~/.bashrc` sets `USER="${USER:-$USERNAME}"` before sourcing ble.sh to suppress the $USER warning
  (Git Bash on Windows doesn't set $USER by default).
- **Starship** prompt active via `~/.bashrc`.

### cmd
- **Clink** installed (`winget install chrisant996.Clink`). Auto-hooks into cmd on launch.
- **Starship** via Clink: lua script at `%LOCALAPPDATA%\clink\starship.lua`.

### Cross-shell
- **Starship** (`winget install Starship.Starship`) — consistent prompt across PS7, Git Bash, cmd.
  Config at `~/.config/starship.toml`. Modules active: directory, git branch/status/state,
  cmd_duration (2s+), Node.js, Python (with virtualenv), time (HH:MM). Colors: bold green for
  directory/prompt, amber/yellow for git, dimmed green for versions/time, red for errors.
- **bat** (`winget install sharkdp.bat`) — syntax-highlighted `cat`/`type` replacement.
  Config at `%APPDATA%\bat\config`. Theme: `base16-256` (uses Phosphor terminal palette).
  Style: line numbers, change indicators, header.
- **fzf** (`winget install junegunn.fzf`) — fuzzy finder. PS7: PSFzf module wired to Ctrl+T / Ctrl+R.
  Git Bash: `eval "$(fzf --bash)"` in `.bashrc`.
- **zoxide** (`winget install ajeetdsouza.zoxide`) — smart cd. Init in PS7 profile and `.bashrc`.
  Use `z` to jump, `zi` for interactive picker.
- **eza** (`winget install eza-community.eza`) — modern ls. Aliased as `ls`, `ll`, `la`, `lt`
  in both PS7 profile and `.bashrc`.
- **lazygit** (`winget install JesseDuffield.lazygit`) — TUI git client. Aliased as `lg`.
- **ripgrep** (`winget install BurntSushi.ripgrep.MSVC`) — fast recursive search (`rg`).
- **btop** (`winget install aristocratos.btop4win`) — TUI system monitor.
- **yazi** (`winget install sxyazi.yazi`) — TUI file manager.
- **PowerToys** (`winget install Microsoft.PowerToys`) — launcher (Alt+Space), FancyZones,
  keyboard remapper, PowerRename.
- **Cheat sheet** at `pc-config/CHEATSHEET.md` — keybindings and usage for all tools.

### Neovim
- **Neovim** (`winget install Neovim.Neovim`) v0.12.2. Default editor: `$EDITOR=nvim`.
  Aliases: `vim`, `vi` → nvim in PS7 profile and `.bashrc`.
- **LazyVim** v16 — full config distribution. Starter cloned to `%LOCALAPPDATA%\nvim`.
  Entry point: `lua/config/lazy.lua`. LazyVim colorscheme set to `phosphor` via
  `opts = { colorscheme = "phosphor" }` on the LazyVim plugin spec.
  TokyoNight/Catppuccin disabled in `lua/plugins/colorscheme.lua`.
- **Colorscheme:** custom `phosphor` at `%LOCALAPPDATA%\nvim\colors\phosphor.lua`.
  `termguicolors = true` (set in `lua/config/options.lua`).
  Palette: green text (`#00ff41`), amber keywords (`#ffaa00`), cyan types (`#00ccbb`),
  dim green strings (`#00cc33`), muted green comments (`#3a6b3a`), red errors (`#ff5555`).
  Covers editor chrome, treesitter `@` groups, diagnostics, LSP, and plugins:
  Snacks, blink.cmp, bufferline, noice, which-key, flash, trouble, todo-comments, gitsigns.
- **Lualine:** custom theme in `lua/plugins/lualine.lua`. Mode block color per mode:
  green (normal), amber (insert), cyan (visual), red (replace), purple (command).
- **Treesitter:** parser compilation requires a C compiler. No compiler currently in PATH —
  needs zig installed, after which `:TSUpdate` will compile parsers.
  Compiler preference set in `lua/plugins/treesitter.lua` (zig → clang → gcc → cc).
  **Note:** `winget install zig.zig` hangs at "Extracting archive..." and never completes.
  Install manually instead: download zip from ziglang.org, extract, add the folder to PATH.
- **Key LazyVim shortcuts:** `Space` = leader. `Space e` = file tree, `Space f f` = find files,
  `Space f g` = live grep, `Space g g` = lazygit. `:e .` = directory browser.
- **Font:** CaskaydiaCove Nerd Font installed to `%LOCALAPPDATA%\Microsoft\Windows\Fonts\`
  (user-level install, no admin needed). Required for LazyVim icons to render correctly.

### System optimizations (2026-06-23)
- **SysMain (Superfetch)** disabled — was wasting RAM with SSD-era pre-loading.
- **Visual effects** set to best performance, keeping smooth fonts and thumbnails only.

### PS5.1 (legacy)
- Profile at `OneDrive\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` has ttyper alias only.

## Startup / task cleanup (2026-06-23)

Removed from startup (registry):
- **Logitech Download Assistant** — update-checker bloatware (HKLM, required admin)
- **StartAUEP** — AMD telemetry/analytics program (HKLM, required admin)
- **AMDNoiseSuppression** — not in use; removed all three duplicate entries (HKLM + HKCU)

Disabled scheduled tasks:
- **StartCN / StartCNBM / StartDVR** — AMD Radeon Software overlay, benchmark, and DVR auto-launch (required admin)
- **RunPlatformExperienceHelperOnUnlock / _Daily / _Metrics** — Google analytics tasks under `\GoogleUserPEH\`

Processes killed (won't restart on next boot):
- **AUEPMaster / AUEPDU** — AMD telemetry (AUEPDU required admin to kill)
- **m365copilot_autostarter** — M365 Copilot auto-launcher

Borderline items left running (user's call to revisit):
- Steam, Discord, Signal silent startup — convenient if used daily
- RTHDVCPL (Realtek audio panel) — harmless, low footprint
- PhoneExperienceHost — disable if not using Phone Link

## Conventions for future sessions
- This is a Windows environment: PowerShell is primary; the Bash tool uses POSIX/MINGW syntax.
- Prefer `winget` for installs unless a tool is only on Scoop/npm/cargo.
- Verify current state on the machine (versions, installed tools) before recommending — defaults here
  are old (e.g. PS 5.1), so don't assume modern baselines.
- Record decisions, installed tools, and config changes back into this file as they happen.
