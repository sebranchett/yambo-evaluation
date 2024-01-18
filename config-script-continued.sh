#!/bin/bash

#SBATCH --job-name=yambo-config
#SBATCH --partition=compute
#SBATCH --account=innovation
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
# second time do not: module load hdf5
# second time do not: module load netcdf-c
# second time do not: module load netcdf-fortran

WORKDIR=./yambo-5.2.0
cd "$WORKDIR"

srun ./configure \
    --enable-hdf5-par-io \
    --with-mpi-path=$OPENMPI_ROOT \
    --with-blas-libs="-L${OPENBLAS_ROOT}/lib -lopenblas" \
    --with-fft-path=$FFTW_ROOT \
    > config_output.log

# second time do not:   --with-hdf5-path=$HDF5_ROOT \
# second time do not:   --with-netcdf-path=$NETCDF_C_ROOT \
# second time do not:   --with-netcdff-path=$NETCDF_FORTRAN_ROOT \
