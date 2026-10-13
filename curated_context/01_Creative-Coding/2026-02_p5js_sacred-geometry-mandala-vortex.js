// STEVE ELIAS OREGEL - SACRED GEOMETRY MANDALA INSTALLATION
// CRCP 6310 - Assignment 6: Mandala
// 
// So basically this is a 13-layer mandala that rotates in 3D space
// think of it like looking down into a well where each layer is a circular 
// plate spinning at different speeds - creates this hypnotic vortex effect
// 
// i'm using the golden ratio (1.618...) for rotation speeds because that's 
// what makes spirals look naturally pleasing - same math you see in nautilus 
// shells and sunflower seed patterns
// 
// the colors go from dark/deep (purple) at the bottom to bright (gold) at the top
// which helps sell that "looking down into depth" feeling

// ============================================
// GLOBAL VARIABLES
// ============================================

let layers = []; // all 13 spinning layers
let globalRotation = 0; // not using this yet but keeping it for later

// color palettes - dark to light progression
// each layer gets 4 colors: main fill, secondary fill, accent, and highlight
// keeping gold for visual consistency
let colorPalettes = [
  ['#2D0052', '#4A0082', '#6B00B8', '#FFD700'], // deepest layer - dark purple
  ['#003D7A', '#0066CC', '#00CED1', '#FFD700'], // deep blue
  ['#008080', '#00B8B8', '#40E0D0', '#FFD700'], // teal
  ['#4B0082', '#8B00FF', '#9370DB', '#FFD700'], // purple
  ['#8B008B', '#FF1493', '#FF69B4', '#FFD700'], // magenta
  ['#0059B8', '#1E90FF', '#00BFFF', '#FFD700'], // electric blue
  ['#00FFFF', '#00CED1', '#7FFFD4', '#FFD700'], // cyan
  ['#FF1493', '#FF00FF', '#DA70D6', '#FFD700'], // hot pink
  ['#FF6347', '#FF7F50', '#FFA500', '#FFD700'], // orange
  ['#9400D3', '#BA55D3', '#DDA0DD', '#FFD700'], // warm purple
  ['#00FFFF', '#40E0D0', '#AFEEEE', '#FFD700'], // bright cyan
  ['#FF69B4', '#FFB6C1', '#FFC0CB', '#FFD700'], // light pink
  ['#FFD700', '#FFA500', '#FF8C00', '#FFFFFF']  // surface layer - gold
];

// ============================================
// SETUP - runs once when you hit play
// ============================================

function setup() {
  createCanvas(1000, 1000, WEBGL); // WEBGL enables 3D rendering
  
  // create all 13 layers with different depths and sizes
  for (let i = 0; i < 13; i++) {
    
    // z-depth: map each layer from way back (-1000) to close up (150)
    // this is what creates the "well" effect
    let zDepth = map(i, 0, 12, -1000, 150);
    
    // scale: smaller when further away (perspective)
    let baseScale = map(i, 0, 12, 0.25, 1.3);
    
    // rotation speed using golden ratio math
    // phi = 1.618 is the golden ratio - shows up everywhere in nature
    // playing with this value until the spin felt right
    let phi = 1.618;
    let rotSpeed = 0.0015 * pow(phi, (i - 6) / 3.5);
    
    // flip direction for every other layer to create vortex spiral
    rotSpeed = (i % 2 == 0) ? abs(rotSpeed) : -abs(rotSpeed);
    
    // actually create the layer object
    layers.push(new MandalaLayer(zDepth, baseScale, rotSpeed, colorPalettes[i], i));
  }
  
  // print controls to console
  console.log("========================================");
  console.log("STEVE ELIAS OREGEL - Sacred Geometry Vortex");
  console.log("========================================");
  console.log("Controls:");
  console.log("  Press 'S' to save frame");
  console.log("  Press '1' for simple complexity");
  console.log("  Press '2' for medium complexity");
  console.log("  Press '3' for complex complexity");
  console.log("========================================");
}

// ============================================
// DRAW - runs 60 times per second
// ============================================

function draw() {
  background(0); // black background makes colors pop
  
  // subtle breathing effect - makes the whole thing pulse slightly
  // using sin() for smooth back-and-forth motion
  let breathe = sin(frameCount * 0.004) * 12;
  translate(0, 0, breathe);
  
  // draw all layers from back to front (painter's algorithm)
  for (let i = 0; i < layers.length; i++) {
    layers[i].update(); // update rotation and animation
    layers[i].display(); // actually draw it
  }
  
  globalRotation += 0.001; // not using this yet
}

// ============================================
// KEYBOARD CONTROLS
// ============================================

function keyPressed() {
  // save current frame as image
  if (key === 's' || key === 'S') {
    saveCanvas('SteveEno_Mandala', 'png');
    console.log("Frame saved!");
  }
  
  // complexity controls
  if (key === '1') layers.forEach(layer => layer.complexityLevel = 1);
  if (key === '2') layers.forEach(layer => layer.complexityLevel = 2);
  if (key === '3') layers.forEach(layer => layer.complexityLevel = 3);
}

// ============================================
// MANDALA LAYER CLASS
// ============================================

class MandalaLayer {
  
  constructor(z, scale, rotSpeed, colors, index) {
    // store the basics
    this.zDepth = z;
    this.baseScale = scale;
    this.currentScale = scale;
    this.rotSpeed = rotSpeed;
    this.rotation = random(TWO_PI); // start at random angle for variety
    this.palette = colors.map(c => color(c)); // convert hex to p5 colors
    this.layerIndex = index;
    this.pulsePhase = random(TWO_PI); // random phase so they don't all pulse together
    this.complexityLevel = 2; // start with medium detail
    
    // assign edge shape - cycles through rounded/sharp/curved
    let shapePattern = [0, 1, 2, 0, 2, 1, 0, 1, 2, 1, 0, 2, 1];
    this.edgeShape = shapePattern[index % 13];
    
    // figure out opacity based on depth
    this.targetOpacity = map(z, -1000, 150, 100, 255);
    this.opacity = this.targetOpacity;
    
    // glow intensity also based on depth
    this.glowIntensity = map(z, -1000, 150, 5, 20);
  }
  
  update() {
    // smooth opacity changes
    this.opacity = lerp(this.opacity, this.targetOpacity, 0.02);
    
    // spin it
    this.rotation += this.rotSpeed;
    
    // update the pulsing
    this.pulsePhase += 0.02;
    
    // calculate pulsing glow
    this.glowIntensity = 10 + sin(this.pulsePhase) * 5;
    
    // calculate pulsing scale (breathing effect)
    let scalePulse = 1 + sin(this.pulsePhase * 0.5) * 0.05;
    this.currentScale = this.baseScale * scalePulse;
  }
  
  display() {
    push();
    
    // move to the right depth
    translate(0, 0, this.zDepth);
    
    // rotate it
    rotate(this.rotation);
    
    // scale it (includes pulsing)
    scale(this.currentScale);
    
    // draw based on complexity setting
    switch(this.complexityLevel) {
      case 1: this.drawSimpleMandala(); break;
      case 2: this.drawMediumMandala(); break;
      case 3: this.drawComplexMandala(); break;
    }
    
    pop();
  }
  
  // SIMPLE VERSION - just the basics
  drawSimpleMandala() {
    let numPetals = (this.edgeShape == 1) ? 6 : 8;
    
    if (this.glowIntensity > 0) {
      drawGlowRing(400, this.palette[3], this.glowIntensity, this.opacity);
    }
    
    if (this.edgeShape == 0) {
      drawPetalRing(numPetals, 350, 180, this.palette[0], this.palette[1], this.opacity);
    } else if (this.edgeShape == 1) {
      drawAngularPetalRing(numPetals, 350, 200, this.palette[0], this.palette[1], this.opacity);
    } else {
      drawOrnatePetalRing(numPetals, 350, 190, this.palette[0], this.palette[1], this.opacity);
    }
    
    drawGeometricCircle(150, 16, this.palette[2], this.palette[3], this.opacity);
    drawStarPolygon(8, 80, 40, this.palette[3], this.palette[2], this.opacity);
  }
  
  // MEDIUM VERSION - adds more layers
  drawMediumMandala() {
    let numPetals = (this.edgeShape == 1) ? 8 : 12;
    
    drawGlowRing(450, this.palette[3], this.glowIntensity, this.opacity);
    
    if (this.edgeShape == 0) {
      drawPetalRing(numPetals, 380, 200, this.palette[0], this.palette[1], this.opacity);
    } else if (this.edgeShape == 1) {
      drawAngularPetalRing(numPetals, 380, 210, this.palette[0], this.palette[1], this.opacity);
    } else {
      drawOrnatePetalRing(numPetals, 380, 200, this.palette[0], this.palette[1], this.opacity);
    }
    
    drawDecorativeRing(numPetals, 280, this.palette[1], this.palette[2], this.opacity);
    drawGeometricCircle(180, 24, this.palette[2], this.palette[3], this.opacity);
    drawPetalRing(numPetals, 120, 60, this.palette[2], this.palette[3], this.opacity);
    drawStarPolygon(12, 60, 30, this.palette[3], this.palette[2], this.opacity);
  }
  
  // COMPLEX VERSION - everything
  drawComplexMandala() {
    let numElements = (this.edgeShape == 1) ? 12 : 16;
    
    drawGlowRing(500, this.palette[3], this.glowIntensity * 1.5, this.opacity);
    drawGlowRing(450, this.palette[0], this.glowIntensity, this.opacity);
    
    if (this.edgeShape == 0) {
      drawOrnatePetalRing(numElements, 420, 220, this.palette[0], this.palette[1], this.opacity);
    } else if (this.edgeShape == 1) {
      drawAngularPetalRing(numElements, 420, 230, this.palette[0], this.palette[1], this.opacity);
    } else {
      drawOrnatePetalRing(numElements, 420, 220, this.palette[0], this.palette[1], this.opacity);
    }
    
    drawDecorativeRing(numElements, 320, this.palette[1], this.palette[2], this.opacity);
    drawPetalRing(numElements, 280, 140, this.palette[1], this.palette[2], this.opacity);
    drawGeometricCircle(200, 32, this.palette[2], this.palette[3], this.opacity);
    drawGeometricCircle(150, 24, this.palette[3], this.palette[0], this.opacity);
    drawSmallCircleRing(numElements, 100, 15, this.palette[2], this.opacity);
    drawComplexStar(numElements, 80, 50, 40, this.palette[3], this.palette[2], this.palette[0], this.opacity);
  }
}

// ============================================
// POLYGON DRAWING FUNCTIONS
// ============================================

function drawPetalRing(numPetals, radius, petalLength, fillCol, strokeCol, alpha) {
  for (let i = 0; i < numPetals; i++) {
    let angle = TWO_PI / numPetals * i;
    push();
    rotate(angle);
    drawPetal(radius, petalLength, fillCol, strokeCol, alpha);
    pop();
  }
}

function drawPetal(startRadius, length, fillCol, strokeCol, alpha) {
  strokeWeight(3);
  stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
  fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.7);
  
  beginShape();
  let resolution = 20;
  for (let i = 0; i <= resolution; i++) {
    let t = i / resolution;
    let angle = map(t, 0, 1, -0.3, 0.3);
    let r = startRadius + sin(t * PI) * length;
    let x = cos(angle) * r;
    let y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  // gold outline
  noFill();
  strokeWeight(2);
  stroke(255, 215, 0, alpha * 0.8);
  beginShape();
  for (let i = 0; i <= resolution; i++) {
    let t = i / resolution;
    let angle = map(t, 0, 1, -0.3, 0.3);
    let r = startRadius + sin(t * PI) * length;
    let x = cos(angle) * r;
    let y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

function drawAngularPetalRing(numPetals, radius, length, fillCol, strokeCol, alpha) {
  for (let i = 0; i < numPetals; i++) {
    let angle = TWO_PI / numPetals * i;
    push();
    rotate(angle);
    drawAngularPetal(radius, length, fillCol, strokeCol, alpha);
    pop();
  }
}

function drawAngularPetal(startRadius, length, fillCol, strokeCol, alpha) {
  strokeWeight(3);
  stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
  fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.7);
  
  beginShape();
  vertex(0, startRadius);
  vertex(-length * 0.3, startRadius + length * 0.5);
  vertex(0, startRadius + length);
  vertex(length * 0.3, startRadius + length * 0.5);
  endShape(CLOSE);
  
  noFill();
  strokeWeight(2);
  stroke(255, 215, 0, alpha);
  beginShape();
  vertex(0, startRadius);
  vertex(-length * 0.3, startRadius + length * 0.5);
  vertex(0, startRadius + length);
  vertex(length * 0.3, startRadius + length * 0.5);
  endShape(CLOSE);
}

function drawOrnatePetalRing(numPetals, radius, length, fillCol, strokeCol, alpha) {
  for (let i = 0; i < numPetals; i++) {
    let angle = TWO_PI / numPetals * i;
    push();
    rotate(angle);
    drawOrnatePetal(radius, length, fillCol, strokeCol, alpha);
    pop();
  }
}

function drawOrnatePetal(startRadius, length, fillCol, strokeCol, alpha) {
  strokeWeight(3);
  stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
  fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.6);
  
  beginShape();
  let resolution = 30;
  for (let i = 0; i <= resolution; i++) {
    let t = i / resolution;
    let angle = map(t, 0, 1, -0.4, 0.4);
    let r = startRadius + sin(t * PI) * length;
    r += sin(t * PI * 4) * (length * 0.1);
    let x = cos(angle) * r;
    let y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  noFill();
  strokeWeight(2);
  stroke(255, 215, 0, alpha);
  beginShape();
  for (let i = 0; i <= resolution; i++) {
    let t = i / resolution;
    let angle = map(t, 0, 1, -0.4, 0.4);
    let r = startRadius + sin(t * PI) * length;
    r += sin(t * PI * 4) * (length * 0.1);
    let x = cos(angle) * r;
    let y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

function drawGeometricCircle(radius, segments, fillCol, strokeCol, alpha) {
  strokeWeight(2);
  stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
  fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.5);
  
  beginShape();
  for (let i = 0; i < segments; i++) {
    let angle = TWO_PI / segments * i;
    let x = cos(angle) * radius;
    let y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  stroke(255, 215, 0, alpha);
  strokeWeight(2);
  for (let i = 0; i < segments; i++) {
    let angle = TWO_PI / segments * i;
    let x2 = cos(angle) * radius;
    let y2 = sin(angle) * radius;
    line(0, 0, x2, y2);
  }
}

function drawStarPolygon(numPoints, outerRadius, innerRadius, fillCol, strokeCol, alpha) {
  strokeWeight(3);
  stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
  fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.8);
  
  beginShape();
  for (let i = 0; i < numPoints * 2; i++) {
    let angle = TWO_PI / (numPoints * 2) * i;
    let r = (i % 2 == 0) ? outerRadius : innerRadius;
    let x = cos(angle - HALF_PI) * r;
    let y = sin(angle - HALF_PI) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  noFill();
  strokeWeight(2);
  stroke(255, 215, 0, alpha);
  beginShape();
  for (let i = 0; i < numPoints * 2; i++) {
    let angle = TWO_PI / (numPoints * 2) * i;
    let r = (i % 2 == 0) ? outerRadius : innerRadius;
    let x = cos(angle - HALF_PI) * r;
    let y = sin(angle - HALF_PI) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

function drawComplexStar(numPoints, outer, mid, inner, col1, col2, col3, alpha) {
  drawStarPolygon(numPoints, outer, mid, col1, col2, alpha);
  push();
  rotate(PI / numPoints);
  drawStarPolygon(numPoints, mid, inner, col2, col3, alpha);
  pop();
  
  fill(red(col3), green(col3), blue(col3), alpha);
  stroke(255, 215, 0, alpha);
  strokeWeight(2);
  ellipse(0, 0, inner * 0.8, inner * 0.8);
}

function drawDecorativeRing(numElements, radius, fillCol, strokeCol, alpha) {
  let circleSize = 30;
  
  stroke(255, 215, 0, alpha * 0.6);
  strokeWeight(2);
  noFill();
  beginShape();
  for (let i = 0; i <= numElements; i++) {
    let angle = TWO_PI / numElements * i;
    let x = cos(angle) * radius;
    let y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  for (let i = 0; i < numElements; i++) {
    let angle = TWO_PI / numElements * i;
    let x = cos(angle) * radius;
    let y = sin(angle) * radius;
    
    fill(red(fillCol), green(fillCol), blue(fillCol), alpha * 0.7);
    stroke(red(strokeCol), green(strokeCol), blue(strokeCol), alpha);
    strokeWeight(2);
    ellipse(x, y, circleSize, circleSize);
    
    fill(red(strokeCol), green(strokeCol), blue(strokeCol), alpha * 0.5);
    noStroke();
    ellipse(x, y, circleSize * 0.5, circleSize * 0.5);
  }
}

function drawSmallCircleRing(numCircles, radius, circleSize, col, alpha) {
  for (let i = 0; i < numCircles; i++) {
    let angle = TWO_PI / numCircles * i;
    let x = cos(angle) * radius;
    let y = sin(angle) * radius;
    
    fill(red(col), green(col), blue(col), alpha * 0.8);
    stroke(255, 215, 0, alpha);
    strokeWeight(1.5);
    ellipse(x, y, circleSize, circleSize);
  }
}

function drawGlowRing(radius, col, intensity, alpha) {
  noFill();
  for (let i = 0; i < 5; i++) {
    let r = radius + i * 10;
    let glowAlpha = map(i, 0, 5, intensity * 20, 0);
    glowAlpha = min(glowAlpha, alpha);
    stroke(red(col), green(col), blue(col), glowAlpha);
    strokeWeight(8 - i);
    ellipse(0, 0, r * 2, r * 2);
  }
}
