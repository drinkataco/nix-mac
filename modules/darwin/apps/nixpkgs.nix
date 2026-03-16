{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Shell and terminal
    bash
    bat
    cmatrix
    eza
    fd
    fzf
    neovim
    tree-sitter
    tmux
    tree
    watch
    zoxide
    zsh
    zsh-completions
    zsh-syntax-highlighting

    # Core Unix tools
    coreutils
    findutils
    gawk
    gettext
    gnugrep
    gnused
    gnutar

    # Dev tooling
    ansible
    awscli2
    delta
    fnm
    gcc
    gnupg
    go
    jq
    k9s
    kubectl
    lazygit
    nmap
    opentofu
    openvpn
    pinentry_mac
    shellcheck
    shfmt
    silver-searcher

    # Monitoring and networking
    htop
    wireshark

    # Media and data tools
    mkvtoolnix
    xan
  ];
}
