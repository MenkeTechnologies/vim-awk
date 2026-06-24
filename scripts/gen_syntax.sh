#!/usr/bin/env bash
# Stamp syntax/awk.vim with the awkrs version it was checked against.
#
# AWK's language surface is fixed and small (a POSIX core plus the gawk / mawk
# extensions awkrs accepts), so the keyword / builtin lists are hand-curated in
# syntax/awk.vim — there is no 10k-builtin reflection table to dump like stryke.
# This script keeps the one volatile piece — the "verified against awkrs vX.Y.Z"
# line and the dynamically-counted token totals — in sync with the binary.
#
#   ./scripts/gen_syntax.sh        # uses `awkrs` on $PATH
#   AWKRS=/path/to/awkrs ./scripts/gen_syntax.sh
set -euo pipefail

awkrs="${AWKRS:-awkrs}"
here="$(cd "$(dirname "$0")/.." && pwd)"
out="$here/syntax/awk.vim"

ver="$("$awkrs" --version 2>/dev/null | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
ver="${ver:-unknown}"

# Count the curated token surface straight out of the syntax file (source of
# truth), so the reported numbers never drift from what is highlighted.
count() { grep -hoE "syntax keyword $1 .*" "$out" | sed -E "s/syntax keyword $1 //" | tr ' ' '\n' | grep -c .; }
nfunc="$(count awkFunction)"
nvar="$(count awkBuiltinVar)"

# Rewrite only the single "Verified against ..." stamp line in place.
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
sed -E "s|^\" Verified against awkrs .*|\" Verified against awkrs ${ver} — pattern / action engine|" "$out" > "$tmp"
mv "$tmp" "$out"

echo "stamped $out (awkrs ${ver}; ${nfunc} builtin functions, ${nvar} builtin variables)"
