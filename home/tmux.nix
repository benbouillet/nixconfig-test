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
    ];
  };
}
