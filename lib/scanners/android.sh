#!/usr/bin/env bash

tmx_scanner_android_detect() {
  local project_root="$1"
  [[ -f "${project_root}/settings.gradle" || -f "${project_root}/build.gradle" ]]
}

tmx_scanner_android_candidates() {
  cat <<'EOF'
.gradle
build
EOF
}
