#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

usage() {
  cat <<'EOF_USAGE'
Usage: bin/run.sh <command>

Commands:
  serve   Start local preview (mkdocs serve)
  build   Build static site into ./build
  clean   Remove ./build
  check   Strict build into ./build (fail on warnings)
  help    Show this help

EOF_USAGE
}

ensure_mkdocs() {
  if ! command -v mkdocs >/dev/null 2>&1; then
    echo "mkdocs not found. Install with: pip install mkdocs" >&2
    exit 1
  fi
}

cmd="${1:-help}"

case "$cmd" in
  serve)
    ensure_mkdocs
    exec mkdocs serve
    ;;
  build)
    ensure_mkdocs
    exec mkdocs build --clean
    ;;
  clean)
    rm -rf "$ROOT/build"
    echo "Removed ./build"
    ;;
  check)
    ensure_mkdocs
    exec mkdocs build --clean --strict
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage >&2
    exit 1
    ;;
esac
