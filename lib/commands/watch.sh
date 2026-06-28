#!/usr/bin/env bash

source "${ROOT_DIR}/lib/commands/scan.sh"
source "${ROOT_DIR}/lib/core/plugins.sh"

tmx_watch_notify() {
  local message="$1"
  if [[ "${TMX_WATCH_NOTIFY}" == "true" ]] && command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"${message}\" with title \"tmexclude\"" >/dev/null 2>&1 || true
  fi
}

tmx_cmd_watch() {
  local interval="${TMX_WATCH_INTERVAL_SECONDS:-20}"
  tmx_run_plugin_hook "watch_started" "interval=${interval}"
  tmx_watch_notify "watch started"
  echo "Starting watch loop. interval_seconds=${interval}"
  while true; do
    tmx_cmd_scan
    tmx_run_plugin_hook "watch_tick" "interval=${interval}"
    sleep "${interval}"
  done
}
