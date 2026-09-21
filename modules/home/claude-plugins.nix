{ lib, ... }:
let
  marketplaces = [
    "max-sixty/worktrunk"
  ];

  plugins = [
    "worktrunk@worktrunk"
  ];

  claude = "/opt/homebrew/bin/claude";
in
{
  home.activation.installClaudePlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x ${lib.escapeShellArg claude} ]; then
      marketplaces_file="$HOME/.claude/plugins/known_marketplaces.json"
      plugins_file="$HOME/.claude/plugins/installed_plugins.json"

      for marketplace in ${lib.escapeShellArgs marketplaces}; do
        if ! grep -q "\"$marketplace\"" "$marketplaces_file" 2>/dev/null; then
          ${lib.escapeShellArg claude} plugin marketplace add "$marketplace"
        fi
      done

      for plugin in ${lib.escapeShellArgs plugins}; do
        if ! grep -q "\"$plugin\"" "$plugins_file" 2>/dev/null; then
          ${lib.escapeShellArg claude} plugin install "$plugin"
        fi
      done
    fi
  '';
}
