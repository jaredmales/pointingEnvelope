

all: out_T0-1kHzComp.pdf out_T0-3000.pdf out_T0-1000.pdf out_T0-300.pdf out_T0-100.pdf out_T0-30.pdf out_T0-10.pdf out_T0-3.pdf out_T0-1.pdf

dats = ../output/out_T0-3000.dat \
       ../output/out_T0-1000.dat \
       ../output/out_T0-300.dat \
       ../output/out_T0-100.dat \
       ../output/out_T0-30.dat \
       ../output/out_T0-3.dat \
       ../output/out_T0-1.dat

out_T0-1kHzComp.pdf: out_T0-1kHzComp.gp out_T0-worker.gp $(dats) 
	gnuplot out_T0-1kHzComp.gp
	
out_T0-3000.pdf: out_T0-3000.gp out_T0-worker.gp ../output/out_T0-3000.dat
	gnuplot out_T0-3000.gp
	
out_T0-1000.pdf: out_T0-1000.gp out_T0-worker.gp ../output/out_T0-1000.dat
	gnuplot out_T0-1000.gp
	
out_T0-300.pdf: out_T0-300.gp out_T0-worker.gp ../output/out_T0-300.dat
	gnuplot out_T0-300.gp
	
out_T0-100.pdf: out_T0-100.gp out_T0-worker.gp ../output/out_T0-100.dat
	gnuplot out_T0-100.gp

out_T0-30.pdf: out_T0-30.gp out_T0-worker.gp ../output/out_T0-30.dat
	gnuplot out_T0-30.gp
	
out_T0-10.pdf: out_T0-10.gp out_T0-worker.gp ../output/out_T0-10.dat
	gnuplot out_T0-10.gp
	
out_T0-3.pdf: out_T0-3.gp out_T0-worker.gp ../output/out_T0-3.dat
	gnuplot out_T0-3.gp
	
out_T0-1.pdf: out_T0-1.gp out_T0-worker.gp ../output/out_T0-1.dat
	gnuplot out_T0-1.gp
	
.PHONY: clean
clean:
	rm -f *.pdf
	

	
	
