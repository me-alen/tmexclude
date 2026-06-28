#!/usr/bin/env bash

source "${ROOT_DIR}/lib/commands/stats.sh"
source "${ROOT_DIR}/lib/commands/doctor.sh"

tmx_cmd_health() {
  echo "tmexclude health"
  echo "config: $(tmx_config_path)"
  echo "state: $(tmx_state_file)"
  echo ""
  if tmx_cmd_doctor; then
    echo "doctor: clean"
  else
    echo "doctor: issues found"
  fi
  echo ""
  tmx_cmd_stats
}
