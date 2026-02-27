#!/usr/bin/env zsh
set -euo pipefail

# Source folder: this site folder (where this script lives).
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Target git repo used for push (same workflow used in this session).
TARGET_REPO="${TARGET_REPO:-/tmp/personalwebsite_1772219288}"

if [[ ! -d "$TARGET_REPO/.git" ]]; then
  echo "Error: TARGET_REPO is not a git repository: $TARGET_REPO"
  echo "Tip: export TARGET_REPO=\"/your/repo/path\" and run again."
  exit 1
fi

# Sync site files into target repo.
rsync -a --delete \
  --exclude '.git' \
  --exclude '.DS_Store' \
  --exclude '.hugo_build.lock' \
  --exclude 'public' \
  --exclude 'public/' \
  "$SOURCE_DIR/" "$TARGET_REPO/"

cd "$TARGET_REPO"

git add -A

if [[ -z "$(git status --porcelain)" ]]; then
  echo "No changes to commit."
  exit 0
fi

MSG="${1:-Update website $(date +%Y-%m-%d\ %H:%M)}"

git commit -m "$MSG"
git push

echo "Done: pushed to origin/main"
