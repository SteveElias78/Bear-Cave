// Assignment 4: 2D Generative Geometry
// Steve Elias Oregel
// inspired by mid-century modern geometric editorial design

color[] palette;
int numShapes;
float noiseScale = 0.015;  // for texture

void setup() {
  size(1000, 1000);  // square format like the reference
  
  // sophisticated editorial color palette
  palette = new color[8];
  palette[0] = color(200, 130, 60);   // burnt orange
  palette[1] = color(220, 200, 170);  // cream/beige
  palette[2] = color(40, 50, 80);     // navy/black
  palette[3] = color(220, 160, 90);   // golden yellow
  palette[4] = color(200, 100, 90);   // coral/salmon
  palette[5] = color(90, 120, 90);    // sage green
  palette[6] = color(100, 80, 130);   // purple
  palette[7] = color(180, 170, 160);  // warm gray
  
  numShapes = int(random(12, 25));
  
  background(235, 225, 210);  // warm off-white like reference
  noLoop();
  
  drawGenerativeComposition();
}

void draw() {
  // composition happens in setup
}

void drawGenerativeComposition() {
  
  // draw layered shapes from back to front
  for (int i = 0; i < numShapes; i++) {
    float x = random(width * 0.2, width * 0.8);
    float y = random(height * 0.2, height * 0.8);
    float size = random(150, 400);
    
    // choose shape type randomly
    float choice = random(1);
    
    if (choice < 0.3) {
      drawRoundedRect(x, y, size);
    } else if (choice < 0.5) {
      drawCapsule(x, y, size);
    } else if (choice < 0.7) {
      drawArc(x, y, size);
    } else if (choice < 0.85) {
      drawCircle(x, y, size);
    } else {
      drawPill(x, y, size);
    }
  }
  
  // add subtle texture overlay
  addTexture();
}

// rounded rectangle using vertex
void drawRoundedRect(float x, float y, float size) {
  color c = palette[int(random(palette.length))];
  fill(red(c), green(c), blue(c), random(180, 230));
  noStroke();
  
  float w = size * random(0.6, 1.2);
  float h = size * random(0.6, 1.2);
  float r = size * 0.15;  // corner radius
  
  beginShape();
  
  // top edge with rounded corners
  vertex(x - w/2 + r, y - h/2);
  vertex(x + w/2 - r, y - h/2);
  
  // top-right corner
  for (float a = -HALF_PI; a <= 0; a += 0.1) {
    vertex(x + w/2 - r + cos(a) * r, y - h/2 + r + sin(a) * r);
  }
  
  // right edge
  vertex(x + w/2, y + h/2 - r);
  
  // bottom-right corner
  for (float a = 0; a <= HALF_PI; a += 0.1) {
    vertex(x + w/2 - r + cos(a) * r, y + h/2 - r + sin(a) * r);
  }
  
  // bottom edge
  vertex(x - w/2 + r, y + h/2);
  
  // bottom-left corner
  for (float a = HALF_PI; a <= PI; a += 0.1) {
    vertex(x - w/2 + r + cos(a) * r, y + h/2 - r + sin(a) * r);
  }
  
  // left edge
  vertex(x - w/2, y - h/2 + r);
  
  // top-left corner
  for (float a = PI; a <= PI + HALF_PI; a += 0.1) {
    vertex(x - w/2 + r + cos(a) * r, y - h/2 + r + sin(a) * r);
  }
  
  endShape(CLOSE);
}

// capsule/pill shape using vertex
void drawCapsule(float x, float y, float size) {
  color c = palette[int(random(palette.length))];
  fill(red(c), green(c), blue(c), random(180, 230));
  noStroke();
  
  float w = size * random(0.4, 0.7);
  float h = size * random(0.8, 1.5);
  float r = w / 2;  // radius for rounded ends
  
  beginShape();
  
  // left straight edge
  vertex(x - w/2, y - h/2 + r);
  vertex(x - w/2, y + h/2 - r);
  
  // bottom rounded end
  for (float a = PI; a <= TWO_PI; a += 0.1) {
    vertex(x + cos(a) * r, y + h/2 - r + sin(a) * r);
  }
  
  // right straight edge
  vertex(x + w/2, y + h/2 - r);
  vertex(x + w/2, y - h/2 + r);
  
  // top rounded end
  for (float a = 0; a <= PI; a += 0.1) {
    vertex(x + cos(a) * r, y - h/2 + r + sin(a) * r);
  }
  
  endShape(CLOSE);
}

// arc shape using vertex
void drawArc(float x, float y, float size) {
  color c = palette[int(random(palette.length))];
  fill(red(c), green(c), blue(c), random(180, 230));
  noStroke();
  
  float radius = size * random(0.7, 1.0);
  float thickness = size * random(0.3, 0.5);
  float startAngle = random(TWO_PI);
  float arcAngle = random(PI * 0.5, PI * 1.5);
  
  beginShape();
  
  // outer arc
  for (float a = startAngle; a <= startAngle + arcAngle; a += 0.1) {
    vertex(x + cos(a) * radius, y + sin(a) * radius);
  }
  
  // inner arc (going backwards)
  for (float a = startAngle + arcAngle; a >= startAngle; a -= 0.1) {
    vertex(x + cos(a) * (radius - thickness), y + sin(a) * (radius - thickness));
  }
  
  endShape(CLOSE);
}

// circle with texture using vertex
void drawCircle(float x, float y, float size) {
  color c = palette[int(random(palette.length))];
  fill(red(c), green(c), blue(c), random(180, 230));
  noStroke();
  
  float radius = size * random(0.4, 0.7);
  
  beginShape();
  
  for (float a = 0; a <= TWO_PI; a += 0.05) {
    // add slight irregularity for organic feel
    float r = radius + random(-3, 3);
    vertex(x + cos(a) * r, y + sin(a) * r);
  }
  
  endShape(CLOSE);
}

// horizontal pill shape using vertex
void drawPill(float x, float y, float size) {
  color c = palette[int(random(palette.length))];
  fill(red(c), green(c), blue(c), random(180, 230));
  noStroke();
  
  float w = size * random(0.8, 1.5);
  float h = size * random(0.3, 0.5);
  float r = h / 2;
  
  beginShape();
  
  // top edge
  vertex(x - w/2 + r, y - h/2);
  vertex(x + w/2 - r, y - h/2);
  
  // right rounded end
  for (float a = -HALF_PI; a <= HALF_PI; a += 0.1) {
    vertex(x + w/2 - r + cos(a) * r, y + sin(a) * r);
  }
  
  // bottom edge
  vertex(x + w/2 - r, y + h/2);
  vertex(x - w/2 + r, y + h/2);
  
  // left rounded end
  for (float a = HALF_PI; a <= PI + HALF_PI; a += 0.1) {
    vertex(x - w/2 + r + cos(a) * r, y + sin(a) * r);
  }
  
  endShape(CLOSE);
}

// add subtle grain texture like the reference image
void addTexture() {
  loadPixels();
  
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y * width;
      
      // get current pixel color
      color currentColor = pixels[loc];
      
      // add noise-based grain
      float noiseVal = noise(x * noiseScale, y * noiseScale);
      float grain = map(noiseVal, 0, 1, -15, 15);
      
      // apply grain
      float r = red(currentColor) + grain;
      float g = green(currentColor) + grain;
      float b = blue(currentColor) + grain;
      
      pixels[loc] = color(r, g, b);
    }
  }
  
  updatePixels();
}

// click to regenerate
void mouseClicked() {
  setup();
}

// press 's' to save
void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("SteveOregel_Generative_####.png");
    println("Saved!");
  }
}

// created generative system inspired by mid-century modern geometric design
// uses vertex commands to build organic rounded shapes
// layered composition with transparency creates depth
// sophisticated editorial color palette
// texture overlay adds luxury printed feel
// connects to my magazine editorial background
