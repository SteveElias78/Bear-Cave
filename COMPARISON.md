# Context Curation: Results Comparison

CRCP 6330 Week 6 Studio. Steve Elias.

**Corpus:** `curated_context/` (my curated creative context: about, code digest, index, brand campaigns, AI image direction, 3D, references, prompts)
**Question (identical for every run):** What is Steve Elias's creative point of view, and what recurring themes connect his code, brand campaigns and AI imagery? Cite the sources.

## Runs

| Run | Answer model | Retrieval | Results file | Prompt chars | Time (s) | Finish | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| A | Phi-4 Mini (local) | None, whole folder stuffed into the prompt | `results/local.json` | | | | |
| B | Gemini 3.8 Flash | None, same snapshot | `results/flash.json` | | | | |
| C | Phi-4 Mini (local) | Vector DB (Chroma + all-minilm, top 3) | `results/vector-comparison.json` | | | | |
| D | Gemini 3.8 Flash | Vector DB (Chroma + all-minilm, top 3) | `results/vector-comparison.json` | | | | |

A and B share the same `prompt_sha256`: _paste here_

## Scoring

1 to 5 each.

| Run | Correct | Citations support the claims | Admits what it doesn't know | Sounds like me |
| --- | --- | --- | --- | --- |
| A | | | | |
| B | | | | |
| C | | | | |
| D | | | | |

## What I saw

**Local SLM vs Gemini (no vector DB):**

**With vs without the vector DB:**

**Best answer and why:**

**Where it got me wrong:**

## Screenshots

See `screenshots/`.
