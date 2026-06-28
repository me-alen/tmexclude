#!/usr/bin/env bash

source "${ROOT_DIR}/lib/scanners/node.sh"
source "${ROOT_DIR}/lib/scanners/flutter.sh"
source "${ROOT_DIR}/lib/scanners/angular.sh"
source "${ROOT_DIR}/lib/scanners/react-native.sh"
source "${ROOT_DIR}/lib/scanners/android.sh"

tmx_scanner_all() {
  echo "node flutter angular react_native android"
}

tmx_scanner_detects() {
  local scanner="$1"
  local root="$2"
  case "${scanner}" in
    node) tmx_scanner_node_detect "${root}" ;;
    flutter) tmx_scanner_flutter_detect "${root}" ;;
    angular) tmx_scanner_angular_detect "${root}" ;;
    react_native) tmx_scanner_react_native_detect "${root}" ;;
    android) tmx_scanner_android_detect "${root}" ;;
    *) return 1 ;;
  esac
}

tmx_scanner_candidates() {
  local scanner="$1"
  case "${scanner}" in
    node) tmx_scanner_node_candidates ;;
    flutter) tmx_scanner_flutter_candidates ;;
    angular) tmx_scanner_angular_candidates ;;
    react_native) tmx_scanner_react_native_candidates ;;
    android) tmx_scanner_android_candidates ;;
    *) return 1 ;;
  esac
}

tmx_detect_scanners_for_root() {
  local root="$1"
  local scanner
  for scanner in $(tmx_scanner_all); do
    if tmx_scanner_detects "${scanner}" "${root}"; then
      echo "${scanner}"
    fi
  done
}

tmx_find_project_roots() {
  local configured_root="$1"
  local max_depth="${TMX_BEHAVIOR_MAX_DEPTH:-6}"
  if [[ ! -d "${configured_root}" ]]; then
    return 0
  fi
  find "${configured_root}" -maxdepth "${max_depth}" -type d 2>/dev/null
}
