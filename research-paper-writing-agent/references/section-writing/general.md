# General Section Writing Workflow

Use this reference for titles, abstracts, conclusions, discussions, limitations,
appendices, and paper-wide editing. Load the section-specific reference for an
introduction, methodology, experiments/results, or related-work task.

## Establish the Writing Contract

Before evidence-bearing drafting, identify the section's purpose, target claims,
available evidence, and forbidden overreach. In edit mode, infer this contract
from the supplied text and preserve its meaning; do not create project files.

Write from the strongest supported statement outward. Distinguish:

- observation: what a source or experiment directly shows;
- interpretation: the mechanism or explanation consistent with the evidence;
- implication: why the result matters within the stated scope;
- speculation: a hypothesis that remains to be tested.

Signal speculation rather than blending it into established findings.

## Build a Coherent Narrative

The paper should make one central contribution. Each section has a distinct job:
the introduction motivates and defines the gap, methods explain the solution,
experiments test its claims, related work establishes the boundary, and the
conclusion states what was learned without introducing new evidence.

At paragraph level, use a clear topic sentence, evidence or reasoning, and a
concluding implication. Put familiar context before new information. Keep the
main verb near its subject and place the sentence's emphasis near the end.

## Title

Name the problem and contribution precisely. Prefer searchable technical terms
over slogans. Do not claim generality, causality, robustness, or superiority that
the evidence does not establish. Finalize the title after the thesis stabilizes.

## Abstract

A compact abstract usually covers:

1. the problem and why it matters;
2. the specific limitation in existing approaches;
3. the proposed mechanism or insight;
4. the evaluation setting and strongest supported result;
5. the bounded implication.

Use concrete quantities when they are traceable and central. Avoid citations,
undefined acronyms, implementation trivia, and claims that appear nowhere in the
paper. Draft early for alignment, then rewrite after results and conclusions are
stable.

## Figures and Tables

Each figure or table must answer a question that matters to a claim. Captions
should state what is shown, define symbols and evaluation direction, and give the
main takeaway without exceeding the evidence. Ensure axes, units, uncertainty,
splits, and best-value markers are correct and consistent with the text.

## Limitations and Discussion

State the result first, then its boundary. Identify tested settings, untested
settings, assumptions, failure cases, resource constraints, and credible
alternative explanations. Explain whether each limitation affects validity,
generality, or practicality. Do not use limitations to excuse a missing control.

Discussion may connect findings to a broader mechanism, but must label hypotheses
and avoid presenting future work as completed evidence.

## Conclusion

Restate the problem, contribution, strongest supported finding, and practical or
scientific implication. Do not introduce a new claim, citation, experiment, or
number. Match the scope and certainty used in `claim_evidence.md`.

## Appendix

Use the appendix for reproducibility details, proofs, extended analyses, and
secondary results. The main paper must still contain the evidence needed to
understand and assess its central claims. Never hide a required baseline, key
failure, or essential method definition only in the appendix.

## Revision Passes

Separate revision concerns:

1. evidence: citations, numbers, comparisons, and claim boundaries;
2. structure: thesis, section roles, paragraph order, and redundancy;
3. expression: clarity, terminology, grammar, and concision;
4. presentation: figures, tables, captions, references, and venue format.

Do not let sentence polish conceal an unsupported claim. After revision, compare
the title, abstract, contribution statements, result tables, and conclusion for
the same claims and degree of certainty.
