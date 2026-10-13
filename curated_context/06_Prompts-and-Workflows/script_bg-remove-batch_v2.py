"""
bg_remove_batch.py — background removal for red dress gif
steve elias / crcp 6310

UPDATED VERSION — reads pre-extracted frames from frames_raw folder.
no gif extraction needed — frames are already there.
outputs a transparent GIF with EXACT per-frame timing from the original.

paths configured for this machine:
  FRAMES_IN  — E:\Hi rez creative computing files\RedDressWaves\data\frames_raw
  ORIGINAL   — E:\Hi rez creative computing files\RedDressWaves\data\red_dress_loop-GIF.gif
  OUTPUT     — E:\Hi rez creative computing files\RedDressWaves\data\Seed GIF with NO Background.gif
  FRAMES_OUT — E:\Hi rez creative computing files\RedDressWaves\data\frames_clean

requirements — install once:
  pip install rembg Pillow

just run:  python bg_remove_batch.py
"""

import os
import sys
import glob

try:
    from PIL import Image
    from rembg import remove, new_session
    print("✅ rembg and Pillow loaded")
except ImportError as e:
    print(f"❌ missing package: {e}")
    print("run: pip install rembg Pillow")
    sys.exit(1)

# ── PATHS (edit these if you move files) ────────────────────────────
BASE          = r"E:\Hi rez creative computing files\RedDressWaves\data"
FRAMES_IN     = os.path.join(BASE, "frames_raw")         # source: raw frames WITH background
FRAMES_OUT    = os.path.join(BASE, "frames_clean")        # dest: bg-removed RGBA PNGs
ORIGINAL_GIF  = os.path.join(BASE, "red_dress_loop-GIF.gif")
OUTPUT_GIF    = os.path.join(BASE, "Seed GIF with NO Background.gif")
MODEL         = "u2net"   # swap to 'isnet-general-use' for sharper mask edges

# ── EXACT PER-FRAME TIMING from the original gif ─────────────────────
# extracted from the real file — 55 frames, mix of 40ms and 50ms
# this is the source of truth — the transparent gif MUST match this
# exactly or the sandwich layers will drift out of sync
FRAME_DELAYS = [
    40, 40, 50, 40, 40, 40, 40, 40, 50, 40,
    40, 40, 40, 40, 50, 40, 40, 40, 40, 40,
    50, 40, 40, 40, 40, 40, 50, 40, 40, 40,
    40, 40, 50, 40, 40, 40, 40, 40, 50, 40,
    40, 40, 40, 40, 50, 40, 40, 40, 40, 40,
    50, 40, 40, 40, 40
]  # total: 2290ms = 2.29s loop


# ── VERIFY TIMING against original gif ──────────────────────────────
def verify_timing():
    if not os.path.exists(ORIGINAL_GIF):
        print(f"⚠️  original gif not found at {ORIGINAL_GIF} — using hardcoded delays")
        return FRAME_DELAYS

    try:
        src = Image.open(ORIGINAL_GIF)
        live_delays = []
        for i in range(src.n_frames):
            src.seek(i)
            live_delays.append(src.info.get('duration', 40))

        if live_delays == FRAME_DELAYS:
            print(f"✅ timing verified: {len(live_delays)} frames, {sum(live_delays)}ms total")
        else:
            print(f"⚠️  hardcoded delays differ from live read — using live read as truth")
            print(f"   live:       {live_delays}")
            print(f"   hardcoded:  {FRAME_DELAYS}")
            return live_delays

        return live_delays
    except Exception as ex:
        print(f"⚠️  could not read original gif ({ex}) — using hardcoded delays")
        return FRAME_DELAYS


# ── FIND FRAMES ──────────────────────────────────────────────────────
def find_frames(folder):
    # collect PNGs, JPGs, or any image type — sorted alphanumerically
    # which preserves the frame order (frame_000.png, frame_001.png ...)
    exts = ('*.png', '*.jpg', '*.jpeg', '*.bmp', '*.tiff', '*.tif', '*.webp')
    files = []
    for ext in exts:
        files.extend(glob.glob(os.path.join(folder, ext)))
    files.sort()
    return files


# ── MAIN ─────────────────────────────────────────────────────────────
def main():
    print(f"\n{'─'*60}")
    print(f"  red dress waves — background removal")
    print(f"{'─'*60}")

    # verify paths
    if not os.path.isdir(FRAMES_IN):
        print(f"❌ frames_raw folder not found: {FRAMES_IN}")
        sys.exit(1)

    os.makedirs(FRAMES_OUT, exist_ok=True)

    # verify timing
    delays = verify_timing()

    # find source frames
    frame_files = find_frames(FRAMES_IN)
    n = len(frame_files)

    if n == 0:
        print(f"❌ no image files found in {FRAMES_IN}")
        sys.exit(1)

    print(f"\nfound {n} frames in frames_raw")

    if n != len(delays):
        print(f"⚠️  frame count ({n}) != delay list length ({len(delays)})")
        print(f"   truncating delays to match frame count")
        delays = delays[:n]

    # init rembg — one session for all frames (much faster than cold calls)
    print(f"initializing {MODEL} model (first run downloads ~170MB)...\n")
    session = new_session(MODEL)
    print("model ready ✅\n")

    # ── PROCESS EACH FRAME ───────────────────────────────────────────
    rgba_frames = []

    for i, fpath in enumerate(frame_files):
        # open frame — convert to RGBA for rembg
        img = Image.open(fpath).convert("RGBA")

        # resize to match original gif exactly if needed
        if img.size != (800, 482):
            img = img.resize((800, 482), Image.LANCZOS)

        # remove background — post_process_mask runs a morphological cleanup
        # pass that closes small holes and smooths jagged mask edges.
        # alpha_matting=True gives even cleaner edge feathering on hair/fringe
        # but is ~3x slower. try it if edges look rough.
        result = remove(
            img,
            session=session,
            post_process_mask=True,
            # alpha_matting=True,           # uncomment for better edges, slower
            # alpha_matting_foreground_threshold=240,
            # alpha_matting_background_threshold=10,
        )

        rgba_frames.append(result)

        # save individual clean frame
        out_path = os.path.join(FRAMES_OUT, f"frame_clean_{i:03d}.png")
        result.save(out_path)

        # progress
        pct = int((i + 1) / n * 100)
        bar = "█" * (pct // 4) + "░" * (25 - pct // 4)
        print(f"\r  [{bar}] {pct}%  frame {i+1}/{n}", end="", flush=True)

    print(f"\n\n✅ all {n} frames processed")
    print(f"   clean PNGs saved to: {FRAMES_OUT}\n")

    # ── STITCH INTO GIF ──────────────────────────────────────────────
    # GIF is palette (P) mode — max 256 colors with one reserved for transparency.
    # we quantize each RGBA frame to 255 colors, keeping alpha intact.
    # the transparent gif uses:
    #   disposal=2  — restore to background before each frame (gifAnimation needs this)
    #   loop=0      — loop forever
    #   duration    — per-frame list matching the original gif EXACTLY

    print(f"quantizing frames and stitching gif...")
    quantized = []

    for i, frame in enumerate(rgba_frames):
        # quantize: 255 colors (1 slot reserved for transparency)
        # FASTOCTREE preserves colors better than median cut for photos
        q = frame.quantize(
            colors=255,
            method=Image.Quantize.FASTOCTREE,
            dither=Image.Dither.NONE
        )
        quantized.append(q)
        pct = int((i + 1) / n * 100)
        bar = "█" * (pct // 4) + "░" * (25 - pct // 4)
        print(f"\r  quantize [{bar}] {pct}%", end="", flush=True)

    print(f"\n")

    # save — PIL accepts duration as a list for per-frame timing
    quantized[0].save(
        OUTPUT_GIF,
        save_all=True,
        append_images=quantized[1:],
        loop=0,
        duration=delays,   # ← the per-frame list — this is what keeps sync perfect
        disposal=2,        # clear each frame before drawing the next
        optimize=False,    # don't re-order palette — preserves frame independence
        transparency=0,    # palette index 0 = transparent
    )

    out_mb = os.path.getsize(OUTPUT_GIF) / 1024 / 1024
    print(f"✅ saved: {OUTPUT_GIF}")
    print(f"   size: {out_mb:.1f} MB")
    print(f"   frames: {n}")
    print(f"   total duration: {sum(delays)}ms ({sum(delays)/1000:.2f}s)")
    print(f"\ndone! copy this gif into your Processing sketch's data/ folder.")
    print(f"the sandwich is ready: original GIF | 3D code | this file 🎉")


if __name__ == "__main__":
    main()
