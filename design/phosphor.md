# Phosphor

## Concept

A monochrome CRT terminal aesthetic. The machine as medium — every surface glowing the same electric green as if the whole environment is a single phosphor screen. Named for the coating on cathode ray tubes that absorbs electron energy and re-emits it as light.

The constraint is the point: one hue, modulated by brightness and saturation, forces the eye to read meaning through intensity rather than colour. This is how terminals actually looked before colour displays. It is also how this machine is supposed to be used — one thing at a time, fully.

## Rationale

The MacBook this runs on is intentionally underpowered. A forcing function for terminal-first, keyboard-first work. Phosphor reinforces that constraint aesthetically. It says: you are in the machine. There is no GUI here. There is no decoration. There is only signal and noise, bright and dim.

It also pairs well with the physical machine — a MacBook in Neo Citrus (yellow-green), where the colour already gestures at the same warm-green spectrum.

## Palette

| Role | Hex | Description |
|------|-----|-------------|
| Background | `#141a03` | Near-black with a deep green tint |
| Background dim | `#0d1102` | Deeper, for floating panels |
| Background highlight | `#1c2404` | Cursor line, subtle lift |
| Background selection | `#2a3a08` | Visual selection |
| Dim | `#2a6e2a` | Low-signal: line numbers, delimiters, comments |
| Mid | `#2eb82e` | Medium signal: structural elements |
| Foreground | `#39FF39` | Primary text — full phosphor |
| Foreground bright | `#66FF66` | Emphasis, function names, headings |
| White | `#ddffdd` | Near-white for high-contrast moments |
| Teal | `#00dd77` | Strings, types — slight hue shift for variety |
| Teal bright | `#11ffbb` | Constants, builtins — warmer teal |
| Amber | `#FFB000` | Operators — the one deliberate break from green |
| Amber dim | `#CC8800` | Git modified, secondary amber |

## Design decisions

**One hue.** Green only, with amber as a single deliberate accent for operators. The amber exists because operators are punctuation-as-logic — they deserve to stand out from the text they connect.

**Brightness = importance.** The hierarchy runs from `#2a6e2a` (barely visible, structural noise) up to `#66FF66` (bright, meaningful, demands attention). Learning to read this gradient is part of inhabiting the environment.

**Teal as pseudo-colour.** The teal variants (`#00dd77`, `#11ffbb`) are a subtle break — close enough to green to feel monochrome, different enough to distinguish types and strings without introducing a second full hue.

**The amber exception.** Operators in amber (`#FFB000`) is the one place the theme admits a second colour. It works because amber is warm, not cool — it doesn't compete with the green, it glows beside it.

## Files

| File | Path |
|------|------|
| Neovim colorscheme | `~/.config/nvim/colors/phosphor.lua` |
| Ghostty config (backup) | `~/code/laptop-maintenance/ghostty-phosphor.conf` |
