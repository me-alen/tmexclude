#!/usr/bin/env bash
set -euo pipefail

TARGET="${HOME}/.local/bin/tmexclude"
PLIST="${HOME}/Library/LaunchAgents/com.tmexclude.watcher.plist"

if [[ -f "${PLIST}" ]]; then
  launchctl unload "${PLIST}" >/dev/null 2>&1 || true
  rm -f "${PLIST}"
fi

rm -f "${TARGET}"
echo "Removed tmexclude and LaunchAgent."
