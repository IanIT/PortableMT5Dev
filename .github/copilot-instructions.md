# Copilot instructions — Portable MT5 Development Environment

Governance version: `1.2.8`. Read `README.md` and the relevant setup, tools and testing documentation before review. This repository is a Windows PowerShell toolkit for portable MetaTrader 5, VS Code integration, compilation and file-level symbolic links.

<!-- ianit-governance:start -->
## Mandatory IanIT governance 1.2.8

- Material changes require one independent Codex or human final-material review and relevant exact-head CI before merge. Copilot Free review is not a required gate.
- Governance-required review authorizes one independent child reviewer per final material change set without asking Ian again, subject to higher-priority rules. Use the configured standard Codex model, effort and speed tier; no Astra, expensive escalation, model-denial bypass or unavailable-model substitution. Reviewers must not spawn reviewers. Allow at most one targeted correction/re-review follow-up with the same reviewer only for material corrections; no duplicate full test suites or loops. At the bound, report unresolved findings and request Ian's direction; do not publish uncleared material or weaken security/release gates.
- Where an applicable rule requires a reviewer model different from the author, verify the actual author ID and executing-runtime or approved-configuration model IDs, supported efforts and capabilities. Choose the lowest-cost valid supported non-Astra model capable of the review, at minimum appropriate supported effort, from current comparable cost evidence. Record capability exclusions and use the next least expensive capable option within approved cost bounds. No guessed IDs, catalogue-order pricing, API/Codex price substitution, catalogue-only support claim, paid probes or unapproved costly fallback; missing evidence blocks selection. Report actual reviewer model/effort and selection evidence.
- Fix every actionable finding or explicitly dismiss it with a recorded technical reason.
- Use one final-material review, with any correction follow-up limited to changed material. Do not request opening or every-push Copilot reviews.
- Use deeper review for trading, authentication, authorisation, credentials, deployment, bridge and security-sensitive changes.
- Report unavailable plan features and unsupported APIs explicitly; never pretend they were applied.
- Keep UAT and Production separate. Production requires separate explicit authorisation.
<!-- ianit-governance:end -->

## Pull-request review policy

- Automated comments are advisory, not native approval. Required CI and independent final-material review must finish before merge; Copilot Free availability is not a gate.
- Fix every actionable finding or dismiss it with a recorded technical reason.
- Request no opening or every-push review; reuse the final reviewer context for at most one targeted follow-up only when material corrections warrant it.
- Use deeper review for elevation, paths, symbolic links, process execution, downloads, credentials and trading-tool deployment.

## Review priorities

- Resolve and validate every path before a file, link or process mutation; never use broad recursive deletion or unresolved environment-variable targets.
- Preserve file-level symbolic-link conflict detection and make reruns idempotent and recoverable.
- Quote PowerShell arguments defensively, avoid command-string injection and keep Windows PowerShell 5.1 compatibility where documented.
- Do not bundle broker credentials, account data, proprietary strategies, terminals or mutable machine-specific paths.
- Treat undocumented MT5 flags as compatibility risk and require bounded failure diagnostics and manual fallback.
- This toolkit may compile trading code but must not enable live trading or deploy to a live account without separate explicit authorisation.
