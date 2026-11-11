/* ==========================================================================
   THE BOLD FANTASTIC
   A context-stuffed orrery. Steve Elias Oregel | CRCP 6330 | Week 9 Studio

   HOW THIS WAS MADE
   My whole curated context snapshot (prepared_context/course.txt, 148,864
   characters) was stuffed into ONE prompt and read start to finish by the
   model (Claude). No vector search, no top-3 chunks, no graph. Week 7's
   "Elemental Ribbons" was built from 13 searches over 250-character chunks.
   This piece is built from details that only show up when the model holds
   the entire folder at once.

   EVERY DECISION AND THE SOURCE IT CAME FROM
    1. The orrery tilt, PERSP = 0.654
       Heavenly_Bodies.pde: "planet orbit rx=347px, ry=227px,
       PERSP=227/347=0.654". Every ellipse here uses that measured number.
    2. Inner belt and outer ring stored as 2D grids
       Heavenly_Bodies.pde: "inner asteroid belt, float[COLS][ROWS] 2D grid"
       and "outer Kuiper ring, float[KCOLS][KROWS]". Comet ejections on click
       come from the same file ("debris flung from both rings").
    3. Belt shards are starPoly() with a low inner ratio
       poly.pde: "For asteroids I use a low inner ratio (0.35 to 0.5) so they
       look jagged and rocky".
    4. Planet positions are parametric, not free n-body
       Body.pde: "parametric positioning owns pos".
    5. The gown has 13 layers and golden ratio motion, gold on every layer
       Mandala.pde: "13-layer mandala", "phi = 1.618", "keeping gold
       (#FFD700) on every layer for visual consistency".
    6. The halo above the gown runs deep purple to gold
       Mandala.pde: "dark/deep (purple) at the bottom to bright (gold) at
       the top".
    7. One red gown in a restrained field
       about-steve.md: "Restraint plus one bold move (a single red gown, a
       single gold accent)". Nothing else in the piece is allowed to be red.
    8. The gown moves on the Red Dress GIF's real clock
       RedDressFinal.pde: frames 0-23 sweep RIGHT, 24-39 sweep LEFT, 40-48
       sweep UP (sonic burst), 49-54 settle. The per-frame delays (40 and
       50 ms, 55 frames, 2290 ms) come from my Claude Code background
       removal prompt. The timeline at the bottom is that data, drawn.
    9. The flock forms a crescent on the trailing edge, then bursts
       RedDressFinal.pde: "crescent forms on RIGHT trailing edge", "sonic
       burst ring expands from center", "flock disperses and reforms".
   10. The stylus is always down and chases the pointer at 0.15
       Silvertrace README: "always touching", "~0.15 lerp per frame".
       Strokes are stored in normalized coordinates so a resize never wipes
       the drawing (same README, "Resizing the window must not wipe").
   11. The stylus line is mirrored like a kaleidoscope, 3 to 12 segments
       crystalline-kaleidoscope.pde: "LEFT/RIGHT, change kaleidoscope
       segments (3-12)" and "flip half of them ... for the mirror effect".
   12. Five planets, one per spec brand, each its own material
       about-steve.md: "One product, many worlds ... (desert strata, Swiss
       lab grid, nautical chart, candlelit stone, island beauty)".
   13. The background is a soft-edged color field
       Rothko sketch: "layered thin washes of paint with no hard edges".
   14. Magazine cover layout, subject overlapping the masthead
       Tantalum cover, "THE BOLD FANTASTIC". I tried a masthead (TANTALUM,
       then TBF) and cut it: the piece is stronger with nothing written
       across the top (my call). Compass needle at 30 degrees
       comes from the PELAGIC nautical chart flatlay caption.
   15. Slow, not aggressive
       crystalline-prism.pde: "keeping it slow and meditative", "sometimes
       restraint is the luxury move".

   WHAT THE CONTEXT COULD NOT SUPPLY (so nobody mistakes it for evidence)
    * Brand colors. The only hex values in the whole snapshot are #FFD700
      and the Silvertrace toy palette. Every planet and field color is the
      model's interpretation of brand words like "amber glass" and "desert
      strata".
    * The images themselves. The model only read machine-made captions, and
      many are wrong (LEI WAI was read as "LELEI", "KATY" and "VIVI"). File
      names and my index were trusted over captions.
    * The red of the gown. "Red" is in the text. The exact red is a guess.
    * Golden ratio rotation on fabric. Counter-rotating layers would tear a
      connected gown apart, so the phi relationship is kept as the ratio
      between each layer's sway frequency instead of its spin speed. The
      halo keeps true phi spin because its layers are not connected.
    * The GIF loop is slowed 4x. At the real 2290 ms it reads as frantic.

   CONTROLS
     Move          steer the always-down stylus, embroiders the floor
     Click         sonic burst plus comets off the belt
     1 to 5        spotlight a brand world (auto-cycles if left alone)
     Up / Down     kaleidoscope segments, 3 to 12
     Space         clear the embroidery
     H             hide or show the cover type
     S             save a PNG
   ========================================================================== */

const PHI = 1.61803398875;
const PERSP = 227 / 347;          // 0.654, measured in Heavenly_Bodies.pde
const LAYERS = 13;                // Mandala.pde
const PANELS = 34;                // pleats per layer (a Fibonacci number)
const GIF_FRAMES = 55;
const SLOW = 4;                   // the loop is slowed 4x, see notes above
const EASE = 0.15;                // Silvertrace stylus easing
const GOLD = [255, 215, 0];       // #FFD700, Mandala.pde
const RED = [198, 18, 42];
const GOWN_H = 0.6;
const HEM_R = 0.27;

const COLS = 150, ROWS = 5;       // inner belt grid
const KCOLS = 230, KROWS = 4;     // outer ring grid

// p5 takes ONE family name, not a CSS list, so pick the first installed one
let SERIF = 'serif', SANS = 'sans-serif';
function pickFont(list, fallback) {
  // document.fonts.check() says yes to fonts that are not installed, so
  // measure instead: an installed font changes the width of a test string.
  const c = document.createElement('canvas').getContext('2d');
  const probe = 'TBFmmwwii 0123 The Bold Fantastic';
  for (const f of list) {
    let hit = false;
    for (const base of ['monospace', 'serif']) {
      c.font = '72px ' + base; const w0 = c.measureText(probe).width;
      c.font = '72px "' + f + '", ' + base; const w1 = c.measureText(probe).width;
      if (Math.abs(w1 - w0) > 0.5) hit = true;
    }
    if (hit) return f;
  }
  return fallback;
}

// Brand worlds. Words come from my index. Colors are interpretation.
const WORLDS = [
  { name: 'EPOCH', line: 'desert strata', orbit: 0.46,
    cols: [[196, 118, 58], [232, 176, 98], [112, 64, 42]] },
  { name: 'LIGAND', line: 'amber glass, swiss grid', orbit: 0.555,
    cols: [[226, 140, 34], [238, 232, 220], [70, 52, 34]] },
  { name: 'PELAGIC', line: 'crystal, nautical chart', orbit: 0.65,
    cols: [[34, 140, 150], [150, 232, 222], [12, 44, 78]] },
  { name: 'SANTO BRUTO', line: 'raw stone, gold foil, candlelight', orbit: 0.745,
    cols: [[92, 74, 66], [240, 172, 84], [40, 32, 30]] },
  { name: 'LEI WAI', line: 'black stone, water, island beauty', orbit: 0.84,
    cols: [[110, 196, 198], [240, 176, 176], [22, 28, 34]] }
];

let W, H, U, cx, cy;
let bgCur, bgPrev, bgFade = 1;
let worldIdx = 0, worldCol, holdUntil = 0, lastAuto = 0;
let starField = [];
let beltJit = [], beltE = [], kJit = [], kE = [];
let boids = [];
let segs = [];
let bursts = [], comets = [];
let stylus = { x: 0, y: 0, ready: false };
let mirrors = 8;
let showType = true;
let delays = [], cum = [];
let swayHist = [], liftHist = [];
let swayNow = 0, liftNow = 0, lastPhase = '';
let gifFrame = 0;
let rings = [];
let T = 0;

// ---------------------------------------------------------------- setup

function setup() {
  pixelDensity(Math.min(window.devicePixelRatio || 1, 2));
  createCanvas(windowWidth, windowHeight);
  SERIF = pickFont(['Didot', 'Bodoni MT', 'Bodoni 72', 'Playfair Display', 'Times New Roman', 'Georgia'], 'serif');
  SANS = pickFont(['Helvetica Neue', 'Helvetica', 'Arial'], 'sans-serif');

  // the real per-frame delays from the red dress GIF: every 6th frame
  // starting at index 2 is 50 ms, the rest are 40 ms. total 2290 ms.
  let acc = 0;
  for (let i = 0; i < GIF_FRAMES; i++) {
    const d = (i % 6 === 2) ? 50 : 40;
    delays.push(d);
    cum.push(acc);
    acc += d;
  }

  for (let i = 0; i < 90; i++) { swayHist.push(0); liftHist.push(0); }

  for (let c = 0; c < COLS; c++) {
    beltJit.push([]); beltE.push([]);
    for (let r = 0; r < ROWS; r++) {
      beltJit[c].push([random(-1, 1), random(-1, 1), random(), random(TAU)]);
      beltE[c].push(0);
    }
  }
  for (let c = 0; c < KCOLS; c++) {
    kJit.push([]); kE.push([]);
    for (let r = 0; r < KROWS; r++) {
      kJit[c].push([random(-1, 1), random(-1, 1), random()]);
      kE[c].push(0);
    }
  }

  for (let i = 0; i < 240; i++) {
    starField.push([random(), random(), random(TAU), random(0.4, 1.6)]);
  }

  worldCol = WORLDS[0].cols.map(c => c.slice());
  layout();
  bgCur = buildField(WORLDS[0]);

  for (let i = 0; i < 230; i++) {
    boids.push({
      x: cx + random(-U, U) * 0.6, y: cy - random(U * 0.6),
      vx: random(-1, 1), vy: random(-1, 1),
      k: random(-1, 1), rr: random(-1, 1)
    });
  }
  stylus.x = cx; stylus.y = cy + U * 0.3;
}

function layout() {
  W = width; H = height;
  U = Math.min(W * 0.47, H * 0.52);
  cx = W / 2;
  cy = H * 0.62;
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  layout();
  bgCur = buildField(WORLDS[worldIdx]);
  bgPrev = null; bgFade = 1;
}

// plane coords (px, pz) plus height py, to screen
function proj(px, pz, py) {
  return [cx + px * U, cy + pz * U * PERSP - (py || 0) * U];
}

// ---------------------------------------------------------------- field

// Rothko: thin washes, no hard edges. Each band is many inset rectangles
// at very low alpha so the edges dissolve.
function buildField(world) {
  const g = createGraphics(W, H);
  g.pixelDensity(1);
  g.background(13, 10, 17);
  g.noStroke();
  const bands = [
    [0.07, 0.36, world.cols[2], 0.9],
    [0.39, 0.72, world.cols[0], 0.55],
    [0.75, 0.95, world.cols[1], 0.28]
  ];
  for (const b of bands) {
    const x0 = W * 0.06, x1 = W * 0.94, y0 = H * b[0], y1 = H * b[1];
    const steps = 34;
    for (let k = 0; k < steps; k++) {
      const inset = k * Math.min(W, H) * 0.0055;
      g.fill(b[2][0] * b[3], b[2][1] * b[3], b[2][2] * b[3], 7);
      g.rect(x0 + inset, y0 + inset * 0.7, (x1 - x0) - inset * 2, (y1 - y0) - inset * 1.4,
        Math.min(W, H) * 0.03);
    }
  }
  // vignette
  const ctx = g.drawingContext;
  const grad = ctx.createRadialGradient(W / 2, H * 0.55, Math.min(W, H) * 0.25,
    W / 2, H * 0.55, Math.max(W, H) * 0.78);
  grad.addColorStop(0, 'rgba(0,0,0,0)');
  grad.addColorStop(1, 'rgba(4,2,8,0.86)');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, W, H);
  return g;
}

function setWorld(i, manual) {
  if (i === worldIdx) { if (manual) holdUntil = millis() + 60000; return; }
  worldIdx = i;
  if (bgPrev) bgPrev.remove();
  bgPrev = bgCur;
  bgCur = buildField(WORLDS[i]);
  bgFade = 0;
  if (manual) holdUntil = millis() + 60000;
  lastAuto = millis();
}

// ---------------------------------------------------------------- clock

// which GIF frame are we on, using the real per-frame delays
function updateClock() {
  const ms = (millis() / SLOW) % 2290;
  let f = 0;
  for (let i = GIF_FRAMES - 1; i >= 0; i--) { if (ms >= cum[i]) { f = i; break; } }
  gifFrame = f;

  let dir = 0, up = 0, phase = 'settle';
  if (f <= 23) { dir = 1; phase = 'right'; }
  else if (f <= 39) { dir = -1; phase = 'left'; }
  else if (f <= 48) { up = 1; phase = 'up'; }

  swayNow = lerp(swayNow, dir, 0.045);
  liftNow = lerp(liftNow, up, 0.07);
  swayHist.unshift(swayNow); swayHist.pop();
  liftHist.unshift(liftNow); liftHist.pop();

  if (phase !== lastPhase) {
    if (phase === 'up') bursts.push({ r: HEM_R, a: 1 });
    lastPhase = phase;
  }
  return phase;
}

// ---------------------------------------------------------------- draw

function draw() {
  T = millis() / 1000;
  const phase = updateClock();

  // auto-cycle the spotlight every two loops unless a key is holding it
  if (millis() > holdUntil && millis() - lastAuto > 2290 * SLOW * 2) {
    setWorld((worldIdx + 1) % WORLDS.length, false);
  }
  for (let i = 0; i < 3; i++) for (let k = 0; k < 3; k++) {
    worldCol[i][k] = lerp(worldCol[i][k], WORLDS[worldIdx].cols[i][k], 0.03);
  }

  // field
  blendMode(BLEND);
  if (bgPrev && bgFade < 1) {
    image(bgPrev, 0, 0, W, H);
    bgFade = Math.min(1, bgFade + 0.012);
    drawingContext.globalAlpha = bgFade;
    image(bgCur, 0, 0, W, H);
    drawingContext.globalAlpha = 1;
  } else {
    image(bgCur, 0, 0, W, H);
  }

  drawStars();

  computeGown();
  updateStylus();

  drawFloorGlow();
  drawEmbroidery();
  drawOrbits();

  updateBursts();
  drawRing(false);
  drawBelt(false);
  drawPlanets(false);

  drawHalo();
  drawGown();

  drawPlanets(true);
  drawBelt(true);
  drawRing(true);
  drawBursts();
  drawComets();

  updateFlock(phase);
  drawFlock();

  drawStylusTip();
  if (showType) drawCoverType(phase);
}

// ---------------------------------------------------------------- stars

function drawStars() {
  noStroke();
  for (const s of starField) {
    const tw = 0.5 + 0.5 * Math.sin(T * 0.8 * s[3] + s[2]);
    fill(235, 225, 210, 30 + tw * 90);
    const d = s[3] * (0.7 + tw * 0.6);
    circle(s[0] * W, s[1] * H * 0.9, d);
  }
}

// ---------------------------------------------------------------- gown

function gownRadius(t) {
  // bodice, waist, then a long flare to the hem
  const flare = Math.pow(Math.max(0, (t - 0.14) / 0.86), 1.65);
  const bust = 0.022 * Math.exp(-Math.pow((t - 0.045) / 0.05, 2));
  return 0.03 + bust + (HEM_R - 0.03) * flare;
}

function computeGown() {
  rings = [];
  for (let i = 0; i < LAYERS; i++) {
    const t = i / (LAYERS - 1);
    const lag = Math.floor(i * 5.5);
    const sw = swayHist[Math.min(lag, swayHist.length - 1)];
    const lf = liftHist[Math.min(Math.floor(i * 2.5), liftHist.length - 1)];
    const ox = sw * 0.07 * Math.pow(t, 1.5);
    let h = GOWN_H * (1 - Math.pow(t, 0.95)) + lf * 0.06 * t;
    let r = gownRadius(t) * (1 + lf * 0.22 * t);
    // golden ratio kept as the ratio between layer sway frequencies
    const twist = T * 0.08 + 0.55 * t * Math.sin(T * 0.6 / Math.pow(PHI, i / 4) + i * 0.7)
      - sw * 0.5 * t;
    const pts = [];
    for (let j = 0; j < PANELS; j++) {
      const a = (j / PANELS) * TAU + twist;
      const ruffle = 1 + 0.085 * t * t * Math.sin(a * 5 + T * 1.25 + i * 0.5)
        + 0.03 * t * Math.sin(a * 13 - T * 2.1);
      const rr = r * ruffle;
      const hh = h + 0.012 * t * t * Math.sin(a * 5 + T * 1.25 + i * 0.5 + 1.2);
      const p = proj(ox + rr * Math.cos(a), rr * Math.sin(a), hh);
      pts.push({ x: p[0], y: p[1], a: a });
    }
    rings.push({ pts: pts, ox: ox, h: h, t: t });
  }
}

function drawFloorGlow() {
  const ctx = drawingContext;
  ctx.save();
  ctx.translate(cx + rings[LAYERS - 1].ox * U, cy);
  ctx.scale(1, PERSP);
  const g = ctx.createRadialGradient(0, 0, 0, 0, 0, U * 0.62);
  g.addColorStop(0, 'rgba(198,18,42,0.34)');
  g.addColorStop(0.45, 'rgba(198,18,42,0.10)');
  g.addColorStop(1, 'rgba(198,18,42,0)');
  ctx.fillStyle = g;
  ctx.beginPath(); ctx.arc(0, 0, U * 0.62, 0, TAU); ctx.fill();
  ctx.restore();
}

function panelColor(am, j, front, t) {
  const nx = Math.cos(am), nz = Math.sin(am);
  const d = Math.max(0, nx * -0.6 + nz * 0.8);
  const pleat = (j % 2) ? 0.78 : 1;
  if (!front) {
    const b = (0.16 + 0.12 * Math.max(0, -nz)) * pleat;
    return [RED[0] * b, RED[1] * b, RED[2] * b + 6, 255];
  }
  const base = (0.2 + 0.8 * d) * pleat * (0.82 + 0.18 * t);
  const spec = Math.pow(d, 16) * 0.75 * pleat;
  return [
    Math.min(255, RED[0] * base + 255 * spec),
    Math.min(255, RED[1] * base + 170 * spec),
    Math.min(255, RED[2] * base + 175 * spec),
    240
  ];
}

function drawGownPass(front) {
  noStroke();
  for (let i = 0; i < LAYERS - 1; i++) {
    const A = rings[i].pts, B = rings[i + 1].pts;
    for (let j = 0; j < PANELS; j++) {
      const j2 = (j + 1) % PANELS;
      const am = A[j].a + PI / PANELS;
      const isFront = Math.sin(am) > 0;
      if (isFront !== front) continue;
      const c = panelColor(am, j, front, rings[i].t);
      fill(c[0], c[1], c[2], c[3]);
      quad(A[j].x, A[j].y, A[j2].x, A[j2].y, B[j2].x, B[j2].y, B[j].x, B[j].y);
    }
  }
  // gold on every layer
  noFill();
  for (let i = 0; i < LAYERS; i++) {
    const P = rings[i].pts;
    const hem = (i === LAYERS - 1);
    stroke(GOLD[0], GOLD[1], GOLD[2], front ? (hem ? 230 : 70 + i * 6) : 40);
    strokeWeight(hem ? 1.6 : 0.8);
    for (let j = 0; j < PANELS; j++) {
      const j2 = (j + 1) % PANELS;
      const isFront = Math.sin(P[j].a + PI / PANELS) > 0;
      if (isFront !== front) continue;
      line(P[j].x, P[j].y, P[j2].x, P[j2].y);
    }
    if (hem && front) {
      noStroke(); fill(255, 235, 150, 230);
      for (let j = 0; j < PANELS; j += 2) {
        if (Math.sin(P[j].a) > -0.1) circle(P[j].x, P[j].y, 2.6);
      }
      noFill();
    }
  }
}

function drawGown() {
  blendMode(BLEND);
  drawGownPass(false);
  drawGownPass(true);
}

// the star: a 13-layer mandala, deep purple outside to gold at the core,
// every layer spinning at a golden ratio step from its neighbor
function drawHalo() {
  const top = rings[0];
  const hx = cx + top.ox * U, hy = cy - (top.h + 0.045) * U;
  const R = U * (0.2 + liftNow * 0.05);
  blendMode(ADD);
  noStroke();
  // soft corona
  const ctx = drawingContext;
  const g = ctx.createRadialGradient(hx, hy, 0, hx, hy, R * 1.5);
  g.addColorStop(0, 'rgba(255,225,150,0.55)');
  g.addColorStop(0.25, 'rgba(255,190,90,0.16)');
  g.addColorStop(1, 'rgba(120,40,160,0)');
  ctx.fillStyle = g;
  ctx.beginPath(); ctx.arc(hx, hy, R * 1.5, 0, TAU); ctx.fill();

  for (let i = LAYERS - 1; i >= 0; i--) {
    const u = i / (LAYERS - 1);                 // 0 core, 1 outer
    const rad = R * (0.1 + 0.9 * u);
    const n = 8 + (i % 4) * 4;
    const speed = 0.22 / Math.pow(PHI, i % 6) * ((i % 2) ? -1 : 1);
    const rot = T * speed + i;
    const cr = lerp(GOLD[0], 96, u), cg = lerp(GOLD[1], 36, u), cb = lerp(60, 170, u);
    const pulse = 1 + 0.06 * Math.sin(T * 1.1 + i * 0.6);
    push();
    translate(hx, hy);
    rotate(rot);
    for (let k = 0; k < n; k++) {
      push();
      rotate((k / n) * TAU);
      fill(cr, cg, cb, 26 + (1 - u) * 34);
      ellipse(rad * pulse, 0, rad * 0.46, rad * 0.13);
      fill(GOLD[0], GOLD[1], GOLD[2], 90);
      circle(rad * pulse * 1.22, 0, 1.6);
      pop();
    }
    pop();
  }
  blendMode(BLEND);
}

// ---------------------------------------------------------------- belts

function starPoly(x, y, outer, inner, n, rot) {
  beginShape();
  for (let i = 0; i < n * 2; i++) {
    const r = (i % 2) ? inner : outer;
    const a = rot + (i / (n * 2)) * TAU;
    vertex(x + Math.cos(a) * r, y + Math.sin(a) * r * 0.85);
  }
  endShape(CLOSE);
}

function drawBelt(front) {
  noStroke();
  blendMode(ADD);
  const c1 = worldCol[1];
  for (let c = 0; c < COLS; c++) {
    for (let r = 0; r < ROWS; r++) {
      const jit = beltJit[c][r];
      const rad = 0.335 + (r / (ROWS - 1)) * 0.065 + jit[1] * 0.006;
      const a = (c / COLS) * TAU + jit[0] * 0.02 + T * 0.05 / Math.pow(rad / 0.335, 1.5);
      const isFront = Math.sin(a) > 0;
      if (isFront !== front) continue;
      const v = noise(c * 0.16, r * 0.7, T * 0.25);
      beltE[c][r] *= 0.965;
      const e = beltE[c][r];
      const p = proj(rad * Math.cos(a), rad * Math.sin(a), 0);
      const depth = 0.75 + 0.25 * Math.sin(a);
      const s = U * 0.0042 * (0.5 + v * 1.7 + e * 2.4) * depth;
      fill(lerp(c1[0], GOLD[0], e), lerp(c1[1], GOLD[1], e), lerp(c1[2], GOLD[2] + 120, e),
        (40 + v * 150 + e * 160) * depth);
      starPoly(p[0], p[1], s, s * (0.35 + 0.15 * jit[2]), 5, jit[3] + T * (jit[0]));
    }
  }
  blendMode(BLEND);
}

function drawRing(front) {
  blendMode(ADD);
  const c0 = worldCol[0];
  strokeWeight(1.4);
  for (let c = 0; c < KCOLS; c++) {
    for (let r = 0; r < KROWS; r++) {
      const jit = kJit[c][r];
      const rad = 0.93 + (r / (KROWS - 1)) * 0.07 + jit[1] * 0.008;
      const a = (c / KCOLS) * TAU + jit[0] * 0.012 - T * 0.012;
      if ((Math.sin(a) > 0) !== front) continue;
      const v = noise(c * 0.09, r * 0.5 + 9, T * 0.12);
      kE[c][r] *= 0.97;
      const e = kE[c][r];
      const p = proj(rad * Math.cos(a), rad * Math.sin(a), 0);
      stroke(lerp(c0[0], 255, e), lerp(c0[1], 230, e), lerp(c0[2], 170, e), 30 + v * 120 + e * 150);
      strokeWeight(0.8 + v * 1.6 + e * 2 + jit[2] * 0.6);
      point(p[0], p[1]);
    }
  }
  blendMode(BLEND);
}

function drawOrbits() {
  noFill();
  for (let i = 0; i < WORLDS.length; i++) {
    const w = WORLDS[i];
    const on = (i === worldIdx);
    stroke(235, 225, 205, on ? 46 : 16);
    strokeWeight(on ? 0.9 : 0.6);
    ellipse(cx, cy, w.orbit * U * 2, w.orbit * U * 2 * PERSP);
  }
}

// ---------------------------------------------------------------- planets

function planetAngle(i) {
  const w = WORLDS[i];
  return i * 2.4 + T * 0.11 / Math.pow(w.orbit / 0.46, 1.5);
}

function drawPlanets(front) {
  for (let i = 0; i < WORLDS.length; i++) {
    const w = WORLDS[i];
    const a = planetAngle(i);
    if ((Math.sin(a) > 0) !== front) continue;
    const p = proj(w.orbit * Math.cos(a), w.orbit * Math.sin(a), 0);
    const depth = 0.8 + 0.2 * Math.sin(a);
    const on = (i === worldIdx);
    const R = U * (0.03 + i * 0.0025) * depth * (on ? 1.25 : 1);

    // trail along the orbit
    noFill();
    for (let k = 1; k < 26; k++) {
      const a0 = a - k * 0.03, a1 = a - (k - 1) * 0.03;
      const q0 = proj(w.orbit * Math.cos(a0), w.orbit * Math.sin(a0), 0);
      const q1 = proj(w.orbit * Math.cos(a1), w.orbit * Math.sin(a1), 0);
      stroke(w.cols[1][0], w.cols[1][1], w.cols[1][2], (1 - k / 26) * (on ? 130 : 60));
      strokeWeight((1 - k / 26) * R * 0.22 + 0.3);
      line(q0[0], q0[1], q1[0], q1[1]);
    }
    drawPlanetBody(i, p[0], p[1], R, on);

    if (on && showType) {
      const side = (p[0] > cx) ? 1 : -1;
      const lx = p[0] + side * R * 2.6, ly = p[1] - R * 2.2;
      stroke(235, 225, 205, 150); strokeWeight(0.7);
      line(p[0] + side * R * 1.1, p[1] - R * 0.9, lx, ly);
      line(lx, ly, lx + side * U * 0.09, ly);
      noStroke(); fill(240, 232, 215, 235);
      textFont(SANS); textSize(Math.max(9, U * 0.02));
      textAlign(side > 0 ? LEFT : RIGHT, BOTTOM);
      spaced(w.name, lx + side * 2, ly - 3, 0.22, side > 0 ? LEFT : RIGHT);
    }
  }
}

function drawPlanetBody(i, x, y, R, on) {
  const w = WORLDS[i];
  const ctx = drawingContext;
  const c = w.cols;
  // glow
  blendMode(ADD);
  const gl = ctx.createRadialGradient(x, y, R * 0.6, x, y, R * (on ? 3.4 : 2.2));
  gl.addColorStop(0, 'rgba(' + c[1][0] + ',' + c[1][1] + ',' + c[1][2] + ',' + (on ? 0.34 : 0.16) + ')');
  gl.addColorStop(1, 'rgba(' + c[1][0] + ',' + c[1][1] + ',' + c[1][2] + ',0)');
  ctx.fillStyle = gl;
  ctx.beginPath(); ctx.arc(x, y, R * 3.4, 0, TAU); ctx.fill();
  blendMode(BLEND);

  noStroke();
  if (i === 0) {
    // EPOCH: desert strata, wavy bands clipped to the sphere
    ctx.save();
    ctx.beginPath(); ctx.arc(x, y, R, 0, TAU); ctx.clip();
    const tones = [c[2], c[0], c[1], c[0], [150, 86, 50], c[1], c[2]];
    for (let b = 0; b < tones.length; b++) {
      fill(tones[b][0], tones[b][1], tones[b][2]);
      beginShape();
      const y0 = y - R + (b / tones.length) * R * 2;
      for (let k = 0; k <= 10; k++) {
        const xx = x - R + (k / 10) * R * 2;
        vertex(xx, y0 + Math.sin(k * 0.9 + b * 1.7 + T * 0.2) * R * 0.07);
      }
      vertex(x + R, y + R); vertex(x - R, y + R);
      endShape(CLOSE);
    }
    ctx.restore();
  } else if (i === 1) {
    // LIGAND: amber glass with a lab-clean highlight and a grid tick
    const g = ctx.createRadialGradient(x - R * 0.3, y - R * 0.35, R * 0.05, x, y, R);
    g.addColorStop(0, 'rgba(255,236,190,0.98)');
    g.addColorStop(0.35, 'rgba(240,160,44,0.92)');
    g.addColorStop(1, 'rgba(110,52,8,0.9)');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(x, y, R, 0, TAU); ctx.fill();
    stroke(238, 232, 220, 150); strokeWeight(0.6); noFill();
    const q = R * 1.5;
    line(x - q, y, x - q * 0.75, y); line(x + q * 0.75, y, x + q, y);
    line(x, y - q, x, y - q * 0.75); line(x, y + q * 0.75, x, y + q);
  } else if (i === 2) {
    // PELAGIC: a faceted crystal
    const n = 7, rot = T * 0.3;
    for (let k = 0; k < n; k++) {
      const a0 = rot + (k / n) * TAU, a1 = rot + ((k + 1) / n) * TAU;
      const sh = 0.45 + 0.55 * Math.abs(Math.sin(a0 * 1.5 + 0.6));
      fill(lerp(c[2][0], c[1][0], sh), lerp(c[2][1], c[1][1], sh), lerp(c[2][2], c[1][2], sh), 240);
      triangle(x, y - R * 0.15, x + Math.cos(a0) * R, y + Math.sin(a0) * R,
        x + Math.cos(a1) * R, y + Math.sin(a1) * R);
    }
    stroke(220, 255, 250, 160); strokeWeight(0.6); noFill();
    for (let k = 0; k < n; k++) {
      const a0 = rot + (k / n) * TAU;
      line(x, y - R * 0.15, x + Math.cos(a0) * R, y + Math.sin(a0) * R);
    }
  } else if (i === 3) {
    // SANTO BRUTO: raw stone, a gold foil edge, candlelight
    const g = ctx.createRadialGradient(x + R * 0.3, y + R * 0.3, R * 0.1, x, y, R);
    g.addColorStop(0, 'rgba(120,96,84,1)');
    g.addColorStop(1, 'rgba(34,27,26,1)');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(x, y, R, 0, TAU); ctx.fill();
    noFill(); stroke(GOLD[0], GOLD[1], GOLD[2], 235); strokeWeight(Math.max(1, R * 0.12));
    arc(x, y, R * 2, R * 2, -2.3, -0.5);
    noStroke(); fill(255, 190, 110, 170 + 60 * Math.sin(T * 7 + 1.3 * Math.sin(T * 3)));
    circle(x - R * 0.2, y + R * 0.15, R * 0.34);
  } else {
    // LEI WAI: black stone in water, a blush gloss highlight, a gold cap
    noFill();
    for (let k = 0; k < 3; k++) {
      const rr = R * (1.3 + ((T * 0.35 + k / 3) % 1) * 1.8);
      stroke(c[0][0], c[0][1], c[0][2], 110 * (1 - ((T * 0.35 + k / 3) % 1)));
      strokeWeight(0.8);
      ellipse(x, y + R * 0.2, rr * 2, rr * 2 * PERSP);
    }
    const g = ctx.createRadialGradient(x - R * 0.35, y - R * 0.4, R * 0.05, x, y, R);
    g.addColorStop(0, 'rgba(250,196,196,0.98)');
    g.addColorStop(0.3, 'rgba(60,62,70,1)');
    g.addColorStop(1, 'rgba(12,14,18,1)');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(x, y, R, 0, TAU); ctx.fill();
    noStroke(); fill(GOLD[0], GOLD[1], GOLD[2], 240);
    circle(x + R * 0.45, y - R * 0.5, R * 0.3);
  }
}

// ---------------------------------------------------------------- bursts

function updateBursts() {
  for (const b of bursts) {
    b.r += 0.0075;
    b.a = Math.max(0, 1 - (b.r - HEM_R) / 0.85);
    // the ring lights up belt and ring cells as it passes through them
    if (b.r > 0.31 && b.r < 0.43) {
      for (let c = 0; c < COLS; c++) for (let r = 0; r < ROWS; r++) {
        const rad = 0.335 + (r / (ROWS - 1)) * 0.065;
        if (Math.abs(rad - b.r) < 0.012) beltE[c][r] = 1;
      }
    }
    if (b.r > 0.9 && b.r < 1.03) {
      for (let c = 0; c < KCOLS; c++) for (let r = 0; r < KROWS; r++) {
        const rad = 0.93 + (r / (KROWS - 1)) * 0.07;
        if (Math.abs(rad - b.r) < 0.014) kE[c][r] = 1;
      }
    }
  }
  bursts = bursts.filter(b => b.a > 0);
}

function drawBursts() {
  blendMode(ADD);
  noFill();
  for (const b of bursts) {
    stroke(255, 228, 150, 190 * b.a);
    strokeWeight(1 + 3 * b.a);
    ellipse(cx, cy, b.r * U * 2, b.r * U * 2 * PERSP);
    stroke(255, 255, 255, 60 * b.a);
    strokeWeight(0.8);
    ellipse(cx, cy, (b.r - 0.02) * U * 2, (b.r - 0.02) * U * 2 * PERSP);
  }
  blendMode(BLEND);
}

function drawComets() {
  blendMode(ADD);
  for (const c of comets) {
    c.px += c.vx; c.pz += c.vz; c.h += c.vh; c.vh -= 0.00012; c.life -= 0.008;
    const p = proj(c.px, c.pz, Math.max(0, c.h));
    const q = proj(c.px - c.vx * 9, c.pz - c.vz * 9, Math.max(0, c.h - c.vh * 9));
    stroke(255, 226, 160, 230 * c.life); strokeWeight(1.6 * c.life + 0.4);
    line(p[0], p[1], q[0], q[1]);
    noStroke(); fill(255, 245, 220, 255 * c.life);
    circle(p[0], p[1], 2.4);
  }
  comets = comets.filter(c => c.life > 0);
  blendMode(BLEND);
}

function mousePressed() {
  bursts.push({ r: HEM_R, a: 1 });
  for (let k = 0; k < 16; k++) {
    const a = random(TAU), rad = random(0.335, 0.4), sp = random(0.003, 0.008);
    comets.push({
      px: rad * Math.cos(a), pz: rad * Math.sin(a), h: 0,
      vx: Math.cos(a) * sp, vz: Math.sin(a) * sp, vh: random(0.001, 0.004), life: 1
    });
  }
  return false;
}

// ---------------------------------------------------------------- stylus

function updateStylus() {
  // always down, always chasing. there is no pen-up.
  const tx = (mouseX === 0 && mouseY === 0 && !stylus.ready) ? stylus.x : mouseX;
  const ty = (mouseX === 0 && mouseY === 0 && !stylus.ready) ? stylus.y : mouseY;
  if (mouseX !== 0 || mouseY !== 0) stylus.ready = true;
  const ox = stylus.x, oy = stylus.y;
  stylus.x += (tx - stylus.x) * EASE;
  stylus.y += (ty - stylus.y) * EASE;
  if (Math.abs(stylus.x - ox) + Math.abs(stylus.y - oy) > 1.2) {
    // normalized plane coordinates so a resize never wipes the drawing
    segs.push({
      u1: (ox - cx) / U, v1: (oy - cy) / (U * PERSP),
      u2: (stylus.x - cx) / U, v2: (stylus.y - cy) / (U * PERSP),
      born: T
    });
    if (segs.length > 620) segs.shift();
  }
}

function drawEmbroidery() {
  const LIFE = 16;
  segs = segs.filter(s => T - s.born < LIFE);
  if (!segs.length) return;
  const ctx = drawingContext;
  blendMode(ADD);
  const BUCKETS = 6;
  for (let b = 0; b < BUCKETS; b++) {
    ctx.beginPath();
    let any = false;
    for (const s of segs) {
      const age = (T - s.born) / LIFE;
      if (Math.min(BUCKETS - 1, Math.floor(age * BUCKETS)) !== b) continue;
      any = true;
      for (let k = 0; k < mirrors; k++) {
        const rot = (k / mirrors) * TAU;
        const cs = Math.cos(rot), sn = Math.sin(rot);
        for (let m = 0; m < 2; m++) {
          const f = m ? -1 : 1;       // flip half of them for the mirror
          const x1 = s.u1 * cs - s.v1 * f * sn, z1 = s.u1 * sn + s.v1 * f * cs;
          const x2 = s.u2 * cs - s.v2 * f * sn, z2 = s.u2 * sn + s.v2 * f * cs;
          ctx.moveTo(cx + x1 * U, cy + z1 * U * PERSP);
          ctx.lineTo(cx + x2 * U, cy + z2 * U * PERSP);
        }
      }
    }
    if (!any) continue;
    const al = (1 - b / BUCKETS) * 0.4 + 0.02;
    ctx.strokeStyle = 'rgba(255,215,0,' + al.toFixed(3) + ')';
    ctx.lineWidth = 1.1;
    ctx.stroke();
  }
  blendMode(BLEND);
}

function drawStylusTip() {
  blendMode(ADD);
  noStroke();
  fill(255, 230, 150, 60); circle(stylus.x, stylus.y, 16);
  fill(255, 245, 210, 230); circle(stylus.x, stylus.y, 3.5);
  blendMode(BLEND);
}

// ---------------------------------------------------------------- flock

function updateFlock(phase) {
  const mid = rings[6];
  const gx = cx + mid.ox * U, gy = cy - mid.h * U;
  const maxS = 3.4;
  for (let i = 0; i < boids.length; i++) {
    const b = boids[i];
    let sx = 0, sy = 0, ax = 0, ay = 0, mx = 0, my = 0, n = 0;
    for (let j = 0; j < boids.length; j++) {
      if (j === i) continue;
      const o = boids[j];
      const dx = o.x - b.x, dy = o.y - b.y;
      const d2 = dx * dx + dy * dy;
      if (d2 < 2600) {
        n++;
        ax += o.vx; ay += o.vy; mx += o.x; my += o.y;
        if (d2 < 260 && d2 > 0.01) { sx -= dx / d2; sy -= dy / d2; }
      }
    }
    if (n) {
      b.vx += (ax / n - b.vx) * 0.045 + (mx / n - b.x) * 0.0012 + sx * 1.3;
      b.vy += (ay / n - b.vy) * 0.045 + (my / n - b.y) * 0.0012 + sy * 1.3;
    }
    if (phase === 'right' || phase === 'left') {
      // crescent on the trailing edge of the sweep
      const base = (phase === 'right') ? 0 : PI;
      const ph = base + b.k * 1.25;
      const R = U * (0.5 + b.rr * 0.07);
      const tx = gx + Math.cos(ph) * R * 0.78, ty = gy + Math.sin(ph) * R * 0.62;
      b.vx += (tx - b.x) * 0.0016; b.vy += (ty - b.y) * 0.0016;
    } else if (phase === 'up') {
      const dx = b.x - gx, dy = b.y - gy, d = Math.sqrt(dx * dx + dy * dy) + 1;
      b.vx += (dx / d) * 0.2; b.vy += (dy / d) * 0.2 - 0.05;
    } else {
      b.vx += (gx - b.x) * 0.0006; b.vy += (gy - b.y) * 0.0006;
    }
    const sp = Math.sqrt(b.vx * b.vx + b.vy * b.vy);
    if (sp > maxS) { b.vx = b.vx / sp * maxS; b.vy = b.vy / sp * maxS; }
    if (sp < 0.8) { b.vx *= 1.1; b.vy *= 1.1; }
    b.x += b.vx; b.y += b.vy;
    if (b.x < -20) b.x = W + 20; if (b.x > W + 20) b.x = -20;
    if (b.y < -20) b.y = H + 20; if (b.y > H + 20) b.y = -20;
  }
}

function drawFlock() {
  blendMode(ADD);
  strokeWeight(1.3);
  for (const b of boids) {
    const sp = Math.sqrt(b.vx * b.vx + b.vy * b.vy) + 0.001;
    stroke(245, 232, 205, 150);
    line(b.x, b.y, b.x - (b.vx / sp) * 6, b.y - (b.vy / sp) * 6);
  }
  blendMode(BLEND);
}

// ---------------------------------------------------------------- type

function spaced(str, x, y, tracking, align) {
  const sz = textSize();
  let total = 0;
  for (const ch of str) total += textWidth(ch) + sz * tracking;
  total -= sz * tracking;
  let px = x;
  if (align === CENTER) px = x - total / 2;
  else if (align === RIGHT) px = x - total;
  const keepAlign = textAlign();
  textAlign(LEFT, keepAlign.vertical);
  for (const ch of str) {
    text(ch, px, y);
    px += textWidth(ch) + sz * tracking;
  }
  textAlign(keepAlign.horizontal, keepAlign.vertical);
  return total;
}

function drawCoverType(phase) {
  const m = Math.max(18, Math.min(W, H) * 0.035);
  const small = Math.max(9, Math.min(W, H) * 0.0135);
  const w = WORLDS[worldIdx];

  // hairline frame
  noFill(); stroke(240, 232, 216, 60); strokeWeight(0.7);
  rect(m, m, W - m * 2, H - m * 2);

  noStroke();
  // cover line
  textFont(SERIF); textStyle(ITALIC);
  textSize(Math.max(16, Math.min(W, H) * 0.04));
  textAlign(LEFT, BASELINE);
  fill(240, 232, 216, 235);
  text('The Bold', m * 1.8, H - m * 1.8 - small * 4.2 - Math.min(W, H) * 0.044);
  text('Fantastic', m * 1.8, H - m * 1.8 - small * 4.2);
  textStyle(NORMAL);

  textFont(SANS); textSize(small);
  fill(240, 232, 216, 170);
  spaced('NO. ' + (worldIdx + 1) + ' OF 5   ' + w.name, m * 1.8, H - m * 1.8 - small * 1.6, 0.2, LEFT);
  fill(240, 232, 216, 110);
  spaced(w.line.toUpperCase(), m * 1.8, H - m * 1.8, 0.2, LEFT);

  // vertical issue line
  push();
  translate(m * 1.75, H * 0.42);
  rotate(-HALF_PI);
  fill(240, 232, 216, 120);
  textAlign(LEFT, BASELINE);
  spaced('ISSUE 09   CONTEXT STUFFED   148,864 CHARACTERS IN ONE PROMPT', 0, 0, 0.26, CENTER);
  pop();

  // compass, needle at 30 degrees
  const kx = W - m * 3.1, ky = m * 3.1, kr = m * 1.05;
  noFill(); stroke(240, 232, 216, 90); strokeWeight(0.7);
  circle(kx, ky, kr * 2);
  for (let k = 0; k < 16; k++) {
    const a = (k / 16) * TAU, r0 = kr * ((k % 4 === 0) ? 0.78 : 0.9);
    line(kx + Math.cos(a) * r0, ky + Math.sin(a) * r0, kx + Math.cos(a) * kr, ky + Math.sin(a) * kr);
  }
  const na = radians(30) - HALF_PI + 0.04 * Math.sin(T * 1.3);
  stroke(GOLD[0], GOLD[1], GOLD[2], 220); strokeWeight(1.1);
  line(kx - Math.cos(na) * kr * 0.4, ky - Math.sin(na) * kr * 0.4,
    kx + Math.cos(na) * kr * 0.72, ky + Math.sin(na) * kr * 0.72);
  noStroke(); fill(240, 232, 216, 150); textSize(small * 0.9);
  textAlign(CENTER, BASELINE);
  text('N', kx, ky - kr - small * 0.5);

  // the 55-frame timeline, drawn from the real delays
  const tw = Math.min(W * 0.34, 420), tx0 = W - m * 1.8 - tw, ty0 = H - m * 1.8;
  let acc = 0;
  for (let i = 0; i < GIF_FRAMES; i++) {
    const x0 = tx0 + (acc / 2290) * tw, ww = (delays[i] / 2290) * tw;
    const isNow = (i === gifFrame);
    let c;
    if (i <= 23) c = [240, 232, 216];
    else if (i <= 39) c = [170, 164, 154];
    else if (i <= 48) c = GOLD;
    else c = [110, 106, 100];
    fill(c[0], c[1], c[2], isNow ? 255 : (i < gifFrame ? 150 : 60));
    rect(x0, ty0 - (isNow ? small * 1.5 : small * 0.6), Math.max(1, ww - 1.2), isNow ? small * 1.5 : small * 0.6);
    acc += delays[i];
  }
  fill(240, 232, 216, 130); textSize(small * 0.9); textAlign(RIGHT, BASELINE);
  spaced('FRAME ' + nf(gifFrame, 2) + ' OF 55   ' + phase.toUpperCase() + '   2290 MS   SLOWED 4X',
    W - m * 1.8, ty0 - small * 2.4, 0.18, RIGHT);
  fill(240, 232, 216, 80);
  spaced('MOVE  CLICK  1-5  UP/DOWN ' + mirrors + '  SPACE  H  S', W - m * 1.8, ty0 - small * 4.2, 0.18, RIGHT);
}

// ---------------------------------------------------------------- keys

function keyPressed() {
  if (key >= '1' && key <= '5') { setWorld(int(key) - 1, true); return false; }
  if (keyCode === UP_ARROW) { mirrors = Math.min(12, mirrors + 1); return false; }
  if (keyCode === DOWN_ARROW) { mirrors = Math.max(3, mirrors - 1); return false; }
  if (key === ' ') { segs = []; return false; }
  if (key === 'h' || key === 'H') { showType = !showType; return false; }
  if (key === 's' || key === 'S') { saveCanvas('the-bold-fantastic', 'png'); return false; }
}
