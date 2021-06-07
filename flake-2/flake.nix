{
  description = "My NPM Package";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/67be794a7f1102c752ab0d00c6ca58652009e67e";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.npm-package =
      let pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
      in pkgs.stdenv.mkDerivation {
        pname = "npm-package";
        version = "1.1.0";
        src = ./.;
        nativeBuildInputs = with pkgs; [
          nodejs-14_x # Actually required node@14.17.0
        ];
        buildPhase = ''
          npm install --no-cache
          npm build
        '';
        installPhase = ''
          cp -r dist/ $out/
        '';
      };

    # Specify the default package
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.npm-package;
  };
}