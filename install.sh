#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
TARGET="${BIN_DIR}/tmexclude"
START_AGENT="false"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [--start-agent]

Options:
  --start-agent    Bootstrap LaunchAgent immediately after install
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
if [[ "${1:-}" == "--start-agent" ]]; then
  START_AGENT="true"
elif [[ -n "${1:-}" ]]; then
  echo "Unknown argument: ${1}" >&2
  usage >&2
  exit 1
fi

mkdir -p "${BIN_DIR}"
chmod +x "${ROOT_DIR}/bin/tmexclude"
cat > "${TARGET}" <<EOF
#!/usr/bin/env bash
exec "${ROOT_DIR}/bin/tmexclude" "\$@"
EOF
chmod +x "${TARGET}"
if [[ "${START_AGENT}" == "true" ]]; then
  "${TARGET}" setup --start-agent
else
  "${TARGET}" setup
fi

echo "Installed tmexclude to ${TARGET}"
echo "Add ${BIN_DIR} to PATH if needed."
