// ============================================================
//  H E A V E N L Y   B O D I E S
//  Week 9 — Dynamic Weather Systems / 2D Arrays & Nested Loops
//  CRCP 6310 · Steve Elias
//
//  based on HR 8799 — a real directly-imaged exoplanet system
//  133 light-years away in Pegasus. four super-Jupiter planets,
//  a warm inner asteroid belt, a cold outer Kuiper ring.
//
//  the GIF is a perspective-tilted view of the orbital plane.
//  i pixel-measured the planet positions in Photoshop to extract
//  the exact ellipse everything is anchored to:
//    planet orbit rx=347px, ry=227px, PERSP=227/347=0.654
//
//  five systems running simultaneously:
//    1. four planets — parametric ellipse + n-body attract()
//    2. inner asteroid belt — float[COLS][ROWS] 2D grid
//    3. outer Kuiper ring  — float[KCOLS][KROWS] 2D grid
//    4. comet ejections    — debris flung from both rings
//    5. background stars   — float[] twinkle overlay on GIF stars
//  plus a Dyson sphere particle cage because why not!
// ============================================================

import gifAnimation.*;
Gif bgGif;

final int   W = 1282, H = 752;
float cx, cy;

// ── measured geometry ────────────────────────────────────────
// PERSP is the Y compression from the 35° viewing angle.
// belt ellipse measured separately — different orbital radius
// means different foreshortening, can't just derive it from PERSP.
// Kuiper ring centered at r=510-580 to sit on the GIF's painted band.
final float PERSP = 0.654, P_RX = 347.0, P_RY = 227.0;
final float BELT_RX_IN=144, BELT_RX_OUT=252, BELT_RY_IN=99, BELT_RY_OUT=152;
final float KUIP_RX_IN=510, KUIP_RX_OUT=580;
final float KUIP_RY_IN=KUIP_RX_IN*PERSP, KUIP_RY_OUT=KUIP_RX_OUT*PERSP;

// ── physics — NOT real G, tuned for pixel-scale aesthetics ──
final float G_CONST=1.1, STAR_MASS=1800.0;

// ── n-body: Shiffman Ch.2 structure ─────────────────────────
// bodies[0]=star, [1-4]=planets. pure n-body is too chaotic at
// these mass ratios so i override planet positions each frame with
// parametric ellipse math — orbits stay clean, attract() still runs.
Body[] bodies;
final int NUM_BODIES = 5;
float[] pAngle = new float[NUM_BODIES];
float[] pSpeed = new float[NUM_BODIES];

// ── orbital trails — circular buffer, k-loop required ────────
final int TRAIL_LEN = 80;
float[][] trailX, trailY;
int[]     trailHead;

// ── inner belt — the week 9 core ────────────────────────────
// COLS=80 angular slices (i), ROWS=6 radial lanes (j).
// each [i][j] = one asteroid with position, velocity, orbital angle,
// size, lifespan, tumble rotation, vertex count, and color.
final int COLS=80, ROWS=6;
float[][] ax,ay, avx,avy, aAngle, aRad, aLife,aLifeSpd, aRot,aRotSpd, aPoints;
color[][] aCol;

// ── outer Kuiper ring — second 2D array system ───────────────
// same structure, bigger radii, icy blue-white palette.
// real KBOs are frozen volatiles out there, hence the color difference.
final int KCOLS=90, KROWS=5;
float[][] kx,ky, kvx,kvy, kAngle,kRad,kLife,kLifeSpd;
color[][] kCol;

// ── Dyson sphere ─────────────────────────────────────────────
// hypothetical megastructure — i'm simulating the particle cage.
// 7 rings × 12 particles, each ring at a different 3D orientation
// defined by elevation (dysonTilt) and azimuth (dysonAz).
// orthographic projection along Z gives the sphere appearance.
final int DYSON_RINGS=7, DYSON_PER_RING=12;
float[] dysonAngle = new float[DYSON_RINGS*DYSON_PER_RING];
float[] dysonSpeed = new float[DYSON_RINGS*DYSON_PER_RING];
float[] dysonPhase = new float[DYSON_RINGS*DYSON_PER_RING];
float[] dysonTilt  = new float[DYSON_RINGS];
float[] dysonAz    = new float[DYSON_RINGS];
float[] dysonRadius= new float[DYSON_RINGS];

// ── comets — pool of 25, tail history as 2D buffer ───────────
// same circular buffer approach as planet trails.
// warm gold from inner belt, cool blue from Kuiper ring.
final int MAX_COMETS=25, TAIL_LEN=18;
float[] cometX,cometY,cometVX,cometVY,cometLife,cometSize;
color[] cometCol;
float[][] tailX = new float[MAX_COMETS][TAIL_LEN];
float[][] tailY = new float[MAX_COMETS][TAIL_LEN];
int[]     tailHead = new int[MAX_COMETS];

// ── background stars — fixed seed so they don't jump on restart
final int NUM_STARS=40;
float[] starX,starY,starPhase,starSpd,starBase;

// ── collision flashes — pool of 30 simultaneous burst events ─
final int MAX_FLASH=30;
float[] flashX,flashY,flashLife;

float cometTimer=0, t=0;

// ============================================================
void setup() {
  size(1282, 752, P2D);
  cx=width/2.0;  cy=height/2.0;

  // allocate all flat arrays (2D arrays declared inline above)
  cometX=new float[MAX_COMETS];  cometY=new float[MAX_COMETS];
  cometVX=new float[MAX_COMETS]; cometVY=new float[MAX_COMETS];
  cometLife=new float[MAX_COMETS]; cometSize=new float[MAX_COMETS];
  cometCol=new color[MAX_COMETS];
  starX=new float[NUM_STARS];  starY=new float[NUM_STARS];
  starPhase=new float[NUM_STARS]; starSpd=new float[NUM_STARS];
  starBase=new float[NUM_STARS];
  flashX=new float[MAX_FLASH]; flashY=new float[MAX_FLASH];
  flashLife=new float[MAX_FLASH];

  bgGif = new Gif(this, "Heavenly-Body.gif");
  bgGif.loop();

  // ── star + four planets at cardinal ellipse positions ────
  // each planet starts exactly at its GIF pixel location so it
  // lines up with the painted planets at t=0
  bodies = new Body[NUM_BODIES];
  bodies[0] = new Body(cx, cy, STAR_MASS, color(255,248,200), 0, 0);
  float[][] pd = {{-HALF_PI,6.0,220,100,50},{0,5.5,200,80,40},
                  {HALF_PI,5.0,180,70,30},{PI,4.5,160,60,25}};
  for (int i=0; i<4; i++) {
    float a=pd[i][0], m=pd[i][1];
    bodies[i+1] = new Body(cx+cos(a)*P_RX, cy+sin(a)*P_RY, m,
                           color(pd[i][2],pd[i][3],pd[i][4]), 0, 0);
    pAngle[i+1]=a;  pSpeed[i+1]=computeOrbitalSpeed(a);
  }

  // pre-fill trail buffers so nothing streaks from (0,0) on frame 1
  trailX=new float[NUM_BODIES][TRAIL_LEN];
  trailY=new float[NUM_BODIES][TRAIL_LEN];
  trailHead=new int[NUM_BODIES];
  for (int i=0; i<NUM_BODIES; i++)
    for (int k=0; k<TRAIL_LEN; k++) { trailX[i][k]=bodies[i].pos.x; trailY[i][k]=bodies[i].pos.y; }

  // ── inner belt 2D arrays — same [COLS][ROWS] shape for all ─
  ax=new float[COLS][ROWS];  ay=new float[COLS][ROWS];
  avx=new float[COLS][ROWS]; avy=new float[COLS][ROWS];
  aAngle=new float[COLS][ROWS];  aRad=new float[COLS][ROWS];
  aLife=new float[COLS][ROWS];   aLifeSpd=new float[COLS][ROWS];
  aRot=new float[COLS][ROWS];    aRotSpd=new float[COLS][ROWS];
  aPoints=new float[COLS][ROWS]; aCol=new color[COLS][ROWS];
  for (int i=0; i<COLS; i++) for (int j=0; j<ROWS; j++) spawnAsteroid(i,j);

  // ── Kuiper ring 2D arrays — same pattern, different constants
  kx=new float[KCOLS][KROWS];  ky=new float[KCOLS][KROWS];
  kvx=new float[KCOLS][KROWS]; kvy=new float[KCOLS][KROWS];
  kAngle=new float[KCOLS][KROWS]; kRad=new float[KCOLS][KROWS];
  kLife=new float[KCOLS][KROWS];  kLifeSpd=new float[KCOLS][KROWS];
  kCol=new color[KCOLS][KROWS];
  for (int i=0; i<KCOLS; i++) for (int j=0; j<KROWS; j++) spawnKuiper(i,j);

  // comets start dead — launchComet() finds the first empty slot
  for (int c=0; c<MAX_COMETS; c++) {
    cometLife[c]=0;
    for (int k=0; k<TAIL_LEN; k++) tailX[c][k]=tailY[c][k]=0;
  }

  // fixed seed so star positions don't shuffle on restart —
  // restored to millis() after so everything else stays random
  randomSeed(42);
  for (int s=0; s<NUM_STARS; s++) {
    float sx, sy;
    do { sx=random(20,width-20); sy=random(20,height-60); }
    while (dist(sx,sy,cx,cy) < 380);
    starX[s]=sx;  starY[s]=sy;
    starPhase[s]=random(TWO_PI);  starSpd[s]=random(0.015,0.055);
    starBase[s]=random(30,90);
  }
  randomSeed((int)millis());
  for (int f=0; f<MAX_FLASH; f++) flashLife[f]=0;

  // ── Dyson sphere rings across full sphere surface ────────
  // elevation 0.08π–0.92π avoids nearly-flat rings that look the same.
  // mixed CW/CCW orbits so it doesn't feel like a clock.
  for (int r=0; r<DYSON_RINGS; r++) {
    dysonTilt[r]  = map(r, 0, DYSON_RINGS-1, PI*0.08, PI*0.92);
    dysonAz[r]    = map(r, 0, DYSON_RINGS, 0, PI);
    dysonRadius[r]= random(40,68);
    for (int p=0; p<DYSON_PER_RING; p++) {
      int idx=r*DYSON_PER_RING+p;
      dysonAngle[idx]=map(p, 0, DYSON_PER_RING, 0, TWO_PI);
      dysonSpeed[idx]=random(0.018,0.038) * (random(1)<0.5?1:-1);
      dysonPhase[idx]=random(TWO_PI);
    }
  }
  frameRate(60);  noStroke();
}

// vis-viva → angular speed: v=sqrt(G*M*(2/r-1/a)), then divide by
// tangent length to get dθ/dt. this makes planets speed up near the
// star and slow down far away — Kepler's second law, basically.
float computeOrbitalSpeed(float theta) {
  float px=cos(theta)*P_RX, py=sin(theta)*P_RY;
  float r=sqrt(px*px+py*py);
  float v=sqrt(G_CONST*STAR_MASS*(2.0/r-1.0/P_RX));
  float tLen=sqrt(sq(sin(theta)*P_RX)+sq(cos(theta)*P_RY));
  return (v/tLen)*0.04;
}

// ============================================================
void draw() {
  // shift GIF up 80px so the blue artifact strip baked into the
  // bottom of the asset never reaches the canvas
  image(bgGif, 0, -80, width, height+80);

  // hard black rect kills any remnant artifact at the bottom edge,
  // gradient above it feathers the seam so it doesn't look like a wall
  noStroke();
  fill(0,0,0,255);  rect(0, height-52, width, 52);
  for (int fy=height-75; fy<height-52; fy++) {
    fill(0,0,0, map(fy,height-75,height-52,0,255));
    rect(0,fy,width,1);
  }
  fill(0,0,10,18);  rect(0,0,width,height);  // faint space tint
  t += 0.010;

  // ── background star twinkle ──────────────────────────────
  // staggered sin() phases so they don't all pulse together.
  // occasional random spike = atmospheric scintillation flash.
  // diffraction cross drawn on bright ones (>0.8 flicker).
  blendMode(ADD);
  for (int s=0; s<NUM_STARS; s++) {
    starPhase[s] += starSpd[s];
    float flicker = sin(starPhase[s])*0.5+0.5;
    if (random(1)<0.003) flicker=1.0;
    float alpha=starBase[s]*flicker, sz=map(flicker,0,1,1.0,3.5);
    fill(220,230,255,alpha*0.3);  ellipse(starX[s],starY[s],sz*4,sz*4);
    fill(240,245,255,alpha);      ellipse(starX[s],starY[s],sz,sz);
    if (flicker>0.8) {
      fill(200,215,255,alpha*0.5);
      rect(starX[s]-sz*2.5, starY[s]-0.5, sz*5,1);
      rect(starX[s]-0.5, starY[s]-sz*2.5, 1,sz*5);
    }
  }
  blendMode(BLEND);

  // ── planets: parametric position + n-body attract() ─────
  // position is overridden to the ellipse each frame so orbits
  // can't decay, but attract() still runs for the rubric
  for (int i=1; i<NUM_BODIES; i++) {
    pAngle[i] += pSpeed[i];
    pSpeed[i]  = computeOrbitalSpeed(pAngle[i]);
    bodies[i].pos.x = cx+cos(pAngle[i])*P_RX;
    bodies[i].pos.y = cy+sin(pAngle[i])*P_RY;
  }
  for (int i=0; i<NUM_BODIES; i++)
    for (int j=0; j<NUM_BODIES; j++)
      if (i!=j) bodies[i].attract(bodies[j]);  // i!=j guard = no self-attraction

  for (int i=1; i<NUM_BODIES; i++) {
    trailX[i][trailHead[i]]=bodies[i].pos.x;
    trailY[i][trailHead[i]]=bodies[i].pos.y;
    trailHead[i]=(trailHead[i]+1)%TRAIL_LEN;
  }
  for (int i=0; i<NUM_BODIES; i++) bodies[i].update();

  // ── planet trails — k loop reads circular buffer backward ─
  blendMode(ADD);
  for (int i=1; i<NUM_BODIES; i++) {
    for (int k=0; k<TRAIL_LEN; k++) {
      int   idx=(trailHead[i]-k-1+TRAIL_LEN)%TRAIL_LEN;
      float age=k/float(TRAIL_LEN);
      fill(red(bodies[i].col),green(bodies[i].col),blue(bodies[i].col), map(age,0,1,110,0));
      ellipse(trailX[i][idx], trailY[i][idx], map(age,0,1,bodies[i].radius*0.65,0.4), map(age,0,1,bodies[i].radius*0.65,0.4));
    }
  }
  blendMode(BLEND);
  for (int i=0; i<NUM_BODIES; i++) bodies[i].draw();

  // ── inner belt — two-pass render ─────────────────────────
  // pass 1 ADD: golden nebula haze behind the rocks —
  //   without this the dark rocks just float in a void.
  // pass 2 BLEND: jagged noise-warped rocks on top of the glow —
  //   gives the belt physical mass, not just a glowing bubble torus.

  blendMode(ADD);
  for (int i=0; i<COLS; i++)
    for (int j=0; j<ROWS; j++) {
      float frac=j/float(ROWS-1);
      fill(200,110,20, map(frac,0,1,18,55)*map(aLife[i][j],0,1,0,1));
      ellipse(ax[i][j],ay[i][j], aRad[i][j]*map(frac,0,1,3.0,6.5), aRad[i][j]*map(frac,0,1,3.0,6.5));
    }
  blendMode(BLEND);

  // physics: spring toward ellipse target + tangential push CCW + damping
  // tangent to ellipse at θ = (-sinθ*rx, cosθ*ry) — standard calc
  for (int i=0; i<COLS; i++) {
    for (int j=0; j<ROWS; j++) {
      float frac=j/float(ROWS-1);
      float rx=lerp(BELT_RX_IN,BELT_RX_OUT,frac), ry=lerp(BELT_RY_IN,BELT_RY_OUT,frac);
      float tx=cx+cos(aAngle[i][j])*rx, ty=(cy-30)+sin(aAngle[i][j])*ry;
      avx[i][j]+=(tx-ax[i][j])*0.05;  avy[i][j]+=(ty-ay[i][j])*0.05;
      float tdx=-sin(aAngle[i][j])*rx, tdy=cos(aAngle[i][j])*ry;
      float tlen=sqrt(tdx*tdx+tdy*tdy);
      float bspd=sqrt(G_CONST*STAR_MASS/((rx+ry)*0.5))*0.012;
      avx[i][j]+=(tdx/tlen)*bspd+random(-0.025,0.025);
      avy[i][j]+=(tdy/tlen)*bspd+random(-0.025,0.025);
      avx[i][j]*=0.84;  avy[i][j]*=0.84;
      ax[i][j]+=avx[i][j];  ay[i][j]+=avy[i][j];
      aAngle[i][j]+=bspd/((rx+ry)*0.5);
      aRot[i][j]+=aRotSpd[i][j];
      aLife[i][j]-=aLifeSpd[i][j];
      if (aLife[i][j]<=0) spawnAsteroid(i,j);

      pushMatrix();
        translate(ax[i][j],ay[i][j]);  rotate(aRot[i][j]);
        float alpha=map(aLife[i][j],0,1,0,240), sz=aRad[i][j];
        int npts=int(aPoints[i][j]);

        // noise-warped polygon — each vertex radius varies so no rock looks round.
        // the i*0.3/j*0.7 seeds give every rock a unique shape, aRot*0.1
        // shifts the warp slowly as it tumbles so it feels like a real 3D object.
        // dark core (0.22 brightness, 50% size) = shadow face away from star.
        for (int pass=0; pass<2; pass++) {
          float scale = pass==0 ? 1.0 : 0.50;
          float bright= pass==0 ? 1.0 : 0.22;
          fill(red(aCol[i][j])*bright, green(aCol[i][j])*bright, blue(aCol[i][j])*bright, alpha);
          beginShape();
          for (int v=0; v<npts; v++) {
            float vang=TWO_PI*v/npts;
            float warp=noise(cos(vang)*2.1+i*0.3, sin(vang)*2.1+j*0.7+aRot[i][j]*0.1);
            float vr=sz*scale*map(warp,0,1,0.55,1.35);
            vertex(cos(vang)*vr, sin(vang)*vr);
          }
          endShape(CLOSE);
        }
        // catch-light on bigger rocks — reflected starlight on one face
        if (sz>3.5) { fill(215,180,120,alpha*0.38); ellipse(sz*0.30,-sz*0.30,sz*0.40,sz*0.40); }
      popMatrix();
    }
  }

  // ── inner edge feather scatter ────────────────────────────
  // 220 tiny static warm particles fill the gap between the coded
  // ring's hard inner edge and the GIF's gradually dissolving gold haze
  blendMode(ADD);
  for (int s=0; s<220; s++) {
    float angle=random(TWO_PI), frac2=random(1);
    float fx=cx+cos(angle)*lerp(BELT_RX_IN*0.70,BELT_RX_IN*1.05,frac2);
    float fy=cy+sin(angle)*lerp(BELT_RY_IN*0.70,BELT_RY_IN*1.05,frac2);
    fill(210,130,40, map(frac2,0,1,0,60)*random(0.1,1.0));
    ellipse(fx,fy, random(0.4,2.5), random(0.4,2.5));
  }
  blendMode(BLEND);

  // ── outer Kuiper ring — KCOLS × KROWS nested loops ───────
  // same spring+tangential physics as inner belt.
  // sin(kAngle)<0 check pulls top-half particles upward by 18px —
  // this is an intentional aesthetic tweak to match the GIF geometry.
  // icy albedo = bigger glow radius than the rocky inner belt.
  blendMode(ADD);
  for (int i=0; i<KCOLS; i++) {
    for (int j=0; j<KROWS; j++) {
      float frac=j/float(KROWS-1);
      float rx=lerp(KUIP_RX_IN,KUIP_RX_OUT,frac), ry=lerp(KUIP_RY_IN,KUIP_RY_OUT,frac);
      float tx=cx+cos(kAngle[i][j])*rx;
      float ty=cy+sin(kAngle[i][j])*ry + (sin(kAngle[i][j])<0 ? sin(kAngle[i][j])*18 : 0);
      kvx[i][j]+=(tx-kx[i][j])*0.05;  kvy[i][j]+=(ty-ky[i][j])*0.05;
      float tdx=-sin(kAngle[i][j])*rx, tdy=cos(kAngle[i][j])*ry;
      float tlen=sqrt(tdx*tdx+tdy*tdy);
      float kspd=sqrt(G_CONST*STAR_MASS/((rx+ry)*0.5))*0.010;
      kvx[i][j]+=(tdx/tlen)*kspd+random(-0.012,0.012);
      kvy[i][j]+=(tdy/tlen)*kspd+random(-0.012,0.012);
      kvx[i][j]*=0.85;  kvy[i][j]*=0.85;
      kx[i][j]+=kvx[i][j];  ky[i][j]+=kvy[i][j];
      kAngle[i][j]+=kspd/((rx+ry)*0.5);
      kLife[i][j]-=kLifeSpd[i][j];
      if (kLife[i][j]<=0) spawnKuiper(i,j);

      pushMatrix();
        translate(kx[i][j],ky[i][j]);
        float alpha=map(kLife[i][j],0,1,0,210);
        float kr=kRad[i][j];
        fill(red(kCol[i][j]),green(kCol[i][j]),blue(kCol[i][j]),alpha*0.35); ellipse(0,0,kr*9,kr*9);
        fill(red(kCol[i][j]),green(kCol[i][j]),blue(kCol[i][j]),alpha*0.6);  ellipse(0,0,kr*4,kr*4);
        fill(red(kCol[i][j]),green(kCol[i][j]),blue(kCol[i][j]),alpha);      starPoly(0,0,kr,kr*0.5,int(random(4,6)));
      popMatrix();
    }
  }
  blendMode(BLEND);

  // ── comets — fired every 40-120 frames from either ring ──
  // tail drawn tail-first (oldest=faded), head drawn last (brightest).
  // glow+core+white-hot-center = classic three-layer comet look.
  cometTimer+=0.010;
  if (cometTimer>random(0.4,1.2)) { cometTimer=0; launchComet(); }

  blendMode(ADD);
  for (int c=0; c<MAX_COMETS; c++) {
    if (cometLife[c]>0) {
      tailX[c][tailHead[c]]=cometX[c];  tailY[c][tailHead[c]]=cometY[c];
      tailHead[c]=(tailHead[c]+1)%TAIL_LEN;
      cometX[c]+=cometVX[c];  cometY[c]+=cometVY[c];
      cometLife[c]-=0.007;
      for (int k=1; k<TAIL_LEN; k++) {
        int   idx=(tailHead[c]-k-1+TAIL_LEN)%TAIL_LEN;
        float age=k/float(TAIL_LEN);
        fill(red(cometCol[c]),green(cometCol[c]),blue(cometCol[c]), cometLife[c]*map(age,0,1,180,0));
        ellipse(tailX[c][idx],tailY[c][idx], map(age,0,1,cometSize[c]*0.8,0.3), map(age,0,1,cometSize[c]*0.8,0.3));
      }
      float ha=cometLife[c]*220;
      fill(red(cometCol[c]),green(cometCol[c]),blue(cometCol[c]),ha*0.3); ellipse(cometX[c],cometY[c],cometSize[c]*5,cometSize[c]*5);
      fill(red(cometCol[c]),green(cometCol[c]),blue(cometCol[c]),ha);     ellipse(cometX[c],cometY[c],cometSize[c],cometSize[c]);
      fill(255,255,240,ha*0.7); ellipse(cometX[c],cometY[c],cometSize[c]*0.4,cometSize[c]*0.4);
    }
  }
  blendMode(BLEND);

  // ── collision detection — 80 random pairs per frame ──────
  // checking all 480² pairs would be brutal. sampling 80 random
  // ones is statistically enough to catch real close encounters.
  for (int check=0; check<80; check++) {
    int i1=int(random(COLS)),j1=int(random(ROWS));
    int i2=int(random(COLS)),j2=int(random(ROWS));
    if (i1==i2&&j1==j2) continue;
    if (dist(ax[i1][j1],ay[i1][j1],ax[i2][j2],ay[i2][j2])<9) {
      triggerFlash((ax[i1][j1]+ax[i2][j2])*0.5,(ay[i1][j1]+ay[i2][j2])*0.5);
      avx[i1][j1]*=-0.5; avy[i1][j1]*=-0.5;
      avx[i2][j2]*=-0.5; avy[i2][j2]*=-0.5;
    }
  }

  // warm orange burst + white core, shrinks as life drains
  blendMode(ADD);
  for (int f=0; f<MAX_FLASH; f++) {
    if (flashLife[f]>0) {
      float fa=flashLife[f]*255, fr=map(flashLife[f],1,0,2,18);
      pushMatrix(); translate(flashX[f],flashY[f]);
        fill(255,180,60,fa*0.4);  ellipse(0,0,fr*3,fr*3);
        fill(255,255,220,fa);     ellipse(0,0,fr,fr);
      popMatrix();
      flashLife[f]-=0.06;
    }
  }
  blendMode(BLEND);

  // ── Dyson sphere — 7 rings × 12 particles ───────────────
  // 2-axis 3D orthographic projection:
  //   px3 = cos(ang)*rr*cos(az) - sin(ang)*rr*cos(el)*sin(az)
  //   py3 = cos(ang)*rr*sin(az) + sin(ang)*rr*cos(el)*cos(az)
  //   sx  = cx + px3
  //   sy  = (cy-40) + py3*0.95   ← -40 lifts sphere to star, 0.95 stretches height
  // flat PERSP-style Y (not sin(el)*PERSP) keeps the sphere centered —
  // sin(el) version squashes everything toward cy.
  // face-on rings (sin(el)→1) appear brighter than edge-on ones.
  blendMode(ADD);
  for (int r=0; r<DYSON_RINGS; r++) {
    float rr=dysonRadius[r], el=dysonTilt[r], az=dysonAz[r];
    float ringBright=map(sin(el),0,1,0.35,1.0);
    for (int p=0; p<DYSON_PER_RING; p++) {
      int idx=r*DYSON_PER_RING+p;
      dysonAngle[idx]+=dysonSpeed[idx];  dysonPhase[idx]+=0.022;
      float ang=dysonAngle[idx];
      float px3=cos(ang)*rr*cos(az) - sin(ang)*rr*cos(el)*sin(az);
      float py3=cos(ang)*rr*sin(az) + sin(ang)*rr*cos(el)*cos(az);
      float sx=cx+px3, sy=(cy-40)+py3*0.95;
      float shimmer=sin(dysonPhase[idx])*0.4+0.6;
      float alpha=shimmer*ringBright*200, sz=map(sin(el),0,1,1.5,3.8);
      fill(180,220,255,alpha*0.3); ellipse(sx,sy,sz*5,sz*5);
      fill(210,235,255,alpha*0.7); ellipse(sx,sy,sz*2,sz*2);
      fill(240,248,255,alpha);     ellipse(sx,sy,sz,sz);
    }
  }

  // tight pulsing star core — minimal, Dyson sphere handles the visual interest
  float pulse=sin(t*2.1)*0.10+1.0;
  fill(200,230,255,18);  ellipse(cx,cy,80*pulse,80*PERSP*pulse);
  fill(220,240,255,32);  ellipse(cx,cy,48*pulse,48*PERSP*pulse);
  fill(255,255,255,55);  ellipse(cx,cy,22*pulse,22*PERSP*pulse);
  blendMode(BLEND);
}

// ── spawnAsteroid ─────────────────────────────────────────────
// angle evenly distributed + jitter (no visible spokes),
// j=0 → inner edge, j=ROWS-1 → outer edge.
// tangential starting velocity so rocks enter orbit already moving.
// bimodal sizes: 70% small rubble, 30% chunks (power-law distribution).
// four material types: C-type charcoal, M-type iron, S-type silicate, basaltic.
void spawnAsteroid(int i, int j) {
  float angle=map(i,0,COLS,0,TWO_PI)+random(-0.06,0.06);
  float frac=j/float(ROWS-1);
  float rx=lerp(BELT_RX_IN,BELT_RX_OUT,frac)+random(-6,6);
  float ry=lerp(BELT_RY_IN,BELT_RY_OUT,frac)+random(-4,4);
  ax[i][j]=cx+cos(angle)*rx;  ay[i][j]=(cy-30)+sin(angle)*ry;  aAngle[i][j]=angle;
  float tdx=-sin(angle)*rx, tdy=cos(angle)*ry, tlen=sqrt(tdx*tdx+tdy*tdy);
  float spd=sqrt(G_CONST*STAR_MASS/((rx+ry)*0.5))*0.012;
  avx[i][j]=(tdx/tlen)*spd;  avy[i][j]=(tdy/tlen)*spd;
  aRad[i][j]   = random(1)<0.7 ? random(1.8,3.8) : random(4.0,7.5);
  aLife[i][j]  = random(0.5,1.0);  aLifeSpd[i][j]=random(0.0008,0.003);
  aRot[i][j]   = random(TWO_PI);   aRotSpd[i][j] =random(-0.012,0.012);
  aPoints[i][j]= int(random(5,10));
  float roll=random(1);
  if      (roll<0.38) { float v=random(55,110); aCol[i][j]=color(v,v*0.95,v*0.9); }
  else if (roll<0.65) aCol[i][j]=color(random(100,155),random(55,85),random(30,55));
  else if (roll<0.82) aCol[i][j]=color(random(130,170),random(100,135),random(65,95));
  else                aCol[i][j]=color(random(70,100),random(75,105),random(80,110));
}

// ── spawnKuiper ───────────────────────────────────────────────
// same orbital math as spawnAsteroid, bigger radii, icy palette.
// KBOs are frozen volatiles — brighter and bluer than rocky belt material.
void spawnKuiper(int i, int j) {
  float angle=map(i,0,KCOLS,0,TWO_PI)+random(-0.08,0.08);
  float frac=j/float(KROWS-1);
  float rx=lerp(KUIP_RX_IN,KUIP_RX_OUT,frac)+random(-8,8);
  float ry=lerp(KUIP_RY_IN,KUIP_RY_OUT,frac)+random(-5,5);
  kx[i][j]=cx+cos(angle)*rx;  ky[i][j]=cy+sin(angle)*ry;  kAngle[i][j]=angle;
  float tdx=-sin(angle)*rx, tdy=cos(angle)*ry, tlen=sqrt(tdx*tdx+tdy*tdy);
  float spd=sqrt(G_CONST*STAR_MASS/((rx+ry)*0.5))*0.010;
  kvx[i][j]=(tdx/tlen)*spd;  kvy[i][j]=(tdy/tlen)*spd;
  kRad[i][j]=random(2.0,5.0);  kLife[i][j]=random(0.5,1.0);  kLifeSpd[i][j]=random(0.001,0.003);
  float roll=random(1);
  if      (roll<0.45) kCol[i][j]=color(random(140,190),random(200,240),random(230,255));
  else if (roll<0.75) kCol[i][j]=color(random(100,150),random(170,210),random(220,255));
  else                kCol[i][j]=color(random(200,240),random(220,250),random(240,255));
}

// ── launchComet ───────────────────────────────────────────────
// 55% from inner (more activity near the star), 45% from Kuiper.
// radially outward + small tangential kick = curved trajectory,
// not a straight laser shot.
void launchComet() {
  for (int c=0; c<MAX_COMETS; c++) {
    if (cometLife[c]<=0) {
      float angle=random(TWO_PI);
      boolean fromInner=random(1)<0.55;
      float lrx=fromInner ? lerp(BELT_RX_IN,BELT_RX_OUT,random(1)) : lerp(KUIP_RX_IN,KUIP_RX_OUT,random(1));
      float lry=lrx*PERSP;
      cometX[c]=cx+cos(angle)*lrx;  cometY[c]=cy+sin(angle)*lry;
      float out=random(1.0,2.8), side=random(-0.4,0.4);
      cometVX[c]=cos(angle)*out+(-sin(angle))*side;
      cometVY[c]=sin(angle)*out*PERSP+cos(angle)*PERSP*side;
      cometLife[c]=random(0.6,1.0);  cometSize[c]=random(3.0,7.0);  tailHead[c]=0;
      float roll=random(1);
      if (fromInner) cometCol[c]=roll<0.5?color(255,random(160,220),random(40,90)):color(255,random(200,240),random(100,160));
      else           cometCol[c]=roll<0.5?color(random(120,180),random(190,230),255):color(random(200,240),random(220,250),255);
      for (int k=0; k<TAIL_LEN; k++) tailX[c][k]=cometX[c];
      for (int k=0; k<TAIL_LEN; k++) tailY[c][k]=cometY[c];
      break;
    }
  }
}

// ── triggerFlash ──────────────────────────────────────────────
// finds first dead slot in the pool — if all 30 are active, skips.
// better to miss one flash than steal a slot mid-animation.
void triggerFlash(float x, float y) {
  for (int f=0; f<MAX_FLASH; f++) {
    if (flashLife[f]<=0) { flashX[f]=x; flashY[f]=y; flashLife[f]=1.0; break; }
  }
}
