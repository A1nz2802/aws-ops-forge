# Lab 003 — Verified Image Publication

## Business problem

ParcelFlow needs a traceable container image published only after verification,
without persistent AWS keys in CI. Unauthorized execution contexts must not
assume the publisher role. Publication is not application deployment.

## Ownership and scope

The learner implemented Terraform and workflows with guided examples and performed
AWS mutations. The mentor supplied requested local tooling, auxiliary scaffold,
reviews and evidence checks. Generated scaffold is not independent learner mastery.
Relevant DOP-C02 task statements: 1.1, 2.1 and 6.1; coverage remains scoped/partial.

## Architecture

```text
verify: tests -> build -> HTTP/nonroot checks -> save/upload image
                                                    |
publish: download/load -> compare ID -> GitHub OIDC -> STS role
                                                    |
                             ECR push -> query digest -> Docker logout
```

PRs verify. Manual service runs transfer/load without AWS publication. A push to
main runs the publication steps. The denial workflow dispatches only from the
dedicated test branch. Trust requires the exact immutable GitHub main subject;
names alone are insufficient for repositories using immutable subject claims.

The local ACT/Floci workbench is documented in [tools/ci](../../tools/ci/README.md).
Its tests are not proof of real AWS identity behavior.

## Demonstrated evidence

- Real Terraform create/readback and teardown of five resources: OIDC provider,
  publisher role, inline policy, ECR repository and lifecycle policy.
- Hosted [publication run](https://github.com/A1nz2802/aws-ops-forge/actions/runs/40815767972):
  verify passed; first publish attempt failed on an outdated subject condition.
  A reviewed one-role Terraform repair enabled a successful publish-only retry.
- Hosted [denial run](https://github.com/A1nz2802/aws-ops-forge/actions/runs/40817926160):
  STS explicitly denied AssumeRoleWithWebIdentity from the non-main branch.
- Local automated positive/negative transfer and ECR tests, including verified
  repository/registry-volume cleanup. Other-host/cold-start portability untested.

## Safety and lifecycle

This root fixes profile `forge`, region `us-east-2` and an expected-account guard.
Provide the real account only in ignored local inputs. State/plans are private.
Policy templates require account substitution in ignored local copies, explicit
approval and administrator review. Role-policy provisioning can enable privilege
escalation even when the role name is scoped; it is not a universal security boundary.

Tags are immutable `ci-<full commit SHA>`; collisions fail, not silently skip.
`force_delete=false` requires explicit image cleanup before repository destroy.
Real resources, temporary access, test branch and repo variables were removed at
closure (see checkpoint for evidence strength). Do not run apply or workflows based
on this document alone. The publication workflow remains enabled: another main
push requires infrastructure/variables or an explicit non-running delivery plan.

## Unvalidated concerns

Real pull, cross-repository denial, lifecycle expiry, concurrent publication,
production deployment/rollback and full account billing inventory were not tested.
See [checkpoint](../../learning/checkpoint-003-ci-image-publish.md) for final state.
