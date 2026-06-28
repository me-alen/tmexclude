#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/state.sh"
source "${ROOT_DIR}/lib/core/tmutil.sh"

tmx_cmd_doctor() {
  local issues=0
  tmx_ensure_state

  if [[ ! -f "$(tmx_config_path)" ]]; then
    echo "WARN config_missing: $(tmx_config_path)"
    issues=$((issues + 1))
  fi

  while IFS=$'\t' read -r _ts project path scanner; do
    [[ "${path}" == "path" ]] && continue
    if [[ ! -e "${path}" ]]; then
      echo "WARN stale_state_path: ${path}"
      issues=$((issues + 1))
      continue
    fi
    if ! tmx_tm_is_excluded "${path}"; then
      echo "WARN drift_not_excluded: ${path} (${scanner} @ ${project})"
      issues=$((issues + 1))
    fi
  done < "$(tmx_state_file)"

  if [[ "${issues}" -eq 0 ]]; then
    echo "Doctor OK: no issues detected."
    return 0
  fi

  echo "Doctor found ${issues} issue(s)."
  return 2
}
