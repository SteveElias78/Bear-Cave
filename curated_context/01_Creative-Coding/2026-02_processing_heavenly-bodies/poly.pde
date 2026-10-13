// ============================================================
//  P O L Y . p d e
//  Reusable polygon drawing functions
//
//  Same poly tab from the previous assignments — I'm keeping
//  this consistent across the whole semester so the you
//  can see the reuse and abstraction principle in practice.
//
//  starPoly() is the one I'm using for asteroid particles —
//  alternating outer/inner radius on the unit circle walk
//  gives that jagged rocky shape that reads as asteroid debris.
// ============================================================

// poly — regular n-sided polygon
// cx, cy = center   r = radius   n = number of sides
void poly(float cx, float cy, float r, int n) {
  beginShape();
  for (int v = 0; v < n; v++) {
    float angle = map(v, 0, n, 0, TWO_PI) - HALF_PI;
    float vx = cx + cos(angle) * r;
    float vy = cy + sin(angle) * r;
    vertex(vx, vy);
  }
  endShape(CLOSE);
}

// starPoly — n-pointed star with alternating outer/inner radius
// outer = outer tip radius   inner = inner notch radius   n = number of points
// The same unit circle walk as poly() but every other vertex
// pulls inward — that's what creates the star / snowflake geometry.
// For asteroids I use a low inner ratio (0.35–0.5) so they look
// jagged and rocky rather than perfectly star-shaped.
void starPoly(float cx, float cy, float outer, float inner, int n) {
  int pts = n * 2;  // outer + inner vertex alternating = 2x the points
  beginShape();
  for (int v = 0; v < pts; v++) {
    float angle = map(v, 0, pts, 0, TWO_PI) - HALF_PI;
    float r = (v % 2 == 0) ? outer : inner;
    float vx = cx + cos(angle) * r;
    float vy = cy + sin(angle) * r;
    vertex(vx, vy);
  }
  endShape(CLOSE);
}
