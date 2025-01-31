{
  description = "my overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-20_09.url = "github:NixOs/nixpkgs/5622b6b6feb669edc227aaf000413d5b593d4051";
  };

  outputs = { self, nixpkgs, nixpkgs-20_09 }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
        ];
        config = { allowUnfree = true; };
      };
    in {
      overlays.default =  (final: prev: rec {
        modules = {
          inspircd = import ./modules/inspircd;
        };

        coldsnap = final.callPackage ./pkgs/tools/virtualization/coldsnap {};

        nixos-ami-upload = final.callPackage ./pkgs/tools/virtualization/nixos-ami-upload {};

        hashpipe = final.callPackage ./pkgs/applications/networking/irc/hashpipe {};

        inspircd = final.callPackage ./pkgs/applications/networking/irc/inspircd {};

        inspircd2 = final.callPackage ./pkgs/applications/networking/irc/inspircd2 {};

        meslolgs-nf = final.callPackage ./pkgs/data/fonts/meslolgs-nf {};

        np2kai = final.callPackage ./pkgs/misc/emulators/np2kai {};

        tl = final.callPackage ./pkgs/applications/security/tl {};

        terraform-providers = final.terraform-providers // {
          stripe = final.callPackage ./pkgs/applications/networking/cluster/terraform-providers/stripe {};
        };

        vivarium-unwrapped = final.callPackage ./pkgs/applications/window-managers/vivarium {};
        vivarium = final.callPackage ./pkgs/applications/window-managers/vivarium/wrapper.nix {};

        nixek-images = final.callPackage ./images { };

        amis = final.callPackage ./amis { inherit nixpkgs; };
      });
      packages.x86_64-linux = pkgs;
    };
}
