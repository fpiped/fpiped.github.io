#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT="${1:-output/filippo-scotti-cv.pdf}"
CONTACT_FILE="${CV_CONTACT_FILE:-$ROOT_DIR/.cv-contact.json}"

case "$OUTPUT" in
  /*) OUTPUT_PATH="$OUTPUT" ;;
  *) OUTPUT_PATH="$ROOT_DIR/$OUTPUT" ;;
esac

find_browser() {
  if [[ -n "${BROWSER:-}" && -x "$BROWSER" ]]; then
    printf '%s\n' "$BROWSER"
    return 0
  fi

  local candidates=(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
    "google-chrome"
    "chromium"
    "chromium-browser"
    "microsoft-edge"
    "brave-browser"
  )

  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ "$candidate" == /* && -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
    if [[ "$candidate" != /* ]] && command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done

  return 1
}

BROWSER_BIN="$(find_browser || true)"
if [[ -z "$BROWSER_BIN" ]]; then
  cat >&2 <<'EOF'
No Chromium-compatible browser found.

Install Google Chrome, Chromium, Microsoft Edge, or Brave, then rerun:
  ./scripts/build-pdf.sh

You can also point to a browser explicitly:
  BROWSER="/path/to/browser" ./scripts/build-pdf.sh
EOF
  exit 1
fi

if [[ ! -r "$CONTACT_FILE" ]]; then
  cat >&2 <<EOF
PDF contact file not found: $CONTACT_FILE

Copy .cv-contact.example.json to .cv-contact.json and replace the example
email. The local file is ignored by Git and is used only while generating the
PDF.
EOF
  exit 1
fi

mkdir -p "$ROOT_DIR/tmp"
TMP_DIR="$(mktemp -d "$ROOT_DIR/tmp/pdf-build.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

cp "$ROOT_DIR/styles.css" "$TMP_DIR/styles.css"

python3 - "$ROOT_DIR/index.html" "$CONTACT_FILE" "$TMP_DIR/index.html" <<'PY'
import html
import json
import sys
from pathlib import Path

source_path, contact_path, output_path = map(Path, sys.argv[1:])
contact = json.loads(contact_path.read_text(encoding="utf-8"))

email = contact.get("email")
if not isinstance(email, str) or not email.strip():
    raise SystemExit("The PDF contact file must contain a non-empty 'email' string.")

email = email.strip()
contact_html = (
    f'<a class="pdf-contact" href="mailto:{html.escape(email, quote=True)}" '
    f'aria-label="Email address">{html.escape(email)}</a>'
)

source = source_path.read_text(encoding="utf-8")
marker = "<!-- PDF_CONTACT_DETAILS -->"
if source.count(marker) != 1:
    raise SystemExit(f"Expected exactly one {marker} marker in index.html.")

output_path.write_text(source.replace(marker, contact_html), encoding="utf-8")
PY

mkdir -p "$(dirname "$OUTPUT_PATH")"
"$BROWSER_BIN" \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --print-to-pdf="$OUTPUT_PATH" \
  --print-to-pdf-no-header \
  --no-pdf-header-footer \
  "file://$TMP_DIR/index.html" >/dev/null

printf 'Generated %s\n' "$OUTPUT_PATH"
