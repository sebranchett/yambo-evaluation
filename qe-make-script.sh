#!/bin/bash

#SBATCH --job-name=qe-make
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=01:00:00
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

# srun make clean \
#     >  qe_make_output.log
srun make all \
    >  qe_make_output.log

