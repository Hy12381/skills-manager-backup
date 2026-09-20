# Claim Evidence

| Claim ID | Allowed wording | Evidence | Support | Boundary |
| --- | --- | --- | --- | --- |
| C1 | The method improves mean F1 over the strongest static baseline on three gradual-shift benchmarks. | `results/main.csv`, rows tagged `C1` | supported | Three named datasets; gradual shift only |
| C2 | Uncertainty weighting contributes to the improvement. | `results/ablation.csv`, full-vs-no-weighting comparison | partial | Supported on two of three datasets |
| C3 | Prior adaptive methods require deployment labels. | Publisher pages and source passages listed below | pending | Do not use until every cited method is checked |

## Source Notes

### C3 / Example Paper

- URL: `https://doi.org/10.0000/example`
- Verified metadata: Example Author, "Example Paper," Example Venue, 2025.
- Supporting passage: Methods section, paragraph 2.
- Status: placeholder example; replace with a real verified source before use.

## Wording Changes

- Rejected: "robust to arbitrary distribution shift."
- Reason: evidence covers gradual shifts on three datasets only.
