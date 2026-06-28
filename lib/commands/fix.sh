#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/state.sh"
source "${ROOT_DIR}/lib/core/tmutil.sh"

tmx_cmd_fix() {
  tmx_ensure_state
  local fixed=0

  while IFS=$'\t' read -r _ts _project path _scanner; do
    [[ "${path}" == "path" ]] && continue
    if [[ ! -e "${path}" ]]; then
      tmx_state_remove "${path}"
      echo "FIX stale_state_removed: ${path}"
      fixed=$((fixed + 1))
      continue
    fi
    if ! tmx_tm_is_excluded "${path}"; then
      if tmx_tm_add_exclusion "${path}"; then
        echo "FIX re_excluded: ${path}"
        fixed=$((fixed + 1))
      fi
    fi
  done < "$(tmx_state_file)"

  echo "Fix complete: ${fixed} change(s)."
}
