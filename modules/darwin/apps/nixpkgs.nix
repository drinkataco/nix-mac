{ pkgs, ... }:
let
  scarlettMixControl = pkgs.callPackage ./packages/scarlett-mixcontrol.nix { };
in
{
  environment.systemPackages = with pkgs; [
    # Shell and terminal
    alacritty.terminfo
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
    google-cloud-sdk
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
    silver-searcher
    typescript
    yq-go

    # Editor support
    # Language servers and formatters used by Neovim's LSP/conform setup.
    bash-language-server # Bash language server
    gopls # Go language server
    helm-ls # Helm language server
    lua-language-server # Lua language server
    marksman # Markdown language server
    nixd # Nix language server
    nixfmt-rfc-style # Nix formatter
    prettier # HTML, CSS, Markdown, JSONC, and JavaScript formatter
    pyright # Python language server
    ruff # Python formatter and linter
    rust-analyzer # Rust language server
    rustfmt # Rust formatter
    shellcheck # Shell script diagnostics
    shfmt # Shell script formatter
    stylua # Lua formatter
    taplo # TOML language server
    terraform-ls # Terraform/OpenTofu language server
    typescript-language-server # TypeScript and JavaScript language server
    vscode-langservers-extracted # JSON language server
    yaml-language-server # YAML language server

    # Monitoring and networking
    htop
    wireshark

    # Media and data tools
    mkvtoolnix
    scarlettMixControl
    xan
  ];
}
