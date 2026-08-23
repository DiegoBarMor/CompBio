#!/bin/bash
set -euo pipefail

convert() {
    usage() {
        echo "Usage: hirerun convert <command> [options]"
        echo
        echo "Commands:"
        echo "  xyz2st  - Converts a XYZ coordinates file to a HiRE 'start' input file"
        echo
    }

    if [[ "$#" -eq 0 ]]; then
        usage
        return 1
    fi

    local dir_scripts=$DIR_HSM/plugins/cbio/scripts/hire/convert

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            xyz2st)
                python3 "$dir_scripts/xyz2start.py" "${@:2}" || return 1
                return 0
                ;;
            -h|--help)
                usage
                return 0
                ;;
            *)
                usage
                return 1
                ;;
        esac
    done
}

convert "$@"
