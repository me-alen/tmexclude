#!/usr/bin/env bash

set -euo pipefail

############################################
# Time Machine Exclusion Utility
#
# Excludes common development folders from
# Time Machine backups.
#
# Usage:
#   ./exclude-time-machine.sh
#   ./exclude-time-machine.sh ~/Projects
#   ./exclude-time-machine.sh ~/Projects ~/Work
############################################

# Default search location
if [ "$#" -eq 0 ]; then
    SEARCH_PATHS=("$HOME")
else
    SEARCH_PATHS=("$@")
fi

# Directories to exclude
EXCLUDE_DIRS=(
    "node_modules"
    ".next"
    "dist"
    "build"
    "out"
    "coverage"
    ".turbo"
    ".cache"
    ".parcel-cache"
    ".vite"
)

echo "==============================================="
echo " Time Machine Development Exclusion Utility"
echo "==============================================="
echo

TOTAL=0

for ROOT in "${SEARCH_PATHS[@]}"; do

    if [ ! -d "$ROOT" ]; then
        echo "Skipping missing path: $ROOT"
        continue
    fi

    echo "Scanning:"
    echo "  $ROOT"
    echo

    for DIR in "${EXCLUDE_DIRS[@]}"; do

        while IFS= read -r PATHNAME; do

            if tmutil isexcluded "$PATHNAME" >/dev/null 2>&1; then
                echo "Already excluded:"
            else
                tmutil addexclusion "$PATHNAME"
                echo "Excluded:"
            fi

            echo "  $PATHNAME"
            TOTAL=$((TOTAL + 1))

        done < <(find "$ROOT" -type d -name "$DIR" 2>/dev/null)

    done
done

echo
echo "==============================================="
echo "Completed."
echo "Processed $TOTAL directories."
echo "==============================================="
