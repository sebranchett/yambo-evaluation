#!/bin/bash

#SBATCH --job-name=Si-tutorial
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=00:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas
module load fftw
export CPATH=$FFTW_ROOT/include:$CPATH
module load hdf5
module load netcdf-c
module load netcdf-fortran
module load gnuplot
# see QE Prerequisites
export LC_ALL=C

QEDIR=/scratch/sbranchett/yambo-evaluation/q-e-qe-7.2
YAMBODIR=${PWD}/yambo-5.2.0
export PATH=$PATH:$QEDIR/bin:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

# Reproducing this tutorial:
# https://www.yambo-code.eu/wiki/index.php/Silicon

WORKDIR=${PWD}/Si-tutorial
cd "$WORKDIR"

# DFT with Quantum Espresso
cd Silicon/PWSCF
mkdir -p newoutput
srun pw.x < input/scf.in        > newoutput/scf.out

for k in gamma 1 2 4 6 8; do
  if [ $k == "gamma" ]; then
    input_label=gamma
    dir_label=GAMMA
    output_label=gamma
  else
    input_label=${k}x${k}x${k}
    dir_label=${k}x${k}x${k}
    output_label=k${k}
  fi
  srun pw.x < input/nscf_${input_label}.in > newoutput/Si_e15.0_${output_label}_nb50_gamma.out
  cd Si.save
  srun p2y
  cd ..
  mkdir -p YAMBO/${dir_label}
  mv Si.save/SAVE YAMBO/${dir_label}/
done

# K-points convergence
cd "$WORKDIR"/Silicon
mv PWSCF/YAMBO/ NEW_YAMBO
for k in GAMMA 2x2x2 4x4x4 6x6x6 8x8x8; do
  # copy Inputs to newly created YAMBO DBs and initialise
  cd "$WORKDIR"/Silicon
  cp -r YAMBO/${k}/Inputs NEW_YAMBO/${k}/Inputs
  cd "$WORKDIR"/Silicon/NEW_YAMBO/${k}
  srun yambo -F Inputs/00_init -J 00_init

  # G-vectors convergence
  for Gvec_xSE in 03 06 07 15; do
    sed -i "s|EXXRLvcs= ....|EXXRLvcs= ${Gvec_xSE}  |" Inputs/01HF_corrections
    srun yambo -F Inputs/01HF_corrections -J HF_${Gvec_xSE}Ry
  done
  gnuplot "$WORKDIR"/hf_vs_cutoff.gnuplot
done

cd "$WORKDIR"/Silicon/NEW_YAMBO
"$WORKDIR"/parse_gap.sh o-HF_15Ry.hf hf_direct_gap_vs_kpoints.dat
gnuplot "$WORKDIR"/k_point_convergence.gnuplot

