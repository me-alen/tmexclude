#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/logger.sh"
source "${ROOT_DIR}/lib/core/tmutil.sh"
source "${ROOT_DIR}/lib/core/state.sh"
source "${ROOT_DIR}/lib/core/engine.sh"
source "${ROOT_DIR}/lib/core/plugins.sh"

tmx_cmd_scan() {
  local dry_run="${TMX_BEHAVIOR_DRY_RUN}"
  if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run="true"
  fi

  local total=0
  local added=0
  local skipped=0

  tmx_run_plugin_hook "before_scan" "dry_run=${dry_run}"

  while IFS=$'\t' read -r project_root scanner path; do
    [[ -z "${path}" ]] && continue
    total=$((total + 1))
    if tmx_tm_is_excluded "${path}"; then
      skipped=$((skipped + 1))
      continue
    fi

    if [[ "${dry_run}" == "true" ]]; then
      tmx_info "DRY-RUN add exclusion: ${path} (${scanner})"
      continue
    fi

    if tmx_tm_add_exclusion "${path}"; then
      tmx_state_add "${project_root}" "${path}" "${scanner}"
      tmx_run_plugin_hook "on_excluded" "path=${path};scanner=${scanner};project_root=${project_root}"
      added=$((added + 1))
      tmx_info "Excluded: ${path} (${scanner})"
    else
      tmx_warn "Failed to exclude: ${path}"
    fi
  done < <(tmx_collect_candidates_for_configured_roots)

  tmx_run_plugin_hook "after_scan" "candidates=${total};added=${added};skipped=${skipped};dry_run=${dry_run}"
  tmx_success "Scan complete. candidates=${total} added=${added} already_excluded=${skipped} dry_run=${dry_run}"
}
