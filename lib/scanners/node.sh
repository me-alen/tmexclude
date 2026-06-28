#!/usr/bin/env bash

tmx_scanner_node_detect() {
  local project_root="$1"
  [[ -f "${project_root}/package.json" ]]
}

tmx_scanner_node_candidates() {
  cat <<'EOF'
node_modules
.next
.turbo
.parcel-cache
.cache
.vite
coverage
dist
out
EOF
}
