#!/bin/bash

#SBATCH --job-name=yambo-make
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=03:00:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=10GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2024r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH
# second time do not: module load hdf5
# second time do not: module load netcdf-c
# second time do not: module load netcdf-fortran

WORKDIR=./yambo-5.2.3
cd "$WORKDIR"

# second time do not: srun make clean > make_output.log
srun make core > make_output.log

