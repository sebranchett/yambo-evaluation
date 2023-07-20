#!/bin/bash

#SBATCH --job-name=qe-config
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load intel/oneapi-all
export CPATH=$MKLROOT/include/fftw:$CPATH

# Just to be sure, see Prerequisites
export LC_ALL=C

WORKDIR=./q-e-qe-7.2
cd "$WORKDIR"

srun ./configure --prefix="/home/$USER/.local" \
    > qe_config_output.log

