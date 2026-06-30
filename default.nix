# Build environment for the Practical Bayes lecture slides (LaTeX/beamer + minted).
#
# Dependencies are pinned with npins (see npins/sources.json); update with
# `npins update`. No flakes required -- works with plain `nix-shell` / `nix-build`.
#
#   nix-shell            # enter the build shell, then: cd lectures && make
#   nix-build            # realise the toolchain into ./result
{ sources ? import ./npins
, pkgs ? import sources.nixpkgs { }
}:
let
  # TeX Live bundle for the decks. scheme-medium covers beamer/pgf/tikz and the
  # recommended fonts; the extras add what the decks actually use:
  #   - collection-langcyrillic: T2A/OT2 encodings, babel-russian, Cyrillic
  #     fonts (the .ru.tex sources and the bilingual titles)
  #   - collection-latexextra: minted + its deps (fvextra, framed, ...)
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      collection-langcyrillic
      collection-latexextra
      latexmk;
  };
in
{
  # The toolchain as a buildable/realisable package (`nix-build`).
  inherit tex;

  # `nix-shell` drops into this (see shell.nix, which selects this attribute).
  shell = pkgs.mkShell {
    packages = [
      tex
      pkgs.python3Packages.pygments # provides `pygmentize`, required by minted
      pkgs.gnumake
    ];

    shellHook = ''
      echo "Practical Bayes lecture build shell (texlive + pygmentize + latexmk)."
      echo "  cd lectures"
      echo "  make                 # build every deck"
      echo "  make lecture-5.pdf   # build one deck"
      echo "  make clean           # remove intermediates"
    '';
  };
}
