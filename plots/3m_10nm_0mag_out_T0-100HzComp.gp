
gpoutname = '3m_10nm_0mag_out_T0-100HzComp'

load 'pdf_startup.gp'

lambda = 617.0
D=6.5
lamD = 0.2063*(lambda*1e-3)/3.0

set terminal epslatex  color standalone dashed size 7,4. header "\\usepackage[dvipsnames]{xcolor}\n\\definecolor{myblue}{RGB}{88, 131, 225}"
set termoption font 'ptm,10'
set lmargin at screen 0.125
set rmargin at screen 0.95
set tmargin at screen 0.925
set bmargin at screen 0.125

set title 'Coronagraph 100 Hz FSM Pointing Requirement'

set xr [1:6]
set xlabel 'PSD Slope $\alpha$'

set yr [0.005:0.5]
set ylabel 'Input Pointing [arcsec rms]'

unset colorbox

set zr [0.25:20000]

set ytics ('0.005' 0.005 2,'0.006' 0.006 1, '0.007' 0.007 1, '0.008' 0.008 1, '0.009' 0.009 1, \
           '0.01' 0.01 2, '0.02' 0.02 1, '0.03' 0.03 1, '0.04' 0.04 1, '0.05' 0.05 1, \
           '0.06' 0.06 1, '0.07' 0.07 1, '0.08' 0.08 1, '0.09' 0.09 1, \
           '0.1' 0.1, '0.2' 0.2 1, '0.3' 0.3 1, '0.4' 0.4 1, '0.5' 0.5)

set cbr [0.25:2000]

set logsc z
set logsc y
set logsc cb

cntcol="black"

set linetype 1 lc rgb cntcol lw 2 dt 1
set linetype 2 lc rgb "grey" lw 2 dt 2
set linetype 3 lc rgb cntcol lw 2 dt 1
set linetype 4 lc rgb cntcol lw 2 dt 1
set linetype 5 lc rgb cntcol lw 2 dt 1
set linetype 6 lc rgb cntcol lw 2 dt 1
set linetype 7 lc rgb cntcol lw 2 dt 1
set linetype 8 lc rgb cntcol lw 2 dt 1
set linetype 9 lc rgb cntcol lw 2 dt 2


set cntrparam linear firstlinetype 1 levels discrete 100
set contour base

pltdir = '/home/jrmales/Source/gnuplotUtils/palettes/'
pltfile= sprintf("%s%s", pltdir, "matlab_bone.plt")
set palette file pltfile


set view map
unset surface

set cntrlabel format ''

unset key

set mxtics 5
set grid ytics mytics xtics mxtics

set label 1 '$T_0=1$ sec' at 5,0.028 rotate by 12
set label 2 '$T_0=3$ sec' at 4.8,0.095 rotate by 14
set label 3 '$T_0=10$ sec' at 4.1,0.25 rotate by 19
set label 4 '$T_0=30$ sec' at 2.92,0.18 rotate by 48
set label 5 '$T_0=100$ sec' at 2.48,0.18 rotate by 58
set label 6 '$T_0=3000$ sec' at 1.87,0.15 rotate by 70

set label 4000 "\\tiny{\\input{../git_version.txt}}" at 5.0,0.003

splot '../output/3m_10nm_0mag/out_T0-3000.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-1000.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-300.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-100.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-30.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-10.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-3.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l, \
      '../output/3m_10nm_0mag/out_T0-1.000000.dat' u 1:(4*($2/lambda)*lamD):3 w l

load 'pdf_shutdown.gp'
