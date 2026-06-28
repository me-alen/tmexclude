#!/usr/bin/env bash

tmx_scanner_react_native_detect() {
  local project_root="$1"
  [[ -f "${project_root}/app.json" || -f "${project_root}/expo.json" ]]
}

tmx_scanner_react_native_candidates() {
  cat <<'EOF'
node_modules
android/build
ios/Pods
ios/build
EOF
}
