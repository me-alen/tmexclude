#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/state.sh"
source "${ROOT_DIR}/lib/core/filesystem.sh"

tmx_cmd_stats() {
  tmx_ensure_state
  local total=0
  echo "Excluded path size estimate:"
  while IFS=$'\t' read -r _ts _project path scanner; do
    [[ "${path}" == "path" ]] && continue
    local bytes
    bytes="$(tmx_dir_size_bytes "${path}")"
    total=$((total + bytes))
    printf "  - [%s] %s (%s)\n" "${scanner}" "${path}" "$(tmx_human_bytes "${bytes}")"
  done < "$(tmx_state_file)"
  echo ""
  echo "Total estimate: $(tmx_human_bytes "${total}")"
}
