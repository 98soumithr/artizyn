#!/usr/bin/env bash
set -euo pipefail
./vendor/bin/pint --test 2>/dev/null || ./vendor/bin/php-cs-fixer fix --dry-run
