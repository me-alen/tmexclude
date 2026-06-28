#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/tmutil.sh"
source "${ROOT_DIR}/lib/core/logger.sh"

tmx_cmd_check() {
  local path="${1:-}"
  if [[ -z "${path}" ]]; then
    tmx_error "Usage: tmexclude check <path>"
    return 1
  fi
  path="$(tmx_expand_home "${path}")"

  if tmx_tm_is_excluded "${path}"; then
    tmx_success "Excluded: ${path}"
  else
    tmx_warn "Not excluded: ${path}"
    return 1
  fi
}
