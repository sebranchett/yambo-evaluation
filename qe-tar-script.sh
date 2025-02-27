#!/bin/bash

#SBATCH --job-name=qe-untar
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:20:00
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

srun tar zxf q-e-qe-7.4.1.tar.gz

