#!/usr/bin/env bash
set -euo pipefail
./vendor/bin/phpunit tests/holdout tests/cross-feature
