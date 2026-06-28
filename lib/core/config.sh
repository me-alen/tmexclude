#!/usr/bin/env bash

TMX_CONFIG_PATH="${TMX_CONFIG_PATH:-${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude/config.ini}"
TMX_BEHAVIOR_DRY_RUN="false"
TMX_BEHAVIOR_FOLLOW_SYMLINKS="false"
TMX_BEHAVIOR_MAX_DEPTH="6"
TMX_WATCH_ENABLED="false"
TMX_WATCH_INTERVAL_SECONDS="20"
TMX_WATCH_NOTIFY="false"
TMX_PLUGIN_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmexclude/plugins.d"
TMX_ROOT_PATHS=()
TMX_IGNORE_DIR_NAMES=()

tmx_trim() {
  local input="$1"
  input="${input#"${input%%[![:space:]]*}"}"
  input="${input%"${input##*[![:space:]]}"}"
  echo "${input}"
}

tmx_expand_home() {
  local path="$1"
  if [[ "${path}" == "~"* ]]; then
    echo "${HOME}${path:1}"
  else
    echo "${path}"
  fi
}

tmx_load_default_roots_if_empty() {
  if [[ "${#TMX_ROOT_PATHS[@]}" -eq 0 ]]; then
    TMX_ROOT_PATHS+=("${HOME}/Projects")
  fi
}

tmx_init_config() {
  TMX_ROOT_PATHS=()
  TMX_IGNORE_DIR_NAMES=()
  TMX_WATCH_NOTIFY="false"
  local section=""
  local collecting=""

  if [[ ! -f "${TMX_CONFIG_PATH}" ]]; then
    tmx_load_default_roots_if_empty
    return 0
  fi

  if [[ "${TMX_CONFIG_PATH}" == *.yaml || "${TMX_CONFIG_PATH}" == *.yml ]]; then
    tmx_parse_yaml_config
    tmx_load_default_roots_if_empty
    return 0
  fi

  while IFS= read -r raw_line || [[ -n "${raw_line}" ]]; do
    local line
    line="$(tmx_trim "${raw_line}")"
    [[ -z "${line}" ]] && continue
    [[ "${line}" =~ ^# ]] && continue
    [[ "${line}" =~ ^\; ]] && continue

    if [[ "${line}" =~ ^\[(.+)\]$ ]]; then
      section="${BASH_REMATCH[1]}"
      collecting=""
      continue
    fi

    if [[ "${line}" == "paths =" ]]; then
      collecting="roots"
      continue
    fi
    if [[ "${line}" == "dir_names =" ]]; then
      collecting="ignore"
      continue
    fi

    if [[ "${line}" =~ ^([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*(.*)$ ]]; then
      local key="${BASH_REMATCH[1]}"
      local value
      value="$(tmx_trim "${BASH_REMATCH[2]}")"
      collecting=""
      case "${section}.${key}" in
        behavior.dry_run) TMX_BEHAVIOR_DRY_RUN="${value}" ;;
        behavior.follow_symlinks) TMX_BEHAVIOR_FOLLOW_SYMLINKS="${value}" ;;
        behavior.max_depth) TMX_BEHAVIOR_MAX_DEPTH="${value}" ;;
        watch.enabled) TMX_WATCH_ENABLED="${value}" ;;
        watch.interval_seconds) TMX_WATCH_INTERVAL_SECONDS="${value}" ;;
        watch.notify) TMX_WATCH_NOTIFY="${value}" ;;
        plugins.dir) TMX_PLUGIN_DIR="$(tmx_expand_home "${value}")" ;;
      esac
      continue
    fi

    case "${collecting}" in
      roots)
        TMX_ROOT_PATHS+=("$(tmx_expand_home "${line}")")
        ;;
      ignore)
        TMX_IGNORE_DIR_NAMES+=("${line}")
        ;;
    esac
  done < "${TMX_CONFIG_PATH}"

  tmx_load_default_roots_if_empty
}

tmx_parse_yaml_config() {
  local section=""
  local list_key=""
  while IFS= read -r raw_line || [[ -n "${raw_line}" ]]; do
    local line
    line="$(tmx_trim "${raw_line}")"
    [[ -z "${line}" ]] && continue
    [[ "${line}" =~ ^# ]] && continue
    if [[ "${line}" =~ ^([a-zA-Z_]+):[[:space:]]*$ ]]; then
      section="${BASH_REMATCH[1]}"
      list_key=""
      continue
    fi
    if [[ "${line}" =~ ^([a-zA-Z_]+):[[:space:]]*(.*)$ ]]; then
      local key="${BASH_REMATCH[1]}"
      local value
      value="$(tmx_trim "${BASH_REMATCH[2]}")"
      case "${section}.${key}" in
        behavior.dry_run) TMX_BEHAVIOR_DRY_RUN="${value}" ;;
        behavior.follow_symlinks) TMX_BEHAVIOR_FOLLOW_SYMLINKS="${value}" ;;
        behavior.max_depth) TMX_BEHAVIOR_MAX_DEPTH="${value}" ;;
        watch.enabled) TMX_WATCH_ENABLED="${value}" ;;
        watch.interval_seconds) TMX_WATCH_INTERVAL_SECONDS="${value}" ;;
        watch.notify) TMX_WATCH_NOTIFY="${value}" ;;
        plugins.dir) TMX_PLUGIN_DIR="$(tmx_expand_home "${value}")" ;;
        roots.paths) list_key="roots_paths" ;;
        ignore.dir_names) list_key="ignore_dir_names" ;;
      esac
      continue
    fi
    if [[ "${line}" =~ ^-[[:space:]]*(.+)$ ]]; then
      local item="${BASH_REMATCH[1]}"
      case "${list_key}" in
        roots_paths) TMX_ROOT_PATHS+=("$(tmx_expand_home "${item}")") ;;
        ignore_dir_names) TMX_IGNORE_DIR_NAMES+=("${item}") ;;
      esac
    fi
  done < "${TMX_CONFIG_PATH}"
}

tmx_config_path() {
  echo "${TMX_CONFIG_PATH}"
}
