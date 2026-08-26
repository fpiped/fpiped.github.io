#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT="${1:-output/filippo-scotti-cv.pdf}"

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

mkdir -p "$(dirname "$OUTPUT_PATH")"
"$BROWSER_BIN" \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --print-to-pdf="$OUTPUT_PATH" \
  --print-to-pdf-no-header \
  --no-pdf-header-footer \
  "file://$ROOT_DIR/index.html" >/dev/null

printf 'Generated %s\n' "$OUTPUT_PATH"
