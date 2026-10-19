# IanIT repository working agreements

Governance version: `1.2.8`. Profile: `active`.

<!-- ianit-governance:start -->
## Mandatory IanIT repository workflow 1.2.8

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
- Governance-required independent review authorizes one child reviewer per final
  material change set without asking Ian again, subject to higher-priority rules.
  Use the configured standard Codex model, effort and speed tier; never escalate
  to Astra or an expensive model, or bypass a model denial. An unavailable model
  must fail clearly without substitution. Reviewers must not spawn reviewers.
  Allow at most one targeted correction/re-review follow-up with the same reviewer
  only when material corrections warrant it; do not duplicate full test suites.
  At the bound, report unresolved findings and request Ian's direction; do not
  loop, publish uncleared material or weaken mandatory security/release gates.
- Scope review follow-up to changed material.
  Diagnose failures before retrying; permit at most one unchanged retry for a
  diagnosed intermittent/infrastructure failure, then report the blocker. Use
  compact CI status checks; never rerun or redeploy merely to make output green.
- Keep PR validation, final-commit packaging and deployment distinct. Reuse
  exact-tree evidence only through verified provenance and the repository's
  supported receipt path; otherwise retain required validation. Preserve
  immutable artifacts, rollback identity and independent live verification.
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
