#!/bin/sh
set -e

# Usage:
#   scripts/lint-vale.sh [minAlertLevel]
#
# minAlertLevel: suggestion | warning | error
# default: suggestion

LEVEL="${1:-suggestion}"

case "$LEVEL" in
  suggestion|warning|error)
    ;;
  *)
    echo "Unknown minAlertLevel '$LEVEL', defaulting to 'suggestion'" >&2
    LEVEL="suggestion"
    ;;
esac

# Always run from the repo root (/workspace in the container)
cd "$(dirname "$0")/.."

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

# Finally run the linter with wide, unwrapped output
COLUMNS="${COLUMNS:-300}"
echo "Running Vale (minAlertLevel=$LEVEL, COLUMNS=$COLUMNS)..."
COLUMNS="$COLUMNS" vale --no-wrap --minAlertLevel="$LEVEL" ./*.md book/
