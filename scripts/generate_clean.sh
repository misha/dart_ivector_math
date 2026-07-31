#!/usr/bin/env bash
# Generates lib/src/clean/ from lib/src/dirty/ by stripping every line
# tagged with the `@dirty` marker, producing a build of the library with
# no dirty-bit tracking overhead. Run via `scripts/generate_clean.sh`
# (or `rps generate-clean`) whenever lib/src/dirty/ changes.
set -euo pipefail

source_dir=lib/src/dirty
target_dir=lib/src/clean

rm -rf "$target_dir"

find "$source_dir" -name '*.dart' | while read -r file; do
  target="$target_dir/${file#"$source_dir"/}"
  
  mkdir -p "$(dirname "$target")"
  {
    echo '// GENERATED FILE. DO NOT EDIT.'
    echo
    grep -v '@dirty$' "$file"
  } > "$target"

  dart format "$target"
done

echo "Generated $target_dir from $source_dir."
