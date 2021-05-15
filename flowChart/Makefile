
all: git_version flowChart.pdf 

flowChart.pdf: flowChart.tex 
	pdflatex flowChart.tex
	
.PHONY: git_version
git_version:
	@bash ../gengitversion.sh ../ ../git_version.txt
	
.PHONY: clean 
clean:
	rm -f flowChart.aux
	rm -f flowChart.log
	rm -f flowChart.pdf
