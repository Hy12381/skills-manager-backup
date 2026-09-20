# Experiment Workflow

Use this reference when planning, running, interpreting, or writing about
experiments. Experiments exist to test paper claims, not to accumulate tables.

## Plan From Claims

For each experiment, record in `research_log.md`:

- the claim or decision it tests;
- the falsifiable hypothesis;
- dataset and evaluation setting;
- primary metric and direction;
- strongest relevant baselines and simple controls;
- fixed factors and allowed tuning;
- raw-output path and reproduction command;
- success, partial-support, and stop criteria;
- the paper decision affected by each outcome.

Prefer the smallest experiment that can change a decision. Run a smoke test before
expensive sweeps. Add scale only after the pipeline, metric, and comparison are
known to be valid.

## Keep Comparisons Clean

Change one scientific factor at a time when claiming causality. Match training
budgets, data access, preprocessing, and evaluation protocols unless the claimed
advantage explicitly includes the difference. Report unavoidable asymmetries.

Include simple controls that can expose leakage or needless complexity: random
or constant predictors, identity/no-op variants, shuffled labels, naive
heuristics, or removal of the proposed mechanism where appropriate. A method
that cannot beat its simple control needs diagnosis, not favorable prose.

## Record Execution, Not Just Outcomes

Log the exact command, code revision, configuration, seed policy, environment,
start/end state, and output paths. Preserve failures and interrupted runs. Do not
overwrite raw outputs when rerunning with different settings.

Treat missing files, partial output, NaNs, inconsistent sample counts, and metric
definition changes as execution failures until resolved. Do not convert them into
scientific conclusions.

## Diagnose Failed Results

When results contradict the hypothesis, separate:

1. implementation or data faults;
2. unfair or unstable evaluation;
3. under-tuned but plausible mechanisms;
4. a false mechanism or claim.

Run bounded repair tests only when they can distinguish these causes. Set a
budget before repair. If the claim remains unsupported, weaken or remove it. A
negative outcome may motivate new research, but it does not automatically justify
turning a method paper into a boundary or negative-result paper.

## Audit Results

For each number used in prose or a table, trace:

- the raw source path;
- the transformation or aggregation;
- the dataset, split, metric, and method;
- uncertainty or seed count where relevant;
- rank and delta under the declared metric direction;
- the claim IDs it supports and the support level.

Use `scripts/check-result-audit.ps1` when a compatible JSONL ledger and CSV source
are available. Otherwise perform the same checks with the project's native
analysis code and record the command. A failed numeric check blocks the affected
result claim, not unrelated manuscript work.

## Interpret Before Writing

An experiment section must do more than restate a table. Explain the strongest
comparison, effect size, consistency, failure cases, and mechanism suggested by
the evidence. Consider credible alternative explanations such as extra compute,
parameter count, data access, preprocessing, or metric artifacts.

Use bounded language from `claim_evidence.md`:

- `supported`: state the claim directly within the tested setting;
- `partial`: name where it holds and where it does not;
- `unsupported`: omit or state as an open hypothesis;
- `contradicted`: revise or remove the claim.

Limitations follow the result statement. They clarify scope; they do not excuse a
missing comparison or turn a loss into a win.
