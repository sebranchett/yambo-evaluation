set terminal png size 500,500
set output '08_G0W0_w_bands_convergence.png'
set title 'G0W0 W bands convergence'
set xrange [10:50]
set yrange [4.24:4.44]
set xlabel "W bands"
set ylabel "Direct gap [eV]"
plot 'G0W0_w_bands_convergence.dat' w lp
