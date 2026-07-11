{ pkgs, inputs, system, ... }:
{
  # These packages are installed on every host. For host-specific packages, add
  #  `environment.systemPackages = [ ... ];` in the relevant host module
  environment.variables = {
    VSCODE_JS_DEBUG_SERVER = "${pkgs.vscode-js-debug}/lib/node_modules/js-debug/dist/src/dapDebugServer.js";
  };

  environment.systemPackages = with pkgs; [
    # Shell and terminal
    alacritty
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
    delve
    dockerfile-language-server
    fnm
    gcc
    gh
    gnupg
    go
    hadolint
    google-cloud-sdk
    jq
    argocd
    k9s
    kubernetes-helm
    kubectl
    lazygit
    nmap
    opentofu
    openvpn
    pinentry_mac
    pnpm
    python3
    ripgrep
    typescript
    uv
    vscode-js-debug
    yq-go

    # Editor support
    # Language servers and formatters used by Neovim's LSP/conform setup.
    bash-language-server # Bash language server
    gopls # Go language server
    helm-ls # Helm language server
    lua-language-server # Lua language server
    nixd # Nix language server
    nixfmt # Nix formatter
    prettier # HTML, CSS, Markdown, JSONC, and JavaScript formatter
    pyright # Python language server
    python3Packages.debugpy # Python debug adapter used by nvim-dap
    ruff # Python formatter and linter
    rust-analyzer # Rust language server
    cargo-nextest # Rust test runner used by neotest-rust
    rustfmt # Rust formatter
    shellcheck # Shell script diagnostics
    shfmt # Shell script formatter
    stylua # Lua formatter
    taplo # TOML language server
    terraform-ls # Terraform/OpenTofu language server
    typescript-language-server # TypeScript and JavaScript language server
    vscode-json-languageserver # JSON language server
    yaml-language-server # YAML language server
    yamllint # YAML linter used by nvim-lint

    # AI
    ollama

    # Monitoring and networking
    htop
    wireshark

    # Media and data tools
    xan
  ];
}
