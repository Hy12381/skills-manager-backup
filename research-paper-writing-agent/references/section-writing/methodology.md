# Methodology Writing Workflow

Use this reference for Methods or Methodology sections. The section must make the
paper's mechanism understandable, checkable, and reproducible.

## Start With the Contract

Define the problem setting, inputs, outputs, assumptions, and notation before the
main method. State what information is available during training and inference.
Readers should be able to distinguish the proposed problem formulation from the
solution.

## Explain the Mechanism

Present the method in causal order:

1. inputs and preprocessing that affect the claim;
2. the proposed mechanism and its components;
3. objective or learning signal;
4. training procedure;
5. inference procedure and outputs.

For each component, explain why it exists and which failure it addresses. Avoid a
module inventory with no mechanism. Use a compact overview before detailed
equations or algorithms.

## Use Notation Deliberately

Define every symbol before use and keep one symbol per concept. State tensor
shapes or domains where ambiguity would affect implementation. Put the main
operation in equations and use prose to explain intent, assumptions, and edge
cases rather than narrating algebra line by line.

## Separate Scientific Choices From Configuration

The main section should include design choices necessary to understand or assess
the contribution. Put exhaustive hyperparameters, hardware, and routine settings
in an implementation-details subsection or appendix. Ordinary details such as
batch size, learning rate, or window size are legitimate manuscript content and
must not be rejected by phrase scanners.

## Support Reproduction

Specify architecture, initialization, losses, optimization, stopping rules, data
processing, and randomness when they materially affect results. Point to code or
appendix details when available. Match the names and settings used in experiment
logs and tables.

## Bound the Method Claim

Do not infer properties such as invariance, robustness, efficiency, convergence,
or causality from architecture alone. Either provide analysis and evidence or
describe the property as a motivation or hypothesis. State assumptions and known
failure modes directly.

## Final Checks

Confirm that every ablated component is defined here, every central method claim
has a corresponding experiment or analysis, and no result is introduced in the
method description. A knowledgeable reader should be able to sketch an
implementation without guessing the core mechanism.
