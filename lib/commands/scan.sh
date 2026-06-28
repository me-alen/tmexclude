#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/logger.sh"
source "${ROOT_DIR}/lib/core/tmutil.sh"
source "${ROOT_DIR}/lib/core/state.sh"
source "${ROOT_DIR}/lib/core/engine.sh"
source "${ROOT_DIR}/lib/core/plugins.sh"
source "${ROOT_DIR}/lib/utils/progress.sh"

tmx_cmd_scan() {
  local dry_run="${TMX_BEHAVIOR_DRY_RUN}"
  if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run="true"
  fi

  local total=0
  local added=0
  local skipped=0
  local processed=0
  local candidates=()
  local project_root=""
  local scanner=""
  local path=""

  tmx_run_plugin_hook "before_scan" "dry_run=${dry_run}"

  while IFS= read -r line; do
    candidates+=("${line}")
  done < <(tmx_collect_candidates_for_configured_roots)
  local total_candidates="${#candidates[@]}"
  tmx_progress "Starting scan. candidates=${total_candidates} dry_run=${dry_run}"

  local line
  for line in "${candidates[@]}"; do
    IFS=$'\t' read -r project_root scanner path <<< "${line}"
    [[ -z "${path}" ]] && continue
    processed=$((processed + 1))
    total=$((total + 1))
    tmx_progress_update "Scanning ${processed}/${total_candidates}: ${path}"

    if tmx_tm_is_excluded "${path}"; then
      skipped=$((skipped + 1))
      continue
    fi

    if [[ "${dry_run}" == "true" ]]; then
      continue
    fi

    if tmx_tm_add_exclusion "${path}"; then
      tmx_state_add "${project_root}" "${path}" "${scanner}"
      tmx_run_plugin_hook "on_excluded" "path=${path};scanner=${scanner};project_root=${project_root}"
      added=$((added + 1))
    else
      tmx_warn "Failed to exclude: ${path}"
    fi
  done

  tmx_progress_done "Scan processed ${processed}/${total_candidates} candidates."

  tmx_run_plugin_hook "after_scan" "candidates=${total};added=${added};skipped=${skipped};dry_run=${dry_run}"
  tmx_success "Scan complete. candidates=${total} added=${added} already_excluded=${skipped} dry_run=${dry_run}"
}
