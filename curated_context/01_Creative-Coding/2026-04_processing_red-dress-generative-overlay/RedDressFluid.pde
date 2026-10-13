import gifAnimation.*;

Gif myAnimation;
PShader fluidShader;

void setup() {
  size(800, 800, P2D); // P2D is necessary for hardware-accelerated shaders
  
  // Load the GIF using the gifAnimation library
  myAnimation = new Gif(this, "Red Dress.gif");
  myAnimation.play(); // Start the loop
  
  // Load our custom liquid shader from the data folder
  fluidShader = loadShader("fluid.glsl");
}

void draw() {
  background(100); // Neutral gray background
  
  // Pass the running time to the shader so the liquid can move
  fluidShader.set("uTime", millis() / 1000.0);
  
  // Apply the shader to everything drawn after this line
  shader(fluidShader);
  
  // Draw the current frame of the GIF to the canvas
  // The shader will intercept this and distort the red parts
  image(myAnimation, 0, 0, width, height);
}