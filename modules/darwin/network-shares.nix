{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networkShares.nfs;
  mountOptions = lib.concatStringsSep "," cfg.mountOptions;

  # Convert an NFS export like "fileserver:/srv/media" into a stable autofs key
  # such as "fileserver-srv-media". The key becomes the directory name under
  # cfg.mountPoint, while the original spec stays untouched for mount_nfs.
  parseMount =
    spec:
    let
      parts = lib.splitString ":" spec;
      server = lib.head parts;
      exportPath = lib.concatStringsSep ":" (lib.tail parts);
      exportName = lib.removePrefix "/" exportPath;
      key = lib.replaceStrings [ "/" " " ] [ "-" "-" ] "${server}-${exportName}";
    in
    {
      inherit key spec;
    };

  mounts = map parseMount cfg.mounts;

  # This is an indirect autofs map. macOS creates entries below cfg.mountPoint
  # and only attempts the NFS mount when one of those entries is accessed.
  # Keeping the map static avoids probing the server during rebuilds.
  nfsMap = pkgs.writeText "nfs" (
    lib.concatMapStringsSep "\n" (mount: "${mount.key} -${mountOptions} ${mount.spec}") mounts + "\n"
  );
in
{
  options.networkShares.nfs = {
    mounts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "fileserver:/srv" ];
      description = "NFS exports to automount under the configured mount point.";
    };

    mountPoint = lib.mkOption {
      type = lib.types.str;
      default = "/Volumes/NetworkShares";
      description = "Finder-visible autofs directory containing NFS export entries.";
    };

    mountOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "fstype=nfs"
        "nosuid"
        "soft"
        "intr"
        "tcp"
        "retrycnt=0"
      ];
      description = "Mount options used for configured NFS exports.";
    };
  };

  config = lib.mkIf (cfg.mounts != [ ]) {
    assertions = [
      {
        # A colon is the minimum useful validation because NFS exports are
        # written as server:/path. More detailed validation would reject valid
        # but unusual server/export strings.
        assertion = lib.all (mount: builtins.length (lib.splitString ":" mount) >= 2) cfg.mounts;
        message = "Each networkShares.nfs.mounts entry must look like server:/export/path.";
      }
    ];

    # nix-darwin manages the map file, while the activation hook below only
    # teaches the system autofs master map where to find it.
    environment.etc."nfs".source = nfsMap;

    home-manager.users.${config.system.primaryUser}.home.activation.networkSharesDesktopLink = {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        ln -sfn ${lib.escapeShellArg cfg.mountPoint} "$HOME/Desktop/$(basename ${lib.escapeShellArg cfg.mountPoint})"
      '';
    };

    system.activationScripts.etc.text = lib.mkAfter ''
      echo "setting up NFS automounts..." >&2

      mount_point=${lib.escapeShellArg cfg.mountPoint}
      master_line=${lib.escapeShellArg "${cfg.mountPoint} /etc/nfs -nosuid"}

      if ! mkdir -p "$mount_point"; then
        echo "warning: could not create $mount_point; skipping NFS automount setup" >&2
      elif [ ! -f /etc/auto_master ]; then
        echo "warning: /etc/auto_master not found; skipping NFS automount setup" >&2
      else
        tmp="$(mktemp /tmp/auto_master.XXXXXX)"
        # Replace only this module's master-map line. This keeps the operation
        # idempotent and avoids disturbing Apple/default autofs entries.
        if /usr/bin/awk -v mount_point="$mount_point" '$1 != mount_point { print }' /etc/auto_master > "$tmp"; then
          printf '%s\n' "$master_line" >> "$tmp"
          if ! /usr/bin/cmp -s "$tmp" /etc/auto_master; then
            cp "$tmp" /etc/auto_master || echo "warning: could not update /etc/auto_master" >&2
          fi
        else
          echo "warning: could not prepare NFS auto_master entry" >&2
        fi
        rm -f "$tmp"

        # Refresh autofs, but do not fail activation when the network share is
        # unavailable. The actual mount is still lazy and happens on access.
        /usr/sbin/automount -vc >/dev/null 2>&1 || \
          echo "warning: could not refresh automount maps for NFS shares" >&2
      fi
    '';
  };
}
