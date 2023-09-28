#!/bin/bash

#SBATCH --job-name=qe-untar
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:20:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

srun tar zxf q-e-qe-7.2.tar.gz

