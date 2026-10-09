# Lab 001: A Tested Container Before AWS Access

## Business problem

The ParcelFlow team needs every change to produce a tested, repeatably built
application artifact before granting its delivery pipeline access to AWS.

## Scope and constraints

- One Go HTTP health endpoint, automated tests, a Docker image, and a CI workflow.
- The mentor supplies the Go application, tests, and Docker packaging; the
  learner focuses on CI decisions, operational checks, and resulting evidence.
- Use the standard library. No AWS calls, credentials, deployment, registry
  publishing, or additional harness tooling.
- Do not publish the repository or trigger hosted CI without explicit approval.
  Check hosted-runner availability and possible costs before using it.
- Bind any local Docker-published port to loopback.
- Keep build inputs explicit. A repeatable build procedure is not a claim of
  byte-for-byte reproducibility; mutable image tags must be identified as a gap
  unless pinned by digest.

## Acceptance criteria

1. Automated tests pass for the supplied endpoint.
2. An intentionally failing test makes CI fail and prevents the image build;
   restore the test and demonstrate the successful path.
3. The image builds and a running container returns HTTP 200 with `ok\n` from
   `GET /healthz`.
4. Runtime evidence shows the application process uses a nonzero UID. Image
   metadata alone is not sufficient evidence.
5. Review the source, build context, image configuration/history, and workflow
   for secret exposure. No AWS credentials or credential mounts are needed.
   Record inspection scope; do not claim an exhaustive secret-free proof.
6. Stop and remove the lab container. Record any intentionally retained image
   and build cache.

## Supplied application

`app/` contains a standard-library HTTP service listening on port 8080 and tests
using `httptest`. The endpoint proves only that the HTTP process responds. It
does not check dependencies or establish readiness for future business traffic.

Run from `app/`:

```sh
go test ./...
```

The mentor-supplied `Dockerfile` uses a Go build stage and a Distroless
`static-debian12:nonroot` runtime stage. Both bases are pinned by registry index
digest. Only the binary reaches the final image, which explicitly selects UID
and GID 65532. `.dockerignore` allows only the current Go source and module file.
Adding source files or dependencies requires updating these inputs deliberately.

Build from the repository root:

```sh
docker build -t aws-ops-forge:lab001 labs/001-tested-container
```

Tests remain a separate CI gate: a successful image build alone does not prove
that tests passed. The learner reported a successful local build and demonstrated
HTTP 200 with the expected body, runtime UID/GID 65532, and named-container
removal. Hosted CI execution and failure gating remain unvalidated.

## Evidence and exam mapping

- DOP-C02 task 1.1: Implement CI/CD pipelines. This lab practices a limited
  test-and-build slice, not deployment or full task coverage.
- Mentor-authored code and mentor-run tests are supporting artifacts, not
  evidence of learner mastery.
- Local tests and Docker results are distinct from hosted CI evidence and do
  not demonstrate AWS service behavior.
- Unvalidated concerns include AWS integration, artifact publishing/promotion,
  deployment rollback, dependency readiness, graceful shutdown, image
  vulnerability management, and exact byte reproducibility.
