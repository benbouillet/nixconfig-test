{
  pkgs, 
  ... 
}:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    escapeTime = 10;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    plugins = with pkgs; [
      tmuxPlugins.yank 
      tmuxPlugins.jump
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-thumbs
      tmuxPlugins.tmux-fzf
      tmuxPlugins.sessionist
      tmuxPlugins.pain-control
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'frappe'
        '';
      }
    ];
    extraConfig = ''
      # Opacity
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
    '';
  };
}
