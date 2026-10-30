# Local CI workbench

Portable local CI tooling under development, targeting Linux amd64 and one
trusted-code user. ACT runs in an ephemeral Compose controller container; the
host daemon runs that controller and its sibling job containers.
This is not a sandbox for external pull requests or a replica of hosted GitHub.

[Architecture overview](../../.images/03.png) and [project overview](../../README.md).
The image shows topology when running, not continuously running infrastructure.
Artifacts live inside the controller; Floci's ECR integration uses a registry
auxiliary container, as described below.

## Explicit entry point

```sh
bash tools/ci/ci.sh
bash tools/ci/ci.sh --dry-run test transfer
bash tools/ci/ci.sh build
bash tools/ci/ci.sh up
bash tools/ci/ci.sh test smoke
bash tools/ci/ci.sh test floci
bash tools/ci/ci.sh test ecr
bash tools/ci/ci.sh test verify
bash tools/ci/ci.sh test transfer
bash tools/ci/ci.sh down
```

These are independent actions, not a mandatory sequence. No arguments displays
help. Dry-run only prints commands; it does not create directories or invoke
Docker/ACT. Every execution prints its command and propagates failures. Unknown
commands or extra arguments fail with exit code 2. No arbitrary ACT flags or
secret values are accepted through this interface.

The script locates the repository relative to itself. Invoke it by its absolute
path when outside the repository. It does not install prerequisites or log in.

## Reproduce the local test cycle

Prerequisites: a Linux amd64 host, accessible local Docker Engine/Compose, Bash,
available disk space and outbound access for downloads. Host ACT, Go, Terraform
and AWS CLI are not required for these test commands. ShellCheck/actionlint are
separate prerequisites only for the optional static checks below.

From the repository root, with no concurrent tests or conflicting resources:

```sh
bash tools/ci/ci.sh build
bash tools/ci/ci.sh up
bash tools/ci/ci.sh test smoke
bash tools/ci/ci.sh test floci
bash tools/ci/ci.sh test transfer
bash tools/ci/ci.sh test ecr
bash tools/ci/ci.sh down
```

`transfer` includes verification and creates the local service image required by
`test ecr`. A missing prerequisite fails instead of being installed implicitly.
Stop on test failure and inspect state before rerunning; do not place the entire
sequence in a shell trap that hides cleanup errors. `down` is an explicit action.
This cycle was exercised on the original host in component/lifecycle blocks;
the exact fresh-clone sequence on another machine has not been demonstrated.

### Files and responsibilities

| File | Responsibility |
|---|---|
| `Dockerfile.runner` | Pinned tools image, including ACT and AWS CLI |
| `compose.yml` | Floci, opt-in controller, socket mounts and CI network |
| `ci.sh` | Host entry point; explicit commands and preflight checks |
| `controller.sh` | Ephemeral ACT config/cache and internal artifact address |
| `smoke.yml`, `floci.yml`, `ecr.yml` | Local-only auxiliary workflows |
| `ecr-test.sh` | Emulated publication/immutability assertions and scoped cleanup |
| `.github/workflows/service-ci.yml` | Service pipeline, also executable by real GitHub |

The first tools build compiles ACT and can take several minutes. Docker may reuse
that layer on later builds; controller action downloads remain ephemeral. Digest
pins improve input control, not byte-for-byte reproducibility or CVE guarantees.

## Current implementation versus target

| Component | Current behavior |
|---|---|
| `Dockerfile.runner` | Digest-pinned ACT base plus AWS CLI copied from a pinned official image; build checks `aws --version` |
| `compose.yml` | Floci and opt-in controller have Docker socket mounts; shared `forge-ci-local` network |
| `controller.sh` | Ephemeral HOME, discovers controller IPv4; internal artifact listener, no host port |
| `test smoke` | Minimal Ubuntu job runner without socket; controller still requires DooD |
| `test floci` | Custom runner without job socket; explicit `http://floci:4566`, fake credentials, assert emulated account response |
| `test ecr` | Local-only registry integration with job socket; requires `aws-ops-forge:lab001` from verify/transfer; refuses preexisting test resources |
| `test verify` | Custom local runner, dedicated CI bridge network, host Docker socket, local artifact upload |
| `test transfer` | Same configuration, both jobs via `workflow_dispatch`; AWS authentication step is skipped by the workflow condition |
| `./forge` | Separate interactive tools environment; not changed or invoked by this wrapper |

**Local runtime validated:** build creates the image
`aws-ops-forge/act-runner:local` used by service tests. Run build and up explicitly
before testing. The wrapper checks image presence, Compose network ownership and
the absence of a conflicting service container; it does not verify image freshness.
The smoke image still uses an exploratory tag. Reproduction on another clean host is unvalidated.
The pipeline remains in `.github/workflows/service-ci.yml`; do not duplicate it.

`up` waits up to 60 seconds for Compose health checks. A timeout does not prove
the container was removed: inspect logs/state before cleanup or retrying.
`test floci` neither creates ECR resources nor proves IAM/OIDC enforcement.
Its workflow stays outside `.github/workflows/` and is not auto-run by GitHub.

## Dedicated-network connections

```text
ACT runner -- Docker socket --> host daemon -- creates --> service container
ACT runner -- HTTP --> forge-lab001:8080 (no host port published locally)
ACT runner -- HTTP --> controller container IP:34567 (ACT artifact server)
ACT runner -- AWS-compatible API --> floci:4566 (separately tested with fake credentials)
```

ACT and its artifact server now share the controller container. Its entrypoint
discovers its own IPv4 and passes it to ACT for listening and advertising.
No artifact port is published on the host. The former host listener was blocked
by UFW; a scoped diagnostic exception made verify pass and was then removed.
The new container route passed artifact upload/download without that exception.
Do not disable host firewalls. This is not multi-tenant artifact storage.

The controller mounts the project at `/workspace`, not the host HOME. ACT copies
source into job runners (no `--bind`); Docker build contexts travel via the API.
Future job bind mounts need care: daemon paths resolve on the host, not inside
the controller. Its HOME/action cache is ephemeral, so downloads may repeat.

Only local ACT invocations supply `CI_DOCKER_NETWORK` and `SERVICE_HEALTH_URL`.
Without these variables, the hosted workflow retains its loopback port mapping
and health URL. Changing the network does not restrict host control through DooD.

Observed host tooling: Docker 29.7.2, Compose 5.5.1. ACT 0.2.89 is built into the
controller image; host ACT is no longer used by the wrapper. Bash, ShellCheck
and actionlint are host prerequisites for the corresponding checks. Builds and
tests may download images, actions, Go and dependencies; they are not offline.

## Before running service tests

Do not overlap runs: the service name, image tag, artifact path and ports are
currently shared. Check that the named container and ports are unused:

```sh
docker ps -a --filter 'name=^/forge-lab001$' --format 'table {{.Names}}\t{{.Status}}'
```

Stop on conflicts; never remove an unrelated container. The workflow cleanup
targets `forge-lab001`. Before starting Floci, check port 4566. The shared Docker
socket still gives broad host control despite the dedicated network.
Only run reviewed code; never add real secrets or host credential mounts.

An ephemeral HOME avoids importing host ACT settings. A project `.actrc` can
still supply extra mounts/secrets: review it and never print secrets into logs.
The whole project is mounted; keep unrelated secrets out of ignored files too.

Artifacts remain under Git-ignored `local/act/artifacts/`. The wrapper does not
rename or delete existing data. `down` affects the `forge-floci` Compose project,
not all ACT resources, cached images or artifacts. It loses Floci RAM state and
can remove the dedicated network only when no other endpoints still use it.
Do not run a global Docker prune. Verify cleanup from container/port evidence.

## Direct commands and checks

```sh
docker build -f tools/ci/Dockerfile.runner -t aws-ops-forge/act-runner:local tools/ci
docker compose -f tools/ci/compose.yml config --quiet
docker compose -f tools/ci/compose.yml ps
docker compose -f tools/ci/compose.yml logs --tail=60 floci
bash -n tools/ci/ci.sh
bash -n tools/ci/controller.sh
shellcheck tools/ci/ci.sh tools/ci/controller.sh
shellcheck tools/ci/ecr-test.sh
actionlint tools/ci/smoke.yml tools/ci/floci.yml tools/ci/ecr.yml .github/workflows/service-ci.yml
```

Use `--dry-run test <name>` to see the exact direct ACT invocation. Local success
does not prove hosted checkout, independent Docker daemons, AWS IAM/OIDC or ECR
behavior. Real platform validation requires a separate bounded phase.

## Lifecycle acceptance evidence

The learner reported successful `down`, resource-absence checks, `up`, and
`test smoke`, `test floci`, `test transfer` in sequence on the original Linux
amd64 host. The transfer screenshot shows matching image IDs and successful jobs;
the Floci test screenshot shows AWS CLI 2.32.7 and the local response assertion.
Intermediate read-only inspection found no controller, job runners or test service,
no host artifact listener, and only healthy Floci attached to the CI network.
At lab closure, Floci was stopped and the CI network/registry volume were absent.
The workbench definition is retained; there is no continuously running local CI.

This recreates containers and networking while reusing local images/caches. It
does not demonstrate a cold install or a second host; cross-architecture support
is unvalidated. ECR integration evidence is recorded separately below.
Run `down` when the emulator is no longer needed; inspect
resource absence rather than inferring cleanup solely from command success.

### Validated local ECR extension

The learner approved local ECR integration: socket access for Floci, dedicated
`forge-ci-ecr-registry` auxiliary container, emulated `forge-lab003-local`
repository, fake credentials, and scoped cleanup. No AWS calls, host firewall
changes or global Docker trust changes are included. Stop on unexpected resources.
The registry image is pinned by digest; URI style is `path` and
`FLOCI_SERVICES_ECR_KEEP_RUNNING_ON_SHUTDOWN=false`.
Manual evidence demonstrated creation, push, matching Docker/API digests, rejection
of a changed image under the immutable tag, preserved remote digest, and automatic
registry/container volume removal after repository deletion. A subsequent API
read confirmed RepositoryNotFoundException and the local fixture tag was removed.

`test ecr` automates that contract using `ecr.yml` and `ecr-test.sh`; the learner's
first execution passed, including the expected rejection and cleanup assertions.
Subsequent mentor inspection found no auxiliary registry, registry volume,
controller, queried ECR job runner or reserved local test tag. It captures the digest dynamically and requires the exact
expected immutability error, not just a nonzero push exit. A trap deletes only
the repository and local tag claimed by this test, checks API absence, and checks
auxiliary registry/volume absence. Cleanup errors fail the test. Preexisting
registry, volume, repository or local test tag abort the run without deletion.
Do not overlap runs or stop Floci during a test. Forced termination can bypass
traps; ambiguous create failures may leave resources needing manual inspection.
Source images/build cache remain. This test is separate from production workflow
steps and does not by itself prove those inline scripts or real AWS behavior.
The registry is created by Floci, not declared as a Compose service; `down` alone
is not sufficient cleanup evidence. Inspect its actual mounts and lifecycle.
