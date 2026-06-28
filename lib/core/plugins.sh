#!/usr/bin/env bash

tmx_run_plugin_hook() {
  local hook="$1"
  local payload="${2:-}"
  local dir="${TMX_PLUGIN_DIR}"
  [[ -d "${dir}" ]] || return 0

  local script
  for script in "${dir}"/*.sh; do
    [[ -e "${script}" ]] || continue
    TMX_PLUGIN_HOOK="${hook}" TMX_PLUGIN_PAYLOAD="${payload}" bash "${script}" || true
  done
}
