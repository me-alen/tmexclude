#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/tmutil.sh"
source "${ROOT_DIR}/lib/core/logger.sh"
source "${ROOT_DIR}/lib/core/state.sh"

tmx_cmd_remove() {
  local path="${1:-}"
  if [[ -z "${path}" ]]; then
    tmx_error "Usage: tmexclude remove <path>"
    return 1
  fi
  path="$(tmx_expand_home "${path}")"

  if tmx_tm_is_excluded "${path}"; then
    if tmx_tm_remove_exclusion "${path}"; then
      tmx_success "Removed exclusion: ${path}"
    else
      tmx_error "Failed to remove exclusion: ${path}"
      return 1
    fi
  else
    tmx_warn "Path is not excluded in tmutil: ${path}"
  fi

  tmx_state_remove "${path}"
  tmx_info "State updated for: ${path}"
}
