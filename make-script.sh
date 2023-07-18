#!/bin/bash

#SBATCH --job-name=yambo-make
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:59:00
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
cd "$WORKDIR"

srun make core > make_output.log

