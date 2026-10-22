#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
step="${1:?usage: tests/gates/run.sh <step>}"
obs() { printf 'AIEN-OBS %s %s\n' "$1" "$2"; }
case "$step" in

  zero-disk-secrets)
    found=false
    if find . -type f \( -name ".env" -o -name ".env.*" \) \
         ! -name "*.example" ! -name "*.sample" ! -path "./target/*" | head -1 | grep -q .; then
      found=true
      find . -type f \( -name ".env" -o -name ".env.*" \) \
        ! -name "*.example" ! -name "*.sample" ! -path "./target/*" | head -5 >&2
    fi
    obs env_files_found "$found"
    [ "$found" = false ]
    ;;

  gitmodules)
    command -v git >/dev/null || { echo "run.sh: git not on PATH" >&2; exit 3; }
    paths=$(grep -E '^[[:space:]]*path[[:space:]]*=' .gitmodules | sed 's/.*=[[:space:]]*//')
    urls=$(grep -E '^[[:space:]]*url[[:space:]]*=' .gitmodules | sed 's/.*=[[:space:]]*//')
    n=0; bad=0
    for p in $paths; do
      n=$((n+1))
      [ -d "$p" ] || { echo "missing submodule directory: $p" >&2; bad=1; }
    done
    for u in $urls; do
      case "$u" in
        https://github.com/aien-dev/*) ;;
        *) echo "submodule url outside aien-dev: $u" >&2; bad=1 ;;
      esac
    done
    obs submodule_count "$n"
    [ "$n" -gt 0 ] || { echo "no submodules parsed from .gitmodules" >&2; exit 1; }
    [ "$bad" = 0 ]
    ;;
  *) echo "run.sh: unknown step $step" >&2; exit 2 ;;
esac
