#!/bin/sh

expected_region="eu-west-1"

if ! config_output=$(aws configure list --profile lab000); then
  printf '%s\n' "Unable to read the lab000 configuration" >&2
  exit 1
fi

actual_region=$(printf '%s\n' "$config_output" | awk '$1 == "region" { print $3 }')

if test "$actual_region" != "$expected_region"; then
  exit 1
fi

exit 0
