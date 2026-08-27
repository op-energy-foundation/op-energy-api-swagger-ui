{ GIT_COMMIT_HASH}:
args@{config, pkgs, options, lib, ...}:
let
  op-energy-api-swagger-ui-overlay = import ./overlay.nix;
  cfg = config.services.op-energy-api-swagger-ui;
in
{
  options.services.op-energy-api-swagger-ui = {
    enable = lib.mkEnableOption "op-energy api swagger ui";
    api_port = lib.mkOption {
      type = lib.types.int;
      example = 8998;
      default = 8998;
      description = ''
        defines API port for a swagger ui service
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    nixpkgs.overlays = [
      op-energy-api-swagger-ui-overlay
    ];
    environment.systemPackages = [ pkgs.op-energy-api-swagger-ui ];
    systemd.services = {
      op-energy-api-swagger-ui = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always"; # we want to keep service always running, especially, now development instance is relying on ssh tunnel which can restart as well leading to op-energy restart as well
          StartLimitIntervalSec = 10;
          StartLimitBurst = 0;
        };
        path = with pkgs; [
          pkgs.op-energy-api-swagger-ui
        ];
        script = ''
          set -ex
          API_PORT=${toString cfg.api_port} op-energy-api-swagger-ui +RTS -c -N -s
        '';
      };
    };
  };
}
