#!/usr/bin/env bash
set -euo pipefail

# An ephemeral HOME avoids importing host ACT config, tokens or login caches.
export HOME=/tmp/forge-ci-home
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME"

# The controller has one bridge interface. Listen on its own IP, not on a host
# gateway or a published port. ACT advertises this address to sibling runners.
read -r -a addresses <<< "$(hostname -i)"
if (( ${#addresses[@]} != 1 )) || \
  [[ ! ${addresses[0]} =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  printf 'Expected one controller IPv4 address; refusing ambiguous networking.\n' >&2
  exit 1
fi
printf 'ACT controller: %s; artifact port stays inside the CI network.\n' "${addresses[0]}"
exec act "$@" --artifact-server-addr "${addresses[0]}"
