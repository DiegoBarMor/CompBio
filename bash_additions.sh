#!/bin/bash

export REPO_HIRE=$HOME/HiRE

alias vg="volgrids" #

fetchpdb() { # FUNC: fetch a PDB file from RCSB
    local pdb="${1}"
    if [ -z "$pdb" ]; then
        echo "Usage: fetchpdb <pdb_id>"
        return 1
    fi
    curl "https://files.rcsb.org/download/$pdb.pdb" --output "$pdb.pdb"
}

hirerun() { # FUNC:
    usage() {
        echo "Usage: hirerun <command> [options]"
        echo
        echo "Commands:"
        echo "  fetch  - Clones HiRE repository from GitHub"
        echo "  topgen - Generate HiRE coarse-grained input files for a full-atomistic PDB file: parameters.top, start, start.xyz"
        echo "  md     - Run molecular dynamics"
        echo "  rex    - Run replica exchange"
        echo "  gmin   - Run GMIN"
        echo "  purge  - Remove all HiRE binaries and data files"
        echo
    }

    if [[ "$#" -eq 0 ]]; then
        usage
        return 1
    fi

    local dir_scripts=$DIR_HSM/plugins/cbio/scripts/hire

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            fetch)
                if [ ! -d "$REPO_HIRE" ]; then
                    git clone --depth 1 --branch NewScheme https://github.com/koroeder/HiRE "$REPO_HIRE"
                fi
                return 0
                ;;
            topgen)
                bash "$dir_scripts/topgen.sh" "${@:2}" || return 1
                return 0
                ;;
            md)
                bash "$dir_scripts/md.sh" "${@:2}" || return 1
                return 0
                ;;
            rex)
                bash "$dir_scripts/rex.sh" "${@:2}" || return 1
                return 0
                ;;
            gmin)
                bash "$dir_scripts/gmin.sh" "${@:2}" || return 1
                return 0
                ;;
            purge)
                rm -rf "${DIR_HSM:?}/plugins/cbio/bin" "${REPO_HIRE:?}"/**/build
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
