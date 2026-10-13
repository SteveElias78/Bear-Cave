// ============================================================
//  B O D Y . p d e
//  n-Body gravitational simulation — Shiffman Chapter 2
//
//  Each Body has mass, position, velocity, acceleration.
//  attract() applies Newton's F = G*m1*m2/r² to 'other'.
//
//  Planet positions are SET parametrically in draw() before
//  attract() runs, so update() only integrates vel/acc.
//  The star's corona is drawn separately in the main sketch
//  as a tight ellipse — Body.draw() skips the star glow
//  to prevent the massive cream blob that was covering the belt.
// ============================================================

class Body {

  PVector pos;
  PVector vel;
  PVector acc;

  float mass;
  color col;
  float radius;

  final float G = 1.1;

  Body(float x, float y, float m, color c, float vx, float vy) {
    pos    = new PVector(x, y);
    vel    = new PVector(vx, vy);
    acc    = new PVector(0, 0);
    mass   = m;
    col    = c;
    radius = sqrt(m) * 3.2;
  }

  // ── attract ──────────────────────────────────────────────
  void attract(Body other) {
    PVector dir  = PVector.sub(pos, other.pos);
    float   dist = constrain(dir.mag(), 8, 500);
    float   mag  = (G * mass * other.mass) / (dist * dist);
    dir.normalize();
    dir.mult(mag / other.mass);
    other.acc.add(dir);
  }

  // ── update ───────────────────────────────────────────────
  // Only integrates velocity — pos is set parametrically
  void update() {
    vel.add(acc);
    vel.limit(3.5);
    // pos.add(vel)  — omitted, parametric positioning owns pos
    acc.set(0, 0);
  }

  // ── draw ─────────────────────────────────────────────────
  void draw() {
    noStroke();

    // Star (mass >= 1000) — skip draw entirely here.
    // The main sketch draws the corona as a tight PERSP-correct
    // ellipse that stays inside the belt boundary.
    if (mass >= 1000.0) return;

    // Planets — layered glow, kept compact
    // Outer atmospheric haze
    fill(red(col), green(col), blue(col), 35);
    ellipse(pos.x, pos.y, radius * 6, radius * 6);

    fill(red(col), green(col), blue(col), 70);
    ellipse(pos.x, pos.y, radius * 4, radius * 4);

    fill(red(col), green(col), blue(col), 140);
    ellipse(pos.x, pos.y, radius * 2.5, radius * 2.5);

    // Planet body
    fill(red(col), green(col), blue(col), 230);
    ellipse(pos.x, pos.y, radius * 2, radius * 2);

    // Hot spot
    fill(255, 200, 150, 100);
    ellipse(pos.x - radius*0.3, pos.y - radius*0.3, radius*0.85, radius*0.85);
  }
}
