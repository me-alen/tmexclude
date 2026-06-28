# tmexclude

`tmexclude` is a macOS CLI that excludes generated/rebuildable project artifacts
from Time Machine while keeping source code backed up.

## Installation

### Option 1: Local repo install

From this repository:

```bash
./install.sh
```

### Option 2: Package install (`.pkg`)

After installing the package, run the user setup script:

```bash
/usr/local/lib/tmexclude/install.sh
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
- `tmexclude config [--path]`

## Watcher

Run watcher in the foreground:

```bash
tmexclude watch
```

## LaunchAgent

Start LaunchAgent now:

```bash
launchctl load "$HOME/Library/LaunchAgents/com.tmexclude.watcher.plist"
```

Check status:

```bash
launchctl list | rg tmexclude
```

Stop LaunchAgent:

```bash
launchctl unload "$HOME/Library/LaunchAgents/com.tmexclude.watcher.plist"
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
- Optional YAML config is supported (`config.example.yaml`) by setting `TMX_CONFIG_PATH`.
- Hook plugins can be installed under `~/.config/tmexclude/plugins.d`.

## Uninstallation

### Remove user-level install and LaunchAgent

```bash
./uninstall.sh
```

### If installed via package, remove system files too

```bash
sudo rm -f /usr/local/bin/tmexclude
sudo rm -rf /usr/local/lib/tmexclude
sudo pkgutil --forget com.tmexclude.cli
```

### Optional: remove user config and logs

```bash
rm -rf ~/.config/tmexclude
rm -rf ~/.local/share/tmexclude
```

## Quality

- Run tests: `bash tests/run.sh`
- Run ShellCheck: `shellcheck bin/tmexclude lib/**/*.sh tests/**/*.sh install.sh uninstall.sh`
