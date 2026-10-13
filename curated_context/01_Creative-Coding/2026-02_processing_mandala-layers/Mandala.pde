/* ============================================
 * STEVE ELIAS OREGEL - SACRED GEOMETRY MANDALA INSTALLATION
 * CRCP 6310 - Assignment 6: Mandala
 * 
 * So basically this is a 13-layer mandala that rotates in 3D space
 * think of it like looking down into a well where each layer is a circular 
 * plate spinning at different speeds - creates this hypnotic vortex effect
 * 
 * i'm using the golden ratio (1.618...) for rotation speeds because that's 
 * what makes spirals look naturally pleasing - same math you see in nautilus 
 * shells and sunflower seed patterns
 * 
 * the colors go from dark/deep (purple) at the bottom to bright (gold) at the top
 * which helps sell that "looking down into depth" feeling
 * ============================================ */

// ============================================
// GLOBAL VARIABLES
// ============================================

MandalaLayer[] layers = new MandalaLayer[13]; // all 13 spinning layers
float globalRotation = 0; // not using this yet but keeping it for later

// color palettes - dark to light progression
// each layer gets 4 colors: main fill, secondary fill, accent, and highlight
// keeping gold (#FFD700) on every layer for visual consistency
color[][] colorPalettes = {
  {#2D0052, #4A0082, #6B00B8, #FFD700}, // deepest layer - dark purple
  {#003D7A, #0066CC, #00CED1, #FFD700}, // deep blue
  {#008080, #00B8B8, #40E0D0, #FFD700}, // teal
  {#4B0082, #8B00FF, #9370DB, #FFD700}, // purple
  {#8B008B, #FF1493, #FF69B4, #FFD700}, // magenta
  {#0059B8, #1E90FF, #00BFFF, #FFD700}, // electric blue
  {#00FFFF, #00CED1, #7FFFD4, #FFD700}, // cyan
  {#FF1493, #FF00FF, #DA70D6, #FFD700}, // hot pink
  {#FF6347, #FF7F50, #FFA500, #FFD700}, // orange
  {#9400D3, #BA55D3, #DDA0DD, #FFD700}, // warm purple
  {#00FFFF, #40E0D0, #AFEEEE, #FFD700}, // bright cyan
  {#FF69B4, #FFB6C1, #FFC0CB, #FFD700}, // light pink
  {#FFD700, #FFA500, #FF8C00, #FFFFFF}  // surface layer - gold
};

// ============================================
// SETUP - runs once when you hit play
// ============================================

void setup() {
  size(1000, 1000, P3D); // P3D enables 3D rendering
  smooth(8); // makes edges look smoother
  
  // create all 13 layers with different depths and sizes
  for (int i = 0; i < layers.length; i++) {
    
    // z-depth: map each layer from way back (-1000) to close up (150)
    // this is what creates the "well" effect
    float zDepth = map(i, 0, layers.length - 1, -1000, 150);
    
    // scale: smaller when further away (perspective)
    float baseScale = map(i, 0, layers.length - 1, 0.25, 1.3);
    
    // rotation speed using golden ratio math
    // phi = 1.618 is the golden ratio - shows up everywhere in nature
    // playing with this value until the spin felt right
    float phi = 1.618;
    float rotSpeed = 0.0015 * pow(phi, (i - 6) / 3.5);
    
    // flip direction for every other layer to create vortex spiral
    rotSpeed = (i % 2 == 0) ? abs(rotSpeed) : -abs(rotSpeed);
    
    // actually create the layer object
    layers[i] = new MandalaLayer(zDepth, baseScale, rotSpeed, colorPalettes[i], i);
  }
  
  // print controls to console (cleaner than on-screen text)
  println("========================================");
  println("STEVE ELIAS OREGEL - Sacred Geometry Vortex");
  println("========================================");
  println("Controls:");
  println("  Press 'S' to save frame");
  println("  Press '1' for simple complexity");
  println("  Press '2' for medium complexity");
  println("  Press '3' for complex complexity");
  println("========================================");
}

// ============================================
// DRAW - runs 60 times per second
// ============================================

void draw() {
  background(0); // black background makes colors pop
  
  // set up camera view
  pushMatrix(); // saves current position
  translate(width/2, height/2, 0); // move to center
  
  // subtle breathing effect - makes the whole thing pulse slightly
  // using sin() for smooth back-and-forth motion
  float breathe = sin(frameCount * 0.004) * 12;
  translate(0, 0, breathe);
  
  // draw all layers from back to front (painter's algorithm)
  for (int i = 0; i < layers.length; i++) {
    layers[i].update(); // update rotation and animation
    layers[i].display(); // actually draw it
  }
  
  popMatrix(); // restore position
  
  globalRotation += 0.001; // not using this yet
}

// ============================================
// KEYBOARD CONTROLS
// ============================================

void keyPressed() {
  // save current frame as image
  if (key == 's' || key == 'S') {
    saveFrame("SteveEno_Mandala_####.png"); // #### auto-numbers files
    println("Frame saved!");
  }
  
  // complexity controls
  // 1 = simple (just outer petals and center)
  // 2 = medium (adds middle rings and details)
  // 3 = complex (everything, full ornate mode)
  if (key == '1') for (MandalaLayer layer : layers) layer.complexityLevel = 1;
  if (key == '2') for (MandalaLayer layer : layers) layer.complexityLevel = 2;
  if (key == '3') for (MandalaLayer layer : layers) layer.complexityLevel = 3;
}
