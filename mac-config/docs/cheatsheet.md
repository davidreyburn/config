# Workflow Reference

Everything installed, how to use it, and how it fits together.

---

## Shell

### Prompt (Starship)
Two-line phosphor prompt. Line 1: directory · git · language · jobs · time · battery. Line 2: `❯`  
Battery goes amber under 20%. `❯` goes amber on error and shows exit code. Username/host only show when SSH'd.

### fzf
| Key | Action |
|-----|--------|
| `Ctrl+R` | Fuzzy search shell history |
| `Ctrl+T` | Fuzzy find file (opens bat preview) |
| `Alt+C` | Fuzzy jump to directory |

### Aliases
| Alias | Does |
|-------|------|
| `ls` | `eza` — icons, colours |
| `ll` | `eza` — long list, icons, git status |
| `lt` | `eza` — 2-level tree |
| `cat` | `bat` — syntax highlighting |
| `lg` | `lazygit` |
| `j <dir>` | `zoxide` smart jump |
| `z` | SSH → aleph → openclaw Docker agent |
| `live` | Start full Tidal livecoding tmux session |

### zoxide
Learns directories you visit frequently. The more you visit, the shorter the query needs to be.
```
j dungeonworld   # jumps to ~/dungeonworld
j know           # jumps to ~/knowledge
j live           # jumps to ~/code/livecode
```

---

## tmux (prefix: `Ctrl+a`)

### Sessions
| Command | Action |
|---------|--------|
| `tmux new -s name` | New named session |
| `tmux attach -t name` | Reattach to session |
| `tmux ls` | List sessions |
| `Ctrl+a d` | Detach (session keeps running) |
| `Ctrl+a $` | Rename session |
| `Ctrl+a Ctrl+s` | Save session (resurrect) |
| `Ctrl+a Ctrl+r` | Restore session after reboot (resurrect) |

### Panes
| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Split vertically (new pane right) |
| `Ctrl+a -` | Split horizontally (new pane below) |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a z` | Zoom pane to fullscreen (toggle) |
| `Ctrl+a x` | Close current pane |
| `Ctrl+a {` / `}` | Swap pane left / right |

### Windows (tabs)
| Key | Action |
|-----|--------|
| `Ctrl+a c` | New window |
| `Ctrl+a n` / `p` | Next / previous window |
| `Ctrl+a 1-9` | Jump to window by number |
| `Ctrl+a ,` | Rename window |

### Copy mode
| Key | Action |
|-----|--------|
| `Ctrl+a [` | Enter copy mode |
| `hjkl` / arrows | Navigate |
| `v` | Begin selection |
| `y` | Copy selection, exit |
| `q` | Exit copy mode |

### Copy / paste (tmux + Ghostty)

Two clipboards exist: macOS system clipboard and tmux's internal buffer. They don't sync automatically.

**From terminal output (e.g. Claude) → tmux pane:**
1. Hold `Shift` and drag to select text — bypasses tmux mouse capture
2. `Cmd+C` — copies to macOS clipboard
3. Click target pane → `Cmd+V` to paste

**From inside a tmux pane → another pane:**
1. `Ctrl+a [` — enter copy mode
2. `hjkl` to navigate, `v` to start selection, `y` to copy
3. `Ctrl+a ]` — paste (tmux buffer only, not macOS clipboard)

**The gotcha:** `Ctrl+a ]` only works within tmux. To get tmux buffer content into the macOS clipboard, use `Shift+drag` + `Cmd+C` instead.

### Other
| Key | Action |
|-----|--------|
| `Ctrl+a r` | Reload config |
| `Ctrl+a ?` | List all keybindings |

---

## Neovim

### Modes
| Key | Action |
|-----|--------|
| `Esc` | Normal mode |
| `i` / `a` | Insert before / after cursor |
| `o` / `O` | New line below / above |
| `v` / `V` / `Ctrl+v` | Visual / line / block select |
| `:` | Command mode |

### Navigation
| Key | Action |
|-----|--------|
| `h j k l` | Left / down / up / right |
| `w` / `b` | Forward / back one word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | Half page down / up |
| `{` / `}` | Jump prev / next blank line |
| `%` | Jump to matching bracket |
| `Ctrl+o` / `Ctrl+i` | Jump back / forward in location history |

### Editing
| Key | Action |
|-----|--------|
| `u` / `Ctrl+r` | Undo / redo |
| `dd` / `yy` | Delete / yank line |
| `p` / `P` | Paste after / before |
| `ciw` | Change inner word |
| `ci"` / `ci'` | Change inside quotes |
| `ci(` / `ci[` | Change inside brackets |
| `>>` / `<<` | Indent / unindent |
| `J` | Join line below to current |
| `~` | Toggle case |
| `.` | Repeat last action |

### Search & replace
| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `*` | Search word under cursor |
| `:%s/old/new/g` | Replace all in file |
| `:'<,'>s/old/new/g` | Replace in visual selection |

### Files & buffers
| Key | Action |
|-----|--------|
| `:w` | Save |
| `:wq` / `:q!` | Save+quit / quit without saving |
| `:e filename` | Open file |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Close buffer |

### Splits
| Key | Action |
|-----|--------|
| `:sp` / `:vsp` | Horizontal / vertical split |
| `Ctrl+h/j/k/l` | Move between splits |
| `:q` | Close split |

### Dashboard (mini.starter)
Opens automatically when nvim is launched with no file, or with a directory (`nvim ~/knowledge`). Neo-tree roots to that directory; starter fills the main panel.

| Key | Action |
|-----|--------|
| `j` / `k` | Move through items |
| `Enter` | Open item |
| Type | Filter items by name |

### Neo-tree (file browser)
| Key | Action |
|-----|--------|
| `\` | Toggle file tree |
| `Enter` | Open file / expand folder |
| `a` / `A` | New file / new directory |
| `r` | Rename |
| `d` | Delete |
| `y` / `m` | Copy / move |
| `q` / `\` | Close tree |

### Oil (filesystem as buffer)
Edit files and directories like a text buffer — rename by editing lines, delete by deleting lines.

| Key | Action |
|-----|--------|
| `-` | Open parent directory in oil |
| `<leader>-` | Open oil in floating window |
| `Enter` | Open file / descend into dir |
| `-` (in oil) | Go up to parent |
| `_` | Open in cwd |
| `Ctrl+s` | Save changes |
| `Ctrl+h` | Toggle hidden files |
| `q` | Quit |

### Flash (jump navigation)
Type `s` then 2 characters of your target — Flash highlights all matches with single-keystroke labels. Press the label to jump.

| Key | Action |
|-----|--------|
| `s` | Flash jump (normal/visual/operator) |
| `S` | Flash treesitter select |
| `r` | Flash remote (operator-pending) |
| `R` | Flash treesitter search (operator) |

### Harpoon (file marks)
Mark up to 4 files per project for instant jumping.

| Key | Action |
|-----|--------|
| `<leader>a` | Mark current file |
| `<C-e>` | Toggle mark menu |
| `<leader>1-4` | Jump to mark 1–4 |

In the menu: `Enter` to open, `d` to remove a mark.

### Trouble (diagnostics panel)
| Key | Action |
|-----|--------|
| `<leader>xx` | Workspace diagnostics |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `gR` | LSP references |

In panel: `j`/`k` navigate, `Enter` jump, `q` close, `o` jump + keep panel open.

### Diffview (git diff UI)
| Key | Action |
|-----|--------|
| `<leader>gd` | Open diff (staged vs HEAD) |
| `<leader>gh` | Current file history |
| `<leader>gH` | Full repo history |
| `<leader>gc` | Close diffview |

In diffview: `[x`/`]x` prev/next conflict, `<leader>co/ct/cb` choose ours/theirs/both.

### Telescope (fuzzy finder)
| Key | Action |
|-----|--------|
| `Space sf` | Find files |
| `Space sg` | Live grep (search contents) |
| `Space sb` | Search open buffers |
| `Space s.` | Recent files |
| `Space sh` | Search help docs |
| `Ctrl+p` / `Ctrl+n` | Move up / down in results |
| `Esc` | Close |

### LSP (Python, Lua)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `Space rn` | Rename symbol |
| `Space ca` | Code actions |
| `[d` / `]d` | Previous / next diagnostic |

### Surround (mini.surround — remapped to `gz`)
| Key | Action |
|-----|--------|
| `gza` + motion | Add surrounding |
| `gzd` + motion | Delete surrounding |
| `gzr` + motion | Replace surrounding |
| `gzf` / `gzF` | Find surrounding right / left |

Examples: `gzaiw)` wraps word in parens · `gzd"` removes quotes · `gzr)'` replaces `)` with `'`

### Zen Mode + Twilight
| Key | Action |
|-----|--------|
| `<leader>z` | Toggle zen mode |

Zen mode centers the buffer at 82 columns, hides line numbers and signs. Twilight dims everything outside the current paragraph automatically.

### Obsidian (`~/knowledge` vault)
| Key | Action |
|-----|--------|
| `<leader>on` | New note |
| `<leader>of` | Find note (quick switch) |
| `<leader>og` | Grep across all notes |
| `<leader>ob` | Backlinks for current note |
| `<leader>ol` | Links in current note |
| `<leader>ot` | Open / create today's daily note |

- `[[` in insert mode → wikilink autocomplete
- `:ObsidianRename` to rename a note and update all links
- Vault path: `~/knowledge`

### Markdown files
| Key / Command | Action |
|---------------|--------|
| `Space f` | Format with Prettier |
| `:set spell` | Enable spellcheck squiggles for this session |
| `:set nospell` | Disable squiggles |
| `]s` / `[s` | Next / previous spelling error (when spell is on) |
| `z=` | Spelling suggestions for word under cursor |
| `zg` | Add word to dictionary |

- Spellcheck **off by default** — enable on demand with `:set spell`
- Soft wrap auto-enabled — `j`/`k` move by visual line
- markview renders headings, bold, italic, code blocks in-buffer
- **Known limitation:** markview cannot render tables when soft wrap is on

### vim-tidal (`.tidal` files only)
| Key | Action |
|-----|--------|
| `Ctrl+e` | Send paragraph/block to GHCi |
| `Ctrl+s` | Silence the channel in current block (`dN silence`) |
| `\s` | Send current line only |
| `Ctrl+h` | Hush — silence all patterns |
| `:TidalConfig` | Set target GHCi pane (once per session) |

**TidalConfig setup:** in the GHCi pane run `tmux display-message -p '#{pane_id}'`, then in Neovim run `:TidalConfig` → Enter → paste the pane ID.

---

## Git

### lazygit (`lg`)
| Key | Action |
|-----|--------|
| `↑↓` / `jk` | Navigate |
| `Space` | Stage / unstage file |
| `a` | Stage all |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch menu |
| `d` | Diff |
| `e` | Open file in editor |
| `z` | Undo last action |
| `?` | Help / all keybindings |
| `q` | Quit |

### git / gh CLI
```
git status / log / diff
git add -p              # stage hunks interactively
gh pr create            # create pull request
gh pr list              # list open PRs
gh issue list           # list issues
```

---

## Navigation & Files

### yazi (TUI file manager)
```
yazi           # open in current directory
yazi ~/path    # open at path
```
| Key | Action |
|-----|--------|
| `hjkl` | Navigate |
| `Enter` | Open file |
| `Space` | Select file |
| `y` / `p` | Copy / paste |
| `d` | Delete |
| `r` | Rename |
| `/` | Search |
| `q` | Quit |

### glow (markdown reader)
```
glow file.md           # render single file
glow ~/knowledge       # browse directory
glow -p file.md        # paged output
```

### bat (enhanced cat)
```
bat file.py            # view with syntax highlighting
bat -n file.md         # show line numbers
bat -r 10:20 file.md   # show lines 10-20
```

---

## System

### btop
```
btop    # full TUI: CPU, memory, processes, network
```
| Key | Action |
|-----|--------|
| `F2` | Options |
| `F5` | Process tree view |
| `F9` | Kill process |
| `q` | Quit |

### ncdu (disk usage)
```
ncdu           # scan current directory
ncdu ~/        # scan home
ncdu /         # scan everything (slow)
```
| Key | Action |
|-----|--------|
| `↑↓` / `jk` | Navigate |
| `Enter` | Open directory |
| `d` | Delete selected |
| `q` | Quit |

### posting (HTTP client)
```
posting    # open TUI
```
Create requests, set headers, inspect responses — all in terminal.

---

## Livecoding

See `~/code/livecode/CLAUDE.md` for full reference. Quick start:

### Tidal + SuperDirt (preferred)
```
live    # starts tmux session with sclang + ghci + nvim
```
In Neovim: `:TidalConfig` → pick GHCi pane → write pattern → `Ctrl+e`

### ORCA + FluidSynth (MIDI)
```
# pane 1:
fluidsynth -a coreaudio -m coremidi /usr/local/share/soundfonts/GeneralUser-GS.sf2
# pane 2:
orca
```
In ORCA: `Ctrl+D` → MIDI Output → select FluidSynth port. Quit with `Ctrl+Q`.

**ORCA controls:**
| Key | Action |
|-----|--------|
| Arrow keys | Move cursor |
| Type letters | Place operators |
| `Space` | Play / pause |
| `Ctrl+D` | Main menu (MIDI, BPM, grid) |
| `Esc` | Normal mode |
| `?` | Show all controls |
| `Ctrl+Q` | Quit |

**Key operators:**
| Op | Name | What it does |
|----|------|-------------|
| `D` | Delay | Bangs every N ticks (south output) |
| `C` | Clock | Counts 0–N, rate west, mod east |
| `T` | Track | Steps through a note sequence |
| `R` | Random | Random value between west and east |
| `U` | Uclid | Euclidean rhythm |
| `:` | MIDI | Plays note — channel, octave, note, velocity, length |

**Pitfalls:** `:` needs a gap row below `D` (D writes `*` south). Uppercase letters are operators — use lowercase for note values in `T` sequences. Edit with clock paused.

**FluidSynth instrument change** (in FluidSynth shell):
```
prog 0 40    # channel 0 → violin
noteon 0 60 100   # test note
```

**GM instruments (useful ones):**
`0` Piano · `4` Rhodes · `25` Acoustic Guitar · `32` Bass · `40` Violin · `48` Strings · `56` Trumpet · `73` Flute · `80` Square Lead

### How $ and # work

`$` is function application — everything to its right is the argument to everything on its left. Avoids brackets:
```haskell
d1 $ sound "bd sn"        -- same as: d1 (sound "bd sn")
d1 $ fast 2 $ sound "bd"  -- chains right-to-left: fast 2 applied to sound "bd", result sent to d1
```

`#` merges a parameter into the pattern on its left. Think of it as "with":
```haskell
d1 $ sound "bd sn" # gain 0.8 # room 0.9
-- "play bd sn, with gain 0.8, with room 0.9"
```

### Tidal pattern basics
```haskell
d1 $ sound "bd sn bd sn"       -- basic beat
d1 $ sound "bd*4"              -- repeat 4x per cycle
d2 $ sound "hh*8" # gain 0.6   -- second pattern, quieter
d1 $ sound "bd [sn sn] bd ~"   -- subdivision, rest
d1 $ fast 2 $ sound "bd sn"    -- double speed
d1 silence                      -- stop d1 only
d2 silence                      -- stop d2 only
hush                            -- silence everything
-- this is a comment
```

### Mini-notation (inside quotes)
| Syntax | Meaning |
|--------|---------|
| `"a b c"` | Three events per cycle |
| `"a*4"` | Repeat a four times |
| `"[a b]"` | Subdivide one step into two |
| `"a ~ b"` | Rest in middle |
| `"<a b>"` | Alternate: a one cycle, b next cycle |
| `"a(3,8)"` | Euclidean rhythm — 3 hits spread across 8 steps |

### Tidal synths (sc3plugins required — installed)
SuperCollider synths available via `sound`:

| Synth | Character |
|-------|-----------|
| `superpiano` | Piano (MdaPiano physical model) |
| `supersaw` | Lush sawtooth pad |
| `supersquare` | Bright square wave |
| `supergong` | Gong / bell |
| `superfm` | FM synthesis |

Use `n` for pitch, `'maj`/`'min` etc. for chords:
```haskell
d3 $ slow 4 $ n "c4'maj a3'min f4'maj g4'maj" # sound "superpiano" # gain 0.6 # sustain 0.8

d3 $ slow 4 $ n "c4'maj a3'min f4'maj g4'maj" # sound "supersaw" # gain 0.5 # sustain 1.2
```

Chord suffixes: `'maj` `'min` `'dim` `'aug` `'maj7` `'min7` `'dom7`

### Parameters (used with #)
| Parameter | What it does |
|-----------|-------------|
| `gain` | Volume (0–1, can go above 1) |
| `pan` | Stereo position (0=left, 0.5=centre, 1=right) |
| `sustain` | Note length in seconds |
| `attack` | Attack time in seconds |
| `release` | Release time in seconds |
| `room` | Reverb amount (0–1) |
| `size` | Reverb tail length (0–1) |
| `delay` | Delay send amount (0–1) |
| `delaytime` | Delay time in cycles (e.g. `1/3`) |
| `delayfeedback` | Delay repeats (0–1, keep below 0.9) |
| `cutoff` | Low-pass filter frequency in Hz |
| `resonance` | Filter resonance (0–1) |
| `speed` | Sample playback speed / pitch (1=normal, 0.5=half speed) |
| `n` | Sample index or note pitch |

### Transformations
| Function | What it does |
|----------|-------------|
| `fast 2` | Double speed |
| `slow 4` | Quarter speed (4x slower) |
| `rev` | Reverse pattern |
| `palindrome` | Forward one cycle, reverse the next |
| `jux f` | Apply `f` to right channel only — easy stereo effect |
| `every 4 f` | Apply `f` every 4 cycles |
| `sometimes f` | Apply `f` randomly ~50% of the time |
| `often f` | Apply `f` ~75% of the time |
| `rarely f` | Apply `f` ~25% of the time |
| `striate 8` | Chop sample into 8 grains, scatter — granular texture |
| `\|+ note "7"` | Transpose up 7 semitones (a fifth) |
| `range lo hi` | Map a signal (e.g. sine) to a range |

### Continuous signals (use with pan, gain, cutoff etc.)
```haskell
# pan (slow 8 $ sine)             -- slow pan sweep left→right→left
# gain (slow 5 $ range 0.3 0.8 $ sine)  -- slow volume swell
# cutoff (slow 4 $ range 400 4000 $ sine)  -- filter opening and closing
```
`sine` runs 0→1→0 per cycle. `slow N` stretches it across N cycles.

### If a pane closes (process exited)
Panes close when their command exits. To recover:
1. `Ctrl+a |` or `Ctrl+a -` to open a new pane
2. Re-run the command (e.g. `sclang`)
3. `Ctrl+a {` / `}` to reorder panes if needed

### Stale SuperDirt port fix
```
lsof -i :57120    # find PID of stuck sclang
kill <PID>        # kill it, then run sclang again
```

---

## Standalone CLI tools

| Tool | Command | What for |
|------|---------|----------|
| `rg` | `rg "pattern" .` | Fast recursive grep (ripgrep) |
| `fd` | `fd filename` | Fast file find |
| `rg -l "text"` | | List files containing text |
| `rg -t py "import"` | | Grep in Python files only |
| `fd -e md` | | Find all `.md` files |

---

## Radio
```
radio    # opens station picker, plays in background
```
Tab title updates to show current station. See `~/code/radio/CLAUDE.md`.

---

## topo-viz

Audio-reactive topographic ASCII terrain. Runs in any terminal pane.

```
topo-viz    # start — cava launches and is managed automatically
```

| Key | Action |
|-----|--------|
| `q` / `Esc` | Quit |
| `h` / `j` | Previous / next palette |
| `k` / `l` | Previous / next character mode |

**Palettes (16):** VERDIGRIS · PHOSPHOR · SURVEY · INFRARED · BATHYMETRY · GHOST · FOSSIL · NEON NOIR · AURORA · OPERATOR · TOXIC · FLORAL SHOPPE · CREAMY SUNSET · PERIDOT · DUSTY PRAIRIE · SGB-2H

**Modes (6):** STRATA · BLOCKS · STIPPLE · BRAILLE · SHADE · RELIEF

- Bass → terrain drift · volume → scroll speed · spectral content → direction
- Pairs with `radio` as a standalone music visualizer
- Also runs in the bottom-left pane of the `live` session

---

## Workflow patterns

**Reading / writing notes:**
```
nvim ~/knowledge        # dashboard + neo-tree rooted there
<leader>of              # fuzzy find a note
<leader>on              # create new note
<leader>z               # zen mode for focused writing
<leader>og              # grep across all notes
```

**GM session prep (dungeonworld):**
```
nvim ~/dungeonworld      # dashboard + neo-tree rooted there
Space sg                 # grep across all campaign files
<leader>a                # mark frequently-used files (harpoon)
<leader>1-4              # jump between them instantly
```

**Checking system health:**
```
btop      # full overview
ncdu ~/   # find space hogs
```

**After a reboot — restore everything:**
```
tmux attach -t live    # reattach livecoding session
Ctrl+a Ctrl+r          # restore with resurrect if session was lost
```
