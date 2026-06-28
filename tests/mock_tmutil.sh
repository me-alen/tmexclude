#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="${TMX_MOCK_TMUTIL_STATE:-/tmp/tmx_mock_tmutil_state.txt}"
mkdir -p "$(dirname "${STATE_FILE}")"
touch "${STATE_FILE}"

cmd="${1:-}"
path="${2:-}"

case "${cmd}" in
  isexcluded)
    if grep -Fxq "${path}" "${STATE_FILE}"; then
      echo "[Excluded] ${path}"
    else
      echo "[Not Excluded] ${path}"
    fi
    ;;
  addexclusion)
    if ! grep -Fxq "${path}" "${STATE_FILE}"; then
      echo "${path}" >> "${STATE_FILE}"
    fi
    ;;
  removeexclusion)
    awk -v p="${path}" '$0!=p {print $0}' "${STATE_FILE}" > "${STATE_FILE}.tmp"
    mv "${STATE_FILE}.tmp" "${STATE_FILE}"
    ;;
  *)
    echo "unknown command: ${cmd}" >&2
    exit 1
    ;;
esac
