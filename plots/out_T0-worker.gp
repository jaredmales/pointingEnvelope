


gpoutname= sprintf("out_T0-%s", T0str)

load 'pdf_startup.gp'

fname = sprintf("../output/out_T0-%s.dat", T0str)
T0lab = sprintf("$T_o$ = %s sec" , T0str)

D = 2.6

set terminal epslatex  color standalone dashed size 7,4. header "\\usepackage[dvipsnames]{xcolor}\n\\definecolor{myblue}{RGB}{88, 131, 225}"
set termoption font 'ptm,10'
set lmargin at screen 0.125
set rmargin at screen 0.85
set tmargin at screen 0.925
set bmargin at screen 0.125

set title 'Coronagraph FSM Spacecraft Pointing Requirement' 
set xlabel 'PSD Slope $\alpha$'

set yr [0.01:0.5]
set ylabel 'Input Pointing [arcsec rms]'
#set yr [1.0:1000.0]
#set ylabel 'Input Disturbance [nm rms]'


set zlabel 'Required Loop Freq [Hz]'
set cblabel 'Required Loop Freq [Hz]' rotate by -90

set colorbox user origin screen 0.86,0.125 size screen 0.025,0.8

set zr [0.25:20000]


set ytics ('0.01' 0.01 2, '0.02' 0.02 1, '0.03' 0.03 1, '0.04' 0.04 1, '0.05' 0.05 1, '0.06' 0.06 1, '0.07' 0.07 1, '0.08' 0.08 1, '0.09' 0.09 1, '0.1' 0.1, '0.2' 0.2 1, '0.3' 0.3 1, '0.4' 0.4 1, '0.5' 0.5)

#set mytics 10
#('0.02' 0.02, '0.03' 0.03, '0.04' 0.04)

set cbr [0.25:2000]

set logsc z
set logsc y
set logsc cb

cntcol="#5883e1"
#"#3A5795"

set linetype 1 lc rgb cntcol lw 2 dt 1
set linetype 2 lc rgb cntcol lw 2 dt 1
set linetype 3 lc rgb cntcol lw 2 dt 1
set linetype 4 lc rgb cntcol lw 2 dt 1
set linetype 5 lc rgb cntcol lw 2 dt 1
set linetype 6 lc rgb cntcol lw 2 dt 1
set linetype 7 lc rgb cntcol lw 2 dt 1
set linetype 8 lc rgb cntcol lw 2 dt 1

set cntrparam linear firstlinetype 1 levels discrete 1,3,10,30,100,c300,1000,c3000
set contour base

pltdir = '/home/jrmales/Source/gnuplot/palettes/'
pltfile= sprintf("%s%s", pltdir, "matlab_bone.plt")
#pltfile= sprintf("%s%s", pltdir, "ch05m151008.gpf")
#pltfile= sprintf("%s%s", pltdir, "ch20m151010.gpf")
#pltfile= sprintf("%s%s", pltdir, "cool-warm.gpf")
#pltfile= sprintf("%s%s", pltdir, "viridis.gpf")
set palette file pltfile

#set pm3d interpolate 5,10 clipcb clip1in
set pm3d interpolate 5,5 clipcb
#clipcb clip1in

set view map

set cntrlabel start 5 int -1
set cntrlabel format '\textcolor{myblue}{%h Hz}'
#unset key 
unset key 
#top left
#outside bottom horizontal
set mxtics 5
set grid ytics mytics xtics mxtics

set label 1 T0lab at 1.1,0.45
set label 4000 "\\tiny{\\input{../git_version.txt}}" at 6.5,0.006

splot fname u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 with pm3d at b t '', fname u 1:(206265 * atan(2.0*($2*1e-9)/D)):3 with labels t ''

#set label 1 T0lab at 1.1,800
#splot fname u 1:2:3 with pm3d at b t '', fname u 1:2:3 with labels t ''

load 'pdf_shutdown.gp'
