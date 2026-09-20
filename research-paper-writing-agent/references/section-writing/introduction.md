# Introduction Writing Workflow

Use this reference when drafting or revising an introduction. Apply the mode and
evidence rules in `SKILL.md`; this file only defines the section's rhetorical job.

## Required Arc

Build the introduction as a sequence of decisions for the reader:

1. Define the concrete problem and why it matters.
2. Explain the dominant approach and its relevant assumption.
3. Show the specific failure or gap, supported by literature or evidence.
4. Identify the mechanism behind that gap rather than naming only a symptom.
5. Introduce the proposed idea as a response to that mechanism.
6. Summarize the evidence and contributions at the level the paper supports.

Do not begin with generic claims about rapid growth, broad importance, or an
unbounded application area. Reach the paper's actual problem quickly.

## Establish the Gap Precisely

A useful gap states who or what fails, under which setting, and why existing
methods do not already solve it. Support comparative statements about prior work
with verified citations. Avoid absolute phrases such as "no prior work" unless
the search can justify them.

Distinguish a missing capability from a missing evaluation. If the contribution
is mainly empirical, do not frame it as a new mechanism. If it is methodological,
explain the technical difference before listing results.

## Present the Method at the Right Depth

Give enough information for a reviewer to understand the core mechanism and why
it addresses the stated cause. Defer equations, implementation detail, and module
catalogues to Methods. Use the same terminology and claim IDs as the rest of the
paper.

## Contribution Statements

Each contribution bullet should state one checkable contribution and its evidence
or consequence. Prefer:

- a precisely scoped method or insight;
- the evaluation that tests its central claim;
- an analysis that explains when or why it works.

Do not split one contribution into several cosmetic bullets. Do not list routine
engineering, broad impact, or future work as completed contributions.

## Final Checks

Verify that the introduction and abstract agree on the problem, method, strongest
result, and scope. Every promised contribution must appear later in the paper,
and every central experiment should connect to a promise made here.
