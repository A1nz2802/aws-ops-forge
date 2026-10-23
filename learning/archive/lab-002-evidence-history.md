# Archived Evidence History: Lab 002

Historical snapshot preserved during harness simplification. Earlier next steps
and approval statements describe past stages, not current authorization. Use
`learning/checkpoint-002-image-registry.md` for the compact closure state.

- Status: CLOSED — scoped empty-registry IaC deployment/readback/teardown demonstrated, with explicit limitations and retained local artifacts.
- Business problem: preserve tested application images for later deployment and rollback without rebuilding or relying on mutable tags.
- Scope: one Amazon ECR repository for the service; Terraform proposed for reproducible infrastructure. Begin locally; publishing and CI AWS access are deferred.
- Constraints: zero AWS spend by default. Specific IAM bootstrap, login/STS, plan and bounded empty-ECR deployment were approved as recorded below. No image publishing, additional IAM changes, teardown, or hosted runs approved. Before any further real AWS action, verify context, permissions, costs, cleanup, and obtain specific approval.

## Closure assessment (authoritative)

| Objective | Outcome | Evidence |
|---|---|---|
| Repository and lifecycle defined with Terraform | Demonstrated within scoped lab | Learner-authored configuration, local validation screenshots, real plan screenshot, successful saved-plan apply reported |
| Stored lifecycle matches design | Demonstrated configuration only | AWS GetLifecyclePolicy screenshot with all three rules |
| Immutable tags and safe deletion | Partial | Source/plan configuration and reported repository readback; no overwrite or nonempty-deletion test |
| Least-privilege publisher/puller separation | Static design demonstrated; runtime not demonstrated | Reviewed IAM document data sources, no attachments or authorization tests |
| AWS resources removed | Demonstrated within scope | Approved destroy plan/apply reported; post-teardown RepositoryNotFoundException screenshot |
| Temporary privilege/session removal | Learner-reported | Learner confirmed completion of temporary-policy removal, preservation of login policy, root logout and source-profile logout; no independent IAM readback |
| Shared-tools local cleanup | Demonstrated within scope | Mentor Docker queries found no common-project containers, tools-home volume or default network |
| Safe publication | Bounded review only | Source review, ignore checks, no tracked private Terraform artifacts, no staged files; no exhaustive layer or secret scan |

- Local shared tools built/tested by mentor are harness evidence, not learner mastery. Learner reproduced versions/validate in the shared shell and implemented the IaC with guidance.
- Retained: tools image/build cache, source, lock file, private local Terraform state and saved plans, and historical `002-image-registry_default` network. Original IAM user/MFA/login permission retained intentionally. No account-wide inventory or server-side credential revocation claim.
- Unvalidated: lifecycle selection/expiration on image fixtures, nonempty deletion, immutable-tag rejection, effective publisher/puller permissions, CI publishing/deployment, full IaC reuse and automatic account guards. No image was published in this scope.
- DOP-C02 tasks 2.1 and 6.1: partial task coverage; scoped IaC and static permission design, not full task mastery. No new image-publication pipeline evidence for task 1.1.
- Public summary: `labs/002-image-registry/README.md`. Security review is recorded below. No commit, staging, push or remote run performed or authorized by the closure request.
- Handoff: open a NEW dedicated session to scope the next lab. This session is closure-only; do not begin the next lab here.

## Last operational state (historical)

- Shared local tools are built and mentor-tested; learner uses `./forge`. Documentation: `tools/README.md`.
- Root logout and new-tools login/STS identity match confirmed by learner. Terraform plan demonstrated provider authentication; see evidence below.
- Empty-repository/lifecycle creation and readback completed; teardown planning and saved destroy-plan execution separately approved. Learner reported successful teardown.
- Specifically approved post-teardown DescribeRepositories returned RepositoryNotFoundException in the target region, demonstrated by screenshot. Repository and associated lifecycle absence confirmed within this scope, not an account-wide inventory.
- Temporary-policy removal/logout subsequently reported complete and local cleanup verified; see closure assessment. No image tests or hosted runs approved.
- Entries below preserve historical implementation steps; this resume point and latest evidence take precedence over earlier next-step statements.

## Acceptance criteria

- Explain artifact identity and prevent accidental tag overwrites.
- Define the repository using learner-owned IaC and demonstrate local static validation.
- Design bounded retention that preserves release images, including an old image bearing both CI and release tags.
- Distinguish registry administration, publishing, and pulling permissions.
- Record unvalidated AWS behavior and a prospective validation/cleanup plan. Local validation does not prove ECR behavior.

## Decisions and evidence

- Learner selected one repository after comparing operational simplicity against separate retention and permission boundaries.
- Intended design: unique immutable tags for traceability; deployment by digest. Exact tag convention and lifecycle implementation remain undecided.
- Reasoning evidence only: learner identified mutable tags versus content digests, recognized that retaining only the latest ten images may lose a deployed version, and recognized that a CI-tag rule can select an image also bearing a release tag.
- Clarifications: lifecycle does not inspect deployment use; immutable tags do not prevent deletion; a digest alone does not establish source provenance or supply-chain trust.
- Required lifecycle outcome: preserve an old image tagged both `ci-abc123` and `release-v1.3.0`. No policy has been authored or tested; do not treat a release prefix as an automatic exemption.
- DOP-C02 targets: task 2.1 (reusable infrastructure definition with IaC), with a connection to task 1.1 (delivery automation). Implementation coverage not demonstrated yet.

## Next step and cleanup

- Check local Terraform availability; proceed to a small learner-authored configuration with authoritative references and progressive hints.
- Initial repository configuration authored and locally validated; no AWS validation or resources created. Compose created the local `002-image-registry_default` network; removal is not yet demonstrated. Tooling image and provider files remain locally.
- Prior retained resources and access limitations remain governed by previous checkpoints.

## Local tooling

- Learner chose Terraform and requested Docker-based tooling; Terraform is new to the learner, who has previously used CloudFormation.
- Learner screenshot demonstrated Terraform v1.16.5 on Linux amd64 using the downloaded HashiCorp image.
- Mentor supplied only `labs/002-image-registry/compose.yaml` at learner request. It mounts only the lab directory, requires host UID/GID, mounts no credentials, and disables EC2 metadata credential lookup. Network remains available for provider downloads; this is not a network isolation guarantee.
- Learner owns all Terraform configuration. Next: run Compose version check, then author the initial version constraint.

## Initial IaC evidence

- Learner-authored `versions.tf` declares CLI `= 1.16.5` and `hashicorp/aws` provider `~> 6.0`.
- Learner screenshot demonstrated successful `init -backend=false`; local lock file inspection confirmed provider 6.68.0 and package checksums.
- Learner-authored `main.tf`, reviewed locally, declares `aws_ecr_repository.service`, name `forge-service-lab002`, `IMMUTABLE` image tags, and `force_delete = false`.
- Learner initially selected forced deletion, then corrected it after a focused prompt; do not equate passing validation with demonstrated deletion behavior.
- Learner screenshot demonstrated `fmt` and successful `validate` after the repository declaration. Evidence type: local static validation, not a deployment or ECR behavior test.
- Next: design lifecycle selection and priority against the mixed-tag release acceptance case, then author the lifecycle resource. No `plan`, `apply`, AWS access, or hosted run approved.

## Lifecycle configuration and revised retention scope

- Learner chose bounded retention of the latest 10 release images, accepting that a deployed version outside that window may be deleted. This revises the earlier broad preservation criterion: mixed-tag releases are protected from the lower-priority CI rule, not from their own release expiration rule.
- Assumption: one distinct image per release; ECR counts images, not tags. Retention by count does not guarantee a time-based rollback window or protection of deployed versions.
- Learner authored `aws_ecr_lifecycle_policy.service`, referencing the repository name and using `jsonencode`: priority 1 selects tagged `release-` images with `imageCountMoreThan = 10`; priority 2 selects tagged `ci-` images with count 5; both actions are `expire`.
- Mentor read the saved file and reviewed this structure. Learner screenshot demonstrated separate Compose `fmt` and `validate` executions with validation SUCCESS in the lab directory.
- Troubleshooting: a prior `docker compose ... fmt && terraform validate` ran the second command on the host; its success did not establish lab validation. Learner injected invalid syntax and observed `fmt` fail, then restored and validated explicitly inside Compose.
- Evidence remains local static review/validation; no ECR lifecycle preview, API acceptance, expiration, or deletion behavior demonstrated.
- Next: inspect retention gaps, starting with untagged images; permissions separation and the prospective AWS validation/cleanup plan remain pending.

## Provider-native policy document

- Learner identified `aws_ecr_lifecycle_policy_document` as a better structured alternative to the generic `jsonencode` object. Mentor verified documentation and implementation at installed provider version 6.68.0; document generation serializes locally, but this does not make a full AWS-provider plan unauthenticated or local-only.
- Learner migrated both existing rules to this data source and connected its `.json` output to `aws_ecr_lifecycle_policy.service`.
- Added priority 3: `untagged`, `sinceImagePushed`, `days`, count 7, action `expire`. Learner corrected an initial `sinceImagePulled` selection after review. Age is measured from push, not tag removal.
- Saved `main.tf` reviewed: all three rule structures and resource references match current requirements. Learner screenshot demonstrated separate Compose `fmt` and `validate` commands with SUCCESS after these changes.
- Untagged retention gap addressed in configuration only; ECR API acceptance, preview, and execution remain unvalidated. Tags outside `release-`/`ci-` remain outside these rules; overall storage is not guaranteed bounded.
- Next: design least-privilege separation of registry administration, CI publishing, and deployment pulling. No IAM policy or authentication implementation yet, and no AWS operations approved.

## CI publisher policy document

- Learner authored `iam.tf` with `aws_iam_policy_document.ci_publish`: separate token statement (`ecr:GetAuthorizationToken`, resource `*`) and repository-scoped publishing statement (six actions from the AWS push example, including layer upload operations, `PutImage`, and `BatchGetImage`). Mentor reviewed the saved file; no administration or lifecycle actions appear in this document.
- Learner initially hypothesized `PutImage` alone; mentor clarified layer upload versus manifest publication. The six-action set follows the documented example, not an empirically proven minimal set for a chosen client.
- Learner screenshot demonstrated successful Compose `validate` and a separate `fmt` execution after this implementation. Local static validation only; no policy created or attached, and no permissions exercised in AWS.
- Learner reports Terraform LSP/filetype and autocomplete are working; no further editor troubleshooting needed. Generic IAM action-string completion remains a tooling limitation, not a missing-provider conclusion.
- Next: scope a pull-only consumer document, then document prospective real-AWS validation, cost, and cleanup requirements. No AWS access, IAM changes, hosted runs, `plan`, or `apply` approved.

## Pull-only document validated locally

- Learner authored `aws_iam_policy_document.image_pull` in `iam.tf`: separate `GetAuthorizationToken` statement on `*` and `BatchCheckLayerAvailability`, `BatchGetImage`, `GetDownloadUrlForLayer` on the service repository ARN. Mentor reviewed the saved file and found no publishing, deletion, or administration actions in this document; publisher document remains unchanged.
- Learner screenshot demonstrated Compose `fmt` and `validate` SUCCESS after this addition.
- Demonstrated: local configuration and static policy scope separation. Not demonstrated: effective IAM enforcement, role trust/authentication, ECR push/pull, lifecycle preview, deployment, or cleanup of AWS resources. No IAM policies have been created or attached by this configuration.
- Next decision: keep remaining evidence local or prepare a separately approved real-AWS validation scope. Before any real action, reverify account/profile/region, current plan/credits, permissions, costs and cleanup; prior identity practice does not authorize new actions.

## Real-AWS preparation and IAM bootstrap

- Learner chose real-AWS validation, confirmed the same private lab account, profile `forge-learner`, region `us-east-2`, and existing browser-based temporary login method. Current CLI identity is not yet verified.
- Learner reports Free plan active, available credits, and non-imminent expiry; exact current dates/balance not verified or persisted. No plan upgrade approved.
- Learner reported only root and `forge-learner` exist, with only `SignInLocalDevelopmentAccess` initially attached to the latter. Root MFA was confirmed as part of explicit approval.
- Specific approval: root console session solely to add inline policy `ForgeLab002Provisioning` to `forge-learner`. Learner reported completion; no screenshot/API verification and root logout not yet confirmed.
- Proposed/reported policy allows CreateRepository, DescribeRepositories, ListTagsForResource, DeleteRepository, PutLifecyclePolicy, GetLifecyclePolicy, DeleteLifecyclePolicy on only the exact private-account ARN of `forge-service-lab002` in `us-east-2`. No account identifiers persisted. This is not a proven minimal effective permission set.
- Initial deployment scope proposed: empty repository plus lifecycle only, no images, compute, advanced scanning, replication, or new roles. No storage/transfer consumption expected for an empty repository; no blanket zero-cost guarantee. Creation and cleanup each need specific approval.
- Planned cleanup: remove lifecycle and empty repository using Terraform, verify absence, remove temporary provisioning inline policy, retain original login policy. None performed yet.
- Permissions boundaries discussed conceptually; none created or approved. They constrain IAM users/roles, not the entire account; they do not automatically carry over to assumed roles or restrict root.
- Next: confirm root logout; prepare and specifically approve non-root temporary login and STS identity verification. No credential inspection outside this project, no authenticated AWS calls by mentor, and no plan/apply approved.

## Shared development tools (learner-requested harness maintenance)

- Learner confirmed root logout, explicitly approved standalone browser login and STS identity query, and reported both intended account and `forge-learner` identity matched. No private values were shared or persisted.
- Mentor proposed manual temporary credential export for separate containers; learner challenged the workflow. Export and authenticated plan were not approved or executed. Learner chose a common Compose development environment instead.
- Added root `compose.yaml`, executable `forge` wrapper, and `tools/` build/config/docs. Old Lab 002 Compose remains as historical tooling with a deprecation comment. Learner-owned Terraform files were not modified.
- One digest-pinned tools image: Go 1.26.10, AWS CLI 2.32.7, Terraform 1.16.5. OS package resolution is not snapshot-pinned; no byte-reproducibility claim. No global AWS Go SDK installation; application dependencies remain in go.mod.
- Runtime uses host UID/GID, read-only root filesystem, dropped capabilities, no-new-privileges, repository bind, and named home volume `aws-ops-forge_tools-home`. No host home, parent credentials, or Docker socket mounts. The home volume is outside Git but accessible to Docker administrators.
- Nonsecret profile template: `forge-login` for CLI browser login, `forge` for credential_process calling AWS CLI export-credentials on the source profile. No login occurs at startup. These profile names are not IAM identities. No cached credentials copied from the standalone container.
- Mentor-run local verification: image build, shell syntax checks, Compose config, non-root UID/GID, tool versions, profile file/directory modes 600/700, lab002 fmt -check/validate, and existing Go tests all passed. These are harness checks, not new learner mastery or real AWS evidence.
- Initial Go execution failed because /tmp was non-executable; corrected tmpfs to explicit exec and reran successfully. This permits temporary test binaries, not untrusted-code sandboxing.
- Read-only engineering review found a UID/GID drift concern; added fail-closed startup checks and rebuild/migration documentation. A local mismatched-ID test was rejected as expected.
- No authenticated AWS calls, credential exports, plan, apply, commit, or push executed by mentor. Real credential_process authentication remains unvalidated.
- Retained locally: `aws-ops-forge:tools` image/build cache, tools-home volume with nonsecret profile and Go caches, and `aws-ops-forge_default` network. Compose ps -a showed no tools containers at verification. Earlier access container/session and old lab network are not inventoried or cleaned; cleanup must be confirmed separately.
- Next: learner reproduces simple local tool checks, then approve renewed login/identity verification using the new environment. No AWS mutation authorization is implied by harness creation.

## New-tools authentication evidence

- Learner screenshot demonstrated Go/AWS CLI/Terraform versions and lab002 validate SUCCESS inside the shared tools shell.
- With specific approval for login and STS only, learner completed `aws login --remote --profile forge-login --region us-east-2`, then `aws sts get-caller-identity --profile forge --region us-east-2`; reported intended account and `user/forge-learner` matched with no errors.
- Evidence is learner-reported authenticated CLI validation, including the consumer credential_process bridge. It is not yet Terraform-provider authentication or ECR authorization evidence.
- Source/consumer profile distinction and container AWS_PROFILE default explained. No additional identity or permissions are created by these profiles. Login cache now resides in the shared home volume; logout/removal pending.
- Next: obtain specific approval for a read-only Terraform plan targeting the empty repository and lifecycle, expecting two managed resources to add. No saved binary plan, apply, push/pull or additional IAM mutation approved.

## First real-AWS deployment (learner executed)

- With explicit read-only plan approval, learner ran Terraform plan through the shared environment. Screenshot showed `2 to add, 0 to change, 0 to destroy`, region `us-east-2`, repository name, IMMUTABLE and force_delete=false; full lifecycle section not visible. Learner reported the overall plan correct. This demonstrates provider authentication, not all future authorization paths.
- Learner explicitly approved empty repository + lifecycle creation, conditioned on saved-plan review. Expected cost: no image storage or transfer usage for empty ECR; no blanket zero-account-cost guarantee. No images, advanced scanning, replication, compute, or new IAM resources in scope.
- Learner generated `lab002.tfplan` and reported `terraform show` matched the two approved resources and three lifecycle rules. Plan is private and ignored by `*.tfplan`; no raw plan content persisted in learning notes.
- Mentor supplied apply command for that saved plan only; learner reported `Apply complete` with no errors. No screenshot/resource counts of apply supplied yet. Evidence: learner-reported manual AWS execution, not mentor execution or independent readback.
- Repository and lifecycle must now be treated as existing until verification. Local state and saved plan retained privately; do not delete state on error or before teardown.
- Next: specifically approve and execute bounded DescribeRepositories/GetLifecyclePolicy readback. AWS lifecycle evaluation/expiry, tag overwrite denial, push/pull IAM enforcement remain unvalidated. Teardown and temporary provisioning-policy removal still require approval and evidence.

## AWS configuration readback

- Learner specifically approved DescribeRepositories and GetLifecyclePolicy for the lab repository, then reported both results correct.
- Screenshot demonstrates the retrieved lifecycle JSON: release- tagged count 10 priority 1, ci- tagged count 5 priority 2, untagged sinceImagePushed 7 days priority 3, all expire. This independently confirms stored policy configuration after Terraform apply.
- Repository name/IMMUTABLE/default encryption readback reported correct by learner; that command's output is not visible in the supplied screenshot. Do not describe it as independently screenshot-verified.
- A displayed evaluation timestamp is not evidence of intended image selection or expiration. No images/fixtures published; lifecycle execution and effective publisher/puller permissions remain unvalidated.
- Next: obtain explicit approval for a destroy plan of the two managed resources, review it, and separately execute approved teardown. No destroy or IAM-policy removal approved yet.

## ECR teardown and absence evidence

- Learner specifically approved a destroy plan, confirmed expected `0 to add, 0 to change, 2 to destroy` for only repository and lifecycle, then separately approved applying `lab002-destroy.tfplan`.
- Learner reported teardown succeeded; exact apply count output not supplied. Mentor did not execute mutations.
- With specific read-only approval, learner ran DescribeRepositories for the exact repository using `forge` in `us-east-2`. Screenshot demonstrates RepositoryNotFoundException, confirming repository absence; associated lifecycle cannot remain independently. No account-wide inventory claim.
- Error output exposed a private account identifier in chat; do not reproduce it in repository artifacts. Future screenshots must redact service error identifiers even when query output is filtered.
- Still retained/unverified: temporary IAM inline policy `ForgeLab002Provisioning`, shared login cache/session, tools image/home volume/network, old standalone access container/session/network if any, local Terraform state and plans. Their removal has not been approved or demonstrated.
- Next: obtain specific approval to remove only the temporary inline policy (root-console bootstrap, MFA, preserve SignInLocalDevelopmentAccess), and logout of the source profile. Decide local cache retention separately; do not close the lab prematurely.

## Final access cleanup and pre-commit security review

- Learner specifically approved removal of only ForgeLab002Provisioning via root console with MFA and source-profile logout, then reported all requested steps complete. Treat this as learner-reported evidence, not independent policy/session inspection.
- Learner approved removing shared home volume/network while retaining image/build cache and lab files, and reported `./forge compose down --volumes` complete after exiting the shell.
- Mentor independently queried Docker: no common-project containers, `aws-ops-forge_tools-home` volume or `aws-ops-forge_default` network. Exact-name old standalone access container was also absent. Historical `002-image-registry_default` network remains; not removed outside the approved common-environment cleanup scope.
- Additional read-only Engineering Reviewer examined public source candidates, without reading state/plans/caches. Missing preventative ignore rules found and fixed: tfvars/tfvars.json, Terraform crash logs, local Terraform CLI configuration and .aws directories. Existing state/plan/env/provider-cache exclusions retained.
- Mentor verified git check-ignore for actual state/plan paths and representative private variable/log/config paths; git ls-files found no tracked private Terraform artifacts matching those classes. Nothing staged. Wrapper executable bit, shell syntax, Compose config and tracked whitespace checks passed without recreating runtime volumes.
- Follow-up source review found no confirmed commit blockers or apparent account IDs, personal host paths, keys or tokens in the reviewed public candidate sources. `/home/forge` is a container-internal path. This is not exhaustive secret detection, image layer inspection, dependency/CVE scanning or a review of every untracked harness file.
- Residual risks disclosed in public lab/tools READMEs: writable repository bind includes ignored files, Docker administrators can access volumes, executable temporary directory needed by Go, OS package resolution not snapshot-pinned, no automatic allowed-account guard, generic IAM action strings and untested effective policies. Pinned versions require future maintenance; pinning is not a vulnerability guarantee.
- Publisher BatchGetImage retained because it follows the official AWS push example; no empirically minimal-client permission claim. No learner challenge code silently changed during review.
- Recommended future commit scope, only after explicit approval and staged-diff review: .gitignore, root compose.yaml, forge, tools sources, and public Lab 002 source/lock/README. Do not add all untracked files; harness, checkpoints, state/plans and private artifacts are not automatically publication scope.
