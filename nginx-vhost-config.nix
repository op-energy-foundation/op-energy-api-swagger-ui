{config, ...}:
URL_BASE:
API_HOST:
let
  zones_enabled =
    if config.services ? "op-energy-account-service"
      then config.services.op-energy-account-service.enable
      else false;
in
{
  locations = {
    "${URL_BASE}api/swagger.json" = {
      proxyPass = "${API_HOST}/api/swagger.json";
      extraConfig = if zones_enabled
        then ''
          limit_req zone=api burst=10 nodelay;
        ''
        else "";
    };
    "${URL_BASE}api/swagger-ui" = {
      proxyPass = "${API_HOST}/api/swagger-ui";
      extraConfig = if zones_enabled
        then ''
          limit_req zone=api burst=10 nodelay;
        ''
        else "";
    };
  };
}
