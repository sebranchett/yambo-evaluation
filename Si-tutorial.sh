#!/bin/bash

#SBATCH --job-name=Si-tutorial
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2023r1
module load openmpi
module load openblas
module load fftw
module load netcdf-c  # adds path to LD_LIBRARY_PATH
module load netcdf-fortran  # adds path to LD_LIBRARY_PATH
module load hdf5  # adds path to LD_LIBRARY_PATH
# correct include folder for fftw
export CPATH=/apps/arch/2023r1/software/linux-rhel8-skylake_avx512/gcc-8.5.0/fftw-3.3.10-ltsfu6fub54vzqa64polif6jqx6e2zy5/include:$CPATH
# add the BLAS/LAPACK/FTTW library path:
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/beegfs/apps/generic/intel/oneapi_2022.3/mkl/latest/lib/intel64
# Just to be sure, see QE Prerequisites
export LC_ALL=C

QEDIR=${PWD}/q-e-qe-7.2
YAMBODIR=${PWD}/yambo-5.1.2
export PATH=$PATH:$QEDIR/bin:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

# Reproducint this tutorial:
# https://www.yambo-code.eu/wiki/index.php/Silicon

WORKDIR=${PWD}/Si-tutorial
cd "$WORKDIR"
cd Silicon/PWSCF
srun pw.x < input/scf.in        > newoutput/scf.out

for k in gamma 1 2 4 6 8; do
  if [ $k == "gamma" ]; then
    input_label=gamma
    label=GAMMA
  else
    input_label=${k}x${k}x${k}
    label=${k}x${k}x${k}
  fi
  srun pw.x < input/nscf_${input_label}.in > newoutput/Si_e15.0_k${k}_nb50_gamma.out
  cd Si.save
  srun p2y
  cd ..
  mkdir -p YAMBO/${label}
  mv Si.save/SAVE YAMBO/${label}/
done

# cd "$WORKDIR"
# mv Silicon/PWSCF/Si.save/SAVE/* Silicon/YAMBO/SAVE/
# cd Silicon/YAMBO
# Yambo initialisation
# rm -f r-01_init_setup  # first tidy up
# echo "-o0o-"                             >> ${WORKDIR}/Si-tutorial.log
# srun yambo -F Inputs/01_init -J 01_init &>> ${WORKDIR}/Si-tutorial.log
# echo "-o0o-"                             >> ${WORKDIR}/Si-tutorial.log
# grep "Fermi Level" r-01_init_setup       >> ${WORKDIR}/Si-tutorial.log
# grep "G-vectors" r-01_init_setup         >> ${WORKDIR}/Si-tutorial.log
# 
# # Bethe-Salpeter equation for Excitons
# echo "-o0o-"                             >> ${WORKDIR}/Si-tutorial.log
# srun yambo -F Inputs/06_BSE -J 06_BSE   &>> ${WORKDIR}/Si-tutorial.log
# echo "COMPLETED"                         >> ${WORKDIR}/Si-tutorial.log

