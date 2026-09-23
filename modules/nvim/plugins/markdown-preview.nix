{ pkgs }:

let
  upstream = pkgs.vimPlugins.markdown-preview-nvim;

  nodeModules = pkgs.stdenv.mkDerivation {
    inherit (upstream) pname version src;

    nativeBuildInputs = [ pkgs.yarnConfigHook ];

    yarnOfflineCache = pkgs.fetchYarnDeps {
      yarnLock = "${upstream.src}/yarn.lock";
      hash = "sha256-kzc9jm6d9PJ07yiWfIOwqxOTAAydTpaLXVK6sEWM8gg=";
    };

    # yarnConfigHook uses `yarn install --force`. Copying its immutable offline
    # mirror makes that forced refresh safe instead of trying to unlink a store
    # path.
    preConfigure = ''
      cp -R "$yarnOfflineCache" yarn-offline-cache
      chmod -R u+w yarn-offline-cache
      yarnOfflineCache="$PWD/yarn-offline-cache"
    '';

    installPhase = ''
      cp -r node_modules "$out"
    '';
  };
in
upstream.overrideAttrs {
  postInstall = ''
    cp -r ${nodeModules} "$out/app/node_modules"
  '';
}
