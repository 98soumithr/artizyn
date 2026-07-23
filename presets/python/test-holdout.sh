#!/usr/bin/env bash
set -euo pipefail
pytest tests/holdout tests/cross-feature -q
