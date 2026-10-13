// Assignment 5: Crystalline Prism
// Steve Elias
// CRCP 6310 - Creative Computing

// so this is basically my take on merging luxury fashion aesthetics with geometric code
// wanted something that feels more gallery installation than typical student project
// the icosahedron from nano banana sits in the back doing its thing while the prisms dance

PImage icosahedron;
float angle = 0;
int colorMode = 0; // tracks which color palette we're using
float[] prismSpeeds = {0.015, -0.022, 0.018, -0.012}; // different rotation speeds for depth
float[] prismSizes = {180, 140, 100, 60}; // layered sizing for that kaleidoscope effect

// color palettes - hybrid approach mixing the magenta/gold vibes with holographic pastels
// switching between these with mouse clicks to keep it dynamic
color[][] palettes = {
  // palette 0: magenta + gold (from my assignment 4 screenshot energy)
  {#D946A6, #C2185B, #FFB300, #F57F17, #8E24AA},
  
  // palette 1: holographic pastels (icosahedron vibes)
  {#E1BEE7, #B39DDB, #90CAF9, #80DEEA, #F8BBD0},
  
  // palette 2: luxury silver/rose gold hybrid
  {#C0C0C0, #E6C3B8, #D4A5A5, #9E9E9E, #FADADD},
  
  // palette 3: deep jewel tones (because why not)
  {#4A148C, #880E4F, #1A237E, #004D40, #BF360C}
};

void setup() {
  size(1280, 720); // going cinematic - this feels more installation than square
  
  // loading the nano banana icosahedron
  // keeping it static because rotation on rotation felt too busy in testing
  // sometimes restraint is the luxury move
  icosahedron = loadImage("icosahedron.png");
  
  smooth(); // because jagged edges are not the vibe
}

void draw() {
  // drawing the icosahedron background first
  // tinted slightly transparent so the prisms pop in front
  tint(255, 120); // 120 opacity feels right - still visible but not competing
  imageMode(CENTER);
  image(icosahedron, width/2, height/2, width, height);
  noTint();
  
  // okay so here's where the magic happens
  // drawing multiple prisms at different speeds and sizes
  // this creates that kaleidoscope layering effect
  for (int i = 0; i < prismSpeeds.length; i++) {
    pushMatrix();
    translate(width/2, height/2); // everything rotates from center
    rotate(angle * prismSpeeds[i]); // each prism has its own speed
    
    // alternating between filled and outline for visual interest
    if (i % 2 == 0) {
      drawPrism(prismSizes[i], 8, true, i); // filled
    } else {
      drawPrism(prismSizes[i], 8, false, i); // outline only
    }
    
    popMatrix();
  }
  
  // increment the main angle - this drives all rotation
  // keeping it slow and meditative, not aggressive
  angle += 0.01;
}

// this is the main function doing the heavy lifting
// using trig to calculate polygon vertices because that's what the module wants
// but also because it actually makes sense for regular polygons
void drawPrism(float radius, int sides, boolean filled, int paletteOffset) {
  
  // getting colors from current palette
  // offset ensures each prism gets different colors even from same palette
  color c1 = palettes[colorMode][(paletteOffset) % palettes[colorMode].length];
  color c2 = palettes[colorMode][(paletteOffset + 1) % palettes[colorMode].length];
  
  if (filled) {
    fill(c1, 180); // slight transparency for layering
    noStroke();
  } else {
    noFill();
    stroke(c2, 200);
    strokeWeight(2);
  }
  
  beginShape();
  
  // this loop calculates each vertex position using polar to cartesian conversion
  // basically: given an angle and radius, where does that point live in x,y space?
  // it's the same math that makes actual prisms and crystals work in nature
  for (int i = 0; i < sides; i++) {
    // dividing the circle into equal angles based on number of sides
    float angleStep = TWO_PI / sides;
    float currentAngle = angleStep * i;
    
    // polar to cartesian conversion (this is the trig from module 5)
    // x = cos(theta) * r
    // y = sin(theta) * r
    float x = cos(currentAngle) * radius;
    float y = sin(currentAngle) * radius;
    
    vertex(x, y);
  }
  
  endShape(CLOSE);
}

// mouse click switches between color palettes
// this keeps the piece interactive and lets it adapt to different moods
void mousePressed() {
  colorMode = (colorMode + 1) % palettes.length;
  // cycling through all 4 palettes then back to start
  // simple but effective for showing range
}

// just some notes for when i present this:
// - the icosahedron is AI-generated via nano banana (comfyui workflow)
// - the code demonstrates custom functions, trig, loops, and polar/cartesian conversion
// - color palette system shows parameterization and easy customization
// - multiple rotation speeds create visual complexity with minimal code
// - this could easily be adapted for Lei Wai branding or Tantalum Magazine motion graphics
// - total code is under 150 lines which feels clean for what it does
