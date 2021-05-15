# Pointing Envelope Analysis

This repo contains the code for analyzing the allowable pointing PSD envelope to achieve the coronagraph pointing requirement.

## Building the doc

You will need Jared's [gnuplotUtils] (https://github.com/jaredmales/gnuplotUtils) with `GNUPLOT_LIB` configured in the environment variables.

You will need `pdflatex` installed.

Typing `make` in the top level directory should build all figures and compile the latex.  The result will be `doc/pointingEnv.pdf`.

`make clean` will remove all output files, includes pdfs, except in the `src` directory.

## Building the src and recalculating

You will need [mxlib](https://github.com/jaredmales/mxlib) installed with `MXMAKEFILE` configured in the environment variables.

In `src`, type make.

Run `bash ./runall.sh` to recalculate the data files.  Note that this will cause the git repo to be modified. To record the new data for proper version control, commit the new files.  The re-build the doc from the top-level directory as above.

## git Tracking

All data files, figures, and the documentation have the git repo state recorded at the time of their creation.  This allows restoring the git repo to the state of any result.  Note, however, that if the git repo is modified the modifications are not recorded.  As such, all changes should be committed before building the doc for distribution.
