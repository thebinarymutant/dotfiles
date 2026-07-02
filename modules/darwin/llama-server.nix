{
  pkgs,
  lib,
  userConfig,
  ...
}: let
  home = "/Users/${userConfig.userName}";
  port = "58721";
in {
  launchd.daemons.llama-server = lib.mkIf pkgs.stdenv.isDarwin {
    environment = {
      LLAMA_CACHE = "${home}/llama_cache";
    };
    serviceConfig = {
      Label = "local.llama-server";
      ProgramArguments = [
        "${pkgs.llama-cpp}/bin/llama-server"
        "-m"
        "${home}/llama_cache/Qwen3.6-35B-A3B-UD-Q6_K.gguf"
        "--no-hf"
        "--temp"
        "0.6"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.00"
        "--presence-penalty"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--spec-type"
        "draft-mtp"
        "--spec-draft-n-max"
        "2"
        "--port"
        port
        "--alias"
        "qwen3.6-mtp"
        "--ctx-size"
        "262144"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${home}/Library/Logs/llama-server.log";
      StandardErrorPath = "${home}/Library/Logs/llama-server.error.log";
    };
  };
}
