{ pkgs, mainUser, ... }:
{
  users.users = {
    ${mainUser} = {
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
