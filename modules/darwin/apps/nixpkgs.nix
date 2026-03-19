{ pkgs, ... }:
let
  scarlettMixControl = pkgs.callPackage ./packages/scarlett-mixcontrol.nix { };
in
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
    kubernetes-helm
    kubectl
    lazygit
    nmap
    opentofu
    openvpn
    pinentry_mac
    pnpm
    pyright
    rust-analyzer
    shellcheck
    shfmt
    silver-searcher
    typescript
    typescript-language-server
    vscode-langservers-extracted

    # Monitoring and networking
    htop
    wireshark

    # Media and data tools
    mkvtoolnix
    scarlettMixControl
    xan
  ];
}
