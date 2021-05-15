


gpoutname = 'out_T0-1kHzComp' 
#sprintf("out_T0-%s", T0str)

load 'pdf_startup.gp'

#fname = sprintf("../output/out_T0-%s.dat", T0str)
#T0lab = sprintf("$T_o$ = %s sec" , T0str)

D = 2.6

set terminal epslatex  color standalone dashed size 7,4. header "\\usepackage[dvipsnames]{xcolor}\n\\definecolor{myblue}{RGB}{88, 131, 225}"
set termoption font 'ptm,10'
set lmargin at screen 0.125
set rmargin at screen 0.85
set tmargin at screen 0.925
set bmargin at screen 0.125

set title 'Coronagraph 1 kHz FSM Spacecraft Pointing Requirement' 
set xlabel 'PSD Slope $\alpha$'

set yr [0.01:0.5]
set ylabel 'Input Pointing [arcsec rms]'
#set yr [1.0:1000.0]
#set ylabel 'Input Disturbance [nm rms]'


set zlabel 'Required Loop Freq [Hz]'
set cblabel 'Required Loop Freq [Hz]' rotate by -90

set colorbox user origin screen 0.86,0.125 size screen 0.025,0.8
unset colorbox

set zr [0.25:20000]


set ytics ('0.01' 0.01 2, '0.02' 0.02 1, '0.03' 0.03 1, '0.04' 0.04 1, '0.05' 0.05 1, '0.06' 0.06 1, '0.07' 0.07 1, '0.08' 0.08 1, '0.09' 0.09 1, '0.1' 0.1, '0.2' 0.2 1, '0.3' 0.3 1, '0.4' 0.4 1, '0.5' 0.5)

#set mytics 10
#('0.02' 0.02, '0.03' 0.03, '0.04' 0.04)

set cbr [0.25:2000]

set logsc z
set logsc y
set logsc cb

cntcol="black"
#"#3A5795"

set linetype 1 lc rgb cntcol lw 2 dt 1
set linetype 2 lc rgb cntcol lw 2 dt 1
set linetype 3 lc rgb cntcol lw 2 dt 1
set linetype 4 lc rgb cntcol lw 2 dt 1
set linetype 5 lc rgb cntcol lw 2 dt 1
set linetype 6 lc rgb cntcol lw 2 dt 1
set linetype 7 lc rgb cntcol lw 2 dt 1
set linetype 8 lc rgb cntcol lw 2 dt 1

set cntrparam linear firstlinetype 1 levels discrete 1000
set contour base

pltdir = '/home/jrmales/Source/gnuplot/palettes/'
pltfile= sprintf("%s%s", pltdir, "matlab_bone.plt")
set palette file pltfile


set view map
unset surface

#set cntrlabel start 5 int -1
set cntrlabel format ''

#unset key 
unset key 
#top left
#outside bottom horizontal
set mxtics 5
set grid ytics mytics xtics mxtics

set label 1 '$T_0=1$ sec' at 6,0.025
set label 2 '$T_0=3$ sec' at 5.5,0.075
set label 3 '$T_0=10$ sec' at 5,0.2 rotate by 10
set label 4 '$T_0=30$ sec' at 3.2,0.2 rotate by 50
set label 5 '$T_0=100$ sec' at 2.75,0.2 rotate by 60
set label 6 '$T_0=3000$ sec' at 2.2,0.18 rotate by 80

splot '../output/out_T0-3000.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l t '3000 sec', \
      '../output/out_T0-1000.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '1000 sec', \
      '../output/out_T0-300.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '300 sec', \
      '../output/out_T0-100.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '100 sec', \
      '../output/out_T0-30.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '30 sec', \
      '../output/out_T0-10.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '10 sec', \
      '../output/out_T0-3.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '3 sec', \
      '../output/out_T0-1.dat' u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 w l dt 2 t '1 sec'
      
#set label 1 T0lab at 1.1,800
#splot fname u 1:2:3 with pm3d at b t '', fname u 1:2:3 with labels t ''

load 'pdf_shutdown.gp'
