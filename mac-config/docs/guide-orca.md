# ORCA — Live Coding Guide
## For the live-orca session on this machine

---

## Your Rig

```
┌─────────────────────┬──────────┐
│                     │  sclang  │  ← define synths, receive MIDI
│       ORCA          ├──────────┤
│                     │  visual  │  ← topo-viz or cava
└─────────────────────┴──────────┘
```

Start the session: `live-orca`

ORCA sequences → CoreMIDI (IAC Driver) → SuperCollider synthesises.
The sclang pane is your synth layer — define sounds, tweak parameters, monitor.
The visual pane runs independently; launch with `topo-viz` or `cava` when wanted.

---

## One-Time System Setup: IAC Driver

ORCA sends MIDI to macOS CoreMIDI. For SC to receive it you need the IAC
(Inter-Application Communication) virtual MIDI bus enabled — this is a
system-level setting, done once.

1. Open **Audio MIDI Setup** (`/Applications/Utilities/Audio MIDI Setup.app`)
2. **Window → Show MIDI Studio** (or `Cmd+2`)
3. Double-click **IAC Driver**
4. Check **Device is online**
5. Confirm there is at least one port listed (add one if empty: click `+`)
6. Close

You now have a virtual MIDI loopback bus. ORCA writes to it, SC reads from it.

---

## Each-Session Setup

### 1. sclang pane — boot and wire MIDI

Paste this into the sclang pane at the start of every session. Evaluate each
block with the cursor inside it (`Ctrl+Enter` in sclang, or select + evaluate).

```supercollider
// Boot the audio server
s.boot;
```

Wait for `Server 'localhost' running` before continuing.

```supercollider
// Connect to IAC MIDI
MIDIClient.init;
MIDIIn.connectAll;
```

```supercollider
// Basic synth — tune this to taste
SynthDef(\orca, { |freq = 440, amp = 0.5, gate = 1, pan = 0, cutoff = 2000, res = 0.2|
    var env = EnvGen.kr(Env.adsr(0.005, 0.1, 0.6, 0.4), gate, doneAction: 2);
    var sig = VarSaw.ar(freq, 0, 0.3) + (SinOsc.ar(freq * 0.5) * 0.4);
    sig = MoogFF.ar(sig, cutoff, res);
    sig = sig * env * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;

// Track active notes so note-off works
~notes = Dictionary.new;

MIDIdef.noteOn(\orca_on, { |vel, note, chan|
    ~notes[note] = Synth(\orca, [
        \freq,   note.midicps,
        \amp,    vel / 127 * 0.7,
        \cutoff, 800 + (vel / 127 * 2000),
    ]);
});

MIDIdef.noteOff(\orca_off, { |vel, note, chan|
    ~notes[note].set(\gate, 0);
    ~notes.removeAt(note);
});
```

### 2. ORCA pane — select MIDI port

In ORCA, the MIDI output port is shown in the bottom status bar. Use the
interface controls to select the IAC Driver port if it isn't already selected.
Once a `:` operator fires with audio playing in SC, you'll hear it.

### 3. Visual pane (optional)

```
topo-viz    ← ambient terrain, audio reactive
cava        ← frequency bars
```

---

## ORCA Interface

**Navigation:** Arrow keys move cursor. Type a character to place it.

**Playback:**
- `Space` — play / pause
- `Ctrl+H` / `Ctrl+L` — increase / decrease BPM
- `Ctrl+F` — set BPM directly

**Editing:**
- Type — place operator or value at cursor
- `Ctrl+D` — erase cell
- `Escape` — deselect
- Click and drag — select region
- `Ctrl+X/C/V` — cut / copy / paste selection

**File:** `Ctrl+S` save, `Ctrl+O` open (or pass filename as arg: `orca myfile.orca`)

**Info bar** at bottom shows: BPM · frame count · cursor position · MIDI port

---

## Value System

ORCA uses **base-36**: `0–9` then `A–Z` (A=10, B=11 … Z=35).
All values are single characters. Positions, lengths, speeds, notes — all one char.

```
0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F  G  H  I  J ...  Z
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 ... 35
```

---

## Operators Reference

Uppercase = **active** (executes every frame). Lowercase = data/value.
`*` is a bang — it triggers operators that read it.

### Movement

| Op | Name | Behaviour |
|----|------|-----------|
| `E` | East | Moves east one cell per frame |
| `W` | West | Moves west one cell per frame |
| `N` | North | Moves north one cell per frame |
| `S` | South | Moves south one cell per frame |
| `H` | Halt | Stops eastward-moving operators |

### Logic

| Op | Name | Inputs | Output |
|----|------|--------|--------|
| `F` | If | W, E | Bang south if W == E |
| `L` | Less | W, E | Bang south if W < E |

### Math

| Op | Name | Inputs | Output |
|----|------|--------|--------|
| `A` | Add | W, E | W + E → south |
| `B` | Subtract | W, E | W − E → south |
| `M` | Multiply | W, E | W × E → south |

### Sequencing

| Op | Name | Inputs | Output |
|----|------|--------|--------|
| `C` | Clock | W=rate, E=mod | Counts 0→mod−1 at rate → south |
| `D` | Delay | W=rate | Bangs south every `rate` frames |
| `I` | Increment | W=step, E=mod | Steps by `step`, wraps at `mod` → south |
| `R` | Random | W=min, E=max | Random value in range → south |
| `U` | Uclid | W=step, E=max | Euclidean rhythm bang → south |

```
04C   →  0 1 2 3 0 1 2 3...  (every frame, mod 4)
28C   →  0 1 2 3 4 5 6 7...  (every 2 frames, mod 8)
13D   →  bang every 3 frames
24U   →  bang . bang .        (2 in 4, Euclidean)
38U   →  bang . bang . bang ...  (3 in 8)
```

### Data Flow

| Op | Name | Behaviour |
|----|------|-----------|
| `J` | Jumper | Reads south, outputs north |
| `Y` | Jymbol | Reads west, outputs east |
| `O` | Read | Reads cell at x,y offset → south |
| `X` | Write | Writes value to x,y offset |
| `P` | Push | Writes value eastward at key position |
| `Q` | Query | Reads `len` cells from offset eastward |
| `G` | Generator | Writes eastward values at offset each frame |
| `T` | Track | Reads indexed value from a sequence |
| `K` | Konkat | Reads variable names east, outputs their values |
| `Z` | Lerp | Steps toward east target at rate → south |

### Variables

```
-- Write: bang into V, name north, value east
*Va
4        ← writes 4 to variable 'a'

-- Read: no bang, outputs value east
Va       ← outputs stored value eastward
```

---

## Output Operators

### MIDI `:`

Sends a MIDI note to SC (via IAC) when it receives a bang on its left.

```
: channel octave note velocity length
```

| Param | Range | Notes |
|-------|-------|-------|
| channel | 0–f | Maps to MIDI channels 1–16 |
| octave | 0–8 | 4 = middle octave |
| note | C c D d E F f G g A a B | lowercase = sharp (C# D# F# G# A#) |
| velocity | 0–f | f = 127 (max) |
| length | 1–f | Duration in frames |

```
*:04C        →  ch0, octave 4, C, default vel/len
*:04Cff      →  full velocity, long note
*:14E84      →  ch1, octave 4, E, vel 8, len 4
```

**Note names:**
```
C  c  D  d  E  F  f  G  g  A  a  B
C  C# D  D# E  F  F# G  G# A  A# B
```

**Channels in your setup:** channel 0 → MIDI ch 1 → `\orca` synth in SC.
Add more synths and MIDIdefs for ch 1, 2 etc. to layer timbres.

### UDP `;`

Sends a raw UDP message to SC when banged. SC must have an `OSCdef` listening.
Useful for triggering non-note events (filter changes, reverb, FX).

```supercollider
// In SC: receive ORCA UDP messages
OSCdef(\orca_osc, { |msg| msg.postln }, '/orca');
```

---

## Patterns & Techniques

### BPM → Frame Relationship

```
At BPM 120, 4 frames per beat:
D4   = quarter note
D8   = half note
D2   = eighth note
D1   = sixteenth note (very fast)
DG   = 16-frame cycle (one bar of 16ths)
```

One bar = 16 frames at standard 4/4 with BPM=120.
`C016` counts one full 16-step bar per cycle.

### Euclidean Rhythms

```
24U  →  . * . *          quarter notes
38U  →  * . * . * . . .  clave-like
58U  →  * . * . * . * . *  dense
```

### Phase-Shifted Clocks

```
04C    ←  4-step clock
08C    ←  8-step clock at half speed
```

Two clocks at different rates create natural polyrhythm.

### Track Sequences

```
04C         ←  clock produces 0,1,2,3
T4CGEA      ←  T reads index from clock, outputs C G E A in turn
```

### Probability Gate

```
R09         ←  random 0–8
3F          ←  bang if == 3 (about 1-in-9 chance)
```

---

## SC Synth Control from the sclang Pane

The sclang pane is your live mixing desk. While ORCA sequences, you can:

```supercollider
// Reshape the timbre without restarting
SynthDef(\orca, { |freq = 440, amp = 0.5, gate = 1, pan = 0, cutoff = 800, res = 0.3|
    var env = EnvGen.kr(Env.adsr(0.01, 0.2, 0.5, 0.8), gate, doneAction: 2);
    var sig = Pulse.ar(freq, 0.4);
    sig = MoogFF.ar(sig, cutoff, res) * env * amp;
    Out.ar(0, Pan2.ar(sig, pan));
}).add;

// Change reverb globally
~verb = { |in| FreeVerb.ar(in, 0.6, 0.9) };

// Set a global filter cutoff all new notes will use
~cutoff = 600;

// Modify MIDIdef on the fly to pick up new parameter
MIDIdef.noteOn(\orca_on, { |vel, note, chan|
    ~notes[note] = Synth(\orca, [\freq, note.midicps, \amp, vel/127*0.6, \cutoff, ~cutoff]);
});
```

---

## Style Recipes

### Ambient

**Goal:** slow, sparse, long held notes. Irregular timing. SC reverb heavy.

```
BPM: 60–80

-- Held drone: D8 = half note pace, long MIDI length (f)
D8*:03Cff

-- Slow random walk through a minor-ish set
C08           ←  8-step clock
T4CEGa        ←  C E G Ab
*:04..8f      ←  bang into MIDI, oct4, note from track, vel 8, long
```

**SC side — ambient synth:**
```supercollider
SynthDef(\ambient, { |freq = 440, amp = 0.3, gate = 1|
    var env = EnvGen.kr(Env.adsr(0.5, 1.0, 0.7, 3.0), gate, doneAction: 2);
    var sig = SinOsc.ar([freq, freq * 1.002]) * env * amp;
    sig = FreeVerb.ar(sig.sum, 0.8, 0.99, 0.3);
    Out.ar(0, sig ! 2);
}).add;
```

**Variations:**
- Two `:` operators on different channels (ch0=pad, ch1=bell) for texture layers
- Increase D rate to D16+ for very sparse events
- Use `Z` to slowly glide between note values
- Long MIDI lengths (f) create natural overlapping chords

---

### Dub Techno

**Goal:** steady kick, hypnotic chord stab, sub bass, reverb-heavy space.

```
BPM: 120–134

-- Kick: D4 = quarter notes
D4*:090C88

-- Chord stab: 3-in-8 Euclidean rhythm, irregular but inevitable
38U*:141G88

-- Bass root rotation: 8-step clock, 4-note sequence
C08
T4CGBf
*:020..88

-- Hats: 2-in-8, sparse open feel
28U*:050f42
```

**SC side — dub pad:**
```supercollider
SynthDef(\dub, { |freq = 220, amp = 0.4, gate = 1, cutoff = 900|
    var env = EnvGen.kr(Env.adsr(0.005, 0.1, 0.6, 2.0), gate, doneAction: 2);
    var sig = Saw.ar([freq, freq * 1.004]);
    sig = MoogFF.ar(sig, cutoff * EnvGen.kr(Env.perc(0.01, 1.5)), 0.3);
    sig = FreeVerb.ar(sig.sum, 0.7, 0.95) * env * amp;
    Out.ar(0, sig ! 2);
}).add;
```

**Variations:**
- Change stab rhythm: `58U` busier, `28U` sparser
- Rotate chord: change track values C→G→Bb→F for movement
- Use `R` on velocity: `R68` randomises feel
- Drop kick channel to silence for breakdowns

---

### Breakbeat

**Goal:** syncopated, punchy, fast melodic movement.

```
BPM: 140–160

-- Kick + off-kick
D4*:090C94
D6*:090C82

-- Snare: F gate on 16-step clock at beats 2 and 4
C016
4F*:091D93
CF*:091D93

-- Hi-hats dense Euclidean
B16U*:090f32

-- Bass: fast 6-step for odd phrasing
C06
T6CGEaCB
*:020..84

-- Melody: 6-step track, short notes
C06
T6EGaCBD
*:130..74
```

**SC side — breakbeat bass:**
```supercollider
SynthDef(\bass, { |freq = 80, amp = 0.7, gate = 1|
    var env = EnvGen.kr(Env.adsr(0.002, 0.08, 0.3, 0.1), gate, doneAction: 2);
    var sig = Pulse.ar(freq, 0.5) + SinOsc.ar(freq * 0.5);
    sig = MoogFF.ar(sig, 600 * env + 100, 0.25) * env * amp;
    Out.ar(0, sig ! 2);
}).add;
```

**Variations:**
- Swing: two parallel D operators at rates 4 and 5 on alternate hits
- Drop hi-hat density: `B16U` → `38U` for sudden space
- Fill: `C28` clock into `T4` for a 4-note fill every 8 steps
- Risk: `I` with step > 1 (`2IG` steps by 2 through 16) for off-kilter sequence

---

## Performance Flow & Timing

### Session Arc (45 minutes)

| Phase | Duration | Approach |
|-------|----------|----------|
| Boot | 0–3 min | SC boots, MIDI wired, one test note confirmed. |
| Ground | 3–8 min | Kick only, or sub drone only. Find the pulse. |
| Layer | 8–22 min | One operator cluster at a time. Listen before next move. |
| Peak | 22–35 min | Full grid. Harmonic variation. Take risks. |
| Strip | 35–43 min | Delete rows. Change direction. |
| Exit | 43–45 min | One or two elements. Long notes. Let it decay. |

### Working the Two Panes

**ORCA pane** → structural changes: rhythm, pitch sequences, density.
**sclang pane** → timbral changes: redefine SynthDefs, tweak global parameters, add reverb/FX.

The split lets you change *what notes play* (ORCA) independently from *how they sound* (SC). Use this. A complete vibe change can come from redefining the SynthDef alone without touching ORCA.

### Rules for Flow

**Work in clusters.** One complete cluster = clock + rhythm operator + `:` output. Build one, confirm it works, then add the next.

**Delete fearlessly.** Select a broken cluster and delete it. Rebuild from scratch faster than debugging.

**Silence via D rate.** Increase a D operator's rate (D4→D8→DG) to thin a pattern without deleting it. Restore by decreasing.

**Gate with F.** `F` can open or close any output. Change the comparison value live to mute/unmute.

**Mutation over addition.** Change track note values (east of `T`) to shift melody — fast, low-risk, immediate.

**Tempo as drama.** `Ctrl+H/L` raises/lowers BPM mid-set. Halving tempo with long MIDI notes is an instant drop. Doubling is a rush.

### Quick Techniques

```
-- Instant half-time: double all D rates
D4 → D8 on kick

-- Instant variation: change one note in a track
T4CGEC → T4CGEa    (Ab instead of C at end)

-- Riser: I stepping through rising notes
1IG    → C D E F G A B... over time

-- Drop: delete all rows except kick, rebuild over next 8 bars

-- SC timbral drop: in sclang pane, redefine \orca with longer attack/release
-- everything ORCA sends now sounds different immediately
```

---

## Troubleshooting

**No sound when `:` fires:**
1. Is SC server running? (`s.boot` in sclang pane, wait for confirmation)
2. Is MIDI connected? (`MIDIClient.init; MIDIIn.connectAll;`)
3. Is IAC Driver online in Audio MIDI Setup?
4. Is the MIDI port selected in ORCA's status bar?
5. Test: send a note manually in sclang — `Synth(\orca, [\freq, 440])` — if you hear it, the synth is fine and the issue is MIDI routing.

**ORCA MIDI port shows nothing:**
- IAC Driver not enabled — see First-time System Setup above.

**Notes stick on (no note-off):**
- MIDI length value in `:` operator is too long, or note-off MIDIdef isn't running.
- Quick fix: `~notes.do(_.set(\gate, 0))` in sclang pane to kill all active notes.
