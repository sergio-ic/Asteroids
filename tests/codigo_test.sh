#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
source_file=${1:-"$script_dir/../codigo.txt"}
normalized_content=$(sed 's/\r$//' "$source_file")
first_line=$(printf '%s\n' "$normalized_content" | sed -n '1p')

if [ "$first_line" != 'Hola mundo!' ]; then
    printf 'not ok - expected the first line to be "Hola mundo!", got "%s"\n' "$first_line" >&2
    exit 1
fi

if printf '%s\n' "$normalized_content" | grep -Fqx 'Hola mundo'; then
    printf 'not ok - found the obsolete greeting without an exclamation mark\n' >&2
    exit 1
fi

greeting_count=$(printf '%s\n' "$normalized_content" | awk '$0 == "Hola mundo!" { count++ } END { print count + 0 }')
if [ "$greeting_count" -ne 1 ]; then
    printf 'not ok - expected the updated greeting exactly once, found %s occurrences\n' "$greeting_count" >&2
    exit 1
fi

printf 'ok - updated greeting is exact, unique, and replaces the obsolete greeting\n'
