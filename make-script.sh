#!/bin/bash

#SBATCH --job-name=yambo-make
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=01:59:00
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

WORKDIR=./yambo-5.1.2
cd "$WORKDIR"

srun make clean > make_output.log
srun make core > make_output.log

