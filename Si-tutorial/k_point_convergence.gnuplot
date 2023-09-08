set terminal png size 500,500
set output 'k_point_convergence.png'
set title 'k-point convergence'
set xrange [0:600]
set yrange [7.5:13]
set xlabel "Number of K-points in the BZ"
set ylabel "Direct HF gap [eV]"
plot 'hf_direct_gap_vs_kpoints.dat' using 1:2 w p
