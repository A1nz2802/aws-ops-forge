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

- Active lab: **none**. Lab 002 closed; only requested harness maintenance here.
- Next: open a new dedicated session to scope the next lab with the compact
  `learning/checkpoint-002-image-registry.md`. No current AWS phase approval.
- Shared tools: `tools/README.md`; host editor, `./forge` for Go/CLI/Terraform.
- Harness streamlined: two read-only specialists, three lab commands, explicit
  phase approvals and mandatory practical closure notes; no new tool services.
- Notes: private Spanish, Git-ignored `notes/START-HERE.md`; closure workflow in
  `docs/LEARNING-NOTES.md`. Never stage/publish notes.
  Vault-side symlink created at the learner's supplied location and filesystem
  target verified; Obsidian indexing/heading navigation awaits learner check.
- Post-closure publication of the harness and completed lab artifacts explicitly
  requested by learner, including normal existing push CI. Delivery is recorded
  in Git history/remote checks, not a self-referential checkpoint commit ID.
  Private notes, credentials, state/plans and generated dependencies stay excluded.

## Lab index

| Lab | Outcome / evidence | Practical note |
|---|---|---|
| 000 | Closed partial; region guard, full preflight/checklist incomplete — `labs/000-safe-aws-workspace/checkpoint.md` | `notes/lab-000-safe-workspace.md` |
| Non-root access | Manual login/STS and denial checks; approval limitations — `learning/checkpoint-non-root-access.md` | Context in Lab 000/002 notes |
| 001 | Scoped hosted test/build pipeline demonstrated — `learning/checkpoint-001-tested-container.md` | `notes/lab-001-tested-container.md` |
| 002 | Scoped empty-ECR IaC/readback/teardown demonstrated; runtime limits — `learning/checkpoint-002-image-registry.md` | `notes/lab-002-image-registry.md` |

## Retained resources / context

- AWS: original `forge-learner` user, MFA and SignInLocalDevelopmentAccess remain.
  Temporary Lab 002 provisioning-policy removal and logout learner-reported;
  ECR repository absence screenshot-verified. Not an account-wide inventory.
- Free plan/credits verified historically and reported active in Lab 002; exact
  current expiry/balance unknown. Default zero spend; recheck when stale/changed.
- Local: images/build cache, private state/plans, old lab-only network and Lab 001
  branches retained. Shared-tools containers/home volume/network confirmed absent
  at Lab 002 closure. No server-side credential-revocation guarantee.

## DOP-C02 coverage

| Domain | Status / evidence |
|---|---|
| 1. SDLC Automation | Partial task 1.1: Lab 001 test/build CI; no image publication/deployment |
| 2. Configuration Management and IaC | Partial task 2.1: Lab 002 scoped ECR IaC; full reusable infrastructure untested |
| 3. Resilient Cloud Solutions | Not started |
| 4. Monitoring and Logging | Not started |
| 5. Incident and Event Response | Not started |
| 6. Security and Compliance | Partial task 6.1: non-root identity checks and Lab 002 static IAM separation; effective push/pull untested |
