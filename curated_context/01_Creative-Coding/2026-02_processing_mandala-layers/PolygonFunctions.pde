/* ============================================
 * POLYGON DRAWING FUNCTIONS
 * 
 * so this file has all the functions that actually draw the shapes
 * each function uses loops to create radial symmetry (like a flower)
 * 
 * the basic pattern is:
 * - figure out how many petals/points/segments you want
 * - use a for loop to draw that many copies in a circle
 * - use trig (sin/cos) to position each copy around the center
 * 
 * all these functions work the same way:
 * - you tell it how many (count)
 * - where to put them (radius)
 * - how big to make them (size/length)
 * - what colors to use
 * - how see-through it should be (alpha)
 * ============================================ */

// ============================================
// PETAL FUNCTIONS
// ============================================

// draws petals arranged in a circle
// this is the bread and butter of the mandala - used everywhere
void drawPetalRing(int numPetals, float radius, float petalLength, color fillCol, color strokeCol, float alpha) {
  // loop through each petal position
  for (int i = 0; i < numPetals; i++) {
    // figure out the angle for this petal
    // TWO_PI is 360 degrees, divide by number of petals
    float angle = TWO_PI / numPetals * i;
    
    pushMatrix(); // save position
    rotate(angle); // spin to the right spot
    
    // draw one petal
    drawPetal(radius, petalLength, fillCol, strokeCol, alpha);
    
    popMatrix(); // restore position
  }
}

// draws a single petal using a smooth curve
// made up of lots of little points connected together
void drawPetal(float startRadius, float length, color fillCol, color strokeCol, float alpha) {
  // set up colors with transparency
  strokeWeight(3);
  stroke(strokeCol, alpha);
  fill(fillCol, alpha * 0.7); // slightly more see-through
  
  beginShape(); // start drawing the petal
  
  // create curve with 20 points (more = smoother)
  int resolution = 20;
  for (int i = 0; i <= resolution; i++) {
    // t goes from 0 to 1 (think of it as 0% to 100%)
    float t = i / float(resolution);
    
    // map t to an angle (how wide the petal spreads)
    float angle = map(t, 0, 1, -0.3, 0.3);
    
    // use sin to make it bulge in the middle
    // when t=0.5 (middle), sin gives us the max bulge
    float r = startRadius + sin(t * PI) * length;
    
    // convert polar (angle + radius) to x,y coordinates
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    vertex(x, y);
  }
  
  endShape(CLOSE); // finish the shape
  
  // add gold outline (that stained glass look)
  noFill();
  strokeWeight(2);
  stroke(#FFD700, alpha * 0.8); // gold
  
  // draw the same shape again for outline
  beginShape();
  for (int i = 0; i <= resolution; i++) {
    float t = i / float(resolution);
    float angle = map(t, 0, 1, -0.3, 0.3);
    float r = startRadius + sin(t * PI) * length;
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

// ============================================
// ANGULAR PETAL FUNCTIONS (sharp geometric style)
// ============================================

// same as regular petal ring but with sharp angular petals
void drawAngularPetalRing(int numPetals, float radius, float length, color fillCol, color strokeCol, float alpha) {
  for (int i = 0; i < numPetals; i++) {
    float angle = TWO_PI / numPetals * i;
    
    pushMatrix();
    rotate(angle);
    
    // Draw sharp angular petal
    drawAngularPetal(radius, length, fillCol, strokeCol, alpha);
    
    popMatrix();
  }
}

// Angular petal with sharp geometric edges
void drawAngularPetal(float startRadius, float length, color fillCol, color strokeCol, float alpha) {
  strokeWeight(3);
  stroke(strokeCol, alpha);
  fill(fillCol, alpha * 0.7);
  
  // Create sharp triangular/diamond petal shape
  beginShape();
  
  // Sharp pointed petal (like your geometric mandalas)
  vertex(0, startRadius); // Base center
  vertex(-length * 0.3, startRadius + length * 0.5); // Left point
  vertex(0, startRadius + length); // Tip point
  vertex(length * 0.3, startRadius + length * 0.5); // Right point
  
  endShape(CLOSE);
  
  // Gold outline for stained glass effect
  noFill();
  strokeWeight(2);
  stroke(#FFD700, alpha);
  
  beginShape();
  vertex(0, startRadius);
  vertex(-length * 0.3, startRadius + length * 0.5);
  vertex(0, startRadius + length);
  vertex(length * 0.3, startRadius + length * 0.5);
  endShape(CLOSE);
}

// Draw ornate petals (more complex curves)
void drawOrnatePetalRing(int numPetals, float radius, float length, color fillCol, color strokeCol, float alpha) {
  for (int i = 0; i < numPetals; i++) {
    float angle = TWO_PI / numPetals * i;
    
    pushMatrix();
    rotate(angle);
    
    // Draw ornate petal with multiple curves
    drawOrnatePetal(radius, length, fillCol, strokeCol, alpha);
    
    popMatrix();
  }
}

// Ornate petal with decorative elements
void drawOrnatePetal(float startRadius, float length, color fillCol, color strokeCol, float alpha) {
  strokeWeight(3);
  stroke(strokeCol, alpha);
  fill(fillCol, alpha * 0.6);
  
  beginShape();
  int resolution = 30;
  for (int i = 0; i <= resolution; i++) {
    float t = i / float(resolution);
    float angle = map(t, 0, 1, -0.4, 0.4);
    
    // More complex curve with decorative bumps
    float r = startRadius + sin(t * PI) * length;
    r += sin(t * PI * 4) * (length * 0.1); // Decorative ripples
    
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  // Gold accent outline
  noFill();
  strokeWeight(2);
  stroke(#FFD700, alpha);
  beginShape();
  for (int i = 0; i <= resolution; i++) {
    float t = i / float(resolution);
    float angle = map(t, 0, 1, -0.4, 0.4);
    float r = startRadius + sin(t * PI) * length;
    r += sin(t * PI * 4) * (length * 0.1);
    
    float x = cos(angle) * r;
    float y = sin(angle) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

// Geometric circle with segmented polygons
void drawGeometricCircle(float radius, int segments, color fillCol, color strokeCol, float alpha) {
  strokeWeight(2);
  stroke(strokeCol, alpha);
  fill(fillCol, alpha * 0.5);
  
  beginShape();
  for (int i = 0; i < segments; i++) {
    float angle = TWO_PI / segments * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  // Gold segmentation lines (stained glass effect)
  stroke(#FFD700, alpha);
  strokeWeight(2);
  for (int i = 0; i < segments; i++) {
    float angle = TWO_PI / segments * i;
    float x1 = 0;
    float y1 = 0;
    float x2 = cos(angle) * radius;
    float y2 = sin(angle) * radius;
    line(x1, y1, x2, y2);
  }
}

// Star polygon (using loops and conditionals)
void drawStarPolygon(int numPoints, float outerRadius, float innerRadius, color fillCol, color strokeCol, float alpha) {
  strokeWeight(3);
  stroke(strokeCol, alpha);
  fill(fillCol, alpha * 0.8);
  
  beginShape();
  for (int i = 0; i < numPoints * 2; i++) {
    float angle = TWO_PI / (numPoints * 2) * i;
    float r;
    
    // Conditional: alternate between outer and inner radius
    if (i % 2 == 0) {
      r = outerRadius;
    } else {
      r = innerRadius;
    }
    
    float x = cos(angle - HALF_PI) * r;
    float y = sin(angle - HALF_PI) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  // Gold outline
  noFill();
  strokeWeight(2);
  stroke(#FFD700, alpha);
  beginShape();
  for (int i = 0; i < numPoints * 2; i++) {
    float angle = TWO_PI / (numPoints * 2) * i;
    float r = (i % 2 == 0) ? outerRadius : innerRadius;
    float x = cos(angle - HALF_PI) * r;
    float y = sin(angle - HALF_PI) * r;
    vertex(x, y);
  }
  endShape(CLOSE);
}

// Complex multi-layer star
void drawComplexStar(int numPoints, float outer, float mid, float inner, color col1, color col2, color col3, float alpha) {
  // Outer star layer
  drawStarPolygon(numPoints, outer, mid, col1, col2, alpha);
  
  // Rotate and draw middle layer
  pushMatrix();
  rotate(PI / numPoints);
  drawStarPolygon(numPoints, mid, inner, col2, col3, alpha);
  popMatrix();
  
  // Center circle
  fill(col3, alpha);
  stroke(#FFD700, alpha);
  strokeWeight(2);
  ellipse(0, 0, inner * 0.8, inner * 0.8);
}

// Decorative ring (circles connected by lines)
void drawDecorativeRing(int numElements, float radius, color fillCol, color strokeCol, float alpha) {
  float circleSize = 30;
  
  // Draw connecting lines first
  stroke(#FFD700, alpha * 0.6);
  strokeWeight(2);
  noFill();
  beginShape();
  for (int i = 0; i <= numElements; i++) {
    float angle = TWO_PI / numElements * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);
  
  // Draw circles at each point
  for (int i = 0; i < numElements; i++) {
    float angle = TWO_PI / numElements * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    
    fill(fillCol, alpha * 0.7);
    stroke(strokeCol, alpha);
    strokeWeight(2);
    ellipse(x, y, circleSize, circleSize);
    
    // Inner decoration
    fill(strokeCol, alpha * 0.5);
    noStroke();
    ellipse(x, y, circleSize * 0.5, circleSize * 0.5);
  }
}

// Small circle ring (for detail)
void drawSmallCircleRing(int numCircles, float radius, float circleSize, color col, float alpha) {
  for (int i = 0; i < numCircles; i++) {
    float angle = TWO_PI / numCircles * i;
    float x = cos(angle) * radius;
    float y = sin(angle) * radius;
    
    fill(col, alpha * 0.8);
    stroke(#FFD700, alpha);
    strokeWeight(1.5);
    ellipse(x, y, circleSize, circleSize);
  }
}

// Glow ring effect (multiple transparent circles)
void drawGlowRing(float radius, color col, float intensity, float alpha) {
  noFill();
  
  // Draw multiple expanding rings for glow effect
  for (int i = 0; i < 5; i++) {
    float r = radius + i * 10;
    float glowAlpha = map(i, 0, 5, intensity * 20, 0);
    glowAlpha = min(glowAlpha, alpha); // Don't exceed layer opacity
    stroke(col, glowAlpha);
    strokeWeight(8 - i);
    ellipse(0, 0, r * 2, r * 2);
  }
}
