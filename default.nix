let
  stable = import ./nixpkgs.nix;
  pkgs = (import stable {
    overlays = [ (import ./overlay.nix ) ];
  }); # first, load the nixpkgs with system-wide overlays
in pkgs.op-energy-api-swagger-ui
