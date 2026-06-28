#!/usr/bin/env bash

tmx_progress() {
  local message="$1"
  printf ".. %s\n" "${message}"
}

tmx_progress_update() {
  local message="$1"
  if [[ -t 1 ]]; then
    printf "\r.. %s" "${message}"
  else
    printf ".. %s\n" "${message}"
  fi
}

tmx_progress_done() {
  local message="$1"
  if [[ -t 1 ]]; then
    printf "\r.. %s\n" "${message}"
  else
    printf ".. %s\n" "${message}"
  fi
}
