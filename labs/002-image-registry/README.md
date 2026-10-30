# Lab 002 — A Reproducible Image Registry

## Problem and scope

Prepare a private registry for ParcelFlow's tested container: reproducible
configuration, artifact retention and separate publisher/puller permissions.
The learner owns Terraform. Real validation is limited to an **empty ECR
repository and lifecycle**: no image push, new roles or compute.

## Acceptance criteria and design

| Requirement | Design |
|---|---|
| Stable artifacts | `forge-service-lab002`, immutable tags; use digests for future deployment |
| Deliberate deletion | `force_delete=false`; not protection against every deletion path |
| Bounded retention | Releases latest 10, priority 1; CI latest 5, priority 2; untagged after 7 days, priority 3 |
| Distinct access | Publisher/puller policy documents, scoped to the repository except registry authentication |
| Reproducible lifecycle | Review plan, create/read back, review destroy plan and verify absence |

Lifecycle counts do not track deployed versions or guarantee a rollback window.
Untagged age is measured since push; other tag prefixes remain unbounded.
IAM document data sources generate JSON; they do not attach or enforce policies.

## Working with the root

Use a shell with the declared Terraform version and provider available. The
project provides [a tools container](../../tools/README.md); from repository root:

```sh
terraform -chdir=labs/002-image-registry fmt -check
terraform -chdir=labs/002-image-registry validate
```

A fresh checkout requires provider installation. Commit `.terraform.lock.hcl`,
not `.terraform/`, state/plans or private tfvars. This root inherits AWS context
from the environment; verify identity/account/region before any approved AWS work.
Local validation is not AWS validation; the README is not execution approval.

**Outcome:** scoped create/readback/teardown demonstrated; IAM separation and
lifecycle enforcement were not exercised with images in this lab.
[Checkpoint and retained-state details](../../learning/checkpoint-002-image-registry.md).
**DOP-C02:** partial tasks 2.1 and 6.1.

## References

- [Lifecycle evaluation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html)
- [Push permissions](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-push-iam.html)
- [Terraform dependency lockfile](https://developer.hashicorp.com/terraform/language/files/dependency-lock)
