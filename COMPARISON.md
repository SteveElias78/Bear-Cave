# Context Curation: Results Comparison

CRCP 6330 Week 6 Studio. Steve Elias.

**Corpus:** `curated_context/`, my curated creative context: about, code digest, index, brand campaigns, AI image direction, 3D, references, prompts. 98 files; about 55 images captioned locally by LLaVA.
**Snapshot:** `prepared_context/course.txt`, 152,934 characters once extracted.
**Question (identical for every run):** What is Steve Elias's creative point of view, and what recurring themes connect his code, brand campaigns and AI imagery? Cite the sources.

## Runs

| Run | Answer model | Retrieval | Results file | Prompt chars | Input tokens actually read | Output tokens | Time (s) | Finish |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A | Phi-4 Mini (local, 4,096 ctx) | None: whole snapshot stuffed into the prompt | `results/local.json` | 152,934 | 2,050 | 475 | 21.8 | stop |
| B | Gemini 3.8 Flash | None: same snapshot | `results/flash.json` | 152,934 | 38,421 | 986 | 90.0 | STOP |
| C | Phi-4 Mini (local) | Vector DB: Chroma + all-minilm, top 3 of 731 chunks | `results/vector-comparison.json` | 1,184 | 286 | 243 | 1.6 | stop |
| D | Gemini 3.8 Flash | Vector DB: same 3 chunks | `results/vector-flash.json` | 1,184 | 315 | 137 | 15.8 | STOP |

* A and B share `prompt_sha256` `f35081b18b8a8ef0...`: identical submitted text.
* C and D share `prompt_sha256` `8254af4dd9ff33e8...`: identical retrieved evidence.
* D's first attempt failed with a Google-side `504 DEADLINE_EXCEEDED` after 120.7 s. It is recorded in `results/vector-comparison.json`; the retry succeeded.

## Scoring

1 to 5 each. _(Pre-filled from my read of the outputs. Adjust to your own judgment.)_

| Run | Correct | Citations support the claims | Admits what it doesn't know | Sounds like me |
| --- | --- | --- | --- | --- |
| A | 3 | 2 | 1 | 2 |
| B | 5 | 4 | 3 | 5 |
| C | 3 | 3 | 4 | 2 |
| D | 4 | 5 | 5 | 1 |

## What I saw

**Local SLM vs Gemini (no vector DB):**
The prompt was 152,934 characters, but Phi-4 Mini only read 2,050 tokens of it because Ollama's 4,096-token window cut the rest. Its answer was generic: a list of brand names and "luxury and elegance", no quotes, and "Editorial Career" listed twice. Gemini read all 38,421 tokens and returned six specific, accurate themes with real quotes. Example: it quoted my Crystalline Prism comment "sometimes restraint is the luxury move", which I verified in the source. Same input, completely different effective context. Gemini was about 4x slower (90 s vs 22 s).

**With vs without the vector DB:**
With the vector DB, prompts shrank from 152,934 characters to 1,184 and answers came back fast (1.6 s local, 15.8 s Gemini). But top-3 retrieval of 250-character chunks pulled only the README intro, the README folder map and the first lines of `about-steve.md`. It missed the "My creative point of view" section and every brand and code file. Both models were honest about it: Gemini said the evidence was missing, and Phi said there was no explicit connection in the sources. Retrieval found the right neighborhood but not enough evidence for a broad "who is this person" question.

**Best answer and why:**
B, Gemini with the whole folder. A broad synthesis question needs evidence from many files at once. Context stuffing works when the model's window is big enough to actually hold the folder. The vector DB wins on speed, cost and honesty, and should shine on narrow factual questions (for example "what palette does LIGAND use?").

**Where it got me wrong:**
* Run B cited `01_Creative-Coding/code-digest.md`; the file is actually `00_About/code-digest.md`. Right quote, wrong path.
* Run A over-indexed on lists and repeated itself; it never saw most of the folder.
* Runs C and D described me mainly as a "Generative AI Developer" because that line sits in the first chunk of my about page. The retrieved slice skewed the portrait.

## What broke and how I fixed it

1. **Embedding crash:** `input length exceeds the context length (status code: 400)` at the default 600-character chunks, and again at 300.
2. **Partial index:** the failed run had already upserted 22 chunks from only 2 files. Queries against it "worked" but only searched those 2 files. A green answer is not proof the index is complete.
3. **Root cause:** the fill-in lines in my design brief templates (`________`) and the decorative dividers in my sketch comments (`──────`, `══════`) tokenize at almost one token per character. One chunk of underscores blows past all-minilm's ~256-token limit.
4. **Fix:** collapsed every run of 4+ filler characters to 3 in the curated files and the snapshot, then re-indexed with `--chunk-size 250 --overlap 30`. Result: 731 chunks, no errors.
5. **Note:** runs A and B used the snapshot from before this cleanup. Only filler characters changed, no content.

## Screenshots

See `screenshots/`.
