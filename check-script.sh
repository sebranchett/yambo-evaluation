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
export CPATH=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/include:$CPATH

# add the netcdf library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-c-4.9.0-di5a6gyhmgbmapai34ran7zzco5jjj2j/lib
# add the netcdff library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-fortran-4.6.0-7ets55p5c7nuask3ah6ejyuvdqq6canp/lib
# add the hdf5 library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/hdf5-1.12.2-ji6agq2hsffcd3mesaopxc2px6w5wot3/lib
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

