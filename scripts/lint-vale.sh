#!/bin/bash
#
# Run Vale as spell checker
#
# 2025-12-09 Helma van der Linden
#

# Location of the script
ME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# assume we are in <root>/scripts
ROOT_DIR="$( dirname "$ME_DIR" )"

set -e

# Always run from the repo root (/workspace in the container)
cd "${ROOT_DIR}"

if ! command -v vale >/dev/null 2>&1; then
  echo "vale not found in container" >&2
  exit 1
fi

# Ensure styles directory exists
mkdir -p .github/styles

# Run vale sync only when write-good has not yet been downloaded
if [ ! -d ".github/styles/write-good" ]; then
  echo "Running vale sync to download write-good styles..." >&2
  if ! vale sync; then
    echo "vale sync failed" >&2
    exit 1
  fi
fi

# Finally run the linter
vale --no-wrap ./*.md book/