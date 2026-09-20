# Review Workflow

Use this reference for full-manuscript review, pre-submission review, or the final
review stage of autonomous mode. A local edit does not require this workflow.

## Review Independently

Review the manuscript against its sources and artifacts, not against the author's
intended conclusion. When possible, separate review from drafting so the reviewer
does not silently preserve earlier assumptions. External GPT review may provide
another perspective, but it is optional and advisory.

Read the paper in the order a reviewer is likely to encounter it: title, abstract,
introduction, figures and tables, methods, experiments, related work, limitations,
and appendix. Record findings in `review.md` with severity, evidence, affected
claim or section, and a concrete repair.

## Review Dimensions

Check scientific soundness:

- Does the problem matter and match the evaluation?
- Are assumptions explicit and realistic for the claimed setting?
- Does the method description support reproduction?
- Are baselines strong, relevant, and fairly compared?
- Do ablations isolate the proposed mechanism?
- Are uncertainty, failures, and limitations reported directly?

Check claim-evidence integrity:

- Every external factual claim has a verified source.
- Every reported number traces to raw output or a reproducible transformation.
- Abstract, introduction, tables, captions, results, and conclusion agree.
- The strongest wording does not exceed `claim_evidence.md`.
- Negative or mixed results are not hidden by defensive phrasing.

Check reviewer-facing clarity:

- The contribution can be stated in one precise sentence.
- Terminology and notation remain consistent.
- Each section advances the same thesis without duplicating text.
- Figures and tables are legible, self-contained, and referenced in order.
- The paper distinguishes observations, interpretations, and speculation.

## Prioritize Findings

Use three severities:

- `blocker`: unsupported central claim, incorrect number, fabricated citation,
  invalid comparison, or a contradiction that changes the paper's conclusion;
- `major`: missing evidence, unclear mechanism, weak baseline coverage, or a
  narrative problem likely to change reviewer judgment;
- `minor`: local clarity, consistency, formatting, or presentation issue.

Do not inflate a long list of stylistic preferences into blockers. A review is
useful when it identifies the few repairs that most change correctness or
reviewer understanding.

## Final Verdict

Record separate verdicts for the three hard gates:

| Gate | Verdict | Evidence or blocker |
| --- | --- | --- |
| Citation integrity | pass/block | Source verification notes |
| Result traceability | pass/block/not applicable | Audit command and paths |
| Claim-scope integrity | pass/block | Claim IDs and wording |

Autonomous completion requires no unresolved blocker. An explicitly requested
review may finish with blockers as findings; do not imply that the manuscript is
submission-ready. Re-run only the checks affected by a repair, then perform one
final cross-section consistency pass.
