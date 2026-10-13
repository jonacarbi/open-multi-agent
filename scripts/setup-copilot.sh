#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Ensure deps
echo "Installing npm dependencies (quiet)..."
npm install --silent --no-audit --no-fund

# Prefer Copilot token env, then GITHUB_TOKEN, then gh
if [ -n "${GITHUB_COPILOT_TOKEN:-}" ]; then
  echo "Using GITHUB_COPILOT_TOKEN (already set)"
elif [ -n "${GITHUB_TOKEN:-}" ]; then
  echo "Using GITHUB_TOKEN (already set)"
else
  if command -v gh >/dev/null 2>&1; then
    echo "Retrieving GitHub token from gh..."
    export GITHUB_TOKEN="$(gh auth token)"
    echo "GITHUB_TOKEN exported in this session"
  else
    echo "ERROR: gh CLI not found. Install/authenticate gh or set GITHUB_COPILOT_TOKEN/GITHUB_TOKEN env var." >&2
    exit 2
  fi
fi

echo "Running Copilot example (examples/providers/copilot.ts)"
NODE_OPTIONS=--max-old-space-size=4096 npx tsx examples/providers/copilot.ts
