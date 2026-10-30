# Lab 000 — A Safe AWS Workspace

## Problem and scope

Before ParcelFlow provisions anything, detect a wrong identity/account/region and
define approval, cost and cleanup boundaries. This lab is local planning and
verification: **no AWS resource mutations or account-plan changes**.
Authenticated reads require the bounded approval defined in `AGENTS.md`.

## Acceptance criteria

- Distinguish Free plan, credits, usage allowances and spending controls.
- Propose temporary non-root access without copying or printing credentials.
- Design target checks; reject unexpected regions and inspection failures.
- Produce a short English `operating-checklist.md` covering target, cost,
  permissions, approval, evidence and cleanup, without real account data.
- State what was checked locally versus in AWS; a region guard alone does not
  verify identity, account, endpoint or authorization.

## Local artifact

`preflight-region.sh` practices effective-region inspection and failure gating:

```sh
sh -n labs/000-safe-aws-workspace/preflight-region.sh
```

Runtime use requires the lab's expected local profile/region configuration.
Never inspect parent credentials or dump the environment to debug selection.

**Closed partial:** local guard demonstrated; full preflight/checklist incomplete.
See [checkpoint](../../learning/checkpoint-000-safe-aws-workspace.md), not this
brief, for historical evidence and gaps.

**DOP-C02:** conceptual preparation for tasks 2.2, 6.1 and 6.3; no full-task claim.
