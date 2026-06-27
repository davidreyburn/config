#!/usr/bin/env python3
"""
topo-viz — audio-reactive topographic ASCII terrain, ANSI terminal output.
Implements topo-ascii-spec-v1.0.0 for terminal emulators.
Audio reactivity via cava raw FIFO at /tmp/topo-audio.
Keys: h/j = prev/next palette  k/l = prev/next character mode  q = quit
"""

import sys, os, math, time, signal, threading, select, random, tty, termios, stat as _stat
import numpy as np

# ─── Palettes ─────────────────────────────────────────────────────────────────

VERDIGRIS = {
    'name': 'VERDIGRIS',
    'bg': (22, 22, 20),
    'bands': [
        (0.12, (28,  27,  24)),
        (0.22, (45,  42,  36)),
        (0.32, (68,  64,  54)),
        (0.43, (95,  88,  74)),
        (0.54, (138, 128, 108)),
        (0.65, (185, 174, 148)),
        (0.75, (30,  82,  52)),
        (0.86, (48,  138, 62)),
        (1.01, (68,  187, 68)),
    ],
    'contour': (68, 187, 68),
}

PHOSPHOR = {
    'name': 'PHOSPHOR',
    'bg': (1, 10, 3),
    'bands': [
        (0.12, (1,   14,  4)),   (0.22, (3,   26,  7)),
        (0.32, (6,   46,  14)),  (0.43, (10,  74,  24)),
        (0.54, (15,  102, 34)),  (0.65, (23,  128, 48)),
        (0.75, (34,  160, 64)),  (0.86, (51,  196, 85)),
        (1.01, (85,  238, 119)),
    ],
    'contour': (57, 255, 106),
}

SURVEY = {
    'name': 'SURVEY',
    'bg': (6, 10, 7),
    'bands': [
        (0.12, (10,  42,  58)),  (0.22, (13,  61,  85)),
        (0.30, (200, 184, 112)), (0.42, (74,  122, 58)),
        (0.55, (58,  98,  48)),  (0.67, (107, 92,  66)),
        (0.79, (138, 122, 106)), (0.89, (184, 176, 164)),
        (1.01, (232, 228, 224)),
    ],
    'contour': (255, 255, 255),
}

INFRARED = {
    'name': 'INFRARED',
    'bg': (8, 5, 5),
    'bands': [
        (0.12, (13,  5,   32)),  (0.25, (26,  8,   64)),
        (0.38, (74,  8,   48)),  (0.50, (138, 16,  32)),
        (0.62, (204, 40,  0)),   (0.74, (238, 102, 0)),
        (0.85, (255, 170, 0)),   (0.93, (255, 221, 68)),
        (1.01, (255, 255, 204)),
    ],
    'contour': (255, 68, 0),
}

BATHYMETRY = {
    'name': 'BATHYMETRY',
    'bg': (2, 8, 16),
    'bands': [
        (0.10, (0,   8,   32)),  (0.22, (0,   24,  64)),
        (0.35, (0,   48,  96)),  (0.47, (0,   72,  128)),
        (0.58, (0,   96,  160)), (0.69, (8,   128, 184)),
        (0.79, (32,  160, 204)), (0.89, (96,  200, 224)),
        (1.01, (176, 238, 255)),
    ],
    'contour': (0, 212, 255),
}

GHOST = {
    'name': 'GHOST',
    'bg': (6, 6, 10),
    'bands': [
        (0.15, (8,   8,   18)),  (0.28, (16,  16,  42)),
        (0.40, (26,  26,  64)),  (0.52, (40,  40,  88)),
        (0.63, (56,  56,  112)), (0.73, (80,  72,  136)),
        (0.82, (104, 88,  160)), (0.91, (136, 120, 192)),
        (1.01, (192, 184, 232)),
    ],
    'contour': (153, 136, 255),
}

FOSSIL = {
    'name': 'FOSSIL',
    'bg': (18, 12, 8),
    'bands': [
        (0.12, (30,  22,  15)),  (0.22, (52,  38,  24)),
        (0.32, (82,  62,  42)),  (0.43, (115, 88,  58)),
        (0.54, (148, 118, 82)),  (0.65, (178, 152, 118)),
        (0.75, (200, 178, 148)), (0.86, (220, 204, 178)),
        (1.01, (242, 232, 215)),
    ],
    'contour': (248, 240, 225),
}

NEON_NOIR = {
    'name': 'NEON NOIR',
    'bg': (2, 4, 18),
    'bands': [
        (0.10, (4,   8,   28)),  (0.20, (8,   18,  62)),
        (0.30, (14,  44,  114)), (0.42, (20,  90,  188)),
        (0.53, (10,  168, 228)), (0.63, (80,  20,  162)),
        (0.73, (202, 22,  168)), (0.86, (255, 44,  188)),
        (1.01, (255, 144, 242)),
    ],
    'contour': (0, 224, 255),
}

AURORA = {
    'name': 'AURORA',
    'bg': (0, 4, 12),
    'bands': [
        (0.10, (0,   8,   20)),  (0.20, (0,   18,  38)),
        (0.30, (2,   42,  48)),  (0.42, (4,   88,  76)),
        (0.53, (8,   148, 92)),  (0.63, (62,  200, 120)),
        (0.73, (160, 60,  180)), (0.86, (220, 40,  160)),
        (1.01, (255, 120, 220)),
    ],
    'contour': (0, 255, 180),
}

OPERATOR = {
    'name': 'OPERATOR',
    'bg': (10, 10, 15),
    'bands': [
        (0.12, (13,  13,  20)),  (0.22, (13,  51,  68)),
        (0.32, (15,  72,  90)),  (0.43, (30,  100, 60)),
        (0.53, (55,  134, 39)),  (0.63, (20,  175, 120)),
        (0.73, (0,   217, 255)), (0.86, (15,  255, 100)),
        (1.01, (30,  255, 0)),
    ],
    'contour': (30, 255, 0),
}

TOXIC = {
    'name': 'TOXIC',
    'bg': (4, 8, 2),
    'bands': [
        (0.10, (8,   16,  4)),   (0.20, (16,  38,  6)),
        (0.30, (26,  76,  10)),  (0.42, (44,  126, 14)),
        (0.53, (68,  188, 20)),  (0.64, (122, 226, 24)),
        (0.74, (182, 246, 30)),  (0.86, (230, 255, 50)),
        (1.01, (255, 255, 130)),
    ],
    'contour': (180, 255, 20),
}

FLORAL_SHOPPE = {
    'name': 'FLORAL SHOPPE',
    'bg': (35, 5, 44),
    'bands': [
        (0.10, (35,  5,   44)),  (0.20, (55,  10,  62)),
        (0.30, (78,  18,  76)),  (0.42, (95,  24,  84)),
        (0.52, (20,  140, 130)), (0.63, (26,  187, 156)),
        (0.74, (80,  210, 190)), (0.86, (178, 240, 226)),
        (1.01, (247, 247, 247)),
    ],
    'contour': (26, 210, 172),
}

CREAMY_SUNSET = {
    'name': 'CREAMY SUNSET',
    'bg': (52, 32, 62),
    'bands': [
        (0.10, (52,  32,  62)),  (0.22, (82,  52,  94)),
        (0.34, (112, 72,  122)), (0.46, (158, 80,  108)),
        (0.56, (192, 108, 130)), (0.67, (218, 132, 118)),
        (0.77, (240, 160, 132)), (0.88, (250, 192, 162)),
        (1.01, (255, 224, 200)),
    ],
    'contour': (255, 180, 120),
}

PERIDOT = {
    'name': 'PERIDOT',
    'bg': (8, 56, 54),
    'bands': [
        (0.10, (8,   56,  54)),  (0.22, (12,  80,  70)),
        (0.34, (20,  110, 78)),  (0.46, (36,  140, 88)),
        (0.56, (62,  172, 98)),  (0.67, (106, 208, 122)),
        (0.77, (162, 232, 108)), (0.88, (210, 248, 130)),
        (1.01, (251, 255, 163)),
    ],
    'contour': (190, 255, 90),
}

DUSTY_PRAIRIE = {
    'name': 'DUSTY PRAIRIE',
    'bg': (60, 36, 8),
    'bands': [
        (0.10, (60,  36,  8)),   (0.22, (92,  60,  16)),
        (0.34, (130, 90,  28)),  (0.46, (164, 124, 48)),
        (0.56, (202, 164, 62)),  (0.67, (236, 198, 70)),
        (0.77, (220, 220, 178)), (0.88, (196, 222, 244)),
        (1.01, (213, 238, 255)),
    ],
    'contour': (248, 204, 68),
}

SGB_2H = {
    'name': 'SGB-2H',
    'bg': (0, 0, 0),
    'bands': [
        (0.10, (20,  20,  20)),  (0.22, (44,  44,  44)),
        (0.34, (72,  72,  72)),  (0.46, (100, 100, 100)),
        (0.56, (124, 124, 124)), (0.67, (152, 152, 152)),
        (0.77, (184, 184, 184)), (0.88, (216, 216, 216)),
        (1.01, (248, 248, 248)),
    ],
    'contour': (255, 255, 255),
}

PALETTES = [
    VERDIGRIS, PHOSPHOR, SURVEY, INFRARED, BATHYMETRY, GHOST, FOSSIL,
    NEON_NOIR, AURORA, OPERATOR, TOXIC, FLORAL_SHOPPE, CREAMY_SUNSET,
    PERIDOT, DUSTY_PRAIRIE, SGB_2H,
]

# ─── Character modes ──────────────────────────────────────────────────────────

MODES = [
    {
        'name': 'STRATA',
        'fill':      [' ', '.', '_', '-', '=', '≈', '≡', '█'],
        'cfn_cases': ['#', '=', '‖', '#'],
    },
    {
        'name': 'BLOCKS',
        'fill':      [' ', '·', '░', '░', '▒', '▒', '█', '█'],
        'cfn_cases': None,
    },
    {
        'name': 'STIPPLE',
        'fill':      [' ', '∙', '·', '+', '×', '±', '÷', '%'],
        'cfn_cases': None,
    },
    {
        'name': 'BRAILLE',
        'fill':      [' ', '.', ':', 'o', 'O', '0', '#', '#'],
        'cfn_cases': None,
    },
    {
        'name': 'SHADE',
        'fill':      [' ', ' ', '.', '.', '+', '+', '#', '@'],
        'cfn_cases': None,
    },
    {
        'name': 'RELIEF',
        'fill':      [' ', '.', '°', 'o', 'O', '0', '@', '█'],
        'cfn_cases': ['+', '-', '¦', '+'],
    },
]

# ─── Noise (spec-exact, vectorized) ───────────────────────────────────────────

NX, NY = 0.012, 0.022
CONTOUR_LEVELS = 12


def _hash2(ix, iy):
    h = (ix.astype(np.int64) * 1619 + iy.astype(np.int64) * 31337) & 0x7FFFFFFF
    h = (((h >> 16) ^ h) * 0x45D9F3B) & 0xFFFFFFFF
    h = (((h >> 16) ^ h) * 0x45D9F3B) & 0xFFFFFFFF
    return ((h >> 16) ^ h) & 0x7FFFFFFF


def _hash2s(ix, iy):
    h = (int(ix) * 1619 + int(iy) * 31337) & 0x7FFFFFFF
    h = (((h >> 16) ^ h) * 0x45D9F3B) & 0xFFFFFFFF
    h = (((h >> 16) ^ h) * 0x45D9F3B) & 0xFFFFFFFF
    return ((h >> 16) ^ h) & 0x7FFFFFFF


def _vn(xs, ys):
    ix = np.floor(xs).astype(np.int64)
    iy = np.floor(ys).astype(np.int64)
    fx = xs - ix
    fy = ys - iy
    sx = fx * fx * fx * (fx * (fx * 6 - 15) + 10)
    sy = fy * fy * fy * (fy * (fy * 6 - 15) + 10)
    v00 = _hash2(ix,   iy  ) / 0x7FFFFFFF
    v10 = _hash2(ix+1, iy  ) / 0x7FFFFFFF
    v01 = _hash2(ix,   iy+1) / 0x7FFFFFFF
    v11 = _hash2(ix+1, iy+1) / 0x7FFFFFFF
    a = v00 + (v10 - v00) * sx
    b = v01 + (v11 - v01) * sx
    return a + (b - a) * sy


def _vns(x, y):
    ix, iy = int(math.floor(x)), int(math.floor(y))
    fx, fy = x - ix, y - iy
    sx = fx*fx*fx*(fx*(fx*6-15)+10)
    sy = fy*fy*fy*(fy*(fy*6-15)+10)
    v00 = _hash2s(ix,   iy  ) / 0x7FFFFFFF
    v10 = _hash2s(ix+1, iy  ) / 0x7FFFFFFF
    v01 = _hash2s(ix,   iy+1) / 0x7FFFFFFF
    v11 = _hash2s(ix+1, iy+1) / 0x7FFFFFFF
    a = v00 + (v10 - v00) * sx
    b = v01 + (v11 - v01) * sx
    return a + (b - a) * sy


def _fbm(xs, ys, octaves):
    v, amp, freq, maxv = np.zeros_like(xs), 0.5, 1.0, 0.0
    for _ in range(octaves):
        v    += _vn(xs * freq, ys * freq) * amp
        maxv += amp
        amp  *= 0.5
        freq *= 2.0
    return v / maxv


def _warped_fbm(xs, ys, dx, dy, warp_scale):
    qx = _fbm(xs + dx,  ys + 0.3 + dy * 0.4, 2)
    qy = _fbm(xs + 1.7, ys + 9.2 + dy,       2)
    return _fbm(xs + warp_scale * qx + 1.3 + dx * 0.6,
                ys + warp_scale * qy + 9.2 + dy * 0.5, 3)


def _upsample(small, H, W):
    H2, W2 = small.shape
    ry = np.linspace(0, H2-1, H)
    rx = np.linspace(0, W2-1, W)
    iy = np.clip(np.floor(ry).astype(int), 0, H2-2)
    ix = np.clip(np.floor(rx).astype(int), 0, W2-2)
    fy = (ry - iy)[:, np.newaxis]
    fx = (rx - ix)[np.newaxis, :]
    a = small[np.ix_(iy, ix)] * (1-fx) + small[np.ix_(iy, ix+1)] * fx
    b = small[np.ix_(iy+1, ix)] * (1-fx) + small[np.ix_(iy+1, ix+1)] * fx
    return a * (1-fy) + b * fy


def compute_elevation(rows, cols, dx, dy, warp_scale=2.2):
    H2 = rows // 2 + 1
    W2 = cols // 2 + 1
    nx = NX * cols / max(W2 - 1, 1)
    ny = NY * rows / max(H2 - 1, 1)
    xs = np.arange(W2, dtype=np.float64)[np.newaxis, :] * nx + dx
    ys = np.arange(H2, dtype=np.float64)[:, np.newaxis] * ny + dy
    xs = np.broadcast_to(xs, (H2, W2)).copy()
    ys = np.broadcast_to(ys, (H2, W2)).copy()
    return _upsample(_warped_fbm(xs, ys, dx, dy, warp_scale), rows, cols)


# ─── Rendering ────────────────────────────────────────────────────────────────

def build_lookup(palette, mode):
    bg = palette['bg']
    bands = palette['bands']
    all_colors = [b[1] for b in bands] + [palette['contour']]
    fill = mode['fill']
    cfn  = mode['cfn_cases'] or []
    all_glyphs = fill + cfn
    bg_esc = f'\x1b[48;2;{bg[0]};{bg[1]};{bg[2]}m'
    lookup = {}
    for ci, color in enumerate(all_colors):
        fg_esc = f'\x1b[38;2;{color[0]};{color[1]};{color[2]}m'
        for gi, glyph in enumerate(all_glyphs):
            lookup[(ci, gi)] = fg_esc + bg_esc + glyph
    return lookup, len(bands), len(fill)


def render(elev, palette, mode, lookup, n_bands, fill_len, rows, cols):
    thresholds = np.array([b[0] for b in palette['bands']])

    color_slots = np.searchsorted(thresholds, elev, side='right').clip(0, n_bands - 1)
    glyph_slots = np.floor(np.clip(elev, 0, 0.9999) * fill_len).astype(int)

    if mode['cfn_cases']:
        cb   = (elev * CONTOUR_LEVELS).astype(int)
        er   = np.roll(elev, -1, axis=1)
        ed   = np.roll(elev, -1, axis=0)
        is_c = (cb != (er * CONTOUR_LEVELS).astype(int)) | \
               (cb != (ed * CONTOUR_LEVELS).astype(int))
        is_c[:, -1] = False
        is_c[-1, :] = False
        has_h = np.abs(elev - er) > 0.001
        has_v = np.abs(elev - ed) > 0.001
        cfn_case = has_h.astype(int) + has_v.astype(int) * 2
        wc = np.where(is_c)
        color_slots[wc] = n_bands
        glyph_slots[wc] = fill_len + cfn_case[wc]

    cs = color_slots.flatten().tolist()
    gs = glyph_slots.flatten().tolist()
    cells = [lookup[(c, g)] for c, g in zip(cs, gs)]

    lines = [f'\x1b[{r+1};1H' + ''.join(cells[r * cols:(r+1) * cols])
             for r in range(rows)]
    return ''.join(lines)


# ─── Drift ────────────────────────────────────────────────────────────────────

SILENCE_FLOOR = 0.025  # rms below this = frozen


class Drift:
    def __init__(self):
        self.dx       = 0.0
        self.dy       = 0.0
        self.angle    = random.uniform(0, 2 * math.pi)
        self.speed    = 0.0
        self.wander_a = random.uniform(0, 50)

    def advance(self, rms, bass, centroid):
        # Steep curves — only near-peak values produce meaningful motion
        def curve(x, floor, exp):
            x = max(0.0, (x - floor) / (1.0 - floor))
            return math.pow(x, exp)

        rms_g  = curve(rms,  SILENCE_FLOOR, 2.5)  # volume → speed
        bass_g = curve(bass, 0.0,            1.5)  # bass   → drift

        # Direction: noise wander (driven by bass) + spectral centroid bias
        self.wander_a += 0.0004 + bass_g * 0.002
        ang_noise  = (_vns(self.wander_a, 0.5) - 0.5) * math.pi * 1.4
        ang_target = ang_noise + (centroid - 0.5) * math.pi * 0.5
        self.angle += (ang_target - self.angle) * (0.006 + bass_g * 0.010)

        # Speed: volume drives magnitude
        self.speed += (rms_g * 0.018 - self.speed) * 0.06

        self.dx += math.cos(self.angle) * self.speed
        self.dy += math.sin(self.angle) * self.speed * 0.55


# ─── Audio ────────────────────────────────────────────────────────────────────

AUDIO_FILE     = '/tmp/topo-audio'
CAVA_PID_FILE  = '/tmp/topo-cava.pid'


class Audio:
    def __init__(self):
        self._rms      = 0.0
        self._bass     = 0.0
        self._centroid = 0.5
        self._lock     = threading.Lock()

    def update(self, rms, bass, bars):
        n = len(bars)
        total = sum(bars)
        centroid = (sum(i * b for i, b in enumerate(bars)) / (n * total)) if total > 0 else 0.5
        with self._lock:
            self._rms      = rms  * 0.12 + self._rms      * 0.88
            self._bass     = bass * 0.10 + self._bass      * 0.90
            self._centroid = centroid * 0.04 + self._centroid * 0.96  # very slow drift

    def get(self):
        with self._lock:
            return self._rms, self._bass, self._centroid


def _audio_thread(audio, stop):
    while not stop.is_set():
        try:
            with open(AUDIO_FILE, 'r') as f:
                warmup = 120  # discard ~2s while cava autosens calibrates
                while not stop.is_set():
                    line = f.readline()
                    if not line:
                        break  # FIFO writer disconnected
                    try:
                        bars = [int(v) / 1000.0 for v in line.strip().split(';') if v]
                    except ValueError:
                        continue
                    if not bars:
                        continue
                    if warmup > 0:
                        warmup -= 1
                        continue
                    rms  = math.sqrt(sum(b*b for b in bars) / len(bars))
                    bass = sum(bars[:4]) / 4
                    audio.update(rms, bass, bars)
        except (FileNotFoundError, IOError, OSError):
            time.sleep(0.5)


# ─── Main ─────────────────────────────────────────────────────────────────────

BASE_INTERVAL = 0.060  # seconds between drift advances at neutral audio


def _start_audio_feed():
    import subprocess
    # Kill any existing cava to avoid stale FIFO data on reconnect
    try:
        pid = int(open(CAVA_PID_FILE).read().strip())
        try:
            os.kill(pid, signal.SIGTERM)
        except (ProcessLookupError, PermissionError):
            pass
    except (FileNotFoundError, ValueError):
        pass
    # Always recreate the FIFO so there's no buffered data from the previous session
    if os.path.exists(AUDIO_FILE):
        os.unlink(AUDIO_FILE)
    os.mkfifo(AUDIO_FILE)
    conf = os.path.expanduser('~/.config/cava/audio-feed.conf')
    proc = subprocess.Popen(['cava', '-p', conf],
                            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    open(CAVA_PID_FILE, 'w').write(str(proc.pid))
    return proc


def main():
    sys.stdout.write('\x1b[?25l\x1b[2J')
    sys.stdout.flush()

    _sz = os.get_terminal_size(sys.stdout.fileno()); rows, cols = _sz.lines, _sz.columns
    resize = threading.Event()
    signal.signal(signal.SIGWINCH, lambda *_: resize.set())

    audio_feed = _start_audio_feed()
    audio = Audio()
    stop  = threading.Event()
    threading.Thread(target=_audio_thread, args=(audio, stop), daemon=True).start()

    palette_idx = 0
    palette     = PALETTES[palette_idx]
    mode_idx    = 0
    mode        = MODES[mode_idx]
    lookup, n_bands, fill_len = build_lookup(palette, mode)
    drift     = Drift()
    elev      = compute_elevation(rows, cols, drift.dx, drift.dy)

    flash_until  = 0.0
    last_advance = time.monotonic()
    last_render  = time.monotonic()
    RENDER_INTERVAL = 1 / 30

    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        while True:
            now = time.monotonic()

            if resize.is_set():
                resize.clear()
                _sz = os.get_terminal_size(sys.stdout.fileno()); rows, cols = _sz.lines, _sz.columns
                elev = compute_elevation(rows, cols, drift.dx, drift.dy)

            r, _, _ = select.select([sys.stdin], [], [], 0)
            if r:
                ch = sys.stdin.read(1)
                if ch in ('q', '\x1b', '\x03'):
                    break
                elif ch in ('h', 'j'):
                    delta = -1 if ch == 'h' else 1
                    palette_idx = (palette_idx + delta) % len(PALETTES)
                    palette = PALETTES[palette_idx]
                    lookup, n_bands, fill_len = build_lookup(palette, mode)
                    flash_until = now + 0.5
                elif ch in ('k', 'l'):
                    delta = -1 if ch == 'k' else 1
                    mode_idx = (mode_idx + delta) % len(MODES)
                    mode = MODES[mode_idx]
                    lookup, n_bands, fill_len = build_lookup(palette, mode)
                    flash_until = now + 0.5

            rms, bass, centroid = audio.get()

            if rms > SILENCE_FLOOR and now - last_advance >= BASE_INTERVAL:
                drift.advance(rms, bass, centroid)
                elev = compute_elevation(rows, cols, drift.dx, drift.dy)
                last_advance = now

            if now - last_render >= RENDER_INTERVAL:
                sys.stdout.write(render(elev, palette, mode, lookup, n_bands, fill_len, rows, cols))
                if now < flash_until:
                    c, b = palette['contour'], palette['bg']
                    style = f'\x1b[38;2;{c[0]};{c[1]};{c[2]}m\x1b[48;2;{b[0]};{b[1]};{b[2]}m'
                    sys.stdout.write(
                        f'\x1b[1;1H{style} PALETTE: {palette["name"]:<16}'
                        f'\x1b[2;1H{style} MODE:    {mode["name"]:<16}'
                    )
                sys.stdout.flush()
                last_render = now
            else:
                time.sleep(0.005)

    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)
        stop.set()
        if audio_feed is not None:
            audio_feed.terminate()
            try:
                os.unlink(CAVA_PID_FILE)
            except FileNotFoundError:
                pass
        sys.stdout.write('\x1b[?25h\x1b[2J\x1b[H')
        sys.stdout.flush()


if __name__ == '__main__':
    main()
