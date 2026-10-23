# Archived Progress Snapshot — Before Harness Simplification

Historical index retained for provenance, not current startup context. Refer
to `learning/PROGRESS.md` and the linked compact checkpoints for current state.

This file is the durable learning state; chat history is not. Keep it concise. Use one dedicated session per lab.

## Profile and constraints

- Starting point: AWS Developer Associate; experienced backend developer; CCNA-level networking; practical Linux.
- Application language: Go.
- Pace: flexible; no target exam date.
- AWS account: Free plan, created recently; exact expiry, credits, account identity, region, and permissions have not yet been verified in a lab.
- AWS spend: zero by default. No resource mutations or plan changes without specific prior approval.
- Public repository language: English. Tutor conversation: Spanish.

## Current state

- Active lab: none
- Status: Lab 002 closed with scoped IaC deployment/readback/teardown demonstrated and explicit runtime/security limitations. Lab 001 and Lab 000 remain closed with their recorded limitations.
- Current session: Lab 002 closure only; do not begin another lab here. No further AWS operations, commit/push or hosted runs approved. Shared local tools: `tools/README.md`.
- Next action: open a new dedicated session to scope the next lab, loading `learning/checkpoint-002-image-registry.md`. Pre-commit source review completed with preventative ignore fixes; nothing staged or committed. Private state/plans, image/build cache and historical lab-only network retained as recorded.
- AWS objects retained from guided practice: learner-created IAM user `forge-learner`, console access, MFA device, and AWS-managed `SignInLocalDevelopmentAccess` attachment. No access keys or deployment resources were reported created. This is not an account-wide inventory.

## Non-root temporary-access practice

- Evidence and limitations: `learning/checkpoint-non-root-access.md`.
- Manual AWS validation, learner-reported: MFA console login; browser-based CLI login in Docker using named profile; STS identity matched the intended account and IAM user; S3 ListBuckets returned AccessDenied and exit code 254.
- Billing screenshots confirmed an active Free plan and available credits; private values and account identifiers are not persisted.
- Cleanup: logout output confirmed cached login credentials removed, with already-loaded access tokens usable until expiration (15-minute lifetime). Screenshot showed no containers matching the lab000 image. Image/build cache and IAM identity intentionally remain.
- Approval gap: learner created the IAM user, enrolled MFA, and performed CLI authentication/profile correction before the corresponding explicit approval was completed. Do not retroactively describe these actions as approved.
- DOP-C02 task 6.1: partial demonstrated coverage through manual AWS identity and authorization checks; federation at organizational scale and automated provisioning remain unvalidated.

## Lab 002: reproducible image registry

- Public summary: `labs/002-image-registry/README.md`; durable evidence: `learning/checkpoint-002-image-registry.md`.
- Learner authored ECR repository/lifecycle and separate publisher/puller policy documents. Local fmt/validate passed; real plan proposed two resources; saved-plan creation and teardown reported successful. Screenshot demonstrated stored lifecycle and subsequent RepositoryNotFoundException.
- Temporary provisioning-policy removal, preservation of original login permission, root logout and source-profile logout are learner-reported. Mentor verified shared-tools containers/home volume/network absent. No account-wide inventory or immediate credential-revocation claim.
- Shared Compose tools supplied at learner request: Go 1.26.10, AWS CLI 2.32.7, Terraform 1.16.5, source/consumer profiles linked by credential_process. Mentor local checks passed and learner reproduced versions/validate; authenticated CLI/plan demonstrated the chosen flow within this scope.
- Coverage: DOP-C02 tasks 2.1 and 6.1 partial. Lifecycle runtime effects, tag overwrite rejection, nonempty deletion, publisher/puller enforcement, reusable multi-environment IaC, image publication and deployment remain unvalidated.
- Additional pre-commit review found missing tfvars/crash-log/local-configuration exclusions; fixed and ignore-tested. No confirmed blocker in reviewed public sources; not exhaustive secrets/layer/CVE scanning. No files staged, committed or pushed.
- Retained intentionally or explicitly recorded: tools image/build cache, private state/plans and historical lab-only Docker network. Original IAM identity/MFA/login policy remain. Public source is not yet authorized for publication.

## Lab 001: tested container

- Brief and supporting application: `labs/001-tested-container/README.md` and `app/`.
- Learner preference: mentor supplies auxiliary Go code with a short explanation; learner focuses on DevOps/AWS decisions, implementation, and troubleshooting.
- Mentor supplies Docker packaging; do not assess Dockerfile syntax. Learner wrote the Actions YAML with guidance, resolved action SHAs, diagnosed a runner-specific check failure, and demonstrated failure gating and restoration.
- CI provider: GitHub Actions; private repository and selected eight-file publication approved. Node.js 24 actions pinned to verified commits; manual, PR-to-main, and push-to-main triggers demonstrated. Screenshots showed included quota and an Actions $0 budget with Stop usage enabled; final billed usage was not inspected.
- Mentor-run local verification: `go test -count=1 -v ./...` passed both tests; `go vet ./...` passed. This is not learner mastery or hosted CI evidence.
- Local Docker evidence: successful build reported by learner; screenshot demonstrated HTTP 200 with body `ok` and `/service` running with UID/GID 65532. Subsequent screenshot demonstrated stop/removal and no rows in the exact-name all-container listing; image/build cache intentionally retained.
- DOP-C02 task 1.1: partial task coverage with demonstrated test/build pipeline. Failure run `37899296899` showed tests FAILED, build/runtime checks SKIPPED, cleanup SUCCEEDED; restored run passed. Updated action runtimes passed. Automatic PR run `37906998896` and push-to-main run `37907615651` independently verified SUCCESS, with merge at `24fe193`. Bounded local image review found no apparent secrets, not exhaustive proof. Artifact publishing/deployment and branch protections remain unvalidated. Earlier second run preceded separate confirmation; see checkpoint for approval limitation.
- Cleanup/retention: named local container removal demonstrated; hosted cleanup steps passed. Learner agreed to retain local image/build cache. Three merged work branches remain; deletion was not explicitly authorized. Harness and checkpoints remain local/untracked; no AWS calls were performed.
- Closure: scoped test/build objectives demonstrated; secret-free criterion partial (bounded source, context, metadata, and visible history review). No artifact publishing, byte-reproducibility proof, branch-protection enforcement, deployment, or exhaustive layer scan. No additional harness tools introduced.

## Lab 000 evidence and learning preference

- Local artifacts: `labs/000-safe-aws-workspace/Dockerfile` and learner-authored `preflight-region.sh` in the same directory.
- Learner-reported container tests: expected region accepted; environment override and missing profile rejected; `&&` prevented a harmless next-step marker on rejection. Final saved script passed mentor-run `sh -n`.
- Manual console evidence confirmed the Free plan and displayed remaining credits and plan duration. No authenticated CLI identity verification was performed; no AWS mutations were performed in the lab's reported action scope.
- Prefer short executable exercises and troubleshooting; derive documentation from evidence rather than repeated recall questions. Written checklist remains pending, not waived as demonstrated.
- Closure retrospective: learner confirms CLI use, shell exercises, and test-driven troubleshooting improve understanding. Keep safety boundaries, reduce recall loops, stop support-tool exercises once they meet their purpose, and derive sparse notes from completed practice. No additional agents or workflow machinery are needed.

## Harness decisions to review after Lab 000

- Does the one-session-per-lab workflow preserve enough context with the current checkpoint format?
- Are three read-only specialist agents useful, or should any be removed/merged?
- Are the start, resume, checkpoint, and close commands clear and low-friction?
- Are safety checks protective without interrupting local-only study?
- What should be simplified before adding more labs or enabling Agent Toolkit capabilities?

## DOP-C02 coverage

Coverage means evidence-based practice, not merely a topic appearing in a document.

| Domain | Weight | Evidence-based status |
|---|---:|---|
| 1. SDLC Automation | 22% | Partial: task 1.1 test/build CI demonstrated; see `learning/checkpoint-001-tested-container.md` |
| 2. Configuration Management and IaC | 17% | Partial: task 2.1 scoped ECR IaC deployment/readback/teardown; see `learning/checkpoint-002-image-registry.md` |
| 3. Resilient Cloud Solutions | 15% | Not started |
| 4. Monitoring and Logging | 15% | Not started |
| 5. Incident and Event Response | 14% | Not started |
| 6. Security and Compliance | 17% | Partial: task 6.1 identity checks and static publisher/puller policy separation; see non-root-access and Lab 002 checkpoints; runtime enforcement unvalidated |

Update status only with links to concrete lab evidence and unresolved gaps.
