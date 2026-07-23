#!/usr/bin/env bash
set -euo pipefail
if [ -f pnpm-lock.yaml ]; then pnpm install --frozen-lockfile
elif [ -f yarn.lock ]; then yarn install --frozen-lockfile
else npm ci 2>/dev/null || npm install; fi
