#!/bin/bash

#SBATCH --job-name=Si-tutorial
#SBATCH --partition=compute
#SBATCH --account=innovation
#SBATCH --time=01:00:00
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1GB

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# find your account with:
# sacctmgr list -sp user $USER

module load 2024r1
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

QEDIR=${PWD}/q-e-qe-7.4.1
YAMBODIR=${PWD}/yambo-5.3.0
export PATH=$PATH:$QEDIR/bin:$YAMBODIR/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$YAMBODIR/lib

# Reproducing this tutorial:
# https://www.yambo-code.eu/wiki/index.php/Silicon

WORKDIR=${PWD}/Si-tutorial
cd "$WORKDIR"
mkdir -p Silicon/plots

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

# Hartree-Fock
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
mv "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4/*.png "$WORKDIR"/Silicon/plots/

cd "$WORKDIR"/Silicon/NEW_YAMBO
"$WORKDIR"/parse_gap.sh o-HF_15Ry.hf hf_direct_gap_vs_kpoints.dat
gnuplot "$WORKDIR"/k_point_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# COHSEX
# K-points convergence
for k in GAMMA 2x2x2 4x4x4 6x6x6 8x8x8; do
  cd "$WORKDIR"/Silicon/NEW_YAMBO/${k}
  srun yambo -F Inputs/02Cohsex -J Cohsex_HF7Ry_X0Ry-nb10
done

cd "$WORKDIR"/Silicon/NEW_YAMBO
"$WORKDIR"/parse_gap.sh o-Cohsex_HF7Ry_X0Ry-nb10.qp cohsex_direct_gap_vs_kpoints.dat
gnuplot "$WORKDIR"/cohsex_k_point_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# W size convergence
# NGsBlkXs starts off as 1 RL
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
grep "  5 " o-Cohsex_HF7Ry_X0Ry-nb10.qp | grep " 2.576" | awk '{print "00 " $3+$4 }' > cohsex_w_convergence.dat
for NGsBlkXs in 03 06 07; do
  sed -i "s|NGsBlkXs= 1            RL|NGsBlkXs= ${NGsBlkXs}             Ry|" Inputs/02Cohsex
  srun yambo -F Inputs/02Cohsex -J Cohsex_W_${NGsBlkXs}Ry
  grep "  5 " o-Cohsex_W_${NGsBlkXs}Ry.qp | grep " 2.576" | awk -v NGsBlkXs="$NGsBlkXs" '{print NGsBlkXs " " $3+$4 }' >> cohsex_w_convergence.dat
# set back to 1 RL
  sed -i "s|NGsBlkXs= ..             Ry|NGsBlkXs= 1            RL|" Inputs/02Cohsex
done
gnuplot "$WORKDIR"/cohsex_w_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# W bands convergence
# BndsRnXs starts off as 1 - 10
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
sed -i "s|NGsBlkXs= 1            RL|NGsBlkXs= 1            Ry|" Inputs/02Cohsex
rm -f cohsex_w_bands_convergence.dat
for BndsRnXs in 20 30 40 50; do
  sed -i "/BndsRnXs/{n;s|  1 . .0|  1 \| ${BndsRnXs}|}" Inputs/02Cohsex
  srun yambo -F Inputs/02Cohsex -J Cohsex_W_${BndsRnXs}_bands
  grep "  5 " o-Cohsex_W_${BndsRnXs}_bands.qp | grep " 2.576" | awk -v BndsRnXs="$BndsRnXs" '{print BndsRnXs " " $3+$4 }' >> cohsex_w_bands_convergence.dat
# set back to 1 - 10
  sed -i "/BndsRnXs/{n;s|  1 . .0|  1 \| 10|}" Inputs/02Cohsex
done
sed -i "s|NGsBlkXs= 1            Ry|NGsBlkXs= 1            RL|" Inputs/02Cohsex

gnuplot "$WORKDIR"/cohsex_w_bands_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# Empty bands convergence
# GbndRnge starts off as 1 - 10
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
sed -i "s|NGsBlkXs= 1            RL|NGsBlkXs= 1            Ry|" Inputs/02Cohsex
sed -i "s|#UseEbands|UseEbands|" Inputs/02Cohsex
rm -f cohsex_empty_bands_convergence.dat
for GbndRnge in 10 20 30 40 50; do
  sed -i "/GbndRnge/{n;s|  1 . .0|  1 \| ${GbndRnge}|}" Inputs/02Cohsex
  srun yambo -F Inputs/02Cohsex -J Cohsex_empty_${GbndRnge}_bands
  grep "  5 " o-Cohsex_empty_${GbndRnge}_bands.qp | grep " 2.576" | awk -v GbndRnge="$GbndRnge" '{print GbndRnge " " $3+$4 }' >> cohsex_empty_bands_convergence.dat
  sed -i "/GbndRnge/{n;s|  1 . .0|  1 \| 10|}" Inputs/02Cohsex
done
# set back to 1 - 10
sed -i "s|NGsBlkXs= 1            Ry|NGsBlkXs= 1            RL|" Inputs/02Cohsex
sed -i "s|UseEbands|#UseEbands|" Inputs/02Cohsex

gnuplot "$WORKDIR"/cohsex_empty_bands_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# G0W0
# K-points convergence
for k in GAMMA 2x2x2 4x4x4 6x6x6 8x8x8; do
  cd "$WORKDIR"/Silicon/NEW_YAMBO/${k}
# NGsBlkXp starts off as 1 RL
  sed -i "s|NGsBlkXp= 1            RL|NGsBlkXp= 1            Ry|" Inputs/03GoWo_PPA_corrections
  rm -f o-G0W0_HF7Ry_X0Ry-nb10.qp
  srun yambo -F Inputs/03GoWo_PPA_corrections -J G0W0_HF7Ry_X0Ry-nb10
# set back to 1 RL
  sed -i "s|NGsBlkXp= 1            Ry|NGsBlkXp= 1            RL|" Inputs/03GoWo_PPA_corrections
done

cd "$WORKDIR"/Silicon/NEW_YAMBO
"$WORKDIR"/parse_gap.sh o-G0W0_HF7Ry_X0Ry-nb10.qp G0W0_direct_gap_vs_kpoints.dat
gnuplot "$WORKDIR"/G0W0_k_point_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# W size convergence
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
rm -f G0W0_w_convergence.dat
for NGsBlkXp in 01 03 06 07; do
  sed -i "s|NGsBlkXp= 1            RL|NGsBlkXp= ${NGsBlkXp}             Ry|" Inputs/03GoWo_PPA_corrections
  rm -f o-G0W0_W_${NGsBlkXp}Ry.qp
  srun yambo -F Inputs/03GoWo_PPA_corrections -J G0W0_W_${NGsBlkXp}Ry
  grep "  5 " o-G0W0_W_${NGsBlkXp}Ry.qp | grep " 2.576" | awk -v NGsBlkXp="$NGsBlkXp" '{print NGsBlkXp " " $3+$4 }' >> G0W0_w_convergence.dat
  sed -i "s|NGsBlkXp= ..             Ry|NGsBlkXp= 1            RL|" Inputs/03GoWo_PPA_corrections
done
gnuplot "$WORKDIR"/G0W0_w_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# W bands convergence
# BndsRnXp starts off as 1 - 10
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
sed -i "s|NGsBlkXp= 1            RL|NGsBlkXp= 1            Ry|" Inputs/03GoWo_PPA_corrections
rm -f G0W0_w_bands_convergence.dat
for BndsRnXp in 10 20 30 40 50; do
  sed -i "/BndsRnXp/{n;s|  1 . .0|  1 \| ${BndsRnXp}|}" Inputs/03GoWo_PPA_corrections
  rm -f o-G0W0_W_${BndsRnXp}_bands.qp
  srun yambo -F Inputs/03GoWo_PPA_corrections -J G0W0_W_${BndsRnXp}_bands
  grep "  5 " o-G0W0_W_${BndsRnXp}_bands.qp | grep " 2.576" | awk -v BndsRnXp="$BndsRnXp" '{print BndsRnXp " " $3+$4 }' >> G0W0_w_bands_convergence.dat
  sed -i "/BndsRnXp/{n;s|  1 . ${BndsRnXp}|  1 \| 10|}" Inputs/03GoWo_PPA_corrections
done
# set back to 1 - 10
sed -i "s|NGsBlkXp= 1            Ry|NGsBlkXp= 1            RL|" Inputs/03GoWo_PPA_corrections

gnuplot "$WORKDIR"/G0W0_w_bands_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# Empty bands convergence
# GbndRnge starts off as 1 - 10
cd "$WORKDIR"/Silicon/NEW_YAMBO/4x4x4
sed -i "s|NGsBlkXp= 1            RL|NGsBlkXp= 1            Ry|" Inputs/03GoWo_PPA_corrections
sed -i "s|#UseEbands|UseEbands|" Inputs/03GoWo_PPA_corrections
rm -f G0W0_empty_bands_convergence.dat
for GbndRnge in 10 20 30 40 50; do
  sed -i "/GbndRnge/{n;s|  1 . .0|  1 \| ${GbndRnge}|}" Inputs/03GoWo_PPA_corrections
  rm -f o-G0W0_empty_${GbndRnge}_bands.qp
  srun yambo -F Inputs/03GoWo_PPA_corrections -J G0W0_empty_${GbndRnge}_bands
  grep "  5 " o-G0W0_empty_${GbndRnge}_bands.qp | grep " 2.576" | awk -v GbndRnge="$GbndRnge" '{print GbndRnge " " $3+$4 }' >> G0W0_empty_bands_convergence.dat
  sed -i "/GbndRnge/{n;s|  1 . .0|  1 \| 10|}" Inputs/03GoWo_PPA_corrections
done
# set back to 1 - 10
sed -i "s|NGsBlkXp= 1            Ry|NGsBlkXp= 1            RL|" Inputs/03GoWo_PPA_corrections
sed -i "s|UseEbands|#UseEbands|" Inputs/03GoWo_PPA_corrections

gnuplot "$WORKDIR"/G0W0_empty_bands_convergence.gnuplot
mv *.png "$WORKDIR"/Silicon/plots/

# Final run with converged parameters
cd "$WORKDIR"/Silicon/NEW_YAMBO/8x8x8
srun yambo -F Inputs/04GoWo_converged -J G0W0_Converged

echo "Direct gap is:" > converged_results.dat
grep "  5 " o-G0W0_Converged.qp | grep " 2.576" | awk '{print $3+$4 }' >> converged_results.dat

VAL_HIGH=$(grep '            4  ' o-G0W0_Converged.qp | awk '{print $3+$4 }' | sort -n | tail -1)
CON_LOW=$(grep '            5  ' o-G0W0_Converged.qp | awk '{print $3+$4 }' | sort -n | head -1)
echo "Indirect gap is:" >> converged_results.dat
echo "$CON_LOW - $VAL_HIGH" | bc >> converged_results.dat

