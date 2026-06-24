# Terminal Cheat Sheet

## Index
- [fzf](#fzf--fuzzy-finder) — fuzzy search everything
- [zoxide](#zoxide--smart-cd) — smart directory jumping
- [lazygit](#lazygit--tui-git-client) — TUI git client
- [eza](#eza--modern-ls) — modern ls
- [ripgrep](#ripgrep-rg--fast-search) — fast recursive search
- [bat](#bat--syntax-highlighted-cat) — syntax-highlighted cat
- [PowerToys](#powertoys) — launcher, window snap, remapping
- [btop](#btop--tui-system-monitor) — TUI system monitor
- [yazi](#yazi--tui-file-manager) — TUI file manager
- [Windows Terminal](#windows-terminal-keybindings) — panes, tabs, splits
- [PS7 / PSReadLine](#ps7--psreadline-keybindings) — shell shortcuts
- [Git Bash / ble.sh](#git-bash--blesh-keybindings) — shell shortcuts

---

## fzf — Fuzzy Finder

| Shortcut | Action |
|---|---|
| `Ctrl+R` | Interactive history search |
| `Ctrl+T` | Fuzzy file finder — inserts path at cursor |
| `Alt+C` | Fuzzy cd into a subdirectory |

**Inside fzf popup:**

| Key | Action |
|---|---|
| `Enter` | Select |
| `Tab` | Multi-select |
| `Ctrl+C` / `Esc` | Cancel |
| `↑↓` | Navigate results |

**Pipe into fzf:**
```sh
cat file.txt | fzf
ps aux | fzf
rg "pattern" | fzf
```

---

## zoxide — Smart cd

| Command | Action |
|---|---|
| `z foo` | Jump to most frecent dir matching "foo" |
| `z foo bar` | Match multiple terms |
| `zi` | Interactive fuzzy picker (uses fzf) |
| `z -` | Go back to previous directory |
| `z ..` | Up one level (like cd ..) |

> Learns over time — the more you visit a directory, the higher it ranks.

---

## lazygit — TUI Git Client

Launch: `lazygit` or `lg`

**Panels** (switch with number keys):

| Key | Panel |
|---|---|
| `1` | Files (staged/unstaged) |
| `2` | Branches |
| `3` | Commits |
| `4` | Stash |
| `5` | Reflog |

**Common actions:**

| Key | Action |
|---|---|
| `Space` | Stage / unstage file or hunk |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch menu |
| `d` | View diff |
| `D` | Discard changes |
| `z` | Undo last action |
| `+` / `-` | Expand / collapse diff context |
| `?` | Show keybindings for current panel |
| `q` | Quit |

---

## eza — Modern ls

| Command | Action |
|---|---|
| `eza` | Basic list |
| `eza -l` | Long format (permissions, size, date) |
| `eza -la` | Long format including hidden files |
| `eza --tree` | Tree view |
| `eza --tree --level=2` | Tree limited to 2 levels deep |
| `eza -l --git` | Show git status per file |
| `eza -l --sort=modified` | Sort by last modified |

> Aliased as `ls` — just use `ls`, `ls -la`, etc.

---

## ripgrep (rg) — Fast Search

| Command | Action |
|---|---|
| `rg "pattern"` | Search current dir recursively |
| `rg "pattern" path/` | Search in specific path |
| `rg -i "pattern"` | Case insensitive |
| `rg -l "pattern"` | List matching files only |
| `rg -t py "pattern"` | Search only Python files |
| `rg -t js "pattern"` | Search only JS files |
| `rg --hidden "pattern"` | Include hidden files/dirs |
| `rg -C 3 "pattern"` | Show 3 lines of context |
| `rg "pattern" \| fzf` | Fuzzy filter results |

---

## bat — Syntax-Highlighted cat

| Command | Action |
|---|---|
| `bat file.txt` | View with syntax highlighting |
| `bat -n file.txt` | Line numbers only (no other decoration) |
| `bat -A file.txt` | Show non-printable characters |
| `bat --diff file.txt` | Show git diff inline |
| `bat -l json file` | Force a specific language |

> Uses `base16-256` theme — inherits Phosphor terminal palette.  
> Alias `cat` → `bat` optionally for automatic use.

---

## PowerToys

| Shortcut | Tool | Action |
|---|---|---|
| `Alt+Space` | PowerToys Run | App / file / command launcher (Spotlight-style) |
| `Win+Shift+C` | Color Picker | Pick any color on screen → clipboard |
| `Win+`` ` | FancyZones | Activate zone layout for window snapping |

**PowerToys Run tips:**
- Type app name, file name, or shell command
- `>` prefix: run a shell command directly
- `?` prefix: web search

**FancyZones:** Hold `Shift` while dragging a window to snap to a zone.

**Keyboard Manager:** Remap any key or shortcut system-wide. Open PowerToys → Keyboard Manager.

**PowerRename:** Select files in Explorer → right-click → PowerRename. Supports regex.

---

## btop — TUI System Monitor

Launch: `btop`

| Key | Action |
|---|---|
| `F2` | Options / settings |
| `F10` | Quit |
| `m` | Toggle memory display |
| `n` | Toggle network display |
| `k` | Kill selected process (with confirmation) |
| `e` | Expand / collapse process tree |
| `↑↓` | Navigate process list |
| `Enter` | Select process for detail |
| `q` | Quit |

> Click column headers to sort. Mouse supported throughout.

---

## yazi — TUI File Manager

Launch: `yazi` or `y`

| Key | Action |
|---|---|
| `h j k l` / `←↑↓→` | Navigate |
| `Enter` | Open file or enter directory |
| `Space` | Select / deselect |
| `y` | Yank (copy) |
| `d` | Cut |
| `p` | Paste |
| `D` | Delete |
| `r` | Rename |
| `/` | Search |
| `f` | Filter |
| `o` | Open with default app |
| `.` | Toggle hidden files |
| `q` | Quit |

---

## Windows Terminal Keybindings

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Ctrl+1–9` | Jump to tab by number |
| `Alt+Shift++` | Split pane vertically |
| `Alt+Shift+-` | Split pane horizontally |
| `Alt+↑↓←→` | Move between panes |
| `Ctrl+Shift+Z` | Zoom / unzoom current pane |
| `Ctrl+Shift+F` | Find in terminal |
| `Ctrl+,` | Open settings |

---

## PS7 / PSReadLine Keybindings

| Shortcut | Action |
|---|---|
| `Ctrl+R` | Interactive history search (fzf) |
| `Tab` | Autocomplete (ListView) |
| `Ctrl+Space` | Show all completions |
| `↑` / `↓` | Navigate history |
| `Ctrl+A` | Jump to start of line |
| `Ctrl+E` | Jump to end of line |
| `Alt+F` | Forward one word |
| `Alt+B` | Back one word |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete to start of line |
| `Ctrl+W` | Delete previous word |
| `Ctrl+L` | Clear screen |

---

## Git Bash / ble.sh Keybindings

| Shortcut | Action |
|---|---|
| `Ctrl+R` | Interactive history search (fzf) |
| `Tab` | Autocomplete (ble.sh) |
| `→` | Accept autosuggestion |
| `Ctrl+A` | Jump to start of line |
| `Ctrl+E` | Jump to end of line |
| `Alt+F` | Forward one word |
| `Alt+B` | Back one word |
| `Ctrl+K` | Delete to end of line |
| `Ctrl+U` | Delete to start of line |
| `Ctrl+W` | Delete previous word |
| `Ctrl+L` | Clear screen |

> ble.sh highlights valid commands green and invalid commands red as you type, before pressing Enter.
