set terminal png size 500,500
set output '10_G0W0_k_point_convergence.png'
set title 'G0W0_k-point convergence'
set xrange [0:600]
set yrange [3.9:4.7]
set xlabel "Number of K-points in the BZ"
set ylabel "Direct gap [eV]"
plot 'G0W0_direct_gap_vs_kpoints.dat' w lp
