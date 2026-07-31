#!/bin/bash
set -euo pipefail

# ------------------------------------------------------------------------------
compile_bin() { # create the "hire_rex" binary
    if [ ! -d "$REPO_HIRE/MD_HiRE" ]; then
        echo "Error: $REPO_HIRE/MD_HiRE is not a directory. Run 'hirerun fetch' first to clone the HiRE repository."
        return 1
    fi

    local dir_build=$REPO_HIRE/MD_HiRE/build
    mkdir -p "$dir_build" "$dir_bin"

    cd "$dir_build"
    FC=mpif90 CC=mpicc cmake ../source -DCOMPILER_SWITCH=gfortran -DWITH_MPI=ON
    make
    cd - > /dev/null

    cp "$dir_build/HIREMD" "$dir_bin/hire_rex"
    cp "$REPO_HIRE/Examples/MD-example-LD/input/scale_RNA.dat" "$dir_bin/"
    cp "$REPO_HIRE/Examples/MD-example-TREX/input/mddata" "$dir_bin/"
}

# ------------------------------------------------------------------------------
run_bin() { # execute the "hire_rex" binary
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
    echo "Usage: hirerun rex <folder_data>"
    exit 1
fi

dir_bin=$DIR_HSM/plugins/cbio/bin/hire_rex

exec="$dir_bin/hire_rex"
if [ ! -f "$exec" ]; then
    compile_bin
fi

run_bin "$1"
