{
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;
    in rec {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "libpcre.zig-build";

        src = ./.;

        nativeBuildInputs = [pkgs.zig pkgs.pcre];

        buildPhase = ''
          export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig"
          zig build test
          touch $out
        '';

        dontInstall = true;
      };

      formatter = pkgs.alejandra;
    });
}
