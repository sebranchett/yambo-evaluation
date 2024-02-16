set terminal png size 500,500
set output '05_cohsex_w_bands_convergence.png'
set title 'cohsex W bands convergence'
set xrange [20:50]
set yrange [2.92:3.0]
set xlabel "W bands"
set ylabel "Direct gap [eV]"
plot 'cohsex_w_bands_convergence.dat' w lp
