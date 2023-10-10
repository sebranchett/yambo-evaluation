#!/bin/bash

#SBATCH --job-name=qe-test
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:59:00
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

# see Prerequisites
export LC_ALL=C

WORKDIR=./q-e-qe-7.2/test-suite
cd "$WORKDIR"

# Do not user srun here. The tests will fail and tell you not to
make clean
make run-tests \
    >  qe_test_output.log

