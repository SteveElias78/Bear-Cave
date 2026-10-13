# EPOCH Ad 1 — Master Cut v01 · Cut Sheet
**2026-07-23 · 55.83s · 720×1280 (9:16) · 24fps · H.264 CRF18 · AAC 192k · −13.8 LUFS / TP −0.9 dBTP**
Grammar per Mission Control: UGC testimonial — hard cuts, jump cuts, no dissolves, no regrade, no retouch.

## Spine (A-roll) — speech-chunk trims (pauses ≥0.9s removed as jump cuts)
| Clip | Chunks kept (src TC) | Runs | Ends at (master TC) |
|---|---|---|---|
| V1 | 0.00–3.42 · 4.31–6.34 · 7.07–9.11 | 7.49s | 7.49 |
| V2 | 0.00–3.53 · 4.93–9.06 | 7.66s | 15.15 |
| V3 | 1.08–3.43 · 4.35–7.81 | 5.81s | 20.96 |
| V4a | 0.00–2.15 · 2.81–9.29 | 8.63s | 29.59 |
| V4b | 0.35–3.23 · 4.04–7.43 | 6.27s | 35.86 |
| V5 | 0.96–5.39 · 6.29–7.77 | 5.91s | 41.77 |
| V6 | 0.00–2.06 · 2.78–6.63 · 7.39–9.57 | 8.09s | 49.86 |

Breaths <0.9s were left in on purpose — they carry the natural read.

## B-roll inserts (video-only cutaways; VO continues underneath)
| Insert | Source (src in / dur) | Master window | Covers |
|---|---|---|---|
| Jar macro | B-roll_animation_2 (3.0 / 3.0s) | 13.80–16.80 | V2→V3 seam (hand-position pop + temp shift) |
| Shoe tie | B-roll_animation_1 (1.0 / 3.2s) | 34.42–37.62 | V4b→V5 seam; sets up the run |
| Run | B-roll_animation_3 (2.5 / 2.9s) | 40.46–43.36 | V5→V6 seam (angle/light shift) |

Seams left as visible cuts by design: V1→V2 (7.49, natural punch-in), V3→V4a (20.96, UGC jump), V4a→V4b (29.59, continuation — near invisible).

## Closer
Bottle_with_warm_glow_B-roll_animation_4: src 0.10–5.30, conformed 1080×1920→720×1280, appended at 49.86. Audio pre-gained −6 dB, 0.35s fade-in, 0.7s fade-out; video fades to black over the final 0.6s (flare blooms into the fade).

## Audio master
Two-pass loudnorm, linear mode, target I=−14 / TP=−1.5 / LRA=11. Measured input −26.5 LUFS → output −13.8 LUFS, TP −0.9 dBTP. TP sits above my −1.5 spec but well under clipping — fine for TikTok/IG; run `alimiter` only if a broadcast spec ever applies.

## Watch these three moments at full speed (I judged motion from sampled frames, not playback)
1. **20.96** — the V3→V4a jump cut: confirm it lands on the sentence start, not mid-word.
2. **16.80** — B2's exit back into V3's read: confirm her mouth position doesn't pop on re-entry.
3. **49.86** — the V6→closer audio handoff: confirm the −6 dB + fade tames the closer's hot mix (its raw max was −3.6 dB vs the VO's −12).

## Open decisions (Steve)
- **Vessel continuity:** talent handles the amber CAMBRIAN jar for 50s; the closer is a bottle. Options: (a) keep as-is — reads as brand beauty shot; (b) re-animate the canon jar render with the same L→R pan + flare in one Flow session and I re-cut in minutes; (c) end on V6's clean label hold + fade, no closer.
- **A true :40** means dropping ~2 of the 7 beats (V4a's long second chunk and V5 are the compressible ones) — director's call; I'll cut the variant on request.
- **v02 adds:** burned captions + end card once you send the EPOCH wordmark PNG.

## Premiere replication
New sequence 720×1280/24. Lay chunks per the spine table on V1/A1 (they're straight source trims — no speed changes). Drop the three inserts on V2 at the master windows, video only. Closer on V1 after 49.86 with the fades above. Loudness: Essential Sound → match −14 LUFS.
