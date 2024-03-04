set terminal png size 500,500
set output 'comparison.png'
set title 'BSE in lithium-floride tutorial'
set xrange [7.5:25]
set yrange [0:12]
set xlabel "E[1] [eV]"
set ylabel "Im(eps)"
plot 'o-02_RPA_no_LF.eps_q1_inv_rpa_dyson' using 1:2 w l \
   , 'o-03_RPA_LF_QP.eps_q1_inv_rpa_dyson' using 1:2 w l \
   , 'o-04_alda_g_space.eps_q1_inv_rpa_dyson' using 1:2 w l \
   , 'o-06_BSE.eps_q1_haydock_bse' using 1:2 w l \
   , 'o-07_LRC.eps_q1_inv_rpa_dyson' using 1:2 w l
