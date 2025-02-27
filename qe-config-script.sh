#!/bin/bash

#SBATCH --job-name=qe-config
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:20:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2024r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH

# see Prerequisites
export LC_ALL=C

WORKDIR=./q-e-qe-7.4.1
cd "$WORKDIR"

srun ./configure \
    LIBDIRS="$FFTW_ROOT/lib $OPENBLAS_ROOT/lib $OPENMPI_ROOT/lib" \
    > qe_config_output.log

