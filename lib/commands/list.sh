#!/usr/bin/env bash

source "${ROOT_DIR}/lib/scanners/generic.sh"
source "${ROOT_DIR}/lib/utils/output.sh"

tmx_cmd_list() {
  local scanner_names
  scanner_names="$(tmx_scanner_all)"
  tmx_print_kv "config" "$(tmx_config_path)"
  tmx_print_kv "scanners" "${scanner_names}"
  echo ""
  echo "Configured roots:"
  local root
  for root in "${TMX_ROOT_PATHS[@]}"; do
    echo "  - ${root}"
  done
}
