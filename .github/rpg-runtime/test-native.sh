#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cmake -S "$root" -B "$work" -DCMAKE_BUILD_TYPE=Release -DARDENS_LIBRETRO=ON -DLIBRETRO_STATIC=ON >/dev/null
cmake --build "$work" --config Release --target ardens_libretro -j4 >/dev/null
archive=$(find "$work" -maxdepth 2 -type f -name 'ardens_libretro.a' -print -quit)
test -n "$archive" && test -s "$archive"
nm "$archive" > "$work/symbols"
grep -q ' retro_serialize$' "$work/symbols"
grep -q ' retro_unserialize$' "$work/symbols"
