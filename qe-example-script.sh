#!/bin/bash

#SBATCH --job-name=qe-example
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=02:30:00
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2024r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH

# see Prerequisites
export LC_ALL=C

# See section on Examples here:
# https://www.quantum-espresso.org/Doc/user_guide/node15.html
WORKDIR=./q-e-qe-7.4.1/PW/examples
cd "$WORKDIR"

# if you want to run in parallel, change these two parameters:
# PARA_PREFIX="srun"
# PARA_POSTFIX=""
# in:
# ./q-e-qe-7.4.1/environment_variables

./run_all_examples

