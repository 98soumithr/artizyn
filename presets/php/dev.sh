#!/usr/bin/env bash
set -euo pipefail
php artisan serve 2>/dev/null || php -S localhost:8000 -t public
