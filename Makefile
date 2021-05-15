
all:
	${MAKE} -C plots
	${MAKE} -C flowChart
	${MAKE} -C doc bib 
		
.PHONY: clean
clean:
	${MAKE} -C plots clean
	${MAKE} -C flowChart clean
	${MAKE} -C doc clean
