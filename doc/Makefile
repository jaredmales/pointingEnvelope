
doc: git_version pointingEnv.pdf 

bib: git_version
	pdflatex pointingEnv.tex 
	bibtex pointingEnv.aux
	pdflatex pointingEnv.tex
	pdflatex pointingEnv.tex
	
plots = ../plots/out_T0-1kHzComp.pdf \
        ../plots/out_T0-3000.pdf \
        ../plots/out_T0-1000.pdf \
        ../plots/out_T0-300.pdf \
        ../plots/out_T0-100.pdf \
        ../plots/out_T0-30.pdf \
        ../plots/out_T0-10.pdf \
        ../plots/out_T0-1.pdf
        
pointingEnv.pdf: pointingEnv.tex $(plots)
	pdflatex pointingEnv.tex
	
	
.PHONY: git_version
git_version:
	@bash ../gengitversion.sh ../ ../git_version.txt
	
.PHONY: clean
clean:
	rm -f pointingEnv.aux
	rm -f pointingEnv.bbl
	rm -f pointingEnv.blg
	rm -f pointingEnv.log
	rm -f pointingEnv.out
	rm -f pointingEnv.pdf
