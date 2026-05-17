#!/bin/bash

# Script to make all repositories private except fitness-app
# Requirements: GitHub CLI (gh) must be installed and authenticated
# Usage: bash make-repos-private.sh

set -e

USERNAME="myz1993"
EXCLUDE_REPO="fitness-app"
PRIVATE_COUNT=0
SKIPPED_COUNT=0

echo "Starting to update repository visibility..."
echo "================================================"

# Get all repositories for the user
REPOS=$(gh repo list $USERNAME --limit 1000 --json name,isPrivate --jq '.[] | select(.isPrivate == false) | .name')

if [ -z "$REPOS" ]; then
  echo "All repositories are already private!"
  exit 0
fi

for repo in $REPOS; do
  if [ "$repo" = "$EXCLUDE_REPO" ]; then
    echo "⊘ Skipping $repo (excluded)"
    ((SKIPPED_COUNT++))
  else
    echo "→ Making $repo private..."
    if gh repo edit $USERNAME/$repo --visibility private; then
      echo "✓ Successfully made $repo private"
      ((PRIVATE_COUNT++))
    else
      echo "✗ Failed to make $repo private"
    fi
  fi
done

echo "================================================"
echo "Summary:"
echo "  Repositories made private: $PRIVATE_COUNT"
echo "  Repositories skipped: $SKIPPED_COUNT"
echo "Done!"
