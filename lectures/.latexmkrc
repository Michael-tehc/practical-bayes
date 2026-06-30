# Robust, consistent build config for all decks. Used by `latexmk` (see Makefile).
$pdf_mode = 1;    # always produce PDF via pdflatex

# -shell-escape: required by minted (it shells out to pygmentize)
# -interaction=nonstopmode: fail fast in CI instead of dropping to a prompt
# -halt-on-error: stop on the first real error
$pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode -halt-on-error -synctex=1 %O %S';

# Run bibtex when the document actually cites something (\bibdata in the .aux).
$bibtex_use = 1.5;

# minted leaves _minted-<jobname>/ caches; let `latexmk -c/-C` remove them too.
$clean_ext = '%R-blx.bib run.xml synctex.gz nav snm';
push @generated_exts, 'nav', 'snm';
$clean_full_ext = '_minted-%R';
