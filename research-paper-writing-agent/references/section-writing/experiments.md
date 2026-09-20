# Experiments Writing Workflow

Use this reference for Experiments, Results, ablation, robustness, efficiency, or
table and figure result prose. Read `references/experiment-workflow.md` as well
when planning or auditing experiments.

## Organize Around Questions

Structure the section around the claims a reviewer needs evaluated, not around the
order in which jobs were run. A common sequence is:

1. setup and evaluation protocol;
2. main comparison for the central claim;
3. ablations for the proposed mechanism;
4. robustness, sensitivity, or efficiency where claimed;
5. failure cases and limitations.

State the question each subsection answers. Keep routine configuration concise and
move exhaustive details to the appendix without hiding information required for a
fair comparison.

## Describe the Setup Fairly

Identify datasets, splits, metrics and their direction, baselines, tuning policy,
randomness, and uncertainty. Explain why baselines are relevant and note material
differences in data, compute, model size, or supervision. Do not call a comparison
state of the art when stronger applicable methods were omitted.

## Write From Verified Numbers

Trace every number, delta, rank, and best marker to raw output or a reproducible
transformation. In prose, state the comparison, magnitude, setting, and claim it
supports. Avoid copying a table row into sentences without interpretation.

When evidence is mixed, report the pattern directly: where the method wins, ties,
or loses, and whether the central claim remains supported. Do not average away a
critical failure or use vague language to conceal it.

## Explain Mechanism and Alternatives

Use ablations to isolate the proposed mechanism. Compare against simple controls
and plausible alternatives. Discuss whether improvements could instead arise from
extra parameters, training budget, data access, preprocessing, or metric choices.

Correlations and qualitative examples can support an interpretation but do not
establish causality on their own. Label mechanism explanations according to their
actual evidence.

## Report Uncertainty and Failures

Use multiple seeds, confidence intervals, significance tests, or another suitable
uncertainty measure when variability affects the conclusion. State the unit of
variation and aggregation. Include representative failure cases and explain what
they reveal about scope.

## Final Checks

Verify table and prose values, metric directions, ranks, labels, captions, and
dataset names. Confirm that each contribution claim has an experiment or analysis
and that each reported experiment changes or supports a paper decision. The
conclusion must not be stronger than the results summarized here.
