# Lecture build. Driven by latexmk, which reruns pdflatex/bibtex until
# cross-references, the TOC, and the bibliography converge -- so the result is
# the same no matter how many passes a given deck needs. Build settings
# (-shell-escape for minted, error handling) live in .latexmkrc.
#
# Reproducible toolchain: `nix develop` at the repo root, then `make` here.

# Standalone decks = every .tex except shared \input fragments.
FRAGMENTS := math_commands.tex
DOCS := $(filter-out $(FRAGMENTS),$(wildcard *.tex))
PDFS := $(DOCS:.tex=.pdf)

LATEXMK := latexmk

.PHONY: all clean cleanall
.DEFAULT_GOAL := all

# Build every deck (English + .ru + teaser).
all: $(PDFS)

%.pdf: %.tex .latexmkrc
	$(LATEXMK) $<

# Remove intermediates (incl. minted caches) but keep the PDFs.
clean:
	$(LATEXMK) -c
	rm -rf _minted-*

# Remove intermediates and the built PDFs.
cleanall:
	$(LATEXMK) -C
	rm -rf _minted-*
