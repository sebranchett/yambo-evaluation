#!/bin/bash

#SBATCH --job-name=yambo-config
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

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

WORKDIR=./yambo-5.1.2
cd "$WORKDIR"

srun ./configure \
    --enable-hdf5-par-io \
    --with-mpi-path=$OPENMPI_ROOT \
    --with-blas-libs="-L${OPENBLAS_ROOT}/lib -lopenblas" \
    --with-fft-path=$FFTW_ROOT \
    --with-hdf5-path=$HDF5_ROOT \
    --with-netcdf-path=$NETCDF_C_ROOT \
    --with-netcdff-path=$NETCDF_FORTRAN_ROOT \
    > config_output.log

