{pkgs, ...}: let
  codeFunction =
    if pkgs.stdenv.hostPlatform.isDarwin
    then ''
      if test -d "$argv[1]" -o -f "$argv[1]"
          open -a "Visual Studio Code" "$argv[1]"
      else
          command code $argv
      end
    ''
    else ''
      command code $argv
    '';
in {
  programs.fish = {
    enable = true;

    shellInit = ''
      for config in ${./fish/configs}/*.fish
        source "$config"
      end
    '';

    functions = {
      code = codeFunction;
    };
  };
}
