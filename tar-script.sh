#!/bin/bash

#SBATCH --job-name=yambo-tar
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

srun tar zxf yambo-5.2.3.tar.gz

