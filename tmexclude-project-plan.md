# tmexclude

Developer-focused macOS CLI utility that excludes generated, rebuildable
project artifacts from Time Machine while keeping source and hand-written
assets backed up.

---

# Goals

## Primary

- Automatically detect supported project types.
- Exclude only generated/rebuildable files.
- Keep source code and project metadata fully backed up.
- Safe to run repeatedly (idempotent).
- Configurable without editing code.

## Secondary

- Monitor configured roots for newly created projects.
- Estimate current excluded size.
- Make exclusions easy to inspect and undo.
- Keep scanner logic extensible for new technologies.

---

# Non-Goals (v1.x)

- Rewriting Time Machine internals or backup destination policies.
- Guaranteed exact "bytes saved in TM history" reporting (only estimates).
- Full plugin system (planned later).

---

# Project Structure

```text
tmexclude/
├── bin/
│   └── tmexclude
├── lib/
│   ├── commands/
│   │   ├── scan.sh
│   │   ├── list.sh
│   │   ├── check.sh
│   │   ├── remove.sh
│   │   ├── stats.sh
│   │   ├── doctor.sh
│   │   ├── fix.sh
│   │   ├── watch.sh
│   │   ├── health.sh
│   │   └── config.sh
│   ├── scanners/
│   │   ├── node.sh
│   │   ├── flutter.sh
│   │   ├── angular.sh
│   │   ├── react-native.sh
│   │   ├── android.sh
│   │   └── generic.sh
│   ├── core/
│   │   ├── logger.sh
│   │   ├── tmutil.sh
│   │   ├── colors.sh
│   │   ├── filesystem.sh
│   │   ├── config.sh
│   │   └── state.sh
│   └── utils/
│       ├── output.sh
│       └── progress.sh
├── install.sh
├── uninstall.sh
├── README.md
├── LICENSE
└── config.example
```

---

# Configuration

Config file location:

```text
~/.config/tmexclude/config.ini
```

State/manifest location:

```text
~/.local/share/tmexclude/state/exclusions.tsv
```

Log directory:

```text
~/.local/share/tmexclude/logs/
```

Example config:

```ini
[roots]
paths =
  ~/Projects
  ~/NxtTechSoft
  ~/Terresta
  ~/Flutter
  ~/Workspace
  ~/GitHub

[ignore]
dir_names =
  Trash
  Archive
  Backups

[behavior]
dry_run = false
follow_symlinks = false
max_depth = 6

[watch]
enabled = false
interval_seconds = 20
```

---

# CLI Commands

| Command | Description | Version |
| --- | --- | --- |
| `tmexclude` / `tmexclude scan` | Scan configured roots and apply missing exclusions | v1.0 |
| `tmexclude scan --dry-run` | Show planned exclusions without applying | v1.1 |
| `tmexclude list` | Show configured roots and scanner availability | v1.0 |
| `tmexclude check <path>` | Check whether a path is currently excluded | v1.0 |
| `tmexclude remove <path>` | Remove exclusion for a specific path | v1.0 |
| `tmexclude stats` | Show current excluded size by project/type | v1.1 |
| `tmexclude doctor` | Detect missing/invalid exclusions and stale state entries | v1.2 |
| `tmexclude fix` | Apply safe fixes suggested by `doctor` | v1.2 |
| `tmexclude watch` | Poll configured roots and auto-apply exclusions | v2.0 |
| `tmexclude health` | High-level status report (`scan`, `doctor`, `stats` summary) | v2.0 |
| `tmexclude config` | Open or print config file path | v1.0 |

---

# Detection and Exclusion Rules

## v1.0 Scanners

### Node.js / Next.js / React / NestJS

- Detect when `package.json` exists.
- Exclude:
  - `node_modules`
  - `.next`
  - `.turbo`
  - `.parcel-cache`
  - `.cache`
  - `.vite`
  - `coverage`
  - `dist`
  - `out`

### Flutter

- Detect when `pubspec.yaml` exists.
- Exclude:
  - `.dart_tool`
  - `build`
  - `ios/Pods`
  - `ios/.symlinks`
  - `macos/Pods`
  - `macos/.symlinks`
  - `android/.gradle`
  - `android/build`

## v1.1 Scanners

### Angular

- Detect when `angular.json` exists.
- Exclude:
  - `node_modules`
  - `.angular`
  - `dist`
  - `coverage`

### React Native / Expo

- Detect when `app.json` or `expo.json` exists.
- Exclude:
  - `node_modules`
  - `android/build`
  - `ios/Pods`
  - `ios/build`

### Android

- Detect when `settings.gradle` or `build.gradle` exists.
- Exclude:
  - `.gradle`
  - `build`

---

# Idempotency and Safety Rules

- Before adding an exclusion, verify with `tmutil isexcluded`.
- Never exclude:
  - `.git`
  - source directories (for example `src`, `lib`, `app` by default)
  - files outside configured roots
- Track each added exclusion in `exclusions.tsv` with:
  - `timestamp`
  - `project_root`
  - `path`
  - `scanner`
- `remove` must update both `tmutil` state and local manifest.
- If a previously excluded path no longer exists, keep record as stale until `doctor`/`fix`.

---

# Watch Mode

`tmexclude watch` (v2.0):

- Polls configured roots every `interval_seconds` (dependency-free baseline).
- Detects new projects and newly created generated directories.
- Reuses scanner rules from `scan`.
- Writes structured logs for each cycle and change.
- Intended to run via LaunchAgent for login persistence.

---

# LaunchAgent

Install path:

```text
~/Library/LaunchAgents/com.tmexclude.watcher.plist
```

Expected behavior:

- Starts at login.
- Restarts on failure.
- Runs `tmexclude watch`.
- Writes stdout/stderr to files under `~/.local/share/tmexclude/logs/`.

---

# Reporting Model

- `stats` reports current size of excluded paths (snapshot estimate).
- "Backup savings" is presented as estimate, not guaranteed historical TM savings.
- `health` aggregates:
  - config validity
  - last scan status
  - doctor findings
  - excluded size summary

---

# Roadmap

## v1.0

- CLI framework and command routing
- Config parsing (`config.ini`)
- Node scanner
- Flutter scanner
- `scan`, `list`, `check`, `remove`, `config`
- Logging and colored output
- State/manifest file

## v1.1

- Angular scanner
- React Native scanner
- Android scanner
- `scan --dry-run`
- `stats`

## v1.2

- `doctor`
- `fix`
- Better reporting and stale state cleanup
- Improved savings estimation output wording

## v2.0

- Background watch mode
- LaunchAgent install/uninstall flow
- Automatic exclusions from watch loop
- `health` command
- Optional notifications

## v3.0

- Homebrew formula
- Plugin architecture
- YAML config support (optional alternative format)
- CI workflows
- Test suite
- ShellCheck gating

---

# Future Ideas

- `tmexclude backup-report` (periodic report artifact)
- Interactive TUI
- Backup restore validation helper
- SSD / Time Machine health checks
