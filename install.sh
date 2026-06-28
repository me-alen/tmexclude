#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
TARGET="${BIN_DIR}/tmexclude"

mkdir -p "${BIN_DIR}"
chmod +x "${ROOT_DIR}/bin/tmexclude"
cat > "${TARGET}" <<EOF
#!/usr/bin/env bash
exec "${ROOT_DIR}/bin/tmexclude" "\$@"
EOF
chmod +x "${TARGET}"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude"
mkdir -p "${CONFIG_DIR}"
if [[ ! -f "${CONFIG_DIR}/config.ini" ]]; then
  cp "${ROOT_DIR}/config.example" "${CONFIG_DIR}/config.ini"
fi
mkdir -p "${CONFIG_DIR}/plugins.d"
mkdir -p "${HOME}/.local/share/tmexclude/logs"

mkdir -p "${HOME}/Library/LaunchAgents"
cat > "${HOME}/Library/LaunchAgents/com.tmexclude.watcher.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key><string>com.tmexclude.watcher</string>
    <key>ProgramArguments</key>
    <array>
      <string>${TARGET}</string>
      <string>watch</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>${HOME}/.local/share/tmexclude/logs/watch.out.log</string>
    <key>StandardErrorPath</key><string>${HOME}/.local/share/tmexclude/logs/watch.err.log</string>
  </dict>
</plist>
EOF

echo "Installed tmexclude to ${TARGET}"
echo "Add ${BIN_DIR} to PATH if needed."
