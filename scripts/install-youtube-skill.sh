#!/usr/bin/env bash
set -euo pipefail

# Default path requested by user (Windows Obsidian vault via remotely-save)
DEFAULT_TARGET='C:\Users\User\OneDrive\應用程式\remotely-save\Obsidian Vault'
TARGET_PATH="${1:-$DEFAULT_TARGET}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$REPO_ROOT/skills/youtube-upgrade"
DEST_DIR="$TARGET_PATH/skills/youtube-upgrade"

if [ ! -d "$SRC_DIR" ]; then
  echo "Source skill directory not found: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
cp -f "$SRC_DIR/SKILL.md" "$DEST_DIR/SKILL.md"
mkdir -p "$DEST_DIR/templates"
cp -f "$SRC_DIR/templates/handoff.template.md" "$DEST_DIR/templates/handoff.template.md"

echo "Installed youtube-upgrade skill to: $DEST_DIR"
