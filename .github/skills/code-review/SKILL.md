---
name: code-review
description: Evidence-first final-material pull-request review for governed IanIT repositories.
---

# Governed code review

1. Identify the pull request's current head SHA and review that material revision.
2. Inspect repository-specific Copilot instructions and affected trust boundaries.
3. Separate actionable findings, technically dismissed findings and unrelated product issues.
4. Require relevant CI to pass. For sensitive changes, examine failure paths, permissions, secrets, logging, idempotency, rollback and UAT evidence.
5. Do not approve or recommend merge until every actionable finding is fixed or dismissed with a concrete technical reason.
6. Record the reviewed head SHA in the final-review attestation. Copilot comments do not count as GitHub approval and do not natively block merging.
7. For Dependabot changes limited to dependency manifests and lockfiles, rely on substantive CI, vulnerability checks and lockfile integrity. Do not spend a Copilot review on files Copilot excludes; workflow, source, generated-code and mixed changes still require final-material review.

