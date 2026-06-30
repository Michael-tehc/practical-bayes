# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Course materials for "Practical Bayesian Methods" (Прикладные байесовские методы), taught at MSU by Maxim Kochurov (PyMC core dev). Three kinds of content:

- `lectures/` — LaTeX **beamer** slide decks, maintained in **two languages**.
- `seminars/` — Jupyter notebooks (PyMC) used live in class, with worked solutions under `seminars/solved/`.
- `ha/` — homework notebooks (`ha-N.ipynb`) plus their data files.

## Version control: jj, not git

This repo is driven with **[Jujutsu](https://jj-vcs.github.io/jj/) (`jj`)** on top of a colocated git repo. Use `jj` commands, not `git`:

- `jj st` — working-copy status; `jj diff` — current changes.
- `jj describe -m "..."` — set the current change's message; `jj new` — start a new change.
- `jj bookmark list` — branches (here: `main`, `master`, `year-2025`).
- `jj log` — history.

The working copy is always a real commit (`@`); there is no staging step. Don't run `git commit`/`git add`.

## Lectures: the bilingual convention

Each lecture exists as a pair of `.tex` files in `lectures/`:

- `lecture-N.ru.tex` — **Russian** (the original source).
- `lecture-N.tex` — **English** (translation of the `.ru` version).

The active work in this repo is **translating the Russian decks into English** (see recent commits like "translate HSGP part"). When translating, mirror the structure of the `.ru.tex` file frame-by-frame; only the natural-language text and `\title`/`\section` strings change — keep math, `\includegraphics`, and layout identical. `teaser.tex` / `teaser.ru.tex` follow the same pairing.

Shared across all decks:
- `ferres.sty` — the custom beamer package (theme AnnArbor/crane, `minted` for code, tikz, custom macros like `\cond`).
- `math_commands.tex` — shared math macros, `\input` at the top of every deck.
- `references.bib` — bibliography for all lectures.
- `img/` — figures referenced by `\includegraphics`.

### Building a deck

The toolchain (TeX Live + `latexmk` + `pygmentize`) is defined in **`default.nix`**, with nixpkgs pinned via **npins** (`npins/sources.json`) — no flakes, no system TeX install needed. Enter the shell, then use `make`:

```sh
nix-shell                       # from repo root; provides texlive, latexmk, pygmentize
cd lectures
make                            # build every deck (English + .ru + teaser)
make lecture-5.pdf              # build one deck
make clean                      # remove intermediates incl. _minted-* (keeps PDFs)
make cleanall                   # also remove the PDFs
```

`nix-build` realises just the TeX Live bundle (`default.nix`'s `tex` attribute) into `./result`. To bump nixpkgs: `npins update` (then rebuild).

The build is driven by **`latexmk`** (config in `lectures/.latexmkrc`): it reruns `pdflatex`/`bibtex` until cross-references, the TOC, and the bibliography converge, so the output is consistent regardless of how many passes a deck needs. `minted` needs `-shell-escape` + `pygmentize`; both are handled by `.latexmkrc` and `default.nix` respectively (this is why a bare system `pdflatex` historically failed on decks with code listings).

**Two gotchas on this machine:**

1. A `zsh` plugin wraps `nix-shell` and breaks `--run` non-interactively (`/scripts/buildShellShim: No such file or directory`). Bypass it with `command nix-shell --run '...'`.
2. Nix offloads builds to a remote builder that can't reach `nix-community.cachix.org` / `cache.numtide.com`, so the `texlive.combine` step can hang then fail at <1 B/s. If a build stalls on cache downloads, force a **local** build off the official cache:

```sh
command nix-shell --builders "" \
  --option substituters "https://cache.nixos.org" \
  --option extra-substituters "" \
  --run 'cd lectures && make'
```

The individual TeX packages still come from `cache.nixos.org`; only the final combine needs to run locally.

## Notebooks (seminars & homework)

Run against the conda environment defined in `environment.yaml` (`conda env create -f environment.yaml`, env name `practical-bayes-env`). Core stack: **PyMC ≥5.8**, PyTensor, ArviZ, NumPy, `pandas<2.0`, matplotlib/seaborn, scikit-learn. The `pandas<2.0` pin is intentional.

`seminars/N-*.ipynb` are the in-class (often blank-to-fill) versions; `seminars/solved/` holds the completed counterparts. Keep the two in sync when editing a seminar.

## Housekeeping

Editor backup/undo artifacts (`*~`, `*.~undo-tree~`, `..gitignore.~undo-tree~`) and LaTeX build leftovers (`.aux`, `.log`, `.nav`, etc.) are scattered in the tree — ignore them; do not edit or "clean up" `*~` files as if they were source.
