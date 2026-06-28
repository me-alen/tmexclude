# tmexclude

`tmexclude` is a macOS CLI that excludes generated/rebuildable project artifacts
from Time Machine while keeping source code backed up.

## Quick Start (PKG flow)

```bash
# 1) Install the .pkg first, then:
tmexclude setup --start-agent
tmexclude list
tmexclude scan --dry-run
tmexclude scan
tmexclude stats
```

## Installation

### Option 1: Local repo install

From this repository:

```bash
./install.sh
```

Install and start LaunchAgent immediately:

```bash
./install.sh --start-agent
```

### Option 2: Package install (`.pkg`)

After installing the package, run setup from CLI:

```bash
tmexclude setup
```

Or setup and start watcher immediately:

```bash
tmexclude setup --start-agent
```

### Verify installation

```bash
tmexclude help
tmexclude list
```

## Commands

- `tmexclude scan [--dry-run]`
- `tmexclude list`
- `tmexclude check <path>`
- `tmexclude remove <path>`
- `tmexclude stats`
- `tmexclude doctor`
- `tmexclude fix`
- `tmexclude watch`
- `tmexclude health`
- `tmexclude setup [--start-agent]`
- `tmexclude --start-agent` (shortcut for `tmexclude setup --start-agent`)
- `tmexclude start-agent`
- `tmexclude stop-agent`
- `tmexclude uninstall [--all]`
- `tmexclude config [--path]`

## Watcher

Run watcher in the foreground:

```bash
tmexclude watch
```

## LaunchAgent

Start LaunchAgent now:

```bash
tmexclude start-agent
```

Check status:

```bash
launchctl print "gui/$(id -u)/com.tmexclude.watcher"
```

Stop LaunchAgent:

```bash
tmexclude stop-agent
```

## Config

Default path: `~/.config/tmexclude/config.ini`

Copy starter config:

```bash
cp config.example ~/.config/tmexclude/config.ini
```

## Notes

- `stats` reports estimate of currently excluded path sizes.
- `doctor` detects stale state and exclusion drift.
- `watch` is polling-based and intended for LaunchAgent usage.
- `scan` shows live progress while processing candidates.
- `setup` creates user-level config, plugin dir, logs, and LaunchAgent plist.
- Optional YAML config is supported (`config.example.yaml`) by setting `TMX_CONFIG_PATH`.
- Hook plugins can be installed under `~/.config/tmexclude/plugins.d`.

## Uninstallation

### Remove user-level install and LaunchAgent

```bash
tmexclude uninstall
```

### Complete uninstall (user + system files)

```bash
tmexclude uninstall --all
```

### Alternative fallback script

```bash
./uninstall.sh
```

## Quality

- Run tests: `bash tests/run.sh`
- Run ShellCheck: `shellcheck bin/tmexclude lib/**/*.sh tests/**/*.sh install.sh uninstall.sh`
