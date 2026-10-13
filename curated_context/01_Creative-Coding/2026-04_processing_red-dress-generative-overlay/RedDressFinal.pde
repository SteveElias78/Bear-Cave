// red dress — crescent murmuration + directional fluid — steve elias / crcp 6310
// i'm using frame-by-frame motion data to drive three distinct effects:
// FRAMES 0-23:  dress sweeps RIGHT → crescent forms on RIGHT trailing edge
// FRAMES 24-39: dress sweeps LEFT  → crescent forms on LEFT trailing edge  
// FRAMES 40-48: dress sweeps UP    → sonic burst ring expands from center
// FRAMES 49-54: settling back      → flock disperses and reforms
// the fluid shader now knows the sweep direction and leans accordingly
// canvas: 800x482 matching the GIF exactly — no scaling artifacts

import gifAnimation.*;

Gif redDress;
PShader fluidShader;

// — motion data from surgical frame analysis —
// i'm encoding the direction and magnitude for all 55 frames
// +1=right, -1=left, 0=up/still, 2=up-burst
int[] frameDir   = {0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,-1,-1,-1,-1,-1,1,1,-1,-1,-1,-1,-1,-1,-1,-1,-1,2,2,2,2,2,2,2,2,2,1,1,1,0,0,0};
float[] frameMag = {0,0,.4f,.5f,.5f,.7f,.4f,.7f,.6f,.7f,.8f,.6f,1f,.7f,.7f,1f,1f,.8f,.7f,.4f,.8f,.9f,.8f,.7f,.4f,.7f,.6f,.7f,.8f,.6f,.2f,.9f,1f,1f,1f,.9f,1f,.8f,.6f,.7f,.9f,1f,1f,1f,.9f,.8f,.8f,.9f,1f,.6f,.5f,.7f,.6f,.5f,.4f};

// — flock state —
int FLOCK_SIZE = 2800;
Boid[] flock;
ArrayList<PVector> dressShape = new ArrayList<PVector>();
ArrayList<PVector> hemShape   = new ArrayList<PVector>();
PVector dressCenter = new PVector(400, 241);

// — crescent formations —
ArrayList<CrescentWave> crescents = new ArrayList<CrescentWave>();
ArrayList<SonicBurst>   bursts    = new ArrayList<SonicBurst>();

float time = 0;
int fc = 0;
int gifFrame = 0;
int lastGifMs = 0;
int GIF_FPS_MS = 42; // i'm matching 24fps gif timing

// — motion smoothing —
float smoothDir = 0;
float smoothMag = 0;
int lastBurstFrame = -30;
int lastCrescentFrame = -10;

void setup() {
  size(800, 482, P2D);
  frameRate(60);

  redDress = new Gif(this, "red_dress_loop-GIF.gif");
  redDress.loop();

  fluidShader = loadShader("fluid.glsl");

  flock = new Boid[FLOCK_SIZE];
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock[i] = new Boid(random(150, 650), random(60, 480), i);
  }
  smooth(8);
}

void draw() {
  background(10, 8, 14);
  time += 0.018;
  fc++;

  // i'm advancing gif frame in sync with its native 24fps timing
  if (millis() - lastGifMs > GIF_FPS_MS) {
    gifFrame = (gifFrame + 1) % 55;
    lastGifMs = millis();
  }

  // i'm reading surgical motion data for this exact frame
  int dir = frameDir[gifFrame];
  float mag = frameMag[gifFrame];
  smoothDir = lerp(smoothDir, dir, 0.15);
  smoothMag = lerp(smoothMag, mag, 0.15);

  // — LAYER 1: GIF with directional fluid shader —
  fluidShader.set("uTime", millis() / 1000.0);
  fluidShader.set("uSweepDir", smoothDir);
  fluidShader.set("uSweepMag", smoothMag);
  shader(fluidShader);
  image(redDress, 0, 0, width, height);
  resetShader();

  // — sample dress shape every 6 frames —
  if (fc % 6 == 0) sampleDressShape();

  // — TRIGGER: crescent wave on strong sweep —
  if (mag > 0.7 && (dir == 1 || dir == -1) && fc - lastCrescentFrame > 18) {
    crescents.add(new CrescentWave(dressCenter.x, dressCenter.y, dir, mag));
    lastCrescentFrame = fc;
  }

  // — TRIGGER: sonic burst on upward apex (frames 40-48) —
  if (dir == 2 && mag > 0.85 && fc - lastBurstFrame > 40) {
    bursts.add(new SonicBurst(dressCenter.x, dressCenter.y));
    lastBurstFrame = fc;
  }

  // — LAYER 2: crescent waves —
  for (int i = crescents.size() - 1; i >= 0; i--) {
    CrescentWave c = crescents.get(i);
    c.update(); c.display();
    if (c.isDead()) crescents.remove(i);
  }

  // — LAYER 3: sonic bursts —
  for (int i = bursts.size() - 1; i >= 0; i--) {
    SonicBurst b = bursts.get(i);
    b.update(); b.display();
    if (b.isDead()) bursts.remove(i);
  }

  // — LAYER 4: murmuration boids —
  for (int i = 0; i < FLOCK_SIZE; i++) {
    flock[i].setSweep(smoothDir, smoothMag);
    flock[i].flock(flock);
    flock[i].update();
    flock[i].display();
  }
}

void sampleDressShape() {
  dressShape.clear(); hemShape.clear();
  PImage frame = redDress.get();
  frame.loadPixels();
  float scaleX = 800.0 / frame.width;
  float scaleY = 482.0 / frame.height;
  float cx = 0, cy = 0, count = 0;
  for (int x = 0; x < frame.width; x += 5) {
    for (int y = 0; y < frame.height; y += 5) {
      int idx = y * frame.width + x;
      if (idx >= frame.pixels.length) continue;
      color c = frame.pixels[idx];
      float r = red(c), g = green(c), b = blue(c);
      if (r > 140 && r > g * 1.75 && r > b * 1.75) {
        float px = x * scaleX, py = y * scaleY;
        dressShape.add(new PVector(px, py));
        cx += px; cy += py; count++;
        if (y > frame.height * 0.5) hemShape.add(new PVector(px, py));
      }
    }
  }
  if (count > 0) { dressCenter.x = cx/count; dressCenter.y = cy/count; }
}

// ═══════════════════════════════════════════════════════════
// CRESCENT WAVE — birds organize into a crescent arc that
// trails the sweep direction like a comet tail of starlings
// ═══════════════════════════════════════════════════════════
class CrescentWave {
  PVector origin;
  int direction; // +1 right, -1 left
  float mag, life, maxLife;
  ArrayList<CrescentBird> birds = new ArrayList<CrescentBird>();
  int BIRD_COUNT = 120;

  CrescentWave(float x, float y, int dir, float m) {
    origin = new PVector(x, y);
    direction = dir;
    mag = m;
    maxLife = 90;
    life = maxLife;

    // i'm building the crescent arc — birds placed along a curved arc
    // that trails opposite to the sweep direction
    float arcCenter = dir == 1 ? x + 80 : x - 80;
    float arcRadius = 120 + mag * 80;

    for (int i = 0; i < BIRD_COUNT; i++) {
      float t = map(i, 0, BIRD_COUNT, -HALF_PI * 0.9, HALF_PI * 0.9);
      // i'm curving the crescent so the tips point toward the sweep direction
      float bx = arcCenter + sin(t) * arcRadius * (dir == 1 ? -1 : 1);
      float by = y + cos(t) * arcRadius * 0.55;
      // i'm staggering the birds so the crescent has density variation
      float scatter = random(8, 25);
      bx += random(-scatter, scatter);
      by += random(-scatter * 0.5, scatter * 0.5);
      birds.add(new CrescentBird(bx, by, dir, t, i));
    }
  }

  void update() { life--; for (CrescentBird b : birds) b.update(life/maxLife); }

  void display() {
    float alpha = map(life, 0, maxLife, 0, 1);
    // i'm fading in fast and out slow for a natural feel
    float fadeIn = life > maxLife * 0.85 ? map(life, maxLife, maxLife*0.85, 0, 1) : 1.0;
    float fadeOut = life < 20 ? map(life, 0, 20, 0, 1) : 1.0;
    float finalAlpha = alpha * fadeIn * fadeOut;
    for (CrescentBird b : birds) b.display(finalAlpha);
  }

  boolean isDead() { return life <= 0; }
}

class CrescentBird {
  PVector pos, vel;
  float sz, wingPhase, arcT, hue;
  int dir, idx;
  PVector target;

  CrescentBird(float x, float y, int d, float t, int i) {
    pos = new PVector(random(width * 0.2, width * 0.8), random(height * 0.2, height * 0.8));
    target = new PVector(x, y);
    vel = new PVector(0, 0);
    dir = d; arcT = t; idx = i;
    sz = random(2.5, 5.0);
    wingPhase = random(TWO_PI) + i * 0.15;
    hue = random(0.8, 1.0);
  }

  void update(float lifeFrac) {
    // i'm flying birds toward their crescent position
    PVector desired = PVector.sub(target, pos);
    float d = desired.mag();
    desired.normalize();
    desired.mult(min(d * 0.12, 5.5));
    vel.add(desired);
    vel.mult(0.88);
    pos.add(vel);
    wingPhase += 0.18 + vel.mag() * 0.05;
  }

  void display(float alpha) {
    float speed = vel.mag();
    float angle = atan2(vel.y, vel.x);
    float wing = sin(wingPhase) * 0.45;
    // i'm making crescent birds gold-scarlet — distinct from the main flock
    float r = 255;
    float g = 140 + hue * 60;
    float b = 20;
    float a = alpha * map(speed, 0, 5, 160, 255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    noStroke();
    fill(r, g, b, a);
    ellipse(0, 0, sz * 2.8, sz);
    fill(r * 0.85, g * 0.7, b * 0.3, a * 0.88);
    triangle(0,0,-sz*2.4,wing*sz*2.2,-sz*0.4,sz*0.55);
    triangle(0,0, sz*2.4,wing*sz*2.2, sz*0.4,sz*0.55);
    // i'm adding a glitter highlight on crescent birds
    fill(255, 240, 180, a * 0.5);
    ellipse(-sz*0.2, -sz*0.15, sz*0.6, sz*0.3);
    popMatrix();
  }
}

// ═══════════════════════════════════════════════════════════
// SONIC BURST — glittering crescent ring that expands from
// the dress center when she sweeps upward at the apex
// layered rings with gold/white glitter particles
// ═══════════════════════════════════════════════════════════
class SonicBurst {
  PVector origin;
  float life, maxLife;
  ArrayList<GlitterParticle> glitter = new ArrayList<GlitterParticle>();
  float[] ringR;
  float[] ringMaxR;
  int RINGS = 4;

  SonicBurst(float x, float y) {
    origin = new PVector(x, y);
    maxLife = 80;
    life = maxLife;
    ringR = new float[RINGS];
    ringMaxR = new float[RINGS];
    for (int i = 0; i < RINGS; i++) {
      ringR[i] = 0;
      ringMaxR[i] = 140 + i * 55;
    }
    // i'm spawning glitter particles in a burst pattern
    for (int i = 0; i < 200; i++) {
      float angle = random(TWO_PI);
      float speed = random(1.5, 6.0);
      glitter.add(new GlitterParticle(x, y, cos(angle)*speed, sin(angle)*speed));
    }
  }

  void update() {
    life--;
    for (int i = 0; i < RINGS; i++) {
      // i'm expanding each ring at a slightly different speed
      float targetR = map(life, maxLife, 0, 0, ringMaxR[i]);
      ringR[i] = lerp(ringR[i], targetR, 0.12);
    }
    for (int i = glitter.size()-1; i >= 0; i--) {
      glitter.get(i).update();
      if (glitter.get(i).isDead()) glitter.remove(i);
    }
  }

  void display() {
    float alpha = map(life, 0, maxLife, 0, 200);
    float fadeIn = life > maxLife*0.9 ? map(life, maxLife, maxLife*0.9, 0, 1) : 1.0;

    // i'm drawing concentric crescent-shaped rings — not full circles
    // they're wider at top, compressed at bottom like a crown
    noFill();
    for (int i = 0; i < RINGS; i++) {
      float r = ringR[i];
      if (r < 2) continue;
      float ringAlpha = alpha * fadeIn * map(i, 0, RINGS, 1.0, 0.4);
      // i'm drawing the ring as a series of arc segments for the crescent shape
      stroke(255, 220, 120, ringAlpha);
      strokeWeight(2.5 - i * 0.4);
      // full ellipse but compressed vertically for crescent crown feel
      ellipse(origin.x, origin.y, r * 2.2, r * 1.4);
      // i'm adding a second thinner ring slightly offset
      stroke(255, 255, 200, ringAlpha * 0.5);
      strokeWeight(0.8);
      ellipse(origin.x, origin.y - r*0.1, r * 2.0, r * 1.2);
    }
    strokeWeight(1);
    noStroke();

    // i'm drawing glitter particles
    for (GlitterParticle g : glitter) g.display();
  }

  boolean isDead() { return life <= 0; }
}

class GlitterParticle {
  PVector pos, vel;
  float life, maxLife, sz;
  color col;

  GlitterParticle(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    maxLife = random(30, 65);
    life = maxLife;
    sz = random(1.5, 4.5);
    // i'm varying between gold, white, and warm scarlet glitter
    float type = random(1);
    if (type > 0.6) col = color(255, 240, 160); // gold
    else if (type > 0.3) col = color(255, 255, 230); // white
    else col = color(255, 130, 80); // warm scarlet
  }

  void update() {
    vel.y += 0.06; // gentle gravity
    vel.mult(0.97);
    pos.add(vel);
    life--;
  }

  void display() {
    float alpha = map(life, 0, maxLife, 0, 220);
    float flicker = sin(life * 0.8) * 0.3 + 0.7; // i'm making glitter shimmer
    noStroke();
    fill(red(col), green(col), blue(col), alpha * flicker);
    ellipse(pos.x, pos.y, sz, sz);
    // i'm adding a bright center to larger glitter pieces
    if (sz > 3) {
      fill(255, 255, 255, alpha * flicker * 0.7);
      ellipse(pos.x, pos.y, sz * 0.4, sz * 0.4);
    }
  }

  boolean isDead() { return life <= 0 || pos.y > height + 20; }
}

// ═══════════════════════════════════════════════════════════
// BOID CLASS — scarlet starlings, sweep-aware murmuration
// ═══════════════════════════════════════════════════════════
class Boid {
  PVector pos, vel, acc;
  float maxForce = 0.09, maxSpeed = 4.0;
  int id;
  float wingPhase, sz, hue;
  PVector target;
  float targetTimer;
  boolean isOrbiter;
  float sweepDir = 0, sweepMag = 0;

  Boid(float x, float y, int id) {
    pos = new PVector(x, y);
    vel = PVector.random2D(); vel.mult(random(1.5, 3.0));
    acc = new PVector(0, 0);
    this.id = id;
    wingPhase = random(TWO_PI);
    sz = random(2.0, 4.0);
    hue = random(0.75, 1.0);
    target = new PVector(x, y);
    targetTimer = random(80);
    isOrbiter = (id % 4 == 0);
  }

  void setSweep(float dir, float mag) { sweepDir = dir; sweepMag = mag; }

  void flock(Boid[] boids) {
    PVector sep = separate(boids), ali = align(boids);
    PVector coh = cohesion(boids), att = attractToDress();
    sep.mult(1.6); ali.mult(1.0); coh.mult(0.85);
    att.mult(isOrbiter ? 1.1 : 2.4);

    // i'm adding sweep-driven wave — flock leans in the sweep direction
    float waveX = sin(time*1.8 + pos.y*0.012) * 0.22 + sweepDir * sweepMag * 0.3;
    float waveY = cos(time*1.4 + pos.x*0.010) * 0.18;
    acc.add(new PVector(waveX, waveY));
    acc.add(sep); acc.add(ali); acc.add(coh); acc.add(att);
  }

  PVector attractToDress() {
    targetTimer--;
    if (targetTimer <= 0) {
      if (isOrbiter && hemShape.size() > 0) {
        target = hemShape.get((int)random(hemShape.size())).copy();
        PVector out = PVector.sub(target, dressCenter);
        out.normalize(); out.mult(random(25, 85));
        target.add(out);
      } else if (dressShape.size() > 0) {
        target = dressShape.get((int)random(dressShape.size())).copy();
        target.x += random(-12,12); target.y += random(-10,10);
      }
      targetTimer = random(50, 110);
    }
    PVector desired = PVector.sub(target, pos);
    float d = desired.mag();
    desired.normalize(); desired.mult(d < 60 ? map(d,0,60,0.4,maxSpeed) : maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce * (isOrbiter ? 1.0 : 1.5));
    return steer;
  }

  PVector separate(Boid[] boids) {
    PVector steer = new PVector(0,0); int count = 0;
    for (int i=max(0,id-25); i<min(boids.length,id+25); i++) {
      if (i==id) continue;
      float d = PVector.dist(pos, boids[i].pos);
      if (d>0 && d<16) { PVector diff=PVector.sub(pos,boids[i].pos); diff.normalize(); diff.div(d); steer.add(diff); count++; }
    }
    if (count>0) { steer.div(count); steer.normalize(); steer.mult(maxSpeed); steer.sub(vel); steer.limit(maxForce); }
    return steer;
  }

  PVector align(Boid[] boids) {
    PVector sum = new PVector(0,0); int count = 0;
    for (int i=max(0,id-18); i<min(boids.length,id+18); i++) {
      if (i==id) continue;
      if (PVector.dist(pos,boids[i].pos)<38) { sum.add(boids[i].vel); count++; }
    }
    if (count>0) { sum.div(count); sum.normalize(); sum.mult(maxSpeed); PVector s=PVector.sub(sum,vel); s.limit(maxForce); return s; }
    return new PVector(0,0);
  }

  PVector cohesion(Boid[] boids) {
    PVector sum = new PVector(0,0); int count = 0;
    for (int i=max(0,id-18); i<min(boids.length,id+18); i++) {
      if (i==id) continue;
      if (PVector.dist(pos,boids[i].pos)<50) { sum.add(boids[i].pos); count++; }
    }
    if (count>0) { sum.div(count); return seek(sum); }
    return new PVector(0,0);
  }

  PVector seek(PVector t) {
    PVector d=PVector.sub(t,pos); d.normalize(); d.mult(maxSpeed);
    PVector s=PVector.sub(d,vel); s.limit(maxForce); return s;
  }

  void update() {
    vel.add(acc); vel.limit(maxSpeed); pos.add(vel); acc.mult(0);
    wingPhase += 0.16 + vel.mag()*0.04;
    if (pos.x<-30) pos.x=width+30; if (pos.x>width+30) pos.x=-30;
    if (pos.y<-30) pos.y=height+30; if (pos.y>height+30) pos.y=-30;
  }

  void display() {
    float speed = vel.mag(), angle = atan2(vel.y, vel.x);
    float wing = sin(wingPhase)*0.45;
    pushMatrix(); translate(pos.x, pos.y); rotate(angle);
    float r  = isOrbiter ? 235+hue*20 : 210+hue*45;
    float g  = isOrbiter ? 80+speed*8  : 18+speed*5;
    float bv = isOrbiter ? 20 : 10+speed*2;
    float alpha = map(speed,0,maxSpeed,150,255);
    noStroke();
    fill(r,g,bv,alpha); ellipse(0,0,sz*2.8,sz);
    fill(r*.82,g*.6,bv*.5,alpha*.88);
    triangle(0,0,-sz*2.4,wing*sz*2.2,-sz*.4,sz*.55);
    triangle(0,0, sz*2.4,wing*sz*2.2, sz*.4,sz*.55);
    if (speed>2.5) { fill(255,220,190,alpha*.28); ellipse(-sz*.25,-sz*.18,sz*.55,sz*.28); }
    popMatrix();
  }
}
