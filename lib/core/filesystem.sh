#!/usr/bin/env bash

tmx_path_exists() {
  local path="$1"
  [[ -e "${path}" ]]
}

tmx_is_dir() {
  local path="$1"
  [[ -d "${path}" ]]
}

tmx_is_ignored_dir_name() {
  local name="$1"
  local ignored
  for ignored in "${TMX_IGNORE_DIR_NAMES[@]:-}"; do
    [[ "${ignored}" == "${name}" ]] && return 0
  done
  return 1
}

tmx_safe_within_root() {
  local root="$1"
  local path="$2"
  [[ "${path}" == "${root}"* ]]
}

tmx_is_protected_path() {
  local path="$1"
  case "${path}" in
    */.git|*/.git/*) return 0 ;;
    */src|*/src/*) return 0 ;;
    */lib|*/lib/*) return 0 ;;
    */app|*/app/*) return 0 ;;
  esac
  return 1
}

tmx_dir_size_bytes() {
  local path="$1"
  if [[ -d "${path}" ]]; then
    du -sk "${path}" 2>/dev/null | awk '{print $1 * 1024}'
  else
    echo 0
  fi
}

tmx_human_bytes() {
  local bytes="$1"
  awk -v b="${bytes}" 'BEGIN{
    split("B KB MB GB TB",u);
    i=1;
    while (b>=1024 && i<5) {b/=1024; i++}
    printf "%.2f %s", b, u[i]
  }'
}
