# Lab 001 — A Tested Container Before AWS Access

## Problem and ownership

ParcelFlow needs changes verified before its pipeline receives cloud access.
The mentor supplies Go/tests/Docker packaging; the learner designs and diagnoses
CI. No AWS calls, credentials, registry publishing or deployment in this lab.
Hosted CI requires a separately approved scope and cost check.

## Acceptance criteria

1. Tests pass; an intentional failure blocks build; restoring it restores success.
2. A built container returns HTTP 200 and `ok\n` at `/healthz`.
3. Runtime process UID is nonzero; image metadata alone is insufficient.
4. Inspect source/build context/workflow for exposure without claiming an
   exhaustive secret scan. Remove the test container; identify retained caches.

## Local entry points

From the repository root, in an environment with Go and host Docker available:

```sh
go -C labs/001-tested-container/app test -count=1 ./...
docker build -t aws-ops-forge:lab001 labs/001-tested-container
```

The image uses pinned Go/Distroless bases and UID/GID 65532. Tests are a separate
gate: build success does not prove they ran. Bind local test ports to loopback.
The health endpoint checks only this HTTP process, not future dependencies.

The service workflow now lives at
[service-ci.yml](../../.github/workflows/service-ci.yml) and evolved in Lab 003;
its current push-to-main path **can publish to AWS**. Do not run it under the
original no-AWS scope without reviewing its present configuration.

**Outcome:** scoped local/hosted verification demonstrated. Details and limits:
[checkpoint](../../learning/checkpoint-001-tested-container.md).
**DOP-C02:** partial task 1.1; not deployment, rollback or production readiness.
