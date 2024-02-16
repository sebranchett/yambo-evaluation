#!/bin/bash

#SBATCH --job-name=yambo-abipy
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load miniconda3

# Set up Miniconda, see https://doc.dhpc.tudelft.nl/delftblue/howtos/conda/
# mkdir -p /scratch/${USER}/.conda  # first time
# ln -s /scratch/${USER}/.conda $HOME/.conda  # first time
unset CONDA_SHLVL
source "$(conda info --base)/etc/profile.d/conda.sh"

if conda info --envs | grep -q abipy; then
	echo "abipy environment exists"; else
	conda create -y --name abipy python=3.9;
fi                                      &>  abipy.log
conda activate abipy                    &>> abipy.log

conda config --add channels conda-forge &>> abipy.log
# See https://discourse.abinit.org/t/error-importing-abilab-pymatgen-modulenotfound-error/3267/3
# See https://github.com/abinit/abipy/issues/274
# This combination seems to work
conda install -y pymatgen=2022.0.14     &>> abipy.log
conda install -y abipy=0.9.2            &>> abipy.log
conda install -y monty=2022.1.19        &>> abipy.log
conda install -y ruamel.yaml=0.17.19    &>> abipy.log
conda deactivate                        &>> abipy.log

