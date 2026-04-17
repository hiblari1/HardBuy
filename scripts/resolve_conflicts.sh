#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-incoming}"
TARGET_FILES=(README.md lib/main.dart)

case "$MODE" in
  incoming)
    echo "Applying INCOMING changes for: ${TARGET_FILES[*]}"
    git checkout --theirs "${TARGET_FILES[@]}"
    ;;
  current)
    echo "Applying CURRENT changes for: ${TARGET_FILES[*]}"
    git checkout --ours "${TARGET_FILES[@]}"
    ;;
  *)
    echo "Usage: $0 [incoming|current]"
    exit 1
    ;;
esac

git add "${TARGET_FILES[@]}"

if rg -n "^(<<<<<<<|=======|>>>>>>>)" "${TARGET_FILES[@]}"; then
  echo "Conflict markers still detected in target files. Resolve manually."
  exit 1
fi

echo "Done. Target files resolved and staged."
