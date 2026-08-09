# Copilot instructions — Portable MT5 Development Environment

Governance version: `1.0.0`. Read `README.md` and the relevant setup, tools and testing documentation before review. This repository is a Windows PowerShell toolkit for portable MetaTrader 5, VS Code integration, compilation and file-level symbolic links.

## Pull-request review policy

- Treat Copilot review as advisory evidence. Required CI and the requested review must finish before merge.
- Fix every actionable finding or dismiss it with a recorded technical reason.
- Do not review every push automatically. Request one opening review and one intentional final re-review after material corrections.
- Use deeper review for elevation, paths, symbolic links, process execution, downloads, credentials and trading-tool deployment.

## Review priorities

- Resolve and validate every path before a file, link or process mutation; never use broad recursive deletion or unresolved environment-variable targets.
- Preserve file-level symbolic-link conflict detection and make reruns idempotent and recoverable.
- Quote PowerShell arguments defensively, avoid command-string injection and keep Windows PowerShell 5.1 compatibility where documented.
- Do not bundle broker credentials, account data, proprietary strategies, terminals or mutable machine-specific paths.
- Treat undocumented MT5 flags as compatibility risk and require bounded failure diagnostics and manual fallback.
- This toolkit may compile trading code but must not enable live trading or deploy to a live account without separate explicit authorisation.

