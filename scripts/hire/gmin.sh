#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------
compile_bin() { # create the "hire_gmin" binary
    if [ ! -d "$REPO_HIRE/GMIN_HiRE" ]; then
        echo "Error: $REPO_HIRE/GMIN_HiRE is not a directory. Run 'hirerun fetch' first to clone the HiRE repository."
        return 1
    fi

    local dir_build=$REPO_HIRE/GMIN_HiRE/build
    mkdir -p "$dir_build" "$dir_bin"

    cd "$dir_build" || return 1
    FC=gfortran cmake ../source
    make
    cd - > /dev/null || return 1

    cp "$dir_build/HIREGMIN" "$dir_bin/hire_gmin" || return 1
    cp "$REPO_HIRE/Examples/GMIN-example/input/scale_RNA.dat" "$dir_bin/" || return 1
    cp "$REPO_HIRE/Examples/GMIN-example/input/data" "$dir_bin/" || return 1
}

# ------------------------------------------------------------------------------
_run_hire_gmin() { # execute the "hire_gmin" binary
    local dir_data;
    dir_data="$(realpath "${1}")"
    if [ ! -d "$dir_data" ]; then
        echo "Error: Data directory not found: $dir_data"
        return 1
    fi

    return 1 # [WIP]
}

# ------------------------------------------------------------------------------
if [ "$#" -lt 1 ]; then
    echo "Usage: hirerun gmin <folder_data>"
    exit 1
fi

dir_bin=$DIR_HSM/plugins/cbio/bin/hire_gmin

exec="$dir_bin/hire_gmin"
if [ ! -f "$exec" ]; then
    compile_bin
fi

run_bin "$1"
