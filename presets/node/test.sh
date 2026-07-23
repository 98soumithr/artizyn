#!/usr/bin/env bash
set -euo pipefail
npx --no-install jest tests/working 2>/dev/null || npx --no-install vitest run tests/working
