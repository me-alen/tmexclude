# Extension Points

`tmexclude` supports lightweight hook-based extensions.

## Plugin Directory

Default plugin directory:

`~/.config/tmexclude/plugins.d`

Each `*.sh` script in this directory is executed with:

- `TMX_PLUGIN_HOOK`: current hook name
- `TMX_PLUGIN_PAYLOAD`: key-value payload string

## Available Hooks

- `before_scan`
- `on_excluded`
- `after_scan`
- `watch_started`
- `watch_tick`

## Example Plugin

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ "${TMX_PLUGIN_HOOK}" == "on_excluded" ]]; then
  echo "$(date) ${TMX_PLUGIN_PAYLOAD}" >> "${HOME}/.local/share/tmexclude/logs/plugin.log"
fi
```
