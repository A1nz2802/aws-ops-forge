# Checkpoint: Lab 003 — Verified Image Publication

- Status: **CLOSED**, scoped real publication/denial/teardown demonstrated.
- Next: new dedicated session to scope the next lab. Requested closure-artifact
  review/publication may continue here, but no new lab or automatic hosted run.
- Ownership: learner Terraform/workflows with guidance and real AWS mutations;
  mentor requested local CI tooling/scaffold/reviews/notes. Scaffold is not mastery.

## Assessment and evidence

| Criterion / DOP-C02 task | Outcome and source |
|---|---|
| IaC / 2.1 | Demonstrated within scope: five-resource saved plan, learner apply screenshot, ECR/lifecycle/OIDC readback and role policies privately confirmed |
| Verified artifact / 1.1 | Hosted verify and cross-job image-ID comparison passed; local wrong-ID test blocked progression |
| OIDC publication / 1.1, 6.1 | Real push and BatchGetImage digest lookup passed in attempt 2 of run 40815767972; mentor API/log review |
| Denied subject / 6.1 | Run 40817926160 from lab003-oidc-denial: explicit STS AssumeRoleWithWebIdentity rejection, not just a green expected-failure job |
| Local CI workbench | ACT/Floci smoke, API, transfer and ECR positive/negative/cleanup tests passed on original Linux amd64 host; cold/second host untested |
| AWS cleanup | Image removed by learner, CLI screenshot empty; five-delete plan reviewed and apply screenshot; ECR/role/OIDC absence learner-confirmed |
| Access/local/GitHub cleanup | See below; evidence strength is scoped, not an account-wide inventory |

## Decisions and incidents

- Preserve verified image via TAR/artifact, no rebuild in publish; immutable
  ci-<full SHA>, collision fails explicitly. ECR force_delete=false.
- Real commit 278370c12d1b05346d686b8e0f0b5c9afed29a3e; published digest
  sha256:b9efc9877def8f3ffb85f0bb6c7cf4e31f40d1a00ce5fcf7b846c55f6a4081c3.
- First publish failed before ECR: old name-only/lower-case sub mismatched GitHub
  immutable subject. API/docs confirmed owner/repo IDs; mentor missed preflight.
  Exact main sub repaired in Terraform, one-role update reviewed, learner apply/
  readback, temporary repair policy removed; publish-only retry succeeded.
- Local UFW incident: host artifact listener blocked; scoped temporary rule proved
  cause and was removed/readback verified. Final ACT controller/artifact server
  runs inside forge-ci-local; no permanent firewall exception or host artifact port.
- Missing AWS CLI fixed in pinned multistage runner; ACT compiled at fixed version.
  GitHub variables initially held descriptions, corrected/exactly compared privately.
- Full local commands/limits: tools/ci/README.md. Local ECR test is separate from
  the real workflow, not evidence that every production inline step is equivalent.

## Cleanup, retention and safety

- AWS: lab ECR/lifecycle, role/inline policy and new OIDC provider removed.
  ForgeLab003PreflightRead, ForgeLab003Provision, ForgeLab003TrustRepair removal
  and forge-login logout learner-confirmed. Original learner user/MFA/login policy
  retained. No server-side immediate credential-revocation claim.
- Mentor verified GitHub variables [] and denial branch absent. Runs/history and
  short-retention artifact retained in GitHub; no further run/retry authorized.
- Mentor Docker/port checks: no CI controllers/runners/test service/Floci,
  forge-ci-local network, registry volume, listeners 4566/34567. Local images,
  caches, private artifacts/state/plans and tools home retained; no global inventory.
- Free plan/credits and low GitHub consumption learner-reported; exact final
  balances/charges not audited. No production-ready or zero-cost guarantee.
- Remaining gaps: real pull/cross-repo denial/lifecycle expiry, concurrent runs,
  second host/cold build, application deployment/rollback and production hardening.

## Durable artifacts and handoff

- Private practical note written: notes/lab-003-ci-image-publish.md, indexed in
  notes/START-HERE.md; ONE consolidated CI engineering section with actual commands,
  decisions/incidents and cleanup. Never stage/publish notes.
- Local root canvas updated to final topology; learner's separately edited/browser
  diagrams were not overwritten or imported without source files.
- Real run URLs in labs/003-ci-image-publish/README.md. Learner requested separate
  postclosure lab, local-CI and harness follow-up commits. Original tested commit
  278370c already mixed lab/tooling; preserve it, no history rewrite authorized.
  Root README improvements and learner's manual diagram sources await feedback.
  No postclosure push/run authorized. A normal main push would trigger publication
  with resources/variables removed; final delivery needs agreed non-running scope.
- All lab phases complete; approvals are not standing authority for the next lab.
