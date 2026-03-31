#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_dir="${repo_root}/environments/dev"

cd "${env_dir}"
tofu init -reconfigure "$@"
