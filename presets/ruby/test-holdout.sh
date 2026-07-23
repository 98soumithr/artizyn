#!/usr/bin/env bash
set -euo pipefail
bundle exec rspec tests/holdout tests/cross-feature
