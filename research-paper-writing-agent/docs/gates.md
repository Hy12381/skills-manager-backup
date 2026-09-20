# Integrity Gates

The skill has three hard gates. They protect evidence-bearing output without
blocking unrelated prose or requiring a universal phase state.

## Citation Integrity

For external factual claims or citations introduced by Codex:

- verify the work in a primary or authoritative source;
- confirm bibliographic metadata;
- read the passage supporting the intended claim;
- record the source and allowed wording.

If verification fails, omit the claim or retain an explicit placeholder. This
gate does not apply to a prose-only edit that introduces no external fact.

## Result Traceability

For every reported number, delta, rank, comparison, or table marker:

- identify the raw output;
- record the transformation or aggregation;
- confirm dataset, metric, direction, method, and uncertainty;
- connect the result to the affected claim.

When CSV sources and a compatible JSONL ledger are available, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check-result-audit.ps1 -ProjectRoot .
```

A failed numeric check blocks the affected result claim. It does not block a
separate introduction edit or a result-independent Methods section.

## Claim-Scope Integrity

Final wording must match the support recorded in `claim_evidence.md` or a trusted
project equivalent:

- supported: state the claim within the tested setting;
- partial: state where it holds and where it does not;
- unsupported: omit it or label it as a hypothesis;
- contradicted: revise or remove it.

State negative and mixed evidence directly. Limitations clarify validity,
generality, or practicality after the result; they do not excuse missing evidence.

## Advisory Checks

Formatting, stylistic phrasing, role separation, external review, and venue
checklists are advisory unless the user or current official venue policy makes
them requirements. Ordinary configuration details such as batch size, learning
rate, seed, and window size are legitimate manuscript content. Broad phrase bans
must not be used as scientific gates.

## Scope of Failure

Local evidence failure has a local consequence. Escalate to a paper-level blocker
only when the affected claim is central to the thesis. Never compensate for a
failed gate by adding defensive prose or silently changing the paper's identity.
