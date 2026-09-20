# IanIT repository working agreements

Governance version: `1.2.6`. Profile: `active`.

<!-- ianit-governance:start -->
## Mandatory IanIT repository workflow 1.2.6

- Establish the real checkout, git state, remote default branch, open pull
  requests, substantive CI, and unresolved review threads before changing code.
- Preserve unrelated working-tree changes and use a reviewable branch and pull
  request; never push task work directly to the default branch.
- Batch related fixes. Use focused validation while iterating and run the full
  relevant suite once on the final local head before publication.
- Use compact GitHub Actions status checks. Do not repeatedly stream the same
  run, rerun unchanged checks, or redeploy merely to produce cleaner output.
- Minimise Actions storage: upload only artefacts needed after the producing job;
  retain routine CI evidence, failed-build diagnostics and UAT packages for 7
  days, small deployment receipts and recovery manifests for 14 days, and
  deliberate benchmark or release evidence for at most 30 days. Preserve
  released deliverables outside recurring Actions artefacts.
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
- At the start and completion of repository work, check that repository's GitHub
  notifications alongside open issues/PRs, security alerts, review findings and
  relevant CI/deployment results. Use repository-scoped, paginated API queries
  and compact summaries; avoid repeated full-account scans.
- Resolve actionable items within the authorised scope and verify the result.
  Mark only individually verified resolved or superseded notifications Done;
  clearing a notification is not resolving an issue. A newer green run counts
  only when it covers the same affected branch/workflow or an explicitly
  documented replacement with matching release evidence.
- Keep unresolved or unverified items visible and record the blocker, owner and
  next action in the handoff or existing tracker. Do not silently dismiss
  security findings, close unrelated work, rerun recovery, or redeploy a live
  app just to make the inbox or checks green. Existing authority boundaries apply.
- Before handoff, refresh scoped notifications and report what was cleared and
  what remains. If access is unavailable, state that the check was not completed.
<!-- ianit-governance:end -->

Repository-specific instructions may add stronger commands, architecture rules,
and safety boundaries. They must not silently weaken this managed baseline.
