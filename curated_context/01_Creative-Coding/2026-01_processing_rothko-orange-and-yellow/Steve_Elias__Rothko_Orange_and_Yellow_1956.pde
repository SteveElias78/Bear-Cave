// Assignment 2: Painting Recreation
// Steve Elias Oregel
// Recreating: Mark Rothko - "Orange and Yellow" (1956)

void setup() {
  size(600, 800);  // tall canvas
  // tried different sizes but 600x800 matches the proportions best
  noLoop();
}

void draw() {
  background(180, 40, 20);
  // this dark orange-red creates the glowing effect rothko was known for
  
  noStroke();
  // rothko layered thin washes of paint with no hard edges
  
  // bright yellow-orange block at top
  fill(255, 200, 60, 220);
  rect(50, 80, 500, 250);
  // top rectangle - used transparency to let background show through slightly
  
  // orange middle section
  fill(255, 140, 40, 200);
  rect(50, 360, 500, 200);
  // middle section pulls more red, less yellow
  
  // darker bottom part
  fill(220, 80, 30, 210);
  rect(50, 590, 500, 150);
  // darkest rectangle grounds the composition
  
  filter(BLUR, 2);  // soften edges
  // blur mimics how his paint edges blur into each other
}
