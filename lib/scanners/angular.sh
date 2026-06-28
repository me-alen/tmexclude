#!/usr/bin/env bash

tmx_scanner_angular_detect() {
  local project_root="$1"
  [[ -f "${project_root}/angular.json" ]]
}

tmx_scanner_angular_candidates() {
  cat <<'EOF'
node_modules
.angular
dist
coverage
EOF
}
