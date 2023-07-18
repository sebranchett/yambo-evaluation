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

module load 2022r2
module load intel-mkl  # this only works with 2022r2, not 2023rc1
module load openmpi/4.1.1  # to work with 2022r2
export CPATH=/apps/arch/2022r2/software/linux-rhel8-skylake_avx512/gcc-8.5.0/intel-mkl-2020.4.304-562z3j76h4zy26bjp5r2mrimud6fshrc/compilers_and_libraries_2020.4.304/linux/mkl/include/fftw:$CPATH  # to find fftw
module load hdf5/1.10.7  # to work with 2022r2

WORKDIR=./yambo-5.1.2
# add yambo path:
export PATH=$PATH:$WORKDIR/bin
# add the netcdf library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/arch/2022r2/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-c-4.8.1-kz7m3osaphp3uut6i2tg5a5mdqf7q64m/lib
# add the netcdff library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/apps/arch/2022r2/software/linux-rhel8-skylake_avx512/gcc-8.5.0/netcdf-fortran-4.5.3-vjqc2vv2me65uouytdvu2sw4jlbqkjyi/lib

cd "$WORKDIR"

srun yambo --version &>  check_output.log
srun echo "-o0o-"     >> check_output.log
srun p2y   --version &>> check_output.log
srun echo "-o0o-"     >> check_output.log
srun yambo           &>> check_output.log

