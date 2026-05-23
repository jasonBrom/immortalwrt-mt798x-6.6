#!/usr/bin/env bash
set -euo pipefail

ARTIFACT_DIR="${1:-artifacts}"

echo "===== artifacts ====="

if [ ! -d "$ARTIFACT_DIR" ]; then
  echo "No artifact directory: $ARTIFACT_DIR"
  exit 0
fi

find "$ARTIFACT_DIR" -maxdepth 2 -type f -printf "%p %k KB\n" | sort

echo
echo "===== expected important images ====="
find "$ARTIFACT_DIR" -maxdepth 1 -type f \( \
  -name "*sdcard*.img.gz" -o \
  -name "*sysupgrade*.itb" -o \
  -name "*recovery*.itb" -o \
  -name "*preloader*.bin" -o \
  -name "*uboot*.fip" \
\) -print | sort || true
