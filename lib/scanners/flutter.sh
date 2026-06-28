#!/usr/bin/env bash

tmx_scanner_flutter_detect() {
  local project_root="$1"
  [[ -f "${project_root}/pubspec.yaml" ]]
}

tmx_scanner_flutter_candidates() {
  cat <<'EOF'
.dart_tool
build
ios/Pods
ios/.symlinks
macos/Pods
macos/.symlinks
android/.gradle
android/build
EOF
}
