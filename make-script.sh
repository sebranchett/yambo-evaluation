#!/bin/bash

#SBATCH --job-name=yambo-make
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH
module load hdf5
module load netcdf-c
module load netcdf-fortran

WORKDIR=./yambo-5.2.3
cd "$WORKDIR"

# srun make clean > make_output.log
srun make core > make_output.log

