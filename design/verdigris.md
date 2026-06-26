# Verdigris

## Concept

A retro-refined terminal palette. Named for the blue-green patina that forms on aged copper and bronze — the colour of old instruments, worn hardware, and things that have been used long enough to develop character. It is what green looks like after time has had its way with it.

Where Phosphor is the machine at full intensity, Verdigris is the machine at rest — still clearly a terminal, still clearly a hacker's tool, but grown up. Less neon, more weight. The kind of environment you could read in for hours.

## Rationale

Phosphor worked as an aesthetic statement and a focus tool. It became oppressive in multiplexed sessions — four panes of neon green is too much candy. The eye needs more differentiation to navigate a complex workspace without fatigue.

Verdigris emerged from two reference points: the btop `matcha-dark-sea` palette (calm, slightly desaturated, earthy) and the bat `BoneVibrant` theme (bone text, vibrant accents, readable at volume). The goal was a palette that sits between those two — more colour than matcha, more restraint than the original BoneVibrant iteration.

The terminal green is still present, deliberately. It connects back to Phosphor and signals that this is the same machine, just older. Green is the first accent colour to reach for, not the primary text.

## Palette

| Role | Hex | Description |
|------|-----|-------------|
| Background | `#161614` | Near-black, faintly warm — no green tint |
| Background dim | `#111110` | Floating panels, sidebar |
| Background highlight | `#1e1d1b` | Cursor line |
| Background selection | `#2c2b28` | Visual selection |
| Dim | `#524e48` | Warm gray — comments, structural noise |
| Bone | `#D0CAB8` | Primary text — warm off-white, readable at volume |
| Bone bright | `#E8E2D0` | Emphasis, operators, parameters |
| White | `#F0EDE4` | Near-white — matchparen, high contrast moments |
| Green | `#44BB44` | Muted phosphor — keywords, folders, structural |
| Orange | `#C4834A` | Warm terra — strings, headings, system/mechanical |
| Teal | `#4AACA4` | Slate teal — functions, links |
| Blue | `#5B8DB8` | Steel blue — constants, operators, attention |
| Purple | `#8855BB` | Dusty violet — types, classes, italic |
| Lime | `#AAFF00` | Numbers only — bright and numerically distinct |
| Red | `#CC5555` | Errors, diff removed |

## Design decisions

**Bone as primary.** Text is `#D0CAB8`, a warm off-white that reads like aged paper or vellum. It is comfortable at the volume of a dense document. The move away from green-as-text was the central decision — it changes the environment from "I am inside a CRT" to "I am reading something serious on a dark surface."

**Green as first accent, not primary.** `#44BB44` is a direct descendant of phosphor green, muted to sit as an accent rather than a base. It appears on keywords, folder icons, list markers — the structural skeleton of content. The eye is still drawn to it, but it no longer dominates.

**Orange as mechanical/system.** `#C4834A` warm terra marks things that are structural metadata rather than content: strings (literal data), markdown headings (document structure), YAML front matter (machine-readable). The rationale is "touch with care" — orange signals that something is a container or label, not prose.

**Blue and purple as attention markers.** `#5B8DB8` steel blue and `#8855BB` dusty purple are used for things that need to be noticed but not urgently: constants, types, `self`/`this`, italic text. In a game UI these would be item rarity indicators — present, meaningful, not alarming.

**Lime for numbers only.** `#AAFF00` is the brightest colour in the palette and appears exactly once: numbers. This makes numeric literals immediately scannable, which matters in pattern code and config files where values are the point.

**Muted but not flat.** The palette deliberately sits between full saturation (Phosphor, the original BoneVibrant) and the near-grey of matcha themes. Each colour has enough saturation to be distinct and vivid without any single one feeling like a warning signal. The aged, slightly desaturated quality is intentional — these are colours that have been used.

**Haskell/Tidal overrides.** The green–bone–blue–purple logic is extended to Tidal livecoding files: keywords (`let`, `where`) are orange (structural/system), operators (`$`, `#`) are blue (connective tissue worth noting), strings are green (pattern data is signal), numbers are lime.

## Files

| File | Path |
|------|------|
| Neovim colorscheme | `~/.config/nvim/colors/verdigris.lua` |
| bat theme | `~/.config/bat/themes/Verdigris.tmTheme` |
| bat config | `~/.config/bat/config` |
| Ghostty config | `~/.config/ghostty/config` |
