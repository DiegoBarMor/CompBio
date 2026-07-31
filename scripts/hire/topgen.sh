#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------
compile_bin() { # create the "hire_topgen" binary
    if [ ! -d "$REPO_HIRE/Top4HiRE" ]; then
        echo "Error: $REPO_HIRE/Top4HiRE is not a directory. Run 'hirerun fetch' first to clone the HiRE repository."
        return 1
    fi

    local dir_build=$REPO_HIRE/Top4HiRE/build
    mkdir -p "$dir_build" "$dir_bin"

    cd "$dir_build"
    FC=gfortran cmake ../src
    make
    cd - > /dev/null

    cp "$dir_build/Top4HiRE" "$dir_bin/hire_topgen"
    cp "$REPO_HIRE/Top4HiRE/data/HiRE-RNA_2026.dat" "$dir_bin/"
}

# ------------------------------------------------------------------------------
run_bin() { # execute the "hire_topgen" binary
    local path_dat="$dir_bin/HiRE-RNA_2026.dat"
    if [ ! -f "$path_dat" ]; then
        echo "Error: HiRE-RNA_2026.dat not found in $dir_bin"
        return 1
    fi

    local path_pdb_fa;
    path_pdb_fa="$(realpath "${1}")"
    if [ ! -f "$path_pdb_fa" ]; then
        echo "Error: PDB file not found: $path_pdb_fa"
        return 1
    fi

    cd "$(dirname "$path_pdb_fa")"
    $exec "$path_pdb_fa" PDB "$path_dat"
    cd - > /dev/null
}

# ------------------------------------------------------------------------------
if [ "$#" -lt 1 ]; then
    echo "Usage: hirerun topgen <pdb_file_fa>"
    exit 1
fi

dir_bin=$DIR_HSM/plugins/cbio/bin/hire_topgen

exec="$dir_bin/hire_topgen"
if [ ! -f "$exec" ]; then
    compile_bin
fi

run_bin "$1"
