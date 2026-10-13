// ============================================================
// CRCP 6310 – Introduction to Creative Coding
// Week 8 Assignment: Particle System – "The Living Vase"
// ============================================================
//
// So here's what I'm going for with this piece:
// The mandala flowers on the vase are already beautiful on their
// own, but I wanted to make them feel like they're alive —
// like they're radiating energy outward. So each flower gets
// its own miniature parametric spiral halo, the same formula
// from the reference code, just scaled down and placed right
// on top of each flower disc. And because each one has its own
// independent phase offset, they all breathe and rotate at
// slightly different speeds — no two are in sync, which is
// what makes it feel organic rather than mechanical.
//
// On top of that, physics particles cascade down from each
// flower center like sparks off a sparkler. They have gravity,
// damping, friction, and they bounce off the walls and floor.
//
// CONTROLS:
//   Keys 1–5  – switch between 5 mandala-inspired color palettes
//   Key  S    – cycle shape mode: Stars → Polygons → Mixed
//   Mouse     – move to warp all spiral halos simultaneously
//   Click     – burst from nearest flower emitter
//
// WEEK 8 REQUIREMENTS:
//   Parallel arrays, for-loop init + update, pushMatrix/popMatrix,
//   randomized ptCount + star variant, color arrays (no flashing),
//   gravity + damping + friction + all four boundary collisions,
//   custom functions: poly(), starPoly(), drawFlowerHalos()
// ============================================================


// ── IMAGE ────────────────────────────────────────────────────
PImage vaseImg;


// ── FLOWER EMITTER POSITIONS ─────────────────────────────────
// These are the centers of the 20 circular flower disc heads,
// measured as offsets from the canvas center (after global translate).
// I tightened them in so particles really do emerge from inside
// the flower faces rather than floating above them.
int NUM_EMITTERS = 20;
float[] emitX = {
     0,
   -45,   45,
   -90,    0,  90,
  -130,  -50,  50, 130,
  -150,  -85,   0,  85, 150,
  -120,  -48,  48, 120,
     0
};
float[] emitY = {
  -275,
  -260, -260,
  -238, -248, -238,
  -214, -228, -228, -214,
  -176, -198, -208, -198, -176,
  -142, -163, -163, -142,
  -128
};

// Each flower gets its own phase offset so they all rotate at
// slightly different speeds — this is what creates the organic,
// non-synchronized breathing effect across the whole bouquet.
float[] haloPhase = new float[20];


// ── PARTICLE ARRAYS ──────────────────────────────────────────
// Parallel arrays — every index i is the same particle across all of them.
// This is the procedural approach before we get into OOP and classes.
// Change PART_COUNT and everything scales automatically — that's the
// whole point of doing it this way instead of 650 individual variables.

final int PART_COUNT = 600;

float[] tx       = new float[PART_COUNT];
float[] ty       = new float[PART_COUNT];
float[] spdX     = new float[PART_COUNT];
float[] spdY     = new float[PART_COUNT];
float   gravity  = 0.11;
float[] damping  = new float[PART_COUNT];
float[] friction = new float[PART_COUNT];
float[] polyRad  = new float[PART_COUNT];
float[] strokeWt = new float[PART_COUNT];
int[]   ptCount  = new int[PART_COUNT];
color[] fillCol  = new color[PART_COUNT];
color[] strokeCol= new color[PART_COUNT];
float[] life     = new float[PART_COUNT];
float[] lifeSpd  = new float[PART_COUNT];
boolean[] isStar = new boolean[PART_COUNT];
int[]   emitter  = new int[PART_COUNT];


// ── SPIRAL HALO PARAMS ───────────────────────────────────────
// Each flower halo is a miniaturized version of the original
// spiral formula. spiralN controls smoothness (fewer = faster),
// spiralS controls how big the halo is relative to the flower disc.
// I tuned it so the halo fits snugly inside each flower circle
// without bleeding into adjacent flowers.
int   spiralN = 2200;   // points per halo (kept low for performance)
float spiralS =  38;    // radius scale — roughly matches flower disc size


// ── INTERACTION STATE ────────────────────────────────────────
int     currentPalette = 0;
int     shapeMode      = 0;   // 0=stars  1=polygons  2=mixed
boolean showHint       = true;
int     hintTimer      = 0;


// ── COLOR PALETTES ───────────────────────────────────────────
// 5 palettes pulled from the mandala reference images.
// [0..2] = fill tones (core → mid → edge),  [3..5] = stroke tones
color[][] palettes = new color[5][6];


// ============================================================
//  S E T U P
// ============================================================
void setup() {
  size(800, 800);
  vaseImg = loadImage("VASE.png");

  buildPalettes();

  // give each flower halo a random starting phase offset
  // so none of them start in sync — they drift apart over time
  for (int e = 0; e < NUM_EMITTERS; e++) {
    haloPhase[e] = random(TWO_PI);
  }

  initParticles();
  hintTimer = 0;
}


void buildPalettes() {
  // 0 – warm gold / teal / violet   (Mandala 12)
  palettes[0][0] = color(255, 215,  30);
  palettes[0][1] = color(  0, 210, 200);
  palettes[0][2] = color( 80,  40, 180);
  palettes[0][3] = color(255, 180,  10);
  palettes[0][4] = color( 10, 180, 200);
  palettes[0][5] = color(140,  50, 220);

  // 1 – electric blue / purple / gold   (Mandala 13)
  palettes[1][0] = color(255, 220,  80);
  palettes[1][1] = color( 60, 100, 240);
  palettes[1][2] = color(160,  20, 180);
  palettes[1][3] = color(220, 180,  60);
  palettes[1][4] = color( 80, 130, 255);
  palettes[1][5] = color(200,  50, 200);

  // 2 – hot pink / cobalt / navy   (Mandala 2)
  palettes[2][0] = color(255,  60, 180);
  palettes[2][1] = color( 20, 150, 220);
  palettes[2][2] = color( 10,  70, 150);
  palettes[2][3] = color(255, 100, 200);
  palettes[2][4] = color( 40, 200, 230);
  palettes[2][5] = color( 40,  40, 120);

  // 3 – full neon spectrum   (Mandala 6)
  palettes[3][0] = color(255,  50,  50);
  palettes[3][1] = color( 50, 255, 100);
  palettes[3][2] = color( 50,  50, 255);
  palettes[3][3] = color(255, 200,   0);
  palettes[3][4] = color(255,  50, 200);
  palettes[3][5] = color(  0, 220, 220);

  // 4 – teal / antique gold / deep purple   (Mandala 10)
  palettes[4][0] = color(  0, 200, 170);
  palettes[4][1] = color(220, 160,  20);
  palettes[4][2] = color(100,  20, 140);
  palettes[4][3] = color( 30, 230, 190);
  palettes[4][4] = color(240, 190,  50);
  palettes[4][5] = color(130,  40, 170);
}


void initParticles() {
  for (int i = 0; i < PART_COUNT; i++) {
    spawnParticle(i);
    life[i] = random(1.0);   // stagger so they don't all die at once
  }
}


void spawnParticle(int i) {
  emitter[i] = int(random(NUM_EMITTERS));
  tx[i] = emitX[emitter[i]] + random(-4, 4);
  ty[i] = emitY[emitter[i]] + random(-4, 4);

  float angle = random(TWO_PI);
  float spd   = random(0.2, 2.8);
  spdX[i] = cos(angle) * spd;
  spdY[i] = sin(angle) * spd - random(0.2, 1.6);

  damping[i]  = random(0.50, 0.88);
  friction[i] = random(0.50, 0.88);
  polyRad[i]  = random(1.8, 6.0);
  strokeWt[i] = random(0.3, 1.6);

  if (shapeMode == 0) {
    isStar[i]  = true;
    ptCount[i] = int(random(3, 7)) * 2;
  } else if (shapeMode == 1) {
    isStar[i]  = false;
    ptCount[i] = int(random(3, 9));
  } else {
    isStar[i]  = (random(1) > 0.5);
    ptCount[i] = isStar[i] ? int(random(3,7))*2 : int(random(3,9));
  }

  lifeSpd[i] = random(0.005, 0.016);
  life[i]    = 0.0;
  assignColor(i, 0.0);
}


// Instead of calling random() on color every frame (which causes
// the per-frame flashing problem from Part 7), I interpolate
// through the palette stops based on how old the particle is.
// Each particle smoothly transitions through the color range as
// it ages, and the alpha fades naturally to zero at death.
void assignColor(int i, float t) {
  int   p     = currentPalette;
  int   c0    = int(t * 2) % 3;
  int   c1    = (c0 + 1) % 3;
  float blend = (t * 2) % 1.0;
  color f = lerpColor(palettes[p][c0],   palettes[p][c1],   blend);
  color s = lerpColor(palettes[p][c0+3], palettes[p][c1+3], blend);
  float a = map(t, 0.0, 1.0, 235, 0);
  fillCol[i]   = color(red(f), green(f), blue(f), a);
  strokeCol[i] = color(red(s), green(s), blue(s), a * 0.65);
}


// ============================================================
//  D R A W
// ============================================================
void draw() {

  // Semi-transparent overlay instead of background() — this is
  // what creates the comet-tail ghosting trail on each particle.
  // Lower alpha = longer trails.
  noStroke();
  fill(8, 6, 20, 50);
  rect(0, 0, width, height);

  // Vase image slightly transparent so the halo glows bleed
  // through and look like they're coming FROM the surface.
  imageMode(CENTER);
  tint(255, 215);
  image(vaseImg, width/2, height/2, 600, 730);
  noTint();

  // Single global translate — everything from here down is
  // relative to canvas center. This one stays OUTSIDE the loop
  // so it doesn't accumulate. (That's the whole push/pop lesson.)
  translate(width/2, height/2);

  // Draw all 20 flower halos first so they sit behind the particles —
  // the particles appear to float above the glowing flower faces.
  drawFlowerHalos();

  // ── PARTICLE LOOP ────────────────────────────────────────────
  for (int i = 0; i < PART_COUNT; i++) {

    life[i] += lifeSpd[i];
    if (life[i] >= 1.0) { spawnParticle(i); continue; }

    assignColor(i, life[i]);

    // Physics: gravity pulls down every frame, velocities integrate
    spdY[i] += gravity;
    tx[i]   += spdX[i];
    ty[i]   += spdY[i];

    // Boundary collisions — radius-aware so shapes don't clip walls
    if (tx[i] >= width/2 - polyRad[i]) {
      spdX[i] *= -1;
      tx[i]    = width/2 - polyRad[i];
    } else if (tx[i] <= -width/2 + polyRad[i]) {
      spdX[i] *= -1;
      tx[i]    = -width/2 + polyRad[i];
    }
    if (ty[i] >= height/2 - polyRad[i]) {
      ty[i]    = height/2 - polyRad[i];
      spdY[i] *= -damping[i];
      spdX[i] *= friction[i];
      if (abs(spdY[i]) < 0.4) life[i] = 0.95;
    } else if (ty[i] <= -height/2 + polyRad[i]) {
      spdY[i] *= -1;
    }

    // pushMatrix / popMatrix: wraps EACH particle's translate so
    // it doesn't accumulate into the next one. Without this every
    // particle after the first ends up completely off screen.
    pushMatrix();
    translate(tx[i], ty[i]);
    if (isStar[i]) {
      starPoly(ptCount[i], polyRad[i], polyRad[i]*0.40,
               strokeCol[i], fillCol[i], strokeWt[i]);
    } else {
      poly(ptCount[i], polyRad[i], strokeCol[i], fillCol[i], strokeWt[i]);
    }
    popMatrix();
  }

  if (showHint && frameCount - hintTimer < 300) drawHint();
}


// ── FLOWER HALO SYSTEM ───────────────────────────────────────
// This is the heart of the piece. For each of the 20 flower
// emitters I draw a miniature version of the parametric spiral
// formula, centered exactly on that flower's position.
//
// The trick that makes them feel independent: each flower has its
// own haloPhase[e] value assigned randomly at startup. I add that
// phase to the frameCount-based oscillation, so each flower's
// spiral is at a different point in its breathing cycle at any
// given moment. They'll never fully sync up — which is exactly
// what makes the whole bouquet feel alive rather than mechanical.
void drawFlowerHalos() {

  float mX = map(mouseX, 0, width,  0.10, 0.99);
  float mY = map(mouseY, 0, height, 14.0, 32.0);

  color p0 = palettes[currentPalette][0];
  color p1 = palettes[currentPalette][2];

  noFill();
  strokeWeight(0.5);

  for (int e = 0; e < NUM_EMITTERS; e++) {

    // Each flower uses its own phase offset to drive the inner
    // radius oscillation independently of all the others.
    // The 0.04 speed factor keeps it slow enough to read as breathing.
    float m = map(sin(frameCount * 0.04 + haloPhase[e]), -1, 1, 0.06, 0.22);

    pushMatrix();
    translate(emitX[e], emitY[e]);   // move to this flower's center

    for (int k = 0; k < spiralN; k++) {
      float t = (float)k / spiralN;

      float a = 10 * PI * k / spiralN;
      float b = 1 - mX * pow(cos(mY * PI * k / spiralN), 2);
      float x = cos(a) * b * spiralS;
      float y = sin(a) * b * spiralS;
      float r = (1.0/200.0 + m * pow(sin(53.0 * PI * k / spiralN), 4)) * spiralS;

      // Fade alpha toward the halo edges so it dissolves naturally
      // into the flower disc rather than having a hard cutoff ring.
      float alpha = map(abs(b), 0.0, 1.0, 130, 12);
      color sc = lerpColor(p0, p1, t);
      stroke(red(sc), green(sc), blue(sc), alpha);

      ellipse(x, y, r, r);
    }

    popMatrix();
  }
}


// ── HUD ──────────────────────────────────────────────────────
void drawHint() {
  fill(255, 175);
  noStroke();
  textSize(13);
  textAlign(LEFT, BOTTOM);
  text("KEYS  1-5 = palette   S = shapes   CLICK = burst",
       -width/2 + 14, height/2 - 28);
  text("Palette: " + (currentPalette+1) + "/5   Shape: " + shapeName(),
       -width/2 + 14, height/2 - 10);
}

String shapeName() {
  if (shapeMode == 0) return "Stars";
  if (shapeMode == 1) return "Polygons";
  return "Mixed";
}


// ── KEYBOARD ─────────────────────────────────────────────────
void keyPressed() {
  showHint  = true;
  hintTimer = frameCount;
  if (key >= '1' && key <= '5') currentPalette = key - '1';
  if (key == 's' || key == 'S') {
    shapeMode = (shapeMode + 1) % 3;
    for (int i = 0; i < PART_COUNT; i++) {
      if (shapeMode == 0) {
        isStar[i]  = true;
        ptCount[i] = int(random(3,7))*2;
      } else if (shapeMode == 1) {
        isStar[i]  = false;
        ptCount[i] = int(random(3,9));
      } else {
        isStar[i]  = (random(1) > 0.5);
        ptCount[i] = isStar[i] ? int(random(3,7))*2 : int(random(3,9));
      }
    }
  }
}


// ── MOUSE BURST ──────────────────────────────────────────────
void mousePressed() {
  float mx = mouseX - width/2;
  float my = mouseY - height/2;
  float bestDist = 99999;
  int   bestE    = 0;
  for (int e = 0; e < NUM_EMITTERS; e++) {
    float d = dist(mx, my, emitX[e], emitY[e]);
    if (d < bestDist) { bestDist = d; bestE = e; }
  }
  int burst = 0;
  for (int i = 0; i < PART_COUNT && burst < 45; i++) {
    if (life[i] > 0.65) {
      spawnParticle(i);
      emitter[i] = bestE;
      tx[i] = emitX[bestE] + random(-3, 3);
      ty[i] = emitY[bestE] + random(-3, 3);
      float angle = random(TWO_PI);
      spdX[i] = cos(angle) * random(2.5, 5.5);
      spdY[i] = sin(angle) * random(2.5, 5.5) - random(1.5, 4.5);
      burst++;
    }
  }
  showHint  = true;
  hintTimer = frameCount;
}
