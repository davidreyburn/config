# Neovim Quick Reference

## Modes
| Key | Action |
|-----|--------|
| `Esc` | Return to Normal mode |
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `o` / `O` | New line below / above, enter Insert |
| `v` | Visual (character select) |
| `V` | Visual (line select) |
| `Ctrl+v` | Visual (block select) |
| `:` | Command mode |

---

## Navigation
| Key | Action |
|-----|--------|
| `h j k l` | Left / down / up / right |
| `w` / `b` | Forward / back one word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | Half page down / up |
| `Ctrl+f` / `Ctrl+b` | Full page down / up |
| `{` / `}` | Jump to prev / next blank line |
| `%` | Jump to matching bracket |

---

## Search
| Key | Action |
|-----|--------|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `*` | Search word under cursor |

---

## Editing
| Key | Action |
|-----|--------|
| `u` | Undo |
| `Ctrl+r` | Redo |
| `dd` | Delete line |
| `yy` | Copy (yank) line |
| `p` / `P` | Paste after / before cursor |
| `x` | Delete character under cursor |
| `r` | Replace single character |
| `ciw` | Change inner word |
| `cit` | Change inner tag (HTML) |
| `ci"` | Change inside quotes |
| `>>` / `<<` | Indent / unindent line |
| `=G` | Auto-indent from cursor to end |
| `J` | Join line below to current |

---

## Files & Buffers
| Key | Action |
|-----|--------|
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Quit without saving |
| `:e filename` | Open file |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Close buffer |

---

## Neo-tree (File Browser)
| Key | Action |
|-----|--------|
| `\` | Toggle file tree |
| `j` / `k` | Move down / up |
| `Enter` | Open file or expand folder |
| `a` | Create new file |
| `A` | Create new directory |
| `r` | Rename |
| `d` | Delete |
| `y` | Copy |
| `m` | Move |
| `q` / `\` | Close tree |

---

## Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `Space+sf` | Find files |
| `Space+sg` | Live grep (search file contents) |
| `Space+sb` | Search open buffers |
| `Space+sh` | Search help docs |
| `Space+s.` | Search recent files |
| `Ctrl+p` / `Ctrl+n` | Move up / down in results |
| `Enter` | Open selected |
| `Esc` | Close |

---

## Windows & Splits
| Key | Action |
|-----|--------|
| `:sp` | Horizontal split |
| `:vsp` | Vertical split |
| `Ctrl+h/j/k/l` | Move between splits |
| `:q` | Close current split |

---

## LSP (Code Intelligence)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `Space+rn` | Rename symbol |
| `Space+ca` | Code actions |
| `[d` / `]d` | Previous / next diagnostic |

---

## vim-tidal (`.tidal` files only)
| Key | Action |
|-----|--------|
| `Ctrl+e` | Send current paragraph/block to GHCi |
| `\s` | Send current line only |
| `Ctrl+h` | Hush — silence all patterns immediately |
| `:TidalConfig` | Set target tmux pane (required once per session) |

**Setup each session:** run `:TidalConfig`, accept socket `default`, enter pane ID from `tmux display-message -p '#{pane_id}'` run in the GHCi pane.

---

## tmux (prefix: `Ctrl+a`)
| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Split pane vertically |
| `Ctrl+a -` | Split pane horizontally |
| `Ctrl+a h/j/k/l` | Navigate panes |
| `Ctrl+a r` | Reload tmux config |
| `Ctrl+a d` | Detach session |
| `Ctrl+a [` | Enter scroll/copy mode (`q` to exit) |
| `Ctrl+a z` | Zoom current pane (toggle fullscreen) |
| `Ctrl+a Ctrl+s` | Save session (tmux-resurrect) |
| `Ctrl+a Ctrl+r` | Restore session (tmux-resurrect) |
| `tmux new -s name` | New named session |
| `tmux attach -t name` | Reattach to session |

---

## Shell aliases
| Alias | Action |
|-------|--------|
| `ls` | `eza` with icons |
| `ll` | `eza` long list with icons and git status |
| `lt` | `eza` tree view (2 levels) |
| `cat` | `bat` with syntax highlighting |
| `lg` | `lazygit` — TUI git client |
| `j <dir>` | `zoxide` smart jump (learns frequent dirs) |
| `live` | Start full Tidal livecoding tmux session |

**fzf:** `Ctrl+R` history search, `Ctrl+T` file search (with bat preview), `Alt+C` directory jump

---

## Formatting & writing (markdown files)
| Key | Action |
|-----|--------|
| `Space+f` | Format with Prettier |
| `]s` / `[s` | Next / previous spelling error |
| `z=` | Suggest spelling corrections |
| `zg` | Add word to dictionary |

- Spellcheck active in markdown/text files (en_gb)
- Soft wrap active — `j`/`k` navigate visual lines not file lines
- **Note:** soft wrap prevents markview from rendering tables (known markview bug)
