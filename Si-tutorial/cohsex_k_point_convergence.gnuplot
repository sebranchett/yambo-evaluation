set terminal png size 500,500
set output '03_cohsex_k_point_convergence.png'
set title 'cohsex_k-point convergence'
set xrange [0:600]
set yrange [4.1:4.65]
set xlabel "Number of K-points in the BZ"
set ylabel "Direct gap [eV]"
plot 'cohsex_direct_gap_vs_kpoints.dat' w lp
