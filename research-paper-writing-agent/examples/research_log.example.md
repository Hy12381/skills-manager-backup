# Research Log

## Literature Decision L1

- Question: Which adaptive baselines operate without deployment labels?
- Search sources: OpenReview, publisher pages, and arXiv.
- Decision: Include methods A and B; exclude method C because it uses labels.
- Claim affected: C3.
- Evidence location: `sources/literature-matrix.md`.

## Experiment E1

- Claim: C1.
- Hypothesis: uncertainty weighting improves F1 under gradual drift.
- Primary metric: F1, higher is better.
- Datasets: Dataset-A, Dataset-B, Dataset-C.
- Baselines: Static-Strong, Adaptive-A, Adaptive-B.
- Simple control: uniform weighting.
- Command: `python run.py --config configs/main.yaml --seeds 1 2 3`.
- Code revision: `abc1234`.
- Raw outputs: `runs/e1/`.
- Aggregated output: `results/main.csv`.
- Success criterion: positive mean delta over the strongest baseline on at least two datasets.
- Stop criterion: stop the route if uniform weighting matches the method within uncertainty on all datasets.
- Outcome: supported; positive delta on all three datasets.
- Next decision: retain C1 and run ablation E2 for C2.

## Failure E2-F1

- Symptom: Dataset-C produced NaNs for seed 2.
- Diagnosis: zero variance after preprocessing.
- Repair: clamp the normalization denominator and rerun only the failed seed.
- Status: execution fault resolved; not treated as scientific evidence.
