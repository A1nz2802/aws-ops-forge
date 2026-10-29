# Checkpoint: Lab 003 — Verified Image Publication

- Status: active; real empty infrastructure created/read back, CI publication pending.
- Next: mentor commits reviewed files; learner pushes main (triggers AWS writes).
  Inspect that run before retries or the separately approved denial run.
- Ownership: learner Terraform/workflow with guidance; requested CI tooling,
  outputs/auth scaffold and root diagram supplied by mentor, not learner mastery.

## Evidence and decisions

| Criterion / DOP-C02 task | Assessment / evidence |
|---|---|
| Terraform / 2.1 | Five-create plan reviewed; learner apply screenshot 5 added; ECR/lifecycle/OIDC readback screenshots, role policies privately confirmed |
| Identity / 6.1 | Static and stored-config validation; effective GitHub OIDC/IAM still untested |
| Pipeline / 1.1 | ACT tests/build/health/nonroot/transfer passed; IDs equal; wrong expected ID blocked job |
| Local ECR | Floci push/API digest agreement, changed-image immutable rejection, original digest retained; automated test ecr PASS + scoped cleanup |
| Local lifecycle | Learner down/absence/up/smoke/floci/transfer passed on original host; cold install/second host unvalidated |

- Publish verified image without rebuild; tag ci-<full SHA>, collision fails.
- tools/ci/ci.sh: build/up/down/test smoke|floci|ecr|verify|transfer; README has
  commands, architecture and limits. ACT 0.2.89 controller + runners are siblings
  via DooD, dedicated forge-ci-local, internal artifact server, no host HOME.
  Floci 2.3.0 socket access and pinned registry auxiliary approved for local ECR.
- Prior host artifact listener blocked by UFW: scoped temporary rule proved cause,
  then removed/readback verified. Containerized ACT removed that dependency.
- Local ECR cleanup verified: absent repo, floci-aws-forge-ci-ecr-registry,
  floci-aws-ecr-registry-data and fixture tag; source image/caches retained.
- service-ci.yml: PR/push/manual verify; manual load/compare; prepare/auth/login/
  push/BatchGetImage summary only push/main, logout always on that route.
  lab003-oidc-denial.yml: manual only, branch guard, expected action failure;
  inspect actual STS error, not just green job. No environment-based OIDC subject.

## AWS context and live resources

- Learner privately verified non-root account via forge-login -> forge; us-east-2.
  Free plan/sufficient credits learner-reported; exact balance/expiry unknown.
- providers.tf fixes profile/region + allowed_account_ids; real ID in ignored tfvars.
- Live retained resources explicitly approved: GitHub OIDC provider, publisher role
  forge-lab003-ci-publish + inline policy, ECR forge-service-lab003 + lifecycle.
  IMMUTABLE, force_delete=false; no images published yet as of this checkpoint.
- Initial read denied. Temporary ForgeLab003PreflightRead/ForgeLab003Provision
  assigned via console with separate approvals; learner reports both now removed.
  Provisioning role-policy privilege risk explained; no general escalation guarantee.

## Current bounded publication approval

- Explicit learner approval: three GitHub repo variables; reviewed commit/push main
  for ONE allowed publication, lab003-oidc-denial branch + ONE manual denial run.
  Timeouts 20+3 job-minutes; no automatic retries. Stop on unexpected state/errors.
- Private personal a1nz2802/aws-ops-forge; low GitHub use learner-confirmed, overage
  blocking unverified. Small ECR storage estimate discussed, no zero-cost promise.
- All three variables exactly compared to local Terraform outputs/us-east-2, values
  redacted. Initially descriptions were pasted instead of outputs; learner fixed.
- Includes subsequent image cleanup, reviewed five-resource teardown, temporary
  restoration/removal of same provisioning policy if needed, branch/variable cleanup.
  Learner executes AWS mutations, including push that triggers publication.
  No new permissions/services/regions or application deployment authorized.
- Source candidates reviewed/linted; notes, state/plans/tfvars/private files and
  outdated root Excalidraw excluded. No staging secrets or global Docker cleanup.

## Closure obligations

- Resume this lab, not another. Local emulator pull, actual IAM enforcement,
  real lifecycle expiry and production deployment remain unvalidated.
- At closure write private Spanish notes/lab-003-ci-image-publish.md with ONE CI
  engineering section: actual commands, decisions/tradeoffs, CLI/UFW/variables
  incidents, evidence/cleanup/limits. Update learner-selected diagrams then.
- Public English docs stay separate. No closure or next lab in this state.
