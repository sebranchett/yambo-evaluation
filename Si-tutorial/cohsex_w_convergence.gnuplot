set terminal png size 500,500
set output '04_cohsex_w_convergence.png'
set title 'cohsex W size convergence'
set xrange [0:7]
set yrange [2.2:4.4]
set xlabel "W size [Ry]"
set ylabel "Direct gap [eV]"
plot 'cohsex_w_convergence.dat' w lp
