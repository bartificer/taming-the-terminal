#!/usr/bin/env bash
set -euo pipefail

# Always run from repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

BOOK_DIR="book"
CONTENTS_FILE="$BOOK_DIR/ttt-contents.adoc"
MP3_LIST="publish/mp3_files"

echo "== Checking Taming the Terminal episodes =="

# Collect all episode files like ttt01.adoc, ttt02.adoc, etc.
mapfile -t EPISODE_FILES < <(cd "$BOOK_DIR" && ls ttt[0-9]*.adoc 2>/dev/null | sort -V || true)

if ((${#EPISODE_FILES[@]} == 0)); then
  echo "No episode files matching book/ttt[0-9]*.adoc found."
  exit 0
fi

echo "Found ${#EPISODE_FILES[@]} episode file(s)."

# --- 1) Check ttt-contents.adoc for missing include:: lines ---

MISSING_CONTENTS_ENTRIES=()

for f in "${EPISODE_FILES[@]}"; do
  id="${f%.adoc}"         # e.g. ttt01
  num_padded="${id#ttt}"  # e.g. 01

  case "$id" in
    ttt-contents|ttt-spine)
      continue
      ;;
  esac

  if ! grep -q "$id" "$CONTENTS_FILE"; then
    echo "Missing contents entry for episode ${num_padded} ($id)"
    MISSING_CONTENTS_ENTRIES+=("$id:$num_padded")
  fi
done

# Insert missing include:: lines before ttt-afterword
if ((${#MISSING_CONTENTS_ENTRIES[@]} > 0)); then
  echo "Updating $CONTENTS_FILE to add missing include:: lines..."

  tmpfile="$(mktemp)"
  inserted=0

  while IFS= read -r line; do
    if [[ $inserted -eq 0 && "$line" == *"ttt-afterword"* ]]; then
      for entry in "${MISSING_CONTENTS_ENTRIES[@]}"; do
        IFS=: read -r eid enum <<<"$entry"
        echo "include::${eid}.adoc[]"
      done
      inserted=1
    fi

    echo "$line"
  done < "$CONTENTS_FILE" > "$tmpfile"

  mv "$tmpfile" "$CONTENTS_FILE"
  echo "Contents updated."
else
  echo "All episodes already appear in $CONTENTS_FILE."
fi

echo

# --- 2) Check MP3 list (TTTNN or ttt-NN as substring) ---

if [[ -f "$MP3_LIST" ]]; then
  echo "Checking MP3 list in $MP3_LIST..."
else
  echo "WARNING: $MP3_LIST not found; skipping MP3 checks."
fi

for f in "${EPISODE_FILES[@]}"; do
  id="${f%.adoc}"         # tttNN
  num_padded="${id#ttt}"  # NN (as in filename, usually 2 digits)

  case "$id" in
    ttt-contents|ttt-spine)
      continue
      ;;
  esac

  if [[ -f "$MP3_LIST" ]]; then
    # Look for either:
    #   TTTNN   (e.g. TTT40)
    #   ttt-NN  (e.g. ttt-40)
    #
    # as a substring anywhere in the line.
    pattern="TTT${num_padded}|ttt-${num_padded}"

    if ! grep -Eq "$pattern" "$MP3_LIST"; then
      echo "WARNING: No MP3 entry for episode ${num_padded} ($id) in $MP3_LIST (expected substring TTT${num_padded} or ttt-${num_padded})"
    fi
  fi
done

echo

# --- 3) Remote URL validation for mp3_files ---

if [[ -f "$MP3_LIST" ]]; then
  if ! command -v curl >/dev/null 2>&1; then
    echo "WARNING: curl not available; skipping remote URL validation for MP3s."
  else
    echo "Validating MP3 URLs in $MP3_LIST..."
    while IFS= read -r line; do
      # Skip empty lines and comments
      [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

      # Grab the first http(s) URL on the line
      url="$(printf '%s\n' "$line" | grep -Eo 'https?://[^[:space:]]+' || true)"

      if [[ -z "$url" ]]; then
        echo "WARNING: No URL found in mp3_files line: $line"
        continue
      fi

      # Perform a HEAD request with a timeout
      resp="$(curl -Is --max-time 10 "$url" 2>/dev/null || true)"

      if [[ -z "$resp" ]]; then
        echo "WARNING: MP3 URL seems unreachable (no response): $url"
        continue
      fi

      status="$(printf '%s\n' "$resp" | head -n1 | awk '{print $2}')"

      if [[ "$status" =~ ^[0-9]+$ ]] && (( status >= 400 )); then
        echo "WARNING: MP3 URL returned HTTP $status: $url"
      fi
    done < "$MP3_LIST"
  fi
fi

# --- 4) Ensure mp3_files ends with a final newline ---

if [[ -f "$MP3_LIST" ]]; then
  # tail -c1 prints the last byte; if non-empty, no newline at EOF
  if [ -n "$(tail -c1 "$MP3_LIST")" ]; then
    echo >> "$MP3_LIST"
    echo "Added missing final newline to $MP3_LIST"
  fi
fi

echo
echo "Episode checks complete."
