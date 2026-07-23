#!/usr/bin/env bash
set -euo pipefail
go vet ./...
command -v golangci-lint >/dev/null && golangci-lint run || true
