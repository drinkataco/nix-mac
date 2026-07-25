{ lib, ... }:
{
  # herdr's Claude integration installs a SessionStart hook script referenced
  # by dotfiles/.claude/settings.json. The herdr binary comes from Homebrew,
  # so this activation runs after that and is idempotent on the hook path.
  home.activation.installHerdrClaudeIntegration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.claude/hooks/herdr-agent-state.sh" ] && [ -x /opt/homebrew/bin/herdr ]; then
      /opt/homebrew/bin/herdr integration install claude
    fi
  '';
}
