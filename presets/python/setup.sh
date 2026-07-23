#!/usr/bin/env bash
set -euo pipefail
if [ -f pyproject.toml ] && command -v uv >/dev/null; then uv sync
elif [ -f requirements.txt ]; then pip install -r requirements.txt
else pip install -e .; fi
