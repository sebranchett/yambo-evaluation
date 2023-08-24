#!/bin/bash

#SBATCH --job-name=qe-test-parallel
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=02:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023rc1
module load openmpi
module load openblas
module load fftw
export CPATH=/apps/arch/2023rc1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/include:$CPATH

# Just to be sure, see Prerequisites
export LC_ALL=C

# See section on Examples here:
# https://www.quantum-espresso.org/Doc/user_guide/node15.html
WORKDIR=./q-e-qe-7.2/PW/examples
cd "$WORKDIR"
export PARA_PREFIX="srun"
export PARA_POSTFIX=""

./run_all_examples

