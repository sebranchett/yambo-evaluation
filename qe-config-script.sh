#!/bin/bash

#SBATCH --job-name=qe-config
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load intel/oneapi-all
# and for FFTW, these 2 lines:
module load 2023rc1
export CPATH=$MKLROOT/include/fftw:$CPATH
# ScaLAPACK needs 2023rc1 and
module load openmpi/4.1.4

# Just to be sure, see Prerequisites
export LC_ALL=C
# Looking for FFT
export LIBDIR=/apps/arch/2023rc1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/lib

# for hdf5
export PATH=$PATH:/apps/arch/2023rc1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/hdf5-1.10.7-dx6qlalqfxamhu7f737mitzetitfs5ah/bin

WORKDIR=./q-e-qe-7.2
cd "$WORKDIR"

srun ./configure \
    --with-scalapack="yes" \
    --with-hdf5="yes" \
    > qe_config_output.log

