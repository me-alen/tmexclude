#!/usr/bin/env bash

tmx_cmd_config() {
  if [[ "${1:-}" == "--path" || "${1:-}" == "" ]]; then
    echo "$(tmx_config_path)"
    return 0
  fi

  local editor="${EDITOR:-vi}"
  "${editor}" "$(tmx_config_path)"
}
