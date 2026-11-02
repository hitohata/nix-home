{ pkgs, pkgs-unstable, inputs, lib, ... }:
let
  codex = inputs.codex-cli.packages.${pkgs.system}.default;
  # Native CLI overrides preserve mutable config.toml files, including those
  # selected by the account launcher's CODEX_HOME.
  statusLineSettings = {
    "tui.status_line" = [
      "model-with-reasoning"
      "context-remaining"
      "five-hour-limit"
      "weekly-limit"
      "used-tokens"
    ];
    "tui.status_line_use_colors" = true;
  };
  statusLineFlags = lib.concatMap (name: [
    "--config"
    "${name}=${builtins.toJSON statusLineSettings.${name}}"
  ]) (builtins.attrNames statusLineSettings);
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "codex-with-status-line-${codex.version}";
      paths = [ codex ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/codex \
          --add-flags ${lib.escapeShellArg (lib.escapeShellArgs statusLineFlags)}
      '';
    })
    # The official desktop app includes Codex alongside ChatGPT.
    pkgs-unstable.chatgpt
  ];
}
