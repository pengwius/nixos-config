{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = pkgs.lib.mkForce "catppuccin_mocha";
      
      editor.line-number = "relative";
  
    };
    extraPackages = with pkgs; [
      nil
    ];
  };
}
