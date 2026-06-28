#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

chmod +x "${ROOT_DIR}/bin/tmexclude" "${ROOT_DIR}/tests/mock_tmutil.sh"

export TMX_CONFIG_PATH="${TMP_DIR}/config.ini"
export XDG_DATA_HOME="${TMP_DIR}/data"
export TMX_TMUTIL_BIN="${ROOT_DIR}/tests/mock_tmutil.sh"
export TMX_MOCK_TMUTIL_STATE="${TMP_DIR}/tm_state.txt"

cat > "${TMX_CONFIG_PATH}" <<'EOF'
[roots]
paths =
  TMPROOT_PLACEHOLDER

[ignore]
dir_names =
  Archive

[behavior]
dry_run = false
follow_symlinks = false
max_depth = 4

[watch]
enabled = false
interval_seconds = 2
notify = false
EOF

PROJECT_ROOT="${TMP_DIR}/projects/sample-node"
mkdir -p "${PROJECT_ROOT}/node_modules" "${PROJECT_ROOT}/dist"
echo "{}" > "${PROJECT_ROOT}/package.json"

awk -v p="${TMP_DIR}/projects" '{gsub("TMPROOT_PLACEHOLDER", p); print}' "${TMX_CONFIG_PATH}" > "${TMX_CONFIG_PATH}.tmp"
mv "${TMX_CONFIG_PATH}.tmp" "${TMX_CONFIG_PATH}"

"${ROOT_DIR}/bin/tmexclude" list >/dev/null
"${ROOT_DIR}/bin/tmexclude" scan >/dev/null

if ! "${ROOT_DIR}/bin/tmexclude" check "${PROJECT_ROOT}/node_modules" >/dev/null; then
  echo "FAIL: expected node_modules to be excluded" >&2
  exit 1
fi

"${ROOT_DIR}/bin/tmexclude" remove "${PROJECT_ROOT}/node_modules" >/dev/null

if "${ROOT_DIR}/bin/tmexclude" check "${PROJECT_ROOT}/node_modules" >/dev/null 2>&1; then
  echo "FAIL: expected node_modules to be non-excluded after remove" >&2
  exit 1
fi

"${ROOT_DIR}/bin/tmexclude" doctor >/dev/null || true
"${ROOT_DIR}/bin/tmexclude" stats >/dev/null

echo "All tests passed."
