set terminal png size 500,500
set output '09_G0W0_empty_bands_convergence.png'
set title 'G0W0 empty bands convergence'
set xrange [10:50]
set yrange [3.6:4.3]
set xlabel "G bands"
set ylabel "Direct gap [eV]"
plot 'G0W0_empty_bands_convergence.dat' w lp
