# tmexclude

`tmexclude` is a macOS CLI that excludes generated/rebuildable project artifacts
from Time Machine while keeping source code backed up.

## Install

```bash
./install.sh
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

## Quality

- Run tests: `bash tests/run.sh`
- Run ShellCheck: `shellcheck bin/tmexclude lib/**/*.sh tests/**/*.sh install.sh uninstall.sh`
