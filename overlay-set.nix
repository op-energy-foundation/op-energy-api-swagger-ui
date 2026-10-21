{ ...
}:
let
  op-energy-blockspan-api-overlay =
    import ../op-energy-blockspan-service/op-energy-api/overlay.nix;
  op-energy-account-api-overlay = import ../op-energy/oe-account-service/op-energy-account-api/overlay.nix;
  op-energy-offer-api-overlay = import ../op-energy/oe-offer-service/op-energy-offer-api/overlay.nix;
  stable = import ./nixpkgs.nix;
  pkgs = import stable {
    config = {};
    overlays = [
      op-energy-blockspan-api-overlay
      op-energy-account-api-overlay
      op-energy-offer-api-overlay
    ];
  };
  op-energy-api-swagger-ui = pkgs.haskellPackages.callPackage ./derivation.nix {
  };
in
{
  op-energy-api-swagger-ui = op-energy-api-swagger-ui;
  op-energy-api-swagger-ui-nginx-vhost-config = import ./nginx-vhost-config.nix;
}
