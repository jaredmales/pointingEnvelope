#############
# call with, e.g., gnuplot -c outT0.gp 617.0 3.0 3m_10nm_0mag 1.000000
#############
lambda = ARG1
D=ARG2
subdir = ARG3

T0str = ARG4

gpoutname= sprintf("%s_out_T0_%s", subdir, T0str)

load 'pdf_startup.gp'

fname = sprintf("../output/%s/out_T0-%s.dat", subdir, T0str)
T0lab = sprintf("$T_o$ = %0.2f sec" , T0str+0)

lamD = 0.2063*(lambda*1e-3)/D


set terminal epslatex  color standalone dashed size 7,4. header "\\usepackage[dvipsnames]{xcolor}\n\\definecolor{myblue}{RGB}{88, 131, 225}"
set termoption font 'ptm,10'
set lmargin at screen 0.125
set rmargin at screen 0.85
set tmargin at screen 0.925
set bmargin at screen 0.125

set title 'Coronagraph FSM Loop Speed Requirement'

set xr[1:6]
set xlabel 'PSD Slope $\alpha$'

set yr [0.005:0.5]
set ylabel 'Input Pointing [arcsec rms]'

set ytics ('0.005' 0.005 2,'0.006' 0.006 1, '0.007' 0.007 1, '0.008' 0.008 1, '0.009' 0.009 1, \
           '0.01' 0.01 2, '0.02' 0.02 1, '0.03' 0.03 1, '0.04' 0.04 1, '0.05' 0.05 1, \
           '0.06' 0.06 1, '0.07' 0.07 1, '0.08' 0.08 1, '0.09' 0.09 1, \
           '0.1' 0.1, '0.2' 0.2 1, '0.3' 0.3 1, '0.4' 0.4 1, '0.5' 0.5)

#set yr [1.0:1000.0]
#set ylabel 'Input Disturbance [nm rms]'


set zlabel 'Required Loop Freq [Hz]'
set cblabel 'Required Loop Freq [Hz]' rotate by -90

set colorbox user origin screen 0.86,0.125 size screen 0.025,0.8

set zr [0.25:20000]

set cbr [0.25:2000]

set logsc z
set logsc y
set logsc cb

cntcol="#5883e1"

set linetype 1 lc rgb cntcol lw 2 dt 1
set linetype 2 lc rgb cntcol lw 2 dt 1
set linetype 3 lc rgb cntcol lw 2 dt 1
set linetype 4 lc rgb cntcol lw 2 dt 1
set linetype 5 lc rgb cntcol lw 2 dt 1
set linetype 6 lc rgb cntcol lw 2 dt 1
set linetype 7 lc rgb cntcol lw 2 dt 1
set linetype 8 lc rgb cntcol lw 2 dt 1

set cntrparam linear firstlinetype 1 levels discrete 10,50,200,100,500
set contour surface

pltdir=system("echo $GNUPLOT_LIB")
print pltdir
pltfile= sprintf("%spalettes/%s", pltdir, "matlab_bone.plt")
print pltfile
set palette file pltfile

set pm3d interpolate 5,5 clipcb

set view map

set cntrlabel start 5 int -1
set cntrlabel format '\textcolor{myblue}{%h Hz}'

unset key

set mxtics 5
set grid ytics mytics xtics mxtics

set label 1 T0lab at 1.1,0.45 front
set label 4000 "\\tiny{\\input{../git_version.txt}}" at 5.0,0.003

set surface explicit
set hidden3d

splot fname u 1:(4*($2/lambda)*lamD):3 with pm3d at b t '', \
      fname u 1:(4*($2/lambda)*lamD):3 with lines t ''

#      fname u 1:(4*($2/lambda)*lamD):3 with labels nohidden3d t ''


load 'pdf_shutdown.gp'
