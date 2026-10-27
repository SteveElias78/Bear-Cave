# Week 7: Graph, Hybrid and MCP (Context Curation, Levels 3 to 5)

CRCP 6330 Week 7 Studio. Steve Elias.

**Corpus:** same as Week 6. `prepared_context/course.txt` built from `curated_context/` (73 source units, 70 indexed sources, 731 vector chunks at 250/30).
**Goal this week:** link the context setup to a frontier model (MCP), and show where graph + hybrid retrieval help and where they fall short.

## Summary

| Level | What it is | Status | Evidence |
| --- | --- | --- | --- |
| 3 | Gemini-extracted knowledge graph (`build_graph.py`) | **Blocked.** 18 of 64 batches extracted and cached; never completed | screenshots 09 to 12 |
| 4 | Hybrid: vector chunks + graph relationships | **Blocked** (needs a complete graph) | n/a |
| 5 | MCP server `context-curation` connected to Claude Code | **Working.** 5 tools, vectors ready, graph "not found" | screenshots 13 to 15 |
| Art | Generative p5.js piece built from MCP-retrieved evidence | **Done.** Published on OpenProcessing | screenshot 16, `art/context-portrait/sketch.js`, https://oppr.org/s/2l4kEfsE |

Per the instructions: "If graph extraction is blocked by quota, continue with ready vector tools and explicitly note that graph evidence is unavailable." Graph evidence is unavailable for this submission. Everything below that uses retrieval used the vector tools only.

## Level 3: what happened with the graph

The graph builder sends the corpus to Gemini in batches and only writes `local_graph.json` when every batch succeeds. Successful batches are cached, so each retry resumes.

| Attempt | Settings | Result |
| --- | --- | --- |
| 1 | Gemini 3.8 Flash, 6,000-char batches (32 batches) | Failed at batch 3: `503 UNAVAILABLE` ("model is currently experiencing high demand"), then `504 DEADLINE_EXCEEDED` |
| 2 | Gemini 3.5 Flash-Lite, 6,000-char batches | Got to batch 8, then failed every retry: `Relationship quote is not an exact supporting excerpt` |
| 3 | Flash, 3,000-char batches (64 batches), auto-retry loop | Reached batch 9, then repeated `503` overload |
| 4 | Same, longer loop | Reached batch 18, then the terminal lost the key (`Set GEMINI_API_KEY`) |
| 5 | Same | `400 API_KEY_INVALID` until the key was replaced |

Root causes:
* **Provider overload (503/504).** Not quota and not my setup. Google's free-tier Flash was saturated most of the afternoon.
* **The exact-quote check.** Every relationship must quote my text character for character. Batch 3 at 6,000 chars was my `code-digest.md` (dense code comments) and batch 8 was the Silvertrace handoff doc (backticks, quotes, symbols). Flash-Lite kept paraphrasing those, so the batch was rejected, correctly.
* **Operator error.** API keys live only in the PowerShell window where they are set. New windows lost the key, and one session used an invalid key.

What the 18 completed batches show (from the run logs): 1 to 9 relationships per batch, average about 4.4. Extraction is sparse; a 3,000-character excerpt of my writing yields only a handful of entity links.

## Where graph + hybrid would help, and where they fall short

Based on the instructions, the retrieval code, and what my Week 6 runs showed.

**Where it would help**
* **Week 6 vector retrieval missed connections.** Top-3 retrieval for "what connects his code, brand campaigns and AI imagery" returned only the README and the first lines of my about page, and both models said the evidence was missing. A graph stores explicit edges like "Red Dress overlay → driven by → model's motion" or "EPOCH → palette → desert strata", so a question about connections can pull links that live in different files.
* **Traceability.** Every graph edge carries the exact supporting quote and its source path, so a claim can be checked.
* **Focused, named questions.** `--entity "LEI WAI"` or "PELAGIC crystal" would return every relationship touching that entity, which is better than hoping it lands in the top 3 vector chunks.

**Where it falls short**
* **Fragile and expensive to build.** It needs one cloud call per batch (64 for my corpus), fails as a whole if any batch fails, and depends on provider capacity I don't control. Vectors built locally in minutes with no API.
* **Broad questions don't benefit.** Graph retrieval ranks edges by word overlap. "What are the key themes?" returns a generic sample, not a ranked survey. My Week 6 question is exactly the broad kind.
* **Exact quotes prove traceability, not truth.** Extraction can still miss facts, split aliases ("Red Dress" vs "red gown") into separate entities, or misread a passage.
* **Same-source evidence is not corroboration.** Most of my "themes" come from my own `about-steve.md`. A vector chunk and a graph edge from that same file agreeing is not independent confirmation.

## Level 5: MCP with Claude Code

* `configure_level5.py` generated client configs; `.mcp.json` (machine-specific, git-ignored) registers `context-curation` for this project.
* Claude Code shows **context-curation: connected, 5 tools** (`get_corpus_status`, `list_sources`, `search_context`, `fetch_source_excerpt`, `get_relationships`).
* `get_corpus_status`: vectors **ready**, 70 sources, 731 chunks, embedding model all-minilm. Graph: **not found**. Vector freshness not checked by the server.
* Ollama stayed on the GPU at idle while ComfyUI was running. all-minilm is about 100 MB and only loads per query.

Before the native connection worked, Claude Code improvised a small script to call the server directly (screenshot 15). Its answer is still useful for the limits it reported:
* **Machine captions can be wrong.** LLaVA described my Rothko recreation screenshot as "Steve Jobs".
* **Mostly self-reported.** Point of view and themes come almost entirely from my own `about-steve.md` and `README.md`; other files are consistent but do not independently confirm.
* **Gaps in the index.** The Vogue Japan references and the Auteur design system HTML are listed in the index but not in the vector store (unsupported type, or added after the snapshot).

## The art: Elemental Ribbons

**Live:** https://oppr.org/s/2l4kEfsE. **Code:** `art/context-portrait/sketch.js` (p5.js, 1080x1080, no external assets).

How it was made: in the MCP-connected Claude Code session, Claude ran **13 `search_context` queries and 9 `fetch_source_excerpt` calls** against my corpus, then wrote the sketch. The comment block at the top of the file maps each visual decision to its source path, for example:
* Rothko color-field background → Rothko recreation notes in `00_About/code-digest.md`
* 13-layer golden-ratio mandala, purple to gold → Sacred Geometry Mandala Vortex notes
* Murmuration crescent, sweep waves and upward-flick bursts → Red Dress overlay notes ("TRIGGER: crescent wave on strong sweep")
* Six clickable worlds → "one product, many worlds" in `about-steve.md` and the brand entries in `INDEX.md`

What I directed by hand after the first version (and marked as art direction, not evidence, in the comments):
* Replaced the permanent Silvertrace line with a short-lived braided light ribbon (the "shooting star" cursor).
* Made the gown elemental per world while keeping its fabric physics: silk (SIGNATURE), sand (EPOCH), liquid amber (LIGAND), crystal (PELAGIC), fire (SANTO BRUTO), water (LEI WAI).
* Fixed a p5.js warning: a local variable named `second` shadowed p5's `second()`.

What the evidence could not supply (stated in the file):
* No brand color values exist in the corpus. Every RGB value is interpretation of names, filenames and captions.
* Images were never looked at directly, only captions and filenames.
* No graph, so no cross-source claims were checked.

## Comparison across all approaches (Weeks 6 and 7)

| Approach | Speed | Coverage of my folder | Answer quality on "who is Steve" | Fragility |
| --- | --- | --- | --- | --- |
| Context stuffing, Phi-4 Mini | 22 s | 2,050 tokens of 153K chars (truncated) | Generic | Low |
| Context stuffing, Gemini Flash | 90 s | All of it | Best | Medium (rate limits, overload) |
| Vector top-3, Phi or Gemini | 2 to 16 s | 3 small chunks | Honest but thin | Low (once chunk size was fixed) |
| Graph / hybrid | n/a | n/a | Not measurable | High (64 cloud calls, all-or-nothing build) |
| MCP agent (Claude Code + vectors) | Minutes | Agent chose 13 searches + 9 fetches | Strong, with explicit limits | Medium (local Ollama + config) |

**Takeaway:** for a broad "who is this person" question, the agent-over-MCP approach did best among the retrieval methods, because the model decided what to search for repeatedly instead of taking one fixed top-3 shot. The graph is the right tool for named, relational questions, but it is the most fragile piece to build on a free tier.

## Stretch thinking: a context setup aimed at a real problem

Where I would point this next: a creative-direction assistant whose corpus is my brand bibles, campaign briefs and art-direction notes. Questions like "what has PELAGIC already used for crystal textures?" or "which of my brands has used gold foil?" are named and relational, exactly where a graph beats vector top-3. To make that work, the corpus needs real brand specs (hex values, type, rules) rather than captions, because this week showed the model has to guess colors when the context only has filenames.

## Screenshots

See `screenshots/` 09 to 16 (Week 7). 01 to 08 are Week 6.
