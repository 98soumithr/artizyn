#!/usr/bin/env bash
set -euo pipefail
python -m uvicorn app.main:app --reload 2>/dev/null || python manage.py runserver
