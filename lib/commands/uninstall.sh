#!/usr/bin/env bash

tmx_cmd_uninstall() {
  local remove_all="false"
  if [[ "${1:-}" == "--all" ]]; then
    remove_all="true"
  elif [[ -n "${1:-}" ]]; then
    echo "Usage: tmexclude uninstall [--all]" >&2
    return 1
  fi

  local bin_wrapper="${HOME}/.local/bin/tmexclude"
  local plist="${HOME}/Library/LaunchAgents/com.tmexclude.watcher.plist"
  local domain="gui/$(id -u)"
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude"
  local data_dir="${HOME}/.local/share/tmexclude"

  launchctl bootout "${domain}/com.tmexclude.watcher" >/dev/null 2>&1 || true
  launchctl unload "${plist}" >/dev/null 2>&1 || true
  rm -f "${plist}"
  rm -f "${bin_wrapper}"
  rm -rf "${config_dir}" "${data_dir}"

  if [[ "${remove_all}" == "true" ]]; then
    echo "Removing system package files (sudo may prompt)..."
    sudo /bin/sh -c '
      rm -f /usr/local/bin/tmexclude
      rm -rf /usr/local/lib/tmexclude
      pkgutil --forget com.tmexclude.cli >/dev/null 2>&1 || true
    '
    echo "Complete uninstall finished (user + system files)."
  else
    echo "User-level uninstall finished."
    echo "For complete cleanup (including /usr/local files), run:"
    echo "  tmexclude uninstall --all"
  fi
}
