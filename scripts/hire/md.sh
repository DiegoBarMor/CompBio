#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------
compile_bin() { # create the "hire_md" binary
    if [ ! -d "$REPO_HIRE/MD_HiRE" ]; then
        echo "Error: $REPO_HIRE/MD_HiRE is not a directory. Run 'hirerun fetch' first to clone the HiRE repository."
        return 1
    fi

    local dir_build=$REPO_HIRE/MD_HiRE/build
    mkdir -p "$dir_build" "$dir_bin"

    cd "$dir_build"
    FC=gfortran cmake ../source
    make
    cd - > /dev/null

    cp "$dir_build/HIREMD" "$dir_bin/hire_md"
}

# ------------------------------------------------------------------------------
run_bin() { # execute the "hire_md" binary
    local dir_data;
    dir_data="$(realpath "${1}")"
    if [ ! -d "$dir_data" ]; then
        echo "Error: Data directory not found: $dir_data"
        return 1
    fi

    local path_top="$dir_data/parameters.top"
    if [ ! -f "$path_top" ]; then
        echo "Error: parameters.top not found in $dir_data. Run 'hirerun topgen <pdb_file_fa>' first."
        return 1
    fi

    local path_scale="$dir_data/scale_RNA.dat"
    if [ ! -f "$path_scale" ]; then
        echo "scale_RNA.dat not found in $dir_data. Copying default from $dir_params."
        cp "$dir_params/scale_RNA.dat" "$dir_data/"
    fi

    if [ ! -f "$dir_data/mddata" ]; then
        echo "mddata not found in $dir_data. Copying default from $dir_params."
        cp "$dir_params/mddata" "$dir_data/"
    fi

    cd "$dir_data"
    $exec parameters.top scale_RNA.dat
    cd - > /dev/null
}

# ------------------------------------------------------------------------------
if [ "$#" -lt 1 ]; then
    echo "Usage: hirerun md <folder_data>"
    exit 1
fi

dir_bin=$DIR_HSM/plugins/cbio/bin/hire_md
dir_params=$DIR_HSM/plugins/cbio/data/hire_md

exec="$dir_bin/hire_md"
if [ ! -f "$exec" ]; then
    compile_bin
fi

run_bin "$1"
