#!/usr/bin/env bash

tmx_state_dir() {
  echo "${XDG_DATA_HOME:-$HOME/.local/share}/tmexclude/state"
}

tmx_state_file() {
  echo "$(tmx_state_dir)/exclusions.tsv"
}

tmx_ensure_state() {
  mkdir -p "$(tmx_state_dir)"
  if [[ ! -f "$(tmx_state_file)" ]]; then
    printf "timestamp\tproject_root\tpath\tscanner\n" > "$(tmx_state_file)"
  fi
}

tmx_state_has_path() {
  local path="$1"
  tmx_ensure_state
  awk -F '\t' -v p="${path}" 'NR>1 && $3==p {f=1} END{exit !f}' "$(tmx_state_file)"
}

tmx_state_add() {
  local project_root="$1"
  local path="$2"
  local scanner="$3"
  tmx_ensure_state
  if tmx_state_has_path "${path}"; then
    return 0
  fi
  printf "%s\t%s\t%s\t%s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "${project_root}" "${path}" "${scanner}" >> "$(tmx_state_file)"
}

tmx_state_remove() {
  local path="$1"
  tmx_ensure_state
  awk -F '\t' -v p="${path}" 'NR==1 || $3!=p {print $0}' "$(tmx_state_file)" > "$(tmx_state_file).tmp"
  mv "$(tmx_state_file).tmp" "$(tmx_state_file)"
}
