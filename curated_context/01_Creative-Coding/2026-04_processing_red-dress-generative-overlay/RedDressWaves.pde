// RED DRESS — hand sparklers + generative waves / steve elias / crcp 6310
// assignment 11: 3D generative geometry, part 1
//
// the model IS the ignition point. her hands are tracked frame-by-frame
// across all 55 gif frames using pixel-level analysis — sparklers erupt
// from exactly where her hands are, interpolated smoothly between frames.
//
// four layers composite together every draw cycle:
//   LAYER 1 — full gif (background, always clean)
//   LAYER 2 — generative wave pattern centered behind her torso
//   LAYER 3 — transparent gif on top (model always visible above waves)
//   LAYER 4 — spark buffer composited with ADD blend for that fire glow
//
// spacebar: freeze hue | up/down: intensity | left/right: shift hue | click: magnet

import gifAnimation.*;

// i'm loading both gifs as frame arrays at startup so i can display
// any frame instantly with image() — no GifAnimation timing weirdness,
// no speed mismatch, both stay perfectly locked to the same counter
PImage[] fullFrames;
PImage[] transFrames;

PGraphics sparkLayer;

// — hand positions: surgically extracted from all 55 frames —
int[] lhx = {156,152,148,145,148,152,157,158,161,165,172,174,185,189,203,236,265,245,248,240,242,256,290,313,309,296,280,300,340,387,404,405,403,402,402,399,391,390,387,353,293,265,249,232,213,190,174,164,160,155,152,149,144,138,133};
int[] lhy = {148,153,161,166,167,168,172,180,187,195,201,204,207,200,160,119,108,105,111,116,125,139,160,176,194,202,215,221,213,192,189,188,184,180,180,184,190,190,190,222,225,212,199,187,180,178,171,159,142,135,137,144,151,154,155};
int[] rhx = {673,674,675,677,681,682,682,683,684,687,695,699,689,687,687,685,682,680,676,671,666,664,660,662,666,670,673,675,670,662,645,627,602,575,547,462,437,438,438,437,438,437,442,459,517,536,555,567,594,616,629,648,655,660,668};
int[] rhy = {168,171,173,174,175,177,179,181,183,186,191,194,195,200,202,203,203,204,204,203,201,198,189,184,180,181,184,191,200,208,210,217,222,225,220,197,183,180,178,175,172,169,170,177,180,162,138,118,102,97,95,92,96,104,111};

ArrayList<Particle> particles = new ArrayList<Particle>();

// — wave pattern variables —
float waveAngle = 0;
float a = 100;
float b = 130;

// — sparkler state —
float   hu            = 0;
boolean freezeHue     = false;
float   intensityMult = 1.0;
boolean magnet        = false;
PVector magnetPt      = new PVector(400, 241);

int   gifFrame    = 0;
int   lastFrameMs = 0;
int   MS_PER_FRAME = 41; // 1000/24 = 41.666ms — using 41 is closer and reduces drift over a full loop

float lx, ly, rx, ry;

void setup() {
  size(800, 482);
  frameRate(60);

  // i'm extracting every frame from both gifs into PImage arrays at startup.
  // this is the only reliable way to display a specific frame in Processing —
  // GifAnimation's internal timer keeps running even after pause() and jump(),
  // which is exactly what was causing the two gifs to drift out of sync.
  // i'm using Gif.getPImages() — the static method that extracts all frames
  // into a PImage array in one shot. no playback thread, no timing drift,
  // both arrays index off the same gifFrame counter so they can never desync
  fullFrames  = Gif.getPImages(this, "red_dress_loop-GIF.gif");
  transFrames = Gif.getPImages(this, "Seed GIF with NO Background.gif");
  println("Loaded " + fullFrames.length + " full frames, " + transFrames.length + " trans frames");

  // i'm initializing sparkLayer with solid black — transparent start
  // breaks blendMode(ADD) and causes the whole buffer to glitch
  sparkLayer = createGraphics(width, height);
  sparkLayer.beginDraw();
  sparkLayer.background(0);
  sparkLayer.endDraw();

  colorMode(HSB, 360, 255, 255, 255);
  hu = random(360);
  lastFrameMs = millis();
}

void draw() {

  // ═══ STEP 1: ADVANCE FRAME COUNTER AT EXACTLY 24FPS ═══════════
  // i'm using fullFrames.length as the master length — the background gif
  // is the source of truth. hardcoding 55 was dangerous because the
  // transparent gif might have a different count due to export differences.
  // using the actual array length means the counter can never go out of bounds.
  int masterLength = fullFrames.length;
  if (millis() - lastFrameMs >= MS_PER_FRAME) {
    gifFrame = (gifFrame + 1) % masterLength;
    lastFrameMs = millis();
  }

  // ═══ STEP 2: TEMPORAL INTERPOLATION — smooth hand tracking ════
  // i'm lerping between current and next frame hand coords based on
  // how far (0.0–1.0) we are through the 42ms window — this gives
  // 60fps smoothness from 24fps data, eliminating stutter completely
  float interp    = (float)(millis() - lastFrameMs) / MS_PER_FRAME;
  int   nextFrame = (gifFrame + 1) % 55;

  if (!magnet) {
    lx = lerp(lhx[gifFrame], lhx[nextFrame], interp);
    ly = lerp(lhy[gifFrame], lhy[nextFrame], interp);
    rx = lerp(rhx[gifFrame], rhx[nextFrame], interp);
    ry = lerp(rhy[gifFrame], rhy[nextFrame], interp);
  } else {
    // magnet mode — both sparklers smoothly follow the cursor
    lx = lerp(lx, magnetPt.x, 0.1);
    ly = lerp(ly, magnetPt.y, 0.1);
    rx = lerp(rx, magnetPt.x, 0.1);
    ry = lerp(ry, magnetPt.y, 0.1);
  }

  if (!freezeHue) hu = (hu + 0.5) % 360;

  // ═══ LAYER 1: FULL GIF AS BACKGROUND ══════════════════════════
  background(0);
  // i'm wrapping with fullFrames.length in case the gif isn't exactly 55
  image(fullFrames[gifFrame], 0, 0, width, height); // gifFrame is already clamped to masterLength

  // ═══ LAYER 2: GENERATIVE WAVE PATTERN BEHIND MODEL ════════════
  // i'm centering on (400,241) — roughly her torso — so the aura
  // radiates outward from behind her body, not a corner of the canvas
  pushMatrix();
  translate(400, 241);
  noStroke();
  for (int i = 0; i < 360; i++) {
    float x = sin(radians(i)) * (a + b * sin(radians(i) * waveAngle));
    float y = cos(radians(i)) * (a + b * sin(radians(i) * waveAngle));
    fill(0, 0, 255, 63); // soft white-blue glow in HSB
    ellipse(x, y, x / 2, x / 2);
  }
  waveAngle += 0.01;
  popMatrix();

  // ═══ LAYER 3: TRANSPARENT GIF — model always on top of waves ══
  // i'm using min() so if transGif has one fewer frame than fullGif
  // it just holds its last frame rather than throwing an array out of bounds
  int safeIndex = min(gifFrame, transFrames.length - 1);
  image(transFrames[safeIndex], 0, 0, width, height);

  // ═══ LAYER 4: SPARKS WITH ADDITIVE BLENDING ═══════════════════
  // blendMode(ADD) simulates real combustion — sparks overlapping
  // the red dress get brighter not darker, exactly like real fire
  updateSparks();
  blendMode(ADD);
  image(sparkLayer, 0, 0);
  blendMode(BLEND); // always reset so the hud text isn't affected

  // — minimal hud —
  colorMode(RGB, 255);
  fill(255, 255, 255, 40);
  noStroke(); textSize(9); textAlign(LEFT, BOTTOM);
  text("F:" + gifFrame + "  intensity:" + nf(intensityMult,1,1) +
       (freezeHue?" · FROZEN":"") + (magnet?" · MAGNET":""), 8, height-6);
  colorMode(HSB, 360, 255, 255, 255);
}

// ═══════════════════════════════════════════════════════════════════
// UPDATESPARKS — fades old trails, spawns new particles at both
// hands, steps physics, purges dead ones. all inside the isolated
// sparkLayer buffer so the gif layers underneath stay untouched.
// ═══════════════════════════════════════════════════════════════════
void updateSparks() {
  sparkLayer.beginDraw();
  sparkLayer.colorMode(HSB, 360, 255, 255, 255);

  // i'm using a semi-transparent black rect for the fade trail effect —
  // the original Japanese firework code trick, isolated to this buffer
  sparkLayer.noStroke();
  sparkLayer.fill(0, 25);
  sparkLayer.rect(0, 0, width, height);

  int burst = (int)(30 * intensityMult);
  for (int i = 0; i < burst; i++) {
    particles.add(new Particle(lx, ly, hu));               // left hand
    particles.add(new Particle(rx, ry, (hu + 25) % 360)); // right hand, hue offset
  }

  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle pt = particles.get(i);
    pt.step();
    pt.display(sparkLayer);
    if (dist(0, 0, pt.xv, pt.yv) < 0.15 || pt.y > height + 50) {
      particles.remove(i);
    }
  }

  // hard cap so we never drop frames from too many particles
  while (particles.size() > 6000) particles.remove(0);

  sparkLayer.endDraw();
}

void keyPressed() {
  if (key == ' ')       freezeHue = !freezeHue;
  if (keyCode == UP)    intensityMult = min(intensityMult + 0.2, 3.0);
  if (keyCode == DOWN)  intensityMult = max(intensityMult - 0.2, 0.1);
  if (keyCode == RIGHT) hu = (hu + 40) % 360;
  if (keyCode == LEFT)  hu = (hu - 40 + 360) % 360;
}
void mousePressed() { magnet = !magnet; magnetPt.set(mouseX, mouseY); }
void mouseDragged() { if (magnet) magnetPt.set(mouseX, mouseY); }

// ═══════════════════════════════════════════════════════════════════
// PARTICLE — each spark is its own object. born at a hand position,
// fires in a random direction, draws as a line from previous to
// current position — that streak IS the sparkler look. gravity arcs
// it downward, friction slows it until it dies. lives entirely inside
// the sparkLayer buffer, never drawn to the main canvas directly.
// ═══════════════════════════════════════════════════════════════════
class Particle {
  float x, px, y, py, xv, yv, sz;
  float gravity  = 0.18; // pulls the arc naturally downward
  float friction = 0.96; // bleeds off speed like air resistance
  color col;

  Particle(float startX, float startY, float hue) {
    x = px = startX;
    y = py = startY;
    float dir = random(TWO_PI);
    float mag = random(1.0, 5.0);
    xv = mag * cos(dir);
    yv = mag * sin(dir);
    sz  = random(1, 3);
    // i'm varying saturation so sparks have depth — some vivid, some softer
    col = color(hue, random(100, 200), 255);
  }

  void step() {
    px = x; py = y;
    x += xv; y += yv;
    yv += gravity;
    xv *= friction;
    yv *= friction;
  }

  void display(PGraphics pg) {
    pg.strokeWeight(sz);
    pg.stroke(col);
    pg.noFill();
    pg.line(px, py, x, y); // line from prev → current = the sparkler streak
  }
}
