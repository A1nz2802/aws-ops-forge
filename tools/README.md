# Shared local tools

This replaces the Lab 002 Terraform-only Compose workflow. It is tooling,
not an application runtime or a deployment pipeline. Keep the editor on the
host; execute Go, AWS CLI and Terraform in this environment.

## Start

From the repository root:

```sh
./forge build
./forge
```

Or run a single command without opening a shell:

```sh
./forge terraform -chdir=labs/002-image-registry fmt
./forge terraform -chdir=labs/002-image-registry validate
./forge bash -c 'cd labs/001-tested-container/app && go test ./...'
```

`forge` only supplies host UID/GID and invokes Compose. It never logs in,
plans, applies, or destroys automatically. For direct Compose operations:

```sh
export LOCAL_UID="$(id -u)" LOCAL_GID="$(id -g)"
docker compose run --rm tools
```

The image includes Go (the pinned image currently contains 1.26.10), AWS
CLI 2.32.7 and Terraform 1.16.5. AWS SDK modules belong in an application's
`go.mod`, not as a global tool. CGO is disabled; native-library builds are
not supported by this minimal environment. Upstream images are digest-pinned;
OS package dependencies are not snapshot-pinned, so builds are not claimed
to be byte-reproducible. Review version updates deliberately.

## Storage and isolation

- The repository is mounted at `/workspace`, writable as your host UID/GID.
- A named volume, `aws-ops-forge_tools-home`, persists the container home:
  login cache, private AWS config, and Go caches. It is outside the Git tree.
- No host home, parent directory, existing AWS credentials, or Docker socket
  is mounted. Do not add those mounts as a shortcut.
- The container root filesystem is read-only; `/tmp` is disposable and
  executable so Go can run its temporary test binaries. It is not a sandbox
  for untrusted code.
- Docker daemon administrators can access the home volume. It is not a
  secret vault, and container isolation is not a complete security boundary.
- The volume is initialized for the UID/GID selected when the image is built.
  Do not share it between host users. A UID/GID change requires rebuilding
  with `./forge build` and explicit volume migration or removal after logout,
  not broad permission changes. Startup rejects mismatched image IDs or an
  unwritable home before initializing profiles.
- The entire repository bind is accessible to tools: do not store unrelated
  secrets anywhere in the project, including Git-ignored directories.
- `run --rm` removes the command container, not the image, volume or network.

## Authentication: only after specific approval

No login or AWS request occurs on startup. The following commands are a
procedure, not standing authorization to run AWS operations.

After confirming account, identity, region, plan/credits, permissions, costs,
cleanup and approval, the learner can use:

```sh
./forge aws login --remote --profile forge-login --region us-east-2
./forge aws sts get-caller-identity --profile forge --region us-east-2
```

Verify the account privately; do not publish identity output, authorization
URLs or codes. `forge-login` is a container-local profile name, not an IAM
user. Select the intended non-root identity in the browser.

The `forge` profile uses `credential_process` to ask the AWS CLI for temporary
credentials from `forge-login`. This bridges the Go SDK v2 login-provider
compatibility gap without manually exporting secrets. The JSON is consumed
by the SDK, not printed for the operator. **Never run the export command by
itself or enable shell tracing/debug logs around credentials.**

Do not point the credential process back to the consumer profile: that would
create recursion. The source login profile and consumer profile are distinct.
The CLI can renew credentials while its login session remains valid; an
expired login requires another explicitly approved browser login.

No credentials are copied from the earlier standalone access container. That
session must be logged out and its container removed separately. Do not
terminate it blindly while another exercise uses it.

Provider/region authentication and a real Terraform plan remain separate
validation steps. Local version checks and `validate` do not prove this
authentication flow works in AWS. Do not execute `plan` or `apply` without
specific approval. Saved state/plans can contain private data; keep them
out of Git and do not publish raw outputs.

## Cleanup: learner-run after approval

After approved AWS teardown and verification, remove the cached source login:

```sh
./forge aws logout --profile forge-login
```

Logout removes local cached login material; already-issued credentials can
remain usable until expiry. Removing the local volume is not server-side
revocation. After ensuring no running tools session needs its contents:

```sh
./forge compose down --volumes
```

This deletes the shared tool home (including Go caches) and Compose network.
It does **not** delete AWS resources, workspace Terraform state, images/build
cache, or containers/networks created by older lab-specific commands. Inspect
those separately; do not use a global Docker prune as lab cleanup.

References: [AWS CLI export-credentials](https://docs.aws.amazon.com/cli/latest/reference/configure/export-credentials.html),
[process credentials](https://docs.aws.amazon.com/sdkref/latest/guide/feature-process-credentials.html),
[login credentials compatibility](https://docs.aws.amazon.com/sdkref/latest/guide/feature-login-credentials.html).
