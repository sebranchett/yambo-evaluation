#!/bin/bash

#SBATCH --job-name=yambo-abipy
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load hdf5
module load netcdf-c
module load miniconda3

# Set up Miniconda, see https://doc.dhpc.tudelft.nl/delftblue/howtos/conda/
# mkdir -p /scratch/${USER}/.conda  # first time
# ln -s /scratch/${USER}/.conda $HOME/.conda  # first time
unset CONDA_SHLVL
source "$(conda info --base)/etc/profile.d/conda.sh"

if conda info --envs | grep -q abipy; then
	echo "abipy environment exists"; else
	conda create -y --name abipy;
fi                                      &>  abipy.log
conda activate abipy                    &>> abipy.log

conda install -y pyyaml netcdf4         &>> abipy.log
conda config --add channels conda-forge &>> abipy.log
conda install -y abipy=0.9.2            &>> abipy.log
conda deactivate                        &>> abipy.log

