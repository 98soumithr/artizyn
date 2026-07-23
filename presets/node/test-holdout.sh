#!/usr/bin/env bash
set -euo pipefail
npx --no-install jest tests/holdout tests/cross-feature 2>/dev/null || npx --no-install vitest run tests/holdout tests/cross-feature
