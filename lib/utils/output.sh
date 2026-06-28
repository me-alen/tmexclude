#!/usr/bin/env bash

tmx_print_kv() {
  local key="$1"
  local value="$2"
  printf "%-22s %s\n" "${key}" "${value}"
}
