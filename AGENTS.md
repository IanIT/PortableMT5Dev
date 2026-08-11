# IanIT repository working agreements

Governance version: `1.2.4`. Profile: `active`.

<!-- ianit-governance:start -->
## Mandatory IanIT repository workflow 1.2.4

- Establish the real checkout, git state, remote default branch, open pull
  requests, substantive CI, and unresolved review threads before changing code.
- Preserve unrelated working-tree changes and use a reviewable branch and pull
  request; never push task work directly to the default branch.
- Batch related fixes. Use focused validation while iterating and run the full
  relevant suite once on the final local head before publication.
- Use compact GitHub Actions status checks. Do not repeatedly stream the same
  run, rerun unchanged checks, or redeploy merely to produce cleaner output.
- Inspect normal, outdated, and suppressed review findings together. Fix or
  technically dismiss each actionable finding, then obtain exact-head
  independent review and CI evidence before merge. Copilot PR review is
  optional and must not be treated as available on GitHub Copilot Free.
- Keep pull-request validation, default-branch artifact creation, and deployment
  distinct. Preserve project-specific security and exact-artifact release gates.
- Keep UAT and Production separate. Production, credentials, live data, email
  delivery, recovery, consent, and trading actions require explicit authority.
- If Actions minutes, plan features, permissions, or external services are
  unavailable, continue safe local validation where possible and report the
  hosted gate honestly; never claim an unrun check or deployment succeeded.
<!-- ianit-governance:end -->

Repository-specific instructions may add stronger commands, architecture rules,
and safety boundaries. They must not silently weaken this managed baseline.
