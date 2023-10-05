#!/bin/bash

#SBATCH --job-name=qe-config
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH

# see Prerequisites
export LC_ALL=C

WORKDIR=./q-e-qe-7.2
cd "$WORKDIR"

srun ./configure \
    > qe_config_output.log

