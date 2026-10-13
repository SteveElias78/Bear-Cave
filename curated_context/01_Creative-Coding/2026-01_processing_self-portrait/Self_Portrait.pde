/**
 * CRCP 6310 - Assignment 3: "Living-Self-Portrait"
 * * CONCEPT:
 * This sketch deconstructs a traditional raster self-portrait into a "quantized" field of data.
 * Instead of displaying the image as a flat picture, I am rebuilding it pixel-by-pixel 
 * using thousands of interactive geometric tiles.
 * * INTERACTION:
 * The portrait is "alive." As the viewer moves their mouse, they disrupt the data field,
 * causing the tiles to expand and rotate. This represents how our digital self is 
 * constantly in flux and reactive to external observation.
 */

// --- GLOBAL VARIABLES ---
PImage img;             // The container for our base image file
float minTileSize = 5;  // The smallest a data block can be (for dark/shadow areas)
float maxTileSize = 25; // The largest a data block can get (used during interaction)

void setup() {
  // matching the aspect ratio of the original portrait image (800x1066)
  size(800, 1066); 
  
  // This helps the geometry edges look smooth and polished, not jagged
  smooth();
  
  // --- IMAGE LOADING & PREP ---
  // We look for the file inside the sketch's 'data' folder.
  // Using a relative path ensures this runs on any computer.
  img = loadImage("base_portrait.jpg");
  
  // Safety Check: We only proceed if the image actually loaded.
  // This prevents the "NullPointerException" crash if the file is missing.
  if (img != null) {
    
    // Resize the image to fit the window exactly. 
    // This creates a 1-to-1 mapping between the window coordinates and image pixels.
    img.resize(width, height);
    
    // CRITICAL STEP: .loadPixels() unlocks the image's data.
    // Without this, we can't read the specific color of each pixel in the loop below.
    img.loadPixels(); 
    
  } else {
    println("ERROR: Image not found! Please check the 'data' folder.");
  }
  
  // Design Choice: I'm removing the stroke (outline) from shapes to make the 
  // composition look like a cohesive field of data rather than a wireframe mesh.
  noStroke(); 
  
  // Drawing rectangles from their center point makes rotation much easier to control later.
  rectMode(CENTER);
}

void draw() {
  // --- BACKGROUND REFRESH ---
  // I'm using a dark, off-black background (RGB: 30, 25, 35).
  // This acts like a dark screen, making the colors of the portrait "pop" 
  // and ensuring gaps between tiles look intentional.
  background(30, 25, 35); 
  
  // If the image failed to load, we exit 'draw' immediately to avoid errors.
  if (img == null) return; 
  
  // --- THE GRID LOOP ---
  // Instead of drawing the image once, we loop through it in a grid pattern.
  // 'step' controls the resolution or "blockiness" of the portrait.
  // A step of 12 means we sample a pixel every 12 pixels across and down.
  int step = 12; 
  
  for (int x = 0; x < width; x += step) {
    for (int y = 0; y < height; y += step) {
      
      // --- STEP 1: DATA EXTRACTION ---
      // Calculate the exact ID (index) of the pixel at coordinate (x, y).
      // The pixels[] array is one long list, so we use math to find the right spot.
      int loc = x + y * width;
      
      // Grab the color from the original image at this location.
      color c = img.pixels[loc];
      
      // --- STEP 2: DATA ANALYSIS ---
      // We aren't just copying the color; we are analyzing its brightness (0-255).
      // Light parts of the face (cheeks, forehead) will have high brightness.
      // Dark parts (hair, beard) will have low brightness.
      float b = brightness(c);
      
      // --- STEP 3: INTERACTIVITY (THE "LENS" EFFECT) ---
      // Calculate how far this specific tile is from the user's mouse cursor.
      float d = dist(mouseX, mouseY, x, y);
      
      // We create a "mouseFactor" based on that distance.
      // If the mouse is close (0-200 pixels), this factor goes up. 
      // If the mouse is far away, the factor is 0.
      float mouseFactor = map(d, 0, 200, 2, 0); 
      
      // We clamp the value so it doesn't get too crazy or negative.
      mouseFactor = constrain(mouseFactor, 0, 2);
      
      // --- STEP 4: GENERATIVE GEOMETRY LOGIC ---
      // This is the core algorithm:
      // The SIZE of the tile is determined by the BRIGHTNESS of the original pixel.
      // Brighter areas = Larger tiles. Darker areas = Smaller tiles.
      float size = map(b, 0, 255, minTileSize, step);
      
      // Now we add the interaction: We multiply the size by the mouseFactor.
      // This creates the "magnifying glass" effect when you hover.
      size = size * (1 + mouseFactor); 
      
      // --- STEP 5: RENDERING THE TILE ---
      // pushMatrix() saves the current coordinate system.
      // This isolates the movement of THIS specific tile so it doesn't affect the others.
      pushMatrix();
      
      // Move the "pen" to the current grid location (x, y)
      translate(x, y);
      
      // Set the fill color to the original pixel color.
      // I added '240' as a second argument to create slight transparency (Alpha),
      // giving the portrait a layered, glass-like texture.
      fill(c, 240); 
      
      // Dynamic Rotation: 
      // 1. rotate(radians(b)) -> Rotates the tile based on its brightness (fixed angle).
      // 2. + frameCount * 0.02 -> Adds a continuous, slow spin over time.
      rotate(radians(b) + frameCount * 0.02); 
      
      // Finally, draw the shape. 
      // Using 'rect' gives it a tech/digital feel.
      // You could swap this for 'ellipse' for a pointillist look.
      rect(0, 0, size, size);
      
      // popMatrix() restores the coordinate system for the next loop iteration.
      popMatrix();
    }
  }
}
