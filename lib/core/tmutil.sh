#!/usr/bin/env bash

TMX_TMUTIL_BIN="${TMX_TMUTIL_BIN:-tmutil}"

tmx_tmutil_available() {
  command -v "${TMX_TMUTIL_BIN}" >/dev/null 2>&1
}

tmx_require_tmutil() {
  if ! tmx_tmutil_available; then
    tmx_error "tmutil not found. This tool requires macOS tmutil."
    return 1
  fi
}

tmx_tm_is_excluded() {
  local path="$1"
  if ! tmx_require_tmutil; then
    return 2
  fi
  local out
  out="$("${TMX_TMUTIL_BIN}" isexcluded "${path}" 2>/dev/null || true)"
  [[ "${out}" == *"[Excluded]"* ]]
}

tmx_tm_add_exclusion() {
  local path="$1"
  tmx_require_tmutil || return 1
  "${TMX_TMUTIL_BIN}" addexclusion "${path}" >/dev/null
}

tmx_tm_remove_exclusion() {
  local path="$1"
  tmx_require_tmutil || return 1
  "${TMX_TMUTIL_BIN}" removeexclusion "${path}" >/dev/null
}
