#!/usr/bin/env bash
set -euo pipefail

if command -v tmexclude >/dev/null 2>&1; then
  tmexclude uninstall
else
  TARGET="${HOME}/.local/bin/tmexclude"
  PLIST="${HOME}/Library/LaunchAgents/com.tmexclude.watcher.plist"
  GUI_DOMAIN="gui/$(id -u)"

  if [[ -f "${PLIST}" ]]; then
    launchctl bootout "${GUI_DOMAIN}/com.tmexclude.watcher" >/dev/null 2>&1 || true
    launchctl unload "${PLIST}" >/dev/null 2>&1 || true
    rm -f "${PLIST}"
  fi

  rm -f "${TARGET}"
  rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude" "${HOME}/.local/share/tmexclude"
  echo "User-level uninstall complete."
fi
