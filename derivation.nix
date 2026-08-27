{ mkDerivation, lib
, base , hspec, text, bytestring
, lens
, op-energy-api
, op-energy-account-api
, servant, servant-server, servant-client, servant-jsonrpc, servant-jsonrpc-client, servant-swagger, servant-swagger-ui, swagger2
, websockets, servant-websockets
, aeson, aeson-pretty
, scientific
, async
, warp
, wai
, ...
}:
mkDerivation {
  pname = "op-energy-api-swagger-ui";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [
    base text bytestring
    lens
    op-energy-api
    op-energy-account-api
    servant servant-server servant-client servant-jsonrpc servant-jsonrpc-client servant-swagger servant-swagger-ui swagger2
    websockets servant-websockets
    aeson aeson-pretty
    scientific
    warp
    wai
  ];
  executableHaskellDepends = [
    base
    lens
  ];
  enableLibraryProfiling = false;
  enableExecutableProfiling = false;
  enableSharedExecutables = false;
  enableSharedLibraries = false;
  enableLibraryForGhci = false;
  enableSeparateBinOutput = false;
  testHaskellDepends = [
    base
    hspec
    text
  ];
  doBenchmark = false;
  doCheck = false;
  license = lib.licenses.bsd3;
}
