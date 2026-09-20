# Open-Source Readiness Notes

This package was prepared as a clean open-source distribution of the local research-paper-writing-agent skill.

## Included

- `SKILL.md`
- `references/`
- `templates/`
- `examples/`
- `docs/`
- `scripts/check-result-audit.ps1`
- `tests/check-content-quality.ps1`
- `tests/check-skill-contract.ps1`
- `tests/check-workflows.ps1`
- `tests/check-open-source.ps1`
- `README.md`
- `LICENSE`

## Excluded

- local backup files
- project-specific manuscripts
- result directories
- external GPT session files
- user browser profiles
- generated packages
- local status notes

## Before Publishing

1. Review `LICENSE` and set the correct copyright holder.
2. Run all four commands under README `Development Checks`.
3. Review any warnings from the scanner.
4. Confirm template licenses are acceptable for redistribution.
5. Confirm the skill provenance is described accurately in the repository description or README.

## Encoding Guarantee

`tests/check-content-quality.ps1` validates Markdown as strict UTF-8, rejects the
known quoted-character and mojibake patterns, checks routed headings, and checks
balanced code fences. Keep this test in CI when changing reference content.

