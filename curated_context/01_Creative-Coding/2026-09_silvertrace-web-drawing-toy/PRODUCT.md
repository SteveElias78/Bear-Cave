# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Two distinct audiences, both real:

- **The player.** Anyone who opens `index.html`. They are not "drawing" in the paint-program
  sense; they are steering. Casual, exploratory, mouse or touch, one sitting.
- **The evaluator.** The CRCP 6330 instructor reading the submission and the repository.
  Their job is to judge process evidence — commit history, reviewed diffs, proof the app
  was run and inspected — not just the running app. Submitted artifacts are read on screen
  and possibly printed.

## Product Purpose

Silvertrace is a browser drawing toy: one continuous line that you steer instead of draw.
Inspired by the mechanical knob-and-stylus toys of the 1960s, rebuilt for the web. Success
for the player is the feeling of the line lagging and overshooting under their hand.
Success for the course is that the repository history reads as a legible record of an
AI-native build loop.

## Positioning

The stylus is **always down**. There is no pen-up state in analog mode, and the stylus
chases the pointer with easing (~0.15 lerp/frame), so lines swoop and overshoot the way
they do when cranking two knobs at once. That constraint — not the retro frame — is the
mechanism a paint program cannot truthfully copy.

## Operating Context

- CRCP 6330, Creative Coding for the Web, Fall 2026, Week 2 Studio. Team of four.
- The workflow is the deliverable as much as the app is. Commit messages are prefixed with
  the loop stage (`spec+plan:`, `build:`, `review:`, `fix:`) so `git log` reads as the story.
- Built AI-natively: specified in natural language, implemented via Claude Code, reviewed
  and committed from that description rather than typed by hand.
- Repo: github.com/SteveElias78/CRCP-6330-Creative-Coding-for-the-Web

## Capabilities and Constraints

**Built and working:** analog mode (always-down easing stylus), free mode via `F`,
one continuous charcoal line, segment list in normalized coordinates, redraw on resize
without wiping, static thickness HUD, mode button.

**Specified but not yet built** — marked `TODO` in `sketch.js` and shown with a `.pending`
class in the UI, so the running app discloses its own gaps: arrow-key thickness (1–40
clamp), erase via `Space`/`E`/button/mouse-shake with fade-out, save-as-PNG via `S`,
knob rotation driven by stylus position.

**Durable constraints:**
- Vanilla HTML/CSS/JS. Opening `index.html` is the entire build process. No frameworks, no build step.
- One `<canvas>`. Pointer events throughout, so touch and stylus input work.
- Resizing must never wipe the drawing.
- No AI API called from the static page — that would ship the key to every visitor.
- Palette lives in CSS custom properties in `:root`.

**Undecided / not yet true:** teammate names are placeholders in the README team table.
No feature branches, pull requests, merges or reverts exist yet; `main` is the only branch.

## Brand Commitments

- Name is **Silvertrace**. Original identity, deliberately *not* a replica of the
  trademarked product; credited as "inspired by" only.
- Display face: **Bungee**. Body/legend text uses the system stack.
- Committed palette in `style.css` `:root`: `--bezel #2e7d74`, `--bezel-light #4aa79b`,
  `--bezel-dark #1d564f`, `--screen #d7d1c3`, `--screen-edge #a89f8c`, `--ink #2b2b2e`,
  `--cream #f2ead8`, `--knob #e6dcc6`, `--knob-dark #a5946f`, `--page #14312e`.
- Material language: chunky molded plastic on a dark surface. Depth comes from gradients
  and inset shadows rather than images, so there are no assets to load.

## Evidence on Hand

- `docs/screenshot.png` (1422×864) — the running app, a five-pointed star and a loop
  traced in analog mode, showing the easing overshoot at each point.
- Verified inspection recorded in `README.md`: 433 segments from one continuous stroke;
  window shrunk 1440×960 → 900×700 with all 433 segments intact and ~16k pixels of ink
  still on screen; `F` toggled to free mode and correctly recorded nothing with no button
  held; no console errors or exceptions.
- Git history: 4 commits on `main`, Sep 1 2026, 14:20–14:31
  (`1f0d357` spec+plan → `c914def` build → `9e97585` rename → `1dfeafa` spec+plan rename).
- `Week2_Individual_Build_Notes.docx` — the student's written reflection, 9 sections.

**Absences future work must not fabricate:** no pull requests, no merges, no reverts,
no feature branches, no teammate names, no deployment, no tests, no CI.

## Product Principles

1. **Constraint before feature.** The always-down stylus is the product; everything else
   is trim. Protect the feel before adding controls.
2. **The history is the artifact.** Record intent before code; a commit message names the
   loop stage it belongs to.
3. **Disclose what is not built.** Unfinished features are marked in the code and visible
   in the UI rather than hidden.
4. **Original by construction.** Never borrow the trademarked name or classic look.
5. **No build step.** Anything that requires tooling to run is out of scope.

## Accessibility & Inclusion

Not yet addressed and explicitly on the hardening list: full keyboard operation, screen
reader labels, visible focus, `prefers-reduced-motion` for the shake animation, adequate
contrast, and on-screen controls for devices without arrow keys.
