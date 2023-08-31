#!/bin/bash

#SBATCH --job-name=yambo-check
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas

module load fftw
module load netcdf-c  # adds path to LD_LIBRARY_PATH
module load netcdf-fortran  # adds path to LD_LIBRARY_PATH
module load hdf5  # adds path to LD_LIBRARY_PATH

# add the BLAS/LAPACK/FTTW library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/beegfs/apps/generic/intel/oneapi_2022.3/mkl/latest/lib/intel64

YAMBODIR=${PWD}/yambo-5.1.2
# add yambo path:
export PATH=$PATH:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

cd "$YAMBODIR"

srun yambo --version &>  check_output.log
srun echo "-o0o-"     >> check_output.log
srun p2y   --version &>> check_output.log
srun echo "-o0o-"     >> check_output.log
srun yambo           &>> check_output.log

