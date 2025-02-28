#!/bin/bash

#SBATCH --job-name=yambo-check
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:10:00
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
module load hdf5
module load netcdf-c
module load netcdf-fortran

YAMBODIR=${PWD}/yambo-5.3.0
# add yambo path:
export PATH=$PATH:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

cd "$YAMBODIR"

srun yambo --version &>  check_output.log
srun echo "-o0o-"     >> check_output.log
srun p2y   --version &>> check_output.log
srun echo "-o0o-"     >> check_output.log
srun yambo           &>> check_output.log

