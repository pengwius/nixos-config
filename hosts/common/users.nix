{ pkgs, ... }:
{
  users.users = {
    pengwius = {
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
