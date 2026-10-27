/*
  CONTEXT PORTRAIT
  A portrait of Steve Elias Oregel's creative practice, built from evidence
  retrieved with the context-curation MCP server on 2026-10-26.

  Corpus status at retrieval: ready, 70 sources, 731 chunks, embedding model
  all-minilm. Index freshness was not checked. The relationship graph was not
  built ("Graph not found"), so get_relationships was not available and every
  decision below rests on search_context and fetch_source_excerpt results.
  All paths are relative to the indexed corpus (course.txt::<path>).

  p5.js only. No images, fonts or network requests. Canvas 1080 x 1080.

  INTERACTION
    move   a braided ribbon of light chases the pointer and fades behind it
    hover  background tiles under the pointer lift, expand and rotate
    sweep  a fast sweep throws a crescent wave
    flick  a fast upward flick sets off a sonic burst at its apex
    drag   lead the red gown; the murmuration follows it
    click  next brand world (one product, many worlds)
    shake  move back and forth quickly to scatter the ribbon into silver dust

  WHAT DROVE EACH VISUAL DECISION

  1. Overall concept: luxury fashion aesthetics merged with geometric code,
     aiming for "gallery installation" rather than student exercise.
     - 00_About/about-steve.md ("merging luxury fashion aesthetics with
       geometric code ... something that feels more gallery installation
       than typical student project")
     - README.md ("luxury fashion editorial sensibility applied to code,
       brands and AI imagery")

  2. Restraint plus one bold move: the red gown is the only saturated red,
     gold is the one constant metal, and the icosahedron stays still.
     - 00_About/about-steve.md ("Restraint plus one bold move (a single red
       gown, a single gold accent)")
     - 00_About/code-digest.md, notes for
       01_Creative-Coding/2026-02_processing_crystalline-prism.pde
       (icosahedron kept static because "rotation on rotation felt too busy";
       "sometimes restraint is the luxury move")

  3. Background: a soft-edged, three-block color field built from many thin
     translucent washes instead of a blur filter.
     - 00_About/code-digest.md, Rothko recreation notes ("rothko layered thin
       washes of paint with no hard edges"; "darkest rectangle grounds the
       composition"; "blur mimics how his paint edges blur into each other")
     - INDEX.md entry for 01_Creative-Coding/2026-01_processing_rothko-orange-
       and-yellow/ ("studying soft-edged color fields")

  4. Center: a 13-layer mandala read as a well, deep purple at the bottom
     rising to gold at the rim, golden-ratio rotation speeds, alternating
     directions, and pointer parallax that shifts the deeper layers more.
     - 00_About/code-digest.md, notes for
       01_Creative-Coding/2026-02_p5js_sacred-geometry-mandala-vortex.js
       ("13-layer mandala"; "golden ratio (1.618...) for rotation speeds";
       "colors go from dark/deep (purple) at the bottom to bright (gold) at
       the top"; "each layer gets 4 colors: main fill, secondary fill,
       accent, and highlight"; "keeping gold for visual consistency")
     - INDEX.md, mandala layers entry ("gold on every layer")
     - 00_About/about-steve.md ("Sacred geometry, golden ratio motion,
       mandalas, prisms and murmurations in code")
     Petal counts follow the Fibonacci sequence; that is my choice, not a
     documented detail.

  5. Petals drawn as smooth point-built curves that breathe, each layer on
     its own phase so nothing moves in lockstep.
     - 00_About/code-digest.md, mandala petal functions ("draws a single
       petal using a smooth curve made up of lots of little points")
     - 00_About/code-digest.md, notes for
       01_Creative-Coding/2026-03_processing_living-vase-particle-system.pde
       ("independent phase offset ... what makes it feel organic rather than
       mechanical")

  6. Orbiting crystalline prisms over a faint static icosahedron, with the
     prism palette changing on click. The four documented palettes are used:
     magenta + gold, holographic pastels, silver / rose gold, jewel tones.
     - 00_About/code-digest.md, notes for
       01_Creative-Coding/2026-02_processing_crystalline-prism.pde
       ("switching between these with mouse clicks"; "drawing multiple
       prisms at different speeds and sizes"; icosahedron "tinted slightly
       transparent so the prisms pop in front")
     - Prism spacing uses the golden angle; that is my choice.

  7. The gown: a ribbon that flares toward the hem, pleats, and billows in
     wind and in gusts from fast pointer motion. In SIGNATURE it is red silk;
     in each brand world it keeps the same fabric physics but changes
     material: EPOCH desert sand, LIGAND liquid amber glass, PELAGIC crystal,
     SANTO BRUTO fire, LEI WAI water. The per-world materials are Steve's art
     direction, mapped to each world's evidence listed under decision 13.
     - 03_AI-Image-Direction/fashion-editorial/2026-01_red-gown-in-motion_
       studio.png (INDEX.md: "Editorial motion and one bold color; seed for
       the Red Dress code"; machine caption: red dress "flowing in the air")
     - 00_About/about-steve.md ("Editorial fashion photography as the north
       star (Vogue Japan, studio light, motion in fabric)")
     - 00_About/code-digest.md, ComfyUI prompt ("Vogue Japan aesthetic ...
       wind blowing")

  8. Murmuration flock in crescent formation driven by the gown, crescent
     waves on strong sweeps, sonic bursts at upward apexes. In the source the
     model's motion drives these layers; here the viewer's motion does.
     - 00_About/code-digest.md, notes for
       01_Creative-Coding/2026-04_processing_red-dress-generative-overlay/
       ("TRIGGER: crescent wave on strong sweep"; "TRIGGER: sonic burst on
       upward apex"; "LAYER 4: murmuration boids"; "crescent formations")
     - INDEX.md (murmuration_v3.mp4 "Flocking render from the Red Dress
       work"; overlay "driven frame by frame by a model's motion")
     - 00_About/about-steve.md ("Code layered on photography: generative
       effects driven by a model's motion")

  9. Gold sparks shed from the stylus with gravity, damping, friction and
     wall / floor bounces.
     - 00_About/code-digest.md, Living Vase notes ("physics particles
       cascade down ... like sparks off a sparkler. They have gravity,
       damping, friction, and they bounce off the walls")
     - INDEX.md, Red Dress entry ("Murmuration flock and sparklers")

  10. The light ribbon: the stylus still chases the pointer with ~0.15
      easing so it swoops and overshoots (Silvertrace), but the permanent
      line was replaced, at Steve's direction, with a short-lived braided
      ribbon of light: three strands that twist around the path, taper from
      tail to tip and fade within a second, so motion reads as fabric
      rather than pencil.
      - 01_Creative-Coding/2026-09_silvertrace-web-drawing-toy/PRODUCT.md
        ("one continuous line that you steer instead of draw"; "~0.15
        lerp/frame")
      - 00_About/about-steve.md ("motion in fabric")
      - 00_About/code-digest.md, Living Vase notes (spiral halos "radiating
        energy outward")
      - The braid, taper and fade are Steve's art direction plus my
        implementation, not corpus evidence.

  11. Hover tiles: the background is quantized into a tile field that
      expands and rotates under the pointer.
      - 00_About/code-digest.md, notes for
        01_Creative-Coding/2026-01_processing_self-portrait/Self_Portrait.pde
        ("rebuilding it pixel-by-pixel using thousands of interactive
        geometric tiles"; "As the viewer moves their mouse, they disrupt the
        data field, causing the tiles to expand and rotate")

  12. Hawaiian island chain as small rocky gold-outlined forms over a data
      wave that swells near the pointer.
      - 00_About/about-steve.md ("Hawai'i as a recurring place: vintage
        postcards, botanicals, the island chain")
      - 03_AI-Image-Direction/illustration-and-environments/2026-02_hawaiian-
        islands_neon-data-wave.png (filename only; I did not inspect pixels)
      - 00_About/code-digest.md, Heavenly Bodies notes (every other vertex
        "pulls inward"; low inner ratio "so they look jagged and rocky")
      Island positions are approximate geography I supplied; they are not
      from the corpus.

  13. Click cycles six worlds, each with its own field, motif and palette.
      - 00_About/about-steve.md ("One product, many worlds ... desert strata,
        Swiss lab grid, nautical chart, candlelit stone, island beauty")
      - README.md ("02_Brand-Campaigns/ shows the full art direction range:
        one product, many worlds")
      - EPOCH, desert strata: 02_Brand-Campaigns/EPOCH/2026-07_epoch_strata-
        texture.png and 2026-07_epoch_desert-still-life.png (caption: desert
        landscape with rock formations)
      - LIGAND, amber glass and Swiss grid: INDEX.md ("Amber-glass lab
        aesthetic; Swiss grid print ad"); 02_Brand-Campaigns/LIGAND/
      - PELAGIC, nautical chart and crystal: INDEX.md ("crystal label;
        freediver mood; nautical chart flatlay"); caption for
        02_Brand-Campaigns/PELAGIC/2026-07_pelagic_crystal-label.png
        (crystals "from blues to greens", teal label)
      - SANTO BRUTO, candlelit stone and gold foil: INDEX.md ("Raw stone;
        gold foil; candlelit gym light"); 02_Brand-Campaigns/SANTO-BRUTO/
      - LEI WAI, island beauty: 02_Brand-Campaigns/LEI-WAI/2026-02_lei-wai_
        lip-gloss_black-stone-water.png and 03_AI-Image-Direction/beauty-
        product/2026-02_premium-blush-silk-texture.png (filenames only)
      - SIGNATURE: the Rothko warmth plus the mandala's purple and gold.

  14. Small letterspaced serif masthead in a system font, like an editorial
      cover line. My interpretation of the editorial north star in
      00_About/about-steve.md and 07_Editorial-Career/.

  EVIDENCE GAPS
  - The corpus has no hex or RGB values for the brand worlds. Every RGB
    value here is my reading of names, filenames and machine captions.
  - Image evidence comes from machine-written captions and filenames, not
    from looking at the images. Captions can be wrong.
  - 05_Style-References/vogue-japan-2017/ is listed in INDEX.md but is not
    indexed, so it informed nothing here.
  - No relationship graph, so no cross-source claims were checked.
*/

const W = 1080;
const H = 1080;
const PHI = (1 + Math.sqrt(5)) / 2;
const CX = 540;
const CY = 500;

const GOLD = [212, 175, 92];
const SILVER = [208, 212, 220];
const IVORY = [238, 228, 208];
const GOWN = [176, 18, 34];

// one product, many worlds; RGB values are interpretation, see block above
const WORLDS = [
  {
    name: 'SIGNATURE', note: 'soft color field, purple well, gold rim',
    ground: [40, 12, 18], bands: [[112, 60, 30], [92, 34, 26], [30, 12, 26]],
    deep: [60, 26, 96], accent: [212, 175, 92],
    prism: [[204, 44, 132], [212, 175, 92], [126, 30, 92], [236, 206, 150]],
    motif: 'none', gown: { style: 'silk', c: [176, 18, 34], c2: [240, 110, 110] }
  },
  {
    name: 'EPOCH', note: 'desert strata',
    ground: [38, 25, 18], bands: [[118, 84, 56], [94, 60, 38], [50, 33, 24]],
    deep: [72, 44, 30], accent: [222, 190, 140],
    prism: [[208, 212, 220], [214, 150, 140], [178, 182, 194], [236, 192, 172]],
    motif: 'strata', gown: { style: 'sand', c: [196, 140, 84], c2: [236, 206, 160] }
  },
  {
    name: 'LIGAND', note: 'amber glass, Swiss lab grid',
    ground: [20, 14, 8], bands: [[108, 60, 14], [82, 42, 10], [26, 18, 10]],
    deep: [62, 32, 8], accent: [236, 170, 70],
    prism: [[200, 120, 30], [236, 170, 70], [120, 64, 16], [250, 214, 150]],
    motif: 'grid', gown: { style: 'amber', c: [214, 128, 30], c2: [252, 214, 140] }
  },
  {
    name: 'PELAGIC', note: 'nautical chart, crystal',
    ground: [6, 18, 28], bands: [[24, 70, 84], [14, 48, 66], [6, 22, 36]],
    deep: [12, 40, 72], accent: [120, 200, 196],
    prism: [[170, 220, 230], [200, 182, 240], [170, 236, 202], [240, 212, 230]],
    motif: 'chart', gown: { style: 'crystal', c: [90, 200, 210], c2: [190, 170, 240] }
  },
  {
    name: 'SANTO BRUTO', note: 'candlelit stone, gold foil',
    ground: [18, 16, 15], bands: [[70, 62, 54], [50, 44, 40], [22, 20, 19]],
    deep: [42, 34, 30], accent: [222, 182, 96],
    prism: [[20, 92, 72], [112, 20, 52], [30, 52, 122], [212, 175, 92]],
    motif: 'stone', gown: { style: 'fire', c: [255, 120, 30], c2: [255, 236, 170] }
  },
  {
    name: 'LEI WAI', note: 'black stone, water, blush',
    ground: [10, 10, 12], bands: [[44, 40, 46], [28, 28, 34], [12, 12, 16]],
    deep: [38, 30, 46], accent: [232, 168, 170],
    prism: [[232, 168, 170], [208, 212, 220], [246, 214, 206], [180, 120, 130]],
    motif: 'water', gown: { style: 'water', c: [120, 200, 220], c2: [232, 168, 170] }
  }
];

const TILE = 24;
const TILE_N = W / TILE;
const LAYERS = 13;
const PETALS = [5, 8, 8, 13, 13, 13, 21, 21, 21, 34, 34, 34, 34];
const PRISMS = 5;
const GN = 64;     // gown spine points
const GSEG = 9;    // gown segment length
const NB = 120;    // murmuration size
const TRACE_MAX = 140;
const TRACE_LIFE = 900; // ms a ribbon point lives before it fades out
const SPARK_MAX = 480;

let field;
let tileColors = [];
let worldIndex = 0;

let hasPointer = false;
let sx = CX, sy = CY;
let trace = [];
let sparks = [];
let waves = [];
let bursts = [];
let gust = 0;

let gown = [];
let elems = []; // element particles shed by the gown: sand, embers, droplets
const ELEM_MAX = 260;
let headX = CX, headY = CY;

let bx = [], by = [], bvx = [], bvy = [];
const sepX = new Float32Array(NB), sepY = new Float32Array(NB);
const aliX = new Float32Array(NB), aliY = new Float32Array(NB);
const cohX = new Float32Array(NB), cohY = new Float32Array(NB);
const cnt = new Uint16Array(NB);

let prismSpin = [];
let islandShapes = [];

let pressX = 0, pressY = 0, pressT = 0;
let dragging = false, dragMoved = false;
let rising = false, waveCooldown = 0, burstCooldown = 0;
let lastVxSign = 0, reversals = [];

function setup() {
  pixelDensity(1);
  createCanvas(W, H);
  frameRate(60);
  field = createGraphics(W, H);
  field.pixelDensity(1);
  buildIslands();
  buildField();

  for (let i = 0; i < GN; i++) gown.push({ x: CX - i * GSEG, y: CY });
  for (let i = 0; i < NB; i++) {
    const a = random(TWO_PI);
    bx.push(random(W));
    by.push(random(H));
    bvx.push(cos(a) * 2);
    bvy.push(sin(a) * 2);
  }
  for (let k = 0; k < PRISMS; k++) prismSpin.push(random(TWO_PI));
}

function draw() {
  const t = millis() / 1000;
  const w = WORLDS[worldIndex];

  image(field, 0, 0);
  drawTiles(t, w);
  updateInput(t);
  drawMandala(t, w);
  drawPrisms(t, w);
  drawIslands(t, w);
  updateGown(t);
  drawGown(t);
  updateBoids(t);
  drawBoids();
  drawWaves(w);
  drawBursts();
  drawTrace();
  updateSparks();
  drawSparks();
  drawMasthead(t, w);
}

// ---------------------------------------------------------------------------
// Color field (Rothko washes + world motif + static icosahedron + vignette)
// ---------------------------------------------------------------------------

function buildField() {
  const w = WORLDS[worldIndex];
  const g = field;
  randomSeed(97 * worldIndex + 7);
  noiseSeed(31 * worldIndex + 5);

  g.push();
  g.background(w.ground[0], w.ground[1], w.ground[2]);
  g.noStroke();

  // three stacked blocks, each built from many thin washes so edges stay soft
  const blocks = [
    { y: 70, h: 330, c: w.bands[0] },
    { y: 420, h: 300, c: w.bands[1] },
    { y: 740, h: 270, c: w.bands[2] }
  ];
  for (const b of blocks) {
    for (let k = 0; k < 36; k++) {
      const inset = k * 2.2;
      g.fill(b.c[0], b.c[1], b.c[2], 14);
      g.rect(70 + inset + random(-2, 2), b.y + inset * 0.7,
        W - 140 - inset * 2, b.h - inset * 1.4, 18);
    }
  }

  // paper grain
  for (let i = 0; i < 6000; i++) {
    const v = random() < 0.5 ? 0 : 255;
    g.fill(v, v, v, 8);
    g.rect(random(W), random(H), 1.5, 1.5);
  }

  drawMotif(g, w);
  drawIcosahedron(g, w.accent);

  // vignette
  const ctx = g.drawingContext;
  const grad = ctx.createRadialGradient(CX, CY, 260, CX, CY, 800);
  grad.addColorStop(0, 'rgba(0,0,0,0)');
  grad.addColorStop(1, 'rgba(0,0,0,0.78)');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, W, H);
  g.pop();

  // quantize the field for the self-portrait tiles
  g.loadPixels();
  tileColors = [];
  for (let j = 0; j < TILE_N; j++) {
    for (let i = 0; i < TILE_N; i++) {
      const x = i * TILE + TILE / 2;
      const y = j * TILE + TILE / 2;
      const idx = 4 * (y * W + x);
      tileColors.push([g.pixels[idx], g.pixels[idx + 1], g.pixels[idx + 2]]);
    }
  }
}

function drawMotif(g, w) {
  const a = w.accent;
  g.noFill();

  if (w.motif === 'strata') {
    for (let i = 0; i < 46; i++) {
      const y0 = 40 + i * 22;
      g.stroke(a[0], a[1], a[2], i % 3 === 0 ? 34 : 16);
      g.strokeWeight(i % 5 === 0 ? 2 : 1);
      g.beginShape();
      for (let x = 0; x <= W; x += 12) {
        g.vertex(x, y0 + (noise(x * 0.004, i * 0.15) - 0.5) * 60);
      }
      g.endShape();
    }
  } else if (w.motif === 'grid') {
    const margin = 60, cols = 12, gut = 16;
    const colW = (W - margin * 2 - gut * (cols - 1)) / cols;
    g.strokeWeight(1);
    g.stroke(a[0], a[1], a[2], 24);
    for (let c = 0; c < cols; c++) {
      const x = margin + c * (colW + gut);
      g.line(x, margin, x, H - margin);
      g.line(x + colW, margin, x + colW, H - margin);
    }
    g.stroke(a[0], a[1], a[2], 10);
    for (let y = margin; y <= H - margin; y += 27) g.line(margin, y, W - margin, y);
    g.stroke(a[0], a[1], a[2], 80);
    g.strokeWeight(6);
    g.line(margin, margin, margin + colW * 3 + gut * 2, margin);
  } else if (w.motif === 'chart') {
    g.strokeWeight(1);
    g.stroke(a[0], a[1], a[2], 18);
    for (let x = 0; x <= W; x += 90) g.line(x, 0, x, H);
    for (let y = 0; y <= H; y += 90) g.line(0, y, W, y);
    // rhumb lines from a compass rose
    g.stroke(a[0], a[1], a[2], 14);
    for (let k = 0; k < 32; k++) {
      const ang = k * TWO_PI / 32;
      g.line(880, 200, 880 + cos(ang) * 1600, 200 + sin(ang) * 1600);
    }
    // depth contours
    for (let c = 0; c < 3; c++) {
      const ox = random(150, 930), oy = random(150, 930);
      for (let r = 1; r <= 8; r++) {
        g.stroke(a[0], a[1], a[2], 22 - r * 2);
        g.beginShape();
        for (let k = 0; k <= 48; k++) {
          const ang = k * TWO_PI / 48;
          const rr = r * 26 * (0.8 + 0.4 * noise(c * 10 + cos(ang), sin(ang), r * 0.2));
          g.vertex(ox + cos(ang) * rr, oy + sin(ang) * rr);
        }
        g.endShape();
      }
    }
  } else if (w.motif === 'stone') {
    g.noStroke();
    for (let i = 0; i < 9000; i++) {
      const v = random(40, 140);
      g.fill(v, v * 0.95, v * 0.9, 18);
      g.rect(random(W), random(H), random(1, 3), random(1, 3));
    }
    const ctx = g.drawingContext;
    const glow = ctx.createRadialGradient(CX, 1000, 0, CX, 1000, 700);
    glow.addColorStop(0, 'rgba(255,170,80,0.20)');
    glow.addColorStop(1, 'rgba(255,170,80,0)');
    ctx.fillStyle = glow;
    ctx.fillRect(0, 0, W, H);
    g.noFill();
    g.stroke(0, 0, 0, 40);
    for (let c = 0; c < 7; c++) {
      let x = random(W), y = random(H);
      g.beginShape();
      for (let k = 0; k < 30; k++) {
        g.vertex(x, y);
        x += random(-14, 14);
        y += random(4, 16);
      }
      g.endShape();
    }
  } else if (w.motif === 'water') {
    g.noStroke();
    for (let i = 0; i < 5000; i++) {
      const v = random(20, 90);
      g.fill(v, v, v + 6, 16);
      g.rect(random(W), random(H), 2, 2);
    }
    g.noFill();
    g.strokeWeight(1);
    for (let i = 0; i < 46; i++) {
      const x = random(W), y = random(560, H), ew = random(80, 320);
      g.stroke(a[0], a[1], a[2], random(8, 20));
      g.ellipse(x, y, ew, ew * 0.16);
    }
  }
}

function drawIcosahedron(g, col) {
  const v = [
    [-1, PHI, 0], [1, PHI, 0], [-1, -PHI, 0], [1, -PHI, 0],
    [0, -1, PHI], [0, 1, PHI], [0, -1, -PHI], [0, 1, -PHI],
    [PHI, 0, -1], [PHI, 0, 1], [-PHI, 0, -1], [-PHI, 0, 1]
  ];
  const ax = 0.42, ay = 0.31; // fixed angles: kept static on purpose
  const p = v.map(([x, y, z]) => {
    const y1 = y * cos(ax) - z * sin(ax);
    const z1 = y * sin(ax) + z * cos(ax);
    const x2 = x * cos(ay) + z1 * sin(ay);
    return [CX + x2 * 190, CY + y1 * 190];
  });
  g.stroke(col[0], col[1], col[2], 34);
  g.strokeWeight(1);
  for (let i = 0; i < 12; i++) {
    for (let j = i + 1; j < 12; j++) {
      const d2 = (v[i][0] - v[j][0]) ** 2 + (v[i][1] - v[j][1]) ** 2 + (v[i][2] - v[j][2]) ** 2;
      if (abs(d2 - 4) < 0.01) g.line(p[i][0], p[i][1], p[j][0], p[j][1]);
    }
  }
}

// ---------------------------------------------------------------------------
// Self-portrait tiles: the quantized field lifts under the pointer
// ---------------------------------------------------------------------------

function drawTiles(t, w) {
  if (!hasPointer || mouseX < 0 || mouseX > W || mouseY < 0 || mouseY > H) return;
  const R = 170;
  const i0 = max(0, floor((mouseX - R) / TILE)), i1 = min(TILE_N - 1, floor((mouseX + R) / TILE));
  const j0 = max(0, floor((mouseY - R) / TILE)), j1 = min(TILE_N - 1, floor((mouseY + R) / TILE));
  noStroke();
  rectMode(CENTER);
  for (let j = j0; j <= j1; j++) {
    for (let i = i0; i <= i1; i++) {
      const cx = i * TILE + TILE / 2, cy = j * TILE + TILE / 2;
      const d = dist(cx, cy, mouseX, mouseY);
      if (d > R) continue;
      let f = 1 - d / R;
      f = f * f * (3 - 2 * f);
      const c = tileColors[j * TILE_N + i];
      const m = f * 0.35;
      fill(lerp(c[0], w.accent[0], m), lerp(c[1], w.accent[1], m), lerp(c[2], w.accent[2], m), 235);
      push();
      translate(cx, cy);
      rotate(f * HALF_PI + f * sin(t * 1.4 + i * 0.3 + j * 0.2) * 0.3);
      const s = TILE * (1 + f * 0.85);
      rect(0, 0, s, s, 2);
      pop();
    }
  }
  rectMode(CORNER);
}

// ---------------------------------------------------------------------------
// Mandala well
// ---------------------------------------------------------------------------

function drawMandala(t, w) {
  const offX = hasPointer ? mouseX - CX : 0;
  const offY = hasPointer ? mouseY - CY : 0;

  for (let i = 0; i < LAYERS; i++) {
    const u = i / (LAYERS - 1);
    const depth = 1 - u; // 1 = bottom of the well
    const cx = CX + offX * depth * 0.07;
    const cy = CY + offY * depth * 0.07;
    const breath = 1 + 0.06 * sin(t * 1.3 + i * PHI);
    // long, narrow petals that overlap the layer below like scales
    const r1 = (30 + i * 22.5) * breath;
    const r0 = max(4, r1 - 46 - 10 * depth);
    const n = PETALS[i];
    const dir = i % 2 === 0 ? 1 : -1;
    const rot = dir * t * 0.6 * pow(PHI, -i * 0.4);
    const halfW = (TWO_PI / n) * 0.26;

    // four colors per layer: main, secondary, accent (gold), highlight
    const main = lerpRGB(w.deep, GOLD, u);
    const secondTone = lerpRGB(w.deep, w.ground, 0.4 + 0.3 * depth);

    push();
    translate(cx, cy);
    rotate(rot);

    noFill();
    stroke(GOLD[0], GOLD[1], GOLD[2], 40);
    strokeWeight(0.8);
    ellipse(0, 0, r1 * 2, r1 * 2);

    for (let p = 0; p < n; p++) {
      const a = p * TWO_PI / n;
      fill(main[0], main[1], main[2], 46 + 60 * u);
      stroke(GOLD[0], GOLD[1], GOLD[2], 70 + 100 * u);
      strokeWeight(0.8);
      petal(a, r0, r1, halfW);

      noStroke();
      fill(secondTone[0], secondTone[1], secondTone[2], 120);
      petal(a, r0 + (r1 - r0) * 0.3, r1 - (r1 - r0) * 0.12, halfW * 0.35);

      fill(IVORY[0], IVORY[1], IVORY[2], 60 + 120 * u);
      circle(cos(a) * r1, sin(a) * r1, 1.5 + u * 1.5);
    }
    pop();
  }

  // the bottom of the well and its single gold point
  const dx = CX + offX * 0.07, dy = CY + offY * 0.07;
  noStroke();
  fill(w.ground[0] * 0.5, w.ground[1] * 0.5, w.ground[2] * 0.5);
  circle(dx, dy, 16);
  fill(GOLD[0], GOLD[1], GOLD[2]);
  circle(dx, dy, 4);
}

function petal(a, r0, r1, halfW) {
  const steps = 7;
  beginShape();
  for (let k = 0; k <= steps; k++) {
    const u = k / steps;
    const rr = lerp(r0, r1, u);
    const hw = halfW * pow(sin(PI * u), 0.8) * (1.15 - 0.3 * u);
    vertex(cos(a - hw) * rr, sin(a - hw) * rr);
  }
  for (let k = steps; k >= 0; k--) {
    const u = k / steps;
    const rr = lerp(r0, r1, u);
    const hw = halfW * pow(sin(PI * u), 0.8) * (1.15 - 0.3 * u);
    vertex(cos(a + hw) * rr, sin(a + hw) * rr);
  }
  endShape(CLOSE);
}

// ---------------------------------------------------------------------------
// Crystalline prisms
// ---------------------------------------------------------------------------

function drawPrisms(t, w) {
  const golden = radians(137.507764);
  for (let k = 0; k < PRISMS; k++) {
    const ang = k * golden + t * 0.04 * (k % 2 ? 1 : -1);
    const orbit = 380 + 40 * sin(t * 0.3 + k);
    const x = CX + cos(ang) * orbit;
    const y = CY + sin(ang) * orbit * 0.92;
    const size = 22 * pow(PHI, k % 3);

    let prox = 0;
    if (hasPointer) prox = max(0, 1 - dist(x, y, mouseX, mouseY) / 220);
    prismSpin[k] += 0.005 + 0.004 * k + prox * 0.06;
    const s = prismSpin[k];

    const front = [], back = [];
    const ox = cos(s * 0.7) * size * 0.6, oy = sin(s * 0.5) * size * 0.35;
    for (let m = 0; m < 3; m++) {
      const a = s + m * TWO_PI / 3;
      front.push([x + cos(a) * size, y + sin(a) * size]);
      back.push([x + cos(a) * size + ox, y + sin(a) * size + oy]);
    }

    stroke(IVORY[0], IVORY[1], IVORY[2], 110);
    strokeWeight(0.8);
    const pal = w.prism;
    fill(pal[3][0], pal[3][1], pal[3][2], 50);
    triangle(back[0][0], back[0][1], back[1][0], back[1][1], back[2][0], back[2][1]);
    for (let m = 0; m < 3; m++) {
      const n = (m + 1) % 3;
      fill(pal[m][0], pal[m][1], pal[m][2], 90 + prox * 80);
      quad(front[m][0], front[m][1], front[n][0], front[n][1],
        back[n][0], back[n][1], back[m][0], back[m][1]);
    }
    fill(pal[3][0], pal[3][1], pal[3][2], 120);
    triangle(front[0][0], front[0][1], front[1][0], front[1][1], front[2][0], front[2][1]);
  }
}

// ---------------------------------------------------------------------------
// Island chain and data wave
// ---------------------------------------------------------------------------

function buildIslands() {
  // [lon, lat, size, elongation]; approximate, supplied by me, not the corpus
  const ISLANDS = [
    [-160.15, 21.90, 0.32, 1.3], // Ni'ihau
    [-159.53, 22.07, 0.60, 1.0], // Kaua'i
    [-157.98, 21.48, 0.62, 1.2], // O'ahu
    [-157.02, 21.13, 0.42, 2.4], // Moloka'i
    [-156.93, 20.83, 0.30, 1.1], // Lana'i
    [-156.33, 20.80, 0.62, 1.3], // Maui
    [-156.61, 20.55, 0.20, 1.3], // Kaho'olawe
    [-155.52, 19.60, 1.15, 1.0]  // Hawai'i
  ];
  randomSeed(808);
  islandShapes = ISLANDS.map(([lon, lat, size, el]) => {
    const x = map(lon, -160.4, -154.7, 70, 420);
    const y = map(lat, 22.4, 19.0, 800, 1008);
    const pts = [];
    const n = 28;
    const seed = random(100);
    for (let k = 0; k < n; k++) {
      const a = k * TWO_PI / n;
      // alternate vertices pull inward slightly over a noisy coast for a rocky edge
      const coast = 0.7 + 0.5 * noise(seed + cos(a) * 1.2, seed + sin(a) * 1.2);
      const jag = coast * (k % 2 ? random(0.86, 0.95) : 1);
      const rx = size * 26 * el * jag, ry = size * 26 * jag;
      const px = cos(a) * rx, py = sin(a) * ry;
      const tilt = -0.35;
      pts.push([x + px * cos(tilt) - py * sin(tilt), y + px * sin(tilt) + py * cos(tilt)]);
    }
    return { x, y, pts };
  });
}

function drawIslands(t, w) {
  const a = w.accent;
  noFill();
  strokeWeight(1);
  for (let l = 0; l < 5; l++) {
    stroke(a[0], a[1], a[2], 70 - l * 10);
    beginShape();
    for (let x = 40; x <= W - 40; x += 10) {
      const near = hasPointer ? exp(-sq((x - mouseX) / 140)) : 0;
      const amp = 5 + 20 * near;
      vertex(x, 1028 + l * 8 + sin(x * 0.018 + t * 1.2 + l * 0.6) * amp * (0.6 + 0.4 * noise(x * 0.01, l, t * 0.2)));
    }
    endShape();
  }

  for (const s of islandShapes) {
    fill(w.ground[0] * 0.6, w.ground[1] * 0.6, w.ground[2] * 0.6, 230);
    stroke(GOLD[0], GOLD[1], GOLD[2], 170);
    strokeWeight(1);
    beginShape();
    for (const p of s.pts) vertex(p[0], p[1]);
    endShape(CLOSE);
    noStroke();
    fill(GOLD[0], GOLD[1], GOLD[2], 200);
    circle(s.x, s.y, 2.5);
  }
}

// ---------------------------------------------------------------------------
// The red gown
// ---------------------------------------------------------------------------

function updateGown(t) {
  let tx = CX + 330 * sin(t * 0.23);
  let ty = CY + 250 * sin(t * 0.23 * PHI + 1.1);
  if (dragging) {
    tx = mouseX;
    ty = mouseY;
  }
  headX = lerp(headX, tx, dragging ? 0.12 : 0.04);
  headY = lerp(headY, ty, dragging ? 0.12 : 0.04);
  gown[0].x = headX;
  gown[0].y = headY;

  const windX = hasPointer ? map(mouseX, 0, W, -0.9, 0.9) : 0.3;
  const force = 1.2 + gust * 3;
  for (let i = 1; i < GN; i++) {
    const p = gown[i], q = gown[i - 1];
    const u = i / GN; // wind matters more toward the hem
    p.x += (noise(i * 0.08, t * 0.6) - 0.5) * force * u + windX * u;
    p.y += (noise(i * 0.08 + 40, t * 0.6) - 0.5) * force * u + 0.25 * u;
    const dx = p.x - q.x, dy = p.y - q.y;
    const d = sqrt(dx * dx + dy * dy) || 1;
    p.x = q.x + dx / d * GSEG;
    p.y = q.y + dy / d * GSEG;
  }
}

function drawGown(t) {
  const N = [];
  for (let i = 0; i < GN; i++) {
    const a = gown[max(0, i - 1)], b = gown[min(GN - 1, i + 1)];
    let tx = b.x - a.x, ty = b.y - a.y;
    const d = sqrt(tx * tx + ty * ty) || 1;
    const u = i / GN;
    const wdt = (3 + 28 * pow(u, 1.1)) * (0.75 + 0.25 * sin(i * 0.32 - t * 2.4)) * (1 + gust * 0.6);
    N.push([-ty / d, tx / d, wdt]);
  }
  const g = WORLDS[worldIndex].gown;
  if (g.style === 'sand') gownSand(N, t, g);
  else if (g.style === 'amber') gownAmber(N, t, g);
  else if (g.style === 'crystal') gownCrystal(N, t, g);
  else if (g.style === 'fire') gownFire(N, t, g);
  else if (g.style === 'water') gownWater(N, t, g);
  else gownSilk(N, t, g);
  updateElems();
}

// edges of the ribbon at a width scale, with optional flicker
function ribbonEdges(N, scale, jitter, t) {
  const L = [], R = [];
  for (let i = 0; i < GN; i++) {
    const p = gown[i];
    let w = N[i][2] * scale;
    if (jitter) w *= 1 + jitter * (noise(i * 0.3, t * 4) - 0.5);
    L.push([p.x + N[i][0] * w, p.y + N[i][1] * w]);
    R.push([p.x - N[i][0] * w, p.y - N[i][1] * w]);
  }
  return [L, R];
}

function fillRibbon(L, R) {
  beginShape();
  for (let i = 0; i < GN; i++) vertex(L[i][0], L[i][1]);
  for (let i = GN - 1; i >= 0; i--) vertex(R[i][0], R[i][1]);
  endShape(CLOSE);
}

function foldLine(N, k0, t, speed, amp) {
  beginShape();
  for (let i = 2; i < GN; i++) {
    const k = k0 + amp * sin(i * 0.25 + t * speed);
    const p = gown[i];
    vertex(p.x + N[i][0] * N[i][2] * k, p.y + N[i][1] * N[i][2] * k);
  }
  endShape();
}

function spinePoint(N, i, k) {
  const p = gown[i];
  return [p.x + N[i][0] * N[i][2] * k, p.y + N[i][1] * N[i][2] * k];
}

// SIGNATURE: the red silk gown
function gownSilk(N, t, g) {
  const c = g.c;
  const [L, R] = ribbonEdges(N, 1, 0, t);
  noStroke();
  fill(c[0] * 0.45, c[1] * 0.4, c[2] * 0.5, 150);
  beginShape();
  for (let i = 0; i < GN; i++) vertex(L[i][0] + N[i][0] * 4 + 3, L[i][1] + N[i][1] * 4 + 5);
  for (let i = GN - 1; i >= 0; i--) vertex(R[i][0] + 3, R[i][1] + 5);
  endShape(CLOSE);
  fill(c[0], c[1], c[2], 220);
  fillRibbon(L, R);
  noFill();
  const folds = [-0.45, 0.05, 0.55];
  for (let f = 0; f < 3; f++) {
    stroke(f === 1 ? 120 : 220, f === 1 ? 10 : 60, f === 1 ? 22 : 70, 90);
    strokeWeight(1.2);
    foldLine(N, folds[f], t + f * 1.1, 1.8, 0.12);
  }
  stroke(g.c2[0], g.c2[1], g.c2[2], 130);
  strokeWeight(1);
  beginShape();
  for (let i = 0; i < GN; i++) vertex(L[i][0], L[i][1]);
  endShape();
}

// EPOCH: desert sand silk in strata bands, shedding grains
function gownSand(N, t, g) {
  const c = g.c, c2 = g.c2;
  const [L, R] = ribbonEdges(N, 1, 0, t);
  noStroke();
  fill(c[0] * 0.5, c[1] * 0.45, c[2] * 0.4, 150);
  fillRibbon(ribbonEdges(N, 1.08, 0, t)[0], ribbonEdges(N, 1.08, 0, t)[1]);
  fill(c[0], c[1], c[2], 225);
  fillRibbon(L, R);
  noFill();
  const bands = [-0.75, -0.4, -0.1, 0.2, 0.5, 0.8];
  for (let f = 0; f < bands.length; f++) {
    const light = f % 2 === 0;
    stroke(light ? c2[0] : c[0] * 0.6, light ? c2[1] : c[1] * 0.55, light ? c2[2] : c[2] * 0.5, light ? 120 : 100);
    strokeWeight(light ? 1.4 : 2);
    foldLine(N, bands[f], t * 0.5 + f, 1.2, 0.05);
  }
  for (let k = 0; k < 3; k++) {
    const i = floor(random(GN * 0.4, GN));
    const [x, y] = spinePoint(N, i, random(-1, 1));
    addElem(x, y, random(-0.4, 0.4), random(0, 0.6), 0.08, lerpRGB(c, c2, random()), 'grain');
  }
}

// LIGAND: liquid amber glass with a gloss line and suspended bubbles
function gownAmber(N, t, g) {
  const c = g.c, c2 = g.c2;
  const [L, R] = ribbonEdges(N, 1, 0, t);
  noStroke();
  fill(c[0] * 0.55, c[1] * 0.4, c[2] * 0.2, 120);
  fillRibbon(ribbonEdges(N, 1.12, 0, t)[0], ribbonEdges(N, 1.12, 0, t)[1]);
  fill(c[0], c[1], c[2], 150);
  fillRibbon(L, R);
  push();
  blendMode(ADD);
  noFill();
  stroke(c2[0], c2[1], c2[2], 120);
  strokeWeight(3);
  foldLine(N, -0.35, t, 1.4, 0.08);
  stroke(255, 245, 220, 150);
  strokeWeight(1);
  foldLine(N, -0.4, t, 1.4, 0.08);
  blendMode(BLEND);
  pop();
  noFill();
  for (let i = 6; i < GN; i += 4) {
    const k = 0.6 * sin(i * 1.7 + t * 0.8);
    const [x, y] = spinePoint(N, i, k);
    stroke(c2[0], c2[1], c2[2], 110);
    strokeWeight(0.8);
    circle(x, y - (t * 6 + i * 3) % 6, 2 + (i % 3) * 1.5);
  }
}

// PELAGIC: faceted crystal shards with twinkling glints
function gownCrystal(N, t, g) {
  const c = g.c, c2 = g.c2;
  const [L, R] = ribbonEdges(N, 1, 0, t);
  for (let i = 0; i < GN - 2; i += 2) {
    const m = spinePoint(N, i + 1, 0.15 * sin(i + t));
    const u = i / GN;
    const tone = lerpRGB(c, c2, noise(i * 0.2, t * 0.3));
    stroke(235, 245, 255, 120);
    strokeWeight(0.6);
    fill(tone[0], tone[1], tone[2], 150 + 60 * u);
    triangle(L[i][0], L[i][1], L[i + 2][0], L[i + 2][1], m[0], m[1]);
    fill(tone[0] * 0.6, tone[1] * 0.7, tone[2] * 0.85, 170 + 50 * u);
    triangle(R[i][0], R[i][1], R[i + 2][0], R[i + 2][1], m[0], m[1]);
    fill(c2[0], c2[1], c2[2], 70);
    triangle(L[i][0], L[i][1], R[i][0], R[i][1], m[0], m[1]);
  }
  push();
  blendMode(ADD);
  for (let i = 4; i < GN; i += 7) {
    const tw = pow(max(0, sin(t * 3 + i * 1.3)), 6);
    if (tw < 0.05) continue;
    const [x, y] = spinePoint(N, i, 0.5 * sin(i));
    const r = 3 + 9 * tw;
    stroke(255, 255, 255, 220 * tw);
    strokeWeight(1);
    line(x - r, y, x + r, y);
    line(x, y - r, x, y + r);
  }
  blendMode(BLEND);
  pop();
}

// SANTO BRUTO: a flame ribbon that throws rising embers
function gownFire(N, t, g) {
  const c = g.c, c2 = g.c2;
  push();
  blendMode(ADD);
  noStroke();
  let e = ribbonEdges(N, 1.5, 0.9, t);
  fill(200, 40, 10, 70);
  fillRibbon(e[0], e[1]);
  e = ribbonEdges(N, 1.05, 0.7, t + 3);
  fill(c[0], c[1], c[2], 120);
  fillRibbon(e[0], e[1]);
  e = ribbonEdges(N, 0.45, 0.5, t + 7);
  fill(c2[0], c2[1], c2[2], 150);
  fillRibbon(e[0], e[1]);
  blendMode(BLEND);
  pop();
  for (let k = 0; k < 3; k++) {
    const i = floor(random(GN * 0.2, GN));
    const [x, y] = spinePoint(N, i, random(-1, 1));
    addElem(x, y, random(-0.6, 0.6), random(-2.2, -0.8), -0.03, random() < 0.5 ? c : c2, 'ember');
  }
}

// LEI WAI: translucent water, aqua to blush, with currents and droplets
function gownWater(N, t, g) {
  const c = g.c, c2 = g.c2;
  const [L, R] = ribbonEdges(N, 1, 0, t);
  noStroke();
  for (let i = 0; i < GN - 1; i++) {
    const col = lerpRGB(c, c2, i / GN);
    fill(col[0], col[1], col[2], 120);
    quad(L[i][0], L[i][1], L[i + 1][0], L[i + 1][1], R[i + 1][0], R[i + 1][1], R[i][0], R[i][1]);
  }
  push();
  blendMode(ADD);
  noFill();
  for (let f = 0; f < 4; f++) {
    stroke(220, 245, 255, 70 + f * 15);
    strokeWeight(1);
    foldLine(N, -0.6 + f * 0.4, t + f * 0.9, 3.2, 0.18);
  }
  stroke(255, 255, 255, 140);
  beginShape();
  for (let i = 0; i < GN; i++) vertex(L[i][0], L[i][1]);
  endShape();
  blendMode(BLEND);
  pop();
  if (random() < 0.6) {
    const i = floor(random(GN * 0.5, GN));
    const [x, y] = spinePoint(N, i, random(-1, 1));
    addElem(x, y, random(-0.3, 0.3), random(0, 1), 0.12, lerpRGB(c, [235, 248, 255], 0.5), 'drop');
  }
}

function addElem(x, y, vx, vy, g, col, kind) {
  if (elems.length >= ELEM_MAX) elems.shift();
  elems.push({ x, y, vx, vy, g, col, kind, life: 1 });
}

function updateElems() {
  push();
  for (let i = elems.length - 1; i >= 0; i--) {
    const p = elems[i];
    p.vy += p.g;
    p.vx *= 0.98;
    if (p.kind === 'ember') p.vx += (noise(p.x * 0.01, p.y * 0.01) - 0.5) * 0.2;
    p.x += p.vx;
    p.y += p.vy;
    p.life -= p.kind === 'grain' ? 0.012 : 0.02;
    if (p.life <= 0 || p.y > H) { elems.splice(i, 1); continue; }
    const a = 255 * p.life;
    if (p.kind === 'ember') {
      blendMode(ADD);
      noStroke();
      fill(p.col[0], p.col[1], p.col[2], a * 0.8);
      circle(p.x, p.y, 1.5 + 2.5 * p.life);
      blendMode(BLEND);
    } else if (p.kind === 'drop') {
      stroke(p.col[0], p.col[1], p.col[2], a);
      strokeWeight(1.4);
      line(p.x, p.y, p.x - p.vx, p.y - p.vy * 2);
    } else {
      noStroke();
      fill(p.col[0], p.col[1], p.col[2], a);
      rect(p.x, p.y, 1.6, 1.6);
    }
  }
  pop();
}

// ---------------------------------------------------------------------------
// Murmuration, led by the gown in a crescent
// ---------------------------------------------------------------------------

function updateBoids(t) {
  const MAXS = 3.6, MAXF = 0.09;
  const hx = gown[0].x, hy = gown[0].y;
  const heading = atan2(gown[0].y - gown[5].y, gown[0].x - gown[5].x);

  sepX.fill(0); sepY.fill(0);
  aliX.fill(0); aliY.fill(0);
  cohX.fill(0); cohY.fill(0);
  cnt.fill(0);

  for (let i = 0; i < NB; i++) {
    for (let j = i + 1; j < NB; j++) {
      const dx = bx[j] - bx[i], dy = by[j] - by[i];
      const d2 = dx * dx + dy * dy;
      if (d2 > 1600) continue;
      aliX[i] += bvx[j]; aliY[i] += bvy[j];
      aliX[j] += bvx[i]; aliY[j] += bvy[i];
      cohX[i] += bx[j]; cohY[i] += by[j];
      cohX[j] += bx[i]; cohY[j] += by[i];
      cnt[i]++; cnt[j]++;
      if (d2 < 196) {
        const d = sqrt(d2) || 1;
        const k = 1 / (d * d);
        sepX[i] -= dx * k; sepY[i] -= dy * k;
        sepX[j] += dx * k; sepY[j] += dy * k;
      }
    }
  }

  for (let i = 0; i < NB; i++) {
    let fx = 0, fy = 0;
    let s;
    if (sepX[i] || sepY[i]) {
      s = steer(sepX[i], sepY[i], i, MAXS, MAXF);
      fx += s[0] * 1.6; fy += s[1] * 1.6;
    }
    if (cnt[i]) {
      s = steer(aliX[i], aliY[i], i, MAXS, MAXF);
      fx += s[0] * 0.6; fy += s[1] * 0.6;
      s = steer(cohX[i] / cnt[i] - bx[i], cohY[i] / cnt[i] - by[i], i, MAXS, MAXF);
      fx += s[0] * 0.3; fy += s[1] * 0.3;
    }
    const a = heading + map(i, 0, NB - 1, -1.25, 1.25);
    const r = 120 + 18 * sin(t * 1.7 + i * 0.37);
    s = steer(hx + cos(a) * r - bx[i], hy + sin(a) * r - by[i], i, MAXS, MAXF);
    fx += s[0] * 0.9; fy += s[1] * 0.9;

    bvx[i] += fx; bvy[i] += fy;
    const sp = sqrt(bvx[i] * bvx[i] + bvy[i] * bvy[i]);
    if (sp > MAXS) { bvx[i] *= MAXS / sp; bvy[i] *= MAXS / sp; }
    bx[i] += bvx[i]; by[i] += bvy[i];
  }
}

function steer(dx, dy, i, maxS, maxF) {
  const d = sqrt(dx * dx + dy * dy) || 1;
  let fx = dx / d * maxS - bvx[i];
  let fy = dy / d * maxS - bvy[i];
  const f = sqrt(fx * fx + fy * fy);
  if (f > maxF) { fx *= maxF / f; fy *= maxF / f; }
  return [fx, fy];
}

function drawBoids() {
  stroke(IVORY[0], IVORY[1], IVORY[2], 180);
  strokeWeight(1.6);
  for (let i = 0; i < NB; i++) {
    line(bx[i], by[i], bx[i] - bvx[i] * 2.2, by[i] - bvy[i] * 2.2);
  }
}

// ---------------------------------------------------------------------------
// Pointer: Silvertrace stylus, sweeps, apex bursts, shake to erase
// ---------------------------------------------------------------------------

function updateInput(t) {
  // before the viewer arrives, the stylus idles on a golden-ratio path
  const tx = hasPointer ? mouseX : CX + 200 * sin(t * 0.7);
  const ty = hasPointer ? mouseY : CY + 200 * sin(t * 0.7 * PHI);
  const psx = sx, psy = sy;
  sx += (tx - sx) * 0.15;
  sy += (ty - sy) * 0.15;

  const last = trace[trace.length - 1];
  if (!last || abs(sx - last[0]) + abs(sy - last[1]) > 0.6) {
    trace.push([sx, sy, millis()]);
    if (trace.length > TRACE_MAX) trace.shift();
  }

  const sSpeed = dist(sx, sy, psx, psy);
  if (sSpeed > 6 && sparks.length < SPARK_MAX) {
    const n = min(3, floor(sSpeed / 6));
    for (let k = 0; k < n; k++) addSpark(sx, sy, random(-1.5, 1.5) - (sx - psx) * 0.1, random(-2.5, 0.5), GOLD);
  }

  if (mouseIsPressed && dist(mouseX, mouseY, pressX, pressY) > 8) {
    dragging = true;
    dragMoved = true;
  }

  waveCooldown = max(0, waveCooldown - 1);
  burstCooldown = max(0, burstCooldown - 1);
  gust *= 0.96;
  if (!hasPointer) return;

  const vx = mouseX - pmouseX, vy = mouseY - pmouseY;
  const speed = sqrt(vx * vx + vy * vy);
  gust = max(gust, min(1, speed / 40));

  if (speed > 38 && waveCooldown === 0) {
    waves.push({ x: mouseX, y: mouseY, a: atan2(vy, vx), r: 20, life: 1 });
    waveCooldown = 8;
  }

  if (vy < -22) {
    rising = true;
  } else if (rising && vy > -3) {
    rising = false;
    if (burstCooldown === 0) {
      bursts.push({ x: mouseX, y: mouseY, r: 10, life: 1 });
      for (let k = 0; k < 30 && sparks.length < SPARK_MAX; k++) {
        const a = random(TWO_PI), v = random(1.5, 5);
        addSpark(mouseX, mouseY, cos(a) * v, sin(a) * v, GOLD);
      }
      burstCooldown = 20;
    }
  }

  if (abs(vx) > 14) {
    const s = Math.sign(vx);
    if (lastVxSign !== 0 && s !== lastVxSign) reversals.push(frameCount);
    lastVxSign = s;
  }
  reversals = reversals.filter((f) => frameCount - f < 50);
  if (reversals.length >= 5) {
    eraseTrace();
    reversals = [];
  }
}

function eraseTrace() {
  for (let k = 0; k < 160 && trace.length; k++) {
    const p = trace[floor(random(trace.length))];
    addSpark(p[0], p[1], random(-1, 1), random(-2, 0), SILVER);
  }
  if (sparks.length > SPARK_MAX) sparks.splice(0, sparks.length - SPARK_MAX);
  trace = [];
}

function drawTrace() {
  const now = millis();
  while (trace.length && now - trace[0][2] > TRACE_LIFE) trace.shift();
  const n = trace.length;
  const t = now / 1000;
  const w = WORLDS[worldIndex];
  const A = w.accent;

  push();
  blendMode(ADD);
  if (n > 2) {
    // three strands braided around the path, tapering tail to tip
    for (let k = 1; k < n; k++) {
      const p = trace[k], q = trace[k - 1];
      const dx = p[0] - q[0], dy = p[1] - q[1];
      const d = sqrt(dx * dx + dy * dy) || 1;
      const nx = -dy / d, ny = dx / d;
      const u = k / (n - 1);                       // 0 = tail, 1 = tip
      const fade = 1 - (now - p[2]) / TRACE_LIFE;  // ages out over time
      const wdt = 1 + 13 * pow(u, 1.5);
      const col = lerpRGB(A, IVORY, u);

      // soft glow core
      stroke(col[0], col[1], col[2], 22 * fade * u);
      strokeWeight(2 + wdt * 1.4);
      line(q[0], q[1], p[0], p[1]);

      for (let s = 0; s < 3; s++) {
        const ph = s * TWO_PI / 3;
        const o1 = sin((k - 1) * 0.3 - t * 7 + ph) * wdt;
        const o0 = sin(k * 0.3 - t * 7 + ph) * wdt;
        stroke(col[0], col[1], col[2], 170 * fade * (0.25 + 0.75 * u));
        strokeWeight(0.5 + 1.5 * u);
        line(q[0] + nx * o1, q[1] + ny * o1, p[0] + nx * o0, p[1] + ny * o0);
      }
    }
  }
  // halo at the tip
  noStroke();
  for (let r = 22; r > 2; r -= 5) {
    fill(IVORY[0], IVORY[1], IVORY[2], 10 + (22 - r) * 2.2);
    circle(sx, sy, r);
  }
  blendMode(BLEND);
  pop();
}

function drawWaves(w) {
  noFill();
  for (let i = waves.length - 1; i >= 0; i--) {
    const v = waves[i];
    v.r += 6;
    v.life -= 0.022;
    if (v.life <= 0) { waves.splice(i, 1); continue; }
    stroke(w.accent[0], w.accent[1], w.accent[2], 200 * v.life);
    strokeWeight(0.3 + 1.6 * v.life);
    arc(v.x, v.y, v.r * 2, v.r * 2, v.a - 0.8, v.a + 0.8);
    arc(v.x, v.y, v.r * 1.6, v.r * 1.6, v.a - 0.6, v.a + 0.6);
  }
}

function drawBursts() {
  noFill();
  for (let i = bursts.length - 1; i >= 0; i--) {
    const b = bursts[i];
    b.r += 5;
    b.life -= 0.028;
    if (b.life <= 0) { bursts.splice(i, 1); continue; }
    stroke(GOLD[0], GOLD[1], GOLD[2], 220 * b.life);
    strokeWeight(1.2);
    circle(b.x, b.y, b.r * 2);
    circle(b.x, b.y, b.r * 1.3);
    for (let k = 0; k < 24; k++) {
      const a = k * TWO_PI / 24;
      const r0 = b.r * 0.6;
      line(b.x + cos(a) * r0, b.y + sin(a) * r0, b.x + cos(a) * (r0 + 12), b.y + sin(a) * (r0 + 12));
    }
  }
}

// ---------------------------------------------------------------------------
// Sparks: gravity, damping, friction, wall and floor bounces
// ---------------------------------------------------------------------------

function addSpark(x, y, vx, vy, col) {
  sparks.push({ x, y, vx, vy, life: 1, col });
}

function updateSparks() {
  for (let i = sparks.length - 1; i >= 0; i--) {
    const p = sparks[i];
    p.vy += 0.12;
    p.vx *= 0.985;
    p.vy *= 0.985;
    p.x += p.vx;
    p.y += p.vy;
    if (p.x < 0 || p.x > W) { p.vx *= -0.55; p.x = constrain(p.x, 0, W); }
    if (p.y > H - 4) { p.y = H - 4; p.vy *= -0.55; p.vx *= 0.8; }
    p.life -= 0.012;
    if (p.life <= 0) sparks.splice(i, 1);
  }
}

function drawSparks() {
  strokeWeight(1.4);
  for (const p of sparks) {
    stroke(p.col[0], p.col[1], p.col[2], 255 * p.life);
    line(p.x, p.y, p.x - p.vx * 1.5, p.y - p.vy * 1.5);
  }
}

// ---------------------------------------------------------------------------
// Masthead
// ---------------------------------------------------------------------------

function drawMasthead(t, w) {
  noStroke();
  textFont('Georgia'); // system serif; no web font is loaded
  textAlign(LEFT, TOP);
  fill(IVORY[0], IVORY[1], IVORY[2], 210);
  textSize(13);
  text('C O N T E X T    P O R T R A I T', 60, 44);
  fill(GOLD[0], GOLD[1], GOLD[2], 160);
  textSize(11);
  text('luxury fashion aesthetics, geometric code', 60, 66);

  textAlign(RIGHT, TOP);
  fill(IVORY[0], IVORY[1], IVORY[2], 210);
  textSize(13);
  text(nf(worldIndex + 1, 2) + ' / ' + nf(WORLDS.length, 2) + '    ' + w.name, W - 60, 44);
  fill(w.accent[0], w.accent[1], w.accent[2], 170);
  textSize(11);
  text(w.note, W - 60, 66);

  const hintAlpha = constrain(map(t, 8, 11, 150, 0), 0, 150);
  if (hintAlpha > 0) {
    fill(IVORY[0], IVORY[1], IVORY[2], hintAlpha);
    textAlign(RIGHT, TOP);
    text('move · sweep · flick up · drag the gown · click for next world · shake to erase', W - 60, 86);
  }
}

// ---------------------------------------------------------------------------
// Events and helpers
// ---------------------------------------------------------------------------

function mouseMoved() {
  hasPointer = true;
}

function mouseDragged() {
  hasPointer = true;
}

function mousePressed() {
  hasPointer = true;
  pressX = mouseX;
  pressY = mouseY;
  pressT = millis();
  dragMoved = false;
}

function mouseReleased() {
  if (!dragMoved && millis() - pressT < 350) nextWorld();
  dragging = false;
  dragMoved = false;
}

function nextWorld() {
  worldIndex = (worldIndex + 1) % WORLDS.length;
  elems = [];
  buildField();
  bursts.push({ x: CX, y: CY, r: 10, life: 1 });
}

function lerpRGB(a, b, u) {
  return [lerp(a[0], b[0], u), lerp(a[1], b[1], u), lerp(a[2], b[2], u)];
}
