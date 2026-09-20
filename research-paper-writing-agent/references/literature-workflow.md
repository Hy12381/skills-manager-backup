# Literature Workflow

Use this reference for literature search, related-work synthesis, novelty checks,
and citation-bearing claims. Do not load it for prose-only edits.

## Search From the Decision

State what the search must decide before collecting papers. Typical decisions
include whether a claimed gap exists, which baselines are credible, which
mechanism is plausible, and what evaluation protocol the field expects.

Start from two to five seed papers supplied by the user or found in an
authoritative index. Expand with:

- backward citations for foundations and definitions;
- forward citations for later corrections and stronger baselines;
- author and venue searches for adjacent work;
- terminology variants, including older names for the same problem;
- competing explanations and negative evidence, not only supportive work.

Stop when new queries mostly repeat known clusters and no longer change the
paper's framing, method, baseline set, or claim boundaries. A large paper count
is not a stopping criterion.

## Verify Before Citing

For every citation introduced by the agent:

1. Confirm the work exists using a primary publisher page, DOI record, arXiv,
   ACL Anthology, OpenReview, or another authoritative index.
2. Verify title, authors, year, venue, and identifier.
3. Read the source passage that supports the intended claim. An abstract is
   sufficient only when the claim is actually present there.
4. Record the source URL or local path and the supported wording in
   `claim_evidence.md`.
5. Retrieve bibliography metadata programmatically where possible; do not
   reconstruct BibTeX from memory.

If verification fails, keep an explicit citation placeholder or omit the claim.
Never turn search snippets, secondary summaries, or remembered attribution into
a verified citation.

## Build a Decision-Oriented Matrix

For evidence or autonomous mode, organize relevant work by the dimensions that
affect the paper rather than by chronological summaries. Include only useful
columns, such as:

| Work | Problem and setting | Core mechanism | Evidence | Limitation | Decision affected |
| --- | --- | --- | --- | --- | --- |
| Paper A | Distribution shift | Adaptive weighting | Three datasets | Assumes labels | Baseline and scope |

Separate facts reported by the paper from your inference. Link every factual row
to its source. Mark unavailable full text and uncertainty explicitly.

## Test Novelty at the Claim Level

Do not infer novelty from a missing keyword match. Decompose the proposed
contribution into problem, assumptions, mechanism, training signal, inference
procedure, and evaluation setting. Search each component and their closest
combinations.

For the nearest work, write:

- what is genuinely shared;
- the smallest technically meaningful difference;
- whether that difference changes capability, evidence, or only presentation;
- what experiment would distinguish the methods;
- the strongest wording justified by the comparison.

If the difference is only a renamed component, parameter choice, or untested
intuition, weaken the novelty claim before drafting.

## Synthesize, Do Not Catalogue

Related-work prose should explain a technical boundary. Group papers by approach
or assumption, state what each group enables, identify the unresolved limitation,
and position the current work with a precise contrast. Avoid one sentence per
paper and unsupported claims that prior work "ignores" a problem.

Before leaving the literature task, state what changed because of the search:
the method, evaluation, baselines, terminology, scope, or claim wording. If
nothing changed, explain why the current decisions remain justified.
