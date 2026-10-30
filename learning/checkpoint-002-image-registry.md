# Checkpoint: Lab 002 — Reproducible Image Registry

- Status: **CLOSED**, scoped empty-ECR IaC validation with recorded limits.
- Next action: new dedicated session to scope the next lab; no AWS phase approval.
  Post-closure harness/lab commit and push were subsequently requested; this
  includes normal existing push CI, not AWS work or arbitrary hosted workflows.
- Ownership: learner authored Terraform repository, lifecycle and IAM documents;
  mentor supplied shared local tools, not assessed implementation.

## Evidence and gaps

| Criterion / task | Outcome | Evidence source and limits |
|---|---|---|
| ECR IaC, task 2.1 | Demonstrated within scope; partial task coverage | Local validation, real plan screenshot, saved-plan apply success reported |
| Lifecycle configuration | Demonstrated | AWS screenshot of three stored rules; no image fixtures/expiry test |
| Immutable tags / safe deletion | Partial | Source/plan; repository readback reported; no overwrite or nonempty-delete test |
| Publisher/puller separation, task 6.1 | Static design demonstrated; partial task coverage | Reviewed document data sources; no policy attachment/enforcement tests |
| AWS teardown | Demonstrated within scope | Destroy-plan/apply reported; RepositoryNotFoundException screenshot |
| Temporary access cleanup | Learner-reported | Provisioning inline policy removed, original login policy kept, root/source-profile logout |
| Shared-tools cleanup | Demonstrated locally | Mentor Docker queries: no common-project containers/home volume/default network |

## Decisions and retained state

- One repository; IMMUTABLE; force_delete=false. Lifecycle: releases latest 10
  priority 1, CI latest 5 priority 2, untagged since push 7 days priority 3.
- Release tags prevent lower-priority CI expiration, not release-rule expiration.
  Count retention does not protect deployed versions; other tag prefixes unbounded.
- `forge-login` source profile -> `forge` credential_process consumer. CLI/STS
  identity matched by learner report; real Terraform plan demonstrated provider
  authentication. Shared-tools profile names are not separate IAM identities.
- Retained: IAM user/MFA/SignInLocalDevelopmentAccess; tools image/build cache,
  private state/plans, source/lock file, old `002-image-registry_default` network.
- No ECR resources remain in the tested scope. No account-wide inventory or
  immediate server-side credential-revocation claim.
- Free plan/credits reported active during lab; exact expiry/balance unverified.
  Recheck when stale or spend assumptions change, not before every command.

## Approval / publication / handoff

- Historical login, bootstrap, create/read/teardown actions had specific approvals;
  all those phases are complete. They are not standing authority for another lab.
- Source review found no confirmed blocker in reviewed public candidates; ignore
  rules cover state/plans/tfvars/crash logs/local credentials. No exhaustive
  secrets/layer/CVE scan, automatic account guard or runtime IAM proof.
- No staging, commit, push or new hosted run during the lab's assessed execution.
  Subsequent requested harness maintenance/publication did not reopen the lab;
  Git history and remote checks record that delivery separately.
- Practical note: `notes/labs/lab-002-image-registry.md`.
- Detailed history: [archive](archive/lab-002-evidence-history.md), load only for
  a specific evidence question. Public scope: `labs/002-image-registry/README.md`.
- Next lab must begin in a **new session**. During post-closure maintenance,
  the learner supplied the vault location; its notes symlink was created and
  filesystem target verified. Obsidian indexing is not yet learner-confirmed.
