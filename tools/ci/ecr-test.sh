#!/usr/bin/env bash
set -euo pipefail

# Deliberately local-only. Never accept a real AWS endpoint or credentials here.
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_SESSION_TOKEN=
export AWS_EC2_METADATA_DISABLED=true AWS_CONFIG_FILE=/dev/null
export AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_PAGER='' AWS_MAX_ATTEMPTS=1

repository=forge-lab003-local
registry=localhost:4566
image_ref="$registry/000000000000/us-east-1/$repository:ci-ecr-test"
source_image=aws-ops-forge:lab001
registry_container=floci-aws-forge-ci-ecr-registry
registry_volume=floci-aws-ecr-registry-data

ecr() {
  aws --endpoint-url http://floci:4566 --region us-east-1 \
    --cli-connect-timeout 5 --cli-read-timeout 120 ecr "$@"
}

assert_no_registry_resources() {
  local containers volumes
  containers="$(docker ps -aq --filter "name=^/$registry_container$")"
  volumes="$(docker volume ls -q --filter "name=^$registry_volume$")"
  if [[ -n $containers || -n $volumes ]]; then
    printf 'Registry container or shared volume exists; stop and inspect, do not blindly delete.\n' >&2
    return 1
  fi
}

# Fail before claiming ownership of anything. Do not overlap local ECR tests.
assert_no_registry_resources
docker image inspect "$source_image" >/dev/null
if docker image inspect "$image_ref" >/dev/null 2>&1; then
  printf 'Local test reference already exists: %s\n' "$image_ref" >&2
  exit 1
fi

temp_dir="$(mktemp -d)"
export DOCKER_CONFIG="$temp_dir/docker"
mkdir -p "$DOCKER_CONFIG"
repo_owned=false
image_owned=false

assert_repository_absent() {
  if ecr describe-repositories --repository-names "$repository" \
    >"$temp_dir/readback.out" 2>"$temp_dir/readback.err"; then
    printf 'Repository already exists: %s\n' "$repository" >&2
    return 1
  fi
  if [[ $(<"$temp_dir/readback.err") != *RepositoryNotFoundException* ]]; then
    cat "$temp_dir/readback.err" >&2
    return 1
  fi
}

cleanup() {
  local result=$?
  trap - EXIT
  set +e
  if [[ $repo_owned == true ]]; then
    printf '\nCleaning up this test repository (including untagged manifests)...\n'
    if ! ecr delete-repository --repository-name "$repository" --force >/dev/null; then
      result=1
    fi
    if ! assert_repository_absent; then result=1; fi
    # Floci removed these automatically in the manually validated lifecycle.
    # Report leftovers instead of deleting a potentially shared volume blindly.
    if ! assert_no_registry_resources; then result=1; fi
  fi
  docker logout "$registry" >/dev/null 2>&1
  if [[ $image_owned == true ]]; then
    if ! docker image rm "$image_ref"; then result=1; fi
  fi
  rm -rf -- "$temp_dir"
  if (( result == 0 )); then
    printf 'PASS: local ECR behavior and scoped cleanup verified. Not AWS IAM/OIDC evidence.\n'
  else
    printf 'FAIL: test or cleanup failed; inspect named resources before retrying.\n' >&2
  fi
  exit "$result"
}
trap cleanup EXIT

assert_repository_absent
uri="$(ecr create-repository --repository-name "$repository" \
  --image-tag-mutability IMMUTABLE --query repository.repositoryUri --output text)"
repo_owned=true
test "$uri" = "$registry/000000000000/us-east-1/$repository"

ecr get-login-password | docker login --username AWS --password-stdin "$registry"
docker tag "$source_image" "$image_ref"
image_owned=true
docker push "$image_ref" >"$temp_dir/push.out" 2>&1
cat "$temp_dir/push.out"
push_output="$(<"$temp_dir/push.out")"
if [[ ! $push_output =~ digest:\ (sha256:[a-f0-9]{64}) ]]; then
  printf 'Could not identify the digest returned by Docker push.\n' >&2
  exit 1
fi
push_digest=${BASH_REMATCH[1]}
original_digest="$(ecr batch-get-image --repository-name "$repository" \
  --image-ids imageTag=ci-ecr-test --query 'images[0].imageId.imageDigest' --output text)"
test "$original_digest" = "$push_digest"
printf 'Initial push and API digest agree: %s\n' "$original_digest"

source_id="$(docker image inspect "$source_image" --format '{{.Id}}')"
printf '%s\n' "FROM $source_image" 'LABEL forge.test="immutable-tag-collision"' \
  | docker build --tag "$image_ref" -
variant_id="$(docker image inspect "$image_ref" --format '{{.Id}}')"
test "$variant_id" != "$source_id"

if docker push "$image_ref" >"$temp_dir/collision.out" 2>&1; then
  printf 'Unexpected success replacing an immutable tag.\n' >&2
  exit 1
fi
cat "$temp_dir/collision.out"
if [[ $(<"$temp_dir/collision.out") != *"tag is immutable"* ]]; then
  printf 'Push failed for a reason other than the expected Floci immutability rejection.\n' >&2
  exit 1
fi
current_digest="$(ecr batch-get-image --repository-name "$repository" \
  --image-ids imageTag=ci-ecr-test --query 'images[0].imageId.imageDigest' --output text)"
test "$current_digest" = "$original_digest"
printf 'Immutable tag preserved the original digest: %s\n' "$current_digest"
