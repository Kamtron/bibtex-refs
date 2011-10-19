
.SUFFIXES :

.SUFFIXES : .tex .dvi .ps .pdf .bib

.PHONEY : default dvi ps pdf clean clobber push pull

REPORTS = all mike_park_publications

default: bib pdf

ps: $(REPORTS:%=%.ps)

pdf: $(REPORTS:%=%.pdf)

bib: $(REPORTS:%=%.bib)

.tex.bib:
	latex $*
	bibtex $*

.tex.dvi:
	latex $*
	grep 'There were undefined references' $*.log > /dev/null && \
	   bibtex $* && latex $* || true
	grep Rerun $*.log > /dev/null && latex $* || true
	grep Rerun $*.log > /dev/null && latex $* || true

.dvi.ps:
	dvips -o $*.ps $*.dvi

.tex.pdf:
	pdflatex $*
	grep 'There were undefined references' $*.log > /dev/null && \
	   bibtex $* && latex $* || true
	grep Rerun $*.log > /dev/null && pdflatex $* || true
	grep Rerun $*.log > /dev/null && pdflatex $* || true

gv: ps
	( gv -w $(SHOW).ps || gv --watch $(SHOW).ps ) &

clean:
	rm -rf $(REPORTS:%=%.aux) $(REPORTS:%=%.bbl) $(REPORTS:%=%.blg)
	rm -rf $(REPORTS:%=%.log) $(REPORTS:%=%.toc) $(REPORTS:%=%.dvi)
	rm -rf *~ 

clobber: clean
	rm -rf $(REPORTS:%=%.ps) $(REPORTS:%=%.pdf)

push:
	git push
	rsync -av --rsh=ssh Ref acdl:/home/mikepark

pull:
	git pull
	rsync -av --rsh=ssh acdl:/home/mikepark/Ref .

pull-subjects:
	rsync -av --rsh=ssh cmb20:bibtex-refs/subjects .

