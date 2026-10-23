#!/bin/sh
set -eu
umask 077

if [ "$(id -u)" != "$(id -u forge)" ] || [ "$(id -g)" != "$(id -g forge)" ]; then
  printf '%s\n' 'Host UID/GID changed: rebuild with ./forge build before running tools.' >&2
  exit 1
fi
if [ ! -w "$HOME" ]; then
  printf '%s\n' 'Tool home is not writable: check volume ownership; do not broaden permissions.' >&2
  exit 1
fi

# Initialize a new tool home, without overwriting an existing login profile.
# No AWS command is executed during startup.
mkdir -p "$HOME/.aws"
if [ ! -e "$HOME/.aws/config" ]; then
  cp /usr/local/share/forge/aws-config "$HOME/.aws/config"
fi

if [ "$#" -eq 0 ]; then
  set -- bash
fi
exec "$@"
