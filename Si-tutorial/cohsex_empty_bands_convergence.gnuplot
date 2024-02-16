set terminal png size 500,500
set output '06_cohsex_empty_bands_convergence.png'
set title 'cohsex empty bands convergence'
set xrange [10:50]
set yrange [3.2:4.8]
set xlabel "G bands"
set ylabel "Direct gap [eV]"
plot 'cohsex_empty_bands_convergence.dat' w lp
