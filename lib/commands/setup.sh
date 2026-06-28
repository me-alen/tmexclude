#!/usr/bin/env bash

tmx_launch_agent_plist_path() {
  echo "${HOME}/Library/LaunchAgents/com.tmexclude.watcher.plist"
}

tmx_launch_agent_domain() {
  echo "gui/$(id -u)"
}

tmx_cmd_setup() {
  local start_agent="false"
  if [[ "${1:-}" == "--start-agent" ]]; then
    start_agent="true"
  elif [[ -n "${1:-}" ]]; then
    echo "Usage: tmexclude setup [--start-agent]" >&2
    return 1
  fi

  local bin_dir="${HOME}/.local/bin"
  local target="${bin_dir}/tmexclude"
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude"
  local config_file="${config_dir}/config.ini"
  local plugin_dir="${config_dir}/plugins.d"
  local log_dir="${HOME}/.local/share/tmexclude/logs"
  local launch_agents_dir="${HOME}/Library/LaunchAgents"
  local plist
  plist="$(tmx_launch_agent_plist_path)"
  local domain
  domain="$(tmx_launch_agent_domain)"

  mkdir -p "${bin_dir}" "${config_dir}" "${plugin_dir}" "${log_dir}" "${launch_agents_dir}"

  cat > "${target}" <<EOF
#!/usr/bin/env bash
exec "${ROOT_DIR}/bin/tmexclude" "\$@"
EOF
  chmod +x "${target}"

  if [[ ! -f "${config_file}" ]]; then
    cp "${ROOT_DIR}/config.example" "${config_file}"
  fi

  cat > "${plist}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key><string>com.tmexclude.watcher</string>
    <key>ProgramArguments</key>
    <array>
      <string>${target}</string>
      <string>watch</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>${log_dir}/watch.out.log</string>
    <key>StandardErrorPath</key><string>${log_dir}/watch.err.log</string>
  </dict>
</plist>
EOF

  if [[ "${start_agent}" == "true" ]]; then
    launchctl bootout "${domain}/com.tmexclude.watcher" >/dev/null 2>&1 || true
    launchctl bootstrap "${domain}" "${plist}"
  fi

  echo "Setup complete."
  echo "Binary: ${target}"
  echo "Config: ${config_file}"
  echo "LaunchAgent: ${plist}"
  if [[ "${start_agent}" == "true" ]]; then
    echo "LaunchAgent status: started"
  else
    echo "Start LaunchAgent:"
    echo "  tmexclude start-agent"
  fi
}

tmx_cmd_start_agent() {
  local plist
  plist="$(tmx_launch_agent_plist_path)"
  local domain
  domain="$(tmx_launch_agent_domain)"

  if [[ ! -f "${plist}" ]]; then
    echo "LaunchAgent plist missing. Run: tmexclude setup" >&2
    return 1
  fi

  launchctl bootout "${domain}/com.tmexclude.watcher" >/dev/null 2>&1 || true
  launchctl bootstrap "${domain}" "${plist}"
  echo "LaunchAgent started."
}

tmx_cmd_stop_agent() {
  local domain
  domain="$(tmx_launch_agent_domain)"
  launchctl bootout "${domain}/com.tmexclude.watcher" >/dev/null 2>&1 || true
  echo "LaunchAgent stopped."
}
