# External GPT Review

External GPT review is an optional, advisory source of independent feedback. It
is never a startup requirement and does not change the selected workflow mode.

## When to Use It

Use an external reviewer when the user requests it or when another independent
reading would materially help with novelty, method logic, experiment coverage,
claim scope, or presentation. Do not invoke it for routine translation or local
polishing.

## Review Package

Provide the minimum material needed for the question:

- the paper brief or bounded review question;
- relevant manuscript sections, figures, or tables;
- affected claim-evidence entries;
- result summaries and source paths when numeric review is requested;
- explicit scope and what the reviewer should not assume.

Never provide credentials, cookies, tokens, browser storage, private datasets,
confidential reviewer material, or unnecessary unpublished content.

## Suggested Prompt

```text
Review the supplied research material independently. Identify blockers, major
issues, and minor issues. For every finding, name the affected claim or section,
the evidence for the finding, and a concrete repair. Check citation integrity,
result traceability, claim scope, methodology, experiment design, novelty risk,
and clarity only where the supplied material permits. State what you could not
verify. Do not rewrite the manuscript or invent missing evidence.
```

## Authority Boundary

External feedback cannot override primary sources, raw results, user-approved
scope, or local evidence. The Lead decides whether to adopt each suggestion and
records material blockers in `review.md`. A requested review may finish with
blockers; autonomous completion may not.
