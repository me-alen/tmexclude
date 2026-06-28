#!/usr/bin/env bash

source "${ROOT_DIR}/lib/core/colors.sh"

tmx_now() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}

tmx_data_dir() {
  echo "${XDG_DATA_HOME:-$HOME/.local/share}/tmexclude"
}

tmx_log_dir() {
  echo "$(tmx_data_dir)/logs"
}

tmx_log_file() {
  echo "$(tmx_log_dir)/tmexclude.log"
}

tmx_ensure_log_dir() {
  mkdir -p "$(tmx_log_dir)"
}

tmx_log_line() {
  local level="$1"
  local message="$2"
  tmx_ensure_log_dir
  printf "%s [%s] %s\n" "$(tmx_now)" "${level}" "${message}" >> "$(tmx_log_file)"
}

tmx_info() {
  local message="$*"
  printf "%s%s%s\n" "${TMX_COLOR_BLUE}" "${message}" "${TMX_COLOR_RESET}"
  tmx_log_line "INFO" "${message}"
}

tmx_warn() {
  local message="$*"
  printf "%s%s%s\n" "${TMX_COLOR_YELLOW}" "${message}" "${TMX_COLOR_RESET}" >&2
  tmx_log_line "WARN" "${message}"
}

tmx_error() {
  local message="$*"
  printf "%s%s%s\n" "${TMX_COLOR_RED}" "${message}" "${TMX_COLOR_RESET}" >&2
  tmx_log_line "ERROR" "${message}"
}

tmx_success() {
  local message="$*"
  printf "%s%s%s\n" "${TMX_COLOR_GREEN}" "${message}" "${TMX_COLOR_RESET}"
  tmx_log_line "OK" "${message}"
}
