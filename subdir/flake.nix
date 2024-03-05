{
  description = "";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        prev =
          let mySrc = pkgs.fetchFromGitHub {
            owner = "waltermoreira";
            repo = "nested-fetch";
            rev = "5fea38724a96da6290cf85923f2153ad2c519dac";
            hash = "sha256-gC8yRUJAFPbobvI/W/OIfmhzu1Bb/5ns78crEaJ3zEA=";
          };
          in
          pkgs.stdenv.mkDerivation {
            name = "test";
            src = "${mySrc}/subdir";
            installPhase = ''
              echo ${mySrc}
              mkdir -p $out
              cp README.md $out
            '';
          };
      in
      {
        packages.default = prev;
      });
}
