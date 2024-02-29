set terminal png size 500,500
set output '07_G0W0_w_convergence.png'
set title 'G0W0 W size convergence'
set xrange [1:7]
set yrange [4.18:4.25]
set xlabel "W size [Ry]"
set ylabel "Direct gap [eV]"
plot 'G0W0_w_convergence.dat' w lp
