# Tidal Cycles — Live Coding Guide

## Setup

Your session: `live` launches sclang (SuperCollider + SuperDirt) in the top-left, GHCi + TidalCycles in the top-right. Tidal sends OSC to SuperDirt, which handles audio.

```
sclang pane    → boot SuperCollider, loads SuperDirt
ghci pane      → start Tidal, connect to SuperDirt
```

Boot order: wait for SC/SuperDirt to finish loading before evaluating Tidal code.

---

## Core Concepts

**Cycles** are the fundamental unit of time. All patterns loop over one cycle. `cps` (cycles per second) sets tempo.

```haskell
setcps (120/60/4)    -- 120 BPM (120 beats / 60 sec / 4 beats per cycle)
setcps (90/60/4)     -- 90 BPM
setcps 0.5           -- 0.5 cycles/sec = 120 BPM at 4/4
```

**Pattern streams** `d1`–`d9` (and more) are independent output channels, each going to a SuperDirt orbit.

```haskell
d1 $ s "bd"          -- kick on d1
d2 $ s "hh*8"        -- hats on d2
silence              -- stop current stream
d1 silence           -- stop d1 only
hush                 -- stop everything
```

---

## Mini Notation

The string inside `"..."` is mini notation — a pattern language.

| Syntax | Meaning | Example |
|--------|---------|---------|
| `a b c` | sequence across cycle | `"bd sd hh"` |
| `[a b]` | subsequence (fits in one step) | `"bd [sd sd]"` |
| `a*n` | repeat n times | `"bd*4"` |
| `a/n` | play once every n cycles | `"bd/2"` |
| `~` | rest | `"bd ~ sd ~"` |
| `<a b>` | alternate each cycle | `"<bd lt>"` |
| `a!n` | replicate n times | `"bd!3 sd"` |
| `a?` | play with 50% probability | `"hh?"` |
| `a@n` | weight (relative duration) | `"bd@2 sd"` |
| `a_` | hold/extend | `"bd _ sd"` |
| `a,b` | stack (layer) | `"[bd, hh*8]"` |

```haskell
d1 $ s "bd [~ sd] bd [sd sd]"     -- syncopated kick/snare
d1 $ s "<bd lt mt> sd hh ~"       -- alternating between 3 kicks
d1 $ s "bd*2 [hh hh?] sd ~"       -- probabilistic hat
```

---

## Sound & Samples

```haskell
d1 $ s "bd"              -- sample name
d1 $ s "bd:2"            -- sample index (0-based)
d1 $ s "bd" # n 2        -- same with param
d1 $ n "0 1 2 3" # s "hh"  -- iterate through samples
```

Common SuperDirt sample banks: `bd`, `sd`, `hh`, `cp`, `lt`, `mt`, `ht`, `oh`, `cb`, `cr`, `ride`, `bass`, `bass2`, `bass3`, `space`, `pad`, `feel`, `flick`, `jazz`, `mouth`, `odx`, `sn`, `tabla`, `tabla2`, `ade`, `ades2`, `ades3`.

---

## Effects Reference

Effects are chained with `#`. Multiple effects stack.

### Volume & Dynamics
```haskell
# gain 0.8          -- volume (default 1.0, 0=silent)
# gain (range 0.5 1 rand)   -- random gain per hit
# velocity (slow 4 $ sine)  -- LFO on velocity
```

### Pitch & Speed
```haskell
# speed 2           -- pitch up one octave (double speed)
# speed 0.5         -- pitch down one octave
# speed (-1)        -- play reversed
# speed (choose [1, 1.5, 0.75])  -- random pitch
# note 3            -- semitone offset
```

### Filter
```haskell
# cutoff 500        -- lowpass cutoff (Hz)
# resonance 0.3     -- resonance 0–1
# hpf 200           -- highpass cutoff (Hz)
# hpq 0.5           -- highpass resonance
# bpf 1000          -- bandpass cutoff
# bpq 0.5           -- bandpass Q
```

### Reverb
```haskell
# room 0.7          -- reverb room size 0–1
# size 0.9          -- reverb tail length 0–1
# dry 0.5           -- dry/wet (SuperDirt-specific)
```

### Delay
```haskell
# delay 0.8         -- delay send level
# delaytime (3/8)   -- delay time (in cycles)
# delayfeedback 0.5 -- delay feedback 0–1
```

### Distortion & Texture
```haskell
# shape 0.5         -- soft clip / waveshaper 0–1
# distort 0.3       -- distortion
# crush 6           -- bit crush (bits: 1–16)
# coarse 3          -- sample rate reduce (steps)
```

### Panning & Space
```haskell
# pan 0.0           -- hard left
# pan 1.0           -- hard right
# pan (slow 8 sine) -- slow autopan
# pan rand          -- random pan per hit
```

### Orbit (SuperDirt channel)
```haskell
# orbit 0           -- send to orbit 0 (default)
# orbit 1           -- send to orbit 1 (separate FX chain)
```

---

## Pattern Functions

### Time Manipulation
```haskell
fast 2 $ s "bd sd"      -- double speed (twice per cycle)
slow 2 $ s "bd sd"      -- half speed (once per 2 cycles)
hurry 2 $ s "bd sd"     -- fast + pitch up
linger 0.25 (s "bd sd") -- loop first 25% of pattern
```

### Structure
```haskell
rev $ s "bd sd hh cp"             -- reverse
palindrome $ s "bd sd hh"         -- forward then backward
iter 4 $ s "bd sd hh cp"          -- rotate start point each cycle
iter' 4 $ s "bd sd hh cp"         -- rotate backward
rotL 1 $ s "bd sd hh cp"          -- rotate left by 1 step
rotR 1 $ s "bd sd hh cp"          -- rotate right
```

### Stacking & Combining
```haskell
stack [ d1 $ s "bd", d2 $ s "hh" ]   -- run patterns together (rarely needed, use d1/d2)
cat [s "bd sd", s "hh cp"]            -- alternate patterns each cycle
append (s "bd sd") (s "hh cp")        -- one then the other (2 cycles)
overlay (s "bd") (s "hh*8")           -- layer two patterns
```

### Conditional & Probabilistic
```haskell
every 4 (fast 2) $ s "bd sd hh"        -- transform every 4th cycle
every 4 (rev) $ s "bd sd hh"           -- reverse every 4th cycle
whenmod 8 6 (fast 2) $ s "bd sd hh"    -- transform when (cycle mod 8) >= 6
sometimes (# crush 4) $ s "hh*8"        -- ~50% of events
often (# speed 2) $ s "hh*8"           -- ~75%
rarely (# speed 0.5) $ s "hh*8"        -- ~25%
someCycles (rev) $ s "bd sd"            -- reverse some cycles
someCyclesBy 0.25 (rev) $ s "bd sd"    -- 25% of cycles reversed
```

### Randomness
```haskell
choose ["bd", "lt", "mt"]          -- pick randomly each event
wchoose [("bd", 4), ("lt", 1)]     -- weighted random
rand                               -- continuous random 0–1
irand 8                            -- random int 0–7
shuffle 4 $ s "bd sd hh cp"        -- shuffle order each cycle
scramble 4 $ s "bd sd hh cp"       -- random with replacement
```

### Sample Manipulation
```haskell
chop 8 $ s "pad"          -- chop sample into 8 pieces
striate 8 $ s "pad"       -- interleave chops across cycle
slice 8 (n "0 3 2 7") $ s "break"   -- slice to specific segments
loopAt 2 $ s "pad"        -- loop sample to fit 2 cycles
fit 4 [0,1,2,3] $ s "hh"  -- distribute indices
```

### Signal Sources (LFOs)
```haskell
sine       -- smooth 0–1 sine wave per cycle
cosine     -- same, phase offset
tri        -- triangle wave
saw        -- sawtooth
square     -- square wave
rand       -- random per event

-- Scale and offset signals
range 0.2 0.8 sine     -- scale sine to 0.2–0.8
segment 16 $ sine      -- discretize sine into 16 steps
slow 4 sine            -- slower LFO
```

---

## Continuous Parameters

Apply LFOs and signals to effects:

```haskell
d1 $ s "hh*8" # pan (slow 4 sine)          -- slow autopan
d1 $ s "pad" # cutoff (range 200 2000 $ slow 8 sine)  -- filter sweep
d1 $ s "bass" # gain (segment 16 $ range 0.7 1 rand)  -- gated dynamics
d1 $ s "hh*16" # speed (range 0.8 1.2 rand)           -- pitch variation
```

---

## Functional Patterns (Synths)

SuperDirt includes built-in synths alongside samples:

```haskell
d1 $ n "c4 e4 g4 b4" # s "superpiano"   -- piano synth
d1 $ n (scale "minor" "0 2 4 7") # s "supersquare"  -- scale-mapped
d1 $ n "0 3 7 10" # s "supersaw" # cutoff 800
```

Scale helpers:
```haskell
scale "minor" "0 1 2 3 4 5 6 7"    -- minor scale degrees
scale "dorian" "0 2 4 5"
scale "pentatonic" "0 1 2 3 4"
```

---

## Style Recipes

### Ambient

**Goal:** slow, textural, evolving. Long cycles, lots of reverb, probabilistic events.

```haskell
-- Set slow tempo
setcps (60/60/4)   -- 60 BPM

-- Sparse kick, barely there
d1 $ s "bd ~ ~ ~" # gain 0.6 # room 0.9 # size 0.95

-- Slowly evolving texture pad
d2 $ loopAt 4 $ chop 32 $ s "pad:3"
   # gain 0.7 # room 0.95 # size 0.99 # cutoff (slow 16 $ range 400 2000 sine)
   # pan (slow 12 sine)

-- Occasional bell hit
d3 $ rarely (const $ s "cb:2") $ s "~"
   # gain 0.5 # room 0.99 # size 0.99 # delay 0.7 # delaytime (3/8) # delayfeedback 0.6

-- Sub bass note, very slow movement
d4 $ slow 4 $ n "<c2 g2 bf2 f2>" # s "bass2"
   # gain 0.8 # cutoff 200 # resonance 0.1
```

**Variations to explore:**
- `striate 16` on pads for granular shimmer
- `# speed (slow 32 $ range 0.95 1.05 sine)` for pitch drift
- `someCycles rev` on texture layers
- Increase `delayfeedback` toward 0.8 for self-oscillating echoes
- `every 16 (slow 2)` to occasionally drop into half-time
- Automate `room` from 0.3 to 0.99 over many cycles for spatial expansion

---

### Dub Techno

**Goal:** hypnotic, pulsing, reverb-heavy chords, sub bass, minimal percussion.

```haskell
-- Solid tempo
setcps (128/60/4)   -- 128 BPM

-- Kick: four on the floor, or sparser
d1 $ s "bd bd bd bd" # gain 0.95

-- Clap/snare on 2 and 4
d2 $ s "~ cp ~ cp" # gain 0.7 # room 0.6 # size 0.8

-- Hi-hats
d3 $ s "hh*8" # gain 0.5 # pan (slow 4 rand)

-- THE DUB CHORD: short stab, long reverb tail
d4 $ every 2 id $ s "pad:5 ~ ~ [~ pad:5] ~ ~ pad:5 ~"
   # gain 0.8 # room 0.95 # size 0.99 # cutoff 1200 # resonance 0.2
   # delay 0.6 # delaytime (3/8) # delayfeedback 0.55
   # pan (slow 8 sine)

-- Sub: root movement every 4 bars
d5 $ slow 4 $ n "<c1 c1 g1 bf1>" # s "bass"
   # gain 0.9 # cutoff 120 # resonance 0.05

-- Percussion layer: subtle and buried
d6 $ s "cb:0? ~ lt? ~" # gain 0.4 # room 0.7 # size 0.8
```

**Variations:**
- Bring in `d4` with `every 4 (const $ s "~")` to drop chords out every 4th cycle
- `# cutoff (slow 16 $ range 400 1800 sine)` for filter movement on the chord
- `delaytime (1/3)` for triplet delays — adds groove
- `fast 2` on `d6` for double-time percussion moments
- `# coarse (choose [0,0,0,4])` occasionally on hats for texture
- Use `d7 $ slow 8 $ s "industrial:0" # gain 0.3 # room 0.99` for subliminal texture
- Drop the kick with `d1 silence` then bring back for impact

---

### Breakbeat

**Goal:** syncopated, punchy, energetic. Focus on the break, manipulation, and bass.

```haskell
-- Higher tempo
setcps (145/60/4)   -- 145 BPM

-- The break: slice and rearrange
d1 $ slice 8 "0 1 2 3 4 <5 7> 6 3" $ s "break:0"
   # gain 0.9 # crush 12

-- Layered kick for weight
d2 $ s "bd ~ [~ bd] ~" # gain 0.85

-- Snare
d3 $ s "~ sd ~ sd" # gain 0.8 # room 0.3

-- Bass line: syncopated
d4 $ n "c2 ~ [~ c2] ~ g2 ~ bf2 [~ f2]" # s "bass"
   # gain 0.9 # cutoff 600 # resonance 0.2 # shape 0.3

-- Upper percussion
d5 $ s "hh*16" # gain (segment 16 $ range 0.3 0.7 rand)
   # pan (segment 16 $ range 0.2 0.8 rand)

-- Optional: sampler element
d6 $ every 4 (rev) $ slice 8 "0 1 3 4 2 7 5 6" $ s "break:1"
   # gain 0.6 # room 0.2
```

**Variations:**
- `hurry 2` on `d1` for a half-bar stutter
- `every 8 (iter 4)` on the break to shift phase
- `# speed (choose [1, 1.5, -1, 0.75])` on individual break slices
- `striate 16 $ s "break"` for granulated texture
- Drop to `setcps (72/60/4)` (half-time) then back for drop effect
- Add swing: `# nudge (segment 16 $ range 0 0.02 rand)` for humanised feel
- `chop 32` on a pad sample and layer at low gain for shimmer
- `someCycles (fast 2)` on the bass for occasional rushes

---

## Performance Flow & Timing

### Before You Start
- Boot SC and SuperDirt fully before touching Tidal
- Set your tempo with `setcps` first — commit to it
- Have 2–3 sample names you trust loaded in your head

### Session Structure (60-minute arc)

| Phase | Duration | Approach |
|-------|----------|----------|
| Ground | 0–8 min | One or two elements. Let them loop 8+ times. Find the pulse. |
| Build | 8–25 min | Add one thing at a time. 4–8 cycles minimum before next move. |
| Peak | 25–40 min | Full arrangement. Take risks here. Use `hush` if it goes wrong. |
| Transform | 40–52 min | Strip elements, mutate what's left. Change fundamental character. |
| Release | 52–60 min | Sparse, long reverb tails. Fade to near-silence. |

### Rules for Flow

**One move at a time.** Evaluate, listen for 2–4 cycles, then move again.

**Use `hush` without shame.** If something breaks the feel, silence it and rebuild.

**Mutation over addition.** Change what's there before adding something new. Use `every`, `sometimes`, `rev`, `fast/slow` on existing patterns.

**The kick is an anchor.** When in doubt, keep `d1` stable and mutate everything else.

**Leave space.** Rest (`~`) is as musical as sound. Sparse patterns breathe.

**Danger zone: eval lag.** When you evaluate code, it takes effect on the next cycle boundary — use this. Evaluate just before a downbeat for tight transitions.

### Useful Resets
```haskell
hush                -- silence everything
setcps (128/60/4)   -- reset tempo
resetCycles         -- restart cycle counter (sync point)
```

### Quick Expression Toolkit

```haskell
-- Instant tension
every 2 (fast 2)

-- Instant release
slow 2

-- Instant variation  
someCycles rev
every 4 (iter 4)

-- Dynamic drop
d1 $ s "bd ~ ~ ~"    -- thin out percussion to a single kick

-- Filter sweep (manual drama)
d4 $ s "pad" # cutoff (slow 2 $ range 200 4000 saw)

-- Sudden pitch shift
d1 $ s "hh*8" # speed 2

-- Glitch moment
every 8 (# crush 3) $ d2
```
