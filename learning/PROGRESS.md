# Learning Progress

Short durable index. Evidence belongs in checkpoints; practical refreshers in
`notes/`. Load only the active/requested lab and directly relevant artifacts.

## Learner and working style

- Experienced backend engineer; AWS Developer Associate; CCNA/Linux background.
- Go application; flexible pace; learner focuses on DevOps/AWS. Mentor may supply
  agreed auxiliary Go/packaging/tooling; that is not learner mastery.
- Spanish conversation and private notes; public artifacts in English. Short practice/review blocks;
  bounded phase approvals, not repetitive consent/recall loops. See `AGENTS.md`.

## Current state

- Active lab: **none**. Lab 003 closed with scoped publication/denial/cleanup evidence.
- Next: new dedicated session using `learning/checkpoint-003-ci-image-publish.md`.
  No standing AWS approval. Postclosure separate follow-up commits/harness review
  requested; no extra push/CI run. Notes revised as conceptual refreshers; lab
  briefs compacted; visual root README uses .images/ PNG exports. Notes now split
  into labs/ and fundamentos/<tool>/; presentation and notes layout revised.
  Private note and engineering section written.
- Postclosure publication review: `docs/PUBLICATION-SECURITY.md`; Gitleaks history
  and retained-log scans found no secrets. Approved deletion of detailed Lab 003
  logs verified; run statuses/evidence retained. Repo private; final [skip ci]
  delivery and learner visibility change approved, pending execution/verification.
- Shared tools: `tools/README.md`; host editor, `./forge` for Go/CLI/Terraform.
- Harness streamlined: two read-only specialists, three lab commands, explicit
  phase approvals and mandatory practical closure notes; no new tool services.
- Notes: private Spanish, Git-ignored `notes/START-HERE.md`; closure workflow in
  `docs/LEARNING-NOTES.md`. Never stage/publish notes.
  Vault-side symlink created at the learner's supplied location and filesystem
  target verified; Obsidian indexing/heading navigation awaits learner check.
- Current postclosure delivery excludes CI execution: mentor prepares a real
  [skip ci] commit; learner pushes and makes public after checks. No new AWS work.
  Private notes, credentials, state/plans and generated dependencies stay excluded.

## Lab index

| Lab | Outcome / evidence | Practical note |
|---|---|---|
| 000 | Closed partial; region guard, full preflight/checklist incomplete — `learning/checkpoint-000-safe-aws-workspace.md` | `notes/labs/lab-000-safe-workspace.md` |
| Non-root access | Manual login/STS and denial checks; approval limitations — `learning/checkpoint-non-root-access.md` | Context in Lab 000/002 notes |
| 001 | Scoped hosted test/build pipeline demonstrated — `learning/checkpoint-001-tested-container.md` | `notes/labs/lab-001-tested-container.md` |
| 002 | Scoped empty-ECR IaC/readback/teardown demonstrated; runtime limits — `learning/checkpoint-002-image-registry.md` | `notes/labs/lab-002-image-registry.md` |
| 003 | Hosted verified-image push, OIDC allow/deny, IaC teardown and local CI workbench demonstrated within scope — `learning/checkpoint-003-ci-image-publish.md` | `notes/labs/lab-003-ci-image-publish.md` |

## Retained resources / context

- AWS: original learner user, MFA and login policy remain. Lab 003 ECR/role/OIDC
  absence, temporary policy removal and logout learner-confirmed after destroy.
  Not an account-wide inventory or immediate credential-revocation guarantee.
- Free plan/credits verified historically and reported active in Lab 003; exact
  current expiry/balance unknown. Default zero spend; recheck when stale/changed.
- Local: images/build cache, private state/plans, old lab-only network and Lab 001
  branches retained. Shared-tools containers/home volume/network confirmed absent
  at Lab 002 closure; tools home recreated/retained in Lab 003. CI containers,
  network/registry volume/listeners absent at Lab 003 closure; GitHub test variables
  and branch removed. Runs/history and short-retention artifact remain in GitHub.

## DOP-C02 coverage

| Domain | Status / evidence |
|---|---|
| 1. SDLC Automation | Partial task 1.1: hosted tests/build/verified-image publication demonstrated; deployment untested |
| 2. Configuration Management and IaC | Partial task 2.1: scoped ECR/IAM IaC create/readback/repair/teardown; reusable infrastructure untested |
| 3. Resilient Cloud Solutions | Not started |
| 4. Monitoring and Logging | Not started |
| 5. Incident and Event Response | Not started |
| 6. Security and Compliance | Partial task 6.1: real OIDC permitted main push and denied non-main subject; real pull/cross-repo denial untested |
