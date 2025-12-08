#!/usr/bin/env bash
set -euo pipefail

# Always run from repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

book_dir=book
output_dir=output
docs_dir=docs

mkdir -p "$output_dir" "$docs_dir"

echo 'Determining version from release.json (if present)...'
version_string=''
if [ -f release.json ]; then
  version_string=$(grep '"version"' release.json | cut -d: -f2 | cut -d'"' -f2 | tr -d '[:space:]' || true)
fi
if [ -z "${version_string:-}" ]; then
  version_string="1.0"
fi

date_string=$(date +%F)
compile_time=$(date '+%Y-%m-%d %H-%M-%S')

echo "Version: $version_string"
echo "Date:    $date_string"
echo "Build:   $compile_time"

# Common attributes as a BASH ARRAY (avoids word-splitting issues)
common_attrs=(
  -a "revnumber=$version_string"
  -a "revdate=$date_string"
  -a "compile_time=$compile_time"
)

echo
echo "Checking EPUB theme files..."
epub_theme_attrs=()
epub_theme_dir="$book_dir/theme/epub"
if [ -d "$epub_theme_dir" ]; then
  if [ -f "$epub_theme_dir/epub3.scss" ]; then
    echo "Found epub3.scss in $epub_theme_dir"
  elif [ -f "$epub_theme_dir/epub3.css" ]; then
    echo "Found epub3.css but no epub3.scss in $epub_theme_dir"
    echo "Creating epub3.scss wrapper that imports epub3.css..."
    cat > "$epub_theme_dir/epub3.scss" <<'EOF'
@import "epub3.css";
EOF
  else
    echo "Warning: no epub3.scss or epub3.css in $epub_theme_dir; using default EPUB styling."
  fi

  # Always set stylesdir if the directory exists; Asciidoctor decides which file to pick.
  epub_theme_attrs=(-a "epub3-stylesdir=theme/epub")
else
  echo "Warning: no $epub_theme_dir directory; using default EPUB styling."
fi

echo
echo "Generating contributors list..."
if git rev-parse --git-dir > /dev/null 2>&1; then
  git shortlog -es | cut -f 2- > "$book_dir/contributors.txt"
else
  echo "Not a git repo; skipping contributors list."
fi

echo
echo "Generating QR codes (if generator script exists)..."
if [[ -x "scripts/generate_qrcode.sh" ]]; then
  scripts/generate_qrcode.sh
else
  echo "QR code generator scripts/generate_qrcode.sh not found or not executable; skipping QR generation."
fi

echo
echo "Converting to HTML..."
asciidoctor \
  --destination-dir="$output_dir" \
  --out-file="ttt.html" \
  "${common_attrs[@]}" \
  "$book_dir/ttt-spine.adoc"
echo "-- HTML output at $output_dir/ttt.html"

echo
echo "Syncing assets..."
mkdir -p "$output_dir/assets" "$docs_dir/assets"
rsync -r --delete "$book_dir/assets/" "$output_dir/assets/" || true
rsync -r --delete "$book_dir/assets/" "$docs_dir/assets/" || true


echo
echo "Updating website (docs/book.html)..."
cp "$output_dir/ttt.html" "$docs_dir/book.html"

echo "Copying static website files into docs..."
mkdir -p docs
if [ -d "website-static" ]; then
  rsync -av website-static/ docs/
else
  echo "NOTE: website-static directory not found; skipping static asset copy."
fi

echo
echo "Converting to EPUB (with audio)..."
asciidoctor-epub3 \
  -d book \
  --destination-dir="$output_dir" \
  --out-file="ttt.epub" \
  "${common_attrs[@]}" \
  "${epub_theme_attrs[@]}" \
  -a toc \
  -a notoc! \
  -a pygments-style=manni \
  -a pygments-linenums-mode=inline \
  -a troubleshoot=1 \
  "$book_dir/ttt-spine.adoc"
echo "-- EPUB (with audio) at $output_dir/ttt.epub"

echo
echo "Validating EPUB (with audio, if epubcheck exists)..."
if command -v epubcheck >/dev/null 2>&1; then
  epubcheck "$output_dir/ttt.epub" -e || echo "EPUB validation returned warnings."
else
  echo "epubcheck not installed; skipping validation."
fi

mv "$output_dir/ttt.epub" "$output_dir/ttt-audio.epub"

echo
echo "Converting to EPUB (no audio, Apple Books)..."
asciidoctor-epub3 \
  -d book \
  --destination-dir="$output_dir" \
  --out-file="ttt.epub" \
  "${common_attrs[@]}" \
  "${epub_theme_attrs[@]}" \
  -a toc \
  -a notoc! \
  -a pygments-style=manni \
  -a pygments-linenums-mode=inline \
  -a troubleshoot=1 \
  -a apple-books=1 \
  "$book_dir/ttt-spine.adoc"
echo "-- EPUB (no audio) at $output_dir/ttt.epub"

echo
echo "Validating EPUB (no audio, if epubcheck exists)..."
if command -v epubcheck >/dev/null 2>&1; then
  epubcheck "$output_dir/ttt.epub" -e || echo "EPUB validation returned warnings."
else
  echo "epubcheck not installed; skipping validation."
fi

echo
echo "Creating Kindle-named EPUB copy..."
cp "$output_dir/ttt.epub" "$output_dir/ttt-kindle.epub"
echo "-- Kindle EPUB at $output_dir/ttt-kindle.epub"

echo
echo "Converting to PDF A4..."
asciidoctor-pdf \
  --destination-dir="$output_dir" \
  --out-file="ttt.pdf" \
  "${common_attrs[@]}" \
  -a "pdf-themesdir=$book_dir/theme/pdf" \
  -a "pdf-fontsdir=$book_dir/theme/fonts,GEM_FONTS_DIR" \
  -a "pdf-theme=bartificer" \
  "$book_dir/ttt-spine.adoc"
echo "-- PDF A4 at $output_dir/ttt.pdf"

echo
echo "Converting to PDF US..."
asciidoctor-pdf \
  --destination-dir="$output_dir" \
  --out-file="ttt-us.pdf" \
  "${common_attrs[@]}" \
  -a "pdf-themesdir=$book_dir/theme/pdf" \
  -a "pdf-fontsdir=$book_dir/theme/fonts,GEM_FONTS_DIR" \
  -a "pdf-theme=bartificer-us" \
  "$book_dir/ttt-spine.adoc"
echo "-- PDF US at $output_dir/ttt-us.pdf"

echo
echo "Converting to PDF A5..."
asciidoctor-pdf \
  --destination-dir="$output_dir" \
  --out-file="ttt-a5.pdf" \
  "${common_attrs[@]}" \
  -a "pdf-themesdir=$book_dir/theme/pdf" \
  -a "pdf-fontsdir=$book_dir/theme/fonts,GEM_FONTS_DIR" \
  -a "pdf-theme=bartificer-a5" \
  "$book_dir/ttt-spine.adoc"
echo "-- PDF A5 at $output_dir/ttt-a5.pdf"

echo
echo "Creating ttt_html.zip..."
zip -r "$output_dir/ttt_html.zip" "$output_dir/ttt.html" "$output_dir/assets" >/dev/null

# echo
# echo "Creating ttt_all.zip..."
# zip -r "$output_dir/ttt_all.zip" "$output_dir"/ttt*.[a-y]* "$output_dir/assets" >/dev/null || true

echo
echo "Removing standalone ttt.html..."
rm -f "$output_dir/ttt.html"

echo
echo "Build Complete."
