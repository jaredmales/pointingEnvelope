
doc: git_version pointingEnv.pdf

bib: git_version
	pdflatex pointingEnv.tex
	bibtex pointingEnv.aux
	pdflatex pointingEnv.tex
	pdflatex pointingEnv.tex

plots = ../plots/3m_10nm_0mag_out_T0-100HzComp.pdf \
	 ../plots/3m_10nm_0mag_out_T0_3000.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_1000.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_300.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_100.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_30.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_10.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_3.000000.pdf \
	 ../plots/3m_10nm_0mag_out_T0_1.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0-100HzComp.pdf \
	 ../plots/3m_10nm_5mag_out_T0_3000.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_1000.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_300.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_100.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_30.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_10.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_3.000000.pdf \
	 ../plots/3m_10nm_5mag_out_T0_1.000000.pdf \

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
