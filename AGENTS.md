# IanIT repository working agreements

Governance version: `1.2.7`. Profile: `active`.

<!-- ianit-governance:start -->
## Mandatory IanIT repository workflow 1.2.7

- Before code, policy or release changes, establish the real checkout/Git state,
  remote default branch, relevant open issues/PRs, review findings, scoped GitHub
  notifications, security alerts and CI/deployment evidence. Use compact,
  paginated repository queries; read-only advice needs only relevant evidence.
- Preserve unrelated changes and private data. Use a reviewable branch and PR;
  never push task work directly to the default branch. Batch related fixes.
- Match validation to impact: ordinary docs/comments need structural checks and
  targeted review; application changes need affected tests/static checks;
  bridge, authentication, trading, data, dependency, CI/release and authorization
  policy changes retain full required security/release gates. Wording-only
  edits are not authority to weaken a safeguard.
- Use focused local checks and required exact-head CI; do not duplicate complete
  suites locally solely because CI runs them. Material changes need one
  independent final-material review before publication and required CI before
  merge. Low-impact changes may use self-review unless stronger rules apply.
  Fix or technically dismiss actionable normal, outdated and suppressed findings.
  Existing reviewed manifest/lockfile-only dependency automation may rely on
  substantive CI, vulnerability checks and lockfile integrity; mixed source or
  workflow changes still need independent review. Copilot Free review is neither
  assumed available nor a required gate.
- Default to one review/correction pass; scope follow-up to changed material.
  Diagnose failures before retrying; permit at most one unchanged retry for a
  diagnosed intermittent/infrastructure failure, then report the blocker. Use
  compact CI status checks; never rerun or redeploy merely to make output green.
- Keep PR validation, final-commit packaging and deployment distinct. Reuse
  exact-tree evidence only through verified provenance and the repository's
  supported receipt path; otherwise retain required validation. Preserve
  immutable artifacts, rollback identity and independent live verification.
- For new projects and new or changed publishing paths, default to content-based
  incremental transfer for both UAT and authorised Production. Use Web Deploy
  `-useChecksum` for file sync, or the platform's verified content-addressed
  equivalent; do not rely only on timestamps or disable required validation.
  Exclude runner-only migration/build tools from hosted staging only after
  proving the application does not need them. Retain the complete immutable
  validated artifact, provenance and rollback package; never trim that artifact.
  Preserve required CI, independent review, migration/backup gates, protected
  hosted data/configuration, environment isolation and live health, release and
  authentication verification. Publishing-process changes require the full gate
  before any validation fast path. Add an appropriate publishing CI regression
  check and report changed files/bytes separately from total artifact size.
- Upload only useful Actions artifacts: retain routine CI/diagnostics/UAT for
  7 days, small deployment/recovery receipts for 14, and deliberate benchmark or
  release evidence for at most 30. Keep released deliverables outside recurring
  Actions artifacts.
- Preserve UAT/Production and project-specific safety boundaries. Production,
  credentials, consent, live data changes, email, recovery and trading require
  explicit authority. Model defaults/guards cannot be silently changed or bypassed.
- Resolve only in-scope actionable items. For code/policy/release work, refresh
  scoped notifications at handoff;
  mark Done only individually verified resolved/superseded items. A newer green
  run must cover the same branch/workflow or a documented equivalent replacement.
  Keep unrelated/unverified issues visible with blocker, owner and next action.
- Report unavailable services, permissions/plan features and unpassed gates.
  Continue safe local work; never claim an unrun check/deployment succeeded.
<!-- ianit-governance:end -->

Repository-specific instructions may add stronger commands, architecture rules,
and safety boundaries. They must not silently weaken this managed baseline.
