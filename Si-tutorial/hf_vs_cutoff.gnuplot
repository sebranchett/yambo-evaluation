set terminal png size 500,500
set output '01_G-vectors-convergence.png'
set title 'G-vectors convergence'
set xrange [-2:8]
set yrange [-6:10]
set xlabel "Eo [eV]"
set ylabel "E_hf-Eo [eV]"
plot 'o-HF_03Ry.hf' using 3:($4-$3) w p title "3Ry" \
   , 'o-HF_06Ry.hf' using 3:($4-$3) w p title "6Ry" \
   , 'o-HF_07Ry.hf' using 3:($4-$3) w p title "7Ry" \
   , 'o-HF_15Ry.hf' using 3:($4-$3) w p title "15Ry"
