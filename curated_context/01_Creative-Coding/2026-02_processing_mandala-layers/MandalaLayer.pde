/* ============================================
 * MANDALA LAYER CLASS
 * 
 * so each layer is basically one complete mandala at a specific depth
 * they all spin independently which is what creates the vortex effect
 * 
 * each layer needs to know:
 * - where it is in 3D space (how far back)
 * - how big it should be (smaller = further away)
 * - how fast to spin (and which direction)
 * - what colors to use
 * - how detailed to draw (simple/medium/complex)
 * ============================================ */

class MandalaLayer {
  
  // position stuff
  float zDepth;          // how far back in 3D space (negative = further)
  float baseScale;       // base size (0.25 to 1.3)
  float currentScale;    // actual size including pulsing animation
  float rotation;        // current angle (in radians)
  float rotSpeed;        // how fast to spin each frame
  
  // visual properties
  float opacity;         // current see-through-ness (0-255)
  float targetOpacity;   // what opacity should be (based on depth)
  float glowIntensity;   // outer glow strength
  
  // colors and style
  color[] palette;       // the 4 colors this layer uses
  int layerIndex;        // which layer this is (0-12)
  int complexityLevel;   // how much detail to draw (1/2/3)
  int edgeShape;         // what petal style to use (0/1/2)
  
  // animation timing
  float pulsePhase;      // where we are in the pulsing cycle
  
  // ============================================
  // CONSTRUCTOR - sets up a new layer
  // ============================================
  
  MandalaLayer(float z, float scale, float rotSpeed, color[] colors, int index) {
    // store the basics
    this.zDepth = z;
    this.baseScale = scale;
    this.currentScale = scale;
    this.rotSpeed = rotSpeed;
    this.rotation = random(TWO_PI); // start at random angle for variety
    this.palette = colors;
    this.layerIndex = index;
    this.pulsePhase = random(TWO_PI); // random phase so they don't all pulse together
    this.complexityLevel = 2; // start with medium detail
    
    // assign edge shape - cycles through rounded/sharp/curved
    // using a pattern that looks good visually
    int[] shapePattern = {0, 1, 2, 0, 2, 1, 0, 1, 2, 1, 0, 2, 1};
    this.edgeShape = shapePattern[index % 13];
    
    // figure out opacity based on depth
    // deeper layers are more see-through (like atmospheric perspective)
    this.targetOpacity = map(z, -1000, 150, 100, 255);
    this.opacity = this.targetOpacity; // start visible
    
    // glow intensity also based on depth
    this.glowIntensity = map(z, -1000, 150, 5, 20);
  }
  
  // ============================================
  // UPDATE - called every frame to animate stuff
  // ============================================
  
  void update() {
    // smooth opacity changes using lerp (linear interpolation)
    // 0.02 makes it gradual instead of instant
    opacity = lerp(opacity, targetOpacity, 0.02);
    
    // spin it
    rotation += rotSpeed;
    
    // update the pulsing
    pulsePhase += 0.02;
    
    // calculate pulsing glow using sin wave
    // oscillates between 5 and 15
    glowIntensity = 10 + sin(pulsePhase) * 5;
    
    // calculate pulsing scale (breathing effect)
    // keeping it subtle - only varies by 5%
    float scalePulse = 1 + sin(pulsePhase * 0.5) * 0.05;
    currentScale = baseScale * scalePulse;
  }
  
  // ============================================
  // DISPLAY - actually draws the mandala
  // ============================================
  
  void display() {
    pushMatrix();
    
    // move to the right depth
    translate(0, 0, zDepth);
    
    // rotate it
    rotate(rotation);
    
    // scale it (includes pulsing)
    scale(currentScale);
    
    // draw based on complexity setting
    switch(complexityLevel) {
      case 1: drawSimpleMandala(); break;
      case 2: drawMediumMandala(); break;
      case 3: drawComplexMandala(); break;
    }
    
    popMatrix();
  }
  
  // ============================================
  // DRAWING METHODS
  // these three functions draw different detail levels
  // ============================================
  
  // SIMPLE VERSION - just the basics
  void drawSimpleMandala() {
    // sharp edges look better with fewer petals
    int numPetals = (edgeShape == 1) ? 6 : 8;
    
    // outer glow if we have any
    if (glowIntensity > 0) {
      drawGlowRing(400, palette[3], glowIntensity, opacity);
    }
    
    // main outer petals - shape depends on edgeShape setting
    if (edgeShape == 0) {
      drawPetalRing(numPetals, 350, 180, palette[0], palette[1], opacity);
    } else if (edgeShape == 1) {
      drawAngularPetalRing(numPetals, 350, 200, palette[0], palette[1], opacity);
    } else {
      drawOrnatePetalRing(numPetals, 350, 190, palette[0], palette[1], opacity);
    }
    
    // inner circle with radial lines
    drawGeometricCircle(150, 16, palette[2], palette[3], opacity);
    
    // center star
    drawStarPolygon(8, 80, 40, palette[3], palette[2], opacity);
  }
  
  // MEDIUM VERSION - adds more layers
  void drawMediumMandala() {
    // more petals for medium complexity
    int numPetals = (edgeShape == 1) ? 8 : 12;
    
    // glow
    drawGlowRing(450, palette[3], glowIntensity, opacity);
    
    // outer petals
    if (edgeShape == 0) {
      drawPetalRing(numPetals, 380, 200, palette[0], palette[1], opacity);
    } else if (edgeShape == 1) {
      drawAngularPetalRing(numPetals, 380, 210, palette[0], palette[1], opacity);
    } else {
      drawOrnatePetalRing(numPetals, 380, 200, palette[0], palette[1], opacity);
    }
    
    // middle ring connects outer to inner
    drawDecorativeRing(numPetals, 280, palette[1], palette[2], opacity);
    
    // inner geometric pattern
    drawGeometricCircle(180, 24, palette[2], palette[3], opacity);
    
    // smaller inner petals
    drawPetalRing(numPetals, 120, 60, palette[2], palette[3], opacity);
    
    // center star with more points
    drawStarPolygon(12, 60, 30, palette[3], palette[2], opacity);
  }
  
  // COMPLEX VERSION - everything
  void drawComplexMandala() {
    // maximum elements
    int numElements = (edgeShape == 1) ? 12 : 16;
    
    // double glow layers for depth
    drawGlowRing(500, palette[3], glowIntensity * 1.5, opacity);
    drawGlowRing(450, palette[0], glowIntensity, opacity);
    
    // outer ornate petals
    if (edgeShape == 0) {
      drawOrnatePetalRing(numElements, 420, 220, palette[0], palette[1], opacity);
    } else if (edgeShape == 1) {
      drawAngularPetalRing(numElements, 420, 230, palette[0], palette[1], opacity);
    } else {
      drawOrnatePetalRing(numElements, 420, 220, palette[0], palette[1], opacity);
    }
    
    // connecting decorative elements
    drawDecorativeRing(numElements, 320, palette[1], palette[2], opacity);
    
    // middle petal layer
    drawPetalRing(numElements, 280, 140, palette[1], palette[2], opacity);
    
    // multiple inner circles for intricate center
    drawGeometricCircle(200, 32, palette[2], palette[3], opacity);
    drawGeometricCircle(150, 24, palette[3], palette[0], opacity);
    
    // small detail circles
    drawSmallCircleRing(numElements, 100, 15, palette[2], opacity);
    
    // layered center stars
    drawComplexStar(numElements, 80, 50, 40, palette[3], palette[2], palette[0], opacity);
  }
}
