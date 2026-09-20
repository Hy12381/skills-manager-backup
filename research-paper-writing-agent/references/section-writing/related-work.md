# Related Work Writing Workflow

Use this reference to draft or revise Related Work after the relevant literature
has been verified. Read `references/literature-workflow.md` for search and citation
integrity.

## Organize by Technical Boundary

Group work by mechanism, assumption, supervision, data access, or evaluation
setting. Choose dimensions that explain the paper's position. Chronological lists
and one-sentence paper catalogues rarely establish a meaningful boundary.

For each group:

1. state the shared approach or assumption;
2. summarize representative capabilities and evidence;
3. identify the limitation relevant to this paper;
4. contrast the current work precisely.

Use neutral language. The goal is to help a reviewer see the closest work and the
actual difference, not to make prior work look weak.

## Cite Claims, Not Names

Place citations next to the factual statement they support. Verify comparative
claims such as "requires labels," "assumes stationarity," or "evaluates only
on synthetic data" against the paper itself. Do not cite a survey as the sole
evidence for a specific method claim when the primary paper is available.

Avoid citation dumping. A cluster of citations may support a category, but any
specific property attributed to all members must hold for all of them.

## State the Closest Difference

Give the nearest related methods more detail than distant background. Explain the
smallest technically meaningful distinction and why it changes capability,
assumptions, or evidence. If the distinction is only naming or implementation, do
not present it as conceptual novelty.

Useful contrast language is bounded:

- "Unlike methods that require X, our setting assumes Y."
- "Both approaches use A; the difference is the signal used to learn B."
- "Prior work studies C, whereas we evaluate the separate question D."

Avoid unsupported absolutes such as "first," "only," "all existing methods,"
or "has not been studied."

## Keep It Consistent With the Paper

Use the same problem definition and terminology as the introduction and methods.
Do not reveal a different contribution in Related Work. If literature search
changes the novelty boundary, update `claim_evidence.md` and the contribution
wording everywhere, not only in this section.

## Final Checks

Confirm that every citation exists, every attributed property is supported, the
closest work is included, and the final positioning matches the evidence. The
section should answer both "what family does this work belong to?" and "what
specific boundary distinguishes it?"
