# Code Digest

The header comments from every sketch and script in this folder, in my own words, so an AI can read what each piece is and why I made it without parsing the code. The source files sit next to their paths below.

## `01_Creative-Coding/2026-01_processing_grid-drawing/gridDraw.pde`

(no header comments)

## `01_Creative-Coding/2026-01_processing_grid-drawing/gridDrawing.pde`

> drawGrid();
> verticalLines();
> drawHWGrid(300, 500);

## `01_Creative-Coding/2026-01_processing_rothko-orange-and-yellow/Steve_Elias__Rothko_Orange_and_Yellow_1956.pde`

> Assignment 2: Painting Recreation
> Steve Elias Oregel
> Recreating: Mark Rothko - "Orange and Yellow" (1956)
> tried different sizes but 600x800 matches the proportions best
> this dark orange-red creates the glowing effect rothko was known for
> rothko layered thin washes of paint with no hard edges
> bright yellow-orange block at top
> top rectangle - used transparency to let background show through slightly
> orange middle section
> middle section pulls more red, less yellow
> darker bottom part
> darkest rectangle grounds the composition
> blur mimics how his paint edges blur into each other

## `01_Creative-Coding/2026-01_processing_self-portrait/Self_Portrait.pde`

> CRCP 6310 - Assignment 3: "Living-Self-Portrait"
> * CONCEPT:
> This sketch deconstructs a traditional raster self-portrait into a "quantized" field of data.
> Instead of displaying the image as a flat picture, I am rebuilding it pixel-by-pixel
> using thousands of interactive geometric tiles.
> * INTERACTION:
> The portrait is "alive." As the viewer moves their mouse, they disrupt the data field,
> causing the tiles to expand and rotate. This represents how our digital self is
> constantly in flux and reactive to external observation.
> --- GLOBAL VARIABLES ---
> matching the aspect ratio of the original portrait image (800x1066)
> This helps the geometry edges look smooth and polished, not jagged
> --- IMAGE LOADING & PREP ---
> We look for the file inside the sketch's 'data' folder.
> Using a relative path ensures this runs on any computer.
> Safety Check: We only proceed if the image actually loaded.
> This prevents the "NullPointerException" crash if the file is missing.
> Resize the image to fit the window exactly.
> This creates a 1-to-1 mapping between the window coordinates and image pixels.
> CRITICAL STEP: .loadPixels() unlocks the image's data.
> Without this, we can't read the specific color of each pixel in the loop below.
> Design Choice: I'm removing the stroke (outline) from shapes to make the
> composition look like a cohesive field of data rather than a wireframe mesh.
> Drawing rectangles from their center point makes rotation much easier to control later.
> --- BACKGROUND REFRESH ---

## `01_Creative-Coding/2026-02_p5js_sacred-geometry-mandala-vortex.js`

> STEVE ELIAS OREGEL - SACRED GEOMETRY MANDALA INSTALLATION
> CRCP 6310 - Assignment 6: Mandala
> So basically this is a 13-layer mandala that rotates in 3D space
> think of it like looking down into a well where each layer is a circular
> plate spinning at different speeds - creates this hypnotic vortex effect
> i'm using the golden ratio (1.618...) for rotation speeds because that's
> what makes spirals look naturally pleasing - same math you see in nautilus
> shells and sunflower seed patterns
> the colors go from dark/deep (purple) at the bottom to bright (gold) at the top
> which helps sell that "looking down into depth" feeling
> GLOBAL VARIABLES
> color palettes - dark to light progression
> each layer gets 4 colors: main fill, secondary fill, accent, and highlight
> keeping gold for visual consistency
> SETUP - runs once when you hit play
> create all 13 layers with different depths and sizes
> z-depth: map each layer from way back (-1000) to close up (150)
> this is what creates the "well" effect
> scale: smaller when further away (perspective)
> rotation speed using golden ratio math
> phi = 1.618 is the golden ratio - shows up everywhere in nature
> playing with this value until the spin felt right
> flip direction for every other layer to create vortex spiral
> actually create the layer object
> print controls to console

## `01_Creative-Coding/2026-02_processing_crystalline-kaleidoscope.pde`

> Assignment 5: Crystalline Kaleidoscope
> Steve Elias Oregel | CRCP 6310 - Intro to Creative Coding
> Interactive rippling polygon bursts kaleidoscope
> Click creates Interactive polygon generator with kaleidoscope mirroring.
> Uses the Assignment 4 color palettes with some new geometry tricks!
> Click creates expanding bursts, patterns shift through 9 different color schemes.
> Built on the radiating techniques from the starburst project but made it way more interactive this time.
> Arrow keys adjust complexity, spacebar resets.new patterns, arrows control complexity
> Demonstrates custom functions, trig, loops, polar/cartesian conversion
> CLICK OF MOUSE → New pattern + polygon burst + cycle colors
> SPACE → Reset everything
> UP/DOWN → Change polygon sides (3-12)
> LEFT/RIGHT → Change kaleidoscope segments (3-12)
> C → Manually cycle color palettes
> mirror ball pattern variables
> kaleidoscope setup
> expanding polygon bursts (the ripple effect when you click)
> assignment 4 color palettes because I liked those combinations - cycling through these on each click!
> setting up sizing constraints based on canvas size
> initialize with first mirror ball pattern
> okay so this is the kaleidoscope magic!!
> we draw the mirror ball pattern multiple times in a circle
> and flip half of them vertically to create the mirrored effect
> draw the pattern normally
> draw it flipped for the mirror effect

## `01_Creative-Coding/2026-02_processing_crystalline-prism.pde`

> Assignment 5: Crystalline Prism
> Steve Elias
> CRCP 6310 - Creative Computing
> so this is basically my take on merging luxury fashion aesthetics with geometric code
> wanted something that feels more gallery installation than typical student project
> the icosahedron from nano banana sits in the back doing its thing while the prisms dance
> color palettes - hybrid approach mixing the magenta/gold vibes with holographic pastels
> switching between these with mouse clicks to keep it dynamic
> palette 0: magenta + gold (from my assignment 4 screenshot energy)
> palette 1: holographic pastels (icosahedron vibes)
> palette 2: luxury silver/rose gold hybrid
> palette 3: deep jewel tones (because why not)
> loading the nano banana icosahedron
> keeping it static because rotation on rotation felt too busy in testing
> sometimes restraint is the luxury move
> drawing the icosahedron background first
> tinted slightly transparent so the prisms pop in front
> okay so here's where the magic happens
> drawing multiple prisms at different speeds and sizes
> this creates that kaleidoscope layering effect
> alternating between filled and outline for visual interest
> increment the main angle - this drives all rotation
> keeping it slow and meditative, not aggressive
> this is the main function doing the heavy lifting
> using trig to calculate polygon vertices because that's what the module wants

## `01_Creative-Coding/2026-02_processing_editorial-generative-geometry.pde`

> Assignment 4: 2D Generative Geometry
> Steve Elias Oregel
> inspired by mid-century modern geometric editorial design
> sophisticated editorial color palette
> composition happens in setup
> draw layered shapes from back to front
> choose shape type randomly
> add subtle texture overlay
> rounded rectangle using vertex
> top edge with rounded corners
> top-right corner
> right edge
> bottom-right corner
> bottom edge
> bottom-left corner
> left edge
> top-left corner
> capsule/pill shape using vertex

## `01_Creative-Coding/2026-02_processing_heavenly-bodies/Body.pde`

>  B O D Y . p d e
>  n-Body gravitational simulation, Shiffman Chapter 2
>  Each Body has mass, position, velocity, acceleration.
>  attract() applies Newton's F = G*m1*m2/r² to 'other'.
>  Planet positions are SET parametrically in draw() before
>  attract() runs, so update() only integrates vel/acc.
>  The star's corona is drawn separately in the main sketch
>  as a tight ellipse, Body.draw() skips the star glow
>  to prevent the massive cream blob that was covering the belt.
> ── attract ───
> ── update ───
> Only integrates velocity, pos is set parametrically
> pos.add(vel) , omitted, parametric positioning owns pos
> ── draw ───
> Star (mass >= 1000), skip draw entirely here.
> The main sketch draws the corona as a tight PERSP-correct
> ellipse that stays inside the belt boundary.
> Planets, layered glow, kept compact
> Outer atmospheric haze
> Planet body
> Hot spot

## `01_Creative-Coding/2026-02_processing_heavenly-bodies/Heavenly_Bodies.pde`

>  H E A V E N L Y   B O D I E S
>  Week 9, Dynamic Weather Systems / 2D Arrays & Nested Loops
>  CRCP 6310 · Steve Elias
>  based on HR 8799, a real directly-imaged exoplanet system
>  133 light-years away in Pegasus. four super-Jupiter planets,
>  a warm inner asteroid belt, a cold outer Kuiper ring.
>  the GIF is a perspective-tilted view of the orbital plane.
>  i pixel-measured the planet positions in Photoshop to extract
>  the exact ellipse everything is anchored to:
>    planet orbit rx=347px, ry=227px, PERSP=227/347=0.654
>  five systems running simultaneously:
>    1. four planets, parametric ellipse + n-body attract()
>    2. inner asteroid belt, float[COLS][ROWS] 2D grid
>    3. outer Kuiper ring , float[KCOLS][KROWS] 2D grid
>    4. comet ejections   , debris flung from both rings
>    5. background stars  , float[] twinkle overlay on GIF stars
>  plus a Dyson sphere particle cage because why not!
> ── measured geometry ───
> PERSP is the Y compression from the 35° viewing angle.
> belt ellipse measured separately, different orbital radius
> means different foreshortening, can't just derive it from PERSP.
> Kuiper ring centered at r=510-580 to sit on the GIF's painted band.
> ── physics, NOT real G, tuned for pixel-scale aesthetics ──
> ── n-body: Shiffman Ch.2 structure ───
> bodies[0]=star, [1-4]=planets. pure n-body is too chaotic at

## `01_Creative-Coding/2026-02_processing_heavenly-bodies/poly.pde`

>  P O L Y . p d e
>  Reusable polygon drawing functions
>  Same poly tab from the previous assignments, I'm keeping
>  this consistent across the whole semester so the you
>  can see the reuse and abstraction principle in practice.
>  starPoly() is the one I'm using for asteroid particles , 
>  alternating outer/inner radius on the unit circle walk
>  gives that jagged rocky shape that reads as asteroid debris.
> poly, regular n-sided polygon
> cx, cy = center   r = radius   n = number of sides
> starPoly, n-pointed star with alternating outer/inner radius
> outer = outer tip radius   inner = inner notch radius   n = number of points
> The same unit circle walk as poly() but every other vertex
> pulls inward, that's what creates the star / snowflake geometry.
> For asteroids I use a low inner ratio (0.35–0.5) so they look
> jagged and rocky rather than perfectly star-shaped.

## `01_Creative-Coding/2026-02_processing_kaleidoscope-openprocessing.pde`

> Assignment 5: Crystalline Kaleidoscope
> Steve Elias Oregel | CRCP 6310 - Intro to Creative Coding
> Interactive rippling polygon bursts kaleidoscope
> Click creates Interactive polygon generator with kaleidoscope mirroring.
> Uses the Assignment 4 color palettes with some new geometry tricks!
> Click creates expanding bursts, patterns shift through 9 different color schemes.
> Built on the radiating techniques from the starburst project but made it way more interactive this time.
> Arrow keys adjust complexity, spacebar resets.new patterns, arrows control complexity
> Demonstrates custom functions, trig, loops, polar/cartesian conversion
> CLICK OF MOUSE → New pattern + polygon burst + cycle colors
> SPACE → Reset everything
> UP/DOWN → Change polygon sides (3-12)
> LEFT/RIGHT → Change kaleidoscope segments (3-12)
> C → Manually cycle color palettes
> mirror ball pattern variables
> kaleidoscope setup
> expanding polygon bursts (the ripple effect when you click)
> assignment 4 color palettes because I liked those combinations - cycling through these on each click!
> setting up sizing constraints based on canvas size
> initialize with first mirror ball pattern
> okay so this is the kaleidoscope magic!!
> we draw the mirror ball pattern multiple times in a circle
> and flip half of them vertically to create the mirrored effect
> draw the pattern normally
> draw it flipped for the mirror effect

## `01_Creative-Coding/2026-02_processing_mandala-layers/Mandala.pde`

> STEVE ELIAS OREGEL - SACRED GEOMETRY MANDALA INSTALLATION
> CRCP 6310 - Assignment 6: Mandala
> So basically this is a 13-layer mandala that rotates in 3D space
> think of it like looking down into a well where each layer is a circular
> plate spinning at different speeds - creates this hypnotic vortex effect
> i'm using the golden ratio (1.618...) for rotation speeds because that's
> what makes spirals look naturally pleasing - same math you see in nautilus
> shells and sunflower seed patterns
> the colors go from dark/deep (purple) at the bottom to bright (gold) at the top
> which helps sell that "looking down into depth" feeling
> GLOBAL VARIABLES
> color palettes - dark to light progression
> each layer gets 4 colors: main fill, secondary fill, accent, and highlight
> keeping gold (#FFD700) on every layer for visual consistency
> SETUP - runs once when you hit play
> create all 13 layers with different depths and sizes
> z-depth: map each layer from way back (-1000) to close up (150)
> this is what creates the "well" effect
> scale: smaller when further away (perspective)
> rotation speed using golden ratio math
> phi = 1.618 is the golden ratio - shows up everywhere in nature
> playing with this value until the spin felt right
> flip direction for every other layer to create vortex spiral
> actually create the layer object
> print controls to console (cleaner than on-screen text)

## `01_Creative-Coding/2026-02_processing_mandala-layers/MandalaLayer.pde`

> MANDALA LAYER CLASS
> so each layer is basically one complete mandala at a specific depth
> they all spin independently which is what creates the vortex effect
> each layer needs to know:
> - where it is in 3D space (how far back)
> - how big it should be (smaller = further away)
> - how fast to spin (and which direction)
> - what colors to use
> - how detailed to draw (simple/medium/complex)
> position stuff
> visual properties
> colors and style
> animation timing
> CONSTRUCTOR - sets up a new layer
> store the basics
> assign edge shape - cycles through rounded/sharp/curved
> using a pattern that looks good visually
> figure out opacity based on depth
> deeper layers are more see-through (like atmospheric perspective)
> glow intensity also based on depth
> UPDATE - called every frame to animate stuff
> smooth opacity changes using lerp (linear interpolation)
> 0.02 makes it gradual instead of instant
> spin it
> update the pulsing

## `01_Creative-Coding/2026-02_processing_mandala-layers/PolygonFunctions.pde`

> POLYGON DRAWING FUNCTIONS
> so this file has all the functions that actually draw the shapes
> each function uses loops to create radial symmetry (like a flower)
> the basic pattern is:
> - figure out how many petals/points/segments you want
> - use a for loop to draw that many copies in a circle
> - use trig (sin/cos) to position each copy around the center
> all these functions work the same way:
> - you tell it how many (count)
> - where to put them (radius)
> - how big to make them (size/length)
> - what colors to use
> - how see-through it should be (alpha)
> PETAL FUNCTIONS
> draws petals arranged in a circle
> this is the bread and butter of the mandala - used everywhere
> loop through each petal position
> figure out the angle for this petal
> TWO_PI is 360 degrees, divide by number of petals
> draw one petal
> draws a single petal using a smooth curve
> made up of lots of little points connected together
> set up colors with transparency
> create curve with 20 points (more = smoother)
> t goes from 0 to 1 (think of it as 0% to 100%)

## `01_Creative-Coding/2026-03_processing_living-vase-particle-system.pde`

> CRCP 6310 – Introduction to Creative Coding
> Week 8 Assignment: Particle System – "The Living Vase"
> So here's what I'm going for with this piece:
> The mandala flowers on the vase are already beautiful on their
> own, but I wanted to make them feel like they're alive , 
> like they're radiating energy outward. So each flower gets
> its own miniature parametric spiral halo, the same formula
> from the reference code, just scaled down and placed right
> on top of each flower disc. And because each one has its own
> independent phase offset, they all breathe and rotate at
> slightly different speeds, no two are in sync, which is
> what makes it feel organic rather than mechanical.
> On top of that, physics particles cascade down from each
> flower center like sparks off a sparkler. They have gravity,
> damping, friction, and they bounce off the walls and floor.
> CONTROLS:
>   Keys 1–5  – switch between 5 mandala-inspired color palettes
>   Key  S    – cycle shape mode: Stars → Polygons → Mixed
>   Mouse     – move to warp all spiral halos simultaneously
>   Click     – burst from nearest flower emitter
> WEEK 8 REQUIREMENTS:
>   Parallel arrays, for-loop init + update, pushMatrix/popMatrix,
>   randomized ptCount + star variant, color arrays (no flashing),
>   gravity + damping + friction + all four boundary collisions,
>   custom functions: poly(), starPoly(), drawFlowerHalos()

## `01_Creative-Coding/2026-04_processing_red-dress-generative-overlay/RedDressFinal.pde`

> red dress, crescent murmuration + directional fluid, steve elias / crcp 6310
> i'm using frame-by-frame motion data to drive three distinct effects:
> FRAMES 0-23:  dress sweeps RIGHT → crescent forms on RIGHT trailing edge
> FRAMES 24-39: dress sweeps LEFT  → crescent forms on LEFT trailing edge
> FRAMES 40-48: dress sweeps UP    → sonic burst ring expands from center
> FRAMES 49-54: settling back      → flock disperses and reforms
> the fluid shader now knows the sweep direction and leans accordingly
> canvas: 800x482 matching the GIF exactly, no scaling artifacts
>, motion data from surgical frame analysis , 
> i'm encoding the direction and magnitude for all 55 frames
> +1=right, -1=left, 0=up/still, 2=up-burst
>, flock state , 
>, crescent formations , 
>, motion smoothing , 
> i'm advancing gif frame in sync with its native 24fps timing
> i'm reading surgical motion data for this exact frame
>, LAYER 1: GIF with directional fluid shader , 
>, sample dress shape every 6 frames , 
>, TRIGGER: crescent wave on strong sweep , 
>, TRIGGER: sonic burst on upward apex (frames 40-48) , 
>, LAYER 2: crescent waves , 
>, LAYER 3: sonic bursts , 
>, LAYER 4: murmuration boids , 

## `01_Creative-Coding/2026-04_processing_red-dress-generative-overlay/RedDressFluid.pde`

> Load the GIF using the gifAnimation library
> Load our custom liquid shader from the data folder
> Pass the running time to the shader so the liquid can move
> Apply the shader to everything drawn after this line
> Draw the current frame of the GIF to the canvas
> The shader will intercept this and distort the red parts

## `01_Creative-Coding/2026-04_processing_red-dress-generative-overlay/RedDressWaves.pde`

> RED DRESS, hand sparklers + generative waves / steve elias / crcp 6310
> assignment 11: 3D generative geometry, part 1
> the model IS the ignition point. her hands are tracked frame-by-frame
> across all 55 gif frames using pixel-level analysis, sparklers erupt
> from exactly where her hands are, interpolated smoothly between frames.
> four layers composite together every draw cycle:
>   LAYER 1, full gif (background, always clean)
>   LAYER 2, generative wave pattern centered behind her torso
>   LAYER 3, transparent gif on top (model always visible above waves)
>   LAYER 4, spark buffer composited with ADD blend for that fire glow
> spacebar: freeze hue | up/down: intensity | left/right: shift hue | click: magnet
> i'm loading both gifs as frame arrays at startup so i can display
> any frame instantly with image(), no GifAnimation timing weirdness,
> no speed mismatch, both stay perfectly locked to the same counter
>, hand positions: surgically extracted from all 55 frames , 
>, wave pattern variables , 
>, sparkler state , 
> i'm extracting every frame from both gifs into PImage arrays at startup.
> this is the only reliable way to display a specific frame in Processing , 
> GifAnimation's internal timer keeps running even after pause() and jump(),
> which is exactly what was causing the two gifs to drift out of sync.
> i'm using Gif.getPImages(), the static method that extracts all frames
> into a PImage array in one shot. no playback thread, no timing drift,
> both arrays index off the same gifFrame counter so they can never desync
> i'm initializing sparkLayer with solid black, transparent start

## `01_Creative-Coding/2026-04_processing_red-dress-generative-overlay/data/fluid.glsl`

> ifdef GL_ES
> endif
> i'm making the wave direction follow the actual sweep direction
> when she sweeps right, waves lean right; left they lean left

## `01_Creative-Coding/2026-09_silvertrace-web-drawing-toy/sketch.js`

> --- DOM handles ---
> --- Tuning ---
> Below this much movement in a frame we do not record anything. It keeps
> --- State ---
> Where the stylus actually is, and where it is being pulled toward.
> Both in CSS pixels relative to the screen element.
> Every segment ever drawn. { ax, ay, bx, by, w } with a/b normalized 0..1
> and w in CSS pixels.
> Measured size of the screen element in CSS pixels. Kept in a variable
> Read the line color out of the palette so CSS stays the single source of
> --- Sizing ---
> Nothing to do if the box did not actually change size (ResizeObserver can
> fire for other reasons, and rebuilding is not free).
> Work in CSS pixels from here on; the DPR scale is baked into the transform.
> Keep the stylus where it was relative to the screen, so the line does
> not jump across the picture on the next frame.
> First run: the stylus starts dead center, like the real toy.
> Move a CSS-pixel point from the old screen size to the new one.
> --- Painting ---

## `06_Prompts-and-Workflows/script_bg-remove-batch_v2.py`

> ── PATHS (edit these if you move files) ───
> ── EXACT PER-FRAME TIMING from the original gif ───
> extracted from the real file, 55 frames, mix of 40ms and 50ms
> this is the source of truth, the transparent gif MUST match this
> exactly or the sandwich layers will drift out of sync
> ── VERIFY TIMING against original gif ───
> ── FIND FRAMES ───
> collect PNGs, JPGs, or any image type, sorted alphanumerically
> which preserves the frame order (frame_000.png, frame_001.png ...)
> ── MAIN ───
> verify paths
> verify timing
> find source frames

## `06_Prompts-and-Workflows/comfyui_fashion-editorial_ipadapter.json`

ComfyUI graph with 10 nodes: CheckpointLoaderSimple, CLIPTextEncode, CLIPTextEncode, KSampler, VAEDecode, SaveImage, IPAdapterUnifiedLoader, LoadImage, IPAdapterSimple, EmptyLatentImage.
> Positive Prompt: High fashion editorial photography, Vogue Japan aesthetic. A model wearing Rami Al Ali Haute Couture 2026. Dynamic pose, walking forward, wind blowing, clean minimal background, shot by Steven Meisel.
> Negative Prompt: text, watermark, blurry, deformed, bad hands, cartoon, illustration

## `06_Prompts-and-Workflows/comfyui_pose-control_dwpose-controlnet.json`

ComfyUI graph with 5 nodes: LoadImage, DWPreprocessor, ControlNetLoader, ControlNetApplyAdvanced, PreviewImage.

