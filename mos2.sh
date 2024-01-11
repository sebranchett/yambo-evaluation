#!/bin/bash

#SBATCH --job-name=MoS2-parallel
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=23:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4GB

# find your account with:
# sacctmgr list -sp user $USER
# #SBATCH --account=research-uco-ict

module load 2023r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH
module load hdf5
module load netcdf-c
module load netcdf-fortran
module load gnuplot
# See QE Prerequisites
export LC_ALL=C

QEDIR=/scratch/sbranchett/yambo-evaluation/q-e-qe-7.2
YAMBODIR=/scratch/sbranchett/parallel-yambo/yambo-5.2.0
export PATH=$PATH:$QEDIR/bin:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

# Reproducing this paper:
# https://www.pnas.org/doi/full/10.1073/pnas.2010110118
# Evidence of ideal excitonic insulator in bulk MoS2 under pressure
# Input file generated using AMS for Quantum Espresso
# Pseudopotentials from https://www.physics.rutgers.edu/gbrv/

WORKDIR=${PWD}/MoS2
cd "$WORKDIR"

# DFT with Quantum Espresso
mkdir -p output
# scf
# srun pw.x < mos2-scf.in > output/mos2-scf.out
# bands - for the graph
# srun pw.x < mos2-bands.in > output/mos2-bands.out
# nscf
# srun pw.x < mos2-nscf.in > output/mos2-nscf.out

# Convert Quantum Espresso output to Yambo input
# cd MoS2.save
# srun p2y > ../output/mos2-p2y.out
# cd ..

# Copy the converted Qantum Espresso DFT data
srun -n1 cp -rf ../../pnas/small/MoS2.save/SAVE SAVE

# Create initialisation file with:
# srun -n1 yambo -i -V RL -F init.in
# and run it:
srun yambo -F init.in -J output/init.out

# Create GW input file with:
# srun -n1 yambo -p p -F gwppa.in
# Changed manually and then run:
srun yambo -F gwppa.in -J output/gwppa.out

