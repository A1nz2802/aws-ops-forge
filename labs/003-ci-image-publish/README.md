# Lab 003 — Publish the Verified Image

## Problem and ownership

ParcelFlow must publish the exact image that passed verification, without
persistent cloud keys. The learner implements Terraform/workflows with guidance;
the mentor supplies requested tooling/scaffold. Publication is not deployment.

![Service CI architecture](../../.images/02.png)

*The full publication path is shown. In the implemented manual route, the second
job stops after download/load/identity comparison; only push to main publishes.*

## Acceptance criteria

- Failed verification blocks publication; transfer the image without rebuilding.
- Use OIDC and temporary credentials; trust the exact authorized repository/main
  subject, including immutable owner/repository IDs when enabled by GitHub.
- Push an immutable `ci-<full SHA>` tag; record its ECR digest; fail on collision.
- Demonstrate one permitted context and an explicit STS denial from another branch.
- Reproduce useful local checks, then validate GitHub/AWS behavior separately.
- Delete images, review Terraform teardown and verify cleanup/access removal.

## Components and limits

- Terraform: OIDC provider, publisher role/inline policy, ECR/lifecycle; fixed
  profile/region and expected-account guard. Private inputs/state/plans stay local.
- [Local workbench](../../tools/ci/README.md): ACT/Floci tests, not proof of IAM/OIDC.
- [Service workflow](../../.github/workflows/service-ci.yml): manual transfer or
  main publication; [denial workflow](../../.github/workflows/lab003-oidc-denial.yml).
- Policy templates are not safe to attach indiscriminately: role creation/policy
  writing can enable escalation even with a scoped role name.

**Closed:** real publication, denied non-main context and scoped teardown
demonstrated. Resources and repo variables are removed; **another normal main
push still triggers the workflow**. Delivery needs an agreed non-running scope or
a separately approved provisioned test. No standing AWS authorization.

[Checkpoint: runs, evidence and cleanup](../../learning/checkpoint-003-ci-image-publish.md).
**DOP-C02:** partial tasks 1.1, 2.1 and 6.1. Real pull/lifecycle expiry,
cross-repository denial, second-host portability and production deployment untested.
Sources actually consulted: [reference index](../../docs/REFERENCES.md).
