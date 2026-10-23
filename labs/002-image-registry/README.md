# Lab 002 — A Reproducible Image Registry

## Business problem

The service has a tested container build, but the team needs a reproducible
private registry for future publication, deployment, and rollback. Define
artifact identity, retention, and distinct publishing/pulling permissions
before giving CI access to AWS.

## Constraints

- Zero AWS spend by default; account/profile/region, current plan/credits,
  permissions, expected cost, cleanup and specific approval precede AWS work.
- Real-AWS validation is limited to an empty repository and its lifecycle.
- No image publishing, new IAM roles, compute, replication or advanced scanning.
- Credentials, account identifiers, state, saved plans and private variable
  files must not be published.

## Acceptance and evidence

| Objective | Outcome | Evidence type |
|---|---|---|
| Define the repository reproducibly | Demonstrated within scope | Learner-authored Terraform; local validation; reviewed real plan; learner-reported successful saved-plan apply |
| Configure immutable tags and non-forced deletion | Configuration demonstrated | Source/plan review; repository readback reported correct; overwrite and nonempty-deletion behavior not exercised |
| Configure bounded retention | Configuration demonstrated | AWS readback screenshot of the three stored rules; no image-selection or expiration test |
| Separate publisher and puller permissions | Static design demonstrated | Reviewed IAM policy documents; no attachment or effective-permission tests |
| Remove deployed resources | Demonstrated within scope | Approved saved destroy-plan execution reported successful; subsequent RepositoryNotFoundException screenshot |

## Design and limitations

- One repository, `forge-service-lab002`; deploy by digest in a future lab.
- Release images: latest 10, priority 1. CI images: latest 5, priority 2.
  Matching a higher-priority release selection prevents lower-priority CI
  expiration, but does not prevent expiration under the release rule itself.
- Untagged images: expire after 7 days since push, not since tag removal.
- Count-based retention does not track running deployments or guarantee a
  time-based rollback window. Tags outside these prefixes are not bounded.
- `force_delete = false` governs Terraform deletion; it is not an ECR
  protection against every deletion path or lifecycle expiration.
- IAM data sources generate documents, not policies attached to identities.
  The publisher action set follows the documented AWS example; it has not
  been proven minimal for a selected publishing client.
- Current authentication and region come from the tools environment. There
  is no configuration-level allowed-account guard; manual identity verification
  remains required before approved operations.

## Working environment

Use the shared root Compose environment described in
[`../../tools/README.md`](../../tools/README.md). The obsolete Terraform-only
lab Compose was removed; the root Compose service is the single tools workflow.

```sh
./forge terraform -chdir=labs/002-image-registry fmt -check
./forge terraform -chdir=labs/002-image-registry validate
```

Run these from the repository root. Provider installation with `init` is
needed in a fresh checkout. These local checks do not prove AWS behavior.
No standing authorization for login, plans, deployment or teardown is granted
by this README. Do not reuse a saved creation plan after teardown; generate
and review a new plan for any future approved run.

## Cleanup and retained artifacts

The empty ECR repository and associated lifecycle are absent in the tested
account/region. Removal of the temporary provisioning inline policy, retention
of the original login permission, root logout and source-profile logout were
reported by the learner. Shared-tools containers, home volume and network
were independently found absent locally.

Tool images/build cache and private Terraform state/plans remain local. An
older lab-only Compose network remains; no global Docker or AWS inventory
claim is made. Old standalone access-container absence was checked, but
server-side revocation of its previously issued credentials was not proven.

## DOP-C02 mapping

- **Task 2.1:** scoped practice defining infrastructure using IaC; not full
  reusable, multi-environment infrastructure coverage.
- **Task 6.1:** scoped identity and IAM-policy design practice; effective
  publisher/puller enforcement and organizational federation remain untested.
- Publishing/deployment pipeline integration remains future work; this lab
  does not establish that additional task 1.1 capability.

## References

- [ECR lifecycle evaluation](https://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html)
- [ECR push permissions](https://docs.aws.amazon.com/AmazonECR/latest/userguide/image-push-iam.html)
- [Provider 6.68.0 lifecycle document](https://github.com/hashicorp/terraform-provider-aws/blob/v6.68.0/website/docs/d/ecr_lifecycle_policy_document.html.markdown)
