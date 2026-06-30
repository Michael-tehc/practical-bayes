# Entry point for `nix-shell` -- the lecture build environment.
# See default.nix for the actual toolchain definition.
{ sources ? import ./npins
, pkgs ? import sources.nixpkgs { }
}:
(import ./default.nix { inherit sources pkgs; }).shell
