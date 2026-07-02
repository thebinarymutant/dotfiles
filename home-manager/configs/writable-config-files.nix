{lib, ...}: let
  # Config files managed by this repo but kept writable in $HOME.
  #
  # Use this for tools that edit their own config in place. Home Manager's
  # home.file/xdg.configFile would create Nix-store symlinks, which makes those
  # edits awkward or impossible.
  writableConfigFiles = [
    {
      target = ".config/jj/config.toml";
      source = ./jujutsu/config.toml;
    }
    {
      target = ".pi/agent/models.json";
      source = ./pi/models.json;
    }
    {
      target = ".pi/agent/settings.json";
      source = ./pi/settings.json;
    }
    {
      target = ".config/opencode/opencode.json";
      source = ./opencode/opencode.json;
    }
    {
      target = ".hermes/config.yaml";
      source = ./hermes/config.yaml;
    }
  ];

  installWritableConfig = {
    target,
    source,
  }: ''
    target_file="$HOME/${target}"
    source_file="${source}"

    mkdir -p "$(dirname "$target_file")"
    cp "$source_file" "$target_file"
    chmod u+w "$target_file"
  '';
in {
  home.activation.installWritableConfigFiles = lib.hm.dag.entryAfter ["writeBoundary"] (
    lib.concatMapStringsSep "\n" installWritableConfig writableConfigFiles
  );
}
