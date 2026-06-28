#!/usr/bin/env bash

source "${ROOT_DIR}/lib/scanners/generic.sh"
source "${ROOT_DIR}/lib/core/filesystem.sh"

tmx_collect_candidates_for_project() {
  local project_root="$1"
  local scanner
  local scanners
  scanners="$(tmx_detect_scanners_for_root "${project_root}" || true)"

  while IFS= read -r scanner; do
    [[ -z "${scanner}" ]] && continue
    local rel
    while IFS= read -r rel; do
      [[ -z "${rel}" ]] && continue
      local candidate="${project_root}/${rel}"
      if tmx_path_exists "${candidate}" && ! tmx_is_protected_path "${candidate}"; then
        printf "%s\t%s\t%s\n" "${project_root}" "${scanner}" "${candidate}"
      fi
    done <<< "$(tmx_scanner_candidates "${scanner}" || true)"
  done <<< "${scanners}"
}

tmx_collect_candidates_for_configured_roots() {
  local root
  for root in "${TMX_ROOT_PATHS[@]}"; do
    tmx_find_project_roots "${root}" | while IFS= read -r maybe_project; do
      local scanner_hits
      scanner_hits="$(tmx_detect_scanners_for_root "${maybe_project}" || true)"
      [[ -z "${scanner_hits}" ]] && continue
      tmx_collect_candidates_for_project "${maybe_project}"
    done
  done | sort -u
}
