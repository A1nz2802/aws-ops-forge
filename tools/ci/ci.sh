#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'HELP'
Usage: bash tools/ci/ci.sh [--dry-run] COMMAND

  build            Build the local ACT runner with AWS CLI (may download images).
  up               Start Floci and create the CI network (no controller yet).
  down             Remove this project's Compose containers/network; lose RAM state.
  test smoke       Minimal runner test: no socket in job; controller uses DooD.
  test floci       Local emulated STS connectivity; fake credentials, no job socket.
  test ecr         Local push/digest/immutability/cleanup; requires service image.
  test verify      Service checks and artifact upload; dedicated CI network + DooD.
  test transfer    Manual workflow: verify, download/load and compare; no AWS step.
  help             Show this help. Also the default when no arguments are given.

--dry-run prints commands without running them or creating directories.
Tests do not automatically build images or start Floci.
No automatic login, AWS operations, installation or global Docker cleanup.
Local artifacts, images and caches are retained by down.
Read tools/ci/README.md before running trusted-code-only DooD tests.
HELP
}

dry_run=false
if [[ ${1:-} == --dry-run ]]; then
  dry_run=true
  shift
fi

command_name=${1:-help}
case "$command_name" in
  help|-h|--help)
    if (( $# > 1 )); then
      usage >&2
      exit 2
    fi
    usage
    exit 0
    ;;
  build|up|down)
    if (( $# != 1 )); then
      usage >&2
      exit 2
    fi
    ;;
  test)
    if (( $# != 2 )) || [[ ! ${2:-} =~ ^(smoke|floci|ecr|verify|transfer)$ ]]; then
      usage >&2
      exit 2
    fi
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

# Resolve from this script, not the caller's current directory or Git checkout.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/../.." && pwd)"
cd "$repo_root"

run() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
  if [[ $dry_run == false ]]; then
    "$@"
  fi
}

case "$command_name" in
  build)
    run docker build --file tools/ci/Dockerfile.runner \
      --tag aws-ops-forge/act-runner:local tools/ci
    ;;
  up)
    run docker compose -f tools/ci/compose.yml up -d --wait --wait-timeout 60 floci
    ;;
  down)
    printf 'Warning: Floci in-memory state will be lost. Images and artifacts remain.\n'
    run docker compose -f tools/ci/compose.yml down
    ;;
  test)
    test_name=$2
    runner_image='aws-ops-forge/act-runner:local'
    ci_network='forge-ci-local'
    if [[ $dry_run == false ]]; then
      docker image inspect "$runner_image" >/dev/null
      project="$(docker network inspect "$ci_network" \
        --format '{{index .Labels "com.docker.compose.project"}}')"
      if [[ $project != forge-floci ]]; then
        printf 'Refusing unexpected network owner: %s\n' "$project" >&2
        exit 1
      fi
    fi
    common_args=(
      --no-cache-server
      --secret-file /dev/null
      --secret GITHUB_TOKEN=
      --env-file /dev/null
      --var-file /dev/null
      --input-file /dev/null
      --rm
    )

    if [[ $test_name == smoke ]]; then
      test_args=(
        --workflows tools/ci/smoke.yml
        --job smoke
        --platform ubuntu-24.04=ubuntu:24.04
        --container-daemon-socket -
        --network bridge
      )
    elif [[ $test_name == floci || $test_name == ecr ]]; then
      test_args=(
        --workflows "tools/ci/$test_name.yml"
        --job "$test_name"
        --platform "ubuntu-24.04=$runner_image"
        --network "$ci_network"
        --pull=false
      )
      if [[ $test_name == ecr ]]; then
        test_args+=(--container-daemon-socket /var/run/docker.sock)
      else
        test_args+=(--container-daemon-socket -)
      fi
    else
      if [[ $dry_run == false ]]; then
        existing="$(docker ps -aq --filter 'name=^/forge-lab001$')"
        if [[ -n $existing ]]; then
          printf 'Container forge-lab001 already exists; inspect it before retrying.\n' >&2
          exit 1
        fi
      fi
      artifact_dir="$repo_root/local/act/artifacts"
      test_args=(
        --workflows .github/workflows/service-ci.yml
        --platform "ubuntu-24.04=$runner_image"
        --container-daemon-socket /var/run/docker.sock
        --network "$ci_network"
        --env "CI_DOCKER_NETWORK=$ci_network"
        --env SERVICE_HEALTH_URL=http://forge-lab001:8080/healthz
        --artifact-server-path /workspace/local/act/artifacts
        --artifact-server-port 34567
        --pull=false
      )
      if [[ $test_name == verify ]]; then
        test_args+=(--job verify)
      fi
      run mkdir -p "$artifact_dir"
    fi

    run docker compose -f tools/ci/compose.yml run --rm --no-deps \
      controller workflow_dispatch "${test_args[@]}" "${common_args[@]}"
    ;;
esac
