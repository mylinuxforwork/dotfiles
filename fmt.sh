#!/usr/bin/env bash

set -eou pipefail

usage() {
    echo "Usage: $0 {fmt|check|check-apply} [file]"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
else
    command=$1
fi

if [ $# -eq 1 ]; then
    file=""
else
    file=$2
fi

case $command in
fmt)
    if [ -z "$file" ]; then
        echo "Please provide a file to format. You can provide '.' for recursion."
        exit 1
    fi
    shfmt -w "$file"
    ;;
check)
    if [ -z "$file" ]; then
        echo "Please provide a file to check. You can provide '.' for recursion'"
        exit 1
    fi
    if [ "$file" == "." ]; then
        mapfile -t FILES < <(shfmt -f .)
        shellcheck "${FILES[@]}"
    else
        shellcheck "$file"
    fi
    ;;
check-apply)
    if [ -z "$file" ]; then
        echo "Please provide a file to check. You can provide '.' for recursion'"
        exit 1
    fi
    if [ "$file" == "." ]; then
        mapfile -t FILES < <(shfmt -f .)
        shellcheck "${FILES[@]}" -f diff | git apply
    else
        shellcheck "$file" -f diff | git apply
    fi
    ;;
*)
    usage
    ;;
esac
