#!/bin/bash

#SBATCH --job-name=yambo-config
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
export CPATH=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/include:$CPATH
export MKLROOT=/beegfs/apps/generic/intel/oneapi_2022.3/mkl/latest

WORKDIR=./yambo-5.1.2
cd "$WORKDIR"

srun ./configure \
    --enable-hdf5-par-io \
    --with-fft-includedir="${MKLROOT}/include/fftw" \
    --with-fft-libs="-L${MKLROOT}/lib/intel64 -lmkl_gf_lp64 -lmkl_core -lmkl_sequential -lpthread -lm" \
    --with-blas-libs="-L${MKLROOT}/lib/intel64 -lmkl_gf_lp64 -lmkl_core -lmkl_sequential -lpthread -lm" \
    --with-netcdf-path=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-c-4.9.0-di5a6gyhmgbmapai34ran7zzco5jjj2j/ \
    --with-netcdff-path=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-fortran-4.6.0-7ets55p5c7nuask3ah6ejyuvdqq6canp/ \
    --with-hdf5-path=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/hdf5-1.12.2-ji6agq2hsffcd3mesaopxc2px6w5wot3/ \
    > config_output.log

