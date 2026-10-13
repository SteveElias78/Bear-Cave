// Assignment 5: Crystalline Kaleidoscope
// Steve Elias Oregel | CRCP 6310 - Intro to Creative Coding

// Interactive rippling polygon bursts kaleidoscope
// Click creates Interactive polygon generator with kaleidoscope mirroring. 
// Uses the Assignment 4 color palettes with some new geometry tricks! 
// Click creates expanding bursts, patterns shift through 9 different color schemes. 
// Built on the radiating techniques from the starburst project but made it way more interactive this time.
// Arrow keys adjust complexity, spacebar resets.new patterns, arrows control complexity

// Demonstrates custom functions, trig, loops, polar/cartesian conversion

//CLICK OF MOUSE → New pattern + polygon burst + cycle colors
//SPACE → Reset everything
//UP/DOWN → Change polygon sides (3-12)
//LEFT/RIGHT → Change kaleidoscope segments (3-12)
//C → Manually cycle color palettes

// mirror ball pattern variables
PVector center; // keeps everything centered for the kaleidoscope effect
ArrayList circles = new ArrayList(); // stores circular ring radii
ArrayList quads = new ArrayList(); // stores quadrilateral vertices
ArrayList rays = new ArrayList(); // ray angles for the radiating pattern
ArrayList quad_rotation = new ArrayList(); // rotation speeds for each quad
color[] shape_colors = new color[35]; // colors for the concentric shapes
color[] ray_colors = new color[15]; // colors for the light rays
int shape_count, ray_count; // how many shapes and rays we're drawing
float ray_size, shape_radius, ray_rotation; // sizing and rotation params
float radius_change_max, radius_change_min, radius; // controls shape spacing
boolean irregular = false; // toggles between square and irregular quads
int color_mode = 0, bMode = 0; // blend mode settings
int[] modes = {HARD_LIGHT, SOFT_LIGHT}; // available blend modes

// kaleidoscope setup
int kaleidoscopeSegments = 6; // number of mirrored wedges (starts at 6)
float kaleidoscopeRotation = 0; // slow rotation of the whole pattern

// expanding polygon bursts (the ripple effect when you click)
ArrayList<ExpandingPolygon> polygons = new ArrayList<ExpandingPolygon>();
int sides = 6; // number of sides for the burst polygons

// assignment 4 color palettes because I liked those combinations - cycling through these on each click!
color[][] palettes = {
  {#FF006E, #FB5607, #FFBE0B, #8338EC, #3A86FF}, // vibrant
  {#E1BEE7, #90CAF9, #F8BBD0, #B39DDB, #80DEEA}, // pastel
  {#D946A6, #FFB300, #8E24AA, #C2185B, #F57F17}, // magenta gold
  {#06FFA5, #FFFB00, #FF006E, #00D9FF, #B967FF}, // neon
  {#2E294E, #541388, #F1E9DA, #FFD400, #D90368}, // dramatic
  {#C0C0C0, #D4A5A5, #FADADD, #E6C3B8, #B8B8B8}, // metallics
  {#4A148C, #1A237E, #BF360C, #880E4F, #004D40}, // jewel tones
  {#FFCDB2, #FFB4A2, #E5989B, #B5838D, #6D6875}, // warm earth
  {#001219, #005F73, #0A9396, #94D2BD, #E9D8A6}  // ocean
};
int currentPalette = 0; // which palette we're currently using

void setup() {
  size(1280, 720); // cinematic aspect ratio
  colorMode(HSB); // HSB makes color manipulation way easier
  smooth(8); // maximum anti-aliasing for smooth edges
  ellipseMode(RADIUS); // so radius values make sense
  
  // setting up sizing constraints based on canvas size
  radius = height * 3;
  radius_change_max = height / 10; // 10% of height for max spacing
  radius_change_min = height / 50; // 2% for min spacing
  
  // initialize with first mirror ball pattern
  center = new PVector(width/2, height/2);
  setupMirrorBall(false);
}

void draw() {
  drawGradientBG(); // soft gradient using current palette
  
  // okay so this is the kaleidoscope magic!!
  // we draw the mirror ball pattern multiple times in a circle
  // and flip half of them vertically to create the mirrored effect
  pushMatrix();
  translate(width/2, height/2); // everything rotates around center
  rotate(kaleidoscopeRotation); // slow spin of the whole thing
  
  for (int i = 0; i < kaleidoscopeSegments; i++) {
    pushMatrix();
    rotate(TWO_PI / kaleidoscopeSegments * i); // divide circle into equal wedges
    
    // draw the pattern normally
    pushMatrix();
    translate(center.x - width/2, center.y - height/2);
    drawMirrorBall();
    popMatrix();
    
    // draw it flipped for the mirror effect
    pushMatrix();
    scale(1, -1); // vertical flip
    translate(center.x - width/2, center.y - height/2);
    drawMirrorBall();
    popMatrix();
    
    popMatrix();
  }
  
  drawCenterGem(); // sparkly center to cover the yucky black void
  popMatrix();
  
  // polygon bursts drawn last so they're on top
  for (int i = polygons.size() - 1; i >= 0; i--) {
    ExpandingPolygon poly = polygons.get(i);
    poly.update();
    poly.display();
    if (poly.radius > max(width, height) * 1.2) polygons.remove(i); // cleanup
  }
  
  // animate the rotations because why not!
  for(int i = 0; i < rays.size(); i++) {
    rays.set(i, (Float)rays.get(i) + ray_rotation); // rotate rays
  }
  for(int i = 0; i < quads.size(); i++) {
    ArrayList quadri = (ArrayList)quads.get(i);
    ArrayList quadri2 = new ArrayList();
    for(int i2 = 0; i2 < 4; i2++) {
      PVector p = (PVector)quadri.get(i2);
      quadri2.add(rotatePoint(p.x, p.y, (Float)quad_rotation.get(i))); // rotate quads
    }
    quads.set(i, quadri2);
  }
  
  kaleidoscopeRotation += 0.003; // slow continuous spin
}

// soft gradient background that shifts with the palette
void drawGradientBG() {
  noStroke();
  color c1 = palettes[currentPalette][0];
  color c2 = palettes[currentPalette][palettes[currentPalette].length - 1];
  for (int y = 0; y < height; y += 4) {
    fill(lerpColor(c1, c2, map(y, 0, height, 0, 1)), 40);
    rect(0, y, width, 4);
  }
}

// sparkly gem in the center so there's no black void
void drawCenterGem() {
  color gem = palettes[currentPalette][2];
  noStroke();
  fill(gem, 60); ellipse(0, 0, 80, 80); // outer glow
  fill(gem, 120); ellipse(0, 0, 50, 50); // mid layer
  fill(gem, 200); ellipse(0, 0, 25, 25); // bright center
  fill(255, 255, 255, 250); ellipse(0, 0, 8, 8); // white sparkle
}

// this draws the radiating mirror ball pattern
// it's a combination of circles and quads with rays between them
void drawMirrorBall() {
  noStroke();
  for(int i = shape_count; i > 0; i--) {
    color C1 = shape_colors[i - 1];
    
    if (i % 2 == 0) { // quads on even layers
      for(int i2 = 0; i2 < ray_count * 2; i2++) {
        float ray1 = (Float)rays.get(i2);
        float ray2 = (Float)rays.get((i2 + 1) % (ray_count * 2));
        ArrayList quadri = (ArrayList)quads.get(i / 2 - 1);
        
        // finding where rays intersect quad edges
        for(int i3 = 0; i3 < 4; i3++) {
          PVector p1 = (PVector)quadri.get(i3);
          PVector p2 = (PVector)quadri.get((i3 + 1) % 4);
          PVector int1 = segIntersection(0, 0, cos(ray1)*height*2, sin(ray1)*height*2, p1.x, p1.y, p2.x, p2.y);
          
          if (int1 != null) {
            // alternating colors between shape color and ray color
            fill((i2 % 2 == 0) ? C1 : blendColor(C1, ray_colors[(i2-1)/2], modes[bMode]));
            
            PVector int2 = segIntersection(0, 0, cos(ray2)*height*2, sin(ray2)*height*2, p1.x, p1.y, p2.x, p2.y);
            if (int2 != null) {
              // both rays hit same edge - simple triangle
              beginShape();
              vertex(int1.x + center.x, int1.y + center.y);
              vertex(center.x, center.y);
              vertex(int2.x + center.x, int2.y + center.y);
              endShape();
            } else {
              // rays hit different edges - need to wrap around corner
              PVector p3 = (PVector)quadri.get((i3 + 2) % 4);
              int2 = segIntersection(0, 0, cos(ray2)*height*2, sin(ray2)*height*2, p2.x, p2.y, p3.x, p3.y);
              if (int2 != null) {
                beginShape();
                vertex(int1.x + center.x, int1.y + center.y);
                vertex(p2.x + center.x, p2.y + center.y);
                vertex(int2.x + center.x, int2.y + center.y);
                vertex(center.x, center.y);
                endShape();
              }
            }
            break;
          }
        }
      }
    } else { // circles on odd layers
      float rad = (Float)circles.get((i - 1) / 2);
      for(int i2 = 0; i2 < ray_count * 2; i2++) {
        fill((i2 % 2 == 0) ? C1 : blendColor(C1, ray_colors[i2/2], modes[bMode]));
        float ray1 = (Float)rays.get(i2);
        float ray2 = (Float)rays.get((i2 + 1) % (ray_count * 2));
        arc(center.x, center.y, rad, rad, ray1, ray2);
      }
    }
  }
}

// sets up a new mirror ball pattern with random parameters
void setupMirrorBall(boolean shapes_only) {
  center = new PVector(width/2, height/2);
  ray_count = int(random(5, 12)); // how many rays radiate out
  ray_size = TWO_PI / ray_count * random(0.2, 0.7); // width of each ray
  shape_radius = random(radius_change_min, radius_change_max) + 15;
  
  if (!shapes_only) color_mode = int(random(4));
  
  shape_count = 0;
  circles.clear(); quads.clear(); rays.clear(); quad_rotation.clear();
  
  // building concentric layers of circles and quads
  while(shape_radius < height * 0.6) {
    if (shape_count % 2 == 0) {
      shape_radius += random(radius_change_min, radius_change_max);
      circles.add(shape_radius);
    } else {
      ArrayList quadri = new ArrayList();
      if (irregular) {
        // irregular quads - vertices at random angles
        ArrayList angles = new ArrayList();
        float ang = 0;
        for(int i = 0; i < 4; i++) {
          ang += 3*PI/8 + random(PI/4);
          angles.add(ang);
        }
        float biggest = TWO_PI - (Float)angles.get(3) + (Float)angles.get(0);
        for(int i = 1; i < 4; i++) {
          if ((Float)angles.get(i) - (Float)angles.get(i-1) > biggest)
            biggest = (Float)angles.get(i) - (Float)angles.get(i-1);
        }
        shape_radius = shape_radius / sqrt(1 - sq(sin(biggest/2))) + random(radius_change_min, radius_change_max);
        for(int i = 0; i < 4; i++) {
          quadri.add(new PVector(cos((Float)angles.get(i)) * shape_radius, sin((Float)angles.get(i)) * shape_radius));
        }
      } else {
        // regular squares
        shape_radius = sqrt(2) * shape_radius + random(radius_change_min, radius_change_max);
        float ang = random(TWO_PI);
        for(int i = 0; i < 4; i++) {
          quadri.add(new PVector(cos(ang) * shape_radius, sin(ang) * shape_radius));
          ang += HALF_PI;
        }
      }
      quads.add(quadri);
      quad_rotation.add(random(-0.025, 0.025)); // random rotation speed
    }
    shape_count++;
  }
  
  // assign colors from current palette
  for(int i = 0; i < shape_colors.length; i++) {
    color pc = palettes[currentPalette][i % palettes[currentPalette].length];
    shape_colors[i] = color(hue(pc), saturation(pc), brightness(pc));
  }
  
  // set up the radiating rays
  float angle = TWO_PI / ray_count * random(1);
  for(int i = 0; i < ray_count; i++) {
    rays.add(angle);
    rays.add(angle + ray_size);
    angle += TWO_PI / ray_count;
  }
  
  // ray colors
  for(int i = 0; i < ray_colors.length; i++) {
    color pc = palettes[currentPalette][(i + 2) % palettes[currentPalette].length];
    ray_colors[i] = color(hue(pc), saturation(pc), brightness(pc), 150);
  }
  
  if (!shapes_only) ray_rotation = random(-0.075, 0.075);
}

// finds where two line segments intersect (returns null if they don't)
// using vector math - this is how we figure out where rays hit quad edges
PVector segIntersection(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  float bx = x2 - x1, by = y2 - y1, dx = x4 - x3, dy = y4 - y3;
  float b_dot_d_perp = bx * dy - by * dx;
  if(b_dot_d_perp == 0) return null; // parallel lines
  float cx = x3 - x1, cy = y3 - y1;
  float t = (cx * dy - cy * dx) / b_dot_d_perp;
  if(t < 0 || t > 1) return null; // intersection outside segment 1
  float u = (cx * by - cy * bx) / b_dot_d_perp;
  if(u < 0 || u > 1) return null; // intersection outside segment 2
  return new PVector(x1 + t*bx, y1 + t*by);
}

// rotates a point around the origin using trig
// this is how we spin the quads
PVector rotatePoint(float x, float y, float angle) {
  return new PVector(cos(angle)*x - sin(angle)*y, cos(angle)*y + sin(angle)*x);
}

// draws a polygon with n sides using polar to cartesian conversion
// this is the core function for creating our polygon bursts
void drawPolygon(float x, float y, float r, int n) {
  beginShape();
  for (float a = 0; a < TWO_PI; a += TWO_PI/n) {
    vertex(x + cos(a)*r, y + sin(a)*r); // polar to cartesian
  }
  endShape(CLOSE);
}

// class for the expanding polygon bursts
// these are the ripples that appear when you click and 
// change shape when you press the up or down button!
class ExpandingPolygon {
  float x, y, radius, speed;
  color col;
  
  ExpandingPolygon(float x, float y) {
    this.x = x; this.y = y;
    this.radius = 1;
    this.speed = 4; // expands pretty quickly
    color pc = palettes[currentPalette][int(random(palettes[currentPalette].length))];
    this.col = color(hue(pc), saturation(pc), brightness(pc), 200);
  }
  
  void update() {
    if (radius < max(width, height) * 1.2) radius += speed;
  }
  
  void display() {
    noFill();
    // outer glow
    stroke(hue(col), saturation(col), brightness(col), 80);
    strokeWeight(5);
    drawPolygon(x, y, radius + 20, sides);
    // main ring
    stroke(col);
    strokeWeight(3);
    drawPolygon(x, y, radius, sides);
    // inner bright ring
    stroke(hue(col), saturation(col), 255, 220);
    strokeWeight(1.5);
    drawPolygon(x, y, radius - 10, sides);
  }
}

// click anywhere: new mirror ball pattern + polygon burst + next color palette
void mousePressed() {
  irregular = random(1) > 0.5; // randomly decide if quads are irregular
  setupMirrorBall(false);
  polygons.add(new ExpandingPolygon(mouseX, mouseY));
  currentPalette = (currentPalette + 1) % palettes.length; // cycle palettes
}

// keyboard controls for tweaking the visuals
void keyPressed() {
  if (key == ' ') { // spacebar resets everything over and over!    
    polygons.clear();
    sides = 6;
    kaleidoscopeSegments = 6;
    setupMirrorBall(false);
  }
  if (keyCode == UP) sides = min(sides + 1, 12); // more polygon sides
  if (keyCode == DOWN) sides = max(sides - 1, 3); // fewer polygon sides
  if (keyCode == LEFT) kaleidoscopeSegments = max(kaleidoscopeSegments - 1, 3); // fewer mirror segments
  if (keyCode == RIGHT) kaleidoscopeSegments = min(kaleidoscopeSegments + 1, 12); // more mirror segments
  if (key == 'c' || key == 'C') currentPalette = (currentPalette + 1) % palettes.length; // cycle colors manually
}
